//
//  SFWorkOneButtonView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFWorkAssessPersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFWorkOneButtonView : UIView

+ (instancetype)shareSFWorkOneButtonView;
- (void)showFromView:(UIView *)superView withModel:(ScoreListModel *)model actionBlock:(void (^)(void))actionBlock ;

@end

NS_ASSUME_NONNULL_END
