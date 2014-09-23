//
//  BRACollectionViewCell.m
//  Pods
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import "BRACollectionViewCell.h"

@interface BRACollectionViewCell()

@property (nonatomic, assign) BRACollectionViewStyle style;

@end

@implementation BRACollectionViewCell

static const float kImageSize = 80.f;
static const float kMapSize = 80.f;

- (instancetype)init
{
  return [self initWithStyle:BRACollectionViewStyleImage reuseIdentifier:nil];
}

- (instancetype)initWithStyle:(BRACollectionViewStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super init]) {
    [self setupSeparatorView];
    self.style = style;
    self.reuseIdentifier = (reuseIdentifier) ? reuseIdentifier : @"BRACollectionViewCell";
    [self setupTitleLabel];
    [self setupDetailLabel];
    [self setupImageView];
    [self setupMapView];
  }
  
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  const float padding = 15.f;
  const float horizontalSpacing = 20.f;
  const float verticalSpacing = 5.f;
  
  self.separatorView.frame = CGRectMake(0,
                                        self.frame.size.height - 1.f,
                                        self.frame.size.width,
                                        1.f);
  
  // Image
  if (self.style == BRACollectionViewStyleImage) {
    self.imageView.frame = CGRectMake(padding, padding, kImageSize, kImageSize);
  }
  
  // Map
  if (self.style == BRACollectionViewStyleMap) {
    self.mapView.frame = CGRectMake(padding, padding, kMapSize, kMapSize);
  }
  
  float titleOffset = (self.style == BRACollectionViewStyleImage) ? kImageSize : kMapSize;
  
  // Title
  [self.titleLabel sizeToFit];
  self.titleLabel.frame = CGRectMake(padding + titleOffset + horizontalSpacing,
                                     padding,
                                     self.bounds.size.width - (padding + titleOffset + horizontalSpacing + padding),
                                     self.titleLabel.frame.size.height);
  
  // Detail
  CGSize suggestedSize = [self.detailLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)];
  self.detailLabel.frame = CGRectMake(self.titleLabel.frame.origin.x,
                                      self.titleLabel.frame.origin.y + self.titleLabel.bounds.size.height + verticalSpacing,
                                      suggestedSize.width,
                                      suggestedSize.height);
}

#pragma mark - Custom

- (void)setupSeparatorView
{
  self.separatorView = [UIView new];
  
  self.separatorView.backgroundColor = [UIColor grayColor];
  
  [self addSubview:self.separatorView];
}

- (void)setupTitleLabel
{
  self.titleLabel = [UILabel new];
  self.titleLabel.font = [UIFont systemFontOfSize:18.f];
  self.titleLabel.textColor = UIColor.blackColor;
  self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  self.titleLabel.numberOfLines = 1;
  
  [self addSubview:self.titleLabel];
}

- (void)setupDetailLabel
{
  self.detailLabel = [UILabel new];
  self.detailLabel.font = [UIFont systemFontOfSize:14.f];
  self.detailLabel.textColor = UIColor.darkGrayColor;
  self.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  self.detailLabel.numberOfLines = 3;
  
  [self addSubview:self.detailLabel];
}

- (void)setupImageView
{
  self.imageView = [UIImageView new];
  self.imageView.contentMode = UIViewContentModeScaleAspectFill;
  self.imageView.clipsToBounds = YES;
  
  if (self.style == BRACollectionViewStyleImage) {
    [self addSubview:self.imageView];
  }
}

- (void)setupMapView
{
  self.mapView = [MKMapView new];
  self.mapView.mapType = MKMapTypeStandard;
  self.mapView.userInteractionEnabled = NO;
  self.mapView.zoomEnabled = NO;
  self.mapView.scrollEnabled = NO;
  
  if (self.style == BRACollectionViewStyleMap) {
    [self addSubview:self.mapView];
  }
}

@end
