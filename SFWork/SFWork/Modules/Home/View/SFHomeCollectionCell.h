//
//  SFHomeCollectionCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFHomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFHomeCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) SFHomeModel *model;

@end

NS_ASSUME_NONNULL_END
