function onCreate()
	-- x shit
	makeLuaSprite('bg', 'stages/Sex/images/bg', -1000, -300);
	setLuaSpriteScrollFactor('bg', 1, 1);
	scaleObject('bg', 2, 2)

	makeLuaSprite('Poster', 'stages/Sex/images/Posters', -225, 125);
	setLuaSpriteScrollFactor('Poster', 0.5, 0.5);
	scaleObject('Poster', 1.2, 1.2);

	makeLuaSprite('Cartel', 'stages/Sex/images/Cartel', -125, 225);
	setLuaSpriteScrollFactor('Cartel', 0.5, 0.5);
	scaleObject('Cartel', 1.5, 1.5);

	makeAnimatedLuaSprite('T41ng', 'stages/Sex/images/T41ng', 425, 425);
	setLuaSpriteScrollFactor('T41ng', 0.7, 0.7);
	addAnimationByPrefix('T41ng', 't41ing', 't41ing', 14, true);
	scaleObject('T41ng', 1, 1);

	makeLuaSprite('Cartel', 'stages/Sex/images/piedras', 650, 890);
	setLuaSpriteScrollFactor('piedras', 1, 1);
	scaleObject('Cartel', 1, 1);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

        addLuaSprite('bg', false);
        addLuaSprite('Poster', false);
        addLuaSprite('Cartel', false);
        addLuaSprite('T41ng', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end