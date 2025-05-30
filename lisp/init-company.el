(require-package 'company)

(add-hook 'after-init-hook 'global-company-mode)

;;   "Modes for which `company-mode' mode is turned on by
;; `global-company-mode'.  If nil, means no modes.  If t, then all major modes
;; have it turned on.  If a list, it should be a list of `major-mode' symbol
;; names for which `company-mode' should be automatically turned on.  The sense
;; of the list is negated if it begins with `not'.  For example: (c-mode
;; c++-mode) means that `company-mode' is turned on for buffers in C and C++
;; modes only.  (not message-mode) means that `company-mode' is always turned
;; on except in `message-mode' buffers."
(setq company-global-modes '(
                            c-mode
                            c++-mode
                            ;; Add both modes in, given not sure what is the
                            ;; real relation between them.
                            latex-mode
                            LaTeX-mode
                            ))
(add-hook 'company-mode-hook (lambda ()
                               (local-set-key (kbd "C-c C-f") 'company-files)
                               ))
;; FIXME: This line should be the way to set keymap once and for all instead of
;; using the hook, but I did not figure out why it does not work.
;; (eval-after-load 'company '(local-set-key (kbd "C-c C-f") 'company-files))
;; Setup keymapping for company-complete.

(provide 'init-company)
