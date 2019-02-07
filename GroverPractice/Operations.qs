namespace GroverPractice
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Canon;

    /// # Input
    /// ## nIterations
    /// 確率振幅増幅の繰り返し数
    /// ## nDatabaseQubits
    /// データベースに使う量子ビット数
    ///
    /// # Output
    /// 出力して得られる、"マークされた"量子ビットとデータベースの量子ビット列の測定結果
    operation ApplyQuantumSearch (nIterations : Int, nDatabaseQubits : Int) : (Result, Result[]) {
        
        // 出力結果用の変数
        mutable resultSuccess = Zero;
        mutable resultElement = new Result[nDatabaseQubits];
        
        // TODO データベースに使うビット数+1の量子ビットを確保
        //using (qubits = Qubit[nDatabaseQubits + 1]) {
        using (qubits = Qubit[0]) {
            // indexが0のものを"マークされた量子ビット"として使う
            let markedQubitIndex = 0;
            
            // Groverのアルゴリズムを実行
            QuantumSearch(nIterations, markedQubitIndex, qubits);
            // これはAmpAmpByOracleを使う場合のコード。
            //(QuantumSearchWithCanon(nIterations, markedQubitIndex))(qubits);

            // TODO データベースの状態を測定して、Result[] の配列を取得する
            // mutable resultAllBits = MultiM(qubits);
            // set resultSuccess = resultAllBits[markedQubitIndex];
            // set resultElement = Exclude([markedQubitIndex], resultAllBits);
            
            // TODO すべての量子ビットの状態を0にする
            //ResetAll(qubits);
        }
        
        // 測定結果を返す
        return (resultSuccess, resultElement);
    }


    /// # Summary
    /// Groverのアルゴリズムを実行するoperation。
    ///
    /// # Input
    /// ## nIterations
    /// 確率振幅増幅の繰り返し数
    /// ## idxMarkedQubit
    /// ”マークされた”量子ビットとして使う量子ビットのindex
    /// ## qubits
    /// ”マークされた”量子ビットとデータベースとして使う量子ビットの配列。|0...0>であるものとする。
    operation QuantumSearch (nIterations : Int, idxMarkedQubit : Int, qubits : Qubit[]) : Unit {
        // TODO  Qubit配列 qubits で、IndexがidxMarkedQubitのものをmarkedQubitとする
        // 残りのqubitsをdatabaseRegisterとする。
        // idxMarkedQubitは0に固定してあるので、0しかこないものとして処理してもよいです。
        let markedQubit = qubits[0]; //TODO qubits[0]を書き直してください
        // HINT Exclude を使います
        let databaseRegister = qubits;　//TODO qubitsを書き直してください
        // let markedQubit = qubits[idxMarkedQubit];
        // let databaseRegister = Exclude([idxMarkedQubit], qubits);

        //初期状態を生成する
        StatePreparationOracle(markedQubit, databaseRegister);
        
        // TODO 指定された回数だけ確率振幅増幅を行う
        // ReflectMarked と ReflectStart を使います
        for (idx in 0 .. nIterations - 1) {
            // ReflectMarked(markedQubit);
            // ReflectStart(markedQubit, databaseRegister);
        }
    }
    
    /// # Summary
    /// 以下の初期状態を生成する
    /// |1〉|N-1〉/√N + |0〉(|0〉+|1〉+...+|N-2〉)/√N.
    ///
    /// # Input
    /// ## markedQubit
    /// データベースが"マーク"されたかどうか示すQubit
    /// ## databaseRegister
    /// データベース用のQubit列
    operation StatePreparationOracle (markedQubit : Qubit, databaseRegister : Qubit[]) : Unit {
        //関数全体の逆操作をコンパイラーに生成するために、adjoint invert キーワードを追加しています。
        //その場合関数本体は body (...){}の中に記述します
        body (...) {
            //TODO UniformSuperpositionOracle と DatabaseOracle を使います
            // UniformSuperpositionOracle(databaseRegister);
            // DatabaseOracle(markedQubit, databaseRegister);
        }
        
        adjoint invert;
    }

    /// # Summary
    /// |0..0>で初期化されてる量子ビット列を、すべての状態が均等に重ね合わされた状態にします
    ///
    /// # Input
    /// ## databaseRegister
    /// |0..0>で初期化されてる量子ビット列
    operation UniformSuperpositionOracle (databaseRegister : Qubit[]) : Unit {
        
        body (...) {
            //TODO for文を使って書けますが、１つのoperationで記述することもできます

            // ApplyToEachCA(H, databaseRegister);
            // もしくは
            // let nQubits = Length(databaseRegister);
            
            // for (idxQubit in 0 .. nQubits - 1) {
            //     H(databaseRegister[idxQubit]);
            // }
        }
        
        adjoint invert;
    }

    /// # Summary
    /// データベースオラクルを実装します。
    /// 今回は実装の簡単のために、|1..1>を探索すると固定されたアルゴリズムになっています。
    /// 即ち、データベースの状態が|1..1>のときに、markedQubitを反転させる実装となります。
    ///
    /// # Input
    /// ## markedQubit
    /// databaseRegisterが所定の状態の場合に反転されるQubit
    /// ## databaseRegister
    /// データベースの量子ビット列
    operation DatabaseOracle (markedQubit : Qubit, databaseRegister : Qubit[]) : Unit {
        
        body (...) {
            //TODO Q#ではControlled functorをoperationに修飾することで、
            //第一引数が|1..1>のときだけoperationを適用することができます。
            // Controlled X(databaseRegister, markedQubit);
        }
        
        adjoint invert;
        controlled distribute;
        controlled adjoint distribute;
    }
    
    /// # Summary
    /// マークされた量子ビットを|1>まわりに反転します。
    ///
    /// # Input
    /// ## markedQubit
    /// データベースがマークされたかどうかを示すQubit
    operation ReflectMarked (markedQubit : Qubit) : Unit {
        
        // TODO R1 operation
        // https://docs.microsoft.com/en-us/qsharp/api/prelude/microsoft.quantum.primitive.r1?view=qsharp-preview
        //R1(PI(), markedQubit);
    }
    
    
    /// # Summary
    /// |00...0〉 まわりに反転します。
    ///
    /// # Input
    /// ## databaseRegister
    /// データベースの量子ビット列
    operation ReflectZero (databaseRegister : Qubit[]) : Unit {
        // TODO 
        // let nQubits = Length(databaseRegister);
        
        // for (idxQubit in 0 .. nQubits - 1) {
        //     X(databaseRegister[idxQubit]);
        // }
        
        // Controlled Z(databaseRegister[1 .. nQubits - 1], databaseRegister[0]);
        
        // for (idxQubit in 0 .. nQubits - 1) {
        //     X(databaseRegister[idxQubit]);
        // }
    }
    
    
    /// # Summary
    /// 初期状態周りに反転します。
    ///
    /// # Input
    /// ## markedQubit
    /// データベースがマークされたかどうかを示すQubit
    /// ## databaseRegister
    /// データベースの量子ビット列
    operation ReflectStart (markedQubit : Qubit, databaseRegister : Qubit[]) : Unit {
        // TODO StatePreparationOracle と ReflectZero を使います
        // HINT operationの逆の操作はAdjointで修飾することで適用できます
        // Adjoint StatePreparationOracle(markedQubit, databaseRegister);
        // ReflectZero([markedQubit] + databaseRegister);
        // StatePreparationOracle(markedQubit, databaseRegister);
    }

    /// ここから先はAmpAmpByOracle を使う場合のコード

    function QuantumSearchWithCanon(nIterations : Int, idxMarkedQubit : Int) : (Qubit[] => Unit : Adjoint, Controlled) {
        
        return AmpAmpByOracle(nIterations, GroverStatePrepOracle(), idxMarkedQubit);
    }

    /// Summary
    /// AmpAmpByOracle operationはStateOracle型の引数を取るので、
    /// 初期状態を生成するStateOracleを返すoperationを用意する。
    /// StateOracleは (Int,Qubit[])を引数にとるため、部分適用を使っている
    /// IntはAmpAmpByOracleの第3引数より、Qubit[]はAmpAmpByOracleの返り値のoperationの引数から取得する（はず)
    function GroverStatePrepOracle () : StateOracle {        
        return StateOracle(GroverStatePrepOracleImpl(_, _));
    }

    /// Summary
    /// 初期状態を生成する。
    ///
    /// # Input
    /// ## idxMarkedQubit
    /// データベースがマークされたかどうかを示すQubitのインデックス
    /// ## startQubits
    /// データベースの量子ビット列とマークされたQubitの2つをあわせたQubit配列。
    /// startQubits[idxMarkedQubit]がマークされたQubitで
    /// それ以外のQubit列がデータベース用
    operation GroverStatePrepOracleImpl (idxMarkedQubit : Int, startQubits : Qubit[]) : Unit {
        
        body (...) {
            // TODO 
            // let flagQubit = startQubits[idxMarkedQubit];
            // let databaseRegister = Exclude([idxMarkedQubit], startQubits);
            
            // TODO すべての状態が均等に現れる状態を生成する
            //ApplyToEachCA(H, databaseRegister);
            
            // TODO オラクル関数を適用する
            //DatabaseOracle(flagQubit, databaseRegister);
        }
        
        adjoint invert;
        controlled distribute;
        controlled adjoint distribute;
    }
}
