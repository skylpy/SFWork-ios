//
//  SFTrackListCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTrackListCell.h"

@interface SFTrackListCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation SFTrackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TrackModel *)model{
    _model = model;
    self.timeLabel.text = model.time;
    self.addressLabel.text = model.address;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
