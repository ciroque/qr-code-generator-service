defmodule QrCodeGenSvcWeb.FallbackController do
  @moduledoc false

  use QrCodeGenSvcWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> send_resp(404, "Not found")
  end
end
