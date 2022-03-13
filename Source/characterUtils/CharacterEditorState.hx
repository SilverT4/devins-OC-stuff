package characterUtils;

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
import characterUtils.CharacterThings;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import lime.app.Application;
import lime.system.Clipboard;
import utils.FlxButtonCustom;
using StringTools;

private typedef EditorAnim = {
    var AnimName:String;
    var AnimXmlName:String;
    var AnimIndices:Array<Int>;
    var AnimFramerate:Int;
    var AnimLoops:Bool;
    var AnimNamePost:String;
}
/**Character editor state. This is very much a WIP at the moment, but it's better than nothing.
@since 0.0.2*/
class CharacterEditorState extends FlxState {
    /**DO NOT USE YET!**/
    static final TemplateCharacter:String = 'DO NOT USE!!';
    static final TemplateAnimsArray:String = 'DO NOT USE!!';
    static final TemplateAnim_Prefix:String = '{
        "AnimName": "lmao",
        "AnimXmlName": "BF HEY",
        "AnimFramerate": 24,
        "AnimLoops": false
    }';
    static final TemplateAnim_Indices:String = '{
        "AnimName": "damn",
        "AnimXmlName": "BF SING LEFT0",
        "AnimIndices": [
            13,
            14,
            15,
            16
        ],
        "AnimNamePost": "",
        "AnimFramerate": 24,
        "AnimLoops": true
    }';
    static final TemplateOffset:String = '{
        "AnimName": "idle",
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
    var camBoxes:FlxCamera;
    var camChara:FlxCamera;
    var camBack:FlxCamera;
    var BlockIfTheseHaveFocus:Array<FlxUIInputText> = [];
    var WeStartinDisWith:String = '';
    public static var PUBLIC_VARS:Array<Dynamic> = [];

    public function new(?CharName:String = 'Steelwolf') {
        if (CharName != null) {
            WeStartinDisWith = CharName;
        } else {
            trace('penis');
        }
        super();
    }

    override function create() {
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
        //addBitchUI();
        //addDisplayUI();

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
            animationInputText.text = anim.AnimName;
            animationNameInputText.text = anim.AnimXmlName;
            animationLoopCheckBox.checked = anim.AnimLoops;
            animationNameFramerate.value = anim.AnimFramerate;

            if (anim.AnimIndices != null) {
                var indicesStr:String = anim.AnimIndices.toString();
                animationIndicesInputText.text = indicesStr;
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
                    "AnimName": animationInputText.text,
                    "AnimXmlName": animationNameInputText.text,
                    "AnimLoops": animationLoopCheckBox.checked,
                    "AnimFramerate": animationNameFramerate.value,
                    "AnimNamePost": "",
                    "AnimIndices": bindices
                };
                jesusPenis = FileUtils.parseTemplate(animThingy);
                BitchAnimList.allAnims.push(jesusPenis);
                BitchAnimList.IndicesAnims.push(jesusPenis);
                var offsetThingy = {
                    "AnimName": animationInputText.text,
                    "X_Value": BitchOffsets[0],
                    "Y_Value": BitchOffsets[1]
                };
                ballGrab = FileUtils.parseTemplate(offsetThingy);
                BitchOffsetList.push(ballGrab);
            } else {
                var animThingy = {
                    "AnimName": animationInputText.text,
                    "AnimXmlName": animationNameInputText.text,
                    "AnimLoops": animationLoopCheckBox.checked,
                    "AnimFramerate": animationNameFramerate.value,
                };
                penisChrist = FileUtils.parseTemplate(animThingy);
                BitchAnimList.allAnims.push(penisChrist);
                BitchAnimList.PrefixAnims.push(penisChrist);
                var offsetThingy = {
                    "AnimName": animationInputText.text,
                    "X_Value": BitchOffsets[0],
                    "Y_Value": BitchOffsets[1]
                };
                ballGrab = FileUtils.parseTemplate(offsetThingy);
                BitchOffsetList.push(ballGrab);
            }
            reloadAnimDropDown();
        });
        reloadAnimDropDown();

        var removeButton:FlxButton = new FlxButton(180, animationIndicesInputText.y + 30, "Remove", function() {
            if (animationIndicesInputText.text.length > 0) {
            for (anim in BitchAnimList.IndicesAnims) {
                if (animationInputText.text == anim.AnimName) {
                    var resetAnim:Bool = false;
                    if (TheBitch.animation.curAnim != null && anim.AnimName == TheBitch.animation.curAnim.name) resetAnim = true;

                    if (TheBitch.animation.getByName(anim.AnimName) != null) {
                        TheBitch.removeAnim(anim.AnimName);
                    }
                    BitchAnimList.IndicesAnims.remove(anim);
                        //BitchAnimList.IndicesAnims.remove(anim);
                    for (penis in BitchOffsetList) {
                        if (penis.AnimName == anim.AnimName) {
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
            for (anim in BitchAnimList.PrefixAnims) {
                if (animationInputText.text == anim.AnimName) {
                    var resetAnim:Bool = false;
                    if (TheBitch.animation.curAnim != null && anim.AnimName == TheBitch.animation.curAnim.name) resetAnim = true;

                    if (TheBitch.animation.getByName(anim.AnimName) != null) {
                        TheBitch.removeAnim(anim.AnimName);
                    }
                    BitchAnimList.PrefixAnims.remove(anim);
                        //BitchAnimList.IndicesAnims.remove(anim);
                    for (penis in BitchOffsetList) {
                        if (penis.AnimName == anim.AnimName) {
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
    var InputBlocked:Bool = false;
    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ESCAPE && !InputBlocked) {
            FlxG.switchState(new IntroStuff());
        }

        for (burger in BlockIfTheseHaveFocus) {
            if (burger.hasFocus) {
                FlxG.sound.muteKeys = null;
                FlxG.sound.volumeDownKeys = null;
                FlxG.sound.volumeUpKeys = null;
                InputBlocked = true;
                break;
            } else {
                continue;
            }
        }

        super.update(elapsed);
    }

    function checkDisBitch(CharacterName:String) {
        if (FileUtils.existential(getFileName(CharacterName, CHAR))) {
            var pen = FileUtils.charProps(getFileName(CharacterName, CHAR));
            BitchPath = pen.ImagePath;
            TheBitch = new Character(50, 50, BitchPath);
            for (egg in pen.AnimArray.PrefixAnims) {
                TheBitch.newAnim(egg.AnimName, egg.AnimXmlName, egg.AnimFramerate, egg.AnimLoops);
            }
            for (ball in pen.AnimArray.IndicesAnims) {
                TheBitch.newAnimByIndices(ball.AnimName, ball.AnimXmlName, ball.AnimIndices, ball.AnimNamePost, ball.AnimFramerate, ball.AnimLoops);
            }
            BitchAnimList = pen.AnimArray;
            BitchOffsetList = pen.OffsetArray;
            TheBitch.cameras = [camChara];
            add(TheBitch);
        } else {
            BitchName = CharacterName;
            setupTemplateBitch();
        }
    }

    function setupTemplateBitch() {
        // PROPS THING WILL BE SET UP LATER!!
        var funkyAnimTemplate:CharAnim_Indices = FileUtils.parseTemplate(TemplateAnim_Indices);
        var funkyAnimTemplate2:CharAnim_Prefix = FileUtils.parseTemplate(TemplateAnim_Prefix);
        BitchAnimList = cast Json.parse('{ "IndicesAnims": [], "PrefixAnims": [], "allAnims": [] }');
        BitchAnimList.IndicesAnims = [];
        BitchAnimList.PrefixAnims = [];
        BitchAnimList.allAnims = [];
        BitchAnimList.IndicesAnims.push(funkyAnimTemplate);
        BitchAnimList.PrefixAnims.push(funkyAnimTemplate2);
        BitchAnimList.allAnims.push(funkyAnimTemplate);
        BitchAnimList.allAnims.push(funkyAnimTemplate2);
        trace(BitchAnimList.PrefixAnims);
        trace(BitchAnimList.IndicesAnims);
        BitchPath = 'test';
        TheBitch = new Character(50, 50, BitchPath);
        for (ani in BitchAnimList.IndicesAnims) {
            TheBitch.newAnimByIndices(ani.AnimName, ani.AnimXmlName, ani.AnimIndices, ani.AnimNamePost, ani.AnimFramerate, ani.AnimLoops);
        }
        for (mat in BitchAnimList.PrefixAnims) {
            TheBitch.newAnim(mat.AnimName, mat.AnimXmlName, mat.AnimFramerate, mat.AnimLoops);
        }
        TheBitch.cameras = [camChara];
        add(TheBitch);
    }
    function reloadAnimDropDown() {
        var anims:Array<String> = [];
        for (meme in BitchAnimList.PrefixAnims) {
            anims.push(meme.AnimName);
        }
        for (shart in BitchAnimList.IndicesAnims) {
            anims.push(shart.AnimName);
        }

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
        var penisFilter = new FileFilter('Character file', 'character');
        var shart = FileUtils.convertToFile(data);
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