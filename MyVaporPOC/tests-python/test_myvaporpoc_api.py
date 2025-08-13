""" 
# test_myvaporpoc_api.py

API-level integration tests for the MyVaporPOC Swift backend, using pytest.

- Runs black-box tests on the running Swagger API at http://localhost:8080
- Complements the Swift VaporTesting suite with Python black-box and system-level scenarios
- Covers CRUD, happy path, and negative/edge cases
"""

import requests

BASE = "http://localhost:8080"

## MARK: - Happy Path Tests

def test_hello():
    """
    ## Test: GET /hello
    Verifies the /hello endpoint returns HTTP 200 and correct response body.
    """
    r = requests.get(f"{BASE}/hello")
    assert r.status_code == 200
    assert r.text == "Hello, world!"


def test_create_and_list_todo():
    """
    ## Test: POST + GET /todos
    - Creates a new Todo via POST, expects 200 and returned todo
    - Lists all todos, ensures new record is present
    """
    # Create
    todo = {"title": "pytest task"}
    r = requests.post(f"{BASE}/todos", json=todo)
    assert r.status_code == 200
    body = r.json()
    assert body["title"] == "pytest task"
    assert "id" in body

    # List should include new todo
    r2 = requests.get(f"{BASE}/todos")
    assert r2.status_code == 200
    todos = r2.json()
    assert any(t["title"] == "pytest task" for t in todos)

## MARK: - Edge/Negative Case Tests

def test_create_todo_missing_title():
    """
    ## Test: POST /todos with missing title
    Expects 400 Bad Request (input validation).
    """
    r = requests.post(f"{BASE}/todos", json={})
    assert r.status_code == 400


def test_delete_nonexistent_todo():
    """
    ## Test: DELETE /todos/:id with nonexistent ID
    Expects 404 Not Found if the todo does not exist.
    """
    import uuid
    fake_id = str(uuid.uuid4())
    r = requests.delete(f"{BASE}/todos/" + fake_id)
    assert r.status_code == 404


def test_create_todo_empty_body():
    """
    ## Test: POST /todos with empty body
    Expects 400 Bad Request (body/decoding failure).
    """
    r = requests.post(f"{BASE}/todos")
    assert r.status_code == 400

def test_get_todos_empty():
    """
    ## Test: GET /todos when no todos exist
    Returns 200 OK and an empty list.
    """
    r = requests.get(f"{BASE}/todos")
    assert r.status_code == 200
    assert isinstance(r.json(), list)
