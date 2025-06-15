%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% a4-satb.ily
%% Include this file at the end of the main file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\version "2.25.26"
#(ly:set-option 'midi-extension "midi")

%% Safe include
#(if (not (defined? 'SOLMISASI_LILY_LOADED))
     (ly:parser-include-string "\\include \"solmisasi.ily\""))

#(if (not (defined? 'SATB_SOLMISASI_INIT))
     (ly:parser-include-string "\\include \"satb-solmisasi-init.ily\""))

%% Append the directory of this file to current parser's include path
#(ly:parser-append-to-include-path
  (normalize-path
   (location-extract-path (*location*))))

\include "titling-init.ly"

\header {
  title = \markup {
    \fromproperty #'header:judul
  }
  subtitle = \markup {
    \fromproperty #'header:sub-judul
  }
  instrument = \markup \normal-text {
    \fromproperty #'header:instrumen
  }
  header-title = \markup {
    \override #'(baseline-skip . 2.3)
    \left-column {
      \bold \caps \fromproperty #'header:judul-header-I
      \smaller \fromproperty #'header:judul-header-II
    }
  }
  composer = \markup {
    \override #'(baseline-skip . 2.5)
    \right-column {
      %\vspace #0.5
      \fromproperty #'header:pencipta-lagu
      \vspace #0.3
    }
  }
  arranger = \markup {
    \override #'(baseline-skip . 2.5)
    \right-column {
      \fromproperty #'header:penata-suara
      \vspace #0.5
    }
  }
  poet = \markup {
    \override #'(baseline-skip . 2.5)
    \left-column {
      %\vspace #0.5
      \fromproperty #'header:pencipta-syair
      \vspace #0.3
    }
  }
  meter = \markup {
    \override #'(baseline-skip . 2.5)
    \right-column {
      \fromproperty #'header:ekspresi-global
      \vspace #0.5
    }
  }
  tagline = \markup \sans {
    \line {
      {
        \concat {
          Di- \italic engrave
        }
        dengan
      }
      {
        \pad-to-box #'(0 . 0) #'(0 . 0)
        \with-url
        "https://lilypond.org"
        \underline #(format #f "LilyPond v~a" (lilypond-version))
      }
      +
      {
        \pad-to-box #'(0 . 0) #'(0 . 0)
        \with-url
        "https://henriyulianto.github.io/solmisasi-lily/"
        \underline #(format #f "solmisasi-lily v~a" (solmisasi-lily-version))
      }
      oleh Henri Yulianto.
    }
  }
  copyright = \markup \sans {
    \fromproperty #'header:hak-cipta
  }
}

#(define watermark-file "../watermark/hy-logo-trans-07.png")
#(define watermark-x-size
   (*
    (/ 11 (ly:output-def-lookup $defaultpaper 'text-font-size))
    80))

#(define watermark-y-offset
   (*
    (/ 11 (ly:output-def-lookup $defaultpaper 'text-font-size))
    -115))

watermark = \markup {
  \with-dimensions-from \null {
    \translate #(cons 0 watermark-y-offset)
    \center-column {
      \fill-line {
        \override #'(background-color . #f)
        \image #X #watermark-x-size \withRelativeDir #watermark-file
      }
    }
  }
}

\paper {

  #(include-special-characters)

  % Paper size
  #(set-paper-size
    (if UkuranKertas UkuranKertas "a4"))

  % Page numbers
  print-page-number       = ##t
  print-first-page-number = ##f

  % Margins and indents
  left-margin   = 15\mm
  right-margin  = 15\mm
  top-margin    = 12.7\mm
  bottom-margin = 12.7\mm
  indent        = 7.5\mm
  short-indent  = 7.5\mm

  % Ragged
  ragged-right  = ##f
  ragged-last   = ##f
  ragged-bottom = ##t

  % Spacing
  system-system-spacing.basic-distance = #8
  system-system-spacing.padding = #3
  score-markup-spacing.basic-distance = #9
  score-system-spacing =
  #'((basic-distance . 9)
     (minimum-distance . 5)
     (padding . 1)
     (stretchability . 12))
  last-bottom-spacing =
  #'((basic-distance . 2)
     (minimum-distance . 2)
     (padding . 3)
     (stretchability . 0))
  top-system-spacing.basic-distance = #12
  top-system-spacing.padding = #3
  top-markup-spacing.basic-distance = #5
  #(set! top-system-spacing
         (if (defined? '_SOLMISASI_LY2VIDEO)
             #f
             top-system-spacing))

  % Headers
  bookTitleMarkup = \markup {
    \override #'(baseline-skip . 2.8)
    \column {
      \fill-line { \fromproperty #'header:dedication }
      \override #'(baseline-skip . 3.0)
      \column {
        \fill-line {
          %\abs-fontsize #17
          \huge \larger \larger \larger \bold \caps
          \fromproperty #'header:title
        }
        \fill-line {
          %\abs-fontsize #12.5
          \large \bold \fromproperty #'header:subtitle
        }
        \vspace #0.5
        \fill-line {
          { \fontsize #0.2 \fromproperty #'header:poet }
          { \bold \fromproperty #'header:instrument }
          { \fontsize #0.5 \fromproperty #'header:composer }
        }
        \fill-line {
          { \fontsize #0.2 \fromproperty #'header:meter }
          { \fontsize #0.2 \fromproperty #'header:arranger }
        }
      }
    }
  }

  oddHeaderMarkup = \markup {
    \combine #(if CetakWatermark
                  #{ \markup \watermark #}
                  #{ \markup\null #})
    \unless \on-first-page-of-part {
      \override #'(baseline-skip . 1.0)
      \column {
        \fill-line {
          \fromproperty #'header:header-title
          ""
          \override #'(baseline-skip . 2.5)
          \right-column {
            \line {
              \if \should-print-page-number
              \bold \concat {
                \fromproperty #'page:page-number-string
                "/"
                \page-ref #'lastPage "0" "?"
              }
            }
            \line {
              \caps \fromproperty #'header:jenis-notasi
            }
          }
        }
        \vspace #0.1
        \override #'(thickness . 1.3)
        \draw-hline
      }
    }
    \if \on-first-page-of-part {
      \column {
        \fill-line {
          ""
          ""
          \box \pad-markup #0.3 \caps \fromproperty #'header:jenis-notasi
        }
      }
    }
  }
  evenHeaderMarkup = \oddHeaderMarkup

  oddFooterMarkup = \markup {
    \override #'(baseline-skip . 2.3)
    \column {
      \fill-line {
        %% Copyright header field only on first page in each bookpart.
        \if \on-first-page-of-part
        \abs-fontsize #9.5 \fromproperty #'header:copyright
      }
      \fill-line {
        %% Tagline header field only on last page in the book.
        %\if \on-last-page-of-part
        \if \on-first-page-of-part
        \abs-fontsize #9.5 \fromproperty #'header:tagline
      }
    }
  }
}

\include "vocal-tkit.ly"
\include "piano-tkit.ly"

%% make the above definitions available
#(set-music-definitions!
  satb-voice-prefixes
  satb-lyrics-postfixes
  satb-lyrics-variable-names)

%% override the usual default value
#(if (not SoloShortInstrumentName)
     (set! SoloShortInstrumentName ""))

SATB_Solmisasi_Layout =
\layout {
  #(layout-set-staff-size SolmisasiStaffSize)
  \context {
    \Score
    %\override BarNumber.font-shape = #'upright
  }
  \context {
    \SolmisasiTimeAndKeySignature
    \omit TimeSignature
    \override KeySignature.extra-offset = #'(1 . 0)
  }
  \context {
    \SolmisasiChoirStaff
    \consists Span_bar_engraver
    \consists Metronome_mark_engraver
  }
  \context {
    \SolmisasiStaff
    \consists Time_signature_engraver
    \undo \omit TimeSignature
    \override TimeSignature.break-visibility = #end-of-line-invisible
    \override TimeSignature.font-size = #-1
    \override TimeSignature.extra-offset = #'(0 . -0.25)
    %\override InstrumentName.font-series = #'bold
  }
  \context {
    \SolmisasiVoice
    \override NoteHead.font-family = #'serif
    \override NoteHead.font-size = #0.25
    \override Rest.font-family = #'serif
    \override Rest.font-size = #0.25
    \override DynamicLineSpanner.outside-staff-priority = ##f
    \override DynamicLineSpanner.Y-offset = #3.25
    \override Hairpin.thickness = #0.9
    \override Tie.thickness = #2.7
    \override Tie.line-thickness = #0.4
    \override Slur.thickness = #2.7
    \override Slur.line-thickness = #0.4
    \override Slur.ratio = #0.275
    \override PhrasingSlur.thickness = #2.7
    \override PhrasingSlur.line-thickness = #0.4
  }
  \context {
    \Lyrics
    \consists Bar_engraver
    \consists Separating_line_group_engraver
    \hide BarLine
    \override VerticalAxisGroup.nonstaff-unrelatedstaff-spacing.padding = #0.75
    \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.basic-distance = #0
    %\override VerticalAxisGroup.nonstaff-relatedstaff-spacing.padding = #0.2
    \override VerticalAxisGroup.staff-affinity = #UP
    \override LyricText.font-series = #'medium
    %%\override LyricText.font-size = #2
    \override LyricHyphen.Y-offset = #0.2
    \override LyricHyphen.minimum-distance = #2.0
    \override LyricText.layer = #-2
    \override LyricText.whiteout = #2
    \override LyricText.whiteout-style = #'outline
    \override LyricText.word-space = #1
    \override LyricExtender.layer = -4
    \override LyricHyphen.layer = #-3
    \override LyricHyphen.minimum-distance = #0.4
  }
}

SATB_Solmisasi = {
  <<
    #(if Global
         #{
           \new SolmisasiTimeAndKeySignature {
             \solmisasiMusic {
               \keepWithTag #'(solmisasi notangka) \Global
             }
           }
         #})
    \make-one-solmisasi-voice-vocal-staff "Intro"
    \make-one-solmisasi-voice-vocal-staff "Solo"
    \new SolmisasiChoirStaff <<
      \make-one-solmisasi-voice-vocal-staff "Descant"
      %%
      \make-one-solmisasi-voice-vocal-staff "Women"
      %%
      \make-one-solmisasi-voice-vocal-staff #AlwaysShortInstrumentName "Soprano"
      \make-one-solmisasi-voice-vocal-staff #AlwaysShortInstrumentName "Alto"
      \make-one-solmisasi-voice-vocal-staff #AlwaysShortInstrumentName "Tenor"
      \make-one-solmisasi-voice-vocal-staff #AlwaysShortInstrumentName "Bass"
      %%
      \make-one-solmisasi-voice-vocal-staff "Men"
    >>
  >>
  \label #'lastPage
}

SATB_NotBalok = {
  <<
    #(if Global Global)
    \make-one-voice-vocal-staff "Solo" "treble"
    \new ChoirStaff <<
      \make-one-voice-vocal-staff "Descant" "treble"
      \make-one-voice-vocal-staff "Women" "treble"
      #(if TwoVoicesPerStaff
           #{
             \make-two-vocal-staves-with-stanzas
             "WomenDivided" "treble" "MenDivided" "bass"
             "Soprano" "Alto" "Tenor" "Bass"
             #satb-lyrics-variable-names
           #}
           #{
             <<
               \make-one-voice-vocal-staff "Soprano" "treble"
               \make-one-voice-vocal-staff "Alto" "treble"
               \make-one-voice-vocal-staff "Tenor" "treble_8"
               \make-one-voice-vocal-staff "Bass" "bass"
             >>
           #} )
      \make-one-voice-vocal-staff "Men" "bass"
    >>
  >>
  \label #'lastPage
}

Bookpart_NotAngka = \bookpart {
  \header {
    jenis-notasi = "Not Angka"
  }
  \paper {
    indent = #(* (if IndentSolmisasi IndentSolmisasi 7.5) mm)
    short-indent = #(* (if ShortIndentSolmisasi ShortIndentSolmisasi 7.5) mm)
    bookpart-level-page-numbering = ##t
  }
  \conditional #EngraveNotAngka \score {
    \keepWithTag #'(solmisasi notangka)
    #(if have-music
         #{ << \SATB_Solmisasi >> #}
         #{ { } #} )
    \layout {
      \SATB_Solmisasi_Layout
    }
  }
}

Piano = \make-pianostaff

Bookpart_NotBalok = \bookpart {
  \header {
    meter = ##f
    jenis-notasi = "Not Balok (Standar)"
    tagline = \markup \sans {
      \line {
        {
          \concat {
            Di- \italic engrave
          }
          dengan
        }
        {
          \pad-to-box #'(0 . 0) #'(0 . 0)
          \with-url
          "https://lilypond.org"
          \underline #(format #f "LilyPond v~a" (lilypond-version))
        }
        oleh Henri Yulianto.
      }
    }
  }
  \paper {
    indent = #(* (if IndentNotBalok IndentNotBalok 25) mm)
    short-indent = #(* (if ShortIndentNotBalok ShortIndentNotBalok 12) mm)
    bookpart-level-page-numbering = ##t
  }
  \conditional #EngraveNotBalok \score {
    \keepWithTag #'(notbalok)
    #(if have-music
         #{ << \SATB_NotBalok \Piano >> #}
         #{ { } #} )
    \layout {
      #(layout-set-staff-size StandardStaffSize)
      \context {
        \Score
        \consists Bar_number_engraver
      }
      \context {
        \Score
        \consists Metronome_mark_engraver
      }
    }
  }
}

\include "articulate.ly"

Bookpart_Midi = \bookpart {
  \conditional #ExportMIDI \score {
    \keepWithTag #'(play midi notbalok)
    #(if have-music
         #{
           \articulate \unfoldRepeats <<
             \SATB_NotBalok
             #(if (ly:music? Piano)
                  #{ \Piano #})
           >>
         #}
         #{ { } #} )
    \midi {
      \context {
        \Score
        midiChannelMapping = #'instrument
      }
    }
  }
}

\book {
  \bookpart { \Bookpart_NotAngka }
  \bookpart { \Bookpart_NotBalok }
  \bookpart { \Bookpart_Midi }
}
