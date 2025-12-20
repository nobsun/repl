# repl
Read-Eval-Print-Loop のテンプレート

## はじめに

このプロジェクトは、プログラミング言語解釈系のREPL部分（String -> String）をラップして、I/O担当部分を提供するライブラリ（になる予定）です。

## 構成の概要

以下を含む

- 指定したテキストファイルの内容
- haskeline を利用して行編集可能なユーザー入力

全体としては、以下のとおりになることを想定しています。

```haskell
main :: IO ()
main = let 
         ?history = Just "repl.log"
         ?prompt  = "> "
       in  interact' repl
```

`?history :: Maybe FilePath` は入力ログファイルを、`prompt :: String`は入力プロンプト文字列を指定します。
`repl :: String -> String` は入力全体を出力全体に変換する関数です。
これを具体的に定義し与えると動作します。
