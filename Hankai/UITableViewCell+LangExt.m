//
//  UITableViewCell+LangExt.m
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

#import "UITableViewCell+LangExt.h"

#ifndef __MAC_OS_X_VERSION_MIN_REQUIRED

@implementation UITableViewCell (LangExt)

+ (instancetype)cellFromNib:(NSString *)nibName tag:(NSInteger)tag {
    NSArray * objs = nil;
    @try {
        objs = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    } @catch (NSException *exception) {
        NSLog(@"Failed to load nib with name %@ due to %@", nibName, exception.reason);
        return nil;
    }
    
    UITableViewCell * cell = nil;
    if ([objs count] == 1) {
        //如果只找到一个顶层对象，那么只用检查其类型（必须是 UITableViewCell 或其子类）
        if (![[objs objectAtIndex:0] isKindOfClass:[self class]]) {
            NSLog(@"Failed to load cell from nib %@. Only one top level object found, but the object is not UITableViewCell or its subclass", nibName);
            assert(NO);
        } else {
            cell = (UITableViewCell *)[objs objectAtIndex:0];
            if (cell.tag != tag) {
                NSLog(@"Only one cell was found and returned, but the tag is not equal to %ld", (long)tag);
            }
        }
    } else if ([objs count] > 1) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"tag=%@", [NSNumber numberWithInteger:tag]];
        NSArray * results = [objs filteredArrayUsingPredicate:pre];
        if ([results count] == 1) {
            cell = [results lastObject];
        } else if ([results count] > 1) {
            NSLog(@"Multiple objects found while loading objects from nib %@ with tag %ld", nibName, (long)tag);
        } else {
            NSLog(@"Cell not found in nib %@ with tag %ld.", nibName, (long)tag);
        }
    } else {
        NSLog(@"Cannot load cell from an empty nib %@", nibName);
    }
    
    return cell;
}


@end

#endif