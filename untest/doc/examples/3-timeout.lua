-- By deflaut untest will throw a `error: timeout of 2 s exceeded` if a test
-- takes too long to finish.

it("test taking too long", looooong_test)
--> error: timeout of 2 s exceeded

-- You can increase (or decrease) this timer by passing a amount of second

it("test taking a long time but it's okay", looooong_test, 10)
--> testing passed