#lang web-server

(provide interface-version stuffer start)
(define interface-version 'stateless)

(require web-server/templates)

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

(define (response/default #:code      [code 200]
                          #:message   [message #"Okay"]
                          #:seconds   [seconds (current-seconds)]
                          #:mime-type [mime-type TEXT/HTML-MIME-TYPE]
                          #:headers   [headers '()]
                          ;; #:cookies   [cookies '()]
                          #:body      [body '(#"")])
  (response/full code message seconds mime-type headers body))

(define-syntax include-template-body
  (syntax-rules ()
    [(_ . p)
     (list (string->bytes/utf-8 (include-template . p)))]))

(define (form-value id req)
  (define val (bindings-assq id (request-bindings/raw req)))
  (when (binding:form? val)
    (bytes->string/utf-8 (binding:form-value val))))

(define (serve-home req)
  (response/default #:body (include-template-body "templates/index.html")))

(define (serve-create-group req)
  (define group-name (form-value #"group-name" req))
  (response/default #:body (include-template-body "templates/create-group.html")))

;; commentary: statically-checked templates are *amazing*!

;; IDEA:
;; - Front page has two things: create a streak group, sign up for a streak group.
;; - "Put in your GitHub username to create a streak group and compete with your friends."
