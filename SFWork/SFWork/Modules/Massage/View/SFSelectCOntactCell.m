//
//  SFSelectCOntactCell.m
//  SFWork
//
//  Created by fox on 2019/3/31.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectCOntactCell.h"

@interface SFSelectCOntactCell ()

@end

@implementation SFSelectCOntactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ContactsList *)model{
    [self.headView setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:DefaultImage];
    self.nameLB.text = model.name;
}

- (void)setGroupMemberModel:(SFGroupMemberModel *)groupMemberModel{
    [self.headView setImageWithURL:[NSURL URLWithString:groupMemberModel.smallAvatar] placeholder:DefaultImage];
    self.nameLB.text = groupMemberModel.name;
}

- (IBAction)selectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectBlock) {
        self.selectBlock(sender.selected);
    }
}
@end
