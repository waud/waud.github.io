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
	var radiodumdum:ImageElement;
	var radio9:ImageElement;
	var radiogeetam:ImageElement;
	var nuke:ImageElement;

	public function new() {
		Waud.init();

		title = cast Browser.document.getElementById("title");
		playing = cast Browser.document.getElementById("playing");
		adhurs = cast Browser.document.getElementById("adhurs");
		radiodumdum = cast Browser.document.getElementById("radiodumdum");
		radio9 = cast Browser.document.getElementById("radio9");
		radiogeetam = cast Browser.document.getElementById("radiogeetam");
		nuke = cast Browser.document.getElementById("nuke");

		adhurs.onclick = function() playRadio("adhurs");
		radiodumdum.onclick = function() playRadio("radiodumdum");
		radio9.onclick = function() playRadio("radio9");
		radiogeetam.onclick = function() playRadio("radiogeetam");
		nuke.onclick = function() playRadio("nuke");

		title.innerText = "WAUD RADIO TELUGU";

		stations = new Map();
		stations.set("adhurs", "http://stream.radiojar.com/265xy1sdxwwtv");
		stations.set("radiodumdum", "http://hyd.radiodumdum.com:8000/stream");
		stations.set("radio9", "http://174.37.252.208:8530/;stream.mp3");
		stations.set("radiogeetam", "http://149.56.175.167:5700/stream");
		stations.set("nuke", "http://live.nukeradio.com:8000/Stream3");

		labels = new Map();
		labels.set("adhurs", "Radio Adhurs");
		labels.set("radiodumdum", "Radio Dum Dum");
		labels.set("radio9", "Radio 9");
		labels.set("radiogeetam", "Radio Geetam");
		labels.set("nuke", "Nuke Radio");

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