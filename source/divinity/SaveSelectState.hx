package divinity;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class SaveSelectState extends MusicBeatState //i hate nigrhfergfherg
{
    public static var preSaveFileName:String = 'save1';

    override function create()
	{
        var bg:FlxBackdrop = new FlxBackdrop(Paths.image('udGrid'), 0.2, 0);
		bg.velocity.set(25, 25);
		bg.updateHitbox();
        bg.scale.x = 2;
        bg.scale.y = 2;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
    }
    
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER) {
			FlxG.sound.play(Paths.music('confirmMenu'));
            LoadingState.loadAndSwitchState(new TitleState());
        }
    }
}