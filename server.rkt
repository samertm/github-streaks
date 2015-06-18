#lang web-server

(provide interface-version stuffer start)
(define interface-version 'stateless)

(require "server-utils.rkt"
         "config.rkt"
         octokit)

;; start is the entry point for your server.
(define (start req)
  (site-router req))

;; Router:

(define-values (site-router site-url)
  ;; See http://docs.racket-lang.org/web-server/dispatch.html for
  ;; dispatch-rules syntax.
  (dispatch-rules
   [("") serve-home]
   [("create-group") #:method "post" serve-create-group]
   [("sign-in") #:method "post" serve-sign-in]
   [("authorize") serve-authorize]))

(define (serve-error req)
  (response/xexpr
   `(html (body (p "error page.")))))

;; Request handlers:

(define (serve-home req)
  (response/default #:body (template "templates/index.html")))

;; Remove?
(define (serve-create-group req)
  (define group-name (form-value #"group-name" req))
  (response/default #:body (template "templates/create-group.html")))

(define (serve-sign-in req)
  ;; TODO: Add "state".
  (redirect-to (string-append "https://github.com/login/oauth/authorize"
                              "?client_id=" github-client-id)))

(define (serve-authorize req)
  (define github-code (form-value 'code req))
  ;; Exchange code for oauth token.
  (post-pure-port
   (string->url "https://github.com/login/oauth/access_token")
   ))

;; Oauth flow:
;; - For login, get oauth token from github.
;; - Store token in cookies.
;;(define octokit-client (new ))

;; commentary: statically-checked templates are *amazing*!

;; IDEA:
;; - Front page has two things: create a streak group, sign up for a streak group.
;; - "Put in your GitHub username to create a streak group and compete with your friends."
