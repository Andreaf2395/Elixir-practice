defmodule HelloWeb.RoomChannel do
  use Phoenix.Channel
  alias HelloWeb.Presence


  def join("room:lobby", _params, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:second))
    })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  # def join("room:lobby", _message, socket) do
  #   {:ok, socket}
  # end
  # def join("room:" <> _private_room_id, _params, _socket) do
  #   {:error, %{reason: "unauthorized"}}
  # end

  # def handle_in("new_msg", %{"body" => body}, socket) do
  #   broadcast!(socket, "new_msg", %{body: body})
  #   {:noreply, socket}
  # end
end
