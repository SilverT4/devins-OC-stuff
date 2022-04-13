package;

import utils.FlxUIDropDownMenuCustom;
import characterUtils.SpeciesThingie;
import characterUtils.CharInfo;
import characterUtils.CharacterPicture;
import characterUtils.CharInfo.FavouriteStuff;
import characterUtils.CharInfo.Headcanon;
import characterUtils.CharInfo.CharInfoJsonUtil;
import extraShit.*;
import flixel.addons.ui.*;
import flixel.ui.*;
import flixel.text.*;
import flixel.util.*;
import flixel.*;
import flixel.group.*;
import haxe.extern.EitherType;
using StringTools;

/**This is going to be the main UI state, displaying information about an OC. I'm including some debug-related things in debug builds, such as the ability to add things directly in game if possible.
    @since 0.0.3 (early April 2022)*/
class InfoState extends FlxState {
    #if debug
    var pissButton:FlxButton;
    function addButton() {
        pissButton = new FlxButton(FlxG.mouse.x, FlxG.mouse.y, "SAMPLE", function() {
            FlxG.sound.play(FileUtils.sound("errorSound", null, false), 1, false, null, true, function() {
                trace("Information about this button:\nX position: " + pissButton.x + "\nY position: " + pissButton.y);
            });
        });
        pissButton.cameras = [poopyCam];
        add(pissButton);
    }
    var testerInt:Int = 0;
    var pissyThing:CharInfo;
    var pissSpecies:Species;
    var pissSubSpecies:Subspecies;
    var pissday:Birthday = {
        month: "May",
        day: 4,
        year: 1989
    }
    var pissheight:Height = {
        ft: 7,
        inch: 3
    }
    var languages:Array<String> = ["English", "German", "Understands Dutch"];
    #end
    var theChar:Dynamic;
    var cursorCamera:FlxCamera;
    var infoUI:FlxUITabMenu;
    var mainBox:FlxUI; // the main box. contains name, nickname, etc.
    var hcBox:FlxUI; // the headcanon box. self-explanatory.
    var fsBox:FlxUI; // the favourites box.
    var specBox:FlxUI; // the species info box.
    var tabussy = [
        { name: "Main", label: "About this OC" },
        { name: "HC", label: "Headcanons" },
        { name: "Fav", label: "Favourites" },
        { name: "Species", label: "Species Info" }
    ]; // tablist bc yes || not quite ready to add species thing yet.
    public function new(#if !debug characterInfo:EitherType<CharInfo, JsonFormat_CIMain> #end) { // I'M GONNA BE USING A CHARACTER IN DEBUG BUILDS TO TEST!!
        super();
        #if debug
        pissSpecies = new Species("Robot", "The definition of robot varies, but to me it's pretty much just... Anything mechanic in nature, whether sentient or not.", "Unknown"); // that's my definition - devin503
        pissSubSpecies = new Subspecies("Were-con", "A subspecies of Mini-con that can be more aggressive in nature. They're basically werewolf Mini-cons, hence the name.", "Mini-con", false, "devin503");
        testerInt = FlxG.random.int(0, 1);
        pissyThing = new CharInfo("Gear", null, ((testerInt == 0) ? pissSpecies : pissSubSpecies), pissday, pissheight, languages, new FavouriteStuff("Unsure", ["Blue", "Green"], ["Mostly puzzle games on the DS"], "Unsure"), [
            new Headcanon("Very much prefers tea over coffee.", "I came up with the character?", null, "ass")
        ]);
        #else
        if (characterInfo is CharInfo) {
            theChar = characterInfo;
        } else {
            theChar = CharInfoJsonUtil.moonPiss(theChar);
        }
        #end
    }
    var pissBg:BackgroundSprite;
    var pissBgFile:String = 'winDesat.png';
    var pissyCursorShit:CustomMouseCursor;
    var poopyCam:FlxCamera;
    override function create() {
        poopyCam = new FlxCamera();
        poopyCam.bgColor.alpha = 0;
        poopyCam.scroll = FlxG.camera.scroll;
        FlxG.cameras.add(poopyCam);
        //FlxG.cameras.reset(poopyCam);
        FlxG.cameras.setDefaultDrawTarget(poopyCam, true);
        pissBg = new BackgroundSprite();
        pissBg.loadImage("Assets/Images/" + pissBgFile);
        pissBg.fitToScreen();
        pissBg.color = 0xFFFFFF00; // settin it directly bc yes
        add(pissBg);
        cursorCamera = new FlxCamera();
        cursorCamera.bgColor.alpha = 0;
        FlxG.cameras.add(cursorCamera, false);
        pissyCursorShit = new CustomMouseCursor();
        pissyCursorShit.visible = !FlxG.mouse.visible;
        pissyCursorShit.cameras = [cursorCamera];
        add(pissyCursorShit);
        infoUI = new FlxUITabMenu(null, tabussy);
        infoUI.resize(500, 550);
        infoUI.setPosition(FlxG.width - 575, 25);
        add(infoUI);
        addMainUi();
        headass();
        // i need to set up the UI elements and functions. lmao
    }

    var charName:FlxText;
    // var charNick:FlxText; I'm making charName include the age and nickname as well!!
    var charSpecQuick:FlxText;
    #if debug
    var GEAR:CharacterPicture; // THE SAME SCALING I USE IN TESTING FOR BLITZ SHOULD WORK FOR GEAR, I BELIEVE!!
    #else
    var charPic:CharacterPicture;
    #end
    var charAge:String = '';
    var nameString:String = "";
    var _stDates:Array<Int> = [
        1,
        21,
        31
    ];
    var _ndDates:Array<Int> = [
        2,
        22
    ];
    function addMainUi() {
        mainBox = new FlxUI(null, infoUI);
        mainBox.name = "Main";
        var forLessCondits:CharInfo = #if debug pissyThing #else theChar #end;
        var bdayShit = (_stDates.contains(forLessCondits.birthday.day)) ? forLessCondits.birthday.day + "st" : (_ndDates.contains(forLessCondits.birthday.day)) ? forLessCondits.birthday.day + "nd" : forLessCondits.birthday.day + "th";
        var monthFormatted = CharInfo.getSHIT(forLessCondits.birthday.month);
        var formattedbirthday = (forLessCondits.birthday.year != null) ? bdayShit + " " + monthFormatted + ", " + forLessCondits.birthday.year : bdayShit + " " + monthFormatted;
        nameString = forLessCondits.name + " | " + ((forLessCondits.nickname != null) ? forLessCondits.nickname : "No nickname");
        if (forLessCondits.age != null) {
            if (forLessCondits.age is Int) {
                charAge = forLessCondits.age + " years old";
            } else {
                charAge = forLessCondits.age;
            }
            nameString += " | " + charAge;
        }
        charName = new FlxText(15, 10, 0, nameString, 14);
        charName.setFormat(FileUtils.getFont("trebuc.ttf"), 14, FlxColor.BLACK, LEFT);
        #if debug
        GEAR = new CharacterPicture(15, charName.y + 20, FileUtils.image("CharPics/gear.png", null, true), "https://wattpad.com/stories/jiafei", "yes i put a wattpad thing");
        GEAR.scale.set(0.35, 0.35);
        GEAR.updateHitbox();
        mainBox.add(GEAR);
        #else
        //WIP!!
        #end
        var thePic = #if debug GEAR #else charPic #end;
        var speciesQuick = forLessCondits.species.name;
        charSpecQuick = new FlxText(15, thePic.height + 30, 0, speciesQuick, 14);
        charSpecQuick.setFormat(FileUtils.getFont("trebuc.ttf"), 14, FlxColor.BLACK, LEFT);
        mainBox.add(charSpecQuick);

        mainBox.add(charName);
        infoUI.addGroup(mainBox);
    }
    var pissDroplet:FlxUIDropDownMenuCustom;
    function headass() {
        hcBox = new FlxUI(null, infoUI);
        hcBox.name = "HC";

        pissDroplet = new FlxUIDropDownMenuCustom(15, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray(['your mom', 'bussy'], true), fuckYou);

        hcBox.add(pissDroplet);
        infoUI.addGroup(hcBox);
    }

    function fuckYou(asshead:String) {
        pissDroplet.selectedLabel = "your mom";
    }
    #if debug
    var testPicture:CharacterPicture;
    function doPictureShit() {
        testPicture = new CharacterPicture(0, 0, FileUtils.image("cyan-robo", null, false), "https://google.com", "this literally just goes to google. lmao");
        add(testPicture);
        ogWidth = testPicture.width;
        picInfo = new FlxText(0, 50, 0, "", 12);
        picInfo.setFormat("_sans", 12, FlxColor.WHITE, LEFT);
        add(picInfo);
    }
    var picInfo:FlxText;
    var enormousPeen:String = "";
    var pissyScale:Float = 1;
    var ogWidth:Float = 1;
    var moveTestPic:Bool = false;
    function doScale(scrollUp:Bool) {
        if (scrollUp) {
            pissyScale += 0.01;
        } else {
            pissyScale -= 0.01;
        }
        if (testPicture != null) {
            testPicture.setGraphicSize(Std.int(ogWidth * pissyScale));
            testPicture.updateHitbox();
        }
    }
    var mouseDir:String = "in neither direction";
    var susX:Float = 0;
    var susY:Float = 0;
    #end
    override function update(elapsed:Float) {
        super.update(elapsed);

        #if debug
        if (GEAR != null) {
            if (GEAR.visible && FlxG.mouse.overlaps(GEAR) && FlxG.mouse.justPressed) {
                GEAR.openMyURL();
            }
            GEAR.update(elapsed);
        }
        if (FlxG.keys.justPressed.SPACE && pissyThing != null) {
            openSubState(new HeadcanonPictureSubstate(pissyThing.headcanons[0]));
        }
        if (FlxG.keys.justPressed.B) addButton();
        susX = FlxG.mouse.x;
        susY = FlxG.mouse.y;
        if (FlxG.keys.justPressed.P && testPicture == null && picInfo == null) doPictureShit();

        if (FlxG.keys.justPressed.L) moveTestPic = !moveTestPic;
        if (testPicture != null) {
            testPicture.update(elapsed);
            if (moveTestPic) {
                enormousPeen = pissyScale + "||" + testPicture.scale;
                testPicture.setPosition(susX, susY);
                if (picInfo != null) {
                    picInfo.text = "Image X: "
                    + testPicture.x
                    + "\nImage Y: "
                    + testPicture.y
                    + "\nImage scale: "
                    + enormousPeen
                    + "\nMouse currently scrolling "
                    + mouseDir + "\n";
                }
                if (FlxG.mouse.wheel == -1) {
                    doScale(false);
                }
                if (FlxG.mouse.wheel == 1) {
                    doScale(true);
                }
            }
        }
        if (picInfo != null) picInfo.update(elapsed);
        if (FlxG.mouse.wheel == -1) {
            mouseDir = "in neither direction";
        } else if (FlxG.mouse.wheel == 1) {
            mouseDir = "up";
        } else {
            mouseDir = "down";
        }
        #end

        if (pissyCursorShit != null) {
            //if (pissyCursorShit.visible) pissyCursorShit.setPosition(FlxG.mouse.x, FlxG.mouse.y);
            #if debug
            if (pissButton != null && FlxG.mouse.overlaps(pissButton)) {
                pissyCursorShit.switchAnim("idle");
            } else {
                if (pissyCursorShit.animation.curAnim != null && pissyCursorShit.animation.curAnim.name != "idle") pissyCursorShit.switchAnim('idle');
            }
            #end
            pissyCursorShit.update(elapsed);
        }
    }
}