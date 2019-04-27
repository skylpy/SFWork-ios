//
//  SFFinancialApprovalModel.m
//  SFWork
//
//  Created by fox on 2019/4/25.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFFinancialApprovalModel.h"
#import "SFFinancialApprovalHttpModel.h"

@implementation SFFinancialApprovalModel

+ (NSMutableDictionary *)pramApprovalJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray * arr in data) {
        
        for (SFFinancialApprovalModel * model in arr) {
            [array addObject:model];
        }
    }
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFFinancialApprovalModel * model = (SFFinancialApprovalModel *)obj;
        switch (model.type) {
            case 1:
                [dict setValue:model.destitle forKey:@"bizType"];
                break;
            case 5:
                [dict setValue:model.value forKey:@"cashierId"];
                break;
            case 6:
                [dict setValue:model.title forKey:@"remark"];
                break;
            case 7:
                [dict setValue:model.title forKey:@"subject"];
                break;
            case 8:
                [dict setValue:model.destitle forKey:@"category"];
                break;
            case 9:
                [dict setValue:model.destitle forKey:@"bizDate"];
                break;
            case 10:
                [dict setValue:model.destitle forKey:@"dealing"];
                break;
            case 11:
            {
                [dict setValue:model.destitle forKey:@"chargeType"];
                [dict setValue:model.value forKey:@"chargeTypeId"];
            }
                break;
            case 12:
                [dict setValue:model.destitle forKey:@"keyword"];
                break;
            case 13:
                [dict setValue:model.value forKey:@"customerId"];
                break;
            
            default:
                break;
        }
    }];
    return dict;
}


+ (NSArray *)shareShowItemArray :(SFFinancialModel *)model {
    NSArray * array1 = @[[SFFinancialApprovalModel manageTitle:@"编号：" withDestitle:model.bizNo withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]]];
    SFFinancialApprovalModel * model1 = [SFFinancialApprovalModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:[SFFinaApprovalModel apprpvalSixModel:model]];
    NSArray * array2 = @[model1];
    NSArray * array3 = [SFFinancialApprovalModel shareAddSixCostModel:model];
    
    SFFinancialApprovalModel * model44 = [SFFinancialApprovalModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    NSArray * array44 = @[model44];
    
    SFFinancialApprovalModel * model4 = [SFFinancialApprovalModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:[SFFinaApprovalModel apprpvalModel:model]];
    NSArray * array4 = @[model4];
    NSArray * array5 = @[[SFFinancialApprovalModel manageTitle:@"出纳人：" withDestitle:model.cashierName withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:model.cashierId withPersons:@[]]];
    SFFinancialApprovalModel * model6 = [SFFinancialApprovalModel manageTitle:@"摘要：" withDestitle:model.remark withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    model6.limitCount = @"500";
    SFFinancialApprovalModel * model7 = [SFFinancialApprovalModel manageTitle:@"科目：" withDestitle:model.subject withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    model7.limitCount = @"500";
    NSArray * array6 = @[model6,model7];
    
    SFFinancialApprovalModel * model8 = [SFFinancialApprovalModel manageTitle:@"审批人" withDestitle:@"" withPlaceholder:@"" withStars:@"*" withDescolor:@"" withClick:NO withType:7 withValue:@"" withPersons:@[]];
    NSArray * array7 = @[model8];
    
   
    return @[array1,array2,array3,array44,array4,array5,array6,array7];
}

+ (NSArray *)shareAddSixCostModel:(SFFinancialModel *)model{
    SFFinancialApprovalModel * model1 = [SFFinancialApprovalModel manageTitle:@"类别：" withDestitle:model.category withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFFinancialApprovalModel * model2 = [SFFinancialApprovalModel manageTitle:@"业务日期：" withDestitle:model.bizDate withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFFinancialApprovalModel * model3 = [SFFinancialApprovalModel manageTitle:@"来往业务：" withDestitle:model.dealing withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFFinancialApprovalModel * model4 = [SFFinancialApprovalModel manageTitle:@"记账方式：" withDestitle:model.chargeType withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFFinancialApprovalModel * model5 = [SFFinancialApprovalModel manageTitle:@"关键词：" withDestitle:model.keyword withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFFinancialApprovalModel * model6 = [SFFinancialApprovalModel manageTitle:@"客户：" withDestitle:model.customerName withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    
    
    return @[model1,model2,model3,model4,model5,model6];
}

+ (SFFinancialApprovalModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value withPersons:(NSArray *)persons{
    
    SFFinancialApprovalModel * model = [[SFFinancialApprovalModel alloc] init];
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

@implementation SFFinaApprovalModel
+ (NSArray *)apprpvalModel:(SFFinancialModel *)model {
    SFFinaApprovalModel * model1 = [SFFinaApprovalModel manageTitle:@"经办人：" withDetitle:model.operatorName withValue:model.operatorId withPlaceholder:@"请选择" withClick:NO];
    SFFinaApprovalModel * model2 = [SFFinaApprovalModel manageTitle:@"审核人：" withDetitle:model.auditorName withValue:model.auditorId withPlaceholder:@"请选择" withClick:NO];
    SFFinaApprovalModel * model3 = [SFFinaApprovalModel manageTitle:@"审批人：" withDetitle:model.approverName withValue:model.approverId withPlaceholder:@"请选择" withClick:NO];
    SFFinaApprovalModel * model4 = [SFFinaApprovalModel manageTitle:@"制表人：" withDetitle:model.listerName withValue:model.listerId withPlaceholder:@"请选择" withClick:NO];
    return @[model1,model2,model3,model4];
}

+ (NSArray *)apprpvalShowModel:(SFBillInfoModel *)model{
    SFFinaApprovalModel * model1 = [SFFinaApprovalModel manageTitle:@"经办人：" withDetitle:model.operatorName withValue:[SFInstance shareInstance].userInfo._id withPlaceholder:@"请选择" withClick:NO];
    SFFinaApprovalModel * model2 = [SFFinaApprovalModel manageTitle:@"制表人：" withDetitle:model.listerName withValue:@"" withPlaceholder:@"请选择" withClick:NO];
    SFFinaApprovalModel * model3 = [SFFinaApprovalModel manageTitle:@"审核人：" withDetitle:model.auditorName withValue:@"" withPlaceholder:@"请选择" withClick:NO];
    SFFinaApprovalModel * model4 = [SFFinaApprovalModel manageTitle:@"审批人：" withDetitle:model.approverName withValue:@"" withPlaceholder:@"请选择" withClick:NO];
    return @[model1,model2,model3,model4];
}

+ (NSArray *)apprpvalSixModel:(SFFinancialModel *)model {
    SFFinaApprovalModel * model1 = [SFFinaApprovalModel manageTitle:@"收入金额：" withDetitle:model.amount withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    SFFinaApprovalModel * model2 = [SFFinaApprovalModel manageTitle:@"结账方式：" withDetitle:model.chargeType withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    SFFinaApprovalModel * model3 = [SFFinaApprovalModel manageTitle:@"单价：" withDetitle:model.price withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    SFFinaApprovalModel * model4 = [SFFinaApprovalModel manageTitle:@"数量：" withDetitle:model.num withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    SFFinaApprovalModel * model5 = [SFFinaApprovalModel manageTitle:@"凭证字：" withDetitle:model.voucherWord withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    SFFinaApprovalModel * model6 = [SFFinaApprovalModel manageTitle:@"凭证号：" withDetitle:model.voucherNo withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    return @[model1,model2,model3,model4,model5,model6];
}

+ (NSArray *)apprpvalSixShowModel:(SFBillInfoModel *)model{
    SFFinaApprovalModel * model1 = [SFFinaApprovalModel manageTitle:@"收入金额：" withDetitle:model.amount withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    SFFinaApprovalModel * model2 = [SFFinaApprovalModel manageTitle:@"结账方式：" withDetitle:model.chargeType withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    SFFinaApprovalModel * model3 = [SFFinaApprovalModel manageTitle:@"单价：" withDetitle:model.price withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    SFFinaApprovalModel * model4 = [SFFinaApprovalModel manageTitle:@"数量：" withDetitle:model.num withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    SFFinaApprovalModel * model5 = [SFFinaApprovalModel manageTitle:@"凭证字：" withDetitle:model.voucherWord withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    SFFinaApprovalModel * model6 = [SFFinaApprovalModel manageTitle:@"凭证号：" withDetitle:model.voucherNo withValue:@"" withPlaceholder:@"请输入" withClick:NO];
    return @[model1,model2,model3,model4,model5,model6];
}

+ (NSArray *)addFinaSixModel {
    SFFinaApprovalModel * model1 = [SFFinaApprovalModel manageTitle:@"收入金额：" withDetitle:@"" withValue:[SFInstance shareInstance].userInfo._id withPlaceholder:@"请输入" withClick:YES];
    SFFinaApprovalModel * model2 = [SFFinaApprovalModel manageTitle:@"结账方式：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFFinaApprovalModel * model3 = [SFFinaApprovalModel manageTitle:@"单价：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFFinaApprovalModel * model4 = [SFFinaApprovalModel manageTitle:@"数量：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFFinaApprovalModel * model5 = [SFFinaApprovalModel manageTitle:@"凭证字：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFFinaApprovalModel * model6 = [SFFinaApprovalModel manageTitle:@"凭证号：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    return @[model1,model2,model3,model4,model5,model6];
}

+ (SFFinaApprovalModel *)manageTitle:(NSString *)title withDetitle:(NSString *)detitle withValue:(NSString *)value withPlaceholder:(NSString *)placeholder withClick:(BOOL)isClick{
    
    SFFinaApprovalModel * model = [SFFinaApprovalModel new];
    model.title = title;
    model.value = value;
    model.detitle = detitle;
    model.placeholder = placeholder;
    model.isClick = isClick;
    return model;
}
@end
