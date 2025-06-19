--- dist/common/msg.c.orig	2025-05-26 18:05:11.262496706 +0900
+++ dist/common/msg.c	2025-05-26 18:07:31.952436306 +0900
@@ -810,10 +810,10 @@
 	case CMSG_CONF:
 		return (msg_cat(sp, "268|confirm? [ynq]", lenp));
 	case CMSG_CONT:
-		return (msg_cat(sp, "269|Press any key to continue: ", lenp));
+		return (msg_cat(sp, "", lenp));
 	case CMSG_CONT_EX:
 		return (msg_cat(sp,
-	    "270|Press any key to continue [: to enter more ex commands]: ",
+	    "",
 		    lenp));
 	case CMSG_CONT_R:
 		return (msg_cat(sp, "161|Press Enter to continue: ", lenp));

