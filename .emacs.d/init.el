(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("ab729ed3a8826bf8927b16be7767aa449598950f45ddce7e4638c0960a96e0f1" "dcdd1471fde79899ae47152d090e3551b889edf4b46f00df36d653adc2bf550d" default)))
 '(package-selected-packages
   (quote
    (auto-complete nlinum-relative try which-key use-package evil dracula-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Download use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package evil
  :ensure t ;; install the evil package if not installed
  :init ;; tweak evil's configuration before loading it
  (setq evil-want-C-u-scroll t)
  :config ;; tweak evil after loading it
  (evil-mode))

(use-package nlinum-relative
  :ensure t
  :config
  ;; something else you want
  (nlinum-relative-setup-evil)
  (add-hook 'prog-mode-hook 'nlinum-relative-mode)
  (setq nlinum-relative-redisplay-delay 0))

(use-package auto-complete
  :ensure t
  :config
  (ac-config-default))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package try
  :ensure t)

(use-package dracula-theme
  :ensure t
  :config
  (load-theme 'dracula))

(scroll-bar-mode -1) ;; disable scrool bar
(tool-bar-mode -1) ;; disable toolba
(menu-bar-mode -1) ;; remove menu bar

;; set default font
(set-face-attribute 'default nil
		    :family "fira code"
		    :height 140)
 ;; Determine the specific system type. 
 ;; Emacs variable system-type doesn't yet have a "wsl/linux" value,
 ;; so I'm front-ending system-type with my variable: sysTypeSpecific.
 ;; I'm no elisp hacker, so I'm diverging from the elisp naming convention
 ;; to ensure that I'm not stepping on any pre-existing variable.
 (setq-default sysTypeSpecific  system-type) ;; get the system-type value
 
 (cond 
  ;; If type is "gnu/linux", override to "wsl/linux" if it's WSL.
  ((eq sysTypeSpecific 'gnu/linux)  
   (when (string-match "Linux.*Microsoft.*Linux" 
                       (shell-command-to-string "uname -a"))
 
     (setq-default sysTypeSpecific "wsl/linux") ;; for later use.
     (setq
      cmdExeBin"/mnt/c/Windows/System32/cmd.exe"
      cmdExeArgs '("/c" "start" "") )
     (setq
      browse-url-generic-program  cmdExeBin
      browse-url-generic-args     cmdExeArgs
      browse-url-browser-function 'browse-url-generic)
     )))

;; set backup directory
(setq backup-directory-alist `(("." . "~/.saves")))
