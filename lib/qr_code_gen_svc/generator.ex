defmodule QrCodeGenSvc.Generator do
  alias QrCode

  def generate_qr_code(data) do
    # Convert input data to string format
    string_data = convert_to_string(data)

    IO.puts(">>>>>>>>>>>>>>>> #{data} :: #{string_data}")

    case QRCode.create(string_data, :quartile)
         |> QRCode.render() do
      {:ok, svg} -> {:ok, svg}
      {:error, reason} -> {:error, reason}
    end
  end

  # Helper function to convert various data types to strings
  defp convert_to_string(data) when is_binary(data), do: data
  defp convert_to_string(data) when is_integer(data), do: Integer.to_string(data)
  defp convert_to_string(data) when is_float(data), do: Float.to_string(data)
  defp convert_to_string(data) when is_atom(data), do: Atom.to_string(data)
  defp convert_to_string(data) when is_list(data) do
    # Handle charlists and regular lists
    if List.ascii_printable?(data) do
      List.to_string(data)
    else
      inspect(data)
    end
  end
  defp convert_to_string(data) when is_map(data), do: Jason.encode!(data)
  defp convert_to_string(data) when is_tuple(data), do: inspect(data)
  defp convert_to_string(data), do: inspect(data)
end

