//
//  SFPunchCardRecordCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPunchCardRecordCell.h"

@interface SFPunchCardRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *addreesLabel;

@end

@implementation SFPunchCardRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MyAttendanceGetRecord *)model{
    _model = model;
    
    self.timeLabel.text = model.startTime;
    NSString * urlString = model.photo == nil?@"":model.photo;
    [self.iconImage setImageWithURL:[NSURL URLWithString:[NSString getAliOSSConstrainURL:urlString]] placeholder:DefaultImage];
    self.titleLable.text = model.type;
    
    NSString * contentStr = @"";
    if ([model.attendanceType isEqualToString:@"IN"]) {
        
        if ([model.attendanceStatus isEqualToString:@"NORMAL"]) {
            if ([model.positioningType isEqualToString:@"OUTRAGE"]) {
                
                contentStr = @"不在打卡范围内，正常打卡";
            }
            if ([model.positioningType isEqualToString:@"UNKNOWN"]) {
                contentStr = @"无法定位，正常打卡";
            }
            if ([model.positioningType isEqualToString:@"NORMAL"]) {
                contentStr = @"在打卡范围内，正常打卡";
            }
        }
        if ([model.attendanceStatus isEqualToString:@"LATE"]) {
            
            if ([model.positioningType isEqualToString:@"OUTRAGE"]) {
                contentStr = @"不在打卡范围内，迟到打卡";
            }
            if ([model.positioningType isEqualToString:@"UNKNOWN"]) {
                contentStr = @"无法定位，迟到打卡";
            }
            if ([model.positioningType isEqualToString:@"NORMAL"]) {
                contentStr = @"在打卡范围内，迟到打卡";
            }
        }
        if ([model.attendanceStatus isEqualToString:@"MISSING"]) {
            
            contentStr = @"漏卡";
        }
        if ([model.attendanceStatus isEqualToString:@"ABSENTEEISM"]) {
            if ([model.positioningType isEqualToString:@"OUTRAGE"]) {
                contentStr = @"不在打卡范围内，旷工打卡";
            }
            if ([model.positioningType isEqualToString:@"UNKNOWN"]) {
                contentStr = @"无法定位，旷工打卡";
            }
            if ([model.positioningType isEqualToString:@"NORMAL"]) {
                contentStr = @"在打卡范围内，旷工打卡";
            }
        }
        if ([model.attendanceStatus isEqualToString:@"EARLY"]) {
            if ([model.positioningType isEqualToString:@"OUTRAGE"]) {
                contentStr = @"不在打卡范围内，早退打卡";
            }
            if ([model.positioningType isEqualToString:@"UNKNOWN"]) {
                contentStr = @"无法定位，早退打卡";
            }
            if ([model.positioningType isEqualToString:@"NORMAL"]) {
                contentStr = @"在打卡范围内，早退打卡";
            }
        }
    }else{
        if ([model.attendanceStatus isEqualToString:@"NORMAL"]) {
            if ([model.positioningType isEqualToString:@"OUTRAGE"]) {
                
                contentStr = @"外出不在打卡范围内，正常打卡";
            }
            if ([model.positioningType isEqualToString:@"UNKNOWN"]) {
                contentStr = @"外出无法定位，正常打卡";
            }
            if ([model.positioningType isEqualToString:@"NORMAL"]) {
                contentStr = @"外出在打卡范围内，正常打卡";
            }
        }
        if ([model.attendanceStatus isEqualToString:@"LATE"]) {
            
            if ([model.positioningType isEqualToString:@"OUTRAGE"]) {
                contentStr = @"外出不在打卡范围内，迟到打卡";
            }
            if ([model.positioningType isEqualToString:@"UNKNOWN"]) {
                contentStr = @"外出无法定位，迟到打卡";
            }
            if ([model.positioningType isEqualToString:@"NORMAL"]) {
                contentStr = @"外出在打卡范围内，迟到打卡";
            }
        }
        if ([model.attendanceStatus isEqualToString:@"MISSING"]) {
            
            contentStr = @"外出漏卡";
        }
        if ([model.attendanceStatus isEqualToString:@"ABSENTEEISM"]) {
            if ([model.positioningType isEqualToString:@"OUTRAGE"]) {
                contentStr = @"不在打卡范围内，旷工打卡";
            }
            if ([model.positioningType isEqualToString:@"UNKNOWN"]) {
                contentStr = @"无法定位，旷工打卡";
            }
            if ([model.positioningType isEqualToString:@"NORMAL"]) {
                contentStr = @"在打卡范围内，旷工打卡";
            }
        }
        if ([model.attendanceStatus isEqualToString:@"EARLY"]) {
            if ([model.positioningType isEqualToString:@"OUTRAGE"]) {
                contentStr = @"不在打卡范围内，早退打卡";
            }
            if ([model.positioningType isEqualToString:@"UNKNOWN"]) {
                contentStr = @"无法定位，早退打卡";
            }
            if ([model.positioningType isEqualToString:@"NORMAL"]) {
                contentStr = @"在打卡范围内，早退打卡";
            }
        }
    }
    self.contentLabel.text = contentStr;
    self.addreesLabel.text = model.address;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
