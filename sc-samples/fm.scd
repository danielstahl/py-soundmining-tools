s.scope;
FreqScope.new;


/* ELI FM synthesis videos
https://www.youtube.com/watch?v=UoXMUQIqFk4
https://www.youtube.com/watch?v=dLMSR2Kjq6Y
*/

/* Simple fm synthesis
500 sine wave carrier
400 sine wave modulator
*/
{ SinOsc.ar(500 + SinOsc.ar(400, mul:400)) * 0.2}.play

/*
Simple synthdef
Higher modulator amp more sidebands
The interval of sidebands is equal to the modulator frequency
Sidebands wrap when they cross zero
Clear sense of pitch when the carrier and modulator form a simple ratio
with the fundamental at the modulator
*/

(
SynthDef.new(\simpleFm, {
	arg carHz = 500, modHz = 400, modAmp = 200, amp = 0.2;
	var car, mod;
	mod = SinOsc.ar(modHz, mul:modAmp);
	car = SinOsc.ar(carHz + mod, mul:amp);
	Out.ar(0, car);
}).add;
)
Synth(\simpleFm, [\carHz, 500, \modHz, 2000, \modAmp, 400]);

/*
Let modulator and carrier be expressed as ratio related
to a fundamental freq
*/
(
SynthDef.new(\ratioFm, {
	arg freq = 500, mRatio=1, cRatio=1, modAmp=200, amp = 0.2;
	var car, mod;
	mod = SinOsc.ar(freq * mRatio, mul:modAmp);
	car = SinOsc.ar((freq * cRatio) + mod, mul:amp);
	Out.ar(0, car);
}).add;
)
Synth(\ratioFm, [\freq, 110, \cRatio, 1, \mRatio, 2]);

/*
Index of modulation
Proportional to modulator amplitude
index of modulation
index = modAmp / modHz
Number of audiable sidebands roughly equal to index + 1

*/

(
SynthDef.new(\indexFm, {
	arg freq = 500, mRatio=1, cRatio=1, index=1, amp = 0.2;
	var car, mod;
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * index);
	car = SinOsc.ar((freq * cRatio) + mod, mul:amp);
	Out.ar(0, car);
}).add;
)
Synth(\indexFm, [\freq, 110, \cRatio, 1, \mRatio, 2, \index, 10]);

/*
Second modulator that modulates the the first modulator
*/
(
SynthDef.new(\twoModFm, {
	arg freq = 500, m1Ratio=1, m2Ratio=1, cRatio=1, index1=1, index2=1, amp = 0.2;
	var car, mod1, mod2;

	mod1 = SinOsc.ar(freq * m1Ratio, mul:freq * m1Ratio * index1);
	mod2 = SinOsc.ar((freq * m2Ratio) + mod1, mul:freq * m2Ratio * index2);
	car = SinOsc.ar((freq * cRatio) + mod2, mul:amp);
	Out.ar(0, car);
}).add;
)
Synth(\twoModFm, [\freq, 110, \cRatio, 1, \m1Ratio, 1.51, \index1, 3, \m2Ratio, 1, \index2, 10]);


/*
The idea is to allow the ordinary osc instruments to be allowed to be modulated. Even nested. This should be
possible with the current instruments.
But,
1) perhaps we need the incomoning freq and amp signals to be at audio rate
2) we need a set of control signals at audio rate
3) we need a way to combine audio rate signals, especially sum

For shaping different ground curves.
1) Open up so you can set the shape on basic shapes via lincurve curve attribute. E.g LFTri.ar(40).lincurve(-1, 1, -1, 1, Line.ar(3, -3, 5))
2) Open up so you can change the width of the pulse. E.g Pulse.ar(freq:30, width:Line.kr(0, 1, 10))

*/


/*
Ring modulate and am modulate
https://composerprogrammer.com/teaching/supercollider/sctutorial/2.4%20Modulation%20Synthesis.html

Ring modulate is a straight multiplication of two signals. We end up with the sum and the difference of the two signals
*/
(
SynthDef.new(\ringMod, {
	arg carrFreq, modFreq;
	var carr, mod;
	carr = SinOsc.ar(freq:carrFreq, mul:0.5);
	mod = SinOsc.ar(freq:modFreq, mul:0.5);
	Out.ar(0, carr * mod);
}).add;
)
Synth(\ringMod, [\carrFreq, 220, \modFreq, 880]);

/*
In Am Modulate the modulator is always positive. We end up with the sum and the difference + the two original signals
*/
(
SynthDef.new(\amMod, {
	arg carrFreq, modFreq;
	var carr, mod;
	carr = SinOsc.ar(freq:carrFreq, mul:0.5);
	mod = SinOsc.ar(freq:modFreq, mul:0.25, add:0.25);
	Out.ar(0, carr * mod);
}).add;
)
Synth(\amMod, [\carrFreq, 220, \modFreq, 110]);

/*
[ "/s_new", "sineControl", -1, 0, 1004, "out", 72, "dur", 2, "startValue", 0, "peakValue", 0.370079 ],
  [ "/s_new", "signalSum", -1, 0, 1004, "out", 73, "dur", 2, "in1", 74, "in2", 75 ],
  [ "/s_new", "staticControl", -1, 0, 1004, "out", 74, "dur", 2, "value", 150 ],
  [ "/s_new", "staticControl", -1, 0, 1004, "out", 76, "dur", 2, "value", 500 ],
  [ "/s_new", "staticControl", -1, 0, 1004, "out", 77, "dur", 2, "value", 40 ],
  [ "/s_new", "staticControl", -1, 0, 1004, "out", 78, "dur", 2, "value", 0 ],
  [ "/s_new", "sineOsc", -1, 3, 1004, "out", 75, "dur", 2, "freqBus", 77, "ampBus", 76 ],
  [ "/s_new", "sineOsc", -1, 1, 1004, "out", 79, "dur", 2, "freqBus", 73, "ampBus", 72 ],
  [ "/s_new", "pan", -1, 1, 1004, "out", 0, "dur", 2, "in", 79, "panBus", 78 ]
*/


// Basic FM synth
(
// car_amp
Synth(\sineControl, [\out, 64, \dur, 2, \startValue, 0, \peakValue, 0.5]);
// car_freq
Synth(\staticControl, [\out, 65, \dur, 2, \value, 55]);
// mod_amp
Synth(\staticControl, [\out, 66, \dur, 2, \value, 1000]);
// mod_freq
Synth(\staticControl, [\out, 67, \dur, 2, \value, 450]);
// mod
Synth(\sineOsc, [\out, 68, \dur, 2, \freqBus, 67, \ampBus, 66], addAction:\addToTail);
// fm_mod
Synth(\signalSum, [\out, 69, \dur, 2, \in1, 68, \in2, 65], addAction:\addToTail);
// signal
Synth(\sineOsc, [\out, 0, \dur, 2, \freqBus, 69, \ampBus, 64], addAction:\addToTail);
)



