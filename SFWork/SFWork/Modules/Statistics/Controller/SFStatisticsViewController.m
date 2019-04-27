//
//  SFStatisticsViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFStatisticsViewController.h"
#import "SFTemplateSetViewController.h"
#import "SFStatisticsListViewController.h"
#import "SFStatisticsView.h"
#import "SFDepStatisticsView.h"
@interface SFStatisticsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statisticesLayoutWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectLayoutHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (nonatomic, strong) SFStatisticsView *statisticsView;
@property (nonatomic, strong) SFDepStatisticsView *depStatisticsView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) BOOL isBack;
@end

@implementation SFStatisticsViewController

- (SFDepStatisticsView *)depStatisticsView{
    
    if (!_depStatisticsView) {
        
        _depStatisticsView = [SFDepStatisticsView shareSFDepStatisticsView];
        @weakify(self)
        [_depStatisticsView setSelectTap:^(NSInteger index) {
            @strongify(self)
            
            switch (index) {
                
                case 2:
                    [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
                    break;
                case 3:
                    [self.scrollView setContentOffset:CGPointMake(kWidth*2, 0)];
                    break;
                case 4:
                    [self.scrollView setContentOffset:CGPointMake(kWidth*3, 0)];
                    break;
                default:
                    break;
            }
        }];
    }
    return _depStatisticsView;
}

- (SFStatisticsView *)statisticsView{
    
    if (!_statisticsView) {
        
        _statisticsView = [SFStatisticsView shareStatisticsHeaderView];
        @weakify(self)
        [_statisticsView setSelectTap:^(NSInteger index) {
            @strongify(self)
            
            switch (index) {
                case 1:
                    [self.scrollView setContentOffset:CGPointMake(0, 0)];
                    break;
                case 2:
                    [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
                    break;
                case 3:
                    [self.scrollView setContentOffset:CGPointMake(kWidth*2, 0)];
                    break;
                case 4:
                    [self.scrollView setContentOffset:CGPointMake(kWidth*3, 0)];
                    break;
                default:
                    break;
            }
        }];
    }
    return _statisticsView;
}


- (void)updateViewConstraints{
    
    [super updateViewConstraints];
    
    self.statisticesLayoutWidth.constant = kWidth*4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"统计";
    
    if (isSuper) {
        [self.selectView addSubview:self.statisticsView];
        [self.statisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.selectView);
        }];
    }
    if (isDeMgr) {
        [self.selectView addSubview:self.depStatisticsView];
        [self.depStatisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.selectView);
        }];
    }
   
    if (isEmployee) {
        self.rightButton.hidden = YES;
        self.selectLayoutHeight.constant = 0;
    }
    
    self.isBack = YES;
    SFStatisticsListViewController * vc  = self.childViewControllers.lastObject;
    @weakify(self)
    [vc setBackClick:^{
        @strongify(self)
        self.isBack = NO;
    }];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.isBack) return;
    if (isSuper) {
        
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    if (isDeMgr) {
        
        
        [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
    }
    if (isEmployee) {
       
        [self.scrollView setContentOffset:CGPointMake(kWidth*2, 0)];
    }
    
    
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"设置汇报模板" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            SFTemplateSetViewController * vc = [SFTemplateSetViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _rightButton;
}


@end
