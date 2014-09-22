//
//  BRACollectionView.m
//  Pods
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import "BRACollectionView.h"

@implementation BRACollectionView

- (NSInteger)numberOfRows
{
  if ([self.dataSource respondsToSelector:@selector(numberOfRowsForCollectionView:)]) {
    return [self.dataSource numberOfRowsForCollectionView:self];
  }
  
  return 0;
}

@end
