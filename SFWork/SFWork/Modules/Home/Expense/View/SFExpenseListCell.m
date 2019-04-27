//
//  SFExpenseListCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFExpenseListCell.h"

@interface SFExpenseListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateilLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation SFExpenseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(ExpenseListModel *)model{
    _model = model;
    
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.reimbursePersonAvatar] placeholder:DefaultImage];
    self.nameLabel.text = [NSString stringWithFormat:@"%@提交的费用报销",model.reimbursePersonName];
    self.timeLabel.text = model.createTime;
    self.stateLabel.text = [model.approveStatus isEqualToString:@"UNAPPROVED"]?
    @"未审批":[model.approveStatus isEqualToString:@"APPROVING"]?
    @"待审批":[model.approveStatus isEqualToString:@"REJECTED"]?
    @"已驳回":@"已审批";
    self.moneyLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"报销的金额：%@元",self.model.reimbursementItemDTO.amount] rangeText:[NSString stringWithFormat:@"%@元",self.model.reimbursementItemDTO.amount] textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#5E6167")];
    self.cateLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"报销的类别：%@",self.model.reimbursementItemDTO.category] rangeText:[NSString stringWithFormat:@"%@",self.model.reimbursementItemDTO.category] textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#5E6167")];
    self.dateilLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"费用明细：%@",self.model.reimbursementItemDTO.detail] rangeText:[NSString stringWithFormat:@"%@",self.model.reimbursementItemDTO.detail] textFont:[UIFont fontWithName:kRegFont size:14] textColor:Color(@"#5E6167")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
