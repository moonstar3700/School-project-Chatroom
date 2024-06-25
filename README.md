# ChatroomGroep77

## How to start the chat room!

Execute following commands in the chatroom_groep77 folder.

Terminal

``mix deps_get()``


Use for example the names ping and pong.

Terminal

``iex --sname <NAME> -S mix``

Second Terminal

``iex --sname <SECOND_NAME> -S mix``

Type 'Help' if you want to see all the commands.

Here is a summary of all the commands and what they can do:

* Join                ->  This command will let you join a chat room with a certain name.
* Create              ->  This command will create a chat room with a given name.
* Leave               ->  This command will let a user leave a certain chat room. (*)
* Show all messages   -> This command shows all the messages of a certain chat room. (*)
* Show messages users -> This command shows all the messages and the users who send it of a certain chat room. (*)
* Show users          -> This command shows all the users who have joined a certain chat room. (*)
* Send message        -> This command will let you send a message in a certain chat room. (*)
* State               -> This command will let you show the state of a certain chat room. (*)
* Chat rooms          -> This command will let you show all the chat rooms that are available.
* Exit                -> This command will shut down the node.
* Help                -> This will show you all the commands.

Some commands require you to join a chatroom before you can execute them. These commands are marked with (*).

## Problems

1. Connecting nodes -> eaddrinuse

Connecting nodes with gossip does not always work on all pc's. There can be problems with the ports. A temporary solution is to connect the nodes with localedmp instead of gossip. This is only available if the nodes are located in the same local network. If you want to enable this option you need to go to the file "lib/chatroom_groep77/application.ex" and comment the next following line (15) -> "strategy: Cluster.Strategy.Gossip" and uncomment the line (14) "strategy: Elixir.Cluster.Strategy.LocalEpmd".

1. Observer.start

There is no possibility to start the observer because the node will infinitly execute the "HulpMethods.choose_option()". If you want to start the observer you need to comment this line (30) in the application.ex. Now a normal iex shell will spawn when executing the terminal command above. You can manually start the application by typing "ChatroomGroep77.Hulp.HulpMethods.choose_option()" or start an observer with ":observer.start"
