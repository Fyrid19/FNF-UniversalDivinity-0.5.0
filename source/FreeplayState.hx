package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.util.FlxStringUtil;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end
import divinity.SkinSelectState;
using StringTools;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/melDoesStuff2'));

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var curChar:String = "unknown";

	public static var fart:Bool = false;

	private var InMainFreeplayState:Bool = false;
	private var isInMods:Bool = false;

	public var allowinputShit:Bool = true;

	private var CurrentSongIcon:FlxSprite;

	private var AllPossibleSongs:Array<String> = ["main", "extrasandfanmades", "covers"];

	private var CurrentPack:Int = 0;

	var loadingPack:Bool = false;

	var songColors:Array<FlxColor> = [ // numbers at the side represent the number of that item in a array.
		0xFF000000, // DUMBASS PLACEHOLDER 0
		0xFF1D3FFF, // DAVE 1
		0xFFDC97AA, // ANGEY ANGER 2
		0xFF00B515, // MISTER BAMBI RETARD (thats kinda rude ngl) 3
		0xFF4965FF, // fdfdfd 4 
		0xFFA40B09, // EVIL UNFAIRNESSSSS 5
		0xFFFF0030, // 3d dave og color scary (sharted) 6
		0xFF00FFFF, // SPLIT THE THONNNNN 7
		0xFFFFFFFF, // blinding 8
		0xFFFFD146, // divinity stuf 9
		0xFFE7F1FF, // divinity stuf 10
		0xFF8302DF, // divinity stuf 11
		0xFFAAAAAA, // divinity stuf 12
		0xFF3B4FFF, // divinity stuf 13
		0xFFFFEA00, // divinity stuf 14
    ];

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		#if desktop
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end
		
		var isDebug:Bool = false;

		persistentUpdate = true;
		WeekData.reloadWeekFiles(false);

		#if debug
		isDebug = true;
		#end

		bg.loadGraphic(MainMenuState.randomizeBG());
		bg.color = 0xFF4965FF;
		add(bg);

		CurrentSongIcon = new FlxSprite(0,0).loadGraphic(Paths.image('week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));

		CurrentSongIcon.centerOffsets(false);
		CurrentSongIcon.x = (FlxG.width / 2) - 256;
		CurrentSongIcon.y = (FlxG.height / 2) - -605; // haxe is weird
		CurrentSongIcon.antialiasing = true;

		add(CurrentSongIcon);

		FlxTween.tween(CurrentSongIcon,{y: 50}, 1.4, {ease: FlxEase.expoInOut});

		isInMods = false;

		super.create();
	}

	public function LoadProperPack() // wait fyrid what happened to singularity lmao -frogb 
		// its called ringularity ayo named it wrong -fyrid
		{
			switch (AllPossibleSongs[CurrentPack].toLowerCase())
			{
				case 'main':
					addWeek(['Midnight'], 1, ['dave-insanity']); // upheaval.
					addWeek(['Meadow'], 3, ['bambi']); // ayo renamed it coz of donut smh
					addWeek(['Golden'], 9, ['tristan-golden']);
					addWeek(['Undefiable'], 3, ['bambi3d']); // true exfucked
					addWeek(['Spiral'], 13, ['barren']); // unshitted barren
					addWeek(['Ringularity'], 14, ['lenzo']);
					addWeek(['Remorseless'], 12, ['morrow']);
					//EVERYTHING FROM HERE ONWARDS IS COMING IN V1, and yes i copied and pasted the sbarren template lmao ignore that -frogb
					//addWeek(['Apprehensive'], 8, ['sbarren']);
					//addWeek(['Distortion'], 8, ['sbarren']);
					//addWeek(['Reality Twist'], 8, ['sbarren']);
					//addWeek(['Distinctive'], 8, ['sbarren']);
					//addWeek(['Ultimatum'], 8, ['sbarren']);
				case 'extrasandfanmades':
					//addWeek(['Deep End'], 15, ['mordon']);
					//addWeek(['Unruly'], 6, ['dave-angey']);
					//addWeek(['SFF'], 3, ['bambi']);
					addWeek(['Hellbound'], 8, ['heldai-phase-1']); // remade in v1
					//addWeek(['Retro'], 6, ['dave-angey']);
					addWeek(['Intertwined'], 6, ['dave3d']);
					//addWeek(['All-Star'], 6, ['dave-angey']); // fyrid said she wanted it replaced, awaiting the new song name
					//addWeek(['Shifted'], 8, ['sbarren']); / shitted barren
				// case 'joke': //whenever you ready you take the double slashes off this shit
					//addWeek(['snoc'], 8, ['sbarren']);
					//addWeek(['Gamer'], 8, ['sbarren']);
				case 'covers':
					//addWeek(['Purgatory'], 8, ['sbarren']);
					//addWeek(['Roofs'], 8, ['face']);
					addWeek(['Disposition'], 8, ['heldai-phase-1']);
					//addWeek(['Endless D'], 8, ['face']);
					addWeek(['Boiling Point'], 11, ['mordon']);
					addWeek(['Tessattack'], 10, ['sbarren']);
					//addWeek(['Triple Trouble'], 8, ['sbarren']); //<--- and if some fucker presses 7 or do some other shitthey get bought to triple dev
					//addWeek(['Triple Dev'], 8, ['sbarren']); //<--- idk do something in triple trouble to unlock this???
					//god damn it redly (may be for 1.0 and 1.5 idk, unless we want a separate dev covers section or mod or some other shit)
					//addWeek(['Victory'], 8, ['sbarren']);
					//addWeek(['Armed'], 8, ['sbarren']);
					//addWeek(['Monotone Atack'], 8, ['sbarren']);
					//addWeek(['Gamebreaker'], 8, ['sbarren']);
					//addWeek(['Quadruple Quarrel'], 8, ['sbarren']);
					//addWeek(['Prey'], 8, ['sbarren']); // ITS ALL SHITTED BARRENNN -fyrid
					
			}
		}


	public function GoToActualFreeplay()
	{
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = false;
			songText.itemType = "D-Shape";
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("comic-sans.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.x = 20;
		scoreText.y = -60;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 1), 66, 0xFF000000);
		scoreBG.alpha = 0.5;
		scoreBG.screenCenter(X);
		scoreBG.y = -40;
		add(scoreBG);

		diffText = new FlxText(scoreText.x -10, scoreText.y + 30, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.x = 20;
		diffText.y = -40;
		// just like purgatory, I DONT ADD THE TEXT HAHA

		add(scoreText);

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		#if (PRELOAD_ALL && android)
	    	var leText:String = "Press X to listen to the Song / Press C to open the Gameplay Changers Menu / Press Y to Reset your Score and Accuracy.";
		#elseif (PRELOAD_ALL)
	    	var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		#elseif android
	    	var leText:String = "Press C to open the Gameplay Changers Menu / Press Y to Reset your Score and Accuracy."
 		#else 
	    	var leText:String = "Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		#end
		var text:FlxText = new FlxText(textBG.x + -10, textBG.y + 3, FlxG.width, leText, 21);
		text.setFormat(Paths.font("comic-sans.ttf"), 18, FlxColor.WHITE, LEFT);
		text.scrollFactor.set();
		add(text);
		
		#if android
		addVirtualPad(FULL, A_B_C_X_Y);
		#end

		FlxTween.tween(scoreBG,{y: 25},0.5,{ease: FlxEase.expoInOut});
		FlxTween.tween(scoreText,{y: 20},0.5,{ease: FlxEase.expoInOut});
		FlxTween.tween(diffText,{y: 55},0.5,{ease: FlxEase.expoInOut});

		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}
	
	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)
		{
			CurrentPack = AllPossibleSongs.length - 1;
		}
		if (CurrentPack == AllPossibleSongs.length)
		{
			CurrentPack = 0;
		}
		CurrentSongIcon.loadGraphic(Paths.image('week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));
	}

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(fart) allowinputShit = true;

		if (!InMainFreeplayState) 
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				UpdatePackSelection(-1);
			}
			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				UpdatePackSelection(1);
			}
			if (controls.ACCEPT && !loadingPack)
			{
				loadingPack = true;
				LoadProperPack();
				FlxTween.tween(CurrentSongIcon, {alpha: 0}, 0.3);
				new FlxTimer().start(0.5, function(Dumbshit:FlxTimer)
				{
					CurrentSongIcon.visible = false;
					GoToActualFreeplay();
					InMainFreeplayState = true;
					loadingPack = false;
				});
			}
			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}
		
			return;
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + Math.floor(lerpRating * 100) + '%)';

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE #if android || _virtualpad.buttonX.justPressed #end;
		var ctrl = FlxG.keys.justPressed.CONTROL #if android || _virtualpad.buttonC.justPressed #end;

		if (upP && allowinputShit)
		{
			changeSelection(-1);
		}
		if (downP && allowinputShit)
		{
			changeSelection(1);
		}

		// LOCKED ON HARD AHAHAHAHAHAHAHAHAHAHA
		// if (controls.UI_LEFT_P && allowinputShit)
			// changeDiff(-1);
		//if (controls.UI_RIGHT_P && allowinputShit)
			// changeDiff(1);

		if (controls.BACK && allowinputShit)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new FreeplayState());
	
			if (accepted && allowinputShit)
			{
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			
				trace(poop);
			
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
			
				PlayState.storyWeek = songs[curSelected].week;
				LoadingState.loadAndSwitchState(new PlayState()); // fuck.
			}
		}
		if(ctrl)
		{
			openSubState(new GameplayChangersSubstate());
			allowinputShit = false;
			fart = false;
		}
	#if PRELOAD_ALL
	if(space && instPlaying != curSelected)
	{
		destroyFreeplayVocals();
		Paths.currentModDirectory = songs[curSelected].folder;
		var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
		PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
		if (PlayState.SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
		vocals.play();
		vocals.persist = true;
		vocals.looped = true;
		vocals.volume = 0.7;
		instPlaying = curSelected;
	}
	else #end if (accepted && allowinputShit)
	{
		var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
		var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
		#if MODS_ALLOWED
		if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
		#else
		if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
		#end
			poop = songLowercase;
			curDifficulty = 1;
			trace('Couldnt find file');
		}
		trace(poop);

		PlayState.SONG = Song.loadFromJson(poop, songLowercase);
		PlayState.isStoryMode = false;
		
		PlayState.storyDifficulty = curDifficulty;

		PlayState.storyWeek = songs[curSelected].week;
		trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
		if (songLowercase == 'intertwined') {
			PlayState.skipSkinSelect = true;
		} else {
			PlayState.skipSkinSelect = false;
		}

		if (PlayState.skipSkinSelect) { // ok but how do we skip it though do we like hold down a key or smth lol -frogb
			LoadingState.loadAndSwitchState(new PlayState());
		} else {
			LoadingState.loadAndSwitchState(new divinity.SkinSelectState());
		}

		FlxG.sound.music.volume = 0;
				
		destroyFreeplayVocals();
	}
	else if(controls.RESET #if android || _virtualpad.buttonY.justPressed #end)
	{
		openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
		FlxG.sound.play(Paths.sound('scrollMenu'));
		allowinputShit = false;
		fart = false;
	}
	super.update(elapsed);
}

public static function destroyFreeplayVocals() {
	if(vocals != null) {
		vocals.stop();
		vocals.destroy();
	}
	vocals = null;
}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 1;
		if (curDifficulty > 2)
			curDifficulty = 1;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end
	
		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;

		if (curSelected >= songs.length)
			curSelected = 0;

		if (songs[curSelected].week != 1 || songs[curSelected].songName == 'Old-Insanity')
		{
			if (curDifficulty < 2)
				curDifficulty = 1;

			if (curDifficulty > 2)
				curDifficulty = 1;
		}
		
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		changeDiff();
		if(!isInMods) {
	     	FlxTween.color(bg, 0.25, bg.color, songColors[songs[curSelected].week]);
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
