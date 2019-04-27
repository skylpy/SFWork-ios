//
//  SFTrackWorkCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTrackWorkCell.h"

@interface SFTrackWorkCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation SFTrackWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(SFTrackWorksModel *)model{
    _model = model;
    
    self.iconImage.image = [UIImage imageNamed:model.icon];
    self.titleName.text = model.title;
    self.desLabel.text = model.destitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
