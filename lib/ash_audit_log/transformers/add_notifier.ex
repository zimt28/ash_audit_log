defmodule AshAuditLog.Transformers.AddNotifier do
  @moduledoc "Adds the generated audit log to the resource's notifiers"
  use Ash.Dsl.Transformer

  import AshAuditLog.Resource, only: [audit_log_module: 1]

  alias Ash.Dsl.Transformer

  def before?(Ash.Api.Transformers.EnsureResourcesCompiled), do: true
  def before?(_), do: false

  def transform(resource, dsl) do
    notifiers = [audit_log_module(resource)] ++ get_in(dsl, [:persist, :notifiers])

    dsl = Transformer.persist(dsl, :notifiers, notifiers)

    {:ok, dsl}
  end
end
