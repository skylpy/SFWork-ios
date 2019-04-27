//
//  SFForGetPwdViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/17.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFForGetPwdViewController.h"
#import "SFEntryCell.h"
#import "SFVerCodeCell.h"
#import "SFForGetModel.h"
#import "SFRegisterModel.h"
#import "SFPickerView.h"

static NSString * const SFEntryCellID = @"SFEntryCellID";
static NSString * const SFVerCodeCellID = @"SFVerCodeCellID";

@interface SFForGetPwdViewController ()<UITableViewDelegate,UITableViewDataSource,SFPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutH;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *comArray;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (nonatomic, strong) SFForGetModel * model;
@property (nonatomic, copy) NSString *companyId;
@end

@implementation SFForGetPwdViewController

- (NSMutableArray *)comArray{
    
    if (!_comArray) {
        _comArray = [NSMutableArray array];
    }
    return _comArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewLayoutHeight.constant = kHeight;
}

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
    
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[SFForGetModel shareForGetModel]];
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFEntryCell" bundle:nil] forCellReuseIdentifier:SFEntryCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFVerCodeCell" bundle:nil] forCellReuseIdentifier:SFVerCodeCellID];
    
    @weakify(self)
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.view endEditing:NO];
        
        [self saveResetPost];
    }];
}

- (void)saveResetPost{
    
    NSMutableDictionary * dict = [SFForGetModel pramJson:self.dataArray];
    
    if (![NSString valiMobile:dict[@"phone"]]) {
        
        [MBProgressHUD showTipMessageInView:@"请输入正确的手机号码"];
        return;
    }
    if ([dict[@"password"] isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInView:@"请输入新密码"];
        return;
    }
    if ([dict[@"vercode"] isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInView:@"请输入验证码"];
        return;
    }
    if (self.comArray.count > 1 && !self.companyId) {
        
        [MBProgressHUD showTipMessageInView:@"请选择公司"];
        return;
    }
    if (self.companyId) {
        [dict setValue:self.companyId forKey:@"companyId"];
    }
    
    [SFRegHttpModel resetPwdWithUser:dict success:^{
        
        [MBProgressHUD showTipMessageInView:@"重置成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showTipMessageInView:@"重置失败"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFForGetModel * model = self.dataArray[indexPath.row];
    if (model.type == 2) {
        SFVerCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFVerCodeCellID forIndexPath:indexPath];
        cell.model = model;
        @weakify(self)
        [cell setGetCodeClick:^(UIButton * _Nonnull sender) {
            @strongify(self)
            [self resetPassWord:sender];
        }];
        return cell;
    }
    SFEntryCell * cell = [tableView dequeueReusableCellWithIdentifier:SFEntryCellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFForGetModel * model = self.dataArray[indexPath.row];
    self.model = model;
    if (model.type == 4) {
        
        NSMutableArray * array = [NSMutableArray array];
        for (ForGetModel * mod in self.comArray) {
            [array addObject:mod.name];
        }
        [self customArr:array withRow:indexPath.row];
    }
}

- (void)customArr:(NSArray *)array withRow:(NSInteger)row{
    
    SFPickerView *picker = [[SFPickerView alloc] initWithFrame:self.view.bounds];
    picker.delegate = self ;
    picker.row = row;
    picker.customArr = array;
    [LSKeyWindow addSubview:picker];
}
#pragma mark- SFPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text withRow:(NSInteger)row withSelectIndex:(NSInteger)selectIndex{
    
    self.model.value = text;
    ForGetModel * mod= self.comArray[selectIndex];
    self.companyId = mod._id;
    [self.tableView reloadData];
}

- (void)resetPassWord:(UIButton *)sender {
    
    [self.view endEditing:NO];
    SFForGetModel * model = self.dataArray[0];
    if (![NSString valiMobile:model.value]) {
        [MBProgressHUD showTipMessageInView:@"请输入正确的手机号码"];
        return;
    }
    [SFRegHttpModel resetPwdSendVercodes:@{@"phone":model.value} success:^(NSArray<ForGetModel *> * _Nonnull list) {
        if (list.count > 0) {
            self.tableViewLayoutH.constant = 280;
            [self.dataArray insertObject:[SFForGetModel addForGetModel] atIndex:2];
            [self.tableView reloadData];
        }
        [self.comArray addObjectsFromArray:list];
        [MBProgressHUD showSuccessMessage:@"验证码发送成功"];
        [self cutdownWithButton:sender];
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showTipMessageInView:@"验证码发送失败"];
    }];
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

@end
