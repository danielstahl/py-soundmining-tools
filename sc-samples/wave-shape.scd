// Change the curvature of, for instance Triangle and Sine
{ LFTri.ar(40).lincurve(-1, 1, -1, 1, Line.ar(3, -3, 5)) }.play;
{ SinOsc.ar(40).lincurve(-1, 1, -1, 1, Line.ar(3, -3, 5))}.play;


// The width of the pulse between 0 and 1. 0.5 is the default and defines a sqare wave
{ Pulse.ar(freq:30, width:Line.kr(0, 1, 10)) * 0.1}.play;

// LFPar
{ SinOsc.ar(55)}.play;
{ LFPar.ar(55)}.play;
{ LFTri.ar(55)}.play;
{ LFSaw.ar(55)}.play;
{ Pulse.ar(55)}.play;

