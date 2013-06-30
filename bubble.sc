s.boot;
s.scope;
~crinkles = "./wavs/crinkle*wav".pathMatch.collect({arg path; Buffer.read(s,path)});
~pops = "./wavs/pop*wav".pathMatch.collect({arg path; Buffer.read(s,path)});
~scratches = "./wavs/scratch-*wav".pathMatch.collect({arg path; Buffer.read(s,path)});
~silences = "./wavs/silence*wav".pathMatch.collect({arg path; Buffer.read(s,path)});

~bal = {
	var y = 1.0.rand;
	[1.0 - y, y]
};

~splayer = {
	arg buf, rate=1.0, looping=0, amp=1.0;
	{
		var myrate, trigger, frames, myvol;
		myvol = ~bal.(); 
		amp * myvol * PlayBuf.ar(1, buf, rate, 1, 0, looping, 2); 
	}.play();
};

SynthDef(\splayer, {
	arg buf, out=0, rate=1.0, looping=0, amp=1.0 ;
	var myrate, trigger, frames, myvol, bal;
	bal = {
		var y = 1.0.rand;
		[1.0 - y, y]
	};
	myvol = bal.(); 
	Out.ar(0,
		amp * myvol * PlayBuf.ar(1, buf, rate, 1, 0, looping, 2)
	);
}).add;
Synth(\splayer,[\buf,~pops.choose]);


Synth(\splayer,[\buf, ~crinkles.choose]);
fork {
	100.do{Synth(\splayer,[\buf, ~pops.choose]); 0.05.wait;};
};
Synth(\splayer,[buf: ~scratches.choose, rate: 0.9 + (0.5.rand)]);
Synth(\splayer,[buf: ~scratches.choose, looping: 1, rate: 0.9 + (0.5.rand)]);
Synth(\splayer,[buf: ~crinkles.choose, looping: 1, rate: 0.9 + (0.5.rand)]);

~silences.do{|silence| 
	Synth(\splayer,[buf: silence, rate: 0.3+1.0.rand, looping: 1]);
};

~loopall = {
	arg vals, f, waittime=0.1;
	Routine {
		waittime.rand.wait;
		loop {
			f.(vals.choose).waitForFree;
		}
	}.play;
};

4.do {
  ~loopall.( ~silences, {|x| Synth(\splayer,[buf: x, rate: 0.3+1.0.rand]); });
}
~loopall.( ~crinkles, {|x| Synth(\splayer,[buf: x, rate: 0.3+1.0.rand]) });
~loopall.( ~scratches, {|x| Synth(\splayer,[buf: x, rate: 0.3+1.0.rand]) });
~loopall.( ~pops, {|x| Synth(\splayer,[buf: x, rate: 0.3+1.0.rand]) });

/* pop osc responder */
