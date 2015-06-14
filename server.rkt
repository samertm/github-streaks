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
   [("create-group") serve-create-group]))

;; Request handlers:

(define (serve-home req)
  (response/xexpr
   `(html
     (body
      (p "Track your GitHub streaks and compete with your friends!")))))

(define (serve-create-group req)
  )

;; IDEA:
;; - Front page has two things: create a streak group, sign up for a streak group.
;; - "Put in your GitHub username to create a streak group and compete with your friends."

