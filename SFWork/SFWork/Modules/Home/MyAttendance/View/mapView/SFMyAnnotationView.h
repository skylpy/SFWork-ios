//
//  SFMyAnnotationView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "SFCustomCalloutView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFMyAnnotationView : MAAnnotationView

@property (nonatomic, strong) SFCustomCalloutView *calloutView;
@property (nonatomic, copy) NSString *calltitle;

@end

NS_ASSUME_NONNULL_END
