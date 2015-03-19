
defmodule DefMemo.ResultTable.GS.Supervisor do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [ worker(DefMemo.ResultTable.GS, []) ]
    Supervisor.start_link(children, 
                            [strategy: :one_for_one, 
                            name: DefMemo.ResultTable.GS.Supervisor])
  end
end
