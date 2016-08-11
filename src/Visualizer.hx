import js.Browser;
import js.html.audio.AudioContext;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
import js.html.Uint8Array;
import js.html.audio.AnalyserNode;

@:expose class Visualizer {

	var WIDTH:Int;
	var HEIGHT:Int;

	var SMOOTHING = 1;
	var FFT_SIZE = 2048;

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

	public function new(c:CanvasElement, context:AudioContext) {
		canvas = c;
		drawContext = canvas.getContext2d();
		audioContext = context;

		analyser = audioContext.createAnalyser();
		analyser.connect(audioContext.destination);
		analyser.minDecibels = -140;
		analyser.maxDecibels = 0;
		freqs = new Uint8Array(analyser.frequencyBinCount);
		times = new Uint8Array(analyser.frequencyBinCount);

		isPlaying = false;
		startTime = 0;
		startOffset = 0;
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

	public function stop() {
		snd.stop();
		startOffset += snd.getTime() - startTime;
		isPlaying = false;
		canvas.style.visibility = "hidden";
	}

	function draw(t:Float) {
		analyser.smoothingTimeConstant = SMOOTHING;
		analyser.fftSize = FFT_SIZE;
		analyser.getByteFrequencyData(freqs);
		analyser.getByteTimeDomainData(times);

		WIDTH = Browser.window.innerWidth;
		HEIGHT = Browser.window.innerHeight;
		canvas.width = WIDTH;
		canvas.height = HEIGHT;

		for (i in 0 ... analyser.frequencyBinCount) {
			var value = freqs[i];
			var percent = value / 256;
			var height = HEIGHT * percent;
			var offset = HEIGHT - height - 1;
			var barWidth = WIDTH / analyser.frequencyBinCount;
			var hue = i / analyser.frequencyBinCount * 360;
			//drawContext.fillStyle = "hsl(" + hue + ", 100%, 50%)";
			//drawContext.fillRect(i * barWidth, offset, barWidth, height);

			value = times[i];
			percent = value / 256;
			height = HEIGHT * percent;
			offset = HEIGHT - height - 1;
			barWidth = WIDTH / analyser.frequencyBinCount;
			drawContext.globalAlpha = 1;
			drawContext.fillStyle = "white"; //"#35B398";
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
}