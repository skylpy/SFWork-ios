//
//  SFVisitModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitModel.h"
#import "SFVisitHttpModel.h"

@implementation SFVisitModel

+ (NSMutableDictionary *)pramCompleteVisitJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFVisitModel * model = (SFVisitModel *)obj;
        switch (model.type) {
            case 1:
                [dict setValue:model.destitle forKey:@"visitTime"];
                break;
            case 2:
                [dict setValue:model.destitle forKey:@"location"];
                break;
                
            case 4:
                [dict setValue:model.destitle forKey:@"summary"];
                break;
            
            
            default:
                break;
        }
    }];
    return dict;
}

+ (NSMutableDictionary *)pramAddVisitJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFVisitModel * model = (SFVisitModel *)obj;
        switch (model.type) {
            case 1:
                [dict setValue:model.value forKey:@"clientId"];
                break;
            case 2:
                [dict setValue:model.value forKey:@"clientLinkmanId"];
                break;
            
            case 4:
                [dict setValue:model.value forKey:@"clientVisitingType"];
                break;
            case 5:
                [dict setValue:model.destitle forKey:@"deadline"];
                break;
            case 7:
                [dict setValue:model.destitle forKey:@"content"];
                break;
            default:
                break;
        }
    }];
    return dict;
}

+ (NSMutableDictionary *)pramSeachVisitJson:(NSArray *)data {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFVisitModel * model = (SFVisitModel *)obj;
        switch (model.type) {
            case 1:
                [dict setValue:model.value forKey:@"clientId"];
                break;
            case 2:
                [dict setValue:model.value forKey:@"clientLinkmanId"];
                break;
            case 3:
//                [dict setValue:model.value forKey:@"clientLinkmanId"];
                break;
            case 4:
                [dict setValue:model.destitle forKey:@"createTime"];
                break;
            case 5:
                [dict setValue:model.destitle forKey:@"deadline"];
                break;
            case 6:
                [dict setValue:model.value forKey:@"assignerId"];
                break;
            case 7:
                [dict setValue:model.value forKey:@"visitor"];
                break;
            case 8:
                [dict setValue:model.value forKey:@"clientVisitingStatus"];
                break;
            default:
                break;
        }
    }];
    return dict;
}

+ (NSArray *)shareSeachVisitModel {
    
    SFVisitModel * mine1 = [SFVisitModel manageTitle:@"拜访客户：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:1 withValue:@""];
    SFVisitModel * mine2 = [SFVisitModel manageTitle:@"客户联系人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    SFVisitModel * mine3 = [SFVisitModel manageTitle:@"客户类型：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:3 withValue:@""];
    SFVisitModel * mine4 = [SFVisitModel manageTitle:@"创建时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:4 withValue:@""];
    
    SFVisitModel * mine5 = [SFVisitModel manageTitle:@"截止时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:5 withValue:@""];
    
    SFVisitModel * mine6 = [SFVisitModel manageTitle:@"指派人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:6 withValue:@""];
    
    SFVisitModel * mine7 = [SFVisitModel manageTitle:@"拜访人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:7 withValue:@""];
    
    SFVisitModel * mine8 = [SFVisitModel manageTitle:@"拜访状态：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:8 withValue:@""];
    
    return @[mine1,mine2,mine3,mine4,mine5,mine6,mine7,mine8];
}

+ (NSArray *)shareAddVisitModel:(BOOL)isBusiness {
    
    SFVisitModel * mine1 = [SFVisitModel manageTitle:@"拜访客户：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:1 withValue:@""];
    SFVisitModel * mine2 = [SFVisitModel manageTitle:@"客户联系人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    SFVisitModel * mine3 = [SFVisitModel manageTitle:@"客户类型：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:3 withValue:@""];
    SFVisitModel * mine4 = [SFVisitModel manageTitle:@"拜访方式：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:4 withValue:@""];
    
    SFVisitModel * mine5 = [SFVisitModel manageTitle:@"截止时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:5 withValue:@""];
    
    SFVisitModel * mine6 = [SFVisitModel manageTitle:@"拜访人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:6 withValue:@""];
    
    SFVisitModel * mine7 = [SFVisitModel manageTitle:@"拜访内容：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:YES withType:7 withValue:@""];
    
    SFVisitModel * mine8 = [SFVisitModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"请填写任务内容" withStars:@"" withDescolor:@""  withClick:NO withType:8 withValue:@""];
    
    return @[mine1,mine2,mine3,mine4,mine5,mine6,mine7,mine8];
}

+ (NSArray *)shareVisitResultModel:(SFVisitListModel *)model withType:(NSString *)type{
    
    NSString * visitTime = model.visitTime ? model.visitTime :@"";
    SFVisitModel * mine1 = [SFVisitModel manageTitle:@"拜访时间：" withDestitle:visitTime withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:1 withValue:@""];
    SFVisitModel * mine2 = [SFVisitModel manageTitle:@"拜访位置：" withDestitle:model.location withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    
    SFVisitModel * mine3 = [SFVisitModel manageTitle:@"拜访照片：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:3 withValue:@""];
    NSString * content = model.visitTime ? model.content :@"";
    SFVisitModel * mine4 = [SFVisitModel manageTitle:@"拜访总结：" withDestitle:content withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:YES withType:4 withValue:@""];
    
    NSArray * array = @[];
    if ([model.clientVisitingType isEqualToString:@"TEL"]) {
        
        array = @[mine1,mine3,mine4];
    }else{
        array = @[mine1,mine2,mine3,mine4];
    }
    
    return array;
}

+ (NSArray *)shareVisitDateilModel:(SFVisitListModel *)model {
    
    SFVisitModel * mine1 = [SFVisitModel manageTitle:@"拜访客户：" withDestitle:model.clientName withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:1 withValue:@""];
    SFVisitModel * mine2 = [SFVisitModel manageTitle:@"客户联系人：" withDestitle:model.clientLinkmanName withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    SFVisitModel * mine3 = [SFVisitModel manageTitle:@"客户类型：" withDestitle:model.typeName withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:3 withValue:@""];
    NSString * clientVisitingType = [model.clientVisitingType isEqualToString:@"TEL"]?@"电话拜访":@"走访";
    SFVisitModel * mine4 = [SFVisitModel manageTitle:@"拜访方式：" withDestitle:clientVisitingType withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:4 withValue:@""];
    
    SFVisitModel * mine5 = [SFVisitModel manageTitle:@"截止时间：" withDestitle:model.deadline withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:5 withValue:@""];
    
    NSString * userName = @"";
    for (int i = 0; i < model.visitorList.count; i ++) {
        EmployeeModel * models = model.visitorList[i];
        if (i == 0) {
            userName = models.name;
        }else{
            userName = [NSString stringWithFormat:@"%@,%@",userName,models.name];
        }
    }
    
    SFVisitModel * mine6 = [SFVisitModel manageTitle:@"拜访人：" withDestitle:userName withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:6 withValue:@""];
    
    SFVisitModel * mine7 = [SFVisitModel manageTitle:@"拜访内容：" withDestitle:model.content withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:YES withType:7 withValue:@""];
    
    SFVisitModel * mine8 = [SFVisitModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"请填写任务内容" withStars:@"" withDescolor:@""  withClick:NO withType:8 withValue:@""];
    
    return @[mine1,mine2,mine3,mine4,mine5,mine6,mine7,mine8];
}

+ (SFVisitModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value{
    
    SFVisitModel * model = [[SFVisitModel alloc] init];
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
