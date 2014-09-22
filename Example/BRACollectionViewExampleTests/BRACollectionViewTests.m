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

@interface BRACollectionView()

- (CGFloat)calculateContentHeight;

@property (nonatomic, strong) NSArray *cellHeights;

@end

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
  
  describe(@"#reloadData", ^{
    beforeEach(^{
      collectionView.dataSource = dataSource;
      [dataSource stub:@selector(numberOfRowsForCollectionView:) andReturn:theValue(15)];
    });
    
    it(@"Busts the #numberOfRows cache", ^{
      // Ensure #numberOfRows is cached
      [collectionView stub:@selector(calculateContentHeight)];
      [collectionView numberOfRows];
      
      [collectionView reloadData];
      
      [[dataSource should] receive:@selector(numberOfRowsForCollectionView:)];
      [collectionView numberOfRows];
    });
    
    it(@"Caches #cellHeights", ^{
      collectionView.cellHeights = nil;
      
      [collectionView reloadData];
      
      [[collectionView.cellHeights shouldNot] beNil];
    });
    
    context(@"When the delegate does not provide cell height", ^{
      beforeEach(^{
        [collectionView stub:@selector(numberOfRows) andReturn:theValue(15)];
      });
      
      it(@"Sets the content height to the total number of cells * 44.f", ^{
        [collectionView reloadData];
        
        [[theValue(collectionView.contentSize) should] equal:theValue(CGSizeMake(collectionView.bounds.size.width, 15 * 44.f))];
      });
    });
  });
  
});

SPEC_END
