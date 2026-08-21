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

defines["AI_MATKEY_COLOR_TRANSPARENT"] = "$clr.transparent"
defines["EISDIR"] = 21
defines["AI_CONFIG_GLOB_MEASURE_TIME"] = "GLOB_MEASURE_TIME"
defines["ENFILE"] = 23
defines["AI_CONFIG_IMPORT_NO_SKELETON_MESHES"] = "IMPORT_NO_SKELETON_MESHES"
defines["EMFILE"] = 24
defines["AI_CONFIG_PP_SBBC_MAX_BONES"] = "PP_SBBC_MAX_BONES"
defines["ENOTTY"] = 25
defines["CHAR_MAX"] = 127
defines["AI_SBBC_DEFAULT_MAX_BONES"] = 60
defines["MB_LEN_MAX"] = 5
defines["ENOSPC"] = 28
defines["AI_CONFIG_PP_CT_MAX_SMOOTHING_ANGLE"] = "PP_CT_MAX_SMOOTHING_ANGLE"
defines["SHRT_MIN"] = -32768
defines["ESPIPE"] = 29
defines["SHRT_MAX"] = 32767
defines["EROFS"] = 30
defines["USHRT_MAX"] = 65535
defines["EMLINK"] = 31
defines["INT_MIN"] = -2147483648
defines["EPIPE"] = 32
defines["INT_MAX"] = 2147483647
defines["ENOSYS"] = 40
defines["UINT_MAX"] = 4294967295
defines["ENOTEMPTY"] = 41
defines["AI_CONFIG_IMPORT_COLLADA_USE_COLLADA_NAMES"] = "IMPORT_COLLADA_USE_COLLADA_NAMES"
defines["AI_CONFIG_EXPORT_XFILE_64BIT"] = "EXPORT_XFILE_64BIT"
defines["_FP_LT"] = 1
defines["_FP_EQ"] = 2
defines["ERANGE"] = 34
defines["_FP_GT"] = 4
defines["_ARGMAX"] = 100
defines["EILSEQ"] = 42
defines["AI_CONFIG_USE_GLTF_PBR_SPECULAR_GLOSSINESS"] = "USE_GLTF_PBR_SPECULAR_GLOSSINESS"
defines["STRUNCATE"] = 80
defines["_CRT_INT_MAX"] = 2147483647
defines["EADDRINUSE"] = 100
defines["EADDRNOTAVAIL"] = 101
defines["EAFNOSUPPORT"] = 102
defines["EALREADY"] = 103
defines["AI_MAXLEN"] = 1024
defines["EBADMSG"] = 104
defines["ECANCELED"] = 105
defines["_CRT_FUNCTIONS_REQUIRED"] = 1
defines["_CRT_HAS_CXX17"] = 0
defines["ECONNABORTED"] = 106
defines["_CRT_HAS_C11"] = 1
defines["ECONNRESET"] = 108
defines["_HAS_CXX17"] = 0
defines["EDESTADDRREQ"] = 109
defines["EHOSTUNREACH"] = 110
defines["EIDRM"] = 111
defines["_HAS_CXX23"] = 0
defines["EINPROGRESS"] = 112
defines["_HAS_CXX26"] = 0
defines["EISCONN"] = 113
defines["ELOOP"] = 114
defines["EMSGSIZE"] = 115
defines["ENETDOWN"] = 116
defines["_CRT_INTERNAL_NONSTDC_NAMES"] = 1
defines["AI_SCENE_FLAGS_ALLOW_SHARED"] = 32
defines["_AI_MATKEY_UVTRANSFORM_BASE"] = "$tex.uvtrafo"
defines["ENETRESET"] = 117
defines["AI_SCENE_FLAGS_VALIDATION_WARNING"] = 4
defines["AI_SCENE_FLAGS_VALIDATED"] = 2
defines["AI_SCENE_FLAGS_INCOMPLETE"] = 1
defines["AI_CONFIG_EXPORT_GLTF_UNLIMITED_SKINNING_BONES_PER_VERTEX"] = "USE_UNLIMITED_BONES_PER VERTEX"
defines["AI_MATKEY_SPECULAR_FACTOR"] = "$mat.specularFactor"
defines["WINT_MIN"] = 0
defines["ENOBUFS"] = 119
defines["AI_CONFIG_EXPORT_FBX_TRANSPARENCY_FACTOR_REFER_TO_OPACITY"] = "EXPORT_FBX_TRANSPARENCY_FACTOR_REFER_TO_OPACITY"
defines["ENODATA"] = 120
defines["AI_CONFIG_EXPORT_BLOB_NAME"] = "EXPORT_BLOB_NAME"
defines["ENOLINK"] = 121
defines["AI_CONFIG_GLOBAL_SCALE_FACTOR_KEY"] = "GLOBAL_SCALE_FACTOR"
defines["ENOMSG"] = 122
defines["AI_EMBEDDED_TEXNAME_PREFIX"] = "*"
defines["_AI_MATKEY_MAPPINGMODE_V_BASE"] = "$tex.mapmodev"
defines["ENOPROTOOPT"] = 123
defines["__STDC_WANT_SECURE_LIB__"] = 1
defines["AI_MATKEY_GLTF_PBRMETALLICROUGHNESS_METALLIC_FACTOR"] = "$mat.metallicFactor"
defines["ENOSR"] = 124
defines["_AI_MATKEY_GLTF_MAPPINGID_BASE"] = "$tex.mappingid"
defines["AI_MATKEY_GLTF_PBRMETALLICROUGHNESS_ROUGHNESS_FACTOR"] = "$mat.roughnessFactor"
defines["_AI_MATKEY_GLTF_MAPPINGFILTER_MIN_BASE"] = "$tex.mappingfiltermin"
defines["ENOSTR"] = 125
defines["AI_MATKEY_GLTF_PBRSPECULARGLOSSINESS"] = "$mat.glossinessFactor"
defines["_SECURECRT_FILL_BUFFER_PATTERN"] = 254
defines["AI_MAX_NUMBER_OF_COLOR_SETS"] = 8
defines["AI_MATKEY_GLTF_PBRSPECULARGLOSSINESS_GLOSSINESS_FACTOR"] = "$mat.glossinessFactor"
defines["ENOTRECOVERABLE"] = 127
defines["AI_MAX_FACE_INDICES"] = 32767
defines["_ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE"] = 1
defines["AI_MATKEY_GLTF_UNLIT"] = "$mat.gltf.unlit"
defines["_CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES"] = 0
defines["_CRT_BUILD_DESKTOP_APP"] = 1
defines["AI_MATKEY_GLTF_MATERIAL_SHEEN_ROUGHNESS_FACTOR"] = "$mat.sheen.roughnessFactor"
defines["_CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES_COUNT"] = 0
defines["ENOTSUP"] = 129
defines["AI_CONFIG_IMPORT_SMD_KEYFRAME"] = "IMPORT_SMD_KEYFRAME"
defines["_CRT_SECURE_CPP_OVERLOAD_SECURE_NAMES"] = 1
defines["AI_MATKEY_GLTF_MATERIAL_SHEEN_COLOR_FACTOR"] = "$clr.sheen.factor"
defines["EOPNOTSUPP"] = 130
defines["AI_CONFIG_IMPORT_UNREAL_KEYFRAME"] = "IMPORT_UNREAL_KEYFRAME"
defines["EOTHER"] = 131
defines["_CRT_SECURE_CPP_OVERLOAD_SECURE_NAMES_MEMORY"] = 0
defines["AI_CONFIG_IMPORT_MDL_HL1_READ_ANIMATIONS"] = "IMPORT_MDL_HL1_READ_ANIMATIONS"
defines["EOVERFLOW"] = 132
defines["_AI_MATKEY_GLTF_STRENGTH_BASE"] = "$tex.strength"
defines["AI_MATKEY_GLTF_MATERIAL_CLEARCOAT_FACTOR"] = "$mat.clearcoat.factor"
defines["AI_CONFIG_IMPORT_MDL_HL1_READ_ANIMATION_EVENTS"] = "IMPORT_MDL_HL1_READ_ANIMATION_EVENTS"
defines["AI_MATKEY_GLTF_MATERIAL_CLEARCOAT_ROUGHNESS_FACTOR"] = "$mat.clearcoat.roughnessFactor"
defines["EPROTO"] = 134
defines["AI_CONFIG_IMPORT_MDL_HL1_TRANSFORM_COORD_SYSTEM"] = "TRANSFORM COORDSYSTEM FOR HS! MODELS"
defines["AI_MAX_NUMBER_OF_TEXTURECOORDS"] = 8
defines["EPROTONOSUPPORT"] = 135
defines["AI_MAX_FACES"] = 2147483647
defines["AI_CONFIG_IMPORT_MDL_HL1_READ_BLEND_CONTROLLERS"] = "IMPORT_MDL_HL1_READ_BLEND_CONTROLLERS"
defines["AI_MAX_BONE_WEIGHTS"] = 2147483647
defines["EPROTOTYPE"] = 136
defines["ENOLCK"] = 39
defines["AI_CONFIG_IMPORT_MDL_HL1_READ_SEQUENCE_TRANSITIONS"] = "IMPORT_MDL_HL1_READ_SEQUENCE_TRANSITIONS"
defines["ETIME"] = 137
defines["AI_MATKEY_GLTF_PBRMETALLICROUGHNESS_BASE_COLOR_FACTOR"] = "$clr.base"
defines["_AI_MATKEY_GLTF_SCALE_BASE"] = "$tex.scale"
defines["AI_CONFIG_IMPORT_MDL_HL1_READ_ATTACHMENTS"] = "IMPORT_MDL_HL1_READ_ATTACHMENTS"
defines["_VCRT_COMPILER_PREPROCESSOR"] = 1
defines["AI_MATKEY_GLTF_MATERIAL_TRANSMISSION_FACTOR"] = "$mat.transmission.factor"
defines["_AI_MATKEY_GLTF_MAPPINGFILTER_MAG_BASE"] = "$tex.mappingfiltermag"
defines["ETXTBSY"] = 139
defines["AI_CONFIG_IMPORT_MDL_HL1_READ_BONE_CONTROLLERS"] = "IMPORT_MDL_HL1_READ_BONE_CONTROLLERS"
defines["_AI_MATKEY_GLTF_MAPPINGNAME_BASE"] = "$tex.mappingname"
defines["_CRT_PACKING"] = 8
defines["AI_MATKEY_GLTF_ALPHACUTOFF"] = "$mat.gltf.alphaCutoff"
defines["AI_CONFIG_IMPORT_MDL_HL1_READ_HITBOXES"] = "IMPORT_MDL_HL1_READ_HITBOXES"
defines["AI_MATKEY_GLTF_ALPHAMODE"] = "$mat.gltf.alphaMode"
defines["AI_SCENE_FLAGS_NON_VERBOSE_FORMAT"] = 8
defines["_AI_MATKEY_TEXFLAGS_BASE"] = "$tex.flags"
defines["AI_TRUE"] = 1
defines["AI_CONFIG_IMPORT_MDL_HL1_READ_MISC_GLOBAL_INFO"] = "IMPORT_MDL_HL1_READ_MISC_GLOBAL_INFO"
defines["AI_SCENE_FLAGS_TERRAIN"] = 16
defines["_AI_MATKEY_TEXMAP_AXIS_BASE"] = "$tex.mapaxis"
defines["_AI_MATKEY_MAPPINGMODE_U_BASE"] = "$tex.mapmodeu"
defines["AI_CONFIG_IMPORT_SMD_LOAD_ANIMATION_LIST"] = "IMPORT_SMD_LOAD_ANIMATION_LIST"
defines["_AI_MATKEY_TEXBLEND_BASE"] = "$tex.blend"
defines["_SAL_VERSION"] = 20
defines["_AI_MATKEY_MAPPING_BASE"] = "$tex.mapping"
defines["_AI_MATKEY_TEXOP_BASE"] = "$tex.op"
defines["AI_CONFIG_IMPORT_AC_SEPARATE_BFCULL"] = "IMPORT_AC_SEPARATE_BFCULL"
defines["_AI_MATKEY_UVWSRC_BASE"] = "$tex.uvwsrc"
defines["__SAL_H_VERSION"] = 180000000
defines["_AI_MATKEY_TEXTURE_BASE"] = "$tex.file"
defines["AI_CONFIG_IMPORT_AC_EVAL_SUBDIVISION"] = "IMPORT_AC_EVAL_SUBDIVISION"
defines["AI_MATKEY_USE_AO_MAP"] = "$mat.useAOMap"
defines["_USE_DECLSPECS_FOR_SAL"] = 0
defines["AI_MATKEY_EMISSIVE_INTENSITY"] = "$mat.emissiveIntensity"
defines["AI_MATKEY_USE_EMISSIVE_MAP"] = "$mat.useEmissiveMap"
defines["AI_CONFIG_IMPORT_UNREAL_HANDLE_FLAGS"] = "UNREAL_HANDLE_FLAGS"
defines["AI_CONFIG_PP_RVC_FLAGS"] = "PP_RVC_FLAGS"
defines["_USE_ATTRIBUTES_FOR_SAL"] = 0
defines["AI_CONFIG_PP_SLM_VERTEX_LIMIT"] = "PP_SLM_VERTEX_LIMIT"
defines["AI_CONFIG_IMPORT_FBX_OPTIMIZE_EMPTY_ANIMATION_CURVES"] = "IMPORT_FBX_OPTIMIZE_EMPTY_ANIMATION_CURVES"
defines["AI_CONFIG_IMPORT_TER_MAKE_UVS"] = "IMPORT_TER_MAKE_UVS"
defines["AI_MATKEY_VOLUME_THICKNESS_FACTOR"] = "$mat.volume.thicknessFactor"
defines["AI_SLM_DEFAULT_MAX_VERTICES"] = 1000000
defines["AI_CONFIG_IMPORT_ASE_RECONSTRUCT_NORMALS"] = "IMPORT_ASE_RECONSTRUCT_NORMALS"
defines["AI_CONFIG_PP_LBW_MAX_WEIGHTS"] = "PP_LBW_MAX_WEIGHTS"
defines["AI_MATKEY_TRANSMISSION_FACTOR"] = "$mat.transmission.factor"
defines["AI_CONFIG_IMPORT_COLLADA_IGNORE_UNIT_SIZE"] = "IMPORT_COLLADA_IGNORE_UNIT_SIZE"
defines["_NLSCMPERROR"] = 2147483647
defines["AI_CONFIG_IMPORT_MD3_HANDLE_MULTIPART"] = "IMPORT_MD3_HANDLE_MULTIPART"
defines["AI_LMW_MAX_WEIGHTS"] = 4
defines["EDOM"] = 33
defines["EACCES"] = 13
defines["AI_MATKEY_CLEARCOAT_ROUGHNESS_FACTOR"] = "$mat.clearcoat.roughnessFactor"
defines["AI_CONFIG_IMPORT_MD3_SKIN_NAME"] = "IMPORT_MD3_SKIN_NAME"
defines["AI_CONFIG_PP_DB_THRESHOLD"] = "PP_DB_THRESHOLD"
defines["AI_CONFIG_PP_GSN_MAX_SMOOTHING_ANGLE"] = "PP_GSN_MAX_SMOOTHING_ANGLE"
defines["AI_CONFIG_FAVOUR_SPEED"] = "FAVOUR_SPEED"
defines["_STATIC_INLINE_UCRT_FUNCTIONS"] = 0
defines["AI_MATKEY_SHEEN_ROUGHNESS_FACTOR"] = "$mat.sheen.roughnessFactor"
defines["AI_MATKEY_SHEEN_COLOR_FACTOR"] = "$clr.sheen.factor"
defines["AI_MATKEY_GLOSSINESS_FACTOR"] = "$mat.glossinessFactor"
defines["HINTMAXTEXTURELEN"] = 9
defines["AI_CONFIG_IMPORT_MD3_SHADER_SRC"] = "IMPORT_MD3_SHADER_SRC"
defines["ENOTCONN"] = 126
defines["AI_CONFIG_PP_DB_ALL_OR_NONE"] = "PP_DB_ALL_OR_NONE"
defines["AI_MATKEY_ROUGHNESS_FACTOR"] = "$mat.roughnessFactor"
defines["AI_CONFIG_IMPORT_LWO_ONE_LAYER_ONLY"] = "IMPORT_LWO_ONE_LAYER_ONLY"
defines["AI_MATKEY_USE_ROUGHNESS_MAP"] = "$mat.useRoughnessMap"
defines["AI_MATKEY_METALLIC_FACTOR"] = "$mat.metallicFactor"
defines["PP_ICL_PTCACHE_SIZE"] = 12
defines["AI_MATKEY_COLOR_REFLECTIVE"] = "$clr.reflective"
defines["AI_CONFIG_IMPORT_MD5_NO_ANIM_AUTOLOAD"] = "IMPORT_MD5_NO_ANIM_AUTOLOAD"
defines["AI_MATKEY_USE_METALLIC_MAP"] = "$mat.useMetallicMap"
defines["AI_CONFIG_PP_ICL_PTCACHE_SIZE"] = "PP_ICL_PTCACHE_SIZE"
defines["AI_MATKEY_GLOBAL_BACKGROUND_IMAGE"] = "?bg.global"
defines["AI_CONFIG_IMPORT_LWS_ANIM_START"] = "IMPORT_LWS_ANIM_START"
defines["_HAS_CXX20"] = 0
defines["AI_MATKEY_USE_COLOR_MAP"] = "$mat.useColorMap"
defines["AI_MATKEY_SHADER_COMPUTE"] = "?sh.cs"
defines["AI_MATKEY_GLOBAL_SHADERLANG"] = "?sh.lang"
defines["AI_CONFIG_IMPORT_LWS_ANIM_END"] = "IMPORT_LWS_ANIM_END"
defines["AI_MATKEY_SHADER_PRIMITIVE"] = "?sh.ps"
defines["AI_MATKEY_BUMPSCALING"] = "$mat.bumpscaling"
defines["AI_MATKEY_REFRACTI"] = "$mat.refracti"
defines["AI_MATKEY_SHADER_VERTEX"] = "?sh.vs"
defines["AI_CONFIG_IMPORT_IRR_ANIM_FPS"] = "IMPORT_IRR_ANIM_FPS"
defines["AI_MATKEY_COLOR_SPECULAR"] = "$clr.specular"
defines["_HAS_EXCEPTIONS"] = 1
defines["AI_MATKEY_COLOR_EMISSIVE"] = "$clr.emissive"
defines["AI_MATKEY_SHADER_FRAGMENT"] = "?sh.fs"
defines["AI_CONFIG_IMPORT_OGRE_MATERIAL_FILE"] = "IMPORT_OGRE_MATERIAL_FILE"
defines["AI_MATKEY_COLOR_AMBIENT"] = "$clr.ambient"
defines["AI_MATKEY_COLOR_DIFFUSE"] = "$clr.diffuse"
defines["AI_MATKEY_SHADER_GEO"] = "?sh.gs"
defines["AI_CONFIG_IMPORT_OGRE_TEXTURETYPE_FROM_FILENAME"] = "IMPORT_OGRE_TEXTURETYPE_FROM_FILENAME"
defines["AI_MATKEY_SHININESS_STRENGTH"] = "$mat.shinpercent"
defines["EIO"] = 5
defines["WCHAR_MIN"] = 0
defines["AI_MATKEY_SHADER_TESSELATION"] = "?sh.ts"
defines["AI_CONFIG_ANDROID_JNI_ASSIMP_MANAGER_SUPPORT"] = "AI_CONFIG_ANDROID_JNI_ASSIMP_MANAGER_SUPPORT"
defines["AI_MATKEY_TRANSPARENCYFACTOR"] = "$mat.transparencyfactor"
defines["AI_MATKEY_OPACITY"] = "$mat.opacity"
defines["AI_CONFIG_IMPORT_IFC_SKIP_SPACE_REPRESENTATIONS"] = "IMPORT_IFC_SKIP_SPACE_REPRESENTATIONS"
defines["AI_MATKEY_BLEND_FUNC"] = "$mat.blend"
defines["AI_MATKEY_ENABLE_WIREFRAME"] = "$mat.wireframe"
defines["AI_MATKEY_SHADING_MODEL"] = "$mat.shadingm"
defines["AI_CONFIG_IMPORT_IFC_CUSTOM_TRIANGULATION"] = "IMPORT_IFC_CUSTOM_TRIANGULATION"
defines["AI_MATKEY_TWOSIDED"] = "$mat.twosided"
defines["AI_MATKEY_NAME"] = "?mat.name"
defines["AI_DEFAULT_MATERIAL_NAME"] = "DefaultMaterial"
defines["AI_CONFIG_IMPORT_IFC_SMOOTHING_ANGLE"] = "IMPORT_IFC_SMOOTHING_ANGLE"
defines["AI_FALSE"] = 0
defines["AI_CONFIG_PP_PTV_KEEP_HIERARCHY"] = "PP_PTV_KEEP_HIERARCHY"
defines["AI_MATKEY_BASE_COLOR"] = "$clr.base"
defines["_DENORM"] = -2
defines["ENAMETOOLONG"] = 38
defines["_FINITE"] = -1
defines["AI_CONFIG_IMPORT_IFC_CYLINDRICAL_TESSELLATION"] = "IMPORT_IFC_CYLINDRICAL_TESSELLATION"
defines["ASSIMP_AI_REAL_TEXT_PRECISION"] = 9
defines["_INFCODE"] = 1
defines["_NANCODE"] = 2
defines["AI_IMPORT_IFC_DEFAULT_CYLINDRICAL_TESSELLATION"] = 32
defines["AI_CONFIG_PP_SBP_REMOVE"] = "PP_SBP_REMOVE"
defines["AI_MATH_PI"] = 3.1415926535898
defines["FP_NAN"] = 2
defines["AI_MATH_TWO_PI"] = 6.2831853071796
defines["AI_MAX_VERTICES"] = 2147483647
defines["FP_NORMAL"] = -1
defines["AI_MATH_HALF_PI"] = 1.5707963267949
defines["AI_CONFIG_PP_FID_IGNORE_TEXTURECOORDS"] = "PP_FID_IGNORE_TEXTURECOORDS"
defines["FP_SUBNORMAL"] = -2
defines["EWOULDBLOCK"] = 140
defines["ETIMEDOUT"] = 138
defines["AI_UVTRAFO_SCALING"] = 1
defines["FP_ZERO"] = 0
defines["AI_CONFIG_PP_CT_TEXTURE_CHANNEL_INDEX"] = "PP_CT_TEXTURE_CHANNEL_INDEX"
defines["EOWNERDEAD"] = 133
defines["AI_UVTRAFO_ROTATION"] = 2
defines["_C2"] = 1
defines["ENOTSOCK"] = 128
defines["FP_ILOGB0"] = -2147483648
defines["AI_UVTRAFO_TRANSLATION"] = 4
defines["AI_MATKEY_ANISOTROPY_FACTOR"] = "$mat.anisotropyFactor"
defines["AI_UVTRAFO_ALL"] = 7
defines["FP_ILOGBNAN"] = 2147483647
defines["ENETUNREACH"] = 118
defines["EDEADLK"] = 36
defines["AI_CONFIG_PP_TUV_EVALUATE"] = "PP_TUV_EVALUATE"
defines["AI_CONFIG_IMPORT_MDL_COLORMAP"] = "IMPORT_MDL_COLORMAP"
defines["_SING"] = 2
defines["AI_CONFIG_EXPORT_POINT_CLOUDS"] = "EXPORT_POINT_CLOUDS"
defines["math_errhandling"] = 3
defines["AI_CONFIG_PP_RRM_EXCLUDE_LIST"] = "PP_RRM_EXCLUDE_LIST"
defines["_OVERFLOW"] = 3
defines["AI_CONFIG_APP_SCALE_KEY"] = "APP_SCALE_FACTOR"
defines["_FE_DIVBYZERO"] = 4
defines["AI_CONFIG_IMPORT_SCHEMA_DOCUMENT_PROVIDER"] = "IMPORT_SCHEMA_DOCUMENT_PROVIDER"
defines["_UNDERFLOW"] = 4
defines["_FE_INEXACT"] = 32
defines["ECONNREFUSED"] = 107
defines["_TLOSS"] = 5
defines["AI_CONFIG_PP_PTV_NORMALIZE"] = "PP_PTV_NORMALIZE"
defines["_FE_INVALID"] = 1
defines["AI_CONFIG_IMPORT_COLLADA_IGNORE_UP_DIRECTION"] = "IMPORT_COLLADA_IGNORE_UP_DIRECTION"
defines["_PLOSS"] = 6
defines["AI_CONFIG_IMPORT_FBX_READ_ALL_MATERIALS"] = "IMPORT_FBX_READ_ALL_MATERIALS"
defines["_FE_OVERFLOW"] = 8
defines["_CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES_MEMORY"] = 0
defines["_FE_UNDERFLOW"] = 16
defines["AI_CONFIG_PP_PTV_ROOT_TRANSFORMATION"] = "PP_PTV_ROOT_TRANSFORMATION"
defines["AI_MATKEY_CLEARCOAT_FACTOR"] = "$mat.clearcoat.factor"
defines["_D0_C"] = 3
defines["AI_CONFIG_IMPORT_FBX_READ_TEXTURES"] = "IMPORT_FBX_READ_TEXTURES"
defines["AI_CONFIG_CHECK_IDENTITY_MATRIX_EPSILON"] = "CHECK_IDENTITY_MATRIX_EPSILON"
defines["_HUGE_ENUF"] = 1e+300
defines["_D2_C"] = 1
defines["AI_CONFIG_IMPORT_FBX_READ_MATERIALS"] = "IMPORT_FBX_READ_MATERIALS"
defines["AI_CONFIG_IMPORT_FBX_READ_CAMERAS"] = "IMPORT_FBX_READ_CAMERAS"
defines["_D1_C"] = 2
defines["_DBIAS"] = 1022
defines["CHAR_BIT"] = 8
defines["AI_CONFIG_IMPORT_FBX_READ_LIGHTS"] = "IMPORT_FBX_READ_LIGHTS"
defines["_DOFF"] = 4
defines["_F0_C"] = 1
defines["DOMAIN"] = 1
defines["AI_CONFIG_IMPORT_FBX_READ_ANIMATIONS"] = "IMPORT_FBX_READ_ANIMATIONS"
defines["AI_MATKEY_ANISOTROPY_ROTATION"] = "$mat.anisotropyRotation"
defines["_FBIAS"] = 126
defines["SING"] = 2
defines["AI_CONFIG_PP_FD_CHECKAREA"] = "PP_FD_CHECKAREA"
defines["AI_CONFIG_IMPORT_FBX_READ_WEIGHTS"] = "IMPORT_FBX_READ_WEIGHTS"
defines["_FOFF"] = 7
defines["OVERFLOW"] = 3
defines["FP_INFINITE"] = 1
defines["AI_CONFIG_PP_OG_EXCLUDE_LIST"] = "PP_OG_EXCLUDE_LIST"
defines["AI_CONFIG_IMPORT_FBX_STRICT_MODE"] = "IMPORT_FBX_STRICT_MODE"
defines["UNDERFLOW"] = 4
defines["_L0_C"] = 3
defines["_F1_C"] = 0
defines["_L1_C"] = 2
defines["AI_CONFIG_IMPORT_FBX_PRESERVE_PIVOTS"] = "IMPORT_FBX_PRESERVE_PIVOTS"
defines["_L2_C"] = 1
defines["SCHAR_MAX"] = 127
defines["_L3_C"] = 0
defines["AI_SLM_DEFAULT_MAX_TRIANGLES"] = 1000000
defines["_LBIAS"] = 1022
defines["_DOMAIN"] = 1
defines["_LOFF"] = 4
defines["AI_MATKEY_VOLUME_ATTENUATION_DISTANCE"] = "$mat.volume.attenuationDistance"
defines["TLOSS"] = 5
defines["AI_CONFIG_IMPORT_FBX_EMBEDDED_TEXTURES_LEGACY_NAMING"] = "AI_CONFIG_IMPORT_FBX_EMBEDDED_TEXTURES_LEGACY_NAMING"
defines["E2BIG"] = 7
defines["CHAR_MIN"] = -128
defines["AI_MATKEY_VOLUME_ATTENUATION_COLOR"] = "$mat.volume.attenuationColor"
defines["AI_CONFIG_IMPORT_REMOVE_EMPTY_BONES"] = "AI_CONFIG_IMPORT_REMOVE_EMPTY_BONES"
defines["ENOEXEC"] = 8
defines["ENXIO"] = 6
defines["MATH_ERREXCEPT"] = 2
defines["AI_CONFIG_FBX_CONVERT_TO_M"] = "AI_CONFIG_FBX_CONVERT_TO_M"
defines["EBADF"] = 9
defines["AI_MATKEY_SHININESS"] = "$mat.shininess"
defines["WCHAR_MAX"] = 65535
defines["AI_CONFIG_IMPORT_FBX_IGNORE_UP_DIRECTION"] = "AI_CONFIG_IMPORT_FBX_IGNORE_UP_DIRECTION"
defines["ECHILD"] = 10
defines["PLOSS"] = 6
defines["AI_MATKEY_REFLECTIVITY"] = "$mat.reflectivity"
defines["AI_CONFIG_FBX_USE_SKELETON_BONE_CONTAINER"] = "AI_CONFIG_FBX_USE_SKELETON_BONE_CONTAINER"
defines["EAGAIN"] = 11
defines["AI_CONFIG_PP_SLM_TRIANGLE_LIMIT"] = "PP_SLM_TRIANGLE_LIMIT"
defines["_FRND"] = 1
defines["AI_CONFIG_IMPORT_GLOBAL_KEYFRAME"] = "IMPORT_GLOBAL_KEYFRAME"
defines["ENOMEM"] = 12
defines["AI_CONFIG_PP_FD_REMOVE"] = "PP_FD_REMOVE"
defines["SCHAR_MIN"] = -128
defines["WINT_MAX"] = 65535
defines["AI_CONFIG_IMPORT_MD3_KEYFRAME"] = "IMPORT_MD3_KEYFRAME"
defines["_D3_C"] = 0
defines["UCHAR_MAX"] = 255
defines["EFAULT"] = 14
defines["AI_CONFIG_IMPORT_MD2_KEYFRAME"] = "IMPORT_MD2_KEYFRAME"
defines["AI_CONFIG_IMPORT_FBX_READ_ALL_GEOMETRY_LAYERS"] = "IMPORT_FBX_READ_ALL_GEOMETRY_LAYERS"
defines["AI_CONFIG_PP_PTV_ADD_ROOT_TRANSFORMATION"] = "PP_PTV_ADD_ROOT_TRANSFORMATION"
defines["EBUSY"] = 16
defines["EPERM"] = 1
defines["AI_CONFIG_IMPORT_MDL_KEYFRAME"] = "IMPORT_MDL_KEYFRAME"
defines["MATH_ERRNO"] = 1
defines["EEXIST"] = 17
defines["ENOENT"] = 2
defines["AI_CONFIG_PP_FID_ANIM_ACCURACY"] = "PP_FID_ANIM_ACCURACY"
defines["AI_CONFIG_IMPORT_MDC_KEYFRAME"] = "IMPORT_MDC_KEYFRAME"
defines["EXDEV"] = 18
defines["ESRCH"] = 3
defines["AI_CONFIG_IMPORT_MD3_LOAD_SHADERS"] = "IMPORT_MD3_LOAD_SHADERS"
defines["EDEADLOCK"] = 36
defines["ENODEV"] = 19
defines["EINTR"] = 4
defines["EINVAL"] = 22
defines["EFBIG"] = 27
defines["ENOTDIR"] = 20

ffi.cdef([[
        typedef unsigned __int64  uintptr_t;
        typedef char* va_list;
    void __cdecl __va_start(va_list* , ...);
    typedef unsigned __int64 size_t;
    typedef __int64          ptrdiff_t;
    typedef __int64          intptr_t;
    typedef _Bool __vcrt_bool;
    typedef unsigned short wchar_t;
    void __cdecl __security_init_cookie(void);
        void __cdecl __security_check_cookie(  uintptr_t _StackCookie);
        __declspec(noreturn) void __cdecl __report_gsfailure(  uintptr_t _StackCookie);
extern uintptr_t __security_cookie;
    typedef _Bool __crt_bool;
 void __cdecl _invalid_parameter_noinfo(void);
 __declspec(noreturn) void __cdecl _invalid_parameter_noinfo_noreturn(void);
__declspec(noreturn)
 void __cdecl _invoke_watson(
      wchar_t const* _Expression,
      wchar_t const* _FunctionName,
      wchar_t const* _FileName,
            unsigned int _LineNo,
            uintptr_t _Reserved);
typedef int                           errno_t;
typedef unsigned short                wint_t;
typedef unsigned short                wctype_t;
typedef long                          __time32_t;
typedef __int64                       __time64_t;
typedef struct __crt_locale_data_public
{
      unsigned short const* _locale_pctype;
      int _locale_mb_cur_max;
               unsigned int _locale_lc_codepage;
} __crt_locale_data_public;
typedef struct __crt_locale_pointers
{
    struct __crt_locale_data*    locinfo;
    struct __crt_multibyte_data* mbcinfo;
} __crt_locale_pointers;
typedef __crt_locale_pointers* _locale_t;
typedef struct _Mbstatet
{ 
    unsigned long _Wchar;
    unsigned short _Byte, _State;
} _Mbstatet;
typedef _Mbstatet mbstate_t;
        typedef __time64_t time_t;
    typedef size_t rsize_t;
    struct _exception
    {
        int    type;   
        char*  name;   
        double arg1;   
        double arg2;   
        double retval; 
    };
        struct _complex
        {
            double x, y; 
        };
    typedef float  float_t;
    typedef double double_t;
        extern double const _HUGE;
void __cdecl _fperrraise(  int _Except);
   short __cdecl _dclass(  double _X);
   short __cdecl _ldclass(  long double _X);
   short __cdecl _fdclass(  float _X);
   int __cdecl _dsign(  double _X);
   int __cdecl _ldsign(  long double _X);
   int __cdecl _fdsign(  float _X);
   int __cdecl _dpcomp(  double _X,   double _Y);
   int __cdecl _ldpcomp(  long double _X,   long double _Y);
   int __cdecl _fdpcomp(  float _X,   float _Y);
   short __cdecl _dtest(  double* _Px);
   short __cdecl _ldtest(  long double* _Px);
   short __cdecl _fdtest(  float* _Px);
 short __cdecl _d_int(  double* _Px,   short _Xexp);
 short __cdecl _ld_int(  long double* _Px,   short _Xexp);
 short __cdecl _fd_int(  float* _Px,   short _Xexp);
 short __cdecl _dscale(  double* _Px,   long _Lexp);
 short __cdecl _ldscale(  long double* _Px,   long _Lexp);
 short __cdecl _fdscale(  float* _Px,   long _Lexp);
 short __cdecl _dunscale(  short* _Pex,   double* _Px);
 short __cdecl _ldunscale(  short* _Pex,   long double* _Px);
 short __cdecl _fdunscale(  short* _Pex,   float* _Px);
   short __cdecl _dexp(  double* _Px,   double _Y,   long _Eoff);
   short __cdecl _ldexp(  long double* _Px,   long double _Y,   long _Eoff);
   short __cdecl _fdexp(  float* _Px,   float _Y,   long _Eoff);
   short __cdecl _dnorm(  unsigned short* _Ps);
   short __cdecl _fdnorm(  unsigned short* _Ps);
   double __cdecl _dpoly(  double _X,   double const* _Tab,   int _N);
   long double __cdecl _ldpoly(  long double _X,   long double const* _Tab,   int _N);
   float __cdecl _fdpoly(  float _X,   float const* _Tab,   int _N);
   double __cdecl _dlog(  double _X,   int _Baseflag);
   long double __cdecl _ldlog(  long double _X,   int _Baseflag);
   float __cdecl _fdlog(  float _X,   int _Baseflag);
   double __cdecl _dsin(  double _X,   unsigned int _Qoff);
   long double __cdecl _ldsin(  long double _X,   unsigned int _Qoff);
   float __cdecl _fdsin(  float _X,   unsigned int _Qoff);
typedef union
{   
    unsigned short _Sh[4];
    double _Val;
} _double_val;
typedef union
{   
    unsigned short _Sh[2];
    float _Val;
} _float_val;
typedef union
{   
    unsigned short _Sh[4];
    long double _Val;
} _ldouble_val;
typedef union
{   
    unsigned short _Word[4];
    float _Float;
    double _Double;
    long double _Long_double;
} _float_const;
extern const _float_const _Denorm_C,  _Inf_C,  _Nan_C,  _Snan_C, _Hugeval_C;
extern const _float_const _FDenorm_C, _FInf_C, _FNan_C, _FSnan_C;
extern const _float_const _LDenorm_C, _LInf_C, _LNan_C, _LSnan_C;
extern const _float_const _Eps_C,  _Rteps_C;
extern const _float_const _FEps_C, _FRteps_C;
extern const _float_const _LEps_C, _LRteps_C;
extern const double      _Zero_C,  _Xbig_C;
extern const float       _FZero_C, _FXbig_C;
extern const long double _LZero_C, _LXbig_C;
      int       __cdecl abs(  int _X);
      long      __cdecl labs(  long _X);
      long long __cdecl llabs(  long long _X);
      double __cdecl acos(  double _X);
      double __cdecl asin(  double _X);
      double __cdecl atan(  double _X);
      double __cdecl atan2(  double _Y,   double _X);
      double __cdecl cos(  double _X);
      double __cdecl cosh(  double _X);
      double __cdecl exp(  double _X);
       double __cdecl fabs(  double _X);
      double __cdecl fmod(  double _X,   double _Y);
      double __cdecl log(  double _X);
      double __cdecl log10(  double _X);
      double __cdecl pow(  double _X,   double _Y);
      double __cdecl sin(  double _X);
      double __cdecl sinh(  double _X);
       double __cdecl sqrt(  double _X);
      double __cdecl tan(  double _X);
      double __cdecl tanh(  double _X);
       double    __cdecl acosh(  double _X);
       double    __cdecl asinh(  double _X);
       double    __cdecl atanh(  double _X);
        double    __cdecl atof(  char const* _String);
        double    __cdecl _atof_l(  char const* _String,   _locale_t _Locale);
       double    __cdecl _cabs(  struct _complex _Complex_value);
       double    __cdecl cbrt(  double _X);
       double    __cdecl ceil(  double _X);
       double    __cdecl _chgsign(  double _X);
       double    __cdecl copysign(  double _Number,   double _Sign);
       double    __cdecl _copysign(  double _Number,   double _Sign);
       double    __cdecl erf(  double _X);
       double    __cdecl erfc(  double _X);
       double    __cdecl exp2(  double _X);
       double    __cdecl expm1(  double _X);
       double    __cdecl fdim(  double _X,   double _Y);
       double    __cdecl floor(  double _X);
       double    __cdecl fma(  double _X,   double _Y,   double _Z);
       double    __cdecl fmax(  double _X,   double _Y);
       double    __cdecl fmin(  double _X,   double _Y);
       double    __cdecl frexp(  double _X,   int* _Y);
       double    __cdecl hypot(  double _X,   double _Y);
       double    __cdecl _hypot(  double _X,   double _Y);
       int       __cdecl ilogb(  double _X);
       double    __cdecl ldexp(  double _X,   int _Y);
       double    __cdecl lgamma(  double _X);
       long long __cdecl llrint(  double _X);
       long long __cdecl llround(  double _X);
       double    __cdecl log1p(  double _X);
       double    __cdecl log2(  double _X);
       double    __cdecl logb(  double _X);
       long      __cdecl lrint(  double _X);
       long      __cdecl lround(  double _X);
    int __cdecl _matherr(  struct _exception* _Except);
       double __cdecl modf(  double _X,   double* _Y);
       double __cdecl nan(  char const* _X);
       double __cdecl nearbyint(  double _X);
       double __cdecl nextafter(  double _X,   double _Y);
       double __cdecl nexttoward(  double _X,   long double _Y);
       double __cdecl remainder(  double _X,   double _Y);
       double __cdecl remquo(  double _X,   double _Y,   int* _Z);
       double __cdecl rint(  double _X);
       double __cdecl round(  double _X);
       double __cdecl scalbln(  double _X,   long _Y);
       double __cdecl scalbn(  double _X,   int _Y);
       double __cdecl tgamma(  double _X);
       double __cdecl trunc(  double _X);
       double __cdecl _j0(  double _X );
       double __cdecl _j1(  double _X );
       double __cdecl _jn(int _X,   double _Y);
       double __cdecl _y0(  double _X);
       double __cdecl _y1(  double _X);
       double __cdecl _yn(  int _X,   double _Y);
       float     __cdecl acoshf(  float _X);
       float     __cdecl asinhf(  float _X);
       float     __cdecl atanhf(  float _X);
       float     __cdecl cbrtf(  float _X);
       float     __cdecl _chgsignf(  float _X);
       float     __cdecl copysignf(  float _Number,   float _Sign);
       float     __cdecl _copysignf(  float _Number,   float _Sign);
       float     __cdecl erff(  float _X);
       float     __cdecl erfcf(  float _X);
       float     __cdecl expm1f(  float _X);
       float     __cdecl exp2f(  float _X);
       float     __cdecl fdimf(  float _X,   float _Y);
       float     __cdecl fmaf(  float _X,   float _Y,   float _Z);
       float     __cdecl fmaxf(  float _X,   float _Y);
       float     __cdecl fminf(  float _X,   float _Y);
       float     __cdecl _hypotf(  float _X,   float _Y);
       int       __cdecl ilogbf(  float _X);
       float     __cdecl lgammaf(  float _X);
       long long __cdecl llrintf(  float _X);
       long long __cdecl llroundf(  float _X);
       float     __cdecl log1pf(  float _X);
       float     __cdecl log2f(  float _X);
       float     __cdecl logbf(  float _X);
       long      __cdecl lrintf(  float _X);
       long      __cdecl lroundf(  float _X);
       float     __cdecl nanf(  char const* _X);
       float     __cdecl nearbyintf(  float _X);
       float     __cdecl nextafterf(  float _X,   float _Y);
       float     __cdecl nexttowardf(  float _X,   long double _Y);
       float     __cdecl remainderf(  float _X,   float _Y);
       float     __cdecl remquof(  float _X,   float _Y,   int* _Z);
       float     __cdecl rintf(  float _X);
       float     __cdecl roundf(  float _X);
       float     __cdecl scalblnf(  float _X,   long _Y);
       float     __cdecl scalbnf(  float _X,   int _Y);
       float     __cdecl tgammaf(  float _X);
       float     __cdecl truncf(  float _X);
           float __cdecl _logbf(  float _X);
           float __cdecl _nextafterf(  float _X,   float _Y);
           int   __cdecl _finitef(  float _X);
           int   __cdecl _isnanf(  float _X);
           int   __cdecl _fpclassf(  float _X);
           int   __cdecl _set_FMA3_enable(  int _Flag);
           int   __cdecl _get_FMA3_enable(void);
           float __cdecl acosf(  float _X);
           float __cdecl asinf(  float _X);
           float __cdecl atan2f(  float _Y,   float _X);
           float __cdecl atanf(  float _X);
           float __cdecl ceilf(  float _X);
           float __cdecl cosf(  float _X);
           float __cdecl coshf(  float _X);
           float __cdecl expf(  float _X);
          __inline float __cdecl fabsf(  float _X)
        {
            return (float)fabs(_X);
        }
           float __cdecl floorf(  float _X);
           float __cdecl fmodf(  float _X,   float _Y);
      __inline float __cdecl frexpf(  float _X,   int *_Y)
    {
        return (float)frexp(_X, _Y);
    }
      __inline float __cdecl hypotf(  float _X,   float _Y)
    {
        return _hypotf(_X, _Y);
    }
      __inline float __cdecl ldexpf(  float _X,   int _Y)
    {
        return (float)ldexp(_X, _Y);
    }
           float  __cdecl log10f(  float _X);
           float  __cdecl logf(  float _X);
           float  __cdecl modff(  float _X,   float *_Y);
           float  __cdecl powf(  float _X,   float _Y);
           float  __cdecl sinf(  float _X);
           float  __cdecl sinhf(  float _X);
           float  __cdecl sqrtf(  float _X);
           float  __cdecl tanf(  float _X);
           float  __cdecl tanhf(  float _X);
       long double __cdecl acoshl(  long double _X);
      __inline long double __cdecl acosl(  long double _X)
    {
        return acos((double)_X);
    }
       long double __cdecl asinhl(  long double _X);
      __inline long double __cdecl asinl(  long double _X)
    {
        return asin((double)_X);
    }
      __inline long double __cdecl atan2l(  long double _Y,   long double _X)
    {
        return atan2((double)_Y, (double)_X);
    }
       long double __cdecl atanhl(  long double _X);
      __inline long double __cdecl atanl(  long double _X)
    {
        return atan((double)_X);
    }
       long double __cdecl cbrtl(  long double _X);
      __inline long double __cdecl ceill(  long double _X)
    {
        return ceil((double)_X);
    }
      __inline long double __cdecl _chgsignl(  long double _X)
    {
        return _chgsign((double)_X);
    }
       long double __cdecl copysignl(  long double _Number,   long double _Sign);
      __inline long double __cdecl _copysignl(  long double _Number,   long double _Sign)
    {
        return _copysign((double)_Number, (double)_Sign);
    }
      __inline long double __cdecl coshl(  long double _X)
    {
        return cosh((double)_X);
    }
      __inline long double __cdecl cosl(  long double _X)
    {
        return cos((double)_X);
    }
       long double __cdecl erfl(  long double _X);
       long double __cdecl erfcl(  long double _X);
      __inline long double __cdecl expl(  long double _X)
    {
        return exp((double)_X);
    }
       long double __cdecl exp2l(  long double _X);
       long double __cdecl expm1l(  long double _X);
      __inline long double __cdecl fabsl(  long double _X)
    {
        return fabs((double)_X);
    }
       long double __cdecl fdiml(  long double _X,   long double _Y);
      __inline long double __cdecl floorl(  long double _X)
    {
        return floor((double)_X);
    }
       long double __cdecl fmal(  long double _X,   long double _Y,   long double _Z);
       long double __cdecl fmaxl(  long double _X,   long double _Y);
       long double __cdecl fminl(  long double _X,   long double _Y);
      __inline long double __cdecl fmodl(  long double _X,   long double _Y)
    {
        return fmod((double)_X, (double)_Y);
    }
      __inline long double __cdecl frexpl(  long double _X,   int *_Y)
    {
        return frexp((double)_X, _Y);
    }
       int __cdecl ilogbl(  long double _X);
      __inline long double __cdecl _hypotl(  long double _X,   long double _Y)
    {
        return _hypot((double)_X, (double)_Y);
    }
      __inline long double __cdecl hypotl(  long double _X,   long double _Y)
    {
        return _hypot((double)_X, (double)_Y);
    }
      __inline long double __cdecl ldexpl(  long double _X,   int _Y)
    {
        return ldexp((double)_X, _Y);
    }
       long double __cdecl lgammal(  long double _X);
       long long __cdecl llrintl(  long double _X);
       long long __cdecl llroundl(  long double _X);
      __inline long double __cdecl logl(  long double _X)
    {
        return log((double)_X);
    }
      __inline long double __cdecl log10l(  long double _X)
    {
        return log10((double)_X);
    }
       long double __cdecl log1pl(  long double _X);
       long double __cdecl log2l(  long double _X);
       long double __cdecl logbl(  long double _X);
       long __cdecl lrintl(  long double _X);
       long __cdecl lroundl(  long double _X);
      __inline long double __cdecl modfl(  long double _X,   long double* _Y)
    {
        double _F, _I;
        _F = modf((double)_X, &_I);
        *_Y = _I;
        return _F;
    }
       long double __cdecl nanl(  char const* _X);
       long double __cdecl nearbyintl(  long double _X);
       long double __cdecl nextafterl(  long double _X,   long double _Y);
       long double __cdecl nexttowardl(  long double _X,   long double _Y);
      __inline long double __cdecl powl(  long double _X,   long double _Y)
    {
        return pow((double)_X, (double)_Y);
    }
       long double __cdecl remainderl(  long double _X,   long double _Y);
       long double __cdecl remquol(  long double _X,   long double _Y,   int* _Z);
       long double __cdecl rintl(  long double _X);
       long double __cdecl roundl(  long double _X);
       long double __cdecl scalblnl(  long double _X,   long _Y);
       long double __cdecl scalbnl(  long double _X,   int _Y);
      __inline long double __cdecl sinhl(  long double _X)
    {
        return sinh((double)_X);
    }
      __inline long double __cdecl sinl(  long double _X)
    {
        return sin((double)_X);
    }
      __inline long double __cdecl sqrtl(  long double _X)
    {
        return sqrt((double)_X);
    }
      __inline long double __cdecl tanhl(  long double _X)
    {
        return tanh((double)_X);
    }
      __inline long double __cdecl tanl(  long double _X)
    {
        return tan((double)_X);
    }
       long double __cdecl tgammal(  long double _X);
       long double __cdecl truncl(  long double _X);
            extern double HUGE;
        __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_j0" ". See online help for details."))    double __cdecl j0(  double _X);
        __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_j1" ". See online help for details."))    double __cdecl j1(  double _X);
        __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_jn" ". See online help for details."))    double __cdecl jn(  int _X,   double _Y);
        __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_y0" ". See online help for details."))    double __cdecl y0(  double _X);
        __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_y1" ". See online help for details."))    double __cdecl y1(  double _X);
        __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_yn" ". See online help for details."))    double __cdecl yn(  int _X,   double _Y);
enum aiComponent
{
    aiComponent_NORMALS = 0x2u,
    aiComponent_TANGENTS_AND_BITANGENTS = 0x4u,
    aiComponent_COLORS = 0x8,
    aiComponent_TEXCOORDS = 0x10,
    aiComponent_BONEWEIGHTS = 0x20,
    aiComponent_ANIMATIONS = 0x40,
    aiComponent_TEXTURES = 0x80,
    aiComponent_LIGHTS = 0x100,
    aiComponent_CAMERAS = 0x200,
    aiComponent_MESHES = 0x400,
    aiComponent_MATERIALS = 0x800,
    _aiComponent_Force32Bit = 0x9fffffff
};
typedef float ai_real;
typedef signed int ai_int;
typedef unsigned int ai_uint;
struct aiVector3D {
    ai_real x, y, z;
};
struct aiAABB {
    struct aiVector3D mMin;
    struct aiVector3D mMax;
};
     int* __cdecl _errno(void);
     errno_t __cdecl _set_errno(  int _Value);
     errno_t __cdecl _get_errno(  int* _Value);
 extern unsigned long  __cdecl __threadid(void);
 extern uintptr_t __cdecl __threadhandle(void);
typedef signed char        int8_t;
typedef short              int16_t;
typedef int                int32_t;
typedef long long          int64_t;
typedef unsigned char      uint8_t;
typedef unsigned short     uint16_t;
typedef unsigned int       uint32_t;
typedef unsigned long long uint64_t;
typedef signed char        int_least8_t;
typedef short              int_least16_t;
typedef int                int_least32_t;
typedef long long          int_least64_t;
typedef unsigned char      uint_least8_t;
typedef unsigned short     uint_least16_t;
typedef unsigned int       uint_least32_t;
typedef unsigned long long uint_least64_t;
typedef signed char        int_fast8_t;
typedef int                int_fast16_t;
typedef int                int_fast32_t;
typedef long long          int_fast64_t;
typedef unsigned char      uint_fast8_t;
typedef unsigned int       uint_fast16_t;
typedef unsigned int       uint_fast32_t;
typedef unsigned long long uint_fast64_t;
typedef long long          intmax_t;
typedef unsigned long long uintmax_t;
     int* __cdecl _errno(void);
     errno_t __cdecl _set_errno(  int _Value);
     errno_t __cdecl _get_errno(  int* _Value);
     unsigned long* __cdecl __doserrno(void);
     errno_t __cdecl _set_doserrno(  unsigned long _Value);
     errno_t __cdecl _get_doserrno(  unsigned long * _Value);
 void  * __cdecl memchr(
      void const* _Buf,
                                 int         _Val,
                                 size_t      _MaxCount
    );
int __cdecl memcmp(
      void const* _Buf1,
      void const* _Buf2,
                         size_t      _Size
    );
void* __cdecl memcpy(
      void* _Dst,
            void const* _Src,
                               size_t      _Size
    );
 void* __cdecl memmove(
      void*       _Dst,
            void const* _Src,
                                   size_t      _Size
    );
void* __cdecl memset(
      void*  _Dst,
                               int    _Val,
                               size_t _Size
    );
 char  * __cdecl strchr(
      char const* _Str,
        int         _Val
    );
 char  * __cdecl strrchr(
      char const* _Str,
        int         _Ch
    );
 char  * __cdecl strstr(
      char const* _Str,
      char const* _SubStr
    );
 wchar_t  * __cdecl wcschr(
      wchar_t const* _Str,
        wchar_t        _Ch
    );
 wchar_t  * __cdecl wcsrchr(
      wchar_t const* _Str,
        wchar_t        _Ch
    );
 wchar_t  * __cdecl wcsstr(
      wchar_t const* _Str,
      wchar_t const* _SubStr
    );
    static __inline errno_t __cdecl memcpy_s(
          void*       const _Destination,
                                                              rsize_t     const _DestinationSize,
                                 void const* const _Source,
                                                              rsize_t     const _SourceSize
        )
    {
        if (_SourceSize == 0)
        {
            return 0;
        }
        { int _Expr_val=!!(_Destination != ((void *)0)); if (!(_Expr_val)) { (*_errno()) = 22; _invalid_parameter_noinfo(); return 22; } } ;
        if (_Source == ((void *)0) || _DestinationSize < _SourceSize)
        {
            memset(_Destination, 0, _DestinationSize);
            { int _Expr_val=!!(_Source != ((void *)0)); if (!(_Expr_val)) { (*_errno()) = 22; _invalid_parameter_noinfo(); return 22; } } ;
            { int _Expr_val=!!(_DestinationSize >= _SourceSize); if (!(_Expr_val)) { (*_errno()) = 34; _invalid_parameter_noinfo(); return 34; } } ;
            return 22 ;
        }
        memcpy(_Destination, _Source, _SourceSize);
        return 0;
    }
    static __inline errno_t __cdecl memmove_s(
          void*       const _Destination,
                                                              rsize_t     const _DestinationSize,
                                 void const* const _Source,
                                                              rsize_t     const _SourceSize
        )
    {
        if (_SourceSize == 0)
        {
            return 0;
        }
        { int _Expr_val=!!(_Destination != ((void *)0)); if (!(_Expr_val)) { (*_errno()) = 22; _invalid_parameter_noinfo(); return 22; } } ;
        { int _Expr_val=!!(_Source != ((void *)0)); if (!(_Expr_val)) { (*_errno()) = 22; _invalid_parameter_noinfo(); return 22; } } ;
        { int _Expr_val=!!(_DestinationSize >= _SourceSize); if (!(_Expr_val)) { (*_errno()) = 34; _invalid_parameter_noinfo(); return 34; } } ;
        memmove(_Destination, _Source, _SourceSize);
        return 0;
    }
 int __cdecl _memicmp(
      void const* _Buf1,
      void const* _Buf2,
                             size_t      _Size
    );
 int __cdecl _memicmp_l(
      void const* _Buf1,
      void const* _Buf2,
                             size_t      _Size,
                         _locale_t   _Locale
    );
    __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_memccpy" ". See online help for details."))
     void* __cdecl memccpy(
          void*       _Dst,
            void const* _Src,
                                   int         _Val,
                                   size_t      _Size
        );
      __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_memicmp" ". See online help for details."))
     int __cdecl memicmp(
          void const* _Buf1,
          void const* _Buf2,
                                 size_t      _Size
        );
     errno_t __cdecl wcscat_s(
          wchar_t* _Destination,
          rsize_t _SizeInWords,
          wchar_t const* _Source
        );
     errno_t __cdecl wcscpy_s(
          wchar_t* _Destination,
          rsize_t _SizeInWords,
          wchar_t const* _Source
        );
     errno_t __cdecl wcsncat_s(
          wchar_t*       _Destination,
                                     rsize_t        _SizeInWords,
               wchar_t const* _Source,
                                     rsize_t        _MaxCount
        );
     errno_t __cdecl wcsncpy_s(
          wchar_t*       _Destination,
                                  rsize_t        _SizeInWords,
            wchar_t const* _Source,
                                  rsize_t        _MaxCount
        );
     wchar_t* __cdecl wcstok_s(
                          wchar_t*       _String,
                                 wchar_t const* _Delimiter,
            wchar_t**      _Context
        );
 __declspec(allocator) wchar_t* __cdecl _wcsdup(
      wchar_t const* _String
    );
    __declspec(deprecated("This function or variable may be unsafe. Consider using " "wcscat_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) wchar_t* __cdecl wcscat( wchar_t *_Destination, wchar_t const* _Source);
 int __cdecl wcscmp(
      wchar_t const* _String1,
      wchar_t const* _String2
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "wcscpy_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) wchar_t* __cdecl wcscpy( wchar_t *_Destination, wchar_t const* _Source);
 size_t __cdecl wcscspn(
      wchar_t const* _String,
      wchar_t const* _Control
    );
 size_t __cdecl wcslen(
      wchar_t const* _String
    );
 size_t __cdecl wcsnlen(
      wchar_t const* _Source,
                            size_t         _MaxCount
    );
     __inline size_t __cdecl wcsnlen_s(
          wchar_t const* _Source,
                                size_t         _MaxCount
        )
    {
        return (_Source == 0) ? 0 : wcsnlen(_Source, _MaxCount);
    }
__declspec(deprecated("This function or variable may be unsafe. Consider using " "wcsncat_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) wchar_t* __cdecl wcsncat( wchar_t *_Destination, wchar_t const* _Source, size_t _Count);
 int __cdecl wcsncmp(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "wcsncpy_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) wchar_t* __cdecl wcsncpy( wchar_t *_Destination, wchar_t const* _Source, size_t _Count);
 wchar_t  * __cdecl wcspbrk(
      wchar_t const* _String,
      wchar_t const* _Control
    );
 size_t __cdecl wcsspn(
      wchar_t const* _String,
      wchar_t const* _Control
    );
  __declspec(deprecated("This function or variable may be unsafe. Consider using " "wcstok_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details."))
 wchar_t* __cdecl wcstok(
                          wchar_t*       _String,
                                 wchar_t const* _Delimiter,
        wchar_t**      _Context
    );
      __declspec(deprecated("This function or variable may be unsafe. Consider using " "wcstok_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details."))
    static __inline wchar_t* __cdecl _wcstok(
          wchar_t*       const _String,
                 wchar_t const* const _Delimiter
        )
    {
        return wcstok(_String, _Delimiter, 0);
    }
  __declspec(deprecated("This function or variable may be unsafe. Consider using " "_wcserror_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details."))
 wchar_t* __cdecl _wcserror(
      int _ErrorNumber
    );
 errno_t __cdecl _wcserror_s(
      wchar_t* _Buffer,
                                  size_t   _SizeInWords,
                                  int      _ErrorNumber
    );
  __declspec(deprecated("This function or variable may be unsafe. Consider using " "__wcserror_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details."))
 wchar_t* __cdecl __wcserror(
      wchar_t const* _String
    );
  errno_t __cdecl __wcserror_s(
      wchar_t*       _Buffer,
                                  size_t         _SizeInWords,
                                wchar_t const* _ErrorMessage
    );
   int __cdecl _wcsicmp(
      wchar_t const* _String1,
      wchar_t const* _String2
    );
   int __cdecl _wcsicmp_l(
        wchar_t const* _String1,
        wchar_t const* _String2,
      _locale_t      _Locale
    );
   int __cdecl _wcsnicmp(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount
    );
   int __cdecl _wcsnicmp_l(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount,
                        _locale_t      _Locale
    );
  errno_t __cdecl _wcsnset_s(
      wchar_t* _Destination,
                                 size_t   _SizeInWords,
                                 wchar_t  _Value,
                                 size_t   _MaxCount
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_wcsnset_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) wchar_t* __cdecl _wcsnset( wchar_t *_String, wchar_t _Value, size_t _MaxCount);
 wchar_t* __cdecl _wcsrev(
      wchar_t* _String
    );
  errno_t __cdecl _wcsset_s(
      wchar_t* _Destination,
                                 size_t   _SizeInWords,
                                 wchar_t  _Value
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_wcsset_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) wchar_t* __cdecl _wcsset( wchar_t *_String, wchar_t _Value);
  errno_t __cdecl _wcslwr_s(
      wchar_t* _String,
                                 size_t   _SizeInWords
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_wcslwr_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) wchar_t* __cdecl _wcslwr( wchar_t *_String);
 errno_t __cdecl _wcslwr_s_l(
      wchar_t*  _String,
                                 size_t    _SizeInWords,
                             _locale_t _Locale
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_wcslwr_s_l" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) wchar_t* __cdecl _wcslwr_l( wchar_t *_String, _locale_t _Locale);
 errno_t __cdecl _wcsupr_s(
      wchar_t* _String,
                          size_t   _Size
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_wcsupr_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) wchar_t* __cdecl _wcsupr( wchar_t *_String);
 errno_t __cdecl _wcsupr_s_l(
      wchar_t*  _String,
                          size_t    _Size,
                      _locale_t _Locale
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_wcsupr_s_l" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) wchar_t* __cdecl _wcsupr_l( wchar_t *_String, _locale_t _Locale);
 size_t __cdecl wcsxfrm(
        wchar_t*       _Destination,
                                         wchar_t const* _Source,
                size_t         _MaxCount
    );
 size_t __cdecl _wcsxfrm_l(
        wchar_t*       _Destination,
                                         wchar_t const* _Source,
                size_t         _MaxCount,
                                       _locale_t      _Locale
    );
 int __cdecl wcscoll(
      wchar_t const* _String1,
      wchar_t const* _String2
    );
 int __cdecl _wcscoll_l(
        wchar_t const* _String1,
        wchar_t const* _String2,
      _locale_t      _Locale
    );
 int __cdecl _wcsicoll(
      wchar_t const* _String1,
      wchar_t const* _String2
    );
 int __cdecl _wcsicoll_l(
        wchar_t const* _String1,
        wchar_t const* _String2,
      _locale_t      _Locale
    );
 int __cdecl _wcsncoll(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount
    );
 int __cdecl _wcsncoll_l(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount,
                        _locale_t      _Locale
    );
 int __cdecl _wcsnicoll(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount
    );
 int __cdecl _wcsnicoll_l(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount,
                        _locale_t      _Locale
    );
      __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_wcsdup" ". See online help for details."))
     wchar_t* __cdecl wcsdup(
          wchar_t const* _String
        );
      __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_wcsicmp" ". See online help for details."))
     int __cdecl wcsicmp(
          wchar_t const* _String1,
          wchar_t const* _String2
        );
      __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_wcsnicmp" ". See online help for details."))
     int __cdecl wcsnicmp(
          wchar_t const* _String1,
          wchar_t const* _String2,
                                size_t         _MaxCount
        );
    __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_wcsnset" ". See online help for details."))
     wchar_t* __cdecl wcsnset(
          wchar_t* _String,
                                  wchar_t  _Value,
                                  size_t   _MaxCount
        );
    __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_wcsrev" ". See online help for details."))
     wchar_t* __cdecl wcsrev(
          wchar_t* _String
        );
    __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_wcsset" ". See online help for details."))
     wchar_t* __cdecl wcsset(
          wchar_t* _String,
               wchar_t  _Value
        );
    __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_wcslwr" ". See online help for details."))
     wchar_t* __cdecl wcslwr(
          wchar_t* _String
        );
    __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_wcsupr" ". See online help for details."))
     wchar_t* __cdecl wcsupr(
          wchar_t* _String
        );
      __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_wcsicoll" ". See online help for details."))
     int __cdecl wcsicoll(
          wchar_t const* _String1,
          wchar_t const* _String2
        );
     errno_t __cdecl strcpy_s(
          char*       _Destination,
                                  rsize_t     _SizeInBytes,
                                char const* _Source
        );
     errno_t __cdecl strcat_s(
          char*       _Destination,
                                     rsize_t     _SizeInBytes,
                                   char const* _Source
        );
     errno_t __cdecl strerror_s(
          char*  _Buffer,
                                  size_t _SizeInBytes,
                                  int    _ErrorNumber);
     errno_t __cdecl strncat_s(
          char*       _Destination,
                                     rsize_t     _SizeInBytes,
               char const* _Source,
                                     rsize_t     _MaxCount
        );
     errno_t __cdecl strncpy_s(
          char*       _Destination,
                                  rsize_t     _SizeInBytes,
            char const* _Source,
                                  rsize_t     _MaxCount
        );
     char*  __cdecl strtok_s(
                          char*       _String,
                                 char const* _Delimiter,
            char**      _Context
        );
 void* __cdecl _memccpy(
      void*       _Dst,
                                   void const* _Src,
                                   int         _Val,
                                   size_t      _MaxCount
    );
    __declspec(deprecated("This function or variable may be unsafe. Consider using " "strcat_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) char* __cdecl strcat( char *_Destination, char const* _Source);
int __cdecl strcmp(
      char const* _Str1,
      char const* _Str2
    );
 int __cdecl _strcmpi(
      char const* _String1,
      char const* _String2
    );
 int __cdecl strcoll(
      char const* _String1,
      char const* _String2
    );
 int __cdecl _strcoll_l(
        char const* _String1,
        char const* _String2,
      _locale_t   _Locale
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "strcpy_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) char* __cdecl strcpy( char *_Destination, char const* _Source);
 size_t __cdecl strcspn(
      char const* _Str,
      char const* _Control
    );
 __declspec(allocator) char* __cdecl _strdup(
      char const* _Source
    );
  __declspec(deprecated("This function or variable may be unsafe. Consider using " "_strerror_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details."))
 char*  __cdecl _strerror(
      char const* _ErrorMessage
    );
 errno_t __cdecl _strerror_s(
      char*       _Buffer,
                              size_t      _SizeInBytes,
                        char const* _ErrorMessage
    );
  __declspec(deprecated("This function or variable may be unsafe. Consider using " "strerror_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details."))
 char* __cdecl strerror(
      int _ErrorMessage
    );
 int __cdecl _stricmp(
      char const* _String1,
      char const* _String2
    );
 int __cdecl _stricoll(
      char const* _String1,
      char const* _String2
    );
 int __cdecl _stricoll_l(
        char const* _String1,
        char const* _String2,
      _locale_t   _Locale
    );
 int __cdecl _stricmp_l(
        char const* _String1,
        char const* _String2,
      _locale_t   _Locale
    );
size_t __cdecl strlen(
      char const* _Str
    );
 errno_t __cdecl _strlwr_s(
      char*  _String,
                          size_t _Size
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_strlwr_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) char* __cdecl _strlwr( char *_String);
 errno_t __cdecl _strlwr_s_l(
      char*     _String,
                          size_t    _Size,
                      _locale_t _Locale
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_strlwr_s_l" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) char* __cdecl _strlwr_l( char *_String, _locale_t _Locale);
__declspec(deprecated("This function or variable may be unsafe. Consider using " "strncat_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) char* __cdecl strncat( char *_Destination, char const* _Source, size_t _Count);
 int __cdecl strncmp(
      char const* _Str1,
      char const* _Str2,
                            size_t      _MaxCount
    );
 int __cdecl _strnicmp(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount
    );
 int __cdecl _strnicmp_l(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount,
                        _locale_t   _Locale
    );
 int __cdecl _strnicoll(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount
    );
 int __cdecl _strnicoll_l(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount,
                        _locale_t   _Locale
    );
 int __cdecl _strncoll(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount
    );
 int __cdecl _strncoll_l(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount,
                        _locale_t   _Locale
    );
 size_t __cdecl __strncnt(
      char const* _String,
                         size_t      _Count
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "strncpy_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) char* __cdecl strncpy( char *_Destination, char const* _Source, size_t _Count);
 size_t __cdecl strnlen(
      char const* _String,
                            size_t      _MaxCount
    );
     __inline size_t __cdecl strnlen_s(
          char const* _String,
                                size_t      _MaxCount
        )
    {
        return _String == 0 ? 0 : strnlen(_String, _MaxCount);
    }
 errno_t __cdecl _strnset_s(
      char*  _String,
                                 size_t _SizeInBytes,
                                 int    _Value,
                                 size_t _MaxCount
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_strnset_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) char* __cdecl _strnset( char *_Destination, int _Value, size_t _Count);
 char  * __cdecl strpbrk(
      char const* _Str,
      char const* _Control
    );
 char* __cdecl _strrev(
      char* _Str
    );
 errno_t __cdecl _strset_s(
      char*  _Destination,
                                     size_t _DestinationSize,
                                     int    _Value
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_strset_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) char* __cdecl _strset( char *_Destination, int _Value);
 size_t __cdecl strspn(
      char const* _Str,
      char const* _Control
    );
  __declspec(deprecated("This function or variable may be unsafe. Consider using " "strtok_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details."))
 char* __cdecl strtok(
      char*       _String,
             char const* _Delimiter
    );
 errno_t __cdecl _strupr_s(
      char*  _String,
                          size_t _Size
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_strupr_s" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) char* __cdecl _strupr( char *_String);
 errno_t __cdecl _strupr_s_l(
      char*     _String,
                          size_t    _Size,
                      _locale_t _Locale
    );
__declspec(deprecated("This function or variable may be unsafe. Consider using " "_strupr_s_l" " instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. " "See online help for details.")) char* __cdecl _strupr_l( char *_String, _locale_t _Locale);
 size_t __cdecl strxfrm(
        char*       _Destination,
                                         char const* _Source,
                 size_t      _MaxCount
    );
 size_t __cdecl _strxfrm_l(
        char*       _Destination,
                                         char const* _Source,
                 size_t      _MaxCount,
                                       _locale_t   _Locale
    );
      __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_strdup" ". See online help for details."))
     char* __cdecl strdup(
          char const* _String
        );
      __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_strcmpi" ". See online help for details."))
     int __cdecl strcmpi(
          char const* _String1,
          char const* _String2
        );
      __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_stricmp" ". See online help for details."))
     int __cdecl stricmp(
          char const* _String1,
          char const* _String2
        );
    __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_strlwr" ". See online help for details."))
     char* __cdecl strlwr(
          char* _String
        );
      __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_strnicmp" ". See online help for details."))
     int __cdecl strnicmp(
          char const* _String1,
          char const* _String2,
                                size_t      _MaxCount
        );
    __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_strnset" ". See online help for details."))
     char* __cdecl strnset(
          char*  _String,
                                  int    _Value,
                                  size_t _MaxCount
        );
    __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_strrev" ". See online help for details."))
     char* __cdecl strrev(
          char* _String
        );
    __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_strset" ". See online help for details."))
    char* __cdecl strset(
          char* _String,
               int   _Value);
    __declspec(deprecated("The POSIX name for this item is deprecated. Instead, use the ISO C " "and C++ conformant name: " "_strupr" ". See online help for details."))
     char* __cdecl strupr(
          char* _String
        );
    typedef unsigned short _ino_t; 
        typedef _ino_t ino_t;
    typedef unsigned int _dev_t; 
        typedef _dev_t dev_t;
    typedef long _off_t; 
        typedef _off_t off_t;
struct aiVector2D {
    ai_real x, y;
};
struct aiColor4D {
    float r, g, b, a;
};
struct aiMatrix3x3 {
    ai_real a1, a2, a3;
    ai_real b1, b2, b3;
    ai_real c1, c2, c3;
};
struct aiMatrix4x4 {
    ai_real a1, a2, a3, a4;
    ai_real b1, b2, b3, b4;
    ai_real c1, c2, c3, c4;
    ai_real d1, d2, d3, d4;
};
struct aiQuaternion {
    ai_real w, x, y, z;
};
typedef int32_t ai_int32;
typedef uint32_t ai_uint32;
struct aiPlane {
    ai_real a, b, c, d;
}; 
struct aiRay {
    struct aiVector3D pos, dir;
}; 
struct aiColor3D {
    float r, g, b;
}; 
struct aiString {
    ai_uint32 length;
    char data[1024 ];
}; 
typedef enum aiReturn {
    aiReturn_SUCCESS = 0x0,
    aiReturn_FAILURE = -0x1,
    aiReturn_OUTOFMEMORY = -0x3,
    _AI_ENFORCE_ENUM_SIZE = 0x7fffffff
} aiReturn; 
enum aiOrigin {
    aiOrigin_SET = 0x0,
    aiOrigin_CUR = 0x1,
    aiOrigin_END = 0x2,
    _AI_ORIGIN_ENFORCE_ENUM_SIZE = 0x7fffffff
}; 
enum aiDefaultLogStream {
    aiDefaultLogStream_FILE = 0x1,
    aiDefaultLogStream_STDOUT = 0x2,
    aiDefaultLogStream_STDERR = 0x4,
    aiDefaultLogStream_DEBUGGER = 0x8,
    _AI_DLS_ENFORCE_ENUM_SIZE = 0x7fffffff
}; 
struct aiMemoryInfo {
    unsigned int textures;
    unsigned int materials;
    unsigned int meshes;
    unsigned int nodes;
    unsigned int animations;
    unsigned int cameras;
    unsigned int lights;
    unsigned int total;
}; 
struct aiBuffer {
    const char *data; 
    const char *end;  
};
struct aiScene;
struct aiFileIO;
struct aiExportFormatDesc {
    const char *id;
    const char *description;
    const char *fileExtension;
};
 size_t aiGetExportFormatCount(void);
 const struct aiExportFormatDesc *aiGetExportFormatDescription(size_t pIndex);
 void aiReleaseExportFormatDescription(const struct aiExportFormatDesc *desc);
 void aiCopyScene(const struct aiScene *pIn,
        struct aiScene **pOut);
 void aiFreeScene(const struct aiScene *pIn);
 aiReturn aiExportScene(const struct aiScene *pScene,
        const char *pFormatId,
        const char *pFileName,
        unsigned int pPreprocessing);
 aiReturn aiExportSceneEx(const struct aiScene *pScene,
        const char *pFormatId,
        const char *pFileName,
        struct aiFileIO *pIO,
        unsigned int pPreprocessing);
struct aiExportDataBlob {
    size_t size;
    void *data;
    struct aiString name;
    struct aiExportDataBlob *next;
};
 const struct aiExportDataBlob *aiExportSceneToBlob(const struct aiScene *pScene, const char *pFormatId,
        unsigned int pPreprocessing);
 void aiReleaseExportBlob(const struct aiExportDataBlob *pData);
struct aiFileIO;
struct aiFile;
typedef size_t          (*aiFileWriteProc) (struct aiFile*,   const char*, size_t, size_t);
typedef size_t          (*aiFileReadProc)  (struct aiFile*,   char*, size_t,size_t);
typedef size_t          (*aiFileTellProc)  (struct aiFile*);
typedef void            (*aiFileFlushProc) (struct aiFile*);
typedef enum aiReturn (*aiFileSeek)      (struct aiFile*, size_t, enum aiOrigin);
typedef struct aiFile* (*aiFileOpenProc)  (struct aiFileIO*, const char*, const char*);
typedef void             (*aiFileCloseProc) (struct aiFileIO*, struct aiFile*);
typedef char* aiUserData;
struct aiFileIO
{
    aiFileOpenProc OpenProc;
    aiFileCloseProc CloseProc;
    aiUserData UserData;
};
struct aiFile {
    aiFileReadProc ReadProc;
    aiFileWriteProc WriteProc;
    aiFileTellProc TellProc;
    aiFileTellProc FileSizeProc;
    aiFileSeek SeekProc;
    aiFileFlushProc FlushProc;
    aiUserData UserData;
};
enum aiImporterFlags {
    aiImporterFlags_SupportTextFlavour = 0x1,
    aiImporterFlags_SupportBinaryFlavour = 0x2,
    aiImporterFlags_SupportCompressedFlavour = 0x4,
    aiImporterFlags_LimitedSupport = 0x8,
    aiImporterFlags_Experimental = 0x10
};
struct aiImporterDesc {
    const char *mName;
    const char *mAuthor;
    const char *mMaintainer;
    const char *mComments;
    unsigned int mFlags;
    unsigned int mMinMajor;
    unsigned int mMinMinor;
    unsigned int mMaxMajor;
    unsigned int mMaxMinor;
    const char *mFileExtensions;
};
 const struct aiImporterDesc *aiGetImporterDesc(const char *extension);
struct aiScene;
struct aiTexture;
struct aiFileIO;
typedef void (*aiLogStreamCallback)(const char *  , char *  );
struct aiLogStream {
    aiLogStreamCallback callback;
    char *user;
};
struct aiPropertyStore {
    char sentinel;
};
typedef int aiBool;
 const struct aiScene *aiImportFile(
        const char *pFile,
        unsigned int pFlags);
 const struct aiScene *aiImportFileEx(
        const char *pFile,
        unsigned int pFlags,
        struct aiFileIO *pFS);
 const struct aiScene *aiImportFileExWithProperties(
        const char *pFile,
        unsigned int pFlags,
        struct aiFileIO *pFS,
        const struct aiPropertyStore *pProps);
 const struct aiScene *aiImportFileFromMemory(
        const char *pBuffer,
        unsigned int pLength,
        unsigned int pFlags,
        const char *pHint);
 const struct aiScene *aiImportFileFromMemoryWithProperties(
        const char *pBuffer,
        unsigned int pLength,
        unsigned int pFlags,
        const char *pHint,
        const struct aiPropertyStore *pProps);
 const struct aiScene *aiApplyPostProcessing(
        const struct aiScene *pScene,
        unsigned int pFlags);
 struct aiLogStream aiGetPredefinedLogStream(
        enum aiDefaultLogStream pStreams,
        const char *file);
 void aiAttachLogStream(
        const struct aiLogStream *stream);
 void aiEnableVerboseLogging(aiBool d);
 enum aiReturn aiDetachLogStream(
        const struct aiLogStream *stream);
 void aiDetachAllLogStreams(void);
 void aiReleaseImport(
        const struct aiScene *pScene);
 const char *aiGetErrorString(void);
 aiBool aiIsExtensionSupported(
        const char *szExtension);
 void aiGetExtensionList(
        struct aiString *szOut);
 void aiGetMemoryRequirements(
        const struct aiScene *pIn,
        struct aiMemoryInfo *in);
 const struct aiTexture *aiGetEmbeddedTexture(const struct aiScene *pIn, const char *filename);
 struct aiPropertyStore *aiCreatePropertyStore(void);
 void aiReleasePropertyStore(struct aiPropertyStore *p);
 void aiSetImportPropertyInteger(
        struct aiPropertyStore *store,
        const char *szName,
        int value);
 void aiSetImportPropertyFloat(
        struct aiPropertyStore *store,
        const char *szName,
        ai_real value);
 void aiSetImportPropertyString(
        struct aiPropertyStore *store,
        const char *szName,
        const struct aiString *st);
 void aiSetImportPropertyMatrix(
        struct aiPropertyStore *store,
        const char *szName,
        const struct aiMatrix4x4 *mat);
 void aiCreateQuaternionFromMatrix(
        struct aiQuaternion *quat,
        const struct aiMatrix3x3 *mat);
 void aiDecomposeMatrix(
        const struct aiMatrix4x4 *mat,
        struct aiVector3D *scaling,
        struct aiQuaternion *rotation,
        struct aiVector3D *position);
 void aiTransposeMatrix4(
        struct aiMatrix4x4 *mat);
 void aiTransposeMatrix3(
        struct aiMatrix3x3 *mat);
 void aiTransformVecByMatrix3(
        struct aiVector3D *vec,
        const struct aiMatrix3x3 *mat);
 void aiTransformVecByMatrix4(
        struct aiVector3D *vec,
        const struct aiMatrix4x4 *mat);
 void aiMultiplyMatrix4(
        struct aiMatrix4x4 *dst,
        const struct aiMatrix4x4 *src);
 void aiMultiplyMatrix3(
        struct aiMatrix3x3 *dst,
        const struct aiMatrix3x3 *src);
 void aiIdentityMatrix3(
        struct aiMatrix3x3 *mat);
 void aiIdentityMatrix4(
        struct aiMatrix4x4 *mat);
 size_t aiGetImportFormatCount(void);
 const struct aiImporterDesc *aiGetImportFormatDescription(size_t pIndex);
 int aiVector2AreEqual(
        const struct aiVector2D *a,
        const struct aiVector2D *b);
 int aiVector2AreEqualEpsilon(
        const struct aiVector2D *a,
        const struct aiVector2D *b,
        const float epsilon);
 void aiVector2Add(
        struct aiVector2D *dst,
        const struct aiVector2D *src);
 void aiVector2Subtract(
        struct aiVector2D *dst,
        const struct aiVector2D *src);
 void aiVector2Scale(
        struct aiVector2D *dst,
        const float s);
 void aiVector2SymMul(
        struct aiVector2D *dst,
        const struct aiVector2D *other);
 void aiVector2DivideByScalar(
        struct aiVector2D *dst,
        const float s);
 void aiVector2DivideByVector(
        struct aiVector2D *dst,
        struct aiVector2D *v);
 ai_real aiVector2Length(
        const struct aiVector2D *v);
 ai_real aiVector2SquareLength(
        const struct aiVector2D *v);
 void aiVector2Negate(
        struct aiVector2D *dst);
 ai_real aiVector2DotProduct(
        const struct aiVector2D *a,
        const struct aiVector2D *b);
 void aiVector2Normalize(
        struct aiVector2D *v);
 int aiVector3AreEqual(
        const struct aiVector3D *a,
        const struct aiVector3D *b);
 int aiVector3AreEqualEpsilon(
        const struct aiVector3D *a,
        const struct aiVector3D *b,
        const float epsilon);
 int aiVector3LessThan(
        const struct aiVector3D *a,
        const struct aiVector3D *b);
 void aiVector3Add(
        struct aiVector3D *dst,
        const struct aiVector3D *src);
 void aiVector3Subtract(
        struct aiVector3D *dst,
        const struct aiVector3D *src);
 void aiVector3Scale(
        struct aiVector3D *dst,
        const float s);
 void aiVector3SymMul(
        struct aiVector3D *dst,
        const struct aiVector3D *other);
 void aiVector3DivideByScalar(
        struct aiVector3D *dst,
        const float s);
 void aiVector3DivideByVector(
        struct aiVector3D *dst,
        struct aiVector3D *v);
 ai_real aiVector3Length(
        const struct aiVector3D *v);
 ai_real aiVector3SquareLength(
        const struct aiVector3D *v);
 void aiVector3Negate(
        struct aiVector3D *dst);
 ai_real aiVector3DotProduct(
        const struct aiVector3D *a,
        const struct aiVector3D *b);
 void aiVector3CrossProduct(
        struct aiVector3D *dst,
        const struct aiVector3D *a,
        const struct aiVector3D *b);
 void aiVector3Normalize(
        struct aiVector3D *v);
 void aiVector3NormalizeSafe(
        struct aiVector3D *v);
 void aiVector3RotateByQuaternion(
        struct aiVector3D *v,
        const struct aiQuaternion *q);
 void aiMatrix3FromMatrix4(
        struct aiMatrix3x3 *dst,
        const struct aiMatrix4x4 *mat);
 void aiMatrix3FromQuaternion(
        struct aiMatrix3x3 *mat,
        const struct aiQuaternion *q);
 int aiMatrix3AreEqual(
        const struct aiMatrix3x3 *a,
        const struct aiMatrix3x3 *b);
 int aiMatrix3AreEqualEpsilon(
        const struct aiMatrix3x3 *a,
        const struct aiMatrix3x3 *b,
        const float epsilon);
 void aiMatrix3Inverse(
        struct aiMatrix3x3 *mat);
 ai_real aiMatrix3Determinant(
        const struct aiMatrix3x3 *mat);
 void aiMatrix3RotationZ(
        struct aiMatrix3x3 *mat,
        const float angle);
 void aiMatrix3FromRotationAroundAxis(
        struct aiMatrix3x3 *mat,
        const struct aiVector3D *axis,
        const float angle);
 void aiMatrix3Translation(
        struct aiMatrix3x3 *mat,
        const struct aiVector2D *translation);
 void aiMatrix3FromTo(
        struct aiMatrix3x3 *mat,
        const struct aiVector3D *from,
        const struct aiVector3D *to);
 void aiMatrix4FromMatrix3(
        struct aiMatrix4x4 *dst,
        const struct aiMatrix3x3 *mat);
 void aiMatrix4FromScalingQuaternionPosition(
        struct aiMatrix4x4 *mat,
        const struct aiVector3D *scaling,
        const struct aiQuaternion *rotation,
        const struct aiVector3D *position);
 void aiMatrix4Add(
        struct aiMatrix4x4 *dst,
        const struct aiMatrix4x4 *src);
 int aiMatrix4AreEqual(
        const struct aiMatrix4x4 *a,
        const struct aiMatrix4x4 *b);
 int aiMatrix4AreEqualEpsilon(
        const struct aiMatrix4x4 *a,
        const struct aiMatrix4x4 *b,
        const float epsilon);
 void aiMatrix4Inverse(
        struct aiMatrix4x4 *mat);
 ai_real aiMatrix4Determinant(
        const struct aiMatrix4x4 *mat);
 int aiMatrix4IsIdentity(
        const struct aiMatrix4x4 *mat);
 void aiMatrix4DecomposeIntoScalingEulerAnglesPosition(
        const struct aiMatrix4x4 *mat,
        struct aiVector3D *scaling,
        struct aiVector3D *rotation,
        struct aiVector3D *position);
 void aiMatrix4DecomposeIntoScalingAxisAnglePosition(
        const struct aiMatrix4x4 *mat,
        struct aiVector3D *scaling,
        struct aiVector3D *axis,
        ai_real *angle,
        struct aiVector3D *position);
 void aiMatrix4DecomposeNoScaling(
        const struct aiMatrix4x4 *mat,
        struct aiQuaternion *rotation,
        struct aiVector3D *position);
 void aiMatrix4FromEulerAngles(
        struct aiMatrix4x4 *mat,
        float x, float y, float z);
 void aiMatrix4RotationX(
        struct aiMatrix4x4 *mat,
        const float angle);
 void aiMatrix4RotationY(
        struct aiMatrix4x4 *mat,
        const float angle);
 void aiMatrix4RotationZ(
        struct aiMatrix4x4 *mat,
        const float angle);
 void aiMatrix4FromRotationAroundAxis(
        struct aiMatrix4x4 *mat,
        const struct aiVector3D *axis,
        const float angle);
 void aiMatrix4Translation(
        struct aiMatrix4x4 *mat,
        const struct aiVector3D *translation);
 void aiMatrix4Scaling(
        struct aiMatrix4x4 *mat,
        const struct aiVector3D *scaling);
 void aiMatrix4FromTo(
        struct aiMatrix4x4 *mat,
        const struct aiVector3D *from,
        const struct aiVector3D *to);
 void aiQuaternionFromEulerAngles(
        struct aiQuaternion *q,
        float x, float y, float z);
 void aiQuaternionFromAxisAngle(
        struct aiQuaternion *q,
        const struct aiVector3D *axis,
        const float angle);
 void aiQuaternionFromNormalizedQuaternion(
        struct aiQuaternion *q,
        const struct aiVector3D *normalized);
 int aiQuaternionAreEqual(
        const struct aiQuaternion *a,
        const struct aiQuaternion *b);
 int aiQuaternionAreEqualEpsilon(
        const struct aiQuaternion *a,
        const struct aiQuaternion *b,
        const float epsilon);
 void aiQuaternionNormalize(
        struct aiQuaternion *q);
 void aiQuaternionConjugate(
        struct aiQuaternion *q);
 void aiQuaternionMultiply(
        struct aiQuaternion *dst,
        const struct aiQuaternion *q);
 void aiQuaternionInterpolate(
        struct aiQuaternion *dst,
        const struct aiQuaternion *start,
        const struct aiQuaternion *end,
        const float factor);
enum aiTextureOp {
    aiTextureOp_Multiply = 0x0,
    aiTextureOp_Add = 0x1,
    aiTextureOp_Subtract = 0x2,
    aiTextureOp_Divide = 0x3,
    aiTextureOp_SmoothAdd = 0x4,
    aiTextureOp_SignedAdd = 0x5,
    _aiTextureOp_Force32Bit = 2147483647
};
enum aiTextureMapMode {
    aiTextureMapMode_Wrap = 0x0,
    aiTextureMapMode_Clamp = 0x1,
    aiTextureMapMode_Decal = 0x3,
    aiTextureMapMode_Mirror = 0x2,
    _aiTextureMapMode_Force32Bit = 2147483647
};
enum aiTextureMapping {
    aiTextureMapping_UV = 0x0,
    aiTextureMapping_SPHERE = 0x1,
    aiTextureMapping_CYLINDER = 0x2,
    aiTextureMapping_BOX = 0x3,
    aiTextureMapping_PLANE = 0x4,
    aiTextureMapping_OTHER = 0x5,
    _aiTextureMapping_Force32Bit = 2147483647
};
enum aiTextureType {
    aiTextureType_NONE = 0,
    aiTextureType_DIFFUSE = 1,
    aiTextureType_SPECULAR = 2,
    aiTextureType_AMBIENT = 3,
    aiTextureType_EMISSIVE = 4,
    aiTextureType_HEIGHT = 5,
    aiTextureType_NORMALS = 6,
    aiTextureType_SHININESS = 7,
    aiTextureType_OPACITY = 8,
    aiTextureType_DISPLACEMENT = 9,
    aiTextureType_LIGHTMAP = 10,
    aiTextureType_REFLECTION = 11,
    aiTextureType_BASE_COLOR = 12,
    aiTextureType_NORMAL_CAMERA = 13,
    aiTextureType_EMISSION_COLOR = 14,
    aiTextureType_METALNESS = 15,
    aiTextureType_DIFFUSE_ROUGHNESS = 16,
    aiTextureType_AMBIENT_OCCLUSION = 17,
    aiTextureType_UNKNOWN = 18,
    aiTextureType_SHEEN = 19,
    aiTextureType_CLEARCOAT = 20,
    aiTextureType_TRANSMISSION = 21,
    aiTextureType_MAYA_BASE = 22,
    aiTextureType_MAYA_SPECULAR = 23,
    aiTextureType_MAYA_SPECULAR_COLOR = 24,
    aiTextureType_MAYA_SPECULAR_ROUGHNESS = 25,
    aiTextureType_ANISOTROPY = 26,
    aiTextureType_GLTF_METALLIC_ROUGHNESS = 27,
    _aiTextureType_Force32Bit = 2147483647
};
 const char *aiTextureTypeToString(enum aiTextureType in);
enum aiShadingMode {
    aiShadingMode_Flat = 0x1,
    aiShadingMode_Gouraud = 0x2,
    aiShadingMode_Phong = 0x3,
    aiShadingMode_Blinn = 0x4,
    aiShadingMode_Toon = 0x5,
    aiShadingMode_OrenNayar = 0x6,
    aiShadingMode_Minnaert = 0x7,
    aiShadingMode_CookTorrance = 0x8,
    aiShadingMode_NoShading = 0x9,
    aiShadingMode_Unlit = aiShadingMode_NoShading, 
    aiShadingMode_Fresnel = 0xa,
    aiShadingMode_PBR_BRDF = 0xb,
    _aiShadingMode_Force32Bit = 2147483647
};
enum aiTextureFlags {
    aiTextureFlags_Invert = 0x1,
    aiTextureFlags_UseAlpha = 0x2,
    aiTextureFlags_IgnoreAlpha = 0x4,
    _aiTextureFlags_Force32Bit = 2147483647
};
enum aiBlendMode {
    aiBlendMode_Default = 0x0,
    aiBlendMode_Additive = 0x1,
    _aiBlendMode_Force32Bit = 2147483647
};
struct aiUVTransform {
    struct aiVector2D mTranslation;
    struct aiVector2D mScaling;
    ai_real mRotation;
};
enum aiPropertyTypeInfo {
    aiPTI_Float = 0x1,
    aiPTI_Double = 0x2,
    aiPTI_String = 0x3,
    aiPTI_Integer = 0x4,
    aiPTI_Buffer = 0x5,
    _aiPTI_Force32Bit = 2147483647
};
struct aiMaterialProperty {
    struct aiString mKey;
    unsigned int mSemantic;
    unsigned int mIndex;
    unsigned int mDataLength;
    enum aiPropertyTypeInfo mType;
    char *mData;
};
struct aiMaterial
{
    struct aiMaterialProperty **mProperties;
    unsigned int mNumProperties;
    unsigned int mNumAllocated;
};
 enum aiReturn aiGetMaterialProperty(
        const struct aiMaterial *pMat,
        const char *pKey,
        unsigned int type,
        unsigned int index,
        const struct aiMaterialProperty **pPropOut);
 enum aiReturn aiGetMaterialFloatArray(
        const struct aiMaterial *pMat,
        const char *pKey,
        unsigned int type,
        unsigned int index,
        ai_real *pOut,
        unsigned int *pMax);
static inline aiReturn aiGetMaterialFloat(const struct aiMaterial *pMat,
        const char *pKey,
        unsigned int type,
        unsigned int index,
        ai_real *pOut) {
    return aiGetMaterialFloatArray(pMat, pKey, type, index, pOut, ((void *)0) );
}
 enum aiReturn aiGetMaterialIntegerArray(const struct aiMaterial *pMat,
        const char *pKey,
        unsigned int type,
        unsigned int index,
        int *pOut,
        unsigned int *pMax);
static inline aiReturn aiGetMaterialInteger(const struct aiMaterial *pMat,
        const char *pKey,
        unsigned int type,
        unsigned int index,
        int *pOut) {
    return aiGetMaterialIntegerArray(pMat, pKey, type, index, pOut, ((void *)0) );
}
 enum aiReturn aiGetMaterialColor(const struct aiMaterial *pMat,
        const char *pKey,
        unsigned int type,
        unsigned int index,
        struct aiColor4D *pOut);
 enum aiReturn aiGetMaterialUVTransform(const struct aiMaterial *pMat,
        const char *pKey,
        unsigned int type,
        unsigned int index,
        struct aiUVTransform *pOut);
 enum aiReturn aiGetMaterialString(const struct aiMaterial *pMat,
        const char *pKey,
        unsigned int type,
        unsigned int index,
        struct aiString *pOut);
 unsigned int aiGetMaterialTextureCount(const struct aiMaterial *pMat,
        enum aiTextureType type);
enum aiReturn aiGetMaterialTexture(const struct aiMaterial *mat,
        enum aiTextureType type,
        unsigned int index,
        struct aiString *path,
        enum aiTextureMapping *mapping  ,
        unsigned int *uvindex  ,
        ai_real *blend  ,
        enum aiTextureOp *op  ,
        enum aiTextureMapMode *mapmode  ,
        unsigned int *flags  );
struct aiFace {
    unsigned int mNumIndices;
    unsigned int *mIndices;
}; 
struct aiVertexWeight {
    unsigned int mVertexId;
    ai_real mWeight;
};
struct aiNode;
struct aiBone {
    struct aiString mName;
    unsigned int mNumWeights;
    struct aiNode *mArmature;
    struct aiNode *mNode;
    struct aiVertexWeight *mWeights;
    struct aiMatrix4x4 mOffsetMatrix;
};
enum aiPrimitiveType {
    aiPrimitiveType_POINT = 0x1,
    aiPrimitiveType_LINE = 0x2,
    aiPrimitiveType_TRIANGLE = 0x4,
    aiPrimitiveType_POLYGON = 0x8,
    aiPrimitiveType_NGONEncodingFlag = 0x10,
    _aiPrimitiveType_Force32Bit = 2147483647
}; 
struct aiAnimMesh {
    struct aiString mName;
    struct aiVector3D *mVertices;
    struct aiVector3D *mNormals;
    struct aiVector3D *mTangents;
    struct aiVector3D *mBitangents;
    struct aiColor4D *mColors[0x8 ];
    struct aiVector3D *mTextureCoords[0x8 ];
    unsigned int mNumVertices;
    float mWeight;
};
enum aiMorphingMethod {
    aiMorphingMethod_UNKNOWN = 0x0,
    aiMorphingMethod_VERTEX_BLEND = 0x1,
    aiMorphingMethod_MORPH_NORMALIZED = 0x2,
    aiMorphingMethod_MORPH_RELATIVE = 0x3,
    _aiMorphingMethod_Force32Bit = 2147483647
}; 
struct aiMesh {
    unsigned int mPrimitiveTypes;
    unsigned int mNumVertices;
    unsigned int mNumFaces;
    struct aiVector3D *mVertices;
    struct aiVector3D *mNormals;
    struct aiVector3D *mTangents;
    struct aiVector3D *mBitangents;
    struct aiColor4D *mColors[0x8 ];
    struct aiVector3D *mTextureCoords[0x8 ];
    unsigned int mNumUVComponents[0x8 ];
    struct aiFace *mFaces;
    unsigned int mNumBones;
    struct aiBone **mBones;
    unsigned int mMaterialIndex;
    struct aiString mName;
    unsigned int mNumAnimMeshes;
    struct aiAnimMesh **mAnimMeshes;
    enum aiMorphingMethod mMethod;
    struct aiAABB mAABB;
    struct aiString **mTextureCoordsNames;
};
struct aiSkeletonBone {
    int mParent;
    struct aiNode *mArmature;
    struct aiNode *mNode;
    unsigned int mNumnWeights;
    struct aiMesh *mMeshId;
    struct aiVertexWeight *mWeights;
    struct aiMatrix4x4 mOffsetMatrix;
    struct aiMatrix4x4 mLocalMatrix;
};
struct aiSkeleton {
    struct aiString mName;
    unsigned int mNumBones;
    struct aiSkeletonBone **mBones;
};
enum aiPostProcessSteps
{
    aiProcess_CalcTangentSpace = 0x1,
    aiProcess_JoinIdenticalVertices = 0x2,
    aiProcess_MakeLeftHanded = 0x4,
    aiProcess_Triangulate = 0x8,
    aiProcess_RemoveComponent = 0x10,
    aiProcess_GenNormals = 0x20,
    aiProcess_GenSmoothNormals = 0x40,
    aiProcess_SplitLargeMeshes = 0x80,
    aiProcess_PreTransformVertices = 0x100,
    aiProcess_LimitBoneWeights = 0x200,
    aiProcess_ValidateDataStructure = 0x400,
    aiProcess_ImproveCacheLocality = 0x800,
    aiProcess_RemoveRedundantMaterials = 0x1000,
    aiProcess_FixInfacingNormals = 0x2000,
    aiProcess_PopulateArmatureData = 0x4000,
    aiProcess_SortByPType = 0x8000,
    aiProcess_FindDegenerates = 0x10000,
    aiProcess_FindInvalidData = 0x20000,
    aiProcess_GenUVCoords = 0x40000,
    aiProcess_TransformUVCoords = 0x80000,
    aiProcess_FindInstances = 0x100000,
    aiProcess_OptimizeMeshes  = 0x200000,
    aiProcess_OptimizeGraph  = 0x400000,
    aiProcess_FlipUVs = 0x800000,
    aiProcess_FlipWindingOrder  = 0x1000000,
    aiProcess_SplitByBoneCount  = 0x2000000,
    aiProcess_Debone  = 0x4000000,
    aiProcess_GlobalScale = 0x8000000,
    aiProcess_EmbedTextures  = 0x10000000,
    aiProcess_ForceGenNormals = 0x20000000,
    aiProcess_DropNormals = 0x40000000,
    aiProcess_GenBoundingBoxes = 0x80000000
};
struct aiTexel {
    unsigned char b,g,r,a;
}  ;
struct aiTexture {
    unsigned int mWidth;
    unsigned int mHeight;
    char achFormatHint[ 9 ];
    struct aiTexel* pcData;
    struct aiString mFilename;
};
enum aiLightSourceType {
    aiLightSource_UNDEFINED     = 0x0,
    aiLightSource_DIRECTIONAL   = 0x1,
    aiLightSource_POINT         = 0x2,
    aiLightSource_SPOT          = 0x3,
    aiLightSource_AMBIENT       = 0x4,
    aiLightSource_AREA          = 0x5,
    _aiLightSource_Force32Bit = 2147483647
};
struct aiLight {
    struct aiString mName;
    enum aiLightSourceType mType;
    struct aiVector3D mPosition;
    struct aiVector3D mDirection;
    struct aiVector3D mUp;
    float mAttenuationConstant;
    float mAttenuationLinear;
    float mAttenuationQuadratic;
    struct aiColor3D mColorDiffuse;
    struct aiColor3D mColorSpecular;
    struct aiColor3D mColorAmbient;
    float mAngleInnerCone;
    float mAngleOuterCone;
    struct aiVector2D mSize;
};
struct aiCamera {
    struct aiString mName;
    struct aiVector3D mPosition;
    struct aiVector3D mUp;
    struct aiVector3D mLookAt;
    float mHorizontalFOV;
    float mClipPlaneNear;
    float mClipPlaneFar;
    float mAspect;
    float mOrthographicWidth;
};
enum aiAnimInterpolation {
    aiAnimInterpolation_Step,
    aiAnimInterpolation_Linear,
    aiAnimInterpolation_Spherical_Linear,
    aiAnimInterpolation_Cubic_Spline,
    _aiAnimInterpolation_Force32Bit = 2147483647
};
struct aiVectorKey {
    double mTime;
    struct aiVector3D mValue;
    enum aiAnimInterpolation mInterpolation;
};
struct aiQuatKey {
    double mTime;
    struct aiQuaternion mValue;
    enum aiAnimInterpolation mInterpolation;
};
struct aiMeshKey {
    double mTime;
    unsigned int mValue;
};
struct aiMeshMorphKey {
    double mTime;
    unsigned int *mValues;
    double *mWeights;
    unsigned int mNumValuesAndWeights;
};
enum aiAnimBehaviour {
    aiAnimBehaviour_DEFAULT = 0x0,
    aiAnimBehaviour_CONSTANT = 0x1,
    aiAnimBehaviour_LINEAR = 0x2,
    aiAnimBehaviour_REPEAT = 0x3,
    _aiAnimBehaviour_Force32Bit = 2147483647
};
struct aiNodeAnim {
    struct aiString mNodeName;
    unsigned int mNumPositionKeys;
    struct aiVectorKey *mPositionKeys;
    unsigned int mNumRotationKeys;
    struct aiQuatKey *mRotationKeys;
    unsigned int mNumScalingKeys;
    struct aiVectorKey *mScalingKeys;
    enum aiAnimBehaviour mPreState;
    enum aiAnimBehaviour mPostState;
};
struct aiMeshAnim {
    struct aiString mName;
    unsigned int mNumKeys;
    struct aiMeshKey *mKeys;
};
struct aiMeshMorphAnim {
    struct aiString mName;
    unsigned int mNumKeys;
    struct aiMeshMorphKey *mKeys;
};
struct aiAnimation {
    struct aiString mName;
    double mDuration;
    double mTicksPerSecond;
    unsigned int mNumChannels;
    struct aiNodeAnim **mChannels;
    unsigned int mNumMeshChannels;
    struct aiMeshAnim **mMeshChannels;
    unsigned int mNumMorphMeshChannels;
    struct aiMeshMorphAnim **mMorphMeshChannels;
};
typedef enum aiMetadataType {
    AI_BOOL = 0,
    AI_INT32 = 1,
    AI_UINT64 = 2,
    AI_FLOAT = 3,
    AI_DOUBLE = 4,
    AI_AISTRING = 5,
    AI_AIVECTOR3D = 6,
    AI_AIMETADATA = 7,
    AI_INT64 = 8,
    AI_UINT32 = 9,
    AI_META_MAX = 10,
    FORCE_32BIT = 2147483647
} aiMetadataType;
struct aiMetadataEntry {
    aiMetadataType mType;
    void *mData;
};
struct aiMetadata {
    unsigned int mNumProperties;
    struct aiString *mKeys;
    struct aiMetadataEntry *mValues;
};
struct  aiNode {
    struct aiString mName;
    struct aiMatrix4x4 mTransformation;
    struct aiNode* mParent;
    unsigned int mNumChildren;
    struct aiNode** mChildren;
    unsigned int mNumMeshes;
    unsigned int* mMeshes;
    struct aiMetadata* mMetaData;
};
struct  aiScene {
    unsigned int mFlags;
    struct aiNode* mRootNode;
    unsigned int mNumMeshes;
    struct aiMesh** mMeshes;
    unsigned int mNumMaterials;
    struct aiMaterial** mMaterials;
    unsigned int mNumAnimations;
    struct aiAnimation** mAnimations;
    unsigned int mNumTextures;
    struct aiTexture** mTextures;
    unsigned int mNumLights;
    struct aiLight** mLights;
    unsigned int mNumCameras;
    struct aiCamera** mCameras;
    struct aiMetadata* mMetaData;
    struct aiString mName;
    unsigned int mNumSkeletons;
    struct aiSkeleton **mSkeletons;
    char* mPrivate;
};
typedef struct aiFile aiFile;
typedef struct aiFileIO aiFileIO;
typedef struct aiString aiString;
typedef struct aiColor4D aiColor4D;
typedef enum aiTextureMapMode aiTextureMapMode;
]])

return setmetatable({Library = ffi.load("Assimp/assimp.dll", false), Defines = defines}, {__index = IndexMetamethod})