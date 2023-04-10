package;

import flixel.FlxG;
import flixel.FlxSprite;
import vlc.MP4Handler;
import flixel.FlxBasic;

import vlc.MP4Sprite;

class Stage extends FlxBasic {
    var curStage:String = 'stage';

    public var video:MP4Sprite;

    public function new(stage:String) {
        super();
        changeStage(stage);
    }

    public function changeStage(daStage:String) {
        curStage = daStage;

        switch(curStage) {
            case 'point':
                var point:BGSprite = new BGSprite('point', -0.5, -0.5, 0.3, 0);
                PlayState.instance.addBehindGF(point);
            case 'wall':
                var wall:BGSprite = new BGSprite('wall', -0.5, -0.5, 0.3, 0);
                PlayState.instance.addBehindGF(wall);
            case 'room':
                var room:BGSprite = new BGSprite('room', 15, -0.5, 0.3, -6);
                PlayState.instance.addBehindGF(room);
        }

        if (Paths.formatToSongPath(PlayState.SONG.song) == 'your-last-flight') {
            PlayState.instance.add(new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xff000000));

            var preload:MP4Handler = new MP4Handler();
            preload.playVideo(Paths.video('yourlastflight'));
            preload.readyCallback = function() {
                preload.stop();
                preload = null;
            }
        }
    }

    public function onSongStart() {
        if (Paths.formatToSongPath(PlayState.SONG.song) == 'your-last-flight') {
            video = new MP4Sprite();
            video.cameras = [PlayState.instance.camHUD];
            PlayState.instance.addBehindNotes(video);
            video.playVideo(Paths.video('yourlastflight'));
        }
    }
}