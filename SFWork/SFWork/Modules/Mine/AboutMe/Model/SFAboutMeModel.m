//
//  SFAboutMeModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAboutMeModel.h"

@implementation SFAboutMeModel

+ (NSArray *)shareAboutModel{
    
    SFAboutMeModel * mine1 = [SFAboutMeModel manageTitle:@"官方网站" withDes:@"www.sanfanerp.com" withController:@"" withType:0];
    SFAboutMeModel * mine2 = [SFAboutMeModel manageTitle:@"服务协议" withDes:@"" withController:@"" withType:1];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    SFAboutMeModel * mine3 = [SFAboutMeModel manageTitle:@"版本更新" withDes:app_Version withController:@"" withType:2];
    SFAboutMeModel * mine4 = [SFAboutMeModel manageTitle:@"销售热线" withDes:@"400-688-1280" withController:@"" withType:3];
//    SFAboutMeModel * mine5 = [SFAboutMeModel manageTitle:@"系统日志" withDes:@"" withController:@"" withType:4];
    
    
    return @[mine1,mine2,mine3,mine4];
    
}

+ (SFAboutMeModel *)manageTitle:(NSString *)title withDes:(NSString *)des withController:(NSString *)controller withType:(NSInteger)type{
    
    SFAboutMeModel * model = [[SFAboutMeModel alloc] init];
    model.title = title;
    model.detitle = des;
    model.controller = controller;
    model.type = type;
    
    return model;
}


@end
