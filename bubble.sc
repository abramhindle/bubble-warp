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
		/* frames = buf.numFrames; */
		/* myrate = 1.0*rate; */
		/* [rate*1.0,rate*1.0]; */
		/* trigger = Impulse.kr(rate); */
		/* frames*Line.kr(0,1,10)) * */
		amp * myvol * PlayBuf.ar(1, buf, rate, 1, 0, looping, 2); 
	/* * EnvGen.kr(Env.linen(0.01,0.96,0.01), trigger) * rate; */
	}.play();
};

SynthDef(\splayer, {
	arg buf, out=0, rate=1.0, looping=0, amp=1.0 ;
	var myrate, trigger, frames, myvol, bal;
	bal = {
		var y = 1.0.rand;
		[1.0 - y, y]
	};
	Out.ar(0,
		PlayBuf.ar(1, buf, 1, 1, 0, 0, 2)
	);
}).add;
Synth(\splayer,[\buf,~pops.choose]);

SynthDef(\splayer, {
	arg buf, out=0, rate=1.0, looping=0, amp=1.0 ;
	var myrate, trigger, frames, myvol, bal;
	bal = {
		var y = 1.0.rand;
		[1.0 - y, y]
	};
	myvol = bal.(); 
	/* frames = buf.numFrames; */
		/* myrate = 1.0*rate; */
		/* [rate*1.0,rate*1.0]; */
		/* trigger = Impulse.kr(rate); */
		/* frames*Line.kr(0,1,10)) * */
		/* * EnvGen.kr(Env.linen(0.01,0.96,0.01), trigger) * rate; */
	Out.ar(0,
		amp * myvol * PlayBuf.ar(1, buf, rate, 1, 0, looping, 2)
	);
}).add;

~splayer.(buf: ~crinkles.choose);
fork {
	100.do{~splayer.(buf: ~pops.choose); 0.05.wait;};
};
~splayer.(buf: ~scratches.choose, rate: 0.9 + (0.5.rand));
~splayer.(buf: ~scratches.choose, looping: 1, rate: 0.9 + (0.5.rand));
~splayer.(buf: ~crinkles.choose, looping: 1, rate: 0.9 + (0.5.rand));

~silences.do{|silence| 
	~splayer.(buf: silence, rate: 0.3+1.0.rand, looping: 1);
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
  ~loopall.( ~silences, {|x| ~splayer.(buf: x, rate: 0.3+1.0.rand) });
}
~loopall.( ~crinkles, {|x| ~splayer.(buf: x, rate: 0.3+1.0.rand) });
~loopall.( ~scratches, {|x| ~splayer.(buf: x, rate: 0.3+1.0.rand) });
~loopall.( ~pops, {|x| ~splayer.(buf: x, rate: 0.3+1.0.rand) });

4.do{
	Routine {
		0.1.rand.wait;
		loop {
			~splayer.(buf: (~silences).choose, rate: 0.3+1.0.rand).waitForFree;
		}
	}.play;
};
/* ~splayer.(buf: ~silences.choose, rate: 0.9 + (0.2.rand), looping: 1); */
/* pop osc responder */
