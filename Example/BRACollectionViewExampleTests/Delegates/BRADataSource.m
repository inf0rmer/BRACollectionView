//
//  BRADataSource.m
//  BRACollectionViewExample
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import "BRADataSource.h"
#import <BRACollectionView/BRACollectionViewCell.h>

@implementation BRADataSource

- (NSInteger)numberOfRowsForCollectionView:(BRACollectionView *)collectionView
{
  return 0;
}

- (BRACollectionViewCell *)collectionView:(BRACollectionView *)collectionView
                    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [BRACollectionViewCell new];
}

@end
