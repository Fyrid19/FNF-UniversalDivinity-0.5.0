package divinity;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import divinity.DivinityFreeplayState;

using StringTools;

class SkinSelectState extends MusicBeatState
{
    public static var curSkin:String = 'bf';

    // info shit
    var curText:FlxText;
    var controlsText:FlxText;
    var formText:FlxText;

    public static var curSelected:Int = 0;
    var charSelected = false;

    var skinList:Array<String> = [];

    var bg:FlxBackdrop;
    var character:Boyfriend;
    var playtesting:Bool = false;
    var animTimer:FlxTimer;

    var playtestTxt:FlxText;
    
    override function create()
	{
        skinList = CoolUtil.coolTextFile(Paths.txt('skinList'));

        FlxG.sound.playMusic(Paths.music("breakfast"), 1, true);

		bg = new FlxBackdrop(MainMenuState.randomizeBG(), 0.2, 0);
		bg.velocity.set(25, 0);
		bg.updateHitbox();
		bg.screenCenter(X);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

        var buttonBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('arrowBGFull'));
        buttonBG.updateHitbox();
        buttonBG.scale.x = 1.8;
        buttonBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(buttonBG);

        var bars:FlxSprite = new FlxSprite().loadGraphic(Paths.image('barFull'));
        bars.updateHitbox();
        bars.scale.y = 2.0;
        bars.antialiasing = ClientPrefs.globalAntialiasing;
		add(bars);

        character = new Boyfriend(0, 0, curSkin);
        character.screenCenter();
        add(character);

        playtestTxt = new FlxText(0, FlxG.height - 30, 800, 'PLAYTESTING', 64);
        playtestTxt.setFormat('default.ttf', 64, 0xFFFFFF, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        playtestTxt.screenCenter(X);
        add(playtestTxt);
            
        controlsText = new FlxText(10, 50, 0, 'Left or right to change character.\nPress ESC to go back to the Freeplay Menu\n', 20);
        controlsText.setFormat(Paths.font("comic.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        controlsText.size = 20;
    
        // add(formText); took this from strident crisis but wtf is a formtext?
        // something we dont need :troll: - fyrid
        add(controlsText);

        FlxTween.tween(buttonBG, {'scale.x': 1}, 1, {ease: FlxEase.circOut});
        FlxTween.tween(bars, {'scale.y': 1}, 1, {ease: FlxEase.circOut});
        FlxTween.tween(controlsText, {'scale.y': 1}, 1, {ease: FlxEase.circOut});

        super.create();
        
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.BACK && !charSelected) {
            MusicBeatState.switchState(new divinity.DivinityFreeplayState());
        }

        if(controls.NOTE_LEFT_P && playtesting && !charSelected) {
			character.playAnim('singLEFT', true);
            animTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
            {
                character.playAnim('idle', true);
            });
		}

        if(controls.NOTE_RIGHT_P && playtesting && !charSelected) {
			character.playAnim('singRIGHT', true);
            animTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
            {
                character.playAnim('idle', true);
            });
		}

        if(controls.NOTE_UP_P && playtesting && !charSelected) {
			character.playAnim('singUP', true);
            animTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
            {
                character.playAnim('idle', true);
            });
		}

        if(controls.NOTE_DOWN_P && playtesting && !charSelected) {
			character.playAnim('singDOWN', true);
            animTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
            {
                character.playAnim('idle', true);
            });
		}

        if (controls.UI_RIGHT_P && !playtesting && !charSelected) {
            changeSkin(1);
        }

        if (controls.UI_LEFT_P && !playtesting && !charSelected) {
            changeSkin(-1);
        }

        if (FlxG.keys.justPressed.P && !charSelected) {
			if (!playtesting) {
                playtesting = true;
            } else {
                playtesting = false;
            }
		}

        if (playtesting) {
            playtestTxt.alpha = 1;
            FlxFlicker.flicker(playtestTxt, 0, 0.5, false);
        } else {
            playtestTxt.alpha = 0;
        }

        if (controls.ACCEPT && !playtesting) {
            charSelected = true;
            var heyAnimation:Bool = character.animation.getByName("hey") != null; 
			character.playAnim(heyAnimation ? 'hey' : 'singUP', true);
            FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd'));
            new FlxTimer().start(2, function(tmr:FlxTimer)
            {
                LoadingState.loadAndSwitchState(new PlayState());
            });
        }
    }

    function changeSkin(num:Int) {
        curSelected += num;
        curSkin = skinList[curSelected];

        character.destroy();
        character = new Boyfriend(0, 0, curSkin);
        character.screenCenter();
        add(character);

        if (curSelected >= skinList.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = skinList.length;
    }
}