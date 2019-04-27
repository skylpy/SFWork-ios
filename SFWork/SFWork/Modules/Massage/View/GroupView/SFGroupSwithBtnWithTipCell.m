//
//  SFGroupSwithBtnWithTipCell.m
//  ClassForEvery
//
//  Created by Adam on 2019/4/2.
//  Copyright © 2019年 Adam. All rights reserved.
//

#import "SFGroupSwithBtnWithTipCell.h"

@implementation SFGroupSwithBtnWithTipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)swithBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.swithBlock) {
        self.swithBlock(sender.selected);
    }
}
@end
