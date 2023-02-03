(bind-key* "C-h" 'delete-backward-char)

(use-package package
  :config
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (package-initialize))

(use-package dracula-theme
  :ensure t
  :config
  (load-theme 'dracula t))

(setq use-package-always-ensure t)

(use-package parinfer-rust-mode
  :hook emacs-lisp-mode
  :init
  (setq parinfer-rust-auto-download t))
