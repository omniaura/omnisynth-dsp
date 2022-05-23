/*
desc: Simple 4/4 quarter note kick drum at 120 bpm.
author: Omar Barazanji
date: 5/27/2021
*/

~bpm = (60/120)*4;
a = Scale.melodicMinor;
~synth = "tone2";

o = OSCFunc({

	// arguments to OSCFunc.
	| msg, time, addr, recvPort |
	var temp;
	// post all messages to terminal window.
	[msg, time, addr, recvPort].postln;

	case

		// Parameter adjustment.
		{msg[1] == "paramSel".asSymbol} {
			if (msg[2] == "bpm".asSymbol) {
				~bpm = (60 / msg[3].asInteger) * 4;
			};
			if (msg[2] == "synth".asSymbol) {
				~synth = msg[3].asString;
			};
		}
		

		// base case - set synth to default patch.
		{true} {~synth = ~synth};

	Pdef (
		\pattern5,
		Pbind(
			\instrument, ~synth,
			\bend, ~bend.linlin(0,16383,-2,2),
			\scale, a,
			\degree, Pseq((0..3), inf),
			\root, Pexprand(-90,-50),
			\out, 0,
			\amp, Pexprand(0.01, 0.02, inf),
			\gate, 1,
			\mod_freq, 0,
			\mod_amp, 30,
			\lpf_cutoff, 20000, 
			\hpf_cutoff, 20,
			\attack, Pexprand(0.01, 0.03, inf), 
			\decay, 0.1, 
			\sustain, 0.1,
			\release, 1.0,
			\bias, 0.0,
			\lin_start, 600, 
			\lin_stop, 2,
			\lin_duration, 1.0,
			\dur, Pseq([1/1], inf),
			\stretch, ~bpm,
		);
	).quant_(~bpm);
	case
		{msg[1] == "playerSel".asSymbol} {
			if (msg[2] == "start".asSymbol) {
				Pdef('\pattern5').play;
			};
			if (msg[2] == "stop".asSymbol) {
				Pdef('\pattern5').stop;
			};
		}

}, '/pattern5').add;


