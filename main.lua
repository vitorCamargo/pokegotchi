local game = require('classes/game')

local mainBackground = love.graphics.newImage('/assets/background/1.png')
local titleFont = '/assets/fonts/title.ttf'
local pixelFont = '/assets/fonts/pixel.ttf'
local backgroundSound = '/assets/sounds/background.mp3'
local actionSound = '/assets/sounds/action.mp3'
local timer = 0

nameNewPokemon = ''

local gameState = 'mainPage'

function love.load()
    cursor = love.mouse.getSystemCursor('hand')
    game = game:new()

    -- Song
    souceAudio = love.audio.newSource(love.sound.newSoundData(backgroundSound))
    souceAudio:setLooping(true)
    souceAudio:play()

    if not love.filesystem.getInfo('data.lua') then
        love.filesystem.newFile('data.lua')
        love.filesystem.write('data.lua', '')
    else
        indexPokemon = 1
        for lines in love.filesystem.lines('data.lua') do
            local params = {}

            for p in string.gmatch(lines, '([^;]*);') do
                table.insert(params, p)
            end

            game:addPokemon(params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10])
            game.pokemons[indexPokemon]:updateStats()
            indexPokemon = indexPokemon + 1
        end
    end
end

function love.update( dt )
    timer = timer + dt
    changeMainBackground(dt)
end

function love.draw()
    if gameState == 'mainPage' then drawMainPage()
    elseif gameState == 'choosePokemon' then drawChoosePokemon()
    elseif gameState == 'pokemonSettings' then drawPokemonSettings()
    elseif gameState == 'createNewPokemon' then drawCreateNewPokemon()
    elseif gameState == 'gameMainPage' then drawGameMainPage()
	else error('gameState is not a valid state.') end
end

function drawMainPage()
    -- Background
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(mainBackground, x, y)

    -- Title
    love.graphics.setColor(250, 200, -59)
    love.graphics.setNewFont(titleFont, 50)
    love.graphics.printf('PoKéGotchi', 0, love.graphics.getHeight()/2 - 60, love.graphics.getWidth(), 'center')

    -- Subtitle
    love.graphics.setColor(255, 255, 255)
    love.graphics.setNewFont(pixelFont, 20)
    love.graphics.printf('PRESS ANY KEY..', 0, love.graphics.getHeight()/2 + 80, love.graphics.getWidth(), 'center')

    -- After key is Pressed/Released
    function love.keyreleased( key )
        if gameState == 'mainPage' then
            gameState = 'choosePokemon'
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))
        end
    end
    
    function love.mousereleased( z, y, button )
        if gameState == 'mainPage' then
            gameState = 'choosePokemon'
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))
        end
    end
end

function drawChoosePokemon()
    -- Background
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(mainBackground, x, y)

    local x, y = love.mouse.getPosition()

    -- Title
    love.graphics.setColor(250, 200, -59)
    love.graphics.setNewFont(titleFont, 40)
    love.graphics.printf('PoKéGotchi', 0, 10, love.graphics.getWidth(), 'center')
    
    -- Subtitle
    love.graphics.setColor(255, 255, 255)
    love.graphics.setNewFont(pixelFont, 20)
    love.graphics.printf('PICK OR ADD ONE POKEMON', 0, 80, love.graphics.getWidth(), 'center')

    -- Games Loaded ('till 3 games) | Slot 1
    if table.getn(game.pokemons) >= 1 then
        love.graphics.printf(game.pokemons[1].name, 0, love.graphics.getHeight()/2 - 50, love.graphics.getWidth(), 'center')

        local f = love.graphics.getFont()
        fwSlot1 = f:getWidth(game.pokemons[1].name)
        fhSlot1 = f:getHeight()
    end

    -- Slot 2
    if table.getn(game.pokemons) >= 2 then
        love.graphics.printf(game.pokemons[2].name, 0, love.graphics.getHeight()/2 - 10, love.graphics.getWidth(), 'center')

        local f = love.graphics.getFont()
        fwSlot2 = f:getWidth(game.pokemons[2].name)
        fhSlot2 = f:getHeight()
    end

    -- Slot 3
    if table.getn(game.pokemons) >= 3 then
        love.graphics.printf(game.pokemons[3].name, 0, love.graphics.getHeight()/2 + 30, love.graphics.getWidth(), 'center')

        local f = love.graphics.getFont()
        fwSlot3 = f:getWidth(game.pokemons[3].name)
        fhSlot3 = f:getHeight()
    end

    -- New Pokemons
    if table.getn(game.pokemons) < 3 then
        love.graphics.printf('+ New Poke', 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), 'center')

        local f = love.graphics.getFont()
        fwSlotNew = f:getWidth('+ New Poke')
        fhSlotNew = f:getHeight()
    end
    
    -- Function to Click in Slots/New Poke
    function love.mousepressed( z, y, button )
        if table.getn(game.pokemons) < 3 and (y >= love.graphics.getHeight() - 50 and y <= love.graphics.getHeight() - 50 + fhSlotNew) and (x >= (love.graphics.getWidth() - fwSlotNew)/2 and x <= (love.graphics.getWidth() - fwSlotNew)/2 + fwSlotNew) then
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))
            nameNewPokemon = ''
            gameState = 'createNewPokemon'
        elseif table.getn(game.pokemons) >= 1 and (y >= love.graphics.getHeight()/2 - 50 and y <= love.graphics.getHeight()/2 - 50 + fhSlot1) and (x >= (love.graphics.getWidth() - fwSlot1)/2 and x <= (love.graphics.getWidth() - fwSlot1)/2 + fwSlot1) then
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))
            game:setCurrentPokemon(1)
            gameState = 'pokemonSettings'
        elseif table.getn(game.pokemons) >= 2 and (y >= love.graphics.getHeight()/2 - 10 and y <= love.graphics.getHeight()/2 - 10 + fhSlot2) and (x >= (love.graphics.getWidth() - fwSlot2)/2 and x <= (love.graphics.getWidth() - fwSlot2)/2 + fwSlot2) then
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))
            game:setCurrentPokemon(2)
            gameState = 'pokemonSettings'
        elseif table.getn(game.pokemons) >= 3 and (y >= love.graphics.getHeight()/2 + 30 and y <= love.graphics.getHeight()/2 + 30 + fhSlot3) and (x >= (love.graphics.getWidth() - fwSlot3)/2 and x <= (love.graphics.getWidth() - fwSlot3)/2 + fwSlot3) then
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))
            game:setCurrentPokemon(3)
            gameState = 'pokemonSettings'
        end
    end

    -- Change Mouse Cursor
    if table.getn(game.pokemons) < 3 and (y >= love.graphics.getHeight() - 50 and y <= love.graphics.getHeight() - 50 + fhSlotNew) and (x >= (love.graphics.getWidth() - fwSlotNew)/2 and x <= (love.graphics.getWidth() - fwSlotNew)/2 + fwSlotNew) then
        love.mouse.setCursor(cursor)
    elseif table.getn(game.pokemons) >= 1 and (y >= love.graphics.getHeight()/2 - 50 and y <= love.graphics.getHeight()/2 - 50 + fhSlot1) and (x >= (love.graphics.getWidth() - fwSlot1)/2 and x <= (love.graphics.getWidth() - fwSlot1)/2 + fwSlot1) then
        love.mouse.setCursor(cursor)
    elseif table.getn(game.pokemons) >= 2 and (y >= love.graphics.getHeight()/2 - 10 and y <= love.graphics.getHeight()/2 - 10 + fhSlot2) and (x >= (love.graphics.getWidth() - fwSlot2)/2 and x <= (love.graphics.getWidth() - fwSlot2)/2 + fwSlot2) then
        love.mouse.setCursor(cursor)
    elseif table.getn(game.pokemons) >= 3 and (y >= love.graphics.getHeight()/2 + 30 and y <= love.graphics.getHeight()/2 + 30 + fhSlot3) and (x >= (love.graphics.getWidth() - fwSlot3)/2 and x <= (love.graphics.getWidth() - fwSlot3)/2 + fwSlot3) then
        love.mouse.setCursor(cursor)
    else love.mouse.setCursor() end
end

function drawPokemonSettings()
    -- Background
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(mainBackground, x, y)

    local x, y = love.mouse.getPosition()

    -- Title
    love.graphics.setColor(250, 200, -59)
    love.graphics.setNewFont(titleFont, 40)
    love.graphics.printf('PoKéGotchi', 0, 10, love.graphics.getWidth(), 'center')
    
    -- Subtitle (Name of Pokemon)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setNewFont(pixelFont, 20)
    love.graphics.print(game:getCurrentPokemon().name, 10, 130)

    -- Load Game
    love.graphics.print('LOAD GAME', 40, 200)

    local f = love.graphics.getFont()
    fwLoad = f:getWidth('LOAD GAME')
    fhLoad = f:getHeight()

    -- Delete Game
    love.graphics.print('DELETE GAME', 40, 240)

    local f = love.graphics.getFont()
    fwDelete = f:getWidth('DELETE GAME')
    fhDelete = f:getHeight()

    -- Back to Menu
    love.graphics.print('BACK', 40, 280)

    local f = love.graphics.getFont()
    fwBack = f:getWidth('BACK')
    fhBack = f:getHeight()
    
    -- Function to Click in Slots/New Poke
    function love.mousepressed( z, y, button )
        if y >= 200 and y <= 200 + fhLoad and x >= 40 and x <= 40 + fwLoad then
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))
            gameState = 'gameMainPage'
        elseif y >= 240 and y <= 240 + fhDelete and x >= 40 and x <= 40 + fwDelete then
            game:removePokemon(game.currentPokemon)
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))
            love.filesystem.write('data.lua', game:saveInFile())

            gameState = 'choosePokemon'
        elseif y >= 280 and y <= 280 + fhBack and x >= 40 and x <= 40 + fwBack then
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))
            gameState = 'choosePokemon'
        end
    end

    -- Change Mouse Cursor
    if y >= 200 and y <= 200 + fhLoad and x >= 40 and x <= 40 + fwLoad then
        love.mouse.setCursor(cursor)
    elseif y >= 240 and y <= 240 + fhDelete and x >= 40 and x <= 40 + fwDelete then
        love.mouse.setCursor(cursor)
    elseif y >= 280 and y <= 280 + fhBack and x >= 40 and x <= 40 + fwBack then
        love.mouse.setCursor(cursor)
    else love.mouse.setCursor() end
end

function drawCreateNewPokemon()
    -- Background
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(mainBackground, x, y)

    local x, y = love.mouse.getPosition()

    -- Title
    love.graphics.setColor(250, 200, -59)
    love.graphics.setNewFont(titleFont, 40)
    love.graphics.printf('PoKéGotchi', 0, 10, love.graphics.getWidth(), 'center')
    
    -- Subtitle (Name of Pokemon)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setNewFont(pixelFont, 20)
    love.graphics.print('TYPE THE NAME OF', 10, 100)
    love.graphics.print('YOUR NEW POKÉ', 10, 125)    

    -- Name of New Pokemon
    love.graphics.print('/ ' .. nameNewPokemon, 10, 200)

    -- Back to Menu
    love.graphics.print('BACK', 40, love.graphics.getHeight() - 30)

    local f = love.graphics.getFont()
    fwBack = f:getWidth('BACK')
    fhBack = f:getHeight()

    -- Confirm Action
    if nameNewPokemon ~= nil and nameNewPokemon ~= '' then
        local f = love.graphics.getFont()
        fwCreate = f:getWidth('CREATE')
        fhCreate = f:getHeight()

        love.graphics.print('CREATE', love.graphics.getWidth() - fwCreate - 40, love.graphics.getHeight() - 30)
    end
    
    -- Function to Click in Slots/New Poke
    function love.mousepressed( z, y, button )
        if y >= love.graphics.getHeight() - 30 and y <= love.graphics.getHeight() - 30 + fhBack and x >= 40 and x <= 40 + fwBack then
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))
            gameState = 'choosePokemon'
        elseif nameNewPokemon ~= nil and nameNewPokemon ~= '' and y >= love.graphics.getHeight() - 30 and y <= love.graphics.getHeight() - 30 + fhCreate and x >= love.graphics.getWidth() - fwCreate - 40 and x <= love.graphics.getWidth() - fwCreate - 40 + fwCreate then
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))

            game:addPokemon(nameNewPokemon)
            game:setCurrentPokemon(table.getn(game.pokemons))
            love.filesystem.write('data.lua', game:saveInFile())

            gameState = "gameMainPage"
        end
    end

    -- Change Mouse Cursor
    if y >= love.graphics.getHeight() - 30 and y <= love.graphics.getHeight() - 30 + fhBack and x >= 40 and x <= 40 + fwBack then
        love.mouse.setCursor(cursor)
    elseif nameNewPokemon ~= nil and nameNewPokemon ~= '' and y >= love.graphics.getHeight() - 30 and y <= love.graphics.getHeight() - 30 + fhCreate and x >= love.graphics.getWidth() - fwCreate - 40 and x <= love.graphics.getWidth() - fwCreate - 40 + fwCreate then
        love.mouse.setCursor(cursor)
    else love.mouse.setCursor() end
    
    -- Get the name of new Pokémon
    function love.textinput( t )
        nameNewPokemon = nameNewPokemon .. t
    end

    function love.keypressed( key )
        if key == 'backspace' then
            nameNewPokemon = nameNewPokemon:sub(1, -2)
        elseif key == 'return' and nameNewPokemon ~= nil and nameNewPokemon ~= '' then
            love.audio.play(love.audio.newSource(love.sound.newSoundData(actionSound)))

            game:addPokemon(nameNewPokemon)
            game:setCurrentPokemon(table.getn(game.pokemons))
            love.filesystem.write('data.lua', game:saveInFile())

            gameState = "gameMainPage"
        end
     end
end

function drawGameMainPage()

end

function changeMainBackground( dt )
    mainBackground = love.graphics.newImage('/assets/background/' .. tonumber(string.format('%.0f', timer)) % 20 + 1 .. '.png')
end