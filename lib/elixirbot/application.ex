defmodule Elixirbot.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Nosedrum.Storage.ETS,
      Elixirbot.Consumer,
      {Nosedrum.Interactor.Dispatcher, name: Nosedrum.Interactor.Dispatcher}
    ]
    options = [strategy: :rest_for_one, name: Elixirbot.Supervisor]
    Supervisor.start_link(children, options)
  end
end
