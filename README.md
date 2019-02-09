# 問題 Groverの探索アルゴリズムの実装

この問題は[Microsoftのコードサンプル](https://github.com/Microsoft/Quantum/tree/release/v0.3.1810/Samples/src/DatabaseSearch)を一部利用し、編集しています。


## 問題

[`GroverPractice`](./GroverPractice)フォルダ以下が問題です。次のコマンドで実行できるようになっています。

```
> cd GroverPractice 
> dotnet run
```

Driver.csは編集する必要はありません。
Operations.qsはメソッド定義とヒント(TODO)が書いてあるので、TODOの箇所を埋めていってください。

C#からQ#には、確率振幅増幅を何回行うか(nIterations)とデータベースの量子ビット列のサイズ(nDatabaseQubits)を渡す。
つまりデータベースのサイズは2^nDatabaseQubits。
実装の簡単のため、探索する状態は固定で |1..1> としています。

## ハンズオンの手順

1. TODOをうめていく
2. 実行してみる
3. データベースサイズ(nDatabaseQubits)や繰り返し数(nIterations)を変えて試してみる
4. AmpAmpByOracle APIを使うパターンに実装を変更してみる。

[AmpAmpByOracle](https://docs.microsoft.com/en-us/qsharp/api/canon/microsoft.quantum.canon.ampampbyoracle?view=qsharp-preview)はQ#がAPIとして提供している振幅増幅の関数です。これを使うと振幅増幅部分で量子ゲートを並べて実装するようなコードをかかずにすみます。
今回の実装だとあまり簡単さに変化はありませんが、Groverのアルゴリズムは探索対象を複数にすることもでき、そのようなケースではコードが非常に完結になります。
[GroverMulti](./GroverMulti)に探索対象が複数の場合の実装例を載せています。