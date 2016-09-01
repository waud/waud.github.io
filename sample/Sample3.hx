import js.Browser;
import pixi.core.Pixi;
import pixi.core.text.Text;
import pixi.core.display.Container;
import pixi.plugins.app.Application;

class Sample3 extends Application {

	var _btnContainer:Container;

	var _snd1:IWaudSound;
	var _snd2:IWaudSound;
	var _snd3:IWaudSound;
	var _snd4:IWaudSound;
	var _snd5:IWaudSound;
	var _snd6:IWaudSound;
	var _snd7:IWaudSound;
	var _snd8:IWaudSound;
	var _snd9:IWaudSound;
	var _snd10:IWaudSound;

	var _ua:Text;

	public function new() {
		super();
		Pixi.RESOLUTION = pixelRatio = Browser.window.devicePixelRatio;
		autoResize = true;
		backgroundColor = 0x5F04B4;
		roundPixels = true;
		onResize = _resize;
		super.start();

		_btnContainer = new Container();
		stage.addChild(_btnContainer);

		_ua = new Text(Browser.navigator.userAgent, { font: "12px Tahoma", fill:"#FFFFFF" });
		stage.addChild(_ua);

		_addButton("Spin Sound 1", 0, 100, 80, 30, function() { _snd1.play(); });
		_addButton("Spin Sound 2", 80, 100, 80, 30, function() { _snd2.play(); });
		_addButton("Spin Sound 3", 160, 100, 80, 30, function() { _snd3.play(); });
		_addButton("Spin Sound 4", 240, 100, 80, 30, function() { _snd4.play(); });
		_addButton("Spin Sound 5", 320, 100, 80, 30, function() { _snd5.play(); });
		_addButton("Hit Bonus", 400, 100, 80, 30, function() { _snd6.play(); });

		Waud.init();
		Waud.autoMute();
		Waud.enableTouchUnlock(touchUnlock);

		_ua.text += "\n" + Waud.getFormatSupportString();
		_ua.text += "\nWeb Audio API: " + Waud.isWebAudioSupported;
		_ua.text += "\nHTML5 Audio: " + Waud.isHTML5AudioSupported;
		_ua.text += "\nSample Rate: " + Waud.preferredSampleRate;

		_snd1 = new WaudSound("sounds/spin_1.m4a");
		_snd2 = new WaudSound("sounds/sun_spin2.m4a");
		_snd3 = new WaudSound("sounds/Sun_spin_4.m4a");
		_snd4 = new WaudSound("sounds/sun_spin_5.m4a");
		_snd5 = new WaudSound("sounds/sun_spin_6.m4a");
		_snd6 = new WaudSound("sounds/sun_win_during_free_spin.m4a");

		_resize();
	}

	function touchUnlock() {

	}

	function _mute() {
		Waud.mute(true);
	}

	function _unmute() {
		Waud.mute(false);
	}

	function _stop() {
		Waud.stop();
	}

    function _pause() {
		Waud.pause();
	}

	function _addButton(label:String, x:Float, y:Float, width:Float, height:Float, callback:Dynamic) {
		var btn:Button = new Button(label, width, height);
		btn.position.set(x, y);
		btn.action.add(callback);
		btn.enable();
		_btnContainer.addChild(btn);
	}

	function _resize() {
		_btnContainer.position.set((Browser.window.innerWidth - _btnContainer.width) / 2, (Browser.window.innerHeight - _btnContainer.height) / 2);
	}

	static function main() {
		new Sample3();
	}
}