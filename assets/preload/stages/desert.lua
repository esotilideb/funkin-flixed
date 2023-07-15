function onCreate()
	-- x shit
	makeLuaSprite('Escenario', 'stages/desert/images/Escenario', 10, 125);
	setLuaSpriteScrollFactor('Escenario', 0.95, 1);
	scaleObject('Escenario', 1, 1);

	makeLuaSprite('MEdio', 'stages/desert/images/MEdio', 225, -225);
	setLuaSpriteScrollFactor('MEdio', 0.5, 0.5);
	scaleObject('MEdio', 0.8, 0.8);

	makeLuaSprite('boceto', 'stages/desert/images/boceto', 200, -300);
	setLuaSpriteScrollFactor('boceto', 0.8, 0);
	scaleObject('boceto', 1, 1);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	  addLuaSprite('boceto', false);
        addLuaSprite('MEdio', false);
        addLuaSprite('Escenario', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end