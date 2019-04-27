//
//  SFExpenseModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFExpenseModel.h"
#import "SFExpenseHttpModel.h"

@implementation SFExpenseModel


+ (NSArray *)shareCostDateilModel:(ExpenseListModel *)model {
    
    NSMutableArray *allArray = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    for (ExpenseItemModel * item in model.reimbursementItemDTOList) {
        
        [array1 addObject: [SFExpenseModel shareAddModel:item]];
    }
    [allArray addObjectsFromArray:array1];
    SFExpenseModel * model1 = [SFExpenseModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    NSArray * array2 = @[model1];
    
    SFExpenseModel * model2 = [SFExpenseModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:[SFApprpvalModel apprpvalModel:model]];
    NSArray * array3 = @[model2];
    
    SFExpenseModel * model3 = [SFExpenseModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:6 withValue:@"" withPersons:@[]];
    NSArray * array4 = @[model3];
    
    SFExpenseModel * model4 = [SFExpenseModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:7 withValue:@"" withPersons:model.reimbursementProcessDTOList];
    NSArray * array5 = @[model4];
    
    [allArray addObject:array2];
    [allArray addObject:array3];
    [allArray addObject:array5];
    if (model.coToWhos.count > 0) {
        [allArray addObject:array4];
    }
    
    return allArray;
}



+ (NSArray *)shareAddModel:(ExpenseItemModel *)item{
    
    SFExpenseModel * model1 = [SFExpenseModel manageTitle:@"报销金额(元)：" withDestitle:item.amount withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    SFExpenseModel * model2 = [SFExpenseModel manageTitle:@"报销类别：" withDestitle:item.category withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    SFExpenseModel * model3 = [SFExpenseModel manageTitle:@"费用明细：" withDestitle:item.detail withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];
    return @[model1,model2,model3];
}

+ (NSArray *)shareAddCostModel{
    
    SFExpenseModel * model1 = [SFExpenseModel manageTitle:@"报销金额(元)：" withDestitle:@"" withPlaceholder:@"请输入数字" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    SFExpenseModel * model2 = [SFExpenseModel manageTitle:@"报销类别：" withDestitle:@"" withPlaceholder:@"如：出差经费、办公耗材" withStars:@"" withDescolor:@"" withClick:YES withType:2 withValue:@"" withPersons:@[]];
    SFExpenseModel * model3 = [SFExpenseModel manageTitle:@"费用明细：" withDestitle:@"" withPlaceholder:@"请输入费用明细描述" withStars:@"" withDescolor:@"" withClick:YES withType:3 withValue:@"" withPersons:@[]];
    return @[model1,model2,model3];
}

+ (NSArray *)shareAddSixCostModel{
    
    SFExpenseModel * model1 = [SFExpenseModel manageTitle:@"类别：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    SFExpenseModel * model2 = [SFExpenseModel manageTitle:@"业务日期：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    SFExpenseModel * model3 = [SFExpenseModel manageTitle:@"来往业务：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    SFExpenseModel * model4 = [SFExpenseModel manageTitle:@"记账方式：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    SFExpenseModel * model5 = [SFExpenseModel manageTitle:@"关键词：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    SFExpenseModel * model6 = [SFExpenseModel manageTitle:@"客户：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];
    return @[model1,model2,model3,model4,model5,model6];
}

+ (NSArray *)shareCostListModel {
    
    NSArray * array1 = [SFExpenseModel shareAddCostModel];
    
    SFExpenseModel * model1 = [SFExpenseModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:4 withValue:@"" withPersons:@[]];
    NSArray * array2 = @[model1];
    
    SFExpenseModel * model2 = [SFExpenseModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:5 withValue:@"" withPersons:[SFApprpvalModel apprpvalModel]];
    NSArray * array3 = @[model2];
    
    SFExpenseModel * model3 = [SFExpenseModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:6 withValue:@"" withPersons:@[]];
    NSArray * array4 = @[model3];
    
    return @[array1,array2,array3,array4];
}

+ (NSArray *)shareSearchItemArray{
    NSArray * array1 = @[[SFExpenseModel manageTitle:@"编号：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]]];
    SFExpenseModel * model1 = [SFExpenseModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:5 withValue:@"" withPersons:[SFApprpvalModel apprpvalSixModel]];
    NSArray * array2 = @[model1];
    NSArray * array3 = [SFExpenseModel shareAddSixCostModel];
    SFExpenseModel * model4 = [SFExpenseModel manageTitle:@"" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:5 withValue:@"" withPersons:[SFApprpvalModel apprpvalModel]];
    NSArray * array4 = @[model4];
    NSArray * array5 = @[[SFExpenseModel manageTitle:@"出纳人：" withDestitle:@"" withPlaceholder:@"请选择" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]]];
    SFExpenseModel * model6 = [SFExpenseModel manageTitle:@"摘要：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:3 withValue:@"" withPersons:@[]];
    model6.limitCount = @"500";
    SFExpenseModel * model7 = [SFExpenseModel manageTitle:@"科目：" withDestitle:@"" withPlaceholder:@"请输入" withStars:@"" withDescolor:@"" withClick:YES withType:3 withValue:@"" withPersons:@[]];
    model7.limitCount = @"500";
    NSArray * array6 = @[model6,model7];
    return @[array1,array2,array3,array4,array5,array6];
}

+ (SFExpenseModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value withPersons:(NSArray *)persons{
    
    SFExpenseModel * model = [[SFExpenseModel alloc] init];
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

@implementation SFApprpvalModel

+ (NSArray *)apprpvalModel:(ExpenseListModel *)model {
    
    SFApprpvalModel * model1 = [SFApprpvalModel manageTitle:@"报销人：" withDetitle:model.reimbursePersonName withValue:@"" withPlaceholder:@"" withClick:NO];
    SFApprpvalModel * model2 = [SFApprpvalModel manageTitle:@"审核人：" withDetitle:model.checkerName withValue:@"" withPlaceholder:@"" withClick:NO];
    SFApprpvalModel * model3 = [SFApprpvalModel manageTitle:@"审批人：" withDetitle:model.approverName withValue:@"" withPlaceholder:@"" withClick:NO];
    SFApprpvalModel * model4 = [SFApprpvalModel manageTitle:@"出纳人：" withDetitle:model.cashierName withValue:@"" withPlaceholder:@"" withClick:NO];
    return @[model1,model2,model3,model4];
}

+ (NSArray *)apprpvalModel {
    
    SFApprpvalModel * model1 = [SFApprpvalModel manageTitle:@"报销人：" withDetitle:[SFInstance shareInstance].userInfo.name withValue:[SFInstance shareInstance].userInfo._id withPlaceholder:@"请选择" withClick:NO];
    SFApprpvalModel * model2 = [SFApprpvalModel manageTitle:@"审核人：" withDetitle:@"" withValue:@"" withPlaceholder:@"请选择" withClick:NO];
    SFApprpvalModel * model3 = [SFApprpvalModel manageTitle:@"审批人：" withDetitle:@"" withValue:@"" withPlaceholder:@"请选择" withClick:NO];
    SFApprpvalModel * model4 = [SFApprpvalModel manageTitle:@"出纳人：" withDetitle:@"" withValue:@"" withPlaceholder:@"请选择" withClick:NO];
    return @[model1,model2,model3,model4];
}

+ (NSArray *)apprpvalSixModel {
    
    SFApprpvalModel * model1 = [SFApprpvalModel manageTitle:@"收入金额：" withDetitle:@"" withValue:[SFInstance shareInstance].userInfo._id withPlaceholder:@"请输入" withClick:YES];
    SFApprpvalModel * model2 = [SFApprpvalModel manageTitle:@"结账方式：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFApprpvalModel * model3 = [SFApprpvalModel manageTitle:@"单价：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFApprpvalModel * model4 = [SFApprpvalModel manageTitle:@"数量：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFApprpvalModel * model5 = [SFApprpvalModel manageTitle:@"凭证字：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    SFApprpvalModel * model6 = [SFApprpvalModel manageTitle:@"凭证号：" withDetitle:@"" withValue:@"" withPlaceholder:@"请输入" withClick:YES];
    return @[model1,model2,model3,model4,model5,model6];
}

+ (SFApprpvalModel *)manageTitle:(NSString *)title withDetitle:(NSString *)detitle withValue:(NSString *)value withPlaceholder:(NSString *)placeholder withClick:(BOOL)isClick{
    
    SFApprpvalModel * model = [SFApprpvalModel new];
    model.title = title;
    model.value = value;
    model.detitle = detitle;
    model.placeholder = placeholder;
    model.isClick = isClick;
    return model;
}

@end
