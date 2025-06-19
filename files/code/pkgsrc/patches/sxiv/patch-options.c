--- options.c.orig	2021-08-02 00:50:35.316292936 +0900
+++ options.c	2021-08-02 00:50:54.302233900 +0900
@@ -63,7 +63,7 @@
 
 	_options.fullscreen = false;
 	_options.embed = 0;
-	_options.hide_bar = false;
+	_options.hide_bar = true;
 	_options.geometry = NULL;
 	_options.res_name = NULL;
 
@@ -87,7 +87,7 @@
 				_options.animate = true;
 				break;
 			case 'b':
-				_options.hide_bar = true;
+				_options.hide_bar = false;
 				break;
 			case 'c':
 				_options.clean_cache = true;

