/*
desc: Simple 4/4 quarter note kick drum at 120 bpm.
author: Omar Barazanji
date: 5/27/2021
*/

~bpm = (60/180)*4;
a = Scale.melodicMinor;


Pdef (
	\pattern2,
	Pbind(
		\instrument, \tone3,
		\scale, a,
		\bend, ~bend.linlin(0,16383,-2,2),
		\degree, Pseq((4..3)++(1..0) ,inf),
		\root,1,
		\out, 0,
		\amp, Pexprand(0.3, 0.4, inf),
		\gate, 1,
		\mod_freq, Pwhite(102, 106, inf),
		\lpf_cutoff, 20000, 
		\hpf_cutoff, 20,
		\attack, Pexprand(0.07, 0.09, inf), 
		\decay, 0.3, 
		\sustain, 0.4,
		\release, 2.2,
		\lin_start, 1000, 
		\lin_stop, 2,
		\lin_duration, 0.1,
		\bias, 0.0,
		\dur, Prand(
			[Pseq([1/4], Prand([4,8,16],1)),
			Pseq([1/6], Prand([3,6,9],1)),
			Pseq([1/8], Prand([4,8,16],1))], inf),
		\stretch, ~bpm,
	);
).quant_(~bpm);

