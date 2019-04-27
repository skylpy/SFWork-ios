//
//  SFCustomPopView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFCustomPopView.h"

@implementation SFCustomPopView

+ (instancetype)shareSFCustomPopView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFCustomPopView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.popView.layer.cornerRadius = 10;
    self.popView.clipsToBounds = YES;
    
    @weakify(self)
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self hideView];
    }];
    
    [[self.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self sureClick];
        
    }];
}

- (void)sureClick{
    
    !self.actionBlock?:self.actionBlock();
    [self hideView];
}

- (void)hideView{
    
    [self removeFromSuperview];
}

- (void)showFromView:(UIView *)superView actionBlock:(void (^)(void))actionBlock  {
    
    self.frame = superView.bounds;
    [superView addSubview:self];
    self.actionBlock = actionBlock;
    
}

@end
