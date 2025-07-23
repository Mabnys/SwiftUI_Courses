# Troubleshooting Guide

## Common Issues and Solutions

### Database and Migration Issues

#### Issue: 500 Internal Server Error on API Endpoints
**Symptoms:**
- All `/todos` endpoints return 500 status
- Swift tests pass but Python API tests fail
- Server logs show database schema errors

**Root Cause:** Database tables not created before server starts handling requests

**Solution:**
1. Add `try await app.autoMigrate()` to `configure.swift` before routes registration:

```swift

public func configure(_ app: Application) async throws {
// Database configuration
if app.environment == .testing {
app.databases.use(.sqlite(.memory), as: .sqlite)
} else {
app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
}

       app.migrations.add(CreateTodo())
       app.views.use(.leaf)
       
       // Critical: Run migrations before routes
       try await app.autoMigrate()
       
       try routes(app)
    }

```

2. Restart the server after making changes
3. Verify migration success in server logs

#### Issue: Test Data Pollution Between Tests
**Symptoms:**
- Tests fail when run together but pass individually
- Inconsistent test results
- Data from previous tests affects current test

**Root Cause:** Database state not reset between tests

**Solution:**
1. Always use in-memory SQLite for tests
2. Use the `withApp` helper pattern:

```swift
private func withApp(_ test: (Application) async throws -> ()) async throws {
let app = try await Application.make(.testing)
do {
try await configure(app)
try await app.autoMigrate()
try await test(app)
try await app.autoRevert()  // Critical: Revert changes
} catch {
try? await app.autoRevert()
try await app.asyncShutdown()
throw error
}
try await app.asyncShutdown()
}
```

### Connection and Network Issues

#### Issue: "Connection Refused" in Python Tests
**Symptoms:**

```
requests.exceptions.ConnectionError: HTTPConnectionPool(host='localhost', port=8080):
Max retries exceeded with url: /todos
```

**Root Cause:** Swift API server not running when Python tests execute

**Solution:**
1. Start the server before running Python tests:

```
swift run MyVaporPOC &
sleep 5  # Wait for server to start
pytest tests-python
```

2. Verify server is listening:

```
curl http://localhost:8080/hello

# Should return: "Hello, world!"
```

3. Check if port is already in use:

```sh
lsof -i :8080
```

#### Issue: Wrong Port or Host Configuration
**Symptoms:**
- Python tests connect but get unexpected responses
- Server logs show requests on different port

**Root Cause:** Server running on different port than expected

**Solution:**
1. Check server startup logs for actual port:

```
[ INFO ] Server starting on http://127.0.0.1:8080
```

2. Update Python test BASE URL if needed:

```
BASE = "http://localhost:8080"  # Match actual server port
```

3. Explicitly set port when starting server:

```
PORT=8080 swift run MyVaporPOC
```

### Swift Package and Compilation Issues

#### Issue: "No such module 'Fluent'" in Tests
**Symptoms:**
- Test compilation fails
- Import statements cause errors

**Root Cause:** Dependencies not properly resolved or linked

**Solution:**
1. Clean and rebuild:

```sh
rm -rf .build
swift package resolve
swift build
```

2. If using Xcode, restart and regenerate project:
```

swift package generate-xcodeproj

```

3. Verify Package.swift has correct test target dependencies:

```swift
.testTarget(
name: "MyVaporPOCTests",
dependencies: [
.target(name: "MyVaporPOC"),
.product(name: "VaporTesting", package: "vapor"),
]
)
```

#### Issue: Swift Concurrency Warnings or Errors
**Symptoms:**
- Compiler warnings about async/await usage
- Tests hang or fail with concurrency errors

**Root Cause:** Mixing sync and async code incorrectly

**Solution:**
1. Ensure all test functions are marked `async throws`:

```swift
@Test("Test name")
func testFunction() async throws {
// Test implementation
}
```

2. Properly await async operations:

```swift
try await app.testing().test(.GET, "todos", afterResponse: { res async throws in
// Async response handling
})
```

### API and Validation Issues

#### Issue: Expected 400 but Got 500 on Invalid Input
**Symptoms:**
- Edge case tests expect 400 Bad Request
- Server returns 500 Internal Server Error instead

**Root Cause:** Missing input validation in controllers

**Solution:**
1. Add proper validation to controller methods:

```swift
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

2. Test validation logic:

```swift
@Test("POST /todos with missing title returns 400")
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

### Performance and Timing Issues

#### Issue: Tests Are Slow or Time Out
**Symptoms:**
- Test suite takes more than expected time
- Individual tests hang or timeout

**Root Cause:** Database operations or network calls not optimized

**Solution:**
1. Use in-memory SQLite for all tests
2. Minimize database operations in tests
3. Set appropriate timeouts for HTTP requests:

```
response = requests.get(f"{BASE}/hello", timeout=5)
```

4. Run tests in parallel where possible:

```sh
pytest tests-python -n auto  # Requires pytest-xdist
```

### CI/CD Integration Issues

#### Issue: Tests Pass Locally but Fail in CI
**Symptoms:**
- All tests pass on developer machine
- CI pipeline fails with test errors

**Root Cause:** Environment differences or race conditions

**Solution:**
1. Ensure consistent environment variables
2. Add proper wait times for server startup in CI:

```
- name: Start API Server
run: |
swift run MyVaporPOC &
sleep 10  # Longer wait in CI environment
```

3. Use absolute paths and explicit configurations
4. Check CI logs for specific error messages

## Performance Benchmarks

### Expected Performance Metrics
- **Swift Test Suite**: < 0.5 seconds for full suite
- **Python API Tests**: < 1 second for all endpoints
- **Total Test Time**: < 2 seconds combined

### Performance Troubleshooting
If tests are slower than expected:

1. **Database Performance:**
- Ensure using in-memory SQLite
- Check for unnecessary database queries
- Optimize test data creation

2. **Network Performance:**
- Use localhost instead of 127.0.0.1
- Check for DNS resolution delays
- Minimize HTTP request payloads

3. **Concurrency Issues:**
- Avoid blocking operations in async contexts
- Use proper async/await patterns
- Check for deadlocks or race conditions

## Getting Help

### Debug Information to Collect
When reporting issues, include:

1. **System Information:**
- Swift version: `swift --version`
- Python version: `python --version`
- Operating system and version

2. **Error Messages:**
- Complete error output
- Server logs during failure
- Test execution logs

3. **Configuration:**
- Package.swift content
- Environment variables
- Test command used

### Useful Commands for Debugging

```sh
# Check Swift package status

swift package show-dependencies

# Verbose test output

swift test --verbose

# Python test debugging

pytest tests-python -v -s

# Check server status

curl -v http://localhost:8080/hello

# Database file inspection (if using file-based SQLite)

sqlite3 db.sqlite ".tables"
```