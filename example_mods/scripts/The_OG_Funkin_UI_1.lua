--Credits

--First og script Made by Shaggy#3760(Psych Engine server)
--Second script made by BombasticTom#0646 and another unknown guy
--Ratings in cam script made by Unholywanderer04
--BF Vanilla notes postion script by BombasticTom#0084
--Other lua scripts made by Steve The Creeper
--All lua scripts combined + edited by Steve The Creeper

--Options

local NoTextBorder = true --Removes the border from the score text like the OG game.

local SmolText = true --Makes the text smaller like the OG game.

local ScoreOffset = true --Adds the score offset from the OG game.

local MinimizedScoreInfo = true --Removes accuracy and misses

local HideSongPosition = false --Hides the song position bar.

windowNamevanilla = true -- if you want the window name to be the same as vanilla (basically removes ": Psych Engine" from the window name).

vanillaHealthcolors = true -- if you want the health colors to be the same as vanilla (red to dad, aka the one on the left; green to bf, aka the on the right).

noBOTPLAYtext = true -- removes the "BOTPLAY" watermark when botplay is enabled.

--Script Code

function onCreatePost()          
  if HideSongPosition then
    setProperty('timeBarBG.visible', false)
    setProperty('timeBar.visible', false)
    setProperty('timeTxt.visible', false)
  end

  if MinimizedScoreInfo then
   setTextString('scoreTxt', 'Score:'..score) 
  end

  if ScoreOffset then
    setProperty('scoreTxt.x', 280)
  end

  if SmolText then
    scaleObject('scoreTxt', 0.815, 0.815)
  end
 
   if NoTextBorder then
     setTextBorder('scoreTxt', false)
  end

   if windowNamevanilla then
		   setPropertyFromClass('lime.app.Application', 'current.window.title', "Funkin Flixed - Adobe Flash Player")
  end

    if vanillaHealthcolors then
		   setHealthBarColors('ff0000', '66FF33') 
  end

   if noBOTPLAYtext then
		   setProperty('botplayTxt.visible', false)	
	  end

function onEvent(n, v1, v2)
	if n == 'Change Character' then
		if vanillaHealthColors then setHealthBarColors('FF0000', '66FF33') end

	    setTextFont("scoreTxt", "waos.ttf");

	end
end

end

--Icon Beat Stuff

function onBeatHit()
	scaleObject('iconP1', 1.2, 1.2)
	doTweenX('iconP1', 'iconP1.scale', 1, crochet/1000, 'circOut')
	doTweenY('iconP1-2', 'iconP1.scale', 1, crochet/1000, 'circOut')
	
	scaleObject('iconP2', 1.2, 1.2)
	doTweenX('iconP2', 'iconP2.scale', 1, crochet/1000, 'circOut')
	doTweenY('iconP2-2', 'iconP2.scale', 1, crochet/1000, 'circOut')
end

function onUpdate(elasped)

iconOffset = 26
healthBarX = getProperty('healthBar.x')
healthBarW = getProperty('healthBar.width')
healthBarP = getProperty('healthBar.percent')

setGraphicSize('iconP1',math.lerp(150,getProperty('iconP1.width'), 0.50))
setProperty('iconP1.x', healthBarX + (healthBarW * (math.remapToRange(healthBarP, 0, 100, 100, 0) * 0.01) - iconOffset));

setGraphicSize('iconP2',math.lerp(150,getProperty('iconP1.width'), 0.50))
setProperty('iconP2.x', healthBarX + (healthBarW * (math.remapToRange(healthBarP, 0, 100, 100, 0) * 0.01) - iconOffset));

updateHitbox('iconP1')
updateHitbox('iconP2')
end

--For after a note has been pressed

function onUpdatePost()
  
  if MinimizedScoreInfo then
   setTextString('scoreTxt', 'Score:'..score)
  end

  if ScoreOffset then
    setProperty('scoreTxt.x', 280) 
  end 
   
  if SmolText then
   scaleObject('scoreTxt', 0.815, 0.815)
  end
  
  if NoTextBorder then
   setTextBorder('scoreTxt', false)
  end

end

--Getting score even if botplay is on

function goodNoteHit(index, nData, nType, sustain)
if botPlay and not sustain then
addScore(350)
end
end

--Dad goes idle when cam focus is on bf

function onMoveCamera(focus) if focus == 'boyfriend' then characterDance('dad') end end