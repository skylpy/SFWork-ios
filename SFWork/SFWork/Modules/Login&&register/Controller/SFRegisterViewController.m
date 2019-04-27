//
//  SFRegisterViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFRegisterViewController.h"
#import "SFWebViewController.h"
#import "SFRegisterCell.h"
#import "SFRegisterModel.h"
#import "SFHomeHeaderView.h"
#import "SFGetCodeCell.h"
#import "SFServiceAgreeCell.h"

static NSString * const SFServiceAgreeCellID = @"SFServiceAgreeCellID";
static NSString * const SFRegisterCellID = @"SFRegisterCellID";
static NSString * const SFGetCodeCellID = @"SFGetCodeCellID";

@interface SFRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,AddressViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * titleArray;
@property (nonatomic,strong) UIButton * bottomButton;
@property (nonatomic,strong) UIView * bottomView;
@property (nonatomic, strong) SFAddressPicker *  addressPicker;
@property (nonatomic, strong) SFRegisterModel * addressModel;
@property (nonatomic, copy) NSString * areaId;
@property (nonatomic, assign) BOOL serviceAgree;
@end

@implementation SFRegisterViewController

- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 130)];
        [_bottomView addSubview:self.bottomButton];
    }
    return _bottomView;
}

- (UIButton *)bottomButton{
    
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(15, 50, kWidth-30, 45);
        [_bottomButton setTitle:@"注册" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomButton.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        _bottomButton.backgroundColor = Color(@"#01B38B");
//        _bottomButton.layer.cornerRadius = 5;
//        _bottomButton.clipsToBounds = YES;
        @weakify(self)
        [[_bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self registerRequest];
        }];
    }
    return _bottomButton;
}

-(NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"企业信息",@"管理员信息",@"推荐码",@"服务协议", nil];
    }
    return _titleArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新企业注册";
    
    [self initDrawUI];
    [self initData];
    [self getCity];
}

- (void)getCity{
    
    [SFRegHttpModel getCityDataSuccess:^(NSArray<AddressModel *> * _Nonnull address) {
        
        [self.addressPicker loadRequestData:address];
        
    } failure:nil];
}

- (void)initData{
    
    NSArray * array = [SFRegisterModel shareRegisterModel];

    [self.dataArray addObjectsFromArray:array];

    [self.tableView reloadData];
}

-(void)initDrawUI {
    
    self.serviceAgree = YES;
    [self.view addSubview:self.bottomButton];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
       
    }];
    
    self.addressPicker= [[SFAddressPicker alloc] init];
    [LSKeyWindow addSubview:self.addressPicker];
    self.addressPicker.delegate = self;
}

- (void)registerRequest{
    [MBProgressHUD showActivityMessageInView:@"正在注册..."];
    NSMutableDictionary * prame = [SFRegisterModel pramJson:self.dataArray];
//    [prame setObject:self.areaId forKey:@"areaId"];
//    NSDictionary * dict = @{
//        @"adminName" : @"admin",
//        @"areaId" : @"12345",
//        @"companyAccount" :@"hh123",
//        @"companyName" :@"hhh",
//        @"invitationCode" :@"",
//        @"password" : @"123456",
//        @"phone" : @"13888888888",
//        @"vercode" : @"1234"
//    };
    
    if (!self.serviceAgree) {
        [UIAlertController alertTitle:@"温情提示" mesasge:@"请选择服务协议！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
        } viewController:self];
        return;
    }
    
    if (![NSString valiMobile:prame[@"phone"]]) {
        [UIAlertController alertTitle:@"温情提示" mesasge:@"请输入正确的手机号码！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
        } viewController:self];
        return;
    }
    
    if ([prame[@"adminName"] isEqualToString:@""]) {
        [UIAlertController alertTitle:@"温情提示" mesasge:@"请输入管理员名字！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
        } viewController:self];
        return;
    }
    
    if ([prame[@"areaId"] isEqualToString:@""]) {
        [UIAlertController alertTitle:@"温情提示" mesasge:@"请选择地区！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
        } viewController:self];
        return;
    }
    
    if ([prame[@"companyAccount"] isEqualToString:@""]) {
        [UIAlertController alertTitle:@"温情提示" mesasge:@"请输入企业账号！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
        } viewController:self];
        return;
    }
    
    if ([prame[@"companyName"] isEqualToString:@""]) {
        [UIAlertController alertTitle:@"温情提示" mesasge:@"请输入企业名称！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
        } viewController:self];
        return;
    }
    
//    if ([prame[@"invitationCode"] isEqualToString:@""]) {
//        [UIAlertController alertTitle:@"温情提示" mesasge:@"请输入验证码！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
//        } viewController:self];
//        return;
//    }
    
    if ([prame[@"password"] isEqualToString:@""]) {
        [UIAlertController alertTitle:@"温情提示" mesasge:@"请输入密码！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
        } viewController:self];
        return;
    }
    
   
    
    [SFRegHttpModel registerCompany:prame success:^{
        
        [MBProgressHUD hideHUD];
        if (self.delegate && [self.delegate respondsToSelector:@selector(registerBackLogin)]) {
            
            [self.delegate registerBackLogin];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        
        if (error) {
            [MBProgressHUD showErrorMessage:error.userInfo[@"NSLocalizedFailureReason"]];
        }
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SFHomeHeaderView * header = [SFHomeHeaderView shareSFHomeHeaderView];
    header.titleLabel.text = self.titleArray[section];
    header.backgroundColor = [UIColor clearColor];
    header.lineView.hidden = YES;
    [header.titleLabel setTextColor: Color(@"#666666")];
    header.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFRegisterModel * model = array[indexPath.row];
    
    if (model.type == 5) {
       
        SFGetCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFGetCodeCellID forIndexPath:indexPath];
        cell.model = model;
        @weakify(self)
        [cell setGetCodeClick:^(UIButton * _Nonnull sender) {
            @strongify(self)
            [self cutdownWithButton:sender];
        }];
        return cell;
    }
    if (model.type == 8) {
        SFServiceAgreeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFServiceAgreeCellID forIndexPath:indexPath];
        
        @weakify(self)
        [cell setSelectClick:^(UIButton * _Nonnull sender) {
            @strongify(self)
            self.serviceAgree = sender.selected;
        }];
        [cell setServiceClick:^{
            @strongify(self)
            SFWebViewController * vc = [SFWebViewController new];
            
            vc.urlString = BASE_URL(@"/common/protocol.html");
            [self.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
    SFRegisterCell * cell = [tableView dequeueReusableCellWithIdentifier:SFRegisterCellID forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * array = self.dataArray[indexPath.section];
    SFRegisterModel * model = array[indexPath.row];
    [self.view endEditing:YES];
    if (model.type == 2) {
        self.addressModel = model;
        [self.addressPicker show];
    }
}


- (void)cutdownWithButton:(UIButton *)button {
    
    button.userInteractionEnabled = NO;
    
    __block int timeout=90; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:[NSString stringWithFormat:@"%@s重新发送",strTime] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFRegisterCell" bundle:nil] forCellReuseIdentifier:SFRegisterCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFGetCodeCell" bundle:nil] forCellReuseIdentifier:SFGetCodeCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFServiceAgreeCell" bundle:nil] forCellReuseIdentifier:SFServiceAgreeCellID];
        
//        _tableView.tableFooterView = self.bottomView;
        
        
    }
    return _tableView;
}

#pragma mark - AddressViewDelegate
- (void)cancelOnclick{
    [self.addressPicker hide];
}

- (void)viewDisappearance{
    [self.addressPicker hide];
}

- (void)completingTheSelection:(AddressModel *)province city:(AddressModel *)city area:(AddressModel *)area;{
    [self.addressPicker hide];
    self.addressModel.value = [NSString stringWithFormat:@"%@,%@,%@",province.label,city.label,area.label];
    self.areaId = area.value;
    NSLog(@"province:%@,city:%@,area:%@",province.label,city.label,area.label);
    
}

@end
