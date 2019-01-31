# double to float

## Issue
* `std::string version="1.0";` to `std::string version="1.0f";`
* `double abc = 1.0; // comment` to `double abc = 1.0; // comment`
```
/*
 * ver 1.0
 *
 */
```
```
xxx_to_double
doublecomplex
doublereal
```

## how to conv
```
git sed "$pattern" -- '*.cpp' '*.cxx' '*.cc' '*.c' '*.h' '*.hh' '*.hpp' '*.hxx' '!:$IGNORE_DIR/'
```

## fuzzy confirmation command
```
git diff HEAD | grep -E '^[+-]' | grep -E '".*[0-9]f.*"'
git diff HEAD | grep -E '^[+-]' | grep -E '^\s*\*.*[0-9]f.*'
git diff HEAD | grep -E '^[+-]' | grep -E '[a-zA-Z0-9_]double|double[a-zA-Z0-9_]'
```
