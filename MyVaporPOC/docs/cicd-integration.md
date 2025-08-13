# CI/CD Integration Examples

## GitHub Actions Workflow

### Complete Backend Testing Pipeline

Create `.github/workflows/backend-tests.yml`:

```yml
name: Backend Testing Pipeline

on:
push:
branches: [ main, develop, 'feature/*' ]
pull_request:
branches: [ main, develop ]

env:
SWIFT_VERSION: "5.9"
PYTHON_VERSION: "3.9"

jobs:
swift-tests:
name: Swift VaporTesting Suite
runs-on: macos-latest
timeout-minutes: 10

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Swift
        uses: swift-actions/setup-swift@v1
        with:
          swift-version: ${{ env.SWIFT_VERSION }}
          
      - name: Cache Swift packages
        uses: actions/cache@v3
        with:
          path: .build
          key: ${{ runner.os }}-swift-${{ hashFiles('Package.swift') }}
          restore-keys: |
            ${{ runner.os }}-swift-
            
      - name: Resolve dependencies
        run: swift package resolve
        
      - name: Build project
        run: swift build
        
      - name: Run Swift tests
        run: swift test --enable-code-coverage
        
      - name: Generate test coverage
        run: |
          xcrun llvm-cov export -format="lcov" \
            .build/debug/MyVaporPOCPackageTests.xctest/Contents/MacOS/MyVaporPOCPackageTests \
            -instr-profile .build/debug/codecov/default.profdata > coverage.lcov
            
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.lcov
          flags: swift-tests
          name: swift-coverage
    api-tests:
name: Python API Testing Suite
runs-on: macos-latest
timeout-minutes: 10
needs: swift-tests

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Swift
        uses: swift-actions/setup-swift@v1
        with:
          swift-version: ${{ env.SWIFT_VERSION }}
          
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: ${{ env.PYTHON_VERSION }}
          
      - name: Cache Python packages
        uses: actions/cache@v3
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('requirements.txt') }}
          restore-keys: |
            ${{ runner.os }}-pip-
            
      - name: Install Python dependencies
        run: |
          python -m pip install --upgrade pip
          pip install pytest requests pytest-html pytest-cov
          
      - name: Build Swift project
        run: swift build
        
      - name: Start API server
        run: |
          swift run MyVaporPOC &
          SERVER_PID=$!
          echo "SERVER_PID=$SERVER_PID" >> $GITHUB_ENV
          sleep 10  # Wait for server to fully start
          
      - name: Verify server is running
        run: |
          curl -f http://localhost:8080/hello || exit 1
          
      - name: Run Python API tests
        run: |
          cd tests-python
          pytest test_myvaporpoc_api.py -v --html=report.html --cov=. --cov-report=xml
          
      - name: Stop API server
        if: always()
        run: |
          if [ ! -z "$SERVER_PID" ]; then
            kill $SERVER_PID || true
          fi
          
      - name: Upload test results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: pytest-results
          path: tests-python/report.html
          
      - name: Upload API test coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./tests-python/coverage.xml
          flags: api-tests
          name: api-coverage
    integration-tests:
name: Full Integration Test Suite
runs-on: macos-latest
needs: [swift-tests, api-tests]
if: github.event_name == 'pull_request'

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Swift and Python
        uses: swift-actions/setup-swift@v1
        with:
          swift-version: ${{ env.SWIFT_VERSION }}
          
      - uses: actions/setup-python@v4
        with:
          python-version: ${{ env.PYTHON_VERSION }}
          
      - name: Install dependencies
        run: |
          swift package resolve
          pip install pytest requests
          
      - name: Run comprehensive test suite
        run: |
          # Run Swift tests
          swift test
          
          # Start server for API tests
          swift run MyVaporPOC &
          SERVER_PID=$!
          sleep 15
          
          # Run API tests
          pytest tests-python/ -v
          
          # Cleanup
          kill $SERVER_PID
```

### Simplified Workflow for Development

Create `.github/workflows/quick-tests.yml`:

```yml
name: Quick Test Suite

on:
push:
branches: [ 'feature/*' ]

jobs:
quick-validation:
runs-on: macos-latest
timeout-minutes: 5

    steps:
      - uses: actions/checkout@v4
      - uses: swift-actions/setup-swift@v1
        
      - name: Quick Swift test
        run: |
          swift package resolve
          swift test
          
      - name: Basic API validation
        run: |
          swift run MyVaporPOC &
          sleep 5
          curl -f http://localhost:8080/hello
```

## GitLab CI Integration

### `.gitlab-ci.yml`

```yml
  stages:

  - build
  - test
  - integration

  variables:
  SWIFT_VERSION: "5.9"

  before_script:

  - swift --version

  build:
  stage: build
  script:
  - swift package resolve
  - swift build
  artifacts:
  paths:
  - .build/
  expire_in: 1 hour

  swift-tests:
  stage: test
  dependencies:
  - build
  script:
  - swift test
  coverage: '/Coverage: \d+\.\d+/'

  api-tests:
  stage: test
  dependencies:
  - build
  before_script:
  - python3 -m pip install pytest requests
  script:
  - swift run MyVaporPOC \&
  - sleep 10
  - pytest tests-python/ -v
  after_script:
  - pkill -f MyVaporPOC || true

  integration:
  stage: integration
  dependencies:
  - build
  script:
  - swift test
  - swift run MyVaporPOC \&
  - sleep 15
  - python3 -m pip install pytest requests
  - pytest tests-python/ -v --junit-xml=report.xml
  artifacts:
  reports:
  junit: report.xml
  only:
  - merge_requests
  - main
```

## Jenkins Pipeline

### `Jenkinsfile`

```yml
pipeline {
agent any

    environment {
        SWIFT_VERSION = '5.9'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Dependencies') {
            steps {
                sh 'swift package resolve'
            }
        }
        
        stage('Build') {
            steps {
                sh 'swift build'
            }
        }
        
        stage('Swift Tests') {
            steps {
                sh 'swift test --enable-test-discovery'
            }
            post {
                always {
                    publishTestResults testResultsPattern: 'test-results.xml'
                }
            }
        }
        
        stage('API Tests') {
            steps {
                script {
                    // Start server in background
                    def serverProcess = sh(
                        script: 'swift run MyVaporPOC &',
                        returnStatus: true
                    )
                    
                    // Wait for server startup
                    sh 'sleep 15'
                    
                    // Install Python dependencies and run tests
                    sh '''
                        python3 -m pip install pytest requests
                        pytest tests-python/ -v --junit-xml=api-results.xml
                    '''
                }
            }
            post {
                always {
                    publishTestResults testResultsPattern: 'api-results.xml'
                    sh 'pkill -f MyVaporPOC || true'
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        failure {
            emailext (
                subject: "Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "Build failed. Check console output at ${env.BUILD_URL}",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
    }
    }
```

## Docker Integration

### Multi-stage Dockerfile for Testing

```
# Build stage

FROM swift:5.9 as builder

WORKDIR /app
COPY Package.swift .
COPY Sources ./Sources
COPY Tests ./Tests

RUN swift package resolve
RUN swift build --configuration release

# Test stage

FROM builder as tester

RUN swift test

# Python API test stage

FROM python:3.9-slim as api-tester

RUN pip install pytest requests

COPY tests-python/ /tests-python/
COPY --from=builder /app/.build/release/MyVaporPOC /usr/local/bin/

# Start server and run API tests

RUN MyVaporPOC \& \
sleep 10 \&\& \
pytest /tests-python/ -v

# Final runtime stage

FROM swift:5.9-slim

COPY --from=builder /app/.build/release/MyVaporPOC /usr/local/bin/

EXPOSE 8080
CMD ["MyVaporPOC"]
```

### Docker Compose for Testing

```
version: '3.8'

services:
app:
build: .
ports:
- "8080:8080"
environment:
- LOG_LEVEL=debug
healthcheck:
test: ["CMD", "curl", "-f", "http://localhost:8080/hello"]
interval: 30s
timeout: 10s
retries: 3

test-runner:
build:
context: .
target: tester
depends_on:
- app
command: ["swift", "test"]

api-test-runner:
image: python:3.9-slim
depends_on:
- app
volumes:
- ./tests-python:/tests
working_dir: /tests
command: |
sh -c "
pip install pytest requests \&\&
sleep 15 \&\&
pytest -v
"
```

## Quality Gates and Reporting

### Coverage Requirements

```
# In GitHub Actions

- name: Check coverage threshold
run: |
COVERAGE=\$(swift test --enable-code-coverage 2>\&1 | grep -o '[0-9]*\.[0-9]*%' | tail -1 | sed 's/%//')
if (( $(echo "$COVERAGE < 80" | bc -l) )); then
echo "Coverage \$COVERAGE% is below threshold of 80%"
exit 1
fi
```

### Performance Benchmarks

```
- name: Performance benchmarks
run: |

# Swift test performance

SWIFT_TIME=\$(time swift test 2>\&1 | grep real | awk '{print \$2}')

# API test performance

API_TIME=\$(time pytest tests-python/ 2>\&1 | grep real | awk '{print \$2}')

echo "Swift tests: \$SWIFT_TIME"
echo "API tests: \$API_TIME"

# Fail if tests take too long

if [[ "\$SWIFT_TIME" > "00:00:05" ]]; then
echo "Swift tests too slow: \$SWIFT_TIME"
exit 1
fi

```

### Notification Integration

```
- name: Slack notification
if: failure()
uses: 8398a7/action-slack@v3
with:
status: failure
channel: '\#backend-alerts'
text: 'Backend tests failed in \${{ github.repository }}'
env:
SLACK_WEBHOOK_URL: \${{ secrets.SLACK_WEBHOOK }}
```

## Environment-Specific Configurations

### Development Environment

```
env:
LOG_LEVEL: debug
DATABASE_URL: sqlite:///:memory:
ENVIRONMENT: development
```

### Staging Environment

```
env:
LOG_LEVEL: info
DATABASE_URL: sqlite:///staging.db
ENVIRONMENT: staging
```

### Production Environment

```
env:
LOG_LEVEL: warning
DATABASE_URL: \${{ secrets.DATABASE_URL }}
ENVIRONMENT: production
```

This CI/CD integration ensures your backend testing strategy runs consistently across all environments and provides comprehensive feedback for every code change.
