//
//  BRACollectionView.m
//  Pods
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import "BRACollectionView.h"

@interface BRACollectionView()

- (CGFloat)calculateContentHeight;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) NSArray *cellHeights;

@end

@implementation BRACollectionView {
  NSInteger _numberOfRows;
}

#pragma mark - Lifecycle

- (instancetype)init
{
  if (self == [super init]) {
    _numberOfRows = NSNotFound;
  }
  
  return self;
}

#pragma mark - Public Interface

- (NSInteger)numberOfRows
{
  if (_numberOfRows != NSNotFound) {
    return _numberOfRows;
  }
  
  if ([self.dataSource respondsToSelector:@selector(numberOfRowsForCollectionView:)]) {
    _numberOfRows = [self.dataSource numberOfRowsForCollectionView:self];
    return _numberOfRows;
  }
  
  return 0;
}

- (void)reloadData
{
  // Reset _numberOfRows
  _numberOfRows = NSNotFound;
  
  // Recalculate content height
  self.contentSize = CGSizeMake(self.bounds.size.width, [self calculateContentHeight]);
}

#pragma mark - Helpers

- (NSArray *)rows
{
  NSRange range = NSMakeRange(0, [self numberOfRows]);
  NSMutableArray *rows = [NSMutableArray array];
  
  for (NSUInteger i = range.location; i < range.location + range.length; i++) {
    [rows addObject:[NSNumber numberWithUnsignedInteger:i]];
  }
  
  return rows;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(collectionView:heightForRowAtIndexPath:)]) {
    return [self.delegate collectionView:self heightForRowAtIndexPath:indexPath];
  }
  
  return 44.f;
}

- (NSArray *)getCellHeights {
  return [[self rows] map:^NSNumber *(NSNumber *rowNumber) {
    return @([self heightForRowAtIndexPath:[NSIndexPath indexPathWithIndex:[rowNumber integerValue]]]);
  }];
}

- (CGFloat)calculateContentHeight
{
  // Cache cell heights
  self.cellHeights = [self getCellHeights];
  
  // The latest ObjectiveSugar version on Cocoapods
  // does not yet have #reduce. Sigh.
  __block CGFloat totalHeight = 0;
  [self.cellHeights each:^(NSNumber *height) {
    totalHeight += [height floatValue];
  }];
  
  return totalHeight;
}

@end
