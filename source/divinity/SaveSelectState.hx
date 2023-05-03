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
        FlxG.mouse.visible = true;

        var menuText:FlxText;
        var menuText2:FlxText;

        var bg:FlxBackdrop = new FlxBackdrop(Paths.image('udGrid'), 0.2, 0);
		bg.velocity.set(25, 25);
		bg.updateHitbox();
        bg.scale.x = 2;
        bg.scale.y = 2;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

        var textBG:FlxSprite = new FlxSprite(0, 20).makeGraphic(FlxG.width, 70, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		var leText:String = "FRIDAY NIGHT FUNKIN' | VS DAVE & BAMBI: UNIVERSAL DIVINITY";
        var leText2:String = "Use your cursor to select a save file. Pressing R will reset all save files.";

		menuText = new FlxText(textBG.x + -10, textBG.y + 3, FlxG.width, leText, 21);
		menuText.setFormat(Paths.font("comic-sans.ttf"), 28, FlxColor.WHITE, CENTER);
		menuText.scrollFactor.set();
		add(menuText);
        
        menuText2 = new FlxText(textBG.x + -10, textBG.y + 33, FlxG.width, leText2, 21); 
		menuText2.setFormat(Paths.font("comic-sans.ttf"), 20, FlxColor.WHITE, CENTER);
		menuText2.scrollFactor.set(); 
		add(menuText2);
    }
    
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER) {
            FlxG.mouse.visible = false;
			FlxG.sound.play(Paths.music('confirmMenu'));
            LoadingState.loadAndSwitchState(new TitleState());
        }
    }
}