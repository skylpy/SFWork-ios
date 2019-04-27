//
//  SFMineModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMineModel.h"

@implementation SFMineModel

+ (NSArray *)shareSoftwareSetModel{
    
    SFMineModel * mine1 = [SFMineModel manageTitle:@"消息订阅" withImage:@"icon_personal_information_black" withController:@"" withType:0];
    SFMineModel * mine2 = [SFMineModel manageTitle:@"提醒设置" withImage:@"icon_enterprise_black" withController:@"" withType:1];
    SFMineModel * mine3 = [SFMineModel manageTitle:@"模块管理" withImage:@"icon_salary_black" withController:@"" withType:2];
    SFMineModel * mine4 = [SFMineModel manageTitle:@"后台设置" withImage:@"icon_backstage_black" withController:@"" withType:3];
    
    
    return @[mine1,mine2,mine3,mine4];
    
}

+ (NSArray *)shareCompanySetModel{
    
    SFMineModel * mine1 = [SFMineModel manageTitle:@"考勤管理" withImage:@"icon_personal_information_black" withController:@"SFAttendanceSetViewController" withType:0];
    SFMineModel * mine2 = [SFMineModel manageTitle:@"手机绑定" withImage:@"icon_enterprise_black" withController:@"" withType:1 ];
    SFMineModel * mine3 = [SFMineModel manageTitle:@"节假日设置" withImage:@"icon_salary_black" withController:@"" withType:2];
    
    NSArray * array1 = @[mine1,mine2,mine3];
    
    SFMineModel * mine4 = [SFMineModel manageTitle:@"客户区域" withImage:@"icon_backstage_black" withController:@"" withType:3];
    SFMineModel * mine5 = [SFMineModel manageTitle:@"客户等级" withImage:@"icon_about_us_black" withController:@"" withType:4];
    SFMineModel * mine6 = [SFMineModel manageTitle:@"客户类型" withImage:@"icon_about_us_black" withController:@"" withType:5];
    SFMineModel * mine7 = [SFMineModel manageTitle:@"意向类型" withImage:@"icon_about_us_black" withController:@"" withType:6];
    
    NSArray * array2 = @[mine4,mine5,mine6,mine7];
    
    SFMineModel * mine8 = [SFMineModel manageTitle:@"职位类型" withImage:@"icon_about_us_black" withController:@"" withType:7];
    SFMineModel * mine9 = [SFMineModel manageTitle:@"拍照类型" withImage:@"icon_about_us_black" withController:@"" withType:8];
    SFMineModel * mine10 = [SFMineModel manageTitle:@"任务类型" withImage:@"icon_about_us_black" withController:@"" withType:9];
    SFMineModel * mine11 = [SFMineModel manageTitle:@"请假类型" withImage:@"icon_about_us_black" withController:@"" withType:10];
//    SFMineModel * mine12 = [SFMineModel manageTitle:@"日报设置" withImage:@"icon_about_us_black" withController:@"" withType:11];
    SFMineModel * mine13 = [SFMineModel manageTitle:@"拜访设置" withImage:@"icon_about_us_black" withController:@"" withType:12];
    
    NSArray * array3 = @[mine8,mine9,mine10,mine11,mine13];
    
    return @[array1,array2,array3];
    
}



+ (NSArray *)shareMineModel{
    
    SFMineModel * mine1 = [SFMineModel manageTitle:@"个人信息" withImage:@"icon_personal_information_black" withController:@"SFProfileViewController" withType:0];
    
    SFMineModel * mine2 = [SFMineModel manageTitle:@"企业设置" withImage:@"icon_enterprise_black" withController:@"SFCompanySetViewController" withType:1];
//    SFMineModel * mine3 = [SFMineModel manageTitle:@"员工薪资" withImage:@"icon_salary_black" withController:@"SFBusinessPlanViewController"withType:2];
    SFMineModel * mine4 = [SFMineModel manageTitle:@"软件设置" withImage:@"icon_backstage_black" withController:@"SFSoftwareSetViewController" withType:3];
    SFMineModel * mine5 = [SFMineModel manageTitle:@"关于我们" withImage:@"icon_about_us_black" withController:@"SFAboutMeViewController" withType:4];
    NSArray * arrs = [SFInstance shareInstance].userInfo.permissions;
    
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:mine1];
    for (PermissionsModel * model in arrs) {
        
        if ([model.code isEqualToString:@"companySetting"]&&model.hasPermission) {
            [array addObject:mine2];
        }
    }
    [array addObject:mine4];
    [array addObject:mine5];
    return array;
    
}

+ (SFMineModel *)manageTitle:(NSString *)title withImage:(NSString *)icon withController:(NSString *)controller withType:(NSInteger)type{
    
    SFMineModel * model = [[SFMineModel alloc] init];
    model.title = title;
    model.icon = icon;
    model.controller = controller;
    model.type = type;
    
    return model;
}

@end
