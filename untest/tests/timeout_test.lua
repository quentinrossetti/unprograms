-- Configuration
-- -------------

local CHECKFILE_NAME = "timeout_test.txt"
-- If the checkfile has to be regenerated. (default: false)
local CHECKFILE_GENERATION = false
-- Set to true to produce actual results. Set to false to simply run the dummy 
-- suite. (default: true)
local DEPENDENCY_INJECTION = true

-- Test setup
-- ----------
local untest = nil
local buffer = ""
local di = {}
if DEPENDENCY_INJECTION then
  di.write = function(s) buffer = buffer..s end
  di.gpu = require("component").gpu
  di.thread = require("thread")
  untest = loadfile("/usr/lib/untest.lua")(di)
else
  untest = require("untest")
end
function mock_f_long() os.sleep(3); di.write("end mock_f_long\n") end
function mock_f_short() di.write("end mock_f_short\n") end
function mock_f_error() error("custom error") end

local it = untest.it
local describe = untest.describe

-- Run tests
-- ---------

describe("suite", function ()
  it("normal error", mock_f_error)
  it("short test", mock_f_short)
  it("test taking too long", mock_f_long)
  it("specified timeout", mock_f_long, 4)
end)

-- Test results
-- ------------
if CHECKFILE_GENERATION then
  io.open(CHECKFILE_NAME, "w"):write(buffer):close()
end

-- Asserts
-- -------
local file = io.open(CHECKFILE_NAME, "rb")
local check = file:read("*all")
file:close()
local ok, err = pcall(assert, buffer==check)
if ok then
  print("Testing passed: "..CHECKFILE_NAME)
else
  error("Testing failed: "..CHECKFILE_NAME)
end
