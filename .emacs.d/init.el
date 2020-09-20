(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("446cc97923e30dec43f10573ac085e384975d8a0c55159464ea6ef001f4a16ba" default)))
 '(package-selected-packages
   (quote
    (yasnippet-snippets yapfify which-key vi-tilde-fringe use-package try pyvenv pdf-tools parent-mode paradox neotree helm-projectile helm-company gnu-elpa-keyring-update git-gutter-fringe general flycheck-pos-tip evil-magit evil-anzu dracula-theme doom-modeline company-statistics company-quickhelp company-anaconda column-enforce-mode color-theme-sanityinc-solarized benchmark-init base16-theme avy auto-complete))))
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
