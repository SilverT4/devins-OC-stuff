package;

import lime.system.Clipboard;
import HeadcanonPictureSubstate.HeadcanonPicture;
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
        testCharacter = new CharInfo("Blitz", null, new Subspecies("Were-con", "Were-cons are a subspecies of Mini-con. \nThink of them as werewolf Mini-cons,\njust nowhere near as violent as real werewolves.", "Mini-con", false, "devin503"), {
            month: "April",
            day: 12,
            year: 2004
        }, { ft: 7, inch: 1 }, ["English", "Dutch"], new FavouriteStuff("Chillwave", ["Blue", "Purple"], ["Luigi's Mansion", "Minecraft"], "Simple"), [
            new Headcanon("Gets along with Alphagolem", "April 3rd, 2022", "Although they don't show it around others,\nBlitz and Alphagolem get along with each other,\ndespite his dislike of Medabots due to an event in his past.\nBlitz respected Alphagolem's bravery and gave him a chance,\nand hasn't regretted it."),
            new Headcanon("Sometimes sleeps with Alphagolem", "April 3rd, 2022", "Adding onto the first one, they do sometimes sleep together,\nusually with Alphagolem just leaning on Blitz when they're sitting,\nor with Alphagolem on his chest if they're lying down.\nNobody has caught on yet,\ninstead just assuming Alphagolem's being brave."), // THESE HEADCANONS ARE FROM BLITZ'S GOOGLE DOC.
            new Headcanon("Got injured defending a friend", "test thingy", "This is a test thingy.\nI just want to see the button workin properly", "ass")
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
        speciesBox();
    }
    var picTure:CharacterPicture;
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
        picTure = new CharacterPicture(15, nameText.y + 16, FileUtils.image("CharPics/blitz.png", null, true));
        picTure.scale.set(0.35, 0.35);
        picTure.updateHitbox();
        mainShit.add(picTure);
        mainShit.add(nameText);
        infoBox.addGroup(mainShit);
    }
    var hcNameList:Array<String> = [];
    var hcDropper:FlxUIDropDownMenuCustom;
    var hcSince:FlxText;
    var hcExpand:FlxText;
    var hcPicButton:FlxButton;
    function headass() {
        hcShit = new FlxUI(null, infoBox);
        hcShit.name = "HC";

        hcNameList = getHeadcanonList();

        hcDropper = new FlxUIDropDownMenuCustom(15, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray(hcNameList, true), doHeadBullshit);
        hcDropper.width += 50;
        hcDropper.selectedLabel = hcNameList[0];
        hcSince = new FlxText(15, hcDropper.y + 30, 0, "PICK SOMETHIN!", 14);
        hcSince.setFormat(FileUtils.getFont("HYYoyo_Regular.ttf"), 14, FlxColor.BLACK);
        hcExpand = new FlxText(15, hcSince.y + 16, 0, "Amogus", 12);
        hcExpand.setFormat(FileUtils.getFont("HYYoyo_Regular.ttf"), 12, FlxColor.BLACK);
        hcPicButton = new FlxButton(hcDropper.width + 120, hcDropper.y, "View Image", imageBullshit);
        hcShit.add(hcExpand);
        hcShit.add(hcSince);
        hcShit.add(hcDropper);
        hcShit.add(hcPicButton);
        infoBox.addGroup(hcShit);
    }
    var curHc:Headcanon;

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
        if (that.imageName != null) {
            curHc = that;
            hcPicButton.revive();
        } else {
            curHc = that;
            hcPicButton.kill();
        }
    }

    function imageBullshit() {
        openSubState(new HeadcanonPictureSubstate(curHc));
    }

    function formatAttempt(hcInfo:String) {
        var returnMe:String = "";
        var eee = hcInfo.split(' '); // split by spaces idk
        if (hcInfo.contains('\n')) {
            returnMe = hcInfo;
            trace("already including new lines. nice");
        } else {
            trace(eee);
            var sinceLastNL:Int = 0; // idk how modulo works (modulo is something like 4 % 2 for those who dont know it lmfao) so im using ints
            var nlIndexes:Array<Int> = [];
            for (word in eee) {
                var bruh = eee.indexOf(word) % 5;
                if (bruh == 4 && eee.indexOf(word) != eee.length - 2) {
                    returnMe += word + "\n";
                    //sinceLastNL = 0;
                    nlIndexes.push(eee.indexOf(word));
                } else {
                    returnMe += word + " ";
                    //sinceLastNL++;
                }
                trace(eee.indexOf(word) % 5);
            }
            returnMe += "\n";
            trace(returnMe);
            if (nlIndexes.length > 0) trace("new lines inserted at these indexes:\n" + nlIndexes.join(", "));
        }
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

    function speciesBox() {
        specShit = new FlxUI(null, infoBox);
        specShit.name = "Species";

        var theSpecies:Subspecies = new Subspecies(testCharacter.species.name, testCharacter.species.description, "Mini-con", false, "devin503");

        var nameThing:FlxText = new FlxText(15, 30, theSpecies.name, 14);
        nameThing.setFormat(FileUtils.getFont("HYYoyo_Regular.ttf"), 14, FlxColor.BLACK);
        var parentSpec:FlxText = new FlxText(15, nameThing.y + 16, theSpecies.extending, 14);
        parentSpec.setFormat(FileUtils.getFont("HYYoyo_Regular.ttf"), 14, FlxColor.BLACK);
        var creatorThing:FlxText = new FlxText(15, parentSpec.y + 16, theSpecies.ogMedia, 14);
        creatorThing.setFormat(FileUtils.getFont("HYYoyo_Regular.ttf"), 14, FlxColor.BLACK);
        var descTest:FlxText = new FlxText(15, creatorThing.y + 16, formatAttempt(theSpecies.description) + "\n", 14);
        descTest.setFormat(FileUtils.getFont("HYYoyo_Regular.ttf"), 14, FlxColor.BLACK);
        specShit.add(descTest);
        specShit.add(nameThing);
        specShit.add(parentSpec);
        specShit.add(creatorThing);
        infoBox.addGroup(specShit);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (theMouse != null) {
            theMouse.update(elapsed);
        }
        #if debug
        if (FlxG.keys.justPressed.L) Clipboard.text = Json.stringify(testTemplateThingy, "\t");
        #end
    }

    #if debug
    var testTemplateThingy:JsonFormat_CIMain = {
        name: "Test Character",
        nickname: "AMONG US!!",
        height: {
            ft: 5,
            inch: 3
        },
        birthday: {
            month: "January",
            day: 1,
            year: 2001
        },
        favourites: {
            MusicGenre: "Soundtrack",
            Colours: [
                "Blue",
                "Green",
                "White"
            ],
            Aesthetic: "Pastel",
            VideoGames: [
                "Among Us",
                "Animal Crossing"
            ]
        },
        languageList: [
            "English",
            "German",
            "Sus"
        ],
        headcanons: [
            {
                headCanon: "eeeee",
                since: "pee",
                expandInfo: "Your mom",
                imageName: "ass"
            }
        ],
        species: {
            name: "Example Subspecies",
            isSub: true,
            parent: "Example Species"
        }
    }
    #end
}