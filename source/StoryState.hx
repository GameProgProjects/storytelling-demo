package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

/**
 * StoryState — plays a short intro sequence before the main game.
 * Works on all targets (HTML5, Neko, Windows, macOS).
 */
class StoryState extends FlxState
{
    var pages:Array<{ img:String, text:String }>;
    var current:Int = 0;
    var bg:FlxSprite;
    var caption:FlxText;

    override public function create():Void
    {
        super.create();

        // Define your story slides (images + captions)
        pages = [
            { img: AssetPaths.scene1__webp, text: "Year 2089. The world stands on the edge of ruin." },
            { img: AssetPaths.scene2__webp, text: "An unknown enemy has invaded every city." },
            { img: AssetPaths.scene3__webp, text: "You are the last defender. Humanity's hope rests on your aim." }
        ];

        // Display first image
        bg = new FlxSprite().loadGraphic(pages[0].img);
        
        // Scale image proportionally to fit screen while maintaining aspect ratio
        var scaleX = FlxG.width / bg.width;
        var scaleY = FlxG.height / bg.height;
        var scale = Math.min(scaleX, scaleY); // Use smaller scale to fit entirely
        
        bg.scale.set(scale, scale);
        
        // Center the image
        bg.x = (FlxG.width - bg.width) / 2;
        bg.y = (FlxG.height - bg.height) / 2;
        
        add(bg);

        // Caption text area
        caption = new FlxText(0, FlxG.height - 60, FlxG.width, pages[0].text);
        caption.size = 16;
        caption.alignment = "center";
        add(caption);

        // Mouse visible for skipping
        FlxG.mouse.visible = true;

        // Auto-advance after 4 seconds
        new FlxTimer().start(4, function(_) nextPage(), 1);
    }

    function nextPage():Void
    {
        current++;

        // Check if we've gone past the last slide
        if (current >= pages.length)
        {
            // End of story → go to PlayState
            FlxG.switchState(() -> new PlayState());
            return;
        }

        // Show the current slide
        bg.loadGraphic(pages[current].img);
        
        // Scale image proportionally to fit screen while maintaining aspect ratio
        var scaleX = FlxG.width / bg.width;
        var scaleY = FlxG.height / bg.height;
        var scale = Math.min(scaleX, scaleY); // Use smaller scale to fit entirely
        
        bg.scale.set(scale, scale);
        
        // Center the image
        bg.x = (FlxG.width - bg.width) / 2;
        bg.y = (FlxG.height - bg.height) / 2;
        
        caption.text = pages[current].text;

        // Always wait 4 seconds before doing anything
        new FlxTimer().start(4, function(_) nextPage(), 1);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        // Skip manually
        if (FlxG.keys.justPressed.SPACE || FlxG.mouse.justPressed)
        {
            nextPage();
        }
    }
}
