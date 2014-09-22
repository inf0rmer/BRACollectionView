//
//  BRACollectionViewTests.m
//  BRACollectionViewExample
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import <Kiwi/Kiwi.h>
#import <BRACollectionView/BRACollectionView.h>
#import "BRADataSource.h"

SPEC_BEGIN(BRACOLLECTIONVIEWSPEC)

describe(@"BRACollectionView", ^{
  let(collectionView, ^BRACollectionView *{
    return [BRACollectionView new];
  });
  
  let(dataSource, ^BRADataSource *{
    return [BRADataSource new];
  });
  
  describe(@"#numberOfRows", ^{
    
    context(@"The first time it is requested", ^{
      beforeEach(^{
        collectionView.dataSource = dataSource;
        [dataSource stub:@selector(numberOfRowsForCollectionView:) andReturn:theValue(15)];
      });
      
      it(@"Returns the number of items in the dataSource", ^{
        [[dataSource should] receive:@selector(numberOfRowsForCollectionView:) andReturn:theValue(15)];
        [[theValue([collectionView numberOfRows]) should] equal:theValue(15)];
      });
    });
    
    context(@"The next time it is requested", ^{
      beforeEach(^{
        collectionView.dataSource = dataSource;
        [dataSource stub:@selector(numberOfRowsForCollectionView:) andReturn:theValue(10)];
        [collectionView numberOfRows];
      });
      
      it(@"Returns a cached result", ^{
        [[dataSource shouldNot] receive:@selector(numberOfRowsForCollectionView:)];
        [[theValue([collectionView numberOfRows]) should] equal:theValue(10)];
      });
    });
  });
  
});

SPEC_END
