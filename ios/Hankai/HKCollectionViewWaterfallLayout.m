//
//  HKCollectionViewWaterfallLayout.m
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

#import "HKCollectionViewWaterfallLayout.h"

@interface HKCollectionViewWaterfallLayout () {
    CGRect                  headerFrame;
    
    NSInteger               numberOfItems;
    NSMutableArray *        itemAttributes;
    NSMutableArray *        columnHeights;      //用于布局时记录最短和最长的列
    
    CGFloat                 columnWidth;
}

@end

@implementation HKCollectionViewWaterfallLayout

- (void)setNumberOfColumns:(NSUInteger)value {
    if (_numberOfColumns != value) {
        _numberOfColumns = value;
        [self invalidateLayout];
    }
}

- (void)setHorizontalMinSpacing:(CGFloat)value {
    if (_horizontalMinSpacing != value) {
        _horizontalMinSpacing = value;
        [self invalidateLayout];
    }
}

- (void)setVerticalMinSpacing:(CGFloat)value {
    if (_verticalMinSpacing != value) {
        _verticalMinSpacing = value;
        [self invalidateLayout];
    }
}

- (CGFloat)columnWidth {
    return columnWidth;
}

#pragma mark - Private

- (NSUInteger)shortestColumnIndex {
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;
    
    [columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}

- (NSUInteger)longestColumnIndex {
    __block NSUInteger index = 0;
    __block CGFloat longestHeight = 0;
    
    [columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}


#pragma mark - Life Cycle

- (void)internalInit {
    _numberOfColumns = 0;
    _verticalMinSpacing = _horizontalMinSpacing = 10;
    columnHeights = [NSMutableArray array];
}

- (id)init {
    self = [super init];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self internalInit];
    }
    
    return self;
}


#pragma mark - UICollectionViewLayout (SubclassingHooks)

- (void)prepareLayout {
    if (_numberOfColumns == 0) {
        return;
    }
    
    [super prepareLayout];
    
    [columnHeights removeAllObjects];
    
    CGFloat headerHeight = 0;
    
    if ([self.delegate respondsToSelector:@selector(heightOfHeaderOfCollectionView:)]) {
        headerHeight = [self.delegate heightOfHeaderOfCollectionView:self.collectionView];
    }
    
    if (headerHeight > 0) {
        for (NSInteger i = 0; i < _numberOfColumns; i++) {
            [columnHeights addObject:@(_verticalMinSpacing + headerHeight)];
        }
        headerFrame = CGRectMake(0, 0, self.collectionView.frame.size.width, headerHeight);
    } else {
        for (NSInteger i = 0; i < _numberOfColumns; i++) {
            [columnHeights addObject:@(_verticalMinSpacing)];
        }
        headerFrame = CGRectZero;
    }
    
    numberOfItems = [self.collectionView numberOfItemsInSection:0];
    itemAttributes = [NSMutableArray arrayWithCapacity:numberOfItems];
    
    columnWidth = (self.collectionView.frame.size.width - (_numberOfColumns + 1) * _horizontalMinSpacing) / _numberOfColumns;
    columnWidth = floorf(columnWidth);
    
    UICollectionViewLayoutAttributes * attributes = nil;
    
    for (NSInteger i = 0; i < numberOfItems; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGFloat itemHeight = [self.delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
        
        //便利所有列得到当前高度最小的列，然后将当前这个cell放在这一列最后一个cell之下
        //在对第一行的cell进行布局时，其实所有的列都是高度最小的
        NSUInteger shortestColumnIndex = [self shortestColumnIndex];
        
        //当前cell的位置应该根据所插入的列索引来计算
        CGFloat xOffset = _horizontalMinSpacing * (shortestColumnIndex +1) + columnWidth * shortestColumnIndex;
        CGFloat yOffset = [columnHeights[shortestColumnIndex] floatValue];
        
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(xOffset, yOffset, columnWidth, itemHeight);
        [itemAttributes addObject:attributes];
        
        //这是整个逻辑最关键的部分，在将当前cell插入到高度最短的列中后，需要将当前记录的最短列的高度加上当前
        //cell的高度和垂直间距，这样，最短的列就不再是此时的这一列了，因而在下一轮循环中就会将cell插入次底列
        //如此依次排列就能实现瀑布流布局
        columnHeights[shortestColumnIndex] = @(yOffset + itemHeight + _verticalMinSpacing);
    }

}

- (CGSize)collectionViewContentSize {
    if (_numberOfColumns == 0) {
        return CGSizeZero;
    }
    
    CGSize contentSize = self.collectionView.frame.size;
    NSUInteger columnIndex = [self longestColumnIndex];
    contentSize.height = [columnHeights[columnIndex] floatValue];
    contentSize.height += headerFrame.size.height;
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return itemAttributes[indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    attributes.frame = headerFrame;
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSPredicate * pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }];
    
    NSArray * results = [itemAttributes filteredArrayUsingPredicate:pre];
    
    return results;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}


@end
