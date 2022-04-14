package characterUtils;


/**This json format exists for the character info JSONs. It'll make species stuff a *bit* easier to manage.
    
@param name The species (or subspecies) name
@param isSub If your character is part of a subspecies, set this to true. Otherwise, set this to false.
@param parent The parent species of the subspecies (optional if isSub is false!)*/
typedef JsonFormat_SpeciesInfo = {
    var name:String;
    var isSub:Bool;
    var ?parent:String;
}
/**A json format for a species.
    
@param name The species name.
@param desc A basic description of the description.
@param media The source media of the species, such as a franchise or series.*/
typedef JsonFormat_Species = {
    var name:String;
    var desc:String;
    var media:String;
}

/**A json format for a subspecies.
    
@param name The subspecies name
@param desc A basic description of the subspecies.
@param extending The parent species.
@param creatorName If this isn't a canon subspecies in the parent species' canon, you can include the original creator of the subspecies here.
@param isOfficial If this is a canon subspecies in the parent species' canon, set this to true.*/
typedef JsonFormat_Subspecies = {
    var name:String;
    var desc:String;
    var extending:String;
    var isOfficial:Bool;
    var ?creatorName:String;
}
/**This controls OC species info ig
    
@since 0.0.3 (early April 2022)*/
class SpeciesInfo {
    public var specName:String = "";
    public var parentName:String = "Not a subspecies";
    public var specDesc:String = "";
    public var specMedia:String = "";
    public var specCreator:String = "Unknown";
    public var isSub:Bool = false;
    public var isOriginal:Bool = false;
    public function new(specName:String, specDesc:String, specMedia:String, isSub:Bool = false, isOriginal:Bool, ?parentName:String, ?specCreator:String) {
        this.specName = specName;
        this.specDesc = specDesc;
        this.specMedia = specMedia;
        this.isSub = isSub;
        this.isOriginal = isOriginal;
        if (parentName != null) this.parentName = parentName;
        if (specCreator != null) this.specCreator = specCreator;
    }

    public function traceInfo() {
        //traces each field in individual lines!
        trace("Species name: " + specName);
        trace("Species description: " + specDesc);
        trace("Species origin media: " + specMedia);
        trace("Is a subspecies of another: " + ((isSub) ? "Yes, subspecies of " + parentName : parentName)); // BECAUSE PARENTNAME IS "NOT A SUBSPECIES" BY DEFAULT I STILL USE IT!
        trace("Species is original: " + ((isOriginal) ? "Yes, " + ((specCreator != "Unknown") ? "original creator is unknown" : "created by " + specCreator) : "No."));
    }
}

class Species {
    /**The name of the species or subspecies.*/
    public var name:String;
    /**A basic description of this species or subspecies.*/
    public var description:String;
    /**This variable is for where the species is originally from in terms of media, such as a TV show or franchise.*/
    public var ogMedia:String; // where the species comes from in terms of media.
    var INFO_SHIT:Array<Dynamic>;
    /**Creates a new Species information thing.
        
    @param SN The species name.
    @param desc A basic description of the species.
    @param media Its source media, such as a TV show or franchise.*/
    public function new(SN:String, desc:String, media:String) {
        this.name = SN;
        this.description = desc;
        this.ogMedia = media;
    }

    @:allow(characterUtils.CharInfo)
    function onInfoCreate() {
        makeInfoShit();
    }

    public function getInfo() {
        if (INFO_SHIT != null) return INFO_SHIT.join("\n");
        else {
            INFO_SHIT = ["Species Name: " + this.name,
            "Species description: " + this.description,
            "Source media: " + this.ogMedia];
            return INFO_SHIT.join("\n");
        }
    }
    function makeInfoShit() {
        if (INFO_SHIT == null) INFO_SHIT = ["Species Name: " + this.name,
    "Species description: " + this.description,
    "Source media: " + this.ogMedia];
        trace(INFO_SHIT.join("\n"));
    }
}

class Subspecies extends Species {
    /*public var name:String;
    public var description:String; */
    /**What species this is a subspecies of.*/
    public var extending:String;
    /**Here's a basic explanation of how this variable works:
        ```haxe
        if isOfficial is true when you create the instance, then the variable gets set to "Same as extending", otherwise it gets set to "Original subspecies of extending".
        ```*/
    var sourceMedia:String;
    /**Creates a new Subspecies info instance.
        
    @param SSN The subspecies name.
    @param desc A basic description of the subspecies.
    @param extensionOf What this is a subspecies of.
    @param isOfficial If this subspecies exists in the canon of the parent species' media, then this should be true. Otherwise, set it to false.
    @param creator If this subspecies doesn't exist in the canon of the parent species' media, you can credit the creator of it here. (Optional)*/
    public function new(SSN:String, desc:String, extensionOf:String, isOfficial:Bool, ?creator:String) {
        this.name = SSN;
        this.description = desc;
        this.extending = extensionOf;
        if (isOfficial) sourceMedia = "Same as " + this.extending;
        else {
            if (creator != null) {
                sourceMedia = "Original subspecies of " + this.extending + " by " + creator;
            } else {
                sourceMedia = "Original subspecies of " + this.extending;
            }
        }
        super(this.name, this.description, this.sourceMedia);
    }
    override function getInfo() {
        if (INFO_SHIT != null) trace("E");
        else {
            INFO_SHIT = [
                "Subspecies name: " + this.name,
                "Subspecies description: " + this.description,
                "Parent species: " + this.extending,
                "Subspecies media: " + this.sourceMedia
            ];
        }
        return super.getInfo();
    }
    override function makeInfoShit() {
        INFO_SHIT = [
            "Subspecies name: " + this.name,
            "Subspecies description: " + this.description,
            "Parent species: " + this.extending,
            "Subspecies media: " + this.sourceMedia
        ];
        super.makeInfoShit();
    }
}