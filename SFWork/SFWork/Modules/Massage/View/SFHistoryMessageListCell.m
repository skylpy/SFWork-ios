//
//  SFHistoryMessageListCell.m
//  SFWork
//
//  Created by fox on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFHistoryMessageListCell.h"

@interface SFHistoryMessageListCell()
@property (weak, nonatomic) IBOutlet UIImageView *headIMG;

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@end
@implementation SFHistoryMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(RCMessage *)message{
    RCTextMessage *testMessage = (RCTextMessage *)message.content;
    NSLog(@"消息内容：%@", testMessage.content);
    _timeLB.text = [self timeStampStringToTime:message.receivedTime];
    _contentLB.text = testMessage.content!=nil?testMessage.content:@"";
    _nameLB.text = message.content.senderUserInfo.name;
    if ([message.senderUserId isEqualToString:[SFInstance shareInstance].userInfo.rongCloudId]) {
        _nameLB.text = [SFInstance shareInstance].userInfo.name;
    }
}

- (NSString *)timeStampStringToTime:(long long)stampTime{
    // timeStampString 是服务器返回的13位时间戳
    NSString *timeStampString  = [NSString stringWithFormat:@"%lld",stampTime];
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    return dateString;
}


@end
