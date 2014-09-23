//
//  BRACollectionViewCell.h
//  Pods
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, BRACollectionViewStyle) {
  BRACollectionViewStyleImage,
  BRACollectionViewStyleMap
};

@interface BRACollectionViewCell : UIControl

@property (nonatomic, strong) NSString *reuseIdentifier;

@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithStyle:(BRACollectionViewStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
