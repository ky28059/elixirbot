defmodule Elixirbot.Handlers.MessageCreate do
  alias Nosedrum.Invoker.Split, as: CommandInvoker
  alias Nosedrum.Storage.ETS, as: CommandStorage
  alias Nostrum.Struct.{Message, Embed}
  alias Elixirbot.Util.Messages

  @doc """
  Handles the :MESSAGE_CREATE event by attempting to invoke the corresponding command.
  """
  @spec handle(Message.t()) :: nil
  def handle(msg) do
    unless msg.author.bot do
      case CommandInvoker.handle_message(msg, CommandStorage) do
        {:error, :predicate, {:error, reason}} ->
          Messages.reply_embed(msg, %Embed{
            title: "[ERR] Permission denied",
            description: reason,  # TODO: customize this message
            color: 0x6e4a7e
          })

        {:error, :predicate, {:noperm, reason}} ->
          Messages.reply_embed(msg, %Embed{
            title: "[ERR] Permission denied",
            description: reason,  # TODO: customize this message?
            color: 0x6e4a7e
          })

        _ -> :ok
      end
    end
  end
end
