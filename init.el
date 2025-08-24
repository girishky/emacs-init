;;
;;Few things to install. Many of them are installed via homebrew
;; - pyright (for eglot to configure as python lsp)
;; - ruff (python code formatter for apheleia package)
;; - aspell (for spell-checking)
;; - mu, isync (for mu4e email)

(defun my-full-name () "Girish Kumar")

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
  (setq inhibit-startup-screen t)
  (setq initial-scratch-message nil)
  (defun display-startup-echo-area-message ()
    (message ""))
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (setq ns-use-proxy-icon nil)
  (setq frame-title-format nil)
  (setq window-resize-pixelwise t)
  (setq frame-resize-pixelwise t)
  (save-place-mode 1)
  (recentf-mode 1)
  (electric-pair-mode 1)
  (show-paren-mode 1)
  (global-visual-line-mode 1)
  (setq column-number-mode t)
  (global-auto-revert-mode 1)
  (global-set-key [remap list-buffers] 'ibuffer)
  ;; Improve scrolling behavior
  (setq redisplay-dont-pause t
        scroll-margin 1
        scroll-step 1
        scroll-conservatively 10000
        scroll-preserve-screen-position 1)
  ;; Use spaces instead of tabs by default
  (setq-default indent-tabs-mode nil)
  ;; (setq-default tab-width 4)
  (set-default-coding-systems 'utf-8)
  (set-language-environment "UTF-8")
  ;;(set-frame-font "DejaVuSansM Nerd Font Mono 14" nil t) ;; set default font face
  (set-frame-font "Iosevka SS08-17" nil t)
  (delete-selection-mode 1) ;; enable delete-selection-mode
  (winner-mode 1)
  (tooltip-mode -1)  ;;tooltip in echo area

  :custom
  (use-short-answers t)
  (delete-by-moving-to-trash t)
  (trash-directory "~/.Trash")
  (epg-pinentry-mode 'loopback)
  ;; (auto-save-default nil)
  (treesit-font-lock-level 4)
  (shr-use-fonts nil "disable variable fonts")
  (eldoc-echo-area-use-multiline-p nil)
  (major-mode-remap-alist
   '((python-mode . python-ts-mode))) ;; use tree-sitter mode for Python

  :hook
  ((prog-mode  . display-line-numbers-mode)
   ;;(prog-mode  . flyspell-prog-mode)
   (text-mode . flyspell-mode))

  :bind
  ("M-o" . other-window)
  ("C-s-S-f" . toggle-frame-fullscreen))


;; (use-package apropospriate-theme
;;   :ensure t
;;   :config 
;;   (load-theme 'apropospriate-dark t))


(use-package doom-themes
  :ensure t
  :init
  ;; (load-theme 'doom-nord-light t) 
  ;; (load-theme 'doom-solarized-light t)
  (load-theme 'doom-zenburn t)
  )
;; (use-package atom-one-dark-theme
;;   :ensure t
;;   :config
;;   (load-theme 'atom-one-dark t))

(use-package which-key
  :ensure nil
  :init
  (setq which-key-idle-delay 0.5) ; Open after .5s instead of 1s
  (which-key-mode 1))

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-count 10)   
  (vertico-resize t)   
  (vertico-cycle t)    
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

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package beacon
  :ensure t
  :init (beacon-mode 1)
  :custom
  (beacon-blink-when-window-scrolls nil))

(use-package avy
  :ensure t
  :init
  (global-set-key (kbd "M-j") 'avy-goto-char-timer)
  :custom
  (avy-timeout-seconds 0.5) ;; default
  :bind  (("M-g g" . avy-goto-line)
          ;; ("M-g j" . avy-goto-char)
          ;; ("M-g M-j"     . avy-goto-word-1)
          ))

(use-package consult
  :ensure t
  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :hook
  (completion-list-mode . consult-preview-at-point-mode)
  :bind
  (("C-s" . consult-line)    
   ("C-x b" . consult-buffer)
   ("C-x 4 b" . consult-buffer-other-window)
   ("C-x 5 b" . consult-buffer-other-frame)
   ("C-x t b" . consult-buffer-other-tab)
   ("C-x r b" . consult-bookmark)           
   ("C-x p b" . consult-project-buffer)  
   ("C-x C-r" . consult-recent-file)))

(use-package embark
  :ensure t
  :bind
  (("C-s-." . embark-act)
   ("C-s-;" . embark-dwim) 
   ("C-h B" . embark-bindings)) 
  :config
  (setq prefix-help-command #'embark-prefix-help-command)
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode 1)
  (corfu-history-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0)
  (corfu-cycle t )
  (corfu-echo-documentation nil))


(use-package multiple-cursors
  :ensure t
  :bind (("C-S-m"       . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"         . mc/mark-all-like-this)
         ("C-c C->"       . mc/mark-more-like-this-extended)
         ))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package magit
  :ensure t
  :bind
  (("C-c g" . magit-file-dispatch))
  :custom
  (magit-git-executable "/opt/homebrew/bin/git")
  (magit-diff-refine-hunk 'all)
  (magit-repository-directories
   '(("~/repos/" . 1)))) 


(use-package eglot
  :ensure nil
  :config
  ;; (add-to-list 'eglot-server-programs
  ;;              '(python-ts-mode . ("pyright-langserver" "--stdio")))
  ;; (add-to-list 'eglot-server-programs
  ;;              '(text-mode . ("harper-ls" "--stdio")))
  :custom
  (eglot-send-changes-idle-time 0.5) ;; this is default
  (eglot-extend-to-xref t)
  :hook ((python-ts-mode . eglot-ensure)
	 ;; python-specific settings
         (python-ts-mode . (lambda ()
                             (setq-local indent-tabs-mode nil
                                         tab-width 4
                                         python-indent-offset 4
					 python-shell-interpreter ".venv/bin/python3"
					 python-shell-prompt-detect-failure-warning nil)
                             (superword-mode 1))))

  :bind (:map eglot-mode-map
              ("C-c l a" . eglot-code-actions)
              ("C-c l r" . eglot-rename)
              ("C-c l f" . eglot-format)
              ("C-c l d" . eldoc)
              ("C-c l o" . eglot-code-action-organize-imports)
              ("C-c l h" . eglot-inlay-hints-mode)
              ("C-c l q" . eglot-shutdown-all)
	      ("C-c l e"  . flymake-show-buffer-diagnostics)))


(use-package apheleia
  :ensure t
  :hook prog-mode
  :config
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff)))


(use-package flymake
  :ensure nil
  :bind (:map flymake-mode-map
              ("M-N" . flymake-goto-next-error)
	      ("M-P" . flymake-goto-prev-error)))

;; proselint
(use-package flymake-proselint
  :ensure t
  :hook
  (text-mode . (lambda ()
                 (flymake-mode)
                 (flymake-proselint-setup))))


(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :custom
  (pdf-view-resize-factor 1.1)
  :config
  (pdf-tools-install)
  ;;pdf-tools and Emacs in fullscreen shift my screen to naother
  ;;window before showing pdf. The following is a very poor solution
  ;;but works! There is probably better solution out there. Need to
  ;;check someday.
  (defun life-is-beautiful (&optional ARG) 
    (error "Life is beautiful!"))
  (advice-add 'pdf-view-goto-page :after #'life-is-beautiful)
  :hook ((LaTeX-mode .
                     (lambda () (setq ring-bell-function 'ignore)))
         (pdf-view-mode .
                        (lambda () (setq mode-line-format nil))))
  )

(use-package auctex
  :ensure t
  :hook ((LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . turn-on-auto-fill)
         (LaTeX-mode . turn-on-visual-line-mode)
         (LaTeX-mode . TeX-fold-mode)
         (TeX-mode . prettify-symbols-mode)
         (LaTeX-mode . TeX-source-correlate-mode)
         (LaTeX-mode . my-buffer-face-mode-variable)
         (LaTeX-mode .  (lambda () (set (make-local-variable 'TeX-electric-math)
                                        (cons "\\(" "\\)"))) )
         )
  :config
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer)
  ;; ;; to go back from pdf file to tex file
  ;; (with-eval-after-load 'tex
  ;;   (define-key TeX-source-correlate-map [C-down-mouse-1]
  ;;               #'TeX-view-mouse))
  :custom
  (TeX-parse-self t) ; enable document parsing
  (TeX-auto-save t)
  (TeX-save-query nil) ; save file when compiling
  (TeX-PDF-mode t)
  ;; view pdf inside emacs
  (TeX-view-program-selection '((output-pdf "PDF Tools")))
  )

(use-package reftex
  :after auctex
  :custom
  (reftex-plug-into-AUCTeX t))


(use-package dictionary
  :ensure nil
  :init
  ;; dictionary lookup in a sidebar instead of separate buffer window
  (setq switch-to-buffer-obey-display-actions t)
  (add-to-list 'display-buffer-alist
               '("^\\*Dictionary\\*" display-buffer-in-side-window
		 (side . right)
		 (window-width . 50)))
  :bind (("M-#" .  dictionary-lookup-definition)
	 :map text-mode-map
	 ("M-." . dictionary-lookup-definition))
  :custom
  (dictionary-server "dict.org"))



(defun my-nov-font-setup ()
  (face-remap-add-relative 'variable-pitch :family "DejaVu Sans" :height 140))

(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode)
  :custom
  (nov-text-width 70
                  )
  ;; (nov-variable-pitch nil) ;; use default emacs font
  :hook
  ((nov-mode . turn-on-visual-line-mode)
   (nov-mode . my-nov-font-setup)))


(use-package olivetti
  :ensure t
  :bind ("C-s-f" . olivetti-mode)
  :custom
  (olivetti-body-width 88)
  (olivetti-style 'fancy)
  (olivetti-minimum-body-width 88)
  :hook
  (olivetti-mode . (lambda ()
                     (setq mode-line-format
                           (if olivetti-mode nil
                             (default-value 'mode-line-format)))
		     (force-mode-line-update))))


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
          help-mode
          compilation-mode))
  ;; (setq popper-group-function #'popper-group-by-project)
  ;; (setq popper-group-function #'popper-group-by-directory) 
  (popper-mode 1)
  (popper-echo-mode 1))


;; ;; Load external file defining email & name functions
;; ;; Example code in the file:
;; ;;;         (defun gmail-address () "my_gmail_address")
;; ;; define simiallry functions for name and other email address
;; (load-file (expand-file-name "~/.my-mu4e-identity.el"))

;; (use-package mu4e
;;   :ensure nil
;;   :load-path  "/opt/homebrew/share/emacs/site-lisp/mu/mu4e/"
;;   :init
;;   (add-hook 'mu4e-view-mode-hook #'turn-on-visual-line-mode)
;;   (add-hook 'mu4e-compose-mode-hook #'turn-on-visual-line-mode)
;;   (add-hook 'mu4e-compose-mode-hook #'turn-off-auto-fill)

;;   :custom
;;   (mail-user-agent 'mu4e-user-agent)  ;; use mu4e for e-mail in Emacs
;;   (mu4e-mu-binary (executable-find "mu"))  ;; mu installed with homebrew
;;   (mu4e-maildir "~/.maildir")
;;   ;; command to sync imap servers:
;;   (mu4e-get-mail-command (concat (executable-find "mbsync") " -a"))
;;   (mu4e-update-interval (* 5 60))  ;; update every 5 min
;;   (mu4e-view-use-gnus t)
;;   (mu4e-compose-format-flowed t)
;;   (mu4e-headers-auto-update t)
;;   (fill-flowed-encode-column 990)
;;   (mu4e-attachment-dir "~/Documents") ;; folder to save attachment by default
;;   ;; rename files when moving - needed for mbsync
;;   (mu4e-change-filenames-when-moving t)
;;   ;; don't save message to Sent Messages, IMAP takes care of this
;;   (mu4e-sent-messages-behavior 'delete)
;;   (message-kill-buffer-on-exit t)
;;   (mu4e-compose-dont-reply-to-self t)
;;   ;; attempt to show images when viewing messages
;;   (mu4e-view-show-images t)
;;   ;; Disbale inline images in messages
;;   (gnus-inhibit-images t)
;;   ;; hide annoying "mu4e Retrieving mail..." msg in mini buffer:
;;   (mu4e-hide-index-messages t)
;;   ;; by default do not show related emails:
;;   (mu4e-headers-include-related nil)
;;   ;; hide duplicate messages
;;   ( mu4e-headers-skip-duplicates t)
;;   ;;  use Emacs' completion frameworks
;;   (mu4e-completing-read-function 'completing-read)
;;   ;; configure function to send mail
;;   (send-mail-function 'smtpmail-send-it)
;;   ;; confirm before sending mail
;;   (message-confirm-send t)
;;   ;; email signature imported from a file
;;   (message-signature nil)
;;   (message-signature-file "~/.my_signature_work")
;;   ;; use gmail style message citation
;;   (message-citation-line-format "On %a, %b %d, %Y at %R %Z, %f wrote:\n")
;;   (mu4e-context-policy 'pick-first) ;; start with the first (default) context;
;;   (mu4e-compose-context-policy 'ask) ;; ask for context if no context

;;   :config
;;   ;; show my timezone instead of UTC time
;;   (setq message-citation-line-function
;;         (lambda ()
;;           (message-insert-formatted-citation-line
;;            nil nil (car (current-time-zone)))))

;;   ;;Quickly switching between plain text and HTML mime type.
;;   (keymap-set mu4e-view-mode-map (kbd "K")
;;               (lambda ()
;;                 (interactive)
;;                 (gnus-article-jump-to-part 1)
;;                 (gnus-article-press-button)
;;                 (gnus-article-press-button)))


;;   ;; additional bookmarks
;;   (add-to-list 'mu4e-bookmarks
;;                ;; bookmark for unread messages in my Gmail All Mail
;;                '( :name "Unread Gmail All Mail"
;;                   :query "maildir:/gmail/Archive AND flag:unread"
;;                   :key ?A))

;;   (setq mu4e-contexts
;;         (list
;;          (make-mu4e-context
;;           :name "personal"
;;           :enter-func
;;           (lambda () (mu4e-message "Enter context personal Gmail"))
;;           :leave-func
;;           (lambda () (mu4e-message "Leave context personal Gmail"))
;;           :match-func (lambda (msg)
;;                         (when msg
;;                           (string-prefix-p "/gmail" (mu4e-message-field msg :maildir))))
;;           :vars `((user-mail-address . ,(my-gmail-address))
;;                   (user-full-name . ,(my-full-name))
;;                   (mu4e-drafts-folder . "/gmail/Drafts")
;;                   (mu4e-refile-folder . "/gmail/Archive")
;;                   (mu4e-sent-folder . "/gmail/Sent")
;;                   (mu4e-trash-folder . "/gmail/Trash")
;;                   (mu4e-maildir-shortcuts . (("/gmail/Inbox"   .   ?i)
;;                                              ("/gmail/Sent" . ?s)
;;                                              ("/gmail/Archive" . ?a)))
;; 	          (smtpmail-smtp-user . ,(my-gmail-address))
;; 	          (smtpmail-default-smtp-server . "smtp.gmail.com")
;; 	          (smtpmail-smtp-server . "smtp.gmail.com")
;;                   (smtpmail-smtp-service .  587)
;;                   (smtpmail-stream-type . starttls)
;;                   ))

;;          (make-mu4e-context
;;           :name "othergmail"
;;           :enter-func
;;           (lambda () (mu4e-message "Enter context other Gmail"))
;;           :leave-func
;;           (lambda () (mu4e-message "Leave context other Gmail"))
;;           :match-func (lambda (msg)
;;                         (when msg
;;                           (string-prefix-p "/othergmail" (mu4e-message-field msg :maildir))))
;;           :vars `((user-mail-address . ,(my-another-gmail-address))
;;                   (user-full-name . ,(my-full-name))
;;                   (mu4e-drafts-folder . "/othergmail/Drafts")
;;                   (mu4e-refile-folder . "/othergmail/Archive")
;;                   (mu4e-sent-folder . "/othergmail/Sent")
;;                   (mu4e-trash-folder . "/othergmail/Trash")
;;                   (mu4e-maildir-shortcuts . (("/othergmail/Inbox"   .   ?i)
;;                                              ( "/othergmail/Archive"   .   ?a)))
;; 	          (smtpmail-smtp-user . ,(my-another-gmail-address))
;; 	          (smtpmail-default-smtp-server . "smtp.gmail.com")
;; 	          (smtpmail-smtp-server . "smtp.gmail.com")
;;                   (smtpmail-smtp-service .  587)
;;                   (smtpmail-stream-type . starttls)
;;                   ))
;;          )))

;;----------------------------------------------------------------------------
;; This I originally found on Mastering Emacs website but code didn't
;; work and casued issue loading Emacs.  The following is a modified
;; version of that one and works.
(defvar mode-line-cleaner-alist
  '((apheleia-mode . " AP")
    (python-ts-mode . "py")
    ))

(defun clean-mode-line ()
  "Shorten the mode line display for modes in `mode-line-cleaner-alist`."
  (dolist (cleaner mode-line-cleaner-alist)
    (let* ((mode (car cleaner))
           (mode-str (cdr cleaner))
           (old-mode-str (cdr (assq mode minor-mode-alist))))
      ;; Update minor mode display
      (when old-mode-str
        (setcar old-mode-str mode-str))
      ;; Update major mode display
      (when (eq mode major-mode)
        (setq mode-name mode-str)))))

;; Apply cleanup after major mode changes
(add-hook 'after-change-major-mode-hook #'clean-mode-line)
;;----------------------------------------------------------------------------


;; function to change the font of buffer
(defun my-buffer-face-mode-variable ()
  "Set font to a variable width (proportional) fonts in current buffer"
  (interactive)
  (setq buffer-face-mode-face '(:family "iA Writer Duo S" :height 140))
  (buffer-face-mode))


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



;; org-mode
(global-set-key (kbd "C-c L") #'org-store-link)
(global-set-key (kbd "C-c A") #'org-agenda)
(global-set-key (kbd "C-c C") #'org-capture)
;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)


;; miscellaneous

(defun smart-open-line ()
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode.
credit: emacsredux blog"
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(global-set-key [(shift return)] #'smart-open-line)

;; half-screen scrolling (karthink blog)
(defun scroll-up-half ()
  (interactive)
  (scroll-up-command
   (floor
    (- (window-height)
       next-screen-context-lines)
    2)))

(defun scroll-down-half ()
  (interactive)
  (scroll-down-command
   (floor
    (- (window-height)
       next-screen-context-lines)
    2)))

(global-set-key (kbd "C-v") #'scroll-up-half)
(global-set-key (kbd "M-v") #'scroll-down-half)

(defun mark-whole-line ()
  "Select the current line."
  (interactive)
  (beginning-of-line)
  (set-mark (point))
  (end-of-line))
(global-set-key (kbd "C-S-l") 'mark-whole-line)


(global-set-key (kbd "C-c D") #'disable-theme)
(global-set-key (kbd "C-c T") #'consult-theme)

(use-package elfeed
  :ensure t
  :bind ("C-c f" . elfeed)
  :config
  (setq elfeed-feeds
        '(("https://rss.arxiv.org/atom/hep-ph" hep-ph physics)
          ("https://rss.arxiv.org/atom/hep-ex" hep-ex physics)))

  )



