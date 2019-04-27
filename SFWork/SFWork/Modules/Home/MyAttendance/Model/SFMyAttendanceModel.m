//
//  SFMyAttendanceModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMyAttendanceModel.h"

@implementation SFMyAttendanceModel

+ (NSMutableDictionary *)pramMyOvertimeJson:(NSArray *)data {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray * arr in data) {
        
        for (SFMyAttendanceModel * model in arr) {
            [array addObject:model];
        }
    }
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFMyAttendanceModel * model = (SFMyAttendanceModel *)obj;
        switch (model.type) {
            
            case 2:
                [dict setValue:model.destitle forKey:@"startTime"];
                break;
                
            case 3:
                [dict setValue:model.destitle forKey:@"endTime"];
                break;
                
            case 4:
                [dict setValue:model.destitle forKey:@"duration"];
                break;
                
            case 5:
                [dict setValue:model.destitle forKey:@"cause"];
                break;
            default:
                break;
        }
    }];
    return dict;
}

+ (NSMutableDictionary *)pramMyTripJson:(NSArray *)data {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray * arr in data) {
        
        for (SFMyAttendanceModel * model in arr) {
            [array addObject:model];
        }
    }
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFMyAttendanceModel * model = (SFMyAttendanceModel *)obj;
        switch (model.type) {
            case 1:
                [dict setValue:model.destitle forKey:@"site"];
                break;
            case 2:
                [dict setValue:model.destitle forKey:@"startTime"];
                break;
                
            case 3:
                [dict setValue:model.destitle forKey:@"endTime"];
                break;
                
            case 4:
                [dict setValue:model.destitle forKey:@"duration"];
                break;
                
            case 5:
                [dict setValue:model.destitle forKey:@"cause"];
                break;
            default:
                break;
        }
    }];
    return dict;
}

+ (NSMutableDictionary *)pramMyAttendanceJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray * arr in data) {
        
        for (SFMyAttendanceModel * model in arr) {
            [array addObject:model];
        }
    }
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFMyAttendanceModel * model = (SFMyAttendanceModel *)obj;
        switch (model.type) {
            case 1:
                [dict setValue:model.value forKey:@"leaveId"];
                break;
            case 2:
                [dict setValue:model.destitle forKey:@"startTime"];
                break;
                
            case 3:
                [dict setValue:model.destitle forKey:@"endTime"];
                break;
                
            case 4:
                [dict setValue:model.destitle forKey:@"duration"];
                break;
                
            case 5:
                [dict setValue:model.destitle forKey:@"cause"];
                break;
            default:
                break;
        }
    }];
    return dict;
}

+ (NSArray *)shareMyAttendanceOvertimeModelModel {
    
    SFMyAttendanceModel * model21 = [SFMyAttendanceModel manageTitle:@"开始时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    SFMyAttendanceModel * model22 = [SFMyAttendanceModel manageTitle:@"结束时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    SFMyAttendanceModel * model23 = [SFMyAttendanceModel manageTitle:@"加班时长：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"*" withDescolor:@"" withClick:YES withType:4 withValue:@"" withPersons:@[]];
    NSArray * array2 = @[model21,model22,model23];
    
    SFMyAttendanceModel * model3 = [SFMyAttendanceModel manageTitle:@"加班事由：" withDestitle:@"" withPlaceholder:@"请输入请假事由" withStars:@"*" withDescolor:@"" withClick:YES withType:5 withValue:@"" withPersons:@[]];
    NSArray * array3 = @[model3];
    
    SFMyAttendanceModel * model4 = [SFMyAttendanceModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[]];
    NSArray * array4 = @[model4];
    
    SFMyAttendanceModel * model5 = [SFMyAttendanceModel manageTitle:@"审批人" withDestitle:@"" withPlaceholder:@"" withStars:@"*" withDescolor:@"" withClick:NO withType:7 withValue:@"" withPersons:@[]];
    NSArray * array5 = @[model5];
    
    SFMyAttendanceModel * model6 = [SFMyAttendanceModel manageTitle:@"抄送人" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:8 withValue:@"" withPersons:@[]];
    NSArray * array6 = @[model6];
    
    return @[array2,array3,array4,array5,array6];
}

+ (NSArray *)shareMyAttendanceLeaveModelModel {
    
    SFMyAttendanceModel * model1 = [SFMyAttendanceModel manageTitle:@"出差地点：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"*" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    NSArray * array1 = @[model1];
    
    SFMyAttendanceModel * model21 = [SFMyAttendanceModel manageTitle:@"开始时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    SFMyAttendanceModel * model22 = [SFMyAttendanceModel manageTitle:@"结束时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    SFMyAttendanceModel * model23 = [SFMyAttendanceModel manageTitle:@"出差时长：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"*" withDescolor:@"" withClick:YES withType:4 withValue:@"" withPersons:@[]];
    NSArray * array2 = @[model21,model22,model23];
    
    SFMyAttendanceModel * model3 = [SFMyAttendanceModel manageTitle:@"出差事由：" withDestitle:@"" withPlaceholder:@"请输入请假事由" withStars:@"*" withDescolor:@"" withClick:YES withType:5 withValue:@"" withPersons:@[]];
    NSArray * array3 = @[model3];
    
    SFMyAttendanceModel * model4 = [SFMyAttendanceModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[]];
    NSArray * array4 = @[model4];
    
    SFMyAttendanceModel * model5 = [SFMyAttendanceModel manageTitle:@"审批人" withDestitle:@"" withPlaceholder:@"" withStars:@"*" withDescolor:@"" withClick:NO withType:7 withValue:@"" withPersons:@[]];
    NSArray * array5 = @[model5];
    
    SFMyAttendanceModel * model6 = [SFMyAttendanceModel manageTitle:@"抄送人" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:8 withValue:@"" withPersons:@[]];
    NSArray * array6 = @[model6];
    
    return @[array1,array2,array3,array4,array5,array6];
}

+ (NSArray *)shareMyAttendanceTripModelModel {
    
    SFMyAttendanceModel * model21 = [SFMyAttendanceModel manageTitle:@"开始时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    SFMyAttendanceModel * model22 = [SFMyAttendanceModel manageTitle:@"结束时间：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"*" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    SFMyAttendanceModel * model23 = [SFMyAttendanceModel manageTitle:@"出差时长：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"*" withDescolor:@"" withClick:YES withType:4 withValue:@"" withPersons:@[]];
    NSArray * array2 = @[model21,model22,model23];
    
    SFMyAttendanceModel * model1 = [SFMyAttendanceModel manageTitle:@"出差地点：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"*" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    NSArray * array1 = @[model1];
    
    SFMyAttendanceModel * model3 = [SFMyAttendanceModel manageTitle:@"出差事由：" withDestitle:@"" withPlaceholder:@"请输入请假事由" withStars:@"*" withDescolor:@"" withClick:YES withType:5 withValue:@"" withPersons:@[]];
    NSArray * array3 = @[model3];
    
    SFMyAttendanceModel * model4 = [SFMyAttendanceModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[]];
    NSArray * array4 = @[model4];
    
    SFMyAttendanceModel * model5 = [SFMyAttendanceModel manageTitle:@"审批人" withDestitle:@"" withPlaceholder:@"" withStars:@"*" withDescolor:@"" withClick:NO withType:7 withValue:@"" withPersons:@[]];
    NSArray * array5 = @[model5];
    
    SFMyAttendanceModel * model6 = [SFMyAttendanceModel manageTitle:@"抄送人" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:8 withValue:@"" withPersons:@[]];
    NSArray * array6 = @[model6];
    
    return @[array2,array1,array3,array4,array5,array6];
}

+ (SFMyAttendanceModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value withPersons:(NSArray *)persons{
    
    SFMyAttendanceModel * model = [[SFMyAttendanceModel alloc] init];
    model.title = title;
    model.descolor = descolor;
    model.stars = stars;
    model.destitle = destitle;
    model.isClick = isClick;
    model.placeholder = placeholder;
    model.type = type;
    model.value = value;
    model.persons = persons;
    
    return model;
}


@end
