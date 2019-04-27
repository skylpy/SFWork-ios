//
//  SFVisitListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/14.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitListViewController.h"
#import "SFAddVisitViewController.h"
#import "SFVisitListCell.h"
#import "SFVisitHttpModel.h"

static NSString * const SFVisitListCellID = @"SFVisitListCellID";

@interface SFVisitListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *myVisitArray;
@property (nonatomic, strong) NSMutableArray *myAssignArray;
@property (nonatomic,strong) UIButton * addVisitButton;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *myVisitButton;
@property (weak, nonatomic) IBOutlet UIButton *myAssignButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLayoutX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutY;
@property (nonatomic, assign) BOOL isVisit;

@end

@implementation SFVisitListViewController

- (NSMutableArray *)myVisitArray{
    
    if (!_myVisitArray) {
        
        _myVisitArray = [NSMutableArray array];
    }
    return _myVisitArray;
}

- (NSMutableArray *)myAssignArray{
    
    if (!_myAssignArray) {
        
        _myAssignArray = [NSMutableArray array];
    }
    return _myAssignArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    [self requestMyVisit];
    [self requestMyAssign];
}

//我拜访的
- (void)requestMyVisit{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[SFInstance shareInstance].userInfo._id forKey:@"visitorId"];
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFVisitHttpModel clientVisitList:dict success:^(NSArray<SFVisitListModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.myVisitArray removeAllObjects];
        [self.myVisitArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}
//我指派的
- (void)requestMyAssign{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[SFInstance shareInstance].userInfo._id forKey:@"assignerId"];
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFVisitHttpModel clientVisitList:dict success:^(NSArray<SFVisitListModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.myAssignArray removeAllObjects];
        [self.myAssignArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    if (!isDeMgr) {
        self.tableViewLayoutY.constant = 0;
    }
    if (!isSuper) {
        self.isVisit = YES;
    }else{
        self.isVisit = NO;
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = bgColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFVisitListCell" bundle:nil] forCellReuseIdentifier:SFVisitListCellID];
    
    [self.view addSubview:self.addVisitButton];
    [self.addVisitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(55);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-52);
    }];
    
    
    @weakify(self)
    [[self.addVisitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        SFAddVisitViewController * vc = [NSClassFromString(@"SFAddVisitViewController") new];
        [vc setAddCompleteClick:^{
            [self requestMyVisit];
            [self requestMyAssign];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.myVisitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.isVisit = YES;
        self.lineViewLayoutX.constant = 0;
        [self selectItem:x];
    }];
    
    [[self.myAssignButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.isVisit = NO;
        self.lineViewLayoutX.constant = kWidth/2;
        [self selectItem:x];
    }];
}

-(void)selectItem:(UIButton *)sender{
    
    for (int i = 1000; i < 1002; i ++) {
        UIButton * button = [self.topView viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 10;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 165;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.isVisit ? self.myVisitArray.count : self.myAssignArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFVisitListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFVisitListCellID forIndexPath:indexPath];
    SFVisitListModel * model = self.isVisit ? self.myVisitArray[indexPath.section] : self.myAssignArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFVisitListModel * model = self.isVisit ? self.myVisitArray[indexPath.section] : self.myAssignArray[indexPath.section];
    UIViewController * vc = [[UIStoryboard storyboardWithName:@"VisitMgr" bundle:nil] instantiateViewControllerWithIdentifier:@"SFVisitDateil"];
    [vc setValue:model._id forKey:@"visitId"];
    [vc setValue:self.type forKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)addVisitButton{
    
    if (!_addVisitButton) {
        
        _addVisitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addVisitButton setImage:[UIImage imageNamed:@"btn_oval_add_green"] forState:UIControlStateNormal];
    }
    return _addVisitButton;
}

@end
