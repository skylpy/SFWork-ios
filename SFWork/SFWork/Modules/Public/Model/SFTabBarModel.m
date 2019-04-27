//
//  SFTabBarModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTabBarModel.h"

@implementation SFTabBarModel

+ (NSArray *)shareManage {
    
    SFTabBarModel * model1 = [SFTabBarModel manageTitle:@"首页" withImage:@"icon_homepage_gray" withController:@"icon_homepage_green"];
    SFTabBarModel * model2 = [SFTabBarModel manageTitle:@"消息" withImage:@"icon_message_gray" withController:@"icon_message_green"];
    SFTabBarModel * model3 = [SFTabBarModel manageTitle:@"统计" withImage:@"icon_statistics_gray" withController:@"icon_statistics_green"];
    SFTabBarModel * model4 = [SFTabBarModel manageTitle:@"设置" withImage:@"icon_set_gray" withController:@"icon_set_green"];
    
    return @[model1,model2,model3,model4];
}

+ (SFTabBarModel *)manageTitle:(NSString *)title withImage:(NSString *)normalImageName withController:(NSString *)selectImageName{
    
    SFTabBarModel * model = [[SFTabBarModel alloc] init];
    model.title = title;
    model.normalImageName = normalImageName;
    model.selectImageName = selectImageName;
    return model;
}

@end
