;;; lively.el --- interactively updating text

;; Copyright 2009 Luke Gorrie <luke@bup.co.nz>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Author: Luke Gorrie <luke@bup.co.nz>
;; Maintainer: Steve Purcell <steve@sanityinc.com>
;; Package-Version: 20171005.754
;; Package-Revision: 348675828c6a

;;; Commentary:
;;
;; Go to the end of any of the following lines and run `M-x lively'
;;   Current time:      (current-time-string)
;;   Last command:      last-command
;;   Open buffers:      (length (buffer-list))
;;   Unix processes:    (lively-shell-command "ps -a | wc -l")
;;
;; then the code will be replaced by its formatted result -- and
;; periodically updated.  You can create little dashboards.
;; Use `M-x lively-stop' to restore order.
;;
;; Based on the Squeak hack by Scott Wallace.

;;; Code:

(defvar lively-overlays nil  "List of all overlays representing lively text.")
(defvar lively-timer    nil  "Idle timer for updating lively text.")
(defvar lively-interval 0.25 "Idle time before lively text update in seconds.")

;;;###autoload
(defun lively ()
  "Make the expression before point lively."
  (interactive)
  (lively-region (save-excursion (backward-sexp) (point)) (point)))

;;;###autoload
(defun lively-region (start end)
  "Make the region from START to END lively."
  (interactive "r")
  (when (null lively-timer)
    (lively-init-timer))
  (push (make-overlay start end) lively-overlays))

(defun lively-update ()
  "Update the display of all visible lively text."
  (interactive)
  (dolist (o lively-overlays)
    (when (get-buffer-window (overlay-buffer o))
      (condition-case err
          (lively-update-overlay o)
        (error (message "Error in lively expression: %S" err)
               (lively-delete-overlay o))))))

(defun lively-delete-overlay (o)
  "Delete overlay O."
  (delete-overlay o)
  (setq lively-overlays (remove o lively-overlays)))

(defun lively-update-overlay (o)
  "Update the text of O if it is both lively and visible."
  (with-current-buffer (overlay-buffer o)
    (let ((expr (buffer-substring (overlay-start o) (overlay-end o))))
      (overlay-put o 'display (format "%s" (eval (read expr)))))))

(defun lively-init-timer ()
  "Setup background timer to update lively text."
  (setq lively-timer (run-with-timer 0 lively-interval 'lively-update)))

(defun lively-stop ()
  "Remove all lively regions in Emacs."
  (interactive)
  (when lively-timer (cancel-timer lively-timer))
  (setq lively-timer nil)
  (mapc 'delete-overlay lively-overlays)
  (setq lively-overlays nil))

;;; Nice to have:

(defun lively-shell-command (command)
  "Execute COMMAND and return the output, sans trailing newline."
  (let ((result (shell-command-to-string command)))
    (substring result 0 (1- (length result)))))

(provide 'lively)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; lively.el ends here
