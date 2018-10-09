//
//  ZKCrypto.m
//  ZKCommonCrypto
//
//  Created by kai zhou on 2018/6/21.
//  Copyright © 2018 kai zhou. All rights reserved.
//

#import "ZKCrypto.h"

#import <CommonCrypto/CommonDigest.h>

#define cacheSize 1024*8

@implementation ZKCrypto
+(NSString*)fileMD5WithPath:(NSString*)path{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, cacheSize);
}
/**
 *  获取文件MD5
 **/


CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    CFURLRef fileURL =CFURLCreateWithFileSystemPath(kCFAllocatorDefault,(CFStringRef)filePath,kCFURLPOSIXPathStyle,(Boolean)false);
    
    if (!fileURL) goto done;
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,(CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    CC_MD5_CTX hashObject;
    
    CC_MD5_Init(&hashObject);
    
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = cacheSize;
    }
    
    bool hasMoreData = true;
    
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    
    didSucceed = !hasMoreData;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &hashObject);
    
    if (!didSucceed) goto done;
    
    char hash[2 * sizeof(digest) + 1];
    
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    
    if (fileURL) {
        CFRelease(fileURL);
    }
    
    return result;
    
}

@end
