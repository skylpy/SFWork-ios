//
//  SFSystemMessageDetailViewController.m
//  SFWork
//
//  Created by fox on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSystemMessageDetailViewController.h"
#import "SFSystemMessageModel.h"

@interface SFSystemMessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) SystemMessageModel * dataModel;
@end

@implementation SFSystemMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"系统消息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    NSString * url = [NSString stringWithFormat:@"/message/notification/%@",_messageId];
    [SFBaseModel BGET:BASE_URL(url) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        self->_dataModel = [SystemMessageModel modelWithJSON:model.result];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
    
    NSString * urlRead = [NSString stringWithFormat:@"/message/notification/read/%@",_messageId];
    [SFBaseModel BGET:BASE_URL(urlRead) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        if (self.readBlock) {
            self.readBlock();
        }
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
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:@"SystemMessageDetailCell" bundle:nil] forCellReuseIdentifier:@"SystemMessageDetailCell"];
        [_tableView registerClass:[SystemMessageDetailCell class] forCellReuseIdentifier:@"SystemMessageDetailCell"];
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
    SystemMessageDetailCell * cell = [[SystemMessageDetailCell alloc]initWithFrame:CGRectZero];
    if (self.dataModel) {
        [cell setTitle:_dataModel.title Time:_dataModel.createTime Content:_dataModel.content];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}


@end


@implementation SystemMessageDetailCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLB.textColor = [UIColor blackColor];
    titleLB.font = [UIFont boldSystemFontOfSize:21];
    [self.contentView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-15);
    }];
    self.titleLB = titleLB;
    
    UILabel * timeLB = [[UILabel alloc]initWithFrame:CGRectZero];
    timeLB.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLB.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:timeLB];
    [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(titleLB.mas_bottom).offset(10);
        make.right.mas_equalTo(-15);
    }];
    self.timeLB = timeLB;
    
    UILabel * contentLB = [[UILabel alloc]initWithFrame:CGRectZero];
    contentLB.textColor = [UIColor colorWithHexString:@"#333333"];
    contentLB.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:contentLB];
    [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(timeLB.mas_bottom).offset(30);
        make.right.mas_equalTo(-15);
    }];
    self.contentLb = contentLB;
}

/**
 *设置内容
 */
- (void)setTitle:(NSString *)title Time:(NSString *)time Content:(NSString *)content{
    self.titleLB.text = title;
    self.timeLB.text = time;
    self.contentLb.text = content;
}
@end

