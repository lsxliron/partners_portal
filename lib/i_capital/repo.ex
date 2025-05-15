defmodule ICapital.Repo do
  use Ecto.Repo,
    otp_app: :i_capital,
    adapter: Ecto.Adapters.Postgres
end
