(defmodule lmug-log
  (behaviour gen_server)
  (export all))

(include-lib "logjam/include/logjam.hrl")

(defun format
  ((`#m(body ,body
       method ,method
       remote-addr ,remote-addr
       url ,url
       url-parsed ,url-parsed)
       user-agent
       referrer
       status)
   (let* ((delim " - ")
         (user (maps:get 'user url-parsed #""))
         (now (calendar:system_time_to_rfc3339 (erlang:system_time)))
         (method (string:to_upper (atom_to_list method)))
         (user (binary_to_list user))
         (user (if (== "" user)
                 user
                 (++ delim user)))
         (referrer (binary_to_list referrer))
         (referrer (if (== "" referrer)
                     referrer
                     (++ delim referrer)))
         (user-agent (binary_to_list user-agent))
         (user-agent (if (== "" user-agent)
                       user-agent
                       (++ delim user-agent))))
     (io_lib:format "~s~s [~s] \"~s ~s\" ~s ~p~s~s"
                    (list remote-addr
                          user
                          now
                          method
                          url
                          status
                          (size body)
                          referrer
                          user-agent)))))

(defun request-debug (req user-agent referrer status)
(request req user-agent referrer status 'debug))

(defun request-info (req user-agent referrer status)
(request req user-agent referrer status 'info))

(defun request-notice (req user-agent referrer status)
(request req user-agent referrer status 'notice))

(defun request-warn (req user-agent referrer status)
(request req user-agent referrer status 'warn))

(defun request-error (req user-agent referrer status)
(request req user-agent referrer status 'error))

(defun request-critical (req user-agent referrer status)
(request req user-agent referrer status 'critical))

(defun request-alert (req user-agent referrer status)
(request req user-agent referrer status 'alert))

(defun request-emergency (req user-agent referrer status)
(request req user-agent referrer status 'emergency))

(defun request
((req user-agent referrer status 'debug)
 (log-debug (format req user-agent referrer status)))
((req user-agent referrer status 'info)
 (log-info (format req user-agent referrer status)))
((req user-agent referrer status 'notice)
 (log-notice (format req user-agent referrer status)))
((req user-agent referrer status 'warn)
 (log-warn (format req user-agent referrer status)))
((req user-agent referrer status 'error)
 (log-error (format req user-agent referrer status)))
((req user-agent referrer status 'critical)
 (log-critical (format req user-agent referrer status)))
((req user-agent referrer status 'alert)
 (log-alert (format req user-agent referrer status)))
((req user-agent referrer status 'emergency)
 (log-emergency (format req user-agent referrer status))))
