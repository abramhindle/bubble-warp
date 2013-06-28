<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
 -odac           -iadc     -d    ;;;RT audio I/O
; -odac           -iadc     -d  -+rtaudio=jack -+jack_client=csoundGrain  -b 441 -B 2048   ;;;RT audio I/O
; For Non-realtime ouput leave only the line below:
; -o grain3.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr	=  44100
kr	=  100
ksmps   =  441
nchnls	=  1

/* f#  time  size  1  filcod  skiptime  format  channel */

;; base 1000 pop 1 35
gijunk ftgen 1001, 0, 0, 1, "pop-10.wav", 0, 0, 0
gijunk ftgen 1002, 0, 0, 1, "pop-11.wav", 0, 0, 0
gijunk ftgen 1003, 0, 0, 1, "pop-12.wav", 0, 0, 0
gijunk ftgen 1004, 0, 0, 1, "pop-13.wav", 0, 0, 0
gijunk ftgen 1005, 0, 0, 1, "pop-14.wav", 0, 0, 0
gijunk ftgen 1006, 0, 0, 1, "pop-15.wav", 0, 0, 0
gijunk ftgen 1007, 0, 0, 1, "pop-16.wav", 0, 0, 0
gijunk ftgen 1008, 0, 0, 1, "pop-17.wav", 0, 0, 0
gijunk ftgen 1009, 0, 0, 1, "pop-18.wav", 0, 0, 0
gijunk ftgen 1010, 0, 0, 1, "pop-19.wav", 0, 0, 0
gijunk ftgen 1011, 0, 0, 1, "pop-20.wav", 0, 0, 0
gijunk ftgen 1012, 0, 0, 1, "pop-21.wav", 0, 0, 0
gijunk ftgen 1013, 0, 0, 1, "pop-22.wav", 0, 0, 0
gijunk ftgen 1014, 0, 0, 1, "pop-23.wav", 0, 0, 0
gijunk ftgen 1015, 0, 0, 1, "pop-24.wav", 0, 0, 0
gijunk ftgen 1016, 0, 0, 1, "pop-25.wav", 0, 0, 0
gijunk ftgen 1017, 0, 0, 1, "pop-26.wav", 0, 0, 0
gijunk ftgen 1018, 0, 0, 1, "pop-27.wav", 0, 0, 0
gijunk ftgen 1019, 0, 0, 1, "pop-28.wav", 0, 0, 0
gijunk ftgen 1020, 0, 0, 1, "pop-29.wav", 0, 0, 0
gijunk ftgen 1021, 0, 0, 1, "pop-2.wav" , 0, 0, 0
gijunk ftgen 1022, 0, 0, 1, "pop-30.wav", 0, 0, 0
gijunk ftgen 1023, 0, 0, 1, "pop-31.wav", 0, 0, 0
gijunk ftgen 1024, 0, 0, 1, "pop-32.wav", 0, 0, 0
gijunk ftgen 1025, 0, 0, 1, "pop-33.wav", 0, 0, 0
gijunk ftgen 1026, 0, 0, 1, "pop-34.wav", 0, 0, 0
gijunk ftgen 1027, 0, 0, 1, "pop-35.wav", 0, 0, 0
gijunk ftgen 1028, 0, 0, 1, "pop-36.wav", 0, 0, 0
gijunk ftgen 1029, 0, 0, 1, "pop-3.wav" , 0, 0, 0
gijunk ftgen 1030, 0, 0, 1, "pop-4.wav" , 0, 0, 0
gijunk ftgen 1031, 0, 0, 1, "pop-5.wav" , 0, 0, 0
gijunk ftgen 1032, 0, 0, 1, "pop-6.wav" , 0, 0, 0
gijunk ftgen 1033, 0, 0, 1, "pop-7.wav" , 0, 0, 0
gijunk ftgen 1034, 0, 0, 1, "pop-8.wav" , 0, 0, 0
gijunk ftgen 1035, 0, 0, 1, "pop-9.wav" , 0, 0, 0
;; base 2000 crinkle 1 to 15
gijunk ftgen 2001, 0, 0, 1, "crinkle-10.wav", 0, 0, 0
gijunk ftgen 2002, 0, 0, 1, "crinkle-11.wav", 0, 0, 0
gijunk ftgen 2003, 0, 0, 1, "crinkle-12.wav", 0, 0, 0
gijunk ftgen 2004, 0, 0, 1, "crinkle-13.wav", 0, 0, 0
gijunk ftgen 2005, 0, 0, 1, "crinkle-14.wav", 0, 0, 0
gijunk ftgen 2006, 0, 0, 1, "crinkle-15.wav", 0, 0, 0
gijunk ftgen 2007, 0, 0, 1, "crinkle-2.wav" , 0, 0, 0
gijunk ftgen 2008, 0, 0, 1, "crinkle-3.wav" , 0, 0, 0
gijunk ftgen 2009, 0, 0, 1, "crinkle-4.wav" , 0, 0, 0
gijunk ftgen 2010, 0, 0, 1, "crinkle-5.wav" , 0, 0, 0
gijunk ftgen 2011, 0, 0, 1, "crinkle-6.wav" , 0, 0, 0
gijunk ftgen 2012, 0, 0, 1, "crinkle-7.wav" , 0, 0, 0
gijunk ftgen 2013, 0, 0, 1, "crinkle-8.wav" , 0, 0, 0
gijunk ftgen 2014, 0, 0, 1, "crinkle-9.wav" , 0, 0, 0
gijunk ftgen 2015, 0, 0, 1, "crinkle.wav"   , 0, 0, 0
;; base 3000 scratch 1 to 10
gijunk ftgen 3002, 0, 0, 1, "scratch.wav", 0, 0, 0
gijunk ftgen 3003, 0, 0, 1, "scratch-2.wav", 0, 0, 0
gijunk ftgen 3004, 0, 0, 1, "scratch-3.wav", 0, 0, 0
gijunk ftgen 3005, 0, 0, 1, "scratch-4.wav", 0, 0, 0
gijunk ftgen 3006, 0, 0, 1, "scratch-5.wav", 0, 0, 0
gijunk ftgen 3007, 0, 0, 1, "scratch-6.wav", 0, 0, 0
gijunk ftgen 3008, 0, 0, 1, "scratch-7.wav", 0, 0, 0
gijunk ftgen 3009, 0, 0, 1, "scratch-8.wav", 0, 0, 0
gijunk ftgen 3010, 0, 0, 1, "scratch-9.wav", 0, 0, 0


/* Bartlett window */
itmp	ftgen 1, 0, 16384, 20, 3, 1
/* sawtooth wave */
itmp	ftgen 2, 0, 16384, 7, 1, 16384, -1
/* sine */
itmp	ftgen 4, 0, 1024, 10, 1

	instr 1
	idur = p3
	iamp = p4
        ifn  = p5
;;;asig flooper2 kamp, kpitch, kloopstart, kloopend, kcrossfade, ifn 
;;;      [, istart, imode, ifenv, iskip]
asig	flooper2 iamp, 1, 0, 10, 0.05, ifn
	out	asig
	endin
</CsInstruments>
<CsScore>

;f 0 3600
i1 0 5 16000 3002
i1 5 5 16000 3003
i1 10 5 16000 3004

</CsScore>
</CsoundSynthesizer>
