package;

import flixel.FlxG;
using StringTools;

/**Some extra utils, some of which are copied from FNF at the moment
    @since 0.0.3 (early April 2022)*/
class SusUtil {
    public static function openLink(URLPath:String) {
        FlxG.openURL(URLPath);
    }
}