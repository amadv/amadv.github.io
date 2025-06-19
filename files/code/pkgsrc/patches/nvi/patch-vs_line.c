--- dist/vi/vs_line.c.orig	2025-05-26 18:32:26.006917680 +0900
+++ dist/vi/vs_line.c	2025-05-26 18:33:03.730359506 +0900
@@ -184,7 +184,7 @@
 						goto empty;
 					}
 				} else {
-					ch = L('~');
+					ch = L(' ');
 					goto empty;
 				}
 			} else

