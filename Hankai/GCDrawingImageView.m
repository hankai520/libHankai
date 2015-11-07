//
//  GCDrawingImageView.m
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

#import "GCDrawingImageView.h"

@interface GCDrawingImageView () {
    CGPoint             _previousPoint;
    NSMutableArray *    _drawnPoints;
    UIImage *           _cleanImage;
}

@end

@implementation GCDrawingImageView

- (void)configure {
    self.lineWidth = 4.0f;
    self.drawnLineColor = [UIColor blackColor];
    self.drawingLineColor = [UIColor blueColor];
    self.userInteractionEnabled = YES;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self != nil) {
        [self configure];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        [self configure];
    }
    
    return self;
}


/*
    Draw the received |image| as background of the returned image, 
    and draw a line from |fromPoint| to |toPoint| on the returned image.
 */
- (UIImage *)drawLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint image:(UIImage *)image {
    CGSize siz = self.frame.size;
    UIGraphicsBeginImageContext(siz);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, siz.width, siz.height)];
    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
	CGContextSetLineWidth(currentContext, self.lineWidth);
    [self.drawingLineColor set];
    
	CGContextBeginPath(currentContext);
	CGContextMoveToPoint(currentContext, fromPoint.x, fromPoint.y);
	CGContextAddLineToPoint(currentContext, toPoint.x, toPoint.y);
	CGContextStrokePath(currentContext);
    
    UIImage * ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return ret;
}


/*
    Draw the received |image| as background of the returned image,
    connect the |points| and draw as path on the returned image.
 */
- (UIImage *)drawPathWithPoints:(NSArray *)points image:(UIImage *)image {
    CGSize size = self.frame.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
	CGContextSetLineWidth(currentContext, self.lineWidth);
    [self.drawnLineColor set];
    
	CGContextBeginPath(currentContext);
    
    int count = (int)[points count];
    CGPoint point = [[points objectAtIndex:0] CGPointValue];
	CGContextMoveToPoint(currentContext, point.x, point.y);
    for(int i = 1; i < count; i++) {
        point = [[points objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(currentContext, point.x, point.y);
    }
    CGContextStrokePath(currentContext);
    
    UIImage * ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return ret;
}


/*
        A
          *
         *  *
        *    *
       *      *
      *        * D
     *          *
    *      *     *
   *   *          *  B
C * 
 
 CD is the perpendicular line of AB, calculate CD.
 
 algorithm:  1. calculate length of AD, AC.
             2. calculate angle CAD.
             3. calculate length of CD.
 
 */
- (float)perpendicularDistance:(CGPoint)point lineA:(CGPoint)lineA lineB:(CGPoint)lineB {
    CGPoint v1 = CGPointMake(lineB.x - lineA.x, lineB.y - lineA.y);
    CGPoint v2 = CGPointMake(point.x - lineA.x, point.y - lineA.y);
    float lenV1 = sqrt(v1.x * v1.x + v1.y * v1.y);
    float lenV2 = sqrt(v2.x * v2.x + v2.y * v2.y);
    float angle = acos((v1.x * v2.x + v1.y * v2.y) / (lenV1 * lenV2));
    return sin(angle) * lenV2;
}

/*
 Ramer–Douglas–Peucker algorithm
 Reference: http://en.wikipedia.org/wiki/Ramer–Douglas–Peucker_algorithm
 */

- (NSArray *)douglasPeucker:(NSArray *)points epsilon:(float)epsilon {
    int count = (int)[points count];
    if(count < 3) {
        return points;
    }
    
    //Find the point with the maximum distance
    float dmax = 0;
    int index = 0;
    
    CGPoint lineA = [[points objectAtIndex:0] CGPointValue];
    CGPoint lineB = [[points objectAtIndex:count - 1] CGPointValue];
    
    for(int i = 1; i < count - 1; i++) {
        CGPoint point = [[points objectAtIndex:i] CGPointValue];
        float d = [self perpendicularDistance:point lineA:lineA lineB:lineB];
        if(d > dmax) {
            index = i;
            dmax = d;
        }
    }
    
    //If max distance is greater than epsilon, recursively simplify
    NSArray *resultList;
    if(dmax > epsilon) {
        NSArray *recResults1 = [self douglasPeucker:[points subarrayWithRange:NSMakeRange(0, index + 1)] epsilon:epsilon];
        
        NSArray *recResults2 = [self douglasPeucker:[points subarrayWithRange:NSMakeRange(index, count - index)] epsilon:epsilon];
        
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:recResults1];
        [tmpList removeLastObject];
        [tmpList addObjectsFromArray:recResults2];
        resultList = tmpList;
    } else {
        resultList = [NSArray arrayWithObjects:[points objectAtIndex:0], [points objectAtIndex:count - 1],nil];
    }
    
    return resultList;
}


/*
    Interpolate the points between the vertices for a nice smooth curve.
 */
- (NSArray *)catmullRomSpline:(NSArray *)points segments:(int)segments {
    int count = (int)[points count];
    if(count < 4) {
        return points;
    }
    
    float b[segments][4];
    {
        // precompute interpolation parameters
        float t = 0.0f;
        float dt = 1.0f/(float)segments;
        for (int i = 0; i < segments; i++, t+=dt) {
            float tt = t*t;
            float ttt = tt * t;
            b[i][0] = 0.5f * (-ttt + 2.0f*tt - t);
            b[i][1] = 0.5f * (3.0f*ttt -5.0f*tt +2.0f);
            b[i][2] = 0.5f * (-3.0f*ttt + 4.0f*tt + t);
            b[i][3] = 0.5f * (ttt - tt);
        }
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    {
        int i = 0; // first control point
        [resultArray addObject:[points objectAtIndex:0]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            CGPoint pointIp2 = [[points objectAtIndex:(i + 2)] CGPointValue];
            float px = (b[j][0]+b[j][1])*pointI.x + b[j][2]*pointIp1.x + b[j][3]*pointIp2.x;
            float py = (b[j][0]+b[j][1])*pointI.y + b[j][2]*pointIp1.y + b[j][3]*pointIp2.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    
    for (int i = 1; i < count-2; i++) {
        // the first interpolated point is always the original control point
        [resultArray addObject:[points objectAtIndex:i]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointIm1 = [[points objectAtIndex:(i - 1)] CGPointValue];
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            CGPoint pointIp2 = [[points objectAtIndex:(i + 2)] CGPointValue];
            float px = b[j][0]*pointIm1.x + b[j][1]*pointI.x + b[j][2]*pointIp1.x + b[j][3]*pointIp2.x;
            float py = b[j][0]*pointIm1.y + b[j][1]*pointI.y + b[j][2]*pointIp1.y + b[j][3]*pointIp2.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    
    {
        int i = count-2; // second to last control point
        [resultArray addObject:[points objectAtIndex:i]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointIm1 = [[points objectAtIndex:(i - 1)] CGPointValue];
            CGPoint pointI = [[points objectAtIndex:i] CGPointValue];
            CGPoint pointIp1 = [[points objectAtIndex:(i + 1)] CGPointValue];
            float px = b[j][0]*pointIm1.x + b[j][1]*pointI.x + (b[j][2]+b[j][3])*pointIp1.x;
            float py = b[j][0]*pointIm1.y + b[j][1]*pointI.y + (b[j][2]+b[j][3])*pointIp1.y;
            [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        }
    }
    // the very last interpolated point is the last control point
    [resultArray addObject:[points objectAtIndex:(count - 1)]];
    
    return resultArray;
}

#pragma mark - Touch handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    // record touch points to use as input to our line smoothing algorithm
    _drawnPoints = [NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:currentPoint]];
    
    _previousPoint = currentPoint;

    // to be able to replace the jagged polylines with the smooth polylines, we
    // need to save the unmodified image
    _cleanImage = self.image;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // retrieve touch point
    UITouch * touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    // record touch points to use as input to our line smoothing algorithm
    [_drawnPoints addObject:[NSValue valueWithCGPoint:currentPoint]];
    
    // draw line from the current point to the previous point
    self.image = [self drawLineFromPoint:_previousPoint toPoint:currentPoint image:self.image];
    
    _previousPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray * generalizedPoints = [self douglasPeucker:_drawnPoints epsilon:2];
    NSArray * splinePoints = [self catmullRomSpline:generalizedPoints segments:4];
    self.image = [self drawPathWithPoints:splinePoints image:_cleanImage];
}

@end
