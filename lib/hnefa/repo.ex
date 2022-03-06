defmodule Hnefa.Repo do
  use Ecto.Repo,
    otp_app: :hnefa,
    adapter: Ecto.Adapters.Postgres
end
