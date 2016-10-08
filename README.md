# Notes
Critical Recordings have a set of releases prefixed Binary, with some cool
artwork.

For example: https://static.databeats.com/img/binary/BINARY003.jpg

Given the name, it was pretty obvious that it was probably a binary
encoding of some kind. A bit of counting of the dots showed that it was
probably 8-bit with the leading bit 0, which strongly hinted at 7-bit ASCII in
a 32x32 grid, assuming black is 0 and a colour of any kind is 1.

So, we need a decoder!

# critical.rb

Basically:

* Read image (which we cheat and normalise in the wrapper to 768x768, because Critical's first couple of images are 1000x1000)
* Compute some offsets and widths
* Take a couple of samples and if they're both above a brightness threshold, emit a 1, else emit a 0
* Create a string to hold the bits. It's a string because Ruby string slicing
  is easy!
* Walk down and along the image (assuming left-to-right, top-to-bottom worked
  out well)
* Print out the ASCII

# decode

Basically:

* For the 5 EPs we know about
* Fetch the JPG
* Convert to PNG
* Decode

# Requirements

* gem install chunky\_png
* brew install imagemagick

# Interesting stuff

Because of JPEG decompression or Critical actively trying to thwart automated
decoders, black in the original JPEGs sometimes isn't actual RGB(0,0,0) black.
This broke my decoder for ages until I had a good look at pixel values. Now it
thresholds instead, based on eyeballing values. Sorry for the magic number!

Also, some of the ASCII characters in some of the images seem a bit weird, but
maybe they mean something to Critical. Look at BINARY002 and BINARY003.
I think they got the last 2 characters wrong for those.

# Current output

```
CRITICAL PRESENTS> BINARY / HYROGLIFICS / 1> BAY CITY BALLERS CLUB 2> KILLAMANAMAN 3> MY OWN / CRITDIGI001

CRITICAL PRESENTS> BINARY / KLAX / 1 > HOODRAT 2> CORNERSTONE 3> BLACKBALL / CRITDIGI0`b

CRITICAL PRESENTS> BINARY / BILLAIN / 1>MACULA 2> SUBDUCTION 3> CONFLICTED / CRITDIGI0`c

CRITICAL PRESENTS> BINARY / CURRENT VALUE O 1>DISSONANT 2>DIVISHON 32 3 WHIPLASH 4>PHASELOCK / CRITDIGI004

CRITICAL PRESENTS> BINARY / POSIJ / 1>TECHPLANT 2>SPIN 3>CHANGE 4>ROVER / CRITDIGI005

CRITICAL PRESENTS> BINARY / SUBTENSION / 1>NO WORRIES 2>WHAT DO YOU WANT 3>CAMDEN HYPE 4>FUNK OFF 5>FAIR LADY / CRITDIGI006

CRITICAL PRESENTS> BINARY / SIGNAL / 1>NO WARNJNG 2>JUDGEMENT 3>MOVED ON 4>OMEGA POINT FT. HEAMY & ALLIED / CRITDIGI007

CRITICAL PRESENTS> BINARY / VROMM / 1>LAKE MONSTERS 2> NOMAD 3>MOTOR HELL 4>ZOMBIE / CRITDIGI008

CRITICAL PRESENTS> BINARY / OBEISANT / 1>DREAMCATCHER 2>BASS DROP 3>ON MY MIND 4>TWILIGHT / CRITDIGI009

BINARY010 / MONTY / 1>BREATH IN THE FREQUENCIES 2>DEAD CELLS 3>BRIGHTEN UP 4>THINLINE CONTROL 5>FIRST SKANK THEN TALK

BINARY011 / KIJE / 1>ONCE AGAIN 2>CONECT 3>CRUCIAL MOMENT 4>TRIUMPH
```
