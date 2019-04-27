//
//  SFFinanciaDetailViewController.m
//  SFWork
//
//  Created by fox on 2019/4/19.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFFixeSearchViewController.h"
#import "SFHistoryIncomeViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFAddExpenseViewController.h"
#import "SFAllManagerViewController.h"
#import "SFSelCustomerViewController.h"
#import "SFFinancialApprovalModel.h"
#import "SFExpenseHttpModel.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFSelectPersonCell.h"
#import "SFExpenseCell.h"
#import "PickerTool.h"

static NSString * const SFExpenseCellID = @"SFExpenseCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFSelectPersonCellID = @"SFSelectPersonCellID";
static NSString * const SFExpenseTitleCellID = @"SFExpenseTitleCellID";
@interface SFFixeSearchViewController ()<UITableViewDelegate,UITableViewDataSource,SFExpenseCellDelegate,SFSuperSuborViewControllerDelagete,SFPhotoSelectCellDelegate,PickerToolDelegate,SFSelectPersonCellDelegate,SFAllManagerViewControllerDelagete>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic,strong) PickerTool *pick;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, assign) NSInteger allMoney;
@property (nonatomic, strong) SFApprpvalModel *appModel;
@property (nonatomic, strong) NSMutableArray *IdArray;
@property (nonatomic, strong) NSMutableArray *IconArray;
@property (nonatomic, strong) SFBillSearchModel * model;
@property (nonatomic, assign) BOOL isBack;


@end

@implementation SFFixeSearchViewController


- (NSMutableArray *)IdArray{
    
    if (!_IdArray) {
        _IdArray = [NSMutableArray array];
    }
    return _IdArray;
}

- (NSMutableArray *)IconArray{
    
    if (!_IconArray) {
        _IconArray = [NSMutableArray array];
    }
    return _IconArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)imageArray {
    
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    [self initData];
}

- (BOOL)navigationShouldPopOnBackButton{
    
    return YES;
}


- (void)initData {
    
    if (self.isAdd) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[SFBillSearchModel shareAddItemArray:self.type]];
        
    }else{
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[SFBillSearchModel shareShowItemArray:nil]];
        
    }
   [self.tableView reloadData];
}

- (void)setDrawUI {
    
    self.index = 1;
    self.allMoney = 0;
    self.isBack = NO;
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
        
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(35);
    }];
    
    
    [self topView];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFBillSearchModel * model = array[indexPath.row];
    if (model.type == 2) {
        
        return 120;
    }
    
    if (model.type == 4) {
        
        return 90;
    }
    if (model.type == 3) {
        
        return 120;
    }
    if (model.type == 6 || model.type == 7) {
        
        return 180;
    }
    
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFBillSearchModel * model = array[indexPath.row];
    if (model.type == 6||model.type == 7) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.searchModel = model;
        return cell;
    }
    
    if (model.type == 3) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:NO withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    
    if (model.type == 2 || model.type == 4) {
        SFExpenseCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseCellID forIndexPath:indexPath];
        cell.model = model;
        if (model.type == 4) {
            cell.delegate  = self;
        }
        
        return cell;
    }
    
    SFExpenseTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseTitleCellID forIndexPath:indexPath];
    cell.model = model;
    
    @weakify(self)
    [cell setInputChacneClick:^(NSString * _Nonnull value) {
        @strongify(self)
        
        
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * array = self.dataArray[indexPath.section];
    SFBillSearchModel * model = array[indexPath.row];
    self.model = model;
    if (model.type == 5) {
        SFAllManagerViewController * vc = [SFAllManagerViewController new];
        vc.delagete = self;
        vc.type = singlemType;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (model.type == 13) {
        SFSelCustomerViewController * vc = [NSClassFromString(@"SFSelCustomerViewController") new];
        @weakify(self)
        [vc setSelCustomerClick:^(SFClientModel * _Nonnull cmodel) {
            @strongify(self)
            self.model.destitle = cmodel.name;
            self.model.value = cmodel._id;
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (model.type == 9) {
        
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


//添加回调
- (void)cellClickUpload:(NSArray *)imageArr{
    
    [self.imageArray removeAllObjects];
    [self.imageArray addObjectsFromArray:imageArr];
    self.pick = [[PickerTool alloc]initWithMaxCount:1 selectedAssets:nil];
    self.pick.delegate = self;
    [self presentViewController:self.pick.imagePickerVcC animated:YES completion:nil];
}

//多选
- (void)multiplesSelectEmoloyee:(NSArray <SFEmployeesModel *> *)employees{
    
    [self.IdArray removeAllObjects];
    [self.IconArray removeAllObjects];
    
    for (SFEmployeesModel * model in employees) {
        
        [self.IdArray addObject:model._id];
        [self.IconArray addObject:model.avatar];
    }
    
    [self.tableView reloadData];
}

#pragma mark- PickerToolDelegate
- (void)didPickedPhotos:(NSString *)fileName{
    
    if (self.pick.selectedPhotos.count > 0) {
        [[SFAliOSSManager sharedInstance] asyncUploadMultiImages:self.pick.selectedPhotos withFile:fileName withFolderName:@"Image" CompeleteBlock:^(NSArray *nameArray) {
            NSLog(@"nameArray is %@", nameArray);
            [self files:nameArray];
        } ErrowBlock:^(NSString *errrInfo) {
            
        }];
    }
}

- (void)files:(NSArray *)nameArr {
    
    NSDictionary * dic = nameArr[0];
    NSString *img = dic[@"Img"];
    
    [self.imageArray addObject:img];
    [self.tableView reloadData];
}

#pragma SFExpenseCell   选择人员
- (void)cellSelectModel:(SFApprpvalModel *)model{
    self.appModel = model;
    if ([model.value isEqualToString:[SFInstance shareInstance].userInfo._id]) return;
    SFAllManagerViewController * vc = [SFAllManagerViewController new];
    vc.delagete = self;
    vc.type = singlemType;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    self.appModel.detitle = employee.name;
    self.appModel.value = employee._id;
    [self.tableView reloadData];
}

//单选
- (void)singleSelectAllManager:(SFEmployeesModel *)employee{
    
    if (self.model.type == 5) {
        self.model.destitle = employee.name;
        self.model.value = employee._id;
    }else{
        
        self.appModel.detitle = employee.name;
        self.appModel.value = employee._id;
    }
    
    [self.tableView reloadData];
}


- (void)calculatedAmount {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        self.allMoney = 0;
        for (NSArray * arr in self.dataArray) {
            
            for (SFBillSearchModel * mod  in arr) {
                
                if (mod.type == 1) {
                    
                    self.allMoney = [mod.destitle integerValue] + self.allMoney;
                }
            }
        }
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            NSLog(@"=== %ld",self.allMoney);
            self.titleLabel.text = [NSString stringWithFormat:@"总报销金额(元)：%ld",self.allMoney];
        });
        
    });
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        _tableView.estimatedSectionFooterHeight = 0.0001;
        _tableView.estimatedSectionHeaderHeight = 0.0001;
        [_tableView registerClass:[SFExpenseTitleCell class] forCellReuseIdentifier:SFExpenseTitleCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectPersonCell" bundle:nil] forCellReuseIdentifier:SFSelectPersonCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFExpenseCell" bundle:nil] forCellReuseIdentifier:SFExpenseCellID];
    }
    return _tableView;
}

- (void)topView{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 35)];
    topView.backgroundColor = [UIColor colorWithRed:255/255.0 green:245/255.0 blue:228/255.0 alpha:1.0];
    [self.view addSubview:topView];
    
    UIImageView * newsIMG = [[UIImageView alloc]initWithFrame:CGRectZero];
    [newsIMG setImage:[UIImage imageNamed:@"icon_news_orange"]];
    [topView addSubview:newsIMG];
    [newsIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(15);
    }];
    
    UILabel * topTitleLB = [[UILabel alloc]initWithFrame:CGRectZero];
    topTitleLB.text = _isAdd?@"请填写数据精准和完善一些":@"记得多少填多少，但请填写精准";
    topTitleLB.font = [UIFont systemFontOfSize:13];
    topTitleLB.textColor = [UIColor colorWithRed:249/255.0 green:106/255.0 blue:14/255.0 alpha:1.0];
    [topView addSubview:topTitleLB];
    [topTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(31);
    }];
}

- (void)saveExpense{
    
    NSMutableArray * arrays = [NSMutableArray array];
    NSMutableDictionary * dicts = [SFFinancialApprovalModel pramApprovalJson:self.dataArray];
    for (NSArray * array in self.dataArray) {
        
        for (SFBillSearchModel * model in array) {
            
            if (model.type == 2) {
                for (int i = 0; i < model.persons.count; i ++) {
                    
                    SFSearchApprpvalModel * mod = model.persons[i];
                    if ([mod.title isEqualToString:@"收入金额："]) {
                        
                        [dicts setValue:mod.detitle forKey:@"amount"];
                    }
                    if ([mod.title isEqualToString:@"结账方式："]) {
                        [dicts setValue:mod.detitle forKey:@"payType"];
                    }
                    if ([mod.title isEqualToString:@"单价："]) {
                        [dicts setValue:mod.detitle forKey:@"price"];
                    }
                    if ([mod.title isEqualToString:@"数量："]) {
                        [dicts setValue:mod.detitle forKey:@"num"];
                    }
                    if ([mod.title isEqualToString:@"凭证字："]) {
                        [dicts setValue:mod.detitle forKey:@"voucherWord"];
                    }
                    if ([mod.title isEqualToString:@"凭证号："]) {
                        [dicts setValue:mod.detitle forKey:@"voucherNo"];
                    }
                }
            }
            
            if (model.type == 4 || model.type == 5) {
                
                NSMutableDictionary * dict1 = [NSMutableDictionary dictionary];
                for (int i = 0; i < model.persons.count; i ++) {
                    NSMutableDictionary * dict11 = [NSMutableDictionary dictionary];
                    SFSearchApprpvalModel * mod = model.persons[i];
                    if ([mod.title isEqualToString:@"制表人："]) {
                        [dict11 setValue:@"LISTER" forKey:@"processStage"];
                        
                    }
                    if ([mod.title isEqualToString:@"经办人："]) {
                        [dict11 setValue:@"OPERATOR" forKey:@"processStage"];
                        
                    }
                    if ([mod.title isEqualToString:@"审核人："]) {
                        [dict11 setValue:@"AUDITOR" forKey:@"processStage"];
                        
                    }
                    if ([mod.title isEqualToString:@"审批人："]) {
                        [dict11 setValue:@"APPROVER" forKey:@"processStage"];
                        
                    }
                    [dict11 setValue:mod.value forKey:@"processorId"];
                    NSLog(@"%@",dict11);
                    [arrays addObject:dict11];
                }
                
                
                if (model.type == 5) {
                    NSMutableDictionary * dict11 = [NSMutableDictionary dictionary];
                    [dict11 setValue:@"CASHIER" forKey:@"processStage"];
                    [dict11 setValue:model.value forKey:@"processorId"];
                    
                    [arrays addObject:dict11];
                }
                
            }
        }
    }
    [dicts setObject:arrays forKey:@"billProcessDTOList"];
    for (NSDictionary *dic in arrays) {
        
        if ([dic[@"processStage"] isEqualToString:@"LISTER"]) {
            [dicts setValue:dic[@"processorId"] forKey:@"listerId"];
        }
        if ([dic[@"processStage"] isEqualToString:@"OPERATOR"]) {
            [dicts setValue:dic[@"processorId"] forKey:@"operatorId"];
        }
        if ([dic[@"processStage"] isEqualToString:@"APPROVER"]) {
            [dicts setValue:dic[@"processorId"] forKey:@"approverId"];
        }
        if ([dic[@"processStage"] isEqualToString:@"AUDITOR"]) {
            [dicts setValue:dic[@"processorId"] forKey:@"auditorId"];
        }
        if ([dic[@"processStage"] isEqualToString:@"CASHIER"]) {
            [dicts setValue:dic[@"processorId"] forKey:@"cashierId"];
        }
    }
    [dicts setObject:self.imageArray forKey:@"photos"];
    NSLog(@" ======= %@>>>>",dicts);
    
    
    [MBProgressHUD showActivityMessageInView:@""];
    [SFFinancialApprovalHttpModel addfinacebillProcess:dicts success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showInfoMessage:@"添加成功" completionBlock:^{
            !self.fixeClick?:self.fixeClick();
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:@"添加失败"];
    }];
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:_isAdd?@"提交":@"搜索" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#01B38B");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
             [self saveExpense];

        }];
    }
    return _saveButton;
}

@end
