SndBuf buf => Gain g => dac;
me.arg(0) => buf.read;
1 => buf.loop;
0.5 => g.gain;

while( true )
{
    1::samp => now;
}
