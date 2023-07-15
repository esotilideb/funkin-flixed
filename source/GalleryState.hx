package;

import openfl.display.Sprite;
import lime.ui.Window;
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
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

import lime.app.Application;

import lime.app.Application;
import lime.graphics.RenderContext;
import lime.ui.MouseButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Window;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Sprite;
import openfl.utils.Assets;

import openfl.Lib;

using StringTools;

class GalleryState extends MusicBeatState
{
    var image:FlxSprite;
    var wikichars:Array<String> = ['tadaeref', 'johnref', 'encoresexref', 'dos'];
    var curSelected:Int = 1;

    var sprite:FlxSprite;

    var windowDad:Window;
    var dadWin = new Sprite();
    var dadScrollWin = new Sprite();
	var newWindow:Window;

    var canSelect:Bool = true;

    override function create() {
        /*var arr:Array<String> = Paths.getTextFromFile('images/gallery/list.txt').split('\n');
        for (i in 0...arr.length)
        {
            wikichars.push(arr[i].rtrim());
            trace(arr[i].rtrim());
        }

        var firstarray:Array<String> = Paths.getTextFromFile('gallery/list.txt').split('\n');
        for(i in firstarray)
        {
            arr = i.replace('\\n', '\n');
            trace(arr);
        }*/

		persistentUpdate = persistentDraw = true;

		var abg = new FlxBackdrop(Paths.image('menuBG'), #if (flixel < "5.0.0") 1, 1, true, true, #else XY, #end FlxG.random.int(-25, 5), 0);
		abg.screenCenter();
  		abg.scrollFactor.set();
        abg.color = FlxColor.WHITE; 
  		abg.velocity.set(-100, -100);
  		abg.antialiasing = ClientPrefs.globalAntialiasing;
  		add(abg);

        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('gallery/Gallery_BG'));
		bg.scrollFactor.set(0, 0);
		//bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
        
        var bg2:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('gallery/Frame_BG'));
		bg2.scrollFactor.set(0, 0);
		//bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg2.updateHitbox();
		bg2.screenCenter();
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg2);

		var bg3 = new FlxSprite(190, 0);
        bg3.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
        bg3.scale.set(2, 2);
		bg3.screenCenter(Y);
		bg3.scrollFactor.set(0);
        bg3.antialiasing = true;
        bg3.animation.addByPrefix('idle', 'arrow left', 30, true);
		bg3.animation.addByPrefix('push', 'arrow push left', 30, true);
        bg3.animation.play('idle');
        add(bg3);
        
        var bg4 = new FlxSprite(980, 0);
        bg4.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
        bg4.scale.set(2, 2);
		bg4.screenCenter(Y);
		bg4.scrollFactor.set(0);
        bg4.antialiasing = true;
        bg4.animation.addByPrefix('idle', 'arrow right', 30, true);
		bg4.animation.addByPrefix('push', 'arrow push right', 30, true);
        bg4.animation.play('idle');
        add(bg4);

        image = new FlxSprite().loadGraphic(Paths.image('gallery/' + wikichars[curSelected]));
        add(image);

        // Creamos una nueva ventana con un título y un tamaño
     /*   var window = new Window(100, 100, "Mi ventana");
        window.makeResizable();
        window.setDraggable(true);
        window.width = 300;
        window.height = 200;*/

        // Creamos un nuevo FlxSprite

       // popupWindow(362, 350, 100, 'mauricio.json');

        // Agregamos el FlxSprite a la ventana

        changeSelection();

        super.create();
    }
    
    override function update(elapsed:Float)
    {
        if (canSelect)
        {
            if (controls.UI_LEFT_P)
            {
                changeSelection(-1);
            }
            else if (controls.UI_RIGHT_P)
            {
                changeSelection(1);
            }
    
            if (controls.BACK)
            {
                MusicBeatState.switchState(new MainMenuState());
                canSelect = false;
            }
        }

        /*@:privateAccess
        var dadFrame = sprite._frame;
        
        if (dadFrame == null || dadFrame.frame == null) return; // prevents crashes (i think???)
            
        var rect = new Rectangle(dadFrame.frame.x, dadFrame.frame.y, dadFrame.frame.width, dadFrame.frame.height);*/

        super.update(elapsed);
    }

    function changeSelection(huh:Int = 0)
    {
        curSelected += huh;

		if (curSelected >= wikichars.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = wikichars.length - 1;

        image.loadGraphic(Paths.image('gallery/' + wikichars[curSelected]));
        image.setGraphicSize(0, 720);
        image.updateHitbox();
        image.antialiasing = ClientPrefs.globalAntialiasing;
        image.screenCenter();

        trace(('gallery/image_' + wikichars[curSelected]));
    }

    /*function popupWindow(customWidth:Int, customHeight:Int, ?customX:Int, ?customName:String) {
        var display = Application.current.window.display.currentMode;
        // PlayState.defaultCamZoom = 0.5;

		if(customName == '' || customName == null){
			customName = 'Opponent.json';
		}

        windowDad = openfl.Lib.application.createWindow({
            title: customName,
            width: customWidth,
            height: customHeight,
            borderless: false,
            alwaysOnTop: true

        });
		if(customX == null){
			customX = -10;
		}
        windowDad.x = customX;
	    windowDad.y = Std.int(display.height / 2);
        windowDad.stage.color = 0xFF000000;

        var bg = Paths.image('newgrounds_logo').bitmap;
        var spr = new Sprite();

        var m = new Matrix();

        spr.graphics.beginBitmapFill(bg, m);
        spr.graphics.drawRect(0, 0, bg.width, bg.height);
        spr.graphics.endFill();
        FlxG.mouse.useSystemCursor = true;
	    windowDad.stage.addChild(spr);
        Application.current.window.focus();
	    	FlxG.autoPause = false;
    }*/
}