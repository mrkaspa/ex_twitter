defmodule ExTwitter.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExTwitter.Accounts` context.
  """

  import ExTwitter.Factory

  def valid_user_attributes(attrs \\ %{}) do
    params_for(:user, attrs)
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> ExTwitter.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
