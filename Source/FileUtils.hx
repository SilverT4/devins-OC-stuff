package;

import flixel.input.keyboard.FlxKey;
import haxe.Json;
import sys.FileSystem;
import sys.io.File as SusFile;
import sys.FileStat;
import IntroStuff;
import flixel.graphics.frames.FlxAtlasFrames as Faf;
import characterUtils.CharacterThings;
import haxe.ValueException;
import flixel.animation.FlxAnimationController;
using StringTools;
/**File utilities. Allows you to grab files or check if they exist.
    
TODO: Add save/load capabilities.
@since 0.0.1*/
class FileUtils {
    static final bruh = IntroStuff.sndExtension[IntroStuff.yourPlatform];
    static final defaultPaths:Map<String, String> = [
        'image' => 'Assets/Images/',
        'audio' => 'Assets/Audio/',
        'chara' => 'Assets/Characters/',
        'xml' => 'Assets/Images/',
        'bird' => 'Assets/Images/',
        'json' => 'Assets/JsonData/',
        'txt' => 'Assets/TxtData/'
    ];
    static final commonExtensions:Map<String, String> = [
        'image' => '.png',
        'chara' => '.character',
        'xml' => '.xml',
        'json' => '.json'
    ];
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO, FlxKey.NUMPADZERO];
    public static var volKeysUp:Array<FlxKey> = [FlxKey.PLUS, FlxKey.NUMPADPLUS];
    public static var volKeysDown:Array<FlxKey> = [FlxKey.MINUS, FlxKey.NUMPADMINUS];
    /**Checks if the file exists. The file must have an extension, if it doesn't the game will crash!!
    @since 0.0.1*/
    public static function existential(File:String, ?Path:String):Bool {
        var yes:Bool = false;
        if (Path != null) {
            if (FileSystem.exists(Path + File)) {
                yes = true;
            }
        } else {
            var ben = File.split('.');
            var exten = ben[1];
            var neb = bruh.replace('.', '');
            switch (exten) {
                case neb:
                    if (FileSystem.exists(defaultPaths[audio] + File)) {
                        yes = true;
                    }
                case 'json':
                    if (FileSystem.exists(defaultPaths[json] + File)) {
                        yes = true;
                    }
                case 'character':
                    if (FileSystem.exists(defaultPaths[chara] + File)) {
                        yes = true;
                    }
                case 'png' | 'xml':
                    if (FileSystem.exists(defaultPaths[image] + File)) {
                        yes = true;
                    }
                case 'txt':
                    if (FileSystem.exists(defaultPaths[txt] + File)) {
                        yes = true;
                    }
            }
        }
        return yes;
    }
    /**Allows you to load a picture. No extension needed as this function will return that along with the path.
    @since 0.0.1*/
    public static function pic(File:String, ?Path:String):String {
        var pathThingy = 'Assets/Images/';
        var fileThingy = File + commonExtensions[image];
        if (Path != null) pathThingy = Path;
        if (Path != null) {
            if (existential(File + commonExtensions[image], Path)) {
                imageFileThing = Path + File + commonExtensions[image];
            }
        } else {
            if (existential(File + commonExtensions[image])) {
                imageFileThing = defaultPaths[image] + File + commonExtensions[image];
            }
        }
        return pathThingy + fileThingy;
    }
    /**Allows you to load audio. No extension needed as this function will return that along with the path.
    @since 0.0.1*/
    public static function sound(File:String, ?Path:String):String {
        var audioFileThing:String = '';
        if (Path != null) {
            if (existential(File + bruh, Path)) {
                audioFileThing = Path + File + bruh;
            }
        } else {
            if (existential(File + bruh)) {
                audioFileThing = defaultPaths[audio] + File + bruh;
            }
        }
        return audioFileThing;
    }
    /**Allows you to load a spritesheet. No extension needed for either the image or XML, as this function will return the FlxAtlasFrames as needed.
    @since 0.0.1*/
    public static function birdy(File:String, ?Path:String):Array<String> {
        var pathThingy = 'Assets/Images/';
        if (Path != null) pathThingy = Path;
        var imageyShit:String = pathThingy + File + '.png';
        var xmlShit:String = pathThingy + File + '.xml';
        /*if (Path != null) {
            if (existential(File + commonExtensions[image], Path) && existential(File + commonExtensions[xml], Path)) {
                imageyShit = Path + File + commonExtensions[image];
                xmlShit = Path + File + commonExtensions[xml];
                return [imageyShit, xmlShit];
            }
        } else {
            if (existential(File + commonExtensions[image]) && existential(File + commonExtensions[xml])) {
                imageyShit = defaultPaths[image] + File + commonExtensions[image];
                xmlShit = defaultPaths[xml] + File + commonExtensions[xml];
                return [imageyShit, xmlShit];
                }
        } */ // may need this later!
        trace(imageyShit, xmlShit);
        trace(File);
        if (Path != null) trace(Path);
        return [imageyShit, xmlShit];
        // return Faf.fromSparrow(imageFileThing, xmlFileThing);
    }
    /**Uses birdy's output to give frames
    @since 0.0.1*/
    public static function getBirdAtlas(Bird:Array<String>) {
        return Faf.fromSparrow(Bird[0], Bird[1]);
    }
    /**Allows you to load the character's properties.
    @since 0.0.1*/
    public static function charProps(File:String):CharProperties {
        if (existential(File + commonExtensions[chara])) {
            charaFileThing = defaultPaths[chara] + File + commonExtensions[chara];
        }
        return cast Json.parse(getDataInt(charaFileThing));
    }
    /**Reads data from a file. (INTERNAL THING THAT ALREADY HAS PATHS SET UP! THERE'S A SEPARATE ONE FOR USE IN OTHER CLASSES.)
    @since 0.0.1*/
    inline static function getDataInt(FilePath:String):String {
        return SusFile.getContent(FilePath);
    }

    /**Reads data from a file. (**USE THIS IN YOUR CLASSES TO AVOID ERRORS ABOUT A PRIVATE FUNCTION!**)
    @param File The file to read
    @param FileType Is it an **xml** (0), **json** (1), **character** (2), or a **txt** file (3)? (Only necessary if Path is nulL!)
    @param Path (Optional) The file path.
    @since 0.0.1*/
    public static function getFileData(File:String, ?Path:String, ?FileType:Int):String {
        if (Path != null) {
            dataFileThing = SusFile.getContent(Path + File);
        } else {
            switch (FileType) {
                case 2:
                    dataFileThing = SusFile.getContent(defaultPaths[chara] + File + commonExtensions[xml]);
                case 1:
                    dataFileThing = SusFile.getContent(defaultPaths[json] + File + commonExtensions[json]);
                case 3:
                    dataFileThing = SusFile.getContent(defaultPaths[txt] + File + '.txt');
                case 0:
                    dataFileThing = SusFile.getContent(defaultPaths[xml] + File + commonExtensions[xml]); // you could really just use readXmlAnims since it's public. lmfao
            }
        }
        return dataFileThing;
    }
    /**CharacterThings will read this if no file exists for the specified character.
    @since 0.0.1*/
    public static function readXmlAnims(File:String):Dynamic {
        var mama = cast Xml.parse(getDataInt(defaultPaths[xml] + File + commonExtensions[xml]));
        return mama;
    }
    /**Copy a file from outside of the game's folders to your game.
    @param File Where the file is
    @param Path Where to place it.
    @since 0.0.1*/
    public static function externalFile(File:String, Path:String) {
        new sys.io.Process('cmd', ['/c copy ' + File, Path]);
    }
    /**Allows you to quickly parse a template and save a few seconds typing it out.
        @since 0.0.2
        @param Template The template to parse.*/
    public static function parseTemplate(Template:Dynamic):Dynamic {
        return Json.parse(Json.stringify(Template));
    }

    public static function convertToFile(JsonData:Dynamic):String {
        return Json.stringify(JsonData);
    }
    static var dataFileThing:String;
    static var charaFileThing:String;
    static var xmlFileThing:String;
    static var imageFileThing:String;
    //static var audioFileThing:String;
    static final image:String = 'image';
    static final audio:String = 'audio';
    static final xml:String = 'xml';
    static final bird:String = 'bird';
    static final chara:String = 'chara';
    static final json:String = 'json';
    static final txt:String = 'txt';
}