defmodule AshAuditLog.Transformers.CreateResource do
  @moduledoc "Generates an audit log resource for an another resource"
  use Ash.Dsl.Transformer

  import AshAuditLog.Resource

  def transform(resource, dsl) do
    Module.create(
      audit_log_module(resource),
      audit_log_module_contents(resource, dsl),
      Macro.Env.location(__ENV__)
    )

    {:ok, dsl}
  end
end
