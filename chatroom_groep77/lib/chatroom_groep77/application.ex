defmodule ChatroomGroep77.Application do
  alias ChatroomGroep77.Hulp.HulpMethods

  use Application

  @impl true
  def start(_type, _args) do
    topologies = [
      chatroom_groep77: [
        # Indien problemen bij het opstarten of met gossip deze strategies wisselen
        #strategy: Elixir.Cluster.Strategy.LocalEpmd]]
        strategy: Cluster.Strategy.Gossip
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: ChatroomGroep77.ClusterSupervisor]]},
      ChatroomGroep77.SubApplication.SubApplication
    ]

    opts = [strategy: :one_for_one, name: ChatroomGroep77.Supervisor]
    Supervisor.start_link(children, opts)
    # Disable the following options to access the normal iex shell.
    HulpMethods.choose_option()
  end
end
