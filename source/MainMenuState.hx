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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
import Achievements;
import flixel.util.FlxTimer;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import GameJolt;
import GameJolt.GameJoltAPI;

import GameJolt.GameJoltLogin;

using StringTools;

class MainMenuState extends MusicBeatState
{

	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var gamejolt:FlxSprite;
	
	var gallery:String = 'gallery'; //khe
	var abg:FlxBackdrop;

	override function create()
	{

		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		GameJoltAPI.connect();
		GameJoltAPI.authDaUser(FlxG.save.data.gjUser, FlxG.save.data.gjToken);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Main Menu.", null);
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

		var cosa = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, 0x8e70ff);
		cosa.screenCenter();
		add(cosa);

		var abg = new FlxBackdrop(Paths.image('menuBG'));
		abg.screenCenter();
  		abg.scrollFactor.set();
  		abg.velocity.set(-100, -100);
		add(abg);

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('triangulos'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		/*gallery = new FlxSprite(1100, 500);
		gallery.frames = Paths.getSparrowAtlas('mainmenu/menu_gallery');
		//gallery.screenCenter(X);
		gallery.scrollFactor.set(0);
		gallery.setGraphicSize(Std.int(gallery.width * 0.8));
		gallery.antialiasing = false;
		gallery.animation.addByPrefix('idle', 'Galeria', 10, true); //nothing
		gallery.animation.addByPrefix('selected', 'Galeria Select', 10, true); //mushroom
		gallery.animation.play('idle');
		add(gallery);	*/

		gamejolt = new FlxSprite(1100, 0);
		gamejolt.frames = Paths.getSparrowAtlas('mainmenu/Gamejolt');
		//gamejolt.screenCenter(X);
		gamejolt.scrollFactor.set(0);
		gamejolt.antialiasing = false;
		gamejolt.animation.addByPrefix('idle', 'Gamejolt idle', 10, true); //nothing
	//	gamejolt.animation.addByPrefix('selected', 'Gamejolt Select', 10, true); //mushroom
		gamejolt.animation.play('idle');
		add(gamejolt);	

		if(ClientPrefs.isGalleryUnlocked){
			optionShit.push(gallery);
			trace('galeria añadida...');
		}

		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		if(optionShit.length > 5) {
			scale = 5 / optionShit.length;
		}

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(100, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 5) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;

			menuItem.updateHitbox();
			if (ClientPrefs.isGalleryUnlocked) 
			{
				switch (i)
				{
					case 0: //story
						menuItem.setPosition(100, 50);
					case 1: //freeplay
						menuItem.setPosition(100, 200);
					case 2: //credits
						menuItem.setPosition(100, 350);
					case 3: //options
						menuItem.setPosition(100, 500);
					case 4: //gallery
						menuItem.setPosition(800, 500);
				}
			}
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Funkin Flixed' v1", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

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
		FlxG.mouse.visible = true;
		if(usingMouse)
			{
				if(!FlxG.mouse.overlaps(gamejolt))
					gamejolt.animation.play('idle');

				/*if(!FlxG.mouse.overlaps(gallery))
					gallery.animation.play('idle');*/
			}
	
			if (FlxG.mouse.overlaps(gamejolt))
			{
				if(canClick)
				{
					curSelected = gamejolt.ID;
					usingMouse = true;
					gamejolt.animation.play('selected');
				}
					
				if(FlxG.mouse.pressed && canClick)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					if(ClientPrefs.flashing) FlxFlicker.flicker(gamejolt, 1.1, 0.15, false);
					new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							MusicBeatState.switchState(new GameJoltLogin());
						});
				}
			}

		/*	if (FlxG.mouse.overlaps(gallery))
				{
					if(canClick)
					{
						curSelected = gallery.ID;
						usingMouse = true;
					}
						
					if(FlxG.mouse.pressed && canClick)
					{
					//	gallery.animation.play('selected');
						FlxG.sound.play(Paths.sound('confirmMenu'));
						if(ClientPrefs.flashing) FlxFlicker.flicker(gallery, 1.1, 0.15, false);
						new FlxTimer().start(1.5, function(tmr:FlxTimer)
							{
								MusicBeatState.switchState(new GalleryState());
							});
					}
				}*/

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (FlxG.keys.justPressed.ONE)
				{
					ClientPrefs.isGalleryUnlocked = true;
					trace('chited fnf eyx ramapge');
				}
			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					//if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(FlxG.camera, {zoom: 2}, 1.1, {ease: FlxEase.expoIn});
							//thanks you fnf vs koi v4
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});








							
						}
						else
						{
							{
								
								var daChoice:String = optionShit[curSelected];

								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									case 'credits':
										MusicBeatState.switchState(new CreditsNewState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
									case 'gallery':
										MusicBeatState.switchState(new GalleryState());
								});
							}
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
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
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
