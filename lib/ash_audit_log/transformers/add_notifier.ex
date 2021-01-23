defmodule AshAuditLog.Transformers.AddNotifier do
  @moduledoc "Adds the generated audit log to the resource's notifiers"
  use Ash.Dsl.Transformer

  import Ash.Dsl.Transformer, only: [get_persisted: 3, persist: 3]
  import AshAuditLog.Resource, only: [audit_log_module: 1]

  def before?(Ash.Api.Transformers.EnsureResourcesCompiled), do: true
  def before?(_), do: false

  def transform(resource, dsl) do
    notifiers = [audit_log_module(resource)] ++ get_persisted(dsl, :notifiers, nil)

    dsl = persist(dsl, :notifiers, notifiers)

    {:ok, dsl}
  end
end
