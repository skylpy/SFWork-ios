//
//  SFWorkHeaderView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFWorkHeaderView.h"

@interface SFWorkHeaderView ()


@end

@implementation SFWorkHeaderView

+ (instancetype)shareSFWorkHeaderView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFWorkHeaderView" owner:self options:nil].firstObject;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.timeButton layoutButtonWithImageStyle:ZJButtonImageStyleRight imageTitleToSpace:5];
    self.timeButton.layer.cornerRadius = 11;
    self.timeButton.clipsToBounds = YES;
}

- (void)setModel:(TotalSocreModel *)model{
    _model = model;
    self.nameLabel.text = model.employeeName;
    self.sorceLabel.text = [NSString stringWithFormat:@"总分：%@",model.totalScore];
    self.desLabel.text = [NSString stringWithFormat:@"(初始化分为%@)",model.iniScore];
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@考核",model.month] forState:UIControlStateNormal];
}

@end
