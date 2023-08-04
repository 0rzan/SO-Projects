# Operating Systems Assignments
This repository contains my solutions to assignments from the "Operating Systems" course.

## Overview

The assignments involved tasks ranging from working with assembly language to modifying the MINIX operating system's source code.

## Assignment Descriptions

Here's a brief description of each assignment:

1. **Inverting Permutations in Assembly Language**: In this assignment, I implemented a function in assembly language to calculate the inverse of a permutation in-place. The function is callable from C and takes a non-empty array of integers and its size as arguments. The primary goal was to verify whether the given array represents a valid permutation within the range of `[0, n - 1]`.

2. **Distributed Stack Machine Simulator**: This assignment required creating a simulator for a distributed stack machine using assembly language. The simulator comprises `N` cores, each executing computations specified by ASCIIZ strings. Operations included addition, multiplication, negation, stack manipulation, and synchronization between cores. The final result was the value at the top of the stack after the computations were executed.

3. **Money Transfers in MINIX**: The objective of this assignment was to implement money transfers between processes in the MINIX operating system. Each process had an initial balance and could perform mutual money transfers, subject to certain conditions. The primary challenge was ensuring successful transfers while preventing money laundering and maintaining valid account balances.

Please note that the assignment descriptions provide only a brief overview, and for further details, you can refer to the corresponding files in the repository.
