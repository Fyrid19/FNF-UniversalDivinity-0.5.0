package;

import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import FreeplayState.SongMetadata;

using StringTools;

typedef FreeplayPackList = {
	public var packs:Array<FreeplayPack>;
}

typedef FreeplayPack = {
	public var songs:Array<SongMetadata>;
	public var name:String;
	public var imageName:String;
	public var color:String;
}

class FreeplayPackState extends MusicBeatState 
{
	var curSelected:Int = 0;
    var BG:FlxSprite;
	var iconGrp:FlxTypedGroup<FlxSprite>;
}