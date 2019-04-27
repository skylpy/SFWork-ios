//
//  SFExpenseMgrViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFExpenseMgrViewController.h"
#import "SFAddExpenseViewController.h"
#import "ExpenseBottomView.h"

@interface SFExpenseMgrViewController ()

@property (nonatomic, strong) ExpenseBottomView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *addExpenseButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidth;

@end

@implementation SFExpenseMgrViewController

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.layoutWidth.constant = kWidth*3;
}

- (ExpenseBottomView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [ExpenseBottomView shareExpenseBottomView];
        
        @weakify(self)
        [_bottomView setSelectTag:^(NSInteger tag) {
            @strongify(self)
            switch (tag) {
                case 1:
                    [self.scrollView setContentOffset:CGPointMake(0, 0)];
                    break;
                case 2:
                    [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
                    break;
                case 3:
                    [self.scrollView setContentOffset:CGPointMake(kWidth*2, 0)];
                    break;
                default:
                    break;
            }
        }];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"审批列表";
    
    [self setDrawUI];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
    
    [self.view addSubview:self.addExpenseButton];
    [self.addExpenseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(55);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-52);
    }];
    
    @weakify(self)
    [[self.addExpenseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        SFAddExpenseViewController * vc = [SFAddExpenseViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (UIButton *)addExpenseButton{
    
    if (!_addExpenseButton) {
        
        _addExpenseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addExpenseButton setImage:[UIImage imageNamed:@"btn_oval_add_green"] forState:UIControlStateNormal];
    }
    return _addExpenseButton;
}

@end
