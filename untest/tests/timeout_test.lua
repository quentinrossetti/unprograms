-- This file compares the output of a collection of test suits agains a pre-
-- generated and pre-validated file. Basically it ensures that 
-- `stdout==checkfile.txt`

-- Configuration
-- -------------

local CHECKFILE_NAME = debug.getinfo(2, "S").source:sub(2):sub(1,-4).."txt"
-- If the checkfile has to be regenerated. (default: false)
local CHECKFILE_GENERATION = false

-- Test setup
-- ----------

local buffer = ""
local di = {}
di.write = function (s) buffer = buffer..s end
di.gpu = require("component").gpu
local close = loadfile("/usr/bin/untest.lua")(di)

local function mock_f_long() os.sleep(3); di.write("end mock_f_long\n") end
local function mock_f_short() di.write("end mock_f_short\n") end
local function mock_f_error() error("custom error") end

-- Run tests
-- ---------

describe("suite", function ()
  it("normal error", mock_f_error)
  it("short test", mock_f_short)
  it("test taking too long", mock_f_long)
  it("specified timeout", mock_f_long, 4)
end)
close()

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
