//
//  SFVisitStatisticsViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/14.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitStatisticsViewController.h"
#import "SFStatisticsHeaderView.h"
#import "SFStatisticesView.h"
#import "SFVisitCompanyController.h"
#import "SFDepartViewController.h"
#import "SFStaffViewController.h"

@interface SFVisitStatisticsViewController ()

@property (nonatomic, strong) SFStatisticsHeaderView *headerView;
@property (nonatomic, strong) SFStatisticesView *statisticesView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutWidth;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewLayoutTop;

@end

@implementation SFVisitStatisticsViewController

- (void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.viewLayoutWidth.constant = kWidth*3;
}

- (SFStatisticsHeaderView *)headerView {
    
    if (!_headerView) {
        if (isSuper) {
            _headerView = [SFStatisticsHeaderView shareSuperAdminHeaderView];
        }
        
        if (isEmployee) {
            _headerView = [SFStatisticsHeaderView shareEmpHeaderView];
        }
        @weakify(self)
        [_headerView setSelectTap:^(NSInteger index) {
            @strongify(self)
            
            if (index == 0) {
                SFVisitCompanyController * vc = self.childViewControllers[0];
                vc.type = self.type;
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:@"WEEK" forKey:@"clientVisitingTimeCycle"];
                [dict setValue:self.type forKey:@"clientVisitingType"];
                [vc requestData:dict];
                
                [self.scrollView setContentOffset:CGPointMake(0, 0)];
            }
            if (index == 1) {
                SFDepartViewController * vc = self.childViewControllers[1];
                vc.type = self.type;
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:@"WEEK" forKey:@"clientVisitingTimeCycle"];
                [dict setValue:self.type forKey:@"clientVisitingType"];
                [vc requestData:dict];
                [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
            }
            if (index == 2) {
                
                SFStaffViewController * vc = self.childViewControllers[2];
                vc.type = self.type;
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:@"WEEK" forKey:@"clientVisitingTimeCycle"];
                [dict setValue:self.type forKey:@"clientVisitingType"];
                [vc requestData:dict];
                [self.scrollView setContentOffset:CGPointMake(kWidth*2, 0)];
            }
        }];
    }
    return _headerView;
}


- (SFStatisticesView *)statisticesView {
    
    if (!_statisticesView) {
        _statisticesView = [SFStatisticesView sharedevAdminHeaderView];
        @weakify(self)
        [_statisticesView setSelectTap:^(NSInteger index) {
            @strongify(self)
            
            NSLog(@"%ld",index);
            if (index == 1) {
                SFDepartViewController * vc = self.childViewControllers[1];
                vc.type = self.type;
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:[SFInstance shareInstance].userInfo.departmentId forKey:@"departmentId"];
                [dict setValue:self.type forKey:@"clientVisitingType"];
                [vc requestData:dict];
                [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
            }
            if (index == 2) {
                SFStaffViewController * vc = self.childViewControllers[2];
                vc.type = self.type;
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:@"WEEK" forKey:@"clientVisitingTimeCycle"];
                [dict setValue:self.type forKey:@"clientVisitingType"];
                [vc requestData:dict];
                [self.scrollView setContentOffset:CGPointMake(kWidth*2, 0)];
            }
            
        }];
    }
    return _statisticesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    if (isDeMgr) {
        
        [self.selectView addSubview:self.statisticesView];
        [self.statisticesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.selectView);
        }];
        
    }else{
        if (isSuper) {
            [self.selectView addSubview:self.headerView];
            [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.selectView);
            }];
        }
        
    }
}

- (void)setType:(NSString *)type{
    _type = type;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (isSuper) {
        SFVisitCompanyController * vc = self.childViewControllers[0];
        vc.type = self.type;
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:@"WEEK" forKey:@"clientVisitingTimeCycle"];
        [dict setValue:self.type forKey:@"clientVisitingType"];
        [vc requestData:dict];
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    if (isDeMgr) {
        
        SFDepartViewController * vc = self.childViewControllers[1];
        vc.type = self.type;
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:@"WEEK" forKey:@"clientVisitingTimeCycle"];
        [dict setValue:self.type forKey:@"clientVisitingType"];
        [dict setValue:[SFInstance shareInstance].userInfo.departmentId forKey:@"departmentId"];
        [vc requestData:dict];
        [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
    }
    if (isEmployee) {
        SFStaffViewController * vc = self.childViewControllers[2];
        vc.type = self.type;
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:@"WEEK" forKey:@"clientVisitingTimeCycle"];
        [dict setValue:self.type forKey:@"clientVisitingType"];
        [dict setValue:[SFInstance shareInstance].userInfo._id forKey:@"employeeId"];
        [vc requestData:dict];
        self.scrollViewLayoutTop.constant = -45;
        [self.scrollView setContentOffset:CGPointMake(kWidth*2, 0)];
    }
}

@end
