//
//  SFProfileViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFProfileViewController.h"
#import "SFProfileModel.h"
#import "SFProfileTableCell.h"
#import "SFOrganizationModel.h"
#import "SFSetTypeModel.h"
#import "HttpManager.h"
#import "PickerTool.h"
#import "SFUserStatueCell.h"

static NSString * const SFUserStatueCellID = @"SFUserStatueCellID";
static NSString * const SFProfileTableCellID = @"SFProfileTableCellID";
static NSString * const SFProfileImageCellID = @"SFProfileImageCellID";

@interface SFProfileViewController ()<UITableViewDelegate,UITableViewDataSource,PickerToolDelegate,DateTimePickerViewDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)UIButton * bottomButton;
@property (nonatomic, strong) UIButton *letfButton;
@property (nonatomic, strong) NSMutableArray *position;
@property (nonatomic,strong) PickerTool *pick;
@property (nonatomic, strong) SFProfileModel * model;
@end

@implementation SFProfileViewController

- (UIButton *)letfButton{
    
    if (!_letfButton) {
        
        _letfButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _letfButton.frame = CGRectMake(0, 0, 12, 20);
        [_letfButton setImage:[UIImage imageNamed:@"arrow_return_gray"] forState:UIControlStateNormal];
        @weakify(self)
        [[_letfButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _letfButton;
}

- (UIButton *)bottomButton{
    
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(0, 0, kWidth, 45);
        [_bottomButton setTitle:@"保存" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _bottomButton.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        _bottomButton.backgroundColor = Color(@"#01B38B");
    }
    return _bottomButton;
}

- (NSMutableArray *)position{
    
    if (!_position) {
        _position = [NSMutableArray array];
    }
    return _position;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    
    [self initDrawUI];
    [self initData];
    [self getSetTypeModel];
}

- (void)getSetTypeModel{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    [SFSetTypeModel getCompanySetting:@"POSITION" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.position removeAllObjects];
        [self.position addObjectsFromArray:list];
        
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
    
}

//选择职业
- (void)selectPosition:(SFProfileModel *)model {
    
    NSMutableArray * array = [NSMutableArray array];
    for (SFSetTypeModel * model in self.position) {
         ModelComfirm *item = [ModelComfirm comfirmModelWith:model.name titleColor:Color(@"#0B0B0B") fontSize:16];
        [array addObject:item];
    }
  
    ModelComfirm *cancelItem = [ModelComfirm comfirmModelWith:@"取消" titleColor:Color(@"#0B0B0B") fontSize:16];
    [ComfirmView showInView:LSKeyWindow cancelItemWith:cancelItem dataSource:array actionBlock:^(ComfirmView *view, NSInteger index) {
        //textField 已经和model绑定，改变model textField 跟着改变
        ModelComfirm *item = array[index];
        model.destitle = item.title;
        SFSetTypeModel * smodel = self.position[index];
        model.value = smodel._id;
    }];
}


- (void)updateEmployees{
    
    [MBProgressHUD showActivityMessageInView:@"保存中"];
    NSMutableDictionary * dict = [SFProfileModel pramEmployeeJson:self.dataArray];
    [dict setObject:self.employees.companyId forKey:@"companyId"];
    [dict setObject:self.employees.departmentId forKey:@"departmentId"];
    [dict setObject:self.employees._id forKey:@"id"];
//    [dict setObject:@"EMPLOYEE" forKey:@"role"];
//    [dict setObject:@"ENABLED" forKey:@"status"];
    
    [SFOrganizationModel updateCompanyEmployee:dict success:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"成功"];
        !self.didSaveClick?:self.didSaveClick();
        [[NSNotificationCenter defaultCenter] postNotificationName:updateSelfInfoDataNotificationSuccess object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"失败"];
    }];
}

- (void)addEmployees {
    
    [MBProgressHUD showActivityMessageInView:@"保存中"];
    NSMutableDictionary * dict = [SFProfileModel pramEmployeeJson:self.dataArray];
    
//    NSDictionary * dict = @{
//                            @"name": @"哈哈哈",
//                            @"companyId": self.companyId,
//                            @"departmentId": self.departmentId,
//                            @"gender": @"MALE",
//                            @"phone": @"13666666666",
//                            @"plainPassword": @"123456",
//                            @"email": @"",
//                            @"status": @"ENABLED",
//                            @"role": @"EMPLOYEE",
//                            @"avatar": @"",
//                            @"workNumber": @"12345678"
//                            };
    [dict setObject:self.companyId forKey:@"companyId"];
    [dict setObject:self.departmentId forKey:@"departmentId"];
//    [dict setObject:@"EMPLOYEE" forKey:@"role"];
//    [dict setObject:@"ENABLED" forKey:@"status"];
    
    [SFOrganizationModel addCompanyEmployee:dict success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"成功"];
        !self.didSaveClick?:self.didSaveClick();
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"失败"];
    }];
}

- (void)initData{
    
    NSArray * array = [SFProfileModel shareProfileModel:self.employees depName:self.departmentName withIsOrg:self.isOrg];
    
    [self.dataArray addObjectsFromArray:array];
    
    [self.tableView reloadData];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
    }];
    
    [self.view addSubview:self.bottomButton];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(45);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    @weakify(self)
    [[self.bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        if (self.isOrg) {
            
            if (!self.employees) {
                [self addEmployees];
            }else{
                [self updateEmployees];
            }
        }else{
            [self updateEmployees];
        }
    }];
    
    if (self.isOrg) {
        UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.letfButton];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * array = self.dataArray[indexPath.section];
    SFProfileModel * model = array[indexPath.row];
    if (model.type == 0) {
        
        SFProfileImageCell * cell = [tableView dequeueReusableCellWithIdentifier:SFProfileImageCellID forIndexPath:indexPath];
        
        cell.model = model;
        
        return cell;
    }
    if (model.type == 12 || model.type == 13) {
        SFUserStatueCell * cell = [tableView dequeueReusableCellWithIdentifier:SFUserStatueCellID forIndexPath:indexPath];
        cell.model = model;
        @weakify(self)
        [cell setSelectAllClick:^(BOOL isSelect) {
            @strongify(self)
            
            if (model.type == 12) {
                model.value = isSelect ? @"ENABLED":@"DISABLED";
            }else{
                model.value = isSelect ? @"1":@"0";
            }
            
        }];
        return cell;
    }
    SFProfileTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFProfileTableCellID forIndexPath:indexPath];
   
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * array = self.dataArray[indexPath.section];
    SFProfileModel * model = array[indexPath.row];
    self.model = model;
    //类型等于7属于职位
    if (model.type == 7) {
        [self selectPosition:model];
    }
    
    if (model.type == 0) {
        //上传头像
        self.pick = [[PickerTool alloc]initWithMaxCount:1 selectedAssets:nil];
        self.pick.delegate = self;
        [self presentViewController:self.pick.imagePickerVcC animated:YES completion:nil];
        
    }
    
    if (model.type == 10) {
       
        [self selectTime:DatePickerViewDateMode];
    }
}

- (void)selectTime:(DatePickerViewMode)type{
    
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    
    pickerView.delegate = self;
    pickerView.pickerViewMode = type;
    [LSKeyWindow addSubview:pickerView];
    [pickerView showDateTimePickerView];
}
#pragma mark - delegate

- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSLog(@"%@",date);
    self.model.destitle = date;
    
    [self.tableView reloadData];
}

#pragma mark- PickerToolDelegate
- (void)didPickedPhotos:(NSString *)fileName{
    
    NSString * URLString = [NSString stringWithFormat:@"%@",BASE_URL(@"/org/employee/uploadAvatar/")];
    [MBProgressHUD showActivityMessageInWindow:@""];
//    ,[SFInstance shareInstance].userInfo._id
    [HttpManager uploadImage:URLString parameters:nil images:self.pick.selectedPhotos keys:@[@"1"] uploadProgress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        self.model.destitle = responseObject[@"url"];
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInWindow:@"上传成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
         [MBProgressHUD showTipMessageInWindow:@"上传失败"];
    }];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerClass:[SFProfileTableCell class] forCellReuseIdentifier:SFProfileTableCellID];
        [_tableView registerClass:[SFProfileImageCell class] forCellReuseIdentifier:SFProfileImageCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFUserStatueCell" bundle:nil] forCellReuseIdentifier:SFUserStatueCellID];
    }
    return _tableView;
}

@end
