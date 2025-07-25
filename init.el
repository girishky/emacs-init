;; Basic UI configuration
(setq inhibit-startup-screen t)
;; (menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Store automatic customization options elsewhere
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Add the NonGNU ELPA package archive
(require 'package)
(add-to-list 'package-archives  '("melpa" . "https://melpa.org/packages/"))
;; (unless package-archive-contents  (package-refresh-contents))

(use-package emacs
  :init
  (setq initial-scratch-message nil)
  (defun display-startup-echo-area-message ()
    (message ""))
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (setq ns-use-proxy-icon nil)
  (setq frame-title-format nil)
  ;; (setq-default mode-line-format nil)
  (setq window-resize-pixelwise t)
  (setq frame-resize-pixelwise t)
  (save-place-mode 1)
  (recentf-mode 1)
  (electric-pair-mode 1)
  (show-paren-mode 1)
  (global-visual-line-mode 1)
  (setq column-number-mode t)
  (defalias 'yes-or-no-p 'y-or-n-p)
  (setq auto-save-default nil)
  (global-auto-revert-mode 1)
  (setq treesit-font-lock-level 4)
  (setq eldoc-echo-area-use-multiline-p nil)
  (global-set-key [remap list-buffers] 'ibuffer)
  (setq delete-by-moving-to-trash t)
  ;; Improve scrolling behavior
  (setq redisplay-dont-pause t
        scroll-margin 1
        scroll-step 1
        scroll-conservatively 10000
        scroll-preserve-screen-position 1)
  ;; Use spaces instead of tabs by default
  (setq-default indent-tabs-mode nil)
  ;; Set a reasonable default tab width
  (setq-default tab-width 4)
  ;; Set default font face
  (set-face-attribute 'default nil :font "Atkinson Hyperlegible Mono-16")
  ;; (set-face-attribute 'default nil :font "IBM Plex Mono-14") ;

  ;; Enable delete-selection-mode
  (delete-selection-mode 1)
  (winner-mode 1)
  ;; (tab-bar-mode 1)
  (windmove-default-keybindings)
  :config
  ;; Use tree-sitter mode for Python
  (setq major-mode-remap-alist
        '((python-mode . python-ts-mode)))
  (setq python-shell-interpreter ".venv/bin/python3")
  (setq python-shell-prompt-detect-failure-warning nil)

  (with-eval-after-load 'eglot
    ;; (add-to-list 'eglot-server-programs
    ;;              '(python-ts-mode . ("pyright-langserver" "--stdio")))
    (add-to-list 'eglot-server-programs
                 '(text-mode . ("harper-ls" "--stdio"))))
  ;; Enable relative line numbers in programming modes
  :hook ((prog-mode . (lambda () (setq display-line-numbers 'relative)))
         (LaTeX-mode . (lambda () (setq display-line-numbers 'relative)))
         (python-ts-mode . eglot-ensure)
         ;; (text-mode . eglot-ensure)
         )
  :bind
  ("M-o" . other-window)
  ("C-s-S-f" . toggle-frame-fullscreen)
  ("C-c l d" . xref-find-definitions)
  ("C-c l r" . xref-find-references) 
  ("C-c l a" . eglot-code-actions)  
  ("C-c l R" . eglot-rename)       
  ("C-c l f" . eglot-format-buffer)
  ("C-c l h" . eldoc)             
  ("C-c l e"  . flymake-show-buffer-diagnostics)
  ("M-n" . flymake-goto-next-error)
  ("M-p" . flymake-goto-prev-error)) 


(use-package which-key
  :init
  (setq which-key-idle-delay 0.5) ; Open after .5s instead of 1s
  ;; :after evil
  :config
  (which-key-mode 1)
  ;; (which-key-setup-minibuffer)
  ;; (setq which-key-popup-type 'minibuffer)
  )

;; (use-package evil
;;   :ensure t
;;   :config
;;   (evil-mode 1)
;;   (define-key evil-normal-state-map (kbd "C-s-u") 'evil-scroll-up))

(use-package vertico
  :ensure t
  :custom
  (vertico-count 10)   
  (vertico-resize t)   
  (vertico-cycle t)    
  :init
  (vertico-mode)
  :bind
  (:map vertico-map
        ("RET" . vertico-directory-enter)
        ("DEL" . vertico-directory-delete-word)
        ("M-d" . vertico-directory-delete-char)))


(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :ensure t
  :bind
  (("C-s" . consult-line)    
   ("C-x b" . consult-buffer)
   ("C-x 4 b" . consult-buffer-other-window)
   ("C-x 5 b" . consult-buffer-other-frame)
   ("C-x t b" . consult-buffer-other-tab)
   ("C-x r b" . consult-bookmark)           
   ("C-x p b" . consult-project-buffer)  
   ("C-x C-r" . consult-recent-file))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  )

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package embark
  :ensure t
  :bind
  (("C-s-." . embark-act)
   ("C-s-;" . embark-dwim) 
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode 1)
  (corfu-history-mode 1)
  :config
  ;; (add-hook 'prog-mode-hook #'corfu-mode)
  (setq corfu-auto t
        corfu-auto-delay 0
        corfu-cycle t 
        corfu-echo-documentation nil)
  ) 
(use-package popper
  :ensure t
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          "\\*Warnings\\*"
          "\\*Error\\*"
	      inferior-python-mode
          flymake-diagnostics-buffer-mode
          
	      ;; dired-mode
	      ;; emacs-lisp-mode
	      ;; magit-refs-mode
          help-mode
          compilation-mode))
  ;; (setq popper-group-function #'popper-group-by-project)
  ;; (setq popper-group-function #'popper-group-by-directory) 
  (popper-mode +1)
  (popper-echo-mode +1))


(use-package magit
  :ensure t
  :bind
  (("C-c g" . magit-file-dispatch))
  :custom
  (magit-git-executable "/opt/homebrew/bin/git")
  :config
  (setq magit-diff-refine-hunk 'all)
  (setq magit-repository-directories
        '(("~/Documents/repos/" . 2))))


(use-package apheleia
  :ensure t
  :hook
  ((latex-mode . (lambda () (apheleia-mode -1)))
   (LaTeX-mode . (lambda () (apheleia-mode -1))))
  :config
  (apheleia-global-mode t)
  (with-eval-after-load 'apheleia
    (setf (alist-get 'python-mode apheleia-mode-alist)
          '(ruff-isort ruff))
    (setf (alist-get 'python-ts-mode apheleia-mode-alist)
          '(ruff-isort ruff))))


(use-package beacon
  :ensure t
  :init
  (beacon-mode 1)
  :config
  (setq beacon-blink-when-window-scrolls nil))


(use-package olivetti
  :ensure t
  ;; :defer
  :bind ("C-s-f" . olivetti-mode)
  :init
  (setq olivetti-body-width 80)
  (setq olivetti-style 'fancy)
  (setq olivetti-minimum-body-width 72)
  :hook
  (olivetti-mode . (lambda ()
                     (setq mode-line-format (if olivetti-mode nil (default-value 'mode-line-format)))
                     (force-mode-line-update))))


;; (use-package doom-modeline
;;   :ensure t
;;   :after evil
;;   :init (doom-modeline-mode 1)
;;   (setq doom-modeline-vcs-max-length 25)
;;   (setq doom-modeline-modal-icon nil
;;         evil-normal-state-tag   (propertize "<N>")
;;         evil-emacs-state-tag    (propertize "[Emacs]" )
;;         evil-insert-state-tag   (propertize "<I>")
;;         evil-motion-state-tag   (propertize "[Motion]")
;;         evil-visual-state-tag   (propertize "<V>")
;;         evil-operator-state-tag (propertize "[Operator]"))
;;   )


(use-package doom-themes
  :ensure t
  :config
  ;; (load-theme 'doom-solarized-light t)
  (load-theme 'doom-oceanic-next t)
  )


;; (use-package atom-one-dark-theme
;;   :ensure t
;;   :init
;;   (load-theme 'atom-one-dark t))

;; (use-package gptel
;;   :ensure t
;;   :config  
;;   (setq
;;    gptel-model 'mistral-nemo:latest
;;    gptel-backend (gptel-make-ollama "Ollama"   ;Any name of your choosing
;;                    :host "localhost:11434"     ;Where it's running
;;                    :stream t                   ;Stream responses
;;                    :models '("gemma3:1b" "mistral-nemo:latest"))) ;List of models
;;   (setq gptel-default-mode 'org-mode))


(use-package auctex
  :ensure t
  :defer t
  :hook ((LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . turn-on-reftex)
         ;; (LaTeX-mode . TeX-source-correlate-mode)
         ;; (LaTeX-mode . flyspell-mode)
         (LaTeX-mode . turn-on-auto-fill)
         (LaTeX-mode . my-buffer-face-mode-variable))
  :config
  (setq TeX-PDF-mode t)
  (setq TeX-auto-save t)
  (setq TeX-save-query nil)
  (setq TeX-parse-self t)
  ;; (setq-default TeX-master nil)
  )

(use-package reftex
  :defer t
  :config
  (setq reftex-plug-into-AUCTeX t)
  )

(use-package ebib
  :ensure t
  :defer t
  :bind ("C-c e" . ebib)
  )

;; Use variable width font faces in current buffer
(defun my-buffer-face-mode-variable ()
  "Set font to a variable width (proportional) fonts in current buffer"
  (interactive)
  (setq buffer-face-mode-face '(:family "Source Code Pro" :height 160))
  (buffer-face-mode))

;; Load external file defining email & name functions
(load-file (expand-file-name "~/.mu4e-identity.el"))

(use-package mu4e
  :ensure nil
  :load-path  "/opt/homebrew/share/emacs/site-lisp/mu/mu4e/"
  :config
  ;; we installed this with homebrew
  (setq mu4e-mu-binary (executable-find "mu")
        ;; this is the directory we created before:
        mu4e-maildir "~/.maildir"
        ;; this command is called to sync imap servers:
        mu4e-get-mail-command (concat (executable-find "mbsync") " -a")
        ;; how often to call it in seconds:
        mu4e-update-interval 300
        mu4e-headers-auto-update t
        mu4e-compose-format-flowed t
        ;; save attachment to desktop by default
        mu4e-attachment-dir "~/Documents"
        ;; rename files when moving - needed for mbsync:
        mu4e-change-filenames-when-moving t)

  (setq mu4e-contexts
        (list
         (make-mu4e-context
          :name "Gmail"
          :enter-func
          (lambda () (mu4e-message "Enter context personal Gmail"))
          :leave-func
          (lambda () (mu4e-message "Leave context personal Gmail"))
          :match-func (lambda (msg)
                        (when msg
                          (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
          :vars `((user-mail-address . ,(gmail-address))
                  (user-full-name . ,(full-name))
                  (mu4e-drafts-folder . "/Gmail/Drafts")
                  (mu4e-refile-folder . "/Gmail/Archive")
                  (mu4e-sent-folder . "/Gmail/Sent")
                  (mu4e-trash-folder . "/Gmail/Trash")
                  (mu4e-maildir-shortcuts . (( "/Gmail/Inbox"   .   ?i)
                                             ("/Gmail/Sent" . ?s)))
                  (message-send-mail-function . smtpmail-send-it)
                  (smtpmail-smtp-service .  587)
                  (smtpmail-default-smtp-server . "smtp.gmail.com")
                  (smtpmail-smtp-server .  "smtp.gmail.com")
                  ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
                  (mu4e-sent-messages-behavior . delete)
                  ))
         )
        )

  (setq mu4e-context-policy 'pick-first) ;; start with the first (default) context;
  (setq mu4e-compose-context-policy 'ask) ;; ask for context if no context matches;
  (setq  message-confirm-send t
         message-signature nil
         message-signature-file "~/.signature_work")
                                        ;
  ;; don't keep message buffers around
  (setq message-kill-buffer-on-exit t
        mu4e-compose-dont-reply-to-self t
        ;; attempt to show images when viewing messages
        mu4e-view-show-images t
        ;; Disbale inline images in messages
        gnus-inhibit-images t
        ;; hide annoying "mu4e Retrieving mail..." msg in mini buffer:
        mu4e-hide-index-messages t
        ;; by default do not show related emails:
        mu4e-headers-include-related nil
        ;; hide duplicate messages
        mu4e-headers-skip-duplicates t
        )
  ;; Quickly switching between plain text and HTML mime type.
  (keymap-set mu4e-view-mode-map (kbd "K")
              (lambda ()
                (interactive)
                (gnus-article-jump-to-part 1)
                (gnus-article-press-button)
                (gnus-article-press-button)))
  (with-eval-after-load 'mm-decode
    (add-to-list 'mm-discouraged-alternatives "text/html")
    (add-to-list 'mm-discouraged-alternatives "text/richtext"))

  (add-hook 'mu4e-view-mode-hook 'my-buffer-face-mode-variable)
  (add-hook 'mu4e-thread-mode-hook #'mu4e-thread-fold-apply-all)
  )

