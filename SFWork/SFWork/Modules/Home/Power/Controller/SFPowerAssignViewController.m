//
//  SFPowerAssignViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPowerAssignViewController.h"
#import "SFPowerHttpModel.h"
#import "SFPowerAssignCell.h"
#import "SFAllPowerCell.h"
#import "SFPowerModel.h"

static NSString * const SFPowerAssignCellID = @"SFPowerAssignCellID";
static NSString * const SFAllPowerCellID = @"SFAllPowerCellID";


@interface SFPowerAssignViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UIButton * saveButton;
@property (nonatomic, strong) EmpPermissionModel *pmodel;
@property (nonatomic, strong) NSArray *addArray;
@end

@implementation SFPowerAssignViewController

- (NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"基础权限（基层员工都有的）",@"财务权限",@"行政权限",@"高级权限", nil];
    }
    return _titleArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"权限分配";
    
    [self initDrawUI];
    if (self.model) {
        [self initData];
    }else{
        [self addInitData];
    }
}

- (void)addInitData {
    
    [SFPowerHttpModel getDefaultPermission:self.type success:^(NSArray<PermissionsModel *> * _Nonnull list) {
        
        self.addArray = list;
        [self.dataArray removeAllObjects];
        NSArray * allArr = [SFPowerModel sharePowerListModel];
        
        for (NSArray * arr in allArr) {
            
            for (SFPowerModel * mod in arr) {
                
                for (PermissionsModel * pmod in list) {
                    
                    if ([pmod.code isEqualToString:mod.code]) {
                        mod.hasPermission = pmod.hasPermission;
                        mod.title = pmod.name;
                        mod.code = pmod.code;
                    }
                }
            }
        }
        [self.dataArray addObjectsFromArray: allArr];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)initData {
    
    [SFPowerHttpModel getPermissionListsPid:self.model._id success:^(EmpPermissionModel * _Nonnull model) {
        
        self.pmodel = model;
        [self.dataArray removeAllObjects];
        NSArray * allArr = [SFPowerModel sharePowerListModel];
    
        for (NSArray * arr in allArr) {
            
            for (SFPowerModel * mod in arr) {
                
                for (PermissionsModel * pmod in model.permissions) {
                    
                    if ([pmod.code isEqualToString:mod.code]) {
                        mod.hasPermission = pmod.hasPermission;
                        mod.title = pmod.name;
                        mod.code = pmod.code;
                    }
                }
            }
        }
        [self.dataArray addObjectsFromArray: allArr];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

-(void)initDrawUI {
    

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self.view);
        make.height.offset(43);
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 10;
    }
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return [UIView new];
    }
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 45)];
    
    UILabel * titleLabel = [UILabel createALabelText:self.titleArray[section-1] withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#999999")];
    [header addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left).offset(15);
        make.right.equalTo(header.mas_right).offset(-15);
        make.top.equalTo(header.mas_top).offset(20);
        
    }];
    return header;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 45;
    }
    return 67;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
    NSArray * array = self.dataArray[section-1];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SFAllPowerCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAllPowerCellID forIndexPath:indexPath];
        @weakify(self)
        [cell setSelectAllClick:^(BOOL isSelect) {
            @strongify(self)
            [self selectPermission:isSelect];
        }];
        return cell;
    }
    SFPowerAssignCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPowerAssignCellID forIndexPath:indexPath];
    NSArray * array = self.dataArray[indexPath.section-1];
    SFPowerModel * model = array[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)selectPermission:(BOOL)isSelect{
    
    for (NSArray * arr in self.dataArray) {
        
        for (SFPowerModel * model in arr) {
            
            model.hasPermission = isSelect;
        }
    }
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFPowerAssignCell" bundle:nil] forCellReuseIdentifier:SFPowerAssignCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFAllPowerCell" bundle:nil] forCellReuseIdentifier:SFAllPowerCellID];
       
    }
    return _tableView;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.backgroundColor = Color(@"#01B38B");
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            if (self.model) {
                NSMutableDictionary * dict = [self saveSetAllSelect];
                [self saveData:dict];
            }else{
                NSArray * array = [self saveAddAllSelect];
                !self.selectAllClick?:self.selectAllClick(array);
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }];
    }
    return _saveButton;
}

- (void)saveData:(NSMutableDictionary *)dict{
    [dict removeObjectForKey:@"createTime"];
    [dict removeObjectForKey:@"endTime"];
    [dict removeObjectForKey:@"employeeName"];
    [dict removeObjectForKey:@"departmentName"];
    [dict removeObjectForKey:@"permissionIds"];
    [dict removeObjectForKey:@"startTime"];
    [dict removeObjectForKey:@"typeName"];
    NSLog(@"dict ====== %@",dict);
    
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFPowerHttpModel addPermissioneUser:dict success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"授权成功"];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"授权失败"];
    }];
}

- (NSArray *)saveAddAllSelect{
    
    //遍历获取
    for (NSArray * array in self.dataArray) {
        
        for (SFPowerModel * mod in array) {
            
            for (PermissionsModel * pmod in self.addArray) {
                
                if ([mod.code isEqualToString:pmod.code]) {
                    pmod.hasPermission = mod.hasPermission;
                }
            }
        }
    }
    
    NSArray * array = [NSString arrayOrDicWithObject:self.addArray];
    NSLog(@"%@",array);
    return array;
}

- (NSMutableDictionary *)saveSetAllSelect{
    
    //遍历获取
    for (NSArray * array in self.dataArray) {
        
        for (SFPowerModel * mod in array) {
            
            for (PermissionsModel * pmod in self.pmodel.permissions) {
                
                if ([mod.code isEqualToString:pmod.code]) {
                    pmod.hasPermission = mod.hasPermission;
                }
            }
        }
    }
    
    NSMutableDictionary * dic = [NSString dicFromObject:self.pmodel].mutableCopy;
    
    return dic;
}

@end
