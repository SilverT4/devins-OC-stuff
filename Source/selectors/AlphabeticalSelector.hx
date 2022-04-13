package selectors;

import haxe.ds.ArraySort;
import FileUtils;
import flixel.*;
import flixel.text.*;
import flixel.ui.*;
import flixel.addons.ui.*;
import flixel.group.FlxGroup.FlxTypedGroup as Crew;
import extraShit.*;
using StringTools;

/**This is *technically* an extension of the SelectorState file, but I'm using separate FlxStates because I don't know how to extend from the SelectorState without null errors. Like with SelectorState, you can check out the commit history to see what I tried doing with this state.
    
@since 0.0.3 (early April 2022)*/
class AlphabeticalSelector extends FlxState {
    // wip!
    var charList:Array<String> = [];
    var pissBg:BackgroundSprite;

    public function new() {
        super();
        #if debug
        charList = ["Sus", "Gear (won't crash)"];
        charList.sort(alphabetSoup);
        trace(charList);
        #else
        //i need to make sort
        #end
    }

    function alphabetSoup(ass:String, hole:String):Int {
        ass = ass.toUpperCase();
        hole = hole.toUpperCase();

        if (ass < hole) {
            return -1;
        } else if (ass > hole) {
            return 1;
        } else {
            return 0;
        }
    }
}