# Internal Assessment III — Case 11

## 1. Cover page

**Karunya Institute of Technology and Sciences**  
**Course:** 25DC2012 Quantum Computing and Cryptography  
**Assessment:** Internal Assessment III  
**Case number:** 11  
**Algorithm:** Bernstein–Vazirani Algorithm  
**Hidden string:** s = 011, in q[0], q[1], q[2] order

| Team member name | Register number |
|---|---|
| <Devanandhana P S> | <URK23AI1129> |

**Department / class:** <DEPARTMENT_AND_CLASS>  
**Submitted to:** <FACULTY_NAME>  
**Submission date:** <DATE>  
**Source filename:** <REG_NO>_Case11.qs

Replace all placeholders before submission.

## 2. Aim and circuit

### Aim

To implement the Bernstein–Vazirani algorithm in modern Q#, recover the hidden three-bit string 011 using one oracle call per execution, and verify the result with at least 100 simulator shots.

We use three input qubits and one ancilla. Throughout this report, |x0 x1 x2> follows q[0], q[1], q[2] order. For s = 011,

f(x) = (0*x0 + 1*x1 + 1*x2) mod 2 = x1 XOR x2.

The reversible oracle acts as U_f|x>|y> = |x>|y XOR f(x)>.

### Circuit

```text
                         oracle U_f
                       +-------------+
q[0] |0> ----[H]--------|-------------|----[H]----[MZ]----[reset]
                       |             |
q[1] |0> ----[H]--------|--o----------|----[H]----[MZ]----[reset]
                       |  |          |
q[2] |0> ----[H]--------|--|-----o----|----[H]----[MZ]----[reset]
                       |  |     |    |
y    |0> --[X]--[H]-----|-(+)---(+)---|------------------[reset]
                       +-------------+
```

The letter o denotes a control; (+) denotes a CNOT target. Each vertical connection joins a control to its target on y. The horizontal box boundaries only group the oracle; they are not gates. MZ followed by reset is implemented by MResetZ. The ancilla reset is cleanup and is not a returned algorithm result.

To redraw:
1. Draw four wires labelled q[0], q[1], q[2], and y; initialize all to |0>.
2. Put X on y.
3. In the next layer, put H on all four wires.
4. Add a CNOT with control q[1] and target y.
5. Add a later CNOT with control q[2] and target y. Group these two gates as U_f.
6. Put H on each input wire, with no final algorithm H on y.
7. Measure q[0], q[1], and q[2] in that order.
8. Mark input reset after measurement and ancilla reset before release.

The input H gates commute with X(y), so their drawing before H(y) still represents the code's X(y), then first-H-layer sequence.

## 3. Code

Save as <REG_NO>_Case11.qs. Replace the first Message string with every team member's actual register number.

```qsharp
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
    Message("Team register numbers: <REG_NO_1>, <REG_NO_2>, <ADD_REMAINING_REG_NOS>");

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
```

## 4. Output

### Expected output from one execution

Before replacing the placeholders, the program's two Message lines are:

```text
Team register numbers: <REG_NO_1>, <REG_NO_2>, <ADD_REMAINING_REG_NOS>
Measured results (q[0], q[1], q[2]): Zero, One, One
```

The returned value is [Zero, One, One], meaning 011 in the specified order. VS Code may add execution banners and format the returned array separately. The first line controlled by the program is the team-register Message; the program cannot control extension-generated banners.

With the ideal simulator and no noise, all N shots return the same result. For 100 shots, the histogram has a single nonzero outcome: 011, count 100, percentage 100%. Other outcomes have count 0. The UI may label the result as an array such as [Zero, One, One] or as a bit string. Record the actual label shown in your installed version. The outcome and its order remain the same.

The two Message lines can repeat during histogram execution because each shot runs Main again; message display or suppression depends on the extension version. The histogram uses returned values, not Message text.

### Run and screenshot checklist

1. Open the .qs file in VS Code with Microsoft Quantum Development Kit enabled, save it, and resolve any reported errors.
2. Run Main once. Capture the console with all team register numbers and the measured results visible.
3. Select Histogram above Main, or run “QDK: Run file and show histogram” from the Command Palette.
4. Enter 100 or more shots.
5. Capture the histogram with its outcome and shot count visible; select its bar if needed to show the percentage.
6. Arrange the console beside or below the histogram so the actual register-number message is also visible in the histogram screenshot.
7. Capture the complete code, including the oracle and first Message. Use two readable screenshots if necessary.

Insert these real screenshots in the submitted report:
- Code screenshot(s), showing the filename, imports, oracle, Main, and register numbers.
- Console screenshot, showing register numbers and Zero, One, One.
- Histogram screenshot, showing at least 100 shots, the sole nonzero outcome, 100%, and the register-number console message.

Expected results above are predictions, not a claim that screenshots were collected. Replace this note with your actual observations after running.

## 5. Answers

### Q1 — Why is the measured result exactly s? (3 marks)

Write |-> = (|0> - |1>)/sqrt(2). The input register comes first and the ancilla comes last in every state below.

**Initial state**

|psi0> = |000>|0>.

**After X(y)**

|psi1> = |000>|1>.

**After the first H layer**

|psi2> = (1/sqrt(8)) sum over x in {0,1}^3 of |x>|->  
       = |+>|+>|+>|->.

Every input has equal amplitude.

**After the oracle**

Since X|-> = -|->, a conditional flip of the ancilla contributes a phase:

U_f |x>|-> = (-1)^(f(x)) |x>|-> = (-1)^(s dot x) |x>|->.

Therefore,

|psi3> = (1/sqrt(8)) sum_x (-1)^(s dot x) |x>|->.

For s = 011, s dot x = x1 XOR x2. Expanding in q[0], q[1], q[2] order:

|psi3> = (1/sqrt(8)) (|000> - |001> - |010> + |011>
                          + |100> - |101> - |110> + |111>) |->.

Equivalently, |psi3> = |+>|->|->|->, with the last factor being the ancilla. The phase depends on x, so it is a relative phase between input components.

**After the final H layer on the inputs**

Using H|+> = |0> and H|-> = |1>,

|psi4> = |0>|1>|1>|-> = |011>|->.

More generally, the amplitude for an input outcome z is

A(z) = (1/8) sum_x (-1)^(s dot x + x dot z)
     = (1/8) sum_x (-1)^(x dot (s XOR z)).

For z = s, all eight terms are +1, so A(s) = 1. For z != s, equal positive and negative terms cancel, so A(z) = 0.

Thus measuring the inputs returns 011 with probability 1 in the ideal circuit. The final H gates turn the hidden phase pattern into the measurable string.

### Q2 — Classical and quantum oracle calls (2 marks)

For an unknown three-bit string and a black-box oracle, a classical algorithm needs three calls to determine s exactly in the worst case:

| Query x, in x0 x1 x2 order | Oracle answer |
|---|---|
| 100 | s0 = 0 |
| 010 | s1 = 1 |
| 001 | s2 = 1 |

Each answer supplies one bit, so fewer than three binary answers cannot distinguish all eight possible strings.

The Bernstein–Vazirani circuit uses one call to U_f per execution. The two CNOTs are the internal implementation of that one call.

Running 100 shots means 100 independent executions and therefore 100 oracle calls in total. The algorithmic comparison is three classical calls versus one quantum call for one recovery of the string. Knowing s from the assignment is for constructing and checking the oracle; the query comparison assumes the solver does not already know it.

## 6. Conclusion and references

We implemented the Bernstein–Vazirani algorithm for s = 011 using four qubits.
The ancilla allowed the oracle to encode f(x) as the phase (-1)^(s dot x).
The final Hadamard layer converted this phase pattern into the input state |011>.
The ideal prediction is 011 in every shot, using one oracle call per execution.
The experiment also showed why measurement order and resetting qubits matter.

### References

1. Nielsen, M. A., and Chuang, I. L. (2010). *Quantum Computation and Quantum Information*, 10th Anniversary Edition. Cambridge University Press. Chapter 1, Section 1.4.4, “The Deutsch–Jozsa algorithm.” This is the textbook background for the shared circuit and interference method; it is not presented here as a separate BV chapter. [Author-hosted chapter and contents](https://michaelnielsen.org/qcqi/QINFO-book-nielsen-and-chuang-toc-and-chapter1-nov00.pdf).
2. Microsoft Learn. *Introduction to the Quantum Programming Language Q#*. [Documentation](https://learn.microsoft.com/en-us/azure/quantum/qsharp-overview).
3. Microsoft Learn. *MResetZ operation* and *Std.Intrinsic namespace*. [MResetZ](https://learn.microsoft.com/en-us/qsharp/api/qsharp-lang/std.measurement/mresetz), [Std.Intrinsic](https://learn.microsoft.com/en-us/qsharp/api/qsharp-lang/std.intrinsic/).
4. Microsoft Learn. *Tutorial: Create a Quantum Random Number Generator*. See the VS Code histogram instructions. [Tutorial](https://learn.microsoft.com/en-us/azure/quantum/tutorial-qdk-quantum-random-number-generator).
5. IBM Quantum Learning. *Fundamentals of Quantum Algorithms*, “Quantum query algorithms,” lesson “The Deutsch–Jozsa algorithm,” subsection “The Bernstein–Vazirani problem.” [Course lesson](https://quantum.cloud.ibm.com/learning/en/courses/fundamentals-of-quantum-algorithms/quantum-query-algorithms/deutsch-jozsa-algorithm).

Online references checked on 27 October 2026.

