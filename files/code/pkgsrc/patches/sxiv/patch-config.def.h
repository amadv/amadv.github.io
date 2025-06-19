--- config.def.h.orig	2021-08-02 00:47:11.972189099 +0900
+++ config.def.h	2021-08-02 00:49:16.904268094 +0900
@@ -48,7 +48,7 @@
 #ifdef _THUMBS_CONFIG
 
 /* thumbnail sizes in pixels (width == height): */
-static const int thumb_sizes[] = { 32, 64, 96, 128, 160 };
+static const int thumb_sizes[] = { 32, 64, 96, 128, 160, 192, 224, 400 };
 
 /* thumbnail size at startup, index into thumb_sizes[]: */
 static const int THUMB_SIZE = 3;

