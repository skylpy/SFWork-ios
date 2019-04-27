//
//  SFStatisticalDataViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFStatisticalDataViewController.h"
#import "SFAttenStatiTableCell.h"
#import "SFCircularStatisticsView.h"
#import "SFDepListViewController.h"
#import "SFMyAttendanceHttpModel.h"
#import "SFDepListViewController.h"

static NSString * const SFAttenStatiTableCellID = @"SFAttenStatiTableCellID";

@interface SFStatisticalDataViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *conentView;
@property (nonatomic, strong) SFCircularStatisticsView *progress;
@property (weak, nonatomic) IBOutlet UIView *selectDateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *progView;
@property (nonatomic, copy) NSString *date;

@property (nonatomic, strong) MyAttendanceModel *attModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MyAttendanceStatisticsModel *statisticsModel;
@end

@implementation SFStatisticalDataViewController

- (SFCircularStatisticsView*)progress {
    
    if (!_progress) {
        SFCircularStatisticsView *progress = [[SFCircularStatisticsView alloc] initWithFrame:CGRectZero];
        _progress = progress;
        progress.arcFinishColor = Color(@"#FF9335");//[UIColor lightGrayColor];//Color(@"#3699FF");
        
        progress.arcUnfinishColor = Color(@"#01B38B");
        progress.arcTitleColor = Color(@"#01B38B");
        progress.arcBackColor = Color(@"#FF9335");//[UIColor lightGrayColor];//Color(@"#EAEAEA");
        progress.width = 11;
        progress.percent = 0.7;
        
        progress.fontSize = 24;
    }
    return _progress;
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
    
    [self getNoti];
}

- (void)getNoti {
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"AttendanceRules" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        
        self.attModel = x.object;
        [self requestData];
    }];
}

- (void)requestData{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.attModel.permissionType forKey:@"type"];
    [dict setValue:self.date forKey:@"qCreateTime"];
    
    [MBProgressHUD showActivityMessageInView:@""];
    [SFMyAttendanceHttpModel getAttendanceStatistics:dict success:^(MyAttendanceStatisticsModel * _Nonnull model) {
        
        [MBProgressHUD hideHUD];
        self.statisticsModel = model;
        self.progress.chartTitleView.normalLabel.text = [NSString stringWithFormat:@"正常%@人",model.NORMAL];
        self.progress.chartTitleView.abnormalLabel.text = [NSString stringWithFormat:@"异常%@人",model.ABNORMAL];
        self.progress.percent = [model.NORMAL floatValue]/([model.NORMAL floatValue]+ [model.ABNORMAL floatValue])-0.0001;
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    self.bgView.backgroundColor = bgColor;
    self.conentView.layer.cornerRadius = 3;
    self.conentView.clipsToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = bgColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SFAttenStatiTableCell" bundle:nil] forCellReuseIdentifier:SFAttenStatiTableCellID];
    
    [self.progView addSubview:self.progress];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progView);
        make.top.equalTo(self.progView.mas_top).offset(60);
        make.height.width.offset(130);
    }];
    self.date = [NSDate dateWithFormat:@"yyyy-MM-dd"];
    self.dateLabel.text = [NSDate dateWithFormat:@"yyyy-MM-dd"];
    @weakify(self)
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] init];
    [[tapGesture1 rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self selectTime:DatePickerViewDateMode];
    }];
    [self.selectDateView addGestureRecognizer:tapGesture1];
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
    self.dateLabel.text = date;
    self.date = date;
    [self requestData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFAttenStatiTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAttenStatiTableCellID forIndexPath:indexPath];

    NSString * title = @"";
    switch (indexPath.row) {
        case 0:
            title = [NSString stringWithFormat:@"迟到%@人",self.statisticsModel.LATE];
            break;
        case 1:
            title = [NSString stringWithFormat:@"早退%@人",self.statisticsModel.EARLY];
            break;
        case 2:
            title = [NSString stringWithFormat:@"缺卡%@人",self.statisticsModel.MISSING];
            break;
        case 3:
            title = [NSString stringWithFormat:@"外出%@人",self.statisticsModel.OUT];
            break;
        case 4:
            title = [NSString stringWithFormat:@"请假%@人",self.statisticsModel.LEAVE];
            break;
        case 5:
            title = [NSString stringWithFormat:@"出差%@人",self.statisticsModel.BUSINESS_TRAVEL];
            break;
        case 6:
            title = [NSString stringWithFormat:@"加班%@人",self.statisticsModel.OVERTIME];
            break;
        
        default:
            break;
    }
    cell.titleLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFDepListViewController * vc = [[UIStoryboard storyboardWithName:@"MyAttendance" bundle:nil] instantiateViewControllerWithIdentifier:@"SFDepList"];
    switch (indexPath.row) {
        case 0:
        {
            vc.isAtten = YES;
            vc.atype = @"LATE";
            vc.type = self.attModel.permissionType;
        }
            break;
        case 1:
        {
            vc.isAtten = YES;
            vc.atype = @"EARLY";
            vc.type = self.attModel.permissionType;
        }
            break;
        case 2:
        {
            vc.isAtten = YES;
            vc.atype = @"MISSING";
            vc.type = self.attModel.permissionType;
        }
            break;
        case 3:
        {
            vc.isAtten = YES;
            vc.atype = @"LATES";
            vc.type = self.attModel.permissionType;
        }
            break;
        case 4:
        {
            vc.isAtten = NO;
            vc.atype = @"LEAVE";
            vc.type = self.attModel.permissionType;
        }
            break;
        case 5:
        {
            vc.isAtten = NO;
            vc.atype = @"BUSINESS_TRAVEL";
            vc.type = self.attModel.permissionType;
        }
            break;
        case 6:
        {
            vc.isAtten = NO;
            vc.atype = @"OVERTIME";
            vc.type = self.attModel.permissionType;
        }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}



@end
