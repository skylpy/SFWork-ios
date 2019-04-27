//
//  SFTaskSummaryViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTaskSummaryViewController.h"
#import "SFAddTaskViewController.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFTaskModel.h"
#import "PickerTool.h"
#import "SFTaskHttpModel.h"

static NSString * const SFAddTaskCellID = @"SFAddTaskCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";

@interface SFTaskSummaryViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate,SFPhotoSelectCellDelegate,PickerToolDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) TaskListModel *model;
@property (nonatomic,strong) PickerTool *pick;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) DateTimePickerView *timePickerView;

@property (nonatomic, strong) SFTaskModel * tmodel;

@end

@implementation SFTaskSummaryViewController

- (UIButton *)bottomButton{
    
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(20, 20, kWidth-40, 50);
        [_bottomButton setTitle:@"保存" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _bottomButton.backgroundColor = defaultColor;//Color(@"#D8D8D8");
        
        @weakify(self)
        [[_bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self saveTaskSummary];
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

- (void)saveTaskSummary{
    
    NSMutableDictionary * dict = [SFTaskModel pramTaskSummaryJson:self.dataArray];
    [dict setValue:self.model._id forKey:@"id"];
    [dict setValue:self.imageArray forKey:@"summarizePhotos"];
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFTaskHttpModel putMyTaskSummary:dict success:^{
        [MBProgressHUD hideHUD] ;
        [MBProgressHUD showTipMessageInWindow:@"提交成功"];
        
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD] ;
        [MBProgressHUD showTipMessageInWindow:@"提交失败"];
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

- (void)getData:(TaskListModel * )models {
    
    self.model = models;
    
    if (!models.accomplishTime && [models.executorId isEqualToString:[SFInstance shareInstance].userInfo._id]) {
        
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 90)];
        
        [footerView addSubview:self.bottomButton];
        
        self.tableView.tableFooterView = footerView;
    }
    
    
    [self.imageArray removeAllObjects];
    [self.dataArray removeAllObjects];
    
    [self.imageArray addObjectsFromArray:models.summarizePhotos];
    
    [self.dataArray addObjectsFromArray:[SFTaskModel shareTaskSummaryModel:YES withModel:models]];
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFTaskModel * model = self.dataArray[indexPath.row];
    if (model.type == 3) {
        
        return 203;
    }
    if (model.type == 2) {
        
        return 120;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFTaskModel * model = self.dataArray[indexPath.row];
    if (model.type == 3) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 2) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        BOOL isE = self.model.accomplishTime ? YES:NO;
        [cell cellImage:nil withIsEdit:isE withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    SFAddTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddTaskCellID forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SFTaskModel * model = self.dataArray[indexPath.row];
    self.tmodel = model;
    
    if (![self.model.executorId isEqualToString:[SFInstance shareInstance].userInfo._id]) return;
    [self selectTime:DatePickerViewDateTimeMode];
}

//添加回调
- (void)cellClickUpload:(NSArray *)imageArr {
    if (![self.model.executorId isEqualToString:[SFInstance shareInstance].userInfo._id]) return;
    [self.imageArray removeAllObjects];
    [self.imageArray addObjectsFromArray:imageArr];
    self.pick = [[PickerTool alloc]initWithMaxCount:1 selectedAssets:nil];
    self.pick.delegate = self;
    [self presentViewController:self.pick.imagePickerVcC animated:YES completion:nil];
}


#pragma mark- PickerToolDelegate
- (void)didPickedPhotos:(NSString *)fileName{
    
    if (self.pick.selectedPhotos.count > 0) {
        [[SFAliOSSManager sharedInstance] asyncUploadMultiImages:self.pick.selectedPhotos withFile:fileName withFolderName:@"Image" CompeleteBlock:^(NSArray *nameArray) {
            NSLog(@"nameArray is %@", nameArray);
            [self files:nameArray];
        } ErrowBlock:^(NSString *errrInfo) {
            
        }];
    }
}

- (void)files:(NSArray *)nameArr {
    
    NSDictionary * dic = nameArr[0];
    NSString *img = dic[@"Img"];
    
    [self.imageArray addObject:img];
    [self.tableView reloadData];
}

- (void)selectTime:(DatePickerViewMode)type{
    
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    self.timePickerView = pickerView;
    pickerView.delegate = self;
    pickerView.pickerViewMode = type;
    [LSKeyWindow addSubview:pickerView];
    [pickerView showDateTimePickerView];
}
#pragma mark - delegate

- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSLog(@"%@",date);
    self.tmodel.destitle = date;
    
    [self.tableView reloadData];
    
    //    [self getSearchDailyLists];
}

@end
