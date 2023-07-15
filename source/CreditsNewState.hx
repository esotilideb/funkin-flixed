package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import flixel.sound.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import flixel.addons.display.FlxBackdrop;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class CreditsNewState extends MusicBeatState
{
	var songs:Array<SongMetadataTwo> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreBGtwo:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	public static var adioscap:Bool = false;

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;


	var t4ilskuus:FlxSprite;
	var holacap:FlxText; //perdoncap
	var cosa:Int = FlxG.random.int(0, 5);
	//como en eyx rampage digo
	//perdon capm...
	var personajes:FlxSprite;
	var optionShit:Array<String> = [
		'-¡Awesome and Cool Funkin Flixel Dev Team!-',
		'Champ',
		'Zozer',
		'Cabox',
		'Loxo Highscore',
		'Andree1x',
		'CoconutMall',
		'TheCapM',
		'Coferip',
		'Griveon'
	];
	var devmessage:FlxText;
	var message:FlxText;

	override function create()
	{
		trace(cheatedReference);
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		//BRO REALLY TOOK THE CODE FROM FREEPLAY AND CONVERT IT IN A CREDIT THING 💀
		addSong('-¡Awesome and Cool Funkin Flixel Dev Team!-', 1, '', FlxColor.fromRGB(255, 66, 200));
		addSong('Champ', 1, 'Champ', FlxColor.fromRGB(255, 66, 200));
        addSong('Zozer', 1, 'zozer', FlxColor.fromRGB(255, 66, 101));
        addSong('Cabox', 1, 'Cabox', FlxColor.fromRGB(255, 66, 101));
		addSong('Loxo Highscore', 1, 'Loxo', FlxColor.fromRGB(255, 66, 101));
		addSong('Andree1x', 1, 'Andree', FlxColor.fromRGB(255, 66, 101));
		addSong('CoconutMall', 1, 'Coco', FlxColor.fromRGB(255, 66, 101));
		addSong('TheCapM', 1, 'cap', FlxColor.fromRGB(255, 66, 101));
		addSong('Coferip', 1, 'Cofe', FlxColor.fromRGB(255, 66, 101));
		addSong('Griveon', 1, 'Griveon', FlxColor.fromRGB(255, 66, 101));

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/

		var abg = new FlxBackdrop(Paths.image('credits/bg'));
		abg.screenCenter();
		abg.scrollFactor.set();
		abg.velocity.set(-100, -100);
		add(abg);

		var degradado:FlxSprite = new FlxSprite(600, 0).loadGraphic(Paths.image('credits/cosaquerealmentenosecomollamar,algunaidea'));
		degradado.scrollFactor.set(0);
		degradado.updateHitbox();
		degradado.antialiasing = ClientPrefs.globalAntialiasing;
		add(degradado);

		personajes = new FlxSprite(0,0);
	 	personajes.loadGraphic(Paths.image('credits/portraits/' + optionShit[curSelected]));
		personajes.scrollFactor.set(0, 0);
		personajes.screenCenter(X);
		//personajes.setGraphicSize(Std.int(personajes.width * 1));
		personajes.antialiasing = ClientPrefs.globalAntialiasing;
		add(personajes);

		t4ilskuus = new FlxSprite(0, 0).loadGraphic(Paths.image('gallery/t4ilskuus'));
		t4ilskuus.scrollFactor.set(0);
		t4ilskuus.screenCenter(X);
		t4ilskuus.angularVelocity = 69;
		t4ilskuus.antialiasing = ClientPrefs.globalAntialiasing;
		add(t4ilskuus);

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.visible = false;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Dev Message - Link - BG Color
			['Flixed Team'],
			['-¡Awesome and Cool Funkin Flixel Dev Team!-', 'null', 'Director and Main Artist', 'Porfavor quitenme la PC', 'https://twitter.com/Cham0i_'],
			['Champ','Champ','Musician and Artist', 'Champ remasterizo los sprites 40 veces ya duermanlo', 'https://twitter.com/F0xer_Kuul','444444'],
			['Zozer', 'zozer', 'Main Coder', '¡Waos!', 'https://twitter.com/MJejejojo'],
			['Cabox', 'Cabox', 'Main Musician', 'nunca mas participo en un mod de fnf. De los 10, este fue el unico que salio, y fue un año despues.', 'https://youtube.com/@loxohighscore'],
			['Loxo Highscore', 'Loxo', 'Charter', 'Tsunku saca un nuevo Rhythm Heaven porfa plis', 'https://twitter.com/Andree1x' ],
			['Andree1x', 'Andree', 'Voice Actor', 'hice un oc chistoso y por eso le dieron una cancion entera gracias flixed deidad', 'https://twitter.com/_Coconut_Mall_			'],
			['TheCapM', 'cap', 'Artist', 'El de (lamentablemente) Twitter.com', 'https://twitter.com/ThecapM_'],
			['CoconutMall', 'Coco', 'Charter', 'null', 'https://twitter.com/FERRETWITHKNIFE'],
			['Coferip', 'Cofe', 'Charter', 'No sé que poner acá xd', 'https://twitter.com/FERRETWITHKNIFE'],
			['Griveon', 'Griveon', 'Charter', '', 'https://twitter.com/griveon']
		];

		if (cheatedReference == 5)
			pisspoop = [ //Name - Icon name - Description - Dev Message - Link - BG Color
				['Flixed Team'],
				['-¡Awesome and Cool Funkin Flixel Dev Team!-', 'null', 'Director and Main Artist', 'Porfavor quitenme la PC', 'https://twitter.com/Cham0i_'],
				['Champ','Champ','Musician and Artist', 'Champ remasterizo los sprites 40 veces ya duermanlo', 'https://twitter.com/F0xer_Kuul','444444'],
				['Zozer', 'zozer', 'Main Coder', '¡Waos!', 'https://twitter.com/MJejejojo'],
				['Cabox', 'Cabox', 'Main Musician', 'nunca mas participo en un mod de fnf. De los 10, este fue el unico que salio, y fue un año despues.', 'https://youtube.com/@loxohighscore'],
				['Loxo Highscore', 'Loxo', 'Charter', 'Tsunku saca un nuevo Rhythm Heaven porfa plis', 'https://twitter.com/Andree1x' ],
				['Andree1x', 'Andree', 'Voice Actor', 'hice un oc chistoso y por eso le dieron una cancion entera gracias flixed deidad', 'https://twitter.com/_Coconut_Mall_			'],
				['TheCapM', 'cap', 'Artist', 'Pon que le gusta el pene y ama a t4ilskuus'],
				['CoconutMall', 'Coco', 'Charter', 'null', 'https://twitter.com/FERRETWITHKNIFE'],
				['Coferip', 'Cofe', 'Charter', 'No sé que poner acá xd', 'https://twitter.com/FERRETWITHKNIFE'],
				['Griveon', 'Griveon', 'Charter', '', 'https://twitter.com/griveon']
			];
	
		//Pon que le gusta el pene y ama a t4ilskuus
		//zozer
		for(i in pisspoop){
			creditsStuff.push(i);
		}

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(90, 320, songs[i].songName, true);
			songText.isMenuItem = true;
			songText.targetY = i - curSelected;
			grpSongs.add(songText);

			var maxWidth = 980;
			if (songText.width > maxWidth)
			{
				songText.scaleX = maxWidth / songText.width;
			}
			songText.snapToPosition();

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon('credits/' + songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.visible=false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(300 - 6, 0).makeGraphic(20, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		scoreBGtwo = new FlxSprite(300 - 6, 650).makeGraphic(20, 66, 0xFF000000);
		scoreBGtwo.alpha = 0.6;
		add(scoreBGtwo);

		devmessage = new FlxText(300, 0, 1180, "Esto es una prueba sobre el mensaje dev", 32);
		devmessage.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		devmessage.screenCenter(X);
		devmessage.scrollFactor.set();
		//devmessage.borderSize = 2.4;
		add(devmessage);

		message = new FlxText(300, 670, 1180, "Esto es una prueba sobre nose", 32);
		message.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		message.screenCenter(X);
		message.scrollFactor.set();
		//devmessage.borderSize = 2.4;
		add(message);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.visible = false;
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0;
		add(textBG);

		#if PRELOAD_ALL
		var leText:String = "";
		var size:Int = 16;
		#else
		var leText:String = "";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadataTwo(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{

		if (creditsStuff[curSelected][3] == 'El de (lamentablemente) Twitter.com' && cheatedReference == 5 || creditsStuff[curSelected][3] == 'Pon que le gusta el pene y ama a t4ilskuus' && cheatedReference == 5)
		{
		t4ilskuus.visible = true;
		trace('lo cambia!');
	}

        else{t4ilskuus.visible = false;}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		devmessage.text = creditsStuff[curSelected][3];
		message.text = creditsStuff[curSelected][2];
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP || downP)
				{
					FlxTween.tween(personajes,{x: 600, alpha : 0},0.2,{ease:FlxEase.cubeIn,onComplete: function(twn:FlxTween)
						{
							personajes.loadGraphic(Paths.image('credits/portraits/' + optionShit[curSelected]));
							FlxTween.tween(personajes,{x: 0, alpha : 1},0.2,{ease:FlxEase.cubeOut});
						}
					});
				}

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
					changeDiff();
				}
			}
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		else if (accepted && (creditsStuff[curSelected][4] == null || creditsStuff[curSelected][3].length > 4))
			CoolUtil.browserLoad(creditsStuff[curSelected][4]);
		
		else if(controls.RESET && creditsStuff[curSelected][3] == 'El de (lamentablemente) Twitter.com' && !adioscap)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;


			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - devmessage.width - 6;

		scoreBG.scale.x = FlxG.width - devmessage.x + 6;	
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		
		scoreBGtwo.scale.x = FlxG.width - message.x + 6;	
		scoreBGtwo.x = FlxG.width - (scoreBGtwo.scale.x / 2);

		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadataTwo
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}