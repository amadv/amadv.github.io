--- ctwm.h.orig	2022-01-19 22:55:26.394450318 +0900
+++ ctwm.h	2022-01-19 22:56:13.263265588 +0900
@@ -225,6 +225,11 @@
 	GRAV_WEST,
 } RegGravity;
 
+/* CentrePlacement bits */
+typedef enum {
+	CP_OFF,
+	CP_ON
+} CntrPlac;
 
 /* RandomPlacement bits */
 typedef enum {

