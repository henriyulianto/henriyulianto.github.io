%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% a4-satb-paper.ily
%% A4 SATB Paper defaults
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\version "2.25.26"
#(define SATB_SOLMISASI_INIT #t)
#(if (not (eq? 'svg (ly:get-option 'backend)))
     (ly:set-option 'backend 'cairo))

%% Safe include
#(if (not (defined? 'SOLMISASI_LILY_LOADED))
     (ly:parser-include-string "\\include \"solmisasi.ily\""))

%% Append the directory of this file to current parser's include path
#(ly:parser-append-to-include-path
  (normalize-path
   (location-extract-path (*location*))))

\include "pseudo-indents.ily"

%% Includes from bwv-zeug
\include "tie-attributes.ily"
\include "highlight-bars.ily"
\include "fermata.ily"

\include "vocal-tkit.ly"

#(define satb-voice-prefixes
   ;; These define the permitted prefixes to various names.
   ;; They are combined with a fixed set of postfixes to form
   ;; names such as AltoMusic, BassInstrumentName, etc.
   ;; These names may be redefined.
   '(
      "Alto"
      "Bass"
      "Descant"
      "Intro"
      "Men"
      "MenDivided"
      "Piano"
      "PianoLH"
      "PianoRH"
      "Solo"
      "Sopran"
      "Soprano"
      "Tenor"
      "Women"
      "WomenDivided"))

#(define satb-lyrics-postfixes
   ;; These define the permitted postfixes to the names of lyrics.
   ;; They are combined with the prefixes to form names like
   ;; AltoLyrics, etc.
   ;; These names may be redefined or extended.
   '(
      "Lyrics"
      "LyricsOne"
      "LyricsTwo"
      "LyricsThree"
      "LyricsFour"))

#(define satb-lyrics-variable-names
   ;; These define the names which may be used to specify stanzas
   ;; which go between the two two-voice staves when TwoVoicesPerStaff
   ;; is set to #t.  They may be redefined or extended.
   '(
      "VerseOne"
      "VerseTwo"
      "VerseThree"
      "VerseFour"
      "VerseFive"
      "VerseSix"
      "VerseSeven"
      "VerseEight"
      "VerseNine"))

%% make the above definitions available
#(set-music-definitions!
  satb-voice-prefixes
  satb-lyrics-postfixes
  satb-lyrics-variable-names)

make-solmisasi-voice =
#(define-music-function (name) (voice-prefix?)
   (define music (tkit-lookup name "Music"))
   (if music
       #{
         \new SolmisasiVoice = #(string-append name "Voice") <<
           \skip \AllMusic
           #(if Time Time )
           \solmisasiMusic \keepWithTag #'(solmisasi notangka) #music
         >>
       #} ))

make-pseudo-solmisasi-voice =
#(define-music-function (name) (voice-prefix?)
   (define music (tkit-lookup name "Music"))
   (if music
       #{
         \new Voice = #(string-append name "Voice") <<
           \skip \AllMusic
           #(if Time Time )
           \solmisasiMusic \keepWithTag #'(solmisasi notangka) #music
         >>
       #} ))

make-one-solmisasi-voice-staff =
#(define-music-function (show-instrName always-short name)
   ((boolean? #t) (boolean? #f) voice-prefix?)
   "Make a solmisasi staff with one voice (no lyrics)
    show-instrName: show instrument and short instrument names?
              name: the default prefix for instrument name and music
              clef: the clef for this staff
 dynamic-direction: dynamics are up, down or neither"
   (define music (tkit-lookup name "Music"))
   (define instrName (tkit-lookup name "InstrumentName"))
   (define shortInstrName (tkit-lookup name "ShortInstrumentName"))
   (define midiName (tkit-lookup name "MidiInstrument"))
   (if music
       #{
         \new SolmisasiStaff = #(string-append name "Staff")
         \with {
           instrumentName = \markup \smallCaps {
             #(if show-instrName
                  (if instrName
                      instrName
                      (if always-short
                          (markup #:right-column
                                  (#:with-dimensions-from
                                   "I"
                                   (#:center-align (substring name 0 1))))
                          name))
                  "")
           }
           shortInstrumentName = \markup \smallCaps {
             #(if show-instrName
                  (cond
                   (shortInstrName
                    (markup #:right-column
                            (#:with-dimensions-from
                             "I"
                             (#:center-align shortInstrName))))
                   (instrName
                    (markup #:right-column
                            (#:with-dimensions-from
                             "I"
                             (#:center-align (substring instrName 0 1)))))
                   (else
                    (markup #:right-column
                            (#:with-dimensions-from
                             "I"
                             (#:center-align (substring name 0 1))))))
                  "")
           }
           midiInstrument = #(if midiName midiName "clarinet")
           male-vocal =
           #(or (equal? name "Tenor")
                (equal? name "Bass")
                (equal? name "Men"))
         }
         {
           % #(if Key Key)
           %          \clef #clef
           \make-solmisasi-voice #name
         }
       #}
       (make-music 'SequentialMusic 'void #t)))

make-one-pseudo-solmisasi-voice-staff =
#(define-music-function (show-instrName always-short name)
   ((boolean? #t) (boolean? #f) voice-prefix?)
   "Make a solmisasi staff with one voice (no lyrics)
    show-instrName: show instrument and short instrument names?
              name: the default prefix for instrument name and music
              clef: the clef for this staff
 dynamic-direction: dynamics are up, down or neither"
   (define music (tkit-lookup name "Music"))
   (define instrName (tkit-lookup name "InstrumentName"))
   (define shortInstrName (tkit-lookup name "ShortInstrumentName"))
   (define midiName (tkit-lookup name "MidiInstrument"))
   (if music
       #{
         \new Staff = #(string-append name "Staff")
         \with {
           instrumentName = \markup \smallCaps {
             #(if show-instrName
                  (if instrName
                      instrName
                      (if always-short
                          (markup #:right-column
                                  (#:with-dimensions-from
                                   "I"
                                   (#:center-align (substring name 0 1))))
                          name))
                  "")
           }
           shortInstrumentName = \markup \smallCaps {
             #(if show-instrName
                  (cond
                   (shortInstrName
                    (markup #:right-column
                            (#:with-dimensions-from
                             "I"
                             (#:center-align shortInstrName))))
                   (instrName
                    (markup #:right-column
                            (#:with-dimensions-from
                             "I"
                             (#:center-align (substring instrName 0 1)))))
                   (else
                    (markup #:right-column
                            (#:with-dimensions-from
                             "I"
                             (#:center-align (substring name 0 1))))))
                  "")
           }
           midiInstrument = #(if midiName midiName "clarinet")
           male-vocal =
           #(or (equal? name "Tenor")
                (equal? name "Bass")
                (equal? name "Men"))
         }
         {
           % #(if Key Key)
           %          \clef #clef
           \make-pseudo-solmisasi-voice #name
         }
       #}
       (make-music 'SequentialMusic 'void #t)))

make-one-solmisasi-voice-vocal-staff =
#(define-music-function (always-short name)
   ((boolean? #f) voice-prefix?)
   "Make a staff with one voice and lyrics beneath
    name: the default prefix for instrument name and music
    clef: the clef for this staff "
   (if (tkit-lookup name "Music")
       (make-simultaneous-music
        (list
         (make-one-solmisasi-voice-staff #t always-short name)
         (make-simultaneous-music
          (reverse (map
                    (lambda (lyrics-postfix)
                      (make-one-stanza "Below" name name lyrics-postfix))
                    lyrics-postfixes)))))
       (make-music 'SequentialMusic 'void #t)))

make-one-pseudo-solmisasi-voice-vocal-staff =
#(define-music-function (always-short name)
   ((boolean? #f) voice-prefix?)
   "Make a staff with one voice and lyrics beneath
    name: the default prefix for instrument name and music
    clef: the clef for this staff "
   (if (tkit-lookup name "Music")
       (make-simultaneous-music
        (list
         (make-one-pseudo-solmisasi-voice-staff #t always-short name)
         (make-simultaneous-music
          (reverse (map
                    (lambda (lyrics-postfix)
                      (make-one-stanza "Below" name name lyrics-postfix))
                    lyrics-postfixes)))))
       (make-music 'SequentialMusic 'void #t)))

%% Markup for short instrument name
#(define-markup-command (satb-short-instrument-name-markup layout props name)
   (markup?)
   (let* ((sname (substring (markup->string name) 0 1))
          (mkup (empty-markup)))
     (set! mkup
           (interpret-markup
            layout props
            #{
              \markup \concat {
                \with-dimensions-from "M" #sname
                .
              }
            #}))
     mkup))

%% Initialise some variables
Global = ##f
TimeAndKeySignature = ##f
EngraveNotAngka = ##t
EngraveNotBalok = ##f
ExportMIDI = ##t
LeadSheetMode = ##f
LeadSheetStaffCombo = ##f
StandardStaffSize = #20
SolmisasiStaffSize = #20
UkuranKertas = ##f
Bookpart_NotAngka = ##f
Bookpart_NotBalok = ##f
CetakWatermark = ##f
AlwaysShortInstrumentName = ##f
TransposeDownForStandard = ##f
\paper {
  IndentSolmisasi = ##f
  ShortIndentSolmisasi = ##f
  IndentNotBalok = ##f
  ShortIndentNotBalok = ##f
  DefaultFonts = property-defaults.fonts
}

%% Initialize #'header:jenis-notasi
\header {
  jenis-notasi = ##f
}

updateJenisNotasi =
#(define-void-function (str-jenis-notasi) (string?)
   (module-define! $defaultheader 'jenis-notasi str-jenis-notasi))

presentationPageLayoutForSVG = \layout {
  % Apply simple highlighting only for SVG output
  #(if is-svg?
       (ly:parser-include-string
        "\\context {
               \\Staff
               \\consists #Simple_highlight_engraver
               \\consists Staff_highlight_engraver
               \\consists #Bar_timing_collector
             }
             \\context {
               \\SolmisasiStaff
               \\consists #Simple_highlight_engraver
               \\consists Staff_highlight_engraver
               \\consists #Bar_timing_collector
             }
      			 \\context {
      			   \\Lyrics
      			   \\remove #Simple_highlight_engraver
      			   \\remove Staff_highlight_engraver
                     \\remove #Bar_timing_collector
      			 }
             \\context {
               \\Score
               \\override StaffHighlight.after-line-breaking = #add-data-bar-to-highlight
             }")
       )
  \context {
    \Score
    \override StaffHighlight.after-line-breaking = #add-data-bar-to-highlight
  }
}

oneLineLayoutForSVG = \layout {
  \context {
    \Voice
    \consists \Tie_grob_engraver
    \consists #simple-fermata-data-engraver
  }
  \context {
    \SolmisasiVoice
    \consists \Tie_grob_engraver
    \consists #simple-fermata-data-engraver
  }
}
