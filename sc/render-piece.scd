(
var server, score;

server = Server(\nrt,
    options: ServerOptions.new
	.sampleRate_(96000)
    .numOutputBusChannels_(36)
	.maxNodes_(4096)
    .numInputBusChannels_(2));

score = Score.newFromFile("/Users/danielstahl/Documents/Music/Pieces/Ambient Music/Ambient Music 7/sc/ambient-music-7/ambientMusic7.txt");

score.recordNRT(
    outputFilePath: "/Users/danielstahl/Documents/Music/Pieces/Ambient Music/Ambient Music 7/stage/ambientMusic7Score.caf".standardizePath,
    headerFormat: "CAF",
    sampleFormat: "float",
    options: server.options,
	duration: 300,
    action: { "done".postln }
);

server.remove;
)