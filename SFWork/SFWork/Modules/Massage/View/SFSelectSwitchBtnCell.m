//
//  SFSelectSwitchBtnCell.m
//  SFWork
//
//  Created by fox on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectSwitchBtnCell.h"

@implementation SFSelectSwitchBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)swithBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_topBtnBlock) {
        self.topBtnBlock(sender.selected);
    }
}

@end
