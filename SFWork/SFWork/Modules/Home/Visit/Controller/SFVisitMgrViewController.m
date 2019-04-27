//
//  SFVisitMgrViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/14.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitMgrViewController.h"
#import "SFVisitStatisticsViewController.h"
#import "SFVisitListViewController.h"
#import "SFVisitBottomView.h"

@interface SFVisitMgrViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *visitmgrLayoutWidth;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) SFVisitBottomView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger index;

@end

@implementation SFVisitMgrViewController

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.visitmgrLayoutWidth.constant = kWidth * 2;
}

- (SFVisitBottomView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [SFVisitBottomView shareVisitBottomView];
        @weakify(self)
        [_bottomView setSelectTag:^(NSInteger tag) {
            @strongify(self)
            if (tag == 0) {
                self.index = 0;
                SFVisitStatisticsViewController * vc = self.childViewControllers[0];
                vc.type = self.type;
                [self.rightButton setTitle:@"查看员工" forState:UIControlStateNormal];
                [self.scrollView setContentOffset:CGPointMake(0, 0)];
            }
            if (tag == 1) {
                self.index = 1;
                SFVisitListViewController * vc = self.childViewControllers[1];
                vc.type = self.type;
                [self.rightButton setTitle:@"详细搜索" forState:UIControlStateNormal];
                [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
            }
        }];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"拜访管理";
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.index = 0;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
    
    SFVisitStatisticsViewController * vc = self.childViewControllers[0];
    vc.type = self.type;
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"查看员工" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            if (self.index == 0) {
                UIViewController * vc = [NSClassFromString(@"SFSelectPersonViewController") new];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                UIViewController * vc = [NSClassFromString(@"SFVisitSeachViewController") new];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }];
    }
    return _rightButton;
}

@end
