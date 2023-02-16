-- create a game that lets the user guess a number from 1 to 10
-- the game will tell the user if they are too high or too low
-- it will continue to ask until the user guesses the correct number

-- get the random number
local number = math.random(1, 10)

-- create a function to ask the user for a number
local function ask()
    -- ask the user for a number
    local guess = tonumber(io.read())

    -- check if the user guessed the correct number
    if guess == number then
        -- tell the user they guessed correctly
        print("You guessed correctly!")
    elseif guess < number then
        -- tell the user they guessed too low
        print("You guessed too low!")
        -- ask the user for another number
        ask()
    else
        -- tell the user they guessed too high
        print("You guessed too high!")
        -- ask the user for another number
        ask()
    end
end
