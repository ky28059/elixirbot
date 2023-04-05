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

  @spec failed_to_parse_user(String.t()) :: Embed.t()
  def failed_to_parse_user(arg) do
    %Embed{
      title: "[ERR] Failed to find user",
      description: "Unable to find user `#{arg}`.",
      color: 0x6e4a7e
    }
  end
end
