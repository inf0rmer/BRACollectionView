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
#import "BRADelegate.h"

@interface BRACollectionView()

- (CGFloat)calculateContentHeight;
- (void)removeCells;
- (void)addCells;
- (NSArray *)visibleCells;
- (void)newVisibleCellsForArray:(NSArray *)array;
- (void)enqueueReusableCell:(BRACollectionViewCell *)cell withIdentifier:(NSString *)identifier;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectCell:(BRACollectionViewCell *)cell;
- (NSIndexPath *)indexPathForCell:(BRACollectionViewCell *)cell;

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
  
  describe(@"#cellForRowAtIndexPath", ^{
    context(@"When there is no cell at the path", ^{
      it(@"Returns nil", ^{
        [[[collectionView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:999 inSection:0]] should] beNil];
      });
    });
    
    context(@"When there is a cell at the path", ^{
      let(cell1, ^BRACollectionViewCell *{
        return [BRACollectionViewCell new];
      });
      
      beforeEach(^{
        collectionView.dataSource = dataSource;
        collectionView.visibleCells = @[cell1];
        [collectionView stub:@selector(numberOfRows) andReturn:theValue(1)];
        [dataSource stub:@selector(collectionView:cellForRowAtIndexPath:) andReturn:cell1];
        [collectionView layoutSubviews];
      });
      
      it(@"Returns the cell", ^{
        BRACollectionViewCell *cell = [collectionView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[cell should] equal:cell1];
      });
    });
  });
  
  describe(@"BRACollectionViewDelegate protocol", ^{
    let(delegate, ^id{
      return [BRADelegate new];
    });
    
    let(cell1, ^BRACollectionViewCell *{
      return [BRACollectionViewCell new];
    });
    
    describe(@"#collectionView:willDisplayCell:forRowAtIndexPath", ^{
      beforeEach(^{
        collectionView.delegate = delegate;
        [collectionView stub:@selector(visibleCells) andReturn:@[cell1]];
      });
      
      it(@"Is called when cell is about to display", ^{
        [[delegate should] receive:@selector(collectionView:willDisplayCell:forRowAtIndexPath:) withArguments:collectionView, cell1, [NSIndexPath indexPathForRow:0 inSection:0], nil];
        
        [collectionView addCells];
      });
    });
    
    describe(@"#collectionView:didDisplayCell:forRowAtIndexPath", ^{
      beforeEach(^{
        collectionView.delegate = delegate;
        [collectionView stub:@selector(visibleCells) andReturn:@[cell1]];
      });
      
      it(@"Is called when cell is about to display", ^{
        [[delegate should] receive:@selector(collectionView:didDisplayCell:forRowAtIndexPath:) withArguments:collectionView, cell1, [NSIndexPath indexPathForRow:0 inSection:0], nil];
        
        [collectionView addCells];
      });
    });
    
    describe(@"#collectionView:heightForRowAtIndexPath", ^{
      beforeEach(^{
        collectionView.delegate = delegate;
      });
      
      it(@"Is called when #heightForRowAtIndexPath: is called", ^{
        [[delegate should] receive:@selector(collectionView:heightForRowAtIndexPath:) withArguments:collectionView, [NSIndexPath indexPathForRow:0 inSection:0], nil];
        
        [collectionView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
      });
    });
    
    describe(@"#collectionView:didSelectRowAtIndexPath:", ^{
      let(indexPath, ^NSIndexPath *{
        return [NSIndexPath indexPathForRow:1 inSection:0];
      });
      
      beforeEach(^{
        collectionView.delegate = delegate;
        [collectionView stub:@selector(indexPathForCell:) andReturn:indexPath];
      });
      
      it(@"Is called when a cell is tapped", ^{
        [[delegate should] receive:@selector(collectionView:didSelectRowAtIndexPath:) withArguments:collectionView, indexPath, nil];
        
        [collectionView didSelectCell:cell1];
      });
    });
  });
  
});

SPEC_END
