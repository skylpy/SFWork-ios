//
//  SFLoginViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFLoginViewController.h"
#import "SFRegisterViewController.h"
#import "SFTabBarViewController.h"
#import "SFRegisterModel.h"
#import "SFFilesMgrModel.h"
#import "JPUSHService.h"
#import "SFTrackManager.h"
#import "SelectCompanysView.h"
#import "HttpManager.h"

@interface SFLoginViewController ()<SFRegisterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UILabel *pwdesLabel;
@property (nonatomic, copy) NSString *companyId;

@end

@implementation SFLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bottomView.layer.shadowOpacity = 0.1;
    self.bottomView.layer.shadowOffset = CGSizeMake(0, -1);
    
    [self racSignalLoad];
}

- (void)racSignalLoad {
    
    
    @weakify(self)
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        SFRegisterViewController * registerVc = [NSClassFromString(@"SFRegisterViewController") new];
        registerVc.delegate = self;
        [self.navigationController pushViewController:registerVc animated:YES];
    }];
    
    [[self.phoneTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        
        if (x.length == 0) return ;
        if ([NSString valiMobile:x]) {
            self.desLabel.text = @"";
        }else{
            self.desLabel.text = @"请输入正确的手机号";
        }
    }];
    
    [[self.pswTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        
        if ([x isEqualToString:@""]||[self.phoneTextField.text isEqualToString:@""]) {
            
            self.loginButton.backgroundColor = Color(@"#D8D8D8");
            
        }
        if ([NSString valiMobile:self.phoneTextField.text] && ![x isEqualToString:@""]&&x.length >= 6) {
            
            self.loginButton.backgroundColor = defaultColor;
        }
        
    }];
    
    [[self.seeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        self.pswTextField.secureTextEntry = x.selected;
    }];
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)

        if (![NSString valiMobile:self.phoneTextField.text]) {
            
            self.desLabel.text = @"请输入正确的手机号";
            return ;
        }
        if ([self.pswTextField.text isEqualToString:@""]&&self.pswTextField.text.length < 6) {
            
            self.pwdesLabel.text = @"请输入正确的密码";
            return ;
        }
        [self.view endEditing:NO];
        [self loginWithUser];
    }];
    
    [[self.forgetButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        UIViewController * vc = [[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"SFForGetPwd"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)loginWithUser{
//    @"13888888888"@"123456 18999999999" 13111111111  16813888888
//    NSLog(@"======%@",);13566666666  18777777777
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.phoneTextField.text forKey:@"phone"];
    [dict setValue:self.pswTextField.text forKey:@"password"];
    [dict setValue:[JPUSHService registrationID] forKey:@"jpushId"];
    if (self.companyId) {
        [dict setValue:self.companyId forKey:@"companyId"];
    }
    [MBProgressHUD showActivityMessageInWindow:@"登录中..."];
    [SFRegHttpModel loginWithUser:dict success:^{
        [MBProgressHUD hideHUD];
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotificationSuccess object:nil];
        [self userInfoWithCompanyInfo];
    } failure:^(BaseModel * _Nonnull model) {
        [MBProgressHUD hideHUD];
        if (model.errorCode == 1016) {
            
            [self selectCompany:model.arguments];
        }else{
            if (model) {
                
                [MBProgressHUD showTipMessageInView:model.errorMsg timer:3];
            }else{
                [MBProgressHUD showTipMessageInView:@"网络故障，请查看您的网络"];
            }
        }
    }];
}

- (void)selectCompany:(NSArray *)list{
    
    [[SelectCompanysView shareSFSelectCompanyView] showInView:LSKeyWindow dataSource:list actionBlock:^(BaseErrorModel * _Nonnull model) {
        
        if (model.status) {
            self.companyId = model.companyId;
            [self loginWithUser];
        }else{
            
            self.pswTextField.text = @"";
            self.companyId = nil;
        }
    }];
}

#pragma SFRegisterViewControllerDelegate

- (void)registerBackLogin{
    
    [self userInfoWithCompanyInfo];
}

- (void)userInfoWithCompanyInfo{
    
    [MBProgressHUD showActivityMessageInWindow:@"加载信息..."];
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFRegHttpModel getSelfInfoSuccess:^{
            NSLog(@"==========>>>>rongCloudId = %@",[SFInstance shareInstance].rongCloud);
            [subscriber sendNext:@"1"];
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
        }];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFRegHttpModel getCompanyInfoSuccess:^{
            [subscriber sendNext:@"1"];
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
        }];
        
        return nil;
    }];
    [self rac_liftSelector:@selector(completedRequest1:request2:) withSignalsFromArray:@[signal1, signal2]];
}

- (void)completedRequest1:(NSString *)signal1 request2:(NSString *)signal2 {
    
    if ([signal1 isEqualToString:@"1"] && [signal2 isEqualToString:@"1"] ) {
        //获取OSS token
        [SFFilesMgrModel setupOSSClient];
        
        [MBProgressHUD hideHUD];
        [[RCIM sharedRCIM] connectWithToken:[SFInstance shareInstance].rongCloud success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [SFTabBarViewController new];
    }else{
        [MBProgressHUD showErrorMessage:@"加载失败,请重新加载!"];
        [MBProgressHUD hideHUD];
    }
}

@end
