# MyVaporPOC - Backend Testing Framework Implementation

A comprehensive proof-of-concept demonstrating modern backend testing strategies for Swift Vapor applications, featuring both native Swift testing (VaporTesting) and external API validation (Pytest).

## 🎯 Project Overview

This POC implements the backend testing recommendations from the **QA Engineering: CI/CD Test Strategy Research & Implementation** initiative. It demonstrates how to achieve robust, automated test coverage for a Swift Vapor backend using open-source, CI/CD-friendly testing frameworks.
 
### Key Features
- **VaporTesting (aka XCTVapor) (Swift)**: In-memory, isolated unit and integration testing
- **Pytest + Requests (Python)**: Black-box API contract testing
- **SQLite In-Memory**: Fast, isolated database testing
- **CI/CD Ready**: GitHub Actions integration examples
- **SwiftDocC Documentation**: Comprehensive inline documentation

## 🏗️ Architecture

### Backend Stack
- **Framework**: Swift Vapor 4.115+
- **Database**: SQLite (in-memory for tests, file for development)
- **Models**: Todo CRUD operations with UUID-based identification
- **API**: RESTful endpoints with proper HTTP status codes

### Testing Strategy

```
┌─────────────────┐    ┌──────────────────┐
│   VaporTesting  │    │  Pytest + HTTP   │
│   (Swift)       │    │  (Python)        │
├─────────────────┤    ├──────────────────┤
│ -  Unit Tests   │    │ -  API Contract  │
│ -  Integration  │    │ -  E2E Flows     │
│ -  DB Operations│    │ -  Error Handling│
│ -  In-Memory    │    │ -  Black-box     │
└─────────────────┘    └──────────────────┘
          │                       │
          └───────┬───────────────┘
                  │
          ┌───────▼────────┐
          │  MyVaporPOC    │
          │  Swift API     │
          └────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Swift 5.2+
- Python 3.8+
- Vapor CLI (optional)

### Installation
1. **Clone and setup Swift dependencies:**

```
git clone <repository>
cd MyVaporPOC
swift package resolve
```

2. **Install Python testing dependencies:**

```
pip install pytest requests
```

3. **Run Swift tests:**

```
swift test
```

4. **Start the API server:**

```
swift run MyVaporPOC

# Server starts at http://localhost:8080
```

5. **Run Python API tests:**
```

cd tests-python
pytest test_myvaporpoc_api.py

```

## 📋 Test Coverage

### Swift VaporTesting Suite (`MyVaporPOCTests.swift`)
- ✅ **Happy Path Tests**
- GET `/hello` → 200 "Hello, world!"
- GET `/todos` → 200 with empty/populated arrays
- POST `/todos` → 200 with created Todo
- DELETE `/todos/:id` → 204 for existing records

- ❌ **Edge/Negative Tests**
- POST `/todos` (missing title) → 400 Bad Request
- POST `/todos` (empty body) → 400 Bad Request
- DELETE `/todos/:nonexistent` → 404 Not Found

### Python Pytest Suite (`test_myvaporpoc_api.py`)
- 🔍 **API Contract Tests**
- All CRUD endpoints with proper HTTP status codes
- JSON response structure validation
- Error message consistency
- Cross-language compatibility verification

## 🧪 Test Execution

### Local Development

```
# Swift native tests (fast, in-memory)

swift test

# Start API server for external testing

swift run MyVaporPOC &

# Python black-box API tests

pytest test_myvaporpoc_api.py
```

### CI/CD Integration

```
# GitHub Actions example

- name: Run Swift Tests
run: swift test
- name: Start API Server
run: swift run MyVaporPOC &
- name: Run API Tests
run: pytest tests-python
```

## 🛠️ Key Components

### Database Configuration (`configure.swift`)
- **Testing Environment**: In-memory SQLite for isolation
- **Development Environment**: File-based SQLite for persistence
- **Auto-migration**: Ensures schema is ready before tests

### Test Isolation (`withApp` helper)
- Creates fresh application instance per test
- Applies all migrations
- Automatically reverts database changes
- Prevents test pollution and ensures repeatability

### Error Handling (`TodoController.swift`)
- Input validation with descriptive error messages
- Proper HTTP status codes (400, 404, 500)
- Graceful handling of malformed requests

## 📚 Documentation

Comprehensive documentation is available in the [`docs/`](./docs/) directory:
- **[MyVaporPOC](./docs/MYVAPORPOC.md)**: Best Testing Frameworks for the backend
- **[Presentation File](./docs/implementation-guide.md)**: Backend Testing Frameworks' Details Overview
- **[Testing Strategy](./docs/testing-strategy.md)**: Testing Strategy for MyVaporPOC
- **[Implementation Guide](./docs/implementation-guide.md)**: Implementation Guide for MyVaporPOC
- **[CI/CD Integration](./docs/cicd-integration.md)**: Pipeline configuration examples

## 🔧 Troubleshooting

### Common Issues
| Issue | Cause | Solution |
|-------|-------|----------|
| 500 errors on `/todos` | Missing DB migration | Add `try await app.autoMigrate()` to `configure.swift` |
| Connection refused (pytest) | API server not running | Start server with `swift run MyVaporPOC` |
| Test data leakage | Missing DB reset | Use `withApp` helper for proper isolation |

### Performance Benchmarks
- **Swift Tests**: ~0.07 seconds for full suite (9 tests)
- **Python Tests**: ~0.10 seconds for API validation (6 tests)
- **Total Coverage**: 90%+ of API endpoints and error cases

## 🎯 Future Enhancements [For PortkeyServer Issue](https://github.com/ny-mobile/PortKeyServer/issues/120)

This POC provides the foundation for expanding to full MVP requirements:
- **Multi-tenant testing**: Tenant isolation and cross-tenant access prevention
- **OAuth 2.0 PKCE flows**: Authorization code flow with PKCE testing
- **LDAP integration testing**: Authentication and authorization flows
- **Performance testing**: Load testing with K6 or similar tools
- **Security testing**: Input validation, SQL injection, XSS prevention