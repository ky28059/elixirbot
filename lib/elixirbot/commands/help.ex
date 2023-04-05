defmodule Elixirbot.Commands.Help do
  @behaviour Nosedrum.Command
  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Struct.{Embed, User}
  alias Nosedrum.Storage.ETS, as: CommandStorage
  alias Elixirbot.Util.Messages

  @impl true
  def usage, do: ["help [command]?"]

  @impl true
  def description,
    do: "Returns info about a given command, or a list of commands if no command was provided."

  @impl true
  def predicates, do: []

  @impl true
  def command(msg, []) do
    Messages.reply_embed(msg, help_embed(msg.author))
  end

  @impl true
  def command(msg, [command_name]) do
    Messages.reply_embed(msg, help_embed(msg.author, command_name))
  end

  @impl true
  def command(interaction) do
    case interaction.data.options do
      [%{name: "command", value: command_name}] -> [embeds: [help_embed(interaction.user, command_name)]]
      nil -> [embeds: [help_embed(interaction.user)]]
    end
  end

  @spec help_embed(User.t()) :: Embed.t()
  defp help_embed(user) do
    commands = CommandStorage.all_commands()
      |> Map.keys()
      |> Enum.join(", ")

    %Embed{
      title: "Command list",
      description: commands,
      color: 0x6e4a7e,
      footer: %{
        text: "Requested by #{User.full_name(user)}"
      }
    }
  end

  @spec help_embed(User.t(), String.t()) :: Embed.t()
  defp help_embed(user, command_name) do
    case CommandStorage.lookup_command(command_name) do
      # No command found
      nil ->
        commands = CommandStorage.all_commands()
          |> Map.keys()
          |> Enum.join(", ")

        %Embed{
          title: "Command `#{command_name}` not found.",
          description: "Available commands: #{commands}",
          color: 0x6e4a7e,
          footer: %{
            text: "Requested by #{User.full_name(user)}"
          }
        }

      # Command with no subcommands found
      command when not is_map(command) ->
        prefix = Application.get_env(:nosedrum, :prefix)
        usages = Stream.map(command.usage, fn usage -> prefix <> usage end)
          |> Enum.join("\n")

        %Embed{
          title: command_name,
          description: "```elm\n#{usages}\n```#{command.description}",
          color: 0x6e4a7e,
          footer: %{
            text: "Requested by #{User.full_name(user)}"
          }
        }
    end
  end

  @impl true
  def type, do: :slash

  @impl true
  def options() do
    [
      %{
        type: :string,
        name: "command",
        description: "The command to get info about.",
        required: false,
        choices: CommandStorage.all_commands()
          |> Map.keys()
          |> Enum.map(fn name -> %{name: name, value: name} end)
      }
    ]
  end
end
