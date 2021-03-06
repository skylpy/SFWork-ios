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
@interface SFFixeSearchViewController ()<UITableViewDelegate,UITableViewDataSource,SFExpenseCellDelegate,SFSuperSuborViewControllerDelagete,SFPhotoSelectCellDelegate,PickerToolDelegate,SFSelectPersonCellDelegate>
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
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[SFBillSearchModel shareShowItemArray:nil]];
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
    
    [self.view addSubview:self.saveButton];
    [self topView];

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
    
    if (model.type == 4) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:NO withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    
    if (model.type == 5) {
        SFExpenseCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseCellID forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    
    SFExpenseTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseTitleCellID forIndexPath:indexPath];
    cell.model = model;
    
    @weakify(self)
    [cell setInputChacneClick:^(NSString * _Nonnull value) {
        @strongify(self)
        
        [self calculatedAmount];
    }];
    return cell;
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
    SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
    vc.delagete = self;
    vc.type = singleType;
    vc.isSubor = NO;
    
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
    
    //    NSArray * array = self.dataArray;
    //    NSArray * array = self.dataArray[indexPath.section];
    //    SFBillSearchModel * model = array[indexPath.row];
    NSMutableArray * arrays = [NSMutableArray array];
    NSMutableDictionary * dicts = [NSMutableDictionary dictionary];
    for (NSArray * array in self.dataArray) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        for (SFBillSearchModel * model in array) {
            
            if (model.type == 1) {
                [dict setValue:model.destitle forKey:@"amount"];
            }
            if (model.type == 2) {
                [dict setValue:model.destitle forKey:@"category"];
            }
            if (model.type == 3) {
                [dict setValue:model.destitle forKey:@"detail"];
            }
            if (model.type == 5) {
                
                for (SFApprpvalModel * appmodel in model.persons) {
                    
                    if ([appmodel.title isEqualToString:@"审核人："]) {
                        [dicts setValue:appmodel.value forKey:@"checkerId"];
                    }
                    if ([appmodel.title isEqualToString:@"审批人："]) {
                        [dicts setValue:appmodel.value forKey:@"approverId"];
                    }
                    if ([appmodel.title isEqualToString:@"出纳人："]) {
                        [dicts setValue:appmodel.value forKey:@"cashierId"];
                    }
                }
            }
        }
        
        if (dict.count) {
            [arrays addObject:dict];
        }
    }
    
    [dicts setObject:arrays forKey:@"reimbursementItemDTOList"];
    [dicts setObject:self.IdArray forKey:@"copyToIds"];
    [dicts setObject:self.imageArray forKey:@"photoList"];
    NSLog(@" ======= %@>>>>",dicts);
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFExpenseHttpModel postAddExpense:dicts success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"添加成功" completionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showWarnMessage:@"添加失败"];
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
            
//            SFHistoryIncomeViewController * hisVC = [SFHistoryIncomeViewController new];
//            hisVC.title = @"搜索结果";
//            hisVC.params = [self saveExpense];
//            [self.navigationController pushViewController:hisVC animated:YES];
        }];
    }
    return _saveButton;
}

@end
