/*
===========================================================================
Vulkan graphics backend for ZEQ2-Lite.

This module implements the small OpenGL-compatible entry point surface the
classic renderer front end talks to.  Scene assembly, model loading, material
parsing and tessellation are shared with the OpenGL backend; only the drawing
API below is different.  GLSL sources (either the built-in fallback programs
or shaders shipped in a pk3) are translated to Vulkan-friendly GLSL and
compiled to SPIR-V with shaderc.
===========================================================================
*/

#ifdef HAVE_VULKAN

#include "tr_local.h"

#include <X11/Xlib.h>
#include <vulkan/vulkan.h>
#include <vulkan/vulkan_xlib.h>
#include <shaderc/shaderc.h>
#include <SDL.h>
#include <SDL_syswm.h>
#include <string.h>

#ifndef ARRAY_LEN
#define ARRAY_LEN(a) (sizeof(a) / sizeof((a)[0]))
#endif

#define VK_MAX_TEXTURES  1024
#define VK_MAX_PROGRAMS  64
#define VK_MAX_UNIFORMS  72
#define VK_MAX_PIPELINES 128
#define VK_MAX_SWAP      8
#define VK_NUM_SAMPLERS  8
#define VK_NUM_SAMPLERS_MIP (VK_NUM_SAMPLERS * 2)
#define VK_WHITE_TEXTURE (VK_MAX_TEXTURES - 1)
#define VK_UNIFORM_ALIGN 256
#define VK_VERTEX_ALIGN  4

/* Alpha-test modes stored in the UBO.  Zero disables the emulation so a
   disabled GL_ALPHA_TEST can never discard. */
#define VK_ALPHA_DISABLED 0
#define VK_ALPHA_NEVER    1
#define VK_ALPHA_LESS     2
#define VK_ALPHA_EQUAL    3
#define VK_ALPHA_LEQUAL   4
#define VK_ALPHA_GREATER  5
#define VK_ALPHA_NOTEQUAL 6
#define VK_ALPHA_GEQUAL   7
#define VK_ALPHA_ALWAYS   8

typedef struct {
	vec3_t xyz;
	float color[4];
	float tc0[2];
	float tc1[2];
	vec3_t normal;
} vkVertex_t;

typedef enum {
	VKUNI_FLOAT,
	VKUNI_INT,
	VKUNI_VEC2,
	VKUNI_VEC3,
	VKUNI_VEC4,
	VKUNI_MAT4,
	VKUNI_SAMPLER
} vkUniformType_t;

typedef struct {
	char name[64];
	vkUniformType_t type;
	VkDeviceSize offset;
	VkDeviceSize size;
	int sampler;
} vkUniform_t;

typedef struct {
	char name[64];
	VkShaderModule vertexModule;
	VkShaderModule fragmentModule;
	GLhandleARB vertexShader;
	GLhandleARB fragmentShader;
	vkUniform_t uniforms[VK_MAX_UNIFORMS];
	int numUniforms;
	byte uboData[2048];
	VkDeviceSize uboSize;
	int generation;
	qboolean valid;
} vkProgram_t;

typedef struct {
	VkImage image;
	VkDeviceMemory memory;
	VkImageView view;
	VkSampler sampler;
	int width, height, mipLevels;
	qboolean clamp;
	qboolean nearest;
	qboolean mipmapped;
	qboolean allocated;
	qboolean initialized;
} vkTexture_t;

typedef struct {
	vkProgram_t *program;
	VkPipeline pipeline;
	VkPrimitiveTopology topology;
	int generation;
	qboolean blend;
	qboolean depthTest;
	qboolean depthWrite;
	VkCullModeFlags cullMode;
	int blendSrc, blendDst;
	int depthFunc;
	int frontFace;
	int polygonMode;
	VkColorComponentFlags colorMask;
	qboolean polygonOffset;
	int used;
} vkPipeline_t;

typedef struct {
	VkInstance instance;
	VkPhysicalDevice physical;
	VkDevice device;
	VkQueue queue;
	int queueFamily;
	VkPhysicalDeviceMemoryProperties memoryProps;

	VkSurfaceKHR surface;
	VkSwapchainKHR swapchain;
	VkSurfaceFormatKHR surfaceFormat;
	VkExtent2D extent;
	VkImage swapImages[VK_MAX_SWAP];
	VkImageView swapViews[VK_MAX_SWAP];
	uint32_t numSwapImages;
	uint32_t swapIndex;

	VkImage colorImage;
	VkDeviceMemory colorMemory;
	VkImageView colorView;
	VkImage depthImage;
	VkDeviceMemory depthMemory;
	VkImageView depthView;

	VkRenderPass renderPass;
	VkFramebuffer framebuffer;
	VkCommandPool commandPool;
	VkCommandBuffer commandBuffer;
	VkFence fence;
	VkSemaphore imageAvailable;
	VkSemaphore renderFinished;
	qboolean recording;
	qboolean inRenderPass;
	qboolean videoInitialized;

	VkDescriptorSetLayout descriptorLayout;
	VkDescriptorPool descriptorPool;
	VkPipelineLayout pipelineLayout;
	VkSampler samplers[VK_NUM_SAMPLERS_MIP];

	VkBuffer vertexBuffer;
	VkDeviceMemory vertexMemory;
	VkDeviceSize vertexCapacity;
	VkDeviceSize vertexUsed;
	byte *vertexMapped;

	VkBuffer uniformBuffer;
	VkDeviceMemory uniformMemory;
	VkDeviceSize uniformCapacity;
	VkDeviceSize uniformUsed;
	byte *uniformMapped;

	VkBuffer stagingBuffer;
	VkDeviceMemory stagingMemory;
	VkDeviceSize stagingCapacity;
	byte *stagingMapped;

	VkCommandPool transientPool;
	VkCommandBuffer transientCommand;

	vkTexture_t textures[VK_MAX_TEXTURES];
	vkProgram_t programs[VK_MAX_PROGRAMS];
	int numPrograms;
	vkProgram_t *builtinProgram;
	vkProgram_t *currentProgram;

	vkPipeline_t pipelines[VK_MAX_PIPELINES];
	int numPipelines;

	/* GL-compatible state mirrored from qgl* calls. */
	int matrixMode;
	float matrices[2][16];
	float matrixStack[2][32][16];
	int stackDepth[2];
	int viewport[4];
	int scissor[4];
	qboolean scissorEnabled;
	float clearColor[4];
	float clearDepth;
	qboolean depthTest;
	qboolean depthWrite;
	qboolean blend;
	qboolean alphaTest;
	int alphaFunc;
	float alphaRef;
	qboolean cullFace;
	qboolean texture2D[VK_NUM_SAMPLERS];
	int textureUnits;
	int activeTexture;
	int clientTexture;
	int blendSrc, blendDst;
	int depthFunc;
	int cullMode;
	int frontFace;
	int polygonMode;
	qboolean polygonOffset;
	float polygonOffsetFactor;
	float polygonOffsetUnits;
	VkColorComponentFlags colorMask;
	float lineWidth;
	qboolean currentColorSet;
	float currentColor[4];
	float currentTexCoord[2][2];
	float currentNormal[3];
	int beginMode;
	qboolean inBegin;
	vkVertex_t immediate[65536];
	int numImmediate;

	const void *vertexPointer;
	int vertexSize;
	int vertexType;
	int vertexStride;
	const void *colorPointer;
	int colorSize;
	int colorType;
	int colorStride;
	const void *texCoordPointer[2];
	int texCoordStride[2];
	const void *normalPointer;
	int normalStride;
	qboolean clientVertex;
	qboolean clientColor;
	qboolean clientTexCoord[2];
	qboolean clientNormal;

	int boundTextures[VK_NUM_SAMPLERS];
	GLuint boundTextureName;
	GLuint nextTextureName;
	VkDescriptorSet descriptorSets[4096];
	int numDescriptorSets;

	qboolean initialized;
} vkState_t;

static vkState_t vk;

static const float vkIdentity[16] = {
	1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1
};

/* ------------------------------------------------------------------------ */
/* Small helpers                                                             */
/* ------------------------------------------------------------------------ */

static qboolean VK_Check( VkResult result, const char *what )
{
	if ( result == VK_SUCCESS )
	{
		return qtrue;
	}

	ri.Printf( PRINT_ALL, "Vulkan: %s failed (%d)\n", what, (int)result );
	return qfalse;
}

static int VK_MemoryType( uint32_t typeBits, VkMemoryPropertyFlags properties )
{
	uint32_t i;

	for ( i = 0; i < vk.memoryProps.memoryTypeCount; i++ )
	{
		if ( ( typeBits & ( 1u << i ) ) &&
		     ( vk.memoryProps.memoryTypes[i].propertyFlags & properties ) == properties )
		{
			return (int)i;
		}
	}

	ri.Printf( PRINT_ALL, "Vulkan: no suitable memory type found\n" );
	return -1;
}

static qboolean VK_CreateBuffer( VkDeviceSize size, VkBufferUsageFlags usage,
                                 VkMemoryPropertyFlags properties,
                                 VkBuffer *buffer, VkDeviceMemory *memory, void **mapped )
{
	VkBufferCreateInfo bufferInfo;
	VkMemoryRequirements requirements;
	VkMemoryAllocateInfo allocInfo;
	int memoryType;

	Com_Memset( &bufferInfo, 0, sizeof( bufferInfo ) );
	bufferInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	bufferInfo.size = size;
	bufferInfo.usage = usage;
	bufferInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
	if ( !VK_Check( vkCreateBuffer( vk.device, &bufferInfo, NULL, buffer ),
	                "vkCreateBuffer" ) )
	{
		return qfalse;
	}

	vkGetBufferMemoryRequirements( vk.device, *buffer, &requirements );
	memoryType = VK_MemoryType( requirements.memoryTypeBits, properties );
	if ( memoryType < 0 )
	{
		vkDestroyBuffer( vk.device, *buffer, NULL );
		*buffer = VK_NULL_HANDLE;
		return qfalse;
	}
	Com_Memset( &allocInfo, 0, sizeof( allocInfo ) );
	allocInfo.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
	allocInfo.allocationSize = requirements.size;
	allocInfo.memoryTypeIndex = (uint32_t)memoryType;
	if ( !VK_Check( vkAllocateMemory( vk.device, &allocInfo, NULL, memory ),
	                "vkAllocateMemory" ) )
	{
		vkDestroyBuffer( vk.device, *buffer, NULL );
		*buffer = VK_NULL_HANDLE;
		return qfalse;
	}
	if ( !VK_Check( vkBindBufferMemory( vk.device, *buffer, *memory, 0 ),
	                "vkBindBufferMemory" ) )
	{
		vkFreeMemory( vk.device, *memory, NULL );
		vkDestroyBuffer( vk.device, *buffer, NULL );
		*buffer = VK_NULL_HANDLE;
		*memory = VK_NULL_HANDLE;
		return qfalse;
	}

	if ( mapped && !VK_Check( vkMapMemory( vk.device, *memory, 0, size, 0, mapped ),
	                           "vkMapMemory" ) )
	{
		vkFreeMemory( vk.device, *memory, NULL );
		vkDestroyBuffer( vk.device, *buffer, NULL );
		*buffer = VK_NULL_HANDLE;
		*memory = VK_NULL_HANDLE;
		return qfalse;
	}
	return qtrue;
}

static qboolean VK_CreateImage( uint32_t width, uint32_t height, uint32_t mipLevels,
                                VkFormat format, VkImageUsageFlags usage,
                                VkImage *image, VkDeviceMemory *memory )
{
	VkImageCreateInfo imageInfo;
	VkMemoryRequirements requirements;
	VkMemoryAllocateInfo allocInfo;
	int memoryType;

	Com_Memset( &imageInfo, 0, sizeof( imageInfo ) );
	imageInfo.sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
	imageInfo.imageType = VK_IMAGE_TYPE_2D;
	imageInfo.format = format;
	imageInfo.extent.width = width;
	imageInfo.extent.height = height;
	imageInfo.extent.depth = 1;
	imageInfo.mipLevels = mipLevels;
	imageInfo.arrayLayers = 1;
	imageInfo.samples = VK_SAMPLE_COUNT_1_BIT;
	imageInfo.tiling = VK_IMAGE_TILING_OPTIMAL;
	imageInfo.usage = usage;
	imageInfo.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
	if ( !VK_Check( vkCreateImage( vk.device, &imageInfo, NULL, image ), "vkCreateImage" ) )
	{
		return qfalse;
	}

	vkGetImageMemoryRequirements( vk.device, *image, &requirements );
	memoryType = VK_MemoryType( requirements.memoryTypeBits,
	                            VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT );
	if ( memoryType < 0 )
	{
		vkDestroyImage( vk.device, *image, NULL );
		*image = VK_NULL_HANDLE;
		return qfalse;
	}
	Com_Memset( &allocInfo, 0, sizeof( allocInfo ) );
	allocInfo.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
	allocInfo.allocationSize = requirements.size;
	allocInfo.memoryTypeIndex = (uint32_t)memoryType;
	if ( !VK_Check( vkAllocateMemory( vk.device, &allocInfo, NULL, memory ),
	                "vkAllocateMemory" ) )
	{
		vkDestroyImage( vk.device, *image, NULL );
		*image = VK_NULL_HANDLE;
		return qfalse;
	}
	if ( !VK_Check( vkBindImageMemory( vk.device, *image, *memory, 0 ),
	                "vkBindImageMemory" ) )
	{
		vkFreeMemory( vk.device, *memory, NULL );
		vkDestroyImage( vk.device, *image, NULL );
		*image = VK_NULL_HANDLE;
		*memory = VK_NULL_HANDLE;
		return qfalse;
	}
	return qtrue;
}

static VkImageView VK_CreateImageView( VkImage image, VkFormat format, uint32_t mipLevels,
                                       VkImageAspectFlags aspect )
{
	VkImageViewCreateInfo viewInfo;
	VkImageView view;

	Com_Memset( &viewInfo, 0, sizeof( viewInfo ) );
	viewInfo.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
	viewInfo.image = image;
	viewInfo.viewType = VK_IMAGE_VIEW_TYPE_2D;
	viewInfo.format = format;
	viewInfo.subresourceRange.aspectMask = aspect;
	viewInfo.subresourceRange.baseMipLevel = 0;
	viewInfo.subresourceRange.levelCount = mipLevels;
	viewInfo.subresourceRange.baseArrayLayer = 0;
	viewInfo.subresourceRange.layerCount = 1;
	VK_Check( vkCreateImageView( vk.device, &viewInfo, NULL, &view ), "vkCreateImageView" );
	return view;
}

static void VK_Transition( VkCommandBuffer command, VkImage image,
                           VkImageAspectFlags aspect,
                           VkImageLayout oldLayout, VkImageLayout newLayout,
                           VkAccessFlags srcAccess, VkAccessFlags dstAccess,
                           VkPipelineStageFlags srcStage, VkPipelineStageFlags dstStage,
                           uint32_t baseMip, uint32_t mipCount )
{
	VkImageMemoryBarrier barrier;

	Com_Memset( &barrier, 0, sizeof( barrier ) );
	barrier.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
	barrier.oldLayout = oldLayout;
	barrier.newLayout = newLayout;
	barrier.srcAccessMask = srcAccess;
	barrier.dstAccessMask = dstAccess;
	barrier.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
	barrier.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
	barrier.image = image;
	barrier.subresourceRange.aspectMask = aspect;
	barrier.subresourceRange.baseMipLevel = baseMip;
	barrier.subresourceRange.levelCount = mipCount;
	barrier.subresourceRange.baseArrayLayer = 0;
	barrier.subresourceRange.layerCount = 1;
	vkCmdPipelineBarrier( command, srcStage, dstStage, 0, 0, NULL, 0, NULL, 1, &barrier );
}

/* ------------------------------------------------------------------------ */
/* GLSL -> SPIR-V translation                                                */
/* ------------------------------------------------------------------------ */

static void VK_Append( char **cursor, int *remaining, const char *format, ... )
{
	va_list args;
	int written;

	if ( *remaining <= 1 )
	{
		return;
	}

	va_start( args, format );
	written = Q_vsnprintf( *cursor, *remaining, format, args );
	va_end( args );

	if ( written < 0 )
	{
		written = 0;
	}
	if ( written >= *remaining )
	{
		written = *remaining - 1;
	}
	*cursor += written;
	*remaining -= written;
}

static qboolean VK_IsSampler( const char *type )
{
	return !Q_stricmp( type, "sampler2D" ) || !Q_stricmp( type, "samplerCube" );
}

static int VK_UniformTypeSize( vkUniformType_t type )
{
	switch ( type )
	{
		case VKUNI_FLOAT: return 4;
		case VKUNI_INT:   return 4;
		case VKUNI_VEC2:  return 8;
		case VKUNI_VEC3:  return 12;
		case VKUNI_VEC4:  return 16;
		case VKUNI_MAT4:  return 64;
		case VKUNI_SAMPLER: return 4;
		default:          return 4;
	}
}

static const char *VK_UniformTypeString( vkUniformType_t type )
{
	switch ( type )
	{
		case VKUNI_FLOAT: return "float";
		case VKUNI_INT:   return "int";
		case VKUNI_VEC2:  return "vec2";
		case VKUNI_VEC3:  return "vec3";
		case VKUNI_VEC4:  return "vec4";
		case VKUNI_MAT4:  return "mat4";
		default:          return "int";
	}
}

static vkUniformType_t VK_UniformType( const char *type )
{
	if ( !Q_stricmp( type, "float" ) ) return VKUNI_FLOAT;
	if ( !Q_stricmp( type, "int" ) || !Q_stricmp( type, "bool" ) ) return VKUNI_INT;
	if ( !Q_stricmp( type, "vec2" ) ) return VKUNI_VEC2;
	if ( !Q_stricmp( type, "vec3" ) ) return VKUNI_VEC3;
	if ( !Q_stricmp( type, "vec4" ) ) return VKUNI_VEC4;
	return VKUNI_MAT4;
}

static vkUniform_t *VK_FindUniform( vkProgram_t *program, const char *name )
{
	int i;

	for ( i = 0; i < program->numUniforms; i++ )
	{
		if ( !Q_stricmp( program->uniforms[i].name, name ) )
		{
			return &program->uniforms[i];
		}
	}
	return NULL;
}

static void VK_AddUniform( vkProgram_t *program, const char *name, vkUniformType_t type )
{
	VkDeviceSize offset;
	vkUniform_t *uniform;

	if ( VK_FindUniform( program, name ) )
	{
		return;
	}
	if ( program->numUniforms >= VK_MAX_UNIFORMS )
	{
		ri.Printf( PRINT_ALL, "Vulkan: too many uniforms for %s\n", program->name );
		return;
	}
	offset = ( program->uboSize + 15 ) & ~(VkDeviceSize)15;
	uniform = &program->uniforms[program->numUniforms++];
	Com_Memset( uniform, 0, sizeof( *uniform ) );
	Q_strncpyz( uniform->name, name, sizeof( uniform->name ) );
	uniform->type = type;
	uniform->offset = offset;
	uniform->size = VK_UniformTypeSize( type );
	uniform->sampler = -1;
	program->uboSize = offset + uniform->size;
}

static qboolean VK_ParseUniformLine( const char *line, char *type, int typeSize,
                                     char *name, int nameSize )
{
	char declaration[1024];
	char *semicolon;

	if ( Q_strncmp( line, "uniform ", 8 ) != 0 )
	{
		return qfalse;
	}
	Q_strncpyz( declaration, line + 8, sizeof( declaration ) );
	if ( sscanf( declaration, "%63s %63[^;]", type, name ) < 2 )
	{
		return qfalse;
	}
	if ( ( semicolon = strchr( name, ';' ) ) != NULL )
	{
		*semicolon = 0;
	}
	(void)typeSize;
	(void)nameSize;
	return qtrue;
}

/*
 * Build one program-wide uniform table from both shader stages before either
 * stage is compiled.  Samplers are opaque and get bindings; int/float/vector
 * and matrix uniforms get explicit, 16-byte aligned std140 offsets in the UBO.
 */
static void VK_CollectUniforms( const char *source, vkProgram_t *program )
{
	const char *cursor = source;
	const char *lineEnd;
	char line[1024];
	char type[64], name[64];
	int samplerCount = 0;

	while ( cursor && *cursor )
	{
		lineEnd = strchr( cursor, '\n' );
		if ( lineEnd )
		{
			Q_strncpyz( line, cursor,
			            ( (int)( lineEnd - cursor ) + 1 < (int)sizeof( line ) ) ?
			            (int)( lineEnd - cursor ) + 1 : (int)sizeof( line ) );
			cursor = lineEnd + 1;
		}
		else
		{
			Q_strncpyz( line, cursor, sizeof( line ) );
			cursor = NULL;
		}

		if ( !VK_ParseUniformLine( line, type, sizeof( type ), name, sizeof( name ) ) )
		{
			continue;
		}

		{
			vkUniform_t *uniform = VK_FindUniform( program, name );

			if ( VK_IsSampler( type ) )
			{
				int unit = samplerCount++;

				if ( !Q_strncmp( name, "u_Texture", 9 ) &&
				     name[9] >= '0' && name[9] <= '7' )
				{
					unit = name[9] - '0';
				}
				if ( unit < 0 || unit >= VK_NUM_SAMPLERS )
				{
					unit = VK_NUM_SAMPLERS - 1;
				}
				if ( !uniform && program->numUniforms < VK_MAX_UNIFORMS )
				{
					uniform = &program->uniforms[program->numUniforms++];
					Com_Memset( uniform, 0, sizeof( *uniform ) );
					Q_strncpyz( uniform->name, name, sizeof( uniform->name ) );
					uniform->type = VKUNI_SAMPLER;
					uniform->sampler = -1;
				}
				if ( uniform )
				{
					uniform->type = VKUNI_SAMPLER;
					uniform->size = 0;
					uniform->offset = 0;
					if ( uniform->sampler < 0 )
					{
						uniform->sampler = unit;
					}
				}
			}
			else if ( !uniform && program->numUniforms < VK_MAX_UNIFORMS )
			{
				VkDeviceSize offset = ( program->uboSize + 15 ) & ~(VkDeviceSize)15;

				uniform = &program->uniforms[program->numUniforms++];
				Com_Memset( uniform, 0, sizeof( *uniform ) );
				Q_strncpyz( uniform->name, name, sizeof( uniform->name ) );
				uniform->type = VK_UniformType( type );
				uniform->offset = offset;
				uniform->size = VK_UniformTypeSize( uniform->type );
				uniform->sampler = -1;
				program->uboSize = offset + uniform->size;
			}
		}
	}

	/* Reserve the fixed-function alpha test uniforms for every program so the
	   translated fragment stage can emulate GL_ALPHA_TEST uniformly. */
	VK_AddUniform( program, "u_VKAlphaRef", VKUNI_FLOAT );
	VK_AddUniform( program, "u_VKAlphaFunc", VKUNI_INT );

	program->uboSize = ( program->uboSize + 15 ) & ~(VkDeviceSize)15;
	if ( program->uboSize > sizeof( program->uboData ) )
	{
		program->uboSize = sizeof( program->uboData );
	}
}

static qboolean VK_ValidateUniformLayout( vkProgram_t *program )
{
	int i;

	for ( i = 0; i < program->numUniforms; i++ )
	{
		vkUniform_t *uniform = &program->uniforms[i];

		if ( uniform->type == VKUNI_SAMPLER )
		{
			if ( uniform->sampler < 0 || uniform->sampler >= VK_NUM_SAMPLERS )
			{
				ri.Printf( PRINT_ALL, "Vulkan: invalid sampler binding for %s\n",
				           uniform->name );
				return qfalse;
			}
			continue;
		}
		if ( ( uniform->offset & 15 ) != 0 || uniform->size <= 0 ||
		     uniform->offset + uniform->size > program->uboSize ||
		     program->uboSize > sizeof( program->uboData ) )
		{
			ri.Printf( PRINT_ALL, "Vulkan: invalid UBO offset for %s\n", uniform->name );
			return qfalse;
		}
	}
	return qtrue;
}

static int VK_AlphaTestMode( void )
{
	switch ( vk.alphaFunc )
	{
		case GL_NEVER:    return VK_ALPHA_NEVER;
		case GL_LESS:     return VK_ALPHA_LESS;
		case GL_EQUAL:    return VK_ALPHA_EQUAL;
		case GL_LEQUAL:   return VK_ALPHA_LEQUAL;
		case GL_GREATER:  return VK_ALPHA_GREATER;
		case GL_NOTEQUAL: return VK_ALPHA_NOTEQUAL;
		case GL_GEQUAL:   return VK_ALPHA_GEQUAL;
		default:          return VK_ALPHA_ALWAYS;
	}
}

static void VK_SetAlphaTestUniforms( vkProgram_t *program )
{
	vkUniform_t *uniform;
	float ref = vk.alphaRef;
	int mode = vk.alphaTest ? VK_AlphaTestMode() : VK_ALPHA_DISABLED;

	uniform = VK_FindUniform( program, "u_VKAlphaRef" );
	if ( uniform && uniform->type == VKUNI_FLOAT )
	{
		Com_Memcpy( program->uboData + uniform->offset, &ref, sizeof( ref ) );
	}
	uniform = VK_FindUniform( program, "u_VKAlphaFunc" );
	if ( uniform && uniform->type == VKUNI_INT )
	{
		Com_Memcpy( program->uboData + uniform->offset, &mode, sizeof( mode ) );
	}
}

/*
 * Strip GLSL 1.20 constructs and emit a Vulkan-friendly shader.  The UBO
 * declaration is generated from the complete program table so both stages
 * declare the same block with the same explicit offsets.
 * uniforms are placed in a std140 block (Vulkan requires explicit blocks),
 * samplers get fixed bindings matching the 8 texture units of the renderer.
 * Both shader stages contribute to one program-wide uniform table so the
 * engine's uniform setters work unchanged.
 */
static char *VK_TranslateGLSL( const char *source, qboolean vertexShader,
                               vkProgram_t *program, int *outSize )
{
	const char *cursor = source;
	const char *lineEnd;
	char line[1024];
	char declaration[1024];
	char names[VK_MAX_UNIFORMS][64];
	int nameCount = 0;
	char *result;
	char *resultCursor;
	int resultRemaining;
	int varyingLocation = 0;
	int attributeLocation = 5;
	int braceDepth = 0;
	qboolean inMain = qfalse;
	int pass;
	int i, j;
	char *brace;
	vkUniform_t *uniform;

	result = ri.Malloc( strlen( source ) * 3 + 16384 );
	if ( !result )
	{
		return NULL;
	}
	resultCursor = result;
	resultRemaining = strlen( source ) * 3 + 16384;

	for ( pass = 0; pass < 2; pass++ )
	{
		if ( pass == 0 )
		{
			/* The program-wide table is already complete.  Collect just the
			   names used by this stage for sampler bindings and #defines. */
			cursor = source;
			while ( cursor && *cursor )
			{
				char type[64], name[64];

				lineEnd = strchr( cursor, '\n' );
				if ( lineEnd )
				{
					Q_strncpyz( line, cursor,
					            ( (int)( lineEnd - cursor ) + 1 < (int)sizeof( line ) ) ?
					            (int)( lineEnd - cursor ) + 1 : (int)sizeof( line ) );
					cursor = lineEnd + 1;
				}
				else
				{
					Q_strncpyz( line, cursor, sizeof( line ) );
					cursor = NULL;
				}

				if ( !VK_ParseUniformLine( line, type, sizeof( type ),
				                           name, sizeof( name ) ) )
				{
					continue;
				}
				for ( j = 0; j < nameCount; j++ )
				{
					if ( !Q_stricmp( names[j], name ) )
					{
						break;
					}
				}
				if ( j == nameCount && nameCount < VK_MAX_UNIFORMS )
				{
					Q_strncpyz( names[nameCount++], name, sizeof( names[0] ) );
				}
			}
			resultCursor = result;
			resultRemaining = strlen( source ) * 3 + 16384;
			continue;
		}

		VK_Append( &resultCursor, &resultRemaining,
		           "#version 450 core\n"
		           "#define texture2D texture\n"
		           "#define texture2DProj textureProj\n"
		           "#define textureCube texture\n"
		           "#define texture3D texture\n"
		           "%s"
		           "layout(std140, set=0, binding=0) uniform EngineUniforms {\n",
		           vertexShader ? "#define attribute in\n#define varying out\n"
		                        : "layout(location=0) out vec4 vkFragColor;\n"
		                          "#define gl_FragColor vkFragColor\n"
		                          "#define varying in\n" );

		/* Emit the same block in both stages with exact CPU-side offsets. */
		for ( i = 0; i < program->numUniforms; i++ )
		{
			uniform = &program->uniforms[i];
			if ( uniform->type == VKUNI_SAMPLER )
			{
				continue;
			}
			VK_Append( &resultCursor, &resultRemaining, "\tlayout(offset=%u) %s %s;\n",
			           (unsigned)uniform->offset, VK_UniformTypeString( uniform->type ),
			           uniform->name );
		}
		VK_Append( &resultCursor, &resultRemaining,
		           "} vkUniforms;\n" );

		for ( i = 0; i < nameCount; i++ )
		{
			uniform = VK_FindUniform( program, names[i] );

			if ( !uniform )
			{
				continue;
			}
			if ( uniform->type == VKUNI_SAMPLER )
			{
				VK_Append( &resultCursor, &resultRemaining,
				           "layout(set=0,binding=%d) uniform sampler2D %s;\n",
				           uniform->sampler + 1, names[i] );
			}
			else
			{
				VK_Append( &resultCursor, &resultRemaining,
				           "#define %s vkUniforms.%s\n", names[i], names[i] );
			}
		}

		if ( !vertexShader )
		{
			VK_Append( &resultCursor, &resultRemaining,
			           "bool vkAlphaPass(float a) {\n"
			           "  int mode = vkUniforms.u_VKAlphaFunc;\n"
			           "  if (mode == %d || mode == %d) return true;\n"
			           "  float ref = vkUniforms.u_VKAlphaRef;\n"
			           "  if (mode == %d) return false;\n"
			           "  if (mode == %d) return a < ref;\n"
			           "  if (mode == %d) return a == ref;\n"
			           "  if (mode == %d) return a <= ref;\n"
			           "  if (mode == %d) return a > ref;\n"
			           "  if (mode == %d) return a != ref;\n"
			           "  if (mode == %d) return a >= ref;\n"
			           "  return true;\n"
			           "}\n",
			           VK_ALPHA_DISABLED, VK_ALPHA_ALWAYS, VK_ALPHA_NEVER,
			           VK_ALPHA_LESS, VK_ALPHA_EQUAL, VK_ALPHA_LEQUAL,
			           VK_ALPHA_GREATER, VK_ALPHA_NOTEQUAL, VK_ALPHA_GEQUAL );
		}

		cursor = source;
		while ( cursor && *cursor )
		{
			lineEnd = strchr( cursor, '\n' );
			if ( lineEnd )
			{
				Q_strncpyz( line, cursor,
				            ( (int)( lineEnd - cursor ) + 1 < (int)sizeof( line ) ? (int)( lineEnd - cursor ) + 1 : (int)sizeof( line ) ) );
				cursor = lineEnd + 1;
			}
			else
			{
				Q_strncpyz( line, cursor, sizeof( line ) );
				cursor = NULL;
			}

			if ( Q_strncmp( line, "#version", 8 ) == 0 ||
			     Q_strncmp( line, "precision ", 10 ) == 0 ||
			     Q_strncmp( line, "uniform ", 8 ) == 0 ||
			     strstr( line, "gl_FragData" ) != NULL )
			{
				continue;
			}

			if ( !Q_strncmp( line, "attribute ", 10 ) )
			{
				char type[64], name[64], rewritten[1024];
				char *semicolon;

				Q_strncpyz( declaration, line + 10, sizeof( declaration ) );
				if ( sscanf( declaration, "%63s %63[^;]", type, name ) >= 2 )
				{
					int location;

					if ( ( semicolon = strchr( name, ';' ) ) != NULL )
					{
						*semicolon = 0;
					}
					if ( !Q_stricmp( name, "vertex" ) )
					{
						location = 0;
					}
					else if ( !Q_stricmp( name, "normal" ) )
					{
						location = 1;
					}
					else if ( !Q_stricmp( name, "color" ) )
					{
						location = 2;
					}
					else if ( !Q_stricmp( name, "texcoord" ) )
					{
						location = 3;
					}
					else if ( !Q_stricmp( name, "texcoord1" ) )
					{
						location = 4;
					}
					else
					{
						location = attributeLocation++;
					}
					Q_snprintf( rewritten, sizeof( rewritten ),
					            "layout(location=%d) in %s %s;", location, type, name );
					Q_strncpyz( line, rewritten, sizeof( line ) );
				}
			}
			else if ( !Q_strncmp( line, "varying ", 8 ) )
			{
				char type[64], name[64], rewritten[1024];
				char *semicolon;

				Q_strncpyz( declaration, line + 8, sizeof( declaration ) );
				if ( sscanf( declaration, "%63s %63[^;]", type, name ) >= 2 )
				{
					if ( ( semicolon = strchr( name, ';' ) ) != NULL )
					{
						*semicolon = 0;
					}
					Q_snprintf( rewritten, sizeof( rewritten ),
					            "layout(location=%d) %s %s %s;", varyingLocation++,
					            vertexShader ? "out" : "in", type, name );
					Q_strncpyz( line, rewritten, sizeof( line ) );
				}
			}

			/* Fixed-function vertex attributes are not available in Vulkan. */
			if ( strstr( line, "gl_Vertex" ) || strstr( line, "gl_Normal" ) ||
			     strstr( line, "gl_Color" ) || strstr( line, "gl_MultiTexCoord" ) )
			{
				continue;
			}

			brace = line;
			while ( *brace == ' ' || *brace == '\t' )
			{
				brace++;
			}
			if ( !vertexShader && inMain && braceDepth == 1 && brace[0] == '}' &&
			     brace[1] == '\0' )
			{
				VK_Append( &resultCursor, &resultRemaining,
				           "\tif (!vkAlphaPass(vkFragColor.a)) discard;\n" );
			}
			if ( strstr( line, "main" ) && strstr( line, "(" ) )
			{
				inMain = qtrue;
			}
			for ( brace = line; *brace; brace++ )
			{
				if ( *brace == '{' )
				{
					braceDepth++;
				}
				else if ( *brace == '}' )
				{
					braceDepth--;
				}
			}

			VK_Append( &resultCursor, &resultRemaining, "%s\n", line );
		}
	}

	*outSize = (int)( resultCursor - result );
	return result;
}

static VkShaderModule VK_CompileShader( const char *source, qboolean vertexShader,
                                       vkProgram_t *program )
{
	shaderc_compiler_t compiler;
	shaderc_compilation_result_t result;
	shaderc_compile_options_t options;
	char *translated;
	int translatedSize;
	const uint32_t *words;
	size_t wordCount;
	VkShaderModuleCreateInfo moduleInfo;
	VkShaderModule module = VK_NULL_HANDLE;

	translated = VK_TranslateGLSL( source, vertexShader, program, &translatedSize );
	if ( !translated )
	{
		return VK_NULL_HANDLE;
	}

	compiler = shaderc_compiler_initialize();
	options = shaderc_compile_options_initialize();
	shaderc_compile_options_set_source_language( options, shaderc_source_language_glsl );
	shaderc_compile_options_set_target_env( options, shaderc_target_env_vulkan,
	                                         shaderc_env_version_vulkan_1_0 );
	result = shaderc_compile_into_spv( compiler, translated, (size_t)translatedSize,
	                                   vertexShader ? shaderc_vertex_shader
	                                                : shaderc_fragment_shader,
	                                   "zeq2_shader", "main", options );
	if ( shaderc_result_get_compilation_status( result ) != shaderc_compilation_status_success )
	{
		ri.Printf( PRINT_ALL, "Vulkan shader translation failed:\n%s\n",
		           shaderc_result_get_error_message( result ) );
	}
	else
	{
		words = (const uint32_t *)shaderc_result_get_bytes( result );
		wordCount = shaderc_result_get_length( result ) / sizeof( uint32_t );
		Com_Memset( &moduleInfo, 0, sizeof( moduleInfo ) );
		moduleInfo.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
		moduleInfo.codeSize = wordCount * sizeof( uint32_t );
		moduleInfo.pCode = words;
		VK_Check( vkCreateShaderModule( vk.device, &moduleInfo, NULL, &module ),
		          "vkCreateShaderModule" );
	}

	shaderc_result_release( result );
	shaderc_compile_options_release( options );
	shaderc_compiler_release( compiler );
	ri.Free( translated );
	return module;
}

/* ------------------------------------------------------------------------ */
/* Built-in fallback shaders                                                 */
/* ------------------------------------------------------------------------ */

static const char *vkBuiltinVertexShader =
	"uniform mat4 u_ModelViewProjectionMatrix;\n"
	"uniform vec4 u_ConstantColor;\n"
	"attribute vec3 vertex;\n"
	"attribute vec4 color;\n"
	"attribute vec2 texcoord;\n"
	"attribute vec2 texcoord1;\n"
	"attribute vec3 normal;\n"
	"varying vec4 v_color;\n"
	"varying vec2 v_texcoord;\n"
	"varying vec3 v_normal;\n"
	"void main() {\n"
	"  v_color = color * u_ConstantColor;\n"
	"  v_texcoord = texcoord;\n"
	"  v_normal = normal;\n"
	"  gl_Position = u_ModelViewProjectionMatrix * vec4(vertex, 1.0);\n"
	"}\n";

static const char *vkBuiltinFragmentShader =
	"uniform sampler2D u_Texture0;\n"
	"uniform vec4 u_FogColor;\n"
	"varying vec4 v_color;\n"
	"varying vec2 v_texcoord;\n"
	"varying vec3 v_normal;\n"
	"void main() {\n"
	"  vec4 texel = texture2D(u_Texture0, v_texcoord);\n"
	"  vec4 color = texel * v_color;\n"
	"  float diffuse = 0.75 + 0.25 * max(dot(normalize(v_normal), vec3(0.4, 0.4, 0.82)), 0.0);\n"
	"  gl_FragColor = vec4(color.rgb * diffuse, color.a);\n"
	"}\n";

/* ------------------------------------------------------------------------ */
/* Device, swapchain and frame setup                                         */
/* ------------------------------------------------------------------------ */

static qboolean VK_FindSurfaceFormat( void )
{
	uint32_t count = 0;
	VkSurfaceFormatKHR *formats;
	uint32_t i;

	VK_Check( vkGetPhysicalDeviceSurfaceFormatsKHR( vk.physical, vk.surface, &count, NULL ),
	          "vkGetPhysicalDeviceSurfaceFormatsKHR" );
	if ( count == 0 )
	{
		return qfalse;
	}

	formats = ri.Malloc( count * sizeof( *formats ) );
	if ( !formats )
	{
		return qfalse;
	}
	VK_Check( vkGetPhysicalDeviceSurfaceFormatsKHR( vk.physical, vk.surface, &count, formats ),
	          "vkGetPhysicalDeviceSurfaceFormatsKHR" );

	vk.surfaceFormat = formats[0];
	for ( i = 0; i < count; i++ )
	{
		if ( formats[i].format == VK_FORMAT_B8G8R8A8_SRGB &&
		     formats[i].colorSpace == VK_COLOR_SPACE_SRGB_NONLINEAR_KHR )
		{
			vk.surfaceFormat = formats[i];
			break;
		}
	}
	if ( vk.surfaceFormat.format == VK_FORMAT_UNDEFINED )
	{
		vk.surfaceFormat.format = VK_FORMAT_B8G8R8A8_UNORM;
		vk.surfaceFormat.colorSpace = VK_COLOR_SPACE_SRGB_NONLINEAR_KHR;
	}
	ri.Free( formats );
	return qtrue;
}

static qboolean VK_CreateSwapchain( VkSwapchainKHR oldSwapchain )
{
	VkSurfaceCapabilitiesKHR capabilities;
	VkSwapchainCreateInfoKHR createInfo;
	VkPresentModeKHR presentMode = VK_PRESENT_MODE_FIFO_KHR;
	uint32_t count = 0;
	VkPresentModeKHR *modes;
	uint32_t i;

	if ( !VK_Check( vkGetPhysicalDeviceSurfaceCapabilitiesKHR( vk.physical, vk.surface,
	                                                           &capabilities ),
	                "vkGetPhysicalDeviceSurfaceCapabilitiesKHR" ) )
	{
		return qfalse;
	}

	vk.extent = capabilities.currentExtent;
	if ( vk.extent.width == 0 || vk.extent.height == 0 )
	{
		vk.extent.width = glConfig.vidWidth;
		vk.extent.height = glConfig.vidHeight;
	}
	if ( vk.extent.width < 1 )
	{
		vk.extent.width = 1;
	}
	if ( vk.extent.height < 1 )
	{
		vk.extent.height = 1;
	}

	if ( !VK_Check( vkGetPhysicalDeviceSurfacePresentModesKHR( vk.physical, vk.surface,
	                                                            &count, NULL ),
	                "vkGetPhysicalDeviceSurfacePresentModesKHR" ) )
	{
		return qfalse;
	}
	if ( count > 0 )
	{
		modes = ri.Malloc( count * sizeof( *modes ) );
		if ( modes )
		{
			VK_Check( vkGetPhysicalDeviceSurfacePresentModesKHR( vk.physical, vk.surface,
			                                                    &count, modes ),
			          "vkGetPhysicalDeviceSurfacePresentModesKHR" );
			for ( i = 0; i < count; i++ )
			{
				if ( modes[i] == VK_PRESENT_MODE_MAILBOX_KHR ||
				     modes[i] == VK_PRESENT_MODE_IMMEDIATE_KHR )
				{
					presentMode = modes[i];
					break;
				}
			}
			ri.Free( modes );
		}
	}

	Com_Memset( &createInfo, 0, sizeof( createInfo ) );
	createInfo.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
	createInfo.surface = vk.surface;
	createInfo.minImageCount = capabilities.minImageCount + 1;
	if ( capabilities.maxImageCount > 0 && createInfo.minImageCount > capabilities.maxImageCount )
	{
		createInfo.minImageCount = capabilities.maxImageCount;
	}
	if ( createInfo.minImageCount > VK_MAX_SWAP )
	{
		createInfo.minImageCount = VK_MAX_SWAP;
	}
	createInfo.imageFormat = vk.surfaceFormat.format;
	createInfo.imageColorSpace = vk.surfaceFormat.colorSpace;
	createInfo.imageExtent = vk.extent;
	createInfo.imageArrayLayers = 1;
	createInfo.imageUsage = VK_IMAGE_USAGE_TRANSFER_DST_BIT;
	createInfo.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
	createInfo.preTransform = capabilities.currentTransform;
	createInfo.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
	createInfo.presentMode = presentMode;
	createInfo.clipped = VK_TRUE;
	createInfo.oldSwapchain = oldSwapchain;
	if ( !VK_Check( vkCreateSwapchainKHR( vk.device, &createInfo, NULL, &vk.swapchain ),
	                "vkCreateSwapchainKHR" ) || vk.swapchain == VK_NULL_HANDLE )
	{
		return qfalse;
	}

	vk.numSwapImages = 0;
	if ( !VK_Check( vkGetSwapchainImagesKHR( vk.device, vk.swapchain, &vk.numSwapImages, NULL ),
	                "vkGetSwapchainImagesKHR" ) || vk.numSwapImages == 0 )
	{
		return qfalse;
	}
	if ( vk.numSwapImages > VK_MAX_SWAP )
	{
		vk.numSwapImages = VK_MAX_SWAP;
	}
	if ( !VK_Check( vkGetSwapchainImagesKHR( vk.device, vk.swapchain, &vk.numSwapImages,
	                                          vk.swapImages ), "vkGetSwapchainImagesKHR" ) )
	{
		return qfalse;
	}
	for ( i = 0; i < vk.numSwapImages; i++ )
	{
		vk.swapViews[i] = VK_CreateImageView( vk.swapImages[i], vk.surfaceFormat.format,
		                                     1, VK_IMAGE_ASPECT_COLOR_BIT );
		if ( vk.swapViews[i] == VK_NULL_HANDLE )
		{
			return qfalse;
		}
	}
	return qtrue;
}

static void VK_DestroySwapchain( void )
{
	uint32_t i;

	if ( vk.swapchain != VK_NULL_HANDLE )
	{
		for ( i = 0; i < vk.numSwapImages; i++ )
		{
			if ( vk.swapViews[i] != VK_NULL_HANDLE )
			{
				vkDestroyImageView( vk.device, vk.swapViews[i], NULL );
				vk.swapViews[i] = VK_NULL_HANDLE;
			}
		}
		vkDestroySwapchainKHR( vk.device, vk.swapchain, NULL );
		vk.swapchain = VK_NULL_HANDLE;
		vk.numSwapImages = 0;
	}
}

static qboolean VK_CreateAttachments( void )
{
	if ( !VK_CreateImage( vk.extent.width, vk.extent.height, 1, VK_FORMAT_R8G8B8A8_UNORM,
	                      VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT | VK_IMAGE_USAGE_TRANSFER_SRC_BIT |
	                      VK_IMAGE_USAGE_TRANSFER_DST_BIT | VK_IMAGE_USAGE_SAMPLED_BIT,
	                      &vk.colorImage, &vk.colorMemory ) )
	{
		return qfalse;
	}
	vk.colorView = VK_CreateImageView( vk.colorImage, VK_FORMAT_R8G8B8A8_UNORM, 1,
	                                   VK_IMAGE_ASPECT_COLOR_BIT );
	if ( vk.colorView == VK_NULL_HANDLE )
	{
		return qfalse;
	}

	if ( !VK_CreateImage( vk.extent.width, vk.extent.height, 1, VK_FORMAT_D32_SFLOAT,
	                      VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT |
	                      VK_IMAGE_USAGE_TRANSFER_SRC_BIT,
	                      &vk.depthImage, &vk.depthMemory ) )
	{
		return qfalse;
	}
	vk.depthView = VK_CreateImageView( vk.depthImage, VK_FORMAT_D32_SFLOAT, 1,
	                                   VK_IMAGE_ASPECT_DEPTH_BIT );
	return vk.depthView != VK_NULL_HANDLE ? qtrue : qfalse;
}

static void VK_DestroyAttachments( void )
{
	if ( vk.colorView != VK_NULL_HANDLE )
	{
		vkDestroyImageView( vk.device, vk.colorView, NULL );
		vk.colorView = VK_NULL_HANDLE;
	}
	if ( vk.colorImage != VK_NULL_HANDLE )
	{
		vkDestroyImage( vk.device, vk.colorImage, NULL );
		vkFreeMemory( vk.device, vk.colorMemory, NULL );
		vk.colorImage = VK_NULL_HANDLE;
		vk.colorMemory = VK_NULL_HANDLE;
	}
	if ( vk.depthView != VK_NULL_HANDLE )
	{
		vkDestroyImageView( vk.device, vk.depthView, NULL );
		vk.depthView = VK_NULL_HANDLE;
	}
	if ( vk.depthImage != VK_NULL_HANDLE )
	{
		vkDestroyImage( vk.device, vk.depthImage, NULL );
		vkFreeMemory( vk.device, vk.depthMemory, NULL );
		vk.depthImage = VK_NULL_HANDLE;
		vk.depthMemory = VK_NULL_HANDLE;
	}
}

static qboolean VK_CreateRenderPass( void )
{
	VkAttachmentDescription attachments[2];
	VkAttachmentReference colorRef, depthRef;
	VkSubpassDescription subpass;
	VkRenderPassCreateInfo passInfo;
	VkFramebufferCreateInfo frameInfo;

	Com_Memset( attachments, 0, sizeof( attachments ) );
	attachments[0].format = VK_FORMAT_R8G8B8A8_UNORM;
	attachments[0].samples = VK_SAMPLE_COUNT_1_BIT;
	attachments[0].loadOp = VK_ATTACHMENT_LOAD_OP_LOAD;
	attachments[0].storeOp = VK_ATTACHMENT_STORE_OP_STORE;
	attachments[0].initialLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
	attachments[0].finalLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

	attachments[1].format = VK_FORMAT_D32_SFLOAT;
	attachments[1].samples = VK_SAMPLE_COUNT_1_BIT;
	attachments[1].loadOp = VK_ATTACHMENT_LOAD_OP_LOAD;
	attachments[1].storeOp = VK_ATTACHMENT_STORE_OP_STORE;
	attachments[1].initialLayout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
	attachments[1].finalLayout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

	colorRef.attachment = 0;
	colorRef.layout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
	depthRef.attachment = 1;
	depthRef.layout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

	Com_Memset( &subpass, 0, sizeof( subpass ) );
	subpass.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS;
	subpass.colorAttachmentCount = 1;
	subpass.pColorAttachments = &colorRef;
	subpass.pDepthStencilAttachment = &depthRef;

	Com_Memset( &passInfo, 0, sizeof( passInfo ) );
	passInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
	passInfo.attachmentCount = 2;
	passInfo.pAttachments = attachments;
	passInfo.subpassCount = 1;
	passInfo.pSubpasses = &subpass;
	if ( !VK_Check( vkCreateRenderPass( vk.device, &passInfo, NULL, &vk.renderPass ),
	                "vkCreateRenderPass" ) )
	{
		return qfalse;
	}

	{
		VkImageView views[2] = { vk.colorView, vk.depthView };
		Com_Memset( &frameInfo, 0, sizeof( frameInfo ) );
		frameInfo.sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
		frameInfo.renderPass = vk.renderPass;
		frameInfo.attachmentCount = 2;
		frameInfo.pAttachments = views;
		frameInfo.width = vk.extent.width;
		frameInfo.height = vk.extent.height;
		frameInfo.layers = 1;
		if ( !VK_Check( vkCreateFramebuffer( vk.device, &frameInfo, NULL, &vk.framebuffer ),
		                "vkCreateFramebuffer" ) )
		{
			return qfalse;
		}
	}
	return qtrue;
}

static qboolean VK_CreateDescriptors( void )
{
	VkDescriptorSetLayoutBinding bindings[VK_NUM_SAMPLERS + 1];
	VkDescriptorSetLayoutCreateInfo layoutInfo;
	VkDescriptorPoolSize poolSizes[2];
	VkDescriptorPoolCreateInfo poolInfo;
	VkPushConstantRange pushRange;
	VkPipelineLayoutCreateInfo layoutCreateInfo;
	VkSamplerCreateInfo samplerInfo;
	int i;

	Com_Memset( bindings, 0, sizeof( bindings ) );
	bindings[0].binding = 0;
	bindings[0].descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC;
	bindings[0].descriptorCount = 1;
	bindings[0].stageFlags = VK_SHADER_STAGE_VERTEX_BIT | VK_SHADER_STAGE_FRAGMENT_BIT;
	for ( i = 0; i < VK_NUM_SAMPLERS; i++ )
	{
		bindings[i + 1].binding = i + 1;
		bindings[i + 1].descriptorType = VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
		bindings[i + 1].descriptorCount = 1;
		bindings[i + 1].stageFlags = VK_SHADER_STAGE_FRAGMENT_BIT;
	}

	Com_Memset( &layoutInfo, 0, sizeof( layoutInfo ) );
	layoutInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
	layoutInfo.bindingCount = ARRAY_LEN( bindings );
	layoutInfo.pBindings = bindings;
	if ( !VK_Check( vkCreateDescriptorSetLayout( vk.device, &layoutInfo, NULL,
	                                              &vk.descriptorLayout ),
	                "vkCreateDescriptorSetLayout" ) )
	{
		return qfalse;
	}

	poolSizes[0].type = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC;
	poolSizes[0].descriptorCount = ARRAY_LEN( vk.descriptorSets );
	poolSizes[1].type = VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
	poolSizes[1].descriptorCount = ARRAY_LEN( vk.descriptorSets ) * VK_NUM_SAMPLERS;
	Com_Memset( &poolInfo, 0, sizeof( poolInfo ) );
	poolInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
	poolInfo.flags = VK_DESCRIPTOR_POOL_CREATE_FREE_DESCRIPTOR_SET_BIT;
	poolInfo.maxSets = ARRAY_LEN( vk.descriptorSets );
	poolInfo.poolSizeCount = 2;
	poolInfo.pPoolSizes = poolSizes;
	if ( !VK_Check( vkCreateDescriptorPool( vk.device, &poolInfo, NULL, &vk.descriptorPool ),
	                "vkCreateDescriptorPool" ) )
	{
		return qfalse;
	}

	Com_Memset( &pushRange, 0, sizeof( pushRange ) );
	pushRange.size = sizeof( float ) * 4; /* tint, reserved for future use */
	pushRange.stageFlags = VK_SHADER_STAGE_FRAGMENT_BIT;
	Com_Memset( &layoutCreateInfo, 0, sizeof( layoutCreateInfo ) );
	layoutCreateInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
	layoutCreateInfo.setLayoutCount = 1;
	layoutCreateInfo.pSetLayouts = &vk.descriptorLayout;
	layoutCreateInfo.pushConstantRangeCount = 1;
	layoutCreateInfo.pPushConstantRanges = &pushRange;
	if ( !VK_Check( vkCreatePipelineLayout( vk.device, &layoutCreateInfo, NULL,
	                                         &vk.pipelineLayout ),
	                "vkCreatePipelineLayout" ) )
	{
		return qfalse;
	}

	Com_Memset( &samplerInfo, 0, sizeof( samplerInfo ) );
	samplerInfo.sType = VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
	samplerInfo.magFilter = VK_FILTER_LINEAR;
	samplerInfo.minFilter = VK_FILTER_LINEAR;
	samplerInfo.mipmapMode = VK_SAMPLER_MIPMAP_MODE_LINEAR;
	samplerInfo.addressModeU = VK_SAMPLER_ADDRESS_MODE_REPEAT;
	samplerInfo.addressModeV = VK_SAMPLER_ADDRESS_MODE_REPEAT;
	samplerInfo.addressModeW = VK_SAMPLER_ADDRESS_MODE_REPEAT;
	for ( i = 0; i < ARRAY_LEN( vk.samplers ); i++ )
	{
		/* Bit 4 selects the mipmapped variant; textures with only level 0
		   uploaded use maxLod 0 so uninitialized levels are never sampled. */
		samplerInfo.maxLod = ( i & 4 ) ? 16.0f : 0.0f;
		if ( i & 1 )
		{
			samplerInfo.magFilter = VK_FILTER_NEAREST;
			samplerInfo.minFilter = VK_FILTER_NEAREST;
			samplerInfo.mipmapMode = VK_SAMPLER_MIPMAP_MODE_NEAREST;
		}
		else
		{
			samplerInfo.magFilter = VK_FILTER_LINEAR;
			samplerInfo.minFilter = VK_FILTER_LINEAR;
			samplerInfo.mipmapMode = VK_SAMPLER_MIPMAP_MODE_LINEAR;
		}
		if ( i & 2 )
		{
			samplerInfo.addressModeU = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE;
			samplerInfo.addressModeV = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE;
			samplerInfo.addressModeW = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE;
		}
		else
		{
			samplerInfo.addressModeU = VK_SAMPLER_ADDRESS_MODE_REPEAT;
			samplerInfo.addressModeV = VK_SAMPLER_ADDRESS_MODE_REPEAT;
			samplerInfo.addressModeW = VK_SAMPLER_ADDRESS_MODE_REPEAT;
		}
		if ( !VK_Check( vkCreateSampler( vk.device, &samplerInfo, NULL, &vk.samplers[i] ),
		                "vkCreateSampler" ) )
		{
			return qfalse;
		}
	}
	return qtrue;
}

static qboolean VK_CreateCommandResources( void )
{
	VkCommandPoolCreateInfo poolInfo;
	VkCommandBufferAllocateInfo bufferInfo;
	VkFenceCreateInfo fenceInfo;
	VkSemaphoreCreateInfo semaphoreInfo;

	Com_Memset( &poolInfo, 0, sizeof( poolInfo ) );
	poolInfo.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
	poolInfo.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
	poolInfo.queueFamilyIndex = vk.queueFamily;
	if ( !VK_Check( vkCreateCommandPool( vk.device, &poolInfo, NULL, &vk.commandPool ),
	                "vkCreateCommandPool" ) )
	{
		return qfalse;
	}
	vk.transientPool = vk.commandPool;

	Com_Memset( &bufferInfo, 0, sizeof( bufferInfo ) );
	bufferInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
	bufferInfo.commandPool = vk.commandPool;
	bufferInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
	bufferInfo.commandBufferCount = 1;
	if ( !VK_Check( vkAllocateCommandBuffers( vk.device, &bufferInfo, &vk.commandBuffer ),
	                "vkAllocateCommandBuffers" ) ||
	     !VK_Check( vkAllocateCommandBuffers( vk.device, &bufferInfo, &vk.transientCommand ),
	                "vkAllocateCommandBuffers" ) )
	{
		return qfalse;
	}

	Com_Memset( &fenceInfo, 0, sizeof( fenceInfo ) );
	fenceInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
	fenceInfo.flags = VK_FENCE_CREATE_SIGNALED_BIT;
	if ( !VK_Check( vkCreateFence( vk.device, &fenceInfo, NULL, &vk.fence ),
	                "vkCreateFence" ) )
	{
		return qfalse;
	}

	Com_Memset( &semaphoreInfo, 0, sizeof( semaphoreInfo ) );
	semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
	if ( !VK_Check( vkCreateSemaphore( vk.device, &semaphoreInfo, NULL, &vk.imageAvailable ),
	                "vkCreateSemaphore" ) ||
	     !VK_Check( vkCreateSemaphore( vk.device, &semaphoreInfo, NULL, &vk.renderFinished ),
	                "vkCreateSemaphore" ) )
	{
		return qfalse;
	}
	return qtrue;
}

static void VK_BeginRenderPass( void )
{
	VkCommandBufferBeginInfo beginInfo;
	VkRenderPassBeginInfo passInfo;
	VkClearValue clearValues[2];

	Com_Memset( &beginInfo, 0, sizeof( beginInfo ) );
	beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
	beginInfo.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
	if ( !VK_Check( vkBeginCommandBuffer( vk.commandBuffer, &beginInfo ),
	                "vkBeginCommandBuffer" ) )
	{
		return;
	}
	vk.recording = qtrue;

	Com_Memset( &passInfo, 0, sizeof( passInfo ) );
	passInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
	passInfo.renderPass = vk.renderPass;
	passInfo.framebuffer = vk.framebuffer;
	passInfo.renderArea.offset.x = 0;
	passInfo.renderArea.offset.y = 0;
	passInfo.renderArea.extent = vk.extent;
	passInfo.clearValueCount = 2;
	passInfo.pClearValues = clearValues;
	clearValues[0].color.float32[0] = 0.0f;
	clearValues[0].color.float32[1] = 0.0f;
	clearValues[0].color.float32[2] = 0.0f;
	clearValues[0].color.float32[3] = 1.0f;
	clearValues[1].depthStencil.depth = 1.0f;
	clearValues[1].depthStencil.stencil = 0;

	vkCmdBeginRenderPass( vk.commandBuffer, &passInfo, VK_SUBPASS_CONTENTS_INLINE );
	vk.inRenderPass = qtrue;
}

static void VK_InvalidateAllPipelines( void );

static qboolean VK_RecreateSwapchain( void )
{
	VkSwapchainKHR oldSwapchain = vk.swapchain;
	uint32_t i;

	if ( !vk.device || !vk.surface )
	{
		return qfalse;
	}

	if ( vk.inRenderPass )
	{
		vkCmdEndRenderPass( vk.commandBuffer );
		vk.inRenderPass = qfalse;
	}
	if ( vk.recording )
	{
		VK_Check( vkEndCommandBuffer( vk.commandBuffer ), "vkEndCommandBuffer" );
		vk.recording = qfalse;
	}
	VK_Check( vkDeviceWaitIdle( vk.device ), "vkDeviceWaitIdle" );

	for ( i = 0; i < vk.numSwapImages; i++ )
	{
		if ( vk.swapViews[i] != VK_NULL_HANDLE )
		{
			vkDestroyImageView( vk.device, vk.swapViews[i], NULL );
			vk.swapViews[i] = VK_NULL_HANDLE;
		}
	}
	vk.numSwapImages = 0;
	vk.swapchain = VK_NULL_HANDLE;

	if ( vk.framebuffer != VK_NULL_HANDLE )
	{
		vkDestroyFramebuffer( vk.device, vk.framebuffer, NULL );
		vk.framebuffer = VK_NULL_HANDLE;
	}
	if ( vk.renderPass != VK_NULL_HANDLE )
	{
		vkDestroyRenderPass( vk.device, vk.renderPass, NULL );
		vk.renderPass = VK_NULL_HANDLE;
	}
	VK_DestroyAttachments();
	VK_InvalidateAllPipelines();

	if ( !VK_CreateSwapchain( oldSwapchain ) )
	{
		if ( vk.swapchain != VK_NULL_HANDLE )
		{
			vkDestroySwapchainKHR( vk.device, vk.swapchain, NULL );
			vk.swapchain = VK_NULL_HANDLE;
		}
		if ( oldSwapchain != VK_NULL_HANDLE )
		{
			vkDestroySwapchainKHR( vk.device, oldSwapchain, NULL );
		}
		return qfalse;
	}
	if ( oldSwapchain != VK_NULL_HANDLE )
	{
		vkDestroySwapchainKHR( vk.device, oldSwapchain, NULL );
	}

	if ( !VK_CreateAttachments() || !VK_CreateRenderPass() )
	{
		return qfalse;
	}
	VK_BeginRenderPass();
	return qtrue;
}

/* ------------------------------------------------------------------------ */
/* Pipelines and drawing                                                     */
/* ------------------------------------------------------------------------ */

static VkBlendFactor VK_BlendFactor( int glFactor )
{
	switch ( glFactor )
	{
		case GL_SRC_ALPHA:           return VK_BLEND_FACTOR_SRC_ALPHA;
		case GL_ONE_MINUS_SRC_ALPHA: return VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA;
		case GL_DST_COLOR:           return VK_BLEND_FACTOR_DST_COLOR;
		case GL_ONE_MINUS_DST_COLOR: return VK_BLEND_FACTOR_ONE_MINUS_DST_COLOR;
		case GL_DST_ALPHA:           return VK_BLEND_FACTOR_DST_ALPHA;
		case GL_ONE_MINUS_DST_ALPHA: return VK_BLEND_FACTOR_ONE_MINUS_DST_ALPHA;
		case GL_SRC_COLOR:           return VK_BLEND_FACTOR_SRC_COLOR;
		case GL_ZERO:                return VK_BLEND_FACTOR_ZERO;
		default:                     return VK_BLEND_FACTOR_ONE;
	}
}

static VkCompareOp VK_CompareOp( int glFunc )
{
	switch ( glFunc )
	{
		case GL_LESS:     return VK_COMPARE_OP_LESS;
		case GL_EQUAL:    return VK_COMPARE_OP_EQUAL;
		case GL_LEQUAL:   return VK_COMPARE_OP_LESS_OR_EQUAL;
		case GL_GREATER:  return VK_COMPARE_OP_GREATER;
		case GL_NOTEQUAL: return VK_COMPARE_OP_NOT_EQUAL;
		case GL_GEQUAL:   return VK_COMPARE_OP_GREATER_OR_EQUAL;
		case GL_ALWAYS:   return VK_COMPARE_OP_ALWAYS;
		default:          return VK_COMPARE_OP_NEVER;
	}
}

static VkCullModeFlags VK_CullMode( void )
{
	if ( !vk.cullFace )
	{
		return VK_CULL_MODE_NONE;
	}
	switch ( vk.cullMode )
	{
		case GL_FRONT:         return VK_CULL_MODE_FRONT_BIT;
		case GL_FRONT_AND_BACK: return VK_CULL_MODE_FRONT_AND_BACK;
		case GL_BACK:
		default:               return VK_CULL_MODE_BACK_BIT;
	}
}

static VkPipeline VK_GetPipeline( vkProgram_t *program, VkPrimitiveTopology topology,
                                  qboolean blend, qboolean depthTest, qboolean depthWrite,
                                  VkCullModeFlags cullMode )
{
	VkVertexInputBindingDescription binding;
	VkVertexInputAttributeDescription attributes[5];
	VkPipelineVertexInputStateCreateInfo vertexInput;
	VkPipelineInputAssemblyStateCreateInfo inputAssembly;
	VkPipelineViewportStateCreateInfo viewportState;
	VkPipelineRasterizationStateCreateInfo rasterization;
	VkPipelineMultisampleStateCreateInfo multisample;
	VkPipelineDepthStencilStateCreateInfo depthStencil;
	VkPipelineColorBlendAttachmentState colorBlendAttachment;
	VkPipelineColorBlendStateCreateInfo colorBlend;
	VkDynamicState dynamicStates[5];
	VkPipelineDynamicStateCreateInfo dynamicState;
	VkGraphicsPipelineCreateInfo pipelineInfo;
	VkPipeline pipeline = VK_NULL_HANDLE;
	int i;

	if ( !program || !program->valid || program->vertexModule == VK_NULL_HANDLE ||
	     program->fragmentModule == VK_NULL_HANDLE )
	{
		return VK_NULL_HANDLE;
	}

	for ( i = 0; i < vk.numPipelines; i++ )
	{
		vkPipeline_t *cached = &vk.pipelines[i];
		if ( cached->program == program && cached->generation == program->generation &&
		     cached->topology == topology && cached->blend == blend &&
		     cached->depthTest == depthTest && cached->depthWrite == depthWrite &&
		     cached->cullMode == cullMode && cached->blendSrc == vk.blendSrc &&
		     cached->blendDst == vk.blendDst && cached->depthFunc == vk.depthFunc &&
		     cached->frontFace == vk.frontFace && cached->polygonMode == vk.polygonMode &&
		     cached->colorMask == vk.colorMask &&
		     cached->polygonOffset == vk.polygonOffset )
		{
			cached->used++;
			return cached->pipeline;
		}
	}

	Com_Memset( &binding, 0, sizeof( binding ) );
	binding.binding = 0;
	binding.stride = sizeof( vkVertex_t );
	binding.inputRate = VK_VERTEX_INPUT_RATE_VERTEX;

	Com_Memset( attributes, 0, sizeof( attributes ) );
	attributes[0].location = 0;
	attributes[0].format = VK_FORMAT_R32G32B32_SFLOAT;
	attributes[0].offset = offsetof( vkVertex_t, xyz );
	attributes[1].location = 1;
	attributes[1].format = VK_FORMAT_R32G32B32_SFLOAT;
	attributes[1].offset = offsetof( vkVertex_t, normal );
	attributes[2].location = 2;
	attributes[2].format = VK_FORMAT_R32G32B32A32_SFLOAT;
	attributes[2].offset = offsetof( vkVertex_t, color );
	attributes[3].location = 3;
	attributes[3].format = VK_FORMAT_R32G32_SFLOAT;
	attributes[3].offset = offsetof( vkVertex_t, tc0 );
	attributes[4].location = 4;
	attributes[4].format = VK_FORMAT_R32G32_SFLOAT;
	attributes[4].offset = offsetof( vkVertex_t, tc1 );

	Com_Memset( &vertexInput, 0, sizeof( vertexInput ) );
	vertexInput.sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
	vertexInput.vertexBindingDescriptionCount = 1;
	vertexInput.pVertexBindingDescriptions = &binding;
	vertexInput.vertexAttributeDescriptionCount = ARRAY_LEN( attributes );
	vertexInput.pVertexAttributeDescriptions = attributes;

	Com_Memset( &inputAssembly, 0, sizeof( inputAssembly ) );
	inputAssembly.sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
	inputAssembly.topology = topology;
	inputAssembly.primitiveRestartEnable = VK_FALSE;

	dynamicStates[0] = VK_DYNAMIC_STATE_VIEWPORT;
	dynamicStates[1] = VK_DYNAMIC_STATE_SCISSOR;
	dynamicStates[2] = VK_DYNAMIC_STATE_LINE_WIDTH;
	dynamicStates[3] = VK_DYNAMIC_STATE_BLEND_CONSTANTS;
	dynamicStates[4] = VK_DYNAMIC_STATE_DEPTH_BIAS;
	Com_Memset( &viewportState, 0, sizeof( viewportState ) );
	viewportState.sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
	viewportState.viewportCount = 1;
	viewportState.scissorCount = 1;

	Com_Memset( &rasterization, 0, sizeof( rasterization ) );
	rasterization.sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
	rasterization.depthClampEnable = VK_FALSE;
	rasterization.rasterizerDiscardEnable = VK_FALSE;
	rasterization.polygonMode = vk.polygonMode == GL_LINE ? VK_POLYGON_MODE_LINE
	                                                      : VK_POLYGON_MODE_FILL;
	rasterization.cullMode = cullMode;
	rasterization.frontFace = vk.frontFace == GL_CW ? VK_FRONT_FACE_CLOCKWISE
	                                                 : VK_FRONT_FACE_COUNTER_CLOCKWISE;
	rasterization.depthBiasEnable = vk.polygonOffset ? VK_TRUE : VK_FALSE;
	rasterization.lineWidth = 1.0f;

	Com_Memset( &multisample, 0, sizeof( multisample ) );
	multisample.sType = VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
	multisample.rasterizationSamples = VK_SAMPLE_COUNT_1_BIT;

	Com_Memset( &depthStencil, 0, sizeof( depthStencil ) );
	depthStencil.sType = VK_STRUCTURE_TYPE_PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO;
	depthStencil.depthTestEnable = depthTest ? VK_TRUE : VK_FALSE;
	depthStencil.depthWriteEnable = depthWrite ? VK_TRUE : VK_FALSE;
	depthStencil.depthCompareOp = depthTest ? VK_CompareOp( vk.depthFunc )
	                                        : VK_COMPARE_OP_ALWAYS;
	depthStencil.depthBoundsTestEnable = VK_FALSE;
	depthStencil.stencilTestEnable = VK_FALSE;

	Com_Memset( &colorBlendAttachment, 0, sizeof( colorBlendAttachment ) );
	colorBlendAttachment.colorWriteMask = vk.colorMask;
	colorBlendAttachment.blendEnable = blend ? VK_TRUE : VK_FALSE;
	colorBlendAttachment.srcColorBlendFactor = VK_BlendFactor( vk.blendSrc );
	colorBlendAttachment.dstColorBlendFactor = VK_BlendFactor( vk.blendDst );
	colorBlendAttachment.colorBlendOp = VK_BLEND_OP_ADD;
	colorBlendAttachment.srcAlphaBlendFactor = VK_BlendFactor( vk.blendSrc );
	colorBlendAttachment.dstAlphaBlendFactor = VK_BlendFactor( vk.blendDst );
	colorBlendAttachment.alphaBlendOp = VK_BLEND_OP_ADD;

	Com_Memset( &colorBlend, 0, sizeof( colorBlend ) );
	colorBlend.sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
	colorBlend.logicOpEnable = VK_FALSE;
	colorBlend.attachmentCount = 1;
	colorBlend.pAttachments = &colorBlendAttachment;

	Com_Memset( &dynamicState, 0, sizeof( dynamicState ) );
	dynamicState.sType = VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO;
	dynamicState.dynamicStateCount = ARRAY_LEN( dynamicStates );
	dynamicState.pDynamicStates = dynamicStates;

	Com_Memset( &pipelineInfo, 0, sizeof( pipelineInfo ) );
	pipelineInfo.sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
	pipelineInfo.stageCount = 2;
	{
		VkPipelineShaderStageCreateInfo stages[2];
		Com_Memset( stages, 0, sizeof( stages ) );
		stages[0].sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
		stages[0].stage = VK_SHADER_STAGE_VERTEX_BIT;
		stages[0].module = program->vertexModule;
		stages[0].pName = "main";
		stages[1].sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
		stages[1].stage = VK_SHADER_STAGE_FRAGMENT_BIT;
		stages[1].module = program->fragmentModule;
		stages[1].pName = "main";
		pipelineInfo.pStages = stages;

		pipelineInfo.pVertexInputState = &vertexInput;
		pipelineInfo.pInputAssemblyState = &inputAssembly;
		pipelineInfo.pViewportState = &viewportState;
		pipelineInfo.pRasterizationState = &rasterization;
		pipelineInfo.pMultisampleState = &multisample;
		pipelineInfo.pDepthStencilState = &depthStencil;
		pipelineInfo.pColorBlendState = &colorBlend;
		pipelineInfo.pDynamicState = &dynamicState;
		pipelineInfo.layout = vk.pipelineLayout;
		pipelineInfo.renderPass = vk.renderPass;
		pipelineInfo.subpass = 0;

		if ( !VK_Check( vkCreateGraphicsPipelines( vk.device, VK_NULL_HANDLE, 1,
		                                           &pipelineInfo, NULL, &pipeline ),
		                "vkCreateGraphicsPipelines" ) )
		{
			return VK_NULL_HANDLE;
		}
	}

	if ( vk.numPipelines < VK_MAX_PIPELINES )
	{
		vkPipeline_t *cached = &vk.pipelines[vk.numPipelines++];
		cached->program = program;
		cached->pipeline = pipeline;
		cached->topology = topology;
		cached->generation = program->generation;
		cached->blend = blend;
		cached->depthTest = depthTest;
		cached->depthWrite = depthWrite;
		cached->cullMode = cullMode;
		cached->blendSrc = vk.blendSrc;
		cached->blendDst = vk.blendDst;
		cached->depthFunc = vk.depthFunc;
		cached->frontFace = vk.frontFace;
		cached->polygonMode = vk.polygonMode;
		cached->colorMask = vk.colorMask;
		cached->polygonOffset = vk.polygonOffset;
		cached->used = 1;
	}
	return pipeline;
}

static void VK_SetViewportState( void )
{
	VkViewport viewport;
	VkRect2D scissor;
	int x = vk.viewport[0];
	int y = vk.viewport[1];
	int width = vk.viewport[2];
	int height = vk.viewport[3];

	if ( width <= 0 )
	{
		width = vk.extent.width;
	}
	if ( height <= 0 )
	{
		height = vk.extent.height;
	}

	viewport.x = (float)x;
	viewport.y = (float)( vk.extent.height - y - height );
	viewport.width = (float)width;
	viewport.height = (float)height;
	viewport.minDepth = 0.0f;
	viewport.maxDepth = 1.0f;

	if ( vk.scissorEnabled )
	{
		scissor.offset.x = vk.scissor[0];
		scissor.offset.y = vk.extent.height - vk.scissor[1] - vk.scissor[3];
		scissor.extent.width = vk.scissor[2];
		scissor.extent.height = vk.scissor[3];
	}
	else
	{
		scissor.offset.x = 0;
		scissor.offset.y = 0;
		scissor.extent.width = vk.extent.width;
		scissor.extent.height = vk.extent.height;
	}
	vkCmdSetViewport( vk.commandBuffer, 0, 1, &viewport );
	vkCmdSetScissor( vk.commandBuffer, 0, 1, &scissor );
	vkCmdSetLineWidth( vk.commandBuffer, vk.lineWidth > 0.0f ? vk.lineWidth : 1.0f );
	vkCmdSetDepthBias( vk.commandBuffer,
	                   vk.polygonOffset ? vk.polygonOffsetUnits : 0.0f,
	                   0.0f,
	                   vk.polygonOffset ? vk.polygonOffsetFactor : 0.0f );
}

static VkPrimitiveTopology VK_Topology( int glMode )
{
	switch ( glMode )
	{
		case GL_LINES:           return VK_PRIMITIVE_TOPOLOGY_LINE_LIST;
		case GL_LINE_STRIP:      return VK_PRIMITIVE_TOPOLOGY_LINE_STRIP;
		case GL_TRIANGLE_STRIP:  return VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP;
		case GL_POINTS:          return VK_PRIMITIVE_TOPOLOGY_POINT_LIST;
		default:                 return VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;
	}
}

/*
 * Vulkan has no triangle fan, quad or quad strip topology.  Convert those
 * GL primitives into triangle lists while keeping winding order intact.
 * Triangle strips need no expansion: Vulkan uses the same (n, n+1, n+2)
 * winding as OpenGL, so they are passed straight through.
 */
static int VK_ConvertVertices( const vkVertex_t *source, int count, int glMode,
                               vkVertex_t **destination )
{
	vkVertex_t *output;
	int i, out = 0;

	if ( glMode == GL_TRIANGLE_FAN )
	{
		if ( count < 3 )
		{
			return 0;
		}
		output = ri.Malloc( (count - 2) * 3 * sizeof( vkVertex_t ) );
		if ( !output )
		{
			return 0;
		}
		for ( i = 1; i < count - 1; i++ )
		{
			output[out++] = source[0];
			output[out++] = source[i];
			output[out++] = source[i + 1];
		}
	}
	else if ( glMode == GL_QUADS )
	{
		output = ri.Malloc( (count / 4) * 6 * sizeof( vkVertex_t ) );
		if ( !output )
		{
			return 0;
		}
		for ( i = 0; i + 3 < count; i += 4 )
		{
			output[out++] = source[i];
			output[out++] = source[i + 1];
			output[out++] = source[i + 2];
			output[out++] = source[i];
			output[out++] = source[i + 2];
			output[out++] = source[i + 3];
		}
	}
	else if ( glMode == GL_QUAD_STRIP )
	{
		output = ri.Malloc( (count / 2) * 6 * sizeof( vkVertex_t ) );
		if ( !output )
		{
			return 0;
		}
		for ( i = 0; i + 3 < count; i += 2 )
		{
			output[out++] = source[i];
			output[out++] = source[i + 1];
			output[out++] = source[i + 2];
			output[out++] = source[i + 2];
			output[out++] = source[i + 1];
			output[out++] = source[i + 3];
		}
	}
	else if ( glMode == GL_POLYGON )
	{
		return VK_ConvertVertices( source, count, GL_TRIANGLE_FAN, destination );
	}
	else
	{
		*destination = NULL;
		return count;
	}

	*destination = output;
	return out;
}

static void VK_DrawVertices( int glMode, const vkVertex_t *vertices, int count )
{
	vkVertex_t *converted = NULL;
	const vkVertex_t *drawData = vertices;
	VkPipeline pipeline;
	VkDescriptorSet descriptorSet;
	VkDescriptorBufferInfo bufferInfo;
	VkDescriptorImageInfo imageInfo[VK_NUM_SAMPLERS];
	VkWriteDescriptorSet writes[VK_NUM_SAMPLERS + 1];
	VkBufferUsageFlags usage;
	VkDeviceSize vertexOffset;
	VkDeviceSize uniformOffset;
	VkDeviceSize size;
	vkProgram_t *program;
	int drawCount;
	int i;

	if ( !vk.inRenderPass || count <= 0 )
	{
		return;
	}

	drawCount = VK_ConvertVertices( vertices, count, glMode, &converted );
	if ( drawCount <= 0 )
	{
		return;
	}
	if ( converted )
	{
		drawData = converted;
	}

	program = vk.currentProgram && vk.currentProgram->valid ? vk.currentProgram
	                                                        : vk.builtinProgram;
	if ( !program )
	{
		if ( converted )
		{
			ri.Free( converted );
		}
		return;
	}

	pipeline = VK_GetPipeline( program, VK_Topology( glMode ), vk.blend, vk.depthTest,
	                           vk.depthWrite, VK_CullMode() );
	if ( pipeline == VK_NULL_HANDLE )
	{
		if ( converted )
		{
			ri.Free( converted );
		}
		return;
	}
	vertexOffset = vk.vertexUsed;
	uniformOffset = vk.uniformUsed;
	size = (VkDeviceSize)drawCount * sizeof( vkVertex_t );

	if ( vertexOffset + size > vk.vertexCapacity ||
	     uniformOffset + program->uboSize > vk.uniformCapacity ||
	     vk.numDescriptorSets >= ARRAY_LEN( vk.descriptorSets ) )
	{
		/* Frame buffers are reset in Present(); this is a safety net for
		   unusually large frames. */
		ri.Printf( PRINT_DEVELOPER, "Vulkan ring buffer exhausted in draw call\n" );
		if ( converted )
		{
			ri.Free( converted );
		}
		return;
	}

	Com_Memcpy( vk.vertexMapped + vertexOffset, drawData, size );
	VK_SetAlphaTestUniforms( program );
	Com_Memcpy( vk.uniformMapped + uniformOffset, program->uboData, program->uboSize );

	{
		VkDescriptorSetAllocateInfo allocateInfo;
		Com_Memset( &allocateInfo, 0, sizeof( allocateInfo ) );
		allocateInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
		allocateInfo.descriptorPool = vk.descriptorPool;
		allocateInfo.descriptorSetCount = 1;
		allocateInfo.pSetLayouts = &vk.descriptorLayout;
		VK_Check( vkAllocateDescriptorSets( vk.device, &allocateInfo, &descriptorSet ),
		          "vkAllocateDescriptorSets" );
	}
	vk.descriptorSets[vk.numDescriptorSets++] = descriptorSet;

	Com_Memset( &bufferInfo, 0, sizeof( bufferInfo ) );
	bufferInfo.buffer = vk.uniformBuffer;
	bufferInfo.offset = 0;
	bufferInfo.range = program->uboSize;

	Com_Memset( imageInfo, 0, sizeof( imageInfo ) );
	Com_Memset( writes, 0, sizeof( writes ) );
	writes[0].sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
	writes[0].dstSet = descriptorSet;
	writes[0].dstBinding = 0;
	writes[0].descriptorCount = 1;
	writes[0].descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC;
	writes[0].pBufferInfo = &bufferInfo;

	for ( i = 0; i < VK_NUM_SAMPLERS; i++ )
	{
		vkTexture_t *texture = &vk.textures[vk.boundTextures[i]];
		if ( !texture->allocated )
		{
			texture = &vk.textures[VK_WHITE_TEXTURE]; /* 1x1 white fallback */
		}
		imageInfo[i].sampler = vk.samplers[( texture->nearest ? 1 : 0 ) +
		                                  ( texture->clamp ? 2 : 0 ) +
		                                  ( texture->mipmapped ? 4 : 0 )];
		imageInfo[i].imageView = texture->view;
		imageInfo[i].imageLayout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
		writes[i + 1].sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
		writes[i + 1].dstSet = descriptorSet;
		writes[i + 1].dstBinding = i + 1;
		writes[i + 1].descriptorCount = 1;
		writes[i + 1].descriptorType = VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
		writes[i + 1].pImageInfo = &imageInfo[i];
	}
	vkUpdateDescriptorSets( vk.device, ARRAY_LEN( writes ), writes, 0, NULL );

	usage = VK_BUFFER_USAGE_VERTEX_BUFFER_BIT;
	(void)usage;
	vkCmdBindPipeline( vk.commandBuffer, VK_PIPELINE_BIND_POINT_GRAPHICS, pipeline );
	VK_SetViewportState();
	vkCmdBindVertexBuffers( vk.commandBuffer, 0, 1, &vk.vertexBuffer, &vertexOffset );
	{
		uint32_t dynamicOffset = (uint32_t)uniformOffset;
		vkCmdBindDescriptorSets( vk.commandBuffer, VK_PIPELINE_BIND_POINT_GRAPHICS,
		                         vk.pipelineLayout, 0, 1, &descriptorSet, 1, &dynamicOffset );
	}
	vkCmdDraw( vk.commandBuffer, drawCount, 1, 0, 0 );

	vk.vertexUsed += ( size + VK_VERTEX_ALIGN - 1 ) & ~( VK_VERTEX_ALIGN - 1 );
	vk.uniformUsed += ( program->uboSize + VK_UNIFORM_ALIGN - 1 ) & ~( VK_UNIFORM_ALIGN - 1 );

	if ( converted )
	{
		ri.Free( converted );
	}
}

/* ------------------------------------------------------------------------ */
/* OpenGL-compatible state and entry points                                  */
/* ------------------------------------------------------------------------ */

static void VK_MatrixMultiply( float *out, const float *a, const float *b )
{
	float result[16];
	int row, col, k;

	/* Column-major out = a * b, matching Matrix4Multiply() in q_math.c.
	   Callers pass the current matrix first and the modification second. */
	for ( col = 0; col < 4; col++ )
	{
		for ( row = 0; row < 4; row++ )
		{
			result[col * 4 + row] = 0.0f;
			for ( k = 0; k < 4; k++ )
			{
				result[col * 4 + row] += a[k * 4 + row] * b[col * 4 + k];
			}
		}
	}
	Com_Memcpy( out, result, sizeof( result ) );
}

static void VKGL_LoadIdentity( void )
{
	Com_Memcpy( vk.matrices[vk.matrixMode], vkIdentity, sizeof( vkIdentity ) );
}

static void VKGL_LoadMatrixf( const GLfloat *m )
{
	Com_Memcpy( vk.matrices[vk.matrixMode], m, sizeof( float ) * 16 );
}

static void VKGL_MultMatrixf( const GLfloat *m )
{
	VK_MatrixMultiply( vk.matrices[vk.matrixMode], vk.matrices[vk.matrixMode], m );
}

static void VKGL_PushMatrix( void )
{
	int mode = vk.matrixMode;
	if ( vk.stackDepth[mode] >= 32 )
	{
		return;
	}
	Com_Memcpy( vk.matrixStack[mode][vk.stackDepth[mode]++], vk.matrices[mode],
	            sizeof( float ) * 16 );
}

static void VKGL_PopMatrix( void )
{
	int mode = vk.matrixMode;
	if ( vk.stackDepth[mode] <= 0 )
	{
		return;
	}
	Com_Memcpy( vk.matrices[mode], vk.matrixStack[mode][--vk.stackDepth[mode]],
	            sizeof( float ) * 16 );
}

static void VKGL_MatrixMode( GLenum mode )
{
	if ( mode == GL_PROJECTION )
	{
		vk.matrixMode = 1;
	}
	else
	{
		vk.matrixMode = 0;
	}
}

static void VKGL_Translatef( GLfloat x, GLfloat y, GLfloat z )
{
	float m[16];
	Com_Memcpy( m, vkIdentity, sizeof( m ) );
	m[12] = x;
	m[13] = y;
	m[14] = z;
	VK_MatrixMultiply( vk.matrices[vk.matrixMode], vk.matrices[vk.matrixMode], m );
}

static void VKGL_Scalef( GLfloat x, GLfloat y, GLfloat z )
{
	float m[16];
	Com_Memcpy( m, vkIdentity, sizeof( m ) );
	m[0] = x;
	m[5] = y;
	m[10] = z;
	VK_MatrixMultiply( vk.matrices[vk.matrixMode], vk.matrices[vk.matrixMode], m );
}

static void VKGL_Rotatef( GLfloat angle, GLfloat x, GLfloat y, GLfloat z )
{
	float m[16];
	float radians = angle * (float)M_PI / 180.0f;
	float c = cosf( radians );
	float s = sinf( radians );
	float length = sqrtf( x * x + y * y + z * z );

	if ( length <= 0.0f )
	{
		return;
	}
	x /= length;
	y /= length;
	z /= length;

	Com_Memcpy( m, vkIdentity, sizeof( m ) );
	m[0] = x * x * ( 1 - c ) + c;
	m[1] = y * x * ( 1 - c ) + z * s;
	m[2] = x * z * ( 1 - c ) - y * s;
	m[4] = x * y * ( 1 - c ) - z * s;
	m[5] = y * y * ( 1 - c ) + c;
	m[6] = y * z * ( 1 - c ) + x * s;
	m[8] = x * z * ( 1 - c ) + y * s;
	m[9] = y * z * ( 1 - c ) - x * s;
	m[10] = z * z * ( 1 - c ) + c;
	VK_MatrixMultiply( vk.matrices[vk.matrixMode], vk.matrices[vk.matrixMode], m );
}

static void VKGL_Ortho( GLdouble left, GLdouble right, GLdouble bottom, GLdouble top,
                        GLdouble zNear, GLdouble zFar )
{
	float m[16];
	Com_Memset( m, 0, sizeof( m ) );
	m[0] = 2.0f / (float)( right - left );
	m[5] = 2.0f / (float)( top - bottom );
	m[10] = -2.0f / (float)( zFar - zNear );
	m[12] = -(float)( right + left ) / (float)( right - left );
	m[13] = -(float)( top + bottom ) / (float)( top - bottom );
	m[14] = -(float)( zFar + zNear ) / (float)( zFar - zNear );
	m[15] = 1.0f;
	VK_MatrixMultiply( vk.matrices[vk.matrixMode], vk.matrices[vk.matrixMode], m );
}

static void VKGL_Frustum( GLdouble left, GLdouble right, GLdouble bottom, GLdouble top,
                          GLdouble zNear, GLdouble zFar )
{
	float m[16];
	Com_Memset( m, 0, sizeof( m ) );
	m[0] = 2.0f * (float)zNear / (float)( right - left );
	m[5] = 2.0f * (float)zNear / (float)( top - bottom );
	m[8] = (float)( right + left ) / (float)( right - left );
	m[9] = (float)( top + bottom ) / (float)( top - bottom );
	m[10] = -(float)( zFar + zNear ) / (float)( zFar - zNear );
	m[11] = -1.0f;
	m[14] = -2.0f * (float)( zFar * zNear ) / (float)( zFar - zNear );
	VK_MatrixMultiply( vk.matrices[vk.matrixMode], vk.matrices[vk.matrixMode], m );
}

static void VKGL_Enable( GLenum cap )
{
	switch ( cap )
	{
		case GL_DEPTH_TEST:   vk.depthTest = qtrue; break;
		case GL_BLEND:        vk.blend = qtrue; break;
		case GL_ALPHA_TEST:   vk.alphaTest = qtrue; break;
		case GL_CULL_FACE:    vk.cullFace = qtrue; break;
		case GL_SCISSOR_TEST: vk.scissorEnabled = qtrue; break;
		case GL_POLYGON_OFFSET_FILL: vk.polygonOffset = qtrue; break;
		case GL_TEXTURE_2D:   vk.texture2D[vk.activeTexture] = qtrue; break;
		default: break;
	}
}

static void VKGL_Disable( GLenum cap )
{
	switch ( cap )
	{
		case GL_DEPTH_TEST:   vk.depthTest = qfalse; break;
		case GL_BLEND:        vk.blend = qfalse; break;
		case GL_ALPHA_TEST:   vk.alphaTest = qfalse; break;
		case GL_CULL_FACE:    vk.cullFace = qfalse; break;
		case GL_SCISSOR_TEST: vk.scissorEnabled = qfalse; break;
		case GL_POLYGON_OFFSET_FILL: vk.polygonOffset = qfalse; break;
		case GL_TEXTURE_2D:   vk.texture2D[vk.activeTexture] = qfalse; break;
		default: break;
	}
}

static GLboolean VKGL_IsEnabled( GLenum cap )
{
	switch ( cap )
	{
		case GL_DEPTH_TEST:   return vk.depthTest ? GL_TRUE : GL_FALSE;
		case GL_BLEND:        return vk.blend ? GL_TRUE : GL_FALSE;
		case GL_ALPHA_TEST:   return vk.alphaTest ? GL_TRUE : GL_FALSE;
		case GL_CULL_FACE:    return vk.cullFace ? GL_TRUE : GL_FALSE;
		case GL_SCISSOR_TEST: return vk.scissorEnabled ? GL_TRUE : GL_FALSE;
		case GL_POLYGON_OFFSET_FILL: return vk.polygonOffset ? GL_TRUE : GL_FALSE;
		case GL_TEXTURE_2D:   return vk.texture2D[vk.activeTexture] ? GL_TRUE : GL_FALSE;
		default:              return GL_FALSE;
	}
}

static void VKGL_BlendFunc( GLenum src, GLenum dst )
{
	vk.blendSrc = src;
	vk.blendDst = dst;
}

static void VKGL_DepthFunc( GLenum func )
{
	vk.depthFunc = func;
}

static void VKGL_DepthMask( GLboolean flag )
{
	vk.depthWrite = flag ? qtrue : qfalse;
}

static void VKGL_DepthRange( GLdouble nearVal, GLdouble farVal )
{
	(void)nearVal;
	(void)farVal;
}

static void VKGL_CullFace( GLenum mode )
{
	vk.cullMode = mode;
}

static void VKGL_FrontFace( GLenum mode )
{
	vk.frontFace = mode;
}

static void VKGL_PolygonMode( GLenum face, GLenum mode )
{
	(void)face;
	vk.polygonMode = mode;
}

static void VKGL_PolygonOffset( GLfloat factor, GLfloat units )
{
	vk.polygonOffsetFactor = factor;
	vk.polygonOffsetUnits = units;
	if ( vk.inRenderPass )
	{
		vkCmdSetDepthBias( vk.commandBuffer,
		                   vk.polygonOffset ? vk.polygonOffsetUnits : 0.0f,
		                   0.0f,
		                   vk.polygonOffset ? vk.polygonOffsetFactor : 0.0f );
	}
}

static void VKGL_LineWidth( GLfloat width )
{
	vk.lineWidth = width;
}

static void VKGL_ColorMask( GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha )
{
	vk.colorMask = 0;
	if ( red )   vk.colorMask |= VK_COLOR_COMPONENT_R_BIT;
	if ( green ) vk.colorMask |= VK_COLOR_COMPONENT_G_BIT;
	if ( blue )  vk.colorMask |= VK_COLOR_COMPONENT_B_BIT;
	if ( alpha ) vk.colorMask |= VK_COLOR_COMPONENT_A_BIT;
}

static void VKGL_ClearColor( GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha )
{
	vk.clearColor[0] = red;
	vk.clearColor[1] = green;
	vk.clearColor[2] = blue;
	vk.clearColor[3] = alpha;
}

static void VKGL_ClearDepth( GLclampd depth )
{
	vk.clearDepth = depth;
}

static void VKGL_ClearStencil( GLint stencil )
{
	(void)stencil;
}

static void VKGL_ClipPlane( GLenum plane, const GLdouble *equation )
{
	(void)plane;
	(void)equation;
}

static void VKGL_CopyTexSubImage2D( GLenum target, GLint level, GLint xoffset, GLint yoffset,
                                    GLint x, GLint y, GLsizei width, GLsizei height );

static void VKGL_CopyTexImage2D( GLenum target, GLint level, GLenum internalFormat,
                                 GLint x, GLint y, GLsizei width, GLsizei height, GLint border )
{
	VKGL_CopyTexSubImage2D( target, level, 0, 0, x, y, width, height );
	(void)internalFormat;
	(void)border;
}

static void VKGL_Fogi( GLenum pname, GLint param )
{
	(void)pname;
	(void)param;
}

static void VKGL_Hint( GLenum target, GLenum mode )
{
	(void)target;
	(void)mode;
}

static void VKGL_StencilFunc( GLenum func, GLint ref, GLuint mask )
{
	(void)func;
	(void)ref;
	(void)mask;
}

static void VKGL_StencilMask( GLuint mask )
{
	(void)mask;
}

static void VKGL_StencilOp( GLenum fail, GLenum zfail, GLenum zpass )
{
	(void)fail;
	(void)zfail;
	(void)zpass;
}

static void VKGL_TexEnvfv( GLenum target, GLenum pname, const GLfloat *params )
{
	(void)target;
	(void)pname;
	(void)params;
}

static void VKGL_Viewport( GLint x, GLint y, GLsizei width, GLsizei height )
{
	vk.viewport[0] = x;
	vk.viewport[1] = y;
	vk.viewport[2] = width;
	vk.viewport[3] = height;
}

static void VKGL_Scissor( GLint x, GLint y, GLsizei width, GLsizei height )
{
	vk.scissor[0] = x;
	vk.scissor[1] = y;
	vk.scissor[2] = width;
	vk.scissor[3] = height;
}

static void VKGL_Clear( GLbitfield mask )
{
	VkClearAttachment attachments[2];
	VkClearRect rect;
	int count = 0;

	if ( !vk.inRenderPass )
	{
		return;
	}

	Com_Memset( &rect, 0, sizeof( rect ) );
	if ( vk.scissorEnabled )
	{
		int x = vk.scissor[0] > 0 ? vk.scissor[0] : 0;
		int y = vk.scissor[1] > 0 ? vk.scissor[1] : 0;
		int width = vk.scissor[2];
		int height = vk.scissor[3];

		if ( width <= 0 || height <= 0 || x >= (int)vk.extent.width ||
		     y >= (int)vk.extent.height )
		{
			return;
		}
		if ( width > (int)vk.extent.width - x )
		{
			width = (int)vk.extent.width - x;
		}
		if ( height > (int)vk.extent.height - y )
		{
			height = (int)vk.extent.height - y;
		}
		rect.rect.offset.x = x;
		rect.rect.offset.y = vk.extent.height - y - height;
		rect.rect.extent.width = (uint32_t)width;
		rect.rect.extent.height = (uint32_t)height;
	}
	else
	{
		/* GL_Clear ignores the viewport; clear the whole framebuffer. */
		rect.rect.extent.width = vk.extent.width;
		rect.rect.extent.height = vk.extent.height;
	}
	rect.baseArrayLayer = 0;
	rect.layerCount = 1;

	Com_Memset( attachments, 0, sizeof( attachments ) );
	if ( mask & GL_COLOR_BUFFER_BIT )
	{
		attachments[count].aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
		attachments[count].colorAttachment = 0;
		attachments[count].clearValue.color.float32[0] = vk.clearColor[0];
		attachments[count].clearValue.color.float32[1] = vk.clearColor[1];
		attachments[count].clearValue.color.float32[2] = vk.clearColor[2];
		attachments[count].clearValue.color.float32[3] = vk.clearColor[3];
		count++;
	}
	if ( mask & GL_DEPTH_BUFFER_BIT )
	{
		attachments[count].aspectMask = VK_IMAGE_ASPECT_DEPTH_BIT;
		attachments[count].clearValue.depthStencil.depth = vk.clearDepth;
		attachments[count].clearValue.depthStencil.stencil = 0;
		count++;
	}
	if ( count > 0 )
	{
		vkCmdClearAttachments( vk.commandBuffer, count, attachments, 1, &rect );
	}
}

static void VKGL_AlphaFunc( GLenum func, GLclampf ref )
{
	vk.alphaFunc = (int)func;
	vk.alphaRef = ref;
}

static void VKGL_Fogf( GLenum pname, GLfloat param )
{
	(void)pname;
	(void)param;
}

static void VKGL_Fogfv( GLenum pname, const GLfloat *params )
{
	vkProgram_t *program = vk.currentProgram ? vk.currentProgram : vk.builtinProgram;
	vkUniform_t *uniform = NULL;
	int i;

	if ( pname != GL_FOG_COLOR || !program )
	{
		return;
	}
	for ( i = 0; i < program->numUniforms; i++ )
	{
		if ( !Q_stricmp( program->uniforms[i].name, "u_FogColor" ) )
		{
			uniform = &program->uniforms[i];
			break;
		}
	}
	if ( uniform && uniform->size >= 16 )
	{
		Com_Memcpy( program->uboData + uniform->offset, params, 16 );
	}
}

static void VKGL_TexEnvf( GLenum target, GLenum pname, GLfloat param )
{
	(void)target;
	(void)pname;
	(void)param;
}

static void VKGL_ShadeModel( GLenum mode )
{
	(void)mode;
}

static void VKGL_DrawBuffer( GLenum mode )
{
	(void)mode;
}

static void VKGL_Finish( void )
{
	if ( vk.device )
	{
		VK_Check( vkDeviceWaitIdle( vk.device ), "vkDeviceWaitIdle" );
	}
}

static void VKGL_Flush( void )
{
}

static GLenum VKGL_GetError( void )
{
	return GL_NO_ERROR;
}

static const GLubyte *VKGL_GetString( GLenum name )
{
	static const GLubyte vendor[] = "ZEQ2-Lite Vulkan backend";
	static const GLubyte renderer[] = "Vulkan translation renderer";
	static const GLubyte version[] = "Vulkan 1.0";
	static const GLubyte extensions[] =
		"GL_ARB_multitexture GL_ARB_shader_objects GL_ARB_vertex_shader GL_EXT_texture_env_add";

	switch ( name )
	{
		case GL_VENDOR:     return vendor;
		case GL_RENDERER:   return renderer;
		case GL_VERSION:    return version;
		case GL_EXTENSIONS: return extensions;
		default:            return NULL;
	}
}

static void VKGL_GetIntegerv( GLenum pname, GLint *params )
{
	switch ( pname )
	{
		case GL_MAX_TEXTURE_SIZE:
			*params = 8192;
			break;
		case GL_MAX_TEXTURE_UNITS_ARB:
		case GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS:
			*params = VK_NUM_SAMPLERS;
			break;
		case GL_VIEWPORT:
			Com_Memcpy( params, vk.viewport, sizeof( int ) * 4 );
			break;
		case GL_SCISSOR_BOX:
			Com_Memcpy( params, vk.scissor, sizeof( int ) * 4 );
			break;
		case GL_TEXTURE_BINDING_2D:
			*params = vk.boundTextureName;
			break;
		case GL_DEPTH_BITS:
			*params = 32;
			break;
		case GL_STENCIL_BITS:
			/* Stencil is not implemented by this backend. */
			*params = 0;
			break;
		case GL_RED_BITS:
		case GL_GREEN_BITS:
		case GL_BLUE_BITS:
		case GL_ALPHA_BITS:
			*params = 8;
			break;
		default:
			*params = 0;
			break;
	}
}

static void VKGL_GetBooleanv( GLenum pname, GLboolean *params )
{
	GLint values[16] = { 0 };
	VKGL_GetIntegerv( pname, values );
	*params = values[0] ? GL_TRUE : GL_FALSE;
}

static void VKGL_GetFloatv( GLenum pname, GLfloat *params )
{
	switch ( pname )
	{
		case GL_MODELVIEW_MATRIX:
			Com_Memcpy( params, vk.matrices[0], sizeof( float ) * 16 );
			break;
		case GL_PROJECTION_MATRIX:
			Com_Memcpy( params, vk.matrices[1], sizeof( float ) * 16 );
			break;
		case GL_LINE_WIDTH:
			*params = vk.lineWidth;
			break;
		case GL_COLOR_CLEAR_VALUE:
			Com_Memcpy( params, vk.clearColor, sizeof( float ) * 4 );
			break;
		case GL_DEPTH_RANGE:
			params[0] = 0.0f;
			params[1] = 1.0f;
			break;
		default:
			*params = 0.0f;
			break;
	}
}

/* ------------------------------------------------------------------------ */
/* Texture uploads and framebuffer readback                                   */
/* ------------------------------------------------------------------------ */

static qboolean VK_SubmitTransient( VkCommandBuffer command )
{
	VkSubmitInfo submitInfo;
	VkCommandBuffer commands[1] = { command };
	qboolean ok;

	ok = VK_Check( vkEndCommandBuffer( command ), "vkEndCommandBuffer" );
	Com_Memset( &submitInfo, 0, sizeof( submitInfo ) );
	submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
	submitInfo.commandBufferCount = 1;
	submitInfo.pCommandBuffers = commands;
	if ( !VK_Check( vkQueueSubmit( vk.queue, 1, &submitInfo, VK_NULL_HANDLE ),
	                "vkQueueSubmit" ) )
	{
		return qfalse;
	}
	return VK_Check( vkDeviceWaitIdle( vk.device ), "vkDeviceWaitIdle" ) && ok ? qtrue : qfalse;
}

static void VK_BeginTransient( void )
{
	VkCommandBufferBeginInfo beginInfo;

	VK_Check( vkResetCommandBuffer( vk.transientCommand, 0 ), "vkResetCommandBuffer" );
	Com_Memset( &beginInfo, 0, sizeof( beginInfo ) );
	beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
	beginInfo.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
	VK_Check( vkBeginCommandBuffer( vk.transientCommand, &beginInfo ),
	          "vkBeginCommandBuffer" );
}

static void VK_ConvertPixels( const void *source, int format, int type,
                              void *destination, int pixels )
{
	const byte *src = source;
	byte *dst = destination;
	int i;

	if ( type == GL_FLOAT )
	{
		const float *floats = source;
		for ( i = 0; i < pixels; i++ )
		{
			dst[i * 4 + 0] = (byte)( floats[i * 4 + 0] * 255.0f );
			dst[i * 4 + 1] = (byte)( floats[i * 4 + 1] * 255.0f );
			dst[i * 4 + 2] = (byte)( floats[i * 4 + 2] * 255.0f );
			dst[i * 4 + 3] = (byte)( floats[i * 4 + 3] * 255.0f );
		}
		return;
	}

	switch ( format )
	{
		case GL_RGB:
			for ( i = 0; i < pixels; i++ )
			{
				dst[i * 4 + 0] = src[i * 3 + 0];
				dst[i * 4 + 1] = src[i * 3 + 1];
				dst[i * 4 + 2] = src[i * 3 + 2];
				dst[i * 4 + 3] = 255;
			}
			break;
		case GL_BGR:
			for ( i = 0; i < pixels; i++ )
			{
				dst[i * 4 + 0] = src[i * 3 + 2];
				dst[i * 4 + 1] = src[i * 3 + 1];
				dst[i * 4 + 2] = src[i * 3 + 0];
				dst[i * 4 + 3] = 255;
			}
			break;
		case GL_BGRA:
			for ( i = 0; i < pixels; i++ )
			{
				dst[i * 4 + 0] = src[i * 4 + 2];
				dst[i * 4 + 1] = src[i * 4 + 1];
				dst[i * 4 + 2] = src[i * 4 + 0];
				dst[i * 4 + 3] = src[i * 4 + 3];
			}
			break;
		case GL_ALPHA:
			for ( i = 0; i < pixels; i++ )
			{
				dst[i * 4 + 0] = 255;
				dst[i * 4 + 1] = 255;
				dst[i * 4 + 2] = 255;
				dst[i * 4 + 3] = src[i];
			}
			break;
		case GL_LUMINANCE:
			for ( i = 0; i < pixels; i++ )
			{
				dst[i * 4 + 0] = src[i];
				dst[i * 4 + 1] = src[i];
				dst[i * 4 + 2] = src[i];
				dst[i * 4 + 3] = 255;
			}
			break;
		default:
			Com_Memcpy( dst, source, pixels * 4 );
			break;
	}
}

static void VK_UploadTexture( vkTexture_t *texture, int level, int x, int y,
                              int width, int height, int format, int type,
                              const void *pixels )
{
	VkBufferImageCopy region;
	VkImageLayout oldLayout;
	VkAccessFlags srcAccess;
	VkPipelineStageFlags srcStage;
	size_t bytes = (size_t)width * height * 4;

	if ( !texture->allocated || !pixels || width <= 0 || height <= 0 ||
	     level < 0 || level >= texture->mipLevels )
	{
		return;
	}
	if ( level > 0 )
	{
		texture->mipmapped = qtrue;
	}
	if ( bytes > vk.stagingCapacity )
	{
		ri.Printf( PRINT_ALL, "Vulkan texture upload exceeds staging buffer\n" );
		return;
	}

	VK_ConvertPixels( pixels, format, type, vk.stagingMapped, width * height );

	/* Subimage updates must preserve the existing contents: transitioning an
	   already initialized image from UNDEFINED would discard the whole image. */
	oldLayout = texture->initialized ? VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL
	                                  : VK_IMAGE_LAYOUT_UNDEFINED;
	srcAccess = texture->initialized ? VK_ACCESS_SHADER_READ_BIT : 0;
	srcStage = texture->initialized ? VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT
	                                 : VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT;

	VK_BeginTransient();
	VK_Transition( vk.transientCommand, texture->image, VK_IMAGE_ASPECT_COLOR_BIT,
	               oldLayout, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
	               srcAccess, VK_ACCESS_TRANSFER_WRITE_BIT,
	               srcStage, VK_PIPELINE_STAGE_TRANSFER_BIT,
	               level, 1 );

	Com_Memset( &region, 0, sizeof( region ) );
	region.bufferOffset = 0;
	region.bufferRowLength = width;
	region.bufferImageHeight = height;
	region.imageSubresource.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
	region.imageSubresource.mipLevel = level;
	region.imageSubresource.baseArrayLayer = 0;
	region.imageSubresource.layerCount = 1;
	region.imageOffset.x = x;
	region.imageOffset.y = y;
	region.imageOffset.z = 0;
	region.imageExtent.width = width;
	region.imageExtent.height = height;
	region.imageExtent.depth = 1;
	vkCmdCopyBufferToImage( vk.transientCommand, vk.stagingBuffer, texture->image,
	                        VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &region );

	VK_Transition( vk.transientCommand, texture->image, VK_IMAGE_ASPECT_COLOR_BIT,
	               VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
	               VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
	               VK_ACCESS_TRANSFER_WRITE_BIT, VK_ACCESS_SHADER_READ_BIT,
	               VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT,
	               level, 1 );
	if ( !VK_SubmitTransient( vk.transientCommand ) )
	{
		return;
	}
	texture->initialized = qtrue;
}

static void VKGL_GenTextures( GLsizei n, GLuint *textures )
{
	int i;

	for ( i = 0; i < n; i++ )
	{
		while ( vk.nextTextureName < VK_MAX_TEXTURES &&
		        vk.nextTextureName == VK_WHITE_TEXTURE )
		{
			vk.nextTextureName++;
		}
		if ( vk.nextTextureName >= VK_MAX_TEXTURES )
		{
			textures[i] = 0;
			continue;
		}
		textures[i] = vk.nextTextureName++;
	}
}

static void VKGL_DeleteTextures( GLsizei n, const GLuint *textures )
{
	int i;

	for ( i = 0; i < n; i++ )
	{
		vkTexture_t *texture;
		if ( textures[i] == 0 || textures[i] >= VK_MAX_TEXTURES )
		{
			continue;
		}
		texture = &vk.textures[textures[i]];
		if ( !texture->allocated )
		{
			continue;
		}
		VK_Check( vkDeviceWaitIdle( vk.device ), "vkDeviceWaitIdle" );
		if ( texture->view != VK_NULL_HANDLE )
		{
			vkDestroyImageView( vk.device, texture->view, NULL );
		}
		if ( texture->image != VK_NULL_HANDLE )
		{
			vkDestroyImage( vk.device, texture->image, NULL );
		}
		if ( texture->memory != VK_NULL_HANDLE )
		{
			vkFreeMemory( vk.device, texture->memory, NULL );
		}
		Com_Memset( texture, 0, sizeof( *texture ) );
	}
}

static void VKGL_BindTexture( GLenum target, GLuint texture )
{
	(void)target;
	if ( texture < VK_MAX_TEXTURES )
	{
		vk.boundTextures[vk.activeTexture] = texture;
		vk.boundTextureName = texture;
	}
}

static void VKGL_TexImage2D( GLenum target, GLint level, GLint internalFormat,
                             GLsizei width, GLsizei height, GLint border,
                             GLenum format, GLenum type, const GLvoid *pixels )
{
	vkTexture_t *texture = &vk.textures[vk.boundTextureName];
	uint32_t mipLevels = 1;
	uint32_t dimension = width > height ? width : height;

	(void)target;
	(void)internalFormat;
	(void)border;

	if ( vk.boundTextureName == 0 || vk.boundTextureName >= VK_MAX_TEXTURES ||
	     width <= 0 || height <= 0 )
	{
		return;
	}

	if ( level == 0 )
	{
		if ( texture->allocated )
		{
			VKGL_DeleteTextures( 1, &vk.boundTextureName );
		}
		while ( dimension > 1 && mipLevels < 16 )
		{
			mipLevels++;
			dimension >>= 1;
		}
		if ( !VK_CreateImage( width, height, mipLevels, VK_FORMAT_R8G8B8A8_UNORM,
		                      VK_IMAGE_USAGE_TRANSFER_DST_BIT | VK_IMAGE_USAGE_SAMPLED_BIT |
		                      VK_IMAGE_USAGE_TRANSFER_SRC_BIT,
		                      &texture->image, &texture->memory ) )
		{
			return;
		}
		texture->view = VK_CreateImageView( texture->image, VK_FORMAT_R8G8B8A8_UNORM,
		                                   mipLevels, VK_IMAGE_ASPECT_COLOR_BIT );
		texture->width = width;
		texture->height = height;
		texture->mipLevels = mipLevels;
		texture->mipmapped = qfalse;
		texture->allocated = qtrue;
		texture->initialized = qfalse;
	}

	VK_UploadTexture( texture, level, 0, 0, width, height, format, type, pixels );
}

static void VKGL_TexSubImage2D( GLenum target, GLint level, GLint xoffset, GLint yoffset,
                                GLsizei width, GLsizei height, GLenum format,
                                GLenum type, const GLvoid *pixels )
{
	(void)target;
	VK_UploadTexture( &vk.textures[vk.boundTextureName], level, xoffset, yoffset,
	                  width, height, format, type, pixels );
}

static void VKGL_TexParameterf( GLenum target, GLenum pname, GLfloat param )
{
	vkTexture_t *texture = &vk.textures[vk.boundTextureName];
	(void)target;

	if ( pname == GL_TEXTURE_MAG_FILTER && param == GL_NEAREST )
	{
		texture->nearest = qtrue;
	}
	else if ( pname == GL_TEXTURE_WRAP_S || pname == GL_TEXTURE_WRAP_T )
	{
		texture->clamp = param == GL_CLAMP;
	}
}

static void VKGL_TexParameteri( GLenum target, GLenum pname, GLint param )
{
	VKGL_TexParameterf( target, pname, (GLfloat)param );
}

static void VKGL_TexParameterfv( GLenum target, GLenum pname, const GLfloat *params )
{
	if ( params )
	{
		VKGL_TexParameterf( target, pname, params[0] );
	}
}

static void VKGL_GetTexParameteriv( GLenum target, GLenum pname, GLint *params )
{
	vkTexture_t *texture = &vk.textures[vk.boundTextureName];
	(void)target;
	*params = ( pname == GL_TEXTURE_MIN_FILTER && texture->nearest ) ? GL_NEAREST
	                                                                 : GL_LINEAR;
}

static qboolean VK_ReadbackColor( int x, int y, int width, int height, byte *destination )
{
	VkBufferImageCopy region;
	size_t bytes;

	if ( !vk.colorImage || !vk.stagingMapped || !destination || width <= 0 || height <= 0 )
	{
		return qfalse;
	}
	if ( x < 0 || y < 0 || x + width > (int)vk.extent.width ||
	     y + height > (int)vk.extent.height )
	{
		return qfalse;
	}
	bytes = (size_t)width * height * 4;
	if ( bytes > vk.stagingCapacity )
	{
		return qfalse;
	}

	VK_BeginTransient();
	VK_Transition( vk.transientCommand, vk.colorImage, VK_IMAGE_ASPECT_COLOR_BIT,
	               VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL, VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL,
	               VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT, VK_ACCESS_TRANSFER_READ_BIT,
	               VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, VK_PIPELINE_STAGE_TRANSFER_BIT,
	               0, 1 );
	Com_Memset( &region, 0, sizeof( region ) );
	region.bufferOffset = 0;
	region.bufferRowLength = width;
	region.bufferImageHeight = height;
	region.imageSubresource.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
	region.imageSubresource.baseArrayLayer = 0;
	region.imageSubresource.layerCount = 1;
	region.imageOffset.x = x;
	region.imageOffset.y = y;
	region.imageOffset.z = 0;
	region.imageExtent.width = width;
	region.imageExtent.height = height;
	region.imageExtent.depth = 1;
	vkCmdCopyImageToBuffer( vk.transientCommand, vk.colorImage,
	                        VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL, vk.stagingBuffer,
	                        1, &region );
	VK_Transition( vk.transientCommand, vk.colorImage, VK_IMAGE_ASPECT_COLOR_BIT,
	               VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL,
	               VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
	               VK_ACCESS_TRANSFER_READ_BIT, VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT,
	               VK_PIPELINE_STAGE_TRANSFER_BIT,
	               VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, 0, 1 );
	if ( !VK_SubmitTransient( vk.transientCommand ) )
	{
		return qfalse;
	}

	Com_Memcpy( destination, vk.stagingMapped, bytes );
	return qtrue;
}

static void VKGL_ReadPixels( GLint x, GLint y, GLsizei width, GLsizei height,
                             GLenum format, GLenum type, GLvoid *pixels )
{
	size_t count;
	size_t bytes;
	size_t i;
	byte *rgba;
	int row, col;
	int pixelBytes;

	if ( width <= 0 || height <= 0 || !pixels )
	{
		return;
	}
	count = (size_t)width * height;
	if ( count > (size_t)0x7fffffff )
	{
		return;
	}
	if ( format == GL_DEPTH_COMPONENT )
	{
		float *depth = pixels;
		for ( i = 0; i < count; i++ )
		{
			depth[i] = 1.0f;
		}
		return;
	}
	if ( format == GL_STENCIL_INDEX )
	{
		Com_Memset( pixels, 0, count );
		return;
	}
	if ( type != GL_UNSIGNED_BYTE )
	{
		return;
	}

	switch ( format )
	{
		case GL_RGB:
		case GL_BGR:   pixelBytes = 3; break;
		case GL_RGBA:
		case GL_BGRA:  pixelBytes = 4; break;
		default:       return;
	}

	bytes = count * 4;
	if ( bytes > vk.stagingCapacity )
	{
		return;
	}
	rgba = ri.Malloc( bytes );
	if ( !rgba )
	{
		return;
	}
	/* GL ReadPixels origins are bottom-left; Vulkan images are top-left. */
	if ( !VK_ReadbackColor( x, (int)vk.extent.height - y - height, width, height, rgba ) )
	{
		ri.Free( rgba );
		return;
	}

	/* Readback rows are top-down; GL ReadPixels returns bottom-up rows. */
	for ( row = 0; row < height; row++ )
	{
		const byte *src = rgba + (size_t)row * width * 4;
		byte *dst = (byte *)pixels + (size_t)( height - 1 - row ) * width * pixelBytes;

		for ( col = 0; col < width; col++ )
		{
			if ( format == GL_RGB )
			{
				dst[0] = src[0]; dst[1] = src[1]; dst[2] = src[2];
			}
			else if ( format == GL_BGR )
			{
				dst[0] = src[2]; dst[1] = src[1]; dst[2] = src[0];
			}
			else if ( format == GL_BGRA )
			{
				dst[0] = src[2]; dst[1] = src[1]; dst[2] = src[0]; dst[3] = src[3];
			}
			else
			{
				dst[0] = src[0]; dst[1] = src[1]; dst[2] = src[2]; dst[3] = src[3];
			}
			src += 4;
			dst += pixelBytes;
		}
	}
	ri.Free( rgba );
}

static void VKGL_CopyTexSubImage2D( GLenum target, GLint level, GLint xoffset, GLint yoffset,
                                    GLint x, GLint y, GLsizei width, GLsizei height )
{
	byte *pixels;

	(void)target;
	if ( width <= 0 || height <= 0 )
	{
		return;
	}
	pixels = ri.Malloc( width * height * 4 );
	if ( !pixels )
	{
		return;
	}
	if ( !VK_ReadbackColor( x, y, width, height, pixels ) )
	{
		ri.Free( pixels );
		return;
	}
	VK_UploadTexture( &vk.textures[vk.boundTextureName], level, xoffset, yoffset,
	                  width, height, GL_RGBA, GL_UNSIGNED_BYTE, pixels );
	ri.Free( pixels );
}

/* ------------------------------------------------------------------------ */
/* ARB shader objects, uniforms and vertex submission                        */
/* ------------------------------------------------------------------------ */

#define VK_MAX_SHADERS 128

typedef struct {
	GLenum type;
	char *source;
	qboolean compiled;
} vkShaderObject_t;

static vkShaderObject_t vkShaders[VK_MAX_SHADERS];

/* Programs and shaders must never share a handle value: qglDeleteObjectARB()
   and qglGetObjectParameterivARB() dispatch on the handle's object kind.
   Handle 0 is reserved for "no program" and tr_glsl.c uses program slots
   starting at 1; builtinProgram uses slot 0 internally via a direct pointer. */
#define VK_SHADER_BASE 0x10000u
#define VK_PROGRAM_HANDLE(index) ((GLhandleARB)( (index) + 1 ))
#define VK_PROGRAM_INDEX(handle) ((int)(handle) - 1)
#define VK_SHADER_HANDLE(index) ((GLhandleARB)( VK_SHADER_BASE + (index) + 1 ))
#define VK_SHADER_INDEX(handle) ((int)(handle) - (int)VK_SHADER_BASE - 1)
#define VK_IS_SHADER_HANDLE(handle) \
	( (handle) >= VK_SHADER_HANDLE( 0 ) && \
	  (handle) < VK_SHADER_HANDLE( ARRAY_LEN( vkShaders ) - 1 ) + 1 )

static vkProgram_t *VK_GetProgram( GLhandleARB handle )
{
	int index = VK_PROGRAM_INDEX( handle );

	/* Slot 0 is the built-in program and has no exportable GL handle. */
	if ( index < 1 || index >= ARRAY_LEN( vk.programs ) ||
	     !vk.programs[index].name[0] )
	{
		return NULL;
	}
	return &vk.programs[index];
}

static vkShaderObject_t *VK_GetShader( GLhandleARB handle )
{
	int index;

	if ( !VK_IS_SHADER_HANDLE( handle ) )
	{
		return NULL;
	}
	index = VK_SHADER_INDEX( handle );
	if ( index < 0 || index >= ARRAY_LEN( vkShaders ) )
	{
		return NULL;
	}
	return &vkShaders[index];
}

static void VK_InvalidateProgramPipelines( vkProgram_t *program )
{
	int i;

	for ( i = 0; i < vk.numPipelines; i++ )
	{
		if ( vk.pipelines[i].program == program )
		{
			if ( vk.pipelines[i].pipeline != VK_NULL_HANDLE )
			{
				vkDestroyPipeline( vk.device, vk.pipelines[i].pipeline, NULL );
			}
			vk.pipelines[i] = vk.pipelines[--vk.numPipelines];
			i--;
		}
	}
}

static void VK_InvalidateAllPipelines( void )
{
	int i;

	for ( i = 0; i < vk.numPipelines; i++ )
	{
		if ( vk.pipelines[i].pipeline != VK_NULL_HANDLE )
		{
			vkDestroyPipeline( vk.device, vk.pipelines[i].pipeline, NULL );
		}
	}
	vk.numPipelines = 0;
	for ( i = 0; i < vk.numPrograms; i++ )
	{
		vk.programs[i].generation++;
	}
}

static GLhandleARB VKGL_CreateShaderObjectARB( GLenum shaderType )
{
	int i;

	for ( i = 0; i < ARRAY_LEN( vkShaders ); i++ )
	{
		if ( !vkShaders[i].source )
		{
			Com_Memset( &vkShaders[i], 0, sizeof( vkShaders[i] ) );
			vkShaders[i].type = shaderType;
			return VK_SHADER_HANDLE( i );
		}
	}
	return 0;
}

static void VKGL_ShaderSourceARB( GLhandleARB shaderObj, GLsizei count,
                                  const GLcharARB **string, const GLint *length )
{
	vkShaderObject_t *shader = VK_GetShader( shaderObj );
	int total = 0;
	int i;
	char *source;

	if ( !shader )
	{
		return;
	}

	for ( i = 0; i < count; i++ )
	{
		if ( string[i] )
		{
			total += length && length[i] >= 0 ? length[i] : (int)strlen( string[i] );
		}
	}
	source = ri.Malloc( total + 1 );
	if ( !source )
	{
		return;
	}
	*source = 0;
	for ( i = 0; i < count; i++ )
	{
		if ( !string[i] )
		{
			continue;
		}
		if ( length && length[i] >= 0 )
		{
			Com_Memcpy( source + strlen( source ), string[i], length[i] );
		}
		else
		{
			Q_strcat( source, total + 1, string[i] );
		}
	}
	if ( shader->source )
	{
		ri.Free( shader->source );
	}
	shader->source = source;
	shader->compiled = qfalse;
}

static void VKGL_CompileShaderARB( GLhandleARB shaderObj )
{
	vkShaderObject_t *shader = VK_GetShader( shaderObj );

	if ( shader && shader->source )
	{
		shader->compiled = qtrue;
	}
}

static GLhandleARB VKGL_CreateProgramObjectARB( void )
{
	int i;

	for ( i = 1; i < ARRAY_LEN( vk.programs ); i++ )
	{
		if ( !vk.programs[i].name[0] )
		{
			int generation = vk.programs[i].generation;

			Com_Memset( &vk.programs[i], 0, sizeof( vk.programs[i] ) );
			vk.programs[i].generation = generation;
			Q_strncpyz( vk.programs[i].name, "program", sizeof( vk.programs[i].name ) );
			if ( i >= vk.numPrograms )
			{
				vk.numPrograms = i + 1;
			}
			return VK_PROGRAM_HANDLE( i );
		}
	}
	return 0;
}

static void VKGL_AttachObjectARB( GLhandleARB containerObj, GLhandleARB obj )
{
	vkProgram_t *program = VK_GetProgram( containerObj );
	vkShaderObject_t *shader = VK_GetShader( obj );

	if ( !program || !shader )
	{
		return;
	}
	if ( shader->type == GL_VERTEX_SHADER_ARB )
	{
		program->vertexShader = obj;
	}
	else
	{
		program->fragmentShader = obj;
	}
}

static void VKGL_LinkProgramARB( GLhandleARB programObj )
{
	vkProgram_t *program = VK_GetProgram( programObj );
	vkShaderObject_t *vertexShader, *fragmentShader;

	if ( !program || program->valid )
	{
		return;
	}

	vertexShader = VK_GetShader( program->vertexShader );
	fragmentShader = VK_GetShader( program->fragmentShader );
	if ( !vertexShader || !fragmentShader || !vertexShader->compiled ||
	     !fragmentShader->compiled || !vertexShader->source ||
	     !fragmentShader->source )
	{
		ri.Printf( PRINT_ALL, "Vulkan: program is missing a compiled shader stage\n" );
		return;
	}

	if ( program->vertexModule != VK_NULL_HANDLE )
	{
		vkDestroyShaderModule( vk.device, program->vertexModule, NULL );
		program->vertexModule = VK_NULL_HANDLE;
	}
	if ( program->fragmentModule != VK_NULL_HANDLE )
	{
		vkDestroyShaderModule( vk.device, program->fragmentModule, NULL );
		program->fragmentModule = VK_NULL_HANDLE;
	}
	/* Any pipeline cached for the old shader set is now stale. */
	program->generation++;
	VK_InvalidateProgramPipelines( program );
	program->numUniforms = 0;
	program->uboSize = 0;
	Com_Memset( program->uboData, 0, sizeof( program->uboData ) );

	/* Collect both stages first so the emitted UBO layout matches exactly. */
	VK_CollectUniforms( vertexShader->source, program );
	VK_CollectUniforms( fragmentShader->source, program );
	if ( !VK_ValidateUniformLayout( program ) )
	{
		program->valid = qfalse;
		return;
	}

	program->vertexModule = VK_CompileShader( vertexShader->source, qtrue, program );
	program->fragmentModule = VK_CompileShader( fragmentShader->source, qfalse, program );
	program->valid = ( program->vertexModule != VK_NULL_HANDLE &&
	                   program->fragmentModule != VK_NULL_HANDLE ) ? qtrue : qfalse;
}

static void VKGL_UseProgramObjectARB( GLhandleARB programObj )
{
	vk.currentProgram = VK_GetProgram( programObj );
}

static void VKGL_DeleteObjectARB( GLhandleARB obj )
{
	vkProgram_t *program = VK_GetProgram( obj );
	vkShaderObject_t *shader;

	if ( program )
	{
		if ( vk.currentProgram == program )
		{
			vk.currentProgram = NULL;
		}
		if ( program->vertexModule != VK_NULL_HANDLE )
		{
			vkDestroyShaderModule( vk.device, program->vertexModule, NULL );
		}
		if ( program->fragmentModule != VK_NULL_HANDLE )
		{
			vkDestroyShaderModule( vk.device, program->fragmentModule, NULL );
		}
		/* Cached pipelines refer to this slot: make sure a reused slot can
		   never pick up a stale pipeline. */
		{
			int generation = ++program->generation;

			VK_InvalidateProgramPipelines( program );
			Com_Memset( program, 0, sizeof( *program ) );
			program->generation = generation;
		}
		return;
	}

	shader = VK_GetShader( obj );
	if ( shader )
	{
		if ( shader->source )
		{
			ri.Free( shader->source );
		}
		Com_Memset( shader, 0, sizeof( *shader ) );
	}
}

static GLint VKGL_GetUniformLocationARB( GLhandleARB programObj, const GLcharARB *name )
{
	vkProgram_t *program = VK_GetProgram( programObj );
	vkUniform_t *uniform;
	int i;

	if ( !program )
	{
		return -1;
	}
	uniform = VK_FindUniform( program, name );
	if ( !uniform )
	{
		ri.Printf( PRINT_DEVELOPER, "Vulkan: shader uniform %s not found\n", name );
		return -1;
	}
	for ( i = 0; i < program->numUniforms; i++ )
	{
		if ( &program->uniforms[i] == uniform )
		{
			return i + 1;
		}
	}
	return -1;
}

static vkUniform_t *VK_UniformByLocation( GLint location )
{
	vkProgram_t *program = vk.currentProgram ? vk.currentProgram : vk.builtinProgram;

	if ( !program || location <= 0 || location > program->numUniforms )
	{
		return NULL;
	}
	return &program->uniforms[location - 1];
}

static void VKGL_Uniform1fARB( GLint location, GLfloat v0 )
{
	vkUniform_t *uniform = VK_UniformByLocation( location );
	if ( uniform && uniform->size >= 4 )
	{
		Com_Memcpy( uniform->offset + ( vk.currentProgram ? vk.currentProgram : vk.builtinProgram )->uboData,
		            &v0, sizeof( v0 ) );
	}
}

static void VKGL_Uniform1iARB( GLint location, GLint v0 )
{
	vkUniform_t *uniform = VK_UniformByLocation( location );
	vkProgram_t *program = vk.currentProgram ? vk.currentProgram : vk.builtinProgram;

	if ( !uniform || !program )
	{
		return;
	}
	if ( uniform->type == VKUNI_SAMPLER )
	{
		/* Opaque sampler: only the descriptor binding is meaningful. */
		if ( v0 >= 0 && v0 < VK_NUM_SAMPLERS )
		{
			uniform->sampler = v0;
		}
		return;
	}
	if ( uniform->type == VKUNI_INT && uniform->size >= sizeof( v0 ) )
	{
		Com_Memcpy( program->uboData + uniform->offset, &v0, sizeof( v0 ) );
	}
}

static void VKGL_Uniform2fARB( GLint location, GLfloat v0, GLfloat v1 )
{
	vkUniform_t *uniform = VK_UniformByLocation( location );
	if ( uniform && uniform->size >= 8 )
	{
		vkProgram_t *program = vk.currentProgram ? vk.currentProgram : vk.builtinProgram;
		GLfloat values[2] = { v0, v1 };
		Com_Memcpy( uniform->offset + program->uboData, values, sizeof( values ) );
	}
}

static void VKGL_Uniform3fARB( GLint location, GLfloat v0, GLfloat v1, GLfloat v2 )
{
	vkUniform_t *uniform = VK_UniformByLocation( location );
	if ( uniform && uniform->size >= 12 )
	{
		vkProgram_t *program = vk.currentProgram ? vk.currentProgram : vk.builtinProgram;
		GLfloat values[3] = { v0, v1, v2 };
		Com_Memcpy( uniform->offset + program->uboData, values, sizeof( values ) );
	}
}

static void VKGL_Uniform4fARB( GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3 )
{
	vkUniform_t *uniform = VK_UniformByLocation( location );
	if ( uniform && uniform->size >= 16 )
	{
		vkProgram_t *program = vk.currentProgram ? vk.currentProgram : vk.builtinProgram;
		GLfloat values[4] = { v0, v1, v2, v3 };
		Com_Memcpy( uniform->offset + program->uboData, values, sizeof( values ) );
	}
}

static void VKGL_UniformMatrix4fvARB( GLint location, GLsizei count,
                                      GLboolean transpose, const GLfloat *value )
{
	vkUniform_t *uniform = VK_UniformByLocation( location );

	(void)transpose;
	if ( uniform && uniform->type == VKUNI_MAT4 && count > 0 )
	{
		vkProgram_t *program = vk.currentProgram ? vk.currentProgram : vk.builtinProgram;
		Com_Memcpy( uniform->offset + program->uboData, value, 16 * sizeof( GLfloat ) );
	}
}

static void VKGL_GetObjectParameterivARB( GLhandleARB obj, GLenum pname, GLint *params )
{
	vkProgram_t *program = VK_GetProgram( obj );
	vkShaderObject_t *shader = VK_GetShader( obj );

	switch ( pname )
	{
		case GL_OBJECT_LINK_STATUS_ARB:
			*params = program && program->valid ? 1 : 0;
			break;
		case GL_OBJECT_COMPILE_STATUS_ARB:
			*params = shader && shader->compiled ? 1 : 0;
			break;
		case GL_OBJECT_INFO_LOG_LENGTH_ARB:
			*params = ( program || shader ) ? 1 : 0; /* empty string */
			break;
		default:
			*params = 0;
			break;
	}
}

static void VKGL_GetInfoLogARB( GLhandleARB obj, GLsizei maxLength,
                                GLsizei *length, GLcharARB *infoLog )
{
	(void)obj;
	(void)maxLength;
	if ( length )
	{
		*length = 0;
	}
	if ( infoLog )
	{
		*infoLog = 0;
	}
}

static void VK_AppendVertex( const float *xyz, const float *color,
                             const float *tc0, const float *tc1, const float *normal )
{
	vkVertex_t *vertex;

	if ( vk.numImmediate >= ARRAY_LEN( vk.immediate ) )
	{
		return;
	}
	vertex = &vk.immediate[vk.numImmediate++];
	Com_Memcpy( vertex->xyz, xyz, sizeof( vertex->xyz ) );
	Com_Memcpy( vertex->color, color, sizeof( vertex->color ) );
	Com_Memcpy( vertex->tc0, tc0, sizeof( vertex->tc0 ) );
	Com_Memcpy( vertex->tc1, tc1, sizeof( vertex->tc1 ) );
	Com_Memcpy( vertex->normal, normal, sizeof( vertex->normal ) );
}

static void VKGL_Begin( GLenum mode )
{
	vk.beginMode = mode;
	vk.numImmediate = 0;
	vk.inBegin = qtrue;
}

static void VKGL_End( void )
{
	if ( !vk.inBegin )
	{
		return;
	}
	VK_DrawVertices( vk.beginMode, vk.immediate, vk.numImmediate );
	vk.inBegin = qfalse;
	vk.numImmediate = 0;
}

static void VKGL_Vertex3f( GLfloat x, GLfloat y, GLfloat z )
{
	float xyz[3] = { x, y, z };
	if ( vk.inBegin )
	{
		VK_AppendVertex( xyz, vk.currentColorSet ? vk.currentColor : vk.clearColor,
		                 vk.currentTexCoord[0], vk.currentTexCoord[1], vk.currentNormal );
	}
}

static void VKGL_Vertex3fv( const GLfloat *v )
{
	VKGL_Vertex3f( v[0], v[1], v[2] );
}

static void VKGL_Vertex2f( GLfloat x, GLfloat y )
{
	VKGL_Vertex3f( x, y, 0.0f );
}

static void VKGL_Color3f( GLfloat red, GLfloat green, GLfloat blue )
{
	vk.currentColor[0] = red;
	vk.currentColor[1] = green;
	vk.currentColor[2] = blue;
	vk.currentColor[3] = 1.0f;
	vk.currentColorSet = qtrue;
}

static void VKGL_Color4f( GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha )
{
	VKGL_Color3f( red, green, blue );
	vk.currentColor[3] = alpha;
}

static void VKGL_Color4ubv( const GLubyte *v )
{
	vk.currentColor[0] = v[0] / 255.0f;
	vk.currentColor[1] = v[1] / 255.0f;
	vk.currentColor[2] = v[2] / 255.0f;
	vk.currentColor[3] = v[3] / 255.0f;
	vk.currentColorSet = qtrue;
}

static void VKGL_TexCoord2f( GLfloat s, GLfloat t )
{
	vk.currentTexCoord[vk.activeTexture][0] = s;
	vk.currentTexCoord[vk.activeTexture][1] = t;
}

static void VKGL_TexCoord2fv( const GLfloat *v )
{
	VKGL_TexCoord2f( v[0], v[1] );
}

static void VKGL_MultiTexCoord2fARB( GLenum target, GLfloat s, GLfloat t )
{
	int unit = 0;

	if ( target >= GL_TEXTURE0_ARB )
	{
		unit = target - GL_TEXTURE0_ARB;
	}
	if ( unit < 0 || unit >= ARRAY_LEN( vk.currentTexCoord ) )
	{
		return;
	}
	vk.currentTexCoord[unit][0] = s;
	vk.currentTexCoord[unit][1] = t;
}

static void VKGL_ActiveTextureARB( GLenum texture )
{
	if ( texture >= GL_TEXTURE0_ARB )
	{
		vk.activeTexture = texture - GL_TEXTURE0_ARB;
	}
	if ( vk.activeTexture < 0 || vk.activeTexture >= VK_NUM_SAMPLERS )
	{
		vk.activeTexture = 0;
	}
}

static void VKGL_ClientActiveTextureARB( GLenum texture )
{
	VKGL_ActiveTextureARB( texture );
	vk.clientTexture = vk.activeTexture;
}

static void VKGL_EnableClientState( GLenum array )
{
	switch ( array )
	{
		case GL_VERTEX_ARRAY:         vk.clientVertex = qtrue; break;
		case GL_COLOR_ARRAY:          vk.clientColor = qtrue; break;
		case GL_NORMAL_ARRAY:         vk.clientNormal = qtrue; break;
		case GL_TEXTURE_COORD_ARRAY:  vk.clientTexCoord[vk.clientTexture] = qtrue; break;
		default: break;
	}
}

static void VKGL_DisableClientState( GLenum array )
{
	switch ( array )
	{
		case GL_VERTEX_ARRAY:         vk.clientVertex = qfalse; break;
		case GL_COLOR_ARRAY:          vk.clientColor = qfalse; break;
		case GL_NORMAL_ARRAY:         vk.clientNormal = qfalse; break;
		case GL_TEXTURE_COORD_ARRAY:  vk.clientTexCoord[vk.clientTexture] = qfalse; break;
		default: break;
	}
}

static void VKGL_VertexPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *pointer )
{
	(void)type;
	vk.vertexSize = size;
	vk.vertexStride = stride ? stride : size * (int)sizeof( float );
	vk.vertexPointer = pointer;
}

static void VKGL_ColorPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *pointer )
{
	(void)size;
	vk.colorType = type;
	vk.colorSize = size;
	vk.colorStride = stride ? stride : size * ( type == GL_UNSIGNED_BYTE ? 1 : 4 );
	vk.colorPointer = pointer;
}

static void VKGL_NormalPointer( GLenum type, GLsizei stride, const GLvoid *pointer )
{
	(void)type;
	vk.normalStride = stride ? stride : 3 * (int)sizeof( float );
	vk.normalPointer = pointer;
}

static void VKGL_TexCoordPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *pointer )
{
	(void)size;
	(void)type;
	vk.texCoordStride[vk.clientTexture] = stride ? stride : size * (int)sizeof( float );
	vk.texCoordPointer[vk.clientTexture] = pointer;
}

static const byte *VK_PointerAt( const void *pointer, int stride, int index )
{
	return (const byte *)pointer + stride * index;
}

static void VKGL_ArrayElement( GLint index )
{
	float xyz[3] = { 0, 0, 0 };
	float color[4] = { 1, 1, 1, 1 };
	float tc[2] = { 0, 0 };
	float tc1[2] = { 0, 0 };
	float normal[3] = { 0, 0, 1 };

	if ( vk.clientVertex && vk.vertexPointer )
	{
		const float *v = (const float *)VK_PointerAt( vk.vertexPointer, vk.vertexStride, index );
		xyz[0] = v[0];
		xyz[1] = v[1];
		if ( vk.vertexSize > 2 )
		{
			xyz[2] = v[2];
		}
	}
	if ( vk.clientColor && vk.colorPointer )
	{
		if ( vk.colorType == GL_UNSIGNED_BYTE )
		{
			const byte *c = VK_PointerAt( vk.colorPointer, vk.colorStride, index );
			color[0] = c[0] / 255.0f;
			color[1] = c[1] / 255.0f;
			color[2] = c[2] / 255.0f;
			color[3] = vk.colorSize > 3 ? c[3] / 255.0f : 1.0f;
		}
		else
		{
			const float *c = (const float *)VK_PointerAt( vk.colorPointer, vk.colorStride, index );
			Com_Memcpy( color, c, sizeof( float ) * ( vk.colorSize > 4 ? 4 : vk.colorSize ) );
		}
	}
	if ( vk.clientNormal && vk.normalPointer )
	{
		const float *n = (const float *)VK_PointerAt( vk.normalPointer, vk.normalStride, index );
		Com_Memcpy( normal, n, sizeof( normal ) );
	}
	if ( vk.clientTexCoord[0] && vk.texCoordPointer[0] )
	{
		const float *t = (const float *)VK_PointerAt( vk.texCoordPointer[0],
		                                             vk.texCoordStride[0], index );
		Com_Memcpy( tc, t, sizeof( tc ) );
	}
	else
	{
		Com_Memcpy( tc, vk.currentTexCoord[0], sizeof( tc ) );
	}
	if ( vk.clientTexCoord[1] && vk.texCoordPointer[1] )
	{
		const float *t = (const float *)VK_PointerAt( vk.texCoordPointer[1],
		                                             vk.texCoordStride[1], index );
		Com_Memcpy( tc1, t, sizeof( tc1 ) );
	}
	else
	{
		Com_Memcpy( tc1, vk.currentTexCoord[1], sizeof( tc1 ) );
	}

	if ( !vk.inBegin )
	{
		return;
	}
	VK_AppendVertex( xyz, color, tc, tc1, normal );
}

static void VKGL_DrawArrays( GLenum mode, GLint first, GLsizei count )
{
	int i;

	VKGL_Begin( mode );
	for ( i = 0; i < count; i++ )
	{
		VKGL_ArrayElement( first + i );
	}
	VKGL_End();
}

static void VKGL_DrawElements( GLenum mode, GLsizei count, GLenum type, const GLvoid *indices )
{
	int i;
	vkVertex_t *vertices;

	if ( count <= 0 )
	{
		return;
	}
	vertices = ri.Malloc( count * sizeof( vkVertex_t ) );
	if ( !vertices )
	{
		return;
	}
	for ( i = 0; i < count; i++ )
	{
		int index;
		if ( type == GL_UNSIGNED_SHORT )
		{
			index = ( (const GLushort *)indices )[i];
		}
		else if ( type == GL_UNSIGNED_INT )
		{
			index = ( (const GLuint *)indices )[i];
		}
		else
		{
			index = ( (const GLubyte *)indices )[i];
		}

		Com_Memset( &vertices[i], 0, sizeof( vertices[i] ) );
		if ( vk.clientVertex && vk.vertexPointer )
		{
			const float *v = (const float *)VK_PointerAt( vk.vertexPointer, vk.vertexStride, index );
			Com_Memcpy( vertices[i].xyz, v, sizeof( float ) * ( vk.vertexSize > 3 ? 3 : vk.vertexSize ) );
		}
		if ( vk.clientColor && vk.colorPointer )
		{
			if ( vk.colorType == GL_UNSIGNED_BYTE )
			{
				const byte *c = VK_PointerAt( vk.colorPointer, vk.colorStride, index );
				vertices[i].color[0] = c[0] / 255.0f;
				vertices[i].color[1] = c[1] / 255.0f;
				vertices[i].color[2] = c[2] / 255.0f;
				vertices[i].color[3] = vk.colorSize > 3 ? c[3] / 255.0f : 1.0f;
			}
			else
			{
				const float *c = (const float *)VK_PointerAt( vk.colorPointer,
				                                             vk.colorStride, index );
				Com_Memcpy( vertices[i].color, c,
				            sizeof( float ) * ( vk.colorSize > 4 ? 4 : vk.colorSize ) );
			}
		}
		else
		{
			Com_Memcpy( vertices[i].color, vk.currentColorSet ? vk.currentColor : vk.clearColor,
			            sizeof( vertices[i].color ) );
		}
		if ( vk.clientNormal && vk.normalPointer )
		{
			const float *n = (const float *)VK_PointerAt( vk.normalPointer,
			                                             vk.normalStride, index );
			Com_Memcpy( vertices[i].normal, n, sizeof( vertices[i].normal ) );
		}
		if ( vk.clientTexCoord[0] && vk.texCoordPointer[0] )
		{
			const float *t = (const float *)VK_PointerAt( vk.texCoordPointer[0],
			                                             vk.texCoordStride[0], index );
			Com_Memcpy( vertices[i].tc0, t, sizeof( vertices[i].tc0 ) );
		}
		else
		{
			Com_Memcpy( vertices[i].tc0, vk.currentTexCoord[0], sizeof( vertices[i].tc0 ) );
		}
		if ( vk.clientTexCoord[1] && vk.texCoordPointer[1] )
		{
			const float *t = (const float *)VK_PointerAt( vk.texCoordPointer[1],
			                                             vk.texCoordStride[1], index );
			Com_Memcpy( vertices[i].tc1, t, sizeof( vertices[i].tc1 ) );
		}
		else
		{
			Com_Memcpy( vertices[i].tc1, vk.currentTexCoord[1], sizeof( vertices[i].tc1 ) );
		}
	}

	VK_DrawVertices( mode, vertices, count );
	ri.Free( vertices );
}

static void VKGL_LockArraysEXT( GLint first, GLsizei count )
{
	(void)first;
	(void)count;
}

static void VKGL_UnlockArraysEXT( void )
{
}

/* ------------------------------------------------------------------------ */
/* Device setup, presentation and backend entry points                       */
/* ------------------------------------------------------------------------ */

static qboolean VK_CreateBuiltinProgram( void )
{
	vkProgram_t *program;
	byte white[4] = { 255, 255, 255, 255 };

	program = &vk.programs[0];
	vk.numPrograms = 1;
	Q_strncpyz( program->name, "builtin", sizeof( program->name ) );
	program->numUniforms = 0;
	program->uboSize = 0;
	VK_CollectUniforms( vkBuiltinVertexShader, program );
	VK_CollectUniforms( vkBuiltinFragmentShader, program );
	program->vertexModule = VK_CompileShader( vkBuiltinVertexShader, qtrue, program );
	program->fragmentModule = VK_CompileShader( vkBuiltinFragmentShader, qfalse, program );
	program->valid = ( program->vertexModule != VK_NULL_HANDLE &&
	                   program->fragmentModule != VK_NULL_HANDLE ) ? qtrue : qfalse;
	if ( !program->valid )
	{
		ri.Printf( PRINT_ALL, "Vulkan: built-in shader compilation failed.\n" );
		return qfalse;
	}
	vk.builtinProgram = program;
	vk.currentProgram = program;

	/* Texture 0 is used when no texture is bound; make it solid white. */
	vk.boundTextureName = VK_WHITE_TEXTURE;
	VKGL_TexImage2D( GL_TEXTURE_2D, 0, GL_RGBA8, 1, 1, 0, GL_RGBA,
	                 GL_UNSIGNED_BYTE, white );
	vk.boundTextureName = 0;
	return qtrue;
}

qboolean Vkqgl_Available( void )
{
	uint32_t count = 0;
	VkExtensionProperties *extensions;
	uint32_t i;
	qboolean haveSurface = qfalse;
	qboolean haveXlib = qfalse;

	if ( vkEnumerateInstanceExtensionProperties( NULL, &count, NULL ) != VK_SUCCESS ||
	     count == 0 )
	{
		return qfalse;
	}

	extensions = ri.Malloc( count * sizeof( *extensions ) );
	if ( !extensions )
	{
		return qfalse;
	}
	if ( vkEnumerateInstanceExtensionProperties( NULL, &count, extensions ) == VK_SUCCESS )
	{
		for ( i = 0; i < count; i++ )
		{
			if ( !Q_stricmp( extensions[i].extensionName, VK_KHR_SURFACE_EXTENSION_NAME ) )
			{
				haveSurface = qtrue;
			}
			if ( !Q_stricmp( extensions[i].extensionName, VK_KHR_XLIB_SURFACE_EXTENSION_NAME ) )
			{
				haveXlib = qtrue;
			}
		}
	}
	ri.Free( extensions );
	return haveSurface && haveXlib ? qtrue : qfalse;
}

qboolean Vkqgl_Init( void )
{
	const char *instanceExtensions[] = {
		VK_KHR_SURFACE_EXTENSION_NAME,
		VK_KHR_XLIB_SURFACE_EXTENSION_NAME
	};
	const char *deviceExtensions[] = { VK_KHR_SWAPCHAIN_EXTENSION_NAME };
	VkInstanceCreateInfo instanceInfo;
	VkApplicationInfo appInfo;
	VkDeviceCreateInfo deviceInfo;
	VkDeviceQueueCreateInfo queueInfo;
	SDL_SysWMinfo wmInfo;
	VkXlibSurfaceCreateInfoKHR surfaceInfo;
	VkPhysicalDevice *devices;
	uint32_t deviceCount = 0;
	uint32_t i;
	float queuePriority = 1.0f;
	qboolean found = qfalse;
	int width, height;
	float windowAspect;
	int mode;
	int flags = 0;

	Com_Memset( &vk, 0, sizeof( vk ) );
	vk.clearColor[3] = 1.0f;
	vk.clearDepth = 1.0f;
	vk.lineWidth = 1.0f;
	vk.depthFunc = GL_LESS;
	vk.alphaFunc = GL_ALWAYS;
	vk.cullMode = GL_BACK;
	vk.frontFace = GL_CCW;
	vk.polygonMode = GL_FILL;
	vk.colorMask = VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT |
	               VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT;
	vk.nextTextureName = 1;
	vk.matrixMode = 0;
	VKGL_LoadIdentity();
	VKGL_LoadMatrixf( vkIdentity );
	Com_Memcpy( vk.matrices[1], vkIdentity, sizeof( vkIdentity ) );

	if ( !SDL_WasInit( SDL_INIT_VIDEO ) )
	{
		if ( SDL_Init( SDL_INIT_VIDEO ) < 0 )
		{
			ri.Printf( PRINT_ALL, "Vulkan: SDL_Init(SDL_INIT_VIDEO) failed: %s\n", SDL_GetError() );
			return qfalse;
		}
		vk.videoInitialized = qtrue;
	}

	mode = Cvar_VariableIntegerValue( "r_mode" );
	if ( !R_GetModeInfo( &width, &height, &windowAspect, mode ) )
	{
		R_GetModeInfo( &width, &height, &windowAspect, 3 );
	}
	if ( Cvar_VariableIntegerValue( "r_fullscreen" ) )
	{
		flags |= SDL_FULLSCREEN;
	}
	if ( Cvar_VariableIntegerValue( "r_noborder" ) )
	{
		flags |= SDL_NOFRAME;
	}

	SDL_WM_SetCaption( CLIENT_WINDOW_TITLE, CLIENT_WINDOW_MIN_TITLE );
	SDL_ShowCursor( 0 );
	if ( !SDL_SetVideoMode( width, height, 32, flags ) )
	{
		ri.Printf( PRINT_ALL, "Vulkan: SDL_SetVideoMode failed: %s\n", SDL_GetError() );
		Vkqgl_Shutdown();
		return qfalse;
	}

	SDL_VERSION( &wmInfo.version );
	if ( !SDL_GetWMInfo( &wmInfo ) || wmInfo.subsystem != SDL_SYSWM_X11 )
	{
		ri.Printf( PRINT_ALL, "Vulkan: no X11 window available\n" );
		Vkqgl_Shutdown();
		return qfalse;
	}

	Com_Memset( &appInfo, 0, sizeof( appInfo ) );
	appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
	appInfo.pApplicationName = "ZEQ2-Lite";
	appInfo.applicationVersion = VK_MAKE_VERSION( 1, 0, 0 );
	appInfo.pEngineName = "ZEQ2-Lite Vulkan backend";
	appInfo.engineVersion = VK_MAKE_VERSION( 1, 0, 0 );
	appInfo.apiVersion = VK_API_VERSION_1_0;

	Com_Memset( &instanceInfo, 0, sizeof( instanceInfo ) );
	instanceInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
	instanceInfo.pApplicationInfo = &appInfo;
	instanceInfo.enabledExtensionCount = ARRAY_LEN( instanceExtensions );
	instanceInfo.ppEnabledExtensionNames = instanceExtensions;
	if ( vkCreateInstance( &instanceInfo, NULL, &vk.instance ) != VK_SUCCESS )
	{
		ri.Printf( PRINT_ALL, "Vulkan: could not create instance\n" );
		Vkqgl_Shutdown();
		return qfalse;
	}

	Com_Memset( &surfaceInfo, 0, sizeof( surfaceInfo ) );
	surfaceInfo.sType = VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR;
	surfaceInfo.dpy = wmInfo.info.x11.display;
	surfaceInfo.window = wmInfo.info.x11.window;
	if ( vkCreateXlibSurfaceKHR( vk.instance, &surfaceInfo, NULL, &vk.surface ) != VK_SUCCESS )
	{
		ri.Printf( PRINT_ALL, "Vulkan: could not create Xlib surface\n" );
		Vkqgl_Shutdown();
		return qfalse;
	}

	vkEnumeratePhysicalDevices( vk.instance, &deviceCount, NULL );
	if ( deviceCount == 0 )
	{
		ri.Printf( PRINT_ALL, "Vulkan: no physical devices found\n" );
		Vkqgl_Shutdown();
		return qfalse;
	}
	devices = ri.Malloc( deviceCount * sizeof( *devices ) );
	if ( !devices )
	{
		Vkqgl_Shutdown();
		return qfalse;
	}
	vkEnumeratePhysicalDevices( vk.instance, &deviceCount, devices );

	for ( i = 0; i < deviceCount; i++ )
	{
		uint32_t queueCount = 0;
		uint32_t queueFamily;

		vkGetPhysicalDeviceQueueFamilyProperties( devices[i], &queueCount, NULL );
		for ( queueFamily = 0; queueFamily < queueCount; queueFamily++ )
		{
			VkBool32 supportsPresent = VK_FALSE;
			VkQueueFamilyProperties *properties;

			if ( vkGetPhysicalDeviceSurfaceSupportKHR( devices[i], queueFamily,
			                                           vk.surface, &supportsPresent ) != VK_SUCCESS ||
			     !supportsPresent )
			{
				continue;
			}

			properties = ri.Malloc( queueCount * sizeof( *properties ) );
			if ( !properties )
			{
				break;
			}
			vkGetPhysicalDeviceQueueFamilyProperties( devices[i], &queueCount, properties );
			if ( properties[queueFamily].queueFlags & VK_QUEUE_GRAPHICS_BIT )
			{
				vk.physical = devices[i];
				vk.queueFamily = queueFamily;
				found = qtrue;
			}
			ri.Free( properties );
			if ( found )
			{
				break;
			}
		}
		if ( found )
		{
			break;
		}
	}
	ri.Free( devices );

	if ( !found )
	{
		ri.Printf( PRINT_ALL, "Vulkan: no graphics queue with presentation support\n" );
		Vkqgl_Shutdown();
		return qfalse;
	}

	vkGetPhysicalDeviceMemoryProperties( vk.physical, &vk.memoryProps );

	Com_Memset( &queueInfo, 0, sizeof( queueInfo ) );
	queueInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
	queueInfo.queueFamilyIndex = vk.queueFamily;
	queueInfo.queueCount = 1;
	queueInfo.pQueuePriorities = &queuePriority;

	Com_Memset( &deviceInfo, 0, sizeof( deviceInfo ) );
	deviceInfo.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
	deviceInfo.queueCreateInfoCount = 1;
	deviceInfo.pQueueCreateInfos = &queueInfo;
	deviceInfo.enabledExtensionCount = ARRAY_LEN( deviceExtensions );
	deviceInfo.ppEnabledExtensionNames = deviceExtensions;
	if ( vkCreateDevice( vk.physical, &deviceInfo, NULL, &vk.device ) != VK_SUCCESS )
	{
		ri.Printf( PRINT_ALL, "Vulkan: could not create logical device\n" );
		Vkqgl_Shutdown();
		return qfalse;
	}
	vkGetDeviceQueue( vk.device, vk.queueFamily, 0, &vk.queue );

	if ( !VK_FindSurfaceFormat() || !VK_CreateSwapchain( VK_NULL_HANDLE ) ||
	     !VK_CreateAttachments() || !VK_CreateRenderPass() ||
	     !VK_CreateDescriptors() || !VK_CreateCommandResources() )
	{
		Vkqgl_Shutdown();
		return qfalse;
	}

	if ( !VK_CreateBuffer( 16 * 1024 * 1024, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT,
	                       VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT |
	                       VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
	                       &vk.vertexBuffer, &vk.vertexMemory,
	                       (void **)&vk.vertexMapped ) ||
	     !VK_CreateBuffer( 4 * 1024 * 1024, VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT,
	                       VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT |
	                       VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
	                       &vk.uniformBuffer, &vk.uniformMemory,
	                       (void **)&vk.uniformMapped ) ||
	     !VK_CreateBuffer( 16 * 1024 * 1024,
	                       VK_BUFFER_USAGE_TRANSFER_SRC_BIT | VK_BUFFER_USAGE_TRANSFER_DST_BIT,
	                       VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT |
	                       VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
	                       &vk.stagingBuffer, &vk.stagingMemory,
	                       (void **)&vk.stagingMapped ) )
	{
		Vkqgl_Shutdown();
		return qfalse;
	}
	vk.vertexCapacity = 16 * 1024 * 1024;
	vk.uniformCapacity = 4 * 1024 * 1024;
	vk.stagingCapacity = 16 * 1024 * 1024;

	if ( !VK_CreateBuiltinProgram() )
	{
		Vkqgl_Shutdown();
		return qfalse;
	}

	/* Move the attachments out of UNDEFINED before the first render pass. */
	VK_BeginTransient();
	VK_Transition( vk.transientCommand, vk.colorImage, VK_IMAGE_ASPECT_COLOR_BIT,
	               VK_IMAGE_LAYOUT_UNDEFINED, VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL, 0,
	               VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT, VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT,
	               VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, 0, 1 );
	VK_Transition( vk.transientCommand, vk.depthImage, VK_IMAGE_ASPECT_DEPTH_BIT,
	               VK_IMAGE_LAYOUT_UNDEFINED, VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL, 0,
	               VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT,
	               VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT,
	               VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT, 0, 1 );
	if ( !VK_SubmitTransient( vk.transientCommand ) )
	{
		Vkqgl_Shutdown();
		return qfalse;
	}

	Q_strncpyz( glConfig.vendor_string, "ZEQ2-Lite", sizeof( glConfig.vendor_string ) );
	Q_strncpyz( glConfig.renderer_string, "Vulkan translation renderer",
	            sizeof( glConfig.renderer_string ) );
	Q_strncpyz( glConfig.version_string, "Vulkan 1.0", sizeof( glConfig.version_string ) );
	Q_strncpyz( glConfig.extensions_string,
	            "GL_ARB_multitexture GL_ARB_shader_objects GL_ARB_vertex_shader "
	            "GL_EXT_texture_env_add GL_EXT_compiled_vertex_array",
	            sizeof( glConfig.extensions_string ) );
	glConfig.vidWidth = width;
	glConfig.vidHeight = height;
	glConfig.windowAspect = windowAspect;
	glConfig.isFullscreen = ( flags & SDL_FULLSCREEN ) != 0;
	glConfig.colorBits = 32;
	glConfig.depthBits = 32;
	glConfig.stencilBits = 0;
	glConfig.deviceSupportsGamma = qfalse;
	glConfig.driverType = GLDRV_ICD;
	glConfig.hardwareType = GLHW_GENERIC;
	glConfig.numTextureUnits = VK_NUM_SAMPLERS;
	glConfig.textureEnvAddAvailable = qtrue;
	glConfig.textureCompression = TC_NONE;
	glConfig.maxTextureSize = 8192;

	QGL_SetVulkanARBDispatch();
	VK_BeginRenderPass();
	vk.initialized = qtrue;

	ri.Printf( PRINT_ALL, "Vulkan backend initialized (%dx%d)\n", width, height );
	return qtrue;
}

void Vkqgl_Present( void )
{
	VkSubmitInfo submitInfo;
	VkPresentInfoKHR presentInfo;
	VkResult acquireResult;
	VkResult presentResult = VK_SUCCESS;
	uint32_t imageIndex = 0;
	VkCommandBuffer commands[1];
	VkSemaphore waitSemaphores[1];
	VkSemaphore signalSemaphores[1];
	VkPipelineStageFlags waitStages[1];
	qboolean recreate = qfalse;
	qboolean acquireSuboptimal = qfalse;

	if ( !vk.initialized )
	{
		return;
	}

	/* Acquire before touching the fence or command buffer: a failed acquire
	   must never leave an unsignaled fence that the next frame waits on. */
	acquireResult = vkAcquireNextImageKHR( vk.device, vk.swapchain, UINT64_MAX,
	                                       vk.imageAvailable, VK_NULL_HANDLE, &imageIndex );
	if ( ( acquireResult != VK_SUCCESS && acquireResult != VK_SUBOPTIMAL_KHR ) ||
	     imageIndex >= vk.numSwapImages )
	{
		if ( acquireResult == VK_ERROR_OUT_OF_DATE_KHR || imageIndex >= vk.numSwapImages )
		{
			if ( !VK_RecreateSwapchain() )
			{
				vk.initialized = qfalse;
			}
		}
		return;
	}
	/* VK_SUBOPTIMAL_KHR still returns a usable image; present it once, then
	   recreate the swapchain for the next frame. */
	acquireSuboptimal = acquireResult == VK_SUBOPTIMAL_KHR ? qtrue : qfalse;
	vk.swapIndex = imageIndex;

	if ( !VK_Check( vkWaitForFences( vk.device, 1, &vk.fence, VK_TRUE, UINT64_MAX ),
	                "vkWaitForFences" ) )
	{
		return;
	}

	if ( vk.inRenderPass )
	{
		vkCmdEndRenderPass( vk.commandBuffer );
		vk.inRenderPass = qfalse;
	}

	VK_Transition( vk.commandBuffer, vk.colorImage, VK_IMAGE_ASPECT_COLOR_BIT,
	               VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
	               VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL,
	               VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT, VK_ACCESS_TRANSFER_READ_BIT,
	               VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
	               VK_PIPELINE_STAGE_TRANSFER_BIT, 0, 1 );
	VK_Transition( vk.commandBuffer, vk.swapImages[imageIndex], VK_IMAGE_ASPECT_COLOR_BIT,
	               VK_IMAGE_LAYOUT_UNDEFINED, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
	               0, VK_ACCESS_TRANSFER_WRITE_BIT,
	               VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT, VK_PIPELINE_STAGE_TRANSFER_BIT, 0, 1 );
	{
		VkImageCopy copy;
		Com_Memset( &copy, 0, sizeof( copy ) );
		copy.srcSubresource.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
		copy.srcSubresource.layerCount = 1;
		copy.dstSubresource.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
		copy.dstSubresource.layerCount = 1;
		copy.extent.width = vk.extent.width;
		copy.extent.height = vk.extent.height;
		copy.extent.depth = 1;
		vkCmdCopyImage( vk.commandBuffer, vk.colorImage,
		                VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL,
		                vk.swapImages[imageIndex], VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
		                1, &copy );
	}
	VK_Transition( vk.commandBuffer, vk.swapImages[imageIndex], VK_IMAGE_ASPECT_COLOR_BIT,
	               VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
	               VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,
	               VK_ACCESS_TRANSFER_WRITE_BIT, VK_ACCESS_MEMORY_READ_BIT,
	               VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, 0, 1 );
	VK_Transition( vk.commandBuffer, vk.colorImage, VK_IMAGE_ASPECT_COLOR_BIT,
	               VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL,
	               VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
	               VK_ACCESS_TRANSFER_READ_BIT, VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT,
	               VK_PIPELINE_STAGE_TRANSFER_BIT,
	               VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, 0, 1 );

	if ( !VK_Check( vkEndCommandBuffer( vk.commandBuffer ), "vkEndCommandBuffer" ) )
	{
		vk.initialized = qfalse;
		return;
	}
	vk.recording = qfalse;

	commands[0] = vk.commandBuffer;
	waitSemaphores[0] = vk.imageAvailable;
	waitStages[0] = VK_PIPELINE_STAGE_TRANSFER_BIT;
	signalSemaphores[0] = vk.renderFinished;

	Com_Memset( &submitInfo, 0, sizeof( submitInfo ) );
	submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
	submitInfo.waitSemaphoreCount = 1;
	submitInfo.pWaitSemaphores = waitSemaphores;
	submitInfo.pWaitDstStageMask = waitStages;
	submitInfo.commandBufferCount = 1;
	submitInfo.pCommandBuffers = commands;
	submitInfo.signalSemaphoreCount = 1;
	submitInfo.pSignalSemaphores = signalSemaphores;

	/* Reset only after acquire and immediately before a submit that we expect
	   to succeed; a failed submit leaves the backend shut down, not stalled. */
	if ( !VK_Check( vkResetFences( vk.device, 1, &vk.fence ), "vkResetFences" ) ||
	     !VK_Check( vkQueueSubmit( vk.queue, 1, &submitInfo, vk.fence ), "vkQueueSubmit" ) )
	{
		vk.initialized = qfalse;
		return;
	}

	Com_Memset( &presentInfo, 0, sizeof( presentInfo ) );
	presentInfo.sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;
	presentInfo.waitSemaphoreCount = 1;
	presentInfo.pWaitSemaphores = signalSemaphores;
	presentInfo.swapchainCount = 1;
	presentInfo.pSwapchains = &vk.swapchain;
	presentInfo.pImageIndices = &imageIndex;
	presentResult = vkQueuePresentKHR( vk.queue, &presentInfo );
	if ( presentResult != VK_SUCCESS && presentResult != VK_ERROR_OUT_OF_DATE_KHR &&
	     presentResult != VK_SUBOPTIMAL_KHR )
	{
		VK_Check( presentResult, "vkQueuePresentKHR" );
	}

	/* Descriptor sets and vertex/uniform data may only be reused after this
	   frame's submit has completed, not directly after vkQueueSubmit(). */
	if ( !VK_Check( vkWaitForFences( vk.device, 1, &vk.fence, VK_TRUE, UINT64_MAX ),
	                "vkWaitForFences" ) )
	{
		vk.initialized = qfalse;
		return;
	}
	recreate = acquireSuboptimal || presentResult == VK_ERROR_OUT_OF_DATE_KHR ||
	           presentResult == VK_SUBOPTIMAL_KHR ? qtrue : qfalse;

	vk.vertexUsed = 0;
	vk.uniformUsed = 0;
	vk.numDescriptorSets = 0;
	VK_Check( vkResetDescriptorPool( vk.device, vk.descriptorPool, 0 ),
	          "vkResetDescriptorPool" );
	if ( !VK_Check( vkResetCommandBuffer( vk.commandBuffer, 0 ), "vkResetCommandBuffer" ) )
	{
		vk.initialized = qfalse;
		return;
	}
	if ( recreate )
	{
		if ( !VK_RecreateSwapchain() )
		{
			vk.initialized = qfalse;
		}
	}
	else
	{
		VK_BeginRenderPass();
	}
}

void Vkqgl_Shutdown( void )
{
	int i;
	qboolean videoInitialized;

	if ( !vk.instance && !vk.videoInitialized )
	{
		return;
	}
	videoInitialized = vk.videoInitialized;
	vk.initialized = qfalse;

	for ( i = 0; i < ARRAY_LEN( vkShaders ); i++ )
	{
		if ( vkShaders[i].source )
		{
			ri.Free( vkShaders[i].source );
			vkShaders[i].source = NULL;
		}
	}

	if ( vk.device != VK_NULL_HANDLE )
	{
		vkDeviceWaitIdle( vk.device );

		for ( i = 0; i < vk.numPrograms; i++ )
		{
			if ( vk.programs[i].vertexModule != VK_NULL_HANDLE )
			{
				vkDestroyShaderModule( vk.device, vk.programs[i].vertexModule, NULL );
			}
			if ( vk.programs[i].fragmentModule != VK_NULL_HANDLE )
			{
				vkDestroyShaderModule( vk.device, vk.programs[i].fragmentModule, NULL );
			}
		}
		for ( i = 0; i < vk.numPipelines; i++ )
		{
			if ( vk.pipelines[i].pipeline != VK_NULL_HANDLE )
			{
				vkDestroyPipeline( vk.device, vk.pipelines[i].pipeline, NULL );
			}
		}
		for ( i = 0; i < ARRAY_LEN( vk.textures ); i++ )
		{
			if ( vk.textures[i].view != VK_NULL_HANDLE )
			{
				vkDestroyImageView( vk.device, vk.textures[i].view, NULL );
			}
			if ( vk.textures[i].image != VK_NULL_HANDLE )
			{
				vkDestroyImage( vk.device, vk.textures[i].image, NULL );
			}
			if ( vk.textures[i].memory != VK_NULL_HANDLE )
			{
				vkFreeMemory( vk.device, vk.textures[i].memory, NULL );
			}
		}
		for ( i = 0; i < ARRAY_LEN( vk.samplers ); i++ )
		{
			if ( vk.samplers[i] != VK_NULL_HANDLE )
			{
				vkDestroySampler( vk.device, vk.samplers[i], NULL );
			}
		}

		if ( vk.vertexMapped )
		{
			vkUnmapMemory( vk.device, vk.vertexMemory );
		}
		if ( vk.uniformMapped )
		{
			vkUnmapMemory( vk.device, vk.uniformMemory );
		}
		if ( vk.stagingMapped )
		{
			vkUnmapMemory( vk.device, vk.stagingMemory );
		}
		if ( vk.vertexBuffer != VK_NULL_HANDLE )
		{
			vkDestroyBuffer( vk.device, vk.vertexBuffer, NULL );
		}
		if ( vk.vertexMemory != VK_NULL_HANDLE )
		{
			vkFreeMemory( vk.device, vk.vertexMemory, NULL );
		}
		if ( vk.uniformBuffer != VK_NULL_HANDLE )
		{
			vkDestroyBuffer( vk.device, vk.uniformBuffer, NULL );
		}
		if ( vk.uniformMemory != VK_NULL_HANDLE )
		{
			vkFreeMemory( vk.device, vk.uniformMemory, NULL );
		}
		if ( vk.stagingBuffer != VK_NULL_HANDLE )
		{
			vkDestroyBuffer( vk.device, vk.stagingBuffer, NULL );
		}
		if ( vk.stagingMemory != VK_NULL_HANDLE )
		{
			vkFreeMemory( vk.device, vk.stagingMemory, NULL );
		}

		if ( vk.fence != VK_NULL_HANDLE )
		{
			vkDestroyFence( vk.device, vk.fence, NULL );
		}
		if ( vk.imageAvailable != VK_NULL_HANDLE )
		{
			vkDestroySemaphore( vk.device, vk.imageAvailable, NULL );
		}
		if ( vk.renderFinished != VK_NULL_HANDLE )
		{
			vkDestroySemaphore( vk.device, vk.renderFinished, NULL );
		}
		if ( vk.commandPool != VK_NULL_HANDLE )
		{
			vkDestroyCommandPool( vk.device, vk.commandPool, NULL );
		}
		if ( vk.transientPool != VK_NULL_HANDLE && vk.transientPool != vk.commandPool )
		{
			vkDestroyCommandPool( vk.device, vk.transientPool, NULL );
		}
		if ( vk.descriptorPool != VK_NULL_HANDLE )
		{
			vkDestroyDescriptorPool( vk.device, vk.descriptorPool, NULL );
		}
		if ( vk.descriptorLayout != VK_NULL_HANDLE )
		{
			vkDestroyDescriptorSetLayout( vk.device, vk.descriptorLayout, NULL );
		}
		if ( vk.pipelineLayout != VK_NULL_HANDLE )
		{
			vkDestroyPipelineLayout( vk.device, vk.pipelineLayout, NULL );
		}
		if ( vk.framebuffer != VK_NULL_HANDLE )
		{
			vkDestroyFramebuffer( vk.device, vk.framebuffer, NULL );
		}
		if ( vk.renderPass != VK_NULL_HANDLE )
		{
			vkDestroyRenderPass( vk.device, vk.renderPass, NULL );
		}
		VK_DestroyAttachments();
		VK_DestroySwapchain();
		vkDestroyDevice( vk.device, NULL );
	}

	if ( vk.instance != VK_NULL_HANDLE )
	{
		if ( vk.surface != VK_NULL_HANDLE )
		{
			vkDestroySurfaceKHR( vk.instance, vk.surface, NULL );
		}
		vkDestroyInstance( vk.instance, NULL );
	}

	Com_Memset( &vk, 0, sizeof( vk ) );
	Com_Memset( vkShaders, 0, sizeof( vkShaders ) );
	if ( videoInitialized )
	{
		SDL_QuitSubSystem( SDL_INIT_VIDEO );
	}
}

void QGL_SetVulkanARBDispatch( void )
{
#define SET_ARB(name) qgl##name = (void *)VKGL_##name
	SET_ARB( ActiveTextureARB );
	SET_ARB( ClientActiveTextureARB );
	SET_ARB( MultiTexCoord2fARB );
	SET_ARB( LockArraysEXT );
	SET_ARB( UnlockArraysEXT );
	SET_ARB( DeleteObjectARB );
	SET_ARB( CreateShaderObjectARB );
	SET_ARB( ShaderSourceARB );
	SET_ARB( CompileShaderARB );
	SET_ARB( CreateProgramObjectARB );
	SET_ARB( AttachObjectARB );
	SET_ARB( LinkProgramARB );
	SET_ARB( UseProgramObjectARB );
	SET_ARB( Uniform1fARB );
	SET_ARB( Uniform2fARB );
	SET_ARB( Uniform3fARB );
	SET_ARB( Uniform4fARB );
	SET_ARB( Uniform1iARB );
	SET_ARB( UniformMatrix4fvARB );
	SET_ARB( GetObjectParameterivARB );
	SET_ARB( GetInfoLogARB );
	SET_ARB( GetUniformLocationARB );
#undef SET_ARB
}

void Vkqgl_InstallDispatch( qglFunctionPointer *table )
{
#define INSTALL(name) table[QGLFN_##name].object = (void *)VKGL_##name
	table[QGLFNARB_qglActiveTextureARB].object = (void *)VKGL_ActiveTextureARB;
	INSTALL( AlphaFunc );
	table[QGLFN_ArrayElement].object = (void *)VKGL_ArrayElement;
	INSTALL( Begin );
	INSTALL( BindTexture );
	INSTALL( BlendFunc );
	table[QGLFN_DrawArrays].object = (void *)VKGL_DrawArrays;
	INSTALL( Clear );
	INSTALL( ClearColor );
	INSTALL( ClearDepth );
	INSTALL( ClearStencil );
	INSTALL( ClipPlane );
	INSTALL( Color3f );
	INSTALL( Color4f );
	INSTALL( Color4ubv );
	INSTALL( ColorMask );
	INSTALL( ColorPointer );
	INSTALL( CopyTexImage2D );
	INSTALL( CopyTexSubImage2D );
	INSTALL( CullFace );
	INSTALL( DeleteTextures );
	INSTALL( DepthFunc );
	INSTALL( DepthMask );
	INSTALL( DepthRange );
	INSTALL( Disable );
	INSTALL( DisableClientState );
	INSTALL( DrawBuffer );
	table[QGLFN_DrawElements].object = (void *)VKGL_DrawElements;
	INSTALL( Enable );
	INSTALL( EnableClientState );
	INSTALL( End );
	INSTALL( Finish );
	INSTALL( Flush );
	INSTALL( Fogf );
	INSTALL( Fogfv );
	INSTALL( Fogi );
	INSTALL( FrontFace );
	INSTALL( GenTextures );
	INSTALL( GetBooleanv );
	INSTALL( GetError );
	INSTALL( GetFloatv );
	INSTALL( GetIntegerv );
	INSTALL( IsEnabled );
	INSTALL( GetString );
	INSTALL( Hint );
	INSTALL( LineWidth );
	INSTALL( LoadIdentity );
	INSTALL( LoadMatrixf );
	INSTALL( MatrixMode );
	table[QGLFN_MultMatrixf].object = (void *)VKGL_MultMatrixf;
	INSTALL( NormalPointer );
	INSTALL( Ortho );
	table[QGLFN_Frustum].object = (void *)VKGL_Frustum;
	table[QGLFN_Rotatef].object = (void *)VKGL_Rotatef;
	table[QGLFN_Scalef].object = (void *)VKGL_Scalef;
	INSTALL( PolygonMode );
	INSTALL( PolygonOffset );
	INSTALL( PopMatrix );
	INSTALL( PushMatrix );
	INSTALL( ReadPixels );
	INSTALL( Scissor );
	INSTALL( ShadeModel );
	INSTALL( StencilFunc );
	INSTALL( StencilMask );
	INSTALL( StencilOp );
	INSTALL( TexCoord2f );
	INSTALL( TexCoord2fv );
	INSTALL( TexCoordPointer );
	INSTALL( TexEnvf );
	INSTALL( TexEnvfv );
	INSTALL( TexImage2D );
	INSTALL( TexParameterf );
	INSTALL( TexParameterfv );
	INSTALL( TexParameteri );
	table[QGLFN_GetTexParameteriv].object = (void *)VKGL_GetTexParameteriv;
	INSTALL( TexSubImage2D );
	INSTALL( Translatef );
	table[QGLFN_Vertex2f].object = (void *)VKGL_Vertex2f;
	table[QGLFN_Vertex3f].object = (void *)VKGL_Vertex3f;
	table[QGLFN_Vertex3fv].object = (void *)VKGL_Vertex3fv;
	INSTALL( VertexPointer );
	INSTALL( Viewport );
#undef INSTALL
}

#endif /* HAVE_VULKAN */
