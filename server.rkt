#lang web-server

(provide interface-version stuffer start)
(define interface-version 'stateless)

;; start is the entry point for your server.
(define (start req)
  (site-router req))

;; Router:

(define-values (site-router site-url)
  ;; See http://docs.racket-lang.org/web-server/dispatch.html for
  ;; dispatch-rules syntax.
  (dispatch-rules
   [("") serve-home]
   [("create-group") #:method "post" serve-create-group]))

(define (serve-error req)
  (response/xexpr
   `(html (body (p "error page.")))))

;; Request handlers:

(define (serve-home req)
  (response/xexpr
   `(html
     (body
      (p "Track your GitHub streaks and compete with your friends!")
      (form ([method "POST"] [action ,(site-url serve-create-group)])
            "group name: " (input ([type "text"] [name "group-name"]))
            (input ([type "submit"])))))))

(define (form-value id req)
  (define val (bindings-assq id (request-bindings/raw req)))
  (when (binding:form? val)
    (bytes->string/utf-8 (binding:form-value val))))

(define (serve-create-group req)
  (define group-name (form-value #"group-name" req))
  (response/xexpr
   `(html (body (p "Your group name is " ,group-name ".")))))

;; IDEA:
;; - Front page has two things: create a streak group, sign up for a streak group.
;; - "Put in your GitHub username to create a streak group and compete with your friends."

