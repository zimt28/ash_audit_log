defmodule AshAuditLog.Api do
  use Ash.Dsl.Extension,
    transformers: [
      AshAuditLog.Transformers.VerifyApi,
      AshAuditLog.Transformers.AddResources
      # AshAuditLog.Transformers.Inspect
    ]
end
