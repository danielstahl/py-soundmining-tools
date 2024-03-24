(
var synthsDir = thisProcess.nowExecutingPath.dirname +/+ "synths/";

SynthDef(\staticControl, {
	arg dur = 1, value = 1, out = 0;
	var lineEnv;
	lineEnv = Line.kr(start: value, end: value, dur: dur, doneAction:2);
	Out.kr(out, lineEnv);
}).add.store('global', synthsDir);

SynthDef(\lineControl, {
	arg dur = 1, startValue = 1, endValue = 1, out = 0;
	var lineEnv;
	lineEnv = Line.kr(start: startValue, end: endValue, dur: dur, doneAction:2);
	Out.kr(out, lineEnv);
}).add.store('global', synthsDir);

SynthDef(\xlineControl, {
	arg dur = 1, startValue = 1, endValue = 1, out = 0;
	var xlineEnv;
	xlineEnv = XLine.kr(start: startValue, end: endValue, dur: dur, doneAction:2);
	Out.kr(out, xlineEnv);
}).add.store('global', synthsDir);

SynthDef(\sineControl, {
	arg dur = 1, startValue = 1, peakValue = 1, out = 0;
	var sineEnv;
	sineEnv = EnvGen.kr(Env.sine(dur: dur, level: 1, dur: dur), doneAction:2).linlin(0, 1, startValue, peakValue);
	Out.kr(out, sineEnv);
}).add.store('global', synthsDir);

SynthDef(\percControl, {
	arg dur = 1, attackTime = 0.01, curve = -4, startValue = 1, peakValue = 1, out = 0;
	var percEnv;
	percEnv = EnvGen.kr(
		Env.perc(attackTime, dur - attackTime, 1, curve), doneAction:2).linlin(0, 1, startValue, peakValue);
	Out.kr(out, percEnv);
}).add.store('global', synthsDir);

SynthDef(\sineOscControl, {
	arg dur = 1, freqBus = 0, minValue = 1, maxValue = 1, out = 0;
	var freq, sig;
	Line.kr(dur:dur, doneAction:2);
	freq = In.kr(freqBus, 1);
	sig = SinOsc.kr(freq).linlin(-1, 1, minValue, maxValue);
	Out.kr(out, sig);
}).add.store('global', synthsDir);

SynthDef(\controlMix, {
	arg dur = 1, in1 = 0, in2 = 0, out = 0;
	var sig1, sig2, result;
	Line.kr(dur:dur, doneAction:2);
	sig1 = In.kr(in1, 1);
	sig2 = In.kr(in2, 1);
	result = Mix.new([sig1, sig2]);
	Out.kr(out, result);
}).add.store('global', synthsDir);

SynthDef(\controlMultiply, {
	arg dur = 1, in1 = 0, in2 = 0, out = 0;
	var sig1, sig2, result;
	Line.kr(dur:dur, doneAction:2);
	sig1 = In.kr(in1, 1);
	sig2 = In.kr(in2, 1);
	result = sig1 * sig2;
	Out.kr(out, result);
}).add.store('global', synthsDir);

SynthDef(\controlSum, {
	arg dur = 1, in1 = 0, in2 = 0, out = 0;
	var sig1, sig2, result;
	Line.kr(dur:dur, doneAction:2);
	sig1 = In.kr(in1, 1);
	sig2 = In.kr(in2, 1);
	result = sig1 + sig2;
	Out.kr(out, result);
}).add.store('global', synthsDir);


SynthDef(\threeBlockControlV1, {
	arg dur = 1, startValue1, len1, startValue2, len2, startValue3, len3, endValue3, curve = 'lin', out = 0;
	var threeBlockEnv;
	threeBlockEnv = EnvGen.kr(
		Env.new(
			levels: [startValue1, startValue2, startValue3, endValue3],
			times: [len1, len2, len3],
			curve: curve),
		doneAction:2);
	Out.kr(out, threeBlockEnv);
}).add.store('global', synthsDir);

SynthDef(\twoBlockControl, {
	arg dur = 1, levels = #[0, 0, 0], times = #[0, 0], curves = #[0, 0], out = 0;
	var env;
	env = EnvGen.kr(
		Env.new(
			levels: levels,
			times: times,
			curve: curves).duration_(dur),
		doneAction:2);
	Out.kr(out, env);
}).add.store('global', synthsDir);

SynthDef(\threeBlockControl, {
	arg dur = 1, levels = #[0, 0, 0, 0], times = #[0, 0, 0], curves = #[0, 0, 0], out = 0;
	var env;
	env = EnvGen.kr(
		Env.new(
			levels: levels,
			times: times,
			curve: curves).duration_(dur),
		doneAction:2);
	Out.kr(out, env);
}).add.store('global', synthsDir);

SynthDef(\fourBlockControl, {
	arg dur = 1, levels = #[0, 0, 0, 0, 0], times = #[0, 0, 0, 0], curves = #[0, 0, 0, 0], out = 0;
	var env;
	env = EnvGen.kr(
		Env.new(
			levels: levels,
			times: times,
			curve: curves).duration_(dur),
		doneAction:2);
	Out.kr(out, env);
}).add.store('global', synthsDir);


SynthDef(\soundAmplitudeControl, {
	arg dur = 1, in = 0, out = 0, attackTime = 0.01, releaseTime = 0.01;
	var sig, result;
	Line.kr(dur:dur, doneAction:2);
	sig = In.ar(in, 1);
	result = Amplitude.kr(in:sig, attackTime:attackTime, releaseTime:releaseTime);
	Out.kr(out, result);
}).add.store('global', synthsDir);

SynthDef(\whiteNoiseOsc, {
	arg dur = 1, ampBus = 0, out = 0;
	var noise, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	noise = WhiteNoise.ar(amp);
	Out.ar(out, noise);
}).add.store('global', synthsDir);

SynthDef(\pinkNoiseOsc, {
	arg dur = 1, ampBus = 0, out = 0;
	var noise, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	noise = PinkNoise.ar(amp);
	Out.ar(out, noise);
}).add.store('global', synthsDir);

SynthDef(\sawOsc, {
	arg dur = 1, freqBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	freq = In.kr(freqBus, 1);
	sig = LFSaw.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\pulseOsc, {
	arg dur = 1, freqBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	freq = In.kr(freqBus, 1);
	sig = Pulse.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\sineOsc, {
	arg dur = 1, freqBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	freq = In.kr(freqBus, 1);
	sig = SinOsc.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\triangleOsc, {
	arg dur = 1, freqBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	freq = In.kr(freqBus, 1);
	sig = LFTri.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\dustOsc, {
	arg dur = 1, freqBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	freq = In.kr(freqBus, 1);
	sig = Dust.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\xfade, {
	arg dur = 1, in1 = 0, in2 = 0, xfadeBus = 0, out = 0;
	var sig1, sig2, pan, result;
	Line.kr(dur:dur, doneAction:2);
	sig1 = In.ar(in1, 1);
	sig2 = In.ar(in2, 1);
	pan = In.kr(xfadeBus, 1);
	result = XFade2.ar(sig1, sig2, pan);
	Out.ar(out, result);
}).add.store('global', synthsDir);

SynthDef(\left, {
	arg dur = 1, in = 0, out = 0, ampBus = 0;
	var input, amp;

	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 2);

	Out.ar(out, input[0] * amp);
}).add.store('global', synthsDir);

SynthDef(\right, {
	arg dur = 1, in = 0, out = 0, ampBus = 0;
	var input, amp;

	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 2);

	Out.ar(out, input[1] * amp);
}).add.store('global', synthsDir);

SynthDef(\mix, {
	arg dur = 1, in1 = 0, in2 = 0, out = 0, ampBus = 0;
	var sig1, sig2, result, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	sig1 = In.ar(in1, 1);
	sig2 = In.ar(in2, 1);
	result = Mix.new([sig1, sig2]);
	Out.ar(out, result * amp);
}).add.store('global', synthsDir);

SynthDef(\monoVolume, {
	arg dur = 1, in = 0, out = 0, ampBus = 0;
	var input, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 1);

	Out.ar(out, input * amp);
}).add.store('global', synthsDir);

SynthDef(\stereoVolume, {
	arg dur = 1, in = 0, out = 0, ampBus = 0;
	var input, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 2);

	Out.ar(out, input * amp);
}).add.store('global', synthsDir);

SynthDef(\expand, {
	arg dur = 1, leftIn = 0, rightIn = 0, out = 0;
	var leftInput, rightInput´;
	Line.kr(dur:dur, doneAction:2);
	leftInput = In.ar(leftIn, 1);
	rightInput = In.ar(rightIn, 1);

	Out.ar(out, [leftInput, rightInput]);
}).add.store('global', synthsDir);


/*
stereoSplit
-- take one stereoSignal and send it to two stereo buses
stereoMix
-- take two stereoSignals and mix it into one stereo signal. Use XFade2
stereoBalance
-- take one stereoSignal and re-pan it.
*/

SynthDef(\moogFilter, {
	arg dur = 1, in = 0, freqBus = 0, gainBus = 0, out = 0;
	var input, sig, freq, gain;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.kr(freqBus, 1);
	gain = In.kr(gainBus, 1);
	sig = MoogFF.ar(input, freq, gain);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\resonantFilter, {
	arg dur = 1, in = 0, freqBus = 0, decayBus = 0, out = 0;
	var input, sig, freq, decay;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.kr(freqBus, 1);
	decay = In.kr(decayBus, 1);
	sig = Ringz.ar(input, freq, decay);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\monoHighPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, out = 0;
	var input, sig, freq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.kr(freqBus, 1);
	sig = HPF.ar(input, freq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\stereoHighPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, out = 0;
	var input, sig, freq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 2);
	freq = In.kr(freqBus, 1);
	sig = HPF.ar(input, freq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\monoLowPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, out = 0;
	var input, sig, freq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.kr(freqBus, 1);
	sig = LPF.ar(input, freq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\stereoLowPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, out = 0;
	var input, sig, freq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 2);
	freq = In.kr(freqBus, 1);
	sig = LPF.ar(input, freq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\monoBandPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, rqBus = 0, out = 0;
	var input, sig, freq, rq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.kr(freqBus, 1);
	rq = In.kr(rqBus, 1);
	sig = BPF.ar(input, freq, rq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\stereoBandPassFilter, {
	arg dur = 1, in = 0, freqBus = 0, rqBus = 0, out = 0;
	var input, sig, freq, rq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 2);
	freq = In.kr(freqBus, 1);
	rq = In.kr(rqBus, 1);
	sig = BPF.ar(input, freq, rq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\monoBandRejectFilter, {
	arg dur = 1, in = 0, freqBus = 0, rqBus = 0, out = 0;
	var input, sig, freq, rq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.kr(freqBus, 1);
	rq = In.kr(rqBus, 1);
	sig = BRF.ar(input, freq, rq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\stereoBandRejectFilter, {
	arg dur = 1, in = 0, freqBus = 0, rqBus = 0, out = 0;
	var input, sig, freq, rq;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	freq = In.kr(freqBus, 1);
	rq = In.kr(rqBus, 1);
	sig = BRF.ar(input, freq, rq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\ringModulate, {
	arg dur = 1, carrierBus = 0, modulatorFreqBus = 0, out = 0;
	var carrier, modulatorFreq, sig;
	Line.kr(dur:dur, doneAction:2);
	carrier = In.ar(carrierBus, 1);
	modulatorFreq = In.kr(modulatorFreqBus, 1);
	sig = carrier * SinOsc.ar(modulatorFreq, 0, 0.5);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

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

SynthDef(\amModulate, {
	arg dur = 1, carrierBus = 0, modulatorFreqBus = 0, out = 0;
	var carrier, modulatorFreq, sig;
	Line.kr(dur:dur, doneAction:2);
	carrier = In.ar(carrierBus, 1);
	modulatorFreq = In.ar(modulatorFreqBus, 1);
	sig = carrier * SinOsc.ar(modulatorFreq, 0, 0.25, 0.25);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\frequencyShift, {
	arg dur = 1, carrierBus = 0, modulatorFreqBus = 0, out = 0;
	var carrier, modulatorFreq, sig;
	Line.kr(dur:dur, doneAction:2);
	carrier = In.ar(carrierBus, 1);
	modulatorFreq = In.ar(modulatorFreqBus, 1);
	sig = FreqShift.ar(carrier, modulatorFreq);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\bitCrushing, {
	arg dur = 1, in = 0, amountBus = 0, out = 0;
	var input, amount, sig;
	Line.kr(dur:dur, doneAction:2);
	input = In.ar(in, 1);
	amount = In.kr(amountBus, 1);
	sig = (input / amount).round * amount;
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\pmModulate, {
	arg dur = 1, carrierFreqBus = 0, modulatorFreqBus = 0, modulatorIndexBus = 0, ampBus = 0, out = 0;
	var carrierFreq, modulatorFreq, modulatorIndex, sig, conversion = 2pi/(s.sampleRate), amp;
	Line.kr(dur:dur, doneAction:2);
	carrierFreq = In.kr(carrierFreqBus, 1);
	modulatorFreq = In.kr(modulatorFreqBus, 1);
	modulatorIndex = In.kr(modulatorIndexBus, 1);
	amp = In.kr(ampBus, 1);

	sig = SinOsc.ar(
			carrierFreq,
			modulatorFreq * modulatorIndex * conversion * SinOsc.ar(modulatorFreq), 0.25);
	Out.ar(out, sig * amp);
}).add.store('global', synthsDir);

SynthDef(\fmSineModulate, {
	arg dur = 1, carrierFreqBus = 0, modulatorBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq, mod;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	freq = In.kr(carrierFreqBus, 1);
	mod = In.ar(modulatorBus, 1);

	sig = SinOsc.ar(freq + mod, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\fmPulseModulate, {
	arg dur = 1, carrierFreqBus = 0, modulatorBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq, mod;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	freq = In.kr(carrierFreqBus, 1);
	mod = In.ar(modulatorBus, 1);

	sig = Pulse.ar(freq + mod, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\fmSawModulate, {
	arg dur = 1, carrierFreqBus = 0, modulatorBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq, mod;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	freq = In.kr(carrierFreqBus, 1);
	mod = In.ar(modulatorBus, 1);

	sig = LFSaw.ar(freq + mod, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\fmTriangleModulate, {
	arg dur = 1, carrierFreqBus = 0, modulatorBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq, mod;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	freq = In.kr(carrierFreqBus, 1);
	mod = In.ar(modulatorBus, 1);

	sig = LFTri.ar(freq + mod, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\pmSineOsc, {
	arg dur = 1, freqBus = 0, modBus = 0, ampBus = 0, out = 0;
	var sig, amp, freq, mod, conversion = 2pi/(s.sampleRate);
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	freq = In.kr(freqBus, 1);
	mod = In.ar(modBus, 1);

	sig = SinOsc.ar(freq, mod * conversion, mul:amp);
	Out.ar(out, sig);
}).add.store('global', synthsDir);

SynthDef(\pan, {
	arg dur = 1, panBus = 0, in = 0, out = 0;
	var pan, input;
	Line.kr(dur:dur, doneAction:2);
	pan = In.kr(panBus, 1);

	input = In.ar(in, 1);
	Out.ar(out, LinPan2.ar(input, pan));
}).add.store('global', synthsDir);

SynthDef(\splay, {
	arg dur = 1, in = 0, out = 0, spreadBus = 0, level = 1, centerBus = 1;
	var spread, center, input;
	Line.kr(dur:dur, doneAction:2);
	spread = In.kr(spreadBus, 1);
	center = In.kr(centerBus, 1);
	input = In.ar(in, 1);
	Out.ar(out, Splay.ar(input, spread, level, center));
}).add.store('global', synthsDir);


SynthDef(\monoComb, {
	arg dur = 1, in = 0, out = 0, delaytime = 0.2, decaytime = 1, ampBus = 0;
	var input, delaySig, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 1);
	delaySig = CombL.ar(input, delaytime, delaytime, decaytime, mul:amp);

	Out.ar(out, delaySig);
}).add.store('global', synthsDir);

SynthDef(\stereoComb, {
	arg dur = 1, in = 0, out = 0, delaytime = 0.2, decaytime = 1, ampBus = 0;
	var input, delaySig, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 2);
	delaySig = CombL.ar(input, delaytime, delaytime, decaytime, mul:amp);

	Out.ar(out, delaySig);
}).add.store('global', synthsDir);

SynthDef(\stereoParallelComb, {
	arg dur = 1, in = 0, out = 0, minDelaytime = 0.01, maxDelaytime = 0.1, decayTime = 5, ampBus = 0;
	var input, sig, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 2);
	// 32 prallel comb filters
	sig = CombN.ar(input, maxDelaytime, {Rand(minDelaytime, maxDelaytime)}!32, decayTime);
	// mix it down to 2 channels and spread them over the stereo field
	sig = SplayAz.ar(2, sig);
	Out.ar(out, sig * amp);
}).add.store('global', synthsDir);

SynthDef(\monoDelay, {
	arg dur = 1, in = 0, out = 0, delaytime = 0.2, ampBus = 0;
	var input, delaySig, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 1);
	delaySig = DelayL.ar(input, delaytime, delaytime, mul:amp);

	Out.ar(out, delaySig);
}).add.store('global', synthsDir);

SynthDef(\stereoDelay, {
	arg dur = 1, in = 0, out = 0, delaytime = 0.2, decaytime = 1, ampBus = 0;
	var input, delaySig, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 2);
	delaySig = DelayL.ar(input, delaytime, delaytime, mul:amp);

	Out.ar(out, delaySig);
}).add.store('global', synthsDir);

SynthDef(\monoAllpass, {
	arg dur = 1, in = 0, out = 0, delaytime = 0.2, decaytime = 1, ampBus = 0;
	var input, delaySig, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 1);
	delaySig = AllpassL.ar(input, delaytime, delaytime, decaytime, mul:amp);

	Out.ar(out, delaySig);
}).add.store('global', synthsDir);

SynthDef(\stereoAllpass, {
	arg dur = 1, in = 0, out = 0, delaytime = 0.2, decaytime = 1, ampBus = 0;
	var input, delaySig, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 2);
	delaySig = AllpassL.ar(input, delaytime, delaytime, decaytime, mul:amp);

	Out.ar(out, delaySig);
}).add.store('global', synthsDir);

SynthDef(\stereoChainAllpass, {
	arg dur = 1, in = 0, out = 0, minDelaytime = 0.001, maxDelaytime = 0.05, decayTime = 3, ampBus = 0;
	var input, sig, amp;
	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 2);
	sig = input;
	4.do({ sig = AllpassN.ar(sig, maxDelaytime, {Rand(minDelaytime, maxDelaytime)}!2, decayTime) });
	Out.ar(out, sig * amp);
}).add.store('global', synthsDir);

SynthDef(\stereoConvolutionReverb, {
	arg dur = 1, fftSize=2048, in = 0, out=0, ampBus = 0, irLeft, irRight, amp=1.0;
	var input, output, ampControl;

	Line.kr(dur:dur, doneAction:2);
	ampControl = In.kr(ampBus, 1);
	input = In.ar(in, 2);

	output = PartConv.ar(input, fftSize, [irLeft, irRight], amp);
	Out.ar(out, output * amp);
}).add.store('global', synthsDir);

SynthDef(\stereoHallReverb, {
	arg dur = 1, in = 0, out=0, ampBus = 0, rt60=1, stereo=0.5, lowFreq=200, lowRatio=0.5, hiFreq=4000, hiRatio=0.5, earlyDiffusion=0.5, lateDiffusion=0.5, modRate=0.2, modDepth=0.3;
	var input, output, amp;

	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 2);

	output = NHHall.ar(input, rt60, stereo, lowFreq, lowRatio, hiFreq, hiRatio, earlyDiffusion, lateDiffusion, modRate, modDepth);
	Out.ar(out, output * amp);
}).add.store('global', synthsDir);

SynthDef(\stereoFreeReverb, {
	arg dur = 1, in = 0, out=0, ampBus = 0, mix=0.33, room=0.5, damp=0.5;
	var input, output, amp;

	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	input = In.ar(in, 2);

	output = FreeVerb.ar(input, mix, room, damp);
	Out.ar(out, output * amp);
}).add.store('global', synthsDir);

SynthDef(\stereoGVerb, {
	arg dur = 1, in = 0, out=0, ampBus = 0, roomsize = 10, revtime = 3, damping = 0.5, inputbw = 0.5, spread =15, drylevel = 1, earlyreflevel = 0.7, taillevel = 0.5;
	var input, output, amp;

	Line.kr(dur:dur, doneAction:2);
	amp = In.kr(ampBus, 1);
	// GVerb takes mono as input
	input = Mix.new(In.ar(in, 2));

	output = GVerb.ar(input, roomsize:roomsize, revtime:revtime, damping:damping, inputbw:inputbw, spread:spread, drylevel:drylevel, earlyreflevel:earlyreflevel, taillevel:taillevel, maxroomsize:roomsize + 1);
	Out.ar(out, output * amp);
}).add.store('global', synthsDir);

SynthDef(\stereoPlayBuffer, {
	arg bufNum, rate = 1, start = 0, end = 0, out = 0, ampBus = 0;
	var totalDur, startFrame, endFrame, amp;

	totalDur = ((end - start) / rate).abs;

	startFrame = (start / BufDur.kr(bufNum)) * BufFrames.kr(bufNum);
	endFrame = (end / BufDur.kr(bufNum)) * BufFrames.kr(bufNum);
	Line.kr(dur:totalDur, doneAction:2);
	amp = In.kr(ampBus, 1);

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
	amp = In.kr(ampBus, 1);

	Out.ar(out,
		BufRd.ar(1, bufNum,
			Line.ar(startFrame, endFrame, totalDur, doneAction:2)) * amp);
}).add.store('global', synthsDir);


)