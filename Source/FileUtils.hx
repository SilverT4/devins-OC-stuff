package;

import sys.FileSystem;
import sys.io.File;
import sys.FileStat;
import IntroStuff;
import flixel.graphics.frames.FlxAtlasFrames as Faf;

using StringTools;
/**File utilities. Allows you to grab files or check if they exist.
@since 0.0.1*/
class FileUtils {
    static final bruh = IntroStuff.sndExtension[IntroStuff.yourPlatform];
    static final defaultPaths:Map<String, String> = [
        'image' => 'Assets/Images/',
        'audio' => 'Assets/Audio/',
        'chara' => 'Assets/Characters/',
        'xml' => 'Assets/Images/',
        'bird' => 'Assets/Images/'
    ];
    public static var yes:Bool = false;
    //gonna rework all this shit idk

    static var imageFileThing:String = '';
    static final image:String = 'image';
    static final audio:String = 'audio';
    static final xml:String = 'xml';
    static final bird:String = 'bird';
    static final chara:String = 'chara';
}