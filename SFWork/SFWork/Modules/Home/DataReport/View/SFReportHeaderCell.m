//
//  SFReportHeaderCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFReportHeaderCell.h"

@interface SFReportHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation SFReportHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFTemplateModel *)model{
    _model = model;
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.employeeAvatar] placeholder:DefaultImage];
    self.titleLabel.text = model.name;
    self.timeLabel.text = model.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
