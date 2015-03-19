DefMemo
=======
A memoization macro (defmemo) for Elixir.

[![Build Status](https://travis-ci.org/os6sense/DefMemo.svg?branch=master)](https://travis-ci.org/os6sense/DefMemo)

Adapted from : (Gustavo Brunoro) https://gist.github.com/brunoro/6159378

I found Gustavo's Gist when looking at memoization and elixir and fixed it
to work with version 1.0.x. Since then I've fixed a few of the problems with
the original implementation:

- will correctly memoize the results of functions with identical signatures 
  but in different modules.

- will work with 'when' guard clauses in function definitions. (That was fun!) 

- Added lots of lovely tests.

Usage
=====

Add defmemo to your mix.exs file:

    {:defmemo, "~> 0.1.0"}

And run:
  
    mix deps.get

Before *using* a defmemo'd function start_link must be called. e.g. 

  DefMemo.start_link

or you can add :defmemo into the applications section of your mix.exs:

    [applications: [:logger, :defmemo]]

Example
=======

    defmodule FibMemo do
      import DefMemo
         
      defmemo fibs(0), do: 0
      defmemo fibs(1), do: 1
      defmemo fibs(n), do: fibs(n - 1) + fibs(n - 2)

      def fib_10 do
        fibs(10)
      end
    end

Performance
===========
More or less what you would expect:

    UNMEMOIZED VS MEMOIZED 
    ***********************
    fib (unmemoized)
    function -> {result, running time(μs)}
    ==================================
    fibs(30) -> {832040, 31089}
    fibs(30) -> {832040, 31833}

    FibMemo (memoized)
    ==================================
    fibs(30) -> {832040, 79}
    fibs(30) -> {832040, 3}
    fibs(50) -> {12586269025, 103}
    fibs(50) -> {12586269025, 3}

TODO
====
- Add test for supervisor crashing.
- Look at injecting the type of result table used.
- Better documentation.
- More tests (alwaaaays with the testing!)
- Test with some biger data (e.g. for something like web crawling)

- ~~Supervisor ~~
- ~~Redis Based ResultTable - I've been playing with this - obviously there are
  limitations on type and it's slower than gen server but there are of course
  circumstances where it could be useful but for the most part its not a good
  "fit".~~

