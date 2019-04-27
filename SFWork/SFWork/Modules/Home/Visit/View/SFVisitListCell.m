//
//  SFVisitListCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitListCell.h"

@interface SFVisitListCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *deslabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *gocomButton;


@end

@implementation SFVisitListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.gocomButton.layer.cornerRadius = 10;
    self.gocomButton.clipsToBounds = YES;
}

- (void)setModel:(SFVisitListModel *)model{
    _model = model;
    
    self.timeLabel.text = [NSString stringWithFormat:@"截止：%@",model.deadline];
    self.titleLabel.text = [NSString stringWithFormat:@"拜访%@-%@",model.typeName,[model.clientVisitingType isEqualToString:@"TEL"]?@"电话":@"走访"];
    self.deslabel.text = [NSString stringWithFormat:@"%@创建于%@",model.assignerName,model.createTime];
    self.contentLabel.text = [NSString stringWithFormat:@"拜访内容:%@",model.content];
    
    self.personLabel.text = [NSString stringWithFormat:@"拜访人：    拜访：%@",[model.clientGroup isEqualToString:@"CLIENT"]?@"客户":@"商家"];
    
    self.statueLabel.text = [model.clientVisitingStatus isEqualToString:@"CREATED"]?
    @"未完成":[model.clientVisitingStatus isEqualToString:@"VISITED"]?@"已完成":@"已取消";
    self.statueLabel.textColor = [model.clientVisitingStatus isEqualToString:@"CREATED"]?Color(@"#FF715A"):[model.clientVisitingStatus isEqualToString:@"CREATED"]?defaultColor:Color(@"#999999");
    
    self.gocomButton.hidden = [model.clientVisitingStatus isEqualToString:@"CREATED"]?NO:YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
