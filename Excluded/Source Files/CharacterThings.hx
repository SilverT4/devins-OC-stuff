package characterUtils;

import flixel.FlxG;
import flixel.FlxSprite;
import FileUtils;

using StringTools;

typedef CharProperties = {
    var AnimArray:CharAnims;
    var OffsetArray:Array<CharOffsets>;
    var ImagePath:String;
}
typedef CharAnims = {
    var prefixAnims:Array<CharAnim_Prefix>;
    var indicesAnims:Array<CharAnim_Indices>;
    var allAnims:Array<Dynamic>;
}
typedef CharOffsets = {
    var animName:String;
    var X_Value:Int;
    var Y_Value:Int;
}
typedef CharAnim_Prefix = {
    var animName:String;
    var animXmlName:String;
    var animFramerate:Int;
    var animLoops:Bool;
}
typedef CharAnim_Indices = {
    var animName:String;
    var animXmlName:String;
    var animIndices:Array<Int>;
    var animNamePost:String;
    var animFramerate:Int;
    var animLoops:Bool;
}
class Character extends FlxSprite {
    private var ThisChar:CharProperties;
    /**Create the character on screen.
    @param x Where you want them to appear on the X axis.
    @param y Where you want them to appear on the Y axis.
    @param File The character's file name.*/
    var IDLE_ANIM:String = 'idle';
    public var BitchPositionMode:Bool = false;

    public function new(x:Float, y:Float, File:String, ?Path:String) {
        super(x, y);

        if (Path != null) {
            frames = FileUtils.getBirdAtlas(FileUtils.birdy(File, Path));
        } else {
            frames = FileUtils.getBirdAtlas(FileUtils.birdy(File));
        }
        //trace(frames);

        visible = true;
    }

    public function vibe() {
        if (animation.getByName(IDLE_ANIM) != null) {
            animation.play(IDLE_ANIM);
        }
    }
    public function setIdleAnim(animName:String) {
        if (animation.getByName(animName) != null) {
            IDLE_ANIM = animName;
        } else {
            FlxG.sound.play(FileUtils.sound('errorSound'));
            FlxG.log.warn('No animation named ' + animName + ' found, did you add it?');
        }
    }
    public function newAnim(ani:CharAnim_Prefix) {
        trace(ani);
        animation.addByPrefix(ani.animName, ani.animXmlName, ani.animFramerate, ani.animLoops);
        FlxG.log.add('Added ' + ani.animName + ' to animation list!');
        trace('Added ' + ani.animName + ' to animation list!');
    }

    public function newAnimByIndices(ani:CharAnim_Indices) {
        trace(ani);
        animation.addByIndices(ani.animName, ani.animXmlName, ani.animIndices, ani.animNamePost, ani.animFramerate, ani.animLoops);
        FlxG.log.add('Added ' + ani.animName + ' to animation list!');
        trace('Added ' + ani.animName + ' to animation list!');
    }

    public function addAnimsFromListFile(?ListFile:String, ?ListVar:CharProperties, ?AnimListVar:CharAnims) {
        if (ListFile != null) {
            var benis:CharProperties = cast haxe.Json.parse(ListFile);
            var ben:Array<CharAnim_Prefix> = benis.AnimArray.prefixAnims;
            var neb:Array<CharAnim_Indices> = benis.AnimArray.indicesAnims;
            for (ena in 0...ben.length) {
                trace(ben[ena]);
                var anim:CharAnim_Prefix = ben[ena];
                trace(anim);
                newAnim(anim);
            }
            for (joe in 0...neb.length) {
                trace(neb[joe]);
                var egg:CharAnim_Indices = neb[joe];
                trace(egg);
                newAnimByIndices(egg);
            }
        }
        if (ListVar != null) {
            var pp:Array<CharAnim_Prefix> = ListVar.AnimArray.prefixAnims;
            var ii:Array<CharAnim_Indices> = ListVar.AnimArray.indicesAnims;
            for (bruh in 0...pp.length) {
                trace(pp[bruh]);
                var anim:CharAnim_Prefix = pp[bruh];
                trace(anim);
                newAnim(anim);
            }
            for (hoe in 0...ii.length) {
                trace(ii[hoe]);
                var egg:CharAnim_Indices = ii[hoe];
                trace(egg);
                newAnimByIndices(egg);
            }
        }
        if (AnimListVar != null) {
            for (whore in 0...AnimListVar.prefixAnims.length) {
                trace(AnimListVar.prefixAnims[whore]);
                var anim:CharAnim_Prefix = AnimListVar.prefixAnims[whore];
                trace(anim);
                newAnim(anim);
            }
            for (materialGworl in 0...AnimListVar.indicesAnims.length) {
                trace(AnimListVar.indicesAnims[materialGworl]);
                var egg:CharAnim_Indices = AnimListVar.indicesAnims[materialGworl];
                trace(egg);
                newAnimByIndices(egg);
            }
        }
    }

    public function Editor_ResetAnims(NewAnimList:CharAnims) {
        animation.destroyAnimations();
        var newPrefixes = NewAnimList.prefixAnims;
        var pickMeElephant = NewAnimList.indicesAnims;
        for (girl in 0...newPrefixes.length) {
            trace(newPrefixes[girl]);
            var anim:CharAnim_Prefix = newPrefixes[girl];
            trace(anim);
            newAnim(anim);
        }
        for (bitchass in 0...pickMeElephant.length) {
            trace(pickMeElephant[bitchass]);
            var anim:CharAnim_Indices = pickMeElephant[bitchass];
            trace(anim);
            newAnimByIndices(anim);
        }
    }
    public function playAnim(AnimName:String) {
        if (animation.getByName(AnimName) != null) {
            animation.play(AnimName);
        } else {
            FlxG.sound.play(FileUtils.sound('errorSound'));
            FlxG.log.warn('No animation named ' + AnimName + ', did you add it?');
        }
    }

    public function removeAnim(AnimName:String) {
        if (animation.getByName(AnimName) != null) {
            animation.remove(AnimName);
        } else {
            FlxG.log.warn('No animation named ' + AnimName + ', did you already remove it?');
        }
    }
    // public var butWhy:Bool = animation.curAnim.finished;
}