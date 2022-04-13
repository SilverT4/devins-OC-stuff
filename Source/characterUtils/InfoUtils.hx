package characterUtils;

import characterUtils.CharInfo;
import characterUtils.SpeciesThingie;
import haxe.Json;
import FileUtils;
using StringTools;

typedef SpeciesList = {
    var daList:Array<SpeciesPath>;
}

typedef SpeciesPath = {
    var specName:String;
    var specDir:String;
}

/**This class handles making variables as necessary for the info state and such. It might make things a bit easier to handle.
    
@since 0.0.3 (early April 2022)*/
class InfoUtils {
    static var SpeciesBaseDir:String = "Assets/Species/";
    static var speciesList:SpeciesList;
    public static function initDaList() {
        if (FileUtils.fileExists("LIST.JSON", SpeciesBaseDir)) {
            speciesList = cast Json.parse(FileUtils.getTextContent("LIST.JSON", SpeciesBaseDir, false));
        }
    }
    public static function getSpeciesList() {
        var myAss:TrueSpeciesList = new TrueSpeciesList(speciesList);
        return myAss;
    }
    public static function getSpeciesInfo(speciesName:String, isSub:Bool = false, ?parentName:String):Species {
        var infoThing:Dynamic;
        if (isSub && parentName != null) {
            if (FileUtils.fileExists(parentName + "/" + speciesName + ".subspecies", SpeciesBaseDir)) {
                var jsonThingy:JsonFormat_Subspecies = cast Json.parse(FileUtils.getTextContent(speciesName + ".subspecies", SpeciesBaseDir + parentName + "/", false));
                infoThing = new Subspecies(jsonThingy.name, jsonThingy.desc, jsonThingy.extending, jsonThingy.isOfficial, jsonThingy.creatorName);
            } else {
                infoThing = new Subspecies(speciesName, "An unknown subspecies.\n\n(This is a placeholder. To see your subspecies info you'll have to make sure it exists in the following path: Assets/Species/ParentSpecies/" + speciesName + ".subspecies, replacing ParentSpecies with the actual name of the parent species.", "some unknown species", true, #if sys Sys.getEnv(#if windows "USERNAME" #else "USER" #end) #else "whoever is using this app" #end);
            }
        } else if (isSub && parentName == null) {
            infoThing = new Subspecies(speciesName, "An unknown subspecies.\n\n(This is a placeholder. To see your subspecies info you'll have to make sure it exists in the following path: Assets/Species/ParentSpecies/" + speciesName + ".subspecies, replacing ParentSpecies with the actual name of the parent species.", "some unknown species", true, #if sys Sys.getEnv(#if windows "USERNAME" #else "USER" #end) #else "whoever is using this app" #end);
        } else {
            if (FileUtils.fileExists("main.species", SpeciesBaseDir + speciesName + "/")) {
                var jsonThingy:JsonFormat_Species = cast Json.parse(FileUtils.getTextContent("main.species", SpeciesBaseDir + speciesName + "/"));
                infoThing = new Species(jsonThingy.name, jsonThingy.desc, jsonThingy.media);
            } else {
                infoThing = new Species(speciesName, "An unknown species.\n\n(This is a placeholder. To see your species info you'll have to make sure it exists in the following path: Assets/Species/" + speciesName + "/main.species", "Some unknown media");
            }
        }
        return infoThing;
    }
}
class TrueSpeciesList {
    public var NameList:Array<String> = [];
    public var PathList:Array<String> = [];
    public var FileList:Array<String> = [];
    public function new(BussyShit:SpeciesList) {
        for (thatShit in BussyShit.daList) {
            NameList.push(thatShit.specName);
            if (thatShit.specDir == thatShit.specName) {
                PathList.push(thatShit.specDir + "/");
                FileList.push("main.species");
            } else {
                PathList.push(thatShit.specDir + "/");
                FileList.push(thatShit.specName + ".subspecies");
            }
        }
    }
}