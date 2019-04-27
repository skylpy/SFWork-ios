//
//  SFVisitDellViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitDellViewController.h"
#import "SFAddVisitViewController.h"
#import "SFTextViewCell.h"
#import "SFPhotoSelectCell.h"
#import "SFVisitModel.h"

static NSString * const SFAddVisitCellID = @"SFAddVisitCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";

@interface SFVisitDellViewController ()<UITableViewDelegate,UITableViewDataSource,SFPhotoSelectCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) SFVisitListModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomY;

@end

@implementation SFVisitDellViewController

- (NSMutableArray *)dataArray{
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"VisitDataNot" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self getData:x.object];
    }];
}

- (void)getData:(SFVisitListModel * )model  {
    
    self.model = model;
    [self.dataArray removeAllObjects];
    [self.imageArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[SFVisitModel shareVisitDateilModel:model]];
    [self.imageArray addObjectsFromArray:model.visitingPhotos];
    
    
    if ([model.assignerId isEqualToString:[SFInstance shareInstance].userInfo._id]) {
        
        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 120)];
        UIButton * bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomButton.frame = CGRectMake(0, 10, kWidth, 45);
        bottomButton.backgroundColor = Color(@"#FFFFFF");
        [bottomButton setTitle:@"取消拜访" forState:UIControlStateNormal];
        [bottomButton setTitleColor:Color(@"#FF715A") forState:UIControlStateNormal];
        bottomButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        [bottomView addSubview:bottomButton];
        @weakify(self)
        [[bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            [self cancelVisit];
        }];
        self.tableView.tableFooterView = bottomView;
    }
    
    NSMutableArray * array = [NSMutableArray array];
    for (EmployeeModel * emp in model.visitorList) {
        [array addObject:emp._id];
    }
    NSLog(@"%@,========,%@",array,[SFInstance shareInstance].userInfo._id);
    if ([array containsObject:[SFInstance shareInstance].userInfo._id] && !model.visitTime) {
        self.tableViewBottomY.constant = 50;
        [self.view addSubview:self.saveButton];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.offset(45);
        }];
    }
    [self.tableView reloadData];
    
}

- (void)cancelVisit{
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFVisitHttpModel deleteVisiting:self.model._id success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"拜访已取消" completionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInWindow:@"取消失败"];
    }];
}

- (void)setDrawUI {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = bgColor;
    [self.tableView registerClass:[SFAddVisitCell class] forCellReuseIdentifier:SFAddVisitCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"拜访打卡" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#01B38B");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            [self saveRequest];
        }];
    }
    return _saveButton;
}

- (void)saveRequest {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.model._id forKey:@"id"];
    if ([self.model.clientVisitingType isEqualToString: @"INTERVIEW"]) {
        
        [dict setValue:@"湛江市开发区" forKey:@"location"];
    }else{
        
        [dict setValue:@"3" forKey:@"phoneTime"];
    }
    
    
    [SFVisitHttpModel updateVisitings:dict success:^{
        
        [UIAlertController alertTitle:@"恭喜你！" mesasge:@"打卡成功！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
            
            
        } viewController:self];
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFVisitModel * model = self.dataArray[indexPath.row];
    if (model.type == 7) {
        
        return 203;
    }
    if (model.type == 8) {
        
        return 120;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFVisitModel * model = self.dataArray[indexPath.row];
    if (model.type == 7) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 8) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:YES withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    SFAddVisitCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddVisitCellID forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

//查看回调
- (void)openClickLook:(NSArray *)imageArr withRow:(NSInteger)row withView:(nonnull UIView *)superView{
    
    [SFTool openImageArr:imageArr withController:superView withRow:row];
}

@end


