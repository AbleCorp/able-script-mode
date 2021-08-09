;;; able-script-mode -- Able script mode

;;; Commentary:

;; Major mode for able-script code, by Alex Bethel. See
;; https://github.com/AbleCorp/able-script.

;;; Code:

(defgroup able-script-mode nil
  "Support for AbleScript code."
  :link '(url-link "https://github.com/AbleCorp/able-script")
  :group 'languages)

(defcustom able-script-indent-offset 4
  "Indent AbleScript code by this number of spaces per level."
  :type 'integer
  :group 'able-script-mode)

;; Adapted from
;; gemini://gemini.omarpolo.com/post/writing-a-major-mode.gmi
;;
;; TODO: this behaves strangely sometimes when point is at the
;; beginning of the line; re-write this to work like other major
;; modes.
(defun able-script-indent-line ()
  "Indent current line."
  (let (indent
        boi-p                           ;begin of indent
        move-eol-p
        (point (point)))
    (save-excursion
      (back-to-indentation)
      (setq indent (car (syntax-ppss))
            boi-p (= point (point)))
      ;; don't indent empty lines
      (when (and (eq (char-after) ?\n)
                 (not boi-p))
        (setq indent 0))
      ;; check whether we want to move
      (when boi-p
        (setq move-eol-p t))
      ;; decrement the indent if the first character on the line is a
      ;; closer.
      (when (or (eq (char-after) ?\))
                (eq (char-after) ?\})
                (eq (char-after) ?\]))
        (setq indent (1- indent)))
      ;; indent the line.
      (delete-region (line-beginning-position)
                     (point))
      (indent-to (* able-script-indent-offset indent)))
    (when move-eol-p
      (back-to-indentation))))

;; Using generic-mode for now because I'm lazy.
(define-generic-mode
    able-script-mode
  '("owo")
  '("aint"
    "functio"
    "bff"
    "var"
    "print"
    "read"
    "melo"
    "T-Dark"
    "if"
    "loop"
    "break"
    "rlyeh"
    "rickroll"
    "true"
    "false"
    "always"
    "sometimes"
    "never")
  '(
    ;; Draw base-52 numbers in the `warning' face, because if you're
    ;; anything like me you usually don't mean to use them.
    ("\\b[[:alpha:]]\\b" 0 font-lock-warning-face)
    ("\\bvar \\([[:alnum:]_]*\\)" 1 font-lock-variable-name-face)
    ("\\bfunctio \\([[:alnum:]_]*\\)" 1 font-lock-function-name-face))
  '(".*\\.able")
  (list
   (function
    (lambda ()
      (setq-local indent-line-function #'able-script-indent-line))))
  "Able-script mode")

(provide 'able-script-mode)
;;; able-script-mode.el ends here
