--- ctwm_main.c.orig	2022-01-19 22:56:48.934088211 +0900
+++ ctwm_main.c	2022-01-19 22:57:41.844165125 +0900
@@ -1096,6 +1096,7 @@
 	scr->IconManagerDontShow = false;
 	scr->BackingStore = false;
 	scr->SaveUnder = true;
+	scr->CentrePlacement = CP_OFF;
 	scr->RandomPlacement = RP_ALL;
 	scr->RandomDisplacementX = 30;
 	scr->RandomDisplacementY = 30;

