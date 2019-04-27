//
//  SFTaskModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTaskModel.h"
#import "SFTaskHttpModel.h"

@implementation SFTaskModel

+ (NSMutableDictionary *)pramAddTaskJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFTaskModel * model = (SFTaskModel *)obj;
        switch (model.type) {
            case 2:
                [dict setValue:model.value forKey:@"taskTypeId"];
                break;
            case 3:
                [dict setValue:model.destitle forKey:@"endTime"];
                break;
            case 4:
            {
                NSString * level = [model.destitle isEqualToString:@"非常紧急"]?@"HIGHEST":[model.destitle isEqualToString:@"紧急"]?@"URGENT":@"GENERAL";
                [dict setValue:level forKey:@"level"];
            }
                break;
            case 8:
                [dict setValue:model.destitle forKey:@"content"];
                break;
    
            default:
                break;
        }
    }];
    return dict;
}

+ (NSMutableDictionary *)pramTaskSummaryJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFTaskModel * model = (SFTaskModel *)obj;
        switch (model.type) {
            case 1:
                [dict setValue:model.destitle forKey:@"accomplishTime"];
                break;
            case 3:
                [dict setValue:model.destitle forKey:@"summarize"];
                break;
                
            default:
                break;
        }
    }];
    return dict;
}

+ (NSMutableDictionary *)pramTaskSearchJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFTaskModel * model = (SFTaskModel *)obj;
        switch (model.type) {
            case 1:
                [dict setValue:model.destitle forKey:@"taskNumber"];
                break;
            case 2:
                [dict setValue:model.value forKey:@"taskTypeId"];
                break;
            case 5:
            {
                NSString * level = [model.destitle isEqualToString:@"非常紧急"]?
                @"HIGHEST":[model.destitle isEqualToString:@"紧急"]?
                @"URGENT":[model.destitle isEqualToString:@"普通"]?@"GENERAL":@"";
                [dict setValue:level forKey:@"level"];
            }
                break;
            case 6:
                [dict setValue:model.value forKey:@"createId"];
                break;
            case 7:
                [dict setValue:model.value forKey:@"auditUserId"];
                break;
            case 8:
                [dict setValue:model.value forKey:@"executorId"];
                break;
            default:
                break;
        }
    }];
    return dict;
}

+ (NSArray *)shareTaskSearchModel {
    
    SFTaskModel * mine1 = [SFTaskModel manageTitle:@"任务编号：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@""  withClick:YES withType:1 withValue:@""];
    SFTaskModel * mine2 = [SFTaskModel manageTitle:@"任务类型：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    SFTaskModel * mine3 = [SFTaskModel manageTitle:@"创建时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:3 withValue:@""];
    SFTaskModel * mine4 = [SFTaskModel manageTitle:@"截止时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:4 withValue:@""];
    SFTaskModel * mine5 = [SFTaskModel manageTitle:@"任务级别：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:5 withValue:@""];
    SFTaskModel * mine6 = [SFTaskModel manageTitle:@"发起人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:6 withValue:@""];
    SFTaskModel * mine7 = [SFTaskModel manageTitle:@"审批人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:7 withValue:@""];
    SFTaskModel * mine8 = [SFTaskModel manageTitle:@"办理人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:8 withValue:@""];
    
    return @[mine1,mine2,mine3,mine4,mine5,mine6,mine7,mine8];
}


+ (NSArray *)shareTaskSummaryModel:(BOOL)isSelf withModel:(TaskListModel *)model{
    
    NSString * detit = [model.executorId isEqualToString:[SFInstance shareInstance].userInfo._id]?@"请选择":model.accomplishTime;
     SFTaskModel * mine1 = [SFTaskModel manageTitle:@"完成时间" withDestitle:model.accomplishTime withPlaceholder:detit withStars:@"" withDescolor:@""  withClick:NO withType:1 withValue:@""];
    SFTaskModel * mine2 = [SFTaskModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:detit withStars:@"" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    BOOL isC = [model.executorId isEqualToString:[SFInstance shareInstance].userInfo._id]?YES:NO;
    NSString * C = [model.executorId isEqualToString:[SFInstance shareInstance].userInfo._id]?@"请输入总结":@"";
    SFTaskModel * mine3 = [SFTaskModel manageTitle:@"任务总结：" withDestitle:model.summarize withPlaceholder:C withStars:@"" withDescolor:@""  withClick:isC withType:3 withValue:@""];
    
    return @[mine1,mine2,mine3];
}

+ (NSArray *)shareTaskDateilModel:(BOOL)isSelf withModel:(TaskListModel *)model{
    
    SFTaskModel * mine1 = [SFTaskModel manageTitle:@"任务编号" withDestitle:model.taskNumber withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:1 withValue:@""];
    
    SFTaskModel * mine2 = [SFTaskModel manageTitle:@"任务类型：" withDestitle:model.taskTypeName withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    SFTaskModel * mine3 = [SFTaskModel manageTitle:@"创建时间：" withDestitle:model.createTime withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:3 withValue:@""];
    SFTaskModel * mine4 = [SFTaskModel manageTitle:@"截止时间：" withDestitle:model.endTime withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:4 withValue:@""];
    NSString * level = [model.level isEqualToString:@"HIGHEST"]?@"非常紧急":[model.level isEqualToString:@"URGENT"]?@"紧急":@"普通";
    SFTaskModel * mine5 = [SFTaskModel manageTitle:@"任务级别：" withDestitle:level withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:5 withValue:@""];
    
    SFTaskModel * mine6 = [SFTaskModel manageTitle:@"发起人：" withDestitle:model.createName withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:6 withValue:@""];
    
    NSString * auditUser = @"";
    for (int i = 0; i < model.auditUserList.count; i ++) {
        NSDictionary * dic = model.auditUserList[i];
        if (i == 0) {
            auditUser = dic[@"name"];
        }else{
            auditUser = [NSString stringWithFormat:@"%@%@",auditUser,dic[@"name"]];
        }
    }
    
    SFTaskModel * mine7 = [SFTaskModel manageTitle:@"审批人：" withDestitle:auditUser withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:7 withValue:@""];
    
    
    SFTaskModel * mine8 = [SFTaskModel manageTitle:@"办理人：" withDestitle:model.executorName withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:8 withValue:@""];
    
    SFTaskModel * mine9 = [SFTaskModel manageTitle:@"任务内容：" withDestitle:model.content withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:9 withValue:@""];
    SFTaskModel * mine10 = [SFTaskModel manageTitle:@"照片：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:10 withValue:@""];
    
    return @[mine1,mine2,mine3,mine4,mine5,mine6,mine7,mine8,mine9,mine10];
}

+ (NSArray *)shareAddTaskModel:(BOOL)isSelf {
    
//    NSString * currentTime = [NSString stringWithFormat:@"R%@",[NSString getCurrentTimes]];
//    SFTaskModel * mine1 = [SFTaskModel manageTitle:@"任务编号" withDestitle:currentTime withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:1 withValue:@""];
    SFTaskModel * mine2 = [SFTaskModel manageTitle:@"任务类型：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    SFTaskModel * mine3 = [SFTaskModel manageTitle:@"截止时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:3 withValue:@""];
    SFTaskModel * mine4 = [SFTaskModel manageTitle:@"任务级别：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:4 withValue:@""];
    
//    SFTaskModel * mine5 = [SFTaskModel manageTitle:@"发起人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:5 withValue:@""];
    
    SFTaskModel * mine6 = [SFTaskModel manageTitle:@"审批人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:6 withValue:@""];
    
    NSString * userName = isSelf?[SFInstance shareInstance].userInfo.name:@"";
    SFTaskModel * mine7 = [SFTaskModel manageTitle:@"办理人：" withDestitle:userName withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:7 withValue:@""];
    
    SFTaskModel * mine8 = [SFTaskModel manageTitle:@"任务内容：" withDestitle:@"" withPlaceholder:@"请填写任务内容" withStars:@"*" withDescolor:@""  withClick:YES withType:8 withValue:@""];
    
    SFTaskModel * mine9 = [SFTaskModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:9 withValue:@""];
    
    return @[mine2,mine3,mine4,mine6,mine7,mine8,mine9];
}

+ (SFTaskModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value{
    
    SFTaskModel * model = [[SFTaskModel alloc] init];
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
