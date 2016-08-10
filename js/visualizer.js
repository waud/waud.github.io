(function (console, $hx_exports) { "use strict";
var Visualizer = $hx_exports.Visualizer = function(c,context) {
	this.FFT_SIZE = 2048;
	this.SMOOTHING = 1;
	this.canvas = c;
	this.drawContext = this.canvas.getContext("2d",null);
	this.audioContext = context;
	this.analyser = this.audioContext.createAnalyser();
	this.analyser.connect(this.audioContext.destination);
	this.analyser.minDecibels = -140;
	this.analyser.maxDecibels = 0;
	this.freqs = new Uint8Array(this.analyser.frequencyBinCount);
	this.times = new Uint8Array(this.analyser.frequencyBinCount);
	this.isPlaying = false;
	this.startTime = 0;
	this.startOffset = 0;
};
Visualizer.prototype = {
	start: function(s) {
		this.snd = s;
		this.startTime = this.audioContext.currentTime;
		this.snd.play();
		this.snd.source.connect(this.analyser);
		window.requestAnimationFrame($bind(this,this.draw));
		this.isPlaying = true;
		this.canvas.style.visibility = "visible";
	}
	,stop: function() {
		this.snd.stop();
		this.startOffset += this.snd.getTime() - this.startTime;
		this.isPlaying = false;
		this.canvas.style.visibility = "hidden";
	}
	,draw: function(t) {
		this.analyser.smoothingTimeConstant = this.SMOOTHING;
		this.analyser.fftSize = this.FFT_SIZE;
		this.analyser.getByteFrequencyData(this.freqs);
		this.analyser.getByteTimeDomainData(this.times);
		this.WIDTH = window.innerWidth;
		this.HEIGHT = window.innerHeight;
		this.canvas.width = this.WIDTH;
		this.canvas.height = this.HEIGHT;
		var _g1 = 0;
		var _g = this.analyser.frequencyBinCount;
		while(_g1 < _g) {
			var i = _g1++;
			var value = this.freqs[i];
			var percent = value / 256;
			var height = this.HEIGHT * percent;
			var offset = this.HEIGHT - height - 1;
			var barWidth = this.WIDTH / this.analyser.frequencyBinCount;
			var hue = i / this.analyser.frequencyBinCount * 360;
			value = this.times[i];
			percent = value / 256;
			height = this.HEIGHT * percent;
			offset = this.HEIGHT - height - 1;
			barWidth = this.WIDTH / this.analyser.frequencyBinCount;
			this.drawContext.globalAlpha = 0.75;
			this.drawContext.fillStyle = "#35B398";
			this.drawContext.fillRect(i * barWidth,offset,1,2);
		}
		if(this.isPlaying) window.requestAnimationFrame($bind(this,this.draw));
	}
	,getFrequencyValue: function(freq) {
		var nyquist = this.audioContext.sampleRate / 2;
		var index = Math.round(freq / nyquist * this.freqs.length);
		return this.freqs[index];
	}
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : exports);
