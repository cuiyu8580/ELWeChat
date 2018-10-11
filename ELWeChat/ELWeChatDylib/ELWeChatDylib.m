//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  ELWeChatDylib.m
//  ELWeChatDylib
//
//  Created by Eli on 2018/10/9.
//  Copyright (c) 2018年 eli. All rights reserved.
//

#import "ELWeChatDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>
#import "ELWeChatHeaderinfo.h"
#import "ELSettingViewController.h"

CHConstructor{
    NSLog(INSERT_SUCCESS_WELCOME);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
#ifndef __OPTIMIZE__
        CYListenServer(6666);

        MDCycriptManager* manager = [MDCycriptManager sharedInstance];
        [manager loadCycript:NO];

        NSError* error;
        NSString* result = [manager evaluateCycript:@"UIApp" error:&error];
        NSLog(@"result: %@", result);
        if(error.code != 0){
            NSLog(@"error: %@", error.localizedDescription);
        }
#endif
        
    }];
}


CHDeclareClass(CustomViewController)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

//add new method
CHDeclareMethod1(void, CustomViewController, newMethod, NSString*, output){
    NSLog(@"This is a new method : %@", output);
}

#pragma clang diagnostic pop

CHOptimizedClassMethod0(self, void, CustomViewController, classMethod){
    NSLog(@"hook class method");
    CHSuper0(CustomViewController, classMethod);
}

CHOptimizedMethod0(self, NSString*, CustomViewController, getMyName){
    //get origin value
    NSString* originName = CHSuper(0, CustomViewController, getMyName);
    
    NSLog(@"origin name is:%@",originName);
    
    //get property
    NSString* password = CHIvar(self,_password,__strong NSString*);
    
    NSLog(@"password is %@",password);
    
    [self newMethod:@"output"];
    
    //set new property
    self.newProperty = @"newProperty";
    
    NSLog(@"newProperty : %@", self.newProperty);
    
    //change the value
    return @"Eli";
    
}

//add new property
CHPropertyRetainNonatomic(CustomViewController, NSString*, newProperty, setNewProperty);

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook0(CustomViewController, getMyName);
    CHClassHook0(CustomViewController, classMethod);
    
    CHHook0(CustomViewController, newProperty);
    CHHook1(CustomViewController, setNewProperty);
}

CHDeclareClass(MicroMessengerAppDelegate)


CHOptimizedMethod1(self, void, MicroMessengerAppDelegate, applicationDidEnterBackground, id, arg1)
{
    ELWeChatConfig *appConfig = [ELAppManage sharedManage].appConfig;
    
    [appConfig saveAppInfo:appConfig];
    
    CHSuper1(MicroMessengerAppDelegate, applicationDidEnterBackground, arg1);
}

CHOptimizedMethod1(self, void, MicroMessengerAppDelegate, applicationWillTerminate, id, arg1)
{
    
    ELWeChatConfig *appConfig = [ELAppManage sharedManage].appConfig;
    
    [appConfig saveAppInfo:appConfig];
    
    
    
    CHSuper1(MicroMessengerAppDelegate, applicationWillTerminate, arg1);
    
    
}



CHOptimizedMethod2(self, BOOL, MicroMessengerAppDelegate, application, UIApplication*, application, didFinishLaunchingWithOptions, NSDictionary*, launchOptions) {
    
    return CHSuper2(MicroMessengerAppDelegate, application, application, didFinishLaunchingWithOptions, launchOptions);
}

CHDeclareClass(WCRedEnvelopesLogicMgr)

CHOptimizedMethod2(self, void, WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, HongBaoRes*, arg1, Request, HongBaoReq*, arg2) {
    CHSuper2(WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, arg1, Request, arg2);
    
    if (arg1.cgiCmdid != 3)
    {
        return;
    }
    
    NSString *(^redSignString)(void) = ^NSString *() {
        NSString *requestString = [[NSString alloc] initWithData:arg2.reqText.buffer encoding:NSUTF8StringEncoding];
        NSDictionary *requestDictionary = [objc_getClass("WCBizUtil") dictionaryWithDecodedComponets:requestString separator:@"&"];
        NSString *nativeUrl = [[requestDictionary stringForKey:@"nativeUrl"] stringByRemovingPercentEncoding];
        NSDictionary *nativeUrlDict = [objc_getClass("WCBizUtil") dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
        
        return [nativeUrlDict stringForKey:@"sign"];
    };
    
    NSDictionary *arg1Dict = [[[NSString alloc] initWithData:arg1.retText.buffer encoding:NSUTF8StringEncoding] JSONDictionary];
    
    ELRedEnvelopInfo *redInfo = [ELAppManage sharedManage].redInfo;
    
    
    BOOL (^isAutoRedEnvelop)() = ^BOOL() {

        if (!arg1Dict[@"timingIdentifier"])
        {
            return NO;
        }
        
        [ELAppManage sharedManage].redInfo.timingIdentifier = arg1Dict[@"timingIdentifier"];
        
        if ([arg1Dict[@"receiveStatus"] integerValue] != 0 || [arg1Dict[@"hbStatus"] integerValue] != 2)
        {
            return NO;
        }
        
        if(redInfo.isMyself)
        {
            return [ELAppManage sharedManage].appConfig.autoRedEnvelop;
        }
        else
        {
            return [redSignString() isEqualToString:redInfo.sign] && [ELAppManage sharedManage].appConfig.autoRedEnvelop;
        }

    };
    
    if(isAutoRedEnvelop())
    {
        WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
        [logicMgr OpenRedEnvelopesRequest:[redInfo requestDict]];
        
    }
    
}

#pragma mark - CMessageMgr

CHDeclareClass(CMessageMgr)

CHMethod2(void, CMessageMgr, AsyncOnAddMsg, NSString*, msg, MsgWrap, CMessageWrap*, msgWrap){
    NSString* content = [msgWrap m_nsContent];
    if([msgWrap m_uiMessageType] == 1){
        NSLog(@"收到消息: %@", content);
    }

    //红包消息
    if([msgWrap m_uiMessageType] == 49 && [content rangeOfString:@"wxpay://"].location != NSNotFound)
    {
        
        if([ELAppManage sharedManage].appConfig.autoRedEnvelop)
        {
            
            CContactMgr *contactManager = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CContactMgr")];
            CContact *selfContact = [contactManager getSelfContact];
            
            
            BOOL (^isMyself)(void) = ^BOOL()
            {
                return [msgWrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName];
            };
            BOOL (^isMyselfSender)(void) = ^BOOL() {
                return isMyself() && [msgWrap.m_nsToUsr rangeOfString:@"chatroom"].location != NSNotFound;
            };
            
            
            NSDictionary *(^NativeUrlDict)(NSString *) = ^(NSString *m_NativeUrl) {
                m_NativeUrl = [m_NativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
                return [objc_getClass("WCBizUtil") dictionaryWithDecodedComponets:m_NativeUrl separator:@"&"];
            };
            
            

            void (^RedEnvelopReqeust)(NSDictionary *) = ^(NSDictionary *NativeUrlDict) {
                NSMutableDictionary *m_dict = [NSMutableDictionary dictionary];
                
                [m_dict setValue:[NativeUrlDict stringForKey:@"channelid"] forKey:@"channelId"];
                [m_dict setValue:@"0" forKey:@"agreeDuty"];
                [m_dict setValue:[[msgWrap m_nsFromUsr] rangeOfString:@"@chatroom"].location != NSNotFound ? @"0" : @"1" forKey:@"inWay"];
                [m_dict setValue:[NativeUrlDict stringForKey:@"msgtype"] forKey:@"msgType"];
                [m_dict setValue:[[msgWrap m_oWCPayInfoItem] m_c2cNativeUrl] forKey:@"nativeUrl"];
                [m_dict setValue:[NativeUrlDict stringForKey:@"sendid"] forKey:@"sendId"];

                WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
                [logicMgr ReceiverQueryRedEnvelopesRequest:m_dict];
            };
            
            
            void(^saveRedEnvelopData)(NSDictionary *) = ^(NSDictionary *m_dict)
            {
                NSMutableDictionary *allDict = [NSMutableDictionary dictionaryWithDictionary:m_dict];
                
                [allDict setValue:[selfContact getContactDisplayName] forKey:@"nickName"];
                
                [allDict setValue:[[msgWrap m_oWCPayInfoItem] m_c2cNativeUrl] forKey:@"nativeUrl"];
                
                [allDict setValue:[selfContact m_nsHeadImgUrl] forKey:@"headImg"];
                
                [allDict setValue:isMyself forKey:@"isMyself"];
                
                NSString *m_sessionUserName = isMyselfSender() ? msgWrap.m_nsToUsr : msgWrap.m_nsFromUsr;
                
                [allDict setValue:m_sessionUserName forKey:@"sessionUserName"];
                
                ELRedEnvelopInfo *redInfo = [ELRedEnvelopInfo yy_modelWithJSON:allDict];
                
                [ELAppManage sharedManage].redInfo = redInfo;
                
                [redInfo saveRedInfo:redInfo];
                
                
            };
            
            NSString *m_NativeUrl = [[msgWrap m_oWCPayInfoItem] m_c2cNativeUrl];
            
            NSDictionary *m_NativeUrlDict = NativeUrlDict(m_NativeUrl);
            
            RedEnvelopReqeust(m_NativeUrlDict);
            
            saveRedEnvelopData(m_NativeUrlDict);
        }
        
    }
    
    
    
    CHSuper2(CMessageMgr, AsyncOnAddMsg, msg, MsgWrap, msgWrap);
    
}

CHMethod2(void, CMessageMgr, AddMsg, NSString*, msg, MsgWrap, CMessageWrap*, msgWrap){
    

    if ([msgWrap m_uiMessageType] == 1 && [ELAppManage sharedManage].appConfig.groupManage)
    {
        
        NSString *content = [msgWrap m_nsContent];
        
        NSString *toUser = [msgWrap m_nsToUsr];
        
        BOOL (^isContainString)(NSString *) = ^BOOL(NSString *m_content){

            return [m_content rangeOfString:@"#所有人"].location != NSNotFound;
        };
        
        BOOL (^isInChatRoom)(NSString *) = ^BOOL(NSString *toUser)
        {
            return [toUser rangeOfString:@"@chatroom"].location != NSNotFound;
        };
        
        BOOL (^isAllUser)(void) = ^BOOL()
        {
            return isContainString(content) && isInChatRoom(toUser);
        };
        
        if (isAllUser())
        {
         
            NSString *realContent = [content substringFromIndex:4];
            
             NSArray *result = (NSArray *)[objc_getClass("CContact") getChatRoomMemberWithoutMyself:toUser];
            
            
            NSMutableString *usrString = [NSMutableString string];
            
            NSMutableString *nickString = [NSMutableString string];
            
            [result enumerateObjectsUsingBlock:^(CContact *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [usrString appendFormat:@",%@",obj.m_nsUsrName];
                [nickString appendFormat:@"@%@ ",obj.m_nsNickName];
            }];
            
            
            NSString *contentString = nickString;
            
            
            NSString *sourceString = [usrString substringFromIndex:1];
            
            msgWrap.m_nsContent = [NSString stringWithFormat:@"%@ %@",contentString,realContent];
    
            msgWrap.m_nsMsgSource = [NSString stringWithFormat:@"<msgsource><atuserlist>%@</atuserlist></msgsource>",sourceString];
            
            msgWrap.m_nsAtUserList = sourceString;

            
        }
        
        
        
    }

    
    
    CHSuper2(CMessageMgr, AddMsg, msg, MsgWrap, msgWrap);
    
}

#pragma mark - NewSettingViewController

CHDeclareClass(NewSettingViewController)

CHMethod0(void, NewSettingViewController, reloadTableData) {
    
    CHSuper0(NewSettingViewController, reloadTableData);
    MMTableViewInfo *tableViewInfo = [self valueForKeyPath:@"m_tableViewInfo"];
    
    
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    MMTableViewCellInfo *settingCell = [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(WeChatHelper) target:self title:@"微信助手" accessoryType:1];
    [sectionInfo addCell:settingCell];
    
    
    [tableViewInfo insertSection:sectionInfo At:0];
    

    MMTableView *tableView = [tableViewInfo getTableView];
    [tableView reloadData];
}

// add new
CHDeclareMethod0(void, NewSettingViewController, WeChatHelper) {
    ELSettingViewController *settingViewController = [ELSettingViewController new];
    [self.navigationController PushViewController:settingViewController animated:YES];
}


#pragma mark - CHConstructor

CHConstructor{
    //---MicroMessengerAppDelegate---//
    CHLoadLateClass(MicroMessengerAppDelegate);
    CHHook2(MicroMessengerAppDelegate, application, didFinishLaunchingWithOptions);
    CHHook1(MicroMessengerAppDelegate, applicationWillTerminate);
     CHHook1(MicroMessengerAppDelegate, applicationDidEnterBackground);
    
    //---WCRedEnvelopesLogicMgr---//
    CHLoadLateClass(WCRedEnvelopesLogicMgr);
    CHHook2(WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, Request);
    
    //---CMessageMgr---//
    CHLoadLateClass(CMessageMgr);
    CHClassHook2(CMessageMgr, AsyncOnAddMsg, MsgWrap);
    CHClassHook2(CMessageMgr, AddMsg, MsgWrap);
 
    //---NewSettingViewController---//
    CHLoadLateClass(NewSettingViewController);
    
    CHClassHook0(NewSettingViewController, reloadTableData);
    
    CHClassHook0(NewSettingViewController, WeChatHelper);
    
}









