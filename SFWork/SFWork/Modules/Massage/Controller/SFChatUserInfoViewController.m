//
//  SFChatUserInfoViewController.m
//  SFWork
//
//  Created by fox on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFChatUserInfoViewController.h"
#import "SFChatUserInfoHeadCell.h"

@interface SFChatUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSDictionary * infoDic;
@end

@implementation SFChatUserInfoViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"聊天信息";
    [self initUI];
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self requestData];
}

#pragma mark 获取数据
- (void)requestData{
    NSString * url = [NSString stringWithFormat:@"/org/employee/%@",_targetId];
    [SFBaseModel BGET:BASE_URL(url) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        self.infoDic = model.result;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = bgColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:@"SFChatUserInfoHeadCell" bundle:nil] forCellReuseIdentifier:@"SFChatUserInfoHeadCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFChatUserInfoHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFChatUserInfoHeadCell"];
    if (self.infoDic) {
        [cell.headIMG setImageWithURL:[NSURL URLWithString:self.infoDic[@"smallAvatar"]] placeholder:DefaultImage];
        cell.nameLB.text = self.infoDic[@"name"];
        cell.departMentLB.text = [NSString stringWithFormat:@"部门：%@",self.infoDic[@"departmentName"]];
        cell.companyNameLB.text = self.infoDic[@"positionName"];
        if ([self.infoDic[@"positionName"] isEqualToString:@"FEMALE"]) {
            [cell.sexLB setImage:[UIImage imageNamed:@"icon_gril_orange"]];
        }else{
            [cell.sexLB setImage:[UIImage imageNamed:@"icon_boy_green"]];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0, 0, kWidth, 45);
    [sendBtn setTitle:@"发信息" forState:0];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn setTitleColor:[UIColor colorWithRed:40/255.0 green:179/255.0 blue:139/255.0 alpha:1.0] forState:0];
    [sendBtn addTarget:self action:@selector(sendMessageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return sendBtn;
}

//发送消息
- (void)sendMessageBtnAction:(UIButton *)sender{
    NSLog(@"===============>>>>>>>>>>发送消息");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
