# Elixirbot

https://discord.com/oauth2/authorize?client_id=1092613929278120017&scope=bot+applications.commands&permissions=8

Simple testing bot made to learn Elixir.

Before running, create a `config.secret.exs` that configures your bot token like so:
```exs
import Config

config :nostrum,
  token: "MTA5MjYxMzkyOTI3ODEyMDAxNw.Gh7HFy.eTGSgwR2-6J44TJOqcLms3XMtSHdnR701kGOv0"
```

Install dependencies with
```powershell
mix deps.get
```
compile the project with
```powershell
mix compile
```
and run with
```powershell
iex.bat -S mix
```
