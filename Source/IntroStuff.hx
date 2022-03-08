package;

import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.ui.FlxBar;
import openfl.system.Capabilities;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUI;
import FileUtils;

using StringTools;

/**The main intro screen. This includes a basic explanation of what the user can expect to see.
    @since 0.0.1*/
class IntroStuff extends FlxState {
    public static var currentVersion:String = '0.0.1';
    #if (desktop || mobile)
    public static final yourPlatform:String = 'PC or Mobile';
    #else
    public static final yourPlatform:String = 'Web Browser';
    #end
    public static final sndExtension:Map<String, String> = [
        'PC or Mobile' => '.ogg',
        'Web Browser' => '.mp3'
    ];
    var screens:FlxUITabMenu;
    var background:FlxSprite;
    var cumCam:FlxCamera;
    
    public function new() {
        super();
    }

    override function create() {
        cumCam = new FlxCamera();
        cumCam.bgColor.alpha = 0;

        FlxG.cameras.reset(cumCam); // SO WE DON'T CRASH ON GAME LAUNCH!!

        background = new FlxSprite();
        
    }
}