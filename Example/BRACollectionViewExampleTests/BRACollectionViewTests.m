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
  
  describe(@"#numberOfRows", ^{
    let(dataSource, ^BRADataSource *{
      return [BRADataSource new];
    });
    
    beforeEach(^{
      collectionView.dataSource = dataSource;
      [dataSource stub:@selector(numberOfRowsForCollectionView:) andReturn:theValue(15)];
    });
    
    it(@"Returns the number of items in the dataSource", ^{
      [[theValue([collectionView numberOfRows]) should] equal:theValue(15)];
    });
  });
  
});

SPEC_END
