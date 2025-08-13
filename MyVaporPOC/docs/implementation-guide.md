# Implementation Guide

## Prerequisites

### System Requirements
- **Swift**: 5.2 or later
- **Python**: 3.8 or later
- **macOS**: 13.0 or later (for Swift development)
- **Xcode**: Latest version (optional, for IDE support)

### Dependencies
- Vapor 4.115+
- VaporTesting (included with Vapor)
- pytest and requests (Python packages)

## Step-by-Step Setup

### 1. Swift VaporTesting Setup

#### Install Dependencies
```


# Clone the repository

git clone <repository-url>
cd MyVaporPOC

# Resolve Swift package dependencies

swift package resolve

```

#### Configure Database for Testing
In `configure.swift`, ensure proper database configuration:

```

public func configure(_ app: Application) async throws {
if app.environment == .testing {
// In-memory SQLite for tests
app.databases.use(.sqlite(.memory), as: .sqlite)
} else {
// File-based SQLite for development
app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
}

    app.migrations.add(CreateTodo())
    app.views.use(.leaf)
    
    // Critical: Run migrations before handling requests
    try await app.autoMigrate()
    
    try routes(app)
    }

```

#### Create Test Helper
The `withApp` helper ensures test isolation:

```

private func withApp(_ test: (Application) async throws -> ()) async throws {
let app = try await Application.make(.testing)
do {
try await configure(app)
try await app.autoMigrate()
try await test(app)
try await app.autoRevert()
} catch {
try? await app.autoRevert()
try await app.asyncShutdown()
throw error
}
try await app.asyncShutdown()
}

```

### 2. Python Pytest Configuration

#### Create Python Environment
```


# Create virtual environment (recommended)

python3 -m venv venv
source venv/bin/activate  \# On Windows: venv\Scripts\activate

# Install testing dependencies

pip install pytest requests

```

#### Create Test Directory Structure
```

MyVaporPOC/
├── tests-python/
│   ├── __init__.py
│   ├── test_myvaporpoc_api.py
│   └── conftest.py (optional)

```

#### Configure Base Test Settings
In `test_myvaporpoc_api.py`:

```

import requests
import pytest

BASE = "http://localhost:8080"

def test_server_is_running():
"""Verify the server is accessible before running other tests."""
try:
response = requests.get(f"{BASE}/hello", timeout=5)
assert response.status_code == 200
except requests.exceptions.ConnectionError:
pytest.fail("Server is not running. Start with: swift run MyVaporPOC")

```

### 3. Database Configuration Best Practices

#### Migration Management
- Always run `try await app.autoMigrate()` in `configure.swift`
- Use `app.autoRevert()` in test teardown
- Ensure migrations are idempotent

#### Test Data Management
```

// Good: Create test data in each test
let testTodos = [Todo(title: "test1"), Todo(title: "test2")]
try await testTodos.create(on: app.db)

// Good: Verify data is cleaned up
let remainingTodos = try await Todo.query(on: app.db).all()
\#expect(remainingTodos.isEmpty)

```

### 4. Error Handling Implementation

#### Controller Validation
Implement robust input validation in `TodoController.swift`:

```

@Sendable
func create(req: Request) async throws -> TodoDTO {
let dto: TodoDTO
do {
dto = try req.content.decode(TodoDTO.self)
} catch {
throw Abort(.badRequest, reason: "Invalid request body")
}

    guard let title = dto.title, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        throw Abort(.badRequest, reason: "The title field is required and cannot be empty.")
    }
    
    let todo = dto.toModel()
    try await todo.save(on: req.db)
    return todo.toDTO()
    }

```

### 5. CI/CD Integration

#### GitHub Actions Workflow
Create `.github/workflows/backend-tests.yml`:

```

name: Backend Testing Pipeline

on:
push:
branches: [ main, develop ]
pull_request:
branches: [ main ]

jobs:
swift-tests:
runs-on: macos-latest
steps:
- uses: actions/checkout@v4
- name: Run Swift Tests
run: swift test

api-tests:
runs-on: macos-latest
needs: swift-tests
steps:
- uses: actions/checkout@v4
- name: Setup Python
uses: actions/setup-python@v4
with:
python-version: '3.9'
- name: Install Python dependencies
run: pip install pytest requests
- name: Start API Server
run: |
swift run MyVaporPOC \&
sleep 5  \# Wait for server to start
- name: Run API Tests
run: pytest tests-python/ -v

```

## Testing Patterns

### Happy Path Testing
```

@Test("POST /todos creates a new todo")
func createTodo() async throws {
let dto = TodoDTO(id: nil, title: "integration test todo")
try await withApp { app in
try await app.testing().test(.POST, "todos", beforeRequest: { req in
try req.content.encode(dto)
}, afterResponse: { res async throws in
\#expect(res.status == .ok)
let returned = try res.content.decode(TodoDTO.self)
\#expect(returned.title == dto.title)
\#expect(returned.id != nil)
})
}
}

```

### Negative Testing
```

@Test("POST /todos with missing title returns error")
func createTodoMissingTitle() async throws {
try await withApp { app in
try await app.testing().test(.POST, "todos", beforeRequest: { req in
try req.content.encode([String: String]())
}, afterResponse: { res async throws in
\#expect(res.status == .badRequest)
})
}
}

```

## Performance Considerations

### Test Execution Speed
- Swift tests: ~0.1 seconds for full suite
- Python tests: ~0.2 seconds for API validation
- Total execution: Under 1 second

### Memory Usage
- In-memory SQLite minimizes resource usage
- Each test starts with clean state
- No persistent data between test runs

## Troubleshooting Common Issues

### "No such module 'Fluent'" Error
- Ensure all dependencies are resolved: `swift package resolve`
- Clean build folder: `rm -rf .build && swift build`

### Connection Refused in Python Tests
- Verify server is running: `swift run MyVaporPOC`
- Check port availability: `lsof -i :8080`
- Ensure BASE URL matches server configuration

### Database Migration Errors
- Verify `try await app.autoMigrate()` is called
- Check migration file syntax in `CreateTodo.swift`
- Ensure proper error handling in configure function
```