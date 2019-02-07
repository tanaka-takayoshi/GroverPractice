# 問題 Groverの探索アルゴリズムの実装

この問題はMicrosoftのコードサンプルを使って、ちいさく切り出した上で、少し編集しています。
https://github.com/Microsoft/Quantum/tree/release/v0.3.1810/Samples/src/DatabaseSearch

## 問題の出し方

Driver.csはすべて書いてある状態。
Operations.qsはメソッド定義とヒント(TODO)が書いてある状態を問題として、TODOをうめていく想定。
(まだどこをTODOにするかは決めていない)

C#からQ#には、確率振幅増幅を何回行うか(nIterations)とデータベースの量子ビット列のサイズ(nDatabaseQubits)を渡す。
つまりデータベースのサイズは2^nDatabaseQubits。
実装の簡単のため、探索する状態は固定で |1..1> としている。


## ハンズオンの手順

1. TODOをうめていく
2. 実行してみる
3. データベースサイズや繰り返し数を変えて試してみる
4. AmpAmpByOracle APIを紹介して、それを使って書き換えてみる

[AmpAmpByOracle](https://docs.microsoft.com/en-us/qsharp/api/canon/microsoft.quantum.canon.ampampbyoracle?view=qsharp-preview)はQ#がAPIとして提供している振幅増幅の関数。これを使うと、振幅増幅部分で量子ゲートを並べて実装するようなコードをかかずにすむ。
今回の実装だとあまり簡単さに変化はないが、じつはGroverのアルゴリズムは探索対象を複数にすることもでき、そのようなケースでは便利になる。
検索対象が複数になるケースは実際に動くプロジェクトのサンプルをあわせて提供する予定。