;;; figlet message                  -*- lexical-binding: t; -*-

;; Copyright (C) 1994 Kirby Files

;; Author: Kirby Files <kfiles@bbn.com>
;; Maintainer: ril <fenril.nh@gmail.com>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Clean up the old code.
;; The original header comment is below:

;; filename: figlet.el
;; Kirby Files, 9/18/94.  kfiles@bbn.com
;; add font completion: James LewisMoss 27 Oct 2000, dres@debian.org
;; feel free to modify and distribute; there's not a lot here.
;; call M-x figlet-message to insert a large ascii text in your buffer.
;; Current option is to center text.  Feel free to change this if you'd
;; like.

;;; Code:

(defgroup figlet nil
  "Insert large characters made up of ordinary screen characters in your buffer."
  :prefix "fig-"
  :group 'convenience)

(defcustom fig-options "-c"
  "figlet command options"
  :group 'figlet
  :type 'string)

(defcustom fig-font-locations '("/usr/share/figlet")
  "replace this with \"figlet -I2\" to get the default font dir"
  :group 'figlet
  :type '(repeat string))

(defun fig-collapse-lists (da-list)
  (cond ((stringp da-list) (list da-list))
        ((null da-list) nil)
        (t (append (fig-collapse-lists (car da-list))
                   (fig-collapse-lists (cdr da-list))))))

(defun fig-generate-figlet-font-list (loc-list)
  "Generate a list of figlet fonts."
  (mapcar
   #'(lambda (element)
       (cons element nil))
   (mapcar
    #'(lambda (one-file)
        (let ((point (string-match ".flf" one-file)))
          (substring one-file 0 point)))
    (fig-collapse-lists
     (mapcar
      #'(lambda (dir-string)
          (directory-files (expand-file-name dir-string)
                           nil ".*\\.flf"))
      loc-list)))))

;;;###autoload
(defun figlet-message ()
  "Inserts large message of text in ASCII font into current buffer"
  (interactive)
  (let ((str (read-from-minibuffer "Enter message: "))
        (font (completing-read "Which font: "
                               (fig-generate-figlet-font-list fig-font-locations) nil t)))
    (call-process "figlet" nil t t "-f" font fig-options str))
  (message "Done printing"))

(provide 'figlet-message)
