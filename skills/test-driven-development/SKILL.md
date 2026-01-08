---
name: test-driven-development
description: Use when implementing any feature or bugfix, before writing implementation code
---

# Test-Driven Development

## The Core Loop

```
RED -> GREEN -> REFACTOR
```

1. **RED**: Write a failing test that defines desired behavior
2. **GREEN**: Write minimal code to make test pass
3. **REFACTOR**: Clean up while keeping tests green

## When to Use

- Implementing new features
- Fixing bugs (write test that reproduces bug first)
- Refactoring existing code
- Adding to existing test suite

## The Rules

### Rule 1: Test First, Always

Never write implementation code without a failing test.

```
WRONG: Write feature -> Write test -> Hope it works
RIGHT: Write test -> See it fail -> Write feature -> See it pass
```

### Rule 2: Minimal Implementation

Write only enough code to pass the current test. No more.

```
WRONG: "While I'm here, let me also handle edge cases X, Y, Z"
RIGHT: Make this ONE test pass. Add tests for X, Y, Z next.
```

### Rule 3: One Behavior Per Test

Each test should verify one specific behavior.

```
WRONG: test_user_can_login_and_update_profile_and_logout()
RIGHT: test_user_can_login()
       test_logged_in_user_can_update_profile()
       test_user_can_logout()
```

### Rule 4: Tests Document Intent

Test names should read like specifications.

```
WRONG: test_1(), test_foo(), test_it_works()
RIGHT: test_empty_cart_has_zero_total()
       test_adding_item_increases_cart_count()
       test_removing_last_item_empties_cart()
```

## The Process

### Step 1: Understand the Requirement

Before writing any code:
- What behavior needs to exist?
- What are the inputs?
- What are the expected outputs?
- What are the edge cases?

### Step 2: Write the Test

```python
def test_calculate_discount_applies_ten_percent_for_orders_over_100():
    order = Order(total=150.00)
    discount = calculate_discount(order)
    assert discount == 15.00
```

### Step 3: Run and See It Fail

The test MUST fail. If it passes:
- The feature already exists (verify this)
- The test is wrong (fix it)
- You're testing the wrong thing (rethink)

### Step 4: Write Minimal Code

```python
def calculate_discount(order):
    if order.total > 100:
        return order.total * 0.10
    return 0
```

### Step 5: Run and See It Pass

If it fails, fix implementation (not the test, unless test was wrong).

### Step 6: Refactor

Now clean up:
- Extract magic numbers to constants
- Rename for clarity
- Remove duplication

Tests stay green throughout.

## Test Structure: Arrange-Act-Assert

```python
def test_something():
    # Arrange: Set up the conditions
    user = create_user(name="Alice")
    cart = Cart(user=user)
    cart.add_item(product, quantity=2)
    
    # Act: Perform the action
    total = cart.calculate_total()
    
    # Assert: Verify the result
    assert total == product.price * 2
```

## What Makes a Good Test

| Quality | Description |
|---------|-------------|
| **Fast** | Runs in milliseconds |
| **Isolated** | No dependencies on other tests |
| **Repeatable** | Same result every time |
| **Self-validating** | Pass or fail, no manual checking |
| **Timely** | Written before production code |

## Common Mistakes

### Writing Too Much at Once

```
WRONG: Write 10 tests, then implement everything
RIGHT: Write 1 test, implement, write next test, implement...
```

### Testing Implementation Details

```
WRONG: assert mock_database.save.called_with(user_dict)
RIGHT: assert user_repository.find_by_id(user.id) == user
```

### Skipping the Red Phase

If you never see the test fail, you don't know it can fail.
A test that can't fail provides no value.

### Over-mocking

```
WRONG: Mock everything, test nothing real
RIGHT: Mock external dependencies only (DB, API, filesystem)
```

## For Bugfixes

1. Write a test that reproduces the bug
2. See it fail (confirms bug exists)
3. Fix the bug
4. See test pass (confirms fix works)
5. Bug can never return undetected

## Quick Reference

| Phase | Action | Outcome |
|-------|--------|---------|
| **RED** | Write failing test | Test fails, proves it can detect the problem |
| **GREEN** | Write minimal code | Test passes, feature works |
| **REFACTOR** | Clean up code | Tests still pass, code is clean |
