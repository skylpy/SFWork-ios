//
//  FromDateSelectDatePick.m
//  LJDateTimePickerViewDemo
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 罗盼. All rights reserved.
//


#import "FromDateSelectDatePick.h"
#import "SFDatePickView.h"

@interface FromDateSelectDatePick()<UIScrollViewDelegate,DatePickDelegate>
@property (weak, nonatomic) IBOutlet UIView *datePickBackView;
@property (weak, nonatomic) IBOutlet UILabel *startDateLB;
@property (weak, nonatomic) IBOutlet UILabel *endDateLB;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (strong, nonatomic) UIScrollView * scrollerView;
@property (strong, nonatomic) SFDatePickView * pickerView;
@property (strong, nonatomic) SFDatePickView * endPickerView;
@property (nonatomic,strong) NSString *string;
@end

@implementation FromDateSelectDatePick

- (void)awakeFromNib{
    [super awakeFromNib];
}


- (void)initUI{
    if (_onlyOneDateSelect) {
        _datePickBackView.centerY -= 40/2;
        _datePickBackView.height += 40;
        _pickerView = [[SFDatePickView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 165)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.pickerViewMode = 2;
        _pickerView.delegate = self;
        [_pickerView setCurrentDate:[NSDate date]];
        [_datePickBackView addSubview:_pickerView];
        _bottomLine.hidden = YES;
    }else{
        _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 165)];
        _scrollerView.contentSize = CGSizeMake(kWidth*2, 0);
        _scrollerView.pagingEnabled = YES;
        _scrollerView.delegate = self;
        [_datePickBackView addSubview:_scrollerView];
        
        _pickerView = [[SFDatePickView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 165)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.pickerViewMode = 2;
        _pickerView.delegate = self;
        [_pickerView setCurrentDate:[NSDate date]];
        [_scrollerView addSubview:_pickerView];
        
        _endPickerView = [[SFDatePickView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, 165)];
        _endPickerView.backgroundColor = [UIColor whiteColor];
        _endPickerView.pickerViewMode = 2;
        _endPickerView.delegate = self;
        [_endPickerView setCurrentDate:[NSDate date]];
        [_scrollerView addSubview:_endPickerView];
    }

}

- (void)setTitleStr:(NSString *)titleStr{
    _titleLB.text = titleStr;
}

- (IBAction)sureBtnAction:(id)sender {
    if (self.sureBlock) {
        
        self.sureBlock([_pickerView getCurrenSelectDate], @"");
    }
    [self removeFromSuperview];
}

- (IBAction)cancelBtnAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)startTimeTapAction:(UITapGestureRecognizer *)sender {
    _startDateLB.textColor = [UIColor colorWithRed:1/255.0 green:179/255.0 blue:139/255.0 alpha:1.0];
    _endDateLB.textColor = [UIColor blackColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomLine.centerX = self.startDateLB.centerX;
    }];
    [_scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)entimeTapAction:(UITapGestureRecognizer *)sender {
    _endDateLB.textColor = [UIColor colorWithRed:1/255.0 green:179/255.0 blue:139/255.0 alpha:1.0];
    _startDateLB.textColor = [UIColor blackColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomLine.centerX = self.endDateLB.centerX;
    }];
    [_scrollerView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
}

- (void)endingSelectDate:(NSString *)date DatePick:(id)datePick{
    if (_pickerView == datePick) {
        [_startDateLB setText:date];
    }else if (_endPickerView == datePick){
        [_endDateLB setText:date];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/kWidth;
    if (page == 0) {
        _startDateLB.textColor = [UIColor colorWithRed:1/255.0 green:179/255.0 blue:139/255.0 alpha:1.0];
        _endDateLB.textColor = [UIColor blackColor];
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomLine.centerX = self.startDateLB.centerX;
        }];
    }else{
        _endDateLB.textColor = [UIColor colorWithRed:1/255.0 green:179/255.0 blue:139/255.0 alpha:1.0];
        _startDateLB.textColor = [UIColor blackColor];
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomLine.centerX = self.endDateLB.centerX;
        }];
    }
        
}

@end
