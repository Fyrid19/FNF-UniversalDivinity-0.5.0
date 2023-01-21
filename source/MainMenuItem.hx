package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class MainMenuItem extends FlxSprite //cool menu item scroll
{
	public var forceX:Float = Math.NEGATIVE_INFINITY;
	public var targetY:Float = 0;
	public var targetX:Float = 0;
	public var yMult:Float = 120;
	public var xAdd:Float = 0;
	public var yAdd:Float = 0;

    public function new()
	{
		super();

		//this.image = image;
	}

    override function update(elapsed:Float)
    {
        var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

		y = FlxMath.lerp(y - 80, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
        x = FlxMath.lerp(x - 110, (targetY * 70) + 90, 0.16);
		
        //loadGraphic(Paths.image(image));

		super.update(elapsed);
	}
}