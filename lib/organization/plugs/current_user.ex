defmodule Organization.Plugs.CurrentUser do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    user_id = conn.params["user_id"]
    case Organization.Directory.current_user(user_id) do
      nil ->
        error_message = %{"error" => "User not found"} |> Jason.encode!()
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, error_message)
        |> halt()
      current_user ->
        conn
        |> assign(:current_user, current_user)
        |> assign(:current_customer, current_user.customer)
    end
  end
end