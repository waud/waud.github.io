import js.html.ImageElement;
import js.html.Element;
import js.Browser;

using StringTools;

class RadioTelugu {

	var snd:IWaudSound;

	var stations:Map<String, String>;
	var labels:Map<String, String>;

	var title:Element;
	var playing:Element;

	var adhurs:ImageElement;
	var spicefm:ImageElement;
	var radio9:ImageElement;
	var radiogeetam:ImageElement;
	var mastitime:ImageElement;

	public function new() {
		Waud.init();

		title = cast Browser.document.getElementById("title");
		playing = cast Browser.document.getElementById("playing");
		adhurs = cast Browser.document.getElementById("adhurs");
		spicefm = cast Browser.document.getElementById("spicefm");
		radio9 = cast Browser.document.getElementById("radio9");
		radiogeetam = cast Browser.document.getElementById("radiogeetam");
		mastitime = cast Browser.document.getElementById("mastitime");

		adhurs.onclick = function() playRadio("adhurs");
		spicefm.onclick = function() playRadio("spicefm");
		radio9.onclick = function() playRadio("radio9");
		radiogeetam.onclick = function() playRadio("radiogeetam");
		mastitime.onclick = function() playRadio("mastitime");

		title.innerText = "WAUD RADIO TELUGU";

		stations = new Map();
		stations.set("adhurs", "http://stream.radiojar.com/265xy1sdxwwtv");
		stations.set("spicefm", "http://fmout.spicefm.in:8000/spice_b");
		stations.set("radio9", "http://174.37.252.208:8530/;stream.mp3");
		stations.set("radiogeetam", "http://149.56.175.167:5700/stream");
		stations.set("mastitime", "http://ice41.securenetsystems.net/DPMASTI?type=.mp3");

		labels = new Map();
		labels.set("adhurs", "Radio Adhurs");
		labels.set("spicefm", "Spice FM");
		labels.set("radio9", "Radio 9");
		labels.set("radiogeetam", "Radio Geetam");
		labels.set("mastitime", "Masti Time");

	}

	function playRadio(station:String) {
		if (snd != null) snd.destroy();
		snd = new WaudSound(stations.get(station), { autoplay:true, webaudio:false });
		playing.innerText = labels.get(station);
	}

	static function main() {
		new RadioTelugu();
	}
}