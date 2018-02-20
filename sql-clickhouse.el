;;; sql-clickhouse.el --- support ClickHouse as SQL interpreter

;; Author: Robert Schwarz <mail@rschwarz.net>
;; URL: https://github.com/leethargo/sql-clickhouse


;;; Commentary:
;; Add new product type ClickHouse for SQL mode in Emacs.

(require 'sql)

;;; Code:

(defvar sql-mode-clickhouse-font-lock-keywords
  (list
   ;; keywords (non-ANSI)
   (sql-font-lock-keywords-builder
    'font-lock-keyword-face nil
    "ARRAY JOIN" "ATTACH" "DETACH" "ENGINE" "EXISTS" "FREEZE" "KILL QUERY"
    "MATERIALIZED" "ON CLUSTER" "OPTIMIZE" "PARTITION" "PREWHERE" "SAMPLE"
    "USE" "WITH TOTALS")

   ;; types
   (sql-font-lock-keywords-builder
    'font-lock-type-face nil
    ;; column types
    "Array" "Date" "DateTime" "Enum8" "Enum16" "FixedString" "Float32"
    "Float64" "Int8" "Int16" "Int32" "Int64" "UInt8" "UInt16" "UInt32"
    "UInt64" "String" "Tuple"

    ;; engine types
    "AggregatingMergeTree" "Buffer" "CollapsingMergeTree" "Distributed"
    "File" "GraphiteMergeTree" "Join" "Kafka" "Log" "MaterializedView"
    "Memory" "Merge" "MergeTree" "Null" "ReplacingMergeTree"
    "ReplicatedAggregatingMergeTree" "ReplicatedCollapsingMergeTree"
    "ReplicatedMergeTree" "ReplicatedSummingMergeTree" "Set"
    "SummingMergeTree" "TinyLog" "View")

   ;; functions
   (sql-font-lock-keywords-builder
    'font-lock-builtin-face nil
    "plus" "minus" "multiply" "divide" "intDiv" "intDivOrZero" "modulo"
    "negate" "abs" "gcd" "lcm" "empty" "notEmpty" "length" "emptyArrayUInt8"
    "emptyArrayUInt16" "emptyArrayUInt32" "emptyArrayUInt64" "emptyArrayInt8"
    "emptyArrayInt16" "emptyArrayInt32" "emptyArrayInt64" "emptyArrayFloat32"
    "emptyArrayFloat64" "emptyArrayDate" "emptyArrayDateTime"
    "emptyArrayString" "emptyArrayToSingle" "range" "array" "arrayConcat"
    "arrayElement" "has" "indexOf" "countEqual" "arrayEnumerate"
    "arrayEnumerateUniq" "arrayPopBack" "arrayPopFront" "arrayPushBack"
    "arrayPushFront" "arraySlice" "arrayUniq" "arrayJoin" "bitAnd" "bitOr"
    "bitXor" "bitNot" "bitShiftLeft" "bitShiftRight" "equals" "notEquals"
    "less" "greater" "lessOrEquals" "greaterOrEquals" "if" "toYear" "toMonth"
    "toDayOfMonth" "toDayOfWeek" "toHour" "toMinute" "toSecond" "toMonday"
    "toStartOfMonth" "toStartOfQuarter" "toStartOfYear" "toStartOfMinute"
    "toStartOfFiveMinute" "toStartOfHour" "toTime" "toRelativeYearNum"
    "toRelativeMonthNum" "toRelativeWeekNum" "toRelativeDayNum"
    "toRelativeHourNum" "toRelativeMinuteNum" "toRelativeSecondNum" "now"
    "today" "yesterday" "timeSlot" "timeSlots" "hex" "unhex(str)"
    "UUIDStringToNum(str)" "UUIDNumToString(str)" "bitmaskToList(num)"
    "bitmaskToArray(num)" "dictGetUInt8" "dictGetUInt16" "dictGetUInt32"
    "dictGetUInt64" "dictGetInt8" "dictGetInt16" "dictGetInt32" "dictGetInt64"
    "dictGetFloat32" "dictGetFloat64" "dictGetDate" "dictGetDateTime"
    "dictGetUUID" "dictGetString" "dictGetTOrDefault" "dictIsIn"
    "dictGetHierarchy" "dictHas" "halfMD5" "MD5" "sipHash64" "sipHash128"
    "cityHash64" "intHash32" "intHash64" "SHA1" "SHA224" "SHA256" "URLHash"
    "lambda(params, expr)" "arrayMap" "arrayFilter" "arrayCount" "arrayExists"
    "arrayAll" "arraySum" "arrayFirst" "arrayFirstIndex" "in" "notIn"
    "globalIn" "globalNotIn" "tuple" "tupleElement" "IPv4NumToString"
    "IPv4StringToNum" "IPv4NumToStringClassC" "IPv6NumToString"
    "IPv6StringToNum" "visitParamHas" "visitParamExtractUInt"
    "visitParamExtractInt" "visitParamExtractFloat" "visitParamExtractBool"
    "visitParamExtractRaw" "visitParamExtractString" "and" "or" "not" "xor"
    "e" "pi" "exp" "log" "exp2" "log2" "exp10" "log10" "sqrt" "cbrt" "erf"
    "erfc" "lgamma" "tgamma" "sin" "cos" "tan" "asin" "acos" "atan" "pow"
    "hostName" "visibleWidth" "toTypeName" "blockSize" "materialize" "ignore"
    "sleep" "currentDatabase" "isFinite" "isInfinite" "isNaN"
    "hasColumnInTable" "bar" "transform" "formatReadableSize" "least"
    "greatest" "uptime" "version" "rowNumberInAllBlocks" "runningDifference"
    "MACNumToString" "MACStringToNum" "MACStringToOUI" "rand" "rand64" "floor"
    "ceil" "round" "roundToExp2" "roundDuration" "roundAge" "splitByChar"
    "splitByString" "arrayStringConcat" "alphaTokens" "empty" "notEmpty"
    "length" "lengthUTF8" "lower" "upper" "lowerUTF8" "upperUTF8" "reverse"
    "reverseUTF8" "concat" "substring" "substringUTF8"
    "appendTrailingCharIfAbsent" "convertCharset" "replaceOne" "replaceAll"
    "replaceRegexpOne" "replaceRegexpAll" "position" "positionUTF8" "match"
    "extract" "extractAll" "like" "notLike" "toUInt8" "toUInt16" "toUInt32"
    "toUInt64" "toInt8" "toInt16" "toInt32" "toInt64" "toFloat32" "toFloat64"
    "toUInt8OrZero" "toUInt16OrZero" "toUInt32OrZero" "toUInt64OrZero"
    "toInt8OrZero" "toInt16OrZero" "toInt32OrZero" "toInt64OrZero"
    "toFloat32OrZero" "toFloat64OrZero" "toDate" "toDateTime" "toString"
    "toFixedString" "toStringCutToZero" "reinterpretAsUInt8"
    "reinterpretAsUInt16" "reinterpretAsUInt32" "reinterpretAsUInt64"
    "reinterpretAsInt8" "reinterpretAsInt16" "reinterpretAsInt32"
    "reinterpretAsInt64" "reinterpretAsFloat32" "reinterpretAsFloat64"
    "reinterpretAsDate" "reinterpretAsDateTime" "reinterpretAsString"
    "protocol" "domain" "domainWithoutWWW" "topLevelDomain"
    "firstSignificantSubdomain" "cutToFirstSignificantSubdomain" "path"
    "pathFull" "queryString" "fragment" "queryStringAndFragment"
    "extractURLParameter" "extractURLParameters" "extractURLParameterNames"
    "URLHierarchy" "URLPathHierarchy" "decodeURLComponent" "cutWWW"
    "cutQueryString" "cutFragment" "cutQueryStringAndFragment"
    "cutURLParameter" "regionToCity" "regionToArea" "regionToDistrict"
    "regionToCountry" "regionToContinent" "regionToPopulation" "regionIn"
    "regionHierarchy" "regionToName"))
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

(provide 'sql-clickhouse)

;;; sql-clickhouse.el ends here
