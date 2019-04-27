//
//  SFPunchCardDateilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPunchCardDateilViewController.h"
#import "SFAddDataFooterView.h"
#import "SFMyAttendanceHttpModel.h"

@interface SFPunchCardDateilViewController ()

@property (nonatomic, strong) SFAddDataFooterView * footerView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *addreesLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation SFPunchCardDateilViewController

- (SFAddDataFooterView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [SFAddDataFooterView shareSFAddDataFooterView];
        [_footerView.cancelButton setTitle:@"驳回" forState:UIControlStateNormal];
        [_footerView.sureButton setTitle:@"通过" forState:UIControlStateNormal];
        
    }
    return _footerView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.footerView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"打卡记录详情";
    
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    [SFMyAttendanceHttpModel getAttendanceRulesId:self.p_id success:^(MyAttendanceGetRecord * _Nonnull model) {
        
        self.nameLabel.text = model.employeeName;
        self.timeLabel.text = model.checkInDate;
        self.addreesLabel.text = model.address;
        [self.iconImage setImageWithURL:[NSURL URLWithString:[NSString getAliOSSConstrainURL:model.photo]] placeholder:DefaultImage];
        self.desLabel.text = model.remarks;
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
        self.rangeLabel.text = contentStr;
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setDrawUI {
    
    [LSKeyWindow addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(LSKeyWindow);
        make.height.offset(50);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}

@end
