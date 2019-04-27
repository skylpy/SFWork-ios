//
//  SFTaskDeilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTaskDeilViewController.h"
#import "SFAddTaskViewController.h"
#import "SFPhotoSelectCell.h"
#import "SFSelectItemView.h"
#import "SFTextViewCell.h"
#import "SFTaskModel.h"
#import "SFTaskHttpModel.h"

static NSString * const SFAddTaskCellID = @"SFAddTaskCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";

@interface SFTaskDeilViewController ()<UITableViewDelegate,UITableViewDataSource,SFPhotoSelectCellDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) SFSelectItemView *selectItemView;
@property (nonatomic, strong) TaskListModel *tmodel;
@end

@implementation SFTaskDeilViewController

- (SFSelectItemView *)selectItemView {
    
    if (!_selectItemView) {
        _selectItemView = [SFSelectItemView shareSFSelectItemView];
    }
    return _selectItemView;
}

- (UIButton *)bottomButton{
    
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(0, 10, kWidth, 45);
        _bottomButton.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [_bottomButton setTitle:@"取消任务" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:Color(@"#FF715A") forState:UIControlStateNormal];
        _bottomButton.backgroundColor = Color(@"#FFFFFF");
        @weakify(self)
        [[_bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self cancelTask];
        }];
    }
    return _bottomButton;
}

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
   
    [self setDrawUI];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"TaskDataNot" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self getData:x.object];
    }];
    
}

- (void)cancelTask{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.tmodel._id forKey:@"id"];
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFTaskHttpModel deleteMyTaskManager:dict success:^{
        
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = bgColor;
    [_tableView registerClass:[SFAddTaskCell class] forCellReuseIdentifier:SFAddTaskCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
    
    
}

- (void)getData:(TaskListModel * )model {
    
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * dic in model.auditUserList) {
        
        [array addObject:dic[@"id"]];
    }
    
    if ([array containsObject:[SFInstance shareInstance].userInfo._id]) {
        
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 90)];
        
        [footerView addSubview:self.bottomButton];
        
        self.tableView.tableFooterView = footerView;
        
        [self.view addSubview:self.saveButton];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.offset(45);
        }];
    }
    self.tmodel = model;
    [self.dataArray removeAllObjects];
    [self.imageArray removeAllObjects];
    [self.imageArray addObjectsFromArray:model.photos];
    [self.dataArray addObjectsFromArray:[SFTaskModel shareTaskDateilModel:YES withModel:model]];
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFTaskModel * model = self.dataArray[indexPath.row];
    if (model.type == 9) {
        
        return 203;
    }
    if (model.type == 10) {
        
        return 120;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFTaskModel * model = self.dataArray[indexPath.row];
    if (model.type == 9) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 10) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        cell.delegate = self;
        [cell cellImage:nil withIsEdit:YES withCmodel:nil withArr:self.imageArray];

        return cell;
    }
    SFAddTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddTaskCellID forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

//查看回调
- (void)openClickLook:(NSArray *)imageArr withRow:(NSInteger)row withView:(UIView *)superView{
    
    [SFTool openImageArr:imageArr withController:superView withRow:row];
}


- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"任务结果处理" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#01B38B");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            NSString * title = [self.tmodel.taskStatus isEqualToString:@"ACCOMPLISH"]?
            @"员工申请任务为“已完成”":[self.tmodel.taskStatus isEqualToString:@"UNACCOMPLISHED"]?
            @"员工申请任务为“未完成”":@"员工的任务“已超时”";
            NSArray * array = @[];
            if ([self.tmodel.taskStatus isEqualToString:@"ACCOMPLISH"]) {
                array = @[@"通过",@"标记为未完成",@"驳回",@"取消"];
            }
            else if ([self.tmodel.taskStatus isEqualToString:@"UNACCOMPLISHED"]) {
                array = @[@"通过",@"延时让其完成",@"驳回",@"取消"];
            }
            else{
                array = @[@"标记为已完成",@"标记为未完成",@"延时让其完成",@"取消"];
            }
            [self.selectItemView showFromView:LSKeyWindow withTitle:title withData:array selectClick:^(NSString * _Nonnull type) {
                
                
                if ([type isEqualToString:@"驳回"]) {
                    
                    SFAlertInputView * alert=[[SFAlertInputView alloc] initWithTitle:@"驳回原因" PlaceholderText:@"请输入驳回原因" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
                        NSLog(@"-----%@",contents);
                        
                        [self putTaskStatus:@"NOPASS" with:contents];
                    }];
                    [alert show];
                }
                if ([type isEqualToString:@"通过"]||[type isEqualToString:@"标记为已完成"]) {
                    
                    [self putTaskStatus:@"PASS" with:@""];
                }
                
                if ([type isEqualToString:@"标记为未完成"]) {
                    
                    [self putTaskStatus:@"UNFINISHED" with:@""];
                }
                
                if ([type isEqualToString:@"延时让其完成"]) {
                    
                    [self putTaskStatus:@"DELAYFINISHED" with:@""];
                }
                
            }];
        }];
    }
    return _saveButton;
}

- (void)putTaskStatus:(NSString *)status with:(NSString *)result{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.tmodel._id forKey:@"id"];
    [dict setValue:status forKey:@"auditStatus"];
    [dict setValue:result forKey:@"result"];
    [dict setValue:self.tmodel.endTime forKey:@"endTime"];
    
    [SFTaskHttpModel putMyTaskStatus:dict success:^{
        
        [MBProgressHUD showTipMessageInWindow:@"修改成功"];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showTipMessageInWindow:@"修改失败"];
    }];
}

@end
