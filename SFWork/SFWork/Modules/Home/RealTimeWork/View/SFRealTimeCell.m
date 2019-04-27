//
//  SFRealTimeCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFRealTimeCell.h"

@interface SFRealTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation SFRealTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RealTimeListModel *)model{
    _model = model;
    
    self.nameLabel.text = model.name;
    self.addressLabel.text = model.address;
    self.timeLabel.attributedText = [NSMutableAttributedString setupAttributeString:[NSString stringWithFormat:@"%@ (%@钟之前)",model.time,model.minute] rangeText:[NSString stringWithFormat:@"(%@钟之前)",model.minute] textFont:[UIFont fontWithName:kRegFont size:10] textColor:Color(@"#FF715A")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
