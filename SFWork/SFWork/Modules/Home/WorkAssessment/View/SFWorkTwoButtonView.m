
//
//  SFWorkTwoButtonView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFWorkTwoButtonView.h"

@interface SFWorkTwoButtonView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (nonatomic, copy) void (^actionBlock)(void);


@property (weak, nonatomic) IBOutlet UIButton *knowButton;

@end

@implementation SFWorkTwoButtonView

+ (instancetype)shareSFWorkTwoButtonView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFWorkTwoButtonView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.popView.layer.cornerRadius = 10;
    self.popView.clipsToBounds = YES;
    
    @weakify(self)
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self cancelClick];
    }];
    
    [[self.knowButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self hideView];
    }];
}

- (void)cancelClick{
    
    !self.actionBlock?:self.actionBlock();
    [self hideView];
}

- (void)hideView{
    
    [self removeFromSuperview];
}

- (void)showFromView:(UIView *)superView withModel:(ScoreListModel *)model actionBlock:(void (^)(void))actionBlock {
    self.frame = superView.bounds;
    [superView addSubview:self];
    self.actionBlock = actionBlock;
    self.nameLabel.text = [NSString stringWithFormat:@"员工：%@",model.employeeName];
    self.timeLabel.text = [NSString stringWithFormat:@"时间：%@",model.updateDate];
    self.projectLabel.text = [NSString stringWithFormat:@"项目：%@",model.itemName];
    self.scoreLabel.text = [NSString stringWithFormat:@"分数：%@",model.note];
    self.detailLabel.text = [NSString stringWithFormat:@"详情：%@ ",model.bizDate];
}

@end
