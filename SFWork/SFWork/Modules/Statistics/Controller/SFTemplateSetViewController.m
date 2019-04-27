//
//  SFTemplateSetViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTemplateSetViewController.h"
#import "SFSelectDepViewController.h"
#import "SFTemplateListCell.h"

static NSString * const SFTemplateListCellID = @"SFTemplateListCellID";

@interface SFTemplateSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFTemplateSetViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置汇报模板";
    
    [self setDrawUI];
    [self initData];
}

- (void)initData {
    
    NSDictionary * dict1 = @{@"icon":@"icon_their_department_black",@"name":@"所在部门汇报模板"};
    NSDictionary * dict2 = @{@"icon":@"icon_subordinate_department_black",@"name":@"下属部门汇报模板"};
    [self.dataArray addObject:dict1];
    [self.dataArray addObject:dict2];
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.top.left.right.equalTo(self.view);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFTemplateListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTemplateListCellID forIndexPath:indexPath];
    NSDictionary * dict = self.dataArray[indexPath.row];
    cell.dict = dict;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        UIViewController * vc = [[UIStoryboard storyboardWithName:@"SFStatistics" bundle:nil] instantiateViewControllerWithIdentifier:@"SFTemplateList"];
        [vc setValue:[SFInstance shareInstance].userInfo.departmentId forKey:@"departmentId"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SFSelectDepViewController * vc = [SFSelectDepViewController new];
        vc.type = singleDepType;
        vc.isJust = YES;
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
       
        [_tableView registerNib:[UINib nibWithNibName:@"SFTemplateListCell" bundle:nil] forCellReuseIdentifier:SFTemplateListCellID];
    }
    return _tableView;
}

@end
