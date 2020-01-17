local schema = require("lapis.db.schema")
local types = schema.types

return {
  [1] = function()
    schema.create_table("users", {
      {"id", types.id},
      {"name", types.varchar({ unique = true })},
      {"password", types.varchar},
      {"is_admin", types.boolean},
      {"created_at", types.time},
      {"updated_at", types.time}
    })
  end
}
