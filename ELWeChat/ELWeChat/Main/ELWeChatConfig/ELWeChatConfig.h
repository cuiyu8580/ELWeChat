//
//  ELWeChatConfig.h
//  ELWeChatDylib
//
//  Created by Eli on 2018/10/9.
//  Copyright © 2018年 eli. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ELWeChatHeaderinfo.h"

@interface ELWeChatConfig : NSObject

@property (nonatomic,assign) BOOL autoRedEnvelop;

@property (strong, nonatomic) NSArray *blackList;

@property (nonatomic,assign) BOOL groupManage;

@property (nonatomic,assign) BOOL Message;

@property (nonatomic,assign) BOOL StepManage;

@property (nonatomic,assign) NSInteger ResetStepNum;


@property (nonatomic) id Infor;

- (BOOL)saveAppInfo:(ELWeChatConfig *)Config;


@end
