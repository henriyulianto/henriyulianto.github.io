%%%%%%%% HEADER %%%%%%%%
%
% this code was prompted by
% https://lists.gnu.org/archive/html/lilypond-user/2019-07/msg00139.html
% and offers a pseudoIndent hack suitable for general use

% keywords:
% indent short-indent indentation system line
% mid-score temporarily arbitrary individual single just only once
% coda margin
% mouse's tale acrostic mesostic spine

%%%%%%%% PSEUDOINDENT FUNCTIONS %%%%%%%%

% these two functions are for indenting individual systems
% - to left-indent a system, apply \pseudoIndent before the music continues
% - \pseudoIndents is similar, but lets you also indent on the right
% - both provide an option for changing that system's instrument names

% N.B. these functions
% - assume application to non-ragged lines (generally the default)
% - include a manual \break to ensure application at line start
% - misbehave if called more than once at the same line start

% the parameters of the (full) pseudoIndents function are:
% 1: name-tweaks
%      usually omitted; accepts replacement \markup for instrument names
%      as an ordered list; starred elements leave their i-names unchanged.
% 2: left-indent
%      additional left-indentation, in staff-space units; can be negative,
%      but avoid a total indentation which implies (unsupported) stretching.
% 3: right-indent
%      amount of right-indentation, in staff-space units; can be negative.
%      - not offered by the (reduced) pseudoIndent function


pseudoIndents = % inline alternative to a new \score, also with right-indent
#(define-music-function (name-tweaks left-indent right-indent)
   ((markup-list? '()) number? number?)
   (define (warn-stretched p1 p2) (ly:input-warning (*location*) (G_
                                                                  " pseudoIndents ~s ~s is stretching staff; expect distorted layout") p1 p2))
   (let* (
           (narrowing (+ left-indent right-indent)) ; of staff implied by args

           (set-staffsymbol! (lambda (staffsymbol-grob) ; change staff to new width
                               (let* (
                                       (left-bound (ly:spanner-bound staffsymbol-grob LEFT))
                                       (left-moment (ly:grob-property left-bound 'when))
                                       (capo? (moment<=? left-moment ZERO-MOMENT)) ; in first system of score
                                       (layout (ly:grob-layout staffsymbol-grob))
                                       (lw (ly:output-def-lookup layout 'line-width)) ; debugging info
                                       (indent (ly:output-def-lookup layout (if capo? 'indent 'short-indent)))
                                       (old-stil (ly:staff-symbol::print staffsymbol-grob))
                                       (staffsymbol-x-ext (ly:stencil-extent old-stil X))
                                       ;; >=2.19.16's first system has old-stil already narrowed [2]
                                       ;; compensate for this (ie being not pristine) when calculating
                                       ;; - old leftmost-x (its value is needed when setting so-called 'width)
                                       ;; - the new width and position (via local variable narrowing_)
                                       (ss-t (ly:staff-symbol-line-thickness staffsymbol-grob))
                                       (pristine? (<= 0 (car staffsymbol-x-ext) ss-t)) ; would expect half
                                       (leftmost-x (+ indent (if pristine? 0 narrowing)))
                                       (narrowing_ (if pristine? narrowing 0)) ; uses 0 if already narrowed
                                       (old-width (+ (interval-length staffsymbol-x-ext) ss-t))
                                       (new-width (- old-width narrowing_))
                                       (new-rightmost-x (+ leftmost-x new-width)) ; and set! this immediately
                                       (junk (ly:grob-set-property! staffsymbol-grob 'width new-rightmost-x))
                                       (in-situ-stil (ly:staff-symbol::print staffsymbol-grob))
                                       (new-stil (ly:stencil-translate-axis in-situ-stil narrowing_ X))
                                       ;(new-stil (stencil-with-color new-stil red)) ; for when debugging
                                       (new-x-ext (ly:stencil-extent new-stil X)))
                                 (ly:grob-set-property! staffsymbol-grob 'stencil new-stil)
                                 (ly:grob-set-property! staffsymbol-grob 'X-extent new-x-ext)
                                 )))

           (set-X-offset! (lambda (margin-grob) ; move grob across to line start
                            (let* (
                                    (old (ly:grob-property-data margin-grob 'X-offset))
                                    (new (lambda (grob) (+ (if (procedure? old) (old grob) old) narrowing))))
                              (ly:grob-set-property! margin-grob 'X-offset new))))

           (tweak-text! (lambda (i-name-grob mkup) ; tweak both instrumentname texts
                          (if (and (markup? mkup) (not (string=? (markup->string mkup) "*")))
                              (begin
                               (ly:grob-set-property! i-name-grob 'long-text mkup)
                               (ly:grob-set-property! i-name-grob 'text mkup)
                               )))) ; else retain existing text

           (install-narrowing (lambda (leftedge-grob) ; on staves, + adapt left margin
                                (let* (
                                        (sys (ly:grob-system leftedge-grob))
                                        (all-grobs (ly:grob-array->list (ly:grob-object sys 'all-elements)))
                                        (grobs-named (lambda (name)
                                                       (filter (lambda (x) (eq? name (grob::name x))) all-grobs)))
                                        (first-leftedge-grob (list-ref (grobs-named 'LeftEdge) 0))
                                        (relsys-x-of (lambda (g) (ly:grob-relative-coordinate g sys X)))
                                        (leftedge-x (relsys-x-of first-leftedge-grob))
                                        (leftedged? (lambda (g) (= (relsys-x-of g) leftedge-x)))
                                        (leftedged-ss (filter leftedged? (grobs-named 'StaffSymbol))))
                                  (if (eq? leftedge-grob first-leftedge-grob) ; ignore other leftedges [1]
                                      (begin
                                       (for-each set-staffsymbol! leftedged-ss)
                                       (for-each set-X-offset! (grobs-named 'SystemStartBar))
                                       (for-each set-X-offset! (grobs-named 'InstrumentName))
                                       (for-each tweak-text! (grobs-named 'InstrumentName) name-tweaks)
                                       ))))))

     (if (negative? narrowing) (warn-stretched left-indent right-indent))
     #{ % and continue anyway
       % ensure that these overrides are applied only at begin-of-line
       \break % (but this does not exclude unsupported multiple application)
       % give the spacing engine notice regarding the loss of width for music
       \once \override Score.LeftEdge.X-extent = #(cons narrowing narrowing)
       % discard line start region of staff and reassemble left-margin elements
       \once \override Score.LeftEdge.after-line-breaking = #install-narrowing
       % shift the system to partition the narrowing between left and right
       \overrideProperty Score.NonMusicalPaperColumn.line-break-system-details
       .X-offset #(- right-indent)
       % prevent a leftmost barnumber entering a stretched staff
       \once \override Score.BarNumber.horizon-padding = #(max 1 (- 1 narrowing))
     #}))

pseudoIndent = % for changing just left-indent
#(define-music-function (name-tweaks left-indent)
   ((markup-list? '()) number?)
   #{
     \pseudoIndents $name-tweaks $left-indent 0
   #})

% [1] versions <2.19.1 can have end-of-line leftedges too
%     - these were eliminated in issue 3761
% [2] versions >=2.19.16: the first system behaves differently from the rest
%     - a side effect of issue 660 ?
% [3] versions >=2.23.0: LeftEdge's position may well differ in Y (but not in X)
%     - a side effect of issue 6084 ?