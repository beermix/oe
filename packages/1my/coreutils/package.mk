PKG_NAME="coreutils"
PKG_VERSION="8.31"
PKG_URL="http://ftpmirror.gnu.org/coreutils/coreutils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="acl libcap pcre readline openssl"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_c_restrict=no \
			      ac_cv_func_chown_works=yes \
			      ac_cv_func_euidaccess=no \
			      ac_cv_func_fstatat=yes \
			      ac_cv_func_getdelim=yes \
			      ac_cv_func_getgroups=yes \
			      ac_cv_func_getgroups_works=yes \
			      ac_cv_func_getloadavg=no \
			      ac_cv_func_lstat_dereferences_slashed_symlink=yes \
			      ac_cv_func_lstat_empty_string_bug=no \
			      ac_cv_func_strerror_r_char_p=no \
			      ac_cv_func_strnlen_working=yes \
			      ac_cv_func_strtod=yes \
			      ac_cv_func_working_mktime=yes \
			      ac_cv_have_decl_strerror_r=yes \
			      ac_cv_have_decl_strnlen=yes \
			      ac_cv_lib_getloadavg_getloadavg=no \
			      ac_cv_lib_util_getloadavg=no \
			      ac_fsusage_space=yes \
			      ac_use_included_regex=no \
			      am_cv_func_working_getline=yes \
			      fu_cv_sys_stat_statfs2_bsize=yes \
			      gl_cv_func_getcwd_null=yes \
			      gl_cv_func_getcwd_path_max=yes \
			      gl_cv_func_gettimeofday_clobber=no \
			      gl_cv_func_fstatat_zero_flag=no \
			      gl_cv_func_link_follows_symlink=no \
			      gl_cv_func_re_compile_pattern_working=yes \
			      gl_cv_func_svid_putenv=yes \
			      gl_cv_func_tzset_clobber=no \
			      gl_cv_func_working_mkstemp=yes \
			      gl_cv_func_working_utimes=yes \
			      gl_getline_needs_run_time_check=no \
			      gl_cv_have_proc_uptime=yes \
			      utils_cv_localtime_cache=no \
			      PERL=missing \
			      MAKEINFO=true \
			      --without-selinux"
      
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"