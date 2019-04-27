//
//  SFAttendanceMgrViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttendanceMgrViewController.h"
#import "SFAttenDateilViewController.h"
#import "SFAttendanceMgrHttpModel.h"
#import "SFAttentionTableCell.h"
#import "SFPickerView.h"

static NSString * const SFAttentionTableCellID = @"SFAttentionTableCellID";

@interface SFAttendanceMgrViewController ()<UITableViewDelegate,UITableViewDataSource,SFPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIView *statueView;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (weak, nonatomic) IBOutlet UIButton *approvalButton;
@property (weak, nonatomic) IBOutlet UIButton *senderButton;
@property (weak, nonatomic) IBOutlet UIButton *giveButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *overtimeButton;
@property (weak, nonatomic) IBOutlet UIButton *leaveButton;
@property (weak, nonatomic) IBOutlet UIButton *gooutButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;

@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLayoutX;

@property (nonatomic, strong) NSMutableArray *managerArray1;
@property (nonatomic, strong) NSMutableArray *managerArray2;
@property (nonatomic, strong) NSMutableArray *managerArray3;

@property (nonatomic, strong) NSMutableArray *approvalArray1;
@property (nonatomic, strong) NSMutableArray *approvalArray2;
@property (nonatomic, strong) NSMutableArray *approvalArray3;

@property (nonatomic, strong) NSMutableArray *copListArray1;
@property (nonatomic, strong) NSMutableArray *copListArray2;
@property (nonatomic, strong) NSMutableArray *copListArray3;

@property (nonatomic, assign) ApprovalType type;
@property (nonatomic, assign) ApprovalListType atype;

@property (nonatomic, assign) NSInteger managerPage1;
@property (nonatomic, assign) NSInteger managerPage2;
@property (nonatomic, assign) NSInteger managerPage3;
@property (nonatomic, copy) NSString *managerAuditStatus1;
@property (nonatomic, copy) NSString *managerAuditStatus2;
@property (nonatomic, copy) NSString *managerAuditStatus3;


@property (nonatomic, assign) NSInteger approvalPage1;
@property (nonatomic, assign) NSInteger approvalPage2;
@property (nonatomic, assign) NSInteger approvalPage3;
@property (nonatomic, copy) NSString *approvalAuditStatus1;
@property (nonatomic, copy) NSString *approvalAuditStatus2;
@property (nonatomic, copy) NSString *approvalAuditStatus3;


@property (nonatomic, assign) NSInteger copyListPage1;
@property (nonatomic, assign) NSInteger copyListPage2;
@property (nonatomic, assign) NSInteger copyListPage3;

@end

@implementation SFAttendanceMgrViewController

- (NSMutableArray *)managerArray1{
    
    if (!_managerArray1) {
        _managerArray1 = [NSMutableArray array];
    }
    return _managerArray1;
}

- (NSMutableArray *)managerArray2{
    
    if (!_managerArray2) {
        _managerArray2 = [NSMutableArray array];
    }
    return _managerArray2;
}

- (NSMutableArray *)managerArray3{
    
    if (!_managerArray3) {
        _managerArray3 = [NSMutableArray array];
    }
    return _managerArray3;
}

- (NSMutableArray *)approvalArray1{
    
    if (!_approvalArray1) {
        _approvalArray1 = [NSMutableArray array];
    }
    return _approvalArray1;
}

- (NSMutableArray *)approvalArray2{
    
    if (!_approvalArray2) {
        _approvalArray2 = [NSMutableArray array];
    }
    return _approvalArray2;
}

- (NSMutableArray *)approvalArray3{
    
    if (!_approvalArray3) {
        _approvalArray3 = [NSMutableArray array];
    }
    return _approvalArray3;
}

- (NSMutableArray *)copListArray1{
    
    if (!_copListArray1) {
        _copListArray1 = [NSMutableArray array];
    }
    return _copListArray1;
}

- (NSMutableArray *)copListArray2{
    
    if (!_copListArray2) {
        _copListArray2 = [NSMutableArray array];
    }
    return _copListArray2;
}

- (NSMutableArray *)copListArray3{
    
    if (!_copListArray3) {
        _copListArray3 = [NSMutableArray array];
    }
    return _copListArray3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"考勤管理";
    [self setDrawUI];
    
    [self requestManger];
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
    
    self.selectLabel.text = text;
    
    if ([text isEqualToString:@"全部"]) {
        
        if (self.atype == MySend) {
            
            [self initApprovalType:@""];
        }
        if (self.atype == Manager) {
            
            [self initManagerType:@""];
        }
    }
    if ([text isEqualToString:@"待审批"]) {
        if (self.atype == MySend) {
        
            [self initApprovalType:@"UNAUDITED"];
        }
        if (self.atype == Manager) {

            [self initManagerType:@"UNAUDITED"];
        }
    }
    if ([text isEqualToString:@"已审批"]) {
        if (self.atype == MySend) {
            
            [self initApprovalType:@"APPROVED"];
        }
        if (self.atype == Manager) {
            
           [self initManagerType:@"APPROVED"];
        }
    }
    if ([text isEqualToString:@"已通过"]) {
        if (self.atype == MySend) {

            [self initApprovalType:@"PASS"];
        }
        if (self.atype == Manager) {
            
            [self initManagerType:@"PASS"];
        }
    }
    if ([text isEqualToString:@"未通过"]) {
        if (self.atype == MySend) {
        
            [self initApprovalType:@"UNPASS"];
        }
        if (self.atype == Manager) {
            
            [self initManagerType:@"UNPASS"];
        }
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)initManagerType:(NSString *)status{
    switch (self.type) {
        case LEAVE:
            self.managerAuditStatus1 = status;
            break;
        case BUSINESS_TRAVEL:
            self.managerAuditStatus2 = status;
            break;
        case OVERTIME:
            self.managerAuditStatus3 = status;
            break;
        default:
            break;
    }
}

- (void)initApprovalType:(NSString *)status{
    switch (self.type) {
        case LEAVE:
            self.approvalAuditStatus1 = status;
            break;
        case BUSINESS_TRAVEL:
            self.approvalAuditStatus2 = status;
            break;
        case OVERTIME:
            self.approvalAuditStatus3 = status;
            break;
        default:
            break;
    }
}

- (void)headerLoading {
    
    if ( self.atype == Manager ) {
        if (self.type == LEAVE) {
            
            self.managerPage1 = 1;
        }
        if (self.type == BUSINESS_TRAVEL) {
            
            self.managerPage2 = 1;
        }
        if (self.type == OVERTIME) {
            
            self.managerPage3 = 1;
        }
        [self requestManger];
    }
    if ( self.atype == MySend ) {
        if (self.type == LEAVE) {
            
            self.approvalPage1 = 1;
        }
        if (self.type == BUSINESS_TRAVEL) {
            
            self.approvalPage2 = 1;
        }
        if (self.type == OVERTIME) {
            
            self.approvalPage3 = 1;
        }
        [self requestMyApproval];
    }
    if ( self.atype == CopyList ) {
       
        if (self.type == LEAVE) {
            
            self.copyListPage1 = 1;
        }
        if (self.type == BUSINESS_TRAVEL) {
            
            self.copyListPage2 = 1;
        }
        if (self.type == OVERTIME) {
            
            self.copyListPage3 = 1;
        }
        [self requesCopyList];
    }
}

- (void)footerLoading {
    
    if ( self.atype == Manager ) {
        
        if (self.type == LEAVE) {
           self.managerPage1 ++;
        }
        if (self.type == BUSINESS_TRAVEL) {
            self.managerPage2 ++;
        }
        if (self.type == OVERTIME) {
            self.managerPage3 ++;
        }
        [self requestManger];
    }
    if ( self.atype == MySend ) {
        
        if (self.type == LEAVE) {
            
            self.approvalPage1 ++;
        }
        if (self.type == BUSINESS_TRAVEL) {
            
            self.approvalPage2 ++;
        }
        if (self.type == OVERTIME) {
            
            self.approvalPage3 ++;
        }
        [self requestMyApproval];
    }
    if ( self.atype == CopyList ) {
        
        if (self.type == LEAVE) {
            
            self.copyListPage1 ++;
        }
        if (self.type == BUSINESS_TRAVEL) {
            
            self.copyListPage2 ++;
        }
        if (self.type == OVERTIME) {
            
            self.copyListPage3 ++;
        }
        [self requesCopyList];
    }
}

- (void)requestManger{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    [dict setValue:@"15" forKey:@"pageSize"];
    
    if (self.atype == Manager && self.type == LEAVE) {
        if (![self.managerAuditStatus1 isEqualToString:@""]) {
            [dict setValue:self.managerAuditStatus1 forKey:@"auditStatus"];
        }
    }
    if (self.atype == Manager && self.type == BUSINESS_TRAVEL) {
        if (![self.managerAuditStatus2 isEqualToString:@""]) {
            [dict setValue:self.managerAuditStatus2 forKey:@"auditStatus"];
        }
    }
    if (self.atype == Manager && self.type == OVERTIME) {
        if (![self.managerAuditStatus3 isEqualToString:@""]) {
            [dict setValue:self.managerAuditStatus3 forKey:@"auditStatus"];
        }
    }
    
    
    if (self.type == LEAVE) {
        [dict setValue:@(self.managerPage1) forKey:@"pageNum"];
        [dict setValue:@"LEAVE" forKey:@"applicationType"];
    }
    if (self.type == BUSINESS_TRAVEL) {
        [dict setValue:@(self.managerPage2) forKey:@"pageNum"];
        [dict setValue:@"BUSINESS_TRAVEL" forKey:@"applicationType"];
    }
    if (self.type == OVERTIME) {
        [dict setValue:@(self.managerPage3) forKey:@"pageNum"];
        [dict setValue:@"OVERTIME" forKey:@"applicationType"];
    }
    
    NSLog(@"%@",dict);
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFAttendanceMgrHttpModel getMyManager:dict success:^(NSArray<BusinessTripLeaveOvertimeModel *> * _Nonnull list) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        if (self.type == LEAVE) {
            [self.managerArray1 removeAllObjects];
            
            [self.managerArray1 addObjectsFromArray:list];
        }
        if (self.type == BUSINESS_TRAVEL) {
            [self.managerArray2 removeAllObjects];
            
            [self.managerArray2 addObjectsFromArray:list];
        }
        if (self.type == OVERTIME) {
            [self.managerArray3 removeAllObjects];
            
            [self.managerArray3 addObjectsFromArray:list];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
    }];
}

- (void)requestMyApproval{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    [dict setValue:@"15" forKey:@"pageSize"];
    if (self.atype == MySend && self.type == LEAVE) {
        if (![self.approvalAuditStatus1 isEqualToString:@""]) {
            [dict setValue:self.approvalAuditStatus1 forKey:@"auditStatus"];
        }
    }
    if (self.atype == MySend && self.type == BUSINESS_TRAVEL) {
        if (![self.approvalAuditStatus2 isEqualToString:@""]) {
            [dict setValue:self.approvalAuditStatus2 forKey:@"auditStatus"];
        }
    }
    if (self.atype == MySend && self.type == OVERTIME) {
        if (![self.approvalAuditStatus3 isEqualToString:@""]) {
            [dict setValue:self.approvalAuditStatus3 forKey:@"auditStatus"];
        }
    }
    
    if (self.type == LEAVE) {
        [dict setValue:@(self.approvalPage1) forKey:@"pageNum"];
        [dict setValue:@"LEAVE" forKey:@"applicationType"];
    }
    if (self.type == BUSINESS_TRAVEL) {
        [dict setValue:@(self.approvalPage2) forKey:@"pageNum"];
        [dict setValue:@"BUSINESS_TRAVEL" forKey:@"applicationType"];
    }
    if (self.type == OVERTIME) {
        [dict setValue:@(self.approvalPage3) forKey:@"pageNum"];
        [dict setValue:@"OVERTIME" forKey:@"applicationType"];
    }
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFAttendanceMgrHttpModel getMyApproval:dict success:^(NSArray<BusinessTripLeaveOvertimeModel *> * _Nonnull list) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        if (self.type == LEAVE) {
            [self.approvalArray1 removeAllObjects];
            [self.approvalArray1 addObjectsFromArray:list];
        }
        if (self.type == BUSINESS_TRAVEL) {
            [self.approvalArray2 removeAllObjects];
            [self.approvalArray2 addObjectsFromArray:list];
        }
        if (self.type == OVERTIME) {
            [self.approvalArray3 removeAllObjects];
            [self.approvalArray3 addObjectsFromArray:list];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)requesCopyList{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    
    [dict setValue:@"15" forKey:@"pageSize"];

    if (self.type == LEAVE) {
        [dict setValue:@(self.copyListPage1) forKey:@"pageNum"];
        [dict setValue:@"LEAVE" forKey:@"applicationType"];
    }
    if (self.type == BUSINESS_TRAVEL) {
        [dict setValue:@(self.copyListPage2) forKey:@"pageNum"];
        [dict setValue:@"BUSINESS_TRAVEL" forKey:@"applicationType"];
    }
    if (self.type == OVERTIME) {
        [dict setValue:@(self.copyListPage3) forKey:@"pageNum"];
        [dict setValue:@"OVERTIME" forKey:@"applicationType"];
    }
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFAttendanceMgrHttpModel getMyCopyList:dict success:^(NSArray<BusinessTripLeaveOvertimeModel *> * _Nonnull list) {
        [MBProgressHUD hideHUD];
        if (self.type == LEAVE) {
           
            [self.copListArray1 removeAllObjects];
            [self.copListArray1 addObjectsFromArray:list];
        }
        if (self.type == BUSINESS_TRAVEL) {
            [self.copListArray2 removeAllObjects];
            [self.copListArray2 addObjectsFromArray:list];
        }
        if (self.type == OVERTIME) {
            
            [self.copListArray3 removeAllObjects];
            [self.copListArray3 addObjectsFromArray:list];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    self.atype = Manager;
    self.type = LEAVE;
    self.managerPage1 = 1;
    self.managerPage2 = 1;
    self.managerPage3 = 1;
    
    self.approvalPage1 = 1;
    self.approvalPage2 = 1;
    self.approvalPage3 = 1;
    
    self.copyListPage1 = 1;
    self.copyListPage2 = 1;
    self.copyListPage3 = 1;
    
    self.managerAuditStatus1 = @"";
    self.managerAuditStatus2 = @"";
    self.managerAuditStatus3 = @"";
    
    self.approvalAuditStatus1 = @"";
    self.approvalAuditStatus2 = @"";
    self.approvalAuditStatus3 = @"";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = bgColor;
    
    [_tableView registerNib:[UINib nibWithNibName:@"SFAttentionTableCell" bundle:nil] forCellReuseIdentifier:SFAttentionTableCellID];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerLoading)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoading)];
    
    @weakify(self)
    [[self.approvalButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.atype = Manager;
        self.tableViewLayoutTop.constant = 0;
        self.lineViewLayoutX.constant = 0;
        [self selectStatueBtn:x];
        [self initRequestData];
    }];
    [[self.senderButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.atype = MySend;
        self.tableViewLayoutTop.constant = 0;
        self.lineViewLayoutX.constant = kWidth/3;
        [self selectStatueBtn:x];
        [self initRequestData];
    }];
    [[self.giveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.atype = CopyList;
        self.tableViewLayoutTop.constant = -50;
        self.lineViewLayoutX.constant = kWidth/3*2;
        [self selectStatueBtn:x];
        [self initRequestData];
    }];
    
    [[self.overtimeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.type = OVERTIME;
        [self selectTypeBtn:x];
        [self initRequestData];
        
    }];
    [[self.leaveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.type = LEAVE;
        [self selectTypeBtn:x];
        [self initRequestData];
        
    }];
    [[self.gooutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.type = BUSINESS_TRAVEL;
        [self selectTypeBtn:x];
        [self initRequestData];
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self customArr:@[@"全部",@"待审批",@"已审批",@"已通过",@"未通过"] withRow:0];
    }];
    [self.selectView addGestureRecognizer:tapGesture];
}

- (void)initRequestData {
    
    if (self.atype == Manager && self.type == LEAVE) {
        self.selectLabel.text = [self.managerAuditStatus1 isEqualToString:@""]?
        @"全部": [self.managerAuditStatus1 isEqualToString:@"PASS"]?
        @"已通过": [self.managerAuditStatus1 isEqualToString:@"UNPASS"]?
        @"未通过": [self.managerAuditStatus1 isEqualToString:@"UNAUDITED"]?
        @"待审批":@"已审批";
        
    }
    if (self.atype == Manager && self.type == BUSINESS_TRAVEL) {
        self.selectLabel.text = [self.managerAuditStatus2 isEqualToString:@""]?
        @"全部": [self.managerAuditStatus2 isEqualToString:@"PASS"]?
        @"已通过": [self.managerAuditStatus2 isEqualToString:@"UNPASS"]?
        @"未通过": [self.managerAuditStatus2 isEqualToString:@"UNAUDITED"]?
        @"待审批":@"已审批";
    }
    if (self.atype == Manager && self.type == OVERTIME) {
        self.selectLabel.text = [self.managerAuditStatus3 isEqualToString:@""]?
        @"全部": [self.managerAuditStatus3 isEqualToString:@"PASS"]?
        @"已通过": [self.managerAuditStatus3 isEqualToString:@"UNPASS"]?
        @"未通过": [self.managerAuditStatus3 isEqualToString:@"UNAUDITED"]?
        @"待审批":@"已审批";
    }
    
    if (self.atype == MySend && self.type == LEAVE) {
        self.selectLabel.text = [self.approvalAuditStatus1 isEqualToString:@""]?
        @"全部": [self.approvalAuditStatus1 isEqualToString:@"PASS"]?
        @"已通过": [self.approvalAuditStatus1 isEqualToString:@"UNPASS"]?
        @"未通过": [self.approvalAuditStatus1 isEqualToString:@"UNAUDITED"]?
        @"待审批":@"已审批";
    }
    if (self.atype == MySend && self.type == BUSINESS_TRAVEL) {
        self.selectLabel.text = [self.approvalAuditStatus2 isEqualToString:@""]?
        @"全部": [self.approvalAuditStatus2 isEqualToString:@"PASS"]?
        @"已通过": [self.approvalAuditStatus2 isEqualToString:@"UNPASS"]?
        @"未通过": [self.approvalAuditStatus2 isEqualToString:@"UNAUDITED"]?
        @"待审批":@"已审批";
    }
    if (self.atype == MySend && self.type == OVERTIME) {
        self.selectLabel.text = [self.approvalAuditStatus3 isEqualToString:@""]?
        @"全部": [self.approvalAuditStatus3 isEqualToString:@"PASS"]?
        @"已通过": [self.approvalAuditStatus3 isEqualToString:@"UNPASS"]?
        @"未通过": [self.approvalAuditStatus3 isEqualToString:@"UNAUDITED"]?
        @"待审批":@"已审批";
    }

    
    if ( self.atype == Manager ) {
        if (self.type == OVERTIME && self.managerArray3.count > 0) return;
        if (self.type == BUSINESS_TRAVEL && self.managerArray2.count > 0) return;
        if (self.type == LEAVE && self.managerArray1.count > 0) return;
        [self requestManger];
    }
    if ( self.atype == MySend) {
        if (self.type == OVERTIME && self.approvalArray3.count > 0) return;
        if (self.type == BUSINESS_TRAVEL && self.approvalArray2.count > 0) return;
        if (self.type == LEAVE && self.approvalArray1.count > 0) return;
        [self requestMyApproval];
    }
    if ( self.atype == CopyList ) {
        if (self.type == OVERTIME && self.copListArray3.count > 0) return;
        if (self.type == BUSINESS_TRAVEL && self.copListArray2.count > 0) return;
        if (self.type == LEAVE && self.copListArray1.count > 0) return;
        [self requesCopyList];
    }
    
}

- (void)selectStatueBtn:(UIButton *)sender{
    
    for (int i = 1000; i < 1003; i ++) {
        UIButton * button = [self.statueView viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
    [self.tableView reloadData];
}

- (void)selectTypeBtn:(UIButton *)sender{
    
    for (int i = 2000; i < 2003; i ++) {
        UIButton * button = [self.typeView viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
    [self.tableView reloadData];
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
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 45)];
    NSString * title = self.type == OVERTIME ? @"加班列表":self.type == LEAVE ? @"请假列表" : @"出差列表";
    UILabel * titleLabel = [UILabel createALabelText:title withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#666666")];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(15);
        make.centerY.equalTo(headerView);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.atype == MySend) {
        if (self.type == LEAVE) return self.approvalArray1.count;
        if (self.type == OVERTIME) return self.approvalArray3.count;
        if (self.type == BUSINESS_TRAVEL) return self.approvalArray2.count;
    }
    if (self.atype == Manager) {
        if (self.type == LEAVE) return self.managerArray1.count;
        if (self.type == OVERTIME) return self.managerArray3.count;
        if (self.type == BUSINESS_TRAVEL) return self.managerArray2.count;
    }
    if (self.type == LEAVE) return self.copListArray1.count;
    if (self.type == OVERTIME) return self.copListArray3.count;
    return self.copListArray2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFAttentionTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAttentionTableCellID forIndexPath:indexPath];
    if (self.atype == MySend) {
        
        BusinessTripLeaveOvertimeModel * model = self.type == LEAVE ?
        self.approvalArray1[indexPath.row]: self.type == OVERTIME ?
        self.approvalArray3[indexPath.row]:self.approvalArray2[indexPath.row];
        cell.model = model;
        cell.statueLabel.text = [model.auditStatus isEqualToString:@"PASS"]?
        @"已通过":[model.auditStatus isEqualToString:@"UNPASS"]?
        @"未通过":[model.auditStatus isEqualToString:@"UNAUDITED"]?
        @"待审批":@"已审批";
        
        cell.statueLabel.textColor = [model.auditStatus isEqualToString:@"PASS"]?
        Color(@"#999999"):[model.auditStatus isEqualToString:@"UNPASS"]?
        Color(@"#FF715A"):[model.auditStatus isEqualToString:@"UNAUDITED"]?
        Color(@"#01B38B"):Color(@"#999999");
    }
    if (self.atype == Manager) {
        BusinessTripLeaveOvertimeModel * model = self.type == LEAVE ?
        self.managerArray1[indexPath.row]: self.type == OVERTIME ?
        self.managerArray3[indexPath.row]:self.managerArray2[indexPath.row];
        cell.model = model;
        cell.statueLabel.text = [model.applicationStatus isEqualToString:@"PASS"]?
        @"已通过":[model.applicationStatus isEqualToString:@"UNPASS"]?
        @"未通过":[model.applicationStatus isEqualToString:@"UNAUDITED"]?
        @"待审批":@"已审批";
        cell.statueLabel.textColor = [model.applicationStatus isEqualToString:@"PASS"]?
        Color(@"#999999"):[model.applicationStatus isEqualToString:@"UNPASS"]?
        Color(@"#FF715A"):[model.applicationStatus isEqualToString:@"UNAUDITED"]?
        Color(@"#01B38B"):Color(@"#999999");
    }
    if (self.atype == CopyList) {
        BusinessTripLeaveOvertimeModel * model = self.type == LEAVE ?
        self.copListArray1[indexPath.row]: self.type == OVERTIME ?
        self.copListArray3[indexPath.row]:self.copListArray2[indexPath.row];
        cell.model = model;
        cell.statueLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.atype == MySend) {
        
        BusinessTripLeaveOvertimeModel * model = self.type == LEAVE ?
        self.approvalArray1[indexPath.row]: self.type == LEAVE ?
        self.approvalArray3[indexPath.row]:self.approvalArray2[indexPath.row];
        SFAttenDateilViewController * vc = [SFAttenDateilViewController new];
        vc.model = model;
        vc.type = self.atype;
        vc.atype = self.type;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (self.atype == Manager) {
        BusinessTripLeaveOvertimeModel * model = self.type == LEAVE ?
        self.managerArray1[indexPath.row]: self.type == LEAVE ?
        self.managerArray3[indexPath.row]:self.managerArray2[indexPath.row];
        SFAttenDateilViewController * vc = [SFAttenDateilViewController new];
        vc.model = model;
        vc.type = self.atype;
        vc.atype = self.type;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (self.atype == CopyList) {
        BusinessTripLeaveOvertimeModel * model = self.type == LEAVE ?
        self.copListArray1[indexPath.row]: self.type == LEAVE ?
        self.copListArray3[indexPath.row]:self.copListArray2[indexPath.row];
        SFAttenDateilViewController * vc = [SFAttenDateilViewController new];
        vc.model = model;
        vc.type = self.atype;
        vc.atype = self.type;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

@end
