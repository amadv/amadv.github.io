--- dist/vi/vs_msg.c.orig	2025-05-26 18:32:39.177514132 +0900
+++ dist/vi/vs_msg.c	2025-05-26 18:33:56.019812805 +0900
@@ -681,7 +681,6 @@
 	/* Display new file status line. */
 	if (F_ISSET(sp, SC_STATUS)) {
 		F_CLR(sp, SC_STATUS);
-		msgq_status(sp, sp->lno, MSTAT_TRUNCATE);
 	}
 
 	/* Report on line modifications. */

