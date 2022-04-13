package;

import dumb.Section;
import dumb.Song;
import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.ui.FlxBar;
import flixel.system.FlxSound;
import extraShit.Speen;
import IntroStuff;
import FileUtils; // if i can fix this it will HOPEFULLY work. lmao

using StringTools;

/**Startup loading screen. Handles the Intro loader.
@since 0.0.1*/
class StartupScreen extends FlxState {
    var speen:Speen;
    var bg:FlxSprite;
    var bar:FlxBar;
    var assetsLoaded:Int;
    var assetsToLoad:Array<String> = ['picThing.png'];
    var shitCam:FlxCamera;
    public static var NavigateSound:FlxSound;
    
    public function new() {
        assetsToLoad.push('xpNavigate' + IntroStuff.sndExtension[IntroStuff.yourPlatform]);
        super();
    }
    
    override function create() {
        shitCam = new FlxCamera();
        shitCam.bgColor = 0xFF000000;
        FlxG.cameras.reset(shitCam);
        bg = new FlxSprite(0).loadGraphic(FileUtils.image('loading', null, false));
        add(bg);
        assetsLoaded = 0;
        bar = new FlxBar(2, 30, LEFT_TO_RIGHT, FlxG.width - 4, 24, this, 'assetsLoaded', 0, 2);
        add(bar);
        speen = new Speen(0, FlxG.height - 48, true);
        add(speen);
        NavigateSound = new FlxSound();
        NavigateSound.loadEmbedded(FileUtils.sound('xpNavigate.' + #if web 'mp3' #else 'ogg' #end));
        FlxG.sound.cache(FileUtils.sound('xpNavigate.' + #if web 'mp3' #else 'ogg' #end));
        new FlxTimer().start(3, function(tmr:FlxTimer) {
            assetsLoaded += 1;
            if (assetsLoaded == 2) FlxG.switchState(new #if debug InfoState #else DumbBarTestThing #end());
        }, 2);
    }
}

class DumbBarTestThing extends FlxState {
    var bar:FlxBar;
    var bg:FlxSprite;
    var start:Int = 0;
    var finish:Int;
    var currentShit:Int = 0;
    var bussy:FlxRandom;
    var Eduardo:characterUtils.FnfSpriteSheet;
    var Dave:characterUtils.FnfSpriteSheet;
    var EduarSound:FlxSound;
    var HouseInst:FlxSound;
    var HouseVocals:FlxSound;
    var Wells:Array<Int> = [159, 449, 758];
    var curWell:Int = 0;
    var welling:Bool = false;
    var funnySinging:Bool = false;
    var funnySong:SusSong;
    var curNote:Array<Dynamic> = [0,0];
    var shitass:Int = 0;
    var curTime:Float = 0;
    var singDirections:Map<Int, String> = [
        0 => "LEFT",
        1 => "DOWN",
        2 => "UP",
        3 => "RIGHT"
    ];
    var eduardoNotes:Array<Dynamic> = [];
    var daveNotes:Array<Dynamic> = [];
    var allNotes:Array<Dynamic> = [];
    var currentNOTE:Int;
    public function new() {
        bussy = new FlxRandom();
        finish = bussy.int(0, 200);
        super();
    }
    
    override function create() {
        trace(finish);
        funnySong = Song.loadFromJson('house', 'house');
        generateSong(funnySong);
        EduarSound = new FlxSound().loadEmbedded(FileUtils.sound("theFunnyWell"));
        EduarSound.onComplete = resetWell;
        EduarSound.play();
        EduarSound.pause();
        HouseInst = new FlxSound().loadEmbedded(FileUtils.sound('funnyinst'));
        HouseInst.onComplete = resetHouse;
        HouseVocals = new FlxSound().loadEmbedded(FileUtils.sound('funnyvocals'));
        bg = new FlxSprite(0).loadGraphic(FileUtils.image('loading'));
        add(bg);
        bar = new FlxBar(0, 24, LEFT_TO_RIGHT, FlxG.width, 24, this, 'currentShit', 0, finish);
        bar.createFilledBar(0xFF696969, 0xFFAACCFF);
        add(bar);
        Eduardo = new characterUtils.FnfSpriteSheet(150, 300, "Assets/Images/golem.png", haxe.Json.parse(#if sys sys.io.File.getContent #else openfl.Assets.getText #end("Assets/JsonData/golem.json")));
        Eduardo.playAnim('idle');
        add(Eduardo);
        Dave = new characterUtils.FnfSpriteSheet(750, 300, "Assets/Images/dave_sheet.png", haxe.Json.parse(#if sys sys.io.File.getContent #else openfl.Assets.getText #end("Assets/JsonData/dave.json")));
        Dave.playAnim('idle');
        add(Dave);
        new FlxTimer().start(1, function(tmr:FlxTimer) {
            currentShit += 1;
            trace('bussy count: $currentShit');
        }, finish);
        FlxG.console.registerFunction("pissKink", resetHouse);
    }
    
    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.SPACE) {
            EduarSound.play();
            welling = true;
        }
        
        if (FlxG.mouse.justPressed) {
            if (FlxG.mouse.overlaps(Eduardo)) {
                EduarSound.play();
                welling = true;
            }
            if (FlxG.mouse.overlaps(Dave)) {
                HouseInst.play();
                HouseVocals.play();
                funnySinging = true;
            }
        }
        
        if (Eduardo != null) {
            if (((!welling || (funnySinging && !eduardoNotes.contains(curNote)) || !funnySinging) && Eduardo.animation.curAnim.finished)) {
                Eduardo.playAnim('idle');
            }
            /*if (funnySinging && eduardoNotes.contains(curNote)) {
                doNoteThings(curNote[1]);
            }*/
            Eduardo.update(elapsed);
        }
        
        if (Dave != null) {
            if (((funnySinging && !daveNotes.contains(curNote)) || !funnySinging) && Dave.animation.curAnim.finished) {
                Dave.playAnim('idle');
            }
            /*if (funnySinging && daveNotes.contains(curNote)) {
                doNoteThings(curNote[1]);
            } */
            Dave.update(elapsed);
        }
        
        if (EduarSound != null) {
            if (EduarSound.time >= Wells[curWell]) {
                Eduardo.playAnim('well');
            }
            //trace(EduarSound.time);
            EduarSound.update(elapsed);
        }
        
        if (funnySinging) {
            if (curTime >= curNote[0] && !allDone) {
                doNoteThings(curNote[1]);
            }
            HouseInst.update(elapsed);
            curTime = HouseInst.time;
            //trace('HOUSE: ' + curTime);
        }
    }
    
    function generateSong(sus:SusSong) {
        var songData = sus;
        
        var noteData:Array<SusSection>;
        
        noteData = songData.notes;
        
        for (section in noteData)
            {
            for (songNotes in section.sectionNotes)
                {
                
                if (songNotes[1] > 3)
                    {
                    daveNotes.push(songNotes);
                } else if (songNotes[1] < 4) {
                    eduardoNotes.push(songNotes);
                } else {
                    trace("NOTE MAY NOT EXIST????");
                }
                
                allNotes.push(songNotes);
            }
        }
        currentNOTE = allNotes[0][0];
    }
    var allDone:Bool = false;
    function doNoteThings(currentNOTE:Int) {
        // WIP
        trace("Playing note " + (allNotes.indexOf(curNote) + 1) + " of " + allNotes.length + ", singer: " + ((eduardoNotes.contains(curNote)) ? "Eduardo" : "Dave"));
        switch (currentNOTE) {
            case 0 | 1 | 2 | 3:
            Eduardo.playAnim('sing' + singDirections[currentNOTE]);
            case 4 | 5 | 6 | 7:
            Dave.playAnim('sing' + singDirections[(currentNOTE % 4)]);
            default:
            trace("PUSSY");
        }
        shitass++;
        if (shitass >= allNotes.length) allDone = true;
        (!(shitass >= allNotes.length)) ? curNote = allNotes[shitass] : trace("PISS");
    }
    
    function resetWell() {
        EduarSound.time = 0;
        curWell = 0;
        welling = false;
        EduarSound.play();
        EduarSound.pause();
    }
    
    function resetHouse():Void {
        HouseInst.time = 0;
        HouseVocals.time = 0;//piss n shit
        shitass = 0;
        if (HouseInst.playing) {
            HouseInst.pause();
        }
        if (HouseVocals.playing) {
            HouseVocals.pause();
        }
        funnySinging = false;
        curNote = allNotes[0];
        allDone = false;
    }
}

/**This'll be used later on when I figure out the actual character info screen.
@since 0.0.2 (March 2022) [when I made the class]*/
class CharacterPreloadScreen extends FlxState {
    public static var CharLoadingName:String = '';
    public static var CharLoadingColour:FlxColor;
    public static var CharFilePath:String = '';
    public static var PUBLIC_VARS:Array<Dynamic> = [
        CharLoadingName,
        CharLoadingColour,
        CharFilePath
    ];
    
    public function new() {
        super();
    }
}