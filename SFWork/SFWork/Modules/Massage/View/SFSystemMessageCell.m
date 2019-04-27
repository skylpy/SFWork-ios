//
//  SFSystemMessageCell.m
//  SFWork
//
//  Created by fox on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSystemMessageCell.h"

@interface SFSystemMessageCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *redRoundView;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@end

@implementation SFSystemMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _redRoundView.layer.cornerRadius = _redRoundView.width/2;
    _redRoundView.clipsToBounds = YES;
}

- (void)setModel:(SystemMessageModel *)model{
    _model = model;
    self.timeLB.text = model.createTime;
    self.titleLB.text = model.title;
    self.contentLB.text = model.content;
    
    if ([model.status isEqualToString:@"READ"]) {
        _redRoundView.hidden = YES;
    }else{
        _redRoundView.hidden= NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
