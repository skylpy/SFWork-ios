//
//  SFSalaryEntryModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSalaryEntryModel.h"

@implementation SFSalaryEntryModel

/**
 * des:设置薪资
 * author:SkyWork
 */
+(void)empSetSalary:(NSDictionary *)prame
            success:(void (^)(void))success
            failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(setSalary) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:设置薪资计算规则
 * author:SkyWork
 */
+(void)companySetSalaryRule:(NSDictionary *)prame
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(setSalaryRule) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

+ (NSArray *)shareSalaryEntryModel {
    
    SFSalaryEntryModel * model1 = [SFSalaryEntryModel manageTitle:@"按每月平均法定工作天数21.75天计算薪资" withDestitle:@"日工资=月标准工资/月计薪天数" withCalculate:@"(月计薪天数=(365天-104天公休日)/12月=21.75)" withClick:NO withType:1];
     SFSalaryEntryModel * model2 = [SFSalaryEntryModel manageTitle:@"按每月出勤天数计算薪资" withDestitle:@"日工资=月标准工资/月计薪天数" withCalculate:@"&#91月计薪天数=本月应出勤天数+本月法定节假日(不包括公休日)]" withClick:NO withType:2];
     SFSalaryEntryModel * model3 = [SFSalaryEntryModel manageTitle:@"按每月天数计算薪资" withDestitle:@"日工资=月标准工资/月计薪天数" withCalculate:@"(月计薪天数=本月实际天数)" withClick:NO withType:3];
    return @[model1,model2,model3];
}

+ (SFSalaryEntryModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withCalculate:(NSString *)calculate withClick:(BOOL)isClick withType:(NSInteger)type {
    
    SFSalaryEntryModel * model = [[SFSalaryEntryModel alloc] init];
    model.title = title;
    model.destitle = destitle;
    model.isClick = isClick;
    model.calculate = calculate;
    model.type = type;

    return model;
}


@end
