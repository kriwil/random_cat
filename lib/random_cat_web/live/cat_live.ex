defmodule RandomCatWeb.CatLive do
  use Phoenix.LiveView


  def render(assigns) do
    ~L"""
    <img src="<%= @url %>">
    """
  end

  def mount(%{}, socket) do
    fallback = "http://lorempixel.com/g/500/300/animals/"
    case HTTPoison.get("http://aws.random.cat/meow") do
      {:ok, %HTTPoison.Response{body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"file" => url}} ->
            {:ok, assign(socket, :url, url)}
          {:error, _} ->
            {:ok, assign(socket, :url, fallback)}
        end

      {:error, _} ->
        {:ok, assign(socket, :url, fallback)}
    end
  end
end

