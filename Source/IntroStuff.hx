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
//import characterUtils.CharacterThings;
import extraShit.Speen;
import flixel.util.FlxTimer;
using StringTools;

/**The main intro screen. This includes a basic explanation of what the user can expect to see.
    @since 0.0.1*/
class IntroStuff extends FlxState {
    public static var currentVersion:String = '0.0.3';
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
    var yes:Speen;
    //public static var joeMama:Character;
    public static var cumChat:String = 'cum';
    public static var PUBLIC_VARS:Array<Dynamic> = [
        //joeMama,
        cumChat
    ];
    
    public function new() {
        super();
        if (FlxG.mouse != null) {
            FlxG.mouse.useSystemCursor = true;
        }
        trace(FlxG.width, FlxG.height);
    }

    override function create() {
        cumCam = new FlxCamera();
        cumCam.bgColor.alpha = 0;

        FlxG.cameras.reset(cumCam); // SO WE DON'T CRASH ON GAME LAUNCH!!
        // trace(FileUtils.readXmlAnims('test'));
        background = new FlxSprite();
        //if (FileUtils.existential('picThing.png')) {
            background.loadGraphic(FileUtils.image('picThing'));
            background.setGraphicSize(FlxG.width);
            background.scrollFactor.set();
            background.screenCenter();
        /*} else {
            background.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 255, 255, 128));
        } */
        yes = new Speen(FlxG.width - 48, FlxG.height - 48, false);
        new FlxTimer().start(3, function (tmr:FlxTimer) {
            yes.startSpinning();
        });
        var funnyMsg = new FlxText(0, FlxG.height - 30, FlxG.width - 48, 'Change the "picThing" file to change this image!', 24);
        add(background);
        add(yes);
        add(funnyMsg);
        setupScreens();
    }

    function setupScreens() {
        var tabs = [
            {name: 'Introduction', label: "Introduction"}
        ];
        screens = new FlxUITabMenu(null, tabs);
        screens.resize(FlxG.width - 100, FlxG.height - 100);
        screens.screenCenter();
        add(screens);
    }
}