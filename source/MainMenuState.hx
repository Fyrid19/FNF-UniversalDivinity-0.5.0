package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import options.OptionsState;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var devModVer:String = 'ALPHA 1'; //THIS IS USED FOR FUCKING YOU SO TIGHT IN THE A- -frogb
	public static var curModVer:String = 'Early 1.0'; //This is also used FOR YOUR MOTHE-
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['story_mode', 'freeplay' , 'credits' , 'options']; // god rid of credits since i dont think we are gonna use it that much tbh, unless yall want a ost player? -frogb

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	private var char1:Character = null; // put yo characters here
	private var char2:Character = null; // put more characters here
	private var char3:Character = null; // PUT WAY TOO MANY CHARACTERS here
	private var char4:Character = null; // PUT ALL THE CHARACTERS HERE!!!

	public static var sexo3:Bool = true;

	public static var firstStart:Bool = true;

	public static var finishedFunnyMove:Bool = false;
	
	public static var daRealEngineVer:String = 'David';

	public static var engineVers:Array<String> = ['Fyrid', 'Divinity', 'FrogB', 'Mordon', 'Tristan', 'Morrow', 'Rambi', 'Barren'];

	public static var bgPaths:Array<String> = 
	[
		'DandruNotHere',
		'melDoesStuff',
		'melDoesStuff2',
		'Laughz',
		'MooseDave'
	];

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Divinity Gates", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		daRealEngineVer = engineVers[FlxG.random.int(0, engineVers.length)];

		var yScroll:Float = Math.max(0.1 - (0.03 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(randomizeBG());
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.color = 0xFFfd719b;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(bg.graphic);
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFFDE871;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItem.x += 250;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		firstStart = false;

		FlxG.camera.follow(camFollowPos, null, 1);

		char1 = new Character(900, 60, 'bf', true);
		char1.setGraphicSize(Std.int(char1.width * 0.8));
		add(char1);
		char1.visible = false;

		FlxTween.tween(char1, {y: char1.y + 50}, 5, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(char1, {y: char1.y + 50}, 5, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		char2 = new Character(800, 400, 'RandoScript', true);
		char2.setGraphicSize(Std.int(char2.width * 0.8));
		add(char2);
		char2.visible = false;

		FlxTween.tween(char2, {y: char2.y + 50}, 5, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(char2, {y: char2.y + 50}, 5, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		char3 = new Character(800, 400, 'gf', true);
		char3.setGraphicSize(Std.int(char3.width * 0.8));
		add(char3);
		char3.visible = false;

		FlxTween.tween(char3, {y: char3.y + 50}, 5, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(char3, {y: char3.y + 50}, 5, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});
		
		char4 = new Character(800, 400, 'dad', true);
		char4.setGraphicSize(Std.int(char4.width * 0.8));
		add(char4);
		char4.visible = false;

		FlxTween.tween(char4, {y: char4.y + 50}, 5, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(char4, {y: char4.y + 50}, 5, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		var versionShit:FlxText = new FlxText(12, FlxG.height - 84, 0, "Universal Divinity Developer Build " + devModVer, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, curModVer + " Divinity Engine, VD&B: Universal Divinity 1.0", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

	// i removed the char2, char 3 and char 4 temporarily because they give me a stupid haxeflixel icon despite me defining them wtf is a haxeflixel more like haxefuckxel

		if (optionShit[curSelected] == 'story_mode')
		{
			changeItem(-1);
			changeItem(1);

			char1.dance();
			char1.updateHitbox();
			char1.visible = true;
		}
		else
		{
			char1.visible = false;
		}

		if (optionShit[curSelected] == 'freeplay')
			{
				changeItem(-1);
				changeItem(1);
	
				//char2.dance();
				//char2.updateHitbox();
				//char2.visible = true;
			}
			else
			{
				char2.visible = false;
			}

			if (optionShit[curSelected] == 'options')
				{
					changeItem(-1);
					changeItem(1);
		
					//char3.dance();
					//char3.updateHitbox();
					//char3.visible = true;
				}
				else
				{
					char3.visible = false;
				}
		
		if (optionShit[curSelected] == 'credits')
				{
					changeItem(-1);
					changeItem(1);
		
					//char4.dance();
					//char4.updateHitbox();
					//char4.visible = true;
				}
				else
				{
					char4.visible = false;
				}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					FlxTween.tween(FlxG.camera, {zoom:1.35}, 1.45, {ease: FlxEase.expoIn}); // the funny purgatory camera zoom

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new divinity.DivinityFreeplayState());
									case 'extras': // NOW A PLACEHOLDER LOL
										MusicBeatState.switchState(new ExtrasMenuState());
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.offset.y = 0;
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				spr.offset.x = 0.15 * (spr.frameWidth / 2 + 180);
				spr.offset.y = 0.15 * spr.frameHeight;
				FlxG.log.add(spr.frameWidth);
			}
		});
	}
	public static function randomizeBG():flixel.system.FlxAssets.FlxGraphicAsset
	{
		var chance:Int = FlxG.random.int(0, bgPaths.length - 1);
		return Paths.image('backgrounds/' + bgPaths[chance]);
	}
}