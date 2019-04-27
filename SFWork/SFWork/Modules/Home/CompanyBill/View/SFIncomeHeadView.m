//
//  SFIncomeHeadView.m
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFIncomeHeadView.h"

@interface SFIncomeHeadView()

@end

@implementation SFIncomeHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    _outBtn.layer.cornerRadius = _outBtn.height/2;
}
- (IBAction)outAction:(UIButton *)sender {
    if (self.outBlock) {
        self.outBlock();
    }
}
@end
