package;

import haxe.Json;
import flixel.FlxG;
import flixel.FlxSprite;

typedef DoodleFile = 
{
    var texture:String;
    var add_x:Float;
    var add_y:Float;
    var scale:Float;
}

class FreeplayDoodle extends FlxSprite
{
    public var name:String;
    public var texture:String;

    public var addX:Float = 0;
    public var addY:Float = 0;

    public function new()
    {
        super();
    }

    public function loadJson()
    {
        var rawJson:String = Paths.getTextFromFile('images/freeplay/$name.json');
        var json:DoodleFile = cast Json.parse(rawJson);
        
        addX = json.add_x;
        addY = json.add_y;

        updateDisplay(json.texture);
        scale.set(json.scale, json.scale);
        updateHitbox();
    }

    public function updateDisplay(newTexture:String)
    {
        loadGraphic(Paths.image('freeplay/$newTexture'));
        updateHitbox();
        texture = newTexture;
        x = (FlxG.width - width + FlxG.width / 5) + addX;
        y = (FlxG.height - (height / 5) * 4) + addY;
    }

    override function update(elapsed:Float)
    {
        x = (FlxG.width - width + FlxG.width / 5) + addX;
        y = (FlxG.height - (height / 5) * 4) + addY;
    }
}