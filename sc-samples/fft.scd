// https://doc.sccode.org/Guides/FFT-Overview.html

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
(
{
    var in, chain;
    // in = WhiteNoise.ar(0.2);
	in = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
    chain = FFT(LocalBuf(2048), in);
	chain = PV_MagAbove(chain, Line.kr(0, 310, 10));
    IFFT(chain) // inverse FFT
}.play;
)
