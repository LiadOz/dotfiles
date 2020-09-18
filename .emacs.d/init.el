(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("b8929cff63ffc759e436b0f0575d15a8ad7658932f4b2c99415f3dde09b32e97" "6271fc9740379f8e2722f1510d481c1df1fcc43e48fa6641a5c19e954c21cc8f" "aea30125ef2e48831f46695418677b9d676c3babf43959c8e978c0ad672a7329" "93268bf5365f22c685550a3cbb8c687a1211e827edc76ce7be3c4bd764054bad" "5a7830712d709a4fc128a7998b7fa963f37e960fd2e8aa75c76f692b36e6cf3c" "8cf1002c7f805360115700144c0031b9cfa4d03edc6a0f38718cef7b7cabe382" "16ab866312f1bd47d1304b303145f339eac46bbc8d655c9bfa423b957aa23cc9" "f3ab34b145c3b2a0f3a570ddff8fabb92dafc7679ac19444c31058ac305275e1" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "d4f8fcc20d4b44bf5796196dbeabec42078c2ddb16dcb6ec145a1c610e0842f3" "ab729ed3a8826bf8927b16be7767aa449598950f45ddce7e4638c0960a96e0f1" "dcdd1471fde79899ae47152d090e3551b889edf4b46f00df36d653adc2bf550d" default)))
 '(line-number-mode nil)
 '(package-selected-packages
   (quote
    (neotree evil-anzu anzu-evil doom-modeline yasnippet-snippets yasnippet helm-projectile projectile general helm avy gnu-elpa-keyring-update column-enforce-mode auto-complete nlinum-relative try which-key use-package evil dracula-theme)))
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
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; load init file
(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/machine_config.org"))
