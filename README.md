DefMemo
=======
A simple memoization macro (defmemo) for Elixir.

[![Build Status](https://travis-ci.org/os6sense/DefMemo.svg?branch=master)](https://travis-ci.org/os6sense/DefMemo)

Adapted from : (Gustavo Brunoro) https://gist.github.com/brunoro/6159378

I found Gustavo's Gist when looking at memoization and elixir and fixed it
to work with version 1.0.x. Since then I've fixed a few of the problems with
the original implementation:

- will correctly memoize the results of functions with identical signatures 
  but in different modules.

- will work with 'when' guard clauses in function definitions.(That was fun!) 

- Respects arity

Example
=======

    defmodule FibMemo do
      import DefMemo
         
      defmemo fibs(0), do: 0
      defmemo fibs(1), do: 1
      defmemo fibs(n), do: fibs(n - 1) + fibs(n - 2)
    end

Performance
===========
More or less what you would expect:

    UNMEMOIZED VS MEMOIZED 
    ***********************
    fib (unmemoized)
    function -> {result, running time(μs)}
    ==================================
    fibs(30) -> {832040, 31364}
    fibs(30) -> {832040, 31281}

    FibMemo (memoized)
    ==================================
    fibs(30) -> {832040, 975}
    fibs(30) -> {832040, 8}
    fibs(50) -> {12586269025, 176}
    fibs(50) -> {12586269025, 7}

TODO
====
- Travis
- Better docs
- More tests (alwaaaays with the testing!)
- Redis Based ResultTable
