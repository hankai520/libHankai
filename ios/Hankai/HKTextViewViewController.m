//
//  HKTextViewViewController.m
//
//  HKTextViewViewController.h
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

#import "HKTextViewViewController.h"
#import "UIView+LangExt.h"

@interface HKTextViewViewController ()

@end

@implementation HKTextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    textView.delegate = self;
    lenthLabel.radius = 4.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSInteger left = self.maxLength - self.initialText.length;
    
    if (left >= 0) {
        textView.text = self.initialText;
        lenthLabel.text = [NSString stringWithFormat:@"%ld", (long)left];
    } else {
        textView.text = nil;
        lenthLabel.text = [NSString stringWithFormat:@"%ld", (long)self.maxLength];
    }
    
    [textView becomeFirstResponder];
}

#pragma mark - Events

- (void)finishEditing:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewController:didFinishEditingWithText:)]) {
        [self.delegate textViewController:self didFinishEditingWithText:textView.text];
    }
}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {

}

- (BOOL)textView:(UITextView *)tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString * textToBe = [NSMutableString stringWithString:textView.text];
    [textToBe replaceCharactersInRange:range withString:text];
    if (textToBe.length > self.maxLength) {
        return NO;
    }
    lenthLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)(self.maxLength - textToBe.length)];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {

}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
}


@end
