package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';


	var skip:Array<String> = [];
	var background:FlxSprite;
	var curBg:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;
	var curSound:FlxSound;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var sound:FlxSound;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		skip = ['startvoice', 'stopvoice','bg'];

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				sound = new FlxSound().loadEmbedded(Paths.music('Lunchbox'),true);
				sound.volume = 0;
				FlxG.sound.list.add(sound);
				sound.fadeIn(1, 0, 0.8);
			case 'thorns':
				sound = new FlxSound().loadEmbedded(Paths.music('LunchboxScary'),true);
				sound.volume = 0;
				FlxG.sound.list.add(sound);
				sound.fadeIn(1, 0, 0.8);
		}

		background = new FlxSprite(0,0);
		background.visible = true;
		add(background);

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				hasDialog = true;
				box = new FlxSprite().loadGraphic(Paths.image('box'));
				box.updateHitbox();
				box.antialiasing = FlxG.save.data.antialiasing;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(20, 80);
		portraitLeft.frames = Paths.getSparrowAtlas('dialoguestuff/egg');
		portraitLeft.animation.addByPrefix('egg egg', 'egg egg', 24, false);
		portraitLeft.animation.addByPrefix('1egg egg2', '1egg egg2', 24, false);
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(900, 200);
		portraitRight.frames = Paths.getSparrowAtlas('dialoguestuff/bfandgf');
		portraitRight.animation.addByPrefix('1bfandgf bfhappy', '1bfandgf bfhappy', 24, false);
		portraitRight.animation.addByPrefix('1bfandgf bfshock', '2bfandgf bfshock', 24, false);
		portraitRight.animation.addByPrefix('1bfandgf bfworried', '3bfandgf bfworried', 24, false);
		portraitRight.animation.addByPrefix('1bfandgf gfnormal', '4bfandgf gfnormal', 24, false);
		portraitRight.animation.addByPrefix('1bfandgf gfshock', '5bfandgf gfshock', 24, false);
		portraitRight.animation.addByPrefix('1bfandgf gfworried', '6bfandgf gfworried', 24, false);
		portraitRight.animation.addByPrefix('1bfandgf bfnormal', '7bfandgf bfnormal', 24, false);
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		box.y += 450;

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(227, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFF3F2021;
		add(dropText);

		swagDialogue = new FlxTypeText(225, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFFD89494;
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		dialogueOpened = true;

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (curCharacter == 'bg' && dialogueStarted == true)
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}

			skip = ['startvoice', 'stopvoice','bg'];

		if (PlayerSettings.player1.controls.ACCEPT || (dialogueList.length > 0 && skip.contains(curCharacter))  && dialogueStarted == true)
		{
			remove(dialogue);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						sound.fadeOut(2.2, 0);
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{

			case 'startvoice':
				if (Paths.exists(Paths.sound(dialogueList[0])))
				{
					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(dialogueList[0]));
					//curSound.volume = FlxG.sound.volume;
					curSound.play();
				}
			case 'stopvoice':
				if (curSound != null && curSound.playing)
				{
					curSound.stop();
				}
			case 'egg':
				portraitRight.visible = false;
					portraitLeft.visible = true;
					portraitLeft.animation.play('egg egg');
				
			case 'egg2':
				portraitRight.visible = false;
					portraitLeft.visible = true;
					portraitLeft.animation.play('1egg egg2');
				
			case 'bfhappy':
				portraitLeft.visible = false;
					portraitRight.visible = true;
					portraitRight.animation.play('1bfandgf bfhappy');
				
			case 'bfshock':
				portraitLeft.visible = false;
					portraitRight.visible = true;
					portraitRight.animation.play('1bfandgf bfshock');
				
				
			case 'bfnormal':
				portraitLeft.visible = false;
					portraitRight.visible = true;
					portraitRight.animation.play('1bfandgf bfnormal');
				
			case 'bfworried':
				portraitLeft.visible = false;
					portraitRight.visible = true;
					portraitRight.animation.play('1bfandgf bfworried');
				
			case 'gfshock':
				portraitLeft.visible = false;
					portraitRight.visible = true;
					portraitRight.animation.play('1bfandgf gfshock');
				
			case 'gfnormal':
				portraitLeft.visible = false;
					portraitRight.visible = true;
					portraitRight.animation.play('1bfandgf gfnormal');
				
			case 'gfworried':
				portraitLeft.visible = false;
					portraitRight.visible = true;
					portraitRight.animation.play('1bfandgf gfworried');
				
			case 'bg':			
				remove(background);
				background.loadGraphic(Paths.image('cutscene/$curBg'));
				add(background);
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();

		curBg = dialogueList[0];
	}
}
