package extraShit;

import flixel.FlxSprite;
import FileUtils;
using StringTools;

class Speen extends FlxSprite {
    public var spinning:Bool = false;
    private static final SpinnerPath:String = 'speen';

    public function new(x:Float, y:Float, startAutomatically:Bool) {
        super(x, y);

        frames = FileUtils.getBirdAtlas(FileUtils.birdy('speen', 'Assets/Images/'));
        animation.addByPrefix('speen', 'spinner go brr', 30, true);
        animation.addByIndices('paused', 'spinner go brr', [0, 1], '', 0, false);
        if (startAutomatically) startSpinning() else hideSpeenis();
    }

    public function startSpinning() {
        if (!visible) visible = true;
        animation.play('speen');
    }

    public function hideSpeenis() {
        visible = false;
        animation.play('paused');
    }
}