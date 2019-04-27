//
//  SFAssessmentSetModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAssessmentSetModel.h"

@implementation SFAssessmentSetModel

+ (NSMutableDictionary *)pramAssessmentSetJson:(NSArray *)data {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray * arr in data) {
        
        for (SFAssessmentSetModel * model in arr) {
            [array addObject:model];
        }
    }
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFAssessmentSetModel * model = (SFAssessmentSetModel *)obj;
        switch (model.type) {
           
            case 2:
                [dict setValue:model.destitle forKey:@"name"];
                break;
                
            case 3:
                [dict setValue:model.destitle forKey:@"startDate"];
                break;
                
            case 4:
                [dict setValue:model.destitle forKey:@"endDate"];
                break;
                
            default:
                break;
        }
    }];
    return dict;
}

+ (NSArray *)addModel:(NSString *)title WithDestitle:(NSString *)destitle withValue:(NSString *)value withArr:(SFWorkCheckItemModel *)model {
    
    SFAssessmentSetModel * model1 = [SFAssessmentSetModel manageTitle:title withDestitle:destitle withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:7 withValue:value withPersons:@[] withModel:model];
    
    return @[model1];
}

+ (NSArray *)isOn {
    SFAssessmentSetModel * model1 = [SFAssessmentSetModel manageTitle:@"正在执行" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[] withModel:nil];
    
    NSArray * array1 = @[model1];
    return array1;
}

+ (NSArray *)shareAssessmentSetDateil:(SFWorkCheckItemModel *)model {
    
    
    SFAssessmentSetModel * model1 = [SFAssessmentSetModel manageTitle:@"正在执行" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[] withModel:nil];
    
    NSArray * array1 = @[model1];
    
    SFAssessmentSetModel * model2 = [SFAssessmentSetModel manageTitle:@"考核规则名称：" withDestitle:model.name withPlaceholder:@"请输入规则名称" withStars:@"*" withDescolor:@"" withClick:YES withType:2 withValue:@"" withPersons:@[] withModel:nil];
    
    SFAssessmentSetModel * model3 = [SFAssessmentSetModel manageTitle:@"开始时间：" withDestitle:model.startDate withPlaceholder:@"请选择开始时间" withStars:@"*" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[] withModel:nil];
    
    
    SFAssessmentSetModel * model4 = [SFAssessmentSetModel manageTitle:@"结束时间：" withDestitle:model.endDate withPlaceholder:@"请选择结束时间" withStars:@"*" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[] withModel:nil];
    
    NSArray * array2 = @[model2,model3,model4];
    
    NSString * name = @"";
    for (int i = 0; i < model.rulePersonDTOList.count; i ++) {
        RulePersonModel * person = model.rulePersonDTOList[i];
        if (i == 0) {
            name = person.employeeName;
        }else{
            name = [NSString stringWithFormat:@"%@ %@",name,person.employeeName];
        }
    }
    NSString * number = [NSString stringWithFormat:@"已选%ld人",model.rulePersonDTOList.count];
    SFAssessmentSetModel * model5 = [SFAssessmentSetModel manageTitle:@"选择参与考核的员工" withDestitle:number withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:name withPersons:@[] withModel:nil];
    
    NSArray * array3 = @[model5];
    
    SFAssessmentSetModel * model6 = [SFAssessmentSetModel manageTitle:@"添加考核项" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[] withModel:nil];
    
    NSArray * array4 = @[model6];
    
    return @[array1,array2,array3,array4];
}

+ (NSArray *)shareAssessmentSetModel {
    
    
    SFAssessmentSetModel * model1 = [SFAssessmentSetModel manageTitle:@"正在执行" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[] withModel:nil];
    
    NSArray * array1 = @[model1];
    
    SFAssessmentSetModel * model2 = [SFAssessmentSetModel manageTitle:@"考核规则名称：" withDestitle:@"" withPlaceholder:@"请输入规则名称" withStars:@"*" withDescolor:@"" withClick:YES withType:2 withValue:@"" withPersons:@[] withModel:nil];
    
    SFAssessmentSetModel * model3 = [SFAssessmentSetModel manageTitle:@"开始时间：" withDestitle:@"" withPlaceholder:@"请选择开始时间" withStars:@"*" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[] withModel:nil];
    
    
    SFAssessmentSetModel * model4 = [SFAssessmentSetModel manageTitle:@"结束时间：" withDestitle:@"" withPlaceholder:@"请选择结束时间" withStars:@"*" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[] withModel:nil];
    
    NSArray * array2 = @[model2,model3,model4];
    
    SFAssessmentSetModel * model5 = [SFAssessmentSetModel manageTitle:@"选择参与考核的员工" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[] withModel:nil];
    
    NSArray * array3 = @[model5];
    
    SFAssessmentSetModel * model6 = [SFAssessmentSetModel manageTitle:@"添加考核项" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[] withModel:nil];
    
    NSArray * array4 = @[model6];
    
    return @[array1,array2,array3,array4];
}

+ (SFAssessmentSetModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value withPersons:(NSArray *)persons withModel:(SFWorkCheckItemModel *)mod {
    
    SFAssessmentSetModel * model = [[SFAssessmentSetModel alloc] init];
    model.title = title;
    model.descolor = descolor;
    model.stars = stars;
    model.destitle = destitle;
    model.isClick = isClick;
    model.placeholder = placeholder;
    model.type = type;
    model.value = value;
    model.persons = persons;
    model.mod = mod;
    
    return model;
}

@end
