//
//  BRACollectionViewCell.m
//  Pods
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import "BRACollectionViewCell.h"

@implementation BRACollectionViewCell

- (instancetype)init
{
  return [self initWithReusableIdentifier:nil];
}

- (instancetype)initWithReusableIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super init]) {
    [self setupSeparatorView];
    self.reuseIdentifier = (reuseIdentifier) ? reuseIdentifier : @"BRACollectionViewCell";
    self.nameLabel = [UILabel new];
  }
  
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  self.separatorView.frame = CGRectMake(0,
                                        self.frame.size.height - 20.f,
                                        self.frame.size.width,
                                        1.f);
}

#pragma mark - Custom

- (void)setupSeparatorView
{
  self.separatorView = [UIView new];
  
  self.separatorView.backgroundColor = [UIColor grayColor];
  
  [self addSubview:self.separatorView];
}

@end
