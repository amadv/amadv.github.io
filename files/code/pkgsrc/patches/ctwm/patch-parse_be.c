--- parse_be.c.orig	2022-01-19 22:58:31.153591003 +0900
+++ parse_be.c	2022-01-19 23:06:11.282069766 +0900
@@ -35,6 +35,7 @@
 #include "gram.tab.h"
 
 
+static int ParseCentrePlacement(const char *s);
 static int ParseRandomPlacement(const char *s);
 static int ParseButtonStyle(const char *s);
 static int ParseUsePPosition(const char *s);
@@ -140,6 +141,7 @@
 #define kws_MaxWindowSize               9
 #define kws_PixmapDirectory             10
 /* RandomPlacement moved because it's now a string string keyword */
+#define kws_CentrePlacement             11
 #define kws_IconJustification           12
 #define kws_TitleJustification          13
 #define kws_IconRegionJustification     14
@@ -253,6 +255,8 @@
 	{ "c",                      CONTROL, 0 },
 	{ "center",                 SIJENUM, SIJ_CENTER },
 	{ "centerfeedbackwindow",   KEYWORD, kw0_CenterFeedbackWindow },
+	{ "centerplacement",        SKEYWORD, kws_CentrePlacement },
+	{ "centreplacement",        SKEYWORD, kws_CentrePlacement },
 	{ "changeworkspacefunction", CHANGE_WORKSPACE_FUNCTION, 0 },
 	{ "clearshadowcontrast",    NKEYWORD, kwn_ClearShadowContrast },
 	{ "clicktofocus",           KEYWORD, kw0_ClickToFocus },
@@ -906,6 +910,7 @@
 			}
 			else {
 				Scr->RandomPlacement = rp;
+				Scr->CentrePlacement = CP_OFF;
 			}
 
 			/* If no geom, we're done */
@@ -948,6 +953,20 @@
 do_string_keyword(int keyword, char *s)
 {
 	switch(keyword) {
+		case kws_CentrePlacement: {
+			int cp = ParseCentrePlacement(s);
+			if(cp < 0) {
+				twmrc_error_prefix();
+				fprintf(stderr,
+					"ignoring invalid CentrePlacement argument \"%s\"\n", s);
+			}
+			else {
+				Scr->CentrePlacement = cp;
+				Scr->RandomPlacement = RP_OFF;
+			}
+			return true;
+		}
+
 		case kws_UsePPosition: {
 			int ppos = ParseUsePPosition(s);
 			if(ppos < 0) {
@@ -1677,6 +1696,25 @@
 
 
 /*
+ * CentrePlacement "on" or "off"
+ */
+static int
+ParseCentrePlacement(const char *s)
+{
+	if(s == NULL) {
+		return -1;
+	}
+	if(strlen(s) == 0) {
+		return -1;
+	}
+
+	if(strcasecmp(s, "off") == 0)		return CP_OFF;
+	else if(strcasecmp(s, "on") == 0)	return CP_ON;
+
+	return -1;
+}
+
+/*
  * RandomPlacement [...] parse
  */
 static int

