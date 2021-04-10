(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("446cc97923e30dec43f10573ac085e384975d8a0c55159464ea6ef001f4a16ba" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   (quote
    (evil-smartparens smartparens tide yasnippet-snippets yapfify which-key vi-tilde-fringe use-package try spaceline smart-mode-line pyvenv pdf-tools paradox neotree magithub htmlize helm-projectile helm-company git-gutter-fringe general evil-anzu dracula-theme doom-modeline dashboard company-statistics company-solidity company-quickhelp company-anaconda column-enforce-mode benchmark-init base16-theme avy auto-complete))))
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
