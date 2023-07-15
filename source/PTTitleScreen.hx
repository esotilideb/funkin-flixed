package;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

class PTTitleScreen extends MusicBeatState
{
	inline static var MIN_TIME = 1.0;

	// Browsers will load create(), you can make your song load a custom directory there
	// If you're compiling to desktop (or something that doesn't use NO_PRELOAD_ALL), search for getNextState instead
	// I'd recommend doing it on both actually lol
	
	// TO DO: Make this easier
	
	var target:FlxState;
	var stopMusic = false;
	var directory:String;
	var callbacks:MultiCallbackButCooler;
	var targetShit:Float = 0;

	function new(target:FlxState, stopMusic:Bool, directory:String)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
		this.directory = directory;
	}

	var funkay:FlxSprite;
	var text:FlxSprite;
	var loadBar:FlxSprite;
	public var sexo:Bool = false;
	override function create()
	{
		FlxG.camera.zoom = 3;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.1, {ease: FlxEase.expoOut});
		FlxG.sound.play(Paths.sound('intro'), 1);

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x09FF32);
		bg.screenCenter(X);
		//0xD0D0D0
		add(bg);
		
		funkay = new FlxSprite(0, 0).loadGraphic(Paths.getPath('images/TitleCard/fortnite-bg.png', IMAGE));
		funkay.alpha = 0;
		//funkay.scale.set(2, 2);
		funkay.screenCenter(XY);
		funkay.updateHitbox();
		funkay.antialiasing = ClientPrefs.globalAntialiasing;
		add(funkay);
		funkay.scrollFactor.set();

		text = new FlxSprite(190, 0);
        text.frames = Paths.getSparrowAtlas('TitleCard/fortnite');
		text.alpha = 0;
        //text.scale.set(2, 2);
		text.screenCenter();
		text.scrollFactor.set();
        text.antialiasing = ClientPrefs.globalAntialiasing;
        text.animation.addByPrefix('idle', 'Letra', 30, true);
        text.animation.play('idle');
        add(text);

		loadBar = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 10, 0xffff16d2);
		loadBar.visible = false;
		loadBar.screenCenter(X);
		loadBar.antialiasing = ClientPrefs.globalAntialiasing;
		add(loadBar);

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
			{
				FlxTween.tween(funkay, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
				FlxTween.tween(text, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
			});

		new FlxTimer().start(3.9, function(tmr:FlxTimer) //the final "du"
			{
				FlxTween.tween(FlxG.camera, {zoom: 1.3}, 1.1, {ease: FlxEase.expoOut});
			});

		new FlxTimer().start(4.1, function(tmr:FlxTimer) //the final "du"
			{
				FlxTween.tween(FlxG.camera, {zoom: 1}, 1.1, {ease: FlxEase.expoOut});
			});
	
	new FlxTimer().start(5, function(tmr:FlxTimer)
		{
			initSongsManifest().onComplete
			(
				function (lib)
					{
						callbacks = new MultiCallbackButCooler(onLoad);
						var introComplete = callbacks.add("introComplete");
						/*if (PlayState.SONG != null) {
							checkLoadSong(getSongPath());
							if (PlayState.SONG.needsVoices)
							checkLoadSong(getVocalPath());
						}*/
						checkLibrary("shared");
						if(directory != null && directory.length > 0 && directory != 'shared') {
						checkLibrary(directory);
						}

						var fadeTime = 0.5;
						FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
						new FlxTimer().start(fadeTime + MIN_TIME, function(_) introComplete());
					});		
			});
		}
	
	function checkLoadSong(path:String)
	{
		if (!Assets.cache.hasSound(path))
		{
			var library = Assets.getLibrary("songs");
			final symbolPath = path.split(":").pop();
			// @:privateAccess
			// library.types.set(symbolPath, SOUND);
			// @:privateAccess
			// library.pathGroups.set(symbolPath, [library.__cacheBreak(symbolPath)]);
			var callback = callbacks.add("song:" + path);
			Assets.loadSound(path).onComplete(function (_) { callback(); });
		}
	}
	
	function checkLibrary(library:String) {
		trace(Assets.hasLibrary(library));
		if (Assets.getLibrary(library) == null)
		{
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw "Missing library: " + library;

			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function (_) { callback(); });
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(callbacks != null) {
			targetShit = FlxMath.remapToRange(callbacks.numRemaining / callbacks.length, 1, 0, 0, 1);
			loadBar.scale.x += 0.5 * (targetShit - loadBar.scale.x);
		}
	}
	
	function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		MusicBeatState.switchState(target);
	}
	
	static function getSongPath()
	{
		return Paths.inst(PlayState.SONG.song);
	}
	
	static function getVocalPath()
	{
		return Paths.voices(PlayState.SONG.song);
	}
	
	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		MusicBeatState.switchState(getNextState(target, stopMusic));
	}
	
	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		var directory:String = 'shared';
		var weekDir:String = StageData.forceNextDirectory;
		StageData.forceNextDirectory = null;

		if(weekDir != null && weekDir.length > 0 && weekDir != '') directory = weekDir;

		Paths.setCurrentLevel(directory);
		trace('Setting asset folder to ' + directory);

		var loaded:Bool = false;
		if (PlayState.SONG != null) {
			loaded = isSoundLoaded(getSongPath()) && (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath())) && isLibraryLoaded("shared") && isLibraryLoaded(directory);
		}
		
		if (!loaded)
			return new PTTitleScreen(target, stopMusic, directory);
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		return target;
	}
	
	static function isSoundLoaded(path:String):Bool
	{
		return Assets.cache.hasSound(path);
	}
	
	static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}
	
	override function destroy()
	{
		super.destroy();
		
		callbacks = null;
	}
	
	static function initSongsManifest()
	{
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
			{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				promise.error("Cannot open library \"" + id + "\"");
			}
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
			promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}
}

class MultiCallbackButCooler
{
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;
	
	var unfired = new Map<String, Void->Void>();
	var fired = new Array<String>();
	
	public function new (callback:Void->Void, logId:String = null)
	{
		this.callback = callback;
		this.logId = logId;
	}
	
	public function add(id = "untitled")
	{
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function ()
		{
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;
				
				if (logId != null)
					log('fired $id, $numRemaining remaining');
				
				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}
	
	inline function log(msg):Void
	{
		if (logId != null)
			trace('$logId: $msg');
	}
	
	public function getFired() return fired.copy();
	public function getUnfired() return [for (id in unfired.keys()) id];
}