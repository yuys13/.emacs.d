(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p (expand-file-name custom-file))
    (load custom-file))

(bind-key* "C-h" 'delete-backward-char)
(windmove-default-keybindings)

(use-package package
  :config
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (package-initialize))

(use-package dracula-theme
  :ensure t
  :config
  (load-theme 'dracula t))

(setq use-package-always-ensure t)

(use-package magit)

(use-package ddskk
  :bind (("C-x C-j" . 'skk-mode))
  :config
  (setq skk-sticky-key ";")
  (setq skk-auto-insert-paren t))

(use-package parinfer-rust-mode
  :hook emacs-lisp-mode
  :init
  (setq parinfer-rust-auto-download t))

;; Don't be evil...
;; But keep an evil mode inside for emergencies!!
(use-package evil)
;;  :config
;;  (evil-mode t))
(use-package key-chord
  :config
  (setq key-chord-two-keys-delay 0.5)
  (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
  (key-chord-mode t))
(use-package evil-surround
  :config
  (global-evil-surround-mode t))

(use-package company
  :config
  (global-company-mode t)
  (define-key company-active-map (kbd "C-h") nil))

;; Enable vertico
(use-package vertico
  :init
  (vertico-mode)
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode)) 

(use-package consult
  :bind
  (("C-x M-:" . consult-complex-command)
   ("C-x b" . consult-buffer)
   ("C-x 4b" . consult-buffer-other-window)
   ("C-x 5b" . consult-buffer-other-frame)
   ("C-x r b" . consult-bookmark)
   ("C-x p b" . consult-project-buffer)
   ("M-y" . consult-yank-pop)
   ("M-g f" . consult-flymake)
   ;;
   ("C-s" . consult-line))
  :config
  (setq consult-find-command "fd --color=never --full-path ARG OPTS"))

(use-package embark
  :bind(("C-." . embark-act)))

(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult-ghq)
