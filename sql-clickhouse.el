;;; sql-clickhouse.el --- support ClickHouse as SQL interpreter

;; Author: Robert Schwarz <mail@rschwarz.net>
;; URL: https://github.com/leethargo/sql-clickhouse

(require 'sql)

(defvar sql-mode-clickhouse-font-lock-keywords
  '(("\\b\\(a\\(?:rray join\\|ttach\\)\\|detach\\|e\\(?:ngine\\|xists\\)\\|freeze\\|kill query\\|materialized\\|o\\(?:n cluster\\|ptimize\\)\\|p\\(?:artition\\|rewhere\\)\\|sample\\|use\\|with totals\\)\\b"
     . font-lock-keyword-face))
  "ClickhouseDB SQL keywords used by font-lock.")

(defcustom sql-clickhouse-program "clickhouse-client"
  "Command to start clickhouse-client by ClickHouse."
  :type 'file
  :group 'SQL)

(defcustom sql-clickhouse-login-params '()
  "Login parameters needed to connect to ClickhouseDB."
  :type 'sql-login-params
  :group 'SQL)

(defcustom sql-clickhouse-options '()
  "List of additional options for `sql-clickhouse-program'."
  :type '(repeat string)
  :group 'SQL)

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

(defun sql-clickhouse (&optional buffer)
  "Run clickhouse-client by ClickHouse as an inferior process."
  (interactive "P")
  (sql-product-interactive 'clickhouse buffer))

(eval-after-load "sql"
  '(sql-add-product 'clickhouse "ClickHouse"
                    :font-lock 'sql-mode-clickhouse-font-lock-keywords
                    :sqli-program 'sql-clickhouse-program
                    :prompt-regexp "^:) "
                    :prompt-length 3
                    :prompt-cont-regexp "^:-] "
                    :sqli-login 'sql-clickhouse-login-params
                    :sqli-options 'sql-clickhouse-options
                    :sqli-comint-func 'sql-comint-clickhouse))

(provide 'sql-clickhouse)
