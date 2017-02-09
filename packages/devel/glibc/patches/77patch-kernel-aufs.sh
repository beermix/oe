 dnl On some platforms we cannot use dynamic loading.  We must provide
 dnl static NSS modules.
diff --git a/sysdeps/x86_64/sysdep.h b/sysdeps/x86_64/sysdep.h
index 75ac747..fbe3560 100644
--- a/sysdeps/x86_64/sysdep.h
+++ b/sysdeps/x86_64/sysdep.h
@@ -90,13 +90,9 @@ lose:									      \
 
 #undef JUMPTARGET
 #ifdef PIC
-# ifdef BIND_NOW
-#  define JUMPTARGET(name)	*name##@GOTPCREL(%rip)
-# else
-#  define JUMPTARGET(name)	name##@PLT
-# endif
+#define JUMPTARGET(name)	name##@PLT
 #else
-# define JUMPTARGET(name)	name
+#define JUMPTARGET(name)	name
 #endif
 
 /* Local label name for asm code. */
-- 
2.10.1
