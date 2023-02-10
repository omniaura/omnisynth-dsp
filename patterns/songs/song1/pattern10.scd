~bpm = (60/120)*4;
a = Scale.melodicMinor;
~synth = "tone1";

o = OSCFunc({

	// arguments to OSCFunc.
	| msg, time, addr, recvPort |
	var temp;
	// post all messages to terminal window.
	[msg, time, addr, recvPort].postln;

	case

		// Parameter adjustment.
		{msg[1] == "setParam".asSymbol} {
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
		\pattern10,
		Pbind(
			\instrument, ~synth,
			\scale, a,
			\degree, Pseq((4..3)++(1..0) ,inf),
			\root, -16,
			\out, 0,
			\amp, Pexprand(0.03, 0.06, inf),
			\gate, 1,
			\mod_freq, 100,
			\lpf_cutoff, 1200, 
			\hpf_cutoff, 900,
			\attack, Pexprand(0.07, 0.09, inf), 
			\decay, 0.3, 
			\sustain, 0.4,
			\release, 2.2,
			\lin_duration, 2.0,
			\bias, 0.0,
			\dur, Pseq([1/1], inf),
			\stretch, ~bpm,
		);
	).quant_(~bpm);	

	case
		{msg[1] == "setPatternState".asSymbol} {
			if (msg[2] == "start".asSymbol) {
				Pdef('\pattern10').play;
			};
			if (msg[2] == "stop".asSymbol) {
				Pdef('\pattern10').stop;
			};
		}

}, '/pattern10').add;
