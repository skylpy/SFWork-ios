//
//  SFMyAttendanceViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMyAttendanceViewController.h"
#import "SFMyAttendanceHttpModel.h"
#import "SFAttenBottomView.h"
@interface SFMyAttendanceViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutWidth;
@property (nonatomic, strong) SFAttenBottomView *bottomView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) MyAttendanceModel *attModel;

@end

@implementation SFMyAttendanceViewController


- (void)updateViewConstraints{
    
    [super updateViewConstraints];
    self.viewLayoutWidth.constant = kWidth*3;
}

- (SFAttenBottomView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [SFAttenBottomView shareSFAttenBottomView];
    }
    return _bottomView;
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"打卡记录" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            UIViewController * vc = [[UIStoryboard storyboardWithName:@"MyAttendance" bundle:nil] instantiateViewControllerWithIdentifier:@"SFPunchCardRecord"];
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _rightButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的考勤";
    
    [self setDrawUI];
    [self getAttendanceRules];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"puckUpCarkSuccess" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        
        [self getAttendanceRules];
    }];
}

- (void)getAttendanceRules{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    [SFMyAttendanceHttpModel getAttendanceRulesSuccess:^(MyAttendanceModel * _Nonnull model) {
        
        [MBProgressHUD hideHUD];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AttendanceRules" object:model];
        self.attModel = model;
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:error.userInfo[@""]];
    }];
}

- (void)setDrawUI {
    
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
    
    @weakify(self)
    [self.bottomView setSelectTag:^(NSInteger tag) {
        @strongify(self)
        if (tag == 1) {
            
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
        }
        if (tag == 2) {
            [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
        }
        if (tag == 3) {
            [self.scrollView setContentOffset:CGPointMake(kWidth*2, 0)];
        }
    }];
}


@end
