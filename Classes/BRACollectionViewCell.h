//
//  BRACollectionViewCell.h
//  Pods
//
//  Created by Bruno Abrantes on 22/09/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BRACollectionViewCell : UIControl

@property (nonatomic, strong) NSString *reuseIdentifier;

@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UILabel *nameLabel;

- (instancetype)initWithReusableIdentifier:(NSString *)reuseIdentifier;

@end
