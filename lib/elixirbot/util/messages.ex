defmodule Elixirbot.Util.Messages do
  alias Nostrum.Api
  alias Nostrum.Struct.{Embed, Message}

  @doc """
  Replies to the given message with a given embed.
  """
  @spec reply_embed(Message.t(), Embed.t()) :: Message.t()
  def reply_embed(msg, embed) do
    Api.create_message!(
      msg.channel_id,
      embeds: [embed],
      message_reference: %{message_id: msg.id},
      allowed_mentions: :none
    )
  end

  @doc """
  Replies to the given message with an error embed for when an argument is unable to be parsed
  as a `User`.
  """
  @spec failed_to_parse_user(Message.t(), String.t()) :: Message.t()
  def failed_to_parse_user(msg, arg) do
    embed = %Embed{
      title: "[ERR] Failed to parse user",
      description: "Unable to parse user `#{arg}`.",
      color: 0x6e4a7e
    }
    reply_embed(msg, embed)
  end

  @doc """
  Replies to the given message with an error embed for when too many or little arguments are
  provided to a command.
  """
  @spec argument_arity_mismatch(Message.t(), String.t(), String.t(), Integer.t()) :: Message.t()
  def argument_arity_mismatch(msg, command_name, expected_args, received_args) do
    prefix = Application.get_env(:nosedrum, :prefix)
    embed = %Embed{
      title: "[ERR] Argument arity mismatch",
      description: "Command `#{command_name}` was expecting `#{expected_args}` arguments, but received `#{received_args}`. For more info on this command, run `#{prefix}help #{command_name}`.",
      color: 0x6e4a7e
    }
    reply_embed(msg, embed)
  end
end
