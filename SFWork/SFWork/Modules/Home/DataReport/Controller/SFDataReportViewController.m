//
//  SFDataReportViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFDataReportViewController.h"
#import "SFReportHistoryViewController.h"
#import "SFDataReportHttpModel.h"
#import "SFDataReportCell.h"
static NSString * const SFDataReportCellID = @"SFDataReportCellID";
@interface SFDataReportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) SFTemplateModel *model;
@property (nonatomic, strong) SFTipDesView *tipDesView;
@end

@implementation SFDataReportViewController

- (SFTipDesView *)tipDesView{
    
    if (!_tipDesView) {
        _tipDesView = [SFTipDesView shareSFTipDesView];
    }
    return _tipDesView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据填写";
    
    [self setDrawUI];
    
    [self requestData];
}

- (void)requestData {
    
    [SFDataReportHttpModel getDirectlyEmployeeReportSuccess:^(SFTemplateModel * _Nonnull model) {
        
        self.model = model;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:model.items];
        [self.tableView reloadData];
        
        if ([model.status isEqualToString:@"UNREAD"] || [model.status isEqualToString:@"READ"] || model.status == nil) {
            [self.saveButton setTitle:@"提交" forState:UIControlStateNormal];
            self.saveButton.backgroundColor = Color(@"#01B38B");
        }else{
            [self.saveButton setTitle:@"撤回" forState:UIControlStateNormal];
            self.saveButton.backgroundColor = Color(@"#FF715A");
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
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(self.view);
        make.top.equalTo(self.tipDesView.mas_bottom);
        make.bottom.equalTo(self.saveButton.mas_top);
    }];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFDataReportCell * cell = [tableView dequeueReusableCellWithIdentifier:SFDataReportCellID forIndexPath:indexPath];
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFDataReportCell" bundle:nil] forCellReuseIdentifier:SFDataReportCellID];
        
    }
    return _tableView;
}


- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"历史记录" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            SFReportHistoryViewController * vc = [SFReportHistoryViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _rightButton;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"提交" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#01B38B");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            if ([self.saveButton.titleLabel.text isEqualToString:@"撤回"]) {
                
                [self recallData];
            }else{
                [self saveData];
            }
            
        }];
    }
    return _saveButton;
}

- (void)recallData{
    
    [SFDataReportHttpModel recallDataReport:self.model.id success:^{
        
        [MBProgressHUD showSuccessMessage:@"撤回成功"];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showSuccessMessage:@"撤回失败"];
    }];
}

- (void)saveData {
    
    NSMutableArray * array = [NSMutableArray array];
    for (ItemsModel * item in self.dataArray) {
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:item.templateItemId forKey:@"templateItemId"];
        [dict setValue:item.value forKey:@"value"];
        [array addObject:dict];
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:array forKey:@"items"];
    [dict setValue:self.model.templateId forKey:@"templateId"];
    if (self.model.id) {
        [dict setValue:self.model.id forKey:@"id"];
    }
    [MBProgressHUD showActivityMessageInView:@""];
    [SFDataReportHttpModel submitDataReport:dict success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"提交成功"];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"提交失败"];
    }];
}

@end
