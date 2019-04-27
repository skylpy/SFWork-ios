//
//  SFReportDateilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFReportDateilViewController.h"
#import "SFReportHeaderCell.h"
#import "SFAddDataFooterView.h"
#import "SFItemCell.h"

static NSString * const SFItemCellID = @"SFItemCellID";
static NSString * const SFReportHeaderCellID = @"SFReportHeaderCellID";

@interface SFReportDateilViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SFAddDataFooterView * footerView;
@property (nonatomic, strong) SFTipDesView *tipDesView;
@end

@implementation SFReportDateilViewController

- (SFTipDesView *)tipDesView{
    
    if (!_tipDesView) {
        _tipDesView = [SFTipDesView shareSFTipDesView];
        _tipDesView.titleLabel.text = @"有些员工不需要参与某项考核的，可以点击忽略";
    }
    return _tipDesView;
}

- (SFAddDataFooterView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [SFAddDataFooterView shareSFAddDataFooterView];
        [_footerView.cancelButton setTitle:@"驳回" forState:UIControlStateNormal];
        [_footerView.sureButton setTitle:@"通过" forState:UIControlStateNormal];
    }
    return _footerView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人数据汇报";
    
    [self setDrawUI];
    [self checkAudit];
}

- (BOOL)navigationShouldPopOnBackButton{
    
    !self.backLastPage?:self.backLastPage();
    return YES;
}

- (void)checkAudit{
    
    [SFDataReportHttpModel checkAuditPermissions:self.model.id success:^(NSInteger result) {
        
        if (result == 1) {
            [self.view addSubview:self.footerView];
            [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.offset(50);
            }];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tipDesView];
    [self.tipDesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.offset(35);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.equalTo(self.tipDesView.mas_bottom);
        
    }];
   
    
    @weakify(self)
    [self.footerView setSureClick:^(NSInteger index) {
        @strongify(self)
        
        if (index == 0) {
            SFAlertInputView * alert=[[SFAlertInputView alloc] initWithTitle:@"驳回原因" PlaceholderText:@"请输入驳回原因" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
                NSLog(@"-----%@",contents);
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:contents forKey:@"remark"];
                [dict setValue:@"REJECT" forKey:@"status"];
                [dict setValue:self.model.id forKey:@"id"];
                [self through:dict];
            }];
            [alert show];
        }else{
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            
            [dict setValue:@"CONFIRM" forKey:@"status"];
            [dict setValue:self.model.id forKey:@"id"];
            [self through:dict];
        }
    }];
}

- (void)through:(NSDictionary *)dict{
    
    [SFDataReportHttpModel auditDataReport:dict success:^{
        
        [MBProgressHUD showInfoMessage:@"审核成功"];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showInfoMessage:@"审核失败"];
    }];
}

- (void)setModel:(SFTemplateModel *)model{
    
    _model = model;
    [self.dataArray addObjectsFromArray:model.items];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 70;
    }
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SFReportHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:SFReportHeaderCellID forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }
   
    
    SFItemCell * cell = [tableView dequeueReusableCellWithIdentifier:SFItemCellID forIndexPath:indexPath];
    ItemsModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFReportHeaderCell" bundle:nil] forCellReuseIdentifier:SFReportHeaderCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFItemCell" bundle:nil] forCellReuseIdentifier:SFItemCellID];
        
    }
    return _tableView;
}

@end
