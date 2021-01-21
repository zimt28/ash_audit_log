defmodule AshAuditLog.Transformers.VerifyResource do
  @moduledoc "Verifies that the extension is being used on a resource"
  use Ash.Dsl.Transformer

  def transform(resource, dsl) do
    if Ash.Resource.Dsl in Ash.extensions(resource) do
      {:ok, dsl}
    else
      {:error, "The AshAuditLog extension must be used on an api."}
    end
  end
end
