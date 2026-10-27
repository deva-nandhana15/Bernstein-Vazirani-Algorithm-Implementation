# Case 11 — Code explanation, viva, and troubleshooting

Read Case11_Report.md for the six-section submission report and full mathematics. RegNo_Case11.qs is the runnable source. Rename RegNo to the required real register number and replace the first Message with ALL team register numbers.

## Line-by-line explanation

Line numbers refer to the supplied 57-line Q# file. Lines starting with // are explanatory comments; blank lines only improve readability.

| Line | Statement | Meaning |
|---|---|---|
| 2 | import Std.Intrinsic.*; | Makes gates, Message, and Reset available. This namespace is also automatically available, but the explicit import documents the dependency. |
| 4 | import Std.Measurement.*; | Makes MResetZ available. |
| 7 | operation Case11Oracle(q : Qubit[], y : Qubit) : Unit { | Defines the separate oracle. q is a qubit array; y is one qubit; Unit means it returns no classical data. The qubits are changed by the operation. |
| 10 | CNOT(q[1], y); | Uses q[1] as control and y as target, adding x1 to y modulo 2. |
| 12 | CNOT(q[2], y); | Adds x2 to y modulo 2. Together the gates implement y -> y XOR x1 XOR x2. |
| 13 | } | Ends the oracle. |
| 16 | @EntryPoint() | Identifies the operation to execute. |
| 17 | operation Main() : Result[] { | Defines Main with no parameters and an array of measurement results as its return type. |
| 19 | Message(...); | Prints every team register number before any other program message. Replace the placeholders. |
| 22 | use q = Qubit[3]; | Allocates q[0], q[1], q[2], initially all |0>. |
| 24 | use y = Qubit(); | Allocates the ancilla, initially |0>. |
| 27 | X(y); | Changes the ancilla to |1>. |
| 30 | H(q[0]); | Prepares q[0] in |+>. |
| 31 | H(q[1]); | Prepares q[1] in |+>. |
| 32 | H(q[2]); | Prepares q[2] in |+>. The input now includes all eight strings equally. |
| 34 | H(y); | Changes |1> into |->, which gains a minus sign under X. |
| 37 | Case11Oracle(q, y); | Calls the complete oracle once. Its phase pattern changes the inputs to |+>|->|->. |
| 40 | H(q[0]); | Converts |+> into |0>. |
| 41 | H(q[1]); | Converts |-> into |1>. |
| 42 | H(q[2]); | Converts |-> into |1>. |
| 45 | let r0 = MResetZ(q[0]); | Stores Zero and resets q[0] to |0>. let creates an immutable classical value. |
| 46 | let r1 = MResetZ(q[1]); | Stores One and resets q[1] to |0>. |
| 47 | let r2 = MResetZ(q[2]); | Stores One and resets q[2] to |0>. |
| 50 | Reset(y); | Resets the ancilla from |-> to |0>. Its internal measurement is not part of the returned result. |
| 53 | Message($"..."); | Prints the actual saved results. The dollar sign enables interpolation; {r0}, {r1}, {r2} insert variable values. |
| 56 | return [r0, r1, r2]; | Returns results in q[0], q[1], q[2] order. Resetting qubits does not erase these stored classical values. |
| 57 | } | Ends Main. All qubits are now safe to release. |

Microsoft's current introduction documents import syntax and use allocation:
https://learn.microsoft.com/en-us/azure/quantum/qsharp-overview

MResetZ reference:
https://learn.microsoft.com/en-us/qsharp/api/qsharp-lang/std.measurement/mresetz

## Ten viva questions and short answers

1. **What does Bernstein–Vazirani find?**  
   An unknown bit string s from an oracle for f(x) = s dot x modulo 2.

2. **What is f(x) for this case?**  
   f(x) = x1 XOR x2. The x0 bit has coefficient zero.

3. **Why are there four qubits?**  
   Three hold the input and recovered string. One ancilla implements the reversible function oracle and phase kickback.

4. **Why apply X then H to the ancilla?**  
   X makes |1>; H makes |->. Since X|-> = -|->, the oracle can attach the phase (-1)^f(x).

5. **Why is there no CNOT from q[0]?**  
   s0 = 0, so f does not depend on x0. Its final value is recovered as zero.

6. **What does the first H layer do?**  
   It creates an equal superposition of all eight inputs and prepares the ancilla in |->.

7. **What do the final H gates do?**  
   They convert the phase pattern into |011>. Interference cancels amplitudes for every other input result.

8. **Are two CNOTs two oracle calls?**  
   No. They implement one U_f call. One execution calls Case11Oracle once. A 100-shot experiment uses 100 such calls overall.

9. **Why return Result[] and reset the qubits?**  
   The histogram needs each execution's returned sample. Reset puts allocated qubits into |0> before release. Saved Result values remain available.

10. **Why do we construct an oracle using a string we call hidden?**  
    The assignment specifies s so we can build a known test oracle. In the query model, the solver treats it as a black box. The classical lower bound assumes s is unknown.

## Troubleshooting

| Symptom | Likely cause and fix |
|---|---|
| Error around using (...) | Use modern allocation: use q = Qubit[3]; and use y = Qubit();. |
| Std namespace or import is unknown | Check that Microsoft Quantum Development Kit is enabled and current. Use a consistent modern source file with import Std.Intrinsic.*; and import Std.Measurement.*;. Avoid mixing old Microsoft.Quantum examples into this file. |
| MResetZ is unknown | Include import Std.Measurement.*; and spell MResetZ exactly. |
| No Run / Histogram link | Save the file with .qs extension, select Q# as its language mode, ensure the QDK extension is active, and enable editor CodeLens. Run “QDK: Run file and show histogram” from the Command Palette. |
| No entry point or multiple entry points | Keep one Main and one @EntryPoint() in the intended standalone program. A project containing several assignment copies may compile them together; place each standalone assignment in its own folder or fix the project source layout. |
| Histogram has no useful three-bit result | Main must return Result[] and return [r0, r1, r2];. Message text alone does not supply histogram samples. |
| Histogram contains four bits | Return only the three inputs. Do not add the ancilla result. |
| Result reads 110 | Check label interpretation and actual return order. Our required order is q[0], q[1], q[2], so return [r0, r1, r2] without reversing it. |
| Result is random | Check X(y) before H(y), all four first H gates, both oracle CNOTs in the right direction, and all three final input H gates. Also check that simulator noise is off. |
| Qubit-release/reset error | Keep MResetZ for all three inputs and Reset(y) before return. |
| Printed answer is wrong or brackets cause syntax errors | Keep ordinary double quotes around Message text, dollar sign before an interpolated string, braces around interpolation variables, semicolons, and balanced operation braces. |
| Register numbers missing from screenshots | Replace the first Message placeholders, run once, then keep the console visible beside the histogram. Do not rely on the filename alone. |
| Messages repeat during 100 shots | Each shot executes Main again. Repeated messages are expected if the extension displays them. |
| Gate-count or circuit view includes reset measurements | Reset is cleanup and may be displayed as measurement/conditional correction. It does not add a recovered-string bit because it is not returned. |

Local VS Code simulation and noise settings:
https://learn.microsoft.com/en-us/azure/quantum/qdk-simulator-vscode

Histogram instructions:
https://learn.microsoft.com/en-us/azure/quantum/tutorial-qdk-quantum-random-number-generator

## Verification status

The Q# source was checked against current Microsoft documentation. An independent four-qubit state-vector calculation applied X(y), all four first H gates, CNOT(q[1],y), CNOT(q[2],y), and the three final H gates. It found probability 0.9999999999999989 for 011 (floating-point rounding of 1) and zero for every other input string.

No Q# runtime was available in the execution environment, so this was not a Q# compilation or an actual VS Code 100-shot run. Collect real screenshots after running the supplied file in VS Code.

