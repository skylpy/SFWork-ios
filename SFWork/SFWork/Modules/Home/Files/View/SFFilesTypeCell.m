//
//  SFFilesTypeCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFFilesTypeCell.h"

@interface SFFilesTypeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;
@property (weak, nonatomic) IBOutlet UIButton *informationButton;

@end

@implementation SFFilesTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    @weakify(self)
    [[self.optionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        self.model.isSelect = x.selected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectFile:)]) {
            [self.delegate selectFile:self.model];
        }
    }];
    [[self.informationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(goDateilFile:)]) {
            [self.delegate goDateilFile:self.model];
        }
    }];
}

- (void)setModel:(SFFilesModel *)model{
    _model = model;
    
    self.optionButton.selected = model.isSelect;
    self.nameLabel.text = model.name;
    self.desLabel.text = [NSString stringWithFormat:@"%@ %@",model.createTime,model.size];
    
    if ([model.fileType isEqualToString:@"IMAGES"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_picture_orange"];
    }
    if ([model.fileType isEqualToString:@"VIDEO"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_video_black"];
    }
    if ([model.fileType isEqualToString:@"ZIP"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_zip_multicolor"];
    }
    if ([model.fileType isEqualToString:@"TXT"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_txt_purple"];
    }
    if ([model.fileType isEqualToString:@"EXCEL"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_excel_green"];
    }
    if ([model.fileType isEqualToString:@"PPT"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_ppt_red"];
    }
    if ([model.fileType isEqualToString:@"WORD"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_word_blue"];
    }
    if ([model.fileType isEqualToString:@"PDF"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_pdf_pink"];
    }
    if ([model.fileType isEqualToString:@"OTHER"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_unknown_gray"];
    }
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 238 / 255.0, 238 / 255.0, 238 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 20, 1);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, kWidth ,0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
