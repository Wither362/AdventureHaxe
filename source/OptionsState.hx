package;

import display.FPSState;
import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

using StringTools;

class OptionsState extends MainCode
{
    var groupMenu:FlxTypedGroup<FlxText>;

	var menuSelect:Array<String> = [
        "FPS",
        "Back"
    ];
	var curSelected:Int = 0;
    var stopSelected:Bool = false;

    var tween:FlxTween;

    override function create() {
        super.create();
        
        groupMenu = new FlxTypedGroup<FlxText>();
		add(groupMenu);

		for (i in 0...menuSelect.length)
		{
			var select:FlxText = new FlxText(20, 475 + (i * 50), 0, menuSelect[i], 32);
            select.screenCenter(X);
			select.ID = i;
			groupMenu.add(select);
            FlxTween.tween(select, {y: 475 + (i * 50)}, 1 + (i * 0.25), {
                ease: FlxEase.expoInOut,
                onComplete: function(flxTween:FlxTween)
                {
                    tween.cancel;
                    // trace('move done');
                }
            });
		}
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.UP){
            if (stopSelected == true){}
            else {
                FlxG.sound.play(Paths.sound('select.ogg'));
                curSelected -= 1;
            }
        }

        if (FlxG.keys.justPressed.DOWN){
            if (stopSelected == true){}
            else {
                FlxG.sound.play(Paths.sound('select.ogg'));
                curSelected += 1;
            }
        }

        if (curSelected < 0)
			curSelected = menuSelect.length - 1;

		if (curSelected >= menuSelect.length)
			curSelected = 0;

		groupMenu.forEach(function(txt:FlxText)
        {
            txt.color = FlxColor.WHITE;
    
            if (txt.ID == curSelected)
                txt.color = FlxColor.YELLOW;
        });

        if (FlxG.keys.justPressed.ENTER){
            FlxG.camera.flash(FlxColor.WHITE, 1);
            FlxG.sound.play(Paths.sound('enter.ogg'));
            stopSelected = true;
            new FlxTimer().start(2, function(tmr:FlxTimer){
                switch(menuSelect[curSelected]){
                    case "FPS":
                        FlxG.sound.play(Paths.sound('enter.ogg'));
                        FlxG.switchState(new display.FPSState());
                    case "Back":
                        FlxG.sound.play(Paths.sound('enter.ogg'));
                        FlxG.save.flush();
                        // Sys.exit(0);
                        FlxG.switchState(new MenuState());
                }
            });
        }
    }
}