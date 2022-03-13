package extraShit;

import flixel.math.FlxRandom;
import flixel.FlxG;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxBasic.IFlxBasic;
import flixel.animation.FlxAnimationController;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxBitmapDataUtil;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDirectionFlags;
import flixel.FlxSprite;
import FileUtils;

using flixel.util.FlxColorTransformUtil;

class BackgroundSprite extends FlxSprite{
    public function new() {
        super(0);
    }

    public function loadImage(ImagePath:String) {
        if (FileUtils.existential(ImagePath)) {
            loadGraphic(ImagePath);
        } else {
            loadGraphic(FileUtils.pic(ImagePath));
        }
    }

    public function fitToScreen() {
        setGraphicSize(FlxG.width, FlxG.height);
        scrollFactor.set();
        updateHitbox();
    }

    public function switchImage(ImagePath:String) {
        graphic.destroy();
        loadImage(ImagePath);
    }
    var rand:FlxRandom;
    public function setRandomBackground() {
        trace('SETTING A RANDOM COLOUR!!');
        rand = new FlxRandom();
        var RandColor = rand.color(0xFF000000, 0xFFFFFFFF);
        trace(RandColor);
        makeGraphic(16, 16, RandColor);
    }
}