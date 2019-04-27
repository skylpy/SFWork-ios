//
//  SFWorkHeaderView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFWorkAssessPersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFWorkHeaderView : UIView

+ (instancetype)shareSFWorkHeaderView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sorceLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (nonatomic, strong) TotalSocreModel *model;

@end

NS_ASSUME_NONNULL_END
