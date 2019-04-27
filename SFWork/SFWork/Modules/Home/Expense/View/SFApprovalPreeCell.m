//
//  SFApprovalPreeCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFApprovalPreeCell.h"

@interface SFApprovalPreeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *jobLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation SFApprovalPreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImage.layer.cornerRadius = 24;
    self.iconImage.clipsToBounds = YES;
//    self.backgroundColor = [UIColor redColor];
}

- (void)setModel:(ExpenseProcessModel *)model{
    _model = model;
    
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.approverAvatar] placeholder:DefaultImage];
    self.nameLabel.text = model.approverName;
    self.jobLabel.text = [model.approveType isEqualToString:@"CASH"]?
    @"出纳人":[model.approveType isEqualToString:@"APPROVE"]?
    @"审批人":@"审核人";
    self.stateLabel.text = [model.approveStatus isEqualToString:@"UNAPPROVED"]?
    @"未审批":[model.approveStatus isEqualToString:@"APPROVING"]?
    @"待审批":[model.approveStatus isEqualToString:@"REJECTED"]?
    @"已驳回":@"已审批";
    self.stateLabel.textColor = [model.approveStatus isEqualToString:@"UNAPPROVED"]?
    Color(@"#999999"):[model.approveStatus isEqualToString:@"APPROVING"]?
    Color(@"#FFAB00"):[model.approveStatus isEqualToString:@"REJECTED"]?
    Color(@"#FF715A"):Color(@"#01B38B");
}



@end
