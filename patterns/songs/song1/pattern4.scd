
~bpm = (60/120)*4;
a = Scale.melodicMinor;
~synth = "tone5";

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
		\pattern4,
		Pbind(
			\instrument, ~synth,
			\bend, ~bend.linlin(0,16383,-2,2),
			\scale, a,
			\degree, Pseq((0..3), inf),
			\root, -20,
			\out, 0,
			\amp, Pexprand(0.02, 0.2, inf),
			\gate, 1,
			\mod_freq, 2000,
			\mod_amp, 300,
			\lpf_cutoff, 20000, 
			\hpf_cutoff, 100,
			\attack, Pexprand(0.01, 0.03, inf), 
			\decay, 0.1, 
			\sustain, 0.1,
			\release, 0.1,
			\bias, 0.0,
			\lin_start, 500, 
			\lin_stop, 1,
			\lin_duration, 0.2,
			\dur, Pseq([1/8, Rest(1/16), 1/16, 1/8, 1/8, 1/16, 1/8, Rest(1/16)], inf),
			\stretch, ~bpm,
		);
	).quant_(~bpm);

	case
		{msg[1] == "playerSel".asSymbol} {
			if (msg[2] == "start".asSymbol) {
				Pdef('\pattern4').play;
			};
			if (msg[2] == "stop".asSymbol) {
				Pdef('\pattern4').stop;
			};
		}

}, '/pattern4').add;


