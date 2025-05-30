(require-package 'smartparens)
(require 'smartparens)

;; It is quite mysterious the first time that I tried to use smartparens and
;; found it does ont working. The problem is that the `dash` version is too old
;; -- smartparens needs a version greater than 2.10.0 to work. So I keep the
;; -- loading statements here explicitly.
(require-package 'dash)
(require 'dash)


;; Toggle visualization of matching pairs.  When enabled, any matching pair is
;; highlighted after `sp-show-pair-delay' seconds of Emacs idle time if the
;; point is immediately in front or after a pair.  This mode works similarly to
;; `show-paren-mode', but support custom pairs.
(show-smartparens-global-mode +1)
(smartparens-global-mode t)
(require 'smartparens-config)

;; Template to add customized pair.
;; (sp-pair "$" "$")
;; (sp-pair "<#" "#>")

(provide 'init-smartparens)
