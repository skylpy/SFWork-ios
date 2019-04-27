//
//  SFMapManager.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMapManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SFMyAnnotationView.h"

@interface SFMapManager ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>

@property (nonatomic, strong) MAMapView * mapView;
@property (strong, nonatomic) AMapSearchAPI *search;
@property (nonatomic, strong) SFMyAnnotationView*annotationView;

@end

@implementation SFMapManager

- (MAMapView *)mapView{
    
    if (!_mapView) {
        ///初始化地图
        MAMapView *mapView = [[MAMapView alloc] init];
        _mapView = mapView;
        mapView.delegate = self;
        mapView.zoomLevel = 18;
        mapView.showsCompass = NO;
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        mapView.showsUserLocation = YES;
        mapView.userTrackingMode = MAUserTrackingModeFollow;
        
        
    }
    return _mapView;
}

#pragma mark --创建一个单例类对象
+(instancetype)sharedManager{
    static SFMapManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //初始化单例对象
        instance = [[SFMapManager alloc]init];
    });
    return instance;
}

- (void)showSuperView:(UIView *)superView withFrame:(CGRect)frame{
    
    [superView addSubview:self.mapView];
    self.mapView.frame = frame;
    AMapLocationManager *locationManager = [[AMapLocationManager alloc]init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //   定位超时时间，最低2s，此处设置为10s
    locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    locationManager.reGeocodeTimeout = 2;
    locationManager.delegate = self;
    [locationManager setLocatingWithReGeocode:YES];
    [locationManager startUpdatingLocation];
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
        r.showsAccuracyRing = false;///精度圈是否显示，默认YES
        [mapView updateUserLocationRepresentation:r];
    }
}

-(void)mapView:(MAMapView*)mapView didUpdateUserLocation: (MAUserLocation*)userLocation updatingLocation:(BOOL)updatingLocation{
    
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude, userLocation.location.horizontalAccuracy);
    //请求逆地理编码
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    
    NSLog(@"=====%@",annotation.title)
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        SFMyAnnotationView*annotationView = (SFMyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[SFMyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            self.annotationView = annotationView;
        }
        self.annotationView = annotationView;
        annotationView.enabled = NO;
        annotationView.selected = YES;
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        annotationView.image = [UIImage imageNamed:@"icon_positioning_map_red"];
        annotationView.calltitle = annotation.title;
        
        return annotationView;
    }
    return nil;
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

        self.annotationView.calltitle = response.regeocode.formattedAddress;
        
    }
}

@end
