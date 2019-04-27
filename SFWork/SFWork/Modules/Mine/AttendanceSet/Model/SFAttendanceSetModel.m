//
//  SFAttendanceSetModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttendanceSetModel.h"

@implementation SFAttendanceSetModel

+ (NSMutableDictionary *)pramJournalJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray * arr in data) {
        
        for (SFAttendanceSetModel * model in arr) {
            [array addObject:model];
        }
    }
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFAttendanceSetModel * model = (SFAttendanceSetModel *)obj;
        switch (model.type) {
            case 1:
                [dict setValue:model.destitle forKey:@"name"];
                break;
            case 6:
                [dict setValue:model.value forKey:@"startRemind"];
                break;
            case 8:
                [dict setValue:@(model.isClick) forKey:@"holidays"];
                break;
            case 9:
                [dict setValue:@(model.isClick) forKey:@"photoCheck"];
                break;
            
            default:
                break;
        }
    }];
    return dict;
}

+ (NSArray *)shareNoClickTimeModel {
    
    
    SFAttendanceSetModel * model1 = [SFAttendanceSetModel manageTitle:@"日期：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    
    NSArray * array1 = @[model1];
    
    SFAttendanceSetModel * model2 = [SFAttendanceSetModel manageTitle:@"事由：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:3 withValue:@"" withPersons:@[]];

    
    NSArray * array2 = @[model2];
    
    return @[array1,array2];
}

+ (NSArray *)shareSpecialTimeModel {
    
    
    SFAttendanceSetModel * model1 = [SFAttendanceSetModel manageTitle:@"日期：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[]];
    
    NSArray * array1 = @[model1];
    
    SFAttendanceSetModel * model2 = [SFAttendanceSetModel manageTitle:@"上班：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    
    SFAttendanceSetModel * model3 = [SFAttendanceSetModel manageTitle:@"下班：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    
    NSArray * array2 = @[model2,model3];
    
    SFAttendanceSetModel * model4 = [SFAttendanceSetModel manageTitle:@"添加时段" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    
    NSArray * array3 = @[model4];
    
    SFAttendanceSetModel * model6 = [SFAttendanceSetModel manageTitle:@"事由：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:6 withValue:@"" withPersons:@[]];
    
    
    NSArray * array4 = @[model6];
    
    return @[array1,array2,array3,array4];
}

+ (NSArray *)shareLimitPunchTimeModel {
    
    SFAttendanceSetModel * model1 = [SFAttendanceSetModel manageTitle:@"凌晨4点以后可打上班卡" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFAttendanceSetModel * model2 = [SFAttendanceSetModel manageTitle:@"上班前15分钟分钟可打卡" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    SFAttendanceSetModel * model3 = [SFAttendanceSetModel manageTitle:@"上班前30分钟分钟可打卡" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    SFAttendanceSetModel * model4 = [SFAttendanceSetModel manageTitle:@"上班前1小时可打卡" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    SFAttendanceSetModel * model5 = [SFAttendanceSetModel manageTitle:@"上班前2小时可打卡" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[]];
    SFAttendanceSetModel * model6 = [SFAttendanceSetModel manageTitle:@"上班前3小时可打卡" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[]];
    
    return @[model1,model2,model3,model4,model5,model6];
}

+ (NSArray *)sharePunchTimeModel {
    
    
    SFAttendanceSetModel * model1 = [SFAttendanceSetModel manageTitle:@"工作日：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[]];
    
    NSArray * array1 = @[model1];
    
    SFAttendanceSetModel * model2 = [SFAttendanceSetModel manageTitle:@"上班：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    
    SFAttendanceSetModel * model3 = [SFAttendanceSetModel manageTitle:@"下班：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    
    NSArray * array2 = @[model2,model3];
    
    SFAttendanceSetModel * model4 = [SFAttendanceSetModel manageTitle:@"添加时段" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    
    NSArray * array3 = @[model4];
    
    SFAttendanceSetModel * model6 = [SFAttendanceSetModel manageTitle:@"允许迟到分钟数：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[]];
    
    SFAttendanceSetModel * model7 = [SFAttendanceSetModel manageTitle:@"允许早退分钟数：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:7 withValue:@"" withPersons:@[]];
    
    SFAttendanceSetModel * model8 = [SFAttendanceSetModel manageTitle:@"打卡时间限制：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:8 withValue:@"" withPersons:@[]];
    
    SFAttendanceSetModel * model9 = [SFAttendanceSetModel manageTitle:@"迟到时长算旷工：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:9 withValue:@"" withPersons:@[]];
    
    NSArray * array4 = @[model6,model7,model8,model9];
    
    return @[array1,array2,array3,array4];
}

+ (NSArray *)addPunchTimeSection{
    
    SFAttendanceSetModel * model2 = [SFAttendanceSetModel manageTitle:@"上班：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    
    SFAttendanceSetModel * model3 = [SFAttendanceSetModel manageTitle:@"下班：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    
    NSArray * array2 = @[model2,model3];
    return array2;
}

+ (NSArray *)shareAttendanceSetModel {
    
    
    SFAttendanceSetModel * model1 = [SFAttendanceSetModel manageTitle:@"考勤组名称：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    
    NSArray * array1 = @[model1];
    
    SFAttendanceSetModel * model2 = [SFAttendanceSetModel manageTitle:@"打卡时间：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    
    SFAttendanceSetModel * model3 = [SFAttendanceSetModel manageTitle:@"打卡位置：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    
    NSArray * array2 = @[model2,model3];
    
    SFAttendanceSetModel * model4 = [SFAttendanceSetModel manageTitle:@"打卡人员：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    
    
    SFAttendanceSetModel * model5 = [SFAttendanceSetModel manageTitle:@"汇报对象：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[]];
    
    NSArray * array3 = @[model4,model5];
    
     SFAttendanceSetModel * model6 = [SFAttendanceSetModel manageTitle:@"打卡提醒：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[]];
    
    
    
     SFAttendanceSetModel * model7 = [SFAttendanceSetModel manageTitle:@"特殊日期：" withDestitle:@"" withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:7 withValue:@"" withPersons:@[]];
    
    NSArray * array4 = @[model6,model7];
    
     SFAttendanceSetModel * model8 = [SFAttendanceSetModel manageTitle:@"同步中国节假日：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:8 withValue:@"" withPersons:@[]];
    
    SFAttendanceSetModel * model9 = [SFAttendanceSetModel manageTitle:@"拍照打卡：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:9 withValue:@"" withPersons:@[]];
    
    NSArray * array5 = @[model8,model9];
    
    
    return @[array1,array2,array3,array4,array5];
}


+ (NSArray *)shareAttendanceSetModel:(SFAttendanceModel *)model {
    
    
    SFAttendanceSetModel * model1 = [SFAttendanceSetModel manageTitle:@"考勤组名称：" withDestitle:model.name withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    
    NSArray * array1 = @[model1];
    
    AttendanceDateModel * arrm = model.attendanceDateDTOList[0];
    NSString * title = @" ";
    for (int i = 0; i < arrm.days.count; i ++) {
        NSString * day = arrm.days[i];
        switch ([day integerValue]) {
            case 1:
                title = [NSString stringWithFormat:@"%@ 星期一",title];
                break;
            case 2:
                title = [NSString stringWithFormat:@"%@ 星期二",title];
                break;
            case 3:
                title = [NSString stringWithFormat:@"%@ 星期三",title];
                break;
            case 4:
                title = [NSString stringWithFormat:@"%@ 星期四",title];
                break;
            case 5:
                title = [NSString stringWithFormat:@"%@ 星期五",title];
                break;
            case 6:
                title = [NSString stringWithFormat:@"%@ 星期六",title];
                break;
            case 7:
                title = [NSString stringWithFormat:@"%@ 星期日",title];
                break;
                
            default:
                break;
        }
    }
    
    
    NSString * time = @" ";
    for (int i = 0; i < arrm.attendanceTimeDTOList.count; i ++) {
        AttendanceTimeModel * mod = arrm.attendanceTimeDTOList[i];
        
        time = [NSString stringWithFormat:@"%@ %@ %@ ",time,mod.startTime,mod.endTime];
    }
    
    SFAttendanceSetModel * model2 = [SFAttendanceSetModel manageTitle:@"打卡时间：" withDestitle:[NSString stringWithFormat:@"%@ %@",title,time] withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    
     SFAddressModel * addree = model.addressDTOList[0];
    
    SFAttendanceSetModel * model3 = [SFAttendanceSetModel manageTitle:@"打卡位置：" withDestitle:addree.address withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    
    NSArray * array2 = @[model2,model3];
    
    NSString * title1 = @" ";
    for (AttendancePersonnelModel * mod  in model.attendancePersonnelDTOList) {
        title1 = [NSString stringWithFormat:@"%@ %@",title1,mod.targetName];
    }
    
    SFAttendanceSetModel * model4 = [SFAttendanceSetModel manageTitle:@"打卡人员：" withDestitle:title1 withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    
    NSString * title2 = @" ";
    for (ReportUserModel * mod  in model.reportUserList) {
        title2 = [NSString stringWithFormat:@"%@ %@",title2,mod.name];
    }
    SFAttendanceSetModel * model5 = [SFAttendanceSetModel manageTitle:@"汇报对象：" withDestitle:title2 withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[]];
    
    NSArray * array3 = @[model4,model5];
    
    NSString * title3 = [NSString stringWithFormat:@"上班提前%@分钟",model.startRemind];
    SFAttendanceSetModel * model6 = [SFAttendanceSetModel manageTitle:@"打卡提醒：" withDestitle:title3 withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:model.startRemind withPersons:@[]];
    
    NSString * title4 = @" ";
    for (SpecialDateModel * mod  in model.specialDateDTOList) {
        title4 = [NSString stringWithFormat:@"%@ %@",title4,mod.specialDate];
    }
    
    SFAttendanceSetModel * model7 = [SFAttendanceSetModel manageTitle:@"特殊日期：" withDestitle:title4 withPlaceholder:@"请设置" withStars:@"" withDescolor:@"" withClick:NO withType:7 withValue:@"" withPersons:@[]];
    
    NSArray * array4 = @[model6,model7];
    
    SFAttendanceSetModel * model8 = [SFAttendanceSetModel manageTitle:@"同步中国节假日：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:model.holidays withType:8 withValue:@"" withPersons:@[]];
    
    SFAttendanceSetModel * model9 = [SFAttendanceSetModel manageTitle:@"拍照打卡：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:model.photoCheck withType:9 withValue:@"" withPersons:@[]];
    
    NSArray * array5 = @[model8,model9];
    
    
    return @[array1,array2,array3,array4,array5];
}

+ (SFAttendanceSetModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value withPersons:(NSArray *)persons{
    
    SFAttendanceSetModel * model = [[SFAttendanceSetModel alloc] init];
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



