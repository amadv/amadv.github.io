--- screen.h.orig	2022-01-19 23:06:24.331878356 +0900
+++ screen.h	2022-01-19 23:07:03.751825902 +0900
@@ -831,6 +831,7 @@
 	bool DontPaintRootWindow;    ///< DontPaintRootWindow config var
 	bool BackingStore; ///< BackingStore config var
 	bool SaveUnder;    ///< NoSaveUnders config var (inverse)
+	CntrPlac CentrePlacement;  ///< CentrePlacement config var (on/off)
 	RandPlac RandomPlacement;  ///< RandomPlacement config var (1st arg)
 	short RandomDisplacementX; ///< RandomPlacement config var (2nd arg)
 	short RandomDisplacementY; ///< RandomPlacement config var (2nd arg)

