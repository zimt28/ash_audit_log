# Used by "mix format"
locals_without_parens = [actor: 1, ignore_fields: 1, private?: 1]

[
  import_deps: [:ash, :ash_postgres],
  locals_without_parens: locals_without_parens,
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  export: [
    locals_without_parens: locals_without_parens
  ]
]
