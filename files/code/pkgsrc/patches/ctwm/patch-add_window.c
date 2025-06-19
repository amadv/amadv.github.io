--- add_window.c.orig	2022-01-19 22:52:09.035425719 +0900
+++ add_window.c	2022-01-19 22:54:39.535512022 +0900
@@ -745,7 +745,26 @@
 	 * functions, for extra readability...
 	 */
 	if(HandlingEvents && ask_user && !restoredFromPrevSession) {
-		if((Scr->RandomPlacement == RP_ALL) ||
+		if(Scr->CentrePlacement == CP_ON) {
+#ifdef DEBUG
+			fprintf(stderr,
+			        "DEBUG[CentrePlacement]: win: %dx%d+%d+%d, screen: %dx%d, title height: %d, centre: +%d+%d\n",
+			        tmp_win->attr.width, tmp_win->attr.height,
+			        tmp_win->attr.x, tmp_win->attr.y,
+			        Scr->rootw, Scr->rooth,
+			        tmp_win->title_height,
+			        Scr->rootw/2, Scr->rooth/2);
+#endif
+			if (tmp_win->attr.width >= Scr->rootw || tmp_win->attr.height >= Scr->rooth) {
+				tmp_win->attr.x = 0;
+				tmp_win->attr.y = tmp_win->title_height;
+			} else {
+				tmp_win->attr.x = (Scr->rootw - tmp_win->attr.width) / 2;
+				tmp_win->attr.y = (Scr->rooth - (tmp_win->attr.height - tmp_win->title_height)) / 2;
+			}
+			random_placed = true;	/* reuse */
+		}
+		else if((Scr->RandomPlacement == RP_ALL) ||
 		                ((Scr->RandomPlacement == RP_UNMAPPED) &&
 		                 ((tmp_win->wmhints->initial_state == IconicState) ||
 		                  (! visible(tmp_win))))) {

