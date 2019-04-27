//
//  SFSearchDetailViewController.m
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFSearchDetailViewController.h"
#import "SFHistoryIncomeViewController.h"
#import "SFAllManagerViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFAddExpenseViewController.h"
#import "SFSelCustomerViewController.h"
#import "SFExpenseHttpModel.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFSelectPersonCell.h"
#import "SFExpenseCell.h"
#import "PickerTool.h"
#import "SFAttendanceSetHttpModel.h"
#import "SFTallyTypeSelectView.h"
#import "SFAddTallyTypeView.h"
#import "FromDateSelectDatePick.h"

static NSString * const SFExpenseCellID = @"SFExpenseCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFSelectPersonCellID = @"SFSelectPersonCellID";
static NSString * const SFExpenseTitleCellID = @"SFExpenseTitleCellID";

@interface SFSearchDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SFExpenseCellDelegate,SFSuperSuborViewControllerDelagete,SFPhotoSelectCellDelegate,PickerToolDelegate,SFSelectPersonCellDelegate>

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

@property (nonatomic, assign) BOOL isBack;

@end

@implementation SFSearchDetailViewController


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
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[SFBillSearchModel shareSearchItemArray]];
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    self.index = 1;
    self.allMoney = 0;
    self.isBack = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.saveButton];
    [self topView];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFBillSearchModel * model = array[indexPath.row];
    if (model.type == 3) {
        
        return 203;
    }
    if (model.type == 4 || model.type == 6) {
        
        return 120;
    }
    
    if (model.type == 5) {
        if (indexPath.section == 1) {
            return 120;
        }
        return 80;
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
    if (model.type == 3) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.searchModel = model;
        return cell;
    }
    
    if (model.type == 5) {
        SFExpenseCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseCellID forIndexPath:indexPath];
        cell.model = model;
        cell.delegate = self;
        return cell;
    }

    SFExpenseTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseTitleCellID forIndexPath:indexPath];
    if (indexPath.section==2&&indexPath.row==5) {
        if ([self.title containsString:@"支出"]) {
            model.title = @"客户";
        }else{
            model.title = @"商家";
        }
        
    }
    cell.model = model;

    @weakify(self)
    [cell setInputChacneClick:^(NSString * _Nonnull value) {
        @strongify(self)
        
        [self calculatedAmount];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * array = self.dataArray[indexPath.section];
    SFBillSearchModel * model = array[indexPath.row];
    if (indexPath.section == 2) {
        if (indexPath.row == 3) {
            SFTallyTypeSelectView * selectView = [[[NSBundle mainBundle]loadNibNamed:@"SFTallyTypeSelectView" owner:nil options:nil] firstObject];
            
            selectView.addBlock = ^{
                SFAddTallyTypeView * addView = [[[NSBundle mainBundle]loadNibNamed:@"SFAddTallyTypeView" owner:nil options:nil] firstObject];
                addView.frame = CGRectMake(0, 0, kWidth, kHeight);
                __weak typeof(addView) weakAddView;
                addView.sureBlock = ^(NSString * _Nonnull text) {
                    if (text.length==0) {
                        [MBProgressHUD showWarnMessage:@"新增名称不能为空或者全为空格"];
                        return;
                    }
                    [MBProgressHUD showActivityMessageInView:@"加载中..."];
                    [SFBaseModel BPOST:BASE_URL(@"") parameters:@{text:@"name"} success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
                        [MBProgressHUD hideHUD];
                        if (model.status == 200) {
                            [MBProgressHUD showSuccessMessage:@"新增成功"];
                            [weakAddView removeAllSubviews];
                        }
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        
                    }];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:addView];
            };
            selectView.frame = CGRectMake(0, 0, kWidth, kHeight);
            selectView.sureBlock = ^(NSString * _Nonnull name) {
                SFExpenseTitleCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                model.destitle = name;
                cell.model = model;

            };
            [[UIApplication sharedApplication].keyWindow addSubview:selectView];

        }else if (indexPath.row == 1){
            FromDateSelectDatePick * datePickView = [[[NSBundle mainBundle]loadNibNamed:@"FromDateSelectDatePick" owner:nil options:nil] firstObject];
            datePickView.frame = CGRectMake(0, 0, kWidth, kHeight);
            datePickView.onlyOneDateSelect = YES;
            datePickView.titleStr = @"日期选择";
            [datePickView initUI];
            datePickView.sureBlock = ^(NSString * _Nonnull startDate, NSString * _Nonnull endDate) {
                SFExpenseTitleCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                model.destitle = startDate;
                cell.model = model;
            };
            [[UIApplication sharedApplication].keyWindow addSubview:datePickView];
        }else if (indexPath.row == 5){
            SFSelCustomerViewController * selectVC = [SFSelCustomerViewController new];
            [self.navigationController pushViewController:selectVC animated:YES];
        }
    }else if (indexPath.section == 4){
        SFAllManagerViewController * vc = [SFAllManagerViewController new];
        vc.selectAllClick = ^(NSArray * _Nonnull allArray) {
            ReportUserModel * remodel = [allArray firstObject];
            SFExpenseTitleCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            model.destitle =  remodel.name;
            model.value = remodel.id;
            cell.model = model;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    vc.selectAllClick = ^(NSArray * _Nonnull allArray) {
        ReportUserModel * remodel = [allArray firstObject];
        self.appModel.value = remodel.id;
        self.appModel.detitle = remodel.name;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    self.appModel.detitle = employee.name;
    self.appModel.value = employee._id;
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

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#01B38B");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            SFHistoryIncomeViewController * hisVC = [SFHistoryIncomeViewController new];
            hisVC.title = @"搜索结果";
            hisVC.params = [self saveExpense];
            [self.navigationController pushViewController:hisVC animated:YES];
        }];
    }
    return _saveButton;
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
    topTitleLB.text = @"记得多少填多少，但请填写精准";
    topTitleLB.font = [UIFont systemFontOfSize:13];
    topTitleLB.textColor = [UIColor colorWithRed:249/255.0 green:106/255.0 blue:14/255.0 alpha:1.0];
    [topView addSubview:topTitleLB];
    [topTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(31);
    }];
}

- (NSMutableDictionary *)saveExpense{
    
    //    NSArray * array = self.dataArray;
    //    NSArray * array = self.dataArray[indexPath.section];
    //    SFBillSearchModel * model = array[indexPath.row];
    NSMutableArray * arrays = [NSMutableArray array];
    NSMutableDictionary * dicts = [NSMutableDictionary dictionary];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (NSArray * array in self.dataArray) {
        for (SFBillSearchModel * model in array) {
            if (model.type == 5) {
                for (SFApprpvalModel * appmodel in model.persons) {
                    
                    if ([appmodel.title isEqualToString:@"收入金额："]) {
                        [dict setValue:appmodel.detitle forKey:@"amount"];
                    }
                    if ([appmodel.title isEqualToString:@"结账方式："]) {
                        [dict setValue:appmodel.detitle forKey:@"payType"];
                    }
                    if ([appmodel.title isEqualToString:@"单价："]) {
                        [dict setValue:appmodel.detitle forKey:@"price"];
                    }
                    if ([appmodel.title isEqualToString:@"数量："]) {
                        [dict setValue:appmodel.detitle forKey:@"num"];
                    }
                    if ([appmodel.title isEqualToString:@"凭证字："]) {
                        [dict setValue:appmodel.detitle forKey:@"voucherWord"];
                    }
                    if ([appmodel.title isEqualToString:@"凭证号："]) {
                        [dict setValue:appmodel.detitle forKey:@"voucherNo"];
                    }
                    if ([appmodel.title isEqualToString:@"经办人："]) {
                        [dict setValue:appmodel.value forKey:@"operatorId"];
                    }
                    if ([appmodel.title isEqualToString:@"制表人："]) {
                        [dict setValue:appmodel.value forKey:@"listerId"];
                    }
                    if ([appmodel.title isEqualToString:@"审核人："]) {
                        [dict setValue:appmodel.value forKey:@"auditorId"];
                    }
                    if ([appmodel.title isEqualToString:@"审批人："]) {
                        [dict setValue:appmodel.value forKey:@"approverId"];
                    }
                }
            }else{
                if ([model.title isEqualToString:@"编号："]) {
//                    [dict setValue:model.destitle forKey:@"detail"];
                }else if ([model.title isEqualToString:@"类别："]) {
                    [dict setValue:model.destitle forKey:@"category"];
                }else if ([model.title isEqualToString:@"业务日期："]) {
                    [dict setValue:model.destitle forKey:@"bizDate"];
                }else if ([model.title isEqualToString:@"来往业务："]) {
                    [dict setValue:model.destitle forKey:@"dealing"];
                }else if ([model.title isEqualToString:@"记账方式："]) {
                    [dict setValue:model.destitle forKey:@"chargeType"];
                }else if ([model.title isEqualToString:@"关键词："]) {
                    [dict setValue:model.destitle forKey:@"keyword"];
                }else if ([model.title isEqualToString:@"客户："]) {
                    [dict setValue:model.destitle forKey:@"customer"];
                }else if ([model.title isEqualToString:@"出纳人："]) {
                    [dict setValue:model.destitle forKey:@"cashierId"];
                }else if ([model.title isEqualToString:@"摘要："]) {
                    [dict setValue:model.destitle forKey:@"remark"];
                }else if ([model.title isEqualToString:@"科目："]) {
                    [dict setValue:model.destitle forKey:@"subject"];
                }
                
            }
        }
        
        if (dict.count) {
            [arrays addObject:dict];
        }
    }
    
    [dict setObject:[self.title containsString:@"收入"]?@[@"DEBIT"]:@[@"CREDIT"] forKey:@"dcFlags"];
    
//
//    [MBProgressHUD showActivityMessageInWindow:@""];
//    [SFExpenseHttpModel postAddExpense:dicts success:^{
//
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showSuccessMessage:@"添加成功" completionBlock:^{
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//
//    } failure:^(NSError * _Nonnull error) {
//
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showWarnMessage:@"添加失败"];
//    }];
    
    return dict;
}

@end
