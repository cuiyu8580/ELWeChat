//
//  ELWeChatConfig.m
//  ELWeChatDylib
//
//  Created by Eli on 2018/10/9.
//  Copyright © 2018年 eli. All rights reserved.
//

#import "ELWeChatConfig.h"



@implementation ELWeChatConfig

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

- (BOOL)saveAppInfo:(ELWeChatConfig *)Config
{
    
    return  [NSKeyedArchiver archiveRootObject:Config toFile:kAppDataPath];
    
}

@end
