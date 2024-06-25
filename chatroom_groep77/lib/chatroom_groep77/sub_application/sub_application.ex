defmodule ChatroomGroep77.SubApplication.SubApplication do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {ChatroomGroep77.Supervisor.DynamicSupervisor, []}
    ]
    Supervisor.init(children, strategy: :rest_for_one)
  end
end
