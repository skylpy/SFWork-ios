//
//  SFWorkAssessmentViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFWorkAssessmentViewController.h"
#import "SFWorkAssessPersonModel.h"
#import "SFWorkAssessHttpModel.h"
#import "SFWorkAssessmentCell.h"
#import "SFHomeHeaderView.h"
#import "SFWorkHeaderView.h"
#import "SFWorkTwoButtonView.h"
#import "SFWorkOneButtonView.h"
#import "SFSuperSuborViewController.h"
#import "SFCustomPopView.h"

static NSString * const SFWorkAssessmentCellID = @"SFWorkAssessmentCellID";

@interface SFWorkAssessmentViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate,SFSuperSuborViewControllerDelagete>
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * titleArray;
@property (nonatomic, strong) SFWorkHeaderView *headerView;
@property (nonatomic, strong) SFWorkAssessPersonModel *model;
@property (nonatomic, copy) NSString *month;

@property (nonatomic, strong) NSMutableArray *addScoreArray;
@property (nonatomic, strong) NSMutableArray *subScoreArray;


@end

@implementation SFWorkAssessmentViewController

- (NSMutableArray *)addScoreArray{
    
    if (!_addScoreArray) {
        _addScoreArray = [NSMutableArray array];
    }
    return _addScoreArray;
}

- (NSMutableArray *)subScoreArray{
    
    if (!_subScoreArray) {
        _subScoreArray = [NSMutableArray array];
    }
    return _subScoreArray;
}

-(NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"加分",@"扣分", nil];
    }
    return _titleArray;
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"选择员工" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.delagete = self;
            vc.type = singleType;
            vc.isSubor = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _rightButton;
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    
    self.employeeId = employee._id;
    [self requestData];
}

- (SFWorkHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [SFWorkHeaderView shareSFWorkHeaderView];
        _headerView.frame = CGRectMake(0, 0, kWidth, 86);
        @weakify(self)
        [[_headerView.timeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self selectTime:DatePickerViewMonthMode];
        }];
    }
    return _headerView;
}

- (void)selectTime:(DatePickerViewMode)type{
    
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    pickerView.delegate = self;
    pickerView.pickerViewMode = type;
    [LSKeyWindow addSubview:pickerView];
    [pickerView showDateTimePickerView];
}
#pragma mark - delegate

- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSLog(@"%@",date);
    [self.headerView.timeButton setTitle:[NSString stringWithFormat:@"%@ 考核",date] forState:UIControlStateNormal];
    self.month = date;
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人考核明细";
    
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.employeeId forKey:@"employeeId"];
    [dict setValue:self.month forKey:@"month"];
    
    [MBProgressHUD showActivityMessageInView:@""];
    [SFWorkAssessHttpModel getWorkAssessCheckPrame:dict success:^(SFWorkAssessPersonModel * _Nonnull model) {
        
        [MBProgressHUD hideHUD];
        self.model = nil;
        self.model = model;
        [self.addScoreArray removeAllObjects];
        [self.subScoreArray removeAllObjects];
        [self.addScoreArray addObjectsFromArray:model.addScoreDetail];
        [self.subScoreArray addObjectsFromArray:model.subScoreDetail];
        self.headerView.model = model.totalScore;
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = bgColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFWorkAssessmentCell" bundle:nil] forCellReuseIdentifier:SFWorkAssessmentCellID];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 96)];
    [headerView addSubview:self.headerView];
    headerView.backgroundColor = bgColor;
    self.tableView.tableHeaderView = headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    SFHomeHeaderView * header = [SFHomeHeaderView shareSFHomeHeaderView];
    header.titleLabel.text = self.titleArray[section];
    header.titleLabel.textColor = Color(@"#333333");
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return self.addScoreArray.count;
    }
    
    return self.subScoreArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SocreDetailModel * model = self.addScoreArray[indexPath.row];
        
        return model.dataList.count * 40;
    }
    SocreDetailModel * model = self.subScoreArray[indexPath.row];
    
    return model.dataList.count * 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFWorkAssessmentCell * cell = [tableView dequeueReusableCellWithIdentifier:SFWorkAssessmentCellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        
        if (self.model.addScoreDetail.count > 0) {
            SocreDetailModel * model = self.addScoreArray[indexPath.row];
            cell.model = model;
        }
        
    }else{
        if (self.model.subScoreDetail.count > 0) {
            SocreDetailModel * model = self.subScoreArray[indexPath.row];
            cell.model = model;
        }
    }
    @weakify(self)
    [cell setSelectSocreClick:^(ScoreListModel * _Nonnull mode) {
        @strongify(self)
        
        if (isEmployee) {
            
            [self selectScoreIsEmpModel:mode];
        }else{
            [self selectScoreModel:mode];
        }
        
    }];
    
    return cell;
}

- (void)selectScoreIsEmpModel:(ScoreListModel *)model {
    
    SFWorkOneButtonView * buView = [SFWorkOneButtonView shareSFWorkOneButtonView];
    [buView showFromView:LSKeyWindow withModel:model actionBlock:^{
        
        
    }];
}

- (void)selectScoreModel:(ScoreListModel *)model {
    
    SFWorkTwoButtonView * buView = [SFWorkTwoButtonView shareSFWorkTwoButtonView];
    [buView showFromView:LSKeyWindow withModel:model actionBlock:^{
        
        SFCustomPopView * popView = [SFCustomPopView shareSFCustomPopView];
        [popView showFromView:LSKeyWindow actionBlock:^{
            if ([model.scoreStatus isEqualToString:@"CANCELED"]) {
                [self postWorkAssess:model withStatue:@"RECOVER"];
            }else{
                [self postWorkAssess:model withStatue:@"CANCEL"];
            }
        }];
        if ([model.scoreStatus isEqualToString:@"CANCELED"]) {
            popView.contentLabel.text = @"您确定要恢复这条记录吗？";
            
        }else{
            popView.contentLabel.text = @"您确定要撤销这条记录吗？";
        }
        
    }];
    if ([model.scoreStatus isEqualToString:@"CANCELED"]) {
        [buView.cancelButton setTitle:@"恢复该分数" forState:UIControlStateNormal];
    }else{
        [buView.cancelButton setTitle:@"撤销该分数" forState:UIControlStateNormal];
    }
}

- (void)postWorkAssess:(ScoreListModel *)mod withStatue:(NSString *)statue{

    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:statue forKey:@"process"];

    [SFWorkAssessHttpModel postWorkAssessCheckAssessId:mod._id withProcess:dict success:^{
        
        if ([statue isEqualToString:@"RECOVER"]) {
            [MBProgressHUD showTipMessageInView:@"恢复成功"];
        }else{
            [MBProgressHUD showTipMessageInView:@"撤销成功"];
        }
        self.model = nil;
        [self requestData];
        
    } failure:^(NSError * _Nonnull error) {
        if ([statue isEqualToString:@"RECOVER"]) {
            [MBProgressHUD showTipMessageInView:@"恢复失败"];
        }else{
             [MBProgressHUD showTipMessageInView:@"撤销失败"];
        }
       
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


@end
