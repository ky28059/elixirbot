defmodule Elixirbot.Handlers.MessageCreate do
  alias Nosedrum.Invoker.Split, as: CommandInvoker
  alias Nosedrum.Storage.ETS, as: CommandStorage
  alias Nostrum.Struct.Message

  @doc """
  Handles the :MESSAGE_CREATE event by attempting to invoke the corresponding command.
  """
  @spec handle(Message.t()) :: nil
  def handle(msg) do
    unless msg.author.bot do
      CommandInvoker.handle_message(msg, CommandStorage)
    end
  end
end
