function onCreate()
	-- x shit
	makeLuaSprite('Escenario', 'stages/desertnight/images/Escenario', 10, 25);
	setLuaSpriteScrollFactor('Escenario', 0.9, 0.9);
	scaleObject('Escenario', 1, 1);

	makeLuaSprite('MEdio', 'stages/desertnight/images/MEdio', 225, -225);
	setLuaSpriteScrollFactor('MEdio', 0.5, 0.5);
	scaleObject('MEdio', 0.8, 0.8);

	makeLuaSprite('boceto', 'stages/desertnight/images/boceto', 200, -300);
	setLuaSpriteScrollFactor('boceto', 0.8, 0);
	scaleObject('boceto', 1, 1);

	makeLuaSprite('sombra', 'stages/desertnight/images/sombra', -360, -135);
	setLuaSpriteScrollFactor('sombra', 0, 0);
	scaleObject('sombra', 1, 1);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	  addLuaSprite('boceto', false);
        addLuaSprite('MEdio', false);
        addLuaSprite('Escenario', false);
        addLuaSprite('sombra', true);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end