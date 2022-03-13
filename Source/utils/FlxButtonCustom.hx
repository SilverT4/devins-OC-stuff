package utils;

import flash.events.MouseEvent;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.atlas.FlxNode;
import flixel.graphics.frames.FlxTileFrames;
import flixel.input.FlxInput;
import flixel.input.FlxPointer;
import flixel.input.IFlxInput;
import flixel.input.mouse.FlxMouseButton;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxDestroyUtil;
import flixel.ui.FlxButton;
import FileUtils;
#if FLX_TOUCH
import flixel.input.touch.FlxTouch;
#end

/**A simple button with the option for multiple callbacks.
@since 0.0.2 (March 2022)*/
class FlxButtonCustom extends FlxButton {
    private var callbackList:Array<Dynamic> = [];
    public function new(x:Float, y:Float, ?LabelText:String, ?InitialCallback:Void->Void) {
        if (LabelText != null && InitialCallback == null) {
            super(x, y, LabelText);
        } else if (LabelText != null && InitialCallback != null) {
            super(x, y, LabelText, InitialCallback);
            callbackList.push(InitialCallback);
        } else if (LabelText == null && InitialCallback != null) {
            super(x, y, null, InitialCallback);
            callbackList.push(InitialCallback);
        } else {
            super(x, y);
        }
    }

    public function addCallback(Callback:Void->Void) {
        trace('adding a new callback.');
        callbackList.push(Callback);
        trace(callbackList.length + ' callbacks on this button!');
    }

    public function removeCallback(Callback:Void->Void) {
        if (callbackList.contains(Callback)) {
            for (aeugh in callbackList) {
                if (aeugh == Callback) {
                    trace('removing a callback');
                    FlxG.sound.play(FileUtils.sound('yeet'));
                    callbackList.remove(aeugh);
                    break;
                }
            }
        } else {
            FlxG.sound.play(FileUtils.sound('errorSound'));
            FlxG.log.warn('No callback in this button for that function. Did you already remove it?');
        }
    }

    public function switchCallback(NewCallback:Void->Void) {
        if (callbackList.contains(NewCallback)) {
            onDown.callback = NewCallback;
        } else {
            FlxG.sound.play(FileUtils.sound('errorSound'));
            FlxG.log.warn('No callback in this button for that function. Did you add it?');
        }
    }
}