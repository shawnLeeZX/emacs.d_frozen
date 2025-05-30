;;; Init related evil extensions.
(require-package 'evil)
(require-package 'evil-surround)
(require-package 'evil-leader)
(require-package 'evil-nerd-commenter)
(require-package 'evil-matchit)
(require-package 'evil-visualstar)

;; Disable TAB
;; Emacs’ Org mode uses the TAB key to call org-cycle, which cycles
;; visibility for headers. Every TAB press on a headline cycles
;; through a different function1:

;;     The first press folds the headline’s subtree, showing only the
;;     headline itself
;;     The scond press shows the headline and its direct descendants,
;;     but keeps them folded
;;     The third press shows the headline’s complete subtree

;; However, running Emacs with Evil mode in a terminal breaks the TAB
;; key for cycling through header visibility in Org mode.

;; Most terminals map both TAB and C-i to U+0009 (Character
;; Tabulation) for historical reasons, meaning they’re recognised as
;; the same keypress. Because of this, there is no way to map
;; different functions to them inside Emacs.

;; Evil remaps C-i to evil-jump-forward to emulate Vim’s jump lists
;; feature2, which overwrites the default mapping for the TAB key in
;; Org mode.

;; To fix the tab key’s functionality in Org mode, sacrifice Evil’s
;; C-i backward jumping by turning it off in your configuration with
;; the evil-want-C-i-jump option.
(setq evil-want-C-i-jump nil)

;; Make a visual selection with v or V, and then hit * to search that
;; selection forward, or # to search that selection backward.
(require 'evil-visualstar)
(global-evil-visualstar-mode t)

(require 'evil-matchit)
(global-evil-matchit-mode 1)

(require 'evil-surround)
(global-evil-surround-mode)

(require 'evil-nerd-commenter)
;; Tip 2, change comment style

;; For example, use double slashes (//) instead of slash-stars (* … *)
;; in c-mode.

;; Insert below code into your ~/.emacs:

;; (add-hook 'c-mode-common-hook
;;   (lambda ()
;;     ;; Preferred comment style
;;     (setq comment-start "// "
;;           comment-end "")))
(global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)
(global-set-key (kbd "C-c l") 'evilnc-quick-comment-or-uncomment-to-the-line)
(global-set-key (kbd "C-c c") 'evilnc-copy-and-comment-lines)
(global-set-key (kbd "C-c p") 'evilnc-comment-or-uncomment-paragraphs)

(require 'evil-leader)
;; You can also bind several keys at once:

;; (evil-leader/set-key
;;   "e" 'find-file
;;   "b" 'switch-to-buffer
;;   "k" 'kill-buffer)
;; The key map can of course be filled in several places.

;; After you set up the key map you can access the bindings by pressing <leader> (default: \) and the key(s). E.g. \ e would call find-file to open a file.

;; If you wish to change so you can customize evil-leader/leader or call evil-leader/set-leader, e.g. (evil-leader/set-leader ",") to change it to “,”. The leader has to be readable by read-kbd-macro, so using Space as a prefix key would be (evil-leader/set-leader "<SPC>").

;; Beginning with version 0.3 evil-leader has support for mode-local bindings:

;; (evil-leader/set-key-for-mode 'emacs-lisp-mode "b" 'byte-compile-file)
;; Again, you can bind several keys at once.

;; A mode-local binding shadows a normal mode-independent binding.
(global-evil-leader-mode)
(evil-leader/set-key
  "c SPC" 'evilnc-comment-or-uncomment-lines
  "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
  "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
  "cc" 'evilnc-copy-and-comment-lines
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "cr" 'comment-or-uncomment-region
  "cv" 'evilnc-toggle-invert-comment-line-by-line
  "w"  'save-buffer
  )

;; Begin evil mode.
(require 'evil)
(evil-mode 1)

(evil-set-initial-state #'git-commit-mode 'normal)

;; Set up the undo system.
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)

(provide 'init-evil)
