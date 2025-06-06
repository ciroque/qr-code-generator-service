defmodule QrCodeGenSvc.CreateRequest do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:data]
end

defmodule QrCodeGenSvc.CreateResponse do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:qr_code, :format]
end
