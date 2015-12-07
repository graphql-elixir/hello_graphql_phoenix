defmodule HelloGraphQL.PageControllerTest do
  use HelloGraphQL.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Welcome to GraphQL!"
  end
end
