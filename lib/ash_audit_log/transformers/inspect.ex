defmodule AshAuditLog.Transformers.Inspect do
  @moduledoc "Adds a relationship to the resource"
  use Ash.Dsl.Transformer

  def transform(resource, dsl) do
    {:ok, IO.inspect(dsl, label: resource)}
  end
end
