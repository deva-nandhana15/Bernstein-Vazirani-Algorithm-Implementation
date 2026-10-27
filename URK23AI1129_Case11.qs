// Import the gates, Message, and Reset operations.
import Std.Intrinsic.*;
// Import the operation that measures and resets a qubit.
import Std.Measurement.*;

// Implement f(x) = x1 XOR x2 for s = 011.
operation Case11Oracle(q : Qubit[], y : Qubit) : Unit {
    // s0 = 0, so q[0] has no CNOT to the ancilla.
    // s1 = 1: XOR x1 into y.
    CNOT(q[1], y);
    // s2 = 1: XOR x2 into y.
    CNOT(q[2], y);
}

// Mark the operation that VS Code runs.
@EntryPoint()
operation Main() : Result[] {
    // FIRST program message: replace this list with ALL team register numbers.
    Message("Team register numbers: URK23AI1129");

    // Allocate three input qubits, initially |000>.
    use q = Qubit[3];
    // Allocate one ancilla, initially |0>.
    use y = Qubit();

    // Prepare the ancilla in |1> before the first Hadamard layer.
    X(y);

    // First Hadamard layer: input becomes |+>|+>|+>.
    H(q[0]);
    H(q[1]);
    H(q[2]);
    // The ancilla becomes |-> = (|0> - |1>)/sqrt(2).
    H(y);

    // Make ONE oracle call, implemented using TWO CNOT gates.
    Case11Oracle(q, y);

    // Final Hadamard layer: convert the input phases into the bits 011.
    H(q[0]);
    H(q[1]);
    H(q[2]);

    // Measure in the required order and reset each input to |0>.
    let r0 = MResetZ(q[0]);
    let r1 = MResetZ(q[1]);
    let r2 = MResetZ(q[2]);

    // Reset the ancilla before releasing it; its result is not returned.
    Reset(y);

    // Print the actual measured values, rather than a hard-coded answer.
    Message($"Measured results (q[0], q[1], q[2]): {r0}, {r1}, {r2}");

    // Return one three-result sample for the histogram on each shot.
    return [r0, r1, r2];
}
