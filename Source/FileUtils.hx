package;

import haxe.extern.EitherType;
import openfl.Assets;
import openfl.utils.AssetType;
import flixel.*;
import haxe.Exception;
import flixel.graphics.frames.FlxAtlasFrames;
using StringTools;

/**Rework of the FileUtils class. Started in early April 2022. It'll *hopefully* be more compatible with the limitations of HTML5 (I'm writing this file with HTML5 mode in VS Code), even if that means on-the-fly asset access is eliminated.

(Perhaps I'll make some functions for both HTML5 and sys builds so I can have on-the-fly access in desktop/mobile builds?)
    @since 0.0.3 (early April 2022)*/
class FileUtils {
    static final DefaultImagePath = "Assets/Images/"; // With the second `/` there, you can just type "DefaultImagePath + WHATEVER" lol
    static final DefaultAudioPath = "Assets/Audio/";
    static final DefaultCharacterPath = "Assets/Characters/";
    static final DefaultJsonPath = "Assets/JsonData/";
    static final DefaultTextPath = "Assets/TxtData/";

    public static function fileExists(FilePath:String, ?Directory:String) {
        if (Directory != null) {
            if (Assets.exists(Directory + FilePath)) return true;
            //else if (Assets.exists(fuckinDefaultShit(FilePath))) return true;
            else return false;
        } else {
            if (Assets.exists(fuckinDefaultShit(FilePath))) return true;
            else return false;
        }
    }

    static function fuckinDefaultShit(FileName:String) {
        var plz = FileName.split('.');
        var EXTENSION_SHIT = plz[plz.length - 1]; // in case there's multiple dots!!
        switch (EXTENSION_SHIT) {
            case 'png' | 'xml':
                return DefaultImagePath + FileName;
            case 'txt':
                return DefaultTextPath + FileName;
            case 'json':
                return DefaultJsonPath + FileName;
            case 'character':
                return DefaultCharacterPath + FileName;
            case #if !web 'ogg' #else 'mp3' #end:
                return DefaultAudioPath + FileName;
            case 'species': // Fun fact that I discovered while editing the "Unknown species" file: Starbound also uses the .species extension. The species files in this repo won't work for the game though. ^_^''
                return "Assets/Species/Unknown/" + FileName;
            case 'subspecies':
                return "Assets/Species/Unknown/unknown.subspecies";
            default:
                throw new Exception("Unable to figure out the asset type for " + FileName + ".");
        }
    }

    /**Get an image.
        
    @param FileName The file's name.
    @param Directory (Optional) Look in this directory. If it's not found there, an attempt will be made to search the default image path.
    @param HasExtension If `FileName` has `.png` at the end, set this to true. Otherwise, set it to false.
    @since 0.0.3 (early April 2022)*/
    public static function image(FileName:String, ?Directory:String, HasExtension:Bool = true) {
        var pissyShit = (HasExtension) ? FileName : FileName + '.png';
        if (Directory != null) {
            if (fileExists(pissyShit, Directory)) return Directory + pissyShit;
            else if (fileExists(pissyShit, DefaultImagePath)) return DefaultImagePath + pissyShit;
            else throw new Exception("Unable to locate " + FileName + ".");
        } else {
            if (fileExists(pissyShit, DefaultImagePath)) return DefaultImagePath + pissyShit;
            else throw new Exception("Unable to locate " + FileName + "."); // I'll be removing these exceptions at some point.
        }
    }

    #if web
    /**Get an audio file.
        
    @param FileName The file's name.
    @param Directory (Optional) Look in this directory. If it's not found there, an attempt will be made to search the default audio path.
    @param HasExtension If `FileName` has `.mp3` at the end, set this to true. Otherwise, set it to false.
    @since 0.0.3 (early April 2022)*/
    #else
    /**Get an audio file.
        
    @param FileName The file's name.
    @param Directory (Optional) Look in this directory. If it's not found there, an attempt will be made to search the default audio path.
    @param HasExtension If `FileName` has `.ogg` at the end, set this to true. Otherwise, set it to false.
    @since 0.0.3 (early April 2022)*/
    #end
    public static function sound(FileName:String, ?Directory:String, HasExtension:Bool = true) {
        var shitBurger = (HasExtension) ? FileName : FileName + #if web '.mp3' #else '.ogg' #end;
        if (Directory != null) {
            if (fileExists(shitBurger, Directory)) return Directory + shitBurger;
            else if (fileExists(shitBurger)) return DefaultAudioPath + shitBurger;
            else return DefaultAudioPath + "errorSound." + #if web 'mp3' #else 'ogg' #end;
        } else {
            if (fileExists(shitBurger)) return DefaultAudioPath + shitBurger;
            else return DefaultAudioPath + "errorSound." + #if web 'mp3' #else 'ogg' #end;
        }
    }

    public static function getFont(FontName:String, HasExtension:Bool = true) {
        var pissyShit = (HasExtension) ? FontName : FontName + '.ttf';
        if (Assets.exists("Assets/Fonts/" + pissyShit)) return 'Assets/Fonts/$pissyShit';
        else return '_sans';
    }

    public static function birdy(ImageName:String, ?Directory:String) {
        if (Directory != null) {
            if (fileExists(ImageName + '.png', Directory) && fileExists(ImageName + '.xml', Directory)) {
                var peter = Directory + ImageName;
                return ['$peter.png', '$peter.xml'];
            } else return ["Assets/Images/speen.png", "Assets/Images/speen.xml"];
        } else {
            if (fileExists(ImageName + '.png') && fileExists(ImageName + '.xml')) {
                var peter = DefaultImagePath + ImageName;
                return ['$peter.png', '$peter.xml'];
            } else return ["Assets/Images/speen.png", "Assets/Images/speen.xml"];
        }
    }

    public static function getTextContent(FilePath:String, ?Directory:String, AsArray:Bool = false, ArraySeparator:String = "\n"):EitherType<Array<String>, String> {
        if (Directory != null) {
            if (fileExists(FilePath, Directory)) {
                if (AsArray) return Assets.getText(Directory + FilePath).split(ArraySeparator);
                else return Assets.getText(Directory + FilePath);
            } else {
                trace("PLACEHOLDER GIVEN, COULDN'T FIND A FILE AT " + Directory + FilePath);
                if (AsArray) return ["THIS IS A PLACEHOLDER THING!!", "CHECK YOUR SOURCE."];
                else return "CHECK YOUR SOURCE. THIS IS A PLACEHOLDER.";
            }
        } else {
            if (fileExists(FilePath, DefaultTextPath)) {
                if (AsArray) return Assets.getText(DefaultTextPath + FilePath).split(ArraySeparator);
                else return Assets.getText(DefaultTextPath + FilePath);
            } else {
                trace("PLACEHOLDER GIVEN, COULDN'T FIND A FILE NAMED " + FilePath);
                if (AsArray) return ["THIS IS A PLACEHOLDER THING!!", "CHECK YOUR SOURCE."];
                else return "CHECK YOUR SOURCE. THIS IS A PLACEHOLDER.";
            }
        }
    }

    public static function getBirdAtlas(BIRDY:Array<String>) {
        return FlxAtlasFrames.fromSparrow(BIRDY[0], BIRDY[1]);
    }
}