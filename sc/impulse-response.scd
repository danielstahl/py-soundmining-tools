

(
~fftsize = 2048;
~loadIr = {
	arg irPath, convIrPath;
	irPath.filesDo({
		arg path;
		var convPathL, convPathR, fullPath;
		fullPath = path.fullPath;
		convPathL = convIrPath.fullPath +/+ path.fileNameWithoutExtension ++ "-L." ++ path.extension;
		convPathR = convIrPath.fullPath +/+ path.fileNameWithoutExtension ++ "-R." ++ path.extension;
		fullPath.postln;
		s.waitForBoot {
			var irbufferL, irbufferR, bufsizeL, bufsizeR, irspectrumL, irspectrumR;

			irbufferL = Buffer.readChannel(s, fullPath, channels:[0]);
			irbufferR = Buffer.readChannel(s, fullPath, channels:[1]);
			s.sync;
			bufsizeL = PartConv.calcBufSize(~fftsize, irbufferL);
			bufsizeR = PartConv.calcBufSize(~fftsize, irbufferR);

			irspectrumL = Buffer.alloc(s, bufsizeL, 1);
			irspectrumL.preparePartConv(irbufferL, ~fftsize);
			irspectrumR = Buffer.alloc(s, bufsizeR, 1);
			irspectrumR.preparePartConv(irbufferR, ~fftsize);
			s.sync;
			irbufferL.free;
			irbufferR.free;
			irspectrumL.write(convPathL, "wav", "int24");
			irspectrumR.write(convPathR, "wav", "int24");
			irspectrumL.free;
			irspectrumR.free;
		}
	});
};

~irPath = PathName.new("/Users/danielstahl/Documents/Music/impulse-response/ir");
~convIrPath = PathName.new("/Users/danielstahl/Documents/Music/impulse-response/convolution-ir");

~loadIr.value(~irPath, ~convIrPath);
)


(
~fftsize = 2048;
~irL = Buffer.read(s, "/Users/danielstahl/Documents/Music/impulse-response/convolution-ir/CarpenterCenter-L.wav");
~irR = Buffer.read(s, "/Users/danielstahl/Documents/Music/impulse-response/convolution-ir/CarpenterCenter-R.wav");

{
	var input = Pan2.ar(Impulse.ar(0.4, mul:1), Line.kr(-1, 1, 10));
	[PartConv.ar(input[0], ~fftsize, ~irL.bufnum, 0.5), PartConv.ar(input[1], ~fftsize, ~irR.bufnum, 0.5)]
}.play
)



"Hello" ++ "World"