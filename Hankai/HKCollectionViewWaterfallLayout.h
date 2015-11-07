//
//  HKCollectionViewWaterfallLayout.h
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

#import <UIKit/UIKit.h>

@class HKCollectionViewWaterfallLayout;

@protocol HKCollectionViewDelegateWaterfallLayout <UICollectionViewDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(HKCollectionViewWaterfallLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

//只支持一个header
- (CGFloat)heightOfHeaderOfCollectionView:(UICollectionView *)collectionView;

@end

/*
    瀑布流式布局，目前只能支持单个 section。
 */

@interface HKCollectionViewWaterfallLayout : UICollectionViewLayout

@property (nonatomic, weak) IBOutlet id<HKCollectionViewDelegateWaterfallLayout> delegate; //委托

@property (nonatomic, assign) NSUInteger        numberOfColumns;        //根据列数量均分得到列宽度

@property (nonatomic, assign) CGFloat           horizontalMinSpacing;   //水平最小间隔

@property (nonatomic, assign) CGFloat           verticalMinSpacing;     //垂直最小间隔

@property (nonatomic, readonly) CGFloat         columnWidth;

@end
