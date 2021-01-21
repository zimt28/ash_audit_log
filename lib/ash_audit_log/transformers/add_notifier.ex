defmodule AshAuditLog.Transformers.AddNotifier do
  @moduledoc "Adds the generated audit log to the resource's notifiers"
  use Ash.Dsl.Transformer

  import AshAuditLog.Resource, only: [audit_log_module: 1]

  def transform(resource, dsl) do
    notifiers = [audit_log_module(resource)] ++ get_in(dsl, [:persist, :notifiers])
    dsl = put_in(dsl, [:persist, :notifiers], notifiers)

    {:ok, dsl}
  end
end
