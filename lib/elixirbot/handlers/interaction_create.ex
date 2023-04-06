defmodule Elixirbot.Handlers.InteractionCreate do
  alias Nostrum.Struct.Interaction

  @doc """
  Handles the :INTERACTION_CREATE event by invoking the corresponding slash command.
  """
  @spec handle(Interaction.t()) :: :ok
  def handle(interaction) do
    Nosedrum.Interactor.Dispatcher.handle_interaction(interaction)
  end
end
