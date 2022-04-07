package characterUtils;

import openfl.net.URLLoader;
import flixel.FlxSprite;
import FileUtils;
using StringTools;

class CharacterPicture extends FlxSprite {
    public var MyURL:String = '';
    public var funnyTrace:String = '';
    public function new(x:Float = 0, y:Float = 0, imagePath:String, ?URLPath:String, ?funnyTrace:String) {
        super(x, y);
        loadGraphic((imagePath.contains('/')) ? imagePath : FileUtils.pic(imagePath));
        if (URLPath != null) this.MyURL = URLPath;
        if (funnyTrace != null) this.funnyTrace = funnyTrace;
    }

    public function openMyURL() {
        if (MyURL != null && MyURL.length > 1) {
            if (funnyTrace.length >= 1) trace(funnyTrace);
            SusUtil.openLink(MyURL);
        }
    }
}