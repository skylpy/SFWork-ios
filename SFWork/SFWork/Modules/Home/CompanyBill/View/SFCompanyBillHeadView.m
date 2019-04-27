//
//  SFCompanyBillHeadView.m
//  SFWork
//
//  Created by fox on 2019/4/15.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFCompanyBillHeadView.h"

@interface SFCompanyBillHeadView()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *dayIncomeLB;
@property (weak, nonatomic) IBOutlet UILabel *dayOutLB;
@property (weak, nonatomic) IBOutlet UILabel *balanceLB;


@end

@implementation SFCompanyBillHeadView


- (void)awakeFromNib{
    [super awakeFromNib];
    _mainView.layer.cornerRadius = 8;
}

- (void)setInfoDic:(NSDictionary *)infoDic{
    _dayIncomeLB.text = [SFCommon getNULLStringReturnZero:infoDic[@"debitAmount"]];
    _dayOutLB.text = [SFCommon getNULLStringReturnZero:infoDic[@"creditAmount"]];
    _balanceLB.text = [SFCommon getNULLStringReturnZero:infoDic[@"totalAmt"]];
}

@end
