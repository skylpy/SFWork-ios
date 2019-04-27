//
//  SFAlertInputView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAlertInputView.h"
#import "UIView+SDAutoLayout.h"
@interface SFAlertInputView()<UITextViewDelegate>{
    
    //备注文本View高度
    float noteTextHeight;
    NSString * _title;
    NSString * _PlaceholderText;
    LSXKeyboardType  _type;
    
    UIView * alertView;
    UILabel * titLa;
    SFPlacehoderTextView * _textView;
    UIButton * qxbtn;
    UIButton * okbtn;
    
    UIView * _longLineView;
    UIView * _shortLineView;
}
typedef void(^doneBlock)(NSString *);
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic,strong)doneBlock doneBlock;

@end

@implementation SFAlertInputView


-(instancetype)initWithTitle:(NSString *)title PlaceholderText:(NSString *)PlaceholderText WithKeybordType:(LSXKeyboardType)bordtype CompleteBlock:(void(^)(NSString * contents))completeBlock{
    
    if([super init]){
        
        _title=title;
        _PlaceholderText=PlaceholderText;
        _type=bordtype;
        self.frame=CGRectMake(0, 0, kWidth, kHeight);
        [self insertSubview:self.shadowView belowSubview:self];
        [self CreatUI];
        
        if (completeBlock) {
            self.doneBlock = ^(NSString * contents) {
                completeBlock(contents);
            };
        }
    }
    return self;
}
-(void)CreatUI{
    
    alertView=[UIView new];
    alertView.backgroundColor=Color(@"#FAFAFA");
    alertView.sd_cornerRadius=[NSNumber numberWithInt:8];
    [_shadowView addSubview:alertView];
    
    
    titLa=[UILabel new];
    titLa.text=_title;
    titLa.textAlignment=NSTextAlignmentCenter;
    titLa.font=[UIFont systemFontOfSize:17];
    [alertView addSubview:titLa];
    
    _textView=[SFPlacehoderTextView new];
    if(_type==0){
        _textView.keyboardType=UIKeyboardTypeDefault;
    }else if (_type==1){
        _textView.keyboardType=UIKeyboardTypeURL;
    }else if (_type==2){
        _textView.keyboardType=UIKeyboardTypeNumberPad;
    }else if (_type==3){
        _textView.keyboardType=UIKeyboardTypePhonePad;
    }else{
        _textView.keyboardType=UIKeyboardTypeNamePhonePad;
    }
    _textView.font=[UIFont systemFontOfSize:15];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.placeholders=_PlaceholderText;
    _textView.layer.borderColor=[UIColor colorWithHexString:@"#E3E3E5"].CGColor;
    _textView.layer.borderWidth=0.5;
    _textView.delegate=self;
    [alertView addSubview:_textView];
    
    
    
    
    qxbtn=[UIButton new];
    [qxbtn addTarget:self action:@selector(qxTap) forControlEvents:UIControlEventTouchUpInside];
    [qxbtn setTitle:@"取消" forState:UIControlStateNormal];
    [qxbtn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
    [alertView addSubview:qxbtn];
    
    okbtn=[UIButton new];
    [okbtn addTarget:self action:@selector(okTap) forControlEvents:UIControlEventTouchUpInside];
    [okbtn setTitleColor:defaultColor forState:UIControlStateNormal];
    [okbtn setTitle:@"确定" forState:UIControlStateNormal];
    [alertView addSubview:okbtn];
    
    [self updateViewsFrame];
    
    _longLineView = [UIView new];
    _longLineView.backgroundColor = Color(@"#D8D8D8");
    [alertView addSubview:_longLineView];
    [_longLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(okbtn.mas_top);
        make.left.right.equalTo(alertView);
        make.height.offset(1);
    }];
    
    _shortLineView = [UIView new];
    _shortLineView.backgroundColor = Color(@"#D8D8D8");
    [alertView addSubview:_shortLineView];
    [_shortLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(alertView.mas_bottom);
        make.top.equalTo(_longLineView.mas_bottom);
        make.width.offset(1);
        make.centerX.equalTo(alertView);
    }];
}
/**
 *  界面布局 frame
 */
- (void)updateViewsFrame{
    
    if (!noteTextHeight) {
        noteTextHeight = 35;
    }
    alertView.sd_layout.centerXIs(self.centerX).centerYIs(self.centerY-60).autoHeightRatio(0).widthIs(kWidth-80);
    
    titLa.sd_layout.topSpaceToView(alertView,20).leftSpaceToView(alertView,0).heightIs(20).rightSpaceToView(alertView,0);
    
    _textView.sd_layout.topSpaceToView(titLa,15).leftSpaceToView(alertView,15).heightIs(noteTextHeight).rightSpaceToView(alertView,15);
    
    qxbtn.sd_layout.topSpaceToView(_textView,25).leftSpaceToView(alertView,0).heightIs(40).widthIs((kWidth-80)/2-1);
    
    okbtn.sd_layout.topSpaceToView(_textView,25).leftSpaceToView(qxbtn,1).heightIs(40).rightSpaceToView(alertView,0);
    
    [alertView setupAutoHeightWithBottomView:okbtn bottomMargin:0];
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self textChanged];
    return YES;
}
/**
 *  文本高度自适应
 */
-(void)textChanged{
    
    CGRect orgRect = _textView.frame;//获取原始UITextView的frame
    
    //获取尺寸
    CGSize size = [_textView sizeThatFits:CGSizeMake(_textView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+5;//获取自适应文本内容高度
    
    //如果文本框没字了恢复初始尺寸
    if (orgRect.size.height > 40) {
        noteTextHeight = orgRect.size.height;
    }else{
        noteTextHeight = 40;
    }
    [self updateViewsFrame];
}
-(int)num{
    if(!_num){
        _num=0;
    }
    return _num;
}
//文本框每次输入文字都会调用  -> 更改文字个数提示框
- (void)textViewDidChangeSelection:(UITextView *)textView{
    if(_num>0){
        if (textView.text.length > _num){
            textView.text = [textView.text substringToIndex:_num];
        }
    }
    [self textChanged];
}
#pragma mark - LazyLoad
- (UIView *)shadowView {
    
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.backgroundColor  = ColorA(0, 0, 0, 0.4);//RGBA(0, 0, 0, 0.4);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissNinaView)];
        [self.shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}
- (void)tapToDismissNinaView {
    [_textView resignFirstResponder];
}
-(void)dismiss{
    
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}
//显示
-(void)show {
    
    [UIView animateWithDuration:.3 animations:^{
        // [self layoutIfNeeded];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
}
-(void)qxTap{
    [self dismiss];
}
-(void)okTap{
    self.doneBlock(_textView.text);
    [self dismiss];
}

@end

static NSString * const kTextKey = @"text";

@interface SFPlacehoderTextView ()

@property (nonatomic, strong) UITextView *placeholderView;

@end

@implementation SFPlacehoderTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpPlaceholderView];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpPlaceholderView];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:kTextKey];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _placeholderView.frame = self.bounds;
}


#pragma mark - observation

- (void)setUpPlaceholderView
{
    _placeholderView = [UITextView new];
    _placeholderView.editable = NO;
    _placeholderView.scrollEnabled = NO;
    _placeholderView.showsHorizontalScrollIndicator = NO;
    _placeholderView.showsVerticalScrollIndicator = NO;
    _placeholderView.userInteractionEnabled = NO;
    _placeholderView.font = self.font;
    _placeholderView.contentInset = self.contentInset;
    _placeholderView.contentOffset = self.contentOffset;
    _placeholderView.textContainerInset = self.textContainerInset;
    _placeholderView.textColor = Color(@"#C7C7CD");
    _placeholderView.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeholderView];
    
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(textDidChange:)
                          name:UITextViewTextDidChangeNotification object:self];
    
    [self addObserver:self forKeyPath:kTextKey options:NSKeyValueObservingOptionNew context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kTextKey]) {
        _placeholderView.hidden = [self hasText];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)textDidChange:(NSNotification *)notification
{
    _placeholderView.hidden = [self hasText];
}



#pragma mark - setter

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    _placeholderView.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    _placeholderView.textAlignment = textAlignment;
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:contentInset];
    _placeholderView.contentInset = contentInset;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    _placeholderView.contentOffset = contentOffset;
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    [super setTextContainerInset:textContainerInset];
    _placeholderView.textContainerInset = textContainerInset;
}

#pragma mark placeholder

- (void)setPlaceholders:(NSString *)placeholders
{
    _placeholderView.text = placeholders;
}

- (NSString *)placeholder
{
    return _placeholderView.text;
}


@end


