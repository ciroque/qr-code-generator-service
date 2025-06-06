defmodule QrCodeGenSvcWeb.Probez.ReadinessController do
  @moduledoc false

  use QrCodeGenSvcWeb, :controller

  def index(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, "{\"status\": \"OK\"}")
  end
end
