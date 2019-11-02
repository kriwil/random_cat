defmodule RandomCatWeb.CatLive do
  use Phoenix.LiveView


  def render(assigns) do
    ~L"""
    <div>
      <img src="<%= @url %>">
    </div>
    <button phx-click="moar" phx-hook="MoarButton">moar!</button>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, :url, get_cat_url())}
  end

  def handle_event("moar", _values, socket) do
    {:noreply, assign(socket, :url, get_cat_url())}
  end

  defp get_cat_url() do
    fallback = "http://lorempixel.com/g/500/300/animals/"
    case HTTPoison.get("http://aws.random.cat/meow") do
      {:ok, %HTTPoison.Response{body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"file" => url}} ->
            url
          {:error, _} ->
            fallback
        end

      {:error, _} ->
        fallback
    end
  end
end

