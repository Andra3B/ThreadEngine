#include "assimp/aabb.h"
#include "assimp/cexport.h"
#include "assimp/cfileio.h"
#include "assimp/cimport.h"
#include "assimp/color4.h"
#include "assimp/config.h"
#include "assimp/GltfMaterial.h"
#include "assimp/material.h"
#include "assimp/matrix4x4.h"
#include "assimp/mesh.h"
#include "assimp/postprocess.h"
#include "assimp/pbrmaterial.h"
#include "assimp/quaternion.h"
#include "assimp/scene.h"
#include "assimp/texture.h"
#include "assimp/vector3.h"

typedef struct aiFile aiFile;
typedef struct aiFileIO aiFileIO;
typedef struct aiString aiString;
typedef struct aiColor4D aiColor4D;
typedef enum aiTextureMapMode aiTextureMapMode;