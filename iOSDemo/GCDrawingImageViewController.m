//
//  GCDrawingImageViewController.m
//  Hankai
//
//  Created by hankai on 24/05/2017.
//  Copyright © 2017 Hankai. All rights reserved.
//

#import "GCDrawingImageViewController.h"
@import Hankai;

@interface GCDrawingImageViewController () {
    IBOutlet GCDrawingImageView *   drawingImageView;
}

@end

@implementation GCDrawingImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    drawingImageView.lineWidth = 2.0f;
    drawingImageView.drawingLineColor = [UIColor redColor];
    drawingImageView.drawnLineColor = [UIColor blackColor];
}

#pragma mark - Events

- (IBAction)clear:(id)sender {
    drawingImageView.image = nil;
}

@end
