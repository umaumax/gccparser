# double to float

## Issue
* `std::string version="1.0";` to `std::string version="1.0f";`
* `double abc = 1.0; // comment` to `double abc = 1.0; // comment`
```
/*
 * ver 1.0
 * created 2018.12.31 by xxx
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

## FYI
[基本構造体 — opencv v2\.1 documentation]( http://opencv.jp/opencv-2.1/cpp/basic_structures.html#cv-mat-depth )
```
CV_32F - 32-ビット浮動小数点数 ( -FLT_MAX..FLT_MAX, INF, NAN )
CV_64F - 64-ビット浮動小数点数 ( -DBL_MAX..DBL_MAX, INF, NAN )
```
