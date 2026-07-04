# AWS Serverless Todo API

A fully serverless REST API for managing todos — built on AWS Lambda, API Gateway, and DynamoDB, provisioned entirely through Terraform, with CI/CD via GitHub Actions and monitoring through CloudWatch.

---

## 🏗️ Architecture

```mermaid
flowchart LR
    Client[Client / Postman] -->|HTTPS| APIGW[API Gateway]
    APIGW -->|Invoke| Lambda[Lambda Function<br/>todo-api]
    Lambda -->|Read/Write| DDB[(DynamoDB<br/>todos table)]
    Lambda -->|Logs| CW[CloudWatch Logs]
    IAM[IAM Role] -.->|Permissions| Lambda
```

**Flow:** A client request hits API Gateway, which invokes a Lambda function. The function performs the requested operation against a DynamoDB table and returns a response — with every invocation logged to CloudWatch for full observability.

---

## 🛠️ Tech Stack

| Layer            | Technology              |
|-------------------|--------------------------|
| Compute           | AWS Lambda (Python)     |
| API Layer         | Amazon API Gateway      |
| Database          | Amazon DynamoDB         |
| Infrastructure    | Terraform               |
| CI/CD             | GitHub Actions          |
| Monitoring/Logs   | Amazon CloudWatch       |
| Testing           | Postman                 |

---

## ✨ Highlights

- **Fully serverless** — no servers to provision or manage, scales automatically with demand
- **Infrastructure as Code** — the entire stack (19 AWS resources) is defined and provisioned through Terraform
- **Automated CI/CD** — GitHub Actions runs `terraform fmt`, `validate`, and `plan` on every push, with `apply` gated behind manual approval
- **Complete CRUD API** — create, read, update, and delete operations, each independently tested
- **Built-in observability** — every Lambda invocation logged to CloudWatch with execution duration and memory metrics

---

## 📡 API Design

| Method | Endpoint            | Description          |
|--------|----------------------|-----------------------|
| POST   | `/todos`             | Create a new todo    |
| GET    | `/todos`             | Get all todos        |
| GET    | `/todos/{id}`        | Get a single todo    |
| PUT    | `/todos/{id}`        | Update a todo        |
| DELETE | `/todos/{id}`        | Delete a todo        |

### Example — Create a Todo
**Request:** `POST /todos`
```json
{
  "title": "Buy groceries"
}
```

**Response:**
```json
{
  "id": "bdae23c9-b67b-4fb5-b328-eba51330ad8d",
  "title": "Buy groceries",
  "completed": false,
  "created_at": "2026-07-03T13:52:48.786428"
}
```

### Example — Update a Todo
**Request:** `PUT /todos/{id}`
```json
{
  "title": "Buy groceries and cook dinner",
  "completed": true
}
```

### Example — Delete a Todo
**Response:**
```json
{
  "message": "Todo deleted successfully"
}
```

---

## 📸 Testing

All five operations were tested end-to-end using Postman, verifying correct status codes and response payloads for every route.

| Operation | Screenshot |
|-----------|------------|
| Create Todo (POST) | `screenshots/01-post-create.png` |
| Get All Todos (GET) | `screenshots/02-get-all.png` |
| Get One Todo (GET) | `screenshots/03-get-one.png` |
| Update Todo (PUT) | `screenshots/04-put-update.png` |
| Delete Todo (DELETE) | `screenshots/05-delete.png` |

---

## 📊 Monitoring

Every Lambda invocation is logged to CloudWatch, capturing `START`, `END`, and `REPORT` events with execution duration and memory usage — giving full visibility into runtime performance.

![CloudWatch Logs](screenshots/06-cloudwatch-logs.png)

---

## 🔄 CI/CD Pipeline

This project uses **GitHub Actions** to automatically validate infrastructure changes on every push — running `terraform fmt`, `terraform validate`, and `terraform plan`. Applying changes is gated behind a manual trigger for controlled, deliberate deployments.

---

## 🎯 Design Decisions & Trade-offs

- **Single Lambda for all routes** — chosen for simplicity and lower cold-start overhead vs. per-route functions; a natural next step would be splitting into per-operation functions for larger-scale APIs.
- **DynamoDB over relational DB** — fits the access pattern (simple key-based lookups) and scales seamlessly without connection pooling concerns that come with Lambda + RDS.
- **Terraform over console/CDK** — full reproducibility and version-controlled infrastructure changes.

### Possible Future Improvements
- Unit tests for Lambda handler logic
- API key / usage plan for rate limiting
- Custom domain with ACM certificate

---

## 👤 Author

**Ariba**
Cloud Engineering | DevOps | AWS
GitHub: [github.com/ariba18](https://github.com/ariba18)
