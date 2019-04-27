//
//  SFBTaskListCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBTaskListCell.h"


@interface SFBTaskListCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation SFBTaskListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILongPressGestureRecognizer * longGap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    [self addGestureRecognizer:longGap];
}

- (void)longPressClick:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){

        NSLog(@"长按了")
        !self.gestureClick?:self.gestureClick(self.model);
    }
}

- (void)setModel:(TaskListModel *)model{
    _model = model;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@.%@",model.taskNumber,model.taskTypeName];
    self.timeLabel.text = [NSString stringWithFormat:@"截止:%@",model.endTime];
    self.contentLabel.text = [NSString stringWithFormat:@"任务内容:%@",model.content];
    self.lineView.backgroundColor = [model.level isEqualToString:@"HIGHEST"]? Color(@"#FF715A"):[model.level isEqualToString:@"URGENT"]?Color(@"#FF9800"):Color(@"#FFFFFF");
    self.statueLabel.text = [model.auditStatus isEqualToString:@"NOPASS"]?@"已驳回":[model.auditStatus isEqualToString:@"PASS"]?@"已审批":[model.taskStatus isEqualToString:@"PROCEED"]?@"进行中":[model.taskStatus isEqualToString:@"UNPROVED"]?@"待进行":[model.taskStatus isEqualToString:@"ACCOMPLISH"]?@"完成":@"未完成";
    
    self.personLabel.text = [NSString stringWithFormat:@"办理人：%@",model.executorName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
