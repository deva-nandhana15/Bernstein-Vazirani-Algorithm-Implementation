# Bernstein–Vazirani Algorithm — Case 11

University quantum computing project for **25DC2012 Quantum Computing and Cryptography**, Internal Assessment III, Karunya Institute of Technology and Sciences.

The Q# program recovers the hidden string **011**, with bits read in **q[0], q[1], q[2]** order.

## Project files

- [URK23AI1129_Case11.qs](URK23AI1129_Case11.qs): runnable modern Q# implementation, including the separate oracle.
- [Case11_Report.md](Case11_Report.md): six-section report template, circuit diagram, expected output, mathematical explanation, screenshot checklist, and references.
- [Case11_Study_Guide.md](Case11_Study_Guide.md): line-by-line code explanation, viva questions, and troubleshooting.

The report and study guide were prepared from a template. Replace remaining team and submission placeholders before submitting the assignment. References to `RegNo_Case11.qs` in the template refer to the actual source file `URK23AI1129_Case11.qs` in this repository. Include every team member's register number in the first `Message()` if working as a team.

## Run in VS Code

1. Install Microsoft's **Microsoft Quantum Development Kit** extension.
2. Open this repository folder in VS Code.
3. Open `URK23AI1129_Case11.qs` and save any register-number changes.
4. Select **Run** above `Main` to execute once.
5. Select **Histogram** above `Main`, enter **100** or more shots, and press Enter.
6. If the Histogram link is missing, open the Command Palette and select **QDK: Run file and show histogram**.

No Python host is needed for this VS Code workflow.

## Algorithm and expected results

The circuit uses three input qubits and one ancilla. Its oracle computes

```text
f(x) = s · x (mod 2) = x1 XOR x2
```

It is implemented by `CNOT(q[1], y)` followed by `CNOT(q[2], y)`. These two gates together implement **one oracle call per execution**.

The circuit applies X to the ancilla, H to all four qubits, the oracle, and then H to the three input qubits. It measures the inputs in order and resets all qubits before release.

The expected measurement message is:

```text
Measured results (q[0], q[1], q[2]): Zero, One, One
```

`Main` returns `[Zero, One, One]`. With an ideal simulator and no noise, the expected 100-shot histogram contains only the outcome **011**, with **100 counts (100%)**. Histogram label formatting can depend on the extension version.

An exact classical black-box solver needs three oracle calls for an unknown three-bit string; this quantum algorithm needs one per execution. A 100-shot experiment executes that one-query algorithm 100 times.

## Validation

The implementation was checked against Microsoft Q# documentation, and an independent four-qubit state-vector calculation verified the ideal probability of 1 for 011. This repository does not include captured VS Code execution results. Run the program and collect the assignment screenshots using the checklist in the report.

## References

- [Microsoft: Introduction to Q#](https://learn.microsoft.com/en-us/azure/quantum/qsharp-overview)
- [Microsoft: MResetZ](https://learn.microsoft.com/en-us/qsharp/api/qsharp-lang/std.measurement/mresetz)
- [Microsoft: VS Code histogram instructions](https://learn.microsoft.com/en-us/azure/quantum/tutorial-qdk-quantum-random-number-generator)
- [IBM Quantum Learning: quantum query algorithms and the Bernstein–Vazirani problem](https://quantum.cloud.ibm.com/learning/en/courses/fundamentals-of-quantum-algorithms/quantum-query-algorithms/deutsch-jozsa-algorithm)
