//
//  SFRealTimeListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFRealTimeListViewController.h"
#import <AMapTrackKit/AMapTrackKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SFRealTimeCell.h"

static NSString * const SFRealTimeCellID = @"SFRealTimeCellID";


@interface SFRealTimeListViewController ()<UITableViewDelegate,UITableViewDataSource,AMapTrackManagerDelegate,AMapSearchDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) AMapTrackManager *trackManager;
@property (strong,nonatomic) AMapSearchAPI *search;
@property (nonatomic, copy) NSString *serviceID;
@property (nonatomic, copy) NSString *terminalID;
@property (nonatomic, assign) NSInteger index;

@end

@implementation SFRealTimeListViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"定位统计";
    
    [self setDrawUI];
    [self initTrackManager];
}

- (void)setDrawUI {
    //搜索对象，逆地理编码
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    self.index = 0;
    self.serviceID = kAMapTrackServiceID;
    self.terminalID = kAMapTrackTerminalID;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)setData:(NSArray *)data{
    _data = data;
    
}


- (void)initTrackManager {
    if ([self.serviceID length] <= 0 || [self.terminalID length] <= 0) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您需要指定ServiceID和TerminalID才可以使用轨迹服务"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //Service ID 需要根据需要进行修改
    AMapTrackManagerOptions *option = [[AMapTrackManagerOptions alloc] init];
    option.serviceID = self.serviceID;
    
    //初始化AMapTrackManager
    self.trackManager = [[AMapTrackManager alloc] initWithOptions:option];
    self.trackManager.delegate = self;
    
    //配置定位属性
    [self.trackManager setAllowsBackgroundLocationUpdates:YES];
    [self.trackManager setPausesLocationUpdatesAutomatically:NO];
    
    
    [self requestTrackHisAction];
}

- (void)requestTrackHisAction{
    
    for (int i = 0;i < self.data.count ;i ++) {
        SFEmployeesModel * emp = self.data[i];
        RealTimeListModel * model = [[RealTimeListModel alloc] init];
        model._id = emp._id;
        model.name = emp.name;
        model.sid = emp.sid;
        model.tid = emp.terminalId;
        model.smallAvatar = emp.smallAvatar;
        [self.dataArray addObject:model];
    }
    for (int i = 0;i < self.data.count ;i ++) {
        SFEmployeesModel * emp = self.data[i];
        self.serviceID = emp.sid;
        self.terminalID = emp.terminalId;
        
        [self queryTrackHisAction];
    }
}


- (void)queryTrackHisAction{
    
    AMapTrackQueryLastPointRequest *request = [[AMapTrackQueryLastPointRequest alloc] init];
    request.serviceID = self.serviceID;
    request.terminalID = self.terminalID ;
    [self.trackManager AMapTrackQueryLastPoint:request];
}

- (void)onQueryLastPointDone:(AMapTrackQueryLastPointRequest *)request response:(AMapTrackQueryLastPointResponse *)response
{
    //查询成功
    NSLog(@"onQueryLastPointDone%@", response.formattedDescription);
    
    NSLog(@"response.lastPoint.coordinate.latitude%f", response.lastPoint.coordinate.latitude);
    
    RealTimeListModel * model = self.dataArray[self.index];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:response.lastPoint.locateTime/1000];
    NSString * time = [NSDate stringFromDate:date withFormatter:@"yyyy-MM-dd hh:mm"];
    model.time = time;
    model.minute = [NSString dateTimeDifferenceWithStartTime:[NSDate stringFromDate:date withFormatter:@"yyyy-MM-dd hh:mm"] endTime:[NSDate stringFromDate:[NSDate new] withFormatter:@"yyyy-MM-dd hh:mm"] withFormatter:@"yyyy-MM-dd hh:mm"];
    model.speed = [NSString stringWithFormat:@"%f",response.lastPoint.speed];
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:response.lastPoint.coordinate.latitude longitude:response.lastPoint.coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
    
    
}



/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        NSLog(@"%@",response.regeocode.formattedAddress)
        //解析response获取地址描述，具体解析见 Demo
        NSString *strAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",response.regeocode.addressComponent.province,response.regeocode.addressComponent.city,response.regeocode.addressComponent.district,response.regeocode.addressComponent.township,response.regeocode.addressComponent.neighborhood];
        NSLog(@"%@",strAddress);
         RealTimeListModel * model = self.dataArray[self.index];
        model.address = response.regeocode.formattedAddress;
        
        self.index ++;
        if (self.dataArray.count == self.index){
            
            [self.tableView reloadData];
        }
//        self.annotationView.calltitle = response.regeocode.formattedAddress;
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFRealTimeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFRealTimeCellID forIndexPath:indexPath];
    RealTimeListModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFRealTimeCell" bundle:nil] forCellReuseIdentifier:SFRealTimeCellID];
        
    }
    return _tableView;
}

@end

@implementation RealTimeListModel


@end
