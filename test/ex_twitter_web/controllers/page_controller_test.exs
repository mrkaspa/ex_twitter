defmodule ExTwitterWeb.PageControllerTest do
  use ExTwitterWeb.ConnCase

  setup :register_and_log_in_user

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Make a tweet!"
  end
end
