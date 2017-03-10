defmodule PresenceChat.RoomChannel do
  use PresenceChat.Web, :channel

  alias PresenceChat.Presence

  def join("room:lobby", _, socket) do
    IO.puts("lobby")
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    pres = %{online_at: :os.system_time(:milli_seconds)}
    Presence.track(socket, socket.assigns.user, pres)
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  def handle_in("message:new", message, socket) do
    body =
      %{user: socket.assigns.user,
        body: message,
        timestamp: :os.system_time(:milli_seconds)}
    broadcast!(socket, "message:new", body) 
    {:noreply, socket}
  end
end
