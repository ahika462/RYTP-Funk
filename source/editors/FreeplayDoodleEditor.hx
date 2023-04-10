package editors;

import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;

import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUIInputText;
import flixel.FlxG;
import flixel.addons.ui.FlxUITabMenu;
import flixel.FlxSprite;

class FreeplayDoodleEditor extends MusicBeatState
{
    var doodle:FreeplayDoodle;
    public static var doodleName:String = 'pocyk';

    var textureInputText:FlxUIInputText;
    var scaleStepper:FlxUINumericStepper;
    var nameInputText:FlxUIInputText;

    var file:FileReference;
    
    override function create()
    {
        FlxG.mouse.visible = true;

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
        add(bg);

        var songText:Alphabet = new Alphabet(0, 30, "Da Song", true);
        songText.x = 50;
        songText.y = Std.int(FlxG.height / 2 - songText.height / 2);
		add(songText);

        doodle = new FreeplayDoodle();
        doodle.name = doodleName;
        doodle.loadJson();
        add(doodle);

        var UI_box:FlxUITabMenu = new FlxUITabMenu([{name: "Doodle", label: "Doodle"}]);
        UI_box.resize(FlxG.width / 3, FlxG.height / 4);
        UI_box.x = FlxG.width / 3 * 2;
        UI_box.y = FlxG.height / 4 * 3;
        add(UI_box);

        textureInputText = new FlxUIInputText(UI_box.x + 15, UI_box.y + 45, 200, doodle.texture, 8);
        add(textureInputText);

        scaleStepper = new FlxUINumericStepper(textureInputText.x, textureInputText.y + 40, 0.1, doodle.scale.x, 0.05, 10, 1);
        add(scaleStepper);

        nameInputText = new FlxUIInputText(textureInputText.x, scaleStepper.y + 40, 200, doodle.name, 8);
        add(nameInputText);

        var reloadButton:FlxButton = new FlxButton(nameInputText.x + nameInputText.width + 15, nameInputText.y, "Reload Doodle", function()
        {
            doodleName = nameInputText.text;
            MusicBeatState.resetState();
        });
        add(reloadButton);

        var saveButton:FlxButton = new FlxButton(reloadButton.x + reloadButton.width + 15, reloadButton.y, "Save", function() {
            file = new FileReference();
			file.addEventListener(Event.COMPLETE, onSaveComplete);
			file.addEventListener(Event.CANCEL, onSaveCancel);
			file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);

            var rawJson:String = '{
    "texture": "${doodle.texture}",
    "add_x": ${doodle.addX},
    "add_y": ${doodle.addY},
    "scale": ${doodle.scale.x}
}';

			file.save(rawJson, nameInputText.text + ".json");
        });
        add(saveButton);

        add(new FlxText(textureInputText.x, textureInputText.y - 18, 0, 'Texture:'));
        add(new FlxText(scaleStepper.x, scaleStepper.y - 18, 0, 'Scale:'));
        add(new FlxText(nameInputText.x, nameInputText.y - 18, 0, 'Json:'));
    }

    override function update(elapsed:Float)
    {
        if (Paths.fileExists('images/freeplay/${textureInputText.text}.png', IMAGE))
            doodle.updateDisplay(textureInputText.text);

        doodle.scale.set(scaleStepper.value, scaleStepper.value);
        doodle.updateHitbox();

        var step:Float = 1;
        if (FlxG.keys.pressed.SHIFT) step = 10;
        else step = 1;

        if (!textureInputText.hasFocus && !nameInputText.hasFocus)
        {
            if (FlxG.keys.justPressed.UP)
                doodle.addY -= step;
            if (FlxG.keys.justPressed.DOWN)
                doodle.addY += step;
            if (FlxG.keys.justPressed.LEFT)
                doodle.addX -= step;
            if (FlxG.keys.justPressed.RIGHT)
                doodle.addX += step;
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            MusicBeatState.switchState(new MasterEditorMenu());
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
        }

        super.update(elapsed);
    }

    function onSaveComplete(_):Void
	{
		file.removeEventListener(Event.COMPLETE, onSaveComplete);
		file.removeEventListener(Event.CANCEL, onSaveCancel);
		file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		file = null;
		FlxG.log.notice("Successfully saved file.");
	}

	function onSaveCancel(_):Void
	{
		file.removeEventListener(Event.COMPLETE, onSaveComplete);
		file.removeEventListener(Event.CANCEL, onSaveCancel);
		file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		file = null;
	}

	function onSaveError(_):Void
	{
		file.removeEventListener(Event.COMPLETE, onSaveComplete);
		file.removeEventListener(Event.CANCEL, onSaveCancel);
		file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		file = null;
		FlxG.log.error("Problem saving file");
	}
}
