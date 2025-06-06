defmodule QrCodeGenSvcWeb.ErrorJSONTest do
  use QrCodeGenSvcWeb.ConnCase, async: true

  test "renders 404" do
    assert QrCodeGenSvcWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert QrCodeGenSvcWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
