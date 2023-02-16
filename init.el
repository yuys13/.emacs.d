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
(use-package evil
  :bind
  (:map evil-normal-state-map
    ("SPC /" . consult-line)
    ("C-k" . embark-act))
  (:map evil-insert-state-map
    ("C-n" . nil)
    ("C-p" . nil)))
;;  :config
;;  (evil-mode t))
(use-package key-chord
  :after evil
  :config
  (setq key-chord-two-keys-delay 0.5)
  (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
  (key-chord-mode t))
(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode t))

(use-package corfu
  :bind
  (:map corfu-map
    ("RET" . nil))
    ;;("C-y" . 'corfu-insert)
    ;;("C-e" . 'corfu-quit))
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t)
  (setq corfu-auto-delay 0)
  (setq corfu-preselect-first nil)
  (corfu-popupinfo-mode t))

(defun corfu-enable-in-minibuffer ()
  "Enable Corfu in the minibuffer if `completion-at-point' is bound."
  (when (where-is-internal #'completion-at-point (list (current-local-map)))
    ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
    (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                corfu-popupinfo-delay nil)
    (corfu-mode 1)))
(add-hook 'minibuffer-setup-hook #'corfu-enable-in-minibuffer)

(use-package cape
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))
  ;;(add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-ispell)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)

(use-package corfu-terminal
  :config
  (unless (display-graphic-p)
    (corfu-terminal-mode +1)))

(use-package kind-icon
  :after corfu
  :config
  (setq kind-icon-default-face 'corfu-default)
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

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

(use-package eglot
  :config
  (defun deno-project-p ()
    "Predicate for determining if the open project is a Deno one."
    (let ((p-root (project-root (project-current))))
      (file-exists-p (concat p-root "deno.json"))))

  (defun es-server-program (_)
      "Decide which server to use for ECMA Script based on project characteristics."
      (cond ((deno-project-p) '("deno" "lsp" :initializationOptions (:enable t :lint t)))
            (t                '("typescript-language-server" "--stdio"))))

  (add-to-list 'eglot-server-programs '((js-mode typescript-mode) . es-server-program)))
