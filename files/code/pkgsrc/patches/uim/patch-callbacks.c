--- fep/callbacks.c.orig	2022-08-02 15:25:30.079032168 +0900
+++ fep/callbacks.c	2022-08-02 15:44:03.629616485 +0900
@@ -339,7 +339,7 @@
 
   assert(!s_start_callbacks);
 
-  uim_asprintf(&str, "%s[%s]", s_im_str, s_label_str);
+  uim_asprintf(&str, "", s_im_str, s_label_str);
   strhead(str, s_max_width);
 
   return str;

