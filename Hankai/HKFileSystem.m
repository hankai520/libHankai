//
//  HKFileSystem.m
//  Hankai
//
//  Created by 韩凯 on 3/24/14.
//  Copyright (c) 2014 Hankai. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "HKFileSystem.h"
#import "HKVars.h"
#import "HKMath.h"

@implementation HKFileSystem

+ (NSUInteger)getDirectoryFileSize:(NSURL *)directoryUrl {
    NSUInteger result = 0;
    NSArray * properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey,
                           NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
    
    NSArray * array = [[NSFileManager defaultManager]
                       contentsOfDirectoryAtURL:directoryUrl
                       includingPropertiesForKeys:properties
                       options:(NSDirectoryEnumerationSkipsHiddenFiles)
                       error:nil];
    
    for (NSURL * fileSystemItem in array) {
        BOOL directory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:[fileSystemItem path] isDirectory:&directory];
        if (!directory) {
            NSDictionary * attr = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileSystemItem path] error:nil];
            result += [[attr objectForKey:NSFileSize] unsignedIntegerValue];
        } else {
            result += [self getDirectoryFileSize:fileSystemItem];
        }
    }
    
    return result;
}

+ (float)convertSize:(NSUInteger)size byUnit:(HKFileSizeUnit)unit {
    if (unit == HKFileSizeUnitByte) {
        
    } else if (unit == HKFileSizeUnitKiloByte) {
        size = [HKMath roundFloat:size/1024 fractions:1];
    } else if (unit == HKFileSizeUnitMegaByte) {
        size = [HKMath roundFloat:size/1024/1024 fractions:1];
    } else if (unit == HKFileSizeUnitGigaByte) {
        size = [HKMath roundFloat:size/1024/1024/1024 fractions:1];
    } else if (unit == HKFileSizeUnitTeraByte) {
        size = [HKMath roundFloat:size/1024/1024/1024/1024 fractions:1];
    }
    return size;
}

+ (float)cacheSizeInUnit:(HKFileSizeUnit)unit {
    NSURL * url = [NSURL fileURLWithPath:AppCachesDirectory];
    float size = [self getDirectoryFileSize:url];
    size = [self convertSize:size byUnit:unit];
    return size;
}

+ (float)cacheSizeForSubDir:(NSString *)subDir inUnit:(HKFileSizeUnit)unit {
    NSString * path = [AppCachesDirectory stringByAppendingPathComponent:subDir];
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        NSURL * url = [NSURL fileURLWithPath:path];
        NSUInteger size = [self getDirectoryFileSize:url];
        return [self convertSize:size byUnit:unit];
    } else {
        return 0;
    }
}

+ (NSString *)humanReadableCacheSize {
    float size = [self cacheSizeInUnit:HKFileSizeUnitByte];
    return [self humanReadableCacheSize:size];
}

+ (NSString *)humanReadableCacheSize:(float)size {
    NSInteger unitLevel = HKFileSizeUnitByte;
    while (size > 1024) {
        size /= 1024;
        unitLevel ++;
        if (size < 1024 || unitLevel == HKFileSizeUnitTeraByte) {
            break;
        }
    }
    NSString * unitString = @"";
    if (unitLevel == HKFileSizeUnitByte) {
        unitString = @"Byte";
    } else if (unitLevel == HKFileSizeUnitKiloByte) {
        unitString = @"KB";
    } else if (unitLevel == HKFileSizeUnitMegaByte) {
        unitString = @"MB";
    } else if (unitLevel == HKFileSizeUnitGigaByte) {
        unitString = @"GB";
    } else if (unitLevel == HKFileSizeUnitTeraByte) {
        unitString = @"TB";
    }
    size = [HKMath roundFloat:size fractions:1];
    NSString * str = [NSString stringWithFormat:@"%.1f %@", size, unitString];
    return str;
}

+ (void)cleanCaches {
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError * error = nil;
    NSString * dir = AppCachesDirectory;
    NSArray * items = [fm contentsOfDirectoryAtPath:dir error:&error];
    if (error == nil) {
        for (NSString * item in items) {
            error = nil;
            [fm removeItemAtPath:[dir stringByAppendingPathComponent:item] error:&error];
            if (error != nil) {
                NSLog(@"%@", error);
            }
        }
    } else {
        NSLog(@"%@", error);
    }
}

@end
