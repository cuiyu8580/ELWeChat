//
//  ELAppManange.h
//  ELWeChatDylib
//
//  Created by Eli on 2018/10/10.
//  Copyright © 2018年 eli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELRedEnvelopInfo.h"
#import "ELWeChatConfig.h"


@interface ELAppManage : NSObject


+ (instancetype)sharedManage;

@property (nonatomic,strong) ELWeChatConfig *appConfig;

@property (nonatomic,strong) ELRedEnvelopInfo *redInfo;



@end
