defmodule Elixirbot.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Elixirbot.Supervisor.start_link([])
  end
end
