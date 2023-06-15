## README

| Name：     | netID |
| ---------- | ----- |
| Yixin Cao  | yc538 |
| Yunjia Liu | yl794 |

Based on pc4, some new instructions are added: j, jal, jr, bne, blt, bex, setx. And only code in processor.v has been changed. Here are the changes:

1. We added new control signal for these seven instructions, and built them by truth table of opcode. 

2. We add new instruction type variable target. And it should be extended to unsigned 32 bits traget.
3. Changed ctrl_readRegA to r30 when bex, and changed ctrl_readRegB to r0 when bex. Changed ctrl_writeReg to r31 when jal and to r30 when setx. Changed data_writeReg to pc+1 when jal and to target when setx.
4. Changed pc instructions according to j, jr, jal, bex, and bne.

And there is no bugs and issues occurred in this project.