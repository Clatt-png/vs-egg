package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class End extends FlxState {
	var sprite:FlxSprite;
	var sprite2:FlxSprite;
	var sprite3:FlxSprite;
	public static var taps:Int = 0;

	override public function create():Void {
		super.create();

		FlxG.sound.playMusic(Paths.music('eggMenu'));

		sprite2 = new FlxSprite();
        sprite2.loadGraphic(Paths.image("oh-fuck-why"));
        sprite2.setGraphicSize(1280,720);
        sprite2.updateHitbox();
        sprite2.screenCenter();
		add(sprite2);

		sprite3 = new FlxSprite(-1000);
        sprite3.loadGraphic(Paths.image("image0"));
        sprite3.updateHitbox();
		add(sprite3);

		sprite = new FlxSprite();
        sprite.loadGraphic(Paths.image("ssw"));
        sprite.setGraphicSize(1280,720);
        sprite.updateHitbox();
        sprite.screenCenter();
		add(sprite);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

        if(FlxG.keys.justPressed.ANY)
			{
				taps++;
				check();
			}

	}

	function check()
	{ 
		if (taps == 1)
			{
				remove(sprite);
				FlxTween.tween(sprite3, {x: 0}, 0.9, {ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
					}});
			}
		if (taps == 2)
			{
				FlxG.switchState(new StoryMenuState());
				taps = 0;
			}
	}
}
