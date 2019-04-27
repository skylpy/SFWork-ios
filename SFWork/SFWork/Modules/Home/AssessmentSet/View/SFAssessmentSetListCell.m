//
//  SFAssessmentSetListCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAssessmentSetListCell.h"

@interface SFAssessmentSetListCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serLabel;

@end

@implementation SFAssessmentSetListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFWorkAssessItemModel *)model{
    _model = model;
    self.titleLabel.text = model.name;
}

- (void)setSmodel:(ItemSubListModel *)smodel{
    _smodel = smodel;
    self.titleLabel.text = smodel.name;
    self.serLabel.text = [smodel.period isEqualToString:@"DAY"]?
    @"每天":[smodel.period isEqualToString:@"WEEK"]?
    @"每周":@"每月";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
