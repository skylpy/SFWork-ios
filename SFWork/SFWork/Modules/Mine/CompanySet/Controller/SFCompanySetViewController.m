//
//  SFCompanySetViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFCompanySetViewController.h"
#import "SFCompanySetCell.h"
#import "SFMineModel.h"

static NSString * const SFCompanySetCellID = @"SFCompanySetCellID";

@interface SFCompanySetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation SFCompanySetViewController


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业设置";
    
    [self initDrawUI];
    [self initData];
}

- (void)initData{
    
    NSArray * array = [SFMineModel shareCompanySetModel];
    
    [self.dataArray addObjectsFromArray:array];
    
    [self.tableView reloadData];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array = self.dataArray[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFCompanySetCell * cell = [tableView dequeueReusableCellWithIdentifier:SFCompanySetCellID forIndexPath:indexPath];
    NSArray * array = self.dataArray[indexPath.section];
    SFMineModel * model = array[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * array = self.dataArray[indexPath.section];
    SFMineModel * model = array[indexPath.row];
    if ([model.title isEqualToString:@"客户类型"]
        ||[model.title isEqualToString:@"意向类型"]
        ||[model.title isEqualToString:@"职位类型"]
        ||[model.title isEqualToString:@"拍照类型"]
        ||[model.title isEqualToString:@"任务类型"]
        ||[model.title isEqualToString:@"客户等级"]
        ||[model.title isEqualToString:@"请假类型"]) {
        
        NSString * type = @"";
        switch (model.type) {
            case 4:
                type = @"CLIENT_LEVEL";
                break;
            case 5:
                type = @"CLIENT_TYPE";
                break;
            case 6:
                type = @"INTENTION_TYPE";
                break;
            case 7:
                type = @"POSITION";
                break;
            case 8:
                type = @"PHOTO_TYPE";
                break;
            case 9:
                type = @"TASK_TYPE";
                break;
            case 10:
                type = @"LEAVE_TYPE";
                break;
            default:
                type = @"";
                break;
        }
        UIViewController * vc = [NSClassFromString(@"SFSetTypeViewController") new];
        [vc setValue:type forKey:@"type"];
        [vc setValue:model.title forKey:@"titles"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIViewController * vc = [NSClassFromString(model.controller) new];

        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFCompanySetCell" bundle:nil] forCellReuseIdentifier:SFCompanySetCellID];
        
    }
    return _tableView;
}


@end
