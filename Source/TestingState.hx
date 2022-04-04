package;

import flixel.input.keyboard.FlxKey;
import flixel.*;
import flixel.text.*;
import flixel.ui.*;
import flixel.tweens.*;
import flixel.addons.ui.*;
import SusUtil;
import FileUtils;
import dumb.*;
import characterUtils.*;
import utils.*;
import extraShit.*;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
using StringTools;

/**This state is for testing things that I want to make sure work.
    @since April 4th, 2022. This will not be included in any release builds.*/
class TestingState extends FlxState {
    static inline final HOVER_ALPHA = "hover-alpha";

    static inline final INACTIVE_ALPHA = "inactive-alpha";

    var testPng:CharacterPicture;
    public function new() {
        super();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(testPng)) {
            if (testPng.alpha != 1) FlxTween.tween(testPng, {alpha: new TestingShit(HOVER_ALPHA)}, 0.7);
            if (FlxG.mouse.justPressed) {
                testPng.openMyURL();
            }
        } else {
            if (testPng.alpha != 0.7) FlxTween.tween(testPng, {alpha: new TestingShit(INACTIVE_ALPHA)}, 0.7);
        }
    }

    override function create() {
        testPng = new CharacterPicture(125, 125, "Assets/Images/ralph but funky.png", "https://www.youtube.com/watch?v=eSN0LoFmG0E");
        testPng.alpha = new TestingShit(INACTIVE_ALPHA);
        add(testPng);
    }
}

/**Testing values.*/
abstract TestingShit(Dynamic) from String to Dynamic {
    static inline final HOVER_ALPHA = "hover-alpha";

    static inline final INACTIVE_ALPHA = "inactive-alpha";

    static inline final PEE = "pee";

    inline public function new(Shitass:String) {
        switch (Shitass) {
            case INACTIVE_ALPHA:
                this = 0.7;
            case HOVER_ALPHA:
                this = 1;
        }
        this = PEE;
    }
}