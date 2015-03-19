defmodule Memoize.Mixfile do
  use Mix.Project

  def project do
    [app: :defmemo,
     version: "0.1.1",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [
     mod: {DefMemo, []}
    ]
  end

  defp deps do
    []
  end

  defp description do
    """
      A memoization macro (defmemo) for elixir using a genserver backing store.
    """
  end

  defp package do
    [
     files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
     contributors: ["Adrian Lee", "(Adapted from work by Gustavo Brunoro)"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/os6sense/DefMemo"}
    ]

  end


end
