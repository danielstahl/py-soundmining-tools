(
var server, score;

server = Server(\nrt,
    options: ServerOptions.new
	.sampleRate_(96000)
    .numOutputBusChannels_(36)
	.maxNodes_(4096)
	.memSize_(2.pow(20))
    .numInputBusChannels_(2));

score = Score.newFromFile("/Users/danielstahl/Documents/Music/Pieces/Concrete Music/Concrete Music 11/sc/concrete-music-11/concrete_music_11/concrete-music-11-v2.txt");

score.recordNRT(
    outputFilePath: "/Users/danielstahl/Documents/Music/Pieces/Concrete Music/Concrete Music 11/stage/concreteMusci11Score_v2.caf".standardizePath,
    headerFormat: "CAF",
    sampleFormat: "float",
    options: server.options,
	duration: 400,
    action: { "done".postln }
);

server.remove;
)


(
var server, score;

server = Server(\nrt,
    options: ServerOptions.new
	.sampleRate_(96000)
    .numOutputBusChannels_(60)
	.maxNodes_(4096)
	.memSize_(2.pow(20))
    .numInputBusChannels_(2));

score = Score.newFromFile("/Users/danielstahl/Documents/Music/Pieces/Concrete Music/Concrete Music 11/sc/concrete-music-11/concrete_music_11/concrete-music-12-v1.txt");

score.recordNRT(
    outputFilePath: "/Users/danielstahl/Documents/Music/Pieces/Concrete Music/Concrete Music 11/stage/concreteMusci12Score_v1.caf".standardizePath,
    headerFormat: "CAF",
    sampleFormat: "float",
    options: server.options,
	duration: 560,
    action: { "done".postln }
);

server.remove;
)