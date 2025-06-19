--- dir-index-bozo.c.orig	2024-02-04 14:55:04.000000000 +0900
+++ dir-index-bozo.c	2025-05-06 21:30:06.013887141 +0900
@@ -122,7 +122,9 @@
 
 	bozo_printf(httpd,
 		"<!DOCTYPE html>\r\n"
-		"<html><head><meta charset=\"utf-8\"/>\r\n"
+		"<html lang=\"en\"><head><meta charset=\"utf-8\"/>\r\n"
+		"<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">\r\n"
+		"<link rel=\"icon\" image=\"image/gif\" href=\"data:image/gif;base64,R0lGODlhEAAQAIABAIiIiDY2NiH+EUNyZWF0ZWQgd2l0aCBHSU1QACH5BAEKAAEALAAAAAAQABAAAAIhjI+pywitHpSB0nQrrCCvDn4dF4YR6J2pgzHWscIbO0MFADs=\">\r\n"
 		"<style type=\"text/css\">\r\n"
 		"table {\r\n"
 		"\tborder-top: 1px solid black;\r\n"
@@ -130,14 +132,14 @@
 		"}\r\n"
 		"th { background: aquamarine; }\r\n"
 		"tr:nth-child(even) { background: lavender; }\r\n"
-		"</style>\r\n");
-	bozo_printf(httpd, "<title>Index of %s</title></head>\r\n",
+		"</style>\r\n"
+		"<link href=\"/style.css\" rel=\"stylesheet\">\r\n");
+	bozo_printf(httpd, "<title>%s</title></head>\r\n",
 		printname);
-	bozo_printf(httpd, "<body><h1>Index of %s</h1>\r\n",
+	bozo_printf(httpd, "<body><main><h1>%s</h1><p>-</p>\r\n",
 		printname);
 	bozo_printf(httpd,
-		"<table cols=3>\r\n<thead>\r\n"
-		"<tr><th>Name<th>Last modified<th align=right>Size\r\n"
+		"<table cellpadding=0 cellspacing=0 cols=3>\r\n"
 		"<tbody>\r\n");
 
 	for (j = k = scandir(dirpath, &de, NULL, alphasort), deo = de;
@@ -162,35 +164,61 @@
 		htmlname = bozo_escape_html(httpd, name);
 		if (htmlname == NULL)
 			htmlname = name;
-		bozo_printf(httpd, "<tr><td>");
 		if (strcmp(name, "..") == 0) {
-			bozo_printf(httpd, "<a href=\"../\">");
-			bozo_printf(httpd, "Parent Directory");
-		} else if (!nostat && S_ISDIR(sb.st_mode)) {
-			bozo_printf(httpd, "<a href=\"%s/\">", urlname);
+			bozo_printf(httpd, "<!--<tr><td>");	
+		} else {
+			bozo_printf(httpd, "<tr><td>");	
+		}
+		/* if (strcmp(name, "..") == 0) {
+			bozo_printf(httpd, "<a href=\"../\"><i>");
+			bozo_printf(httpd, "../"); */
+		if (!nostat && S_ISDIR(sb.st_mode)) {
+			bozo_printf(httpd, "<a href=\"%s/\"><i>", urlname);
 			bozo_printf(httpd, "%s/", htmlname);
 		} else if (strchr(name, ':') != NULL) {
 			/* RFC 3986 4.2 */
-			bozo_printf(httpd, "<a href=\"./%s\">", urlname);
+			bozo_printf(httpd, "<a href=\"./%s\"><i>", urlname);
 			bozo_printf(httpd, "%s", htmlname);
 		} else {
-			bozo_printf(httpd, "<a href=\"%s\">", urlname);
+			bozo_printf(httpd, "<a href=\"%s\"><i>", urlname);
 			bozo_printf(httpd, "%s", htmlname);
 		}
 		if (htmlname != name)
 			free(htmlname);
-		bozo_printf(httpd, "</a>");
+		bozo_printf(httpd, "</i></a>");
 
 		if (nostat)
 			bozo_printf(httpd, "<td>?<td>?\r\n");
-		else {
+		else if (strcmp(name, "..") == 0) {
+				bozo_printf(httpd, "<td></td></tr>-->");
+		} else {
 			unsigned long long len;
+			double d;
 
-			strftime(buf, sizeof buf, "%d-%b-%Y %R", gmtime(&sb.st_mtime));
+			strftime(buf, sizeof buf, "<time>%Y-%m-%d</time>", gmtime(&sb.st_mtime));
 			bozo_printf(httpd, "<td>%s", buf);
-
-			len = ((unsigned long long)sb.st_size + 1023) / 1024;
-			bozo_printf(httpd, "<td align=right>%llukB", len);
+			if (S_ISDIR(sb.st_mode)) {
+				bozo_printf(httpd, "<td align=right>%s", "-");
+				} else if (sb.st_size > 1024) {
+					if (sb.st_size < 10240) {
+						d = (double)sb.st_size / 1024;
+						bozo_printf(httpd, "<td align=right>%.1lfK", d);
+					} else if (sb.st_size > 1048576) {
+						if (sb.st_size < 10485760) {
+							d = (double)sb.st_size / 1048576;
+							bozo_printf(httpd, "<td align=right>%.1lfM", d);
+						} else {
+							len = (unsigned long long)sb.st_size / 1048576;
+							bozo_printf(httpd, "<td align=right>%lluM", len);
+						}
+					} else {
+						len = (unsigned long long)sb.st_size / 1024;
+						bozo_printf(httpd, "<td align=right>%lluK", len);
+					}
+			} else {
+				len = (unsigned long long)sb.st_size;
+				bozo_printf(httpd, "<td align=right>%lluB", len);
+			}
 		}
 		bozo_printf(httpd, "\r\n");
 	}
@@ -199,7 +227,13 @@
 	while (k--)
         	free(deo[k]);
 	free(deo);
-	bozo_printf(httpd, "</table>\r\n");
+	bozo_printf(httpd, "</table></main>\r\n");
+	if (strcmp(printname, "files/") == 0) {
+		bozo_printf(httpd, "<footer><a href=\"/info/\"><i>../</i></a></footer>\r\n");
+	} else {
+		bozo_printf(httpd, "<footer><a href=\"../\"><i>../</i></a></footer>\r\n");
+		
+	}
 	if (httpd->dir_readme != NULL) {
 		if (httpd->dir_readme[0] == '/')
 			snprintf(buf, sizeof buf, "%s", httpd->dir_readme);

