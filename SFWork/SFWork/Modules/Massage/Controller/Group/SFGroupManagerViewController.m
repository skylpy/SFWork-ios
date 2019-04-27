//
//  SFGroupManagerViewController.m
//  ClassForEvery
//
//  Created by Adam on 2019/4/2.
//  Copyright © 2019年 Adam. All rights reserved.
//

#import "SFGroupManagerViewController.h"
#import "SFBannedAskViewController.h"
#import "SFChangeGroupMasterViewController.h"
#import "SFGroupSwithBtnWithTipCell.h"

@interface SFGroupManagerViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray * _titleArray;
    NSArray * _tipArray;
}
@property (strong, nonatomic) UITableView * tableView;
@end

@implementation SFGroupManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"群管理";
    [self initUI];
}

- (void)initUI{
    _titleArray = @[@"仅群主可管理",@"设置群内禁言",@"转让群主"];
    _tipArray = @[@"启用后，其他成员不能修改群名称、邀请成员"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    [_tableView registerNib:[UINib nibWithNibName:@"SFGroupSwithBtnWithTipCell" bundle:nil] forCellReuseIdentifier:@"SFGroupSwithBtnWithTipCell"];
    _tableView.tableFooterView = [self createTableFootView];
    [self.view addSubview:_tableView];
    
}

- (UIView *)createTableFootView{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45)];
    UIButton * dissolveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dissolveBtn.frame = footView.bounds;
    [dissolveBtn setTitle:@"解散群聊" forState:0];
    [dissolveBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:113/255.0 blue:90/255.0 alpha:1.0] forState:0];
    dissolveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    dissolveBtn.backgroundColor = [UIColor whiteColor];
    [dissolveBtn addTarget:self action:@selector(deleteGroupChat) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:dissolveBtn];
    return footView;
}

- (void)deleteGroupChat{
    UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定解散该群？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消按钮");
        
    }];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * url = [NSString stringWithFormat:@"/message/chat/group/%@",self.groupInfoModel.ID];
        [SFBaseModel DELETE:BASE_URL(url) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
            [MBProgressHUD showSuccessMessage:@"解散成功"];
            [[RCIMClient sharedRCIMClient] removeConversation:self.conversationModel.conversationType targetId:self.conversationModel.targetId];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [MBProgressHUD showSuccessMessage:@"解散失败"];
        }];
    }];
    
    [alter addAction:cancleAction];
    [alter addAction:defaultAction];
    [self presentViewController:alter animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        SFBannedAskViewController * banVc = [SFBannedAskViewController new];
        banVc.groupInfoModel = _groupInfoModel;
        [self.navigationController pushViewController:banVc animated:YES];
    }else if (indexPath.section == 2){
        SFChangeGroupMasterViewController * changeMasterVc = [SFChangeGroupMasterViewController new];
        changeMasterVc.groupInfoModel = _groupInfoModel;
        [self.navigationController pushViewController:changeMasterVc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SFGroupSwithBtnWithTipCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFGroupSwithBtnWithTipCell"];
        cell.titleLB.text = _titleArray[indexPath.section];
        cell.tipLB.text = _tipArray[indexPath.section];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        if (indexPath.section == 0) {
            cell.switchBtn.selected = self.groupInfoModel.onlyMasterManage.integerValue;
        }
        cell.swithBlock = ^(BOOL isOn) {
            [self setOnlyMasterManager:isOn];
        };
        return cell;
    }
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    cell.textLabel.text = _titleArray[indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 75;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (void)setOnlyMasterManager:(BOOL)onlyMasterManage{
    [SFBaseModel BPOST:BASE_URL(@"/message/chat/group/setOnlyMasterManage") parameters:@{@"id":_groupInfoModel.ID,@"onlyMasterManage":@(onlyMasterManage)} success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD showSuccessMessage:@"设置成功"];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD showSuccessMessage:@"设置失败"];
    }];
}

@end
