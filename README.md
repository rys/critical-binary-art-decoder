# Introduction

Critical Recordings have a set of releases prefixed Binary, with some cool artwork.

For example: https://static.databeats.com/img/binary/BINARY003.jpg

Given the name, it was pretty obvious that it was probably a binary encoding of some kind. A bit of counting of the dots showed that it was probably 8-bit with the leading bit 0, which strongly hinted at 7-bit ASCII in a 32x32 grid, assuming black is 0 and a colour of any kind is 1.

So, we need a decoder!

# critical.rb

Basically:

* Read image (which we cheat and normalise in the wrapper to 768x768, because Critical's first couple of images are 1000x1000)
* Compute some offsets and widths
* Take a couple of samples in the pixel area and if they're both above a brightness threshold, emit a 1, else emit a 0
* Create a string to hold the bits. It's a string because Ruby string slicing is easy!
* Walk down and along the image (assuming left-to-right, top-to-bottom worked out well)
* Print out the decoded ASCII

# decode

A wrapper to call `critical.rb`. Basically:

* For the EPs we know about
* Fetch the JPG
* Convert to PNG
* Decode

# Requirements

* `gem install chunky_png`
* `brew install imagemagick`

# Brightness thresholding

Because of JPEG decompression, black in the original JPEGs sometimes isn't actual RGB(0,0,0) black. This broke my decoder for ages until I had a good look at pixel values. Now it thresholds on brightness instead, based on eyeballing values. Sorry for the magic number!

# Mistakes

A handful of the covers for the releases have off-by-1-ish mistakes:

## BINARY002

```
 Position  ASCII    Binary   Fixed    Binary 
|--------|--------|--------|--------|--------|
|   87   |   `    |01100000|   0    |00110000|
|   88   |   b    |01100010|   2    |00110010|
|--------|--------|--------|--------|--------|
```

First nybble is shifted left by 1 accidentally for both broken characters.

## BINARY003

```
 Position  ASCII    Binary   Fixed    Binary 
|--------|--------|--------|--------|--------|
|   87   |   `    |01100000|   0    |00110000|
|   88   |   c    |01100011|   3    |00110011|
|--------|--------|--------|--------|--------|
```

First nybble is shifted left by 1 accidentally for both broken characters.

## BINARY004

```
 Position  ASCII    Binary   Fixed    Binary 
|--------|--------|--------|--------|--------|
|   43   |   O    |01001111|   /    |00101111|
----------------------------------------------
```

First nybble is shifted left by 1 accidentally for the broken character.

## BINARY015

The 9th character is off by 1 in the ASCII table, giving `BINARY014` again instead of `BINARY015`.

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
BINARY012 / KIRIL / 1>TURN BACK TIME 2>MINIMAL INSTINCT 3>NO FIGHTING 4>RAVE GENERAT 5>ACID ONE
BINARY014 / CRUK / 1>COLD TOP 2>DEVIL AND THE DEEP 3>UNDOING 4>LIT
BINARY014 / KUMARACHI / 1>NG 2>BACK TO YOU 3>DUSK 4>SOMEONE
BINARY016 / T>I / 1>ROTATIONS 2 CRUNCHTIME 3>RIX MILE BOTTOM 4>PACKETS
BINARY017 / STONER / 1>1984 2>PHENOMENON FT.DOTTOR POISON 3>SWEET HOME 4>THERA
BINARY018 / PARTICLE / 1>THE ARRIVAL 0>NEPTUNE 3>SIGNAL 4>TAPE PACK FLEX
BINARY019 / KLIPPEE / 1>TOO TIGHT 2>CACHED 3>HIGH PING
BINARY020 / ABLE / 1>LACURA 2>JUST BECAUSE 3>BE GOOD
BINARY021 / WAEYS / 1>EPHERMERAL 2>MIST 3>WAIS TUNE 4>WAEYS & WAS A BE >BULLYING
```
