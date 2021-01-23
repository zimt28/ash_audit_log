defmodule AshAuditLog.Notifier do
  @moduledoc ""

  import AshAuditLog, only: [ignore_fields: 1]
  import AshAuditLog.Resource, only: [audit_log_module: 1]

  alias Ash.Changeset

  def handle_notification(%Ash.Notifier.Notification{} = notification) do
    %{
      api: api,
      resource: resource,
      action: %{type: action_type},
      changeset: %{attributes: changes},
      data: data,
      actor: _actor
    } = notification

    changes = Map.drop(changes, ignore_fields(resource))

    changeset =
      audit_log_module(resource)
      |> Changeset.new(%{
        action: action_type,
        changes: changes
      })
      |> Changeset.replace_relationship(:resource, data)

    api.create(changeset)
  end
end
