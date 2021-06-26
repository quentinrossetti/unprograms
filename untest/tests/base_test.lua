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

local function mock_f_number() return 42 end
local function mock_f_oops() error("oops") end
local function mock_f_ab(a, b) return a+b end

-- Run tests
-- ---------

it("should number", mock_f_number)
it("should oops", mock_f_oops)
it("should return a sum", function ()
  assert(mock_f_ab(3,5) == 9)
end)
describe("suite 1", function ()
  it("sub test 4", mock_f_oops)
  it("sub test 5", mock_f_number)
end)
describe("suite 2", function ()
  it("sub test 6", mock_f_number)
  it("sub test 7", mock_f_number)
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
