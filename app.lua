local lapis = require("lapis")
local app = lapis.Application()
local Model = require("lapis.db.model").Model
local capture_errors = require("lapis.application").capture_errors
local json_params = require("lapis.application").json_params
local respond_to = require("lapis.application").respond_to

local Users = Model:extend("users")

app:match("/user/(:id)", json_params(respond_to({
  before = function(self)
    self.id = self.params.id
  end,
  GET = function(self)
    local users
    if (self.id ~= nil) then
       users = Users:find(self.id)
    else
       users = Users:select()
    end
    return {
	     json = users
	   }
  end,
  POST = function(self)
    if (self.id ~= nil) then
        local user = Users:find(self.id) 
	user:update(self.params)
    else
  	Users:create(self.params)
    end
    return {
             json = "ok" 
           }
  end,
  DELETE = function(self)
    if (self.id ~= nil) then
       users = Users:find(self.id)
       if users then
       	 users:delete()       
       end
    end 
    return {
             json = "ok" 
           }
  end
})))

return app
