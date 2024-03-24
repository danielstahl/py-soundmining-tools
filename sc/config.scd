(
~customSynthDir = "/Users/danielstahl/Documents/Projects/soundmining-modular/src/main/sc/synths";

~findMidiDevice = {
	arg srcID;
	var device;
	MIDIClient.sources.do({
		arg item, i;
		if(item.uid == srcID, {device = item});
	});
	device
};

~deviceName = {
	arg device;
	device.name ++ ":" ++ device.device
};

~midiBootFunction = {
	var midiReciever;

	MIDIClient.init;
	MIDIIn.connectAll;
	if(MIDIClient.sources.size > 0,
	{
		'Setting up midi'.postln;

		midiReciever = NetAddr("localhost", 57111);

		MIDIdef.noteOn(\noteOn, {
			arg veloc, num, chan, srcID;
			var device, deviceName;
			device = ~findMidiDevice.value(srcID);
			deviceName = ~deviceName.value(device);
			postf("note on % veloc % chan % device %\n", num, veloc, chan, deviceName);
			midiReciever.sendMsg("/noteOn", num, veloc, deviceName);
		});

		MIDIdef.noteOff(\noteOff, {
			arg veloc, num, chan, srcID;
			var device, deviceName;
			device = ~findMidiDevice.value(srcID);
			deviceName = ~deviceName.value(device);
			midiReciever.sendMsg("/noteOff", num, veloc, deviceName);
		});

		MIDIdef.cc(\cc, {
			// 1 = Modulation wheel
			arg value, control, chan, srcID;
			var device, deviceName;
			device = ~findMidiDevice.value(srcID);
			deviceName = ~deviceName.value(device);
			postf("cc value % control % chan % device %\n", value, control, chan, deviceName);
			midiReciever.sendMsg("/cc", value, control, deviceName);
		});

		MIDIdef.bend(\bend, {
			arg value, chan, srcID;
			var device, deviceName;
			device = ~findMidiDevice.value(srcID);
			deviceName = ~deviceName.value(device);
			midiReciever.sendMsg("/bend", value, deviceName);
		});
	},
	{
		'No midi found'.postln;
	})
};

~setupConfig = {
	arg outDevice, numOutputBusChannels;
	s = Server.local;
	s.options.outDevice = outDevice;
	s.options.numOutputBusChannels = numOutputBusChannels;
	s.options.blockSize = 128;
	s.options.sampleRate = 96000;
	s.options.numBuffers = 2056;
	s.options.memSize = 2.pow(20);
	s.dumpOSC(0);
	s.doWhenBooted({
		~midiBootFunction.value;
	});
};
)

// Ordinary config
(
~setupConfig.value("External Headphones", 2);
)
(
~setupConfig.value("Scarlett 2i2 USB", 2);
)