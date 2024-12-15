<Cabbage>.
form caption("Untitled") size(400, 300), guiMode("queue"), pluginId("def1")

image bounds(0, 0, 400, 300) channel("image10004") file("IMG_3832.PNG")
keyboard bounds(8, 246, 384, 54) channel("keyboard3") mouseOverKeyColour(00, 115, 210, 255)
rslider bounds(298, 98, 80, 80) channel("cutoff") range(1, 20000, 10000, 1, 0.001) text("CutOff") textColour(255, 255, 255, 255) trackerColour(0, 115, 210, 255)
groupbox bounds(16, 108, 165, 87) channel("groupbox10005") text("Delay") textColour(255, 255, 255, 255) fontColour(255, 255, 255, 255)
rslider bounds(96, 40, 60, 60) channel("reverb") range(0, 1, 0.5, 1, 0.001) text("Reverb") textColour(255, 255, 255, 255) trackerColour(0, 115, 210, 255)
rslider bounds(14, 10, 60, 60) channel("LFO") range(0, 10, 2, 1, 0.001) text("LFO") textColour(255, 255, 255, 255) trackerColour(0, 115, 210, 255)
rslider bounds(32, 130, 60, 60) channel("Time") range(0, 5, 1, 1, 0.001) text("Time") textColour(255, 255, 255, 255) trackerColour(0, 115, 210, 255)
rslider bounds(104, 130, 60, 60) channel("Feedback") range(0, 5, 1, 1, 0.001) text("Feedback") textColour(255, 255, 255, 255) trackerColour(0, 115, 210, 255)
combobox bounds(286, 40, 100, 25), populate("*.snaps"), channelType("string") automatable(0) channel("combo16") value("1")
filebutton bounds(306, 12, 60, 25), text("Save", "Save"), populate("*.snaps", "test"), mode("named preset") channel("filebutton1")
filebutton bounds(306, 68, 60, 25), text("Remove", "Remove"), populate("*.snaps", "test"), mode("remove preset") channel("filebutton2")
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs  = 1

garvbL init 0
garvbR init 0
gadelayL init 0
gadelayR init 0
;gaflangerL init 0
;gaflangerR init 0



ctrlinit 1,21,20, 22,12, 23,10, 24,55, 25,33

instr 1

icps cpsmidi
iamp ampmidi .5

krvb chnget "reverb"
;krvb midic7 24,0,1
;gkFreq = 440

klfo chnget "LFO"
;klfo_freq = 2.8
al lfo 1, klfo, 0


kamp_env linenr 1, 0.1, 1.5, 0.01
kamp = iamp * 0.5 * al * kamp_env

      ;OSC
kOsc1 = icps 
kOsc2 = icps * 1.5
kOsc3 = icps * 2

aosc1 oscil kamp, kOsc1, 1
aosc2 oscil kamp, kOsc2, 1
aoscsub oscil kamp, kOsc3, 1

kResonance midic7 22,0,1;init 0.1
kCutoff chnget "cutoff"
;kCutoff midic7 23,500,1000;init 800

aFiltL moogladder (aosc1 + aosc2 + aoscsub) * kamp, kCutoff, kResonance
aFiltR moogladder (aosc1 + aosc2 + aoscsub) * kamp, kCutoff, kResonance

kpan randh 1, 3 
kpan port kpan, 0.05 

kFlangerDepth init 0.02
kFlangerFreq init 0.2
aFiltL = aFiltL * kpan
aFiltR = aFiltR * (1 - kpan)
    outs aFiltL, aFiltR 

vincr garvbL, aFiltL*krvb
vincr garvbR, aFiltR*krvb
   endin

      ;Reverb
          instr verb
	denorm garvbL, garvbR
aL, aR freeverb garvbL, garvbR, 0.9, 0.4, sr, 0
	outs aL, aR
	clear garvbL, garvbR
	endin 

      ;Delay	
	       instr delay
	denorm gadelayL, gadelayR
	itime init 5
	ifd init 1 ;feedbak
gadelayLrt delay gadelayL, itime
gadelayRrt delay gadelayL, itime	    
 clear gadelayL, gadelayR
   endin 

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
f 1 0 16384 10 1

i "verb" 0 600000
i "delay" 0 100000

e
</CsScore>
</CsoundSynthesizer>
