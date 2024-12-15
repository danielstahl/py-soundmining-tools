(
var synthsDir = thisProcess.nowExecutingPath.dirname +/+ "synths-v2/";

/*
* Control signals
*/

SynthDef(\staticControl, {
	arg dur = 1, value = 1, out = 0;
	var lineEnv;
	lineEnv = Line.ar(start: value, end: value, dur: dur, doneAction:2);
	Out.ar(out, lineEnv);
}).add.store('global', synthsDir);

SynthDef(\lineControl, {
	arg dur = 1, startValue = 1, endValue = 1, out = 0;
	var lineEnv;
	lineEnv = Line.ar(start: startValue, end: endValue, dur: dur, doneAction:2);
	Out.ar(out, lineEnv);
}).add.store('global', synthsDir);

SynthDef(\xlineControl, {
	arg dur = 1, startValue = 1, endValue = 1, out = 0;
	var xlineEnv;
	xlineEnv = XLine.ar(start: startValue, end: endValue, dur: dur, doneAction:2);
	Out.ar(out, xlineEnv);
}).add.store('global', synthsDir);

SynthDef(\sineControl, {
	arg dur = 1, startValue = 1, peakValue = 1, out = 0;
	var sineEnv;
	sineEnv = EnvGen.ar(Env.sine(dur: dur, level: 1, dur: dur), doneAction:2).linlin(0, 1, startValue, peakValue);
	Out.ar(out, sineEnv);
}).add.store('global', synthsDir);

SynthDef(\percControl, {
	arg dur = 1, attackTime = 0.01, curve = -4, startValue = 1, peakValue = 1, out = 0;
	var percEnv;
	percEnv = EnvGen.ar(
		Env.perc(attackTime, dur - attackTime, 1, curve), doneAction:2).linlin(0, 1, startValue, peakValue);
	Out.ar(out, percEnv);
}).add.store('global', synthsDir);

SynthDef(\twoBlockControl, {
	arg dur = 1, levels = #[0, 0, 0], times = #[0, 0], curves = #[0, 0], out = 0;
	var env;
	env = EnvGen.ar(
		Env.new(
			levels: levels,
			times: times,
			curve: curves).duration_(dur),
		doneAction:2);
	Out.ar(out, env);
}).add.store('global', synthsDir);

SynthDef(\threeBlockControl, {
	arg dur = 1, levels = #[0, 0, 0, 0], times = #[0, 0, 0], curves = #[0, 0, 0], out = 0;
	var env;
	env = EnvGen.ar(
		Env.new(
			levels: levels,
			times: times,
			curve: curves).duration_(dur),
		doneAction:2);
	Out.ar(out, env);
}).add.store('global', synthsDir);

SynthDef(\fourBlockControl, {
	arg dur = 1, levels = #[0, 0, 0, 0, 0], times = #[0, 0, 0, 0], curves = #[0, 0, 0, 0], out = 0;
	var env;
	env = EnvGen.ar(
		Env.new(
			levels: levels,
			times: times,
			curve: curves).duration_(dur),
		doneAction:2);
	Out.ar(out, env);
}).add.store('global', synthsDir);


SynthDef(\soundAmplitudeControl, {
	arg dur = 1, in = 0, out = 0, attackTime = 0.01, releaseTime = 0.01;
	var sig, result;
	Line.kr(dur:dur, doneAction:2);
	sig = In.ar(in, 1);
	result = Amplitude.ar(in:sig, attackTime:attackTime, releaseTime:releaseTime);
	Out.ar(out, result);
}).add.store('global', synthsDir);


/*
* Signal combination
*/

SynthDef(\signalMix, {
	arg dur = 1, in1 = 0, in2 = 0, out = 0;
	var sig1, sig2, result;
	Line.kr(dur:dur, doneAction:2);
	sig1 = In.ar(in1, 1);
	sig2 = In.ar(in2, 1);
	result = Mix.new([sig1, sig2]);
	Out.ar(out, result);
}).add.store('global', synthsDir);

SynthDef(\signalMultiply, {
	arg dur = 1, in1 = 0, in2 = 0, out = 0;
	var sig1, sig2, result;
	Line.kr(dur:dur, doneAction:2);
	sig1 = In.ar(in1, 1);
	sig2 = In.ar(in2, 1);
	result = sig1 * sig2;
	Out.ar(out, result);
}).add.store('global', synthsDir);

SynthDef(\signalSum, {
	arg dur = 1, in1 = 0, in2 = 0, out = 0;
	var sig1, sig2, result;
	Line.kr(dur:dur, doneAction:2);
	sig1 = In.ar(in1, 1);
	sig2 = In.ar(in2, 1);
	result = sig1 + sig2;
	Out.ar(out, result);
}).add.store('global', synthsDir);

SynthDef(\signalShape, {
	arg dur = 1, in = 0, shapeBus = 0, out = 0;
	var sig, shape, result;
	Line.kr(dur:dur, doneAction:2);
	sig = In.ar(in, 1);
	shape = In.ar(shapeBus, 1);
	result = sig.lincurve(-1, 1, -1, 1, shape);
	Out.ar(out, result);
}).add.store('global', synthsDir);

/*
* Noise signals
*/

SynthDef(\whiteNoiseOsc, {
	arg dur = 1, ampBus = 0, out = 0;
	var noise, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	noise = WhiteNoise.ar(amp);
	Out.ar(out, noise);
}).add.store('global', synthsDir);

SynthDef(\pinkNoiseOsc, {
	arg dur = 1, ampBus = 0, out = 0;
	var noise, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	noise = PinkNoise.ar(amp);
	Out.ar(out, noise);
}).add.store('global', synthsDir);

SynthDef(\dustOsc, {
	arg dur = 1, freqBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq;
	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	freq = In.ar(freqBus, 1);
	sig = Dust.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);


/*
* Deterministic signals.
*/

SynthDef(\sineOsc, {
	arg dur = 1, freqBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq;
	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	freq = In.ar(freqBus, 1);
	sig = SinOsc.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);


SynthDef(\sawOsc, {
	arg dur = 1, freqBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq;
	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	freq = In.ar(freqBus, 1);
	sig = LFSaw.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\triangleOsc, {
	arg dur = 1, freqBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq;
	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	freq = In.ar(freqBus, 1);
	sig = LFTri.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\pulseOsc, {
	arg dur = 1, freqBus = 0, widthBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq, width;
	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	freq = In.ar(freqBus, 1);
	width = In.ar(widthBus, 1);
	sig = Pulse.ar(freq, width:width, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

/*
* Modulate volume of signal
*/

SynthDef(\monoVolume, {
	arg dur = 1, in = 0, out = 0, ampBus = 0;
	var input, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	input = In.ar(in, 1);

	Out.ar(out, input * amp);
}).add.store('global', synthsDir);

SynthDef(\stereoVolume, {
	arg dur = 1, in = 0, out = 0, ampBus = 0;
	var input, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	input = In.ar(in, 2);

	Out.ar(out, input * amp);
}).add.store('global', synthsDir);

/*
* Filters
*/

SynthDef(\moogFilter, {
	arg dur = 1, in = 0, freqBus = 0, gainBus = 0, out = 0;
	var input, sig, freq, gain;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.ar(freqBus, 1);
	gain = In.kr(gainBus, 1);
	sig = MoogFF.ar(input, freq, gain);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\resonantFilter, {
	arg dur = 1, in = 0, freqBus = 0, decayBus = 0, out = 0;
	var input, sig, freq, decay;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.ar(freqBus, 1);
	decay = In.ar(decayBus, 1);
	sig = Ringz.ar(input, freq, decay);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\monoHighPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, out = 0;
	var input, sig, freq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.ar(freqBus, 1);
	sig = HPF.ar(input, freq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\stereoHighPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, out = 0;
	var input, sig, freq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 2);
	freq = In.ar(freqBus, 1);
	sig = HPF.ar(input, freq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\monoLowPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, out = 0;
	var input, sig, freq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.ar(freqBus, 1);
	sig = LPF.ar(input, freq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\stereoLowPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, out = 0;
	var input, sig, freq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 2);
	freq = In.ar(freqBus, 1);
	sig = LPF.ar(input, freq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\monoBandPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, rqBus = 0, out = 0;
	var input, sig, freq, rq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.ar(freqBus, 1);
	rq = In.ar(rqBus, 1);
	sig = BPF.ar(input, freq, rq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\stereoBandPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, rqBus = 0, out = 0;
	var input, sig, freq, rq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 2);
	freq = In.ar(freqBus, 1);
	rq = In.ar(rqBus, 1);
	sig = BPF.ar(input, freq, rq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\monoBandRejectFilter, {
	arg dur = 1, in = 0, freqBus = 0, rqBus = 0, out = 0;
	var input, sig, freq, rq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.ar(freqBus, 1);
	rq = In.kr(rqBus, 1);
	sig = BRF.ar(input, freq, rq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\stereoBandRejectFilter, {
	arg dur = 1, in = 0, freqBus = 0, rqBus = 0, out = 0;
	var input, sig, freq, rq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 2);
	freq = In.ar(freqBus, 1);
	rq = In.ar(rqBus, 1);
	sig = BRF.ar(input, freq, rq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);


/*
* Banks
*/

SynthDef(\bankOfResonators, {
	arg dur = 1, in = 0, freqs = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	amps = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	ringTimes = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], out = 0;
	var input, sig;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	sig = Klank.ar(`[freqs, amps, ringTimes ], input);
	Out.ar(out, sig);
}).add.store('global', synthsDir );

SynthDef(\bankOfOsc, {
	arg dur = 1, freqs = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	amps = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	phases = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], out = 0;
	var sig;
	Line.kr(dur:dur, doneAction:2);
	sig = Klang.ar(`[freqs, amps, phases ]);
	Out.ar(out, sig);
}).add.store('global', synthsDir );

/*
* Pan
*/

SynthDef(\pan, {
	arg dur = 1, panBus = 0, in = 0, out = 0;
	var pan, input;
	Line.kr(dur:dur, doneAction:2);
	pan = In.ar(panBus, 1);

	input = In.ar(in, 1);
	Out.ar(out, LinPan2.ar(input, pan));
}).add.store('global', synthsDir);

SynthDef(\splay, {
	arg dur = 1, in = 0, out = 0, spreadBus = 0, level = 1, centerBus = 1;
	var spread, center, input;
	Line.kr(dur:dur, doneAction:2);
	spread = In.ar(spreadBus, 1);
	center = In.ar(centerBus, 1);
	input = In.ar(in, 1);
	Out.ar(out, Splay.ar(input, spread, level, center));
}).add.store('global', synthsDir);

/*
* Reverb
*/

SynthDef(\stereoConvolutionReverb, {
	arg dur = 1, fftSize=2048, in = 0, out=0, ampBus = 0, irLeft, irRight, amp=1.0;
	var input, output, ampControl;

	Line.kr(dur:dur, doneAction:2);
	ampControl = In.ar(ampBus, 1);
	input = In.ar(in, 2);

	output = PartConv.ar(input, fftSize, [irLeft, irRight], amp);
	Out.ar(out, output * amp);
}).add.store('global', synthsDir);

SynthDef(\stereoHallReverb, {
	arg dur = 1, in = 0, out=0, ampBus = 0, rt60=1, stereo=0.5, lowFreq=200, lowRatio=0.5, hiFreq=4000, hiRatio=0.5, earlyDiffusion=0.5, lateDiffusion=0.5, modRate=0.2, modDepth=0.3;
	var input, output, amp;

	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	input = In.ar(in, 2);

	output = NHHall.ar(input, rt60, stereo, lowFreq, lowRatio, hiFreq, hiRatio, earlyDiffusion, lateDiffusion, modRate, modDepth);
	Out.ar(out, output * amp);
}).add.store('global', synthsDir);

SynthDef(\stereoFreeReverb, {
	arg dur = 1, in = 0, out=0, ampBus = 0, mix=0.33, room=0.5, damp=0.5;
	var input, output, amp;

	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	input = In.ar(in, 2);

	output = FreeVerb.ar(input, mix, room, damp);
	Out.ar(out, output * amp);
}).add.store('global', synthsDir);

SynthDef(\stereoGVerb, {
	arg dur = 1, in = 0, out=0, ampBus = 0, roomsize = 10, revtime = 3, damping = 0.5, inputbw = 0.5, spread =15, drylevel = 1, earlyreflevel = 0.7, taillevel = 0.5;
	var input, output, amp;

	Line.kr(dur:dur, doneAction:2);
	amp = In.ar(ampBus, 1);
	// GVerb takes mono as input
	input = Mix.new(In.ar(in, 2));

	output = GVerb.ar(input, roomsize:roomsize, revtime:revtime, damping:damping, inputbw:inputbw, spread:spread, drylevel:drylevel, earlyreflevel:earlyreflevel, taillevel:taillevel, maxroomsize:roomsize + 1);
	Out.ar(out, output * amp);
}).add.store('global', synthsDir);

/*
* Playback
*/

SynthDef(\stereoPlayBuffer, {
	arg bufNum, rate = 1, start = 0, end = 0, out = 0, ampBus = 0;
	var totalDur, startFrame, endFrame, amp;

	totalDur = ((end - start) / rate).abs;

	startFrame = (start / BufDur.kr(bufNum)) * BufFrames.kr(bufNum);
	endFrame = (end / BufDur.kr(bufNum)) * BufFrames.kr(bufNum);
	Line.kr(dur:totalDur, doneAction:2);
	amp = In.ar(ampBus, 1);

	Out.ar(out,
		BufRd.ar(2, bufNum,
			Line.ar(startFrame, endFrame, totalDur, doneAction:2)) * amp);
}).add.store('global', synthsDir);

SynthDef(\monoPlayBuffer, {
	arg bufNum, rate = 1, start = 0, end = 0, out = 0, ampBus = 0;
	var totalDur, startFrame, endFrame, amp;

	totalDur = ((end - start) / rate).abs;

	startFrame = (start / BufDur.kr(bufNum)) * BufFrames.kr(bufNum);
	endFrame = (end / BufDur.kr(bufNum)) * BufFrames.kr(bufNum);
	Line.kr(dur:totalDur, doneAction:2);
	amp = In.ar(ampBus, 1);

	Out.ar(out,
		BufRd.ar(1, bufNum,
			Line.ar(startFrame, endFrame, totalDur, doneAction:2)) * amp);
}).add.store('global', synthsDir);

)