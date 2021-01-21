defmodule AshAuditLog.Notifier do
  @moduledoc ""

  import AshAuditLog, only: [api: 1, ignore_fields: 1]
  import AshAuditLog.Resource, only: [audit_log_module: 1]

  alias Ash.Changeset

  @always_ignore_fields Application.get_env(:ash_audit_log, :always_ignore_fields, [])

  def handle_notification(%Ash.Notifier.Notification{
        resource: resource,
        action: %{type: action_type},
        changeset: %{attributes: changes},
        data: data,
        actor: _actor
      }) do
    changes = Map.drop(changes, @always_ignore_fields ++ ignore_fields(resource))

    changeset =
      audit_log_module(resource)
      |> Changeset.new(%{
        action: action_type,
        changes: changes
      })
      |> Changeset.replace_relationship(:resource, data)

    api(resource).create(changeset)
  end

  def handle_notification(_notification), do: nil
end
