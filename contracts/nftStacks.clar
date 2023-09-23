(impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait) ;; importing the trait and implementing the function 

(define-non-fungible-token amazing-aardvarks uint) ;; init the non-fungible token 
;; type name type 
(define-data-var last-token-id uint u0) ;; last-token-id variable 
;;type name type initial value 

(define-constant contract-owner tx-sender) ;;  constant -> to store the owner 

;;storing the error message 
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;; returns the last-token-id
(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
    (ok none)
)
;; returns the owner -> using the nft-get-owner? 
(define-read-only (get-owner (token-id uint))
    (ok (nft-get-owner? amazing-aardvarks token-id))
    ;; ok (function nft-contract-name token-id)
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) err-not-token-owner) ;; check
        (nft-transfer? amazing-aardvarks token-id sender recipient)
    )
)

(define-public (mint (recipient principal))
    (let
        (
            (token-id (+ (var-get last-token-id) u1))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only);; check 
        (try! (nft-mint? amazing-aardvarks token-id recipient))
        (var-set last-token-id token-id)
        (ok token-id)
    )
)
