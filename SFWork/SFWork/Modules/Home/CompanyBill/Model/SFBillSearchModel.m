//
//  SFBillSearchModel.m
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFBillSearchModel.h"

@implementation SFBillSearchModel

+ (NSArray *)shareSearchItemArray{
    NSArray * array1 = @[[SFBillSearchModel manageTitle:@"编号：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]]];
    SFBillSearchModel * model1 = [SFBillSearchModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:5 withValue:@"" withPersons:[SFSearchApprpvalModel apprpvalSixModel:nil]];
    NSArray * array2 = @[model1];
    NSArray * array3 = [SFBillSearchModel shareAddSixCostModel:nil];
    SFBillSearchModel * model4 = [SFBillSearchModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:5 withValue:@"" withPersons:[SFSearchApprpvalModel apprpvalModel:nil]];
    NSArray * array4 = @[model4];
    NSArray * array5 = @[[SFBillSearchModel manageTitle:@"出纳人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]]];
    SFBillSearchModel * model6 = [SFBillSearchModel manageTitle:@"摘要：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:3 withValue:@"" withPersons:@[]];
    model6.limitCount = @"500";
    SFBillSearchModel * model7 = [SFBillSearchModel manageTitle:@"科目：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:3 withValue:@"" withPersons:@[]];
    model7.limitCount = @"500";
    NSArray * array6 = @[model6,model7];
    return @[array1,array2,array3,array4,array5,array6];
}

+ (NSArray *)shareShowItemArray:(SFFinancialModel *)model{
    NSArray * array1 = @[[SFBillSearchModel manageTitle:@"编号：" withDestitle:model.bizNo withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]]];
    SFBillSearchModel * model1 = [SFBillSearchModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:5 withValue:@"" withPersons:[SFSearchApprpvalModel apprpvalSixModel:model]];
    NSArray * array2 = @[model1];
    NSArray * array3 = [SFBillSearchModel shareAddSixCostModel:model];
    
    SFBillSearchModel * model44 = [SFBillSearchModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    NSArray * array44 = @[model44];
    
    SFBillSearchModel * model4 = [SFBillSearchModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:5 withValue:@"" withPersons:[SFSearchApprpvalModel apprpvalModel:model]];
    NSArray * array4 = @[model4];
    NSArray * array5 = @[[SFBillSearchModel manageTitle:@"出纳人：" withDestitle:model.cashierName withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:model.cashierId withPersons:@[]]];
    SFBillSearchModel * model6 = [SFBillSearchModel manageTitle:@"摘要：" withDestitle:model.remark withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:3 withValue:@"" withPersons:@[]];
    model6.limitCount = @"500";
    SFBillSearchModel * model7 = [SFBillSearchModel manageTitle:@"科目：" withDestitle:model.subject withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:3 withValue:@"" withPersons:@[]];
    model7.limitCount = @"500";
    NSArray * array6 = @[model6,model7];
    return @[array1,array2,array3,array44,array4,array5,array6];
}

+ (NSArray *)shareShowItemArrayWithModel:(SFBillInfoModel *)model{
    NSArray * array1 = @[[SFBillSearchModel manageTitle:@"编号：" withDestitle:model.bizNo withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]]];
    SFBillSearchModel * model1 = [SFBillSearchModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:[SFSearchApprpvalModel apprpvalSixShowModel:model]];
    NSArray * array2 = @[model1];
    NSArray * array3 = [SFBillSearchModel shareAddSixCostModelWithModel:model];
    
    SFBillSearchModel * model44 = [SFBillSearchModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:model.photos];
    NSArray * array44 = @[model44];
    
    SFBillSearchModel * model4 = [SFBillSearchModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:[SFSearchApprpvalModel apprpvalShowModel:model]];
    NSArray * array4 = @[model4];
    NSArray * array5 = @[[SFBillSearchModel manageTitle:@"出纳人：" withDestitle:model.cashierName withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]]];
    SFBillSearchModel * model6 = [SFBillSearchModel manageTitle:@"摘要：" withDestitle:model.remark withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
//    model6.limitCount = @"500";
    SFBillSearchModel * model7 = [SFBillSearchModel manageTitle:@"科目：" withDestitle:model.subject withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
//    model7.limitCount = @"500";
    NSArray * array6 = @[model6,model7];
    return @[array1,array2,array3,array44,array4,array5,array6];
}

+ (NSArray *)shareAddItemArray:(NSString *)type {
    NSArray * array1 = @[[SFBillSearchModel manageTitle:@"编号：" withDestitle:type withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]]];
    SFBillSearchModel * model1 = [SFBillSearchModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:2 withValue:@"" withPersons:[SFSearchApprpvalModel addFinaSixModel]];
    NSArray * array2 = @[model1];
    NSArray * array3 = [SFBillSearchModel shareAddFinanSixCostModel];
    
    SFBillSearchModel * model44 = [SFBillSearchModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    NSArray * array44 = @[model44];
    
    SFBillSearchModel * model4 = [SFBillSearchModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:4 withValue:@"" withPersons:[SFSearchApprpvalModel apprpvalModel]];
    NSArray * array4 = @[model4];
    NSArray * array5 = @[[SFBillSearchModel manageTitle:@"出纳人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[]]];
    SFBillSearchModel * model6 = [SFBillSearchModel manageTitle:@"摘要：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"*" withDescolor:@"" withClick:YES withType:6 withValue:@"" withPersons:@[]];
    model6.limitCount = @"500";
    SFBillSearchModel * model7 = [SFBillSearchModel manageTitle:@"科目：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:7 withValue:@"" withPersons:@[]];
    model7.limitCount = @"500";
    NSArray * array6 = @[model6,model7];
    return @[array1,array2,array3,array44,array4,array5,array6];
}



+ (SFBillSearchModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value withPersons:(NSArray *)persons{
    
    SFBillSearchModel * model = [[SFBillSearchModel alloc] init];
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

+ (NSArray *)shareAddSixCostModel:(SFFinancialModel *)model{
    SFBillSearchModel * model1 = [SFBillSearchModel manageTitle:@"类别：" withDestitle:@"111" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model2 = [SFBillSearchModel manageTitle:@"业务日期：" withDestitle:model.bizDate withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model3 = [SFBillSearchModel manageTitle:@"来往业务：" withDestitle:[SFCommon getNULLString:model.dealing] withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model4 = [SFBillSearchModel manageTitle:@"记账方式：" withDestitle:model.chargeType withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model5 = [SFBillSearchModel manageTitle:@"关键词：" withDestitle:model.keyword withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model6 = [SFBillSearchModel manageTitle:@"客户：" withDestitle:model.customerName withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    return @[model1,model2,model3,model4,model5,model6];
}

+ (NSArray *)shareAddSixCostModelWithModel:(SFBillInfoModel *)model{
    SFBillSearchModel * model1 = [SFBillSearchModel manageTitle:@"类别：" withDestitle:model.category withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model2 = [SFBillSearchModel manageTitle:@"业务日期：" withDestitle:model.bizDate withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model3 = [SFBillSearchModel manageTitle:@"来往业务：" withDestitle:[SFCommon getNULLString:model.dealing] withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model4 = [SFBillSearchModel manageTitle:@"记账方式：" withDestitle:model.chargeType withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model5 = [SFBillSearchModel manageTitle:@"关键词：" withDestitle:model.keyword withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model6 = [SFBillSearchModel manageTitle:@"客户：" withDestitle:model.customer withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    return @[model1,model2,model3,model4,model5,model6];
}

+ (NSArray *)shareAddFinanSixCostModel{
    SFBillSearchModel * model1 = [SFBillSearchModel manageTitle:@"类别：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:8 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model2 = [SFBillSearchModel manageTitle:@"业务日期：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"*" withDescolor:@"" withClick:NO withType:9 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model3 = [SFBillSearchModel manageTitle:@"来往业务：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:10 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model4 = [SFBillSearchModel manageTitle:@"记账方式：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:11 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model5 = [SFBillSearchModel manageTitle:@"关键词：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:12 withValue:@"" withPersons:@[]];
    SFBillSearchModel * model6 = [SFBillSearchModel manageTitle:@"客户：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:NO withType:13 withValue:@"" withPersons:@[]];
    return @[model1,model2,model3,model4,model5,model6];
}


@end



@implementation SFSearchApprpvalModel

+ (NSArray *)apprpvalModel {
    SFSearchApprpvalModel * model1 = [SFSearchApprpvalModel manageTitle:@"经办人：" withDetitle:@"" withValue:@"" withPlaceholder:@"请选择" withClick:NO];
    SFSearchApprpvalModel * model2 = [SFSearchApprpvalModel manageTitle:@"制表人：" withDetitle:[SFInstance shareInstance].userInfo.name withValue:[SFInstance shareInstance].userInfo._id withPlaceholder:@"请选择" withClick:NO];
    SFSearchApprpvalModel * model3 = [SFSearchApprpvalModel manageTitle:@"审核人：" withDetitle:@"" withValue:@"" withPlaceholder:@"请选择" withClick:NO];
    SFSearchApprpvalModel * model4 = [SFSearchApprpvalModel manageTitle:@"审批人：" withDetitle:@"" withValue:@"" withPlaceholder:@"请选择" withClick:NO];
    return @[model1,model2,model3,model4];
}

+ (NSArray *)apprpvalModel:(SFFinancialModel *)model {
    SFSearchApprpvalModel * model1 = [SFSearchApprpvalModel manageTitle:@"经办人：" withDetitle:model.operatorName withValue:model.operatorId withPlaceholder:@"请选择" withClick:NO];
    SFSearchApprpvalModel * model2 = [SFSearchApprpvalModel manageTitle:@"制表人：" withDetitle:model.listerName withValue:model.listerId withPlaceholder:@"请选择" withClick:NO];
    SFSearchApprpvalModel * model3 = [SFSearchApprpvalModel manageTitle:@"审核人：" withDetitle:model.auditorName withValue:model.auditorId withPlaceholder:@"请选择" withClick:NO];
    SFSearchApprpvalModel * model4 = [SFSearchApprpvalModel manageTitle:@"审批人：" withDetitle:model.approverName withValue:model.approverId withPlaceholder:@"请选择" withClick:NO];
    return @[model1,model2,model3,model4];
}

+ (NSArray *)apprpvalShowModel:(SFBillInfoModel *)model{
    SFSearchApprpvalModel * model1 = [SFSearchApprpvalModel manageTitle:@"经办人：" withDetitle:model.operatorName withValue:model.operatorId withPlaceholder:@"" withClick:NO];
    SFSearchApprpvalModel * model2 = [SFSearchApprpvalModel manageTitle:@"制表人：" withDetitle:model.listerName withValue:@"" withPlaceholder:@"" withClick:NO];
    SFSearchApprpvalModel * model3 = [SFSearchApprpvalModel manageTitle:@"审核人：" withDetitle:model.auditorName withValue:@"" withPlaceholder:@"" withClick:NO];
    SFSearchApprpvalModel * model4 = [SFSearchApprpvalModel manageTitle:@"审批人：" withDetitle:model.approverName withValue:@"" withPlaceholder:@"" withClick:NO];
    return @[model1,model2,model3,model4];
}

+ (NSArray *)apprpvalSixModel:(SFFinancialModel *)model {
    SFSearchApprpvalModel * model1 = [SFSearchApprpvalModel manageTitle:@"收入金额：" withDetitle:model.amount withValue:[SFInstance shareInstance].userInfo._id withPlaceholder:@"" withClick:YES];
    SFSearchApprpvalModel * model2 = [SFSearchApprpvalModel manageTitle:@"结账方式：" withDetitle:model.chargeType withValue:@"" withPlaceholder:@"" withClick:YES];
    SFSearchApprpvalModel * model3 = [SFSearchApprpvalModel manageTitle:@"单价：" withDetitle:model.price withValue:@"" withPlaceholder:@"" withClick:YES];
    SFSearchApprpvalModel * model4 = [SFSearchApprpvalModel manageTitle:@"数量：" withDetitle:model.num withValue:@"" withPlaceholder:@"" withClick:YES];
    SFSearchApprpvalModel * model5 = [SFSearchApprpvalModel manageTitle:@"凭证字：" withDetitle:model.voucherWord withValue:@"" withPlaceholder:@"" withClick:YES];
    SFSearchApprpvalModel * model6 = [SFSearchApprpvalModel manageTitle:@"凭证号：" withDetitle:model.voucherNo withValue:@"" withPlaceholder:@"" withClick:YES];
    return @[model1,model2,model3,model4,model5,model6];
}

+ (NSArray *)apprpvalSixShowModel:(SFBillInfoModel *)model{
    SFSearchApprpvalModel * model1 = [SFSearchApprpvalModel manageTitle:@"收入金额：" withDetitle:model.amount withValue:@"" withPlaceholder:@"" withClick:NO];
    SFSearchApprpvalModel * model2 = [SFSearchApprpvalModel manageTitle:@"结账方式：" withDetitle:model.chargeType withValue:@"" withPlaceholder:@"" withClick:NO];
    SFSearchApprpvalModel * model3 = [SFSearchApprpvalModel manageTitle:@"单价：" withDetitle:model.price withValue:@"" withPlaceholder:@"" withClick:NO];
    SFSearchApprpvalModel * model4 = [SFSearchApprpvalModel manageTitle:@"数量：" withDetitle:model.num withValue:@"" withPlaceholder:@"" withClick:NO];
    SFSearchApprpvalModel * model5 = [SFSearchApprpvalModel manageTitle:@"凭证字：" withDetitle:model.voucherWord withValue:@"" withPlaceholder:@"" withClick:NO];
    SFSearchApprpvalModel * model6 = [SFSearchApprpvalModel manageTitle:@"凭证号：" withDetitle:model.voucherNo withValue:@"" withPlaceholder:@"" withClick:NO];
    return @[model1,model2,model3,model4,model5,model6];
}

+ (NSArray *)addFinaSixModel {
    SFSearchApprpvalModel * model1 = [SFSearchApprpvalModel manageTitle:@"收入金额：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFSearchApprpvalModel * model2 = [SFSearchApprpvalModel manageTitle:@"结账方式：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFSearchApprpvalModel * model3 = [SFSearchApprpvalModel manageTitle:@"单价：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFSearchApprpvalModel * model4 = [SFSearchApprpvalModel manageTitle:@"数量：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFSearchApprpvalModel * model5 = [SFSearchApprpvalModel manageTitle:@"凭证字：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFSearchApprpvalModel * model6 = [SFSearchApprpvalModel manageTitle:@"凭证号：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    return @[model1,model2,model3,model4,model5,model6];
}

+ (SFSearchApprpvalModel *)manageTitle:(NSString *)title withDetitle:(NSString *)detitle withValue:(NSString *)value withPlaceholder:(NSString *)placeholder withClick:(BOOL)isClick{
    
    SFSearchApprpvalModel * model = [SFSearchApprpvalModel new];
    model.title = title;
    model.value = value;
    model.detitle = detitle;
    model.placeholder = placeholder;
    model.isClick = isClick;
    return model;
}
@end
