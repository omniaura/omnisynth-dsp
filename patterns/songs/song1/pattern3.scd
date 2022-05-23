~bpm = (60/120)*4;
a = Scale.melodicMinor;
~synth = "tone6";

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
		\pattern3,
		Pbind(
			\instrument, ~synth,
			\scale, a,
			\degree, Pseq((0..2) ++ (7..5), inf), 
			\out, 0,
			\root, 15,
			\amp, Pexprand(0.1, 0.12, inf),
			\gate, 1,
			\mod_freq, Pexprand(1000,3000,inf),
			\mod_amp, 200,
			\lpf_cutoff, 10000, 
			\hpf_cutoff, 200,
			\attack, Pexprand(0.10, 0.20, inf), 
			\decay, 0.3, 
			\sustain, 0.4,
			\release, 0.2,
			\lin_start, 100, 
			\lin_stop, 1,
			\lin_duration, 0.05,
			\bias, 0.0,
			\dur, Prand([
				Pseq([1/16], 32),
				Pseq([1/4],8),
				Pseq([1/12],12)
				], inf),
			\stretch, ~bpm,
		);
	).quant_(~bpm);

	case
		{msg[1] == "playerSel".asSymbol} {
			if (msg[2] == "start".asSymbol) {
				Pdef('\pattern3').play;
			};
			if (msg[2] == "stop".asSymbol) {
				Pdef('\pattern3').stop;
			};
		}

}, '/pattern3').add;



