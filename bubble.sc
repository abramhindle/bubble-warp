s.options.memSize = 650000;
s.boot;
s.scope;

s.doWhenBooted({


	~bal = {
		var y = 1.0.rand;
		[1.0 - y, y]
	};
	SynthDef(\splayer, {
		arg buf, out=0, rate=1.0, looping=0, amp=1.0, myvol=[0.5,0.5];
		var myrate, trigger, frames,y;
		Out.ar(0,
			myvol * [amp,amp] * PlayBuf.ar(1, buf, [rate,rate], 1, 0, looping, 2)
		);
	}).add;
	s.sync;
	~crinkles = "./wavs/crinkle*wav".pathMatch.collect({arg path; Buffer.read(s,path)});
	~pops = "./wavs/pop*wav".pathMatch.collect({arg path; Buffer.read(s,path)});
	~scratches = "./wavs/scratch-*wav".pathMatch.collect({arg path; Buffer.read(s,path)});
	~silences = "./wavs/silence*wav".pathMatch.collect({arg path; Buffer.read(s,path)});
	
	
	
	
	~splayer = {
		arg buf, rate=1.0, looping=0, amp=1.0;
		{
			var myrate, trigger, frames, myvol;
			myvol = ~bal.(); 
			amp * myvol * PlayBuf.ar(1, buf, rate, 1, 0, looping, 2); 
		}.play();
	};
	
	~since = {
		arg since=10000.0;
		var amp = log(1.0+(abs(1000.0.min(since))))/log(1.0+10000.0);
		amp
	};
	


	~popf = {
		var myvol = ~bal.();
		Synth(\splayer,[\buf,~pops.choose,\myvol,myvol]);
	};
	~scratchf = {
		arg since=1000;
		var amp = 1.0.min(2.0 * (~since.(since))), myvol = ~bal.();
		Synth(\splayer,[buf: ~scratches.choose, rate: 0.9 + (0.3.rand), amp: amp, myvol: myvol ]);
	};
	
	~crinklef = {
		arg since=1000;
		var amp = ~since.(since), myvol = ~bal.();
		Synth(\splayer,[buf: ~crinkles.choose, rate: 0.9 + (0.5.rand), amp: 0.5*amp, myvol: myvol]);
	};
	
	~popexplosion = {
		Routine {
			fork {
				1000.do{
					Synth(\splayer,[\buf, ~pops.choose, \myvol: (~bal.())]); 0.05.wait;
				};
			};
		}.play();
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

/*
~loopall.( ~crinkles, {|x| Synth(\splayer,[buf: x, rate: 0.3+1.0.rand]) });
~loopall.( ~scratches, {|x| Synth(\splayer,[buf: x, rate: 0.3+1.0.rand]) });
~loopall.( ~pops, {|x| Synth(\splayer,[buf: x, rate: 0.3+1.0.rand]) });
*/

/* it's all good brah */

/* pop osc responder */
    o = ();
    o.n = NetAddr("127.0.0.1", 57120); 
    o.o = OSCresponderNode(n, '/chat', { |t, r, msg| ("time:" + t).postln; msg[1].postln }).add;
    o.m = NetAddr("127.0.0.1", 57120); // the url should be the one of computer of app 1
    o.m.sendMsg("/chat", "Hello App 1");
    o.m.sendBundle(2.0, ["/chat", "Hello App 1"], ["/chat", "Hallo Wurld"]);
    o.m.sendBundle(0.0, ["/chat", "Hello App 1"], ["/chat", "Hallo Wurld"]);
    o.pops = OSCresponderNode(n, '/pop', 
    	{ arg t, r, msg;		
    		~popf.();
    	}
    ).add;
    o.scratch = OSCresponderNode(n, '/scratch',
    	{ arg t, r, msg;
    		var since = msg[3];
    		since.postln;
    		~scratchf.(since: since);
    	}
    ).add;
    o.crinkle = OSCresponderNode(n, '/crinkle',
    	{ arg t, r, msg;
    		var since = msg[3];
    		since.postln;
    		~crinklef.(since: since);
    	}
    ).add;
    
    o.m.sendBundle(0.0, ["/scratch"], ["/scratch"], ["/scratch"]  );
    o.m.sendBundle(0.0, ["/crinkle"], ["/crinkle"], ["/crinkle"]  );
    o.m.sendBundle(0.0, ["/pop"], ["/pop"], ["/pop"]  );
    
    o.m.sendBundle(0.0, ["/scratch",10,20,100]);
    
    /* o.m.remove; */
    
    /*
    
    o.scratch.remove;
    o.crinkle.remove;
    o.pops.remove;
    
    
    */
    
    
    
    /* eval this at the start of the performance */
    
    
    
    
    4.do {
      ~loopall.( ~silences, {|x| Synth(\splayer,[buf: x, rate: 0.3+1.0.rand, myvol: ~bal.()]); });
    };
    
    
    
    // Change this to 840
    r = Routine {
        780.0.wait;
        "Splotion".postln;
        ~popexplosion.().yield;
    }.play;
    
    fork {
        loop {
            30.0.rand.wait;
    		~crinklef.();
    	}
    };
    
    /* [X] make osc webservice */
    /* [X] make UI */
    /* [X] improve graphics */
    /* [ ] make Video */
    /* [ ] Burn DVD */
    /* [ ] Test Network */
    /* */
    
    
});    
