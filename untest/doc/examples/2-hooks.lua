-- You can call a function to run before and after each test.
-- It allows you to reset/cleanup your setup between each test.

before_each = function ()
  -- do stuff before each test
  -- e.g: move items back to chest, reset some condition, etc.
end

after_each = function ()
  -- do stuff after each test
end

describe("The count() function", function ()

  it("sould return a number", function ()
    -- some test
  end)

  it("can take a item name", function ()
    local result = super_inventory.count("minecraft:stone")
    assert(result == 64)
  end)

end)