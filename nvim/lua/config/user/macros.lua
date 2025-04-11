--------------------------------------------------
--               MODULE VARIABLES               --
--------------------------------------------------

local function macro(name, value)
  assert(type(name) == "string")
  assert(type(value) == "string")

  vim.cmd("let @" .. name .. "='" .. value .. "'")
end

--------------------------------------------------
--                    MACROS                    --
--------------------------------------------------

macro("n", "^yEop^") -- create number list
