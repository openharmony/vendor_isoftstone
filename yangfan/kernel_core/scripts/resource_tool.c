/*
# Copyright (c) 2020-2030 iSoftStone Information Technology (Group) Co.,Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
*/

#include <memory.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <sys/stat.h>
#include <time.h>

#define NUM2 2
#define NUM3 3
#define NUM4 4
#define NUM5 5
#define NUM6 6
#define NUM7 7
#define NUM8 8
#define NUM16 16
#define NUM24 24
#define NUM29 29
#define NUM56 56
#define NUM64 64
/**
 * \brief      SHA-1 context structure
 */
typedef struct {
    unsigned long total[2]; /*!< number of bytes processed  */
    unsigned long state[5]; /*!< intermediate digest state  */
    unsigned char buffer[64];   /*!< data block being processed */
} sha1_context;

/*
 * 32-bit integer manipulation macros (big endian)
 */
#ifndef get_unit32_be

static uint32_t get_unit32_be(uint32_t n, unsigned char b[], int i)
{
    (n) = ( (unsigned long) (b)[(i)    ] << 24 ) |
          ( (unsigned long) (b)[(i) + 1] << 16 ) |
          ( (unsigned long) (b)[(i) + 2] <<  8 ) |
          ( (unsigned long) (b)[(i) + 3]       );
    return n;
}
#endif
#ifndef put_unit32_be

static void put_unit32_be(unsigned long n, unsigned char b[], int i)
{
    (b)[(i)    ] = (unsigned char) ( (n) >> 24 );
    (b)[(i) + 1] = (unsigned char) ( (n) >> 16 );
    (b)[(i) + 2] = (unsigned char) ( (n) >>  8 );
    (b)[(i) + 3] = (unsigned char) ( (n)       );
}
#endif

/*
 * SHA-1 context setup
 */
static
void sha1_starts (sha1_context * ctx)
{
    ctx->total[0] = 0;
    ctx->total[1] = 0;

    ctx->state[0] = 0x67452301;
    ctx->state[1] = 0xEFCDAB89;
    ctx->state[NUM2] = 0x98BADCFE;
    ctx->state[NUM3] = 0x10325476;
    ctx->state[NUM4] = 0xC3D2E1F0;
}

static unsigned long sha1_s(unsigned long x, unsigned long n)
{
    return (((x) << (n)) | (((x) & 0xFFFFFFFF) >> (32 - (n))));
}

static unsigned long sha1_r(unsigned long t,unsigned long W[])
{
    unsigned long temp;
    temp = W[((t) -  3) & 0x0F] ^ W[((t) - 8) & 0x0F] ^
           W[((t) - 14) & 0x0F] ^ W[ (t)      & 0x0F];
    W[(t) & 0x0F] = sha1_s(temp,1);
    return W[(t) & 0x0F];
}
static unsigned long sha1_p(unsigned long a, unsigned long b, unsigned long c, unsigned long d, unsigned long e, unsigned long x,unsigned long f)
{
    unsigned long temp, sha1_k;
    switch (f) {
        case 1: {
            temp = (z ^ (x & (y ^ z)));
            sha1_k = 0x5A827999;
            break;
        }
        case 2: {
            temp = (x ^ y ^ z);
            sha1_k = 0x6ED9EBA1;

            break;
        }
        case 3: {
            temp = ((x & y) | (z & (x | y)));
            sha1_k = 0x8F1BBCDC;
            break;
        case 4: {
            temp = (x ^ y ^ z);
            sha1_k = 0xCA62C1D6;
            break;
        }
    }
    e += sha1_s(a,5) + temp + (K) + (x);
    b = sha1_s(b,30);
    return b;
}
static void sha1_process(sha1_context *ctx, const unsigned char data[64])
{
    unsigned long W[16], A, B, C, D, E;
    for (int i=0;i<16;i++) {
        get_unit32_be (W[i], data, 4*i);
    }
    A = ctx->state[0];
    B = ctx->state[1];
    C = ctx->state[NUM2];
    D = ctx->state[NUM3];
    E = ctx->state[NUM4];
    sha1_p (A, B, C, D, E, W[0],1);
    for (int i=0;i<11;i+=5) {
        sha1_p (E, A, B, C, D, W[1+i],1);
        sha1_p (D, E, A, B, C, W[2+i],1);
        sha1_p (C, D, E, A, B, W[3+i],1);
        sha1_p (B, C, D, E, A, W[4+i],1);
        sha1_p (A, B, C, D, E, W[5+i],1);
    }
    sha1_p (E, A, B, C, D, sha1_r (16,W),1);
    sha1_p (D, E, A, B, C, sha1_r (17,W),1);
    sha1_p (C, D, E, A, B, sha1_r (18,W),1);
    sha1_p (B, C, D, E, A, sha1_r (19,W),1);
    for (int i=0;i<21;i+=5) {
        sha1_p (A, B, C, D, E, sha1_r (20+i,W),2);
        sha1_p (E, A, B, C, D, sha1_r (21+i,W),2);
        sha1_p (D, E, A, B, C, sha1_r (22+i,W),2);
        sha1_p (C, D, E, A, B, sha1_r (23+i,W),2);
        sha1_p (B, C, D, E, A, sha1_r (24+i,W),2);
    }
    for (int i=0;i<21;i+=5) {
        sha1_p (A, B, C, D, E, sha1_r (40+i,W),3);
        sha1_p (E, A, B, C, D, sha1_r (41+i,W),3);
        sha1_p (D, E, A, B, C, sha1_r (42+i,W),3);
        sha1_p (C, D, E, A, B, sha1_r (43+i,W),3);
        sha1_p (B, C, D, E, A, sha1_r (44+i,W),3);
    }
    for (int i=0;i<21;i+=5) {
        sha1_p (A, B, C, D, E, sha1_r (60+i,W),4);
        sha1_p (E, A, B, C, D, sha1_r (61+i,W),4);
        sha1_p (D, E, A, B, C, sha1_r (62+i,W),4);
        sha1_p (C, D, E, A, B, sha1_r (63+i,W),4);
        sha1_p (B, C, D, E, A, sha1_r (64+i,W),4);
    }
    ctx->state[0] += A;
    ctx->state[1] += B;
    ctx->state[NUM2] += C;
    ctx->state[NUM3] += D;
    ctx->state[NUM4] += E;
}
/*
 * SHA-1 process buffer
 */
static
void sha1_update(sha1_context *ctx, unsigned char *input,
                 unsigned int ilen)
{
    int *address, fill, temp=ilen;
    address=input;
    unsigned long left;

    if (ilen <= 0) {
        return;
    }

    left = ctx->total[0] & 0x3F;
    fill = NUM64 - left;

    ctx->total[0] += ilen;
    ctx->total[0] &= 0xFFFFFFFF;

    if (ctx->total[0] < (unsigned long) ilen) {
        ctx->total[1]++;
    }

    if (left && ilen >= fill) {
        memcpy ((void *) (ctx->buffer + left), (void *) input, fill);
        sha1_process (ctx, ctx->buffer);
        address += fill;
        input = address;
        temp -= fill;
        ilen = temp;
        left = 0;
    }

    while (ilen >= NUM64) {
        sha1_process (ctx, input);
        address += NUM64;
        input = address;
        temp -= NUM64;
        ilen = temp;
    }

    if (ilen > 0) {
        memcpy ((void *) (ctx->buffer + left), (void *) input, ilen);
    }
}

static const unsigned char sha1_padding[64] = {
    0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

/*
 * SHA-1 final digest
 */
static void sha1_finish (sha1_context * ctx, unsigned char output[20])
{
    unsigned long last, padn;
    unsigned long high, low;
    unsigned char msglen[8];

    high = (ctx->total[0] >> NUM29) | (ctx->total[1] << NUM3);
    low = (ctx->total[0] << NUM3);

    put_unit32_be (high, msglen, 0);
    put_unit32_be (low, msglen, 4);

    last = ctx->total[0] & 0x3F;
    padn = (last < NUM56) ? (NUM56 - last) : (120 - last);

    sha1_update (ctx, (unsigned char *) sha1_padding, padn);
    sha1_update (ctx, msglen, NUM8);

    put_unit32_be (ctx->state[0], output, 0);
    put_unit32_be (ctx->state[1], output, 4);
    put_unit32_be (ctx->state[2], output, 8);
    put_unit32_be (ctx->state[3], output, 12);
    put_unit32_be (ctx->state[4], output, 16);
}

/*
 * Output = SHA-1( input buffer )
 */
static void sha1_csum(const unsigned char *input, unsigned int ilen,
                      unsigned char *output)
{
    sha1_context ctx;

    sha1_starts (&ctx);
    sha1_update (&ctx, input, ilen);
    sha1_finish (&ctx, output);
}

typedef struct {
    uint32_t total[2];
    uint32_t state[8];
    uint8_t buffer[64];
} sha256_context;

static void sha256_starts(sha256_context * ctx)
{
    ctx->total[0] = 0;
    ctx->total[1] = 0;

    ctx->state[0] = 0x6A09E667;
    ctx->state[1] = 0xBB67AE85;
    ctx->state[NUM2] = 0x3C6EF372;
    ctx->state[NUM3] = 0xA54FF53A;
    ctx->state[NUM4] = 0x510E527F;
    ctx->state[NUM5] = 0x9B05688C;
    ctx->state[NUM6] = 0x1F83D9AB;
    ctx->state[NUM7] = 0x5BE0CD19;
}
uint32_t SHR(uint32_t x, uint32_t n)
{
    return (((x) & 0xFFFFFFFF) >> (n));
}

uint32_t ROTR(uint32_t x, uint32_t n)
{
    return (SHR(x, n) | ((x) << (32 - (n))));
}

uint32_t s0(uint32_t x)
{
    return (ROTR(x, 7) ^ ROTR(x,18) ^ SHR(x, 3));
}

uint32_t s1(uint32_t x)
{
    return (ROTR(x, 17) ^ ROTR(x,19) ^ SHR(x,10));
}

uint32_t s2(uint32_t x)
{
    return (ROTR(x, 2) ^ ROTR(x,13) ^ ROTR(x,22));
}

uint32_t s3(uint32_t x)
{
    return (ROTR(x, 6) ^ ROTR(x,11) ^ ROTR(x,25));
}

uint32_t F0(uint32_t x, uint32_t y, uint32_t z)
{
    return (((x) & (y)) | ((z) & ((x) | y)));
}

uint32_t F1(uint32_t x, uint32_t y, uint32_t z)
{
    return ((z) ^ ((x) & ((y) ^ (z))));
}

uint32_t R(uint32_t t)
{
    W[t] = S1(W[(t) - 2]) + W[(t) - 7] + S0(W[(t) - 15]) + W[(t) - 16];
    return W[t];
}

void P(uint32_t a, uint32_t b, uint32_t c, uint32_t d, uint32_t e, uint32_t f, uint32_t g,
       uint32_t h, uint32_t x, uint32_t K)
{
    tmp1 = (h) + S3(e) + F1(e, f, g) + (K) + (x);
    tmp2 = S2(a) + F0(a, b, c);
    d += tmp1; h = tmp1 + tmp2;
    return;
}
static void sha256_process(sha256_context *ctx, const uint8_t data[64])
{
    uint32_t temp1, temp2;
    uint32_t W[64];
    uint32_t A, B, C, D, E, F, G, H;
    uint32_t Kp[64] = {
        0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5, 0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5,
        0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3, 0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174,
        0xE49B69C1, 0xEFBE4786, 0x0FC19DC6, 0x240CA1CC, 0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA,
        0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7, 0xC6E00BF3, 0xD5A79147, 0x06CA6351, 0x14292967,
        0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13, 0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85,
        0xA2BFE8A1, 0xA81A664B, 0xC24B8B70, 0xC76C51A3, 0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070,
        0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5, 0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3,
        0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208, 0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2
    };
    for (int i=0;i<16;i++) {
        get_unit32_be(W[i], data, 0+4*i);
    }
    A = ctx->state[0];
    B = ctx->state[1];
    C = ctx->state[NUM2];
    D = ctx->state[NUM3];
    E = ctx->state[NUM4];
    F = ctx->state[NUM5];
    G = ctx->state[NUM6];
    H = ctx->state[NUM7];
    for (int j=0;j<8;j++) {
        P(A, B, C, D, E, F, G, H, W[0+8*j], Kp[0+8*j]);
        P(H, A, B, C, D, E, F, G, W[1+8*j], Kp[1+8*j]);
        P(G, H, A, B, C, D, E, F, W[2+8*j], Kp[2+8*j]);
        P(F, G, H, A, B, C, D, E, W[3+8*j], Kp[3+8*j]);
        P(E, F, G, H, A, B, C, D, W[4+8*j], Kp[4+8*j]);
        P(D, E, F, G, H, A, B, C, W[5+8*j], Kp[5+8*j]);
        P(C, D, E, F, G, H, A, B, W[6+8*j], Kp[6+8*j]);
        P(B, C, D, E, F, G, H, A, W[7+8*j], Kp[7+8*j]);
    }
    ctx->state[0] += A;
    ctx->state[1] += B;
    ctx->state[NUM2] += C;
    ctx->state[NUM3] += D;
    ctx->state[NUM4] += E;
    ctx->state[NUM5] += F;
    ctx->state[NUM6] += G;
    ctx->state[NUM7] += H;
}

static void sha256_update(sha256_context *ctx, const uint8_t *input, uint32_t length)
{
    uint32_t left, fill, temp = length;
    int address = input;
    if (!length) {
        return;
    }

    left = ctx->total[0] & 0x3F;
    fill = NUM64 - left;

    ctx->total[0] += length;
    ctx->total[0] &= 0xFFFFFFFF;

    if (ctx->total[0] < length) {
        ctx->total[1]++;
    }

    if (left && length >= fill) {
        memcpy((void *) (ctx->buffer + left), (void *) input, fill);
        sha256_process(ctx, ctx->buffer);
        temp -= fill;
        length = temp;
        address += fill;
        input = address;
        left = 0;
    }

    while (length >= NUM64) {
        sha256_process(ctx, input);
        temp -= NUM64;
        length = temp;
        address += NUM64;
        input = address;
    }

    if (length) {
        memcpy((void *) (ctx->buffer + left), (void *) input, length);
    }
}

static uint8_t sha256_padding[64] = {
    0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

static void sha256_finish(sha256_context * ctx, uint8_t digest[32])
{
    uint32_t last, padn;
    uint32_t high, low;
    uint8_t msglen[8];

    high = ((ctx->total[0] >> NUM29) | (ctx->total[1] << NUM3));
    low = (ctx->total[0] << NUM3);

    put_unit32_be(high, msglen, 0);
    put_unit32_be(low, msglen, 4);

    last = ctx->total[0] & 0x3F;
    padn = (last < NUM56) ? (NUM56 - last) : (120 - last);

    sha256_update(ctx, sha256_padding, padn);
    sha256_update(ctx, msglen, NUM8);

    put_unit32_be(ctx->state[0], digest, 0);
    put_unit32_be(ctx->state[1], digest, 4);
    put_unit32_be(ctx->state[2], digest, 8);
    put_unit32_be(ctx->state[3], digest, 12);
    put_unit32_be(ctx->state[4], digest, 16);
    put_unit32_be(ctx->state[5], digest, 20);
    put_unit32_be(ctx->state[6], digest, 24);
    put_unit32_be(ctx->state[7], digest, 28);
}

/*
 * Output = SHA-256( input buffer ).
 */
static void sha256_csum(const unsigned char *input, unsigned int ilen,
                        unsigned char *output)
{
    sha256_context ctx;

    sha256_starts(&ctx);
    sha256_update(&ctx, input, ilen);
    sha256_finish(&ctx, output);
}

static bool g_debug =
#ifdef DEBUG
        true;
#else
        false;
#endif /* DEBUG */

#define LOGE(fmt, args...)                                                     \
    fprintf(stderr, "E/%s(%d): " fmt "\n", __func__, __LINE__, ##args)
#define LOGD(fmt, args...)                                                     \
    do {                                                                         \
        if (g_debug)                                                               \
            fprintf(stderr, "D/%s(%d): " fmt "\n", __func__, __LINE__, ##args);      \
    } while (0)

/* sync with ./board/rockchip/rk30xx/rkloader.c #define FDT_PATH */
#define FDT_PATH "rk-kernel.dtb"
#define DTD_SUBFIX ".dtb"

#define DEFAULT_IMAGE_PATH "resource.img"
#define DEFAULT_UNPACK_DIR "out"
#define BLOCK_SIZE 512

#define RESOURCE_PTN_HDR_SIZE 1
#define INDEX_TBL_ENTR_SIZE 1

#define RESOURCE_PTN_VERSION 0
#define INDEX_TBL_VERSION 0

#define RESOURCE_PTN_HDR_MAGIC "RSCE"
typedef struct {
    char magic[4]; /* tag, "RSCE" */
    uint16_t resource_ptn_version;
    uint16_t index_tbl_version;
    uint8_t header_size;    /* blocks, size of ptn header. */
    uint8_t tbl_offset;     /* blocks, offset of index table. */
    uint8_t tbl_entry_size; /* blocks, size of index table's entry. */
    uint32_t tbl_entry_num; /* numbers of index table's entry. */
} resource_ptn_header;

#define INDEX_TBL_ENTR_TAG "ENTR"
#define MAX_INDEX_ENTRY_PATH_LEN    220
#define MAX_HASH_LEN            32

typedef struct {
    char tag[4]; /* tag, "ENTR" */
    char path[MAX_INDEX_ENTRY_PATH_LEN];
    char hash[MAX_HASH_LEN]; /* hash data */
    uint32_t hash_size;  /* 20 or 32 */
    uint32_t content_offset; /* blocks, offset of resource content. */
    uint32_t content_size;   /* bytes, size of resource content. */
} index_tbl_entry;

#define OPT_VERBOSE "--verbose"
#define OPT_HELP "--help"
#define OPT_VERSION "--version"
#define OPT_PRINT "--print"
#define OPT_PACK "--pack"
#define OPT_UNPACK "--unpack"
#define OPT_TEST_LOAD "--test_load"
#define OPT_TEST_CHARGE "--test_charge"
#define OPT_IMAGE "--image="
#define OPT_ROOT "--root="

#define VERSION "2014-5-31 14:43:42"

typedef struct {
    char path[MAX_INDEX_ENTRY_PATH_LEN];
    uint32_t content_offset; /* blocks, offset of resource content. */
    uint32_t content_size;   /* bytes, size of resource content. */
    void *load_addr;
} resource_content;

typedef struct {
    int max_level;
    int num;
    int delay;
    char prefix[MAX_INDEX_ENTRY_PATH_LEN];
} anim_level_conf;

#define DEF_CHARGE_DESC_PATH "charge_anim_desc.txt"

#define OPT_CHARGE_ANIM_DELAY "delay="
#define OPT_CHARGE_ANIM_LOOP_CUR "only_current_level="
#define OPT_CHARGE_ANIM_LEVELS "levels="
#define OPT_CHARGE_ANIM_LEVEL_CONF "max_level="
#define OPT_CHARGE_ANIM_LEVEL_NUM "num="
#define OPT_CHARGE_ANIM_LEVEL_PFX "prefix="

static char image_path[MAX_INDEX_ENTRY_PATH_LEN] = "\0";

static int fix_blocks(size_t size)
{
    return (size + BLOCK_SIZE - 1) / BLOCK_SIZE;
}

static const char *fix_path(const char *path)
{
    if (!memcmp(path, "./", 2)) {
        return path + 2;
    }
    return path;
}

static uint16_t switch_short(uint16_t x)
{
    uint16_t val;
    uint8_t *p = (uint8_t *)(&x);

    val = (*p++ & 0xff) << 0;
    val |= (*p & 0xff) << NUM8;

    return val;
}

static uint32_t switch_int(uint32_t x)
{
    uint32_t val;
    uint8_t *p = (uint8_t *)(&x);

    val = (*p++ & 0xff) << 0;
    val |= (*p++ & 0xff) << NUM8;
    val |= (*p++ & 0xff) << NUM16;
    val |= (*p & 0xff) << NUM24;

    return val;
}

static void fix_header(resource_ptn_header *header)
{
    /* switch for be. */
    header->resource_ptn_version = switch_short(header->resource_ptn_version);
    header->index_tbl_version = switch_short(header->index_tbl_version);
    header->tbl_entry_num = switch_int(header->tbl_entry_num);
}

static void fix_entry(index_tbl_entry *entry)
{
    /* switch for be. */
    entry->content_offset = switch_int(entry->content_offset);
    entry->content_size = switch_int(entry->content_size);
}

static int inline get_ptn_offset(void)
{
    return 0;
}

void endFile(FILE *file)
{
    if (file) {
        fclose(file);
        
    }
}
static bool StorageWriteLba(int offset_block, void data[], int blocks)
{
    bool ret = false;
    FILE *file = fopen(image_path, "rb+");
    if (!file) {
        return ret;
    }
    int offset = offset_block * BLOCK_SIZE;
    int rej = fseek(file, offset, SEEK_SET);
    if (rej != 0) {
        LOGE("Failed to fseek !");
    }
    if (offset != ftell(file)) {
        LOGE("Failed to seek %s to %d!", image_path, offset);
        endFile(*file);
        return ret;
    }
    if (!fwrite(data, blocks * BLOCK_SIZE, 1, file)) {
        LOGE("Failed to write %s!", image_path);
        endFile(*file);
        return ret;
    }
    ret = true;
    return ret;
}

static bool StorageReadLba(int offset_block, void data[], int blocks)
{
    bool ret = false;
    FILE *file = fopen(image_path, "rb");
    if (!file) {
        return ret;
    }
    int offset = offset_block * BLOCK_SIZE;
    int rej = fseek(file, offset, SEEK_SET);
    if (rej != 0) {
        LOGE("Failed to fseek !");
    }
    if (offset != ftell(file)) {
        if(file) {
            fclose(file);
            return ret;
        };
    }
    if (!fread(data, blocks * BLOCK_SIZE, 1, file)) {
        if(file) {
            fclose(file);
            return ret;
        };
    }
    ret = true;
    return ret;
}

static bool write_data(int offset_block, void data[], size_t len)
{
    bool ret = false;
    if (!data) {
        return ret;
    }
    int blocks = len / BLOCK_SIZE;
    if (blocks && !StorageWriteLba(offset_block, data, blocks)) {
        return ret;
    }
    int left = len % BLOCK_SIZE;
    if (left) {
        char buf[BLOCK_SIZE] = "\0";
        memcpy(buf, data + blocks * BLOCK_SIZE, left);
        if (!StorageWriteLba(offset_block + blocks, buf, 1)) {
            return ret;
        }
    }
    ret = true;
    return ret;
}

/**********************load test************************/
static int load_file(const char *file_path, int offset_block, int blocks);

static int test_load(int argc, char **argv)
{
    if (argc < 1) {
        LOGE("Nothing to load!");
        return -1;
    }
    const char *file_path;
    int offset_block = 0;
    int blocks = 0, count=argc, address=argv;
    if (count > 0) {
        file_path = (const char *)fix_path(argv[0]);
        count--, address++;
    }
    if (count > 0) {
        offset_block = atoi(argv[0]);
        count--, address++;
    }
    if (count > 0) {
        blocks = atoi(argv[0]);
    }
    return load_file(file_path, offset_block, blocks);
}

static void free_content(resource_content *content)
{
    if (content->load_addr) {
        free(content->load_addr);
        content->load_addr = 0;
    }
}

static void tests_dump_file(const char *path, void data[], int len)
{
    FILE *file = fopen(path, "wb");
    if (!file) {
        return;
    }
    int rej = fwrite(data, len, 1, file);
    if (rej == 0) {
        LOGE("Failed to fwrite !");
    }
    int ret = fclose(file);
    if (ret != 0) {
        LOGE("fclose error!");
    }
}

static bool load_content(resource_content *content)
{
    if (content->load_addr) {
        return true;
    }
    int blocks = fix_blocks(content->content_size);
    content->load_addr = malloc(blocks * BLOCK_SIZE);
    if (!content->load_addr) {
        return false;
    }
    if (!StorageReadLba(get_ptn_offset() + content->content_offset,
                        content->load_addr, blocks)) {
        free_content(content);
        return false;
    }

    tests_dump_file(content->path, content->load_addr, content->content_size);
    return true;
}

static bool load_content_data(resource_content *content, int offset_block,
                              void data[], int blocks)
{
    if (!StorageReadLba(get_ptn_offset() + content->content_offset + offset_block,
                        data, blocks)) {
        return false;
    }
    tests_dump_file(content->path, data, blocks * BLOCK_SIZE);
    return true;
}

static bool get_entry(const char *file_path, index_tbl_entry *entry)
{
    bool ret = false;
    char buf[BLOCK_SIZE];
    resource_ptn_header header;
    if (!StorageReadLba(get_ptn_offset(), buf, 1)) {
        LOGE("Failed to read header!");
        return ret;
    }
    memcpy(&header, buf, sizeof(header));

    if (memcmp(header.magic, RESOURCE_PTN_HDR_MAGIC, sizeof(header.magic))) {
        LOGE("Not a resource image(%s)!", image_path);
        return ret;
    }
    /* test on pc, switch for be. */
    fix_header(&header);

    if (header.resource_ptn_version != RESOURCE_PTN_VERSION ||
        header.header_size != RESOURCE_PTN_HDR_SIZE ||
        header.index_tbl_version != INDEX_TBL_VERSION ||
        header.tbl_entry_size != INDEX_TBL_ENTR_SIZE) {
        LOGE("Not supported in this version!");
        return ret;
    }

    int i;
    for (i = 0; i < header.tbl_entry_num; i++) {

        if (!StorageReadLba(get_ptn_offset() + header.header_size + i * header.tbl_entry_size, buf, 1)) {
            LOGE("Failed to read index entry:%d!", i);
            return ret;
        }
        memcpy(entry, buf, sizeof(*entry));

        if (memcmp(entry->tag, INDEX_TBL_ENTR_TAG, sizeof(entry->tag))) {
            LOGE("Something wrong with index entry:%d!", i);
            return ret;
        }

        if (!strncmp(entry->path, file_path, sizeof(entry->path))) {
            break;
        }
    }
    if (i == header.tbl_entry_num) {
        LOGE("Cannot find %s!", file_path);
        return ret;
    }
    /* test on pc, switch for be. */
    fix_entry(entry);

    printf("Found entry:\n\tpath:%s\n\toffset:%d\tsize:%d\n", entry->path,
           entry->content_offset, entry->content_size);

    ret = true;
    return ret;
}

static bool get_content(resource_content *content)
{
    bool ret = false;
    index_tbl_entry entry;
    if (!get_entry(content->path, &entry)) {
        return ret;
    }
    content->content_offset = entry.content_offset;
    content->content_size = entry.content_size;
    ret = true;
    return ret;
}

static int load_file(const char *file_path, int offset_block, int blocks)
{
    printf("Try to load:%s", file_path);
    if (blocks) {
        printf(", offset block:%d, blocks:%d\n", offset_block, blocks);
    } else {
        printf("\n");
    }
    bool ret = false;
    resource_content content;
    int rej = snprintf(content.path, sizeof(content.path), "%s", file_path);
    if (rej == 0) {
        LOGE("Failed to fwrite !");
    }
    content.load_addr = 0;
    if (!get_content(&content)) {
        free_content(&content);
        return ret;
    }
    if (!blocks) {
        if (!load_content(&content)) {
            free_content(&content);
            return ret;
        }
    } else {
        void *data = malloc(blocks * BLOCK_SIZE);
        if (!data) {
            free_content(&content);
            return ret;
        }
        if (!load_content_data(&content, offset_block, data, blocks)) {
            free_content(&content);
            return ret;
        }
    }
    ret = true;
    free_content(&content);
    return ret;
}

/**********************load test end************************/
/**********************anim test************************/

static bool parse_level_conf(const char *arg, anim_level_conf *level_conf)
{
    memset(level_conf, 0, sizeof(anim_level_conf));
    char *buf = NULL;
    buf = strstr(arg, OPT_CHARGE_ANIM_LEVEL_CONF);
    if (buf) {
        level_conf->max_level = atoi(buf + strlen(OPT_CHARGE_ANIM_LEVEL_CONF));
    } else {
        LOGE("Not found:%s", OPT_CHARGE_ANIM_LEVEL_CONF);
        return false;
    }
    buf = strstr(arg, OPT_CHARGE_ANIM_LEVEL_NUM);
    if (buf) {
        level_conf->num = atoi(buf + strlen(OPT_CHARGE_ANIM_LEVEL_NUM));
        if (level_conf->num <= 0) {
            return false;
        }
    } else {
        LOGE("Not found:%s", OPT_CHARGE_ANIM_LEVEL_NUM);
        return false;
    }
    buf = strstr(arg, OPT_CHARGE_ANIM_DELAY);
    if (buf) {
        level_conf->delay = atoi(buf + strlen(OPT_CHARGE_ANIM_DELAY));
    }
    buf = strstr(arg, OPT_CHARGE_ANIM_LEVEL_PFX);
    if (buf) {
        int rej = snprintf(level_conf->prefix, sizeof(level_conf->prefix), "%s",
                           buf + strlen(OPT_CHARGE_ANIM_LEVEL_PFX));
    } else {
        LOGE("Not found:%s", OPT_CHARGE_ANIM_LEVEL_PFX);
        return false;
    }

    LOGD("Found conf:\nmax_level:%d, num:%d, delay:%d, prefix:%s",
         level_conf->max_level, level_conf->num, level_conf->delay,
         level_conf->prefix);
    return true;
}

int get_while_value(char *buf, resource_content content, int level_conf_pos, int delay, int
                    only_current_level, int level_conf_num, anim_level_conf *level_confs)
{
    while (true) {
        if (buf >= end) {
            break;
        }
        const char *arg = buf;
        buf += (strlen(buf) + 1);
        LOGD("parse arg:%s", arg);
        if (!memcmp(arg, OPT_CHARGE_ANIM_LEVEL_CONF, strlen(OPT_CHARGE_ANIM_LEVEL_CONF))) {
            if (!level_confs) {
                LOGE("Found level conf before levels!");
                free_content(&content);
                return 0;
            }
            if (level_conf_pos >= level_conf_num) {
                LOGE("Too many level confs!(%d >= %d)", level_conf_pos, level_conf_num);
                free_content(&content);
                return 0;
            }
            if (!parse_level_conf(arg, level_confs + level_conf_pos)) {
                LOGE("Failed to parse level conf:%s", arg);
                free_content(&content);
                return 0;
            }
            level_conf_pos++;
        } else if (!memcmp(arg, OPT_CHARGE_ANIM_DELAY,strlen(OPT_CHARGE_ANIM_DELAY))) {
            delay = atoi(arg + strlen(OPT_CHARGE_ANIM_DELAY));
            LOGD("Found delay:%d", delay);
        } else if (!memcmp(arg, OPT_CHARGE_ANIM_LOOP_CUR, strlen(OPT_CHARGE_ANIM_LOOP_CUR))) {
            only_current_level = !memcmp(arg + strlen(OPT_CHARGE_ANIM_LOOP_CUR), "true", NUM4);
            LOGD("Found only_current_level:%d", only_current_level);
        } else if (!memcmp(arg, OPT_CHARGE_ANIM_LEVELS, strlen(OPT_CHARGE_ANIM_LEVELS))) {
            if (level_conf_num) {
                free_content(&content);
                return 0;
            }
            level_conf_num = atoi(arg + strlen(OPT_CHARGE_ANIM_LEVELS));
            if (!level_conf_num) {
                free_content(&content);
                return 0;
            }
            level_confs = anim_level_conf *)malloc(level_conf_num * sizeof(anim_level_conf));
            LOGD("Found levels:%d", level_conf_num);
        } else {
            LOGE("Unknown arg:%s", arg);
            free_content(&content);
            return 0;
        }
    }
    return 1;
}
int get_for_value(int level_conf_num, anim_level_conf *level_confs, int
                  delay, resource_content content, int level_conf_pos)
{
    if (level_conf_pos != level_conf_num || !level_conf_num) {
        LOGE("Something wrong with level confs!");
        free_content(&content);
        return 0;
    }
    int i = 0, j = 0;
    for (i = 0; i < level_conf_num; i++) {
        if (!level_confs[i].delay) {
            level_confs[i].delay = delay;
        }
        if (!level_confs[i].delay) {
            LOGE("Missing delay in level conf:%d", i);
            free_content(&content);
            return 0;
        }
        for (j = 0; j < i; j++) {
            if (level_confs[j].max_level == level_confs[i].max_level) {
                LOGE("Dup level conf:%d", i);
                free_content(&content);
                return 0;
            }
            if (level_confs[j].max_level > level_confs[i].max_level) {
                anim_level_conf conf = level_confs[i];
                memmove(level_confs + j + 1, level_confs + j,(i - j) * sizeof(anim_level_conf));
                level_confs[j] = conf;
            }
        }
    }
    return 1;
}
static int test_charge(int argc, char **argv)
{
    const char *desc;
    if (argc > 0) {
        desc = argv[0];
    } else {
        desc = DEF_CHARGE_DESC_PATH;
    }
    resource_content content;
    snprintf(content.path, sizeof(content.path), "%s", desc);
    content.load_addr = 0;
    if (!get_content(&content)) {
        free_content(&content);
        return 0;
    }
    if (!load_content(&content)) {
        free_content(&content);
        return 0;
    }
    char *buf = (char *)content.load_addr, *end = buf + content.content_size - 1;
    *end = '\0';
    LOGD("desc:\n%s", buf);
    int pos = 0;
    while (1) {
        char *line = (char *)memchr(buf + pos, '\n', strlen(buf + pos));
        if (!line) {
            break;
        }
        *line = '\0';
        LOGD("splite:%s", buf + pos);
        pos += (strlen(buf + pos) + 1);
    }
    int delay = 900, only_current_level = false, level_conf_pos = 0, level_conf_num = 0;
    anim_level_conf *level_confs = NULL;
    int temp = get_while_value(buf, content, level_conf_pos, delay, only_current_level, level_conf_num);
    if(temp != 1) {
        return 0;
    }
    int value = get_for_value(level_conf_num, level_confs, delay, content);
    if(value != 1) {
        return 0;
    }
    printf("Parse anim desc(%s):\n", desc);
    printf("only_current_level=%d\n", only_current_level);
    printf("level conf:\n");
    for (i = 0; i < level_conf_num; i++) {
        printf("\tmax=%d, delay=%d, num=%d, prefix=%s\n", level_confs[i].max_level,level_confs[i].delay, level_confs[i].num, level_confs[i].prefix);
    }
    free_content(&content);
    return 0;
}

/**********************anim test end************************/
/**********************append file************************/

static const char *PROG = NULL;
static resource_ptn_header header;
static bool just_print = false;
static char root_path[MAX_INDEX_ENTRY_PATH_LEN] = "\0";

static void version(void)
{
    printf("%s (cjf@rock-chips.com)\t" VERSION "\n", PROG);
}

static void usage(void)
{
    printf("Usage: %s [options] [FILES]\n", PROG);
    printf("Tools for Rockchip's resource image.\n");
    version();
    printf("Options:\n");
    printf("\t" OPT_PACK "\t\t\tPack image from given files.\n");
    printf("\t" OPT_UNPACK "\t\tUnpack given image to current dir.\n");
    printf("\t" OPT_IMAGE "path"
           "\t\tSpecify input/output image path.\n");
    printf("\t" OPT_PRINT "\t\t\tJust print informations.\n");
    printf("\t" OPT_VERBOSE "\t\tDisplay more runtime informations.\n");
    printf("\t" OPT_HELP "\t\t\tDisplay this information.\n");
    printf("\t" OPT_VERSION "\t\tDisplay version information.\n");
    printf("\t" OPT_ROOT "path"
           "\t\tSpecify resources' root dir.\n");
}

static int pack_image(int file_num, const char **files);
static int unpack_image(const char *dir);

enum ACTION {
    ACTION_PACK,
    ACTION_UNPACK,
    ACTION_TEST_LOAD,
    ACTION_TEST_CHARGE,
};

int action_switch(enum ACTION action, char **argv)
{
    switch (action) {
        case ACTION_PACK: {
            int file_num = count;
            const char **files = (const char **)argv;
            if (!file_num) {
                LOGE("No file to pack!");
                return 0;
            }
            LOGD("try to pack %d files.", file_num);
            return pack_image(file_num, files);
        }
        case ACTION_UNPACK: {
            return unpack_image(count > 0 ? argv[0] : DEFAULT_UNPACK_DIR);
        }
        case ACTION_TEST_LOAD: {
            return test_load(count, argv);
        }
        case ACTION_TEST_CHARGE: {
            return test_charge(count, argv);
        }
    }
    return -1;
}
int main(int argc, char **argv)
{
    PROG = fix_path(argv[0]);

    enum ACTION action = ACTION_PACK;
    int count=argc,address=argv;
    count--, address++;
    while (count > 0 && argv[0][0] == '-') {
        /* it's a opt arg. */
        const char *arg = argv[0];
        count--, address++;
        if (!strcmp(OPT_VERBOSE, arg)) {
            g_debug = true;
        } else if (!strcmp(OPT_HELP, arg)) {
            usage();
            return 0;
        } else if (!strcmp(OPT_VERSION, arg)) {
            version();
            return 0;
        } else if (!strcmp(OPT_PRINT, arg)) {
            just_print = true;
        } else if (!strcmp(OPT_PACK, arg)) {
            action = ACTION_PACK;
        } else if (!strcmp(OPT_UNPACK, arg)) {
            action = ACTION_UNPACK;
        } else if (!strcmp(OPT_TEST_LOAD, arg)) {
            action = ACTION_TEST_LOAD;
        } else if (!strcmp(OPT_TEST_CHARGE, arg)) {
            action = ACTION_TEST_CHARGE;
        } else if (!memcmp(OPT_IMAGE, arg, strlen(OPT_IMAGE))) {
            snprintf(image_path, sizeof(image_path), "%s", arg + strlen(OPT_IMAGE));
        } else if (!memcmp(OPT_ROOT, arg, strlen(OPT_ROOT))) {
            snprintf(root_path, sizeof(root_path), "%s", arg + strlen(OPT_ROOT));
        } else {
            LOGE("Unknown opt:%s", arg);
            usage();
            return -1;
        }
    }
    if (!image_path[0]) {
        int rej = snprintf(image_path, sizeof(image_path), "%s", DEFAULT_IMAGE_PATH);
    }
    argv=address;
    return action_switch(action, argv);
    /* not reach here. */
}

/************unpack code****************/
static bool mkdirs(char *path)
{
    char *tmp = path;
    char *pos = NULL;
    char buf[MAX_INDEX_ENTRY_PATH_LEN];
    bool ret = true;
    while ((pos = memchr(tmp, '/', strlen(tmp)))) {
        strcpy(buf, path);
        buf[pos - path] = '\0';
        tmp = pos + 1;
        LOGD("mkdir:%s", buf);
        if (!mkdir(buf, 0755)) {
            ret = false;
        }
    }
    if (!ret) {
        LOGD("Failed to mkdir(%s)!", path);
    }
    return ret;
}

void end_block(FILE *out_file, long int pos)
{
    if (out_file) {
        fclose(out_file);
    }
    if (pos) {
        int rej = fseek(file, pos, SEEK_SET);
        if (rej != 0) {
            LOGE("Failed to fseek !");
        }
    }
}
static bool dump_file(FILE *file, const char *unpack_dir,
                      index_tbl_entry entry)
{
    LOGD("try to dump entry:%s", entry.path);
    bool ret = false;
    FILE *out_file = NULL;
    long int pos = 0;
    char path[MAX_INDEX_ENTRY_PATH_LEN * 2 + 1];
    if (just_print) {
        ret = true;
    }

    pos = ftell(file);
    int rej = snprintf(path, sizeof(path), "%s/%s", unpack_dir, entry.path);
    mkdirs(path);
    out_file = fopen(path, "wb");
    if (!out_file) {
        LOGE("Failed to create:%s", path);
        end_block(*out_file, pos);
        return ret;
    }
    long int offset = entry.content_offset * BLOCK_SIZE;
    fseek(file, offset, SEEK_SET);
    if (offset != ftell(file)) {
        LOGE("Failed to read content:%s", entry.path);
        end_block(*out_file, pos);
        return ret;
    }
    char buf[BLOCK_SIZE];
    int n;
    int len = entry.content_size;
    while (len > 0) {
        n = len > BLOCK_SIZE ? BLOCK_SIZE : len;
        if (!fread(buf, n, 1, file)) {
            LOGE("Failed to read content:%s", entry.path);
            end_block(*out_file, pos);
            return ret;
        }
        if (!fwrite(buf, n, 1, out_file)) {
            LOGE("Failed to write:%s", entry.path);
            end_block(*out_file, pos);
            return ret;
        }
        len -= n;
    }
    ret = true;
    return ret;
}

int goEnd(FILE *image_file)
{
    if (image_file) {
    fclose(image_file);
    }
    return 0;
}
static int unpack_image(const char *dir)
{
    FILE *image_file = NULL;
    bool ret = false;
    char unpack_dir[MAX_INDEX_ENTRY_PATH_LEN];
    if (just_print) {
        *dir = ".";
    }
    snprintf(unpack_dir, sizeof(unpack_dir), "%s", dir);
    if (!strlen(unpack_dir)) {
        return goEnd(*image_file);
    } else if (unpack_dir[strlen(unpack_dir) - 1] == '/') {
        unpack_dir[strlen(unpack_dir) - 1] = '\0';
    }
    mkdir(unpack_dir, 0755);
    image_file = fopen(image_path, "rb");
    char buf[BLOCK_SIZE];
    if (!image_file) {
        LOGE("Failed to open:%s", image_path);
        return goEnd(*image_file);
    }
    if (!fread(buf, BLOCK_SIZE, 1, image_file)) {
        LOGE("Failed to read header!");
        return goEnd(*image_file);
    }
    memcpy(&header, buf, sizeof(header));
    if (memcmp(header.magic, RESOURCE_PTN_HDR_MAGIC, sizeof(header.magic))) {
        LOGE("Not a resource image(%s)!", image_path);
        return goEnd(*image_file);
    }
    fix_header(&header);
    printf("Dump header:\n");
    printf("partition version:%d.%d\n", header.resource_ptn_version, header.index_tbl_version);
    printf("header size:%d\n", header.header_size);
    printf("index tbl:\n\toffset:%d\tentry size:%d\tentry num:%d\n", header.tbl_offset, header.tbl_entry_size, header.tbl_entry_num);
    if (header.resource_ptn_version != RESOURCE_PTN_VERSION ||
        header.header_size != RESOURCE_PTN_HDR_SIZE ||
        header.index_tbl_version != INDEX_TBL_VERSION ||
        header.tbl_entry_size != INDEX_TBL_ENTR_SIZE) {
        LOGE("Not supported in this version!");
        return goEnd(*image_file);
    }
    printf("Dump Index table:\n");
    index_tbl_entry entry;
    if(getValue(image_file,  entry, unpack_dir) != -1) {
        return getValue(image_file, entry, unpack_dir);
    }
    printf("Unack %s to %s successed!\n", image_path, unpack_dir);
    ret = true;
    return ret ? 0 : -1;
}
int getValue(FILE *image_file, index_tbl_entry entry, char unpack_dir)
{
    int i;
    for (i = 0; i < header.tbl_entry_num; i++) {
        if (!fread(buf, BLOCK_SIZE, 1, image_file)) {
            LOGE("Failed to read index entry:%d!", i);
            return goEnd(*image_file);
        }
        memcpy(&entry, buf, sizeof(entry));
        if (memcmp(entry.tag, INDEX_TBL_ENTR_TAG, sizeof(entry.tag))) {
            LOGE("Something wrong with index entry:%d!", i);
            return goEnd(*image_file);
        }
        /* switch for be. */
        fix_entry(&entry);
        printf("entry(%d):\n\tpath:%s\n\toffset:%d\tsize:%d\n", i, entry.path, entry.content_offset, entry.content_size);
        if (!dump_file(image_file, unpack_dir, entry)) {
            return goEnd(*image_file);
        }
    }
    return -1;
}
int go_file_End(FILE *src_file, char *buf)
{
    if (src_file) {
        fclose(src_file);
    }
    if (buf) {
        free(buf);
    }

    return ret;
}
static int write_file(int offset_block, const char *src_path,
                      char hash[], int hash_size)
{
    LOGD("try to write file(%s) to offset:%d...", src_path, offset_block);
    char *buf = NULL;
    int ret = -1;
    size_t file_size;
    FILE *src_file = fopen(src_path, "rb");
    if (!src_file) {
        LOGE("Failed to open:%s", src_path);
        return go_file_End(*src_file, *buf);
    }

    file_size = get_file_size(src_path);
    if (file_size < 0) {
        return go_file_End(*src_file, *buf);
    }

    buf = calloc(file_size, 1);
    if (!buf) {
        return go_file_End(*src_file, *buf);
    }

    if (!fread(buf, file_size, 1, src_file)) {
        return go_file_End(*src_file, *buf);
    }

    if (!write_data(offset_block, buf, file_size)) {
        return go_file_End(*src_file, *buf);
    }

    if (hash_size == 20) {
        sha1_csum((const unsigned char *)buf, file_size, (unsigned char *)hash);
    } else if (hash_size == 32) {
        sha256_csum((const unsigned char *)buf, file_size, (unsigned char *)hash);
    } else {
        return go_file_End(*src_file, *buf);
    }

    ret = file_size;
    return ret;
}

static bool write_header(const int file_num)
{
    LOGD("try to write header...");
    memcpy(header.magic, RESOURCE_PTN_HDR_MAGIC, sizeof(header.magic));
    header.resource_ptn_version = RESOURCE_PTN_VERSION;
    header.index_tbl_version = INDEX_TBL_VERSION;
    header.header_size = RESOURCE_PTN_HDR_SIZE;
    header.tbl_offset = header.header_size;
    header.tbl_entry_size = INDEX_TBL_ENTR_SIZE;
    header.tbl_entry_num = file_num;

    /* switch for le. */
    resource_ptn_header hdr = header;
    fix_header(&hdr);
    return write_data(0, &hdr, sizeof(hdr));
}

static bool write_index_tbl(const int file_num, const char **files)
{
    LOGE("try to write index table...");
    bool ret = false;
    bool foundFdt = false;
    int offset =
            header.header_size + header.tbl_entry_size * header.tbl_entry_num;
    index_tbl_entry entry;
    char hash[20];  /* sha1 */
    int i;
        LOGE("write_index_tbl %d\n",file_num);
    memcpy(entry.tag, INDEX_TBL_ENTR_TAG, sizeof(entry.tag));
    for (i = 0; i < file_num; i++) {
        size_t file_size = get_file_size(files[i]);
        if (file_size < 0) {
            return ret;
        }
        entry.content_size = file_size;
        entry.content_offset = offset;

        if (write_file(offset, files[i], hash, sizeof(hash)) < 0) {
            return ret;
        }

        memcpy(entry.hash, hash, sizeof(hash));
        entry.hash_size = sizeof(hash);

        LOGE("try to write index entry(%s)...", files[i]);

        /* switch for le. */
        fix_entry(&entry);
        memset(entry.path, 0, sizeof(entry.path));
        const char *path = files[i];
        if (root_path[0]) && (!strncmp(path, root_path, strlen(root_path))) {
            path += strlen(root_path);
            if (path[0] == '/') {
                path++;
            }
        }
        path = fix_path(path);
        if (!strcmp(files[i] + strlen(files[i]) - strlen(DTD_SUBFIX), DTD_SUBFIX)) {
            if (!foundFdt) {
                /* use default path. */
                LOGE("mod fdt path:%s -> %s...", files[i], FDT_PATH);
                path = FDT_PATH;
                foundFdt = true;
            }
        }
        int rej = snprintf(entry.path, sizeof(entry.path), "%s", path);
        offset += fix_blocks(file_size);
        if (!write_data(header.header_size + i * header.tbl_entry_size, &entry, sizeof(entry))) {
            return ret;
        }
    }
    ret = true;
}

static int pack_image(int file_num, const char **files)
{
    bool ret = false;
    FILE *image_file = fopen(image_path, "wb");
    if (!image_file) {
        LOGE("Failed to create:%s", image_path);
        return ret ? 0 : -1;
    }
    int rej = fclose(image_file);
    if (rej != 0) {
        LOGE("Failed to fclose:%s", image_file);
    }

    /* prepare files */
    int i = 0, temp=file_num;
    int pos = 0;
    const char *tmp;
    for (i = 0; i < file_num; i++) {
        if (!strcmp(files[i] + strlen(files[i]) - strlen(DTD_SUBFIX), DTD_SUBFIX)) {
            /* dtb files for kernel. */
            tmp = files[pos];
            files[pos] = files[i];
            files[i] = tmp;
            pos++;
        } else if (!strcmp(fix_path(image_path), fix_path(files[i]))) {
            /* not to pack image itself! */
            tmp = files[file_num - 1];
            files[file_num - 1] = files[i];
            files[i] = tmp;
            temp--;
            file_num = temp;
        }
    }

    if (!write_header(file_num)) {
        LOGE("Failed to write header!");
        return ret ? 0 : -1;
    }
    if (!write_index_tbl(file_num, files)) {
        LOGE("Failed to write index table!");
        return ret ? 0 : -1;
    }
    printf("Pack to %s successed!\n", image_path);
    ret = true;
}

/************pack code end****************/
