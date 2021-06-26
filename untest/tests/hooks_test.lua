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

local before_each_count = 0
local after_each_count = 0
local function mock_f_number() return 42 end

-- Run tests
-- ---------

before_each = function () 
  before_each_count = before_each_count+1
  di.write("before_each: n°"..before_each_count.."\n")
end
after_each = function () 
  after_each_count = after_each_count+1
  di.write("after_each: n°"..after_each_count.."\n")
end 
describe("suite 1", function ()
  it("sub test A", mock_f_number)
  it("sub test B", mock_f_number)
end)
describe("suite 2", function ()
  it("sub test C", mock_f_number)
  it("sub test D", mock_f_number)
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
local ok, err = pcall(assert, buffer == check)
if ok then
  print("Testing passed: "..CHECKFILE_NAME)
else
  error("Testing failed: "..CHECKFILE_NAME)
end
