local config = require("lapis.config")

config("development", {
  port = 9090,
  mysql = {
    host = "127.0.0.1",
    user = "root",
    password = "test123",
    database = "lapis"
  }
})

