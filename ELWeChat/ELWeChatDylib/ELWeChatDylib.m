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
#import "ELAppManage.h"

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

//拦截别人的撤回消息，自己的撤回消息--RevokeMsg


CHOptimizedMethod1(self, void, CMessageMgr, onRevokeMsg, CMessageWrap *, msgWrap)
{
    if([ELAppManage sharedManage].appConfig.Message)
    {
        NSString *m_content = [msgWrap m_nsContent];
        
        if([m_content rangeOfString:@"撤回了一条消息"].location != NSNotFound)
        {
            NSString *newmsgid = [[[[m_content componentsSeparatedByString:@"<newmsgid>"] lastObject] componentsSeparatedByString:@"</newmsgid>"]firstObject];
            
            NSString *session = [[[[m_content componentsSeparatedByString:@"<session>"] lastObject] componentsSeparatedByString:@"</session>"]firstObject];
            
            NSString *fromUsrName = [[[[m_content componentsSeparatedByString:@"<![CDATA["] lastObject] componentsSeparatedByString:@"撤回了一条消息]]>"]firstObject];
            
            CMessageMgr *CMessageManage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CMessageMgr")];
            
            CMessageWrap *revokemsg = [CMessageManage GetMsg:session n64SvrID:[newmsgid integerValue]];
            
            
            
            NSString *msgContent = @"";
            
            
            if (revokemsg.m_uiMessageType == 1) {
                msgContent = [NSString stringWithFormat:@"\"微信助手\"拦截到一条撤回消息：\n%@: %@",fromUsrName, revokemsg.m_nsContent];
            } else {
                msgContent = [NSString stringWithFormat:@"\"微信助手\"拦截到一条 %@的撤回消息",fromUsrName];
            }
            

            CMessageWrap *newWrap = [[NSClassFromString(@"CMessageWrap") alloc] initWithMsgType:10000];
            
            [newWrap setM_nsContent:msgContent];
            
            [newWrap setM_nsToUsr:msgWrap.m_nsToUsr];
            
            [newWrap setM_nsFromUsr:msgWrap.m_nsFromUsr];
            
            [newWrap setM_uiStatus:4];
            
            [newWrap setM_uiCreateTime:[msgWrap m_uiCreateTime]];
            
            //[newWrap setM_n64MesSvrID:[newmsgid integerValue]];
            
            
            [self AddLocalMsg:session MsgWrap:newWrap fixTime:0 NewMsgArriveNotify:0];
            
            
            return;
        }
    }
    

    
    CHSuper1(CMessageMgr, onRevokeMsg, msgWrap);
    
}

CHOptimizedMethod4(self, void, CMessageMgr, AddLocalMsg, NSString *, arg1, MsgWrap, CMessageWrap*, arg2, fixTime, BOOL, arg3, NewMsgArriveNotify, BOOL, arg4)
{
    
   // NSString *content = [arg2 m_nsContent];
    
   // [arg2 setM_nsContent:@"拦截消息"];
    
    
    CHSuper4(CMessageMgr, AddLocalMsg, arg1, MsgWrap, arg2, fixTime, arg3, NewMsgArriveNotify, arg4);
    
    
    
}



CHOptimizedMethod2(self, void, CMessageMgr, AsyncOnAddMsg, NSString*, msg, MsgWrap, CMessageWrap*, msgWrap){
    NSString* content = [msgWrap m_nsContent];
    if([msgWrap m_uiMessageType] == 1){
        NSLog(@"收到消息: %@", content);
    }
    //红包消息
    if([msgWrap m_uiMessageType] == 49 && [content rangeOfString:@"wxpay://"].location != NSNotFound)
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
        
        
        /** 是否在黑名单中 */
        BOOL (^isGroupInBlackList)(void) = ^BOOL() {
            
            return [[ELAppManage sharedManage].appConfig.blackList containsObject:msgWrap.m_nsFromUsr];
            
        };
        
        BOOL (^isAutoRedEnvelop)(void) = ^BOOL ()
        {
            if (![ELAppManage sharedManage].appConfig.autoRedEnvelop)
            {
                return NO;
            }
            
            if (isGroupInBlackList())
            {
                return NO;
            }
            
            return YES;
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
        
        
        if (isAutoRedEnvelop())
        {
            NSString *m_NativeUrl = [[msgWrap m_oWCPayInfoItem] m_c2cNativeUrl];
            
            NSDictionary *m_NativeUrlDict = NativeUrlDict(m_NativeUrl);
            
            RedEnvelopReqeust(m_NativeUrlDict);
            
            saveRedEnvelopData(m_NativeUrlDict);
        }
        
        
    }
    
    
    
    CHSuper2(CMessageMgr, AsyncOnAddMsg, msg, MsgWrap, msgWrap);
    
}

CHOptimizedMethod2(self, void, CMessageMgr, AddMsg, NSString*, msg, MsgWrap, CMessageWrap*, msgWrap){
    

    if ([msgWrap m_uiMessageType] == 1 && [ELAppManage sharedManage].appConfig.groupManage)
    {
        
        NSString *content = [msgWrap m_nsContent];
        
        NSString *toUser = [msgWrap m_nsToUsr];
        
        
        CContactMgr *contactManager = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CContactMgr")];
        CContact *selfContact = [contactManager getContactForSearchByName:toUser];
        
        BOOL (^isManage)(void) = ^BOOL()
        {
            NSString *fromUser = [msgWrap m_nsFromUsr];

            
            NSString *owner = [selfContact m_nsOwner];
            
            
            return [fromUser isEqualToString:owner];
            
            
        };
        
        
        BOOL (^isContainAll)(NSString *) = ^BOOL(NSString *m_content){

            return [m_content rangeOfString:@"#所有人"].location != NSNotFound;
        };
        
        BOOL (^isContainManage)(NSString *) = ^BOOL(NSString *m_content){
            
            return [m_content rangeOfString:@"#踢"].location != NSNotFound;
        };
        
        BOOL (^isInChatRoom)(NSString *) = ^BOOL(NSString *toUser)
        {
            return [toUser rangeOfString:@"@chatroom"].location != NSNotFound;
        };
        
        BOOL (^isAllUser)(void) = ^BOOL()
        {
            return isContainAll(content) && isInChatRoom(toUser);
        };
        
        BOOL (^isAddManage)(void) = ^BOOL()
        {
            return isContainManage(content) && isInChatRoom(toUser);
        };
        
        
        if (isAllUser())
        {
         
            NSString *realContent = [content substringFromIndex:4];
            
            if (isManage())
            {
                CGroupMgr *groupMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CGroupMgr")];
                [groupMgr SetChatRoomDesc:toUser Desc:realContent Flag:1];
                
                return;
            }
            else
            {
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
        else if (isAddManage())
        {
            NSArray *manageList = [[msgWrap m_nsAtUserList] componentsSeparatedByString:@","];
            
            
            CGroupMgr *groupMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CGroupMgr")];
            [groupMgr DeleteGroupMember:msgWrap.m_nsToUsr withMemberList:manageList scene:0];
            
            return;
            
        }

    }
    

    CHSuper2(CMessageMgr, AddMsg, msg, MsgWrap, msgWrap);
    
}


CHDeclareClass(ManualAuthAesReqData)

CHOptimizedMethod1(self, void, ManualAuthAesReqData, setbundleId, NSString *, bundleId)
{
    
    bundleId = @"com.tencent.xin";
    
    CHSuper1(ManualAuthAesReqData, setbundleId, bundleId);
}

CHDeclareClass(WWKBaseObject)


CHOptimizedMethod1(self, void, WWKBaseObject, setbundleID, NSString *, bundleID){
    
    bundleID = @"com.tencent.xin";
    
    CHSuper1(WWKBaseObject, setbundleID, bundleID);
    

}

CHDeclareClass(NSDictionary)

CHMethod1(id, NSDictionary, objectForKey, id, arg1)
{
    NSString *keys = (NSString *)arg1;
    
    if([keys isEqualToString:@"CFBundleIdentifier"])
    {
        return @"com.tencent.xin";
    }
    
    CHSuper1(NSDictionary, objectForKey, arg1);
}


CHDeclareClass(JailBreakHelper)

CHMethod0(BOOL, JailBreakHelper, HasInstallJailbreakPluginInvalidIAPPurchase)
{
    
   return NO;
}

CHOptimizedMethod1(self, BOOL, JailBreakHelper, HasInstallJailbreakPlugin, id, arg1)
{
    return NO;
    
}

CHMethod0(BOOL, JailBreakHelper, IsJailBreak)
{
   return NO;
    
}


CHDeclareClass(ClientCheckMgr)


CHMethod1(void, ClientCheckMgr, checkHookWithSeq, int, arg1)
{
    CHSuper1(ClientCheckMgr, checkHookWithSeq, arg1);
    
}


CHMethod1(void, ClientCheckMgr, checkHook, id, arg1)
{
     CHSuper1(ClientCheckMgr, checkHook, arg1);
}

CHMethod1(void, ClientCheckMgr, checkConsistency, id, arg1)
{
    CHSuper1(ClientCheckMgr, checkConsistency, arg1);
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
//- (void)makeCell:(id)arg1 cellInfo:(id)arg2;
CHDeclareClass(SetDeviceSafeViewController)


CHOptimizedMethod2(self, void, SetDeviceSafeViewController, makeCell, id, arg1, cellInfo, id, arg2)
{
    CHSuper2(SetDeviceSafeViewController, makeCell, arg1, cellInfo, arg2);
    
}

CHDeclareClass(WCDeviceStepObject)

CHOptimizedMethod1(self, void, WCDeviceStepObject, setM7StepCount, NSInteger, arg1)
{
    
    if([ELAppManage sharedManage].appConfig.StepManage)
    {
        
        NSInteger ResetNum = [ELAppManage sharedManage].appConfig.ResetStepNum ;
        
        arg1 = arg1 > ResetNum ? arg1 :ResetNum;
    }
    
    CHSuper1(WCDeviceStepObject, setM7StepCount, arg1);
}
//- (void)onUploadDeviceStepReponse:(id)arg1 stepCount:(unsigned int)arg2 HKStepCount:(unsigned int)arg3 M7StepCount:(unsigned int)arg4 sourceWhiteList:(id)arg5 ErrorCode:(int)arg6;

CHDeclareClass(WCDeviceBrandMgr)

CHOptimizedMethod6(self, void, WCDeviceBrandMgr, onUploadDeviceStepReponse, id, arg1, stepCount, int, arg2, HKStepCount, int, arg3, M7StepCount, int, arg4, sourceWhiteList, id, arg5, ErrorCode, int, arg6)
{
    
    CHSuper6(WCDeviceBrandMgr, onUploadDeviceStepReponse, arg1, stepCount, arg2, HKStepCount, arg3, M7StepCount, arg4, sourceWhiteList, arg5, ErrorCode, arg6);
    
}


#pragma mark - CHConstructor

CHConstructor{
    
    CHLoadLateClass(WCDeviceBrandMgr);
    
    CHHook6(WCDeviceBrandMgr, onUploadDeviceStepReponse, stepCount, HKStepCount, M7StepCount, sourceWhiteList, ErrorCode);
    

    CHLoadLateClass(WCDeviceStepObject);
    
    CHHook1(WCDeviceStepObject, setM7StepCount);
    
    CHLoadLateClass(SetDeviceSafeViewController);
    
    CHHook2(SetDeviceSafeViewController, makeCell, cellInfo);
    
    
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
    CHHook1(CMessageMgr, onRevokeMsg);
    
    CHClassHook2(CMessageMgr, AsyncOnAddMsg, MsgWrap);
    CHClassHook2(CMessageMgr, AddMsg, MsgWrap);
    
    CHClassHook4(CMessageMgr, AddLocalMsg, MsgWrap, fixTime, NewMsgArriveNotify);
 
    //---NewSettingViewController---//
    CHLoadLateClass(NewSettingViewController);
    
    CHClassHook0(NewSettingViewController, reloadTableData);
    
    CHClassHook0(NewSettingViewController, WeChatHelper);
    
    //---NewSettingViewController---//
    CHLoadLateClass(ManualAuthAesReqData);

    
    CHClassHook1(ManualAuthAesReqData, setbundleId);
    
    
    CHLoadLateClass(WWKBaseObject);
    
    CHClassHook1(WWKBaseObject, setbundleID);
    
    
    CHLoadLateClass(ClientCheckMgr);
    
    CHClassHook1(ClientCheckMgr, checkHookWithSeq);
    CHClassHook1(ClientCheckMgr, checkHook);
    CHClassHook1(ClientCheckMgr, checkConsistency);
    
    CHLoadLateClass(JailBreakHelper);
    CHClassHook0(JailBreakHelper, HasInstallJailbreakPluginInvalidIAPPurchase);
    CHClassHook1(JailBreakHelper, HasInstallJailbreakPlugin);
    CHClassHook0(JailBreakHelper, IsJailBreak);
    
    CHLoadLateClass(NSDictionary);
  
    CHClassHook1(NSDictionary, objectForKey);
    
}









