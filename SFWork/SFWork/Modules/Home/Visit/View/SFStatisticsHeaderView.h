//
//  SFStatisticsHeaderView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFStatisticsHeaderView : UIView

+ (instancetype)shareSuperAdminHeaderView ;

+ (instancetype)shareEmpHeaderView ;

@property (nonatomic,copy) void (^selectTap)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
