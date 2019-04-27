//
//  SFCustomerMgrViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFCustomerMgrViewController.h"
#import "SFCtoMgrBottomView.h"
@interface SFCustomerMgrViewController ()<SFCtoMgrBottomViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customerLayoutWidth;
@property (nonatomic, strong) SFCtoMgrBottomView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation SFCustomerMgrViewController

- (SFCtoMgrBottomView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [SFCtoMgrBottomView shareBottomView];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.customerLayoutWidth.constant = kWidth * 3;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客户管理";
    [self drawUI];
}

- (void)drawUI {
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.offset(50);
    }];
}

- (void)selectClick:(CtoButtonType)type{
    
    switch (type) {
        case comType:
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
            break;
        case busType:
            [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
            break;
        case priType:
            [self.scrollView setContentOffset:CGPointMake(2*kWidth, 0)];
            break;
        default:
            break;
    }
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"详细搜索" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            UIViewController * vc = [NSClassFromString(@"SFSearchMgrViewController") new];
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _rightButton;
}



@end
