defmodule Elixirbot.Consumer do
  use Nostrum.Consumer

  alias Elixirbot.Handlers

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, data, _ws_state}) do
    Handlers.Ready.handle(data)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    Handlers.MessageCreate.handle(msg)
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    Handlers.InteractionCreate.handle(interaction)
  end

  def handle_event(_event) do
    :noop
  end
end
