(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;; set indent-tabs-mode intelligently
;; adapted from [[http://www.emacswiki.org/emacs/FuzzyFormat][fuzzy-format.el]]
(defun su/set-indent-tabs-mode ()
  "set `indent-tabs-mode' somewhat intelligently. uses spaces over tabs to break
ties. in case it finds both in a file, it goes with the more common occurrence
while enabling `whitespace-mode'."
  (interactive)
  (let* ((matcher-prefix "\\(\\(\\sw\\|\\s(\\|\\s)\\|\\s_\\)+\\)\\(.*\\)$")
         (space-matcher (concat "^\\( +\\)" matcher-prefix))
         (tab-matcher (concat "^\\(\t+\\)" matcher-prefix))
         (space-count 0)
         (tab-count 0)
         last-match-point)
    (save-excursion
      ;; count space occurrence
      (goto-char (point-min))
      (while (setq last-match-point (re-search-forward space-matcher nil t))
        (goto-char (match-beginning 3))
        ;; only count towards spaces if the occurrence is in non-commented out
        ;; portion. this helps avoid superfluous matches which are an artifact
        ;; of top-level 'doc' style comments
        (if (not (flyspell-generic-progmode-verify))
            (setq space-count (1+ space-count)))
        (goto-char last-match-point))

      ;; count tab occurrence
      (goto-char (point-min))
      (while (setq last-match-point (re-search-forward tab-matcher nil t))
        (goto-char (match-beginning 3))
        ;; unsure whether this if is needed, but just to be safe do the same
        ;; thing for tabs as you did for spaces
        (if (not (flyspell-generic-progmode-verify))
            (setq tab-count (1+ tab-count)))
        (goto-char last-match-point))

      (if (>= space-count tab-count)
          (setq indent-tabs-mode)
        (setq indent-tabs-mode t))

      (if (and (> space-count 0) ;; help user to pick a lane
               (> tab-count 0))
          (whitespace-mode 1)))))
(add-hook 'find-file-hook 'su/set-indent-tabs-mode)
