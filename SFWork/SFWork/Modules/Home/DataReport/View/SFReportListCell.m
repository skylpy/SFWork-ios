//
//  SFReportListCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFReportListCell.h"

@interface SFReportListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *statueLabel;

@property (weak, nonatomic) IBOutlet UILabel *oneLabel;

@property (weak, nonatomic) IBOutlet UILabel *twoLabel;

@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@property (weak, nonatomic) IBOutlet UILabel *fourLabel;

@end

@implementation SFReportListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self)
    [[self.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectEmpClick?:self.selectEmpClick(self.model);
    }];
}

- (void)setModel:(SFTemplateModel *)model{
    _model = model;
    [self.avatarImage setImageWithURL:[NSURL URLWithString:model.employeeAvatar] placeholder:DefaultImage];
    self.titleLabel.text = model.name;
    self.timeLabel.text = model.createTime;
    
    self.statueLabel.text = [model.status isEqualToString:@"UNREAD"]?@"未读":[model.status isEqualToString:@"READ"]?@"已读":[model.status isEqualToString:@"REJECT"]?@"驳回":[model.status isEqualToString:@"CONFIRM"]?@"已确认":@"已撤回";
    self.statueLabel.textColor = [model.status isEqualToString:@"UNREAD"]?Color(@"#FF715A"):[model.status isEqualToString:@"READ"]?Color(@"#01B38B"):[model.status isEqualToString:@"REJECT"]?Color(@"#FF715A"):[model.status isEqualToString:@"CONFIRM"]?Color(@"#5E6167"):Color(@"#FF715A");
    self.oneLabel.text = @"";self.twoLabel.text = @"";self.threeLabel.text = @"";self.fourLabel.text = @"";
    for (int i = 0; i < model.items.count; i ++) {
        ItemsModel * item = model.items[i];
        switch (i) {
            case 0:
                self.oneLabel.text = [NSString stringWithFormat:@"%@：%@%@",item.name,item.value,item.unit];
                break;
            case 1:
                self.twoLabel.text = [NSString stringWithFormat:@"%@：%@%@",item.name,item.value,item.unit];
                break;
            case 2:
                self.threeLabel.text = [NSString stringWithFormat:@"%@：%@%@",item.name,item.value,item.unit];
                break;
            case 3:
                self.fourLabel.text = [NSString stringWithFormat:@"%@：%@%@",item.name,item.value,item.unit];
                break;
            default:
                break;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
