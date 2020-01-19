local lapis = require("lapis")
local app = lapis.Application()
local Model = require("lapis.db.model").Model
local capture_errors = require("lapis.application").capture_errors
local json_params = require("lapis.application").json_params
local respond_to = require("lapis.application").respond_to

local function getBody(params)
  local newTab = {}
  for k, v in pairs(params) do
    if (k ~= "object" and k ~= "id") then
       newTab[k] = v
    end
  end
  return newTab
end

app:match("/(:object)/(:id)", json_params(respond_to({
  before = function(self)
    self.model = Model:extend(self.params.object)
    self.id = self.params.id
  end,
  GET = function(self)
    local data
    if (self.id ~= nil) then
       data = self.model:find(self.id)
    else
       data = self.model:select()
    end
    return {
	     json = data 
	   }
  end,
  POST = function(self)
    local body = getBody(self.params) 
    if (self.id ~= nil) then
        local data = self.model:find(self.id) 
	data:update(body)
    else
        self.model:create(body)
    end
    return {
             json = "ok" 
           }
  end,
  DELETE = function(self)
    if (self.id ~= nil) then
       local data = self.model:find(self.id)
       if data then
       	 data:delete()       
       end
    end 
    return {
             json = "ok" 
           }
  end
})))

return app
