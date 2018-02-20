;;; sql-clickhouse.el --- support ClickHouse as SQL interpreter

;; Author: Robert Schwarz <mail@rschwarz.net>
;; URL: https://github.com/leethargo/sql-clickhouse

;;; Following the template from sql.el (builtin):

;; 1) Add the product to the list of known products.

(sql-add-product 'xyz "XyzDB"
                 '(:free-software t))

;; 2) Define font lock settings.  All ANSI keywords will be
;;    highlighted automatically, so only product specific keywords
;;    need to be defined here.

(defvar my-sql-mode-xyz-font-lock-keywords
  '(("\\b\\(red\\|orange\\|yellow\\)\\b"
     . font-lock-keyword-face))
  "XyzDB SQL keywords used by font-lock.")

(sql-set-product-feature 'xyz
                         :font-lock
                         'my-sql-mode-xyz-font-lock-keywords)

;; 3) Define any special syntax characters including comments and
;;    identifier characters.

(sql-set-product-feature 'xyz
                         :syntax-alist ((?# . "_")))

;; 4) Define the interactive command interpreter for the database
;;    product.

(defcustom my-sql-xyz-program "ixyz"
  "Command to start ixyz by XyzDB."
  :type 'file
  :group 'SQL)

(sql-set-product-feature 'xyz
                         :sqli-program 'my-sql-xyz-program)
(sql-set-product-feature 'xyz
                         :prompt-regexp "^xyzdb> ")
(sql-set-product-feature 'xyz
                         :prompt-length 7)

;; 5) Define login parameters and command line formatting.

(defcustom my-sql-xyz-login-params '(user password server database)
  "Login parameters to needed to connect to XyzDB."
  :type 'sql-login-params
  :group 'SQL)

(sql-set-product-feature 'xyz
                         :sqli-login 'my-sql-xyz-login-params)

(defcustom my-sql-xyz-options '("-X" "-Y" "-Z")
  "List of additional options for `sql-xyz-program'."
  :type '(repeat string)
  :group 'SQL)

(sql-set-product-feature 'xyz
                         :sqli-options 'my-sql-xyz-options))

(defun my-sql-comint-xyz (product options)
  "Connect ti XyzDB in a comint buffer."

  ;; Do something with `sql-user', `sql-password',
  ;; `sql-database', and `sql-server'.
  (let ((params
         (append
          (if (not (string= "" sql-user))
              (list "-U" sql-user))
          (if (not (string= "" sql-password))
              (list "-P" sql-password))
          (if (not (string= "" sql-database))
              (list "-D" sql-database))
          (if (not (string= "" sql-server))
              (list "-S" sql-server))
          options)))
    (sql-comint product params)))

(sql-set-product-feature 'xyz
                         :sqli-comint-func 'my-sql-comint-xyz)

;; 6) Define a convenience function to invoke the SQL interpreter.

(defun my-sql-xyz (&optional buffer)
  "Run ixyz by XyzDB as an inferior process."
  (interactive "P")
  (sql-product-interactive 'xyz buffer))
