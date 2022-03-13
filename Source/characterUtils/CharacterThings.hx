package characterUtils;

import flixel.FlxG;
import flixel.FlxSprite;
import FileUtils;

using StringTools;

typedef CharProperties = {
    var AnimArray:Array<CharAnims>;
    var OffsetArray:Array<CharOffsets>;
}
typedef CharAnims = {
    var PrefixAnims:Array<CharAnim_Prefix>;
    var IndicesAnims:Array<CharAnim_Indices>;
}
typedef CharOffsets = {
    var AnimName:String;
    var X_Value:Int;
    var Y_Value:Int;
}
typedef CharAnim_Prefix = {
    var AnimName:String;
    var AnimXmlName:String;
    var AnimFramerate:Int;
    var AnimLoops:Bool;
}
typedef CharAnim_Indices = {
    var AnimName:String;
    var AnimXmlName:String;
    var AnimIndices:Array<Int>;
    var AnimNamePost:String;
    var AnimFramerate:Int;
    var AnimLoops:Bool;
}
class Character extends FlxSprite {
    private var ThisChar:CharProperties;
    /**Create the character on screen.
    @param x Where you want them to appear on the X axis.
    @param y Where you want them to appear on the Y axis.
    @param File The character's file name.*/
    public function new(x:Float, y:Float, File:String, ?Path:String) {
        super(x, y);

        if (Path != null) {
            frames = FileUtils.getBirdAtlas(FileUtils.birdy(File, Path));
        } else {
            frames = FileUtils.getBirdAtlas(FileUtils.birdy(File));
        }
        trace(frames);
    }

    public function vibe() {
        if (animation.getByName('idle') != null) {
            animation.play('idle');
        }
    }

    public function newAnim(AnimName:String, AnimXmlName:String, AnimFramerate:Int, Loops:Bool) {
        animation.addByPrefix(AnimName, AnimXmlName, AnimFramerate, Loops);
        FlxG.log.add('Added ' + AnimName + ' to animation list!');
        trace('Added ' + AnimName + ' to animation list!');
    }

    public function newAnimByIndices(AnimName:String, AnimXmlName:String, AnimIndices:Array<Int>, AnimNamePost:String, AnimFramerate:Int, Loops:Bool) {
        animation.addByIndices(AnimName, AnimXmlName, AnimIndices, AnimNamePost, AnimFramerate, Loops);
        FlxG.log.add('Added ' + AnimName + ' to animation list!');
        trace('Added ' + AnimName + ' to animation list!');
    }

    // public var butWhy:Bool = animation.curAnim.finished;
}