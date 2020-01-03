SndBuf funkyPresident => LPF lpf => dac;
1000 => lpf.freq;
0.3 => lpf.Q;
me.dir() + "/resources/James_Brown_-_Funky_President.Wav" => funkyPresident.read;
funkyPresident.samples() => funkyPresident.pos;

SndBuf arethaSample => HPF hpf => NRev rev => LPF lpf2 => dac;
800 => hpf.freq;
0.3 => hpf.Q;
3000 => lpf2.freq;
1 => lpf2.Q;
rev.mix(0.01);
me.dir() + "/resources/Aretha_Franklin_-_Rock_Steady.wav" => arethaSample.read;
arethaSample.samples() => arethaSample.pos;

SndBuf eno => NRev rev2 => dac;
rev2.mix(0.02);
me.dir() + "/resources/enotalk.wav" => eno.read;
eno.samples() => funkyPresident.pos;

10 => int numSawVoices;
0.0025 => float stdGain;
SawOsc saw[numSawVoices];
LPF sawLPF;
300 => sawLPF.freq;
0.4 => sawLPF.Q;
0.312480::second => dur eighthNote;
for (0 => int i; i < 10; i++) {
    saw[i] => sawLPF => dac;
    0 => saw[i].gain;
}

0.08 => float triGain;
1 => int numTriVoices;
TriOsc tri[numTriVoices];
tri[0] => dac;
0 => tri[0].gain;

dac => WvOut out => blackhole;
me.sourceDir() + "/Eno Beat.wav" => string _capture; 
_capture => out.wavFilename;


spork ~enoTalk();
5.17::second => now;

spork ~updateFilter(sawLPF, 200, 4000, (eighthNote * 64));
spork ~ chords();
spork ~ play(aretha());
spork ~ chords();
spork ~ play(aretha());

spork ~bassline();
spork ~resPerc((eighthNote * 32));
spork ~ drumloop();
spork ~ play(aretha());

spork ~bassline();
spork ~resPerc((eighthNote * 32));
spork ~ drumloop();
spork ~ play(aretha());

spork ~updateFilter(sawLPF, 200, 4000, (eighthNote * 64));
spork ~ chords();
spork ~resPerc((eighthNote * 32));
spork ~ play(aretha());
spork ~ chords();
spork ~bassline();
spork ~resPerc((eighthNote * 32));
spork ~ play(aretha());

300 => sawLPF.freq;
spork ~ drumloop();
spork ~bassline();
spork ~ play(chords());

spork ~resPerc((eighthNote * 32));
spork ~ chords();
spork ~bassline();
spork ~ play(drumloop());

spork ~ play(drumloop());
spork ~ playTri8th(4, [31]);
(4 * eighthNote) => now;

out.closeFile();

fun void enoTalk() {
    trigger(eno, 1, 0.8, 0, eno.length());
}

fun dur drumloop() {
    0.9021 => float pitched;
    funkyPresident.length() / pitched => dur length;
    trigger(funkyPresident, pitched, 1, 0, length);
    trigger(funkyPresident, pitched, 1, 0, length);
    trigger(funkyPresident, pitched, 1, 0, length);
    trigger(funkyPresident, pitched, 1, 0, length / 2);
    trigger(funkyPresident, pitched, 1, 0, length / 4);
    trigger(funkyPresident, pitched, 1, 0, length / 4);
    funkyPresident.samples() => funkyPresident.pos;
    return length;
}

fun dur aretha() {
    0.9 => float pitched;
    0.2 => float veloc;
    arethaSample.length() / pitched => dur length;
    arethaSample.samples() => int total;
    length / 16 => dur quarterNote;
    length / 32 => dur eighth;

    trigger(arethaSample, pitched, veloc, 0, (length / 64) * 3);
    total => arethaSample.pos;
    trigger(arethaSample, pitched, veloc, 0, (length / 64) * 3);
    trigger(arethaSample, pitched, veloc, (total / 16) * 4, length / 16);
    total => arethaSample.pos;
    (3 * eighth) => now;

    trigger(arethaSample, pitched, veloc, 0, (length / 64) * 3);
    total => arethaSample.pos;
    trigger(arethaSample, pitched, veloc, 0, (length / 64) * 3);
    trigger(arethaSample, pitched, veloc, (total / 16) * 4, length / 16);
    total => arethaSample.pos;
    (2 * eighth) => now;
    trigger(arethaSample, pitched, veloc, (total / 32) * 31, length / 32);

    trigger(arethaSample, pitched, veloc, 0, (length / 64) * 3);
    total => arethaSample.pos;
    trigger(arethaSample, pitched, veloc, 0, (length / 64) * 3);
    trigger(arethaSample, pitched, veloc, (total / 16) * 4, length / 16);
    total => arethaSample.pos;
    (3 * eighth) => now;
    
    (3 * eighth) => now;
    total => arethaSample.pos;
    trigger(arethaSample, pitched, veloc, (total / 16) * 4, length / 16);
    total => arethaSample.pos;
    (1 * eighth) => now;
    trigger(arethaSample, pitched, veloc, (total / 32) * 31, length / 32);
    trigger(arethaSample, pitched, veloc, (total / 32) * 31, length / 32);
    
    return length;
}

fun dur chords() {
    dur total;
    playSaw8th(8, [55, 58, 62, 65]) => total;
    playSaw8th(8, [57, 60, 62, 65]) => total;
    playSaw8th(8, [58, 62, 65, 67]) => total;
    playSaw8th(8, [60, 64, 67, 69]) => total;
    return total;
}

fun dur bassline() {
    dur total;
    playTri8th(2, [31]) => total;
    (1.75 * eighthNote) => now;
    playTri8th(3, [31]) => total;
    (1.25 * eighthNote) => now;
    
    playTri8th(2, [33]) => total;
    (1.75 * eighthNote) => now;
    playTri8th(3, [33]) => total;
    (.25 * eighthNote) => now;
    playTri8th(1, [33]) => total;

    playTri8th(2, [34]) => total;
    (1.75 * eighthNote) => now;
    playTri8th(3, [34]) => total;
    (1.25 * eighthNote) => now;

    playTri8th(2, [36]) => total;
    (2 * eighthNote) => now;
    playTri8th(1, [36]) => total;
    (1 * eighthNote) => now;
    playTri8th(1, [34]) => total;
    (1 * eighthNote) => now;
    return total;
}

fun void trigger(SndBuf buf, float pitch, float velocity, int start, dur amount) {
    // set pitch
    pitch => buf.rate;
    // set velocity (really just changing gain here)
    velocity => buf.gain;
    // play from beginning
    start => buf.pos;
    // send sound to dac
    amount => now;
}

fun void play(dur amount) {
    amount => now;
}


fun dur playSaw8th(int duration, int voices[]) {
    // load given notes into saw voices and silence rest
    for (0 => int i; i < numSawVoices; i++) {
        if (i < voices.size()) {  
            Std.mtof(voices[i]) => saw[i].freq;
            stdGain => saw[i].gain;
        }
        else {
            0 => saw[i].gain;
        }
    }
    // play notes for given multiple of eighth notes
    (eighthNote * duration) => now;
    for (0 => int i; i < numSawVoices; i++) {
        0 => saw[i].gain;
    }
    return (eighthNote * duration);
}

fun dur playTri8th(int duration, int voices[]) {
    // load given notes into tri voices and silence rest
    for (0 => int i; i < numTriVoices; i++) {
        if (i < voices.size()) { 
            Std.mtof(voices[i]) => tri[i].freq;
            triGain => tri[i].gain;
        }
        else {
            0 => tri[i].gain;
        }
    }
    // play notes for given multiple of eighth notes
    (eighthNote * duration) => now;
    for (0 => int i; i < numTriVoices; i++) {
        0 => tri[i].gain;
    }
    return (eighthNote * duration);
}



fun void updateFilter(LPF lpf, float min, float max, dur duration) {
    // infinite time loop
    min => float currentFreq;
    max - min => float totalFreqs;
    duration / ms => float totalTime;
    totalFreqs / totalTime => float stepSize;
    while (currentFreq < max) {
        stepSize +=> currentFreq;
        currentFreq => lpf.freq;
        1::ms => now;
    }
}

// adapted from filter lab example 1
fun void resPerc(dur myDur) {
    // noise generator, resonator filter, dac (audio output)
    Noise n => ResonZ f => Pan2 p => dac;

    // set filter Q (how sharp to make resonance)
    100 => f.Q;
    // set filter gain 
    .25 => f.gain;

    0.0 => float t;
    //312.480
    now => time myBeg;
    myBeg + myDur => time myEnd;

    // timeloop
    while (now < myEnd) {
        // sweep the filter resonant frequency
        100.0 + (1 + Math.sin(t)) / 2 * 3000.0 => f.freq;
        Math.sin(t) => p.pan;
        // advance value
        t + 0.00804298514 => t;
        
        
        // advance time
        5::ms => now;
    }
}