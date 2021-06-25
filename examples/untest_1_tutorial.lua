-- Let's pretend we are writting a program for managing an adjacent chest.
-- We call our program *super_inventory*, and store it in 'super_inventory.lua'

local super_inventory = require("super_inventory")

-- Our program can count the number of items in a inventory with a `count()`. 
-- function. Let's make sure it always return a number

it("should always return a number when calling count()", function ()
  local my_count = super_inventory.count()
  assert(typeof(my_count) == "number")
end)

-- In the shell we run
-- # untest test_file.lua 

-- Note how we created an anonymous function? In this function you
-- can write what you want to setup the test.
-- Then we check if the returned value a valid number.
-- Then we called the `assert()` function. `assert()` throws an error if it's
-- argument is false.

-- Now we can modify 'super_inventory.lua', add features and such. If we somehow
-- break the program the test will tell us! All we have to do is to run this file.

-- When 'super_inventory.lua' becomes a more elaborated program with a few 
-- features and a dozen of tests, it's time to call `describe()`!

describe("The count() function", function ()

  it("sould return a number", function ()
    -- some test
  end)

  it("can take a item name", function ()
    local result = super_inventory.count("minecraft:stone")
    assert(result == 64)
  end)

end)