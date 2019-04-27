//
//  SFNoticeListCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFNoticeListCell.h"

@interface SFNoticeListCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation SFNoticeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFAnnounceListModel *)model{
    _model = model;
    
    self.timeLabel.text = model.createTime;
    self.titleLabel.text = model.title;
    self.contentLabel.text = [NSString stringWithFormat:@"公告内容：%@",model.content];
    self.nameLabel.text =[NSString stringWithFormat:@"发布人：%@", model.createName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
