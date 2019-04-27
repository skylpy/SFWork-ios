
//
//  SFTrackWorkViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTrackWorkViewController.h"
#import "SFTrackDateilViewController.h"
#import "SFTrackWorksView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SFSuperSuborViewController.h"
#import "SFPickerView.h"
#import "SFTrackManager.h"
#import <AMapTrackKit/AMapTrackKit.h>
#import "SFMyAnnotationView.h"
#import "SFPointAnnotation.h"
#import "SFTrackButtonView.h"

//#define kAMapTrackServiceID  @"31615"
//#define kAMapTrackTerminalID @"60804792"

@interface SFTrackWorkViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,DateTimePickerViewDelegate,SFPickerViewDelegate,AMapTrackManagerDelegate,SFSuperSuborViewControllerDelagete>{
    
     BOOL _correction;
}

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) SFTrackWorksView *trackWorkView;

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) SFTrackWorksModel *model;
@property (nonatomic, strong) AMapTrackManager *trackManager;
//当前
@property (nonatomic, assign) NSInteger currentTimestamp;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, copy) NSString *serviceID;
@property (nonatomic, copy) NSString *terminalID;
//轨迹分页
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) SFTrackButtonView *trackButtonView;

@end

@implementation SFTrackWorkViewController

- (NSMutableArray *)points{
    
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

- (SFTrackButtonView *)trackButtonView{
    
    if (!_trackButtonView) {
        _trackButtonView = [SFTrackButtonView shareSFTrackButtonView];
    }
    return _trackButtonView;
}

- (SFTrackWorksView *)trackWorkView{
    
    if (!_trackWorkView) {
        _trackWorkView = [SFTrackWorksView shareSFTrackWorkView];
        _trackWorkView.array = [SFTrackWorksModel shareTrackModel];
        @weakify(self)
        [_trackWorkView setSelectTrackClick:^(SFTrackWorksModel * _Nonnull model) {
            @strongify(self)
            self.model = model;
            switch (model.type) {
                case 1:
                {
                    SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
                    vc.delagete = self;
                    vc.type = singleType;
                    vc.isSubor = YES;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                    [self selectTime:DatePickerViewDateMode];
                    break;
                case 3:
                     [self customArr:@[@"原始点路径",@"轨道纠偏路径"] withRow:0];
                    break;
                default:
                    break;
            }
        }];
    }
    return _trackWorkView;
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    
    self.model.destitle = employee.name;
    
    [self.trackWorkView.tableView reloadData];
    self.terminalID = employee.terminalId;
    self.serviceID = employee.sid;
    self.pageIndex = 1;
    [self queryTrackHisAction:nil];
}

- (void)selectTime:(DatePickerViewMode)type{
    
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    
    pickerView.delegate = self;
    pickerView.titleL.text = @"请选择日期";
    pickerView.pickerViewMode = type;
    [LSKeyWindow addSubview:pickerView];
    [pickerView showDateTimePickerView];
}
#pragma mark - delegate

- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSLog(@"%@",date);
    self.model.destitle = date;
    
    [self.trackWorkView.tableView reloadData];
    self.currentTimestamp = [NSDate timeSwitchTimestamp:date andFormatter:@"yyyy-MM-dd"];
    self.pageIndex = 1;
    [self queryTrackHisAction:nil];
}

- (void)customArr:(NSArray *)array withRow:(NSInteger)row{
    
    SFPickerView *picker = [[SFPickerView alloc] initWithFrame:self.view.bounds];
    picker.delegate = self ;
    picker.row = row;
    picker.customArr = array;
    [LSKeyWindow addSubview:picker];
}
#pragma mark- SFPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text withRow:(NSInteger)row withSelectIndex:(NSInteger)selectIndex{
    
    
    self.model.destitle = text;
    
    [self.trackWorkView.tableView reloadData];
    
    if ([text isEqualToString:@"轨道纠偏路径"]) {
        _correction = YES;
    }else{
        _correction = NO;
    }
    self.pageIndex = 1;
    [self queryTrackHisAction:nil];
}


- (MAMapView *)mapView{
    
    if (!_mapView) {
        ///初始化地图
        MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
        mapView.delegate = self;
        mapView.zoomLevel = 18;
        mapView.showsCompass = NO;
        _mapView = mapView;
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
//        mapView.showsUserLocation = YES;
//        mapView.userTrackingMode = MAUserTrackingModeFollow;
        
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作轨迹";
    [self setDrawUI];
    
    [self initTrackManager];
    
}

- (void)setDrawUI {

    self.serviceID = kAMapTrackServiceID;
    self.terminalID = kAMapTrackTerminalID;
    self.pageIndex = 1;
    self.currentTimestamp = [NSDate timeSwitchTimestamp:[NSDate dateWithFormat:@"yyyy-MM-dd"] andFormatter:@"yyyy-MM-dd"];
    [self.view addSubview:self.trackWorkView];
    [self.trackWorkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.offset(121);
    }];
    
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trackWorkView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.trackButtonView];
    [self.trackButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-88);
        make.height.offset(132);
        make.width.offset(44);
    }];
    
    @weakify(self)
    AppLocal(15)
    [self.trackButtonView setSelectTag:^(NSInteger tag) {
        @strongify(self)
        
        switch (tag) {
            case 0:
            {
                self.pageIndex ++;
                [self queryTrackHisAction:nil];
            }
                break;
            case 1:
            {
                if (self.mapView.zoomLevel < 19 && self.mapView.zoomLevel > 2) {
                    
                    self.mapView.zoomLevel +=1;
                }
            }
                break;
            case 2:
            {
                if (self.mapView.zoomLevel < 20 && self.mapView.zoomLevel > 2) {
                    
                    self.mapView.zoomLevel -=1;
                }
            }
                break;
            default:
                break;
        }
    }];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 40, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"详情" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            SFTrackDateilViewController * vc = [SFTrackDateilViewController new];
            vc.data = self.points;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _rightButton;
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
    
    [self queryTrackHisAction:nil];
}

#pragma mark - Actions

- (void)queryTrackInfoAction:(UIButton *)button {
    //查询Track信息
    AMapTrackQueryTrackInfoRequest *request = [[AMapTrackQueryTrackInfoRequest alloc] init];
    request.serviceID = self.trackManager.serviceID;
    request.terminalID = self.terminalID;
    request.startTime = ([[NSDate date] timeIntervalSince1970] - 12*60*60) * 1000;
    request.endTime = [[NSDate date] timeIntervalSince1970] * 1000;
//    if (_correction) {
//        request.correctionMode = @"denoise=1,mapmatch=1,threshold=0,mode=driving";
//    }
//    if (_recoup) {
//        request.recoupMode = AMapTrackRecoupModeDriving;
//    }
    
    [self.trackManager AMapTrackQueryTrackInfo:request];
}

- (void)queryTrackHisAction:(UIButton *)button {
    //查询历史轨迹和距离
    AMapTrackQueryTrackHistoryAndDistanceRequest *request = [[AMapTrackQueryTrackHistoryAndDistanceRequest alloc] init];
    request.serviceID = self.trackManager.serviceID;
    request.terminalID = self.terminalID;
    request.startTime = self.currentTimestamp;
    request.endTime = self.currentTimestamp+86400000;
    request.recoupGap = 500;
    request.recoupMode = AMapTrackRecoupModeNone;
    request.pageIndex = self.pageIndex;
    request.pageSize = 999;
    if (_correction) {
        request.correctionMode = @"driving";
    }
//    if (_recoup) {
//        request.recoupMode = AMapTrackRecoupModeDriving;
//    }
    [MBProgressHUD showActivityMessageInView:@"加载中.."];
    [self.trackManager AMapTrackQueryTrackHistoryAndDistance:request];
}


#pragma mark - Helper

- (void)showPolylineWithTrackPoints:(NSArray<AMapTrackPoint *> *)points {
    int pointCount = (int)[points count];
    
    CLLocationCoordinate2D *allCoordinates = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < pointCount; i++) {
        allCoordinates[i].latitude = [[points objectAtIndex:i] coordinate].latitude;
        allCoordinates[i].longitude = [[points objectAtIndex:i] coordinate].longitude;
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:allCoordinates count:pointCount];
    [self.mapView addOverlay:polyline];
    
    if (allCoordinates) {
        free(allCoordinates);
        allCoordinates = NULL;
    }
}

#pragma mark - AMapTrackManagerDelegate

- (void)didFailWithError:(NSError *)error associatedRequest:(id)request {
    NSLog(@"didFailWithError:%@; --- associatedRequest:%@;", error, request);
    [MBProgressHUD hideHUD];
    [MBProgressHUD showTipMessageInWindow:@"请检查您的网络"];
}

- (void)onQueryTrackHistoryAndDistanceDone:(AMapTrackQueryTrackHistoryAndDistanceRequest *)request response:(AMapTrackQueryTrackHistoryAndDistanceResponse *)response {
    NSLog(@"onQueryTrackHistoryAndDistanceDone%@", response.formattedDescription);

    [MBProgressHUD hideHUD];
    
    [self.mapView removeOverlays:[self.mapView overlays]];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.pageIndex == 1) {
         [self.points removeAllObjects];
    }
   
    [self.points addObjectsFromArray:[response points]];
    if (self.points.count > 0) {
        
//        if (![self.points containsObject:response.endPoint]) {
//            [self.points addObject:response.endPoint];
//        }
        [self showPolylineWithTrackPoints:self.points];
        [self.mapView showOverlays:self.mapView.overlays animated:NO];
        
        SFPointAnnotation *startpointAnnotation = [[SFPointAnnotation alloc] init];
        startpointAnnotation.coordinate = CLLocationCoordinate2DMake(response.startPoint.coordinate.latitude, response.startPoint.coordinate.longitude);
        startpointAnnotation.siteNumber = 0;
        [self.mapView addAnnotation:startpointAnnotation];
        
        SFPointAnnotation *endpointAnnotation = [[SFPointAnnotation alloc] init];
        endpointAnnotation.coordinate = CLLocationCoordinate2DMake(response.endPoint.coordinate.latitude, response.endPoint.coordinate.longitude);
        endpointAnnotation.siteNumber = 1;
        [self.mapView addAnnotation:endpointAnnotation];
    }
   
    
    if ([[response points] count] > 0) {
        
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    NSLog(@"=====%@",annotation.title)
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        SFMyAnnotationView*annotationView = (SFMyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[SFMyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];

        }

        SFPointAnnotation *ano=annotation;
        annotationView.enabled = NO;
        annotationView.selected = NO;
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        if (ano.siteNumber == 0) {
            annotationView.image = [UIImage imageNamed:@"icon_the_starting_point_green"];
        }else{
            annotationView.image = [UIImage imageNamed:@"icon_destination_red"];
        }
        
        annotationView.calltitle = annotation.title;
        
        return annotationView;
    }
    return nil;
}


- (void)onQueryTrackInfoDone:(AMapTrackQueryTrackInfoRequest *)request response:(AMapTrackQueryTrackInfoResponse *)response {
    NSLog(@"onQueryTrackInfoDone%@", response.formattedDescription);
    
    [self.mapView removeOverlays:[self.mapView overlays]];
    for (AMapTrackBasicTrack *track in response.tracks) {
        if ([[track points] count] > 0) {
            [self showPolylineWithTrackPoints:[track points]];
        }
    }
    [self.mapView showOverlays:self.mapView.overlays animated:NO];
}

#pragma mark - MapView Delegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        
        MAPolylineRenderer * polylineRenderer = [[MAPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 15.f;

        polylineRenderer.strokeImage = [UIImage imageNamed:@"arrow_down_64x64@2x"];

        return polylineRenderer;
    }
    
    return nil;
}

- (void)dealloc {
    
    NSLog(@"释放 ====== trackManager");
    [self.trackManager stopService];
    self.trackManager.delegate = nil;
    self.trackManager = nil;
    
}

@end
