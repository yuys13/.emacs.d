;;; init.el --- My init.el

;;; Commentary:

;; My init.el

;;; Code:
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p (expand-file-name custom-file))
  (load custom-file))

;; Initialize use-package
(eval-and-compile
  (if (>= emacs-major-version 29)
      (progn
        (require 'use-package)
        (use-package package
          :config
          (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
          (package-initialize)))
    (progn
      (require 'package)
      (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
      (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
      (package-initialize)
      (unless (package-installed-p 'use-package)
        (package-refresh-contents)
        (package-install 'use-package))
      (require 'use-package))))

(bind-key* "C-h" 'delete-backward-char)
(windmove-default-keybindings)
(global-display-line-numbers-mode t)
(global-hl-line-mode t)
(setq scroll-conservatively 1)

(setq use-package-always-ensure t)

(use-package ediff
  :custom
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-split-window-function 'split-window-horizontally))

(use-package whitespace
  :init
  (global-whitespace-mode)
  :custom
  (whitespace-style '(face
                      trailing
                      tabs
                      ;; spaces
                      ;; lines
                      newline
                      missing-newline-at-eof
                      ;; empty
                      ;; indentation
                      ;; space-mark
                      tab-mark)))

(use-package diminish)

(require 'color)
(use-package highlight-indent-guides
  :diminish
  :hook
  ((prog-mode yaml-mode) . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-auto-enabled t)
  (highlight-indent-guides-responsive t)
  (highlight-indent-guides-method 'column)
  :config
  (defun my-highlight-indent-guides-auto-set-faces (func &rest args)
    "Emurate Emacs 28.2"
    (cl-letf (((symbol-function 'color-lighten-hsl)
               (lambda (H S L percent)
                 "color-lighten-hsl from Emacs 28.2"
                 (list H S (color-clamp (+ L (/ percent 100.0)))))))
      (apply func args)))
  (advice-add 'highlight-indent-guides-auto-set-faces :around 'my-highlight-indent-guides-auto-set-faces))

(use-package dracula-theme)

(use-package modus-themes
  :custom
  (modus-themes-to-toggle
   '(modus-vivendi-deuteranopia
     modus-operandi-deuteranopia))
  :config
  (load-theme 'modus-vivendi-deuteranopia t))

(use-package editorconfig
  :diminish
  :config
  (editorconfig-mode 1))

(use-package recentf
  :defines recentf-auto-save-timer
  :init
  (recentf-mode 1)
  (setq recentf-auto-save-timer
        (run-with-idle-timer 30 t 'recentf-save-list))
  :custom
  (recentf-max-saved-items 2000)
  (recentf-exclude '(".recentf"))
  (recentf-auto-cleanup 10))

(use-package which-key
  :diminish
  :init
  (which-key-mode))

(use-package magit)

(use-package git-gutter
  :config
  (global-git-gutter-mode t))

(use-package ddskk
  :bind (("C-x C-j" . skk-mode))
  :custom
  (skk-user-directory (locate-user-emacs-file "ddskk")))

(use-package ddskk-posframe
  :custom
  (ddskk-posframe-mode t))

(use-package parinfer-rust-mode
  :hook emacs-lisp-mode
  :custom
  (parinfer-rust-auto-download t))

;; Don't be evil...
;; But keep an evil mode inside for emergencies!!
(use-package evil
  :commands (evil-mode evil-local-mode)
  :init
  (setq evil-search-module 'evil-search)
  :config
  (bind-keys :map evil-normal-state-map
             ("SPC /" . consult-line)
             ("C-k" . embark-act))
  (bind-keys :map evil-insert-state-map
             ("C-n" . nil)
             ("C-p" . nil)))
(use-package key-chord
  :after evil
  :custom
  (key-chord-two-keys-delay 0.5)
  :config
  (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
  (key-chord-mode t))
(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode t))

(use-package corfu
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode t)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0)
  (corfu-preselect 'prompt)
  :config
  (bind-keys :map corfu-map
             ;; ("C-y" . 'corfu-insert)
             ;; ("C-e" . 'corfu-quit)
             ("RET" . nil)))

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
  :unless (display-graphic-p)
  :config
  (corfu-terminal-mode +1))

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; Enable vertico
(use-package vertico
  :functions crm-indicator
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
  (setq enable-recursive-minibuffers t)
  :custom
  (vertico-preselect 'prompt))

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
   ("C-s" . consult-line)))

(use-package embark
  :bind(("C-." . embark-act)))

(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult-ghq
  :after (affe))

(use-package affe)

(use-package flycheck
  :init
  (global-flycheck-mode))

(use-package yasnippet
  :init
  (yas-global-mode 1))

(use-package lsp-mode
  :defines lsp-lua-runtime-version lsp-lua-diagnostics-globals lsp-lua-workspace-library
  :custom
  (lsp-keymap-prefix "C-c l")
  :hook
  (((sh-mode lua-mode vimrc-mode) . lsp-deferred)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp lsp-deferred
  :config
  (setq lsp-lua-runtime-version "LuaJIT")
  (setq lsp-lua-diagnostics-globals '((vim)))
  (when (executable-find "nvim")
    (setq lsp-lua-workspace-library (ht ((concat (file-name-as-directory (shell-command-to-string "nvim --headless \"+echo stdpath('data')\" +qa")) "lazy") t)))))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package consult-lsp)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package lua-mode)
(use-package vimrc-mode)

(use-package ellama
  :init
  (require 'llm-ollama)
  :custom
  (ellama-language "Japanese")
  (ellama-provider
   (make-llm-ollama
    :chat-model "mistral" :embedding-model "mistral")))

;;; init.el ends here
