//
//  SFComStatisticsViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFComStatisticsViewController.h"
#import "SFStatisticsHeaderView.h"
#import "SFChatTableCell.h"
#import "SFVisitTitleCell.h"
#import "TFDropDownMenuView.h"
#import "SFVisitHttpModel.h"
#import "SFStatisticsModel.h"
#import "SFStatisticesView.h"
#import "SFDataReportHttpModel.h"

static NSString * const SFChatTableCellID = @"SFChatTableCellID";
static NSString * const SFVisitTitleCellID = @"SFVisitTitleCellID";

@interface SFComStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource,TFDropDownMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) TFDropDownMenuView *menu;

@property (nonatomic, strong) NSMutableArray *datasLists;
@property (nonatomic, strong) NSMutableArray *daysLists;
@property (nonatomic, strong) NSArray <StatisticsList *> *array;

@property (nonatomic, strong) NSMutableArray *empArray;
@property (nonatomic, strong) NSMutableArray *empList;

@property (nonatomic, strong) NSMutableArray *data1;
@property (nonatomic, strong) NSMutableArray *data2;

@property (nonatomic, strong) SFStatisticsModel *smodel;
@property (nonatomic, copy) NSString *timeCycle;

@end

@implementation SFComStatisticsViewController

- (NSMutableArray *)data1{
    
    if (!_data1) {
        _data1 = [NSMutableArray array];
    }
    return _data1;
}

- (NSMutableArray *)data2{
    
    if (!_data2) {
        _data2 = [NSMutableArray array];
    }
    return _data2;
}

- (NSMutableArray *)empList{
    
    if (!_empList) {
        
        _empList = [NSMutableArray array];
    }
    return _empList;
}

- (NSMutableArray *)datasLists{
    
    if (!_datasLists) {
        _datasLists = [NSMutableArray array];
    }
    return _datasLists;
}

- (NSMutableArray *)daysLists{
    
    if (!_daysLists) {
        _daysLists = [NSMutableArray array];
    }
    return _daysLists;
}
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)empArray{
    
    if (!_empArray) {
        
        _empArray = [NSMutableArray array];
    }
    return _empArray;
}

- (TFDropDownMenuView *)menu{
    
    if (!_menu) {
        
        TFDropDownMenuView *menu = [[TFDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 45) firstArray:self.data1 secondArray:self.data2];
        _menu = menu;
        menu.itemTextSelectColor = defaultColor;
        menu.cellTextSelectColor = defaultColor;
        menu.delegate = self;
        menu.cellSelectBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        menu.ratioLeftToScreen = 0.35;
        
    }
    return _menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.timeCycle forKey:@"timeCycle"];

    [SFDataReportHttpModel statisticsDataReport:dict success:^(SFStatisticsModel * _Nonnull model) {
        
        self.smodel = model;
        [self.dataArray removeAllObjects];
        [self.datasLists removeAllObjects];
        [self.daysLists removeAllObjects];
        [self.dataArray addObjectsFromArray:model.statisticsDatas];
        if (model.statisticsDatas.count == 0) return ;
        StatisticsList * smodel = model.statisticsDatas[0];
        
        [self.datasLists addObjectsFromArray:smodel.datas];
        [self.daysLists addObjectsFromArray:smodel.days];
        
        NSMutableArray * arr = [NSMutableArray array];
        for (StatisticsList* sm in self.dataArray) {
            [arr addObject:sm.name];
        }
        NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"近三周", @"近三月", @"近半年", @"近一年", nil];
        self.data1 = [NSMutableArray arrayWithObjects:array1, arr,  nil];
        self.data2 = [NSMutableArray arrayWithObjects:@[], @[], nil];
        self.menu.firstArray = self.data1;
        self.menu.secondArray = self.data2;
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setDrawUI {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = bgColor;
    self.timeCycle = @"WEEK";
    [self.tableView registerNib:[UINib nibWithNibName:@"SFChatTableCell" bundle:nil] forCellReuseIdentifier:SFChatTableCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFVisitTitleCell" bundle:nil] forCellReuseIdentifier:SFVisitTitleCellID];
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"近一周", @"近一月", @"近半年", @"近一年", nil];
    NSMutableArray *array2 = [NSMutableArray arrayWithObjects: @"今日客户数", @"今日营业额",@"今日销售额",@"今日销售额", nil];
    
    self.data1 = [NSMutableArray arrayWithObjects:array1, array2,  nil];
    self.data2 = [NSMutableArray arrayWithObjects:@[], @[], nil];
    self.tableView.tableHeaderView = self.menu;
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 250;
    }
    return 45;
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
    
    if (indexPath.section == 0) {
        SFChatTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFChatTableCellID forIndexPath:indexPath];
        
        [cell cellWithDatas:@[self.datasLists] withDays:self.daysLists];
        return cell;
    }
    
    SFVisitTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFVisitTitleCellID forIndexPath:indexPath];
    StatisticsList * model = self.dataArray[indexPath.row];
    cell.smodel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)menuView:(TFDropDownMenuView *)menu selectIndex:(TFIndexPatch *)index {
    NSLog(@"index: %ld,%ld,%ld", index.column,index.section,index.row);
    
    self.smodel = nil;
    if (index.column == 0) {
        switch (index.section) {
            case 0:
                self.timeCycle = @"WEEK";
                break;
            case 2:
                self.timeCycle = @"MONTH";
                break;
            case 3:
                self.timeCycle = @"SEASON";
                break;
            case 4:
                self.timeCycle = @"HALF_YEAR";
                break;
            case 5:
                self.timeCycle = @"YEAR";
                break;
            default:
                break;
        }
        [self requestData];
    }else{
        StatisticsList * smodel = self.dataArray[index.section];
        [self.datasLists removeAllObjects];
        [self.daysLists removeAllObjects];
        [self.datasLists addObjectsFromArray:smodel.datas];
        [self.daysLists addObjectsFromArray:smodel.days];
        [self.tableView reloadData];
    }
}

- (void)menuView:(TFDropDownMenuView *)menu tfColumn:(NSInteger)column {
    NSLog(@"column: %ld", column);
}


@end