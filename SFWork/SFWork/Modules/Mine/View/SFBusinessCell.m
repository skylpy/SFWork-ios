//
//  SFBusinessCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBusinessCell.h"

@interface SFBusinessCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation SFBusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CompanyLifeModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"使用名额：%@ 个",model.quota];
    self.desLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"剩余 %@ 天",model.surplusDays] rangeText:model.surplusDays
                                                                          textFont:[UIFont fontWithName:kRegFont size:12] textColor:Color(@"#FF715A")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
