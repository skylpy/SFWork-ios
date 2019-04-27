//
//  SFAnnotationView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "SFCalloutView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAnnotationView : MAAnnotationView

@property (nonatomic, strong) SFCalloutView *calloutView;
@property (nonatomic, copy) NSString *calltitle;

@end

NS_ASSUME_NONNULL_END
