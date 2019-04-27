//
//  SFJournalModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFJournalModel.h"

@implementation SFJournalModel

+ (NSMutableDictionary *)pramJournalJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFJournalModel * model = (SFJournalModel *)obj;
        switch (model.type) {
            case 2:
                [dict setValue:model.value forKey:@"dailyType"];
                break;
            case 3:
                [dict setValue:model.destitle forKey:@"content"];
                break;
            default:
                break;
        }
    }];
    return dict;
}


+ (NSArray *)shareJournalModel {
    
    SFJournalModel * mine1 = [SFJournalModel manageTitle:@"审批人" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:1 withValue:@""];
    SFJournalModel * mine2 = [SFJournalModel manageTitle:@"日报类型：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@""  withClick:NO withType:2 withValue:@""];
    SFJournalModel * mine3 = [SFJournalModel manageTitle:@"日报内容：" withDestitle:@"" withPlaceholder:@"请填写日报内容" withStars:@"*" withDescolor:@""  withClick:YES withType:3 withValue:@""];
    SFJournalModel * mine4 = [SFJournalModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:4 withValue:@""];
    
    
    return @[mine1,mine2,mine3,mine4];
}

+ (NSArray *)shareJournalDateilModel:(SFJournalListModel *)model {
    
    NSString * name = @"";
    for (int i = 0; i < model.dailyAuditUserList.count; i ++) {
        
        AuditUser * user = model.dailyAuditUserList[i];
        if (i == 0) {
            name = user.name;
        }else{
            name = [NSString stringWithFormat:@"%@,%@",name,user.name];
        }
    }
    SFJournalModel * mine1 = [SFJournalModel manageTitle:@"审批人" withDestitle:name withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:1 withValue:@""];
    
    
    NSString * dailyType = [model.dailyType isEqualToString:@"DAILY"]?@"日报":[model.dailyType isEqualToString:@"WEEKLY"]?@"周报":@"月报";
    SFJournalModel * mine2 = [SFJournalModel manageTitle:@"日报类型：" withDestitle:dailyType withPlaceholder:@"请选择" withStars:@"" withDescolor:@""  withClick:NO withType:2 withValue:model.dailyType];
    SFJournalModel * mine3 = [SFJournalModel manageTitle:@"日报内容：" withDestitle:model.content withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:3 withValue:@""];
    SFJournalModel * mine4 = [SFJournalModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@""  withClick:NO withType:4 withValue:@""];
    
    
    return @[mine1,mine2,mine3,mine4];
}

//保存日报设置
+ (NSMutableDictionary *)pramJournalSetDayJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray * arr in data) {
        
        for (SFJournalModel * model in arr) {
            [array addObject:model];
        }
    }
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFJournalModel * model = (SFJournalModel *)obj;
        switch (model.type) {
            case 1:
                [dict setValue:@(model.isClick) forKey:@"dailyStatus"];
                break;
            case 2:
                [dict setValue:@[] forKey:@"days"];
                break;
            case 3:
                [dict setValue:model.destitle forKey:@"startTime"];
                break;
            case 4:
                [dict setValue:model.destitle forKey:@"endTime"];
                break;
            case 5:
                [dict setValue:@(model.isClick) forKey:@"isRemindOfDay"];
                break;
            case 6:
                [dict setValue:model.destitle forKey:@"remindTimeOfDay"];
                break;
            case 7:
                [dict setValue:model.destitle forKey:@"contentOfDay"];
                break;
            default:
                break;
        }
    }];
    return dict;
}

//汇报 日
+ (NSArray *)shareReportSetModel:(BOOL)isOn with:(BOOL)isO withM:(TemplateModel *)model{
    
    NSString * title = @"";
    for (NSString * values in model.days) {
        NSString * value =  [NSString stringWithFormat:@"%@",values];

        if ([value isEqualToString:@"0"]) {
            title = [NSString stringWithFormat:@"%@ 周日",title];
        }
        if ([value isEqualToString:@"1"]) {
            title = [NSString stringWithFormat:@"%@ 周一",title];
        }
        if ([value isEqualToString:@"2"]) {
            title = [NSString stringWithFormat:@"%@ 周二",title];
        }
        if ([value isEqualToString:@"3"]) {
            title = [NSString stringWithFormat:@"%@ 周三",title];
        }
        if ([value isEqualToString:@"4"]) {
            title = [NSString stringWithFormat:@"%@ 周四",title];
        }
        if ([value isEqualToString:@"5"]) {
            title = [NSString stringWithFormat:@"%@ 周五",title];
        }
        if ([value isEqualToString:@"6"]) {
            title = [NSString stringWithFormat:@"%@ 周六",title];
        }
        
    }
    
    SFJournalModel * mine21 = [SFJournalModel manageTitle:@"提交日期：" withDestitle:title withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:7 withValue:@""];
    
    SFJournalModel * mine2 = [SFJournalModel manageTitle:@"提交开始时间：" withDestitle:[NSString stringWithFormat:@"%@:00",model.startTime] withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:2 withValue:@""];
    
    SFJournalModel * mine3 = [SFJournalModel manageTitle:@"提交截止时间：" withDestitle:[NSString stringWithFormat:@"%@:00",model.endTime] withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:3 withValue:@""];
    
    NSArray * array2 = @[mine21,mine2,mine3];
    
    SFJournalModel * mine4 = [SFJournalModel manageTitle:@"提醒员工提交：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"#666666"  withClick:YES withType:4 withValue:@""];
    
    SFJournalModel * mine5 = [SFJournalModel manageTitle:@"提醒时间：" withDestitle:[NSString stringWithFormat:@"日报截止前%ld小时",[model.remindTime integerValue]/60] withPlaceholder:@"请选择" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:5 withValue:@""];
    
    SFJournalModel * mine6 = [SFJournalModel manageTitle:@"提醒内容：" withDestitle:model.remindContext withPlaceholder:@"请填写提醒内容" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:6 withValue:@""];
    NSArray * array3 = @[];
    if (!isO) {
        array3 = @[mine4];
    }else{
        array3 = @[mine4,mine5,mine6];
    }
    
    
    return @[array2,array3];
}

//汇报 周
+ (NSArray *)shareReportSetWeekModel:(BOOL)isOn with:(BOOL)isO withM:(TemplateModel *)model{
    
    NSString * startDate = [model.startDate isEqualToString:@"1"]?@"周一":
    [model.startDate isEqualToString:@"2"]?@"周二":
    [model.startDate isEqualToString:@"3"]?@"周三":
    [model.startDate isEqualToString:@"4"]?@"周四":
    [model.startDate isEqualToString:@"5"]?@"周五":
    [model.startDate isEqualToString:@"6"]?@"周六":@"周日";
    
    NSString * endDate = [model.endDate isEqualToString:@"1"]?@"周一":
    [model.endDate isEqualToString:@"2"]?@"周二":
    [model.endDate isEqualToString:@"3"]?@"周三":
    [model.endDate isEqualToString:@"4"]?@"周四":
    [model.endDate isEqualToString:@"5"]?@"周五":
    [model.endDate isEqualToString:@"6"]?@"周六":@"周日";
    
    SFJournalModel * mine2 = [SFJournalModel manageTitle:@"提交开始时间：" withDestitle:[NSString stringWithFormat:@"%@   %@:00",startDate,model.startTime] withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:2 withValue:@""];
    SFJournalModel * mine3 = [SFJournalModel manageTitle:@"提交截止时间：" withDestitle:[NSString stringWithFormat:@"%@   %@:00",endDate,model.endTime] withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:3 withValue:@""];
    
    NSArray * array2 = @[mine2,mine3];
    
    SFJournalModel * mine4 = [SFJournalModel manageTitle:@"提醒员工提交：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"#666666"  withClick:model.remindNotification withType:4 withValue:@""];
    SFJournalModel * mine5 = [SFJournalModel manageTitle:@"提醒时间：" withDestitle:[NSString stringWithFormat:@"日报截止前%ld小时",[model.remindTime integerValue]/60] withPlaceholder:@"请选择" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:5 withValue:@""];
    SFJournalModel * mine6 = [SFJournalModel manageTitle:@"提醒内容：" withDestitle:model.remindContext withPlaceholder:@"请填写提醒内容" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:6 withValue:@""];
    NSArray * array3 = @[];
    if (!isO) {
        array3 = @[mine4];
    }else{
        array3 = @[mine4,mine5,mine6];
    }
    
    
    return @[array2,array3];
}

//汇报 月
+ (NSArray *)shareReportSetMonthModel:(BOOL)isOn with:(BOOL)isO withM:(TemplateModel *)model{
    
    SFJournalModel * mine2 = [SFJournalModel manageTitle:@"提交开始时间：" withDestitle:[NSString stringWithFormat:@"%@号   %@:00",model.startDate,model.startTime] withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:2 withValue:@""];
    SFJournalModel * mine3 = [SFJournalModel manageTitle:@"提交截止时间：" withDestitle:[NSString stringWithFormat:@"%@号   %@:00",model.endDate,model.endTime] withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:3 withValue:@""];
    
    NSArray * array2 = @[mine2,mine3];
    
    SFJournalModel * mine4 = [SFJournalModel manageTitle:@"提醒员工提交：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"#666666"  withClick:model.remindNotification withType:4 withValue:@""];
    SFJournalModel * mine5 = [SFJournalModel manageTitle:@"提醒时间：" withDestitle:[NSString stringWithFormat:@"日报截止前%ld小时",[model.remindTime integerValue]/60] withPlaceholder:@"请选择" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:5 withValue:@""];
    SFJournalModel * mine6 = [SFJournalModel manageTitle:@"提醒内容：" withDestitle:model.remindContext withPlaceholder:@"请填写提醒内容" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:6 withValue:@""];
    NSArray * array3 = @[];
    if (!isO) {
        array3 = @[mine4];
    }else{
        array3 = @[mine4,mine5,mine6];
    }
    
    
    return @[array2,array3];
}

//日
+ (NSArray *)shareJournalSetModel:(BOOL)isOn with:(BOOL)isO withM:(SFJournalSetModel *)model{
    
    SFJournalModel * mine1 = [SFJournalModel manageTitle:@"已启用" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@"#666666"  withClick:YES withType:1 withValue:@""];
    
    
    NSArray * array1 = @[mine1];
    if (!isOn) {
        return @[array1];
    }
    NSString * title = @"";
    for (NSString * value in model.days) {
        
        if ([value isEqualToString:@"0"]) {
            title = [NSString stringWithFormat:@"%@,周日",title];
        }
        if ([value isEqualToString:@"1"]) {
            title = [NSString stringWithFormat:@"%@,周一",title];
        }
        if ([value isEqualToString:@"2"]) {
            title = [NSString stringWithFormat:@"%@,周二",title];
        }
        if ([value isEqualToString:@"3"]) {
            title = [NSString stringWithFormat:@"%@,周三",title];
        }
        if ([value isEqualToString:@"4"]) {
            title = [NSString stringWithFormat:@"%@,周四",title];
        }
        if ([value isEqualToString:@"5"]) {
            title = [NSString stringWithFormat:@"%@,周五",title];
        }
        if ([value isEqualToString:@"6"]) {
            title = [NSString stringWithFormat:@"%@,周六",title];
        }
        
    }
    
    SFJournalModel * mine21 = [SFJournalModel manageTitle:@"提交日期：" withDestitle:title withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:7 withValue:@""];
    
    SFJournalModel * mine2 = [SFJournalModel manageTitle:@"提交开始时间：" withDestitle:model.startTime withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:2 withValue:@""];
    
    SFJournalModel * mine3 = [SFJournalModel manageTitle:@"提交截止时间：" withDestitle:model.endTime withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:3 withValue:@""];
    
    NSArray * array2 = @[mine21,mine2,mine3];
    
    SFJournalModel * mine4 = [SFJournalModel manageTitle:@"提醒员工提交：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"#666666"  withClick:YES withType:4 withValue:@""];
    
    SFJournalModel * mine5 = [SFJournalModel manageTitle:@"提醒时间：" withDestitle:[NSString stringWithFormat:@"日报截止前%@分钟",model.remindTimeOfDay] withPlaceholder:@"请选择" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:5 withValue:@""];
    
    SFJournalModel * mine6 = [SFJournalModel manageTitle:@"提醒内容：" withDestitle:model.contentOfDay withPlaceholder:@"请填写提醒内容" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:6 withValue:@""];
    NSArray * array3 = @[];
    if (!isO) {
        array3 = @[mine4];
    }else{
        array3 = @[mine4,mine5,mine6];
    }
   
    
    return @[array1,array2,array3];
}

//周
+ (NSArray *)shareJournalSetWeekModel:(BOOL)isOn with:(BOOL)isO withM:(SFJournalSetModel *)model{
    
    SFJournalModel * mine1 = [SFJournalModel manageTitle:@"已启用" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@"#666666"  withClick:model.weeklyStatus withType:1 withValue:@""];
    
    
    NSArray * array1 = @[mine1];
    if (!isOn) {
        return @[array1];
    }
    
    SFJournalModel * mine2 = [SFJournalModel manageTitle:@"提交开始时间：" withDestitle:[NSString stringWithFormat:@"%@   %@",model.weeklyStartDate,model.weeklyStartTime] withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:2 withValue:@""];
    SFJournalModel * mine3 = [SFJournalModel manageTitle:@"提交截止时间：" withDestitle:[NSString stringWithFormat:@"%@   %@",model.weeklyEndDate,model.weeklyEndTime] withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:3 withValue:@""];
    
    NSArray * array2 = @[mine2,mine3];
    
    SFJournalModel * mine4 = [SFJournalModel manageTitle:@"提醒员工提交：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"#666666"  withClick:model.isRemindOfDay withType:4 withValue:@""];
    SFJournalModel * mine5 = [SFJournalModel manageTitle:@"提醒时间：" withDestitle:[NSString stringWithFormat:@"日报截止前%@分钟",model.remindTimeOfDay] withPlaceholder:@"请选择" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:5 withValue:@""];
    SFJournalModel * mine6 = [SFJournalModel manageTitle:@"提醒内容：" withDestitle:model.contentOfWeekly withPlaceholder:@"请填写提醒内容" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:6 withValue:@""];
    NSArray * array3 = @[];
    if (!isO) {
        array3 = @[mine4];
    }else{
        array3 = @[mine4,mine5,mine6];
    }
    
    
    return @[array1,array2,array3];
}

//月
+ (NSArray *)shareJournalSetMonthModel:(BOOL)isOn with:(BOOL)isO withM:(SFJournalSetModel *)model{
    
    SFJournalModel * mine1 = [SFJournalModel manageTitle:@"已启用" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@"#666666"  withClick:model.monthlyStatus withType:1 withValue:@""];
    
    
    NSArray * array1 = @[mine1];
    if (!isOn) {
        return @[array1];
    }
    
    SFJournalModel * mine2 = [SFJournalModel manageTitle:@"提交开始时间：" withDestitle:[NSString stringWithFormat:@"%@号   %@",model.monthlyStartDate,model.monthlyStartTime] withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:2 withValue:@""];
    SFJournalModel * mine3 = [SFJournalModel manageTitle:@"提交截止时间：" withDestitle:[NSString stringWithFormat:@"%@号   %@",model.monthlyEndDate,model.monthlyEndTime] withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"#666666"  withClick:NO withType:3 withValue:@""];
    
    NSArray * array2 = @[mine2,mine3];
    
    SFJournalModel * mine4 = [SFJournalModel manageTitle:@"提醒员工提交：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"#666666"  withClick:model.isRemindOfMonthly withType:4 withValue:@""];
    SFJournalModel * mine5 = [SFJournalModel manageTitle:@"提醒时间：" withDestitle:[NSString stringWithFormat:@"日报截止前%@分钟",model.remindTimeOfMonthly] withPlaceholder:@"请选择" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:5 withValue:@""];
    SFJournalModel * mine6 = [SFJournalModel manageTitle:@"提醒内容：" withDestitle:model.contentOfMonthly withPlaceholder:@"请填写提醒内容" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:6 withValue:@""];
    NSArray * array3 = @[];
    if (!isO) {
        array3 = @[mine4];
    }else{
        array3 = @[mine4,mine5,mine6];
    }
    
    
    return @[array1,array2,array3];
}

+ (NSArray *)selectList{
    
    SFJournalModel * mine1 = [SFJournalModel manageTitle:@"选择员工" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:1 withValue:@""];
    SFJournalModel * mine2 = [SFJournalModel manageTitle:@"日期筛选" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@"#666666"  withClick:NO withType:1 withValue:@""];
    
    return @[mine1,mine2];
}

+ (SFJournalModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value{
    
    SFJournalModel * model = [[SFJournalModel alloc] init];
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
