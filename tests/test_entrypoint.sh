#!/bin/bash
# Test suite for codemeta2zenodo GitHub Action
# Run with: bash tests/test_entrypoint.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENTRYPOINT="$PROJECT_ROOT/entrypoint.sh"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test helper functions
setup_test_dir() {
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR"
    echo "$TEST_DIR"
}

cleanup_test_dir() {
    if [ -n "$TEST_DIR" ] && [ -d "$TEST_DIR" ]; then
        rm -rf "$TEST_DIR"
    fi
}

assert_file_exists() {
    local file=$1
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} File exists: $file"
        return 0
    else
        echo -e "${RED}✗${NC} File does not exist: $file"
        return 1
    fi
}

assert_file_not_exists() {
    local file=$1
    if [ ! -f "$file" ]; then
        echo -e "${GREEN}✓${NC} File does not exist (as expected): $file"
        return 0
    else
        echo -e "${RED}✗${NC} File exists (unexpected): $file"
        return 1
    fi
}

run_test() {
    local test_name=$1
    TESTS_RUN=$((TESTS_RUN + 1))
    echo ""
    echo -e "${YELLOW}Running test: $test_name${NC}"
    echo "----------------------------------------"
}

test_passed() {
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo -e "${GREEN}✓ Test passed${NC}"
}

test_failed() {
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo -e "${RED}✗ Test failed${NC}"
}

# Create a minimal valid codemeta.json for testing
create_test_codemeta() {
    local filename=${1:-codemeta.json}
    cat > "$filename" <<'EOF'
{
  "@context": "https://doi.org/10.5063/schema/codemeta-2.0",
  "@type": "SoftwareSourceCode",
  "name": "test-software",
  "description": "A test software project",
  "version": "1.0.0",
  "author": [
    {
      "@type": "Person",
      "givenName": "Test",
      "familyName": "User"
    }
  ]
}
EOF
}

# Test 1: Missing input file
test_missing_input() {
    run_test "Test 1: Missing input file should fail"
    TEST_DIR=$(setup_test_dir)
    
    if bash "$ENTRYPOINT" "nonexistent.json" "false" 2>/dev/null; then
        echo "Expected failure but succeeded"
        cleanup_test_dir
        test_failed
        return 1
    else
        echo "Correctly failed with missing input file"
        cleanup_test_dir
        test_passed
        return 0
    fi
}

# Test 2: Validate script syntax
test_script_syntax() {
    run_test "Test 2: Validate script syntax"
    
    if bash -n "$ENTRYPOINT"; then
        echo "Script syntax is valid"
        test_passed
        return 0
    else
        echo "Script has syntax errors"
        test_failed
        return 1
    fi
}

# Test 3: Check script permissions
test_script_executable() {
    run_test "Test 3: Check script is executable"
    
    if [ -x "$ENTRYPOINT" ]; then
        echo "Script is executable"
        test_passed
        return 0
    else
        echo "Script is not executable"
        test_failed
        return 1
    fi
}

# Test 4: Verify test fixture validity
test_fixture_validity() {
    run_test "Test 4: Verify test fixtures are valid JSON"
    TEST_DIR=$(setup_test_dir)
    
    create_test_codemeta "test.json"
    
    if command -v python3 >/dev/null 2>&1; then
        if python3 -c "import json; json.load(open('test.json'))" 2>/dev/null; then
            echo "Test fixture is valid JSON"
            cleanup_test_dir
            test_passed
            return 0
        else
            echo "Test fixture is invalid JSON"
            cleanup_test_dir
            test_failed
            return 1
        fi
    else
        echo "Python3 not available, skipping JSON validation"
        cleanup_test_dir
        test_passed
        return 0
    fi
}

# Main test execution
echo "========================================"
echo "CodeMeta2Zenodo Action Test Suite"
echo "========================================"

# Run all tests
test_script_syntax
test_script_executable
test_missing_input
test_fixture_validity

# Summary
echo ""
echo "========================================"
echo "Test Summary"
echo "========================================"
echo -e "Tests run:    $TESTS_RUN"
echo -e "${GREEN}Tests passed: $TESTS_PASSED${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "${RED}Tests failed: $TESTS_FAILED${NC}"
else
    echo -e "Tests failed: $TESTS_FAILED"
fi
echo "========================================"

if [ $TESTS_FAILED -gt 0 ]; then
    exit 1
else
    exit 0
fi
