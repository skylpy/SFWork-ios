//
//  SFMakeCopyViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMakeCopyViewController.h"
#import "SFExpenseDateilViewController.h"
#import "SFExpenseListCell.h"
#import "SFExpenseHttpModel.h"

static NSString * const SFExpenseListCellID = @"SFExpenseListCellID";

@interface SFMakeCopyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *unreadButton;
@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutX;

@property (nonatomic, strong) NSMutableArray *readArray;
@property (nonatomic, strong) NSMutableArray *unreadArray;

@property (nonatomic, assign) BOOL isRead;

@end

@implementation SFMakeCopyViewController

- (NSMutableArray *)readArray{
    
    if (!_readArray) {
        _readArray = [NSMutableArray array];
    }
    return _readArray;
}

- (NSMutableArray *)unreadArray{
    
    if (!_unreadArray) {
        
        _unreadArray = [NSMutableArray array];
    }
    return _unreadArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    [MBProgressHUD showActivityMessageInWindow:@"加载信息..."];
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:@"UNAPPROVED" forKey:@"approveStatus"];
        [SFExpenseHttpModel postgetApprove:dict success:^(NSArray<ExpenseListModel *> * _Nonnull list) {
            
            [self.unreadArray removeAllObjects];
            [self.unreadArray addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
            
        } failure:^(NSError * _Nonnull error) {
            
            [subscriber sendNext:@"2"];
        }];
        
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:@"APPROVED" forKey:@"approveStatus"];
        [SFExpenseHttpModel postgetApprove:dict success:^(NSArray<ExpenseListModel *> * _Nonnull list) {
            [self.readArray removeAllObjects];
            [self.readArray addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
        }];
        
        return nil;
    }];
    [self rac_liftSelector:@selector(completedRequest1:request2:) withSignalsFromArray:@[signal1, signal2]];
}

- (void)completedRequest1:(NSString *)signal1 request2:(NSString *)signal2 {
    
    if ([signal1 isEqualToString:@"1"] && [signal2 isEqualToString:@"1"] ) {
        
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    }else{
        
        [MBProgressHUD showErrorMessage:@"加载失败,请重新加载!"];
        [MBProgressHUD hideHUD];
    }
}


- (void)setDrawUI {
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = bgColor;
    
    [_tableView registerNib:[UINib nibWithNibName:@"SFExpenseListCell" bundle:nil] forCellReuseIdentifier:SFExpenseListCellID];
    
    self.isRead = YES;
    @weakify(self)
    [[self.allButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.isRead = YES;
        self.viewLayoutX.constant = 0;
        [self selectBtn:x];
    }];
    
    [[self.unreadButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.isRead = NO;
        self.viewLayoutX.constant = kWidth/2;
        [self selectBtn:x];
    }];
}

- (void)selectBtn:(UIButton *)sender{
    
    for (int i = 1000; i < 1002; i ++) {
        UIButton * button = [self.selectView viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.isRead ? self.readArray.count:self.unreadArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 178;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFExpenseListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseListCellID forIndexPath:indexPath];
    ExpenseListModel * model = self.isRead ? self.readArray[indexPath.section]:self.unreadArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExpenseListModel * model = self.isRead ? self.readArray[indexPath.section]:self.unreadArray[indexPath.section];
    SFExpenseDateilViewController * vc = [SFExpenseDateilViewController new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
