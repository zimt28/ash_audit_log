defmodule AshAuditLog.Transformers.VerifyApi do
  @moduledoc "Verifies that the extension is being used on an api"
  use Ash.Dsl.Transformer

  def transform(resource, dsl) do
    if Ash.Api.Dsl in Ash.extensions(resource) do
      {:ok, dsl}
    else
      {:error, "The AshAuditLog.Api extension must be used on an api."}
    end
  end
end
