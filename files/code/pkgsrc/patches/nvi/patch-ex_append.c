--- dist/ex/ex_append.c.orig	2025-05-26 17:55:20.600787990 +0900
+++ dist/ex/ex_append.c	2025-05-26 18:01:54.228147840 +0900
@@ -227,7 +227,7 @@
 		 * it.  Give them an informational message.
 		 */
 		(void)ex_puts(sp,
-		    msg_cat(sp, "273|Entering ex input mode.", NULL));
+		    msg_cat(sp, "", NULL));
 		(void)ex_puts(sp, "\n");
 		(void)ex_fflush(sp);
 	}

