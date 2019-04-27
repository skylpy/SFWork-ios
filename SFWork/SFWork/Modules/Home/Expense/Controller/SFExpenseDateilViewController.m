
//
//  SFExpenseDateilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFExpenseDateilViewController.h"
#import "SFAddExpenseViewController.h"
#import "SFAddDataFooterView.h"
#import "SFExpenseHttpModel.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFExpenseModel.h"
#import "SFSelectPersonCell.h"
#import "SFApprovalProCell.h"
#import "SFExpenseCell.h"
#import "PickerTool.h"


static NSString * const SFExpenseCellID = @"SFExpenseCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFSelectPersonCellID = @"SFSelectPersonCellID";
static NSString * const SFExpenseTitleCellID = @"SFExpenseTitleCellID";
static NSString * const SFApprovalProCellID = @"SFApprovalProCellID";

@interface SFExpenseDateilViewController ()<UITableViewDelegate,UITableViewDataSource,SFPhotoSelectCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ExpenseListModel *smodel;
@property (nonatomic, strong) NSMutableArray *copyIconArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) SFAddDataFooterView * footerView;
@end

@implementation SFExpenseDateilViewController

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)copyIconArray{
    
    if (!_copyIconArray) {
        _copyIconArray = [NSMutableArray array];
    }
    return _copyIconArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (SFAddDataFooterView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [SFAddDataFooterView shareSFAddDataFooterView];
        [_footerView.cancelButton setTitle:@"驳回" forState:UIControlStateNormal];
        [_footerView.sureButton setTitle:@"通过" forState:UIControlStateNormal];
        
    }
    return _footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"费用报销";
    [self initData];
    [self setDrawUI];
}

- (void)initData {
    
    [SFExpenseHttpModel getMineExpenseDateil:self.model._id success:^(ExpenseListModel * _Nonnull model,NSArray <ExpenseToWhoModel *>* list) {
        
        self.smodel = model;
        [self.dataArray removeAllObjects];
        [self.imageArray removeAllObjects];
        [self.copyIconArray removeAllObjects];
        
        [self.copyIconArray addObjectsFromArray:list];
        [self.imageArray addObjectsFromArray:model.photoList];
        [self.dataArray addObjectsFromArray:[SFExpenseModel shareCostDateilModel:model]];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        
    }];
}

- (void)approvalSet:(NSDictionary *)dict{
    
    [SFExpenseHttpModel postDoApprove:dict success:^{
        
        [MBProgressHUD showSuccessMessage:@"提交成功" completionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showErrorMessage:@"提交失败"];
    }];
}



- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    NSInteger bottom = [self.model.reimburseStatus isEqualToString:@"UNDERWAY"]?-45:0;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(bottom);
        make.top.left.right.equalTo(self.view);
    }];
    
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:self.model.checkerId];
    [array addObject:self.model.approverId];
    [array addObject:self.model.cashierId];
    if ([array containsObject:[SFInstance shareInstance].userInfo._id] && [self.model.reimburseStatus isEqualToString:@"UNDERWAY"]) {
        [self.view addSubview:self.footerView];
        [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.offset(50);
        }];
    }
    
    if ([self.model.reimbursePersonId isEqualToString:[SFInstance shareInstance].userInfo._id]&& [self.model.reimburseStatus isEqualToString:@"UNDERWAY"]) {
        [self.view addSubview:self.saveButton];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.offset(45);
        }];
    }
    @weakify(self)
    [self.footerView setSureClick:^(NSInteger index) {
        @strongify(self)
        
        if (index == 0) {
            SFAlertInputView * alert=[[SFAlertInputView alloc] initWithTitle:@"驳回原因" PlaceholderText:@"请输入驳回原因" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
                NSLog(@"-----%@",contents);
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:contents forKey:@"note"];
                [dict setValue:@"REJECTED" forKey:@"approveStatus"];
                [dict setValue:self.smodel._id forKey:@"id"];
                [self approvalSet:dict];
            }];
            [alert show];
        }else{
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            
            [dict setValue:@"APPROVED" forKey:@"approveStatus"];
            [dict setValue:self.smodel._id forKey:@"id"];
            [self approvalSet:dict];
        }
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFExpenseModel * model = array[indexPath.row];
    if (model.type == 3 ) {
        
        return 160;
    }
    if (model.type == 4 ) {
        
        return 120;
    }
    
    if (model.type == 5) {
        
        return 90;
    }
    if (model.type == 6) {
        
        return 160;
    }
    if ( model.type == 7) {
        
        return 175;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section <= self.smodel.reimbursementItemDTOList.count) {
        
        return 30;
    }
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section < self.smodel.reimbursementItemDTOList.count) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        UILabel * titleLabel = [UILabel createALabelText:[NSString stringWithFormat:@"报销明细(%ld)",section+1] withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#999999")];
        
        [header addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header.mas_left).offset(15);
            make.centerY.equalTo(header);
        }];
        
        return header;
    }
    if (section == self.smodel.reimbursementItemDTOList.count) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        UILabel * titleLabel = [UILabel createALabelText:[NSString stringWithFormat:@"总报销金额(元)：%@",self.model.amount] withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#999999")];
        [header addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header.mas_left).offset(15);
            make.centerY.equalTo(header);
        }];
        
        return header;
    }
    return [UIView new];
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
    SFExpenseModel * model = array[indexPath.row];
    if (model.type == 3) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 4) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:YES withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    
    if (model.type == 5) {
        SFExpenseCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseCellID forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    if (model.type == 6&&self.copyIconArray.count > 0) {

        SFApprovalProCell * cell = [tableView dequeueReusableCellWithIdentifier:SFApprovalProCellID forIndexPath:indexPath];
        
        cell.array = self.copyIconArray;
        
        return cell;
    }
    
    if (model.type == 7) {
        SFApprovalProCell * cell = [tableView dequeueReusableCellWithIdentifier:SFApprovalProCellID forIndexPath:indexPath];
        
        cell.model = model;
        
        return cell;
    }
    SFExpenseTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseTitleCellID forIndexPath:indexPath];
    
    cell.model = model;
    
    return cell;
}

//查看回调
- (void)openClickLook:(NSArray *)imageArr withRow:(NSInteger)row withView:(nonnull UIView *)superView{
    
    [SFTool openImageArr:imageArr withController:superView withRow:row];
    
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFExpenseTitleCell class] forCellReuseIdentifier:SFExpenseTitleCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectPersonCell" bundle:nil] forCellReuseIdentifier:SFSelectPersonCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFExpenseCell" bundle:nil] forCellReuseIdentifier:SFExpenseCellID];
         [_tableView registerNib:[UINib nibWithNibName:@"SFApprovalProCell" bundle:nil] forCellReuseIdentifier:SFApprovalProCellID];
    }
    return _tableView;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"撤回" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#FF715A");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self recallExpense];
        }];
    }
    return _saveButton;
}

- (void)recallExpense{
    
    [UIAlertController alertTitle:@"温馨提示" mesasge:@"确认要撤回这条消息吗？" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *alertAction) {
        
        [MBProgressHUD showActivityMessageInWindow:@""];
        [SFExpenseHttpModel deleteExpense:self.smodel._id success:^{
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:@"撤回成功"];
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:@"撤回失败"];
        }];
        
    } cancleHandler:^(UIAlertAction *alertAction) {
        
    } viewController:self];
    
}

@end
