//
//  SFWorkTwoButtonView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFWorkAssessPersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFWorkTwoButtonView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

+ (instancetype)shareSFWorkTwoButtonView ;

- (void)showFromView:(UIView *)superView withModel:(ScoreListModel *)model actionBlock:(void (^)(void))actionBlock;

@end

NS_ASSUME_NONNULL_END
