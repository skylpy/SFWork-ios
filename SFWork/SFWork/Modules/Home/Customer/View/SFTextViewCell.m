//
//  SFTextViewCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTextViewCell.h"
#import "UITextView+XMExtension.h"

@interface SFTextViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *limitCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewConstraint;

@end

@implementation SFTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textView.placeholdLabel.font = [UIFont fontWithName:kRegFont size:14];

    @weakify(self)
    [self.textView.rac_textSignal subscribeNext:^(id x) {

        @strongify(self)
        self.model.destitle = x;
        self.searchModel.destitle = x;
        !self.textChange?:self.textChange(x);

        NSLog(@"model text is%@",self.model.destitle);
    }];
}

- (void)setModel:(SFCustomerModel *)model{
    
    _model = model;
    self.textView.placeholder = model.placeholder;
    self.namelabel.text = model.title;
    self.textView.text = model.destitle;
    self.textView.editable = model.isClick;
    self.textViewConstraint.constant = 10;
    
}

- (void)setSearchModel:(SFBillSearchModel *)searchModel{
    _searchModel = searchModel;
    self.textView.placeholder = searchModel.placeholder;
    self.namelabel.text = searchModel.title;
    self.textView.text = searchModel.destitle;
    self.textView.editable = searchModel.isClick;
    self.textViewConstraint.constant = 10;
    
    if (searchModel.limitCount.integerValue>0) {
        self.limitCount.hidden = NO;
        self.limitCount.text = searchModel.limitCount;
        self.textViewConstraint.constant = 40;
    }
}

- (void)setJmodel:(SFJournalModel *)jmodel{
    _jmodel = jmodel;
    self.namelabel.textColor = Color(jmodel.descolor);
    self.textView.text = jmodel.destitle;
    self.textView.placeholder = jmodel.placeholder;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
