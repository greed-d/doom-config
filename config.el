;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Google Sans" :size 16))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'mocha
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;; File tree (treemacs)
;; Put the sidebar on the right and give it a fixed width.
(after! treemacs
  (setq treemacs-position 'right
        treemacs-width 35))

;; Toggle the file tree with `SPC \` instead of `SPC o p`.
;; (map! :leader
;;       :desc "Toggle file tree" "\\" #'+treemacs/toggle
;;       "o p" nil)

;;; Gitsigns-like VC gutter (diff-hl)
;; Show git changes in a sign column (margin) instead of the fringe, using
;; gitsigns-style marker glyphs.
(after! diff-hl
  (require 'diff-hl-margin)
  (setq diff-hl-margin-symbols-alist
        '((insert    . "▎")
          (change    . "▎")
          (delete    . "")
          (unknown   . "?")
          (ignored   . "i")
          (reference . " ")))
  (diff-hl-margin-mode +1))

;; Colors for the diff-hl sign column (Catppuccin Mocha palette).
;; Change these hex values to whatever you prefer.
(custom-set-faces!
  '(diff-hl-margin-insert :foreground "#a6e3a1")
  '(diff-hl-margin-change :foreground "#f9e2af")
  '(diff-hl-margin-delete :foreground "#f38ba8"))

;; Hunk actions. Doom already provides:
;;   SPC g s  stage hunk        SPC g r  revert hunk
;;   SPC g S  stage file        SPC g U  unstage file
;;   SPC g B  blame             SPC g ]  next hunk   SPC g [  previous hunk
(map! :leader
      :desc "Preview hunk"            "g v" #'diff-hl-show-hunk
      :desc "Diff hunk against index" "g d" #'diff-hl-diff-goto-hunk
      :desc "Diff hunk against HEAD"  "g H" #'diff-hl-diff-reference-goto-hunk)

;; Gitsigns-style hunk navigation, in addition to Doom's ]d / [d.
(map! :n "]c" #'+vc-gutter/next-hunk
      :n "[c" #'+vc-gutter/previous-hunk)

;;; Python: ruff + ty
;; Format with ruff on save (the `format +onsave` module uses apheleia).
;; `ruff-isort` sorts imports first, then `ruff` formats the buffer.
(after! apheleia
  (setf (alist-get 'python-mode apheleia-mode-alist) '(ruff-isort ruff)
        (alist-get 'python-ts-mode apheleia-mode-alist) '(ruff-isort ruff)))

;; Lint with ruff and type-check with ty, both reported through flycheck.
;; Ruff is already Doom's preferred checker when `ruff' is on PATH. Chain ty
;; after it and drop the default mypy step so we do not check types twice.
(after! flycheck
  (flycheck-define-checker python-ty
    "Type-check Python with ty."
    :command ("ty" "check"
              "--output-format" "concise"
              "--no-progress"
              "--color" "never"
              source-inplace)
    :error-patterns
    ((error
      (file-name (one-or-more (not (any ":\n"))))
      ":" line ":" column ": error["
      (id (one-or-more (not (any "]\n"))))
      "] " (message) line-end)
     (warning
      (file-name (one-or-more (not (any ":\n"))))
      ":" line ":" column ": warning["
      (id (one-or-more (not (any "]\n"))))
      "] " (message) line-end))
    :working-directory flycheck-python-find-project-root
    :modes (python-mode python-ts-mode))

  (flycheck-remove-next-checker 'python-ruff '(warning . python-mypy))
  (flycheck-add-next-checker 'python-ruff 'python-ty))
