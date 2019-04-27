//
//  SFStatisticsHeaderView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFStatisticsView.h"

@interface SFStatisticsView ()

@property (weak, nonatomic) IBOutlet UIButton *companyButton;

@property (weak, nonatomic) IBOutlet UIButton *depButton;

@property (weak, nonatomic) IBOutlet UIButton *empButton;

@property (weak, nonatomic) IBOutlet UIButton *reportButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLayoutX;

@end

@implementation SFStatisticsView

+ (instancetype)shareStatisticsHeaderView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFStatisticsView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    @weakify(self)
    
    [[self.companyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.lineViewLayoutX.constant = 0;
        [self selectOneClick:x];
        !self.selectTap?:self.selectTap(1);
    }];
    
    [[self.depButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.lineViewLayoutX.constant = kWidth/4;
        [self selectOneClick:x];
        !self.selectTap?:self.selectTap(2);
    }];
    
    [[self.empButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.lineViewLayoutX.constant = kWidth/4*2;
        [self selectOneClick:x];
        !self.selectTap?:self.selectTap(3);
    }];
    
    [[self.reportButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.lineViewLayoutX.constant = kWidth/4*3;
        [self selectOneClick:x];
        !self.selectTap?:self.selectTap(4);
    }];
}

- (void)selectOneClick:(UIButton *)sender {
    
    for (int i = 1000; i < 1005; i++) {
        
        UIButton * button = [self viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
}


@end
