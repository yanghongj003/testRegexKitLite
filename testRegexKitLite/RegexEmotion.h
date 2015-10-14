//
//  RegexEmotion.h
//  testRegexKitLite
//
//  Created by TomPro on 15/10/14.
//  Copyright © 2015年 TomPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegexEmotion : NSObject

@property (nonatomic,assign,getter=isEmotion) BOOL emotion;
@property (nonatomic,copy) NSString *str;
@property (nonatomic,assign) NSRange range;

@end
