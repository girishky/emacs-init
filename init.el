;;; -*- lexical-binding: t; -*-

;;
;;Few things to install. Many of them are installed via homebrew
;; - pyright (for eglot to configure as python lsp)
;; - ruff (python code formatter for apheleia package)
;; - aspell, enchant (for spell-checking using jinx; for flyspell only aspell is enough)
;; - notmuch, isync (for notmuch email) if using mu4e, then install mu

(defun my-full-name () "Girish Kumar")

;; Store automatic customization options elsewhere
(setopt custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Add the NonGNU ELPA package archive
(require 'package)
(add-to-list 'package-archives  '("melpa" . "https://melpa.org/packages/"))
;; (unless package-archive-contents  (package-refresh-contents))

(use-package emacs
  :init
  (setopt inhibit-startup-screen t)
  (setopt initial-scratch-message nil)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  ;; (add-to-list 'frameset-filter-alist '(ns-transparent-titlebar . :never))
  ;; (add-to-list 'frameset-filter-alist '(ns-appearance . :never))
  (setopt ns-use-proxy-icon nil)
  ;; (setopt frame-title-format nil)
  (setopt frame-resize-pixelwise t)
  (setopt window-resize-pixelwise t)
  (setopt frame-inhibit-implied-resize t)
  (save-place-mode 1)
  (recentf-mode 1)
  (setopt electric-pair-mode t)
  (show-paren-mode t)
  (setopt show-paren-style 'mixed)
  (global-visual-line-mode t)
  (global-visual-wrap-prefix-mode t)
  (setopt column-number-mode t)
  (global-auto-revert-mode 1)
  (global-set-key [remap list-buffers] 'ibuffer)
  ;; Use spaces instead of tabs by default
  (setopt indent-tabs-mode nil)
  ;; (setq-default tab-width 4)
  (set-default-coding-systems 'utf-8)
  (set-language-environment "UTF-8")
  (setopt font-use-system-font t)
  ;; (set-frame-font "Cascadia Mono-14" nil t)
  (setopt default-frame-alist '((font . "Cascadia Mono-14")))
  (setopt delete-selection-mode t) ;; enable delete-selection-mode
  (winner-mode 1)

  ;; MacOS screen, when in fullscreen, jumps when i am in LaTeX buffer and view the compiled
  ;; pdf file. I use pdf-tools package for pdf files. I checked that setting system-tooltips variables to t fixes the issue.
  (setopt use-system-tooltips t)
  (setopt x-gtk-use-system-tooltips t)
  (setopt tooltip-mode nil)  ;;tooltip in echo area
  (setopt pdf-annot-tweak-tooltips nil)
  ;; file sizes in human-readable format
  (setq-default dired-listing-switches "-alh")
  (setopt mode-line-compact 'long)
  (setopt savehist-mode t)
  (setopt save-place-mode t)
  ;; Dired buffers are refreshed whenever revisiting
  (setopt dired-auto-revert-buffer t)
  ;; Show the current directory when prompting for a shell command
  (setopt shell-command-prompt-show-cwd t)
  (setopt compilation-scroll-output 'first-error)

  (setopt gc-cons-threshold 50000000) ;; reduce the frequency of garbage collection
  (setopt make-backup-files nil) ; I either have files version controlled or I will manually create backup.
  (setopt auto-save-default nil) ; I save so often myself that I don't have a need for this.
  (setopt create-lockfiles nil) ; I don't have a situation where multiple emacses want to edit the same file.

  ;; (setopt initial-major-mode 'org-mode) ; start the scratch buffer in Org mode.

  ;;;;from Emacs-Redux blog
  (setq-default bidi-display-reordering 'left-to-right
                bidi-paragraph-direction 'left-to-right)
  (setopt bidi-inhibit-bpa t)
  (setopt redisplay-skip-fontification-on-input t)
  (setopt read-process-output-max (* 1 1024 1024)) ; 1MB
  (setq-default cursor-in-non-selected-windows nil)
  (setopt highlight-nonselected-windows nil)
  (setopt save-interprogram-paste-before-kill t)
  (setopt kill-do-not-save-duplicates t)
  (setopt set-mark-command-repeat-pop t)
  

  :custom
  (use-short-answers t)
  (delete-by-moving-to-trash t)
  (trash-directory "~/.Trash")
  (epg-pinentry-mode 'loopback)
  ;; (auto-save-default nil)
  ;; (treesit-font-lock-level 4)
  (shr-use-fonts nil "disable variable fonts")
  (pixel-scroll-precision-mode t)
  (eldoc-echo-area-use-multiline-p nil)
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)
  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)
  ;; TAB cycle if there are only few candidates
  (completion-cycle-threshold 3)
  ;; ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; ;; Try `cape-dict' as an alternative.
  ;; (text-mode-ispell-word-completion 'cape-dict)
  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;;;; see post https://rahuljuliato.com/posts/emacs-31-around-the-corner for some Emacs 31 configuration below
  (treesit-auto-install-grammar 'ask)
  (treesit-enabled-modes t)
  (delete-pair-push-mark t)
  (ibuffer-human-readable-size t)
  (kill-region-dwim 'emacs-word)
  (view-lossage-auto-refresh t)
  (display-fill-column-indicator-warning t)

  :hook
  ((prog-mode  . display-line-numbers-mode)
   ;;(prog-mode  . flyspell-prog-mode)
   ;; (text-mode . flyspell-mode)
   )

  :bind
  ("M-o" . other-window)
  ("C-s-f" . toggle-frame-fullscreen))



(use-package ef-themes
  :ensure t
  :init
  (ef-themes-take-over-modus-themes-mode 1)
  :config
  (setopt modus-themes-mixed-fonts t)
  (setopt modus-themes-italic-constructs t)
  ;; (modus-themes-load-theme 'ef-duo-light)
  )


(use-package batppuccin
  :ensure t
  ;; :config
  ;; (load-theme 'batppuccin-mocha t)
  ) ;; mocha, macchiato, frappe, latte

(use-package tokyo-night
  :ensure t
  ;; :config
  ;; (load-theme 'tokyo-night t)
  ) ;; night, storm, moon, day

(defun my/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'tokyo-night-day t))
    ('dark (load-theme 'tokyo-night t))))

(add-hook 'ns-system-appearance-change-functions #'my/apply-theme)

(use-package which-key
  :ensure nil
  :init
  ;; show the popup faster (the default is a full second)
  (setopt which-key-idle-delay 0.3)
  (which-key-mode 1)
  )

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-count 10)   
  (vertico-resize t)   
  (vertico-cycle t))

(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word)))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring



(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))


(use-package pulsar
  :ensure t
  :bind
  ( :map global-map
    ("C-x l" . pulsar-pulse-line) ; overrides `count-lines-page'
    ("C-x L" . pulsar-highlight-permanently-dwim)  ; or use `pulsar-highlight-temporarily'
    )
  :init
  (pulsar-global-mode 1)
  :config
  (setq pulsar-delay 0.055)
  (setq pulsar-iterations 5)
  )

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
  (setopt register-preview-delay 0.5)
  (setopt xref-show-xrefs-function #'consult-xref
          xref-show-definitions-function #'consult-xref)
  :hook (completion-list-mode . consult-preview-at-point-mode)
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
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init
  (setopt prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure t
  :hook (embark-collect-mode . consult-preview-at-point-mode))


(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-history-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-cycle t)
  (corfu-auto-trigger ".") ;; Custom trigger characters
  (corfu-quit-no-match 'separator)
  )

(use-package dabbrev
  ;; ;; Swap M-/ and C-M-/
  ;; :bind (("M-/" . dabbrev-completion)
  ;;        ("C-M-/" . dabbrev-expand))
  :config
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
  (add-to-list 'dabbrev-ignored-buffer-modes 'authinfo-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode))

(use-package cape
  :ensure t
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-history)
  )


(use-package prescient
  :ensure t
  :config
  (prescient-persist-mode 1))

(use-package corfu-prescient
  :ensure t
  :after corfu prescient
  :custom
  (corfu-prescient-enable-sorting t)
  (corfu-prescient-override-sorting nil) ; Don't override `display-sort-function'
  ;; Filtering
  (corfu-prescient-enable-filtering nil) ; We want orderless to do the filtering
  :config
  (corfu-prescient-mode 1))

(use-package vertico-prescient
  :ensure t
  :after vertico prescient
  :custom
  (vertico-prescient-enable-sorting t)
  (vertico-prescient-override-sorting nil) ; Don't override `display-sort-function'
  ;; Filtering
  (vertico-prescient-enable-filtering nil) ; We want orderless to do the filtering
  :config
  (vertico-prescient-mode 1))


(use-package multiple-cursors
  :ensure t
  :bind (("C-S-m"       . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"         . mc/mark-all-like-this)
         ("C-c C->"       . mc/mark-more-like-this-extended)
         ))


(use-package expreg
  :ensure t
  :bind (("C-=" . expreg-expand)
         ("C--" . expreg-contract))
  :config
  (add-hook 'text-mode-hook
            (lambda ()
              (add-to-list 'expreg-functions #'expreg--sentence)))
  )

(use-package magit
  :ensure t
  :bind
  (("C-c g" . magit-file-dispatch))
  :custom
  (magit-git-executable "/opt/homebrew/bin/git")
  (magit-diff-refine-hunk 'all)
  (magit-repository-directories
   '(("~/Projects/" . 1)
     ("~/Side-projects/" . 1))))

(use-package diff-hl
  :ensure t
  :init
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 1)
  :hook (dired-mode . diff-hl-dired-mode)
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  )


(use-package eglot
  :ensure nil
  :config
  (add-to-list 'eglot-server-programs
               '(python-ts-mode . ("pyright-langserver" "--stdio")))
  ;; (add-to-list 'eglot-server-programs
  ;;              '(python-ts-mode . ("ty" "server")))
  (add-to-list 'eglot-server-programs
               '((LaTeX-mode bibtex-mode) . ("texlab")))
  ;; (add-to-list 'eglot-server-programs
  ;;              '(text-mode . ("harper-ls" "--stdio")))
  ;; (setq-default eglot-workspace-configuration
  ;;               '(:ty
  ;;                 (:inlayHints
  ;;                  (
  ;;                   :variableTypes :json-false
  ;;                   :callArgumentNames :json-false
  ;;                   )
  ;;                  )))
  :custom
  (eglot-send-changes-idle-time 0.2) ;; this is default
  (eglot-extend-to-xref t)
  
  :hook (((python-ts-mode). eglot-ensure)
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
	      ("C-c l e" . flymake-show-buffer-diagnostics)))


(use-package markdown-ts-mode
  :ensure nil
  :mode ("\\.md\\'" . markdown-ts-mode))


(use-package apheleia
  :ensure t
  :hook prog-mode
  :config
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff)))


(use-package flymake
  :ensure nil
  ;; :hook
  ;; (text-mode . flymake-mode)
  :config
  (setopt flymake-show-diagnostics-at-end-of-line 'short) ;; other option: 'short
  :bind (:map flymake-mode-map
              ("M-N" . flymake-goto-next-error)
	      ("M-P" . flymake-goto-prev-error)))

(use-package jinx
  :ensure t
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages))
  :custom
  (jinx-languages "en_US")
  :config
  ;; Exclude ordinary comments in every applicable major mode,
  ;; including Org, programming modes, and TeX.
  (dolist (face '(font-lock-comment-face
                  font-lock-comment-delimiter-face))
    (cl-pushnew face (alist-get t jinx-exclude-faces)))

  ;; Jinx checks these faces by default in programming modes.
  ;; Exclude them too if strings and doc comments should not be checked.
  (dolist (face '(font-lock-doc-face
                  font-lock-string-face))
    (cl-pushnew face (alist-get 'prog-mode jinx-exclude-faces)))

  ;; Additional TeX exclusions.
  (dolist (face '(font-latex-warning-face
                  tex-font-script-face
                  font-lock-constant-face))
    (cl-pushnew face (alist-get 'tex-mode jinx-exclude-faces))))



(use-package pdf-tools
  :ensure t
  ;; :mode ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  ;; :custom
  ;; (pdf-view-use-scaling t)
  ;; (pdf-view-resize-factor 1.1)
  ;; (pdf-view-display-size 'fit-page)
  ;; (pdf-view-continuous t)
  :config
  (pdf-tools-install)

  :hook ((pdf-view-mode .
                        (lambda () (setq-local ring-bell-function #'ignore)))
         (pdf-view-mode .
                        (lambda () (setq-local mode-line-format nil)))
         )
  )


(use-package auctex
  :ensure t
  :hook ((LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . turn-on-auto-fill)
         (LaTeX-mode . turn-on-visual-line-mode)
         (LaTeX-mode . TeX-fold-mode)
         (LaTeX-mode . prettify-symbols-mode)
         (LaTeX-mode . TeX-source-correlate-mode)
         ;; (LaTeX-mode . my-buffer-face-mode-variable)
         ;; (LaTeX-mode .  (lambda () (set (make-local-variable 'TeX-electric-math)
         ;;                                (cons "\\(" "\\)"))) )
         (LaTeX-mode .  (lambda () (set (make-local-variable 'TeX-electric-math)
                                        (cons "$" "$"))) )
         (plain-TeX-mode .   (lambda () (set (make-local-variable 'TeX-electric-math)
                                             (cons "$" "$"))))
         (LaTeX-mode .  (lambda () (setq-local fill-column 95)))
         ;; (LaTeX-mode .  (lambda () (setopt line-spacing 0.1)))
         ;; (LaTeX-mode . (lambda () (setopt olivetti-body-width 55)))
         )
  :config
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer)

  (set-default 'preview-default-document-pt 12)
  (set-default 'preview-scale-function 0.8)

  ;; Match preview image size to text size
  ;; (setopt preview-scale-function
  ;;       (lambda () (/ (face-attribute 'default :height) 120.0)))
  ;; (setopt preview-image-type 'dvipng) ;; or 'dvipng
  ;; ;; to go back from pdf file to tex file
  ;; (with-eval-after-load 'tex
  ;;   (define-key TeX-source-correlate-map [C-down-mouse-1]
  ;;               #'TeX-view-mouse))
  :custom
  (TeX-parse-self t) ; enable document parsing
  (TeX-auto-save t)
  (TeX-save-query nil) ; save file when compiling
  (TeX-PDF-mode t)
  (TeX-source-correlate-start-server t)
  (TeX-view-program-selection '((output-pdf "PDF Tools")))
  )


(use-package reftex
  :after auctex
  :custom
  (reftex-plug-into-AUCTeX t))

;; CDLatex settings
(use-package cdlatex
  :ensure t
  :hook (LaTeX-mode . turn-on-cdlatex)
  ;; :bind (:map cdlatex-mode-map 
  ;;             ("<tab>" . cdlatex-tab))
  :custom
  (cdlatex-takeover-dollar nil)
  (cdlatex-takeover-parenthesis nil))


(use-package dictionary
  :ensure nil
  :init
  ;; dictionary lookup in a sidebar instead of separate buffer window
  (setopt switch-to-buffer-obey-display-actions t)
  (add-to-list 'display-buffer-alist
               '("^\\*Dictionary\\*" display-buffer-in-side-window
		 (side . right)
		 (window-width . 70)))
  :bind ("C-c L" .  dictionary-lookup-definition)
  
  :custom
  (dictionary-server "dict.org"))

(use-package powerthesaurus
  :ensure t
  :bind
  ("M--" . powerthesaurus-lookup-word-dwim))


(use-package olivetti
  :ensure t
  :bind ("C-s-S-f" . olivetti-mode)
  :custom
  (olivetti-body-width 84)
  ;; (olivetti-style 'fancy)
  ;; (olivetti-minimum-body-width 66)
  :hook
  (olivetti-mode . (lambda ()
                     (setopt mode-line-format
                             (if olivetti-mode nil
                               (default-value 'mode-line-format)))
		     ;; (force-mode-line-update)
                     )))


(use-package popper
  :ensure t
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setopt popper-reference-buffers
          '("\\*Messages\\*"
            "Output\\*$"
            "\\*Async Shell Command\\*"
            "\\*Warnings\\*"
            "\\*Error\\*"
	    inferior-python-mode
            flymake-diagnostics-buffer-mode
            help-mode
            compilation-mode))
  ;; (setopt popper-group-function #'popper-group-by-project)
  ;; (setopt popper-group-function #'popper-group-by-directory) 
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
;;   (setopt message-citation-line-function
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

;;   (setopt mu4e-contexts
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

;; ;;----------------------------------------------------------------------------
;; ;; This I originally found on Mastering Emacs website but code didn't
;; ;; work and casued issue loading Emacs.  The following is a modified
;; ;; version of that one and works.
;; (defvar mode-line-cleaner-alist
;;   '((apheleia-mode . " AP")
;;     (python-ts-mode . "py")
;;     ))

;; (defun clean-mode-line ()
;;   "Shorten the mode line display for modes in `mode-line-cleaner-alist`."
;;   (dolist (cleaner mode-line-cleaner-alist)
;;     (let* ((mode (car cleaner))
;;            (mode-str (cdr cleaner))
;;            (old-mode-str (cdr (assq mode minor-mode-alist))))
;;       ;; Update minor mode display
;;       (when old-mode-str
;;         (setcar old-mode-str mode-str))
;;       ;; Update major mode display
;;       (when (eq mode major-mode)
;;         (setopt mode-name mode-str)))))

;; ;; Apply cleanup after major mode changes
;; (add-hook 'after-change-major-mode-hook #'clean-mode-line)
;; ;;----------------------------------------------------------------------------

;; suppress prompt when closing running processes like python
(setopt kill-buffer-query-functions
        (remq 'process-kill-buffer-query-function
              kill-buffer-query-functions))

;; ;; function to change the font of buffer
;; (defun my-buffer-face-mode-variable ()
;;   "Set font to a variable width (proportional) fonts in current buffer"
;;   (interactive)
;;   (setopt buffer-face-mode-face '(:family "Cascadia Code" :height 160))
;;   (buffer-face-mode 1))


(use-package gptel
  :ensure t
  ;; :bind (
  ;;        :map gptel-mode-map
  ;;        ("S-<return>" . gptel-send)
  ;;        )
  :config  
  (setopt
   gptel-model 'qwen3.8:27b-mlx
   gptel-backend (gptel-make-ollama "Ollama"   ;Any name of your choosing
                   :host "localhost:11434"     ;Where it's running
                   :stream t                   ;Stream responses
                   :models '(
                             "gemma4:31b-mxfp8"
                             "gemma4:26b-mxfp8"
                             "qwen3.8:27b-mxfp8"
                             "qwen3.8:27b-mlx"
                             "qwen3.6:35b-a3b-mxfp8"
                             ) ;List of models
                   ) 
   gptel-default-mode 'org-mode
   ;; gptel-include-reasoning nil
   ;; gptel-stream nil
   )
  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)

  (gptel-make-preset 'proofreader
    :description "Preset for proofreading tasks"
    :system "Fix spelling mistakes in the selected text"
    )
  )

;; (use-package gptel-agent
;;   :ensure t
;;   :after gptel
;;   :config (gptel-agent-update))         ;Read files from agents directories

(use-package gptel-agent
  :vc ( :url "https://github.com/karthink/gptel-agent"
        :rev :newest)
  :config (gptel-agent-update))         ;Read files from agents directories


;; (use-package agent-shell
;;   :ensure t
;;   :config
;;   (setopt agent-shell-goose-authentication
;;           (agent-shell-make-goose-authentication :none t)))


;; miscellaneous

(defun smart-open-line ()
  "Insert an empty line after the current line.
   Position the cursor at its beginning, according to the current mode.
   credit: emacsredux blog"
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

;; (global-set-key [(shift return)] #'smart-open-line)
(define-key prog-mode-map [(shift return)] #'smart-open-line)

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


(use-package org
  :ensure nil
  :hook
  (;; (org-mode . my-buffer-face-mode-variable) ;; custom font
   ;; (org-mode . turn-on-org-cdlatex)
   (org-mode . org-indent-mode))  ;; Make the indentation look nicer
  ;; :custom

  :bind
  (( "C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ( "C-c c" . org-capture))
  :config
  (setopt org-pretty-entities t)
  (setopt org-directory "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/")
  (setopt org-default-notes-file (expand-file-name "inbox.org" org-directory))
  (setopt org-agenda-files (file-expand-wildcards (concat org-directory "*.org")))
  (setopt org-archive-location
          (expand-file-name "archive.org::datetree/" org-directory))
  )


(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n o" . denote-open-or-create)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep))

  :custom
  (denote-directory (expand-file-name "~/Dropbox/thenotes/"))
  (denote-rename-buffer-mode 1))

(use-package denote-sequence
  :ensure t
  :after denote
  :bind
  ( :map global-map
    ;; Here we make "C-c n s" a prefix for all "[n]otes with [s]equence".
    ;; This is just for demonstration purposes: use the key bindings
    ;; that work for you.  Also check the commands:
    ;;
    ;; - `denote-sequence-new-parent'
    ;; - `denote-sequence-new-sibling'
    ;; - `denote-sequence-new-child'
    ;; - `denote-sequence-new-child-of-current'
    ;; - `denote-sequence-new-sibling-of-current'
    ("C-c n s s" . denote-sequence)
    ("C-c n s f" . denote-sequence-find)
    ("C-c n s l" . denote-sequence-link)
    ("C-c n s d" . denote-sequence-dired)
    ("C-c n s r" . denote-sequence-reparent)
    ("C-c n s c" . denote-sequence-convert))
  :custom
  ;; The default sequence scheme is `numeric'.
  (denote-sequence-scheme 'alphanumeric))


(use-package denote-journal
  :ensure t
  :after denote
  ;; ;; Bind those to some key for your convenience.
  ;; :commands ( denote-journal-new-entry
  ;;             denote-journal-new-or-existing-entry
  ;;             denote-journal-link-or-create-entry )
  ;; :hook (calendar-mode . denote-journal-calendar-mode)
  :bind
  ( :map global-map
    ("C-c n j n" . denote-journal-new-entry)
    ("C-c n j o" . denote-journal-new-or-existing-entry)
    ("C-c n j l" . denote-journal-link-or-create-entry))
  :custom
  ;; ;; Use the "journal" subdirectory of the `denote-directory'.  Set this
  ;; ;; to nil to use the `denote-directory' instead.
  ;; (denote-journal-directory
  ;;  "~/Library/Mobile Documents/com~apple~CloudDocs/a-journal")
  (denote-journal-directory (expand-file-name "~/Library/Mobile Documents/com~apple~CloudDocs/a-journal"))
  ;; Default keyword for new journal entries. It can also be a list of
  ;; strings.
  (denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (denote-journal-title-format 'day-date-month-year))


;; (use-package citar
;;   :ensure t
;;   :defer t
;;   :custom
;;   (citar-bibliography
;;    (append
;;     '("~/Zotero/library.bib")
;;     ;; (file-expand-wildcards "~/Projects/draft_*/*.bib")
;;     ))
;;   ;; Allow multiple notes per bibliographic entry
;;   (citar-open-always-create-notes nil)
;;   :hook
;;   (LaTeX-mode . citar-capf-setup)
;;   (org-mode . citar-capf-setup)
;;   :bind
;;   ("C-c w c" . citar-create-note))

;; (use-package citar-denote
;;   :ensure t
;;   :demand t ;; Ensure minor mode loads
;;   :after (:any citar denote)
;;   :custom
;;   ;; Package defaults
;;   (citar-denote-file-type 'org)
;;   (citar-denote-keyword "bib")
;;   (citar-denote-signature nil)
;;   (citar-denote-subdir nil)
;;   (citar-denote-template nil)
;;   (citar-denote-title-format "title")
;;   (citar-denote-title-format-andstr "and")
;;   (citar-denote-title-format-authors 1)
;;   (citar-denote-use-bib-keywords nil)
;;   :preface
;;   (bind-key "C-c w n" #'citar-denote-open-note)
;;   :init
;;   (citar-denote-mode)
;;   :bind
;;   ("C-c w d" . citar-denote-dwim))

;; (use-package citar-embark
;;   :ensure t
;;   :after (citar embark)
;;   :no-require
;;   :config (citar-embark-mode))


;; (use-package surround
;;   :ensure t
;;   :bind-keymap ("M-'" . surround-keymap))










;; ;; -------------------------------------------------------------------
;; ;; Asynchronous mail polling
;; ;; -------------------------------------------------------------------

;; (defun my/notmuch-refresh-buffers ()
;;   "Refresh all open Notmuch buffers."
;;   (dolist (buffer (buffer-list))
;;     (with-current-buffer buffer
;;       (when (derived-mode-p
;;              'notmuch-hello-mode
;;              'notmuch-search-mode
;;              'notmuch-show-mode
;;              'notmuch-tree-mode)
;;         (ignore-errors
;;           (notmuch-refresh-this-buffer))))))


;; (defun my/notmuch-poll-async ()
;;   "Run `notmuch new' asynchronously.

;; The Notmuch pre-new hook is expected to run mbsync.
;; Refresh open Notmuch buffers when synchronization finishes."
;;   (interactive)

;;   ;; Avoid launching multiple simultaneous mail syncs.
;;   (if (get-process "notmuch-new")

;;       (message "Mail sync already in progress.")

;;     (message "Syncing mail...")

;;     (notmuch-start-notmuch
;;      "notmuch-new"
;;      nil

;;      (lambda (process _event)
;;        (when (memq (process-status process) '(exit signal))

;;          (if (zerop (process-exit-status process))

;;              (progn
;;                (my/notmuch-refresh-buffers)
;;                (message "Mail sync complete."))

;;            (message
;;             "Mail sync failed; see buffer *notmuch-new*."))))

;;      "new")))

;; (use-package notmuch
;;   :ensure nil
;;   :load-path "/opt/homebrew/opt/notmuch/share/emacs/site-lisp/notmuch"
;;   :commands (notmuch notmuch-hello notmuch-search)
;;   :bind
;;   (("C-c m" . notmuch))

;;   :custom
;;   (notmuch-command "/opt/homebrew/bin/notmuch")
;;   (notmuch-search-oldest-first nil)
;;   ;; Cleaner hello screen.
;;   (notmuch-show-logo nil)
;;   ;; Opening a message marks it read.
;;   (notmuch-show-mark-read-tags '("-unread"))
;;   ;; Archive = remove inbox tag.
;;   (notmuch-archive-tags '("-inbox"))
;;   ;; Do not create another Sent copy locally.
;;   ;; Gmail SMTP will keep one for us.
;;   (notmuch-fcc-dirs nil)

;;   ;; Prefer text/plain, then rendered HTML.
;;   (notmuch-multipart/alternative-discouraged
;;    '("text/plain" "text/html"))


;;   ;; ;; dashboard
;;   ;; (notmuch-saved-searches
;;   ;;  '((:name "inbox"
;;   ;;           :query "tag:inbox"
;;   ;;           :key "i")
;;   ;;    (:name "unread"
;;   ;;           :query "tag:inbox and tag:unread"
;;   ;;           :key "u")
;;   ;;    (:name "today"
;;   ;;           :query "date:today"
;;   ;;           :key "t")
;;   ;;    (:name "week"
;;   ;;           :query "date:1week.."
;;   ;;           :key "w")
;;   ;;    (:name "attachments"
;;   ;;           :query "attachment:*"
;;   ;;           :key "a")
;;   ;;    ))
;;   :config
;;   ;; Use Notmuch as Emacs' mail user agent.
;;   (setopt mail-user-agent 'notmuch-user-agent)
;;   ;; Kill composition buffer after successful sending.
;;   (setopt message-kill-buffer-on-exit t)
;;   ;; Make G perform asynchronous synchronization.
;;   (define-key notmuch-hello-mode-map
;;               (kbd "G") #'my/notmuch-poll-async)

;;   (define-key notmuch-search-mode-map
;;               (kbd "G") #'my/notmuch-poll-async)

;;   (define-key notmuch-show-mode-map
;;               (kbd "G") #'my/notmuch-poll-async)

;;   (when (boundp 'notmuch-tree-mode-map)
;;     (define-key notmuch-tree-mode-map
;;                 (kbd "G") #'my/notmuch-poll-async))
;;   )

;; (use-package smtpmail
;;   :ensure nil
;;   :custom
;;   (smtpmail-smtp-server "smtp.gmail.com")
;;   (smtpmail-smtp-service 587)
;;   (smtpmail-stream-type 'starttls)
;;   (message-send-mail-function #'smtpmail-send-it)
;;   (send-mail-function #'smtpmail-send-it)
;;   )

;; (use-package auth-source
;;   :ensure nil
;;   :config
;;   (add-to-list 'auth-sources 'macos-keychain-internet)
;;   (add-to-list 'auth-sources 'macos-keychain-generic))

