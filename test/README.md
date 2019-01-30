# double to float

## Issue
* `std::string version="1.0";` to `std::string version="1.0f";`
* `double abc = 1.0; // comment` to `double abc = 1.0; // comment`

fuzzy confirmation command
```
git diff HEAD | grep '^[+-]' | grep '".*[0-9]f.*"'
```
