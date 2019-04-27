//
//  SFAttendanceMgrModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttendanceMgrModel.h"

@implementation SFAttendanceMgrModel


+ (NSArray *)shareMyAttendanceTripModelModel:(ApprovalDetailsModel *)model {
    
    SFAttendanceMgrModel * model21 = [SFAttendanceMgrModel manageTitle:@"开始时间：" withDestitle:model.startTime withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    SFAttendanceMgrModel * model22 = [SFAttendanceMgrModel manageTitle:@"结束时间：" withDestitle:model.endTime withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    SFAttendanceMgrModel * model23 = [SFAttendanceMgrModel manageTitle:@"出差时长：" withDestitle:[NSString stringWithFormat:@"%@ 天",model.duration] withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    NSArray * array2 = @[model21,model22,model23];
    
    SFAttendanceMgrModel * model1 = [SFAttendanceMgrModel manageTitle:@"出差地点：" withDestitle:model.site withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    NSArray * array1 = @[model1];
    
    SFAttendanceMgrModel * model3 = [SFAttendanceMgrModel manageTitle:@"出差事由：" withDestitle:model.cause withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[]];
    NSArray * array3 = @[model3];
    
    SFAttendanceMgrModel * model4 = [SFAttendanceMgrModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[]];
    NSArray * array4 = @[model4];
    
    SFAttendanceMgrModel * model5 = [SFAttendanceMgrModel manageTitle:@"审批人" withDestitle:@"" withPlaceholder:@"" withStars:@"*" withDescolor:@"" withClick:NO withType:7 withValue:@"" withPersons:@[]];
    NSArray * array5 = @[model5];
    
    SFAttendanceMgrModel * model6 = [SFAttendanceMgrModel manageTitle:@"抄送人" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:8 withValue:@"" withPersons:@[]];
    NSArray * array6 = @[model6];
    
    return @[array2,array1,array3,array4,array5,array6];
}

+ (NSArray *)shareMyAttendanceOvertimeModelModel:(ApprovalDetailsModel *)model {
    
    SFAttendanceMgrModel * model21 = [SFAttendanceMgrModel manageTitle:@"开始时间：" withDestitle:model.startTime withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    SFAttendanceMgrModel * model22 = [SFAttendanceMgrModel manageTitle:@"结束时间：" withDestitle:model.endTime withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    SFAttendanceMgrModel * model23 = [SFAttendanceMgrModel manageTitle:@"加班时长：" withDestitle:[NSString stringWithFormat:@"%@ 天",model.duration] withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    NSArray * array2 = @[model21,model22,model23];
    
    SFAttendanceMgrModel * model3 = [SFAttendanceMgrModel manageTitle:@"加班事由：" withDestitle:model.cause withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[]];
    NSArray * array3 = @[model3];
    
    SFAttendanceMgrModel * model4 = [SFAttendanceMgrModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[]];
    NSArray * array4 = @[model4];
    
    SFAttendanceMgrModel * model5 = [SFAttendanceMgrModel manageTitle:@"审批人" withDestitle:@"" withPlaceholder:@"" withStars:@"*" withDescolor:@"" withClick:NO withType:7 withValue:@"" withPersons:@[]];
    NSArray * array5 = @[model5];
    
    SFAttendanceMgrModel * model6 = [SFAttendanceMgrModel manageTitle:@"抄送人" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:8 withValue:@"" withPersons:@[]];
    NSArray * array6 = @[model6];
    
    return @[array2,array3,array4,array5,array6];
}

+ (NSArray *)shareAttendanceMgrDateilModel:(ApprovalDetailsModel *)model {
    
  
    SFAttendanceMgrModel * model1 = [SFAttendanceMgrModel manageTitle:@"请假类型：" withDestitle:model.leaveName withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    NSArray * array1 = @[model1];
    
    SFAttendanceMgrModel * model21 = [SFAttendanceMgrModel manageTitle:@"开始时间：" withDestitle:model.startTime withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    SFAttendanceMgrModel * model22 = [SFAttendanceMgrModel manageTitle:@"结束时间：" withDestitle:model.endTime withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    SFAttendanceMgrModel * model23 = [SFAttendanceMgrModel manageTitle:@"请假时长：" withDestitle:[NSString stringWithFormat:@"%@ 天",model.duration] withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    NSArray * array2 = @[model21,model22,model23];
    
    SFAttendanceMgrModel * model3 = [SFAttendanceMgrModel manageTitle:@"请假事由：" withDestitle:model.cause withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[]];
    NSArray * array3 = @[model3];
    
    SFAttendanceMgrModel * model4 = [SFAttendanceMgrModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[]];
    NSArray * array4 = @[model4];
    
    SFAttendanceMgrModel * model5 = [SFAttendanceMgrModel manageTitle:@"审批人" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:7 withValue:@"" withPersons:@[]];
    NSArray * array5 = @[model5];
    
    SFAttendanceMgrModel * model6 = [SFAttendanceMgrModel manageTitle:@"抄送人" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:8 withValue:@"" withPersons:@[]];
    NSArray * array6 = @[model6];
    
    
    
    return @[array1,array2,array3,array4,array5,array6];
}

+ (SFAttendanceMgrModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value withPersons:(NSArray *)persons{
    
    SFAttendanceMgrModel * model = [[SFAttendanceMgrModel alloc] init];
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
