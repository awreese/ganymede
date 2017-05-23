package;


import haxe.Timer;
import haxe.Unserializer;
import lime.app.Future;
import lime.app.Preloader;
import lime.app.Promise;
import lime.audio.AudioSource;
import lime.audio.openal.AL;
import lime.audio.AudioBuffer;
import lime.graphics.Image;
import lime.net.HTTPRequest;
import lime.system.CFFI;
import lime.text.Font;
import lime.utils.Bytes;
import lime.utils.UInt8Array;
import lime.Assets;

#if sys
import sys.FileSystem;
#end

#if flash
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLRequest;
#end


class DefaultAssetLibrary extends AssetLibrary {
	
	
	public var className (default, null) = new Map <String, Dynamic> ();
	public var path (default, null) = new Map <String, String> ();
	public var type (default, null) = new Map <String, AssetType> ();
	
	private var lastModified:Float;
	private var timer:Timer;
	
	
	public function new () {
		
		super ();
		
		#if (openfl && !flash)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		
		
		#end
		
		#if flash
		
		className.set ("assets/sounds/applause.ogg", __ASSET__assets_sounds_applause_ogg);
		type.set ("assets/sounds/applause.ogg", AssetType.SOUND);
		className.set ("assets/sounds/applause.wav", __ASSET__assets_sounds_applause_wav);
		type.set ("assets/sounds/applause.wav", AssetType.SOUND);
		className.set ("assets/sounds/laser.ogg", __ASSET__assets_sounds_laser_ogg);
		type.set ("assets/sounds/laser.ogg", AssetType.SOUND);
		className.set ("assets/sounds/laser.wav", __ASSET__assets_sounds_laser_wav);
		type.set ("assets/sounds/laser.wav", AssetType.SOUND);
		className.set ("assets/data/level1.json", __ASSET__assets_data_level1_json);
		type.set ("assets/data/level1.json", AssetType.TEXT);
		className.set ("assets/data/level2.json", __ASSET__assets_data_level2_json);
		type.set ("assets/data/level2.json", AssetType.TEXT);
		className.set ("assets/data/level2_harder.json", __ASSET__assets_data_level2_harder_json);
		type.set ("assets/data/level2_harder.json", AssetType.TEXT);
		className.set ("assets/data/level3.json", __ASSET__assets_data_level3_json);
		type.set ("assets/data/level3.json", AssetType.TEXT);
		className.set ("assets/data/level4.json", __ASSET__assets_data_level4_json);
		type.set ("assets/data/level4.json", AssetType.TEXT);
		className.set ("assets/data/level5.json", __ASSET__assets_data_level5_json);
		type.set ("assets/data/level5.json", AssetType.TEXT);
		className.set ("assets/data/level6.json", __ASSET__assets_data_level6_json);
		type.set ("assets/data/level6.json", AssetType.TEXT);
		className.set ("assets/data/level7.json", __ASSET__assets_data_level7_json);
		type.set ("assets/data/level7.json", AssetType.TEXT);
		className.set ("assets/data/level8.json", __ASSET__assets_data_level8_json);
		type.set ("assets/data/level8.json", AssetType.TEXT);
		className.set ("assets/images/background.png", __ASSET__assets_images_background_png);
		type.set ("assets/images/background.png", AssetType.IMAGE);
		className.set ("assets/images/backgrounds/move background images here", __ASSET__assets_images_backgrounds_move_background_images_here);
		type.set ("assets/images/backgrounds/move background images here", AssetType.TEXT);
		className.set ("assets/images/capturing_faction_tutorial.png", __ASSET__assets_images_capturing_faction_tutorial_png);
		type.set ("assets/images/capturing_faction_tutorial.png", AssetType.IMAGE);
		className.set ("assets/images/capturing_faction_tutorial.psd", __ASSET__assets_images_capturing_faction_tutorial_psd);
		type.set ("assets/images/capturing_faction_tutorial.psd", AssetType.BINARY);
		className.set ("assets/images/combat_tutorial.png", __ASSET__assets_images_combat_tutorial_png);
		type.set ("assets/images/combat_tutorial.png", AssetType.IMAGE);
		className.set ("assets/images/cursor.png", __ASSET__assets_images_cursor_png);
		type.set ("assets/images/cursor.png", AssetType.IMAGE);
		className.set ("assets/images/feedback_btn.png", __ASSET__assets_images_feedback_btn_png);
		type.set ("assets/images/feedback_btn.png", AssetType.IMAGE);
		className.set ("assets/images/finishgamebg.png", __ASSET__assets_images_finishgamebg_png);
		type.set ("assets/images/finishgamebg.png", AssetType.IMAGE);
		className.set ("assets/images/gameover.png", __ASSET__assets_images_gameover_png);
		type.set ("assets/images/gameover.png", AssetType.IMAGE);
		className.set ("assets/images/images-go-here.txt", __ASSET__assets_images_images_go_here_txt);
		type.set ("assets/images/images-go-here.txt", AssetType.TEXT);
		className.set ("assets/images/mapbg.png", __ASSET__assets_images_mapbg_png);
		type.set ("assets/images/mapbg.png", AssetType.IMAGE);
		className.set ("assets/images/menubg.png", __ASSET__assets_images_menubg_png);
		type.set ("assets/images/menubg.png", AssetType.IMAGE);
		className.set ("assets/images/MenuBG.psd", __ASSET__assets_images_menubg_psd);
		type.set ("assets/images/MenuBG.psd", AssetType.BINARY);
		className.set ("assets/images/mouse.png", __ASSET__assets_images_mouse_png);
		type.set ("assets/images/mouse.png", AssetType.IMAGE);
		className.set ("assets/images/mouse_left.png", __ASSET__assets_images_mouse_left_png);
		type.set ("assets/images/mouse_left.png", AssetType.IMAGE);
		className.set ("assets/images/mouse_right.png", __ASSET__assets_images_mouse_right_png);
		type.set ("assets/images/mouse_right.png", AssetType.IMAGE);
		className.set ("assets/images/moving_ship_tutorial.psd", __ASSET__assets_images_moving_ship_tutorial_psd);
		type.set ("assets/images/moving_ship_tutorial.psd", AssetType.BINARY);
		className.set ("assets/images/moving_ship_tutorial_1.png", __ASSET__assets_images_moving_ship_tutorial_1_png);
		type.set ("assets/images/moving_ship_tutorial_1.png", AssetType.IMAGE);
		className.set ("assets/images/moving_ship_tutorial_2.png", __ASSET__assets_images_moving_ship_tutorial_2_png);
		type.set ("assets/images/moving_ship_tutorial_2.png", AssetType.IMAGE);
		className.set ("assets/images/nextlevelbg.png", __ASSET__assets_images_nextlevelbg_png);
		type.set ("assets/images/nextlevelbg.png", AssetType.IMAGE);
		className.set ("assets/images/planet.psd", __ASSET__assets_images_planet_psd);
		type.set ("assets/images/planet.psd", AssetType.BINARY);
		className.set ("assets/images/planets/planet_1_enemy1.png", __ASSET__assets_images_planets_planet_1_enemy1_png);
		type.set ("assets/images/planets/planet_1_enemy1.png", AssetType.IMAGE);
		className.set ("assets/images/planets/planet_1_neutral.png", __ASSET__assets_images_planets_planet_1_neutral_png);
		type.set ("assets/images/planets/planet_1_neutral.png", AssetType.IMAGE);
		className.set ("assets/images/planets/planet_1_none.png", __ASSET__assets_images_planets_planet_1_none_png);
		type.set ("assets/images/planets/planet_1_none.png", AssetType.IMAGE);
		className.set ("assets/images/planets/planet_1_player.png", __ASSET__assets_images_planets_planet_1_player_png);
		type.set ("assets/images/planets/planet_1_player.png", AssetType.IMAGE);
		className.set ("assets/images/play_btn.png", __ASSET__assets_images_play_btn_png);
		type.set ("assets/images/play_btn.png", AssetType.IMAGE);
		className.set ("assets/images/replay_btn.png", __ASSET__assets_images_replay_btn_png);
		type.set ("assets/images/replay_btn.png", AssetType.IMAGE);
		className.set ("assets/images/restart_btn.png", __ASSET__assets_images_restart_btn_png);
		type.set ("assets/images/restart_btn.png", AssetType.IMAGE);
		className.set ("assets/images/select_ship_tutorial.png", __ASSET__assets_images_select_ship_tutorial_png);
		type.set ("assets/images/select_ship_tutorial.png", AssetType.IMAGE);
		className.set ("assets/images/select_ship_tutorial.psd", __ASSET__assets_images_select_ship_tutorial_psd);
		type.set ("assets/images/select_ship_tutorial.psd", AssetType.BINARY);
		className.set ("assets/images/select_ship_tutorial_1.png", __ASSET__assets_images_select_ship_tutorial_1_png);
		type.set ("assets/images/select_ship_tutorial_1.png", AssetType.IMAGE);
		className.set ("assets/images/select_ship_tutorial_2.png", __ASSET__assets_images_select_ship_tutorial_2_png);
		type.set ("assets/images/select_ship_tutorial_2.png", AssetType.IMAGE);
		className.set ("assets/images/ship.psd", __ASSET__assets_images_ship_psd);
		type.set ("assets/images/ship.psd", AssetType.BINARY);
		className.set ("assets/images/ships/ship_1_enemy1.png", __ASSET__assets_images_ships_ship_1_enemy1_png);
		type.set ("assets/images/ships/ship_1_enemy1.png", AssetType.IMAGE);
		className.set ("assets/images/ships/ship_1_neutral.png", __ASSET__assets_images_ships_ship_1_neutral_png);
		type.set ("assets/images/ships/ship_1_neutral.png", AssetType.IMAGE);
		className.set ("assets/images/ships/ship_1_player.png", __ASSET__assets_images_ships_ship_1_player_png);
		type.set ("assets/images/ships/ship_1_player.png", AssetType.IMAGE);
		className.set ("assets/images/ships/ship_1_player_selected.png", __ASSET__assets_images_ships_ship_1_player_selected_png);
		type.set ("assets/images/ships/ship_1_player_selected.png", AssetType.IMAGE);
		className.set ("assets/images/ships/ship_2_enemy1.png", __ASSET__assets_images_ships_ship_2_enemy1_png);
		type.set ("assets/images/ships/ship_2_enemy1.png", AssetType.IMAGE);
		className.set ("assets/images/ships/ship_2_neutral.png", __ASSET__assets_images_ships_ship_2_neutral_png);
		type.set ("assets/images/ships/ship_2_neutral.png", AssetType.IMAGE);
		className.set ("assets/images/ships/ship_2_player.png", __ASSET__assets_images_ships_ship_2_player_png);
		type.set ("assets/images/ships/ship_2_player.png", AssetType.IMAGE);
		className.set ("assets/images/ships/ship_2_player_selected.png", __ASSET__assets_images_ships_ship_2_player_selected_png);
		type.set ("assets/images/ships/ship_2_player_selected.png", AssetType.IMAGE);
		className.set ("assets/images/ships/ship_3_enemy1.png", __ASSET__assets_images_ships_ship_3_enemy1_png);
		type.set ("assets/images/ships/ship_3_enemy1.png", AssetType.IMAGE);
		className.set ("assets/images/ships/ship_3_neutral.png", __ASSET__assets_images_ships_ship_3_neutral_png);
		type.set ("assets/images/ships/ship_3_neutral.png", AssetType.IMAGE);
		className.set ("assets/images/ships/ship_3_player.png", __ASSET__assets_images_ships_ship_3_player_png);
		type.set ("assets/images/ships/ship_3_player.png", AssetType.IMAGE);
		className.set ("assets/images/ships/ship_3_player_selected.png", __ASSET__assets_images_ships_ship_3_player_selected_png);
		type.set ("assets/images/ships/ship_3_player_selected.png", AssetType.IMAGE);
		className.set ("assets/images/temp_laser.png", __ASSET__assets_images_temp_laser_png);
		type.set ("assets/images/temp_laser.png", AssetType.IMAGE);
		className.set ("assets/images/thumbnail.png", __ASSET__assets_images_thumbnail_png);
		type.set ("assets/images/thumbnail.png", AssetType.IMAGE);
		className.set ("assets/images/tutorials/move tutorial images and files here", __ASSET__assets_images_tutorials_move_tutorial_images_and_files_here);
		type.set ("assets/images/tutorials/move tutorial images and files here", AssetType.TEXT);
		className.set ("assets/images/whitebg.png", __ASSET__assets_images_whitebg_png);
		type.set ("assets/images/whitebg.png", AssetType.IMAGE);
		className.set ("assets/music/menu.mp3", __ASSET__assets_music_menu_mp3);
		type.set ("assets/music/menu.mp3", AssetType.MUSIC);
		className.set ("assets/music/menu.ogg", __ASSET__assets_music_menu_ogg);
		type.set ("assets/music/menu.ogg", AssetType.SOUND);
		className.set ("assets/music/menu.wav", __ASSET__assets_music_menu_wav);
		type.set ("assets/music/menu.wav", AssetType.SOUND);
		className.set ("assets/music/music-goes-here.txt", __ASSET__assets_music_music_goes_here_txt);
		type.set ("assets/music/music-goes-here.txt", AssetType.TEXT);
		className.set ("assets/sounds/applause.mp3", __ASSET__assets_sounds_applause_mp3);
		type.set ("assets/sounds/applause.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/applause.ogg", __ASSET__assets_sounds_applause_ogg1);
		type.set ("assets/sounds/applause.ogg", AssetType.SOUND);
		className.set ("assets/sounds/applause.wav", __ASSET__assets_sounds_applause_wav1);
		type.set ("assets/sounds/applause.wav", AssetType.SOUND);
		className.set ("assets/sounds/laser.mp3", __ASSET__assets_sounds_laser_mp3);
		type.set ("assets/sounds/laser.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/laser.ogg", __ASSET__assets_sounds_laser_ogg1);
		type.set ("assets/sounds/laser.ogg", AssetType.SOUND);
		className.set ("assets/sounds/laser.wav", __ASSET__assets_sounds_laser_wav1);
		type.set ("assets/sounds/laser.wav", AssetType.SOUND);
		className.set ("assets/sounds/sounds-go-here.txt", __ASSET__assets_sounds_sounds_go_here_txt);
		type.set ("assets/sounds/sounds-go-here.txt", AssetType.TEXT);
		className.set ("flixel/sounds/beep.ogg", __ASSET__flixel_sounds_beep_ogg);
		type.set ("flixel/sounds/beep.ogg", AssetType.SOUND);
		className.set ("flixel/sounds/flixel.ogg", __ASSET__flixel_sounds_flixel_ogg);
		type.set ("flixel/sounds/flixel.ogg", AssetType.SOUND);
		className.set ("flixel/fonts/nokiafc22.ttf", __ASSET__flixel_fonts_nokiafc22_ttf);
		type.set ("flixel/fonts/nokiafc22.ttf", AssetType.FONT);
		className.set ("flixel/fonts/monsterrat.ttf", __ASSET__flixel_fonts_monsterrat_ttf);
		type.set ("flixel/fonts/monsterrat.ttf", AssetType.FONT);
		className.set ("flixel/images/ui/button.png", __ASSET__flixel_images_ui_button_png);
		type.set ("flixel/images/ui/button.png", AssetType.IMAGE);
		className.set ("flixel/images/logo/default.png", __ASSET__flixel_images_logo_default_png);
		type.set ("flixel/images/logo/default.png", AssetType.IMAGE);
		
		
		#elseif html5
		
		var id;
		id = "assets/sounds/applause.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/applause.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/laser.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/laser.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/data/level1.json";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/data/level2.json";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/data/level2_harder.json";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/data/level3.json";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/data/level4.json";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/data/level5.json";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/data/level6.json";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/data/level7.json";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/data/level8.json";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/images/background.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/backgrounds/move background images here";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/images/capturing_faction_tutorial.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/capturing_faction_tutorial.psd";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "assets/images/combat_tutorial.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/cursor.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/feedback_btn.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/finishgamebg.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/gameover.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/images-go-here.txt";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/images/mapbg.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menubg.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/MenuBG.psd";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "assets/images/mouse.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/mouse_left.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/mouse_right.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/moving_ship_tutorial.psd";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "assets/images/moving_ship_tutorial_1.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/moving_ship_tutorial_2.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/nextlevelbg.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/planet.psd";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "assets/images/planets/planet_1_enemy1.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/planets/planet_1_neutral.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/planets/planet_1_none.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/planets/planet_1_player.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/play_btn.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/replay_btn.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/restart_btn.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/select_ship_tutorial.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/select_ship_tutorial.psd";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "assets/images/select_ship_tutorial_1.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/select_ship_tutorial_2.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ship.psd";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "assets/images/ships/ship_1_enemy1.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ships/ship_1_neutral.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ships/ship_1_player.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ships/ship_1_player_selected.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ships/ship_2_enemy1.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ships/ship_2_neutral.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ships/ship_2_player.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ships/ship_2_player_selected.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ships/ship_3_enemy1.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ships/ship_3_neutral.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ships/ship_3_player.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ships/ship_3_player_selected.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/temp_laser.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/thumbnail.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/tutorials/move tutorial images and files here";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/images/whitebg.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/music/menu.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/music/menu.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/music/menu.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/music/music-goes-here.txt";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/sounds/applause.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/applause.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/applause.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/laser.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/laser.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/laser.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/sounds-go-here.txt";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "flixel/sounds/beep.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "flixel/sounds/flixel.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "flixel/fonts/nokiafc22.ttf";
		className.set (id, __ASSET__flixel_fonts_nokiafc22_ttf);
		
		type.set (id, AssetType.FONT);
		id = "flixel/fonts/monsterrat.ttf";
		className.set (id, __ASSET__flixel_fonts_monsterrat_ttf);
		
		type.set (id, AssetType.FONT);
		id = "flixel/images/ui/button.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "flixel/images/logo/default.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		
		
		var assetsPrefix = null;
		if (ApplicationMain.config != null && Reflect.hasField (ApplicationMain.config, "assetsPrefix")) {
			assetsPrefix = ApplicationMain.config.assetsPrefix;
		}
		if (assetsPrefix != null) {
			for (k in path.keys()) {
				path.set(k, assetsPrefix + path[k]);
			}
		}
		
		#else
		
		#if (windows || mac || linux)
		
		var useManifest = false;
		
		className.set ("assets/sounds/applause.ogg", __ASSET__assets_sounds_applause_ogg);
		type.set ("assets/sounds/applause.ogg", AssetType.SOUND);
		
		className.set ("assets/sounds/applause.wav", __ASSET__assets_sounds_applause_wav);
		type.set ("assets/sounds/applause.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/laser.ogg", __ASSET__assets_sounds_laser_ogg);
		type.set ("assets/sounds/laser.ogg", AssetType.SOUND);
		
		className.set ("assets/sounds/laser.wav", __ASSET__assets_sounds_laser_wav);
		type.set ("assets/sounds/laser.wav", AssetType.SOUND);
		
		className.set ("assets/data/level1.json", __ASSET__assets_data_level1_json);
		type.set ("assets/data/level1.json", AssetType.TEXT);
		
		className.set ("assets/data/level2.json", __ASSET__assets_data_level2_json);
		type.set ("assets/data/level2.json", AssetType.TEXT);
		
		className.set ("assets/data/level2_harder.json", __ASSET__assets_data_level2_harder_json);
		type.set ("assets/data/level2_harder.json", AssetType.TEXT);
		
		className.set ("assets/data/level3.json", __ASSET__assets_data_level3_json);
		type.set ("assets/data/level3.json", AssetType.TEXT);
		
		className.set ("assets/data/level4.json", __ASSET__assets_data_level4_json);
		type.set ("assets/data/level4.json", AssetType.TEXT);
		
		className.set ("assets/data/level5.json", __ASSET__assets_data_level5_json);
		type.set ("assets/data/level5.json", AssetType.TEXT);
		
		className.set ("assets/data/level6.json", __ASSET__assets_data_level6_json);
		type.set ("assets/data/level6.json", AssetType.TEXT);
		
		className.set ("assets/data/level7.json", __ASSET__assets_data_level7_json);
		type.set ("assets/data/level7.json", AssetType.TEXT);
		
		className.set ("assets/data/level8.json", __ASSET__assets_data_level8_json);
		type.set ("assets/data/level8.json", AssetType.TEXT);
		
		className.set ("assets/images/background.png", __ASSET__assets_images_background_png);
		type.set ("assets/images/background.png", AssetType.IMAGE);
		
		className.set ("assets/images/backgrounds/move background images here", __ASSET__assets_images_backgrounds_move_background_images_here);
		type.set ("assets/images/backgrounds/move background images here", AssetType.TEXT);
		
		className.set ("assets/images/capturing_faction_tutorial.png", __ASSET__assets_images_capturing_faction_tutorial_png);
		type.set ("assets/images/capturing_faction_tutorial.png", AssetType.IMAGE);
		
		className.set ("assets/images/capturing_faction_tutorial.psd", __ASSET__assets_images_capturing_faction_tutorial_psd);
		type.set ("assets/images/capturing_faction_tutorial.psd", AssetType.BINARY);
		
		className.set ("assets/images/combat_tutorial.png", __ASSET__assets_images_combat_tutorial_png);
		type.set ("assets/images/combat_tutorial.png", AssetType.IMAGE);
		
		className.set ("assets/images/cursor.png", __ASSET__assets_images_cursor_png);
		type.set ("assets/images/cursor.png", AssetType.IMAGE);
		
		className.set ("assets/images/feedback_btn.png", __ASSET__assets_images_feedback_btn_png);
		type.set ("assets/images/feedback_btn.png", AssetType.IMAGE);
		
		className.set ("assets/images/finishgamebg.png", __ASSET__assets_images_finishgamebg_png);
		type.set ("assets/images/finishgamebg.png", AssetType.IMAGE);
		
		className.set ("assets/images/gameover.png", __ASSET__assets_images_gameover_png);
		type.set ("assets/images/gameover.png", AssetType.IMAGE);
		
		className.set ("assets/images/images-go-here.txt", __ASSET__assets_images_images_go_here_txt);
		type.set ("assets/images/images-go-here.txt", AssetType.TEXT);
		
		className.set ("assets/images/mapbg.png", __ASSET__assets_images_mapbg_png);
		type.set ("assets/images/mapbg.png", AssetType.IMAGE);
		
		className.set ("assets/images/menubg.png", __ASSET__assets_images_menubg_png);
		type.set ("assets/images/menubg.png", AssetType.IMAGE);
		
		className.set ("assets/images/MenuBG.psd", __ASSET__assets_images_menubg_psd);
		type.set ("assets/images/MenuBG.psd", AssetType.BINARY);
		
		className.set ("assets/images/mouse.png", __ASSET__assets_images_mouse_png);
		type.set ("assets/images/mouse.png", AssetType.IMAGE);
		
		className.set ("assets/images/mouse_left.png", __ASSET__assets_images_mouse_left_png);
		type.set ("assets/images/mouse_left.png", AssetType.IMAGE);
		
		className.set ("assets/images/mouse_right.png", __ASSET__assets_images_mouse_right_png);
		type.set ("assets/images/mouse_right.png", AssetType.IMAGE);
		
		className.set ("assets/images/moving_ship_tutorial.psd", __ASSET__assets_images_moving_ship_tutorial_psd);
		type.set ("assets/images/moving_ship_tutorial.psd", AssetType.BINARY);
		
		className.set ("assets/images/moving_ship_tutorial_1.png", __ASSET__assets_images_moving_ship_tutorial_1_png);
		type.set ("assets/images/moving_ship_tutorial_1.png", AssetType.IMAGE);
		
		className.set ("assets/images/moving_ship_tutorial_2.png", __ASSET__assets_images_moving_ship_tutorial_2_png);
		type.set ("assets/images/moving_ship_tutorial_2.png", AssetType.IMAGE);
		
		className.set ("assets/images/nextlevelbg.png", __ASSET__assets_images_nextlevelbg_png);
		type.set ("assets/images/nextlevelbg.png", AssetType.IMAGE);
		
		className.set ("assets/images/planet.psd", __ASSET__assets_images_planet_psd);
		type.set ("assets/images/planet.psd", AssetType.BINARY);
		
		className.set ("assets/images/planets/planet_1_enemy1.png", __ASSET__assets_images_planets_planet_1_enemy1_png);
		type.set ("assets/images/planets/planet_1_enemy1.png", AssetType.IMAGE);
		
		className.set ("assets/images/planets/planet_1_neutral.png", __ASSET__assets_images_planets_planet_1_neutral_png);
		type.set ("assets/images/planets/planet_1_neutral.png", AssetType.IMAGE);
		
		className.set ("assets/images/planets/planet_1_none.png", __ASSET__assets_images_planets_planet_1_none_png);
		type.set ("assets/images/planets/planet_1_none.png", AssetType.IMAGE);
		
		className.set ("assets/images/planets/planet_1_player.png", __ASSET__assets_images_planets_planet_1_player_png);
		type.set ("assets/images/planets/planet_1_player.png", AssetType.IMAGE);
		
		className.set ("assets/images/play_btn.png", __ASSET__assets_images_play_btn_png);
		type.set ("assets/images/play_btn.png", AssetType.IMAGE);
		
		className.set ("assets/images/replay_btn.png", __ASSET__assets_images_replay_btn_png);
		type.set ("assets/images/replay_btn.png", AssetType.IMAGE);
		
		className.set ("assets/images/restart_btn.png", __ASSET__assets_images_restart_btn_png);
		type.set ("assets/images/restart_btn.png", AssetType.IMAGE);
		
		className.set ("assets/images/select_ship_tutorial.png", __ASSET__assets_images_select_ship_tutorial_png);
		type.set ("assets/images/select_ship_tutorial.png", AssetType.IMAGE);
		
		className.set ("assets/images/select_ship_tutorial.psd", __ASSET__assets_images_select_ship_tutorial_psd);
		type.set ("assets/images/select_ship_tutorial.psd", AssetType.BINARY);
		
		className.set ("assets/images/select_ship_tutorial_1.png", __ASSET__assets_images_select_ship_tutorial_1_png);
		type.set ("assets/images/select_ship_tutorial_1.png", AssetType.IMAGE);
		
		className.set ("assets/images/select_ship_tutorial_2.png", __ASSET__assets_images_select_ship_tutorial_2_png);
		type.set ("assets/images/select_ship_tutorial_2.png", AssetType.IMAGE);
		
		className.set ("assets/images/ship.psd", __ASSET__assets_images_ship_psd);
		type.set ("assets/images/ship.psd", AssetType.BINARY);
		
		className.set ("assets/images/ships/ship_1_enemy1.png", __ASSET__assets_images_ships_ship_1_enemy1_png);
		type.set ("assets/images/ships/ship_1_enemy1.png", AssetType.IMAGE);
		
		className.set ("assets/images/ships/ship_1_neutral.png", __ASSET__assets_images_ships_ship_1_neutral_png);
		type.set ("assets/images/ships/ship_1_neutral.png", AssetType.IMAGE);
		
		className.set ("assets/images/ships/ship_1_player.png", __ASSET__assets_images_ships_ship_1_player_png);
		type.set ("assets/images/ships/ship_1_player.png", AssetType.IMAGE);
		
		className.set ("assets/images/ships/ship_1_player_selected.png", __ASSET__assets_images_ships_ship_1_player_selected_png);
		type.set ("assets/images/ships/ship_1_player_selected.png", AssetType.IMAGE);
		
		className.set ("assets/images/ships/ship_2_enemy1.png", __ASSET__assets_images_ships_ship_2_enemy1_png);
		type.set ("assets/images/ships/ship_2_enemy1.png", AssetType.IMAGE);
		
		className.set ("assets/images/ships/ship_2_neutral.png", __ASSET__assets_images_ships_ship_2_neutral_png);
		type.set ("assets/images/ships/ship_2_neutral.png", AssetType.IMAGE);
		
		className.set ("assets/images/ships/ship_2_player.png", __ASSET__assets_images_ships_ship_2_player_png);
		type.set ("assets/images/ships/ship_2_player.png", AssetType.IMAGE);
		
		className.set ("assets/images/ships/ship_2_player_selected.png", __ASSET__assets_images_ships_ship_2_player_selected_png);
		type.set ("assets/images/ships/ship_2_player_selected.png", AssetType.IMAGE);
		
		className.set ("assets/images/ships/ship_3_enemy1.png", __ASSET__assets_images_ships_ship_3_enemy1_png);
		type.set ("assets/images/ships/ship_3_enemy1.png", AssetType.IMAGE);
		
		className.set ("assets/images/ships/ship_3_neutral.png", __ASSET__assets_images_ships_ship_3_neutral_png);
		type.set ("assets/images/ships/ship_3_neutral.png", AssetType.IMAGE);
		
		className.set ("assets/images/ships/ship_3_player.png", __ASSET__assets_images_ships_ship_3_player_png);
		type.set ("assets/images/ships/ship_3_player.png", AssetType.IMAGE);
		
		className.set ("assets/images/ships/ship_3_player_selected.png", __ASSET__assets_images_ships_ship_3_player_selected_png);
		type.set ("assets/images/ships/ship_3_player_selected.png", AssetType.IMAGE);
		
		className.set ("assets/images/temp_laser.png", __ASSET__assets_images_temp_laser_png);
		type.set ("assets/images/temp_laser.png", AssetType.IMAGE);
		
		className.set ("assets/images/thumbnail.png", __ASSET__assets_images_thumbnail_png);
		type.set ("assets/images/thumbnail.png", AssetType.IMAGE);
		
		className.set ("assets/images/tutorials/move tutorial images and files here", __ASSET__assets_images_tutorials_move_tutorial_images_and_files_here);
		type.set ("assets/images/tutorials/move tutorial images and files here", AssetType.TEXT);
		
		className.set ("assets/images/whitebg.png", __ASSET__assets_images_whitebg_png);
		type.set ("assets/images/whitebg.png", AssetType.IMAGE);
		
		className.set ("assets/music/menu.mp3", __ASSET__assets_music_menu_mp3);
		type.set ("assets/music/menu.mp3", AssetType.MUSIC);
		
		className.set ("assets/music/menu.ogg", __ASSET__assets_music_menu_ogg);
		type.set ("assets/music/menu.ogg", AssetType.SOUND);
		
		className.set ("assets/music/menu.wav", __ASSET__assets_music_menu_wav);
		type.set ("assets/music/menu.wav", AssetType.SOUND);
		
		className.set ("assets/music/music-goes-here.txt", __ASSET__assets_music_music_goes_here_txt);
		type.set ("assets/music/music-goes-here.txt", AssetType.TEXT);
		
		className.set ("assets/sounds/applause.mp3", __ASSET__assets_sounds_applause_mp3);
		type.set ("assets/sounds/applause.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/applause.ogg", __ASSET__assets_sounds_applause_ogg1);
		type.set ("assets/sounds/applause.ogg", AssetType.SOUND);
		
		className.set ("assets/sounds/applause.wav", __ASSET__assets_sounds_applause_wav1);
		type.set ("assets/sounds/applause.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/laser.mp3", __ASSET__assets_sounds_laser_mp3);
		type.set ("assets/sounds/laser.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/laser.ogg", __ASSET__assets_sounds_laser_ogg1);
		type.set ("assets/sounds/laser.ogg", AssetType.SOUND);
		
		className.set ("assets/sounds/laser.wav", __ASSET__assets_sounds_laser_wav1);
		type.set ("assets/sounds/laser.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/sounds-go-here.txt", __ASSET__assets_sounds_sounds_go_here_txt);
		type.set ("assets/sounds/sounds-go-here.txt", AssetType.TEXT);
		
		className.set ("flixel/sounds/beep.ogg", __ASSET__flixel_sounds_beep_ogg);
		type.set ("flixel/sounds/beep.ogg", AssetType.SOUND);
		
		className.set ("flixel/sounds/flixel.ogg", __ASSET__flixel_sounds_flixel_ogg);
		type.set ("flixel/sounds/flixel.ogg", AssetType.SOUND);
		
		className.set ("flixel/fonts/nokiafc22.ttf", __ASSET__flixel_fonts_nokiafc22_ttf);
		type.set ("flixel/fonts/nokiafc22.ttf", AssetType.FONT);
		
		className.set ("flixel/fonts/monsterrat.ttf", __ASSET__flixel_fonts_monsterrat_ttf);
		type.set ("flixel/fonts/monsterrat.ttf", AssetType.FONT);
		
		className.set ("flixel/images/ui/button.png", __ASSET__flixel_images_ui_button_png);
		type.set ("flixel/images/ui/button.png", AssetType.IMAGE);
		
		className.set ("flixel/images/logo/default.png", __ASSET__flixel_images_logo_default_png);
		type.set ("flixel/images/logo/default.png", AssetType.IMAGE);
		
		
		if (useManifest) {
			
			loadManifest ();
			
			if (Sys.args ().indexOf ("-livereload") > -1) {
				
				var path = FileSystem.fullPath ("manifest");
				lastModified = FileSystem.stat (path).mtime.getTime ();
				
				timer = new Timer (2000);
				timer.run = function () {
					
					var modified = FileSystem.stat (path).mtime.getTime ();
					
					if (modified > lastModified) {
						
						lastModified = modified;
						loadManifest ();
						
						onChange.dispatch ();
						
					}
					
				}
				
			}
			
		}
		
		#else
		
		loadManifest ();
		
		#end
		#end
		
	}
	
	
	public override function exists (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var assetType = this.type.get (id);
		
		if (assetType != null) {
			
			if (assetType == requestedType || ((requestedType == SOUND || requestedType == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if (requestedType == BINARY && (assetType == BINARY || assetType == TEXT || assetType == IMAGE)) {
				
				return true;
				
			} else if (requestedType == TEXT && assetType == BINARY) {
				
				return true;
				
			} else if (requestedType == null || path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (requestedType == BINARY || requestedType == null || (assetType == BINARY && requestedType == TEXT)) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getAudioBuffer (id:String):AudioBuffer {
		
		#if flash
		
		var buffer = new AudioBuffer ();
		buffer.src = cast (Type.createInstance (className.get (id), []), Sound);
		return buffer;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		if (className.exists(id)) return AudioBuffer.fromBytes (cast (Type.createInstance (className.get (id), []), Bytes));
		else return AudioBuffer.fromFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):Bytes {
		
		#if flash
		
		switch (type.get (id)) {
			
			case TEXT, BINARY:
				
				return Bytes.ofData (cast (Type.createInstance (className.get (id), []), flash.utils.ByteArray));
			
			case IMAGE:
				
				var bitmapData = cast (Type.createInstance (className.get (id), []), BitmapData);
				return Bytes.ofData (bitmapData.getPixels (bitmapData.rect));
			
			default:
				
				return null;
			
		}
		
		return cast (Type.createInstance (className.get (id), []), Bytes);
		
		#elseif html5
		
		var loader = Preloader.loaders.get (path.get (id));
		
		if (loader == null) {
			
			return null;
			
		}
		
		var bytes = loader.bytes;
		
		if (bytes != null) {
			
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Bytes);
		else return Bytes.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if flash
		
		var src = Type.createInstance (className.get (id), []);
		
		var font = new Font (src.fontName);
		font.src = src;
		return font;
		
		#elseif html5
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Font);
			
		} else {
			
			return Font.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	public override function getImage (id:String):Image {
		
		#if flash
		
		return Image.fromBitmapData (cast (Type.createInstance (className.get (id), []), BitmapData));
		
		#elseif html5
		
		return Image.fromImageElement (Preloader.images.get (path.get (id)));
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Image);
			
		} else {
			
			return Image.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	/*public override function getMusic (id:String):Dynamic {
		
		#if flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif openfl_html5
		
		//var sound = new Sound ();
		//sound.__buffer = true;
		//sound.load (new URLRequest (path.get (id)));
		//return sound;
		return null;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return null;
		//if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		//else return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}*/
	
	
	public override function getPath (id:String):String {
		
		//#if ios
		
		//return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		//#else
		
		return path.get (id);
		
		//#end
		
	}
	
	
	public override function getText (id:String):String {
		
		#if html5
		
		var loader = Preloader.loaders.get (path.get (id));
		
		if (loader == null) {
			
			return null;
			
		}
		
		var bytes = loader.bytes;
		
		if (bytes != null) {
			
			return bytes.getString (0, bytes.length);
			
		} else {
			
			return null;
		}
		
		#else
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.getString (0, bytes.length);
			
		}
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		
		#if flash
		
		//if (requestedType != AssetType.MUSIC && requestedType != AssetType.SOUND) {
			
			return className.exists (id);
			
		//}
		
		#end
		
		return true;
		
	}
	
	
	public override function list (type:String):Array<String> {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var items = [];
		
		for (id in this.type.keys ()) {
			
			if (requestedType == null || exists (id, type)) {
				
				items.push (id);
				
			}
			
		}
		
		return items;
		
	}
	
	
	public override function loadAudioBuffer (id:String):Future<AudioBuffer> {
		
		var promise = new Promise<AudioBuffer> ();
		
		#if (flash)
		
		if (path.exists (id)) {
			
			var soundLoader = new Sound ();
			soundLoader.addEventListener (Event.COMPLETE, function (event) {
				
				var audioBuffer:AudioBuffer = new AudioBuffer();
				audioBuffer.src = event.currentTarget;
				promise.complete (audioBuffer);
				
			});
			soundLoader.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			soundLoader.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			soundLoader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getAudioBuffer (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<AudioBuffer> (function () return getAudioBuffer (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	public override function loadBytes (id:String):Future<Bytes> {
		
		var promise = new Promise<Bytes> ();
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = Bytes.ofData (event.currentTarget.data);
				promise.complete (bytes);
				
			});
			loader.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			loader.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getBytes (id));
			
		}
		
		#elseif html5
		
		if (path.exists (id)) {
			
			var request = new HTTPRequest ();
			promise.completeWith (request.load (path.get (id) + "?" + Assets.cache.version));
			
		} else {
			
			promise.complete (getBytes (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<Bytes> (function () return getBytes (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	public override function loadImage (id:String):Future<Image> {
		
		var promise = new Promise<Image> ();
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bitmapData = cast (event.currentTarget.content, Bitmap).bitmapData;
				promise.complete (Image.fromBitmapData (bitmapData));
				
			});
			loader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getImage (id));
			
		}
		
		#elseif html5
		
		if (path.exists (id)) {
			
			var image = new js.html.Image ();
			image.onload = function (_):Void {
				
				promise.complete (Image.fromImageElement (image));
				
			}
			image.onerror = promise.error;
			image.src = path.get (id) + "?" + Assets.cache.version;
			
		} else {
			
			promise.complete (getImage (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<Image> (function () return getImage (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	#if (!flash && !html5)
	private function loadManifest ():Void {
		
		try {
			
			#if blackberry
			var bytes = Bytes.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = Bytes.readFile ("../res/manifest");
			#elseif emscripten
			var bytes = Bytes.readFile ("assets/manifest");
			#elseif (mac && java)
			var bytes = Bytes.readFile ("../Resources/manifest");
			#elseif (ios || tvos)
			var bytes = Bytes.readFile ("assets/manifest");
			#else
			var bytes = Bytes.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				if (bytes.length > 0) {
					
					var data = bytes.getString (0, bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<Dynamic> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							if (!className.exists (asset.id)) {
								
								#if (ios || tvos)
								path.set (asset.id, "assets/" + asset.path);
								#else
								path.set (asset.id, asset.path);
								#end
								type.set (asset.id, cast (asset.type, AssetType));
								
							}
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest (bytes was null)");
				
			}
		
		} catch (e:Dynamic) {
			
			trace ('Warning: Could not load asset manifest (${e})');
			
		}
		
	}
	#end
	
	
	public override function loadText (id:String):Future<String> {
		
		var promise = new Promise<String> ();
		
		#if html5
		
		if (path.exists (id)) {
			
			var request = new HTTPRequest ();
			var future = request.load (path.get (id) + "?" + Assets.cache.version);
			future.onProgress (function (progress) promise.progress (progress));
			future.onError (function (msg) promise.error (msg));
			future.onComplete (function (bytes) promise.complete (bytes.getString (0, bytes.length)));
			
		} else {
			
			promise.complete (getText (id));
			
		}
		
		#else
		
		promise.completeWith (loadBytes (id).then (function (bytes) {
			
			return new Future<String> (function () {
				
				if (bytes == null) {
					
					return null;
					
				} else {
					
					return bytes.getString (0, bytes.length);
					
				}
				
			});
			
		}));
		
		#end
		
		return promise.future;
		
	}
	
	
}


#if !display
#if flash

@:keep @:bind #if display private #end class __ASSET__assets_sounds_applause_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_applause_wav extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_laser_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_laser_wav extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_data_level1_json extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_data_level2_json extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_data_level2_harder_json extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_data_level3_json extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_data_level4_json extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_data_level5_json extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_data_level6_json extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_data_level7_json extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_data_level8_json extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_images_background_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_backgrounds_move_background_images_here extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_images_capturing_faction_tutorial_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_capturing_faction_tutorial_psd extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_images_combat_tutorial_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_cursor_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_feedback_btn_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_finishgamebg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_gameover_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_images_mapbg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menubg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menubg_psd extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_images_mouse_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_mouse_left_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_mouse_right_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_moving_ship_tutorial_psd extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_images_moving_ship_tutorial_1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_moving_ship_tutorial_2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_nextlevelbg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_planet_psd extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_images_planets_planet_1_enemy1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_planets_planet_1_neutral_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_planets_planet_1_none_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_planets_planet_1_player_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_play_btn_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_replay_btn_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_restart_btn_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_select_ship_tutorial_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_select_ship_tutorial_psd extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_images_select_ship_tutorial_1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_select_ship_tutorial_2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ship_psd extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_1_enemy1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_1_neutral_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_1_player_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_1_player_selected_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_2_enemy1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_2_neutral_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_2_player_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_2_player_selected_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_3_enemy1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_3_neutral_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_3_player_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ships_ship_3_player_selected_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_temp_laser_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_thumbnail_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_tutorials_move_tutorial_images_and_files_here extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_images_whitebg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_music_menu_mp3 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_music_menu_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_music_menu_wav extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_applause_mp3 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_applause_ogg1 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_applause_wav1 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_laser_mp3 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_laser_ogg1 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_laser_wav1 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }


#elseif html5












































































@:keep #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { super (); name = "Nokia Cellphone FC Small"; } } 
@:keep #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { super (); name = "Monsterrat"; } } 




#else



#if (windows || mac || linux || cpp)


@:file("assets/sounds/applause.ogg") #if display private #end class __ASSET__assets_sounds_applause_ogg extends lime.utils.Bytes {}
@:file("assets/sounds/applause.wav") #if display private #end class __ASSET__assets_sounds_applause_wav extends lime.utils.Bytes {}
@:file("assets/sounds/laser.ogg") #if display private #end class __ASSET__assets_sounds_laser_ogg extends lime.utils.Bytes {}
@:file("assets/sounds/laser.wav") #if display private #end class __ASSET__assets_sounds_laser_wav extends lime.utils.Bytes {}
@:file("assets/data/level1.json") #if display private #end class __ASSET__assets_data_level1_json extends lime.utils.Bytes {}
@:file("assets/data/level2.json") #if display private #end class __ASSET__assets_data_level2_json extends lime.utils.Bytes {}
@:file("assets/data/level2_harder.json") #if display private #end class __ASSET__assets_data_level2_harder_json extends lime.utils.Bytes {}
@:file("assets/data/level3.json") #if display private #end class __ASSET__assets_data_level3_json extends lime.utils.Bytes {}
@:file("assets/data/level4.json") #if display private #end class __ASSET__assets_data_level4_json extends lime.utils.Bytes {}
@:file("assets/data/level5.json") #if display private #end class __ASSET__assets_data_level5_json extends lime.utils.Bytes {}
@:file("assets/data/level6.json") #if display private #end class __ASSET__assets_data_level6_json extends lime.utils.Bytes {}
@:file("assets/data/level7.json") #if display private #end class __ASSET__assets_data_level7_json extends lime.utils.Bytes {}
@:file("assets/data/level8.json") #if display private #end class __ASSET__assets_data_level8_json extends lime.utils.Bytes {}
@:image("assets/images/background.png") #if display private #end class __ASSET__assets_images_background_png extends lime.graphics.Image {}
@:file("assets/images/backgrounds/move background images here") #if display private #end class __ASSET__assets_images_backgrounds_move_background_images_here extends lime.utils.Bytes {}
@:image("assets/images/capturing_faction_tutorial.png") #if display private #end class __ASSET__assets_images_capturing_faction_tutorial_png extends lime.graphics.Image {}
@:file("assets/images/capturing_faction_tutorial.psd") #if display private #end class __ASSET__assets_images_capturing_faction_tutorial_psd extends lime.utils.Bytes {}
@:image("assets/images/combat_tutorial.png") #if display private #end class __ASSET__assets_images_combat_tutorial_png extends lime.graphics.Image {}
@:image("assets/images/cursor.png") #if display private #end class __ASSET__assets_images_cursor_png extends lime.graphics.Image {}
@:image("assets/images/feedback_btn.png") #if display private #end class __ASSET__assets_images_feedback_btn_png extends lime.graphics.Image {}
@:image("assets/images/finishgamebg.png") #if display private #end class __ASSET__assets_images_finishgamebg_png extends lime.graphics.Image {}
@:image("assets/images/gameover.png") #if display private #end class __ASSET__assets_images_gameover_png extends lime.graphics.Image {}
@:file("assets/images/images-go-here.txt") #if display private #end class __ASSET__assets_images_images_go_here_txt extends lime.utils.Bytes {}
@:image("assets/images/mapbg.png") #if display private #end class __ASSET__assets_images_mapbg_png extends lime.graphics.Image {}
@:image("assets/images/menubg.png") #if display private #end class __ASSET__assets_images_menubg_png extends lime.graphics.Image {}
@:file("assets/images/MenuBG.psd") #if display private #end class __ASSET__assets_images_menubg_psd extends lime.utils.Bytes {}
@:image("assets/images/mouse.png") #if display private #end class __ASSET__assets_images_mouse_png extends lime.graphics.Image {}
@:image("assets/images/mouse_left.png") #if display private #end class __ASSET__assets_images_mouse_left_png extends lime.graphics.Image {}
@:image("assets/images/mouse_right.png") #if display private #end class __ASSET__assets_images_mouse_right_png extends lime.graphics.Image {}
@:file("assets/images/moving_ship_tutorial.psd") #if display private #end class __ASSET__assets_images_moving_ship_tutorial_psd extends lime.utils.Bytes {}
@:image("assets/images/moving_ship_tutorial_1.png") #if display private #end class __ASSET__assets_images_moving_ship_tutorial_1_png extends lime.graphics.Image {}
@:image("assets/images/moving_ship_tutorial_2.png") #if display private #end class __ASSET__assets_images_moving_ship_tutorial_2_png extends lime.graphics.Image {}
@:image("assets/images/nextlevelbg.png") #if display private #end class __ASSET__assets_images_nextlevelbg_png extends lime.graphics.Image {}
@:file("assets/images/planet.psd") #if display private #end class __ASSET__assets_images_planet_psd extends lime.utils.Bytes {}
@:image("assets/images/planets/planet_1_enemy1.png") #if display private #end class __ASSET__assets_images_planets_planet_1_enemy1_png extends lime.graphics.Image {}
@:image("assets/images/planets/planet_1_neutral.png") #if display private #end class __ASSET__assets_images_planets_planet_1_neutral_png extends lime.graphics.Image {}
@:image("assets/images/planets/planet_1_none.png") #if display private #end class __ASSET__assets_images_planets_planet_1_none_png extends lime.graphics.Image {}
@:image("assets/images/planets/planet_1_player.png") #if display private #end class __ASSET__assets_images_planets_planet_1_player_png extends lime.graphics.Image {}
@:image("assets/images/play_btn.png") #if display private #end class __ASSET__assets_images_play_btn_png extends lime.graphics.Image {}
@:image("assets/images/replay_btn.png") #if display private #end class __ASSET__assets_images_replay_btn_png extends lime.graphics.Image {}
@:image("assets/images/restart_btn.png") #if display private #end class __ASSET__assets_images_restart_btn_png extends lime.graphics.Image {}
@:image("assets/images/select_ship_tutorial.png") #if display private #end class __ASSET__assets_images_select_ship_tutorial_png extends lime.graphics.Image {}
@:file("assets/images/select_ship_tutorial.psd") #if display private #end class __ASSET__assets_images_select_ship_tutorial_psd extends lime.utils.Bytes {}
@:image("assets/images/select_ship_tutorial_1.png") #if display private #end class __ASSET__assets_images_select_ship_tutorial_1_png extends lime.graphics.Image {}
@:image("assets/images/select_ship_tutorial_2.png") #if display private #end class __ASSET__assets_images_select_ship_tutorial_2_png extends lime.graphics.Image {}
@:file("assets/images/ship.psd") #if display private #end class __ASSET__assets_images_ship_psd extends lime.utils.Bytes {}
@:image("assets/images/ships/ship_1_enemy1.png") #if display private #end class __ASSET__assets_images_ships_ship_1_enemy1_png extends lime.graphics.Image {}
@:image("assets/images/ships/ship_1_neutral.png") #if display private #end class __ASSET__assets_images_ships_ship_1_neutral_png extends lime.graphics.Image {}
@:image("assets/images/ships/ship_1_player.png") #if display private #end class __ASSET__assets_images_ships_ship_1_player_png extends lime.graphics.Image {}
@:image("assets/images/ships/ship_1_player_selected.png") #if display private #end class __ASSET__assets_images_ships_ship_1_player_selected_png extends lime.graphics.Image {}
@:image("assets/images/ships/ship_2_enemy1.png") #if display private #end class __ASSET__assets_images_ships_ship_2_enemy1_png extends lime.graphics.Image {}
@:image("assets/images/ships/ship_2_neutral.png") #if display private #end class __ASSET__assets_images_ships_ship_2_neutral_png extends lime.graphics.Image {}
@:image("assets/images/ships/ship_2_player.png") #if display private #end class __ASSET__assets_images_ships_ship_2_player_png extends lime.graphics.Image {}
@:image("assets/images/ships/ship_2_player_selected.png") #if display private #end class __ASSET__assets_images_ships_ship_2_player_selected_png extends lime.graphics.Image {}
@:image("assets/images/ships/ship_3_enemy1.png") #if display private #end class __ASSET__assets_images_ships_ship_3_enemy1_png extends lime.graphics.Image {}
@:image("assets/images/ships/ship_3_neutral.png") #if display private #end class __ASSET__assets_images_ships_ship_3_neutral_png extends lime.graphics.Image {}
@:image("assets/images/ships/ship_3_player.png") #if display private #end class __ASSET__assets_images_ships_ship_3_player_png extends lime.graphics.Image {}
@:image("assets/images/ships/ship_3_player_selected.png") #if display private #end class __ASSET__assets_images_ships_ship_3_player_selected_png extends lime.graphics.Image {}
@:image("assets/images/temp_laser.png") #if display private #end class __ASSET__assets_images_temp_laser_png extends lime.graphics.Image {}
@:image("assets/images/thumbnail.png") #if display private #end class __ASSET__assets_images_thumbnail_png extends lime.graphics.Image {}
@:file("assets/images/tutorials/move tutorial images and files here") #if display private #end class __ASSET__assets_images_tutorials_move_tutorial_images_and_files_here extends lime.utils.Bytes {}
@:image("assets/images/whitebg.png") #if display private #end class __ASSET__assets_images_whitebg_png extends lime.graphics.Image {}
@:file("assets/music/menu.mp3") #if display private #end class __ASSET__assets_music_menu_mp3 extends lime.utils.Bytes {}
@:file("assets/music/menu.ogg") #if display private #end class __ASSET__assets_music_menu_ogg extends lime.utils.Bytes {}
@:file("assets/music/menu.wav") #if display private #end class __ASSET__assets_music_menu_wav extends lime.utils.Bytes {}
@:file("assets/music/music-goes-here.txt") #if display private #end class __ASSET__assets_music_music_goes_here_txt extends lime.utils.Bytes {}
@:file("assets/sounds/applause.mp3") #if display private #end class __ASSET__assets_sounds_applause_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/applause.ogg") #if display private #end class __ASSET__assets_sounds_applause_ogg1 extends lime.utils.Bytes {}
@:file("assets/sounds/applause.wav") #if display private #end class __ASSET__assets_sounds_applause_wav1 extends lime.utils.Bytes {}
@:file("assets/sounds/laser.mp3") #if display private #end class __ASSET__assets_sounds_laser_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/laser.ogg") #if display private #end class __ASSET__assets_sounds_laser_ogg1 extends lime.utils.Bytes {}
@:file("assets/sounds/laser.wav") #if display private #end class __ASSET__assets_sounds_laser_wav1 extends lime.utils.Bytes {}
@:file("assets/sounds/sounds-go-here.txt") #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/flixel/4,2,1/assets/sounds/beep.ogg") #if display private #end class __ASSET__flixel_sounds_beep_ogg extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/flixel/4,2,1/assets/sounds/flixel.ogg") #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends lime.utils.Bytes {}
@:font("C:/HaxeToolkit/haxe/lib/flixel/4,2,1/assets/fonts/nokiafc22.ttf") #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:font("C:/HaxeToolkit/haxe/lib/flixel/4,2,1/assets/fonts/monsterrat.ttf") #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:image("C:/HaxeToolkit/haxe/lib/flixel/4,2,1/assets/images/ui/button.png") #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/flixel/4,2,1/assets/images/logo/default.png") #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}



#end
#end

#if (openfl && !flash)
@:keep #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__flixel_fonts_nokiafc22_ttf (); src = font.src; name = font.name; super (); }}
@:keep #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__flixel_fonts_monsterrat_ttf (); src = font.src; name = font.name; super (); }}

#end

#end