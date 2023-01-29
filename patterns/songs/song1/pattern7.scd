~bpm = (60/120)*4;
a = Scale.melodicMinor;
~synth = "tone3";

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
		\pattern7,
		Pbind(
			\instrument, ~synth,
			\scale, a,
			\bend, ~bend.linlin(0,16383,-2,2),
			\degree, Pseq((4..3)++(1..0) ,inf),
			\root, 3,
			\out, 0,
			\amp, Pexprand(0.08, 0.15, inf),
			\gate, 1,
			\mod_freq, Pwhite(102, 106, inf),
			\lpf_cutoff, 20000, 
			\hpf_cutoff, 20,
			\attack, Pexprand(0.07, 0.09, inf), 
			\decay, 0.3, 
			\sustain, 0.4,
			\release, 2.2,
			\lin_start, 100, 
			\lin_stop, 600,
			\lin_duration, 5.0,
			\bias, 0.0,
			\dur, Pseq([1/1], inf),
			\stretch, ~bpm,
		);
	).quant_(~bpm);
	
	case
		{msg[1] == "playerSel".asSymbol} {
			if (msg[2] == "start".asSymbol) {
				Pdef('\pattern7').play;
			};
			if (msg[2] == "stop".asSymbol) {
				Pdef('\pattern7').stop;
			};
		}

}, '/pattern7').add;



