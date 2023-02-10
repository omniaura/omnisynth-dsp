
~bpm = (60/120)*4;
a = Scale.minor;
~synth = "tone7";

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
		\pattern6,
		Pbind(
			\instrument, ~synth,
			\scale, a,
			\degree, Pseq(([1]), inf), 
			\root, 20,
			\out, 0,
			\amp, Pexprand(0.08, 0.1, inf),
			\gate, 1,
			\mod_freq, Pexprand(5000, 6000, inf),
			\mod_amp, 300,
			\lpf_cutoff, 10000, 
			\hpf_cutoff, 8000,
			\attack, Pexprand(0.01, 0.02, inf), 
			\decay, 0.06, 
			\sustain, 0.02,
			\release, 0.01,
			\lin_start, 19000, 
			\lin_stop, 17000,
			\lin_duration, 0.05,
			\bias, 0.0,
			\dur, Prand([
				Pseq([1/8], 8),
				Pseq([1/32], 8),
				Pseq([1/12], 6),
				], inf),
			\stretch, ~bpm,
		);
	).quant_(~bpm);	
	
	case
		{msg[1] == "setPatternState".asSymbol} {
			if (msg[2] == "start".asSymbol) {
				Pdef('\pattern6').play;
			};
			if (msg[2] == "stop".asSymbol) {
				Pdef('\pattern6').stop;
			};
		}

}, '/pattern6').add;
