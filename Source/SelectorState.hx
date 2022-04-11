package;

import flixel.text.FlxText.FlxTextFormat;
#if mobile
import flixel.input.touch.*;
#end
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.*;
import flixel.text.*;
import flixel.addons.ui.*;
import flixel.ui.*;
import flixel.tweens.FlxTween;
import flixel.*;
import extraShit.BackgroundSprite;
import characterUtils.CharInfo;
import CustomMouseCursor;
using StringTools;

/**I don't know what I'm really *doing* with this state, tbh. You can check out its history to see different ideas I've tried for it. lmfao
    @since 0.0.3 (early April 2022)*/
class SelectorState extends FlxState {

    function getToppings() {
        var shel = FlxG.width;
        var cheese:FlxSprite = new FlxSprite(0).makeGraphic(shel, 100, 0xFF000000);
        meat.add(cheese);
        var sourCvm:FlxSprite = new FlxSprite(0, FlxG.height - 100).makeGraphic(shel, 100, 0xFF000000);
        meat.add(sourCvm);
        var watermelon:FlxSprite = new FlxSprite(0).makeGraphic(250, FlxG.height, 0xFF000000);
        meat.add(watermelon);
        var penisJuice:FlxSprite = new FlxSprite(FlxG.width - 250).makeGraphic(250, FlxG.height, 0xFF000000);
        meat.add(penisJuice);
        iLoveLean = new FlxText(watermelon.getGraphicMidpoint().x, watermelon.getGraphicMidpoint().y, 0, "<--", 24);
        iLoveLean.setFormat("Trebuchet MS", 24, FlxColor.WHITE, CENTER);
        skeet = new FlxText(penisJuice.getGraphicMidpoint().x, watermelon.getGraphicMidpoint().y, 0, "-->", 24);
        skeet.setFormat("Trebuchet MS", 24, FlxColor.WHITE, CENTER);
        #if mobile
        add(touchable);
        touchable.add(iLoveLean);
        touchable.add(skeet);
        #else
        add(iLoveLean);
        add(skeet);
        #end
    }
    /**Buy sexy jiafei product to cure your mother's cvm obsession 🥰🥰🥰
    
    ***
    
    In all seriousness, this variable will be the *name* of the character you select in this state.*/
    var jiafei:String = "product";
    var charList:Array<String> = [];
    public function new() {
        super();
        #if !debug
        if (FileUtils.fileExists("charlist.txt")) {
            charList = FileUtils.getTextContent("charlist.txt", null, true, "\n"); //idk
        } else {
            throw new haxe.Exception("No character list found.");
        }
        #else
        charList = ["Sus", "Gear (Won't Crash)"];
        #end
    }
    var menuShit:Array<String> = ["Default", "Alphabetical", "By species"];
    var pissyDisplay:FlxText;
    var iLoveLean:FlxText;
    var skeet:FlxText;
    var down:FlxText;
    var upscroll:FlxText; // for scrolling up/down in the future.
    var debugBg:BackgroundSprite;
    var meat:FlxTypedGroup<FlxSprite>; // gonna make a "cover" thing with flxsprites idk
    override function create() {
        lean = FlxG.random.int(0, 10);
        debugBg = new BackgroundSprite();
        debugBg.loadImage(FileUtils.image("centras_nh", null, false));
        debugBg.fitToScreen();
        debugBg.updateHitbox();
        if (lean == 5) debugBg.color = FlxColor.PURPLE else debugBg.setRandomBackground();
        add(debugBg);
        startinProps = { alpha: 1, y: (FlxG.height / 2) };
        pissyDisplay = new FlxText(FlxG.width / 2, -2000, 0, charList[0], 16);
        pissyDisplay.setFormat(FileUtils.getFont("HYYoyo_Regular.ttf", true), 20, FlxColor.WHITE, CENTER);
        //pissyDisplay.screenCenter();
        add(pissyDisplay);
        super.create();
        #if mobile
        touchable = new FlxTypedGroup();
        //add(touchable);
        #end
        yassified = { onComplete: outer };
        dumb = { onComplete: pegMyBussy };
        jesus = debugBg.getGraphicMidpoint().x;
        inProps = { x: jesus, alpha: 1 };
        FlxTween.tween(pissyDisplay, startinProps, 0.5, dumb);
        meat = new FlxTypedGroup();
        add(meat);
        getToppings();
    }
    #if mobile
    var noob:FlxTouch;
    var touchable:FlxTypedGroup<Dynamic>;
    #end
    override function update(elapsed:Float) {
        #if (desktop || web)
        if (FlxG.keys.justPressed.LEFT) {
            changeSelection(-1);
        }
        if (FlxG.keys.justPressed.RIGHT) {
            changeSelection(1);
        }
        if (FlxG.keys.justPressed.ENTER) {
            doFunny();
        }
        if (FlxG.keys.justPressed.DOWN) {
            trace("NOT FINISHED WITH THIS.");
        }
        if (FlxG.keys.justPressed.UP) {
            trace("NOT FINISHED WITH THIS.");
        }
        #elseif mobile
        if (FlxG.touches.getFirst() != null) {
            noob = FlxG.touches.getFirst();
            if (touchable != null) {
                for (item in touchable) {
                    if (noob.overlaps(item) && noob.justPressed) {
                        if (item == iLoveLean) changeSelection(-1);
                        else if (item == skeet) changeSelection(1);
                    }
                }
            }
        }
        /*if (debugBg != null) {
            trace("pee"); // i need to figure out how these work!!
        }*/
        #end
        super.update(elapsed);
    }
    var curMenu:Int = 0;
    function switchMenus(change:Int = 0) {
        curMenu += change;
        if (curMenu >= menuShit.length) {
            curMenu = 0;
        }
        if (curMenu < 0) {
            curMenu = menuShit.length - 1;
        }
        //i need to set up the tweens for menu changes!
    }
    function doFunny() {
        #if debug
        if (charList[curSelecc] == "Sus") {
            FlxG.sound.play(FileUtils.sound("theFunnyWell", null, false), 1, false, null, true, function() {
                throw new haxe.Exception("PISS!!");
            });
        } else {
            FlxG.switchState(new InfoState());
        }
        #else
        //wip
        #end
    }
    var jesus:Float = 0;
    var lean:Int = 0;
    var curSelecc:Int = 0;
    var funnyProp = { x: 1, y: 1 };
    function changeSelection(change:Int = 0) {
        FlxG.sound.play(FileUtils.sound("xpNavigate.ogg", null, true));
        curSelecc += change;
        if (change == -1) {
            if (iLoveLean != null) {
                iLoveLean.scale.set(2, 2);
                //iLoveLean.updateHitbox();
                FlxTween.tween(iLoveLean.scale, funnyProp, 0.5, { onComplete: function(pee:FlxTween) {
                    iLoveLean.updateHitbox();
                }});
                FlxTween.color(iLoveLean, 0.5, 0xFF00FFFF, 0xFFFFFFFF);
            }
        }
        if (change == 1) {
            if (skeet != null) {
                skeet.scale.set(2, 2);
                //skeet.updateHitbox();
                FlxTween.tween(skeet.scale, funnyProp, 0.5, { onComplete: function(pee:FlxTween) {
                    skeet.updateHitbox();
                }});
                FlxTween.color(skeet, 0.5, 0xFF00FFFF, 0xFFFFFFFF);
            }
        }
        if (curSelecc < 0) {
            curSelecc = charList.length - 1;
        }
        if (curSelecc >= charList.length) {
            curSelecc = 0;
        }
        if (pissyDisplay != null) {
            FlxTween.tween(pissyDisplay, outProps, 0.5, yassified);
        }
    }
    var startinProps = { };
    var outProps = { x: 2300, alpha: 0 };
    var inProps = { };
    var yassified = {  };
    var dumb = {  };
    var tweenie:FlxTween;

    function pegMyBussy(beforeIShart:FlxTween) {
        trace("COOL!");
        pissyDisplay.screenCenter(X);
    }

    function outer(pee:FlxTween) {
        pissyDisplay.x = -500;
        trace("i see your piss");
        pissyDisplay.text = charList[curSelecc];
        pissyDisplay.fieldWidth = 0;
        FlxTween.tween(pissyDisplay, inProps, 0.5, dumb);
    }
}