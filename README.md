# gccpaser

gccのコンパイル結果(error message)をパースして，何らかの処理を自動化

## gccpaser.awk
* コンパイル結果(error message)をパースして，ファイルパスと行を取得

## cpp_comment_out.sh
* 指定したファイルの指定した行から，その行が含まれる関数の次の関数の手前の行までコメントアウトする

## how to use
```
./cpp_comment_out.sh -i main.cpp 13
```

## NOTE
* しばしば，c++ファイルのヘッダにもかかわらず，拡張子が`.h`のファイルがある場合には，拡張子を`.hpp`としたファイルを作成する必要がある(symbolic linkでもよい)

### Issue of using ctags
* `a`を指定すると`b`,`bb`もコメントアウトされてしまう
  * catgsの出力のoptionを工夫する必要がありそう
```
void a() {

}
static int b =123;
struct bb {
};
void c() {

}
```

## how to run python
### Mac OS X
```
brew install llvm
pip install clang

# for libclang.dylib
LD_LIBRARY_PATH="/usr/local/opt/llvm/lib:$LD_LIBRARY_PATH" ./cpp_func_def.py
```
### Ubuntu
```
# pip3 install clang
# or
pip3 install clang-5
LD_LIBRARY_PATH="/usr/lib/llvm-5.0/lib:$LD_LIBRARY_PATH" ./cpp_func_def.py
```

* 動作はするが、errorが出現することもある(たまに出てこない)ので，その理由を解析
```
Exception ignored in: <bound method TranslationUnit.__del__ of <clang.cindex.TranslationUnit object at 0x7fcd4e3e6b38>>
Traceback (most recent call last):
  File "~/.local/lib/python3.5/site-packages/clang/cindex.py", line 2749, in __del__
AttributeError: 'NoneType' object has no attribute 'lib'
Exception ignored in: <bound method Index.__del__ of <clang.cindex.Index object at 0x7fcd4e451d30>>
Traceback (most recent call last):
  File "~/.local/lib/python3.5/site-packages/clang/cindex.py", line 2580, in __del__
AttributeError: 'NoneType' object has no attribute 'lib'
```

## FYI
### show all include files
* [clang/cindex\-includes\.py at master · llvm\-mirror/clang]( https://github.com/llvm-mirror/clang/blob/master/bindings/python/examples/cindex/cindex-includes.py )

### pages
* [ClangのPython bindingを使ったC\+\+の関数定義部の特定 \- Qiita]( https://qiita.com/subaru44k/items/4e69ec987547011d7e63 )
* [Clangのpython bindingsを使う \- 脱初心者を目指す]( http://asdm.hatenablog.com/entry/2015/01/08/170707 )
* [libclangを使ってC\+\+のメンバにアノテーションをつける \- Qiita]( https://qiita.com/YosukeM/items/17232558c86dc236f317 )
* [libclangのPython bindingsで構文解析する]( https://kimiyuki.net/blog/2017/08/17/libclang-python-bindings-tutorial/ )

----

### ctags
```
$ ctags --list-kinds
C++
    c  classes
    d  macro definitions
    e  enumerators (values inside an enumeration)
    f  function definitions
    g  enumeration names
    l  local variables [off]
    m  class, struct, and union members
    n  namespaces
    p  function prototypes [off]
    s  structure names
    t  typedefs
    u  union names
    v  variable definitions
    x  external and forward variable declarations [off]
```
```
ctags -x --c++-kinds=+xp-d main.cpp | sort -n -k 3
```
