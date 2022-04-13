package;

import characterUtils.CharInfo.CharInfoJsonUtil;
import openfl.net.*;
import flixel.input.keyboard.FlxKey;
import flixel.*;
import flixel.text.*;
import flixel.ui.*;
import flixel.tweens.*;
import flixel.addons.ui.*;
import flixel.util.*;
import SusUtil;
import FileUtils;
import dumb.*;
import characterUtils.*;
import characterUtils.CharInfo;
import characterUtils.SpeciesThingie;
import utils.*;
import extraShit.*;
import haxe.Json;
#if sys
import sys.FileSystem;
import sys.io.File;
#else
import openfl.Assets as OpenAssets;
#end
using StringTools;

/**This state is for testing things that I want to make sure work.
    @since April 4th, 2022. This will not be included in any release builds.*/
class TestingState extends FlxState {
    var shit:BackgroundSprite;
    var testPng:CharacterPicture;
    var peenUI:FlxUITabMenu;
    var testing:FlxUI;
    var blitz = [
        {name: "TEST", label: "TEST"}
    ];
    var golem:TestingCharacter;
    var pissThing:CharInfo;
    public function new() {
        super();
        pissThing = new CharInfo("Piss", null, new Species("Piss monster", "piss monsters are dangerous", "piss"), { month: 2, day: 14, year: 2001 }, { ft: 5, inch: 6 }, ["pisslish"], new FavouriteStuff("amogus", ["yellow"], ["Among Us"], "piss"), [
            new Headcanon("Pisses on the moon", "Your mom")
        ]);
    }
    var curScaling:Float = 0.34;
    var warnScale:Bool = false;
    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.mouse.overlaps(testPng)) {
            if (testPng.alpha != 1) FlxTween.tween(testPng, {alpha: 1}, 0.25, {onComplete: amogus});
            if (FlxG.mouse.justPressed) {
                testPng.openMyURL();
            }
        } else {
            if (testPng.alpha != 0.7) FlxTween.tween(testPng, {alpha: 0.7}, 0.25, {onComplete: amogus});
        }
        #if debug
        if (testText != null) {
            if (penis_png != null && updateInfo) {
                testText.text = "Picture X:" + penis_png.x
                + "\nPicture Y:" + penis_png.y
                + "\nPicture scale:" + curScaling + " (" + penis_png.scale + ")"
                + "\nMouse X:" + FlxG.mouse.x
                + "\nMouse Y:" + FlxG.mouse.y
                + "\nMouse scroll: " + FlxG.mouse.wheel
                + "\nMouse hovering over UI box:" + ((FlxG.mouse.overlaps(peenUI)) ? "Yes" : "No")
                + ((warnScale) ? "\nWARNING: Scaling is below 0, picture may be inverted!!" : "");
                testText.fieldWidth = 0;
                testText.updateHitbox();
            }

            testText.update(elapsed);
        }
        if (FlxG.mouse.overlaps(peenUI)) {
            if (FlxG.mouse.wheel == 1) { // If scrolling UP, scale by +0.01
                if (updateInfo) doPeenScale(0.01);
            }
            if (FlxG.mouse.wheel == -1) { // If scrolling DOWN, scale by -0.01
                if (updateInfo) doPeenScale(-0.01);
            }
            if (penis_png != null) {
                if (updateInfo) penis_png.setPosition(FlxG.mouse.x, FlxG.mouse.y);
            }
            if (FlxG.mouse.justPressed) {
                updateInfo = !updateInfo;
            }
        }

        if (FlxG.keys.justPressed.P) {
            trace("Hm. Something like this, maybe?\n\n---------------------------\n\n"
            + "var pissinShit:FlxText = new FlxText(15, 30, 0, character.name + \" || \" + character.pronouns, 16);\n"
            + "var picture:CharacterPicture = new CharacterPicture(15, pissinShit.y + 30, character.filename, someURL, pissyShit)");
        }
        #end

        if (pigstep != null) {
            pigstep.update(elapsed);
        }
        if (pig != null) {
            if (pigstep != null) pig.text = Std.string((2022 - pigstep.value));
            pig.update(elapsed);
        }
    }
    var updateInfo:Bool = true;
    #if debug
    function doPeenScale(Change:Float = 0) {
        curScaling += Change;
        if (curScaling <= 0) {
            warnScale = true;
        } else {
            warnScale = false;
        }
        penis_png.setGraphicSize(Std.int(pisswidth * curScaling));
        penis_png.updateHitbox();
    }
    var testText:FlxText;
    #end
    var pigstep:FlxUINumericStepper;
    var pig:FlxText;
    override function create() {
        golem = {
            name: "Blitz",
            pic: 'blitz',
            prns: 'he/they',
            headcanon: 'gets along with alphagolem despite his dislike of medabots'
        };
        shit = new BackgroundSprite().loadImage("winDesat").fitToScreen();
        shit.setRandomBackground();
        add(shit);
        pig = new FlxText(0, 500, 0, "piss", 16);
        add(pig);
        pigstep = new FlxUINumericStepper(0, 470, 1, 2022, 1950, 2022, 0);
        add(pigstep);
        testPng = new CharacterPicture(125, 125, "Assets/Images/ralph but funky.png", "https://www.youtube.com/watch?v=upjWzWao-Bg", "you are going to brazil");
        testPng.alpha = 0.7;
        testPng.setGraphicSize(Std.int(testPng.width * 0.3));
        testPng.updateHitbox();
        add(testPng);

        #if debug
        testText = new FlxText(0, 0, 0, "Picture X:\nPicture Y:\nPicture scale:\nMouse X:\nMouse Y:\nMouse hovering over UI box:");
        testText.setFormat(FileUtils.getFont("trebucbd.ttf"), 18, FlxColor.RED, LEFT);
        add(testText);
        #end

        peenUI = new FlxUITabMenu(null, blitz);
        peenUI.resize(500, 550);
        peenUI.setPosition(FlxG.width - 525, 15);
        add(peenUI);
        setupPeen();
    }
    var penis_png:CharacterPicture;
    function setupPeen() {
        testing = new FlxUI(null, peenUI);
        testing.name = 'TEST';

        var shitpost:FlxText = new FlxText(15, 30, 0, "Blitz || He/They");
        shitpost.setFormat("HP Simplified", 16, FlxColor.BLUE, CENTER);
        penis_png = new CharacterPicture(15, 48, FileUtils.image("CharPics/blitz"), "https://www.youtube.com/watch?v=fueRUi5AWWQ", "PISSIN ON THE MOON!!");
        #if debug
        pisswidth = penis_png.width;
        #end
        penis_png.setGraphicSize(Std.int(#if debug pisswidth #else penis_png.width #end * 0.34));
        penis_png.updateHitbox();
        testing.add(penis_png);
        testing.add(shitpost);
        peenUI.addGroup(testing);
    }
    #if debug
    var pisswidth:Float = 101;
    #end
    function amogus(shitInMyVagina:FlxTween) {
        testPng.updateHitbox();
    }
}

/**Testing values.*/
abstract TestingShit(Dynamic) from String to Dynamic {

}

typedef TestingCharacter = {
    var name:String;
    var pic:String;
    var prns:String;
    var headcanon:String;
}