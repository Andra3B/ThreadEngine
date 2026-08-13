local ffi = require("ffi")

local function IndexMetamethod(self, name)
	local value = self.Defines[name]

	if value == nil then
		return self.Library[name]
	else
		return value
	end
end

local defines = {}

defines["__FLT32X_MAX_10_EXP__"] = 308
defines["__FLT32X_DECIMAL_DIG__"] = 17
defines["__DBL_MANT_DIG__"] = 53
defines["_WIN32_WINNT"] = 1537
defines["__DBL_DIG__"] = 15
defines["UINT16_MAX"] = 65535
defines["__WINT_MIN__"] = 0
defines["__FLT16_HAS_DENORM__"] = 1
defines["__FLT16_HAS_INFINITY__"] = 1
defines["INT_LEAST16_MIN"] = -32768
defines["__FLT16_HAS_QUIET_NAN__"] = 1
defines["__FLT16_IS_IEC_60559__"] = 1
defines["__FLT32_MANT_DIG__"] = 24
defines["__FLT32_DIG__"] = 6
defines["INT_LEAST8_MAX"] = 127
defines["__FLT32_MIN_EXP__"] = -125
defines["INT_LEAST16_MAX"] = 32767
defines["__FLT32_MIN_10_EXP__"] = -37
defines["INT_LEAST32_MAX"] = 2147483647
defines["__FLT32_MAX_EXP__"] = 128
defines["__FLT32_MAX_10_EXP__"] = 38
defines["__FLT32_DECIMAL_DIG__"] = 9
defines["INT_LEAST64_MAX"] = 9.2233720368548e+18
defines["UINT_LEAST8_MAX"] = 255
defines["UINT_LEAST16_MAX"] = 65535
defines["_SECURECRT_FILL_BUFFER_PATTERN"] = 253
defines["INT16_MIN"] = -32768
defines["INT8_MAX"] = 127
defines["__MINGW_FORTIFY_LEVEL"] = 0
defines["INT_FAST8_MIN"] = -128
defines["INT64_MAX"] = 9.2233720368548e+18
defines["INT_FAST16_MIN"] = -32768
defines["__MINGW_FORTIFY_VA_ARG"] = 0
defines["INT_FAST32_MIN"] = -2147483648
defines["INT_FAST8_MAX"] = 127
defines["_CRT_SECURE_CPP_OVERLOAD_SECURE_NAMES"] = 0
defines["INT_FAST16_MAX"] = 32767
defines["_CRT_SECURE_CPP_OVERLOAD_SECURE_NAMES_MEMORY"] = 0
defines["INT_FAST32_MAX"] = 2147483647
defines["_CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES"] = 0
defines["INT_FAST64_MAX"] = 9.2233720368548e+18
defines["_CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES_COUNT"] = 0
defines["UINT_FAST8_MAX"] = 255
defines["_CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES_MEMORY"] = 0
defines["UINT_FAST16_MAX"] = 65535
defines["INT_LEAST32_MIN"] = -2147483648
defines["__bool_true_false_are_defined"] = 1
defines["INT_LEAST8_MIN"] = -128
defines["INTPTR_MAX"] = 9.2233720368548e+18
defines["UINT8_MAX"] = 255
defines["INT32_MAX"] = 2147483647
defines["__STDC__"] = 1
defines["INT16_MAX"] = 32767
defines["INTMAX_MAX"] = 9.2233720368548e+18
defines["__STDC_VERSION__"] = 202311
defines["INT32_MIN"] = -2147483648
defines["INT8_MIN"] = -128
defines["PTRDIFF_MAX"] = 9.2233720368548e+18
defines["__STDC_UTF_16__"] = 1
defines["SIG_ATOMIC_MIN"] = -2147483648
defines["__STDC_UTF_32__"] = 1
defines["SIG_ATOMIC_MAX"] = 2147483647
defines["__STDC_HOSTED__"] = 1
defines["__STDC_EMBED_NOT_FOUND__"] = 0
defines["WCHAR_MIN"] = 0
defines["__STDC_EMBED_FOUND__"] = 1
defines["_ARGMAX"] = 100
defines["__STDC_EMBED_EMPTY__"] = 2
defines["__GNUC__"] = 16
defines["WINT_MIN"] = 0
defines["__GNUC_MINOR__"] = 1
defines["__GNUC_PATCHLEVEL__"] = 0
defines["__VERSION__"] = "16.1.0"
defines["__ATOMIC_RELAXED"] = 0
defines["__ATOMIC_SEQ_CST"] = 5
defines["__ATOMIC_ACQUIRE"] = 2
defines["__ATOMIC_RELEASE"] = 3
defines["__FLT32_HAS_INFINITY__"] = 1
defines["__ATOMIC_ACQ_REL"] = 4
defines["__FLT32X_MANT_DIG__"] = 53
defines["__ATOMIC_CONSUME"] = 1
defines["__pic__"] = 1
defines["__PIC__"] = 1
defines["__FINITE_MATH_ONLY__"] = 0
defines["__SIZEOF_INT__"] = 4
defines["__SIZEOF_LONG__"] = 4
defines["__SIZEOF_LONG_LONG__"] = 8
defines["__SIZEOF_SHORT__"] = 2
defines["__SIZEOF_FLOAT__"] = 4
defines["__SIZEOF_DOUBLE__"] = 8
defines["__SIZEOF_LONG_DOUBLE__"] = 16
defines["__SIZEOF_SIZE_T__"] = 8
defines["__CHAR_BIT__"] = 8
defines["__BIGGEST_ALIGNMENT__"] = 16
defines["__ORDER_LITTLE_ENDIAN__"] = 1234
defines["__ORDER_BIG_ENDIAN__"] = 4321
defines["__FLT32X_HAS_DENORM__"] = 1
defines["__FLT32X_HAS_INFINITY__"] = 1
defines["__FLT32X_HAS_QUIET_NAN__"] = 1
defines["__USE_MINGW_ANSI_STDIO"] = 0
defines["__BYTE_ORDER__"] = 1234
defines["__FLT64X_MANT_DIG__"] = 64
defines["__FLOAT_WORD_ORDER__"] = 1234
defines["__SIZEOF_POINTER__"] = 8
defines["__FLT64X_DIG__"] = 18
defines["__GNUC_EXECUTION_CHARSET_NAME"] = "UTF-8"
defines["__FLT64X_MIN_EXP__"] = -16381
defines["__SHRT_WIDTH__"] = 16
defines["__GNUC_WIDE_EXECUTION_CHARSET_NAME"] = "UTF-16LE"
defines["__LDBL_MAX_EXP__"] = 16384
defines["__FLT64X_MAX_EXP__"] = 16384
defines["__INT_WIDTH__"] = 32
defines["__FLT64X_MAX_10_EXP__"] = 4932
defines["__LDBL_MAX_10_EXP__"] = 4932
defines["__FLT64X_DECIMAL_DIG__"] = 21
defines["__LONG_WIDTH__"] = 32
defines["__FLT64_HAS_QUIET_NAN__"] = 1
defines["__LONG_LONG_WIDTH__"] = 64
defines["__FLT32_IS_IEC_60559__"] = 1
defines["__DEC128_MIN_EXP__"] = -6142
defines["__DEC64X_MIN_EXP__"] = -6142
defines["__WCHAR_WIDTH__"] = 16
defines["__FLT64_HAS_DENORM__"] = 1
defines["__WINT_WIDTH__"] = 16
defines["__FLT_NORM_MAX__"] = 3.4028234663853e+38
defines["__PTRDIFF_WIDTH__"] = 64
defines["__SIZE_WIDTH__"] = 64
defines["__BITINT_MAXWIDTH__"] = 65535
defines["__STDC_SECURE_LIB__"] = 200411
defines["__SCHAR_WIDTH__"] = 8
defines["_CRT_PACKING"] = 8
defines["__GOT_SECURE_LIB__"] = 200411
defines["__INTMAX_WIDTH__"] = 64
defines["__SIG_ATOMIC_MAX__"] = 2147483647
defines["__SIG_ATOMIC_MIN__"] = -2147483648
defines["__FLT64X_HAS_INFINITY__"] = 1
defines["__BFLT16_MANT_DIG__"] = 8
defines["__SIG_ATOMIC_WIDTH__"] = 32
defines["__INT8_MAX__"] = 127
defines["__CRT__NO_INLINE"] = 1
defines["__INT16_MAX__"] = 32767
defines["__BFLT16_MIN_10_EXP__"] = -37
defines["__INT32_MAX__"] = 2147483647
defines["__FLT64_MANT_DIG__"] = 53
defines["__DEC64X_MANT_DIG__"] = 34
defines["__UINT8_MAX__"] = 255
defines["__USE_CRTIMP"] = 1
defines["__BFLT16_MIN_EXP__"] = -125
defines["__UINT16_MAX__"] = 65535
defines["__x86_64"] = 1
defines["__BFLT16_MAX_EXP__"] = 128
defines["__ATOMIC_HLE_ACQUIRE"] = 65536
defines["__BFLT16_MAX_10_EXP__"] = 38
defines["__MINGW_GCC_VERSION"] = 160100
defines["__BFLT16_DECIMAL_DIG__"] = 4
defines["__MINGW_HAVE_WIDE_C99_SCANF"] = 1
defines["__MINGW64__"] = 1
defines["__INT_LEAST8_MAX__"] = 127
defines["__WIN64"] = 1
defines["__MINGW_HAVE_ANSI_C99_SCANF"] = 1
defines["__INT_LEAST8_WIDTH__"] = 8
defines["__MINGW_HAVE_WIDE_C99_PRINTF"] = 1
defines["__INT_LEAST16_MAX__"] = 32767
defines["__MINGW_HAVE_ANSI_C99_PRINTF"] = 1
defines["_WIN64"] = 1
defines["__INT_LEAST16_WIDTH__"] = 16
defines["__USING_POSIXTHREAD__"] = 1
defines["__INT_LEAST32_MAX__"] = 2147483647
defines["__DECIMAL_BID_FORMAT__"] = 1
defines["__INT_LEAST32_WIDTH__"] = 32
defines["_REENTRANT"] = 1
defines["__INT_LEAST64_WIDTH__"] = 64
defines["__UINT_LEAST8_MAX__"] = 255
defines["__UINT_LEAST16_MAX__"] = 65535
defines["__BFLT16_HAS_DENORM__"] = 1
defines["__BFLT16_HAS_INFINITY__"] = 1
defines["__BFLT16_HAS_QUIET_NAN__"] = 1
defines["__BFLT16_IS_IEC_60559__"] = 0
defines["__INT_FAST8_MAX__"] = 127
defines["__INT_FAST8_WIDTH__"] = 8
defines["__DEC32_MANT_DIG__"] = 7
defines["__INT_FAST16_MAX__"] = 32767
defines["__SEG_GS"] = 1
defines["__INT_FAST16_WIDTH__"] = 16
defines["__DEC32_MIN_EXP__"] = -94
defines["__INT_FAST32_MAX__"] = 2147483647
defines["__SEH__"] = 1
defines["__INT_FAST32_WIDTH__"] = 32
defines["__DEC32_MAX_EXP__"] = 97
defines["__GXX_TYPEINFO_EQUALITY_INLINE"] = 0
defines["__INT_FAST64_WIDTH__"] = 64
defines["__MSVCRT__"] = 1
defines["__UINT_FAST8_MAX__"] = 255
defines["_WIN32"] = 1
defines["__UINT_FAST16_MAX__"] = 65535
defines["__MINGW64_VERSION_STATE"] = "alpha"
defines["__WIN32"] = 1
defines["WIN32"] = 1
defines["__WINNT"] = 1
defines["WINNT"] = 1
defines["__INTPTR_WIDTH__"] = 64
defines["__WIN64__"] = 1
defines["__MINGW_USE_UNDERSCORE_PREFIX"] = 0
defines["__GCC_IEC_559"] = 2
defines["_M_AMD64"] = 100
defines["_M_X64"] = 100
defines["__GCC_IEC_559_COMPLEX"] = 2
defines["__MINGW32_MINOR_VERSION"] = 11
defines["__FLT_EVAL_METHOD__"] = 0
defines["__MINGW32_MAJOR_VERSION"] = 3
defines["__FLT_EVAL_METHOD_TS_18661_3__"] = 0
defines["__DEC64_MANT_DIG__"] = 16
defines["__DEC_EVAL_METHOD__"] = 2
defines["__MINGW64_VERSION_RC"] = 0
defines["__FLT_RADIX__"] = 2
defines["__DEC64_MIN_EXP__"] = -382
defines["__FLT_MANT_DIG__"] = 24
defines["__MINGW64_VERSION_BUGFIX"] = 0
defines["__MINGW64_VERSION_MINOR"] = 0
defines["__DEC64_MAX_EXP__"] = 385
defines["__FLT_DIG__"] = 6
defines["__MINGW64_VERSION_MAJOR"] = 14
defines["__FLT_MIN_EXP__"] = -125
defines["WIN64"] = 1
defines["_INTEGRAL_MAX_BITS"] = 64
defines["__FLT_MIN_10_EXP__"] = -37
defines["__WINNT__"] = 1
defines["__FLT_MAX_EXP__"] = 128
defines["__WIN32__"] = 1
defines["__FLT_MAX_10_EXP__"] = 38
defines["__MINGW32__"] = 1
defines["__FLT_DECIMAL_DIG__"] = 9
defines["__GXX_MERGED_TYPEINFO_NAMES"] = 0
defines["__FLT_MAX__"] = 3.4028234663853e+38
defines["__SEG_FS"] = 1
defines["__DEC128_MANT_DIG__"] = 34
defines["__MMX_WITH_SSE__"] = 1
defines["__DBL_MIN_EXP__"] = -1021
defines["__SSE2_MATH__"] = 1
defines["__FLT_MIN__"] = 1.1754943508223e-38
defines["__SSE_MATH__"] = 1
defines["__DBL_MIN_10_EXP__"] = -307
defines["__FXSR__"] = 1
defines["__DEC128_MAX_EXP__"] = 6145
defines["__FLT_EPSILON__"] = 1.1920928955078e-07
defines["__DEC64X_MAX_EXP__"] = 6145
defines["__GCC_ATOMIC_CHAR_LOCK_FREE"] = 2
defines["__FLT64_DIG__"] = 15
defines["__SSE__"] = 1
defines["__DBL_MAX_10_EXP__"] = 308
defines["__FLT_DENORM_MIN__"] = 1.4012984643248e-45
defines["__FLT64_MIN_EXP__"] = -1021
defines["__ORDER_PDP_ENDIAN__"] = 3412
defines["__DBL_DECIMAL_DIG__"] = 17
defines["__code_model_medium__"] = 1
defines["__FLT64_MIN_10_EXP__"] = -307
defines["__FLT_HAS_DENORM__"] = 1
defines["__k8__"] = 1
defines["__k8"] = 1
defines["__FLT64_MAX_EXP__"] = 1024
defines["__FLT_HAS_INFINITY__"] = 1
defines["__GCC_ASM_FLAG_OUTPUTS__"] = 1
defines["__FLT_HAS_QUIET_NAN__"] = 1
defines["__FLT64_MAX_10_EXP__"] = 308
defines["__FLT_IS_IEC_60559__"] = 1
defines["__DBL_HAS_DENORM__"] = 1
defines["__MINGW_SEC_WARN_STR"] = "This function or variable may be unsafe, use _CRT_SECURE_NO_WARNINGS to disable deprecation"
defines["__FLT64_DECIMAL_DIG__"] = 17
defines["__FLT32X_IS_IEC_60559__"] = 1
defines["__DBL_MAX_EXP__"] = 1024
defines["__x86_64__"] = 1
defines["__MINGW_MSVC2005_DEPREC_STR"] = "This POSIX function is deprecated beginning in Visual C++ 2005, use _CRT_NONSTDC_NO_DEPRECATE to disable deprecation"
defines["__amd64__"] = 1
defines["__GNUC_STDC_INLINE__"] = 1
defines["__amd64"] = 1
defines["__NO_INLINE__"] = 1
defines["__SIZEOF_PTRDIFF_T__"] = 8
defines["__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1"] = 1
defines["__SIZEOF_WINT_T__"] = 2
defines["__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2"] = 1
defines["__SIZEOF_WCHAR_T__"] = 2
defines["__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4"] = 1
defines["__SIZEOF_INT128__"] = 16
defines["__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8"] = 1
defines["__FLT64X_IS_IEC_60559__"] = 1
defines["__DBL_HAS_INFINITY__"] = 1
defines["__HAVE_SPECULATION_SAFE_VALUE"] = 1
defines["__DBL_HAS_QUIET_NAN__"] = 1
defines["__DBL_IS_IEC_60559__"] = 1
defines["USE___UUIDOF"] = 0
defines["__GCC_ATOMIC_CHAR16_T_LOCK_FREE"] = 2
defines["__LDBL_DIG__"] = 18
defines["__FLT32X_MIN_10_EXP__"] = -307
defines["__GCC_ATOMIC_WCHAR_T_LOCK_FREE"] = 2
defines["__GXX_ABI_VERSION"] = 1021
defines["__LDBL_MIN_EXP__"] = -16381
defines["__FLT128_DIG__"] = 33
defines["__FLT64_HAS_INFINITY__"] = 1
defines["__SCHAR_MAX__"] = 127
defines["__LDBL_MIN_10_EXP__"] = -4931
defines["__FLT32X_DIG__"] = 15
defines["__FLT64_IS_IEC_60559__"] = 1
defines["__SHRT_MAX__"] = 32767
defines["__FLT128_MANT_DIG__"] = 113
defines["__BFLT16_DIG__"] = 2
defines["__GCC_DESTRUCTIVE_SIZE"] = 64
defines["__INT_MAX__"] = 2147483647
defines["__GCC_CONSTRUCTIVE_SIZE"] = 64
defines["__GCC_ATOMIC_POINTER_LOCK_FREE"] = 2
defines["__DECIMAL_DIG__"] = 21
defines["__FLT128_HAS_QUIET_NAN__"] = 1
defines["__PRAGMA_REDEFINE_EXTNAME"] = 1
defines["__LDBL_DECIMAL_DIG__"] = 21
defines["__FLT64X_HAS_QUIET_NAN__"] = 1
defines["__LDBL_MAX__"] = inf
defines["__FLT128_HAS_DENORM__"] = 1
defines["__FLT128_MAX_EXP__"] = 16384
defines["__FLT32_HAS_DENORM__"] = 1
defines["__WCHAR_MAX__"] = 65535
defines["__LDBL_NORM_MAX__"] = inf
defines["__FLT128_MAX_10_EXP__"] = 4932
defines["__LDBL_MIN__"] = 0
defines["__WCHAR_MIN__"] = 0
defines["__FLT64X_HAS_DENORM__"] = 1
defines["__FLT128_DECIMAL_DIG__"] = 36
defines["__GCC_ATOMIC_CHAR32_T_LOCK_FREE"] = 2
defines["__LDBL_EPSILON__"] = 1.0842021724855e-19
defines["__GCC_ATOMIC_LONG_LOCK_FREE"] = 2
defines["__SIZEOF_FLOAT80__"] = 16
defines["__GCC_ATOMIC_TEST_AND_SET_TRUEVAL"] = 1
defines["__SIZEOF_FLOAT128__"] = 16
defines["__LDBL_DENORM_MIN__"] = 0
defines["__FLT64X_MIN_10_EXP__"] = -4931
defines["__LDBL_MANT_DIG__"] = 64
defines["__ATOMIC_HLE_RELEASE"] = 131072
defines["__WINT_MAX__"] = 65535
defines["__LDBL_HAS_DENORM__"] = 1
defines["__FLT128_MIN_10_EXP__"] = -4931
defines["__LDBL_HAS_INFINITY__"] = 1
defines["__FLT128_MIN_EXP__"] = -16381
defines["__LDBL_HAS_QUIET_NAN__"] = 1
defines["__FLT32_HAS_QUIET_NAN__"] = 1
defines["__LDBL_IS_IEC_60559__"] = 1
defines["__GCC_ATOMIC_LLONG_LOCK_FREE"] = 2
defines["__FLT16_MANT_DIG__"] = 11
defines["__GCC_ATOMIC_INT_LOCK_FREE"] = 2
defines["__MMX__"] = 1
defines["__GCC_ATOMIC_SHORT_LOCK_FREE"] = 2
defines["__FLT16_DIG__"] = 3
defines["__GCC_ATOMIC_CHAR8_T_LOCK_FREE"] = 2
defines["__SSE2__"] = 1
defines["__GCC_ATOMIC_BOOL_LOCK_FREE"] = 2
defines["__FLT16_MIN_EXP__"] = -13
defines["__FLT128_HAS_INFINITY__"] = 1
defines["__FLT16_MIN_10_EXP__"] = -4
defines["__FLT128_IS_IEC_60559__"] = 1
defines["__FLT16_MAX_EXP__"] = 16
defines["__FLT16_MAX_10_EXP__"] = 4
defines["__FLT32X_MIN_EXP__"] = -1021
defines["__FLT16_DECIMAL_DIG__"] = 5
defines["__FLT32X_MAX_EXP__"] = 1024
defines["__MSVCRT_VERSION__"] = 3584

ffi.cdef([[
  typedef __builtin_va_list __gnuc_va_list;
  typedef __gnuc_va_list va_list;
void __attribute__((__cdecl__)) __debugbreak(void);
extern __inline__ __attribute__((__always_inline__,__gnu_inline__)) void __attribute__((__cdecl__)) __debugbreak(void)
{
  __asm__ __volatile__("int {$}3":);
}
void __attribute__((__cdecl__)) __attribute__ ((__noreturn__)) __fastfail(unsigned int _Code);
extern __inline__ __attribute__((__always_inline__,__gnu_inline__)) void __attribute__((__cdecl__)) __attribute__ ((__noreturn__)) __fastfail(unsigned int _Code)
{
  __asm__ __volatile__("int {$}0x29"::"c"(_Code));
  __builtin_unreachable();
}
const char *__mingw_get_crt_info (void);
__extension__ typedef unsigned long long size_t;
__extension__ typedef long long ssize_t;
typedef size_t rsize_t;
__extension__ typedef long long intptr_t;
__extension__ typedef unsigned long long uintptr_t;
__extension__ typedef long long ptrdiff_t;
typedef unsigned short wchar_t;
typedef unsigned short wint_t;
typedef unsigned short wctype_t;
typedef int errno_t;
typedef long __time32_t;
__extension__ typedef long long __time64_t;
typedef __time64_t time_t;
__attribute__ ((__dllimport__)) void __attribute__((__cdecl__)) _invalid_parameter_noinfo(void);
__attribute__ ((__dllimport__)) __attribute__ ((__noreturn__)) void __attribute__((__cdecl__)) _invalid_parameter_noinfo_noreturn(void);
__attribute__ ((__dllimport__)) __attribute__ ((__noreturn__)) void __attribute__((__cdecl__)) _invoke_watson(const wchar_t *expression, const wchar_t *function_name, const wchar_t *file_name, unsigned int line_number, long long unsigned int reserved);
struct threadlocaleinfostruct;
struct threadmbcinfostruct;
typedef struct threadlocaleinfostruct *pthreadlocinfo;
typedef struct threadmbcinfostruct *pthreadmbcinfo;
struct __lc_time_data;
typedef struct localeinfo_struct {
  pthreadlocinfo locinfo;
  pthreadmbcinfo mbcinfo;
} _locale_tstruct,*_locale_t;
typedef struct tagLC_ID {
  unsigned short wLanguage;
  unsigned short wCountry;
  unsigned short wCodePage;
} LC_ID,*LPLC_ID;
typedef struct threadlocaleinfostruct {
  const unsigned short *_locale_pctype;
  int _locale_mb_cur_max;
  unsigned int _locale_lc_codepage;
} threadlocinfo;
  __attribute__ ((__dllimport__)) extern int *__attribute__((__cdecl__)) _errno(void);
  __attribute__ ((__dllimport__)) errno_t __attribute__((__cdecl__)) _set_errno(int _Value);
  __attribute__ ((__dllimport__)) errno_t __attribute__((__cdecl__)) _get_errno(int *_Value);
  __attribute__ ((__dllimport__)) extern unsigned long __attribute__((__cdecl__)) __threadid(void);
  __attribute__ ((__dllimport__)) extern uintptr_t __attribute__((__cdecl__)) __threadhandle(void);
typedef struct {
  long long __max_align_ll __attribute__((__aligned__(__alignof__(long long))));
  long double __max_align_ld __attribute__((__aligned__(__alignof__(long double))));
} max_align_t;
typedef signed char int8_t;
typedef unsigned char uint8_t;
typedef short int16_t;
typedef unsigned short uint16_t;
typedef int int32_t;
typedef unsigned uint32_t;
__extension__ typedef long long int64_t;
__extension__ typedef unsigned long long uint64_t;
typedef signed char int_least8_t;
typedef unsigned char uint_least8_t;
typedef short int_least16_t;
typedef unsigned short uint_least16_t;
typedef int int_least32_t;
typedef unsigned uint_least32_t;
__extension__ typedef long long int_least64_t;
__extension__ typedef unsigned long long uint_least64_t;
typedef signed char int_fast8_t;
typedef unsigned char uint_fast8_t;
typedef short int_fast16_t;
typedef unsigned short uint_fast16_t;
typedef int int_fast32_t;
typedef unsigned int uint_fast32_t;
__extension__ typedef long long int_fast64_t;
__extension__ typedef unsigned long long uint_fast64_t;
__extension__ typedef long long intmax_t;
__extension__ typedef unsigned long long uintmax_t;
typedef size_t cgltf_size;
typedef long long int cgltf_ssize;
typedef float cgltf_float;
typedef int cgltf_int;
typedef unsigned int cgltf_uint;
typedef int cgltf_bool;
typedef enum cgltf_file_type
{
 cgltf_file_type_invalid,
 cgltf_file_type_gltf,
 cgltf_file_type_glb,
 cgltf_file_type_max_enum
} cgltf_file_type;
typedef enum cgltf_result
{
 cgltf_result_success,
 cgltf_result_data_too_short,
 cgltf_result_unknown_format,
 cgltf_result_invalid_json,
 cgltf_result_invalid_gltf,
 cgltf_result_invalid_options,
 cgltf_result_file_not_found,
 cgltf_result_io_error,
 cgltf_result_out_of_memory,
 cgltf_result_legacy_gltf,
    cgltf_result_max_enum
} cgltf_result;
typedef struct cgltf_memory_options
{
 void* (*alloc_func)(void* user, cgltf_size size);
 void (*free_func) (void* user, void* ptr);
 void* user_data;
} cgltf_memory_options;
typedef struct cgltf_file_options
{
 cgltf_result(*read)(const struct cgltf_memory_options* memory_options, const struct cgltf_file_options* file_options, const char* path, cgltf_size* size, void** data);
 void (*release)(const struct cgltf_memory_options* memory_options, const struct cgltf_file_options* file_options, void* data);
 void* user_data;
} cgltf_file_options;
typedef struct cgltf_options
{
 cgltf_file_type type;
 cgltf_size json_token_count;
 cgltf_memory_options memory;
 cgltf_file_options file;
} cgltf_options;
typedef enum cgltf_buffer_view_type
{
 cgltf_buffer_view_type_invalid,
 cgltf_buffer_view_type_indices,
 cgltf_buffer_view_type_vertices,
 cgltf_buffer_view_type_max_enum
} cgltf_buffer_view_type;
typedef enum cgltf_attribute_type
{
 cgltf_attribute_type_invalid,
 cgltf_attribute_type_position,
 cgltf_attribute_type_normal,
 cgltf_attribute_type_tangent,
 cgltf_attribute_type_texcoord,
 cgltf_attribute_type_color,
 cgltf_attribute_type_joints,
 cgltf_attribute_type_weights,
 cgltf_attribute_type_custom,
 cgltf_attribute_type_max_enum
} cgltf_attribute_type;
typedef enum cgltf_component_type
{
 cgltf_component_type_invalid,
 cgltf_component_type_r_8,
 cgltf_component_type_r_8u,
 cgltf_component_type_r_16,
 cgltf_component_type_r_16u,
 cgltf_component_type_r_32u,
 cgltf_component_type_r_32f,
    cgltf_component_type_max_enum
} cgltf_component_type;
typedef enum cgltf_type
{
 cgltf_type_invalid,
 cgltf_type_scalar,
 cgltf_type_vec2,
 cgltf_type_vec3,
 cgltf_type_vec4,
 cgltf_type_mat2,
 cgltf_type_mat3,
 cgltf_type_mat4,
 cgltf_type_max_enum
} cgltf_type;
typedef enum cgltf_primitive_type
{
 cgltf_primitive_type_invalid,
 cgltf_primitive_type_points,
 cgltf_primitive_type_lines,
 cgltf_primitive_type_line_loop,
 cgltf_primitive_type_line_strip,
 cgltf_primitive_type_triangles,
 cgltf_primitive_type_triangle_strip,
 cgltf_primitive_type_triangle_fan,
 cgltf_primitive_type_max_enum
} cgltf_primitive_type;
typedef enum cgltf_alpha_mode
{
 cgltf_alpha_mode_opaque,
 cgltf_alpha_mode_mask,
 cgltf_alpha_mode_blend,
 cgltf_alpha_mode_max_enum
} cgltf_alpha_mode;
typedef enum cgltf_animation_path_type {
 cgltf_animation_path_type_invalid,
 cgltf_animation_path_type_translation,
 cgltf_animation_path_type_rotation,
 cgltf_animation_path_type_scale,
 cgltf_animation_path_type_weights,
 cgltf_animation_path_type_max_enum
} cgltf_animation_path_type;
typedef enum cgltf_interpolation_type {
 cgltf_interpolation_type_linear,
 cgltf_interpolation_type_step,
 cgltf_interpolation_type_cubic_spline,
 cgltf_interpolation_type_max_enum
} cgltf_interpolation_type;
typedef enum cgltf_camera_type {
 cgltf_camera_type_invalid,
 cgltf_camera_type_perspective,
 cgltf_camera_type_orthographic,
 cgltf_camera_type_max_enum
} cgltf_camera_type;
typedef enum cgltf_light_type {
 cgltf_light_type_invalid,
 cgltf_light_type_directional,
 cgltf_light_type_point,
 cgltf_light_type_spot,
 cgltf_light_type_max_enum
} cgltf_light_type;
typedef enum cgltf_data_free_method {
 cgltf_data_free_method_none,
 cgltf_data_free_method_file_release,
 cgltf_data_free_method_memory_free,
 cgltf_data_free_method_max_enum
} cgltf_data_free_method;
typedef struct cgltf_extras {
 cgltf_size start_offset;
 cgltf_size end_offset;
 char* data;
} cgltf_extras;
typedef struct cgltf_extension {
 char* name;
 char* data;
} cgltf_extension;
typedef struct cgltf_buffer
{
 char* name;
 cgltf_size size;
 char* uri;
 void* data;
 cgltf_data_free_method data_free_method;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_buffer;
typedef enum cgltf_meshopt_compression_mode {
 cgltf_meshopt_compression_mode_invalid,
 cgltf_meshopt_compression_mode_attributes,
 cgltf_meshopt_compression_mode_triangles,
 cgltf_meshopt_compression_mode_indices,
 cgltf_meshopt_compression_mode_max_enum
} cgltf_meshopt_compression_mode;
typedef enum cgltf_meshopt_compression_filter {
 cgltf_meshopt_compression_filter_none,
 cgltf_meshopt_compression_filter_octahedral,
 cgltf_meshopt_compression_filter_quaternion,
 cgltf_meshopt_compression_filter_exponential,
 cgltf_meshopt_compression_filter_max_enum
} cgltf_meshopt_compression_filter;
typedef struct cgltf_meshopt_compression
{
 cgltf_buffer* buffer;
 cgltf_size offset;
 cgltf_size size;
 cgltf_size stride;
 cgltf_size count;
 cgltf_meshopt_compression_mode mode;
 cgltf_meshopt_compression_filter filter;
} cgltf_meshopt_compression;
typedef struct cgltf_buffer_view
{
 char *name;
 cgltf_buffer* buffer;
 cgltf_size offset;
 cgltf_size size;
 cgltf_size stride;
 cgltf_buffer_view_type type;
 void* data;
 cgltf_bool has_meshopt_compression;
 cgltf_meshopt_compression meshopt_compression;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_buffer_view;
typedef struct cgltf_accessor_sparse
{
 cgltf_size count;
 cgltf_buffer_view* indices_buffer_view;
 cgltf_size indices_byte_offset;
 cgltf_component_type indices_component_type;
 cgltf_buffer_view* values_buffer_view;
 cgltf_size values_byte_offset;
} cgltf_accessor_sparse;
typedef struct cgltf_accessor
{
 char* name;
 cgltf_component_type component_type;
 cgltf_bool normalized;
 cgltf_type type;
 cgltf_size offset;
 cgltf_size count;
 cgltf_size stride;
 cgltf_buffer_view* buffer_view;
 cgltf_bool has_min;
 cgltf_float min[16];
 cgltf_bool has_max;
 cgltf_float max[16];
 cgltf_bool is_sparse;
 cgltf_accessor_sparse sparse;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_accessor;
typedef struct cgltf_attribute
{
 char* name;
 cgltf_attribute_type type;
 cgltf_int index;
 cgltf_accessor* data;
} cgltf_attribute;
typedef struct cgltf_image
{
 char* name;
 char* uri;
 cgltf_buffer_view* buffer_view;
 char* mime_type;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_image;
typedef enum cgltf_filter_type {
    cgltf_filter_type_undefined = 0,
    cgltf_filter_type_nearest = 9728,
    cgltf_filter_type_linear = 9729,
    cgltf_filter_type_nearest_mipmap_nearest = 9984,
    cgltf_filter_type_linear_mipmap_nearest = 9985,
    cgltf_filter_type_nearest_mipmap_linear = 9986,
    cgltf_filter_type_linear_mipmap_linear = 9987
} cgltf_filter_type;
typedef enum cgltf_wrap_mode {
    cgltf_wrap_mode_clamp_to_edge = 33071,
    cgltf_wrap_mode_mirrored_repeat = 33648,
    cgltf_wrap_mode_repeat = 10497
} cgltf_wrap_mode;
typedef struct cgltf_sampler
{
 char* name;
 cgltf_filter_type mag_filter;
 cgltf_filter_type min_filter;
 cgltf_wrap_mode wrap_s;
 cgltf_wrap_mode wrap_t;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_sampler;
typedef struct cgltf_texture
{
 char* name;
 cgltf_image* image;
 cgltf_sampler* sampler;
 cgltf_bool has_basisu;
 cgltf_image* basisu_image;
 cgltf_bool has_webp;
 cgltf_image* webp_image;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_texture;
typedef struct cgltf_texture_transform
{
 cgltf_float offset[2];
 cgltf_float rotation;
 cgltf_float scale[2];
 cgltf_bool has_texcoord;
 cgltf_int texcoord;
} cgltf_texture_transform;
typedef struct cgltf_texture_view
{
 cgltf_texture* texture;
 cgltf_int texcoord;
 cgltf_float scale;
 cgltf_bool has_transform;
 cgltf_texture_transform transform;
} cgltf_texture_view;
typedef struct cgltf_pbr_metallic_roughness
{
 cgltf_texture_view base_color_texture;
 cgltf_texture_view metallic_roughness_texture;
 cgltf_float base_color_factor[4];
 cgltf_float metallic_factor;
 cgltf_float roughness_factor;
} cgltf_pbr_metallic_roughness;
typedef struct cgltf_pbr_specular_glossiness
{
 cgltf_texture_view diffuse_texture;
 cgltf_texture_view specular_glossiness_texture;
 cgltf_float diffuse_factor[4];
 cgltf_float specular_factor[3];
 cgltf_float glossiness_factor;
} cgltf_pbr_specular_glossiness;
typedef struct cgltf_clearcoat
{
 cgltf_texture_view clearcoat_texture;
 cgltf_texture_view clearcoat_roughness_texture;
 cgltf_texture_view clearcoat_normal_texture;
 cgltf_float clearcoat_factor;
 cgltf_float clearcoat_roughness_factor;
} cgltf_clearcoat;
typedef struct cgltf_transmission
{
 cgltf_texture_view transmission_texture;
 cgltf_float transmission_factor;
} cgltf_transmission;
typedef struct cgltf_ior
{
 cgltf_float ior;
} cgltf_ior;
typedef struct cgltf_specular
{
 cgltf_texture_view specular_texture;
 cgltf_texture_view specular_color_texture;
 cgltf_float specular_color_factor[3];
 cgltf_float specular_factor;
} cgltf_specular;
typedef struct cgltf_volume
{
 cgltf_texture_view thickness_texture;
 cgltf_float thickness_factor;
 cgltf_float attenuation_color[3];
 cgltf_float attenuation_distance;
} cgltf_volume;
typedef struct cgltf_sheen
{
 cgltf_texture_view sheen_color_texture;
 cgltf_float sheen_color_factor[3];
 cgltf_texture_view sheen_roughness_texture;
 cgltf_float sheen_roughness_factor;
} cgltf_sheen;
typedef struct cgltf_emissive_strength
{
 cgltf_float emissive_strength;
} cgltf_emissive_strength;
typedef struct cgltf_iridescence
{
 cgltf_float iridescence_factor;
 cgltf_texture_view iridescence_texture;
 cgltf_float iridescence_ior;
 cgltf_float iridescence_thickness_min;
 cgltf_float iridescence_thickness_max;
 cgltf_texture_view iridescence_thickness_texture;
} cgltf_iridescence;
typedef struct cgltf_diffuse_transmission
{
 cgltf_texture_view diffuse_transmission_texture;
 cgltf_float diffuse_transmission_factor;
 cgltf_float diffuse_transmission_color_factor[3];
 cgltf_texture_view diffuse_transmission_color_texture;
} cgltf_diffuse_transmission;
typedef struct cgltf_anisotropy
{
 cgltf_float anisotropy_strength;
 cgltf_float anisotropy_rotation;
 cgltf_texture_view anisotropy_texture;
} cgltf_anisotropy;
typedef struct cgltf_dispersion
{
 cgltf_float dispersion;
} cgltf_dispersion;
typedef struct cgltf_material
{
 char* name;
 cgltf_bool has_pbr_metallic_roughness;
 cgltf_bool has_pbr_specular_glossiness;
 cgltf_bool has_clearcoat;
 cgltf_bool has_transmission;
 cgltf_bool has_volume;
 cgltf_bool has_ior;
 cgltf_bool has_specular;
 cgltf_bool has_sheen;
 cgltf_bool has_emissive_strength;
 cgltf_bool has_iridescence;
 cgltf_bool has_diffuse_transmission;
 cgltf_bool has_anisotropy;
 cgltf_bool has_dispersion;
 cgltf_pbr_metallic_roughness pbr_metallic_roughness;
 cgltf_pbr_specular_glossiness pbr_specular_glossiness;
 cgltf_clearcoat clearcoat;
 cgltf_ior ior;
 cgltf_specular specular;
 cgltf_sheen sheen;
 cgltf_transmission transmission;
 cgltf_volume volume;
 cgltf_emissive_strength emissive_strength;
 cgltf_iridescence iridescence;
 cgltf_diffuse_transmission diffuse_transmission;
 cgltf_anisotropy anisotropy;
 cgltf_dispersion dispersion;
 cgltf_texture_view normal_texture;
 cgltf_texture_view occlusion_texture;
 cgltf_texture_view emissive_texture;
 cgltf_float emissive_factor[3];
 cgltf_alpha_mode alpha_mode;
 cgltf_float alpha_cutoff;
 cgltf_bool double_sided;
 cgltf_bool unlit;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_material;
typedef struct cgltf_material_mapping
{
 cgltf_size variant;
 cgltf_material* material;
 cgltf_extras extras;
} cgltf_material_mapping;
typedef struct cgltf_morph_target {
 cgltf_attribute* attributes;
 cgltf_size attributes_count;
} cgltf_morph_target;
typedef struct cgltf_draco_mesh_compression {
 cgltf_buffer_view* buffer_view;
 cgltf_attribute* attributes;
 cgltf_size attributes_count;
} cgltf_draco_mesh_compression;
typedef struct cgltf_mesh_gpu_instancing {
 cgltf_attribute* attributes;
 cgltf_size attributes_count;
} cgltf_mesh_gpu_instancing;
typedef struct cgltf_primitive {
 cgltf_primitive_type type;
 cgltf_accessor* indices;
 cgltf_material* material;
 cgltf_attribute* attributes;
 cgltf_size attributes_count;
 cgltf_morph_target* targets;
 cgltf_size targets_count;
 cgltf_extras extras;
 cgltf_bool has_draco_mesh_compression;
 cgltf_draco_mesh_compression draco_mesh_compression;
 cgltf_material_mapping* mappings;
 cgltf_size mappings_count;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_primitive;
typedef struct cgltf_mesh {
 char* name;
 cgltf_primitive* primitives;
 cgltf_size primitives_count;
 cgltf_float* weights;
 cgltf_size weights_count;
 char** target_names;
 cgltf_size target_names_count;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_mesh;
typedef struct cgltf_node cgltf_node;
typedef struct cgltf_skin {
 char* name;
 cgltf_node** joints;
 cgltf_size joints_count;
 cgltf_node* skeleton;
 cgltf_accessor* inverse_bind_matrices;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_skin;
typedef struct cgltf_camera_perspective {
 cgltf_bool has_aspect_ratio;
 cgltf_float aspect_ratio;
 cgltf_float yfov;
 cgltf_bool has_zfar;
 cgltf_float zfar;
 cgltf_float znear;
 cgltf_extras extras;
} cgltf_camera_perspective;
typedef struct cgltf_camera_orthographic {
 cgltf_float xmag;
 cgltf_float ymag;
 cgltf_float zfar;
 cgltf_float znear;
 cgltf_extras extras;
} cgltf_camera_orthographic;
typedef struct cgltf_camera {
 char* name;
 cgltf_camera_type type;
 union {
  cgltf_camera_perspective perspective;
  cgltf_camera_orthographic orthographic;
 } data;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_camera;
typedef struct cgltf_light {
 char* name;
 cgltf_float color[3];
 cgltf_float intensity;
 cgltf_light_type type;
 cgltf_float range;
 cgltf_float spot_inner_cone_angle;
 cgltf_float spot_outer_cone_angle;
 cgltf_extras extras;
} cgltf_light;
struct cgltf_node {
 char* name;
 cgltf_node* parent;
 cgltf_node** children;
 cgltf_size children_count;
 cgltf_skin* skin;
 cgltf_mesh* mesh;
 cgltf_camera* camera;
 cgltf_light* light;
 cgltf_float* weights;
 cgltf_size weights_count;
 cgltf_bool has_translation;
 cgltf_bool has_rotation;
 cgltf_bool has_scale;
 cgltf_bool has_matrix;
 cgltf_float translation[3];
 cgltf_float rotation[4];
 cgltf_float scale[3];
 cgltf_float matrix[16];
 cgltf_extras extras;
 cgltf_bool has_mesh_gpu_instancing;
 cgltf_mesh_gpu_instancing mesh_gpu_instancing;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
};
typedef struct cgltf_scene {
 char* name;
 cgltf_node** nodes;
 cgltf_size nodes_count;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_scene;
typedef struct cgltf_animation_sampler {
 cgltf_accessor* input;
 cgltf_accessor* output;
 cgltf_interpolation_type interpolation;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_animation_sampler;
typedef struct cgltf_animation_channel {
 cgltf_animation_sampler* sampler;
 cgltf_node* target_node;
 cgltf_animation_path_type target_path;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_animation_channel;
typedef struct cgltf_animation {
 char* name;
 cgltf_animation_sampler* samplers;
 cgltf_size samplers_count;
 cgltf_animation_channel* channels;
 cgltf_size channels_count;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_animation;
typedef struct cgltf_material_variant
{
 char* name;
 cgltf_extras extras;
} cgltf_material_variant;
typedef struct cgltf_asset {
 char* copyright;
 char* generator;
 char* version;
 char* min_version;
 cgltf_extras extras;
 cgltf_size extensions_count;
 cgltf_extension* extensions;
} cgltf_asset;
typedef struct cgltf_data
{
 cgltf_file_type file_type;
 void* file_data;
 cgltf_asset asset;
 cgltf_mesh* meshes;
 cgltf_size meshes_count;
 cgltf_material* materials;
 cgltf_size materials_count;
 cgltf_accessor* accessors;
 cgltf_size accessors_count;
 cgltf_buffer_view* buffer_views;
 cgltf_size buffer_views_count;
 cgltf_buffer* buffers;
 cgltf_size buffers_count;
 cgltf_image* images;
 cgltf_size images_count;
 cgltf_texture* textures;
 cgltf_size textures_count;
 cgltf_sampler* samplers;
 cgltf_size samplers_count;
 cgltf_skin* skins;
 cgltf_size skins_count;
 cgltf_camera* cameras;
 cgltf_size cameras_count;
 cgltf_light* lights;
 cgltf_size lights_count;
 cgltf_node* nodes;
 cgltf_size nodes_count;
 cgltf_scene* scenes;
 cgltf_size scenes_count;
 cgltf_scene* scene;
 cgltf_animation* animations;
 cgltf_size animations_count;
 cgltf_material_variant* variants;
 cgltf_size variants_count;
 cgltf_extras extras;
 cgltf_size data_extensions_count;
 cgltf_extension* data_extensions;
 char** extensions_used;
 cgltf_size extensions_used_count;
 char** extensions_required;
 cgltf_size extensions_required_count;
 const char* json;
 cgltf_size json_size;
 const void* bin;
 cgltf_size bin_size;
 cgltf_memory_options memory;
 cgltf_file_options file;
} cgltf_data;
cgltf_result cgltf_parse(
  const cgltf_options* options,
  const void* data,
  cgltf_size size,
  cgltf_data** out_data);
cgltf_result cgltf_parse_file(
  const cgltf_options* options,
  const char* path,
  cgltf_data** out_data);
cgltf_result cgltf_load_buffers(
  const cgltf_options* options,
  cgltf_data* data,
  const char* gltf_path);
cgltf_result cgltf_load_buffer_base64(const cgltf_options* options, cgltf_size size, const char* base64, void** out_data);
cgltf_size cgltf_decode_string(char* string);
cgltf_size cgltf_decode_uri(char* uri);
cgltf_result cgltf_validate(cgltf_data* data);
void cgltf_free(cgltf_data* data);
void cgltf_node_transform_local(const cgltf_node* node, cgltf_float* out_matrix);
void cgltf_node_transform_world(const cgltf_node* node, cgltf_float* out_matrix);
const uint8_t* cgltf_buffer_view_data(const cgltf_buffer_view* view);
const cgltf_accessor* cgltf_find_accessor(const cgltf_primitive* prim, cgltf_attribute_type type, cgltf_int index);
cgltf_bool cgltf_accessor_read_float(const cgltf_accessor* accessor, cgltf_size index, cgltf_float* out, cgltf_size element_size);
cgltf_bool cgltf_accessor_read_uint(const cgltf_accessor* accessor, cgltf_size index, cgltf_uint* out, cgltf_size element_size);
cgltf_size cgltf_accessor_read_index(const cgltf_accessor* accessor, cgltf_size index);
cgltf_size cgltf_num_components(cgltf_type type);
cgltf_size cgltf_component_size(cgltf_component_type component_type);
cgltf_size cgltf_calc_size(cgltf_type type, cgltf_component_type component_type);
cgltf_size cgltf_accessor_unpack_floats(const cgltf_accessor* accessor, cgltf_float* out, cgltf_size float_count);
cgltf_size cgltf_accessor_unpack_indices(const cgltf_accessor* accessor, void* out, cgltf_size out_component_size, cgltf_size index_count);
cgltf_result cgltf_copy_extras_json(const cgltf_data* data, const cgltf_extras* extras, char* dest, cgltf_size* dest_size);
cgltf_size cgltf_mesh_index(const cgltf_data* data, const cgltf_mesh* object);
cgltf_size cgltf_material_index(const cgltf_data* data, const cgltf_material* object);
cgltf_size cgltf_accessor_index(const cgltf_data* data, const cgltf_accessor* object);
cgltf_size cgltf_buffer_view_index(const cgltf_data* data, const cgltf_buffer_view* object);
cgltf_size cgltf_buffer_index(const cgltf_data* data, const cgltf_buffer* object);
cgltf_size cgltf_image_index(const cgltf_data* data, const cgltf_image* object);
cgltf_size cgltf_texture_index(const cgltf_data* data, const cgltf_texture* object);
cgltf_size cgltf_sampler_index(const cgltf_data* data, const cgltf_sampler* object);
cgltf_size cgltf_skin_index(const cgltf_data* data, const cgltf_skin* object);
cgltf_size cgltf_camera_index(const cgltf_data* data, const cgltf_camera* object);
cgltf_size cgltf_light_index(const cgltf_data* data, const cgltf_light* object);
cgltf_size cgltf_node_index(const cgltf_data* data, const cgltf_node* object);
cgltf_size cgltf_scene_index(const cgltf_data* data, const cgltf_scene* object);
cgltf_size cgltf_animation_index(const cgltf_data* data, const cgltf_animation* object);
cgltf_size cgltf_animation_sampler_index(const cgltf_animation* animation, const cgltf_animation_sampler* object);
cgltf_size cgltf_animation_channel_index(const cgltf_animation* animation, const cgltf_animation_channel* object);
cgltf_result cgltf_write_file(const cgltf_options* options, const char* path, const cgltf_data* data);
cgltf_size cgltf_write(const cgltf_options* options, char* buffer, cgltf_size size, const cgltf_data* data);
]])

return setmetatable({Library = ffi.load("cgltf/cgltf.dll", false), Defines = defines}, {__index = IndexMetamethod})