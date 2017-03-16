import haxe.Timer;
import js.html.AnchorElement;
import js.html.Element;
import js.Browser;
import js.html.audio.AudioContext;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
import js.html.Uint8Array;
import js.html.audio.AnalyserNode;

using StringTools;

class AudioPlayer {

	var WIDTH:Int;
	var HEIGHT:Int;

	var SMOOTHING = 0.8;
	var FFT_SIZE = 256;

	var analyser:AnalyserNode;
	var freqs:Uint8Array;
	var times:Uint8Array;

	var isPlaying:Bool;
	var startTime:Float;
	var startOffset:Float;

	var canvas:CanvasElement;
	var drawContext:CanvasRenderingContext2D;
	var audioContext:AudioContext;

	var snd:Dynamic;

	var soundPack:Map<String, IWaudSound>;

	var title:Element;
	var play:AnchorElement;
	var previous:AnchorElement;
	var next:AnchorElement;
	var load:AnchorElement;

	var songs:Array<String> = [
		"80s-Music",
		"Incidental",
		"Nature-Ambient",
		"Windswept"
	];
	var currentSong:Int;

	public function new() {
		currentSong = 0;
		Waud.init();

		load = cast Browser.document.getElementById("load");
		title = cast Browser.document.getElementById("title");
		play = cast Browser.document.getElementById("play");
		previous = cast Browser.document.getElementById("previous");
		next = cast Browser.document.getElementById("next");
		canvas = cast Browser.document.getElementById("visualisation");

		canvas.width = (Browser.window.innerWidth <= 320) ? Std.int(Browser.window.innerWidth - 60) : 320;

		title.innerText = "NO AUDIO";
		if (!Waud.isWebAudioSupported) {
			load.innerText = "No Web Audio";
			load.className = "button small disabled";
			return;
		}

		load.onclick = loadSounds;
	}

	function loadSounds() {
		var sounds = new WaudBase64Pack("player/sounds/sounds.json", onLoad, onProgress);

		drawContext = canvas.getContext2d();
		audioContext = Waud.audioContext;

		analyser = audioContext.createAnalyser();
		analyser.connect(audioContext.destination);
		analyser.minDecibels = -140;
		analyser.maxDecibels = 0;
		freqs = new Uint8Array(analyser.frequencyBinCount);
		times = new Uint8Array(analyser.frequencyBinCount);

		isPlaying = false;
		startTime = 0;
		startOffset = 0;

		load.onclick = null;
		load.innerText = "Loading Sounds 0%";
	}

	function onLoad(snds:Map<String, IWaudSound>) {
		soundPack = snds;
		play.onclick = playSong;
		next.onclick = nextSong;
		previous.onclick = prevSong;
		load.innerText = "Ready to Play Now";

		play.className = "button special icon small fa-play";
		previous.className = "button special icon small fa-step-backward";
		next.className = "button special icon small fa-step-forward";

		load.className = "button small disabled";
	}

	function onProgress(val:Float) {
		var per = Math.floor(val * 100);
		if (per == 100) load.innerText = "please wait...";
		else load.innerText = per < 10 ? "Loading Sounds 0" + per + "%" : "Loading Sounds " + per + "%";
	}

	function playSong() {
		if (!isPlaying) {
			play.className = "button special icon small fa-pause";
			play.innerHTML = "Pause";
			var snd:IWaudSound = soundPack.get("sounds/" + songs[currentSong] + ".mp3");
			snd.onEnd(autoPlayNextSong);
			start(snd);
			title.innerText = songs[currentSong].replace("-", " ");
		}
		else {
			play.className = "button special icon small fa-play";
			play.innerHTML = "Play";
			pause();
		}
	}

	function autoPlayNextSong(snd:IWaudSound) {
		nextSong();
	}

	function nextSong() {
		currentSong++;
		if (currentSong >= songs.length) currentSong = 0;
		stop();
		playSong();
	}

	function prevSong() {
		currentSong--;
		if (currentSong < 0) currentSong = songs.length - 1;
		stop();
		playSong();
	}

	public function start(s:Dynamic) {
		snd = s;
		startTime = audioContext.currentTime;
		snd.play();
		snd.source.connect(analyser);
		Browser.window.requestAnimationFrame(draw);
		isPlaying = true;
		canvas.style.visibility = "visible";
	}

	public function pause() {
		snd.pause();
		startOffset += snd.getTime() - startTime;
		isPlaying = false;
	}

	public function stop() {
		snd.stop();
		startOffset += snd.getTime() - startTime;
		isPlaying = false;
		canvas.style.visibility = "hidden";
	}

	function draw(t:Float) {
		if (Browser.window.innerWidth <= 320) FFT_SIZE = 128;
		else if (Browser.window.innerWidth <= 960) FFT_SIZE = 256;
		else FFT_SIZE = 512;

		analyser.smoothingTimeConstant = SMOOTHING;
		analyser.fftSize = FFT_SIZE;
		analyser.getByteFrequencyData(freqs);
		analyser.getByteTimeDomainData(times);

		WIDTH = canvas.width;
		HEIGHT = canvas.height;
		canvas.width = WIDTH;
		canvas.height = HEIGHT;

		for (i in 0 ... analyser.frequencyBinCount) {
			var value = times[i];
			var percent = value / 256;
			var height = HEIGHT * percent;
			var offset = HEIGHT - height - 1;
			var barWidth = WIDTH / analyser.frequencyBinCount;
			drawContext.fillStyle = "#E70000";
			drawContext.fillRect(i * barWidth, offset, 1, 2);
		}

		if (isPlaying) {
			Browser.window.requestAnimationFrame(draw);
		}
	}

	function getFrequencyValue(freq) {
		var nyquist = audioContext.sampleRate / 2;
		var index = Math.round(freq / nyquist * this.freqs.length);
		return this.freqs[index];
	}

	static function main() {
		new AudioPlayer();
	}
}