------------
-- Uncomplicated Testing for OpenComputers.
-- - [Homepage](https://github.com/quentinrossetti/untest)
-- - [API documentation](https://quentinrossetti.github.io/untest)
-- @module untest
-- @license ICS 
-- @copyright 2020 Quentin Rossetti <code@bleu.gdn>

-- Dependency injection
-- --------------------

local deps = ({...})[1]
if type(deps)=="string" then deps = {} end
deps.gpu = deps.gpu or require("component").gpu
deps.write = deps.write or require("term").write
deps.thread = deps.thread or require("thread")
deps.shell = deps.shell or require("shell")

-- Configuration
-- -------------

local color_bg    = function () deps.gpu.setBackground(0x000000) end
local color_fg    = function () deps.gpu.setForeground(0xffffff) end
local color_test  = function () deps.gpu.setForeground(0xb4b4b4) end
local color_fail  = function () deps.gpu.setForeground(0xcc2400) end
local color_pass  = function () deps.gpu.setForeground(0x009200) end
local color_reset = function () color_bg(); color_fg(); end

-- Internals
-- ---------

local function create_context()
  return {
    before_each = function () end,
    after_each = function() end,
    timeout = 2,
    trace = false,
    passed=0,
    failed=0,
    test_id_current=0,
    test_id_failed={},
    tb={},
  }
end

local function print_title(title, err)
  if err then
    color_fail()
    deps.write("  x "..context.test_id_current..") "..title.."\n  "..err.."\n")
  else
    color_pass()
    deps.write("  v ")
    color_test()
    deps.write(title.."\n")
  end
  color_reset()
end

local function print_trace(tb)
  color_fail()
  deps.write(tb.."\n")
  color_reset()
end

function close()
  deps.write("\n")
  local exit_code = true
  if context.passed >= 0 then
    color_pass()
    deps.write("v "..tostring(context.passed).." tests passed\n")
  end
  if context.failed >= 0 then
    exit_code = false
    color_fail()
    deps.write("x "..tostring(context.failed).." tests failed\n")
  end
  deps.write("\n")
  color_reset()
  os.exit(exit_code, true)
end

-- Public API
-- ----------

--- Create a test case. A test case should contain one ore more @{assert}. A
-- test fails when @{error} is called. This function is global, you can call it 
-- from anywhere.
-- @tparam string title Description of what is being tested
-- @tparam function f Function that contains the code or your test
-- @tparam[opt] number timeout Max amount of seconds to wait for this test.
-- @usage
-- it("sould return a value between 0 and 100", function ()
--   local percent = my_program.getEnergyPercentage()
--   assert(percent >= 0)
--   assert(percent <= 100)
-- end)
function it(title, f, timeout)
  timeout = timeout or context.timeout
  checkArg(1, title, "string")
  checkArg(2, f, "function")
  checkArg(3, timeout, "number")
  context.test_id_current = context.test_id_current+1
  
  before_each()
  local ok, err = nil, nil
  local timer_thread = deps.thread.create(function ()
    os.sleep(timeout)
  end)
  local f_thread = deps.thread.create(function ()
    local co = coroutine.create(f)
    ok, err = coroutine.resume(co)
  end)

  deps.thread.waitForAny({timer_thread, f_thread})
  if f_thread:status()=="running" then
    f_thread:kill()
    _, err = pcall(error, 'timeout of '..timeout..' s exceeded')
  else
    timer_thread:kill()
  end

  if ok == true then
    context.passed = context.passed+1
    print_title(title)
  else
    table.insert(context.test_id_failed, context.test_id_current)
    context.failed = context.failed+1
    context.tb[context.test_id_current] = debug.traceback(co)
    print_title(title, err)
    if untest.trace then print_trace(context.tb[context.test_id_current]) end
  end
  after_each()
end

--- Group tests. Using `describe()` create a *suite* which  contains all the 
-- tests under it. This function is global, you can call it from anywhere.
-- @tparam string title Description of the suite
-- @tparam function f Function that contains individual tests created using 
-- the `it()` function.
-- @usage
-- decribe("Tests about the energy feature", function ()
--   it("should charge battery when under 10%", function ()
--     -- some test
--   end)
--   it("should stop charging battery when above 80%", function ()
--     -- some test
--   end)
--   it("should return a number between 0% and 100%", function ()
--     -- some test
--   end)
-- end)
function describe(title, f)
  checkArg(1, title, "string")
  checkArg(2, f, "function")
  color_reset()
  deps.write("\n"..title.."\n")
  f()
end


--- Stores infos about the current test run.
-- @table context
-- @tfield number timeout Max amount of seconds to wait for each test.
-- @tfield boolean trace If a traceback has to be displayed
-- @usage
-- context.timeout = 4 -- wait 4 seconds before stopping a test.
-- context.trace = true -- print the traceback of errors
context = create_context()

--- Runs some shared setup before each test
-- @function before_each
-- @usage
-- before_each = function ()
--   -- do stuff before each test
--   -- e.g: move items back to chest, reset some condition, etc.
-- end
before_each = function () end

--- Runs some shared teardown after each test
-- @function after_each
-- @usage
-- after_each = function ()
--   -- do stuff after each test
-- end
after_each = function () end

-- Runtime
-- -------

local args, ops = deps.shell.parse(...)
if ops.timeout then context.timeout = tonumber(ops.timeout) end
if ops.trace=="true" then context.trace = true end
dofile(args[1])
close()