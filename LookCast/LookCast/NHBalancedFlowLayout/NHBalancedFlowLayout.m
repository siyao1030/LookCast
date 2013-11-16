//
//  BalancedFlowLayout.m
//  BalancedFlowLayout
//
//  Created by Niels de Hoog on 31/10/13.
//  Copyright (c) 2013 Niels de Hoog. All rights reserved.
//

#import "NHBalancedFlowLayout.h"
#import "NHLinearPartition.h"

@interface NHBalancedFlowLayout ()

@property (nonatomic) CGSize contentSize;
@property (nonatomic, strong) NSArray *itemFrames;

@end

@implementation NHBalancedFlowLayout

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

#pragma mark - Layout

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSAssert([self.delegate conformsToProtocol:@protocol(NHBalancedFlowLayoutDelegate)], @"UICollectionView delegate should conform to BalancedFlowLayout protocol");
    
    CGFloat idealHeight = self.preferredRowSize;
    if (idealHeight == 0) {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            idealHeight = CGRectGetHeight(self.collectionView.bounds) / 3.0;
        }
        else {
            idealHeight = CGRectGetWidth(self.collectionView.bounds) / 3.0;
        }
    }
    
    NSMutableArray *itemFrames = [NSMutableArray array];
    CGSize contentSize = CGSizeZero;
    for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
        CGSize sectionSize = CGSizeZero;
        
        CGFloat totalItemSize = [self totalItemSizeForSection:section preferredRowSize:idealHeight];
        NSInteger numberOfRows = MAX(roundf(totalItemSize / [self viewPortAvailableSize]), 1);
    
        CGPoint sectionOffset = self.scrollDirection == UICollectionViewScrollDirectionVertical ? CGPointMake(0, contentSize.height) : CGPointMake(contentSize.width, 0);
        NSArray *framesForSection = [self framesForItemsInSection:section numberOfRows:numberOfRows sectionOffset:sectionOffset sectionSize:&sectionSize];
        [itemFrames addObject:framesForSection];
        
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            contentSize = CGSizeMake(sectionSize.width, contentSize.height + sectionSize.height);
        }
        else {
            contentSize = CGSizeMake(contentSize.width + sectionSize.width, sectionSize.height);
        }
    }
    
    self.itemFrames = [itemFrames copy];
    
    self.contentSize = contentSize;
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    NSArray *visibleIndexPaths = [self indexPathsForItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        [layoutAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self itemFrameForIndexPath:indexPath];
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds) || CGRectGetHeight(newBounds) != CGRectGetHeight(oldBounds)) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Layout helpers

- (NSArray *)indexPathsForItemsInRect:(CGRect)rect
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger section = 0, n = [self.collectionView numberOfSections]; section < n; section++) {
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:section]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            if (CGRectIntersectsRect(rect, [self itemFrameForIndexPath:indexPath])) {
                [indexPaths addObject:indexPath];
            }
        }
    }
    
    return [indexPaths copy];
}

- (CGRect)itemFrameForIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.itemFrames objectAtIndex:indexPath.section] objectAtIndex:indexPath.item] CGRectValue];
}

- (CGFloat)totalItemSizeForSection:(NSInteger)section preferredRowSize:(CGFloat)preferredRowSize
{
    CGFloat totalItemSize = 0;
    for (NSInteger i = 0, n = [self.collectionView numberOfItemsInSection:section]; i < n; i++) {
        CGSize preferredSize = [self.delegate collectionView:self.collectionView layout:self preferredSizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
        
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            totalItemSize += (preferredSize.width / preferredSize.height) * preferredRowSize;
        }
        else {
            totalItemSize += (preferredSize.height / preferredSize.width) * preferredRowSize;
        }
    }
    
    return totalItemSize;
}

- (NSArray *)weightsForItemsInSection:(NSInteger)section
{
    NSMutableArray *weights = [NSMutableArray array];
    for (NSInteger i = 0, n = [self.collectionView numberOfItemsInSection:section]; i < n; i++) {
        CGSize preferredSize = [self.delegate collectionView:self.collectionView layout:self preferredSizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
        NSInteger aspectRatio = self.scrollDirection == UICollectionViewScrollDirectionVertical ? roundf((preferredSize.width / preferredSize.height) * 100) : roundf((preferredSize.height / preferredSize.width) * 100);
        [weights addObject:@(aspectRatio)];
    }
    
    return [weights copy];
}

- (NSArray *)framesForItemsInSection:(NSInteger)section numberOfRows:(NSUInteger)numberOfRows sectionOffset:(CGPoint)sectionOffset sectionSize:(CGSize *)sectionSize
{
    NSMutableArray *itemFrames = [NSMutableArray array];

    NSArray *weights = [self weightsForItemsInSection:section];
    NSArray *partition = [NHLinearPartition linearPartitionForSequence:weights numberOfPartitions:numberOfRows];
    
    int i = 0;
    CGPoint offset = CGPointMake(sectionOffset.x + self.sectionInset.left, sectionOffset.y + self.sectionInset.top);
    CGFloat previousItemSize = 0;
    CGFloat contentMaxValueInScrollDirection = 0;
    for (NSArray *row in partition) {
        
        CGFloat summedRatios = 0;
        for (NSInteger j = i, n = i + [row count]; j < n; j++) {
            CGSize preferredSize = [self.delegate collectionView:self.collectionView layout:self preferredSizeForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:section]];
            
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                summedRatios += preferredSize.width / preferredSize.height;
            }
            else {
                summedRatios += preferredSize.height / preferredSize.width;
            }
        }
        
        CGFloat rowSize = [self viewPortAvailableSize] - (([row count] - 1) * self.minimumInteritemSpacing);
        for (NSInteger j = i, n = i + [row count]; j < n; j++) {
            CGSize preferredSize = [self.delegate collectionView:self.collectionView layout:self preferredSizeForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:section]];
            
            CGSize actualSize = CGSizeZero;
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                actualSize = CGSizeMake(roundf(rowSize / summedRatios * (preferredSize.width / preferredSize.height)), roundf(rowSize / summedRatios));
            }
            else {
                actualSize = CGSizeMake(roundf(rowSize / summedRatios), roundf(rowSize / summedRatios * (preferredSize.height / preferredSize.width)));
            }
            
            CGRect frame = CGRectMake(offset.x, offset.y, actualSize.width, actualSize.height);
            [itemFrames addObject:[NSValue valueWithCGRect:frame]];
            
            
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                offset.x += actualSize.width + self.minimumInteritemSpacing;
                previousItemSize = actualSize.height;
                contentMaxValueInScrollDirection = CGRectGetMaxY(frame);
            }
            else {
                offset.y += actualSize.height + self.minimumInteritemSpacing;
                previousItemSize = actualSize.width;
                contentMaxValueInScrollDirection = CGRectGetMaxX(frame);
            }
        }
        
        // move offset to next line
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            offset = CGPointMake(self.sectionInset.left, offset.y + previousItemSize + self.minimumLineSpacing);
        }
        else {
            offset = CGPointMake(offset.x + previousItemSize + self.minimumLineSpacing, self.sectionInset.top);
        }
        
        i += [row count];
    }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        *sectionSize = CGSizeMake([self viewPortWidth], (contentMaxValueInScrollDirection - sectionOffset.y) + self.sectionInset.bottom);
    }
    else {
        *sectionSize = CGSizeMake((contentMaxValueInScrollDirection - sectionOffset.x) + self.sectionInset.right, [self viewPortHeight]);
    }
    
    return [itemFrames copy];
}

- (CGFloat)viewPortWidth
{
    return CGRectGetWidth(self.collectionView.frame) - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
}

- (CGFloat)viewPortHeight
{
    return (CGRectGetHeight(self.collectionView.frame) - self.collectionView.contentInset.top  - self.collectionView.contentInset.bottom);
}

- (CGFloat)viewPortAvailableSize
{
    CGFloat availableSize = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        availableSize = [self viewPortWidth] - self.sectionInset.left - self.sectionInset.right;
    }
    else {
        availableSize = [self viewPortHeight] - self.sectionInset.top - self.sectionInset.bottom;
    }
    
    return availableSize;
}

#pragma mark - Custom setters

- (void)setPreferredRowSize:(CGFloat)preferredRowHeight
{
    _preferredRowSize = preferredRowHeight;
    
    [self invalidateLayout];
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    _sectionInset = sectionInset;
    
    [self invalidateLayout];
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing
{
    _minimumLineSpacing = minimumLineSpacing;
    
    [self invalidateLayout];
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    _minimumInteritemSpacing = minimumInteritemSpacing;
    
    [self invalidateLayout];
}

#pragma mark - Delegate

- (id<NHBalancedFlowLayoutDelegate>)delegate
{
    return (id<NHBalancedFlowLayoutDelegate>)self.collectionView.delegate;
}

@end
