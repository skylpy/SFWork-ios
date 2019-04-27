//
//  SFProfileModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFProfileModel.h"
#import "SFOrganizationModel.h"
@implementation SFProfileModel

+ (NSMutableDictionary *)pramGetDepSetJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (SFProfileModel * model in data) {
        [array addObject:model];
    }
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFProfileModel * model = (SFProfileModel *)obj;
        
        switch (model.type) {
            case 0:
                [dict setObject:model.destitle forKey:@"name"];
                break;
            default:
                
                break;
        }
    }];
    return dict;
}

+ (NSMutableDictionary *)pramGetDepJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFProfileModel * model = (SFProfileModel *)obj;
        
        switch (model.type) {
            case 0:
                [dict setObject:model.destitle forKey:@"name"];
                break;
            default:
                [dict setObject:model.value forKey:@"parentId"];
                break;
        }
    }];
    return dict;
}

+ (NSMutableDictionary *)pramEmployeeJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray * arr in data) {
        
        for (SFProfileModel * model in arr) {
            [array addObject:model];
        }
    }
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFProfileModel * model = (SFProfileModel *)obj;
        
        switch (model.type) {
            case 0:
                [dict setObject:model.destitle forKey:@"avatar"];
                break;
            case 1:
                [dict setObject:model.destitle forKey:@"name"];
                break;
            case 2:
                [dict setObject:@"MALE" forKey:@"gender"];
                break;
            case 3:
                [dict setObject:model.destitle forKey:@"phone"];
                break;
            case 4:
                [dict setObject:model.destitle forKey:@"plainPassword"];
                break;
            case 5:
                [dict setObject:model.destitle forKey:@"departmentId"];
                break;
            case 6:
//                [dict setObject:model.destitle forKey:@"name"];
                break;
            case 7:
                [dict setObject:model.value forKey:@"positionId"];
                break;
            case 8:
                [dict setObject:model.destitle forKey:@"email"];
                break;
            case 9:
                [dict setObject:model.destitle forKey:@"workNumber"];
                break;
            case 10:
                [dict setObject:model.destitle forKey:@"name"];
                break;
            case 11:
                [dict setObject:model.destitle forKey:@"name"];
                break;
            case 12:
                [dict setObject:model.value forKey:@"status"];
                break;
            default:
                [dict setObject:@([model.value boolValue]) forKey:@"hiddenPhone"];
                break;
        }
    }];
    return dict;
}

+ (NSArray *)shareDepSetModel:(SFOrgListModel *)model withDepName:(NSString *)depName withParentId:(NSString *)parentId{
    
    NSString * admin = @"";
    for (int i = 0; i < model.admins.count; i ++) {
        
        SFEmployeesModel * adminM = model.admins[i];
        if (i == 0) {
            admin = adminM.name;
        }else{
            admin = [NSString stringWithFormat:@"%@,%@",admin,adminM.name];
        }
    }
    
    SFProfileModel * mine1 = [SFProfileModel manageTitle:@"部门名称" withDestitle:model.name withPlaceholder:@"请输入"  withStars:@"" withDescolor:@"" withClick:YES withType:0 withValue:model._id];
    
    SFProfileModel * mine2 = [SFProfileModel manageTitle:@"部门管理员" withDestitle:admin withPlaceholder:@"请设置部门管理员" withStars:@"" withDescolor:@""  withClick:NO withType:1 withValue:@""];
    
    SFProfileModel * mine3 = [SFProfileModel manageTitle:@"上级部门" withDestitle:depName withPlaceholder:@"公司" withStars:@"" withDescolor:@""  withClick:NO withType:2 withValue:parentId];
    
    return @[mine1,mine2,mine3];
}

+ (NSArray *)shareSalaryModel:(NSString *)empName withSalary:(NSString *)salary {
    
    SFProfileModel * mine1 = [SFProfileModel manageTitle:@"员工姓名：" withDestitle:empName withPlaceholder:@""  withStars:@"" withDescolor:@"" withClick:NO withType:0 withValue:@""];
    SFProfileModel * mine2 = [SFProfileModel manageTitle:@"工资：" withDestitle:salary withPlaceholder:@"请输入" withStars:@"" withDescolor:@""  withClick:YES withType:1 withValue:@""];
    
    return @[mine1,mine2];
}

+ (NSArray *)shareDepModel:(NSString *)parentName withParentId:(NSString *)parentId{
    
    SFProfileModel * mine1 = [SFProfileModel manageTitle:@"部门名称" withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"" withDescolor:@"" withClick:YES withType:0 withValue:@""];
    SFProfileModel * mine2 = [SFProfileModel manageTitle:@"上级部门" withDestitle:parentName withPlaceholder:@"公司" withStars:@"" withDescolor:@""  withClick:NO withType:1 withValue:parentId];
    
    return @[mine1,mine2];
}

+ (NSArray *)shareProfileModel:(SFEmployeesModel *)employees depName:(NSString *)depname withIsOrg:(BOOL)isOrg{
    
    
    SFProfileModel * mine1 = [SFProfileModel manageTitle:@"头像" withDestitle:employees.avatar withPlaceholder:@""  withStars:@"" withDescolor:@"" withClick:NO withType:0 withValue:employees.avatar];
    
    NSString * name = employees == nil ? @"" : employees.name ;
    SFProfileModel * mine2 = [SFProfileModel manageTitle:@"姓名" withDestitle:name withPlaceholder:@"请输入" withStars:@"*" withDescolor:@""  withClick:YES withType:1 withValue:@""];
    
    NSString * gender = [employees.gender isEqualToString:@"MALE"]?@"男":@"女";
    SFProfileModel * mine3 = [SFProfileModel manageTitle:@"性别" withDestitle:gender withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    
    NSString * phone = employees == nil ? @"" : employees.phone ;
    SFProfileModel * mine4 = [SFProfileModel manageTitle:@"手机号" withDestitle:phone withPlaceholder:@"请输入" withStars:@"*" withDescolor:@""  withClick:YES withType:3 withValue:@""];
    
    NSString * plainPassword = employees == nil ? @"" : employees.plainPassword ;
    SFProfileModel * mine5 = [SFProfileModel manageTitle:@"密码" withDestitle:plainPassword withPlaceholder:@"请输入" withStars:@"*" withDescolor:@""  withClick:YES withType:4 withValue:@"" ];
    
    SFProfileModel * mine6 = [SFProfileModel manageTitle:@"部门" withDestitle:depname withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:5 withValue:@""];
    SFProfileModel * mine7 = [SFProfileModel manageTitle:@"考勤分组" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:6 withValue:@""];
    
//    NSString * positionName = employees.positionName ? @""
    SFProfileModel * mine8 = [SFProfileModel manageTitle:@"职位" withDestitle:employees.positionName withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:7 withValue:employees.positionId];
    SFProfileModel * mine9 = [SFProfileModel manageTitle:@"邮箱" withDestitle:employees.email withPlaceholder:@"请输入" withStars:@"" withDescolor:@""  withClick:YES withType:8 withValue:@""];
    SFProfileModel * mine10 = [SFProfileModel manageTitle:@"工号" withDestitle:employees.workNumber withPlaceholder:@"请输入" withStars:@"" withDescolor:@""  withClick:YES withType:9 withValue:@""];
    SFProfileModel * mine11 = [SFProfileModel manageTitle:@"入职时间" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:10 withValue:@""];
    
    SFProfileModel * mine12 = [SFProfileModel manageTitle:@"办公地点" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@""  withClick:YES withType:11 withValue:@""];
    
    BOOL mineB = [employees.status isEqualToString:@"ENABLED"]?YES:NO;
    SFProfileModel * mine13 = [SFProfileModel manageTitle:@"账号使用状态" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:mineB withType:12 withValue:employees.status];
    
    
    SFProfileModel * mine14 = [SFProfileModel manageTitle:@"号码隐藏" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:employees.hiddenPhone withType:13 withValue:@""];
    
    NSArray * array1;
    if (isOrg) {
        array1= @[mine1,mine2,mine3,mine4,mine5,mine6,mine7,mine8,mine9,mine10,mine11,mine12];
    }else{
        array1= @[mine1,mine2,mine3,mine4,mine5,mine6,mine7,mine8,mine9,mine10,mine11,mine12];
    }
    
    NSArray * array2 = @[mine13];
    NSArray * array3 = @[mine14];
    return @[array1,array2,array3];
    
}

+ (SFProfileModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value{
    
    SFProfileModel * model = [[SFProfileModel alloc] init];
    model.title = title;
    model.descolor = descolor;
    model.stars = stars;
    model.destitle = destitle;
    model.isClick = isClick;
    model.placeholder = placeholder;
    model.type = type;
    model.value = value;
    
    return model;
}

@end
