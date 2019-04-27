//
//  SFJournalDateilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFJournalDateilViewController.h"
#import "SFAddJournalViewController.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFJournalModel.h"
#import "SFJoBottomView.h"

static NSString * const SFAddJournalCellID = @"SFAddJournalCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";

@interface SFJournalDateilViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) SFJoBottomView *bottomView;

@end

@implementation SFJournalDateilViewController

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

- (NSMutableArray *)userArray{
    
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人日报";
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    [SFJournalHttpModel getDailyDetails:self.model._id success:^(SFJournalListModel * _Nonnull smodel) {
        
        [self.dataArray removeAllObjects];
        [self.imageArray removeAllObjects];
        [self.userArray removeAllObjects];
        [self.dataArray addObjectsFromArray: [SFJournalModel shareJournalDateilModel:smodel]];
        [self.imageArray addObjectsFromArray:smodel.photos];
        for (AuditUser * user in smodel.dailyAuditUserList) {
            
            [self.userArray addObject:user._id];
        }
        if ([self.userArray containsObject: [SFInstance shareInstance].userInfo._id]  && ![smodel.dailyStatus isEqualToString:@"NOPASS"] && ![smodel.dailyStatus isEqualToString:@"PASS"]) {
            [self.view addSubview:self.bottomView];
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.offset(50);
            }];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.top.left.right.equalTo(self.view);
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFJournalModel * model = self.dataArray[indexPath.row];
    if (model.type == 3) {
        
        return 203;
    }
    if (model.type == 4) {
        
        return 120;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFJournalModel * model = self.dataArray[indexPath.row];
    if (model.type == 3) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 4) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:YES withCmodel:nil withArr:self.imageArray];
//        cell.delegate = self;
        return cell;
    }
    SFAddJournalCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddJournalCellID forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFAddJournalCell class] forCellReuseIdentifier:SFAddJournalCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
    }
    return _tableView;
}

- (SFJoBottomView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [SFJoBottomView shareBottomView];
        @weakify(self)
        [_bottomView setSelectIndex:^(NSInteger tap) {
            @strongify(self)
            [self changeStatus:tap];
        }];
    }
    return _bottomView;
}

- (void)changeStatus:(NSInteger)tap{
    
    NSString * title = tap == 0 ? @"驳回原因":@"通过原因";
    SFAlertInputView * alert=[[SFAlertInputView alloc] initWithTitle:title PlaceholderText:[NSString stringWithFormat:@"请输入%@",title] WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
        NSLog(@"-----%@",contents);
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:self.model._id forKey:@"id"];
        
        [dict setValue:contents forKey:@"result"];
        if (tap == 0) {
            [dict setValue:@"NOPASS" forKey:@"dailyStatus"];
        }else{
            [dict setValue:@"PASS" forKey:@"dailyStatus"];
        }
        [self changeHttp:dict];
    }];
    [alert show];
    
}

- (void)changeHttp:(NSDictionary *)dic{
    
    [SFJournalHttpModel changeAuditStatuss:dic success:^{
        
        self.bottomView.hidden = YES;
        [MBProgressHUD showSuccessMessage:@"审批成功"];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showErrorMessage:@"审批失败"];
    }];
}

@end
