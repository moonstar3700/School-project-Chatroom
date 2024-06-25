defmodule ChatroomGroep77.Supervisor.DynamicSupervisor do
  use DynamicSupervisor


  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end


  @impl true
  @spec init(any) ::
          {:ok,
           %{
             extra_arguments: list,
             intensity: non_neg_integer,
             max_children: :infinity | non_neg_integer,
             period: pos_integer,
             strategy: :one_for_one
           }}


    def init(_init_arg) do
      DynamicSupervisor.init(strategy: :one_for_one)
    end


    def start_chatroom(room_name) do
      DynamicSupervisor.start_child(__MODULE__, {ChatroomGroep77.General.GeneralProcess, room_name})
    end
end
