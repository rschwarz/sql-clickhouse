;;; sql-clickhouse.el --- support ClickHouse as SQL interpreter

;; Author: Robert Schwarz <mail@rschwarz.net>
;; URL: https://github.com/leethargo/sql-clickhouse

(require 'sql)

;;; Following the template from sql.el (builtin):

;; 1) Add the product to the list of known products.

(sql-add-product 'clickhouse "ClickhouseDB"
                 '(:free-software t))

;; 2) Define font lock settings.  All ANSI keywords will be
;;    highlighted automatically, so only product specific keywords
;;    need to be defined here.

(defvar sql-mode-clickhouse-font-lock-keywords
  (sql-font-lock-keywords-builder 'font-lock-keyword-face nil
                                  "array join" "attach" "detach" "engine"
                                  "exists" "freeze" "kill query" "materialized"
                                  "on cluster" "optimize" "partition" "prewhere"
                                  "sample" "use" "with totals")
  "ClickhouseDB SQL keywords used by font-lock.")

(sql-set-product-feature 'clickhouse
                         :font-lock
                         'sql-mode-clickhouse-font-lock-keywords)

;; 3) Define any special syntax characters including comments and
;;    identifier characters.

;; (sql-set-product-feature 'clickhouse
;;                          :syntax-alist ((?# . "_")))

;; 4) Define the interactive command interpreter for the database
;;    product.

(defcustom sql-clickhouse-program "clickhouse-client"
  "Command to start clickhouse-client by ClickHouse."
  :type 'file
  :group 'SQL)

(sql-set-product-feature 'clickhouse
                         :sqli-program 'sql-clickhouse-program)
(sql-set-product-feature 'clickhouse
                         :prompt-regexp "^:) ")
(sql-set-product-feature 'clickhouse
                         :prompt-length 3)

;; 5) Define login parameters and command line formatting.

(defcustom sql-clickhouse-login-params '()
  "Login parameters needed to connect to ClickhouseDB."
  :type 'sql-login-params
  :group 'SQL)

(sql-set-product-feature 'clickhouse
                         :sqli-login 'sql-clickhouse-login-params)

(defcustom sql-clickhouse-options '("-c" "-h" "--port" "-s" "-u" "--password"
                                    "-d" "-f" "-E" "-t")
  "List of additional options for `sql-clickhouse-program'."
  :type '(repeat string)
  :group 'SQL)

(sql-set-product-feature 'clickhouse
                         :sqli-options 'sql-clickhouse-options))

(defun sql-comint-clickhouse (product options)
  "Connect to ClickHouse in a comint buffer."

  ;; Do something with `sql-user', `sql-password',
  ;; `sql-database', and `sql-server'.
  (let ((params
         (append
          (if (not (string= "" sql-user))
              (list "-u" sql-user))
          (if (not (string= "" sql-password))
              (list "--password" sql-password))
          (if (not (string= "" sql-database))
              (list "-d" sql-database))
          (if (not (string= "" sql-server))
              (list "-h" sql-server))
          options)))
    (sql-comint product params)))

(sql-set-product-feature 'clickhouse
                         :sqli-comint-func 'sql-comint-clickhouse)

;; 6) Define a convenience function to invoke the SQL interpreter.

(defun sql-clickhouse (&optional buffer)
  "Run clickhouse-client by ClickHouse as an inferior process."
  (interactive "P")
  (sql-product-interactive 'clickhouse buffer))
