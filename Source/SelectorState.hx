package;

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
    var pissyDisplay:FlxText;
    var iLoveLean:FlxText;
    var skeet:FlxText;
    var debugBg:BackgroundSprite;
    var meat:FlxTypedGroup<FlxSprite>; // gonna make a "cover" thing with flxsprites idk
    override function create() {
        debugBg = new BackgroundSprite();
        debugBg.loadImage(FileUtils.image("centras_nh", null, false));
        debugBg.fitToScreen();
        debugBg.updateHitbox();
        debugBg.setRandomBackground();
        add(debugBg);
        startinProps = { alpha: 1, y: (FlxG.height / 2) };
        pissyDisplay = new FlxText(FlxG.width / 2, -2000, 0, charList[0], 16);
        //pissyDisplay.screenCenter();
        add(pissyDisplay);
        super.create();
        yassified = { onComplete: outer };
        dumb = { onComplete: pegMyBussy };
        jesus = debugBg.getGraphicMidpoint().x;
        inProps = { x: jesus, alpha: 1 };
        FlxTween.tween(pissyDisplay, startinProps, 0.5, dumb);
        meat = new FlxTypedGroup();
        add(meat);
        for (i in 0...10) {
            trace("item " + i);
                var topping:FlxSprite = new FlxSprite(0, (50 * i));
                topping.makeGraphic(FlxG.width, 100, 0xFF000000);
                meat.add(topping);
        }
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.LEFT) {
            changeSelection(-1);
        }
        if (FlxG.keys.justPressed.RIGHT) {
            changeSelection(1);
        }
        if (FlxG.keys.justPressed.ENTER) {
            doFunny();
        }
        super.update(elapsed);
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
    var curSelecc:Int = 0;
    function changeSelection(change:Int = 0) {
        FlxG.sound.play(FileUtils.sound("xpNavigate.ogg", null, true));
        curSelecc += change;
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