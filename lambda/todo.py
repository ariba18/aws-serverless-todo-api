import json
import boto3
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('todos')

def lambda_handler(event, context):
    http_method = event.get('httpMethod')
    path = event.get('path', '')
    path_parameters = event.get('pathParameters') or {}
    todo_id = path_parameters.get('id')

    try:
        if http_method == 'POST' and path == '/todos':
            return create_todo(event)
        elif http_method == 'GET' and path == '/todos':
            return get_all_todos()
        elif http_method == 'GET' and todo_id:
            return get_todo(todo_id)
        elif http_method == 'PUT' and todo_id:
            return update_todo(todo_id, event)
        elif http_method == 'DELETE' and todo_id:
            return delete_todo(todo_id)
        else:
            return response(404, {'error': 'Route not found'})
    except Exception as e:
        return response(500, {'error': str(e)})


def create_todo(event):
    body = json.loads(event.get('body', '{}'))
    title = body.get('title')
    if not title:
        return response(400, {'error': 'title is required'})

    todo = {
        'id': str(uuid.uuid4()),
        'title': title,
        'completed': False,
        'created_at': datetime.utcnow().isoformat()
    }
    table.put_item(Item=todo)
    return response(201, todo)


def get_all_todos():
    result = table.scan()
    return response(200, result.get('Items', []))


def get_todo(todo_id):
    result = table.get_item(Key={'id': todo_id})
    item = result.get('Item')
    if not item:
        return response(404, {'error': 'Todo not found'})
    return response(200, item)


def update_todo(todo_id, event):
    body = json.loads(event.get('body', '{}'))
    title = body.get('title')
    completed = body.get('completed')

    result = table.get_item(Key={'id': todo_id})
    if not result.get('Item'):
        return response(404, {'error': 'Todo not found'})

    update_expr = []
    expr_values = {}

    if title is not None:
        update_expr.append('title = :t')
        expr_values[':t'] = title
    if completed is not None:
        update_expr.append('completed = :c')
        expr_values[':c'] = completed

    if not update_expr:
        return response(400, {'error': 'Nothing to update'})

    updated = table.update_item(
        Key={'id': todo_id},
        UpdateExpression='SET ' + ', '.join(update_expr),
        ExpressionAttributeValues=expr_values,
        ReturnValues='ALL_NEW'
    )
    return response(200, updated.get('Attributes', {}))


def delete_todo(todo_id):
    result = table.get_item(Key={'id': todo_id})
    if not result.get('Item'):
        return response(404, {'error': 'Todo not found'})
    table.delete_item(Key={'id': todo_id})
    return response(200, {'message': 'Todo deleted successfully'})


def response(status_code, body):
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps(body, default=str)
    }