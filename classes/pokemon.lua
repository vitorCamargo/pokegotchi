module(..., package.seeall)

function new( onSelf, name, image, createdAt, lastLogTime, happiness, energy, healthiness, dirt, hunger, sleeping, foods, medicines )
    local pokemon = {}

    pokemon.image = image or '132.png'
    pokemon.name = name or 'Beneditto'
    pokemon.createdAt = createdAt or os.time()
    pokemon.lastLogTime = lastLogTime or os.time()

    pokemon.happiness = happiness or 100
    pokemon.energy = energy or 100
    pokemon.healthiness = healthiness or 100
    pokemon.dirt = dirt or 0
    pokemon.hunger = hunger or 0
    
    pokemon.foods = foods or 20
    pokemon.medicines = medicines or 20

    pokemon.sleeping = sleeping or false

    function pokemon:eat()
        pokemon.foods = pokemon.foods - 1
        pokemon:setHunger(pokemon.hunger - 10)
    end

    function pokemon:takeMedicine()
        pokemon.medicines = pokemon.medicines - 1
        pokemon:setHealthiness(pokemon.healthiness + 10)
    end

    function pokemon:takeBath()
        pokemon:setDirt(pokemon.dirt - 10)
    end

    function pokemon:setImage( image )
        pokemon.image = image
    end

    function pokemon:setHappiness( happiness )
        if happiness >= 100 then
            pokemon.happiness = 100
        elseif happiness <= 0 then
            pokemon.happiness = 0
        else
            pokemon.happiness = happiness
        end
    end

    function pokemon:setEnergy( energy )
        if energy >= 100 then
            pokemon.energy = 100
        elseif energy <= 0 then
            pokemon.energy = 0
        else
            pokemon.energy = energy
        end
    end

    function pokemon:setHealthiness( healthiness )
        if healthiness >= 100 then
            pokemon.healthiness = 100
        elseif healthiness <= 0 then
            pokemon.healthiness = 0
        else
            pokemon.healthiness = healthiness
        end
    end

    function pokemon:setDirt( dirt )
        if dirt >= 100 then
            pokemon.dirt = 100
        elseif dirt <= 0 then
            pokemon.dirt = 0
        else
            pokemon.dirt = dirt
        end
    end

    function pokemon:setHunger( hunger )
        if hunger >= 100 then
            pokemon.hunger = 100
        elseif hunger <= 0 then
            pokemon.hunger = 0
        else
            pokemon.hunger = hunger
        end
    end

    function pokemon:setSleeping( sleeping )
        pokemon.sleeping = sleeping
    end

    function pokemon:updateStats()
        local now = os.time()
        local deltaTimeSeconds = now - pokemon.lastLogTime
        math.randomseed(now)

        if deltaTimeSeconds > 0 then
            pokemon.lastLogTime = now

            local deltaTimeHours = deltaTimeSeconds/3600
            pokemon:setHappiness(pokemon.happiness - ((math.random(20, 80)/10) * deltaTimeHours))
            pokemon:setHealthiness(pokemon.healthiness - ((math.random(5, 15)/10) * deltaTimeHours))
            pokemon:setDirt(pokemon.dirt + ((math.random(30, 90)/10) * deltaTimeHours))
            pokemon:setHunger(pokemon.hunger + ((math.random(30, 80)/10) * deltaTimeHours))

            if pokemon:isSleeping() == 'true' then
                pokemon:setEnergy(pokemon.energy + (8 * deltaTimeHours))
            else
                pokemon:setEnergy(pokemon.energy - ((math.random(10, 40)/10) * deltaTimeHours))
            end

            status = pokemon:getCurrentStatus()
        end
    end

    function pokemon:getCurrentStatus()
        local status = {}

        if pokemon:isSad() then status[table.getn(status) + 1] = 'sad' end
        if pokemon:isTired() then status[table.getn(status) + 1] = 'tired' end
        if pokemon:isSick() then status[table.getn(status) + 1] = 'sick' end
        if pokemon:isDirty() then status[table.getn(status) + 1] = 'dirty' end
        if pokemon:isHungry() then status[table.getn(status) + 1] = 'hungry' end

        return status
    end

    function pokemon:saveInFile()
        return pokemon.name .. ';' .. pokemon.image .. ';' .. pokemon.createdAt .. ';' .. pokemon.lastLogTime .. ';' .. pokemon.happiness .. ';' .. pokemon.energy .. ';' .. pokemon.healthiness .. ';' .. pokemon.dirt .. ';' .. pokemon.hunger .. ';' .. string.format('%s', tostring(pokemon.sleeping)) .. ';' .. pokemon.foods .. ';' .. pokemon.medicines .. ';'
    end

    function pokemon:isSleeping()
        return pokemon.sleeping
    end

    function pokemon:isSad()
        if pokemon.happiness < 35 then
            return true
        else
            return false
        end
    end

    function pokemon:isTired()
        if pokemon.energy < 20 then
            return true
        else
            return false
        end
    end

    function pokemon:isSick()
        if pokemon.healthiness < 40 then
            return true
        else
            return false
        end
    end

    function pokemon:isDirty()
        if pokemon.dirt > 70 then
            return true
        else
            return false
        end
    end

    function pokemon:isHungry()
        if pokemon.hunger > 80 then
            return true
        else
            return false
        end
    end

    return pokemon
end