package characterUtils;

import haxe.Json;
import haxe.extern.EitherType;
import lime.system.Clipboard;
import characterUtils.SpeciesThingie;
using StringTools;

typedef JsonFormat_CIMain = {
    var name:String;
    var ?nickname:String;
    var species:EitherType<JsonFormat_Species, JsonFormat_Subspecies>;
    var birthday:Birthday;
    var height:Height;
    var languageList:Array<String>;
    var favourites:JsonFormat_CIFS;
    var headcanons:Array<JsonFormat_CIHC>;
}
typedef JsonFormat_CIFS = {
    var MusicGenre:String;
    var Colours:Array<String>;
    var VideoGames:Array<String>;
    var Aesthetic:String;
}
typedef JsonFormat_CIHC = {
    var headCanon:String;
    var since:String;
    var ?imageName:String;
}

class CharInfoJsonUtil {
    public static function pissMoon(FilePath:String) {
        return haxe.Json.parse(#if sys sys.io.File.getContent #else openfl.Assets.getText #end(FilePath));
    }

    public static function moonPiss(FuckMe:JsonFormat_CIMain) {
        var poop:Array<Headcanon> = [];
        for (FUCK in FuckMe.headcanons) {
            poop.push(new Headcanon(FUCK.headCanon, FUCK.since));
        }
        var memeShit:Species;
        var spicyBalls:Subspecies;
        var theSpecies:Species;
        var piss:Dynamic = FuckMe.species;
        if (piss.extending == null) {
            var horn:JsonFormat_Species = piss;
            memeShit = new Species(horn.name, horn.desc, horn.media);
            theSpecies = memeShit;
        } else {
            var knee:JsonFormat_Subspecies = piss;
            spicyBalls = new Subspecies(knee.name, knee.desc, knee.extending, knee.isOfficial, knee.creatorName);
            theSpecies = spicyBalls;
        }
        var pissy:FavouriteStuff = new FavouriteStuff(FuckMe.favourites.MusicGenre, FuckMe.favourites.Colours, FuckMe.favourites.VideoGames, FuckMe.favourites.Aesthetic);
        return new CharInfo(FuckMe.name, FuckMe.nickname, theSpecies, FuckMe.birthday, FuckMe.height, FuckMe.languageList, pissy, poop);
    }
}
class CharInfo {
    public var name:String;
    public var nickname:String;
    public var species:Species;
    public var birthday:Birthday;
    public var height:Height;
    public var age:EitherType<Int, String>; // THIS GETS CALCULATED BASED ON THE CURRENT *YEAR* AND THE YEAR OF YOUR CHARACTER'S BIRTHDAY. IF YOU DON'T ADD THE YEAR, IT'LL SAY "UNKNOWN"
    public var languageList:Array<String>;
    public var favourites:FavouriteStuff;
    public var headcanons:Array<Headcanon>;
    private var INFO_SHIT:Array<Dynamic>;
    public function new(name:String, ?nickname:String, species:Species, birthday:Birthday, height:Height, languageList:Array<String>, favs:FavouriteStuff, hcs:Array<Headcanon>) {
        this.name = name;
        if (nickname != null) this.nickname = nickname;
        this.species = species;
        this.birthday = birthday;
        this.height = height;
        this.languageList = languageList;
        this.favourites = favs;
        this.headcanons = hcs;
        doAgeCalc(this.birthday);
        INFO_SHIT = ["Name: " + this.name,
                    "Nickname: " + ((this.nickname != null) ? this.nickname : "N/A"),
                    "Birthday\n=============\nMonth: " + this.birthday.month + "\nDate: " + this.birthday.day + "\nYear (-1 means N/A): " + ((this.birthday.year != null) ? this.birthday.year : -1) + "\n=============",
                    "Height: " + ((this.height.ft != null && this.height.inch != null) ? this.height.ft + "'" + this.height.inch + '\'' : this.height.cm + "cm"),
                    "Languages: " + this.languageList.join('; ')];
        if (this.age != null) {
            INFO_SHIT.push("Age:" + this.age);
        }
        species.onInfoCreate();
        #if debug trace(INFO_SHIT.join('\n')); #end
    }

    function doAgeCalc(sus:Birthday) {
        if (sus.year != null) {
            var amogus:Date = Date.now();
            var piss = Std.string(amogus).split(' ');
            var shake = piss[0].split('-');
            var hhhh = Std.parseInt(shake[0]) - sus.year;
            if (Std.parseInt(shake[1]) <= getFUCK(sus.month)) {
                trace("IS THE MONTH CURRENT???");
                if (Std.parseInt(shake[1]) == getFUCK(sus.month)) {
                    trace("YES. NOW IS THE DAY PAST OR FUTURE?");
                    if (Std.parseInt(shake[2]) < sus.day) {
                        trace("PAST.");
                        this.age = hhhh;
                    } else if (Std.parseInt(shake[2]) == sus.day) {
                        trace("OH SHIT, IT'S TODAY. HAPPY BIRTHDAY TO " + this.name.toUpperCase() + "!!");
                        this.age = hhhh;
                    } else {
                        trace("FUTURE.");
                        this.age = hhhh - 1;
                    }
                } else {
                    trace("NOPE. IT'S PAST, IT SEEMS.");
                    this.age = hhhh;
                }
            } else {
                this.age = hhhh - 1;
            }
            trace(amogus + "\n" + sus + "\n" + shake);
        } else {
            this.age = "Ageless/Unknown";
        }
    }

    function getFUCK(MONTH:Dynamic) {
        if (MONTH is Int) return MONTH;
        else {
            var ret:Int = monthArray.indexOf(MONTH) + 1;
            return ret;
        }
    }

    public static function getSHIT(MONTH:Dynamic) {
        if (MONTH is String) return MONTH;
        else {
            var ret:String = monthArray[Std.int(MONTH - 1)];
            return ret;
        }
    }
    static var monthArray = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ];
}

class Headcanon {
    public var headCanon:String;
    public var since:String;
    public var expandedInfo:String;
    public var imageName:String;
    private var INFO_SHIT:Array<String> = [];
    public function new(hc:String, since:String, ?moreInfo:String, ?picName:String) {
        this.headCanon = hc;
        this.since = since;
        INFO_SHIT = ["Headcanon: " + this.headCanon,
                    "Since: " + this.since];
        if (moreInfo != null) {
            this.expandedInfo = moreInfo;
            INFO_SHIT.push("More info: " + this.expandedInfo);
        }
        if (picName != null) {
            this.imageName = picName;
            INFO_SHIT.push("Image file:" + this.imageName);
        }
        #if debug trace(INFO_SHIT); #end
    }
}
class FavouriteStuff {
    public var MusicGenre:String;
    public var Colours:Array<String>;
    public var VideoGames:Array<String>;
    public var Aesthetic:String;
    private var INFO_SHIT:Array<Dynamic> = [];
    public function new(MusicGenre:String, Colours:Array<String>, VideoGames:Array<String>, Aesthetic:String) {
        this.Aesthetic = Aesthetic;
        this.VideoGames = VideoGames;
        this.Colours = Colours;
        this.MusicGenre = MusicGenre;
        INFO_SHIT = ["Music genre: " + this.MusicGenre,
                    "Video games: " + this.VideoGames.join('; '),
                    "Colours: " + this.Colours.join('; '),
                    "Aesthetic: " + this.Aesthetic];
        #if debug trace(INFO_SHIT.join("\n")); #end
    }
}
typedef Height = {
    var ?ft:Int;
    var ?inch:Int; // if you use ft'in", use ft and inch!
    var ?cm:Int; // If you use cm, use this!
}
typedef Birthday = {
    var month:EitherType<Int, String>; // can be a string or int, both will show up correctly!
    var day:Int;
    var ?year:Int; // this can be used to calculate the age, but leave it null if the character is ageless.
}