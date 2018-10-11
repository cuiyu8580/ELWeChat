//
//  ELRedEnvelopInfo.h
//  ELWeChatDylib
//
//  Created by Eli on 2018/10/10.
//  Copyright © 2018年 eli. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ELRedEnvelopInfo : NSObject

@property(nonatomic,copy)NSString *msgtype;

@property(nonatomic,copy)NSString *channelid;

@property(nonatomic,copy)NSString *sendid;

@property(nonatomic,copy)NSString *nickName;

@property(nonatomic,copy)NSString *headImg;

@property(nonatomic,copy)NSString *nativeUrl;

@property(nonatomic,copy)NSString *sessionUserName;

@property(nonatomic,copy)NSString *timingIdentifier;

@property(nonatomic,copy)NSString *sendusername;

@property(nonatomic,copy)NSString *ver;

@property(nonatomic,copy)NSString *sign;

@property(nonatomic,assign)BOOL isMyself;


- (BOOL)saveRedInfo:(ELRedEnvelopInfo *)info;

- (NSDictionary *)requestDict;


@end
