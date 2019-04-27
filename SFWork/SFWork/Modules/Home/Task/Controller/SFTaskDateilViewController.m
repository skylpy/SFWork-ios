//
//  SFTaskDateilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTaskDateilViewController.h"
#import "SFTaskHttpModel.h"

@interface SFTaskDateilViewController ()
@property (weak, nonatomic) IBOutlet UIButton *taskDateilButton;
@property (weak, nonatomic) IBOutlet UIButton *taskSummaryButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taskLineLayoutX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taskLayoutW;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SFTaskDateilViewController

- (void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.taskLayoutW.constant = kWidth*2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"任务详情";
    [self drawUI];
    [self requestData];
}

- (void)requestData{
    
    [SFTaskHttpModel getMyTaskManager:self.taskId success:^(TaskListModel * _Nonnull model) {
        
        TaskListModel * tmodel = [TaskListModel shareManager];
        tmodel = model;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskDataNot" object:model];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)drawUI{
    
    @weakify(self)
    [[self.taskDateilButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.taskLineLayoutX.constant = 0;
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        [self selectItem:x];
    }];
    
    [[self.taskSummaryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.taskLineLayoutX.constant = kWidth/2;
        [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
        [self selectItem:x];
    }];
}

-(void)selectItem:(UIButton *)sender{
    
    for (int i = 1000; i < 1002; i ++) {
        UIButton * button = [self.topView viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
}

@end
