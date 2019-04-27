//
//  SFWorkOneButtonView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFWorkOneButtonView.h"

@interface SFWorkOneButtonView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *prejectLabel;
@property (weak, nonatomic) IBOutlet UILabel *sorceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateilLabel;

@property (weak, nonatomic) IBOutlet UIButton *knowButton;

@property (nonatomic, copy) void (^actionBlock)(void);


@end

@implementation SFWorkOneButtonView

+ (instancetype)shareSFWorkOneButtonView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFWorkOneButtonView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    @weakify(self)
    [[self.knowButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self hideView];
    }];
}

- (void)hideView{
    
    [self removeFromSuperview];
}

- (void)showFromView:(UIView *)superView withModel:(ScoreListModel *)model actionBlock:(void (^)(void))actionBlock  {
    self.frame = superView.bounds;
    [superView addSubview:self];
    self.actionBlock = actionBlock;
    self.nameLabel.text = [NSString stringWithFormat:@"员工：%@",model.employeeName];
    self.timeLable.text = [NSString stringWithFormat:@"时间：%@",model.updateDate];
    self.prejectLabel.text = [NSString stringWithFormat:@"项目：%@",model.itemName];
    self.sorceLabel.text = [NSString stringWithFormat:@"分数：%@",model.note];
    self.dateilLabel.text = [NSString stringWithFormat:@"详情：%@ ",model.bizDate];
}

@end
