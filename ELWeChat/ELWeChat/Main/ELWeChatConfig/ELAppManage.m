//
//  ELAppManange.m
//  ELWeChatDylib
//
//  Created by Eli on 2018/10/10.
//  Copyright © 2018年 eli. All rights reserved.
//

#import "ELAppManage.h"

#import <objc/runtime.h>
@implementation ELAppManage

+(id)sharedManage
{
    static ELAppManage *manage = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [ELAppManage new];
    });
    return manage;
}

- (id)init
{
    if (self = [super init])
    {
        self.appConfig = [NSKeyedUnarchiver unarchiveObjectWithFile:kAppDataPath];
        if (!self.appConfig)
        {
            self.appConfig = [[ELWeChatConfig alloc] init];
        }
        
        
        
        self.redInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:kRedInfoPath];
    }
    
    return self;
    
}






@end
