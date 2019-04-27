//
//  SFAllPowerCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAllPowerCell.h"

@interface SFAllPowerCell ()

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation SFAllPowerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)chaneValue:(UISwitch *)sender {
    
    self.model.isClick = sender.on;
    !self.selectAllClick?:self.selectAllClick(sender.on);
}

- (void)setModel:(SFAttendanceSetModel *)model{
    _model = model;
    self.titlelabel.text = model.title;
    self.titlelabel.font = [UIFont fontWithName:kRegFont size:14];
    self.titlelabel.textColor = Color(@"#666666");
    self.switchButton.on = model.isClick;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
