(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;; set indent-tabs-mode intelligently
;; adapted from [[http://www.emacswiki.org/emacs/FuzzyFormat][fuzzy-format.el]]
(defun su/set-indent-tabs-mode ()
  "set `indent-tabs-mode' somewhat intelligently. uses spaces over tabs to break
ties. in case it finds both in a file, it goes with the more common occurrence
while enabling `whitespace-mode'."
  (interactive)
  (let ((space-count 0)
        (tab-count 0))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^ +[^[:space:]\n]+$" nil t)
        (setq space-count (1+ space-count)))
      (goto-char (point-min))
      (while (re-search-forward "^\t+[^[:space:]\n]+$" nil t)
        (setq tab-count (1+ tab-count)))

      (if (>= space-count tab-count)
          (setq indent-tabs-mode)
        (setq indent-tabs-mode t))

      (if (and (> space-count 0) ;; help user to pick a lane
               (> tab-count 0))
          (whitespace-mode 1)))))
(add-hook 'find-file-hook 'su/set-indent-tabs-mode)
