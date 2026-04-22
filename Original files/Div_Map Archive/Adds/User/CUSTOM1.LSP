;=============================================================================
;                                  CUSTOM1.LSP
;  This is an example of a customizing file which can be called from within
;  the ADDS PLOT routine to do special setups to a drawing before it is
;  plotted.  It is optional.
;
;  The rules for use of such a file are:
;     1.  It must be named CUSTOM#.LSP, where # represents a single digit.
;         This digit is referenced in the PLD file.
;     2.  It must contain a function named (do_cus).
;
;=============================================================================
(defun do_cus ()
   (command)
   (command "_.LAYER" "C" "7" "*" "C" "3" "----NO----" "C" "5" "????SW-*"
                    "C" "14" "????SWD*,????CKD*,----SB----" "C" "1" "----ML*" "")
   (command "_.STYLE" "SW" "ROMAND" "" "" "" "" "" "")
   (set2blue)
)
;
(defun set2blue(/ lst cnt total i ssdata elist)
 (command "_.LAYER" "N" "---blue---" "C" "blue" "---blue---" "")
 (setq lst (list "CAP" "A101" "RECL" "A105" "A169" "A193" "A194" "RECLBP" "RECLEL" "REG" "A133" "A195" "REGA" "REGARR")
       cnt 0
       total (length lst))
 (while (< cnt total)
   (setq i 0)
   (if (setq ssdata (ssget "X" (list (cons 0 "INSERT") (cons 2 (nth cnt lst)))))
     (repeat (sslength ssdata)
       (setq elist (entget (ssname ssdata i))
             i (+ i 1)
             elist (subst (cons 8 "---BLUE---") (assoc 8 elist) elist))
       (entmod elist)
     )
   )
   (setq cnt (1+ cnt))
 )
)
