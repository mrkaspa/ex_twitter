defmodule ExTwitterWeb.FallbackController do
  use ExTwitterWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_flash(:error, "NOT FOUND")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
