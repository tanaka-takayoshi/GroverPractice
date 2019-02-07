using System;
using System.Linq;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace GroverPractice
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var qsim = new QuantumSimulator())
            {
                //データベースのサイズ(databaseSize)Nに対する
                //必要な量子ビット数(nDatabaseQubits)n. N=2^n
                var nDatabaseQubits = 6;
                var databaseSize = Math.Pow(2.0, nDatabaseQubits);

                //振幅増幅を繰り返す回数k。
                //確率をほぼ1にするためには PI/4*Sqrt(N)-1/2なので、N=2^6なら6回程度必要。
                var nIterations = 3;

                // データベースに対する問い合わせ数
                var queries = nIterations * 2 + 1;

                // 期待される確率を計算して、実際の結果と比較する
                // 古典アルゴリズムでの確率は、N個から1つ探す確率なので
                var classicalSuccessProbability = 1.0 / databaseSize;
                // Groverアルゴリズムでの確率sin[(2*k+1)θ]。ただしsinθ=Sqrt(1/N)
                var quantumSuccessProbability = Math.Pow(Math.Sin((2.0 * (double)nIterations + 1.0) * Math.Asin(1.0 / Math.Sqrt(databaseSize))),2.0);
                // 一連の測定を繰り返す回数
                var repeats = 100;
                // 探索がうまく行った回数
                var successCount = 0;

                Console.Write(
                    $"\n\nQuantum search for marked element in database.\n" +
                    $"  データベースにサイズ: {databaseSize}.\n" +
                    $"  古典アルゴリズムでの確率: {classicalSuccessProbability}\n" +
                    $"  1回当たりの問い合わせ数: {queries} \n" +
                    $"  量子アルゴリズムでの確率: {quantumSuccessProbability}\n\n");



                foreach (var idxAttempt in Enumerable.Range(0, repeats))
                {
                    //必要なパラメーターを渡してQ#のコードを実行
                    // GetAwaiter().GetResult() はC#のasync/await構文
                    // var () = ... という書き方はタプル構文を参照してください
                    var (markedQubit, databaseRegister) = ApplyQuantumSearch.Run(qsim, nIterations, nDatabaseQubits).GetAwaiter().GetResult();

                    // 探索に成功していればカウントアップ
                    successCount += markedQubit == Result.One ? 1 : 0;

                    // 10回ごとに結果を表示する (10回ごとに特に意味はない)
                    if ((idxAttempt + 1) % 10 == 0)
                    {
                        // 成功した割合を表示
                        var empiricalSuccessProbability = Math.Round((double)successCount / ((double)idxAttempt + 1), 3);

                        // 古典アルゴリズムよりどけだけよかったか（割合の比）
                        var speedupFactor = Math.Round(empiricalSuccessProbability / classicalSuccessProbability / (double)queries, 3);

                        Console.Write(
                            $"Attempt {idxAttempt}. " +
                            $"Success: {markedQubit},  " +
                            $"Probability: {empiricalSuccessProbability} " +
                            $"Speedup: {speedupFactor} " +
                            $"Found database index {string.Join(", ", databaseRegister.ToArray().Select(x => x.ToString()).ToArray())} \n");
                    }
                }
            }
        }
    }
}