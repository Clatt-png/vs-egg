package;

import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;
	public static var firstegg:Bool = true;

	public static var candoshit:Bool = false;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.4" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	public static var cantap:Bool = false;

	var eggclicks:Int = 0;

	var menuegg:FlxSprite;
	var menutext:FlxSprite;

	var bg:FlxSprite;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		FlxG.mouse.visible = true;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('eggMenu'));
		}

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		if (firstegg)
		bg.scale.set(0.5, 0.5);
		if (firstegg)
		bg.alpha = 0;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			if (firstegg)
			menuItem.scale.set(0.5, 0.5);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			if (firstegg)
			menuItem.alpha = 0;
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						
					}});
			else
				menuItem.y = 60 + (i * 160);
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0 * (0 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		finishedFunnyMove = true; 

		changeItem();

		if (firstegg)
			{
				menuegg = new FlxSprite();
				menuegg.frames = Paths.getSparrowAtlas('EggTitleAnim');
				menuegg.animation.addByPrefix('tap1', "EggTap0 instance 1", 24);
				menuegg.animation.addByPrefix('tap2', "EggTap1 instance 1", 24);
				menuegg.animation.addByPrefix('tap3', "EggTap2 instance 1", 24);
				menuegg.animation.addByPrefix('tap4', "EggTap3 instance 1", 24);
				menuegg.animation.addByPrefix('open', "EggCrackOpen instance 1", 24);
				add(menuegg);
				menuegg.animation.play('tap1');
				menuegg.screenCenter();
				menuegg.x += 220;
				menuegg.y += 240;
				menuegg.scrollFactor.set();
				menuegg.antialiasing = true;
				menuegg.alpha = 0;
		
				menutext = new FlxSprite(100, FlxG.height * 0.8);
				menutext.frames = Paths.getSparrowAtlas('TapText');
				menutext.animation.addByPrefix('text', "Text instance 1", 24);
				add(menutext);
				menutext.animation.play('text');
				menutext.alpha = 0;
		
				FlxG.camera.zoom = 0.5;
		
				FlxTween.tween(FlxG.camera, {zoom: 1}, 4, {ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						
					}});
		
				FlxTween.tween(menuegg, {alpha: 1}, 3, {ease: FlxEase.expoInOut});
				FlxTween.tween(menutext, {alpha: 1}, 4, {ease: FlxEase.expoInOut});
				
				new FlxTimer().start(2.5, function(tmr:FlxTimer)
					{
						cantap = true;
					});
			}



		super.create();
	}

	var selectedSomethin:Bool = false;


	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.mouse.justPressed && cantap && firstegg)
			{
				eggclicks++;
				trace('aa');
				checkegg();
				FlxG.camera.shake(0.01, 0.2);
			}


		if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

		if (candoshit)
			firstegg = false;
			

		if (!selectedSomethin && candoshit)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}



			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					fancyOpenURL("https://ninja-muffin24.itch.io/funkin");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

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
							if (FlxG.save.data.flashing)
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

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function checkegg() {
		if (eggclicks == 3)
			{
				menuegg.animation.play('tap2');
			}

		if (eggclicks == 6)
			{
				menuegg.animation.play('tap4');
				new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						if (menuegg.animation.curAnim.name.startsWith('tap4'))
							{
								menuegg.animation.finish();
							}
					});
			}
			
		if (eggclicks == 9)
			{
			  menuegg.x -= 190;
		      menuegg.animation.play('open');
			  new FlxTimer().start(1.3, function(tmr:FlxTimer)
				{
					FlxTween.tween(bg, {alpha: 1}, 1, {ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
						{ 
							candoshit = true;
						}});
					FlxTween.tween(bg,{"scale.x": 1,"scale.y": 1},1.2,{ease: FlxEase.expoInOut});

					menuegg.animation.finish();
					FlxTween.tween(menuegg, {y: 1000}, 2, {ease: FlxEase.expoInOut});
					FlxTween.tween(menutext, {x: 2000}, 1, {ease: FlxEase.expoInOut});
					cantap = false;
					FlxG.mouse.visible = false;
					menuItems.forEach(function(spr:FlxSprite)
						{
							FlxTween.tween(spr,{"scale.x": 1,"scale.y": 1},1.5,{ease: FlxEase.expoInOut});
							FlxTween.tween(spr, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
						});
						
				});
			}


	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
