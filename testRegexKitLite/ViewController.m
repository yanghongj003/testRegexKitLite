//
//  ViewController.m
//  testRegexKitLite
//
//  Created by TomPro on 15/10/14.
//  Copyright © 2015年 TomPro. All rights reserved.
//

#import "ViewController.h"
#import "RegexKitLite.h"
#import "RegexEmotion.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp{
    // 服务器传过来的字符串
    NSString *regexStr = @"你是谁[哈哈]我是你爹[嗯嗯]我还是你爹[是你啊]";
    NSMutableArray *attributedArray = [self regexSepatorWithText:regexStr];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] init];
    [attributedArray enumerateObjectsUsingBlock:^(RegexEmotion *obj, NSUInteger idx, BOOL *stop) {
        if (obj.isEmotion) { //表情文本
            NSTextAttachment *attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
            attach.image = [UIImage imageNamed:obj.str];
            attach.bounds = CGRectMake(0, -3, self.myLabel.font.lineHeight, self.myLabel.font.lineHeight);
            NSAttributedString *emotionAttributr = [NSAttributedString attributedStringWithAttachment:attach];
            [attributeStr appendAttributedString:emotionAttributr];
        } else { //普通文本
            NSAttributedString *noemotionAttributr = [[NSAttributedString alloc]initWithString:obj.str];
            [attributeStr appendAttributedString:noemotionAttributr];
        }
    }];
    
    [attributeStr addAttribute:NSFontAttributeName value:self.myLabel.font range:NSMakeRange(0, attributeStr.length)];
    
    self.myLabel.attributedText = attributeStr;
}
// 用正则切割文本
- (NSMutableArray*)regexSepatorWithText:(NSString *)regexStr{
    
    NSMutableArray *attributedArray = [NSMutableArray array];
    
    // 1:用正则取出表情字符串
    [regexStr enumerateStringsMatchedByRegex: @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        RegexEmotion *emotion = [[RegexEmotion alloc] init];
        emotion.emotion = YES;
        emotion.str = *capturedStrings;
        emotion.range = *capturedRanges;
        [attributedArray addObject:emotion];
    }];

    // 2:用正则切割非表情字符串
    [regexStr enumerateStringsSeparatedByRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        RegexEmotion *emotion = [[RegexEmotion alloc] init];
        emotion.emotion = NO;
        emotion.str = *capturedStrings;
        emotion.range = *capturedRanges;
        [attributedArray addObject:emotion];
    }];
    
    // 3:数组按照location排序
    [attributedArray sortUsingComparator:^NSComparisonResult(RegexEmotion *obj1, RegexEmotion *obj2) {
        if (obj1.range.location<obj2.range.location) {
            return NSOrderedAscending;
        }else if (obj1.range.location>obj2.range.location){
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    return attributedArray;
}
@end
