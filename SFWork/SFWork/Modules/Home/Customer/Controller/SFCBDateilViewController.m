//
//  SFCBDateilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/14.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFCBDateilViewController.h"
#import "SFTextViewCell.h"
#import "SFProfileTableCell.h"
#import "SFPhotoSelectCell.h"
#import "SFCustomerHttpModel.h"
#import "SFContactCell.h"

static NSString * const SFProfileTableCellID = @"SFProfileTableCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFContactCellID = @"SFContactCellID";

@interface SFCBDateilViewController ()<UITableViewDelegate,UITableViewDataSource,SFPhotoSelectCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSMutableArray *contactArr;
@end

@implementation SFCBDateilViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)contactArr{
    
    if (!_contactArr) {
        
        _contactArr = [NSMutableArray array];
    }
    return _contactArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = self.type == businessType ? @"商家资料":@"客户资料";
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self setDrawUI];
    
}

- (void)requestData {
    
    [MBProgressHUD showActivityMessageInWindow:@"加载中..."];
    [SFCustomerHttpModel getClients:self.model._id success:^(SFClientModel * _Nonnull model) {

        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.imageArray removeAllObjects];
        [self.contactArr removeAllObjects];
        [self.dataArray addObjectsFromArray:[SFCustomerModel shareDateilModel:self.type withModel:model]];
        [self.imageArray addObjectsFromArray:model.photos];
        [self.contactArr addObjectsFromArray:model.clientLinkmanDTOList];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showErrorMessage:@"获取数据失败"];
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 40, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)

            UIViewController * vc = [[UIStoryboard storyboardWithName:@"CustomerMgr" bundle:nil] instantiateViewControllerWithIdentifier:@"SFAddData"];
            [vc setValue:self.model forKey:@"cmodel"];
            [vc setValue:@(self.type) forKey:@"type"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _rightButton;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (self.dataArray.count == 0) {
        
        return 0;
    }else{
        return self.dataArray.count + 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2) {
        
        return self.contactArr.count;
    }
    NSArray * array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        
        return 45;
    }
    NSArray * array = self.dataArray[indexPath.section];
    SFCustomerModel * model = array[indexPath.row];
    if (model.type == 9) {
        
        return 120;
    }
    if (model.type == 10) {
        
        return 203;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        SFContactCell * cell = [tableView dequeueReusableCellWithIdentifier:SFContactCellID forIndexPath:indexPath];
        ClientLinkModel * model = self.contactArr[indexPath.row];
        cell.model = model;
        cell.isHiden = YES;
        return cell;
    }
    NSArray * array = self.dataArray[indexPath.section];
    SFCustomerModel * model = array[indexPath.row];
    
    if (model.type == 9) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        
        [cell cellImage:model withIsEdit:YES withCmodel:self.model withArr:self.imageArray ];
        cell.delegate = self;
        return cell;
        
    }
    if (model.type == 10) {
        
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    SFProfileTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFProfileTableCellID forIndexPath:indexPath];
    cell.cmodel = model;
    
    return cell;
}

- (void)openClickLook:(NSArray *)imageArr withRow:(NSInteger)row withView:(nonnull UIView *)superView{
    
    [SFTool openImageArr:imageArr withController:superView withRow:row];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFProfileTableCell class] forCellReuseIdentifier:SFProfileTableCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFContactCell" bundle:nil] forCellReuseIdentifier:SFContactCellID];
    }
    return _tableView;
}


@end
