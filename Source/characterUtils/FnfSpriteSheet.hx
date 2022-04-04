package characterUtils;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import FileUtils;
using StringTools;

/**
    # REWORK CLASS
    
    This class is part of the character sprite rework.
    
    ========================
    
    This class will handle sprite sheets from FNF so I can easily import those if I really want to use them for my OCs.
    
    @since 0.0.3 (Specifically, early April 2022)*/
class FnfSpriteSheet extends FlxSprite {
    public var healthColour:FNFHealthColor;
    var animList:Array<String> = [];
    var offsetMap:Map<String, Array<Int>> = new Map();
    public function new(x:Float = 0, y:Float = 0, SheetPath:String, AnimList:FNFAnimationShit) {
        super(x, y);
        var pissySplit = SheetPath.split('/');
        var pissyName:String = pissySplit[pissySplit.length - 1].split('.')[0];
        var pissySplitTwo = pissySplit.join('/').split(pissyName);
        var pissyPath = pissySplitTwo[0];
        frames = FileUtils.getBirdAtlas(FileUtils.birdy(pissyName, pissyPath));
        if (AnimList != null) {
            var pee = AnimList.healthbar_colors;
            this.healthColour = {
                red: pee[0],
                green: pee[1],
                blue: pee[2]
            };
            for (piss in AnimList.animations) {
                var myMouth:Int = AnimList.animations.indexOf(piss) + 1;
                var toilet:String = (piss.indices.length > 0) ? " with " + piss.indices.length + " frames (" + piss.indices.join(', ') + ")" : "";
                trace("Adding animation labelled " + piss.anim + toilet + ". (" + myMouth + " of " + AnimList.animations.length + ")");
                if (piss.indices.length > 0) {
                    animation.addByIndices(piss.anim, piss.name, piss.indices, '', piss.fps, piss.loop);
                    animList.push(piss.anim);
                } else {
                    animation.addByPrefix(piss.anim, piss.name, piss.fps, piss.loop);
                    animList.push(piss.anim);
                }
                offsetMap.set(piss.anim, piss.offsets);
            }
        }
    }

    public function playAnim(piss:String, kink:Bool = false) {
        var cum:Array<Int> = [0,0];
        if (animation.getByName(piss) != null) {
            if (offsetMap.exists(piss)) cum = offsetMap[piss];
            animation.play(piss, kink);
            offset.set(cum[0], cum[1]);
        } else {
            #if debug
            FlxG.log.error('No animation found by the name of $piss. Please double check your JSON to see if it exists.');
            #end
            trace('No animation found by the name of $piss. Please double check your JSON to see if it exists.');
        }
    }
}

typedef FNFAnimationShit = {
    var animations:Array<FNFAnimDef>;
    var healthbar_colors:Array<Int>;
}

typedef FNFHealthColor = {
    var red:Int;
    var green:Int;
    var blue:Int;
}

typedef FNFAnimDef = {
    var offsets:Array<Int>;
    var anim:String;
    var fps:Int;
    var loop:Bool;
    var name:String;
    var indices:Array<Int>;
}