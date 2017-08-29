import js.html.ImageElement;
import js.html.Element;
import js.Browser;

using StringTools;

class Radio {

	var snd:IWaudSound;

	var stations:Map<String, String>;
	var labels:Map<String, String>;

	var title:Element;
	var playing:Element;

	var radiox:ImageElement;
	var capital:ImageElement;
	var heart:ImageElement;
	var lbc:ImageElement;
	var smooth:ImageElement;

	public function new() {
		Waud.init();

		title = cast Browser.document.getElementById("title");
		playing = cast Browser.document.getElementById("playing");
		radiox = cast Browser.document.getElementById("radiox");
		capital = cast Browser.document.getElementById("capital");
		heart = cast Browser.document.getElementById("heart");
		lbc = cast Browser.document.getElementById("lbc");
		smooth = cast Browser.document.getElementById("smooth");

		radiox.onclick = function() playRadio("radiox");
		capital.onclick = function() playRadio("capital");
		heart.onclick = function() playRadio("heart");
		lbc.onclick = function() playRadio("lbc");
		smooth.onclick = function() playRadio("smooth");

		title.innerText = "WAUD RADIO";

		stations = new Map();
		stations.set("radiox", "http://ice-sov.musicradio.com/RadioXUKMP3");
		stations.set("capital", "http://ice-sov.musicradio.com/CapitalUK");
		stations.set("heart", "http://ice-sov.musicradio.com/HeartUKMP3");
		stations.set("lbc", "http://ice-sov.musicradio.com/LBCUKMP3");
		stations.set("smooth", "http://ice-sov.musicradio.com/SmoothUKMP3");

		labels = new Map();
		labels.set("radiox", "Radio X UK");
		labels.set("capital", "Capital UK");
		labels.set("heart", "Heart UK");
		labels.set("lbc", "LBC UK");
		labels.set("smooth", "Smooth UK");

	}

	function playRadio(station:String) {
		if (snd != null) snd.destroy();
		snd = new WaudSound(stations.get(station), { autoplay:true, webaudio:false });
		playing.innerText = labels.get(station);
	}

	static function main() {
		new Radio();
	}
}