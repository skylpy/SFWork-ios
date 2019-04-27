//
//  SFStatisticesView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFStatisticesView.h"

@interface SFStatisticesView ()
@property (weak, nonatomic) IBOutlet UIButton *departButton;
@property (weak, nonatomic) IBOutlet UIButton *employessButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutX;

@end

@implementation SFStatisticesView

+ (instancetype)sharedevAdminHeaderView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFStatisticesView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    @weakify(self)
    [[self.departButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.viewLayoutX.constant = 0;
        [self selectOneClick:x];
        !self.selectTap?:self.selectTap(1);
    }];
    
    [[self.employessButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.viewLayoutX.constant = kWidth/2;
        [self selectOneClick:x];
        !self.selectTap?:self.selectTap(2);
    }];
}

- (void)selectOneClick:(UIButton *)sender {
    
    for (int i = 1000; i < 1002; i++) {
        
        UIButton * button = [self viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
}

@end
