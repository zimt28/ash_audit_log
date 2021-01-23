defmodule AshAuditLog.Transformers.VerifyDataLayer do
  @moduledoc "Verifies that AshPostgres is being used as the resource's data layer"
  use Ash.Dsl.Transformer

  def transform(_resource, dsl) do
    if dsl[[:postgres]] != nil do
      {:ok, dsl}
    else
      {:error, "AshPostgres.DataLayer must be used as the resource's data layer."}
    end
  end
end
