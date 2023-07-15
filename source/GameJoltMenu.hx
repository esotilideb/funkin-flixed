package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxBackdrop;

import GameJolt;
import GameJolt.GameJoltAPI;

using StringTools;

class GameJoltMenu extends MusicBeatState
{
	public static var psychEngineVersion:String = 'nose, esto es una dev build'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'awards',
		'gamejolt',
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var bg:FlxSprite;
	var debugKeys:Array<FlxKey>;
	public static var isZatekSong:Bool = false;

	//mouse!!!
	override function create()
	{
		FlxG.mouse.visible = true;
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		GameJoltAPI.connect();
		GameJoltAPI.authDaUser(FlxG.save.data.gjUser, FlxG.save.data.gjToken);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Choosing something...", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var abg = new FlxBackdrop(Paths.image('menuBG'), #if (flixel < "5.0.0") 1, 1, true, true, #else XY, #end FlxG.random.int(-25, 5), 0);
		abg.screenCenter();
  		abg.scrollFactor.set();
		abg.color = FlxColor.GREEN;
  		abg.velocity.set(-100, -100);
  		abg.antialiasing = ClientPrefs.globalAntialiasing;
  		add(abg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
	//		menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();

			switch (i)
			{
				case 0: //story mode
				menuItem.setPosition(700,100);	
				case 1: //credits
				menuItem.setPosition(100,100);	

			}
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "pene " + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;
	var canClick:Bool = true;
	var usingMouse:Bool = false;

	var timerThing:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		menuItems.forEach(function(spr:FlxSprite)
			{
				if(usingMouse)
				{
					if(!FlxG.mouse.overlaps(spr))
						FlxTween.tween(spr, {x: spr.x}, 1, {ease: FlxEase.quartInOut});
				}
		
				if (FlxG.mouse.overlaps(spr))
				{
					if(canClick)
					{
						curSelected = spr.ID;
						usingMouse = true;
						spr.animation.play('selected');
						FlxTween.tween(spr, {x: spr.x}, 1, {ease: FlxEase.quartInOut});
					}
						
					if(FlxG.mouse.pressed && canClick)
					{
						selectSomething();
					}
				}
		
				spr.updateHitbox();
			});

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				selectSomething();
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new GameJoltLogin());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
		//	spr.screenCenter(X);
		});
	}

	function selectSomething()
		{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				
				canClick = false;
	
				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {y: spr.y + 900}, 0.7, {ease: FlxEase.quadInOut});
						FlxG.camera.fade(FlxColor.BLACK, 0.7, false);
						FlxTween.tween(spr, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxTween.tween(spr, {y: spr.y + 900}, 0.7, {ease: FlxEase.quadInOut});
						FlxG.camera.fade(FlxColor.BLACK, 0.7, false);
						new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								goToState();
							});
					}
				});
		}
		function goToState()
		{
			var daChoice:String = optionShit[curSelected];
	
			switch (daChoice)
			{
				case 'awards':
				MusicBeatState.switchState(new GameJoltAwards());
				case 'gamejolt':
					LoadingState.loadAndSwitchState(new GameJoltLogin());
			}		
		}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
//				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
