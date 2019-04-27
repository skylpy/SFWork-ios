//
//  SFStatisticsHeaderView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFStatisticsHeaderView.h"

@interface SFStatisticsHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *companyButton;
@property (weak, nonatomic) IBOutlet UIButton *devButton;
@property (weak, nonatomic) IBOutlet UIButton *empButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewOneLayoutX;

@property (weak, nonatomic) IBOutlet UIButton *departButton;
@property (weak, nonatomic) IBOutlet UIButton *emplyseeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTwoLayoutX;


@property (weak, nonatomic) IBOutlet UIButton *emplyseeBtn;

@end

@implementation SFStatisticsHeaderView

+ (instancetype)shareSuperAdminHeaderView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFStatisticsHeaderView" owner:self options:nil].firstObject;
}



+ (instancetype)shareEmpHeaderView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFStatisticsHeaderView" owner:self options:nil].lastObject;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    //超级管理员
    @weakify(self)
    [[self.companyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.viewOneLayoutX.constant = 0;
        [self selectOneClick:x];
        !self.selectTap?:self.selectTap(0);
    }];
    [[self.devButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.viewOneLayoutX.constant = kWidth/3;
        [self selectOneClick:x];
        !self.selectTap?:self.selectTap(1);
    }];
    [[self.empButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.viewOneLayoutX.constant = kWidth/3*2;
        [self selectOneClick:x];
        !self.selectTap?:self.selectTap(2);
    }];
    
    //员工
    [[self.emplyseeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
    }];
}


- (void)selectOneClick:(UIButton *)sender {
    
    for (int i = 1000; i < 1003; i++) {
        
        UIButton * button = [self viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
}

@end
