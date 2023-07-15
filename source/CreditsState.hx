package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;
	//text cosa
	var devmessage:FlxText;

	//portraits
	var optionShit:Array<String> = [
		'Champ',
		'Zozer',
		'Cabox',
		'Loxo Highnosecuanto',
		'Andree1x',
		'TheCapM',
		'CoconutMall',
		'Coferip',
		'Griveon'
	];
	var personajes:FlxSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		FlxG.camera.zoom = 2;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.1, {ease: FlxEase.expoOut});

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("¡The Awesome Credits!", null);
		#end

		persistentUpdate = true;

		personajes = new FlxSprite(0,0);
		personajes.loadGraphic(Paths.image('credits/portraits/' + optionShit[curSelected]));
		personajes.scrollFactor.set(0, 0);
		personajes.screenCenter(X);
		//personajes.setGraphicSize(Std.int(personajes.width * 1));
		personajes.antialiasing = ClientPrefs.globalAntialiasing;
		add(personajes);

		var abg = new FlxBackdrop(Paths.image('credits/bg'), #if (flixel < "5.0.0") 1, 1, true, true, #else XY, #end FlxG.random.int(-25, 5), 0);
		abg.screenCenter();
		abg.scrollFactor.set();
		abg.velocity.set(-100, -100);
		abg.antialiasing = ClientPrefs.globalAntialiasing;
		add(abg);

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.visible = false;
		add(bg);
		bg.screenCenter();
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if(leMods.length > 1 && leMods[0].length > 0) {
					var modSplit:Array<String> = leMods[i].split('|');
					if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if(modSplit[1] == '1')
							pushModCreditsToList(modSplit[0]);
						else
							modsAdded.push(modSplit[0]);
					}
				}
			}
		}

		var arrayOfFolders:Array<String> = Paths.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModCreditsToList(folder);
		}
		#end

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Dev Message - Link - BG Color
			['Flixed Team'],
			['Champ','Champ','Director and Main Artist', 'Esto es una prueba sobre el mensaje dev', 'https://twitter.com/Shadow_Mario_',	'444444'],
			['Zozer', 'zozer', 'Musican and ¿Artist?', 'Champ remasterizo los sprites\n 
			 40 veces ya duermanlo'],
			['Cabox', 'Cabox', 'Main Coder', '¡Waos!'],
			['Loxo Highscore', 'Loxo', 'Main Musican', 'nunca mas participo en un mod de fnf.\n 
			De los 10, este fue el unico\n 
			que salio, y fue un año despues.'],
			['Andree1x', 'Andree', 'Charter', 'buena poa ndre e'],
			['TheCapM', 'cap', 'Artist', 'waos2'],
			['CoconutMall', 'Coco', 'Voice Actor?', 'wawis2'],
			['Coferip', 'Cofe', 'Musican?, idk', 'erabrom a'],
			['Griveon', 'Griveon', 'Musican?, idk', 'waos']
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(300, 300, creditsStuff[i][0], !isSelectable);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.changeX = false;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][6] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][6];
				}

				var icon:AttachedSprite = new AttachedSprite('credits/icons/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
			else optionText.alignment = CENTERED;
		}
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		devmessage = new FlxText(300, 1800, 1180, "", 32);
		devmessage.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		devmessage.scrollFactor.set();
		//devmessage.borderSize = 2.4;
		descBox.sprTracker = devmessage;
		add(devmessage);

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;
						
				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{

					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][4] == null || creditsStuff[curSelected][3].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[curSelected][4]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.bold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					//item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x, lerpVal);
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 300 + -80 * Math.abs(item.targetY), lerpVal);
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int =  getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		devmessage.text = creditsStuff[curSelected][3];
		descText.y = FlxG.height - descText.height + offsetThing - 60;
		devmessage.y = FlxG.height - devmessage.height + offsetThing - 120;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});
		moveTween = FlxTween.tween(devmessage, {y : devmessage.y + -150}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModCreditsToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}