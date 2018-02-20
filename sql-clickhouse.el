;;; sql-clickhouse.el --- support ClickHouse as SQL interpreter

;; Author: Robert Schwarz <mail@rschwarz.net>
;; URL: https://github.com/leethargo/sql-clickhouse

;;; Following the template from sql.el (builtin):

;; 1) Add the product to the list of known products.

(sql-add-product 'clickhouse "ClickhouseDB"
                 '(:free-software t))

;; 2) Define font lock settings.  All ANSI keywords will be
;;    highlighted automatically, so only product specific keywords
;;    need to be defined here.

(defvar sql-mode-clickhouse-font-lock-keywords
  '(("\\b\\(red\\|orange\\|yellow\\)\\b"
     . font-lock-keyword-face))
  "ClickhouseDB SQL keywords used by font-lock.")

(sql-set-product-feature 'clickhouse
                         :font-lock
                         'sql-mode-clickhouse-font-lock-keywords)

;; 3) Define any special syntax characters including comments and
;;    identifier characters.

(sql-set-product-feature 'clickhouse
                         :syntax-alist ((?# . "_")))

;; 4) Define the interactive command interpreter for the database
;;    product.

(defcustom sql-clickhouse-program "iclickhouse"
  "Command to start iclickhouse by ClickhouseDB."
  :type 'file
  :group 'SQL)

(sql-set-product-feature 'clickhouse
                         :sqli-program 'sql-clickhouse-program)
(sql-set-product-feature 'clickhouse
                         :prompt-regexp "^clickhousedb> ")
(sql-set-product-feature 'clickhouse
                         :prompt-length 7)

;; 5) Define login parameters and command line formatting.

(defcustom sql-clickhouse-login-params '(user password server database)
  "Login parameters to needed to connect to ClickhouseDB."
  :type 'sql-login-params
  :group 'SQL)

(sql-set-product-feature 'clickhouse
                         :sqli-login 'sql-clickhouse-login-params)

(defcustom sql-clickhouse-options '("-X" "-Y" "-Z")
  "List of additional options for `sql-clickhouse-program'."
  :type '(repeat string)
  :group 'SQL)

(sql-set-product-feature 'clickhouse
                         :sqli-options 'sql-clickhouse-options))

(defun sql-comint-clickhouse (product options)
  "Connect ti ClickhouseDB in a comint buffer."

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

(sql-set-product-feature 'clickhouse
                         :sqli-comint-func 'sql-comint-clickhouse)

;; 6) Define a convenience function to invoke the SQL interpreter.

(defun sql-clickhouse (&optional buffer)
  "Run iclickhouse by ClickhouseDB as an inferior process."
  (interactive "P")
  (sql-product-interactive 'clickhouse buffer))
