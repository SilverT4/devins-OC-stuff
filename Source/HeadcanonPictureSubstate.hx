package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import characterUtils.CharInfo.Headcanon;
using StringTools;

/**yeah idk why this is separate but it is. btw, image must be in "Headcanons" in the assets/images folder.

@since 0.0.3 (early April 2022)*/
class HeadcanonPicture extends FlxSprite {
    var PicPath:String = "";
    public function new(horny:String) {
        this.PicPath = "Headcanons/" + horny;
        super(0, 0);
        loadGraphic(FileUtils.image(PicPath));
        screenCenter();
    }
}

class HeadcanonPictureSubstate extends FlxSubState {
    var thePic:HeadcanonPicture;
    var pissy:String = #if !mobile "Press ENTER to return." #else "Tap to continue." #end;
    var poop:FlxText;
    var bg:FlxSprite;
    var shit:Headcanon;
    var realTomFoolery:String;
    public function new(hc:Headcanon) {
        trace("PISSIN");
        super();
        this.shit = hc;
        if (shit.imageName != null) realTomFoolery = shit.imageName;
        else FlxG.sound.play(FileUtils.sound("errorSound", null, false), 1, false, null, true, close); // idk
    }

    override function create() {
        trace("PENIS");
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x69000000);
        add(bg);
        thePic = new HeadcanonPicture(realTomFoolery + ".png");
        add(thePic);
        poop = new FlxText(0, thePic.height + 30, 0, pissy, 16);
        poop.setFormat(FileUtils.getFont("HYYoyo_Bold.ttf", true), 16, 0xFFFFFFFF, CENTER);
        poop.screenCenter(X);
        if (poop.overlaps(thePic)) {
            var poopyBack:FlxSprite = new FlxSprite(0, poop.y - 2);
            poopyBack.makeGraphic(Std.int(poop.width + 4), Std.int(poop.height + 3), 0x69000000);
            poopyBack.screenCenter(X);
            poopyBack.x -= 5;
            poopyBack.y -= 3;
            poop.x -= 6;
            poop.y -= 3;
            add(poopyBack);
        }
        add(poop);
        super.create();
    }

    #if !FLX_TOUCH
    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ENTER) {
            close();
        }
    }
    #else // why am i defining an override twice lmfao
    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.touches.getFirst() != null && FlxG.touches.getFirst().justPressed) {
            close();
        }
    }
    #end
}