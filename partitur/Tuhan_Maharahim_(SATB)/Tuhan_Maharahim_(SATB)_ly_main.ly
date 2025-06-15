\version "2.25.26"

Global = {
  \numericTimeSignature
  \time 4/4
  \omit KeySignature
  \key bes \major
  \once \override Score.MetronomeMark.X-offset = #1.5
  \tempo \markup {
    \concat {
      \rhythm { 8.[ 16] } " = " \rhythm { \tuplet 3/2 { 4 8 } }
      "  "
    }
  } 4 = 100
  \set Score.currentBarNumber = #0
  \tag #'notangka { \disallowPageBreak }
  \partial 4
  s1
}

SopranoMusic = {
  % \set Staff.instrumentName = #"S/T"
  %   \set Staff.shortInstrumentName = #"S/T"
  \numericTimeSignature
  \time 4/4
  \key bes \major
  \partial 4
  r8
  \set stemRightBeamCount = #2
  r16 f''16 |
  f''8.  f''16  f''8.  es''16  d''8.
  f''16  bes''8.  c'''16 | % 3
  d'''8.  d'''16  d'''8.  c'''16
  bes''4
  bes''8.  a''16 | % 4
  g''8.  g''16  g''8.  a''16  bes''8.
  a''16  bes''8.  g''16 | % 5
  f''8.  g''16  f''8.  d''16  f''4
  r8
  \set stemRightBeamCount = #2
  r16 f''16 | % 6
  f''8.  f''16  f''8.  es''16  d''8.
  f''16  bes''8.  c'''16 | % 7
  d'''8.  d'''16  d'''8.  c'''16
  bes''4
  bes''4 | % 8
  c'''4  c'''4  bes''4  a''4 | % 9
  bes''2. r4
  \bar "||" \break
  f''4..  es''16  d''8.  f''16  bes''8.
  c'''16 | % 11
  d'''2  bes''2 | % 12
  g''4..  a''16  bes''8.  a''16  bes''8.
  g''16 | % 13
  f''2  d''2 | % 14
  \break
  f''4..  es''16  d''8.  f''16  bes''8.
  c'''16 | % 15
  \noBreak
  d'''2  bes''4  bes''4 | % 16
  \noBreak
  c'''4  c'''4  bes''4  a''4 | % 17
  \noBreak
  bes''2. \bar "|."
}

AltoMusic = {
  \numericTimeSignature
  \time 4/4
  \key bes \major
  \partial 4
  r8[ \set stemRightBeamCount = #2
  r16 d''16] | % 2
  d''8.  d''16  d''8.  c''16  bes'8.
  c''16  d''8.  es''16 | % 3
  f''8.  f''16  f''8.  es''16  d''4
  d''8.  d''16 | % 4
  es''8.  es''16  es''8.  f''16  g''8.
  f''16  g''8.  es''16 | % 5
  d''8.  es''16  d''8.  bes'16  d''4 r8
  \set stemRightBeamCount = #2 r16
  d''16 | % 6
  d''8.  d''16  d''8.  c''16  bes'8.
  c''16  d''8.  es''16 | % 7
  f''8.  f''16  f''8.  es''16
  d''4 f''4 | % 8
  g''4  g''4  f''4  es''4 | % 9
  d''2. r4 \bar "||"
  d''4..  c''16  bes'8.  c''16  d''8.
  es''16 | % 11
  f''2  d''2 | % 12
  es''4..  f''16  g''8.  f''16  g''8.
  es''16 | % 13
  d''2  bes'2 | % 14
  c''4..  c''16  bes'8.  c''16  d''8.
  d''16 | % 15
  e''4 (  fis''4 )  g''4  f''4 | % 16
  g''4  g''4  f''4  f''4 | % 17
  f''2. \bar "|."
}

TenorMusic = {
  \numericTimeSignature
  \time 4/4
  \key bes \major
  \partial 4
  r8
  \set stemRightBeamCount = #2
  r16 f'16 |
  f'8.  f'16  f'8.  es'16  d'8.
  f'16  bes'8.  c''16 | % 3
  d''8.  d''16  d''8.  c''16
  bes'4
  bes'8.  a'16 | % 4
  g'8.  g'16  g'8.  a'16  bes'8.
  a'16  bes'8.  g'16 | % 5
  f'8.  g'16  f'8.  d'16  f'4
  r8
  \set stemRightBeamCount = #2
  r16 f'16 | % 6
  f'8.  f'16  f'8.  es'16  d'8.
  f'16  bes'8.  c''16 | % 7
  d''8.  d''16  d''8.  c''16
  bes'4
  bes'4 | % 8
  c''4  c''4  bes'4  a'4 | % 9
  bes'2. r4
  \bar "||" \break
  bes'4..  bes'16  f'8.  f'16  f'8.
  f'16 | % 11
  bes'2  f'2 | % 12
  bes'4..  c''16  bes'8.  a'16
  bes'8.  c''16 | % 13
  bes'2  f'2 | % 14
  f'4..  f'16  f'8.  f'16  f'8.
  f'16 | % 15
  g'4 (  a'4 )  bes'4  d''4 | % 16
  es''4  es''4  d''4  c''4 | % 17
  d'2. \bar "|."
}

BassMusic = {
  \numericTimeSignature
  \time 4/4
  \key bes \major
  \partial 4
  r8[ \set stemRightBeamCount = #2
  r16 d''16] | % 2
  d''8.  d''16  d''8.  c''16  bes'8.
  c''16  d''8.  es''16 | % 3
  f''8.  f''16  f''8.  es''16  d''4
  d''8.  d''16 | % 4
  es''8.  es''16  es''8.  f''16  g''8.
  f''16  g''8.  es''16 | % 5
  d''8.  es''16  d''8.  bes'16  d''4 r8
  \set stemRightBeamCount = #2 r16
  d''16 | % 6
  d''8.  d''16  d''8.  c''16  bes'8.
  c''16  d''8.  es''16 | % 7
  f''8.  f''16  f''8.  es''16
  d''4 f''4 | % 8
  g''4  g''4  f''4  es''4 | % 9
  d''2. r4 \bar "||"
  bes4..  bes16  f'8.  es'16  d'8.
  c'16 | % 11
  bes2  d'2 | % 12
  es'4..  es'16  es'8.  es'16
  d'8.  c'16 | % 13
  bes2  bes2 | % 14
  a4..  a16  bes8.  bes16  bes8.
  bes16 | % 15
  a4 (  d'4 )  g'4  d'4 | % 16
  es'8. (  d'16 )  c'4  f'4  f'4
  | % 17
  bes2. \bar "|."
}

RefLyrics = \lyricmode {
  Glo -- ry, glo -- ry, ha -- le -- lu -- ya!
  Ma -- ha -- ra -- him Tu -- han ki -- ta.
  Glo -- ry, glo -- ry, ha -- le -- lu -- ya!
  Pu -- ji -- lah na -- ma -- Nya! __
}

BassLyricsOne = \lyricmode {
  \set stanza = "1. "
  Tu -- han Ma -- ha -- ra -- him,
  ka -- sih -- Mu ba -- gai sa -- mu -- dra.
  Sa -- lib tan -- da ke -- me -- nang -- an
  ka -- lah -- kan \markup\undertie "kua" -- sa do -- sa.
  Da -- rah ser -- ta a -- ir
  meng -- a -- lir da -- ri lam -- bung -- Mu,
  Ye -- sus an -- dal -- an -- ku. __
  \RefLyrics
}

SopranoMidiInstrument = "choir aahs"
AltoMidiInstrument = "choir aahs"
TenorMidiInstrument = "choir aahs"
BassMidiInstrument = "choir aahs"

\layout {
  \context {
    \Score
    \consists Metronome_mark_engraver
  }
  \context {
    \SolmisasiStaff
    \omit TimeSignature
  }
}