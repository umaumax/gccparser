# gccpaser

gccのコンパイル結果(error message)をパースして，何らかの処理を自動化

## gccpaser.awk
* コンパイル結果(error message)をパースして，ファイルパスと行を取得

## cpp_comment_out.sh
* 指定したファイルの指定した行から，その行が含まれる関数の次の関数の手前の行までコメントアウトする

### Issue
* `a`を指定すると`b`もコメントアウトされてしまう
  * catgsの出力のoptionを工夫する必要がありそう
```
void a() {

}
static int b =123;
void c() {

}
```
* 関数の途中のstructもcomment outされてしまう可能性がある?
