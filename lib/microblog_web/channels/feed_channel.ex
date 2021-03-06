defmodule MicroblogWeb.FeedChannel do
  use MicroblogWeb, :channel

  intercept(["new_post"])

  def join("feed:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (feed:lobby).
  def handle_in("new_post", %{"body" => body}, socket) do
    broadcast socket, "new_post", %{body: body}
    {:noreply, socket}
  end

  def handle_out("new_post", payload, socket) do
    push socket, "new_post", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
