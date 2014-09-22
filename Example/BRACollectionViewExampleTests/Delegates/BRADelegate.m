//
//  BRADelegate.m
//  BRACollectionViewExample
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import "BRADelegate.h"

@implementation BRADelegate

- (void)collectionView:(BRACollectionView *)collectionView
       willDisplayCell:(BRACollectionViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)collectionView:(BRACollectionView *)collectionView
        didDisplayCell:(BRACollectionViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)collectionView:(BRACollectionView *)collectionView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 85.f;
}

- (void)collectionView:(BRACollectionView *)collectionView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
