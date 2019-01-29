# double to float

## Issue
* `std::string version="1.0";` to `std::string version="1.0f";`

fuzzy confirmation command
```
git diff HEAD | grep '^[+-]' | grep '".*[0-9]f.*"'
```
