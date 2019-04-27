//
//  SFMassageCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMassageCell.h"

@interface SFMassageCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *unReadCountLB;

@end

@implementation SFMassageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.unReadCountLB.layer.cornerRadius = 17/2;
    self.unReadCountLB.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSystemMsgModel:(SystemMessageModel *)systemMsgModel{
//    self.titleLB.text = systemMsgModel.title;
    self.contentLB.text = systemMsgModel.content;
    self.timeLB.text = systemMsgModel.createTime;
    self.unReadCountLB.text = systemMsgModel.count;
    self.unReadCountLB.hidden = NO;
    if (systemMsgModel.count.integerValue == 0) {
        self.unReadCountLB.hidden = YES;
    }
}

@end
