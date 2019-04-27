//
//  SFStatisticsPersonCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFStatisticsPersonCell.h"

@interface SFStatisticsPersonCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *depLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;

@end

@implementation SFStatisticsPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(AttendanceStatisticsModel *)model{
    _model = model;
    
    [self.avatarImage setImageWithURL:[NSURL URLWithString:model.smallAvatar] placeholder:DefaultImage];
    self.nameLabel.text = model.name;
    self.depLabel.text = model.departmentName;
    self.statueLabel.text = [model.attendanceStatus isEqualToString:@"LATE"]?@"迟到":[model.attendanceStatus isEqualToString:@"MISSING"]?@"漏卡":[model.attendanceStatus isEqualToString:@"ABSENTEEISM"]?@"旷工":@"早退";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
