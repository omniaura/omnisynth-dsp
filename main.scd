/*
desc: Main / top level for the Omnisynth.
author: Omar Barazanji
date: 1/16/21
*/

/*
Set server options
*/

p = Server.default.options;

// Set default device to ASIO
// p.device = "ASIO : ASIO4ALL v2";

// Set memSize to 16MB (from 8MB default)
// Only use if you're having memory issues
// p.memSize = 16384;

// Suppress informational messages
// Set this to 0 for more messages,
// Or -2 to suppress error and poll messages
p.verbosity = -1;

// boot server
s.boot;

// Connection to OSC via localhost.
n = NetAddr.new("127.0.0.1", 7771);

// Default patch
~synth = "tone1";

// Set freq to standard Hz
nil.set(\freq, 880);

// Grab any MIDI device plugged in.
MIDIClient.init;
MIDIIn.connectAll;

// Fetch audio devices
~output_devices = ServerOptions.outDevices;

s.doWhenBooted({
	"Booted! Executing boot init logic...".postln;
	~devices_for_messages = List.new(0);
	~output_devices.do({
		arg item, i;
		var out_dev;
		out_dev = [i.asInteger, item.asString];
		~devices_for_messages.add(out_dev);
		// n.sendMsg("/outDev", out_dev[0], out_dev[1]);
		// // wait 5ms before sending the next request
		// // todo: bundle this so we send all at once?
		// (0.005).wait;
	});
	"Sending 'setOutputDevices' message...".postln;
	n.sendMsg("/setOutputDevices", *(~devices_for_messages.asArray));
	"Sending 'superColliderStatus' message...".postln;
	n.sendMsg("/superColliderStatus", "running");
});


// begin main
(

/* OSCFunc called when Python sends "/omni" a message.
 * This function will control the OmniSynth created in Python.
 */
o = OSCFunc( {

	// arguments to OSCFunc.
	| msg, time, addr, recvPort |
	var temp;
	// post all messages to terminal window.
	[msg, time, addr, recvPort].postln;

	case

		// Synth patch selector. Sets the currently active patch
		{msg[1] == "selectPatch".asSymbol} {
			MIDIdef.freeAll;
			msg[2].asString.load;
	    ~synth.postln;
		}

		// Pattern selector. Sets the currently active pattern
		{msg[1] == "selectPattern".asSymbol} {
			MIDIdef.freeAll;
			msg[2].asString.load;
		}

		{msg[1] == "stopScSynth".asSymbol} {
			Server.killAll;
		}

		// compiles all SynthDef's.
		{msg[1] == "compile".asSymbol} {
			msg[2].asString.load;
			MIDIdef.freeAll;
		}

		{msg[1] == "selectOutputDevice".asSymbol} {
			Server.default.options.outDevice_((msg[2].asString));
			Server.default.reboot;
		}

		{msg[1] == "controlPattern".asSymbol} {
			if (msg[2] == "compile".asSymbol) {
				msg[3].asString.load;
			};
		}

		// base case - set synth to default patch.
		{true} {~synth = ~synth};

}, '/omni').add;


) // end main
