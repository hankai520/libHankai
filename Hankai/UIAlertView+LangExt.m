//
//  UIAlertView+LangExt.m
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

#import "UIAlertView+LangExt.h"

@implementation UIAlertView (LangExt)

+ (UIAlertView *)alertViewWithError:(NSError *)error {
    NSMutableString * msg = [NSMutableString string];
    
    NSString * desc = error.userInfo[NSLocalizedDescriptionKey];
    NSString * reason = error.userInfo[NSLocalizedFailureReasonErrorKey];
    NSString * suggestion = error.userInfo[NSLocalizedRecoverySuggestionErrorKey];
    
    if (desc != nil) {
        [msg appendFormat:@"%@", desc];
    }
    
    if (reason != nil) {
        if (desc != nil) {
            [msg appendFormat:@", %@", reason];
        } else {
            [msg appendFormat:@"%@", reason];
        }
    }
    
    if (suggestion != nil) {
        if (desc != nil || reason != nil) {
            [msg appendFormat:@", %@", suggestion];
        } else {
            [msg appendFormat:@"%@", suggestion];
        }
    }
    
    if (msg.length == 0) {
        return nil;
    }
    
    NSArray * options = error.userInfo[NSLocalizedRecoveryOptionsErrorKey];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:msg
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil];
    if ([options count] == 0) {
        [alert addButtonWithTitle:NSLocalizedString(@"ok", nil)];
    } else {
        for (NSString * opt in options) {
            [alert addButtonWithTitle:opt];
        }
    }
    
    return alert;
}

+ (void)presentAlertWithMessage:(NSString *)msg buttonTitle:(NSString *)title {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:msg
                                                    delegate:nil
                                           cancelButtonTitle:title
                                           otherButtonTitles:nil];
    [alert show];
}

+ (void)presentAlertWithMessage:(NSString *)msg buttonTitle:(NSString *)title delegate:(id)delegate {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:msg
                                                    delegate:delegate
                                           cancelButtonTitle:title
                                           otherButtonTitles:nil];
    [alert show];
}

@end
