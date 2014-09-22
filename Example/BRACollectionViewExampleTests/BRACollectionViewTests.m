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
- (void)removeCells;
- (void)addCells;
- (void)newVisibleCellsForArray:(NSArray *)array;
- (void)enqueueReusableCell:(BRACollectionViewCell *)cell withIdentifier:(NSString *)identifier;

@property (nonatomic, strong) NSArray *cellHeights;
@property (nonatomic, strong) NSMutableDictionary *reusableCellPool;
@property (nonatomic, strong) NSArray *visibleCells;

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
  
  describe(@"#dequeueReusableCellWithIdentifier:", ^{
    context(@"When there is no cached array for the given identifier", ^{
      beforeEach(^{
        [collectionView.reusableCellPool stub:@selector(hasKey:) andReturn:theValue(NO)];
      });
      
      it(@"Returns nil", ^{
        [[[collectionView dequeueReusableCellWithIdentifier:@"identifier"] should] beNil];
      });
    });
    
    context(@"When there are no cells for the given identifier", ^{
      beforeEach(^{
        collectionView.reusableCellPool[@"identifier"] = [NSMutableArray arrayWithCapacity:0];
      });
      
      it(@"Returns nil", ^{
        [[[collectionView dequeueReusableCellWithIdentifier:@"identifier"] should] beNil];
      });
    });
    
    context(@"When there is at least a cell for the given identifier", ^{
      beforeEach(^{
        collectionView.reusableCellPool[@"identifier"] = [[NSMutableArray alloc] initWithArray:@[[BRACollectionViewCell new]]];
      });
      
      it(@"Returns the cell", ^{
        [[[collectionView dequeueReusableCellWithIdentifier:@"identifier"] should] beKindOfClass:[BRACollectionViewCell class]];
      });
      
      it(@"Deletes the cell from the pool", ^{
        [collectionView dequeueReusableCellWithIdentifier:@"identifier"];
        
        NSArray *cellPool = collectionView.reusableCellPool[@"identifier"];
        [[theValue(cellPool.count) should] equal:theValue(0)];
      });
    });
  });
  
  describe(@"#layoutSubviews", ^{
    let(cell1, ^BRACollectionViewCell *{
      return [BRACollectionViewCell new];
    });
    
    let(cell2, ^BRACollectionViewCell *{
      return [BRACollectionViewCell new];
    });
    
    let(cell3, ^BRACollectionViewCell *{
      return [BRACollectionViewCell new];
    });
    
    let(cell4, ^BRACollectionViewCell *{
      return [BRACollectionViewCell new];
    });
    
    beforeEach(^{
      collectionView.visibleCells = @[cell1, cell2];
      
      [collectionView stub:@selector(newVisibleCellsForArray:) andReturn:@[cell3, cell4]];
    });
    
    it(@"Removes old cells from the view", ^{
      [[cell1 should] receive:@selector(removeFromSuperview)];
      [[cell2 should] receive:@selector(removeFromSuperview)];
      
      [collectionView layoutSubviews];
    });
    
    it(@"Enqueues the old cells for later reuse", ^{
      [[collectionView should] receive:@selector(enqueueReusableCell:withIdentifier:) withArguments:cell1, cell1.reuseIdentifier, nil];
      [[collectionView should] receive:@selector(enqueueReusableCell:withIdentifier:) withArguments:cell2, cell2.reuseIdentifier, nil];
      
      [collectionView layoutSubviews];
    });
    
    it(@"Adds the new cells", ^{
      [[collectionView should] receive:@selector(addSubview:) withArguments:cell3, nil];
      [[collectionView should] receive:@selector(addSubview:) withArguments:cell4, nil];
      
      [collectionView layoutSubviews];
    });
  });
  
});

SPEC_END
