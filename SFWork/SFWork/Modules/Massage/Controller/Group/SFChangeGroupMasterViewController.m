//
//  SFChangeGroupMasterViewController.m
//  SFWork
//
//  Created by fox on 2019/4/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFChangeGroupMasterViewController.h"
#import "SFConversationViewController.h"
#import "SFSelectCOntactCell.h"

@interface SFChangeGroupMasterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    SFSelectCOntactCell * lastSelectCell;
}

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * selectArray;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectCountLB;

@end

@implementation SFChangeGroupMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.selectArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    [self initDrawUI];
    [self requestBanListWithKeyWord:@""];
}

#pragma mark 从群管理进来
- (void)requestBanListWithKeyWord:(NSString *)keyWord{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:_groupInfoModel.ID forKey:@"groupId"];
    [params setObject:keyWord forKey:@"searchText"];
    
    [SFBaseModel BPOST:BASE_URL(@"/message/chat/group/searchMember") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[SFGroupMemberModel class] json:model.result]];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

//确定创建
- (IBAction)sureBtnAction:(UIButton *)sender {
    if (self.selectArray == 0) {
        [MBProgressHUD showInfoMessage:@"请选择转让的用户"];
        return;
    }
    SFGroupMemberModel * model = [self.selectArray firstObject];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:_groupInfoModel.ID forKey:@"id"];
    [params setObject:model.employeeId forKey:@"masterId"];
    [SFBaseModel BPOST:BASE_URL(@"/message/chat/group/changeMaster") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD showInfoMessage:@"转让成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD showInfoMessage:@"转让失败"];
    }];
}

-(void)initDrawUI {
    self.searchTF.delegate = self;
    self.sureBtn.layer.cornerRadius = 3;
    self.sureBtn.clipsToBounds = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-50);
        make.top.mas_equalTo(44);
        make.left.right.equalTo(self.view);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 68;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFSelectCOntactCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFSelectCOntactCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.groupInfoModel.members.count>indexPath.row) {
        SFGroupMemberModel * model = self.dataArray[indexPath.row];
        [cell.headView setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:DefaultImage];
        cell.nameLB.text = model.name;
        
        cell.selectBlock = ^(BOOL isSelect) {
            if (self->lastSelectCell) {
                self->lastSelectCell.selectBtn.selected = NO;
            }
            [self.selectArray removeAllObjects];
            
            if (isSelect) {
                [self.selectArray addObject:self.dataArray[indexPath.row]];
                self.selectCountLB.text = [NSString stringWithFormat:@"已选择 %@",model.name];
                self->lastSelectCell = cell;
            }else{
                self.selectCountLB.text = @"未选择";
                self->lastSelectCell = nil;
            }
            
        };
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark UITextFieldDelegate 搜索代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self requestBanListWithKeyWord:textField.text];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self requestBanListWithKeyWord:textField.text];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectCOntactCell" bundle:nil] forCellReuseIdentifier:@"SFSelectCOntactCell"];
        
        
    }
    return _tableView;
}

@end
