using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System.Linq;

namespace GroverMulti
{
    class Driver
    {
        static void Main(string[] args)
        {
            var sim = new QuantumSimulator(throwOnReleasingQubitsNotInZeroState: true);

            //データベースのサイズ(databaseSize)Nに対する
            //必要な量子ビット数(nDatabaseQubits)n. N=2^n
            var nDatabaseQubits = 8;
            var databaseSize = Math.Pow(2.0, nDatabaseQubits);

            //探索対象のビットのIndex。IndexはdatabaseSizeより小さい必要がある。
            var markedElements = new QArray<long>() { 0, 39, 101, 234 };
            var nMarkedElements = markedElements.Length;
            
            //振幅増幅を繰り返す回数k。
            //確率をほぼ1にするためには PI/4*Sqrt(N)-1/2なので、N=2^8なら12回程度必要。
            var nIterations = 3;

            // データベースに対する問い合わせ数
            var queries = nIterations * 2 + 1;

            // 期待される確率を計算して、実際の結果と比較する
            // 古典アルゴリズムでの確率は、N個から1つ探す確率なので
            var classicalSuccessProbability = (double)(nMarkedElements) / databaseSize;
            // Groverアルゴリズムでの確率sin^2[(2*k+1)θ]。ただしsinθ=Sqrt(1/N)
            var quantumSuccessProbability = Math.Pow(Math.Sin((2.0 * (double)nIterations + 1.0) * Math.Asin(Math.Sqrt(nMarkedElements) / Math.Sqrt(databaseSize))), 2.0);
            var repeats = 10;
            var successCount = 0;

            Console.Write(
                    $@"

  Quantum search for marked element in database.
  データベースのサイズ: {databaseSize}
  古典アルゴリズムでの確率: {classicalSuccessProbability}
  1回当たりの問い合わせ数: {queries}
  量子アルゴリズムでの確率: {quantumSuccessProbability}

");

            foreach (var idxAttempt in Enumerable.Range(0, repeats))
            {
                var (markedQubit, databaseRegister) = ApplyGroverSearch.Run(sim, markedElements, nIterations, nDatabaseQubits).GetAwaiter().GetResult();

                successCount += markedQubit == Result.One ? 1 : 0;

                var empiricalSuccessProbability = Math.Round((double)successCount / ((double)idxAttempt + 1), 3);

                    var speedupFactor = Math.Round(empiricalSuccessProbability / classicalSuccessProbability / (double)queries, 3);

                    Console.WriteLine($"試行回数 {idxAttempt}. 成功: {markedQubit}, 確率: {empiricalSuccessProbability} 高速化比: {speedupFactor} 検出したインデックス {databaseRegister}");
            }
        }
    }
}