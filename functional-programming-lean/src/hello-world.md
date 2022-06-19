# Hello, World!

While Lean has been designed to have a rich interactive environment in which where programmers can get quite a lot of feedback from the language without leaving the confines of their favorite text editor, it is also a language in which real programs can be written.
This means that it also has a batch-mode compiler, a build system, a package manager, and all the other tools that are necessary for writing programs.

While the [previous chapter](./getting-to-know.md) presented the basics of functional programming in Lean, this chapter explains how to start a programming project, compile it, and run the result.
Programs that run and interact with their environment (e.g. by reading input from standard input or creating files) are difficult to reconcile with the understanding of computation as the evaluation of mathematical expressions.
After a description of how to start a project, write a program that prints to the console, compile the program, and run it, this chapter also provides a way to think about functional programs that interact with the world.