//
//  SFAssessmentListCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAssessmentListCell.h"

@interface SFAssessmentListCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *performStute;
@property (weak, nonatomic) IBOutlet UILabel *performTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *performLabel;
@end

@implementation SFAssessmentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFWorkCheckItemModel *)model{
    _model = model;
    self.titleLabel.text = model.name;
    self.timeLabel.text = [NSString stringWithFormat:@"创建时间：%@",model.createTime];
    self.performLabel.text = [NSString stringWithFormat:@"执行：%ld人",model.rulePersonDTOList.count];
    self.performTimeLabel.text = [NSString stringWithFormat:@"执行时间：%@至%@",model.startDate,model.endDate];
    self.performStute.text = [model.checkRuleStatus isEqualToString:@"UNEXECUTED"]?
    @"未执行":[model.checkRuleStatus isEqualToString:@"EXECUTING"]?
    @"正在执行":@"执行完成";
    self.performStute.textColor = [model.checkRuleStatus isEqualToString:@"UNEXECUTED"]?
    Color(@"#FF715A"):[model.checkRuleStatus isEqualToString:@"EXECUTING"]?
    Color(@"#01B38B"):Color(@"#999999");
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
