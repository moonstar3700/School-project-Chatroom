defmodule ChatroomGroep77.Hulp.HulpMethods do
  alias ChatroomGroep77
  def input_keyboard(question) do
    input = IO.gets("#{question}\n")
    String.slice(input, 0..-2)
  end

  def input_keyboard_without_enter(question) do
    input = IO.gets("#{question}")
    String.slice(input, 0..-2)
  end

  def show_messages_with_list(messages) do
    Enum.map(messages, fn message -> IO.inspect(elem(message, 2)) end)
    IO.puts("")
  end

  def show_messages_with_users_list(messages) do
    Enum.map(messages, fn message ->
      user = elem(message, 1)
      message = elem(message, 2)
      IO.puts("#{user}: #{message}") end)
      IO.puts("")
  end

  def show_users_with_list(users) do
    Enum.map(users, fn user ->
      username = elem(user, 0)
      application = elem(user, 1)
      IO.puts("#{username} on the distributed application #{application}") end)
      IO.puts("")
  end

  def choose_option() do
    IO.puts("Which command do you want to execute? Type 'Help' for more info about the commands!")
    choose_option_sub()
  end

  def choose_option_sub() do
    string = input_keyboard_without_enter("Action: ")
    case String.trim(String.downcase(string)) do
      "join" -> ChatroomGroep77.join()
      "create" -> ChatroomGroep77.run_setup()
      "leave" -> ChatroomGroep77.leave()
      "show all messages" -> ChatroomGroep77.show_all_messages()
      "show messages users" -> ChatroomGroep77.show_all_messages_users()
      "show users" -> ChatroomGroep77.show_all_users()
      "send message" -> ChatroomGroep77.send_message()
      "state" -> ChatroomGroep77.state()
      "exit" -> ChatroomGroep77.exit()
      "chat rooms" -> ChatroomGroep77.show_all_chat_rooms()
      "help" -> IO.puts("Type the one of the following commands:\n   Create -> You can create a chatroom.\n   Chat rooms -> You can view all available chat rooms.\n   Join -> You can join a chatroom.\n   Show all messages -> You can show all the messages of a chatroom you have joined.\n   Show messages users -> You can show the messages with the usernames of a chatroom you have joined.\n   Show users -> You can show all users of a chatroom you have joined.\n   Send message -> You can send a message to a chatroom.\n   State -> Give the state of a chat room.\n   Leave -> You leave a chat room.\n   Exit -> You exit the application.\n")
      _ -> IO.puts("Wrong command given. Type 'Help' to find which command you need.")
    end
    choose_option_sub()
  end
end
