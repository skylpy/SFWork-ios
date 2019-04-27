
//
//  SFAnnounceDateilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAnnounceDateilViewController.h"
#import "SFAddAnnounceViewController.h"
#import "SFAnnounceHttpModel.h"
#import "SFAnnounceModel.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"



static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFAnnounceTitleCellID = @"SFAnnounceTitleCellID";

@interface SFAnnounceDateilViewController ()<UITableViewDelegate,UITableViewDataSource,SFPhotoSelectCellDelegate>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) SFAnnounceListModel *smodel;

@end

@implementation SFAnnounceDateilViewController

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知公告";
    [self initData];
    [self setDrawUI];
}


- (void)initData {
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFAnnounceHttpModel getApprovalDetails:self.model._id success:^(SFAnnounceListModel * _Nonnull model) {
        self.smodel = model;
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.imageArray removeAllObjects];
        [self.imageArray addObjectsFromArray:model.photos];
        [self.dataArray addObjectsFromArray:[SFAnnounceModel shareDateilAnnounceModel:model]];
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
    
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    if ([self.model.createId isEqualToString:[SFInstance shareInstance].userInfo._id]) {
        [self.view addSubview:self.saveButton];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.offset(45);
        }];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFAnnounceModel * model = self.dataArray[indexPath.row];
    if (model.type == 4) {
        
        return 135;
    }
    if (model.type == 5) {
        
        return 120;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SFAnnounceModel * model = self.dataArray[indexPath.row];
    if (model.type == 4) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type ==5) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:YES withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    
    
    
    SFAnnounceTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAnnounceTitleCellID forIndexPath:indexPath];
    
    cell.model = model;
    
    
    @weakify(self)
    [cell setInputChacneClick:^(NSString * _Nonnull value) {
        @strongify(self)
        
        
    }];
    return cell;
}


- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFAnnounceTitleCell class] forCellReuseIdentifier:SFAnnounceTitleCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
        
    }
    return _tableView;
}

//查看回调
- (void)openClickLook:(NSArray *)imageArr withRow:(NSInteger)row withView:(nonnull UIView *)superView{
    
    NSMutableArray<YYPhotoGroupItem *> *items = [NSMutableArray array];
    
    for (NSString * urlString in imageArr) {
        NSString * constrainURL = [NSString getAliOSSConstrainURL:urlString];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.largeImageURL = [NSURL URLWithString:constrainURL];
        
        [items addObject:item];
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    
    [v presentFromImageView:self.view toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"撤回" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#FF715A");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            [self deleteItem];
        }];
    }
    return _saveButton;
}

- (void)deleteItem {
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFAnnounceHttpModel deleteInformation:self.model._id success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"撤回成功" completionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

@end
