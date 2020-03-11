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

app:match("/login/", json_params(respond_to({
  before = function(self)
    if self.session.user then
      self.current_user = self.session.user 
    end
  end,
  POST = function(self)
    if self.current_user then
      return {
        json = self.current_user
      }
    end
    local body = self.params
    local User = Model:extend("user")
    local user = User:find(body)
    if not user then
        return {status=404}
    end
    self.session.user = user 
    return {
      json = user 
    }
end})))

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
       local size = self.params.page_size or 6 
       local page = self.params.page or 1 
       local paginated = self.model:paginated({per_page = tonumber(size)})
       data = paginated:get_page(page)
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
