module(..., package.seeall)

local pokemon = require('classes/pokemon')

function new()
    local game = {}

    game.pokemons = {}
    game.currentPokemon = nil

    function game:getCurrentPokemon()
        if not game.currentPokemon then
            return nil
        else
            return game.pokemons[game.currentPokemon]
        end
    end

    function game:addPokemon( name, image, createdAt, lastLogTime, happiness, energy, healthiness, dirt, hunger, sleeping, foods, medicines )
        game.pokemons[table.getn(game.pokemons) + 1] = pokemon.new('', name, image, createdAt, lastLogTime, happiness, energy, healthiness, dirt, hunger, sleeping, foods, medicines)
    end

    function game:removePokemon( index )
        table.remove(game.pokemons, index)
    end

    function game:saveInFile()
        file = ''
        for i = 1, table.getn(game.pokemons), 1 do
            file = file .. game.pokemons[i]:saveInFile()
            if i ~= table.getn(game.pokemons) then file = file .. '\n' end
        end

        return file
    end

    function game:setCurrentPokemon( currentPokemon )
        game.currentPokemon = currentPokemon
    end

    return game
end