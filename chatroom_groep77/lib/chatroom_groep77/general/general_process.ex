defmodule ChatroomGroep77.General.GeneralProcess do
  use GenServer
  @me __MODULE__

  @enforce_keys [:chat_room]
  defstruct users: [], messages: [], chat_room: nil

  def start_link(nil) do
    {:error, {:no_arguments_given, :room_name}}
  end

  def start_link(room_name) do
     GenServer.start_link(@me, room_name, name: via_tuple(room_name))
  end

  def send_message(room_name, message) do
    chat_room_exists = check_chatroom_exist(room_name)
    case chat_room_exists do
      true -> GenServer.call(via_tuple(room_name), {:send_message, self(), Node.self(), message})
      false -> {:error, :chat_room_not_exist}
    end
  end

  def show_all_messages(room_name) do
    chat_room_exists = check_chatroom_exist(room_name)
    case chat_room_exists do
      true ->GenServer.call(via_tuple(room_name), {:show_all_messages, self(), Node.self()})
      false -> {:error, :chat_room_not_exist}
    end
  end

  def show_all_messages_users(room_name) do
    chat_room_exists = check_chatroom_exist(room_name)
    case chat_room_exists do
      true ->GenServer.call(via_tuple(room_name), {:show_all_messages_users, self(), Node.self()})
      false -> {:error, :chat_room_not_exist}
    end
  end

  def show_all_users(room_name) do
    chat_room_exists = check_chatroom_exist(room_name)
    case chat_room_exists do
      true -> GenServer.call(via_tuple(room_name), {:show_all_users, self(), Node.self()})
      false -> {:error, :chat_room_not_exist}
    end
  end

  def join(room_name, username) do
    chat_room_exists = check_chatroom_exist(room_name)
    case chat_room_exists do
      true -> GenServer.call(via_tuple(room_name), {:join, self(), Node.self(), username})
      false -> {:error, :chat_room_not_exist}
    end
  end

  def leave(room_name) do
    chat_room_exists = check_chatroom_exist(room_name)
    case chat_room_exists do
      true -> GenServer.call(via_tuple(room_name), {:leave, self(), Node.self()})
      false -> {:error, :chat_room_not_exist}
    end
  end

  def show_all_chat_rooms() do
    chat_rooms = :global.registered_names()
    case chat_rooms do
      [] -> IO.puts("There are no chat_rooms..")
      _ -> for chat_room <- chat_rooms do
        IO.inspect(elem(chat_room,1))
      end
    end
    {:ok, :chat_room}
  end
  def get_state(room_name) do
    chat_room_exists = check_chatroom_exist(room_name)
    case chat_room_exists do
      true -> GenServer.call(via_tuple(room_name), {:get_state, self(), Node.self()})
      false -> {:error, :chat_room_not_exist}
    end
  end

  @impl true
  @spec init(any) :: {:ok, %ChatroomGroep77.General.GeneralProcess{chat_room: any, messages: [], users: []}}
  def init(room_name) do
    {:ok, %@me{chat_room: room_name}}
  end

  @impl true
  def handle_call({:leave, pid, node}, _, %@me{users: usrs} = state) do
    user = get_username_with_pid_node(pid, node, usrs)
    username = elem(user, 0)
    with  {:user_joined?, joined_user} when not is_nil(joined_user) <- {:user_joined?, user} do
      new_state = %{state | users: List.delete(state.users, {username, node, pid})}
      {:reply, {:ok, :leave}, new_state}
    else
      {:user_joined?, _} -> {:reply, {:error, :username_not_joined}, state}
    end
  end

  @impl true
  def handle_call({:join, pid, node, username}, _, %@me{users: usrs} = state) do
    user = check_username_with_node_pid_joined(username, node, pid, usrs)
    with  {:user_joined?, joined_user} when is_nil(joined_user) <- {:user_joined?, user} do
      new_state = %{state | users: [{username, node, pid} | state.users]}
      {:reply, {:ok, :join}, new_state}
    else
      {:user_joined?, _} -> {:reply, {:error, :username_already_joined}, state}
    end
  end

  @impl true
  def handle_call({:send_message, pid, node, message}, _, %@me{users: usrs} = state) do
    user = get_username_with_pid_node(pid, node, usrs)
    username = elem(user, 0)
    with  {:username_joined?, joined_name} when not is_nil(joined_name) <- {:username_joined?, username} do
        new_state = %{state | messages: [create_message(username, message) | state.messages]}
        {:reply, {:ok, :send_message}, new_state}
    else
      {:username_joined?, nil} -> {:reply, {:error, :user_not_found}, state}
    end
  end

  @impl true
  def handle_call({:show_all_messages, pid, node}, _, %@me{messages: msgs, users: usrs} = state) do
    user = get_username_with_pid_node(pid, node, usrs)
    username = elem(user, 0)
    with  {:username_joined?, joined_name} when not is_nil(joined_name) <- {:username_joined?, username} do
      {:reply, {:ok, :show_all_messages, msgs}, state}
    else
      {:username_joined?, nil} -> {:reply, {:error, :user_not_found}, state}
    end
  end

  @impl true
  def handle_call({:show_all_messages_users, pid, node}, _, %@me{messages: msgs, users: usrs} = state) do
    user = get_username_with_pid_node(pid, node, usrs)
    username = elem(user, 0)
    with  {:username_joined?, joined_name} when not is_nil(joined_name) <- {:username_joined?, username} do
      {:reply, {:ok, :show_all_messages_users, msgs}, state}
    else
      {:username_joined?, nil} -> {:reply, {:error, :user_not_found}, state}
    end
  end

  @impl true
  def handle_call({:show_all_users, pid, node}, _, %@me{users: usrs} = state) do
    user = get_username_with_pid_node(pid, node, usrs)
    username = elem(user, 0)
    with  {:username_joined?, joined_name} when not is_nil(joined_name) <- {:username_joined?, username} do
      {:reply, {:ok, :show_all_users, usrs}, state}
    else
      {:username_joined?, nil} -> {:reply, {:error, :user_not_found}, state}
    end
  end

  @impl true
  def handle_call({:get_state, pid, node}, _, %@me{users: usrs} = state) do
    user = get_username_with_pid_node(pid, node, usrs)
    username = elem(user, 0)
    with  {:username_joined?, joined_name} when not is_nil(joined_name) <- {:username_joined?, username} do
      {:reply, {:ok, :state, state}, state}
    else
      {:username_joined?, nil} -> {:reply, {:error, :user_not_found}, state}
    end
  end

  defp via_tuple(room_name) do
    {:via, :global, {:chat_room, room_name}}
  end

  defp check_username_with_node_pid_joined(username, node, pid, usrs) do
    Enum.find(usrs, fn {username_in_state, node_in_state, pid_in_state} -> username_in_state == username and node_in_state == node and pid_in_state == pid end)
  end

  defp get_username_with_pid_node(pid, node, usrs) do
    Enum.find(usrs, {nil} ,fn {_, node_in_state, pid_in_state} -> node_in_state == node and pid_in_state == pid end)
  end

  defp check_chatroom_exist(room_name) do
    chat_rooms_list = :global.registered_names()
    Enum.any?(chat_rooms_list, fn chat_room -> chat_room == {:chat_room,  room_name} end)
  end

  defp create_message(sender, message) do
    timestamp = DateTime.utc_now()
    {timestamp, sender, message}
  end
end
