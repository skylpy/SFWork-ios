//
//  SFJournalCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFJournalCell.h"

@interface SFJournalCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateilLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;

@end

@implementation SFJournalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFJournalListModel *)model{
    _model = model;
    
    self.nameLabel.text = model.createName;
    self.timeLabel.text = model.createTime;
    self.contentLabel.text = [NSString stringWithFormat:@"日报内容：%@",model.content];
    
    self.statueLabel.text = [model.dailyStatus isEqualToString:@"READ"]?@"已读":[model.dailyStatus isEqualToString:@"UNREAD"]?@"未读":[model.dailyStatus isEqualToString:@"NOPASS"]?@"已驳回":@"已通过";
    
    self.statueLabel.textColor = [model.dailyStatus isEqualToString:@"READ"]?Color(@"#01B38B"):[model.dailyStatus isEqualToString:@"UNREAD"]?Color(@"#FF715A"):[model.dailyStatus isEqualToString:@"NOPASS"]?Color(@"#FFAB00"):Color(@"#01B38B");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
