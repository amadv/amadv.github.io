--- src/command.C.orig	2022-02-03 01:56:40.029933176 +0900
+++ src/command.C	2022-02-03 01:57:27.998334515 +0900
@@ -2198,7 +2198,7 @@
               else if (option (Opt_mouseWheelScrollPage))
                 lines = nrow - 1;
               else
-                lines = 5;
+                lines = 1;
 
 # ifdef MOUSE_SLIP_WHEELING
               if (ev.state & ControlMask)

