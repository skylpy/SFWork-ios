//
//  SFToDayWorkViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/23.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFToDayWorkViewController.h"

@interface SFToDayWorkViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *arrendanButton;
@property (weak, nonatomic) IBOutlet UIButton *journalButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *taskButton;
@property (weak, nonatomic) IBOutlet UIButton *visitButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SFToDayWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"今日工作";
    
    [self setDrawUI];
}

- (void)setDrawUI {
    
    @weakify(self)
    [[self.arrendanButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self showButtonItem:x];
    }];
    
    [[self.journalButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self showButtonItem:x];
    }];
    
    [[self.reportButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self showButtonItem:x];
    }];
    
    [[self.taskButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self showButtonItem:x];
    }];
    
    [[self.visitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self showButtonItem:x];
    }];
    
}

- (void)showButtonItem:(UIButton *)sender{
    
    for (int i = 1000; i < 1005; i ++) {
        UIButton * button = [self.bottomView viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
}


@end
