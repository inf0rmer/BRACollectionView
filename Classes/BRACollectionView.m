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

- (CGFloat)calculateContentHeight
{
  // The latest ObjectiveSugar version on Cocoapods
  // does not yet have #reduce. Sigh.
  __block CGFloat totalHeight = 0;
  [[self rows] each:^(NSNumber *rowNumber) {
    totalHeight += [self heightForRowAtIndexPath:[NSIndexPath indexPathWithIndex:[rowNumber integerValue]]];
  }];
  
  return totalHeight;
}

@end
