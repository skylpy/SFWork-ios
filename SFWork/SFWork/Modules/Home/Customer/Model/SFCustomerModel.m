//
//  SFCustomerModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFCustomerModel.h"


@implementation SFCustomerModel

//Search
+ (NSMutableDictionary *)pramSearchJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFCustomerModel * model = (SFCustomerModel *)obj;
        
        switch (model.type) {
            case 0:
                [dict setValue:model.destitle forKey:@"number"];
                break;
            case 1:
                [dict setValue:@"" forKey:@"name"];
                break;
            case 2:
                {
                    //归属
                    NSString * clientBelong = [model.destitle isEqualToString:@"我的(私有)"]?@"MINE":@"DEPARTMENT";
                    [dict setValue:clientBelong forKey:@"clientBelong"];
                }
                break;
            case 3:
                //类型
                [dict setValue:model.value forKey:@"typeId"];
                break;
            case 4:
                //等级
                
                [dict setValue:model.value forKey:@"levelId"];
                break;
            case 5:
                //区域
                [dict setValue:model.value forKey:@"areaId"];
                break;
            case 7:
                //意向
                [dict setValue:model.value forKey:@"intentionId"];
                break;
            default:
                break;
        }
    }];
    return dict;
}

+ (NSMutableDictionary *)pramCustomerJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray * arr in data) {
        
        for (SFCustomerModel * model in arr) {
            [array addObject:model];
        }
    }
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFCustomerModel * model = (SFCustomerModel *)obj;
        
        switch (model.type) {
            case 0:
                //名称
                [dict setValue:model.destitle forKey:@"name"];
                break;
            case 1:
            {
                //归属
                NSString * clientBelong = [model.destitle isEqualToString:@"我的(私有)"]?@"MINE":@"DEPARTMENT";
                [dict setValue:clientBelong forKey:@"clientBelong"];
            }
                
                break;
            case 2:
                //类型
                [dict setValue:model.value forKey:@"typeId"];
                break;
            case 3:
                //等级
                
                [dict setValue:model.value forKey:@"levelId"];
                break;
            case 4:
                //区域
                [dict setValue:model.value forKey:@"areaId"];
                break;
            case 5:
                //意向
                [dict setValue:model.value forKey:@"intentionId"];
                break;
            case 6:
                //经手人
                [dict setValue:model.value forKey:@"operatorId"];
                break;
            case 7:
                //地址
                [dict setValue:model.destitle forKey:@"address"];
                break;
            case 8:
                //详细地址
                [dict setValue:model.destitle forKey:@"detailedAddress"];
                break;
            case 9:
                //相片
                [dict setValue:@[] forKey:@"photos"];
                break;
            case 10:
                //备注
                [dict setValue:model.destitle forKey:@"note"];
                break;
            case 11:
                //联系人
                [dict setValue:@[] forKey:@"clientLinkmanDTOList"];
                break;
            default:
                break;
        }
    }];
    
    return dict;
}

//搜索
+ (NSArray *)shareSearchModel:(CustomerType)type{
    
    NSString * title1 = type == customerType ? @"客户编号：":@"商家编号：";
    SFCustomerModel * mine1 = [SFCustomerModel manageTitle:title1 withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"*" withDescolor:@"" withClick:YES withType:0 withValue:@""];
    
    NSString * title2 = type == customerType ? @"客户名称：":@"商家名称：";
    
    SFCustomerModel * mine2 = [SFCustomerModel manageTitle:title2 withDestitle:@"" withPlaceholder:@"请输入" withStars:@"*" withDescolor:@""  withClick:YES withType:1 withValue:@""];
    
    NSString * title3 = type == customerType ? @"客户归属：":@"商家归属：";
    SFCustomerModel * mine3 = [SFCustomerModel manageTitle:title3 withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    
    NSString * title4 = type == customerType ? @"客户类型：":@"商家类型：";
    SFCustomerModel * mine4 = [SFCustomerModel manageTitle:title4 withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:3 withValue:@""];
    
    NSString * title5 = type == customerType ? @"客户等级：":@"商家等级：";
    SFCustomerModel * mine5 = [SFCustomerModel manageTitle:title5 withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:4 withValue:@"" ];
    
    NSString * title6 = type == customerType ? @"客户区域：":@"商家区域：";
    SFCustomerModel * mine6 = [SFCustomerModel manageTitle:title6 withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:5 withValue:@""];
    
    NSString * title8 = type == customerType ? @"客户意向：":@"商家意向：";
    SFCustomerModel * mine8 = [SFCustomerModel manageTitle:title8 withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:7 withValue:@""];
    
    NSArray * array1 = @[mine1,mine2,mine3,mine4,mine5,mine6,mine8];
    return array1;
    
}

//详情数据
+ (NSArray *)shareDateilModel:(CustomerType)type withModel:(SFClientModel *)model{
    
    NSString * cidt = type == customerType ? @"客户编号：":@"商家编号：";
    SFCustomerModel * cidtm = [SFCustomerModel manageTitle:cidt withDestitle:model._id withPlaceholder:@""  withStars:@"" withDescolor:@"" withClick:NO withType:0 withValue:@""];
    
    NSString * title1 = type == customerType ? @"客户名称：":@"商家名称：";
    SFCustomerModel * mine1 = [SFCustomerModel manageTitle:title1 withDestitle:model.name withPlaceholder:@""  withStars:@"" withDescolor:@"" withClick:NO withType:0 withValue:@""];
    
    NSString * title2 = type == customerType ? @"客户归属：":@"商家归属：";
    NSString * desTitle = [model.clientBelong isEqualToString:@"MINE"] ? @"我的(私有)":@"部门(部门公有)";
    SFCustomerModel * mine2 = [SFCustomerModel manageTitle:title2 withDestitle:desTitle withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:1 withValue:model.clientBelong];
    
    NSString * title3 = type == customerType ? @"客户类型：":@"商家类型：";
    SFCustomerModel * mine3 = [SFCustomerModel manageTitle:title3 withDestitle:model.typeName withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:2 withValue:model.typeId];
    
    NSString * title4 = type == customerType ? @"客户等级：":@"商家等级：";
    SFCustomerModel * mine4 = [SFCustomerModel manageTitle:title4 withDestitle:model.levelName withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:3 withValue:model.levelId];
    
    NSString * title5 = type == customerType ? @"客户区域：":@"商家区域：";
    SFCustomerModel * mine5 = [SFCustomerModel manageTitle:title5 withDestitle:model.areaName withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:4 withValue:model.areaId ];
    
    NSString * title6 = type == customerType ? @"客户意向：":@"商家意向：";
    SFCustomerModel * mine6 = [SFCustomerModel manageTitle:title6 withDestitle:model.intentionName withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:5 withValue:model.intentionId];
    SFCustomerModel * mine7 = [SFCustomerModel manageTitle:@"经手人：" withDestitle:model.operatorName withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:6 withValue:model.operatorId];
    
    NSString * title8 = type == customerType ? @"客户地址：":@"商家地址：";
    SFCustomerModel * mine8 = [SFCustomerModel manageTitle:title8 withDestitle:model.address withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:7 withValue:@""];
    
    SFCustomerModel * mine9 = [SFCustomerModel manageTitle:@"" withDestitle:model.detailedAddress withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:8 withValue:@""];
    
    SFCustomerModel * mine10 = [SFCustomerModel manageTitle:@"相片：" withDestitle:@"213" withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:9 withValue:@""];
    SFCustomerModel * mine11 = [SFCustomerModel manageTitle:@"备注：" withDestitle:model.note withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:10 withValue:@""];
    
    NSString * title12 = type == customerType ? @"客户联系人":@"商家联系人";
    SFCustomerModel * mine12 = [SFCustomerModel manageTitle:title12 withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:11 withValue:@""];
    
    
    NSArray * array1 = @[cidtm,mine1,mine2,mine3,mine4,mine5,mine6,mine7,mine8,mine9,mine10,mine11];
    NSArray * array2 = @[mine12];
    
    return @[array1,array2];
}

//新增
+ (NSArray *)shareCustomerModel:(CustomerType)type{
    
    NSString * title1 = type == customerType ? @"客户名称：":@"商家名称：";
    SFCustomerModel * mine1 = [SFCustomerModel manageTitle:title1 withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"*" withDescolor:@"" withClick:YES withType:0 withValue:@""];
    
    NSString * title2 = type == customerType ? @"客户归属：":@"商家归属：";
    
    SFCustomerModel * mine2 = [SFCustomerModel manageTitle:title2 withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:1 withValue:@""];
  
    NSString * title3 = type == customerType ? @"客户类型：":@"商家类型：";
    SFCustomerModel * mine3 = [SFCustomerModel manageTitle:title3 withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    
    NSString * title4 = type == customerType ? @"客户等级：":@"商家等级：";
    SFCustomerModel * mine4 = [SFCustomerModel manageTitle:title4 withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:3 withValue:@""];
    
    NSString * title5 = type == customerType ? @"客户区域：":@"商家区域：";
    SFCustomerModel * mine5 = [SFCustomerModel manageTitle:title5 withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:4 withValue:@"" ];
    
    NSString * title6 = type == customerType ? @"客户意向：":@"商家意向：";
    SFCustomerModel * mine6 = [SFCustomerModel manageTitle:title6 withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:5 withValue:@""];
    SFCustomerModel * mine7 = [SFCustomerModel manageTitle:@"经手人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:6 withValue:@""];
    
    NSString * title8 = type == customerType ? @"客户地址：":@"商家地址：";
    SFCustomerModel * mine8 = [SFCustomerModel manageTitle:title8 withDestitle:@"开发中" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:7 withValue:@""];
    SFCustomerModel * mine9 = [SFCustomerModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"请输入详细地址" withStars:@"" withDescolor:@""  withClick:YES withType:8 withValue:@""];
    SFCustomerModel * mine10 = [SFCustomerModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@""  withClick:YES withType:9 withValue:@""];
    SFCustomerModel * mine11 = [SFCustomerModel manageTitle:@"备注：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:YES withType:10 withValue:@""];
    
    NSString * title12 = type == customerType ? @"客户联系人":@"商家联系人";
    SFCustomerModel * mine12 = [SFCustomerModel manageTitle:title12 withDestitle:@"" withPlaceholder:@"新建联系人" withStars:@"*" withDescolor:@""  withClick:NO withType:11 withValue:@""];
    
    
    NSArray * array1 = @[mine1,mine2,mine3,mine4,mine5,mine6,mine7,mine8,mine9,mine10,mine11];
    NSArray * array2 = @[mine12];

    return @[array1,array2];
    
}

//新增联系人
+ (NSArray *)shareContactsModel{
    
    SFCustomerModel * mine1 = [SFCustomerModel manageTitle:@"姓名：" withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"*" withDescolor:@"" withClick:YES withType:0 withValue:@""];
    SFCustomerModel * mine2 = [SFCustomerModel manageTitle:@"电话号码：" withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"*" withDescolor:@"" withClick:YES withType:1 withValue:@""];
    SFCustomerModel * mine3 = [SFCustomerModel manageTitle:@"主要联系人：" withDestitle:@"" withPlaceholder:@""  withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@""];
    SFCustomerModel * mine4 = [SFCustomerModel manageTitle:@"性别：" withDestitle:@"男" withPlaceholder:@"请选择"  withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"MALE"];
    SFCustomerModel * mine5 = [SFCustomerModel manageTitle:@"部门：" withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"" withDescolor:@"" withClick:YES withType:4 withValue:@""];
    SFCustomerModel * mine6 = [SFCustomerModel manageTitle:@"职务：" withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"" withDescolor:@"" withClick:YES withType:5 withValue:@""];
    SFCustomerModel * mine7 = [SFCustomerModel manageTitle:@"电子邮箱：" withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"" withDescolor:@"" withClick:YES withType:6 withValue:@""];
    SFCustomerModel * mine8 = [SFCustomerModel manageTitle:@"微信号：" withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"" withDescolor:@"" withClick:YES withType:7 withValue:@""];
    SFCustomerModel * mine9 = [SFCustomerModel manageTitle:@"QQ号码：" withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"" withDescolor:@"" withClick:YES withType:8 withValue:@""];
    SFCustomerModel * mine10 = [SFCustomerModel manageTitle:@"传真：" withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"" withDescolor:@"" withClick:YES withType:9 withValue:@""];
    SFCustomerModel * mine11 = [SFCustomerModel manageTitle:@"生日：" withDestitle:@"" withPlaceholder:@"请选择"  withStars:@"" withDescolor:@"" withClick:NO withType:10 withValue:@""];
    SFCustomerModel * mine12 = [SFCustomerModel manageTitle:@"备注：" withDestitle:@"" withPlaceholder:@"请输入"  withStars:@"" withDescolor:@"" withClick:YES withType:11 withValue:@""];
    
    return @[mine1,mine2,mine3,mine4,mine5,mine6,mine7,mine8,mine9,mine10,mine11,mine12];
    
}

//编辑
+ (NSArray *)shareCustomerModel:(SFClientModel *)model withType:(CustomerType)type{
    
    NSString * title1 = type == customerType ? @"客户名称：":@"商家名称：";
    SFCustomerModel * mine1 = [SFCustomerModel manageTitle:title1 withDestitle:model.name withPlaceholder:@"请输入"  withStars:@"*" withDescolor:@"" withClick:YES withType:0 withValue:@""];
    
    NSString * title2 = type == customerType ? @"客户归属：":@"商家归属：";
    NSString * desTitle = [model.clientBelong isEqualToString:@"MINE"] ? @"我的(私有)":@"部门(部门公有)";
    SFCustomerModel * mine2 = [SFCustomerModel manageTitle:title2 withDestitle:desTitle withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:1 withValue:@""];
    
    NSString * title3 = type == customerType ? @"客户类型：":@"商家类型：";
    SFCustomerModel * mine3 = [SFCustomerModel manageTitle:title3 withDestitle:model.typeName withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:2 withValue:model.typeId];
    
    NSString * title4 = type == customerType ? @"客户等级：":@"商家等级：";
    SFCustomerModel * mine4 = [SFCustomerModel manageTitle:title4 withDestitle:model.levelName withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:3 withValue:model.levelId];
    
    NSString * title5 = type == customerType ? @"客户区域：":@"商家区域：";
    SFCustomerModel * mine5 = [SFCustomerModel manageTitle:title5 withDestitle:model.areaName withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:4 withValue:model.areaId ];
    
    NSString * title6 = type == customerType ? @"客户意向：":@"商家意向：";
    SFCustomerModel * mine6 = [SFCustomerModel manageTitle:title6 withDestitle:model.intentionName withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:5 withValue:model.intentionId];
    
    SFCustomerModel * mine7 = [SFCustomerModel manageTitle:@"经手人：" withDestitle:model.operatorName withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:6 withValue:model.operatorId];
    
    NSString * title8 = type == customerType ? @"客户地址：":@"商家地址：";
    SFCustomerModel * mine8 = [SFCustomerModel manageTitle:title8 withDestitle:model.address withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:7 withValue:@""];
    
    SFCustomerModel * mine9 = [SFCustomerModel manageTitle:@"" withDestitle:model.detailedAddress withPlaceholder:@"请输入详细地址" withStars:@"" withDescolor:@""  withClick:YES withType:8 withValue:@""];
    
    SFCustomerModel * mine10 = [SFCustomerModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@""  withClick:YES withType:9 withValue:@""];
    
    SFCustomerModel * mine11 = [SFCustomerModel manageTitle:@"备注：" withDestitle:model.note withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:YES withType:10 withValue:@""];
    
    NSString * title12 = type == customerType ? @"客户联系人":@"商家联系人";
    SFCustomerModel * mine12 = [SFCustomerModel manageTitle:title12 withDestitle:@"" withPlaceholder:@"新建联系人" withStars:@"*" withDescolor:@""  withClick:NO withType:11 withValue:@""];
    
    
    NSArray * array1 = @[mine1,mine2,mine3,mine4,mine5,mine6,mine7,mine8,mine9,mine10,mine11];
    NSArray * array2 = @[mine12];
    
    return @[array1,array2];
    
}

+ (NSMutableDictionary *)pramContactsJson:(NSArray *)data {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
  
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFCustomerModel * model = (SFCustomerModel *)obj;
        switch (model.type) {
            case 0:
                [dict setValue:model.destitle forKey:@"name"];
                break;
            case 1:
                [dict setValue:model.destitle forKey:@"tel"];
                break;
            case 2:
            {
                BOOL ismajor = [model.destitle isEqualToString: @"是"]?YES:NO;
                [dict setValue:@(ismajor) forKey:@"major"];
            }
                break;
            case 3:
                [dict setValue:model.value forKey:@"gender"];
                break;
            case 4:
                [dict setValue:model.destitle forKey:@"department"];
                break;
            case 5:
                //职务
                [dict setValue:model.destitle forKey:@"duty"];
                break;
            case 6:
                [dict setValue:model.destitle forKey:@"email"];
                break;
            case 7:
                [dict setValue:model.destitle forKey:@"weChat"];
                break;
            case 8:
                [dict setValue:model.destitle forKey:@"qq"];
                break;
            case 9:
                //传真
                [dict setValue:model.destitle forKey:@"fax"];
                break;
            case 10:
                [dict setValue:model.destitle forKey:@"birth"];
                break;
            default:
                [dict setValue:model.destitle forKey:@"note"];
                break;
        }
    }];
    return dict;
}

+ (SFCustomerModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value{
    
    SFCustomerModel * model = [[SFCustomerModel alloc] init];
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

@implementation SFClientModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"clientLinkmanDTOList" : [ClientLinkModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation ClientLinkModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
