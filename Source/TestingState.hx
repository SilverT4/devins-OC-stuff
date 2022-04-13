package;

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

***
### Reset history

This section keeps track of when I've reset this file to a base class.

Reset 1: April 13th, 2022. I'm resetting this to attempt to figure out a real layout for the info state.
    
*Final commit before reset: TBD*

***
@since April 4th, 2022. This will not be included in any release builds.*/
class TestingState extends FlxState {
    var theBack:BackgroundSprite;
    var theMouse:CustomMouseCursor;
    var mouseCam:FlxCamera;
    var testCharacter:CharInfo;
    var infoBox:FlxUITabMenu;
    var mainShit:FlxUI;
    var hcShit:FlxUI;
    var specShit:FlxUI;
    public function new() {
        super();
        testCharacter = new CharInfo("Blitz", null, new Subspecies("Were-con", "Were-cons are a subspecies of Mini-con. Think of them as werewolf Mini-cons, just nowhere near as violent as real werewolves.", "Mini-con", false, "devin503"), {
            month: "April",
            day: 12,
            year: 2004
        }, { ft: 7, inch: 1 }, ["English", "Dutch"], new FavouriteStuff("Chillwave", ["Blue", "Purple"], ["Luigi's Mansion", "Minecraft"], "Simple"), [
            new Headcanon("Gets along with Alphagolem", "April 3rd, 2022", "Although they don't show it around others, Blitz and Alphagolem get along with each other, despite his dislike of Medabots due to an event in his past. Blitz respected Alphagolem's bravery and gave him a chance, and hasn't regretted it."),
            new Headcanon("Sometimes sleeps with Alphagolem", "April 3rd, 2022", "Adding onto the first one, they do sometimes sleep together, usually with Alphagolem just leaning on Blitz when they're sitting, or with Alphagolem on his chest if they're lying down. Nobody has caught on yet, instead just assuming Alphagolem's being brave.") // THESE HEADCANONS ARE FROM BLITZ'S GOOGLE DOC.
        ]);
    }
    var tabThing = [
        { name: "Main", label: "About the OC" },
        { name: "HC", label: "Headcanons" },
        { name: "Species", label: "Species Info" }
    ];
    override function create() {
        theBack = new BackgroundSprite();
        theBack.loadImage(FileUtils.image("winDesat", null, false));
        theBack.color = -11496759;
        theBack.fitToScreen();
        add(theBack);
        mouseCam = new FlxCamera();
        mouseCam.bgColor.alpha = 0;
        FlxG.cameras.add(mouseCam, false);
        theMouse = new CustomMouseCursor();
        theMouse.cameras = [mouseCam];
        theMouse.changeColor(theBack.color);
        add(theMouse);
        infoBox = new FlxUITabMenu(null, tabThing);
        infoBox.resize(500, 550);
        infoBox.setPosition(FlxG.width - 525, 15);
        infoBox.selected_tab_id = "Main";
        add(infoBox);
        mainUIShit();
        headass();
    }

    function mainUIShit() {
        mainShit = new FlxUI(null, infoBox);
        mainShit.name = "Main";
        var ageFormat = ((testCharacter.age is Int) ? testCharacter.age + " year old" : testCharacter.age);
        var nameFormat = testCharacter.name
                    + " | "
                    + ((testCharacter.nickname != null) ? testCharacter.nickname : "No nickname")
                    + " | "
                    + ageFormat + " " + testCharacter.species.name;
        var nameText:FlxText = new FlxText(15, 30, 0, nameFormat, 14);
        mainShit.add(nameText);
        infoBox.addGroup(mainShit);
    }
    var hcNameList:Array<String> = [];
    var hcDropper:FlxUIDropDownMenuCustom;
    var hcSince:FlxText;
    var hcExpand:FlxText;
    function headass() {
        hcShit = new FlxUI(null, infoBox);
        hcShit.name = "HC";

        hcNameList = getHeadcanonList();

        hcDropper = new FlxUIDropDownMenuCustom(15, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray(hcNameList, true), doHeadBullshit);
        hcDropper.width += 50;
        hcDropper.selectedLabel = hcNameList[0];
        hcSince = new FlxText(15, hcDropper.y + 30, 0, "PICK SOMETHIN!", 14);
        hcSince.setFormat(FileUtils.getFont("HYYoyo_Regular.ttf"), 14, FlxColor.BLACK);
        hcShit.add(hcSince);
        hcShit.add(hcDropper);
        infoBox.addGroup(hcShit);
    }

    function doHeadBullshit(hc:String) {
        var that:Headcanon = testCharacter.headcanons[Std.parseInt(hc)];
        hcDropper.selectedLabel = hcNameList[Std.parseInt(hc)];
        hcSince.text = that.since;
        hcSince.fieldWidth = 0;
        if (that.expandedInfo != null) {
            hcExpand.text = formatAttempt(that.expandedInfo);
            hcExpand.fieldWidth = 0;
        } else {
            hcExpand.text = "No extra info";
            hcExpand.fieldWidth = 0;
        }
    }

    function formatAttempt(hcInfo:String) {
        var eee = hcInfo.split(' '); // split by spaces idk
        var returnMe:String = "";
        trace(eee);
        for (word in eee) {
            if (eee.indexOf(word) % 5 == 5) {
                returnMe += word + #if debug "(NL)\n" #else "\n"#end;
            } else {
                returnMe += word + " ";
            }
        }
        trace(returnMe);
        return returnMe;
    }

    function getHeadcanonList() {
        var theList:Array<String> = [];
        if (testCharacter.headcanons.length > 0) {
            for (head in testCharacter.headcanons) {
                var hcIndex = testCharacter.headcanons.indexOf(head) + 1;
                trace("addin hc " + hcIndex + " of " + testCharacter.headcanons.length + ".");
                theList.push(head.headCanon);
            }
        } else {
            theList.push("NO HEADCANONS");
        }
        return theList;
    }
    override function update(elapsed:Float) {
        super.update(elapsed);
        if (theMouse != null) {
            theMouse.update(elapsed);
        }
    }
}