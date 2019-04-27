//
//  SFAttendancePopView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/24.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMyAttendanceHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAttendancePopView : UIView

+ (instancetype)shareSFAttendancePopView;
- (void)showInView:(UIView *)superView
         withModel:(MyAttendanceGetRecord *)model
       actionBlock:(void (^)(void))actionBlock;

@end

NS_ASSUME_NONNULL_END
