//
//  SFPrivateListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPrivateListViewController.h"
#import "SFAllEmployeeViewController.h"
#import "SFCustomerHttpModel.h"
#import "SFCustomerCell.h"

static NSString * const SFCustomerCellID = @"SFCustomerCellID";
@interface SFPrivateListViewController ()<UITableViewDelegate,UITableViewDataSource,SFAllEmployeeViewControllerDelagete>

@property (weak, nonatomic) IBOutlet UIButton *pribussButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLayoutX;

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *pricomButtom;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray * depArray;
@property (nonatomic,strong) NSMutableArray * myArray;
//客户
@property (nonatomic, copy) NSString *usercName;
//商家
@property (nonatomic, copy) NSString *userbName;
@property (nonatomic, assign) BOOL isDev;

@end

@implementation SFPrivateListViewController

- (NSMutableArray *)depArray {
    
    if (!_depArray) {
        
        _depArray = [NSMutableArray array];
    }
    return _depArray;
}

- (NSMutableArray *)myArray {
    
    if (!_myArray) {
        
        _myArray = [NSMutableArray array];
    }
    return _myArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
}

- (void)setDrawUI {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.isDev = YES;
    self.usercName = @"请选择";
    self.userbName = @"请选择";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = bgColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFCustomerCell" bundle:nil] forCellReuseIdentifier:SFCustomerCellID];
    
    @weakify(self)
    [[self.pricomButtom rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.isDev = YES;
        [self selectButton:x];
        self.lineViewLayoutX.constant = 0;
    }];
    
    [[self.pribussButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.isDev = NO;
        [self selectButton:x];
        self.lineViewLayoutX.constant = kWidth/2;
    }];
}

- (void)selectButton:(UIButton *)sender{
    
    for (int i = 1000; i < 1002; i ++) {
        
        UIButton * button = [self.selectView viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 45;
    }
    return 60;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
    return self.isDev ? self.depArray.count : self.myArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SFCustomerCell * cell = [tableView dequeueReusableCellWithIdentifier:SFCustomerCellID forIndexPath:indexPath];
        cell.areaLabel.text = self.isDev ? self.usercName : self.userbName;
        return cell;
    }
    SFCustomerCell * cell = [tableView dequeueReusableCellWithIdentifier:SFCustomerCellID forIndexPath:indexPath];
    SFClientModel * model = self.isDev ? self.depArray[indexPath.row] : self.myArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        
        SFAllEmployeeViewController * vc = [NSClassFromString(@"SFAllEmployeeViewController") new];
        vc.delagete = self;
        vc.type = singleType;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        SFClientModel * model = self.isDev ? self.depArray[indexPath.row] : self.myArray[indexPath.row];
        UIViewController * vc = [NSClassFromString(@"SFCBDateilViewController") new];
        [vc setValue:@(0) forKey:@"type"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma SFAllEmployeeViewController
- (void)singleSelectEmoloyee:(SFEmployeesModel *)employee{
    
    [self getData:employee._id];
    if (self.isDev) {
        self.usercName = employee.name;
    }else{
        self.userbName = employee.name;
    }
    
}

- (void)getData:(NSString *)userId{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:userId forKey:@"belongToWhoID"];
    NSString * clientGroup = self.isDev ? @"CLIENT":@"MERCHANT";
    [dict setValue:clientGroup forKey:@"clientGroup"];
    [SFCustomerHttpModel getPrivateClient:dict success:^(NSArray<SFClientModel *> * _Nonnull list) {
        
        if (self.isDev) {
            [self.depArray addObjectsFromArray:list];
        }else{
            [self.myArray addObjectsFromArray:list];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
