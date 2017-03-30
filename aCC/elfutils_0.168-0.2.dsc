-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: elfutils
Binary: elfutils, libelf1, libelf-dev, libdw-dev, libdw1, libasm1, libasm-dev
Architecture: any
Version: 0.168-0.2
Maintainer: Kurt Roeckx <kurt@roeckx.be>
Homepage: https://sourceware.org/elfutils/
Standards-Version: 3.9.8
Build-Depends: debhelper (>= 9), autotools-dev, autoconf, automake, bzip2, zlib1g-dev, libbz2-dev, liblzma-dev, m4, gettext, gawk, dpkg-dev (>= 1.16.1~), gcc-multilib [any-amd64 sparc64] <!nocheck>, libc6-dbg [powerpc powerpcspe ppc64 ppc64el armel armhf arm64 sparc64], flex, bison
Build-Conflicts: autoconf2.13, automake1.4
Package-List:
 elfutils deb utils optional arch=any
 libasm-dev deb libdevel optional arch=any
 libasm1 deb libs optional arch=any
 libdw-dev deb libdevel optional arch=any
 libdw1 deb libs optional arch=any
 libelf-dev deb libdevel optional arch=any
 libelf1 deb libs optional arch=any
Checksums-Sha1:
 53e486ddba572cf872d32e9aad4d7d7aa6e767ff 6840399 elfutils_0.168.orig.tar.bz2
 507a350877ad613071a2ff7956fb5e4739b79f2f 36564 elfutils_0.168-0.2.debian.tar.xz
Checksums-Sha256:
 b88d07893ba1373c7dd69a7855974706d05377766568a7d9002706d5de72c276 6840399 elfutils_0.168.orig.tar.bz2
 8998c51b202ed2efc7b9a3906f0926b8f350b0e0071cf86bb9c06a3aa6d3864e 36564 elfutils_0.168-0.2.debian.tar.xz
Files:
 52adfa40758d0d39e5d5c57689bf38d6 6840399 elfutils_0.168.orig.tar.bz2
 d711a181ae1fa2a43cb647d51bcd21bc 36564 elfutils_0.168-0.2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAlhlFOQQHGRva29AZGVi
aWFuLm9yZwAKCRC9fqpgd4+m9eObEADWJT06HOrEhTNh3lnNmKF7iDyHfAMDuh08
/e46cRE8hZ9qSdRDOkwLstIt/2Q3UWNR6sc6xY7RW2Cj+4xadLXckita66uiqnbG
EyKXVr2X7U/JONUbYgCZjsU7BJ+PNaFbv4J8XREIxBETBC7ImSYBzL3PjMxJm+Ta
yA4D6MNHhVTJRo/GK8W8/tW/IDYkGdaKxsVcKUcu36jplDWDHniB1sztqnOrZRwX
13Z4Z1UWRnqcEKGBrui/7t0XPxRnqlD7dg+rQPEZKlmTyLeuQihmTC+cTf3tg1DT
0r8HVAyZL2ZnaqAyGcNa19FYAhj7RM86+O90gvh6tbqcfSXlvTYy2CwXYncsEc37
Mm3+JRkhGoEfzN8PWKmimhzmfSPt5P/vnAjmhWvmz6lPfSCM+0Pm/WpTy0rDHku7
+FXZkK2cTgmqmj9VzrJKiirexiPipFkl3d9HK2WWxKwuE4NOQToq5YjTdws1VLJu
kkVFal1VojFRjzCsZEubJHfNdbAXdac+AFyPDU5tHyqjWF09doNmTkLiy3HNkVZW
CILFxCfEUaRmJ04yZVuOw1W2HMc3VkP/Qe1v7KD5UipA55JM2OcGAavUBcZIB59c
KX2RZPa3OrFwyJ3Z/ABlp9heiSfeMNPbdFp44CfhYzs5tUtrWD2lPbjxfhPTh5lf
P7nOCzbeVA==
=qAmR
-----END PGP SIGNATURE-----
