//
//  SFChangeGroupNameViewController.m
//  SFWork
//
//  Created by fox on 2019/4/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFChangeGroupNameViewController.h"

@interface SFChangeGroupNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (strong, nonatomic) UIButton * rightIconBtn;

@end

@implementation SFChangeGroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"修改群名称";
   
    [self initUI];
}

- (void)initUI{
    _nameTF.text = _groupName;
    [_nameTF becomeFirstResponder];
    _nameTF.delegate = self;
    
    UIButton * leftIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftIconBtn.frame = CGRectMake(0, 0, 60, 44);
    leftIconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftIconBtn setTitle:@"取消" forState:0];
    leftIconBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftIconBtn setTitleColor:[UIColor blackColor] forState:0];
    [leftIconBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftIconBtn];
    
    UIButton * rightIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightIconBtn.frame = CGRectMake(0, 0, 55, 30);
    [rightIconBtn setBackgroundColor:[UIColor colorWithRed:16/255.0 green:188/255.0 blue:74/255.0 alpha:1]];
    [rightIconBtn setTitle:@"完成" forState:0];
    rightIconBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightIconBtn setTitleColor:[UIColor whiteColor] forState:0];
    rightIconBtn.layer.cornerRadius = 3;
    rightIconBtn.clipsToBounds = YES;
    [rightIconBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightIconBtn = rightIconBtn;
    _rightIconBtn.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightIconBtn];
}

- (void)leftBtnAction:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBtnAction:(UIButton*)sender{
    [SFBaseModel BPOST:BASE_URL(@"/message/chat/group/rename") parameters:@{@"id":_groupID,@"name":_nameTF.text} success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD showSuccessMessage:@"设置成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD showSuccessMessage:@"设置失败"];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    _rightIconBtn.enabled = YES;

    return YES;
}

@end
