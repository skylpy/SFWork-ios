//
//  SFPunchPositionViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SFPunchPositionViewController : SFBaseViewController<UISearchBarDelegate,MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic,  copy ) void(^selectedEvent)(CLLocationCoordinate2D coordinate , NSString *addressName, NSString *province, NSString *city, NSString *distract, NSString *address,NSString * distance);

@end

NS_ASSUME_NONNULL_END
