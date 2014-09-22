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
- (void)enqueueReusableCell:(BRACollectionViewCell *)cell withIdentifier:(NSString *)identifier;

@property (nonatomic, strong) NSArray *cellHeights;
@property (nonatomic, strong) NSArray *visibleCells;
@property (nonatomic, strong) NSMutableDictionary *reusableCellPool;

@end

@implementation BRACollectionView {
  NSInteger _numberOfRows;
  NSMutableDictionary *_rowCellMap;
}

#define LOCATIONS_INTERSECT(location1, length1, location2, length2) ((location1 + length1 >= location2) && (location2 + length2 >= location1))

#pragma mark - Lifecycle

- (instancetype)init
{
  if (self == [super init]) {
    [self commonInit];
  }
  
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if (self == [super initWithCoder:aDecoder]) {
    [self commonInit];
  }
  
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self == [super initWithFrame:frame]) {
    [self commonInit];
  }
  
  return self;
}

- (void)commonInit
{
  _numberOfRows = NSNotFound;
  _rowCellMap = [NSMutableDictionary new];
  self.reusableCellPool = [NSMutableDictionary new];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  // Remove previous cells
  [self removeCells];
  
  // Add visible cells
  [self addCells];
}

- (void)dealloc
{
  [self removeCells];
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

- (BRACollectionViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
  unless([self.reusableCellPool hasKey:identifier]) {
    return nil;
  }
  
  NSMutableArray *cells = self.reusableCellPool[identifier];
  
  unless(cells.count > 0) {
    return nil;
  }
  
  BRACollectionViewCell *cell = [cells firstObject];
  [cells removeObject:cell];
  
  return cell;
}

- (BRACollectionViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return (BRACollectionViewCell *)_rowCellMap[@(indexPath.row)];;
}

#pragma mark - Private Interface

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
  [self.cellHeights each:^(NSNumber *height) {
    totalHeight += [height floatValue];
  }];
  
  return totalHeight;
}

- (void)enqueueReusableCell:(BRACollectionViewCell *)cell withIdentifier:(NSString *)identifier
{
  unless([self.reusableCellPool hasKey:identifier]) {
    self.reusableCellPool[identifier] = [NSMutableArray new];
  }
  
  [self.reusableCellPool[identifier] addObject:cell];
}

- (void)removeCells
{
  [self.visibleCells each:^(BRACollectionViewCell *cell) {
    [cell removeFromSuperview];
    [self enqueueReusableCell:cell withIdentifier:cell.reuseIdentifier];
    [[_rowCellMap keysOfEntriesPassingTest:^BOOL(id key, BRACollectionViewCell *aCell, BOOL *stop) {
      return (cell == aCell);
    }] each:^(NSString *key) {
      _rowCellMap[key] = [NSNull null];
    }];
  }];
}

- (void)addCells
{
  self.visibleCells = [self newVisibleCellsForArray:self.visibleCells];
  
  [self.visibleCells each:^(BRACollectionViewCell *cell) {
    if (cell.superview == nil) {
      [self addSubview:cell];
    }
  }];
}

#pragma mark - Getters
- (NSArray *)cellHeights
{
  if (_cellHeights) {
    return _cellHeights;
  } else {
    return [self getCellHeights];
  }
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

- (NSArray *)getCellHeights {
  return [[self rows] map:^NSNumber *(NSNumber *rowNumber) {
    return @([self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:[rowNumber integerValue] inSection:0]]);
  }];
}

/*
- (NSArray *)cellsToBeRemovedInArray:(NSArray *)cells
{
  return [cells select:^BOOL(BRACollectionViewCell *cell) {
    CGFloat cellYOffset = CGRectGetMinY(cell.frame);
    CGFloat cellHeight = CGRectGetHeight(cell.bounds);
    
    BOOL intersects = (LOCATIONS_INTERSECT(self.contentOffset.y, self.bounds.size.height, cellYOffset, cellHeight));
    
    return (!intersects);
  }];
}
*/

- (NSArray *)newVisibleCellsForArray:(NSArray *)cells
{
  NSArray *visibleIndices = [[[self rows] map:^NSIndexPath *(NSNumber *rowNumber) {
    return ([self isRowVisible:rowNumber]) ? [NSIndexPath indexPathForRow:[rowNumber integerValue] inSection:0] : nil;
  }] reject:^BOOL(id object) {
    return object == [NSNull null];
  }];
  
  return [visibleIndices map:^BRACollectionViewCell *(NSIndexPath *indexPath) {
    BRACollectionViewCell *cell = [self.dataSource collectionView:self cellForRowAtIndexPath:indexPath];
    _rowCellMap[@(indexPath.row)] = cell;
    
    __block CGFloat rowOffsetY = 0;
    [[[self rows] take:indexPath.row] each:^(NSNumber *aRow) {
      rowOffsetY += [(NSNumber *)[self.cellHeights objectAtIndex:aRow.integerValue] floatValue];
    }];
    
    CGFloat rowHeight = [(NSNumber *)[self.cellHeights objectAtIndex:indexPath.row] floatValue];
    
    cell.frame = CGRectMake(0, rowOffsetY, self.bounds.size.width, rowHeight);
    
    return cell;
  }];
}

- (BOOL)isRowVisible:(NSNumber *)row
{
  __block CGFloat rowOffsetY = 0;
  [[[self rows] take:row.integerValue] each:^(NSNumber *aRow) {
    rowOffsetY += [(NSNumber *)[self.cellHeights objectAtIndex:aRow.integerValue] floatValue];
  }];
  
  CGFloat rowHeight = [(NSNumber *)[self.cellHeights objectAtIndex:row.integerValue] floatValue];
  
  return (LOCATIONS_INTERSECT(self.contentOffset.y, self.bounds.size.height, rowOffsetY, rowHeight));
}

@end
