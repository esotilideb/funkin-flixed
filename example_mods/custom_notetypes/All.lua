function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Allsing' then --Nombre de la flecha
			--setPropertyFromGroup('unspawnNotes', i, 'texture', 'notetexture'); --Change notetexture
			--setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0);
			--setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', -20);
			--setPropertyFromGroup('unspawnNotes', i, 'noteSplashBrt', 1);

			setPropertyFromGroup('unspawnNotes', i, '', true); -- make it so original character doesn't sing these notes

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has penalties
			end
		end
	end
end