//
//  SFMineHeaderView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFMineHeaderView : UIView


+ (instancetype)shareSFMineHeaderView;
@property (nonatomic, copy) SFUserInfo *userInfo;
@property (nonatomic, copy) void (^enterPayClick)(void);

@end

NS_ASSUME_NONNULL_END
