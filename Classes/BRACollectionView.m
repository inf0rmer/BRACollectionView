//
//  BRACollectionView.m
//  Pods
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import "BRACollectionView.h"

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
  _numberOfRows = NSNotFound;
}

@end
