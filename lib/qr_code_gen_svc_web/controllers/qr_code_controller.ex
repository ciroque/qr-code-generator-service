defmodule QrCodeGenSvcWeb.QrCodeController do
  @moduledoc false

  use QrCodeGenSvcWeb, :controller

  def index(conn, _params),
      do: send_resp(conn, 200, "#{Jason.encode!(%{status: :ok})}")

  def create(conn, params) do
    case handle_create(params) do
      {:ok, _request, response} ->
        {:ok, response_json} = Jason.encode(response)
        send_resp(conn, 200, response_json)
      {:error, _err} -> send_resp(conn, 500, "Internal Server Error")
    end
  end

  defp handle_create(params)do
    %{data: data} = request = struct(QrCodeGenSvc.CreateRequest, Map.new(params, fn {k, v} -> {String.to_atom(k), v} end))

    case QrCodeGenSvc.Generator.generate_qr_code(data)do
      {:ok, svg}-> {:ok, request, %QrCodeGenSvc.CreateResponse{qr_code: svg, format: :svg}}
     {:error, error} -> {:error, error}
    end
  end
end
