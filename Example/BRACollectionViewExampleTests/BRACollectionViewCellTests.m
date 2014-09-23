//
//  BRACollectionViewCellTests.m
//  BRACollectionViewExample
//
//  Created by Bruno Abrantes on 23/09/14.
//
//

#import <BRACollectionView/BRACollectionViewCell.h>
#import <ObjectiveSugar/ObjectiveSugar.h>
#import <Kiwi/Kiwi.h>

SPEC_BEGIN(BRACOLLECTIONVIEWCELLSPEC)

describe(@"BRACollectionViewCell", ^{
  describe(@"Initialization", ^{
    context(@"When style is BRACollectionViewStyleMap", ^{
      let(cell, ^BRACollectionViewCell *{
        return [[BRACollectionViewCell alloc] initWithStyle:BRACollectionViewStyleMap reuseIdentifier:nil];
      });
      
      it(@"Adds the map view to its subviews", ^{
        [[theValue([cell.subviews includes:cell.mapView]) should] beTrue];
      });
      
      it(@"Does not add the image view to its subviews", ^{
        [[theValue([cell.subviews includes:cell.imageView]) should] beFalse];
      });
    });
  });
});

SPEC_END