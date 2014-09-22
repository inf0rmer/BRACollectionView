//
//  BRACollectionView.h
//  Pods
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BRACollectionViewCell.h"

/**
 `BRACollectionView` is a scrollable collection view that 
 supports the displaying of BRACollectionViewCell instances.
 */
@class BRACollectionView;

///-----------------------------------------
/// @name BRACollectionViewDelegate protocol
///-----------------------------------------

/**
 The BRACollectionViewDelegate protocol handles the displaying and 
 behaviour of cells.
 */
@protocol BRACollectionViewDelegate <NSObject, UIScrollViewDelegate>

@optional

#pragma mark - Display Customisation hooks
///----------------------------
/// @name Display Customisation
///----------------------------

/**
 You can use this hook to customise a cell before it is rendered.
 
 @param collectionView The BRACollectionView instance
 @param cell The BRACollectionViewCell instance that is about to be rendered
 @param indexPAth The indexPath the cell is being rendered at.
 */
- (void)collectionView:(BRACollectionView *)collectionView
       willDisplayCell:(BRACollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 You can use this hook to customise a cell after it is rendered.
 
 @param collectionView The BRACollectionView instance
 @param cell The BRACollectionViewCell instance that has just been rendered
 @param indexPAth The indexPath the cell was rendered at.
 */
- (void)collectionView:(BRACollectionView *)collectionView
        didDisplayCell:(BRACollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath;

///---------------------
/// @name Variable Height
///---------------------

/**
 Use this to provide a height to the cell before it is rendered.
 
 @param collectionView The BRACollectionView instance.
 @param indexPath The indexPath the cell will be displayed at.
 
 @return The desired cell height.
 */
- (CGFloat)collectionView:(BRACollectionView *)collectionView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath;

///---------------------
/// @name Cell Selection
///---------------------

/**
 Use this to react to a cell being tapped.
 
 @param collectionView The BRACollectionView instance.
 @param indexPath The indexPath of the cell.
 */
- (void)collectionView:(BRACollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

///-------------------------------------------
/// @name BRACollectionViewDataSource protocol
///-------------------------------------------

/**
 The BRACollectionViewDataSource protocol is used to provide data
 to the cells.
 */

@protocol BRACollectionViewDataSource <NSObject>

@required

/**
 Provide the total number of rows in the collection view.
 
 @param collectionView The BRACollectionView instance.
 
 @return The total number of rows.
 */
- (NSInteger)numberOfRowsForCollectionView:(BRACollectionView *)collectionView;

/**
 Provide a BRACollectionViewCell instance for displaying.
 
 @param collectionView The BRACollectionView instance.
 @param indexPath The indexPath the cell will be displayed at.
 
 @return A configured BRACollectionViewCell instance.
 */
- (BRACollectionViewCell *)collectionView:(BRACollectionView *)collectionView
                    cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BRACollectionView : NSObject

@property (nonatomic, assign) id <BRACollectionViewDataSource> dataSource;

///--------------------
/// @name Data handling
///--------------------

/**
 Reloads the collection view from scratch, redisplaying visible cells.
 */
- (void)reloadData;

///------------
/// @name Info
///------------

/**
 @return The total number of rows in the collection.
 */
- (NSInteger)numberOfRows;

/**
 @return The cell at the index path, or nil if the cell is not visible or indexPath is out of range
 */
- (BRACollectionViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

///------------------------------
/// @name Cell allocation & reuse
///------------------------------

/**
 Should be used by the delegate to acquire a previously allocated cell
 instead of always allocating a new one. If a cell isn't ready, it creates a new one.
 
 @return A BRACollectionViewCell instance, either fresh or reused.
 */
- (BRACollectionViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
