
//
//  SFTrackDateilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTrackDateilViewController.h"
#import <AMapTrackKit/AMapTrackKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SFRealTimeCell.h"
#import "SFTrackListCell.h"

static NSString * const SFTrackListCellID = @"SFTrackListCellID";


@interface SFTrackDateilViewController ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>{
    
    BOOL _correction;
}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (strong,nonatomic) AMapSearchAPI *search;
//当前
@property (nonatomic, assign) NSInteger currentTimestamp;
@property (nonatomic, assign) NSInteger index;

@end

@implementation SFTrackDateilViewController

- (NSMutableArray *)timeArray{
    
    if (!_timeArray) {
        _timeArray = [NSMutableArray array];
    }
    return _timeArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轨迹详情";
    
    self.index = 0;
    [self setDrawUI];
    
}

- (void)setData:(NSArray *)data{
    _data = data;
    NSLog(@"%@",data);
    [self.timeArray removeAllObjects];
   
    for (AMapTrackPoint * point in data) {

        if (point.accuracy < 50) {
            TrackModel * model = [TrackModel new];
            NSDate *date=[NSDate dateWithTimeIntervalSince1970:point.locateTime/1000];
            NSString * time = [NSDate stringFromDate:date];
            model.time = time;
            [self.timeArray addObject:model];
            
        }
    }
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
     
        TrackModel * model = self.timeArray[self.index];
        model.address = response.regeocode.formattedAddress;
        
        self.index ++;
        if (self.timeArray.count == self.index) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.timeArray];

            NSMutableArray *dateMutablearray = [@[] mutableCopy];
            
            for (int i = 0; i < array.count; i ++) {

                TrackModel * mode = array[i];
  
                NSMutableArray *tempArray = [@[] mutableCopy];
 
                [tempArray addObject:mode];

                for (int j = i+1; j < array.count; j ++) {
    
                    TrackModel * mod = array[j];
                    if([mode.time isEqualToString:mod.time]){

                        [tempArray addObject:mod];

                        [array removeObjectAtIndex:j];
                        
                        j -= 1;
                        
                    }
                }

                [dateMutablearray addObject:tempArray];

            }
            [self.dataArray removeAllObjects];
            for (NSArray * arr in dateMutablearray) {
                
                for (int i = 0; i < arr.count; i ++) {
                    
                    if (i == 0) {
                        TrackModel * mode = arr[i];
                        [self.dataArray addObject:mode];
                    }
                }
            }
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
            return;
        }
 
    }
}


- (void)setDrawUI {
    
    self.currentTimestamp = [NSDate timeSwitchTimestamp:[NSDate dateWithFormat:@"yyyy-MM-dd"] andFormatter:@"yyyy-MM-dd"];
    //搜索对象，逆地理编码
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    //请求逆地理编码
    [MBProgressHUD showActivityMessageInView:@"数据在拼命处理中.."];
    for (AMapTrackPoint * point in self.data) {
        
        if (point.accuracy < 50) {
            AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
            
            regeo.location                    = [AMapGeoPoint locationWithLatitude:point.coordinate.latitude  longitude:point.coordinate.longitude];
            regeo.requireExtension            = YES;
            
            [self.search AMapReGoecodeSearch:regeo];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFTrackListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTrackListCellID forIndexPath:indexPath];
    TrackModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFTrackListCell" bundle:nil] forCellReuseIdentifier:SFTrackListCellID];
        
    }
    return _tableView;
}

@end

@implementation TrackModel



@end
