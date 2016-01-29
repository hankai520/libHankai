//
//  UITableView+LangExt.m
//  Hankai
//
//  Created by hankai on 1/29/16.
//  Copyright © 2016 Hankai. All rights reserved.
//

#import "UITableView+LangExt.h"

#define HKTableViewPlaceholderTag       337283

@implementation UITableView (LangExt)

- (void)showPlaceholderWithText:(NSString *)text {
    self.scrollEnabled = NO;
    CGRect frame = CGRectMake(0, 150, self.frame.size.width, 30);
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.tag = HKTableViewPlaceholderTag;
    label.font = [UIFont boldSystemFontOfSize:17.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    [self addSubview:label];
}

- (void)hidePlaceholder {
    UILabel * label = [self viewWithTag:HKTableViewPlaceholderTag];
    if (label != nil) {
        [label removeFromSuperview];
    }
    self.scrollEnabled = YES;
}

@end
