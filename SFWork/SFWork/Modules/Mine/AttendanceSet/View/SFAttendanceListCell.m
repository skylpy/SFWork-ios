//
//  SFAttendanceListCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttendanceListCell.h"



@interface SFAttendanceListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;

@end

@implementation SFAttendanceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.cornerRadius = 3;
    self.bgView.clipsToBounds = YES;
}

- (void)setModel:(SFAttendanceModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"考勤组：%@",model.name];
    AttendanceDateModel * attmodel = model.attendanceDateDTOList[0];
    NSString * title = @"工作日：";
    for (NSString * day in attmodel.days) {
        NSInteger index = [day integerValue];
        switch (index) {
            case 1:
                title = [NSString stringWithFormat:@"%@ 一",title];
                break;
            case 2:
                title = [NSString stringWithFormat:@"%@ 二",title];
                break;
            case 3:
                title = [NSString stringWithFormat:@"%@ 三",title];
                break;
            case 4:
                title = [NSString stringWithFormat:@"%@ 四",title];
                break;
            case 5:
                title = [NSString stringWithFormat:@"%@ 五",title];
                break;
            case 6:
                title = [NSString stringWithFormat:@"%@ 六",title];
                break;
            case 7:
                title = [NSString stringWithFormat:@"%@ 日",title];
                break;
            default:
                break;
        }
    }
    self.dayLabel.text = title;
    
    SFAddressModel * addmodel = model.addressDTOList[0];
    self.addressLabel.text = [NSString stringWithFormat:@"考勤位置：%@",addmodel.address];
    
    NSString * time = @"考勤时间：";
    for (AttendanceTimeModel * mod in attmodel.attendanceTimeDTOList) {
        
        time = [NSString stringWithFormat:@"%@ %@ %@ ",time,mod.startTime,mod.endTime];
    }
    self.timeLabel.text = time;
    
    NSString * person = @"考勤人员：";
    for (AttendancePersonnelModel * p in model.attendancePersonnelDTOList) {
        person = [NSString stringWithFormat:@"%@ %@ ",person,p.targetName];
    }
    self.personLabel.text = person;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
