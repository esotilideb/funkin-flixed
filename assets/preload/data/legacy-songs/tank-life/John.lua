--Script por ItsCapp Por favor no robar , eso es tonto
--Traduccion por Ninja-Lex 

--Nombres de archivos y de flechas indivuduales o Juntas
name_of_character_xml = 'John 3' -- Nombre del Xml y sprite
name_of_character = 'john3' -- Nombre que le pondras al personaje
name_of_notetype = 'solo' -- Nombre de su flecha individual
name_of_notetype2 = 'duo' --Nombre de la flecha cantando con Oponente principal
name_of_notetype3 = 'All' --Todos cantan
-- Nombre de la flecha de las flechas alternativas (para usarlo borra de abajo '--')
--altnotetype = '' 
-- Nombre de la flehca de las flechas alternativas 2 (para usarlo borra de abajo '--')
--altnotetype2 = '' 

--En true estara encima de Dad , GF y BF, en false estara detras de los antes mencionados
foreground = false
--Para usar la funcion de capas , foreground debe estar en false y borrar los dos '--' de abajo y de la linea 112 (o del -- setObjectOrder(John3,Capa); que esta abajo)
Capa = 6
-- Cuando esta en true el personaje estara mirando a la izquierda , en false estara mirando a la derecha
playablecharacter = true 

-- Aqui pones los nombres de animacion de felchas de tu Personaje.xml
idle_xml_name = 'John Idle Dance'
left_xml_name = 'John Left Note'
down_xml_name = 'John Down Note'
up_xml_name = 'John Up Note'
right_xml_name = 'John Right Note'

--Trabaja casi exactamente como el editor de character del PeFNF(Psych engine)
--Por lo general se recomienda que este en 0 , pero si tu sprite no esta alineado con los mismo tamaños de cuadros
--Usa de referencia el .json de tu personaje ya porteado de PeFnf 
idleoffsets = {'0', '0'} --(Por lo general se deja en 0, pero si lo requiero lo cambias)
leftoffsets = {'130', '0'}
downoffsets = {'50', '-190'}
upoffsets = {'0', '10'}
rightoffsets = {'-70', '100'}

-- Aqui pones los nombres de animacion de Falla de tu Personaje.xml
left_miss_xml_name = 'left miss'  
down_miss_xml_name = 'down miss'   --
up_miss_xml_name = 'up miss'       --
right_miss_xml_name = 'right miss' --

--Lo mismo de arriba pero con las animciones de flechas fallidas (si las tiene tu personaje)(no es nesesario si no las tienes)
leftMissoffsets = {'0', '0'}  
downMissoffsets = {'0', '0'}  
upMissoffsets = {'0', '0'}    
rightMissoffsets = {'0', '0'} 

-- Aqui pones los nombres de animacion Alternativa de flechas de tu Personaje.xml
left_alt_xml_name = 'left alt'
down_alt_xml_name = 'down alt'
up_alt_xml_name = 'up alt'
right_alt_xml_name = 'right alt'

--Lo mismo de la primera , pero con las flechas alternativas(no es nesesario si no las tienes)
leftAltoffsets = {'0', '0'}
downAltoffsets = {'0', '0'}
upAltoffsets = {'0', '0'}
rightAltoffsets = {'0', '0'}

--Posicion de tu Personaje
x_position = 2950
y_position = 580

--Scale o Tamaño (normal: 1) puedes subirlo con 0.1 o reducirlo(Ejemplos: 1.1 ,2.2,1.7,0.7,7.0,2)
xScale = 0.9 --ancho
yScale = 0.9 --alto

--Personaje invisible (Basicamente se utiliza para el evento de personajeBG change character, Nesecitas que el segundo este en invisible:true y el primero en invisible:false)
invisible = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

doIdle = true

function onCreate()
	makeAnimatedLuaSprite(name_of_character, 'characters/' .. name_of_character_xml, x_position, y_position);

	addAnimationByPrefix(name_of_character, 'idle', idle_xml_name, 24, true);
	addAnimationByPrefix(name_of_character, 'singLEFT', left_xml_name, 24, false);
	addAnimationByPrefix(name_of_character, 'singDOWN', down_xml_name, 24, false);
	addAnimationByPrefix(name_of_character, 'singUP', up_xml_name, 24, false);
	addAnimationByPrefix(name_of_character, 'singRIGHT', right_xml_name, 24, false);

	addAnimationByPrefix(name_of_character, 'singLEFTmiss', left_miss_xml_name, 24, false);
    addAnimationByPrefix(name_of_character, 'singDOWNmiss', down_miss_xml_name, 24, false);
    addAnimationByPrefix(name_of_character, 'singUPmiss', up_miss_xml_name, 24, false);
    addAnimationByPrefix(name_of_character, 'singRIGHTmiss', right_miss_xml_name, 24, false);

	addAnimationByPrefix(name_of_character, 'singLEFT-alt', left_alt_xml_name, 24, false);
    addAnimationByPrefix(name_of_character, 'singDOWN-alt', down_alt_xml_name, 24, false);
    addAnimationByPrefix(name_of_character, 'singUP-alt', up_alt_xml_name, 24, false);
    addAnimationByPrefix(name_of_character, 'singRIGHT-alt', right_alt_xml_name, 24, false);

	if playablecharacter == true then
		setPropertyLuaSprite(name_of_character, 'flipX', fals);
	else
		setPropertyLuaSprite(name_of_character, 'flipX', false);
	end

	scaleObject(name_of_character, xScale, yScale);


	objectPlayAnimation(name_of_character, 'idle');
	addLuaSprite(name_of_character, foreground);

	if invisible == true then
		setPropertyLuaSprite(name_of_character, 'alpha', 0)
	end
 setObjectOrder(john3,10);
end

local singAnims = {"singLEFT", "singDOWN", "singUP", "singRIGHT"}
local altAnims ={"singLEFT-alt", "singDOWN-alt", "singUP-alt", "singRIGHT-alt"}
function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == name_of_notetype or noteType == name_of_notetype2 then
		doIdle = false
		objectPlayAnimation(name_of_character, singAnims[direction + 1], false);

		if direction == 0 then
			setProperty(name_of_character .. '.offset.x', leftoffsets[1]);
			setProperty(name_of_character .. '.offset.y', leftoffsets[2]);

			if isSustainNote then
				objectPlayAnimation(name_of_character, singAnims[direction + 1], true);
			end
		elseif direction == 1 then
			setProperty(name_of_character .. '.offset.x', downoffsets[1]);
			setProperty(name_of_character .. '.offset.y', downoffsets[2]);

			if isSustainNote then
				objectPlayAnimation(name_of_character, singAnims[direction + 1], true);
			end
		elseif direction == 2 then
			setProperty(name_of_character .. '.offset.x', upoffsets[1]);
			setProperty(name_of_character .. '.offset.y', upoffsets[2]);

			if isSustainNote then
				objectPlayAnimation(name_of_character, singAnims[direction + 1], true);
			end
		elseif direction == 3 then
			setProperty(name_of_character .. '.offset.x', rightoffsets[1]);
			setProperty(name_of_character .. '.offset.y', rightoffsets[2]);

			if isSustainNote then
				objectPlayAnimation(name_of_character, singAnims[direction + 1], true);
			end
		end
	end
if noteType == name_of_notetype or noteType == name_of_notetype3 then
		doIdle = false
		objectPlayAnimation(name_of_character, singAnims[direction + 1], false);

		if direction == 0 then
			setProperty(name_of_character .. '.offset.x', leftoffsets[1]);
			setProperty(name_of_character .. '.offset.y', leftoffsets[2]);

			if isSustainNote then
				objectPlayAnimation(name_of_character, singAnims[direction + 1], true);
			end
		elseif direction == 1 then
			setProperty(name_of_character .. '.offset.x', downoffsets[1]);
			setProperty(name_of_character .. '.offset.y', downoffsets[2]);

			if isSustainNote then
				objectPlayAnimation(name_of_character, singAnims[direction + 1], true);
			end
		elseif direction == 2 then
			setProperty(name_of_character .. '.offset.x', upoffsets[1]);
			setProperty(name_of_character .. '.offset.y', upoffsets[2]);

			if isSustainNote then
				objectPlayAnimation(name_of_character, singAnims[direction + 1], true);
			end
		elseif direction == 3 then
			setProperty(name_of_character .. '.offset.x', rightoffsets[1]);
			setProperty(name_of_character .. '.offset.y', rightoffsets[2]);

			if isSustainNote then
				objectPlayAnimation(name_of_character, singAnims[direction + 1], true);
			end
		end
	end
	if noteType == altnotetype or noteType == altnotetype2 then
        doIdle = false
        objectPlayAnimation(name_of_character, altAnims[direction + 1], true);

        if direction == 0 then
            setProperty(name_of_character .. '.offset.x', leftAltoffsets[1]);
            setProperty(name_of_character .. '.offset.y', leftAltoffsets[2]);

            if isSustainNote then
                objectPlayAnimation(name_of_character, altAnims[direction + 1], true);
            end
        elseif direction == 1 then
            setProperty(name_of_character .. '.offset.x', dowAltnoffsets[1]);
            setProperty(name_of_character .. '.offset.y', downAltoffsets[2]);

            if isSustainNote then
                objectPlayAnimation(name_of_character, altAnims[direction + 1], true);

            end
        elseif direction == 2 then
            setProperty(name_of_character .. '.offset.x', upAltoffsets[1]);
            setProperty(name_of_character .. '.offset.y', upAltoffsets[2]);

            if isSustainNote then
                objectPlayAnimation(name_of_character, altAnims[direction + 1], true);
            end
        elseif direction == 3 then
            setProperty(name_of_character .. '.offset.x', rightAltoffsets[1]);
            setProperty(name_of_character .. '.offset.y', rightAltoffsets[2]);

            if isSustainNote then
                objectPlayAnimation(name_of_character, altAnims[direction + 1], true);
            end
        end
    end
end

-- I know this is messy, but it's the only way I know to make it work on both sides.
local singAnims = {"singLEFT", "singDOWN", "singUP", "singRIGHT"}
local altAnims ={"singLEFT-alt", "singDOWN-alt", "singUP-alt", "singRIGHT-alt"}
function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == name_of_notetype or noteType == name_of_notetype2 then
		doIdle = false
		objectPlayAnimation(name_of_character, singAnims[direction + 1], false);

		if direction == 0 then
			setProperty(name_of_character .. '.offset.x', leftoffsets[1]);
			setProperty(name_of_character .. '.offset.y', leftoffsets[2]);
		elseif direction == 1 then
			setProperty(name_of_character .. '.offset.x', downoffsets[1]);
			setProperty(name_of_character .. '.offset.y', downoffsets[2]);
		elseif direction == 2 then
			setProperty(name_of_character .. '.offset.x', upoffsets[1]);
			setProperty(name_of_character .. '.offset.y', upoffsets[2]);
		elseif direction == 3 then
			setProperty(name_of_character .. '.offset.x', rightoffsets[1]);
			setProperty(name_of_character .. '.offset.y', rightoffsets[2]);
		end
	end
if noteType == name_of_notetype or noteType == name_of_notetype3 then
		doIdle = false
		objectPlayAnimation(name_of_character, singAnims[direction + 1], false);

		if direction == 0 then
			setProperty(name_of_character .. '.offset.x', leftoffsets[1]);
			setProperty(name_of_character .. '.offset.y', leftoffsets[2]);
		elseif direction == 1 then
			setProperty(name_of_character .. '.offset.x', downoffsets[1]);
			setProperty(name_of_character .. '.offset.y', downoffsets[2]);
		elseif direction == 2 then
			setProperty(name_of_character .. '.offset.x', upoffsets[1]);
			setProperty(name_of_character .. '.offset.y', upoffsets[2]);
		elseif direction == 3 then
			setProperty(name_of_character .. '.offset.x', rightoffsets[1]);
			setProperty(name_of_character .. '.offset.y', rightoffsets[2]);
		end
	end
	if noteType == altnotetype or noteType == altnotetype2 then
        doIdle = false
        objectPlayAnimation(name_of_character, altAnims[direction + 1], true);

        if direction == 0 then
            setProperty(name_of_character .. '.offset.x', leftAltoffsets[1]);
            setProperty(name_of_character .. '.offset.y', leftAltoffsets[2]);

            if isSustainNote then
                objectPlayAnimation(name_of_character, altAnims[direction + 1], true);
            end
        elseif direction == 1 then
            setProperty(name_of_character .. '.offset.x', dowAltnoffsets[1]);
            setProperty(name_of_character .. '.offset.y', downAltoffsets[2]);

            if isSustainNote then
                objectPlayAnimation(name_of_character, altAnims[direction + 1], true);

            end
        elseif direction == 2 then
            setProperty(name_of_character .. '.offset.x', upAltoffsets[1]);
            setProperty(name_of_character .. '.offset.y', upAltoffsets[2]);

            if isSustainNote then
                objectPlayAnimation(name_of_character, altAnims[direction + 1], true);
            end
        elseif direction == 3 then
            setProperty(name_of_character .. '.offset.x', rightAltoffsets[1]);
            setProperty(name_of_character .. '.offset.y', rightAltoffsets[2]);

            if isSustainNote then
                objectPlayAnimation(name_of_character, altAnims[direction + 1], true);
            end
        end
    end
end

local missAnims = {"singLEFTmiss", "singDOWNmiss", "singUPmiss", "singRIGHTmiss"}
function noteMiss(id, direction, noteType, isSustainNote)
    if noteType == name_of_notetype or noteType == name_of_notetype2 then
        doIdle = false
        objectPlayAnimation(name_of_character, missAnims[direction + 1], true);
        if direction == 0 then
            setProperty(name_of_character .. '.offset.x', leftMissoffsets[1]);
            setProperty(name_of_character .. '.offset.y', leftMissoffsets[2]);
            if isSustainNote then
                objectPlayAnimation(name_of_character, missAnims[direction + 1], true);
            end
        elseif direction == 1 then
            setProperty(name_of_character .. '.offset.x', downMissoffsets[1]);
            setProperty(name_of_character .. '.offset.y', downMissoffsets[2]);
            if isSustainNote then
                objectPlayAnimation(name_of_character, missAnims[direction + 1], true);
            end
        elseif direction == 2 then
            setProperty(name_of_character .. '.offset.x', upMissoffsets[1]);
            setProperty(name_of_character .. '.offset.y', upMissoffsets[2]);
            if isSustainNote then
                objectPlayAnimation(name_of_character, missAnims[direction + 1], true);
            end
        elseif direction == 3 then
            setProperty(name_of_character .. '.offset.x', rightMissoffsets[1]);
            setProperty(name_of_character .. '.offset.y', rightMissoffsets[2]);
            if isSustainNote then
                objectPlayAnimation(name_of_character, missAnims[direction + 1], true);
            end
        end
    end
end
if noteType == name_of_notetype or noteType == name_of_notetype3 then
        doIdle = false
        objectPlayAnimation(name_of_character, missAnims[direction + 1], true);
        if direction == 0 then
            setProperty(name_of_character .. '.offset.x', leftMissoffsets[1]);
            setProperty(name_of_character .. '.offset.y', leftMissoffsets[2]);
            if isSustainNote then
                objectPlayAnimation(name_of_character, missAnims[direction + 1], true);
            end
        elseif direction == 1 then
            setProperty(name_of_character .. '.offset.x', downMissoffsets[1]);
            setProperty(name_of_character .. '.offset.y', downMissoffsets[2]);
            if isSustainNote then
                objectPlayAnimation(name_of_character, missAnims[direction + 1], true);
            end
        elseif direction == 2 then
            setProperty(name_of_character .. '.offset.x', upMissoffsets[1]);
            setProperty(name_of_character .. '.offset.y', upMissoffsets[2]);
            if isSustainNote then
                objectPlayAnimation(name_of_character, missAnims[direction + 1], true);
            end
        elseif direction == 3 then
            setProperty(name_of_character .. '.offset.x', rightMissoffsets[1]);
            setProperty(name_of_character .. '.offset.y', rightMissoffsets[2]);
            if isSustainNote then
                objectPlayAnimation(name_of_character, missAnims[direction + 1], true);
            end
        end
    end


 
function onBeatHit()
	-- triggered 4 times per section
	if curBeat % 2 == 0  and doIdle then
		objectPlayAnimation(name_of_character, 'idle');
		setProperty(name_of_character .. '.offset.x', idleoffsets[1]);
		setProperty(name_of_character .. '.offset.y', idleoffsets[2]);
	end
	doIdle = true
end

function onCountdownTick(counter)
	-- counter = 0 -> "Three"
	-- counter = 1 -> "Two"
	-- counter = 2 -> "One"
	-- counter = 3 -> "Go!"
	-- counter = 4 -> Nothing happens lol, tho it is triggered at the same time as onSongStart i think
	if counter % 2 == 0 then
		if doIdle == true then
			objectPlayAnimation(name_of_character, 'idle');
			setProperty(name_of_character .. '.offset.x', idleoffsets[1]);
			setProperty(name_of_character .. '.offset.y', idleoffsets[2]);
		end
	end
end