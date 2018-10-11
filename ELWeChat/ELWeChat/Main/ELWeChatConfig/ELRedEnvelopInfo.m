//
//  ELRedEnvelopInfo.m
//  ELWeChatDylib
//
//  Created by Eli on 2018/10/10.
//  Copyright © 2018年 eli. All rights reserved.
//

#import "ELRedEnvelopInfo.h"

@implementation ELRedEnvelopInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [self yy_modelEncodeWithCoder:aCoder];
    
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    return [self yy_modelInitWithCoder:aDecoder];
    
}


-(id)copyWithZone:(NSZone *)zone
{
    
    return [self yy_modelCopy];
}


- (BOOL)saveRedInfo:(ELRedEnvelopInfo *)info
{
    
    return  [NSKeyedArchiver archiveRootObject:info toFile:kRedInfoPath];
    
}

- (NSDictionary *)requestDict
{
    return @{
             @"channelId": self.channelid,
             @"headImg": self.headImg,
             @"msgType": self.msgtype,
             @"nativeUrl": self.nativeUrl,
             @"nickName": self.nickName,
             @"sendId": self.sendid,
             @"sessionUserName": self.sessionUserName,
             @"timingIdentifier": self.timingIdentifier
             };

}


@end
