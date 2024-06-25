defmodule ChatroomGroep77 do

  alias ChatroomGroep77.General.GeneralProcess
  alias ChatroomGroep77.Supervisor.DynamicSupervisor
  alias ChatroomGroep77.Hulp.HulpMethods

  @spec run_setup :: any
  def run_setup() do
    chat_room = HulpMethods.input_keyboard("What is the chat room called?")
    general_error_check(DynamicSupervisor.start_chatroom(chat_room))
  end

  def join() do
    chat_room = HulpMethods.input_keyboard("What chatroom do you want to join?")
    naam = HulpMethods.input_keyboard("What is your name?")
    general_error_check(GeneralProcess.join(chat_room, naam))
  end

  def leave() do
    chat_room = HulpMethods.input_keyboard("What chatroom do you want to leave?")
    general_error_check(GeneralProcess.leave(chat_room))
  end

  def send_message() do
      chat_room = HulpMethods.input_keyboard("In what chat room do you want to send a message?")
      message = HulpMethods.input_keyboard("What do you want to send?")
      general_error_check(GeneralProcess.send_message(chat_room, message))
  end

  def state() do
    chat_room = HulpMethods.input_keyboard("Which chat room state do you want to access?")
    general_error_check(GeneralProcess.get_state(chat_room))
  end

  def show_all_messages() do
    chat_room = HulpMethods.input_keyboard("Which chat room messages do you want to read?")
    general_error_check(GeneralProcess.show_all_messages(chat_room))
  end

  def show_all_messages_users() do
    chat_room = HulpMethods.input_keyboard("Which chat room messages-users do you want to read?")
    general_error_check(GeneralProcess.show_all_messages_users(chat_room))
  end

  def show_all_users() do
    chat_room = HulpMethods.input_keyboard("Which chat room do you want to know the users?")
    general_error_check(GeneralProcess.show_all_users(chat_room))
  end

  def show_all_chat_rooms() do
    general_error_check(GeneralProcess.show_all_chat_rooms())
  end

  def exit() do
    IO.puts("You have shutdown the application.")
    Process.sleep(:infinity);
  end

  defp general_error_check(function) do
    case function do
      {:ok, :show_all_messages, msgs} -> HulpMethods.show_messages_with_list(msgs)
      {:ok, :show_all_users, usrs} -> HulpMethods.show_users_with_list(usrs)
      {:ok, :show_all_messages_users, msgs} -> HulpMethods.show_messages_with_users_list(msgs)
      {:ok, :create} -> IO.puts("You have created a chat room!\n")
      {:ok, :join} -> IO.puts("You have joined a chat room!\n")
      {:ok, :leave} -> IO.puts("You have left a chat room!\n")
      {:ok, :send_message} ->IO.puts("You have send a message in a chat room!\n")
      {:ok, :state, state} -> IO.inspect(state)
      {:ok, :chat_room} -> IO.puts("Search finished.\n")
      {:error, :chat_room_not_exist} -> IO.puts("This chat room doesn't exist..\n")
      {:error, :username_already_joined} -> IO.puts("The user has already joined the chat room!\n")
      {:error, :username_not_joined} -> IO.puts("This user hasn't joined this chat room, so he can't leave!\n")
      {:error, :user_not_found} -> IO.puts("This user hasn't joined this chat room.. Please use the join command.\n")
      {:error, {:already_started, _}} -> IO.puts("The chatroom is already started/made!")
      {:ok, _} -> IO.puts("The chatroom is created.\n")
    end
  end
end
