//
//  SFFinanciaDetailViewController.m
//  SFWork
//
//  Created by fox on 2019/4/19.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFFinancialApprovalingViewController.h"
#import "SFHistoryIncomeViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFAddExpenseViewController.h"
#import "SFSelectAapprovalPersonCell.h"
#import "SFExpenseHttpModel.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFSelectPersonCell.h"
#import "SFExpenseCell.h"
#import "PickerTool.h"
#import "SFFinancialApprovalModel.h"
#import "SFAddTallyTypeView.h"
#import "SFFinancialApprovalHttpModel.h"

static NSString * const SFExpenseCellID = @"SFExpenseCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFSelectPersonCellID = @"SFSelectPersonCellID";
static NSString * const SFExpenseTitleCellID = @"SFExpenseTitleCellID";
static NSString * const SFSelectAapprovalPersonCellID = @"SFSelectAapprovalPersonCellID";
@interface SFFinancialApprovalingViewController ()<UITableViewDelegate,UITableViewDataSource,SFExpenseCellDelegate,SFSuperSuborViewControllerDelagete,SFPhotoSelectCellDelegate,PickerToolDelegate,SFSelectPersonCellDelegate>

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
@property (nonatomic, strong) NSMutableArray *approvalArray;
@property (nonatomic, assign) BOOL isBack;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIButton *throughtButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation SFFinancialApprovalingViewController

- (NSMutableArray *)approvalArray{
    
    if (!_approvalArray) {
        _approvalArray = [NSMutableArray array];
    }
    return _approvalArray;
}

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
    [self requestDateil];
}

- (BOOL)navigationShouldPopOnBackButton{
    
    return YES;
}


- (void)initData {
    
    
}

- (void)requestDateil{
    
    [SFFinancialApprovalHttpModel getFinancialApprovalDateil:self.f_id success:^(SFFinancialModel * _Nonnull model) {
        
        if (self.fType == FinancialApprovalType) {
            [self.imageArray removeAllObjects];
            [self.dataArray removeAllObjects];
            [self.approvalArray removeAllObjects];
            [self.imageArray addObjectsFromArray:model.photos];
            [self.dataArray addObjectsFromArray:[SFFinancialApprovalModel shareShowItemArray:model]];
            
            NSMutableArray * processArr = [NSMutableArray array];
            for (BillProcessModel * mod in model.billProcessDTOList) {
                
                if (![mod.processStage isEqualToString:@"LISTER"]&&![mod.processStage isEqualToString:@"OPERATOR"]) {
                    NSLog(@"%@",mod.processStage);
                    [self.approvalArray addObject:mod];
                    [processArr addObject:mod.processorId];
                }
            }
            
            if ([processArr containsObject:[SFInstance shareInstance].userInfo._id]&&[model.processResult isEqualToString:@"APPROVING"]) {
                self.bottomView.hidden = NO;
            }else{
                self.bottomView.hidden = YES;
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setDrawUI {
    
    self.index = 1;
    self.allMoney = 0;
    self.isBack = YES;
    if (self.title.length == 0) {
        self.title = self.fType == FinancialApprovalType ? @"收据详情":@"收据详情";
    }
    
    self.view.backgroundColor = bgColor;
    [self.view addSubview:self.tableView];
    float bottomHeight = - 60.0;
    if (_state != nil) {
        bottomHeight = SafeAreaBottomHeight;
        self.bottomView.hidden = YES;
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.equalTo(self.view.mas_bottom);

        make.bottom.equalTo(self.view.mas_bottom).offset(bottomHeight);

        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.saveButton];
    [self topView];
    
    @weakify(self)
    [[self.rejectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        SFAlertInputView * alert=[[SFAlertInputView alloc] initWithTitle:@"驳回原因" PlaceholderText:@"请输入驳回原因" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
            NSLog(@"-----%@",contents);
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setValue:contents forKey:@"note"];
            [dict setValue:@"REJECTED" forKey:@"approveAction"];
            [dict setValue:[SFInstance shareInstance].userInfo._id forKey:@"approveId"];
            [dict setValue:self.f_id forKey:@"billId"];
            [self throught:dict];
        }];
        [alert show];
    }];
    [[self.throughtButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:@"" forKey:@"note"];
        [dict setValue:@"PASSED" forKey:@"approveAction"];
        [dict setValue:[SFInstance shareInstance].userInfo._id forKey:@"approveId"];
        [dict setValue:self.f_id forKey:@"billId"];
        [self throught:dict];
    }];
}

- (void)throught:(NSDictionary *)dict{
    
    [MBProgressHUD showActivityMessageInView:@""];
    [SFFinancialApprovalHttpModel finacebillProcess:dict success:^{
        [MBProgressHUD hideHUD];
        
        [self requestDateil];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:@"审批失败"];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFFinancialApprovalModel * model = array[indexPath.row];
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
    if (model.type == 7) {
        
        return 175;
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
    SFFinancialApprovalModel * model = array[indexPath.row];
    if (model.type == 3) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.searchModel = model;
        return cell;
    }
    
    if (model.type == 4) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:YES withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    
    if (model.type == 7) {
        SFSelectAapprovalPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSelectAapprovalPersonCellID forIndexPath:indexPath];
        cell.model = (SFFinancialApprovalModel *)model;
        [cell cellApprovalContent:self.approvalArray with:FinancialAppType withType:NO withCopy:NO];
        return cell;
    }
    
    if (model.type == 5) {
        SFExpenseCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseCellID forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    
    SFExpenseTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseTitleCellID forIndexPath:indexPath];
    cell.model = model;
    
    return cell;
}

//查看回调
- (void)openClickLook:(NSArray *)imageArr withRow:(NSInteger)row withView:(UIView *)superView{
    
    [SFTool openImageArr:imageArr withController:superView withRow:row];
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
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectAapprovalPersonCell" bundle:nil] forCellReuseIdentifier:SFSelectAapprovalPersonCellID];
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
    if (_state == nil) {
        if ([_fmodel.processResult isEqualToString:@"APPROVED"]) {
            topTitleLB.text = @"这条账款正在走审批流程，等待完成";
        }else if ([_fmodel.processResult isEqualToString:@"REJECTED"]){
            topTitleLB.text = @"此账款被驳回，等待修改后再次提交";
        }else if ([_fmodel.processResult isEqualToString:@"CANCELED"]){
            topTitleLB.text = [NSString stringWithFormat:@""];
        }else{
            topTitleLB.text = @"此账款已经处理完成，已经录入公司总账";
        }
    }else{
        topTitleLB.text = [NSString stringWithFormat:@"该账款详情由%@于%@创建",_fmodel.listerName,_fmodel.createTime];
    }
    
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
    //    SFFinancialApprovalModel * model = array[indexPath.row];
    NSMutableArray * arrays = [NSMutableArray array];
    NSMutableDictionary * dicts = [NSMutableDictionary dictionary];
    for (NSArray * array in self.dataArray) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        for (SFFinancialApprovalModel * model in array) {
            
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

#pragma mark 驳回

- (IBAction)boAction:(UIButton *)sender {
    SFAddTallyTypeView * addView = [[[NSBundle mainBundle]loadNibNamed:@"SFAddTallyTypeView" owner:nil options:nil] firstObject];
    addView.frame = CGRectMake(0, 0, kWidth, kHeight);
    addView.titleLB.text = @"驳回原因";
    addView.textField.placeholder = @"请输入驳回原因";
    __weak typeof(addView) weakAddView;
    addView.sureBlock = ^(NSString * _Nonnull text) {
        if (text.length==0) {
            [MBProgressHUD showWarnMessage:@"驳回原因不能为空或者全为空格"];
            return;
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:addView];
}
@end
