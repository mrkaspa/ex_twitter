defmodule ExTwitter.Repo do
  use Ecto.Repo,
    otp_app: :ex_twitter,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
