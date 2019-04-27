//
//  SFPunchClockTimeCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPunchClockTimeCell.h"

@interface SFPunchClockTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SFPunchClockTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSmodel:(SpecialDateModel *)smodel{
    _smodel = smodel;
    NSString * title = @"日期 ";
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",title,smodel.specialDate];
    if ([smodel.specialDateType isEqualToString:@"CHECKIN"]) {
        NSString * time = @"时段 ";
        for (int i = 0; i < smodel.attendanceTimeDTOList.count; i ++) {
            AttendanceTimeModel * mod = smodel.attendanceTimeDTOList[i];
            
            time = [NSString stringWithFormat:@"%@ %@ %@ ",time,mod.startTime,mod.endTime];
        }
        self.timeLabel.text = time;
    }else{
        NSString * time = @"事由：";
        self.timeLabel.text = [NSString stringWithFormat:@"%@%@",time,smodel.reason];
    }
   
}

- (void)setModel:(AttendanceDateModel *)model{
    _model = model;
    
    NSString * title = @"工作日 ";
    for (int i = 0; i < model.days.count; i ++) {
        NSString * day = model.days[i];
        switch ([day integerValue]) {
            case 1:
                title = [NSString stringWithFormat:@"%@ 星期一",title];
                break;
            case 2:
                title = [NSString stringWithFormat:@"%@ 星期二",title];
                break;
            case 3:
                title = [NSString stringWithFormat:@"%@ 星期三",title];
                break;
            case 4:
                title = [NSString stringWithFormat:@"%@ 星期四",title];
                break;
            case 5:
                title = [NSString stringWithFormat:@"%@ 星期五",title];
                break;
            case 6:
                title = [NSString stringWithFormat:@"%@ 星期六",title];
                break;
            case 7:
                title = [NSString stringWithFormat:@"%@ 星期日",title];
                break;
            
            default:
                break;
        }
    }
    self.titleLabel.text = title;
    
    NSString * time = @"时段 ";
    for (int i = 0; i < model.attendanceTimeDTOList.count; i ++) {
        AttendanceTimeModel * mod = model.attendanceTimeDTOList[i];
        
        time = [NSString stringWithFormat:@"%@ %@ %@ ",time,mod.startTime,mod.endTime];
    }
    self.timeLabel.text = time;
}

- (void)setAmodel:(SFAddressModel *)amodel{
    _amodel = amodel;
    self.titleLabel.text = amodel.address;
    self.timeLabel.text = amodel.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
