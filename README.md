# gms-lzw #

A simple LZW compressor and decompressor in Game Maker: Studio

I felt like implementing some kind of compression algorithm in GMS. Since LZW is **really** simple, it was an excellent candidate. 

The algorithm's code itself is simple, and already contained in two scripts. The fun part is, having an async version, 
which spreads the job over multiple steps. 

This is also the groundwork for some more, juicier features, which I will reveal soon... 

## Limitations ## 

So far, only buffers are encoded, so you have to load the whole file into memory. Because no fucks given, that's why. 

Also, the compressor reads single bytes, and outputs two-byte values. This is fixed. The easy 'fix' is to make datatypes arbitrary 
( for example read u16's and output u32's and that's really the only other option ). The tougher one is to write some functions 
that save a number in x bits, so we can for example read u8's and output u12's. This would probably result in better compression 
ratios, but this feature is really secondary. I already get pretty good compression ratios ( a bit worse than PNG's, and it 
doesn't even do the preprocess step like PNG does )
