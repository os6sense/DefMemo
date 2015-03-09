DefMemo
=======

A simple memoization macro (defmemo) for Elixir.

Adapted from : (Gustavo Brunoro) https://gist.github.com/brunoro/6159378

I'm still learning Elixir and have a long way to go so I'm sure that this could
be better implemented. I had come across a Gist from Gustavo Brunoro that 
looked to cover want I wanted and have quickly updated it to Elixir 1.x while 
also making sure that it doesn't memoize the results from identical signatures
but different modules.

Example
=======

    defmodule FibMemo do
      import Memoize
         
      defmemo fibs(0), do: 0
      defmemo fibs(1), do: 1
      defmemo fibs(n), do: fibs(n - 1) + fibs(n - 2)
    end

