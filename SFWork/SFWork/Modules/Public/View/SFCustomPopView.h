//
//  SFCustomPopView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFCustomPopView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, copy) void (^actionBlock)(void);
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

+ (instancetype)shareSFCustomPopView;
- (void)showFromView:(UIView *)superView actionBlock:(void (^)(void))actionBlock ;

@end

NS_ASSUME_NONNULL_END
