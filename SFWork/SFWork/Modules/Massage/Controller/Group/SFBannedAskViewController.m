//
//  SFBannedAskViewController.m
//  ClassForEvery
//
//  Created by Adam on 2019/4/2.
//  Copyright © 2019年 Adam. All rights reserved.
//

#import "SFBannedAskViewController.h"
#import "SFGroupSwithBtnWithTipCell.h"
#import "SFBannedAskCell.h"
#import "SFGroupMemberModel.h"

@interface SFBannedAskViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray * _titleArray;
    NSArray * _tipArray;
}
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSArray * bankList;
@end

@implementation SFBannedAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置群内禁言";
    [self initUI];
}

- (void)initUI{
    _titleArray = @[@"全部禁言",@"群成员禁言"];
    _tipArray = @[@"开启后，仅群主和指定的成员可以发言"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    [_tableView registerNib:[UINib nibWithNibName:@"SFGroupSwithBtnWithTipCell" bundle:nil] forCellReuseIdentifier:@"SFGroupSwithBtnWithTipCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SFBannedAskCell" bundle:nil] forCellReuseIdentifier:@"SFBannedAskCell"];
    [self.view addSubview:_tableView];
    
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
        cell.switchBtn.selected = self.groupInfoModel.isBan.integerValue;
        cell.swithBlock = ^(BOOL isOn) {
            [self bandAllTalk:isOn];
        };
        return cell;
    }
    SFBannedAskCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFBannedAskCell"];
    cell.groupId = _groupInfoModel.ID;
    cell.rootVC = self;
    cell.isBan = self.groupInfoModel.isBan;
    if (self.groupInfoModel.isBan.integerValue == 1) {
        cell.titleLB.text = @"可发言成员";
        cell.tipLB.text = @"    开启后，仅群主和指定成员发言";
        [cell showALlNobanMemberList:_groupInfoModel.ID];
    }else{
        cell.titleLB.text = @"群成员禁言";
        cell.tipLB.text = @"    以上成员不允许发言";
        [cell showAllBanMemberList:_groupInfoModel.ID];
    }
    
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 75;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

#pragma mark 禁言群聊，全部禁言
- (void)bandAllTalk:(BOOL)isBan{
    [SFBaseModel BPOST:BASE_URL(@"/message/chat/group/banGroup") parameters:@{@"id":_groupInfoModel.ID,@"isBan":@(isBan)} success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD showSuccessMessage:@"设置成功"];
        self.groupInfoModel.isBan = isBan?@"1":@"0";
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD showSuccessMessage:@"设置失败"];
    }];
}


@end
