package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.addons.effects.chainable.FlxGlitchEffect;
import Shaders.GlitchEffect;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import Achievements;
import flixel.input.keyboard.FlxKey;
import editors.MasterEditorMenu;
import divinity.NewStoryDivinity;
import divinity.DivinityFreeplayState;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var devModVer:String = 'ALPHA 2'; //THIS IS USED FOR FUCKING YOU SO TIGHT IN THE A- -frogb
	public static var curModVer:String = 'Early 1.0'; //This is also used for yo maa ma AAAAAAAAAA-
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['story_mode', 'freeplay', 'credits', 'options'];

	var bg:FlxBackdrop;
	var magenta:FlxBackdrop;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	public static var sexo3:Bool = true;

	public static var firstStart:Bool = true;

	public static var finishedFunnyMove:Bool = false;
	
	public static var daRealEngineVer:String = 'David';

	public static var engineVers:Array<String> = ['FyriDev', 'Divinity', 'FrogB', 'Mordon', 'Tristan', 'Morrow', 'Rambi', 'Barren'];

	public static var doTheFunny:Bool = true;

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

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		daRealEngineVer = engineVers[FlxG.random.int(0, 2)];

		//only update the hitbox shit after putting EVERYTHING IN -frogb

		var yScroll:Float = Math.max(0.1 - (0.03 * (optionShit.length - 4)), 0.1);
		var bg = new FlxBackdrop(MainMenuState.randomizeBG(), 0.2, 0, true, true);
		bg.velocity.set(25, 0);
		bg.screenCenter(X);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.updateHitbox();
		bg.color = 0xFFfd719b;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxBackdrop(MainMenuState.randomizeBG(), 0.2, 0, true, true);
		magenta.velocity.set(25, 0);
		magenta.scrollFactor.set();
		magenta.screenCenter(X);
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFFDE871;
		magenta.updateHitbox();
		add(magenta);

		var bars:FlxSprite = new FlxSprite().loadGraphic(Paths.image('barFull'));
        bars.scale.y = 1.0;
		bars.screenCenter(X);
		bars.scrollFactor.set();
        bars.antialiasing = ClientPrefs.globalAntialiasing;
		bars.updateHitbox();
		add(bars);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;

		for (i in 0...optionShit.length)
			{
				var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
				//menuItem.scale.x = scale;
				//menuItem.scale.y = scale;
				menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.x = 100;
				menuItems.add(menuItem);
				menuItem.scrollFactor.set();
				menuItem.antialiasing = ClientPrefs.globalAntialiasing;
				if (firstStart)
					FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
						{ 
							finishedFunnyMove = true; 
							changeItem();
						}});
				else
					menuItem.y = 60 + (i * 160);
			}

		firstStart = false;

		FlxG.camera.follow(camFollowPos, null, 1);

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
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, curModVer + " Divinity Engine, VD&B: Universal Divinity DEMO", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if android
		addVirtualPad(UP_DOWN, A_B_E);
		#end
		
		super.create();

		//fyrid i'll leave this part to you.
		// -frogb

		/*switch (FlxG.random.int(1, 1))
		{
			case 1:
				char = new FlxSprite(100, 270).loadGraphic(Paths.image('mainmenu/CHARACTER SPRITESHEET NAME HERE'));//put your cords and image here
				char.frames = Paths.getSparrowAtlas('mainmenu/CHARACTER XML NAME HERE');//here put the name of the xml
				char.animation.addByPrefix('idleR', 'idle normal', 24, true);//on 'idle normal' change it to your xml one
				char.animation.play('idleR');//you can rename the anim however you want to
				char.scrollFactor.set();
				char.antialiasing = ClientPrefs.globalAntialiasing;
				add(char);
		*/
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		var doTheFunny:Bool = true;

		if (doTheFunny) {
	    	FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
		}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
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
				sexo3 = false;
			}

			if (controls.ACCEPT)
				{
					if (optionShit[curSelected] == 'donate')
					{
						CoolUtil.browserLoad('https://gamebanana.com/mods/43201');
					}
					if (optionShit[curSelected] == 'story_mode')
					{
						FlxG.sound.play(Paths.sound('locked'), 0.7);
						FlxG.camera.shake(0.005, 0.35);
						trace('nope.');
					}
					else
					{
						selectedSomethin = true;
						FlxG.sound.play(Paths.sound('confirmMenu'));

						if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

						FlxTween.tween(FlxG.camera, {zoom:1.35}, 1.5, {ease: FlxEase.expoIn}); //changed the duration to tackle a camera issue 
	
						menuItems.forEach(function(spr:FlxSprite)
						{
							if (curSelected != spr.ID)
							{
								FlxTween.tween(spr, {alpha: 0}, 1.3, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});
							}
							else
							{
								if(ClientPrefs.flashing)
								{
									FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
									{
										goToState();
									});
								}
								else
								{
									new FlxTimer().start(1, function(tmr:FlxTimer)
									{
										goToState();
									});
								}
							}
						});
					}
				}
			}
			#if !html5
			else if (FlxG.keys.anyJustPressed(debugKeys) #if android || _virtualpad.buttonE.justPressed #end)
			{
			  selectedSomethin = true;
			  MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
	
			super.update(elapsed);
		}
	function goToState()
		{
			var daChoice:String = optionShit[curSelected];
	
			switch (daChoice)
			{
				case 'story_mode':
					FlxG.camera.shake(0.005, 0.35);
					FlxG.sound.play(Paths.sound('locked'), 0.7);
				case 'freeplay':
					MusicBeatState.switchState(new divinity.DivinityFreeplayState());
				case 'credits':
					MusicBeatState.switchState(new CreditsState());
				case 'awards':
					MusicBeatState.switchState(new AchievementsMenuState());
				case 'options':
					MusicBeatState.switchState(new options.OptionsState());
			}
		}

	override function beatHit() {
		super.beatHit();

		if (curBeat % 1 == 0) //it doesnt work but when i tested it out it gave kind of a cool transition so im going to leave it here.
		{
			FlxG.camera.zoom += 1.02;
		}
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