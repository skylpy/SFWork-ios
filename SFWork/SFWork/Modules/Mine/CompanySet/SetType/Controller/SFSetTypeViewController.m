//
//  SFSetTypeViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSetTypeViewController.h"
#import "SFSetTypeModel.h"
#import "SFSetTypeCell.h"

static NSString * const SFSetTypeCellID = @"SFSetTypeCellID";

@interface SFSetTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UIButton * bottomButton;

@end

@implementation SFSetTypeViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titles;
    [self initData];
    [self initDrawUI];
}

- (void)initData{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    [SFSetTypeModel getCompanySetting:self.type success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.bottomButton];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(45);
        make.left.right.bottom.equalTo(self.view);
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    
    UILabel * titleLabel = [UILabel createALabelText:[NSString stringWithFormat:@"%@列表",self.titles] withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#666666")];
    [headerView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(15, 10, kWidth-30, 12);
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFSetTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSetTypeCellID forIndexPath:indexPath];
    
    SFSetTypeModel * models = self.dataArray[indexPath.row];
    cell.model = models;
    @weakify(self)
    [cell setDeleteClick:^(SFSetTypeModel * _Nonnull model) {
        @strongify(self)

        SFAlertView *alertView = [[SFAlertView alloc] initWithTitle:@"" message:@"确定要删除这条项目吗？" sureBtn:@"确认" cancleBtn:@"取消"];
        alertView.resultIndex = ^(NSInteger index){
            
            [self deleteCompanyOid:model._id];
        };
        [alertView showMKPAlertView];
    }];
    [cell setUpdateClick:^(SFSetTypeModel * _Nonnull model) {
        @strongify(self)
//        self.titles
        SFAlertInputView * alert=[[SFAlertInputView alloc]initWithTitle:[NSString stringWithFormat:@"编辑%@",self.titles] PlaceholderText:model.name WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
            NSLog(@"-----%@",contents);
            [self updateCompany:contents withOid:model._id];
        }];
        [alert show];
    }];
    return cell;
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFSetTypeCell" bundle:nil] forCellReuseIdentifier:SFSetTypeCellID];
        
        UIView * buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
        buttomView.backgroundColor = [UIColor clearColor];
        
        UIButton * deleteButtom = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButtom.frame = CGRectMake(0, 10, kWidth, 45);
        deleteButtom.backgroundColor = [UIColor whiteColor];
        [deleteButtom setTitleColor:defaultColor forState:UIControlStateNormal];
        [deleteButtom setTitle:[NSString stringWithFormat:@"新增%@",self.titles] forState:UIControlStateNormal];
        deleteButtom.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [buttomView addSubview:deleteButtom];
        _tableView.tableFooterView = buttomView;
        @weakify(self)
        [[deleteButtom rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            SFAlertInputView * alert=[[SFAlertInputView alloc]initWithTitle:[NSString stringWithFormat:@"新增%@",self.titles] PlaceholderText:@"请输入客户类型" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
                NSLog(@"-----%@",contents);
                [self addCompany:contents];
            }];
            [alert show];
            
        }];
    }
    return _tableView;
}

- (void)deleteCompanyOid:(NSString *)oid{
    
    [SFSetTypeModel deleteCompanySetting:oid success:^{
        
        [self initData];
        [MBProgressHUD showSuccessMessage:@"删除成功"];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showErrorMessage:@"删除失败"];
    }];
}

- (void)updateCompany:(NSString *)name withOid:(NSString *)oid{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:name forKey:@"name"];
    [dict setValue:oid forKey:@"id"];
    
    [SFSetTypeModel updateCompanySetting:dict success:^{
        
        [self initData];
        [MBProgressHUD showSuccessMessage:@"修改成功"];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showErrorMessage:@"修改失败"];
    }];
}


- (void)addCompany:(NSString *)name{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:name forKey:@"name"];
    [dict setValue:self.type forKey:@"type"];
    
    [SFSetTypeModel addCompanySetting:dict success:^{
        
        [self initData];
        [MBProgressHUD showSuccessMessage:@"添加成功"];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showErrorMessage:@"添加失败"];
    }];
}

@end
