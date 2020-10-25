(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "446cc97923e30dec43f10573ac085e384975d8a0c55159464ea6ef001f4a16ba" default)))
 '(package-selected-packages
   (quote
    (htmlize magithub spaceline smart-mode-line company yasnippet-snippets yapfify which-key vi-tilde-fringe use-package try pyvenv pdf-tools parent-mode paradox neotree helm-projectile helm-company gnu-elpa-keyring-update git-gutter-fringe general flycheck-pos-tip evil-anzu dracula-theme doom-modeline company-statistics company-quickhelp company-anaconda column-enforce-mode color-theme-sanityinc-solarized benchmark-init base16-theme avy auto-complete)))
 '(paradox-github-token t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; load init file
(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/machine_config.org"))
