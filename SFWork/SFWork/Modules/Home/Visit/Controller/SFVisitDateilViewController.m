//
//  SFVisitDateilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitDateilViewController.h"
#import "SFVisitDellViewController.h"
#import "SFVisitResultViewController.h"
#import "SFVisitHttpModel.h"

@interface SFVisitDateilViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *dateilButton;
@property (weak, nonatomic) IBOutlet UIButton *resultButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLayoutX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutWidth;


@end

@implementation SFVisitDateilViewController

- (void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.viewLayoutWidth.constant = kWidth*2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拜访详情";
    
    [self setDrawUI];
    
    [self requestDateil];
}

//我拜访的
- (void)requestDateil{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.visitId forKey:@"id"];
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFVisitHttpModel clientVisitList:dict success:^(NSArray<SFVisitListModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        SFVisitListModel * model = list[0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitDataNot" object:model];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    SFVisitDellViewController * vc = self.childViewControllers[0];
    vc.type = self.type;
    
    @weakify(self)
    [[self.dateilButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.lineViewLayoutX.constant = 0;
        SFVisitDellViewController * vc = self.childViewControllers[0];
        vc.type = self.type;
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        [self selectItem:x];
    }];
    
    [[self.resultButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.lineViewLayoutX.constant = kWidth/2;
        SFVisitResultViewController * vc = self.childViewControllers[1];
        vc.type = self.type;
        [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
        [self selectItem:x];
    }];
}

-(void)selectItem:(UIButton *)sender{
    
    for (int i = 1000; i < 1002; i ++) {
        UIButton * button = [self.selectView viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
    
}


@end
