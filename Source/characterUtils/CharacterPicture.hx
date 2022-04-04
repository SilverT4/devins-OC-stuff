package characterUtils;

import openfl.net.URLLoader;
import flixel.FlxSprite;
import FileUtils;
using StringTools;

class CharacterPicture extends FlxSprite {
    public var MyURL:String = '';
    public function new(x:Float = 0, y:Float = 0, imagePath:String, ?URLPath:String) {
        super(x, y);
        loadGraphic((imagePath.contains('/')) ? imagePath : FileUtils.pic(imagePath));
        if (URLPath != null) this.MyURL = URLPath;
    }

    public function openMyURL() {
        if (MyURL != null) {
            SusUtil.openLink(MyURL);
        }
    }
}