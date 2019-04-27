//
//  SFAttendancePopView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/24.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttendancePopView.h"

@interface SFAttendancePopView ()

@property (nonatomic, copy) void (^actionBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *popView;

@end

@implementation SFAttendancePopView

+ (instancetype)shareSFAttendancePopView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFAttendancePopView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.popView.layer.cornerRadius = 5;
    self.popView.clipsToBounds = YES;
    
    @weakify(self)
    [[self.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self hideView];
    }];
}

- (void)hideView{
    
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)superView
         withModel:(MyAttendanceGetRecord *)model
       actionBlock:(void (^)(void))actionBlock{
    
    self.actionBlock = actionBlock;
    
    
    self.frame = superView.bounds;
    
    
    [superView addSubview:self];
   
    
    if ([model.attendanceStatus isEqualToString:@"NORMAL"]) {
        
        NSString * title = [model.attendances isEqualToString:@"GOTOWORK"]?@"上班·正常":@"下班·正常";
        self.titleLabel.text = title;
    }else if ([model.attendanceStatus isEqualToString:@"LATE"]){
        
        NSString * title = [model.attendances isEqualToString:@"GOTOWORK"]?@"上班·迟到":@"下班·迟到";
        self.titleLabel.text = title;
    }else if ([model.attendanceStatus isEqualToString:@"MISSING"]){
        
        NSString * title = [model.attendances isEqualToString:@"GOTOWORK"]?@"上班·漏卡":@"下班·漏卡";
        self.titleLabel.text = title;
    }else if ([model.attendanceStatus isEqualToString:@"ABSENTEEISM"]){
        
        NSString * title = [model.attendances isEqualToString:@"GOTOWORK"]?@"上班·矿工":@"下班·矿工";
        self.titleLabel.text = title;
    }else if ([model.attendanceStatus isEqualToString:@"EARLY"]){
        
        NSString * title = [model.attendances isEqualToString:@"GOTOWORK"]?@"上班·早退":@"下班·早退";
        self.titleLabel.text = title;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"打卡时间：%@",model.checkInDate];
    self.addressLabel.text = [NSString stringWithFormat:@"打卡范围：%@",[model.positioningType isEqualToString:@"OUTRAGE"]?@"不在范围":[model.positioningType isEqualToString:@"UNKNOWN"]?@"无法定位":@"正常范围"];
    self.timesLabel.text = [NSString stringWithFormat:@"%@点后再打卡",model.timeNumber];
}

@end
