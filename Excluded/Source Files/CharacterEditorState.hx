package characterUtils;

import flixel.input.keyboard.FlxKey;
import flixel.FlxSubState;
import openfl.net.FileFilter;
import haxe.Json;
import extraShit.BackgroundSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUINumericStepper;
import utils.FlxUIDropDownMenuCustom;
import flixel.addons.ui.FlxUI;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import extraShit.Speen;
//import characterUtils.CharacterThings;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import lime.app.Application;
import lime.system.Clipboard;
import utils.FlxButtonCustom;
using StringTools;
/**
    Hi there. So, if you're reading this, congrats. You've found something from before I decided to just... Rework the character sprite handling.
    
    That's right, I'm reworking the character sprite portion of this thing. The way it is (or *was*) right now is very much a fucking mess. I want to rework them to make it a bit more efficient if possible.
    
    If you want to see how this worked, go and clone this repository. The latest commit with this file was [commit 0eff98b](https://github.com/devin503/my-bussy-sharted/commit/0eff98bd916c043b9d5af13658c6850a5617c860), so just run `git checkout 0eff98b` after you clone and cd into the repo.
    
    Just know that it's a HUGE mess. It doesn't work the way I hoped it would, plus the code itself is just messy and I had a hard time figuring out what I was doing wrong whenever errors would come up.
    
    The way that things will work from this point on is very much what I hope will be better.
    
    Signed, devin503
    
    @since 3rd April 2022*/
private typedef EditorAnim = {
    var animName:String;
    var animXmlName:String;
    var animIndices:Array<Int>;
    var animFramerate:Int;
    var animLoops:Bool;
    var animNamePost:String;
}
/**Character editor state. This is very much a WIP at the moment, but it's better than nothing.
@since 0.0.2*/
class CharacterEditorState extends FlxState {
    /**DO NOT USE YET!**/
    static final TemplateCharacter:String = '{
        "OffsetArray": [],
        "ImagePath": "test",
        "AnimArray": {
            "prefixAnims": [
                {
            "animName": "lmao",
            "animXmlName": "BF HEY",
            "animFramerate": 24,
            "animLoops": false
        }
            ],
            "allAnims": [
                {
            "animName": "damn",
            "animXmlName": "BF SING LEFT0",
            "animIndices": [
                13,
                14,
                15,
                16
            ],
            "animNamePost": "",
            "animFramerate": 24,
            "animLoops": true
        },
                {
            "animName": "lmao",
            "animXmlName": "BF HEY",
            "animFramerate": 24,
            "animLoops": false
        }
            ],
            "indicesAnims": [
                {
            "animName": "damn",
            "animXmlName": "BF SING LEFT0",
            "animIndices": [
                13,
                14,
                15,
                16
            ],
            "animNamePost": "",
            "animFramerate": 24,
            "animLoops": true
        }
            ]
        }
    }';
    static final TemplateAnimsArray:String = 'DO NOT USE!!';
    static final TemplateAnim_Prefix:String = '{
        "animName": "lmao",
        "animXmlName": "BF HEY",
        "animFramerate": 24,
        "animLoops": false
    }';
    static final TemplateAnim_Indices:String = '{
        "animName": "damn",
        "animXmlName": "BF SING LEFT0",
        "animIndices": [
            13,
            14,
            15,
            16
        ],
        "animNamePost": "",
        "animFramerate": 24,
        "animLoops": true
    }';
    static final TemplateOffset:String = '{
        "animName": "idle",
        "X_Value": 0,
        "Y_Value": -5
    }';
    var TheBitch:Character;
    var BitchMakerBg:BackgroundSprite;
    var BitchMakerUI:FlxUITabMenu;
    var BitchSelectUI:FlxUITabMenu;
    var BitchMakerAssets_Anim:FlxUI;
    var BitchMakerAssets_Path:FlxUI;
    var BitchMakerAssets_Disp:FlxUI;
    var BitchSelectAssets:FlxUI;
    var BitchPath:String = '';
    var BitchAnimList:CharAnims;
    var BitchOffsetList:Array<CharOffsets> = [];
    var BitchName:String = 'Bruh Momento';
    var BitchOffsets:Array<Int> = [0, 0]; // CURRENT ANIM OFFSET!
    var BitchProps:CharProperties;
    var camBoxes:FlxCamera;
    var camChara:FlxCamera;
    var camBack:FlxCamera;
    var BlockIfTheseHaveFocus:Array<FlxUIInputText> = [];
    var WeStartinDisWith:String = '';
    public static var PUBLIC_VARS:Array<Dynamic> = [];
    public static var instance:CharacterEditorState;

    public function new(?CharName:String = 'Steelwolf') {
        if (CharName != null) {
            WeStartinDisWith = CharName;
        } else {
            trace('penis');
        }
        super();
    }

    public function updateCharPositions(charX:Float, charY:Float, charScale:Array<Dynamic>) {
        if (TheBitch != null) {
            TheBitch.setPosition(charX, charY);
            TheBitch.scale.set(charScale[0], charScale[1]);
        }
    }

    override function create() {
        instance = this;
        camBack = new FlxCamera();
        camChara = new FlxCamera();
        camBoxes = new FlxCamera();
        camChara.bgColor.alpha = 0;
        camBoxes.bgColor.alpha = 0;
        FlxG.cameras.reset(camBack);
        FlxG.cameras.add(camChara);
        FlxG.cameras.add(camBoxes);
        BitchMakerBg = new BackgroundSprite();
        if (FileUtils.existential('CharEdit.png')) {
            BitchMakerBg.loadImage(FileUtils.pic('CharEdit'));
        } else {
            BitchMakerBg.setRandomBackground();
        }
        BitchMakerBg.fitToScreen();
        add(BitchMakerBg);
        var tabs = [
            {name: 'Animations', label: 'Animations'},
            {name: 'Paths', label: 'Paths'},
            {name: 'Display', label: 'Display'}
        ];
        BitchMakerUI = new FlxUITabMenu(null, tabs);
        BitchMakerUI.resize(350, 250);
        BitchMakerUI.cameras = [camBoxes];
        BitchMakerUI.x = FlxG.width - 375;
        BitchMakerUI.y = 25;
        BitchMakerUI.scrollFactor.set();
        add(BitchMakerUI);
        if (WeStartinDisWith.length > 0) {
            checkDisBitch(WeStartinDisWith);
        } else {
            setupTemplateBitch();
        }
        addAnimUI();
        addBitchUI();
        addDisplayUI();

        BitchMakerUI.selected_tab_id = 'Paths';
    }
    // var ghostDropDown:FlxUIDropDownMenuCustom;
    var animationDropDown:FlxUIDropDownMenuCustom;
    var animationInputText:FlxUIInputText;
    var animationNameInputText:FlxUIInputText;
    var animationIndicesInputText:FlxUIInputText;
    var animationNameFramerate:FlxUINumericStepper;
    var animationLoopCheckBox:FlxUICheckBox;
    var animIndCheckBox:FlxUICheckBox;
    var bindices:Array<String> = [];
    function addAnimUI() {
        BitchMakerAssets_Anim = new FlxUI(null, BitchMakerUI);
        BitchMakerAssets_Anim.name = "Animations";

        animationInputText = new FlxUIInputText(15, 85, 80, '', 8);
	    animationNameInputText = new FlxUIInputText(animationInputText.x, animationInputText.y + 35, 150, '', 8);
		animationIndicesInputText = new FlxUIInputText(animationNameInputText.x, animationNameInputText.y + 40, 250, '', 8);
		animationNameFramerate = new FlxUINumericStepper(animationInputText.x + 170, animationInputText.y, 1, 24, 0, 240, 0);
		animationLoopCheckBox = new FlxUICheckBox(animationNameInputText.x + 170, animationNameInputText.y - 1, null, null, "Should it Loop?", 100);
        BlockIfTheseHaveFocus.push(animationInputText);
        BlockIfTheseHaveFocus.push(animationNameInputText);
        BlockIfTheseHaveFocus.push(animationIndicesInputText);
        animationDropDown = new FlxUIDropDownMenuCustom(15, animationInputText.y - 55, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(penis:String) {
            var selectedAnimation:Int = Std.parseInt(penis);
            var anim:EditorAnim = BitchAnimList.allAnims[selectedAnimation];
            animationInputText.text = anim.animName;
            animationNameInputText.text = anim.animXmlName;
            animationLoopCheckBox.checked = anim.animLoops;
            animationNameFramerate.value = anim.animFramerate;

            if (anim.animIndices != null) {
                var indicesStr:String = anim.animIndices.toString().trim();
                animationIndicesInputText.text = indicesStr;
            } else {
                animationIndicesInputText.text = '';
            }
        });
        var addUpdateButton = new FlxButton(70, animationIndicesInputText.y + 30, "Add/Update", function() {
            if (animationIndicesInputText.text.length >= 1) {
                var coochie = animationIndicesInputText.text.split(',');
                bindices = coochie;
            }
            var jesusPenis:CharAnim_Indices;
            var penisChrist:CharAnim_Prefix;
            var ballGrab:CharOffsets;
            if (bindices.length > 0) {
                var animThingy = {
                    "animName": animationInputText.text,
                    "animXmlName": animationNameInputText.text,
                    "animLoops": animationLoopCheckBox.checked,
                    "animFramerate": animationNameFramerate.value,
                    "animNamePost": "",
                    "animIndices": bindices
                };
                jesusPenis = FileUtils.parseTemplate(animThingy);
                if (!BitchAnimList.allAnims.contains(jesusPenis)) {
                    BitchAnimList.allAnims.push(jesusPenis);
                } else {
                    BitchAnimList.allAnims.remove(jesusPenis);
                    BitchAnimList.allAnims.push(jesusPenis);
                }
                if (!BitchAnimList.indicesAnims.contains(jesusPenis)) {
                    BitchAnimList.indicesAnims.push(jesusPenis);
                } else {
                    BitchAnimList.indicesAnims.remove(jesusPenis);
                    BitchAnimList.indicesAnims.push(jesusPenis);
                }
                var offsetThingy = {
                    "animName": animationInputText.text,
                    "X_Value": BitchOffsets[0],
                    "Y_Value": BitchOffsets[1]
                };
                ballGrab = FileUtils.parseTemplate(offsetThingy);
                if (BitchOffsetList.contains(ballGrab)) {
                    BitchOffsetList.remove(ballGrab);
                    BitchOffsetList.push(ballGrab);
                } else {
                    BitchOffsetList.push(ballGrab);
                }
            } else {
                var animThingy = {
                    "animName": animationInputText.text,
                    "animXmlName": animationNameInputText.text,
                    "animLoops": animationLoopCheckBox.checked,
                    "animFramerate": animationNameFramerate.value,
                };
                penisChrist = FileUtils.parseTemplate(animThingy);
                if (!BitchAnimList.allAnims.contains(penisChrist)) {
                    BitchAnimList.allAnims.push(penisChrist);
                } else {
                    BitchAnimList.allAnims.remove(penisChrist);
                    BitchAnimList.allAnims.push(penisChrist);
                }
                if (BitchAnimList.prefixAnims.contains(penisChrist)) {
                    BitchAnimList.prefixAnims.remove(penisChrist);
                    BitchAnimList.prefixAnims.push(penisChrist);
                } else {
                    BitchAnimList.prefixAnims.push(penisChrist);
                }
                var offsetThingy = {
                    "animName": animationInputText.text,
                    "X_Value": BitchOffsets[0],
                    "Y_Value": BitchOffsets[1]
                };
                ballGrab = FileUtils.parseTemplate(offsetThingy);
                if (!BitchOffsetList.contains(ballGrab)) {
                    BitchOffsetList.push(ballGrab);
                } else {
                    BitchOffsetList.remove(ballGrab);
                    BitchOffsetList.push(ballGrab);
                }
            }
            TheBitch.Editor_ResetAnims(BitchAnimList);
            reloadAnimDropDown();
        });
        reloadAnimDropDown();

        var removeButton:FlxButton = new FlxButton(180, animationIndicesInputText.y + 30, "Remove", function() {
            if (animationIndicesInputText.text.length > 0) {
            for (anim in BitchAnimList.indicesAnims) {
                if (animationInputText.text == anim.animName) {
                    var resetAnim:Bool = false;
                    if (TheBitch.animation.curAnim != null && anim.animName == TheBitch.animation.curAnim.name) resetAnim = true;

                    if (TheBitch.animation.getByName(anim.animName) != null) {
                        TheBitch.removeAnim(anim.animName);
                    }
                    BitchAnimList.indicesAnims.remove(anim);
                        //BitchAnimList.IndicesAnims.remove(anim);
                    for (penis in BitchOffsetList) {
                        if (penis.animName == anim.animName) {
                            BitchOffsetList.remove(penis);
                            break;
                        }
                    }

                    reloadAnimDropDown();
                    //genBitchOffsets();
                    trace('ya yeet');
                    FlxG.sound.play(FileUtils.sound('yeet'));
                    break;

                }
            }
        } else {
            for (anim in BitchAnimList.prefixAnims) {
                if (animationInputText.text == anim.animName) {
                    var resetAnim:Bool = false;
                    if (TheBitch.animation.curAnim != null && anim.animName == TheBitch.animation.curAnim.name) resetAnim = true;

                    if (TheBitch.animation.getByName(anim.animName) != null) {
                        TheBitch.removeAnim(anim.animName);
                    }
                    BitchAnimList.prefixAnims.remove(anim);
                        //BitchAnimList.IndicesAnims.remove(anim);
                    for (penis in BitchOffsetList) {
                        if (penis.animName == anim.animName) {
                            BitchOffsetList.remove(penis);
                            break;
                        }
                    }

                    reloadAnimDropDown();
                    //genBitchOffsets();
                    trace('ya yeet');
                    FlxG.sound.play(FileUtils.sound('yeet'));
                    break;

                }
            }
            TheBitch.Editor_ResetAnims(BitchAnimList);
        }
        });
        BitchMakerAssets_Anim.add(new FlxText(animationDropDown.x, animationDropDown.y - 18, 0, 'Animations:'));
		BitchMakerAssets_Anim.add(new FlxText(animationInputText.x, animationInputText.y - 18, 0, 'Animation name:'));
		BitchMakerAssets_Anim.add(new FlxText(animationNameFramerate.x, animationNameFramerate.y - 18, 0, 'Framerate:'));
		BitchMakerAssets_Anim.add(new FlxText(animationNameInputText.x, animationNameInputText.y - 18, 0, 'Animation on .XML/.TXT file:'));
		BitchMakerAssets_Anim.add(new FlxText(animationIndicesInputText.x, animationIndicesInputText.y - 18, 0, 'ADVANCED - Animation Indices:'));
        BitchMakerAssets_Anim.add(animationLoopCheckBox);
        BitchMakerAssets_Anim.add(animationNameFramerate);
        BitchMakerAssets_Anim.add(animationIndicesInputText);
        BitchMakerAssets_Anim.add(animationNameInputText);
        BitchMakerAssets_Anim.add(animationInputText);
        BitchMakerAssets_Anim.add(addUpdateButton);
        BitchMakerAssets_Anim.add(removeButton);
        BitchMakerAssets_Anim.add(animationDropDown);
        BitchMakerUI.addGroup(BitchMakerAssets_Anim);
    }

    var BitchDisplayEditButton:FlxButton;
    var BitchDisplayInfoText:FlxText;
    function addDisplayUI() {
        BitchMakerAssets_Disp = new FlxUI(null, BitchMakerUI);
        BitchMakerAssets_Disp.name = 'Display';

        BitchDisplayEditButton = new FlxButton(120, 180, 'Edit...', function() {
            BitchSpillNoodles.CharPosArray = [TheBitch.x, TheBitch.y];
            var pathShit = BitchPathInputBox.text.split('/');
            var actualPath:Array<String> = [];
            var theRealFile:String = '';
            for (i in 0...pathShit.length) {
                if (pathShit[i].contains('.png')) {
                    theRealFile = pathShit[i].substr(0, pathShit[i].length - 4);
                } else {
                    actualPath.push(pathShit[i]);
                }
            }
            BitchSpillNoodles.CharPath = theRealFile;
            BitchSpillNoodles.CharDir = 'Assets/Images/';
            openSubState(new BitchSpillNoodles());
        });

        BitchDisplayInfoText = new FlxText(15, 12, 0, 'Char. X: ' + TheBitch.x + '\nChar. Y: ' + TheBitch.y + '\nChar. Scale: ' + TheBitch.scale.toString(), 8);

        BitchMakerAssets_Disp.add(BitchDisplayEditButton);
        BitchMakerAssets_Disp.add(BitchDisplayInfoText);
        BitchMakerUI.addGroup(BitchMakerAssets_Disp);
    }
    var BitchNameInputBox:FlxUIInputText;
    var BitchPathInputBox:FlxUIInputText;
    var BitchReloadButton:FlxButton;
    var BitchBrowseButton:FlxButton;
    var BitchSaveButton:FlxButton;
    var BitchLoadButton:FlxButton;
    function addBitchUI() {
        BitchMakerAssets_Path = new FlxUI(null, BitchMakerUI);
        BitchMakerAssets_Path.name = 'Paths';

        BitchNameInputBox = new FlxUIInputText(15, 30, 200, 'fiuoahedskjlf', 8);
        BitchPathInputBox = new FlxUIInputText(15, BitchNameInputBox.y + 30, 200, BitchPath + '.png', 8);
        BitchBrowseButton = new FlxButton(BitchPathInputBox.x + 210, BitchPathInputBox.y, 'Browse...', function() {
            browseForBitchSprites();
        });
        BitchReloadButton = new FlxButton(BitchPathInputBox.x + 210, BitchPathInputBox.y + 30, 'Reload', reloadBitchSprites);
        BitchSaveButton = new FlxButton(BitchBrowseButton.x, BitchReloadButton.y + 30, 'Save', saveCharacter);
        BitchLoadButton = new FlxButton(BitchBrowseButton.x, BitchSaveButton.y + 30, 'Load', loadCharacter);

        BitchMakerAssets_Path.add(new FlxText(BitchNameInputBox.x, BitchNameInputBox.y - 18, 0, 'Character name', 8));
        BitchMakerAssets_Path.add(new FlxText(BitchPathInputBox.x, BitchPathInputBox.y - 18, 0, 'Character sprite path', 8));
        BitchMakerAssets_Path.add(BitchNameInputBox);
        BitchMakerAssets_Path.add(BitchPathInputBox);
        BitchMakerAssets_Path.add(BitchBrowseButton);
        BitchMakerAssets_Path.add(BitchReloadButton);
        BitchMakerAssets_Path.add(BitchSaveButton);
        BitchMakerAssets_Path.add(BitchLoadButton);
        BitchMakerUI.addGroup(BitchMakerAssets_Path);
    }
    function reloadBitchSprites() {
        var pathShit = BitchPathInputBox.text.split('/');
        var actualPath:Array<String> = [];
        var theRealFile:String = '';
        for (i in 0...pathShit.length) {
            if (pathShit[i].contains('.png')) {
                theRealFile = pathShit[i].substr(0, pathShit[i].length - 4);
            } else {
                actualPath.push(pathShit[i]);
            }
        }
        TheBitch.destroy();
        TheBitch = null;
        TheBitch = new Character(100, 100, theRealFile, actualPath.join('/') + '/');
        TheBitch.cameras = [camBoxes];
        add(TheBitch);
    }
    function browseForBitchSprites() {
        _file = new FileReference();
        var penisFilter = new FileFilter('Spritesheet', '*.png');
        _file.addEventListener(Event.SELECT, onLoadComplete_Sprite);
        _file.addEventListener(Event.CANCEL, onLoadCancel_Sprite);
        _file.addEventListener(IOErrorEvent.IO_ERROR, onLoadError_Sprite);
        _file.browse([penisFilter]);
    }

    function onLoadComplete_Sprite(_):Void {
        _file.removeEventListener(Event.SELECT, onLoadComplete_Sprite);
        _file.removeEventListener(Event.CANCEL, onLoadCancel_Sprite);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError_Sprite);
        var fullBussy:String = '';
        #if sys
        @:privateAccess
        if (_file.__path != null) fullBussy = _file.__path;
        var benis = fullBussy.split(#if windows '\\' #else '/' #end);
        for (bean in 0...benis.length) {
            if (!benis[bean].contains('.png')) {
                trace('ass');
            } else if (!benis[bean].contains('Assets') && !benis[bean].contains('Images') && !benis[bean].contains('.png')) {
                benis.remove(benis[bean]);
            } else {
                BitchPath = benis[bean].substr(0, benis[bean].length - 4);
            }
        }
        BitchPathInputBox.text = benis.join('/');
        TheBitch.destroy();
        TheBitch = null;
        TheBitch = new Character(100, 100, BitchPath);
        TheBitch.cameras = [camBoxes];
        add(TheBitch);
        trace('bussy loaded');
        _file = null;
        #else
        trace('wtf are you on WEB for lmao');
        _file = null;
        #end
    }

    function onLoadCancel_Sprite(_):Void {
        _file.removeEventListener(Event.SELECT, onLoadComplete_Sprite);
        _file.removeEventListener(Event.CANCEL, onLoadCancel_Sprite);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError_Sprite);
        _file = null;
    }

    function onLoadError_Sprite(_):Void {
        _file.removeEventListener(Event.SELECT, onLoadComplete_Sprite);
        _file.removeEventListener(Event.CANCEL, onLoadCancel_Sprite);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError_Sprite);
        _file = null;
    }

    function loadCharacter() {
        trace('penisssssssssssssssssssssssssssssss');
    }
    var InputBlocked:Bool = false;
    var camSwitchers:Array<FlxKey> = [FlxKey.ONE, FlxKey.TWO, FlxKey.THREE];
    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ESCAPE && !InputBlocked) {
            FlxG.switchState(new IntroStuff());
        }

        if (InputBlocked) {
            FlxG.sound.muteKeys = null;
            FlxG.sound.volumeDownKeys = null;
            FlxG.sound.volumeUpKeys = null;
        } else {
            FlxG.sound.muteKeys = FileUtils.muteKeys;
            FlxG.sound.volumeDownKeys = FileUtils.volKeysDown;
            FlxG.sound.volumeUpKeys = FileUtils.volKeysUp;
        }
        if (FlxG.keys.anyJustPressed(camSwitchers)) {
            switch (FlxG.keys.firstJustPressed()) {
                case FlxKey.ONE:
                    if (TheBitch != null) {
                        TheBitch.cameras = [camBack];
                    }
                case FlxKey.TWO:
                    if (TheBitch != null) {
                        TheBitch.cameras = [camChara];
                    }
                case FlxKey.THREE:
                    if (TheBitch != null) {
                        TheBitch.cameras = [camBoxes];
                    }
            }
        }
        for (burger in BlockIfTheseHaveFocus) {
            if (burger.hasFocus) {
                FlxG.sound.muteKeys = null;
                FlxG.sound.volumeDownKeys = null;
                FlxG.sound.volumeUpKeys = null;
                InputBlocked = true;
                break;
            } else {
                InputBlocked = false;
                continue;
            }
        }

        if (TheBitch != null) {
            TheBitch.update(elapsed);
        }

        super.update(elapsed);
    }

    function checkDisBitch(CharacterName:String) {
        if (FileUtils.existential(getFileName(CharacterName, CHAR))) {
            var pen = FileUtils.charProps(getFileName(CharacterName, CHAR));
            BitchProps = pen;
            BitchPath = pen.ImagePath;
            TheBitch = new Character(50, 50, BitchPath);
            /*for (egg in pen.AnimArray.PrefixAnims) {
                TheBitch.newAnim(egg.AnimName, egg.AnimXmlName, egg.AnimFramerate, egg.AnimLoops);
            }
            for (ball in pen.AnimArray.IndicesAnims) {
                TheBitch.newAnimByIndices(ball.AnimName, ball.AnimXmlName, ball.AnimIndices, ball.AnimNamePost, ball.AnimFramerate, ball.AnimLoops);
            } */
            // TheBitch.addAnimsFromListFile(null, pen);
            for (ani in 0...pen.AnimArray.prefixAnims.length) {
                var benis = pen.AnimArray.prefixAnims[ani];
                TheBitch.animation.addByPrefix(benis.animName, benis.animXmlName, benis.animFramerate, benis.animLoops);
            }
            for (ani in 0...pen.AnimArray.indicesAnims.length) {
                var bepis = pen.AnimArray.indicesAnims[ani];
                TheBitch.animation.addByIndices(bepis.animName, bepis.animXmlName, bepis.animIndices, bepis.animNamePost, bepis.animFramerate, bepis.animLoops);
            }
            BitchAnimList = pen.AnimArray;
            BitchOffsetList = pen.OffsetArray;
            TheBitch.playAnim(BitchAnimList.allAnims[0].animName);
            TheBitch.cameras = [camBoxes];
            add(TheBitch);
        } else {
            BitchName = CharacterName;
            setupTemplateBitch();
        }
    }

    function setupTemplateBitch() {
        // PROPS THING WILL BE SET UP LATER!!
        //var funkyAnimTemplate:CharAnim_Indices = FileUtils.parseTemplate(TemplateAnim_Indices);
        //var funkyAnimTemplate2:CharAnim_Prefix = FileUtils.parseTemplate(TemplateAnim_Prefix);
        BitchProps = cast Json.parse(TemplateCharacter);
        BitchAnimList = BitchProps.AnimArray;
        trace(BitchAnimList.prefixAnims);
        trace(BitchAnimList.indicesAnims);
        BitchPath = 'test';
        TheBitch = new Character(50, 50, BitchPath);
        /*for (ani in BitchAnimList.IndicesAnims) {
            trace(ani.AnimName, ani.AnimXmlName, ani.AnimIndices, ani.AnimNamePost, ani.AnimFramerate, ani.AnimLoops);
            TheBitch.newAnimByIndices(ani.AnimName, ani.AnimXmlName, ani.AnimIndices, ani.AnimNamePost, ani.AnimFramerate, ani.AnimLoops);
        }
        for (mat in BitchAnimList.PrefixAnims) {
            trace(mat.AnimName, mat.AnimXmlName, mat.AnimFramerate, mat.AnimLoops);
            TheBitch.newAnim(mat.AnimName, mat.AnimXmlName, mat.AnimFramerate, mat.AnimLoops);
        } */
        //TheBitch.addAnimsFromListFile(null, null, BitchAnimList);
        /*for (ani in 0...BitchAnimList.prefixAnims.length) {
            var benis = BitchAnimList.prefixAnims[ani];
            TheBitch.animation.addByPrefix(benis.animName, benis.animXmlName, benis.animFramerate, benis.animLoops);
        }
        for (ani in 0...BitchAnimList.indicesAnims.length) {
            var bepis = BitchAnimList.indicesAnims[ani];
            TheBitch.animation.addByIndices(bepis.animName, bepis.animXmlName, bepis.animIndices, bepis.animNamePost, bepis.animFramerate, bepis.animLoops);
        }*/
        TheBitch.animation.addByIndices("damn", "BF SING LEFT0", [13, 14, 15, 16], "", 24, false);
        TheBitch.animation.addByPrefix("lmao", "BF HEY", 24, false);
        TheBitch.cameras = [camBoxes];
        TheBitch.playAnim('lmao');
        add(TheBitch);
        if (BitchName.length < 1) BitchName = 'bitch';
        //saveCharacter();
    }
    function reloadAnimDropDown() {
        var anims:Array<String> = [];
        for (meme in BitchAnimList.allAnims) {
            anims.push(meme.animName);
        }
        /*for (shart in BitchAnimList.indicesAnims) {
            anims.push(shart.animName);
        } */

        animationDropDown.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(anims, true));
    }
    function getFileName(Input:String, Type:String):String {
        var afjds:String = '';
        switch (Type) {
            case CHAR:
                afjds = Input + '.character';
            case OFFSET:
                afjds = Input + '.offsets';
        }
        return afjds;
    }
    var _file:FileReference;
    function saveCharacter() {
        trace('PENIS!!');
        var data = {
            "AnimArray": BitchAnimList,
            "ImagePath": BitchPath,
            "OffsetArray": BitchOffsetList
        };
        var penisFilter = new FileFilter('Character file', '*.character');
        var bus = FileUtils.convertToFile(data);
        var shart = bus.replace('\\r\\n', '\r\n').replace('\\"', '\"').replace('}\"', '}').replace('\"{', '{');
        _file = new FileReference();
        _file.addEventListener(Event.SELECT, onSaveComplete);
        _file.addEventListener(Event.CANCEL, onSaveCancel);
        _file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file.save(shart, BitchName + '.character');
    }

    function onSaveComplete(_):Void {
        var savedPath:String = '';
        @:privateAccess
        if (_file.__path != null) {
            savedPath = _file.__path;
            openMessageWindow("Done", "File saved. Path: " + savedPath, function() {
                trace('pp');
                closeTheWindow();
            });
        }
        trace('file saved!');
        _file.removeEventListener(Event.SELECT, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
    }

    function onSaveCancel(_):Void {
        _file.removeEventListener(Event.SELECT, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
        trace('canceled!');
    }

    function onSaveError(_):Void {
        _file.removeEventListener(Event.SELECT, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        trace('OOF!');
        openMessageWindow('Error', 'Something went wrong. The terminal may have more information on the error.', closeTheWindow);
    }
    var OKButton:FlxButtonCustom;
    var windowBg:FlxSprite;
    function openMessageWindow(WinTitle:String, WinMsg:String, ?BtnCallBack:Void -> Void) {
        if (BtnCallBack != null) {
            OKButton = new FlxButtonCustom(0, 150, 'OK', BtnCallBack);
        } else {
            OKButton = new FlxButtonCustom(0, 150, 'OK');
        }
        windowBg = new FlxSprite(0, 20).makeGraphic(FlxG.width - 200, FlxG.height - 150, FlxColor.GRAY);
        windowBg.screenCenter();
        OKButton.y = windowBg.y + 120;
        OKButton.screenCenter(X);
        add(windowBg);
        add(OKButton);
    }

    function closeTheWindow() {
        if (windowBg != null) {
            windowBg.destroy();
            windowBg = null;
        }
        if (OKButton != null) {
            OKButton.destroy();
            OKButton = null;
        }
    }
    static inline final CHAR:String = 'Character';
    static inline final OFFSET:String = 'Offsets';
}

/**BITCH SPILL NOODLE?*/
class BitchSpillNoodles extends FlxSubState {
    public static var CharPosArray:Array<Float> = [0, 0];
    public static var CharPath:String = '';
    public static var CharDir:String = '';
    var HintText:FlxText;
    var InfoText:FlxText;
    var InfoBG:FlxSprite;
    var HintBG:FlxSprite;
    var Back:BackgroundSprite;
    var BitchBoi:Character;
    public function new() {
        super();
    }

    override function create() {
        Back = new BackgroundSprite();
        Back.setRandomBackground();
        Back.fitToScreen();
        Back.alpha = 0.69;
        add(Back);
        HintBG = new FlxSprite(0).makeGraphic(FlxG.width, 26, FlxColor.fromRGB(0, 0, 0, 128));
        add(HintBG);
        HintText = new FlxText(0, HintBG.y, FlxG.width, 'Move your mouse to move the character. Click to set it. Press DOWN to scale down and UP to scale up.', 24);
        add(HintText);
        BitchBoi = new Character(CharPosArray[0], CharPosArray[1], CharPath, CharDir);
        BitchBoi.BitchPositionMode = true;
        InfoBG = new FlxSprite(0, 0);
        InfoText = new FlxText(0, 0, 0, 'Char. X: ' + BitchBoi.x + '\nChar. Y: ' + BitchBoi.y + '\nChar. Scale: ' + BitchBoi.scale.toString(), 16);
        InfoBG.makeGraphic(Std.int(InfoText.width + 3), Std.int(InfoText.height + 3), FlxColor.fromRGB(0, 0, 0, 128));
        add(InfoBG);
        add(InfoText);
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.UP) {
            if (BitchBoi != null) {
                BitchBoi.scale.add(0.1, 0.1);
            }
        }
        if (FlxG.keys.justPressed.DOWN) {
            if (BitchBoi != null) {
                BitchBoi.scale.subtract(0.1, 0.1);
            }
        }
        if (InfoBG != null) {
            if (FlxG.mouse.x <= FlxG.width - 16) {
                InfoBG.setPosition(FlxG.mouse.x - 16, FlxG.mouse.y + 16);
            } else if (FlxG.mouse.y <= FlxG.height - 16) {
                InfoBG.setPosition(FlxG.mouse.x + 16, FlxG.mouse.y - 16);
            } else if (FlxG.mouse.x <= FlxG.width - 16 && FlxG.mouse.y <= FlxG.height - 16) {
                InfoBG.setPosition(FlxG.mouse.x - 16, FlxG.mouse.y - 16);
            } else {
                InfoBG.setPosition(FlxG.mouse.x + 16, FlxG.mouse.y + 16);
            }
            if (InfoText != null) {
                InfoBG.setGraphicSize(Std.int(InfoText.width + 3), Std.int(InfoText.height + 3));
            }
            InfoBG.update(elapsed);
        }
        if (InfoText != null) {
            if (InfoBG != null) InfoText.setPosition(InfoBG.getPosition().x, InfoBG.getPosition().y);
            if (BitchBoi != null) {
                InfoText.text = 'Char. X: ' + BitchBoi.x + '\nChar. Y: ' + BitchBoi.y + '\nChar. Scale: ' + BitchBoi.scale.toString();
            }
            InfoText.update(elapsed);
        }

        if (BitchBoi != null) {
            BitchBoi.setPosition(FlxG.mouse.x, FlxG.mouse.y);
            BitchBoi.update(elapsed);
        }

        if (FlxG.mouse.justPressed) {
            CharacterEditorState.instance.updateCharPositions(BitchBoi.x, BitchBoi.y, [BitchBoi.scale.x, BitchBoi.scale.y]);
            close();
        }
        super.update(elapsed);
    }
}