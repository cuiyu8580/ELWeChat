//
//  ELWeChatHeaderinfo.h
//  ELWeChat
//
//  Created by Eli on 2018/10/9.
//  Copyright © 2018年 eli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCBizUtil : NSObject

+ (id)dictionaryWithDecodedComponets:(id)arg1 separator:(id)arg2;

@end

@interface SKBuiltinBuffer_t : NSObject

@property(retain, nonatomic) NSData *buffer; // @dynamic buffer;

@end

#pragma mark - Message

@interface WCPayInfoItem: NSObject

@property(retain, nonatomic) NSString *m_c2cNativeUrl;

@end


@interface WAAppMsgItem
@property(nonatomic)  int version; // @synthesize version=_version;
@property(nonatomic)  int type;

@property(strong, nonatomic) NSString *username;

@property(strong, nonatomic) NSString *appid;

@property(strong, nonatomic) NSString *pagepath;

@property(strong, nonatomic) NSString *shareId;

@property(strong, nonatomic) NSString *weappIconUrl;

@end


@interface CExtendInfoOfAPP : NSObject

@property(strong, nonatomic) NSString *m_nsTitle;

@property (assign, nonatomic) NSUInteger m_uiAppMsgInnerType;

@property(strong, nonatomic) NSString *m_nsDesc;

@property(strong, nonatomic) NSString *m_nsAppMediaUrl;

@property(strong, nonatomic) NSString *m_nsSourceUsername;

@property(strong, nonatomic) NSString *m_nsSourceDisplayname;

@property(strong, nonatomic) WAAppMsgItem *m_oWAAppItem;

@end

@interface CMessageMgr : NSObject

- (void)AddLocalMsg:(id)arg1 MsgWrap:(id)arg2 fixTime:(_Bool)arg3 NewMsgArriveNotify:(_Bool)arg4;
- (void)AddMsg:(id)arg1 MsgWrap:(id)arg2;
- (void)AddAppMsg:(id)arg1 MsgWrap:(id)arg2 Data:(id)arg3 Scene:(unsigned int)arg4;
- (void)AsyncOnAddMsg:(id)arg1 MsgWrap:(id)arg2;
- (id)GetMsg:(id)arg1 n64SvrID:(long long)arg2;

@end

@interface CMessageWrap : NSObject

@property (retain, nonatomic) WCPayInfoItem *m_oWCPayInfoItem;
@property (assign, nonatomic) NSUInteger m_uiMesLocalID;
@property (strong, nonatomic) NSString* m_nsFromUsr;            ///< 发信人，可能是群或個人
@property (retain, nonatomic) NSString* m_nsToUsr;              ///< 收信人
@property (assign, nonatomic) NSUInteger m_uiStatus;
@property (retain, nonatomic) NSString* m_nsContent;            ///< 消息内容
@property (retain, nonatomic) NSString* m_nsRealChatUsr;        ///< 群消息的发信人，具体是群里的哪個人
@property (assign, nonatomic) NSUInteger m_uiMessageType;
@property (assign, nonatomic) long long m_n64MesSvrID;
@property (assign, nonatomic) NSUInteger m_uiCreateTime;
@property (retain, nonatomic) NSString *m_nsDesc;
@property (retain, nonatomic) NSString *m_nsAppExtInfo;
@property (assign, nonatomic) NSUInteger m_uiAppDataSize;
@property (assign, nonatomic) NSUInteger m_uiAppMsgInnerType;
@property (retain, nonatomic) NSString *m_nsShareOpenUrl;
@property (retain, nonatomic) NSString *m_nsShareOriginUrl;
@property (retain, nonatomic) NSString *m_nsJsAppId;
@property (retain, nonatomic) NSString *m_nsPrePublishId;
@property (retain, nonatomic) NSString *m_nsAppID;
@property (retain, nonatomic) NSString *m_nsAppName;
@property (retain, nonatomic) NSString *m_nsThumbUrl;
@property (retain, nonatomic) NSString *m_nsAppMediaUrl;
@property (retain, nonatomic) NSData *m_dtThumbnail;
@property (retain, nonatomic) NSString *m_nsTitle;
@property (retain, nonatomic) NSString *m_nsMsgSource;
@property (retain, nonatomic) NSString *m_nsAtUserList;
@property(strong, nonatomic)  CExtendInfoOfAPP* m_extendInfoWithMsgType;
- (id)initWithMsgType:(long long)arg1;
+ (_Bool)isSenderFromMsgWrap:(id)arg1;

@end

@interface MMServiceCenter : NSObject

+ (instancetype)defaultCenter;
- (id)getService:(Class)service;

@end

@interface MMLanguageMgr: NSObject

- (id)getStringForCurLanguage:(id)arg1 defaultTo:(id)arg2;


@end

#pragma mark - RedEnvelop

@interface WCRedEnvelopesControlData : NSObject

@property(retain, nonatomic) CMessageWrap *m_oSelectedMessageWrap;

@end

@interface WCRedEnvelopesLogicMgr: NSObject

- (void)OpenRedEnvelopesRequest:(id)params;
- (void)ReceiverQueryRedEnvelopesRequest:(id)arg1;
- (void)GetHongbaoBusinessRequest:(id)arg1 CMDID:(unsigned int)arg2 OutputType:(unsigned int)arg3;

/** Added Methods */
- (unsigned int)calculateDelaySeconds;

@end

@interface HongBaoRes : NSObject

@property(retain, nonatomic) SKBuiltinBuffer_t *retText; // @dynamic retText;
@property(nonatomic) int cgiCmdid; // @dynamic cgiCmdid;

@end

@interface HongBaoReq : NSObject

@property(retain, nonatomic) SKBuiltinBuffer_t *reqText; // @dynamic reqText;

@end

@interface CBaseContact : NSObject <NSCopying>

@property(retain, nonatomic) NSString *m_nsUsrName;


@end



#pragma mark - Contact

@interface CContact: CBaseContact <NSCoding>

@property(retain, nonatomic) NSString *m_nsUsrName;
@property(retain, nonatomic) NSString *m_nsHeadImgUrl;
@property(retain, nonatomic) NSString *m_nsNickName;

@property(retain, nonatomic) NSString *m_nsOwner;

- (id)getContactDisplayName;
+ (id)getChatRoomMemberWithoutMyself:(id)arg1;
- (id)getChatRoomMemberDisplayName:(id)arg1;
@end

@interface WAAppDetailInfoManager




@end

@interface EnterpriseContactMgr :NSObject


@end

@interface WASessionMgr :NSObject

- (id)sessionInfoWithUsrName:(id)arg1;

@end

@interface WCGroupMgr :NSObject


@end

@interface CGroupMgr

- (_Bool)SetChatRoomDesc:(id)arg1 Desc:(id)arg2 Flag:(unsigned int)arg3;

- (_Bool)DeleteGroupMember:(id)arg1 withMemberList:(id)arg2 scene:(unsigned long long)arg3;

@end

@interface CContactMgr : NSObject

@property(nonatomic,strong) NSMutableDictionary *m_dicContacts;
- (id)getContactList:(unsigned int)arg1 contactType:(unsigned int)arg2;
- (id)getContactFromDic:(id)arg1;
- (id)getSelfContact;
- (id)getAllContactUserName;
- (id)getContactByName:(id)arg1;
- (id)getContactForSearchByName:(id)arg1;
- (_Bool)getContactsFromServer:(id)arg1;
- (_Bool)isInContactList:(id)arg1;
- (_Bool)addLocalContact:(id)arg1 listType:(unsigned int)arg2;
- (id)getContactByAlias:(id)arg1;

- (id)getAppID;
@end


#pragma mark - QRCode

@interface ScanQRCodeLogicController: NSObject

@property(nonatomic) unsigned int fromScene;
- (id)initWithViewController:(id)arg1 CodeType:(int)arg2;
- (void)tryScanOnePicture:(id)arg1;
- (void)doScanQRCode:(id)arg1;
- (void)showScanResult;

@end

@interface NewQRCodeScanner: NSObject

- (id)initWithDelegate:(id)arg1 CodeType:(int)arg2;
- (void)notifyResult:(id)arg1 type:(id)arg2 version:(int)arg3;

@end

#pragma mark - MMTableView

@interface MMTableViewInfo

- (id)getTableView;
- (void)clearAllSection;
- (void)addSection:(id)arg1;
- (void)insertSection:(id)arg1 At:(unsigned int)arg2;

@end

@interface MMTableViewSectionInfo

+ (id)sectionInfoDefaut;
+ (id)sectionInfoHeader:(id)arg1;
+ (id)sectionInfoHeader:(id)arg1 Footer:(id)arg2;
- (void)addCell:(id)arg1;

@end

@interface MMTableViewCellInfo

+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 accessoryType:(long long)arg4;
+ (id)switchCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 on:(_Bool)arg4;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 rightValue:(id)arg4 accessoryType:(long long)arg5;
+ (id)normalCellForTitle:(id)arg1 rightValue:(id)arg2;
+ (id)urlCellForTitle:(id)arg1 url:(id)arg2;

@end

@interface MMTableView: UITableView

@end

#pragma mark - UI
@interface MMUICommonUtil : NSObject

+ (id)getBarButtonWithTitle:(id)arg1 target:(id)arg2 action:(SEL)arg3 style:(int)arg4;

@end

@interface MMLoadingView : UIView

@property(retain, nonatomic) UILabel *m_label; // @synthesize m_label;
@property (assign, nonatomic) BOOL m_bIgnoringInteractionEventsWhenLoading; // @synthesize m_bIgnoringInteractionEventsWhenLoading;

- (void)setFitFrame:(long long)arg1;
- (void)startLoading;
- (void)stopLoading;
- (void)stopLoadingAndShowError:(id)arg1;
- (void)stopLoadingAndShowOK:(id)arg1;


@end

@interface MMWebViewController: NSObject

- (id)initWithURL:(id)arg1 presentModal:(_Bool)arg2 extraInfo:(id)arg3;

@end


@protocol ContactSelectViewDelegate <NSObject>

- (void)onSelectContact:(CContact *)arg1;

@end

@interface ContactSelectView : UIView

@property(nonatomic) unsigned int m_uiGroupScene; // @synthesize m_uiGroupScene;
@property(nonatomic) _Bool m_bMultiSelect; // @synthesize m_bMultiSelect;
@property(retain, nonatomic) NSMutableDictionary *m_dicMultiSelect; // @synthesize m_dicMultiSelect;

- (id)initWithFrame:(struct CGRect)arg1 delegate:(id)arg2;
- (void)initData:(unsigned int)arg1;//3,4已保存群聊;5所有群聊;2所有联系人;1联系人+公众号
- (void)initView;
- (void)addSelect:(id)arg1;

@end

@interface ContactsDataLogic : NSObject

@property(nonatomic) unsigned int m_uiScene; // @synthesize m_uiScene;

@end

@interface MMUINavigationController : UINavigationController

@end

#pragma mark - UtilCategory

@interface NSMutableDictionary (SafeInsert)

- (void)safeSetObject:(id)arg1 forKey:(id)arg2;

@end

@interface NSDictionary (NSDictionary_SafeJSON)

- (id)arrayForKey:(id)arg1;
- (id)dictionaryForKey:(id)arg1;
- (double)doubleForKey:(id)arg1;
- (float)floatForKey:(id)arg1;
- (long long)int64ForKey:(id)arg1;
- (long long)integerForKey:(id)arg1;
- (id)stringForKey:(id)arg1;

@end

@interface NSString (NSString_SBJSON)

- (id)JSONArray;
- (id)JSONDictionary;
- (id)JSONValue;

@end

#pragma mark - UICategory

@interface UINavigationController (LogicController)

- (void)PushViewController:(id)arg1 animated:(_Bool)arg2;

@end

@interface MMUIViewController : UIViewController

- (void)startLoadingBlocked;
- (void)startLoadingNonBlock;
- (void)startLoadingWithText:(NSString *)text;
- (void)stopLoading;
- (void)stopLoadingWithFailText:(NSString *)text;
- (void)stopLoadingWithOKText:(NSString *)text;

@end


@interface ChatRoomInfoViewController: MMUIViewController

- (void)reloadTableData;

@end

@interface ManualAuthAesReqData


@property(retain, nonatomic) NSString *bundleId;

@end

@interface JailBreakHelper : NSObject

- (_Bool)HasInstallJailbreakPluginInvalidIAPPurchase;
- (_Bool)isOverADay;
- (_Bool)HasInstallJailbreakPlugin:(id)arg1;
- (_Bool)IsJailBreak;
@end
@interface WWKBaseObject : NSObject

@property(copy, nonatomic) NSString *bundleID;

@end

@interface ClientCheckMgr

- (void)checkHookWithSeq:(unsigned int)arg1;
- (void)checkHook:(id)arg1;
- (void)reportFileConsistency:(id)arg1 fileName:(id)arg2 offset:(unsigned int)arg3 bufferSize:(unsigned int)arg4 seq:(unsigned int)arg5;
- (void)checkConsistency:(id)arg1;
- (void)registerAddImageCallBack;
@end
@interface NewSettingViewController: MMUIViewController

- (void)reloadTableData;

@end



@protocol MultiSelectContactsViewControllerDelegate <NSObject>
- (void)onMultiSelectContactReturn:(NSArray *)arg1;

@optional
- (int)getFTSCommonScene;
- (void)onMultiSelectContactCancelForSns;
- (void)onMultiSelectContactReturnForSns:(NSArray *)arg1;
@end

@interface MultiSelectContactsViewController : UIViewController

@property(nonatomic) _Bool m_bKeepCurViewAfterSelect; // @synthesize m_bKeepCurViewAfterSelect=_m_bKeepCurViewAfterSelect;
@property(nonatomic) unsigned int m_uiGroupScene; // @synthesize m_uiGroupScene;

@property(nonatomic, weak) id <MultiSelectContactsViewControllerDelegate> m_delegate; // @synthesize m_delegate;

@end

@interface XMLReader : NSObject<NSXMLParserDelegate>


@property(nonatomic,strong)NSMutableArray *_dictionaryStack;

@property(nonatomic,strong)NSMutableString *_textInProgress;


+ (id)dictionaryForXMLData:(id)arg1 error:(NSError *)arg2;

+ (id)dictionaryForXMLString:(id)arg1 error:(id *)arg2;

+ (id)dictionaryForXMLString:(id)arg1 options:(unsigned long long)arg2 error:(id *)arg3;

@end

@interface SetDeviceSafeViewController : MMUIViewController

- (void)MessageReturn:(id)arg1 Event:(unsigned int)arg2;
- (void)MessageReturnDelDevice:(id)arg1 Event:(unsigned int)arg2;
- (void)OnClickRightTopBtn;
- (void)commitEditingForRowAtIndexPath:(id)arg1 Cell:(id)arg2;
- (void)actionCell:(id)arg1;
- (void)makeCell:(id)arg1 cellInfo:(id)arg2;

@end



@interface WAStarLinearListViewController : MMUIViewController



@end

@interface WCAccountLoginLastUserViewController

- (void)onNext;

@end

@interface WCDeviceStepObject
@property(retain, nonatomic) NSMutableArray *allHKSampleSource; // @synthesize allHKSampleSource;
@property(nonatomic) unsigned int hkStepCount; // @synthesize hkStepCount;
@property(nonatomic) unsigned int m7StepCount; // @synthesize m7StepCount;
@property(nonatomic) unsigned int endTime; // @synthesize endTime;
@property(nonatomic) unsigned int beginTime;

@end

@interface WCDeviceM7Logic

- (int)getCurrM7StepCount;

@end

@interface WCDeviceBrandMgr : NSObject
{
    WCDeviceM7Logic *_m7Logic;
}

- (void)onUploadDeviceStepReponse:(id)arg1 stepCount:(unsigned int)arg2 HKStepCount:(unsigned int)arg3 M7StepCount:(unsigned int)arg4 sourceWhiteList:(id)arg5 ErrorCode:(int)arg6;

- (void)onGotDeviceStepObject:(id)arg1;

- (unsigned int)getLastM7Step;

@end

@interface WCTimelineDataProvider

- (void)requestForSnsTimeLineRequest:(id)arg1 minID:(id)arg2 lastRequestTime:(unsigned int)arg3;

- (void)MessageReturn:(id)arg1 Event:(unsigned int)arg2;

- (_Bool)responseForSnsTimeLineResponse:(id)arg1 Event:(unsigned int)arg2;

@end



@interface WXPBGeneratedMessage : NSObject
{
    int _has_bits_[3];
    int _serializedSize;
    struct PBClassInfo *_classInfo;
    id _ivarValueDict;
}

+ (id)parseFromData:(id)arg1;
- (_Bool)hasProperty:(int)arg1;
- (unsigned int)continueFlag;
- (id)baseResponse;
- (void)setBaseRequest:(id)arg1;
//- (void)writeValueToCodedOutputDataNoTag:(struct CodedOutputData *)arg1 value:(id)arg2 fieldType:(unsigned char)arg3;
//- (void)writeValueToCodedOutputData:(struct CodedOutputData *)arg1 value:(id)arg2 fieldNumber:(int)arg3 fieldType:(unsigned char)arg4;
//- (void)writeToCodedOutputData:(struct CodedOutputData *)arg1;
- (int)computeValueSizeNoTag:(id)arg1 fieldType:(unsigned char)arg2;
- (int)computeValueSize:(id)arg1 fieldNumber:(int)arg2 fieldType:(unsigned char)arg3;
- (int)serializedSize;
- (id)serializedData;
- (_Bool)isInitialized;
- (_Bool)isMessageInitialized:(id)arg1;
//- (id)readValueFromCodedInputData:(struct CodedInputData *)arg1 fieldType:(unsigned char)arg2;
//- (id)mergeFromCodedInputData:(struct CodedInputData *)arg1;
- (id)mergeFromData:(id)arg1;
- (id)valueAtIndex:(int)arg1;
- (void)setValue:(id)arg1 atIndex:(int)arg2;
- (int)indexOfPropertyWithSetter:(const char *)arg1;
- (int)indexOfPropertyWithGetter:(const char *)arg1;
- (void)dealloc;
- (id)init;

@end


@interface SKBuiltinString_t : WXPBGeneratedMessage
{
}

+ (void)initialize;
+ (id)skStringWithString:(id)arg1;

// Remaining properties
@property(retain, nonatomic) NSString *string; // @dynamic string;

@end

@interface BaseResponse : WXPBGeneratedMessage
{
}

+ (void)initialize;

// Remaining properties
@property(retain, nonatomic) SKBuiltinString_t *errMsg; // @dynamic errMsg;
@property(nonatomic) int ret; // @dynamic ret;

@end


@interface UrlInfo : NSObject <NSCopying>
{
    NSString *m_nsRequestUrl;
    NSData *m_dtResponseData;
    NSString *m_nsRefer;
    _Bool m_bGetMethod;
    NSData *m_dtBodyData;
    NSDictionary *m_dicReq;
    NSDictionary *m_dicResp;
    _Bool m_bCdn;
    NSString *m_nsRequestUrlSuffix;
    unsigned int m_uiRecvTime;
    unsigned int m_uiRetCode;
    unsigned int m_uiDataSize;
    unsigned int m_uiDnsCostTime;
    unsigned int m_uiConnectCostTime;
    unsigned int m_uiSendCostTime;
    unsigned int m_uiWaitResponseCostTime;
    unsigned int m_uiReceiveCostTime;
    NSString *m_nsClientIP;
    NSString *m_nsServerIP;
    unsigned int m_uiDnsType;
    NSString *m_host;
    NSString *m_nsXErrno;
    NSMutableArray *m_aryReceiveData;
    NSString *m_fileMd5;
    _Bool m_bSupportValidateMd5;
    _Bool m_bContinueReceive;
    NSString *m_filePath;
    _Bool m_useDCIP;
    _Bool m_fromSns;
    _Bool m_useXorEncrypt;
    unsigned long long m_xorEncryKey;
    unsigned int m_uiXEncIdx;
    NSString *m_nsXEnc;
    NSString *m_nsXEncToken;
    unsigned int m_uiReqestCSeq;
    unsigned int m_uiResponseCSeq;
}

@property(nonatomic) unsigned int m_uiResponseCSeq; // @synthesize m_uiResponseCSeq;
@property(nonatomic) unsigned int m_uiReqestCSeq; // @synthesize m_uiReqestCSeq;
@property(nonatomic) unsigned int m_uiXEncIdx; // @synthesize m_uiXEncIdx;
@property(retain, nonatomic) NSString *m_nsXEncToken; // @synthesize m_nsXEncToken;
@property(retain, nonatomic) NSString *m_nsXEnc; // @synthesize m_nsXEnc;
@property(nonatomic) unsigned long long m_xorEncryKey; // @synthesize m_xorEncryKey;
@property(retain, nonatomic) NSMutableArray *m_aryReceiveData; // @synthesize m_aryReceiveData;
@property(nonatomic) _Bool m_useXorEncrypt; // @synthesize m_useXorEncrypt;
@property(nonatomic) _Bool m_fromSns; // @synthesize m_fromSns;
@property(nonatomic) _Bool m_useDCIP; // @synthesize m_useDCIP;
@property(nonatomic) _Bool m_bSupportValidateMd5; // @synthesize m_bSupportValidateMd5;
@property(retain, nonatomic) NSString *m_fileMd5; // @synthesize m_fileMd5;
@property(retain, nonatomic) NSString *m_filePath; // @synthesize m_filePath;
@property(nonatomic) _Bool m_bContinueReceive; // @synthesize m_bContinueReceive;
@property(retain, nonatomic) NSString *m_nsXErrno; // @synthesize m_nsXErrno;
@property(retain, nonatomic) NSString *m_nsRequestUrlSuffix; // @synthesize m_nsRequestUrlSuffix;
@property(retain, nonatomic) NSString *m_host; // @synthesize m_host;
@property(nonatomic) unsigned int m_uiDnsType; // @synthesize m_uiDnsType;
@property(retain, nonatomic) NSString *m_nsServerIP; // @synthesize m_nsServerIP;
@property(retain, nonatomic) NSString *m_nsClientIP; // @synthesize m_nsClientIP;
@property(nonatomic) unsigned int m_uiReceiveCostTime; // @synthesize m_uiReceiveCostTime;
@property(nonatomic) unsigned int m_uiWaitResponseCostTime; // @synthesize m_uiWaitResponseCostTime;
@property(nonatomic) unsigned int m_uiSendCostTime; // @synthesize m_uiSendCostTime;
@property(nonatomic) unsigned int m_uiConnectCostTime; // @synthesize m_uiConnectCostTime;
@property(nonatomic) unsigned int m_uiDnsCostTime; // @synthesize m_uiDnsCostTime;
@property(nonatomic) unsigned int m_uiDataSize; // @synthesize m_uiDataSize;
@property(nonatomic) unsigned int m_uiRetCode; // @synthesize m_uiRetCode;
@property(nonatomic) unsigned int m_uiRecvTime; // @synthesize m_uiRecvTime;
@property(nonatomic) _Bool m_bCdn; // @synthesize m_bCdn;
@property(retain, nonatomic) NSDictionary *m_dicResp; // @synthesize m_dicResp;
@property(retain, nonatomic) NSDictionary *m_dicReq; // @synthesize m_dicReq;
@property(retain, nonatomic) NSData *m_dtBodyData; // @synthesize m_dtBodyData;
@property(nonatomic) _Bool m_bGetMethod; // @synthesize m_bGetMethod;
@property(retain, nonatomic) NSString *m_nsRefer; // @synthesize m_nsRefer;
@property(retain, nonatomic) NSData *m_dtResponseData; // @synthesize m_dtResponseData;
@property(retain, nonatomic) NSString *m_nsRequestUrl; // @synthesize m_nsRequestUrl;
- (id)GenStatStringWithDataType:(int)arg1;
- (id)GenStatString;
- (id)init;

@end

@interface SnsServerConfig : WXPBGeneratedMessage
{
}

+ (void)initialize;

// Remaining properties
@property(nonatomic) int copyAndPasteWordLimit; // @dynamic copyAndPasteWordLimit;
@property(nonatomic) int postMentionLimit; // @dynamic postMentionLimit;

@end
@interface SnsTimeLineResponse : WXPBGeneratedMessage
{
}

+ (void)initialize;

// Remaining properties
@property(nonatomic) unsigned int advertiseCount; // @dynamic advertiseCount;
@property(retain, nonatomic) NSMutableArray *advertiseList; // @dynamic advertiseList;
@property(retain, nonatomic) BaseResponse *baseResponse; // @dynamic baseResponse;
@property(nonatomic) unsigned int controlFlag; // @dynamic controlFlag;
@property(retain, nonatomic) NSString *firstPageMd5; // @dynamic firstPageMd5;
@property(nonatomic) unsigned int newRequestTime; // @dynamic newRequestTime;
@property(nonatomic) unsigned int objectCount; // @dynamic objectCount;
@property(nonatomic) unsigned int objectCountForSameMd5; // @dynamic objectCountForSameMd5;
@property(retain, nonatomic) NSMutableArray *objectList; // @dynamic objectList;
@property(nonatomic) unsigned int recCount; // @dynamic recCount;
@property(retain, nonatomic) NSMutableArray *recList; // @dynamic recList;
@property(retain, nonatomic) SnsServerConfig *serverConfig; // @dynamic serverConfig;
@property(retain, nonatomic) SKBuiltinBuffer_t *session; // @dynamic session;

@end

@interface ProtobufCGIWrap : NSObject <NSCopying>
{
    WXPBGeneratedMessage *m_pbRequest;
    Class m_pbRespClass;
    WXPBGeneratedMessage *m_pbResponse;
    unsigned int m_uiChannelType;//1
    unsigned int m_uiCgi;//211
    unsigned int m_uiScene;//0
    NSString *m_nsCgiName;//mmsnstimeline
    NSString *m_nsUri;
    unsigned int m_uiRequestEncryptType;
    NSData *m_dtResponseDecryptKey;
    unsigned int m_uiMessage;//0
    Class m_eventHandlerClass;
    NSObject *m_oUserData;
    UrlInfo *m_oUrlInfo;
    _Bool m_bNotifyPartLen;
    unsigned int m_uiRetryCount;//2
    double m_douTimeout;
    double m_douReadTimeout;
    int m_netwrokStrategy;
    unsigned char m_routeInfo;
}

@property(nonatomic) unsigned char m_routeInfo; // @synthesize m_routeInfo;
@property(nonatomic) int m_netwrokStrategy; // @synthesize m_netwrokStrategy;
@property(nonatomic) double m_douReadTimeout; // @synthesize m_douReadTimeout;
@property(nonatomic) double m_douTimeout; // @synthesize m_douTimeout;
@property(nonatomic) unsigned int m_uiRetryCount; // @synthesize m_uiRetryCount;
@property(nonatomic) _Bool m_bNotifyPartLen; // @synthesize m_bNotifyPartLen;
@property(retain, nonatomic) UrlInfo *m_oUrlInfo; // @synthesize m_oUrlInfo;
@property(retain, nonatomic) NSObject *m_oUserData; // @synthesize m_oUserData;
@property(nonatomic) Class m_eventHandlerClass; // @synthesize m_eventHandlerClass;
@property(nonatomic) unsigned int m_uiMessage; // @synthesize m_uiMessage;
@property(retain, nonatomic) NSData *m_dtResponseDecryptKey; // @synthesize m_dtResponseDecryptKey;
@property(nonatomic) unsigned int m_uiRequestEncryptType; // @synthesize m_uiRequestEncryptType;
@property(nonatomic) unsigned int m_uiChannelType; // @synthesize m_uiChannelType;
@property(retain, nonatomic) NSString *m_nsUri; // @synthesize m_nsUri;
@property(retain, nonatomic) NSString *m_nsCgiName; // @synthesize m_nsCgiName;
@property(nonatomic) unsigned int m_uiScene; // @synthesize m_uiScene;
@property(nonatomic) unsigned int m_uiCgi; // @synthesize m_uiCgi;
@property(retain, nonatomic) WXPBGeneratedMessage *m_pbResponse; // @synthesize m_pbResponse;
@property(nonatomic) Class m_pbRespClass; // @synthesize m_pbRespClass;
@property(retain, nonatomic) WXPBGeneratedMessage *m_pbRequest; // @synthesize m_pbRequest;

@end




@interface FindContactSearchViewCellInfo

+ (id)contactsFromSearchResponse:(id)arg1 req:(id)arg2;
- (_Bool)isValidLocalQuery:(id)arg1;

- (void)showContactInfoView:(id)arg1;
- (void)doSearch:(id)arg1 Pre:(_Bool)arg2;
- (void)onSearch:(id)arg1;
- (void)doSearch;
- (id)getSearchBarText;

- (void)MessageReturn:(id)arg1 Event:(unsigned int)arg2;
- (void)mmSearchDisplayControllerDidBeginSearch;


@end

@interface AddFriendEntryViewController

{
    FindContactSearchViewCellInfo *m_headerSearchView;
}

- (void)viewWillDisappear:(_Bool)arg1;

- (void)viewDidAppear:(_Bool)arg1;


@end

@interface SearchContactDataProvider : NSObject
{
    _Bool _isFromAddFriendScene;

    NSString *_keyword;
    NSArray *_contactGroupArray;
    NSString *_svrErrorMsg;
}

@property(retain, nonatomic) NSString *svrErrorMsg; // @synthesize svrErrorMsg=_svrErrorMsg;
@property(retain, nonatomic) NSArray *contactGroupArray; // @synthesize contactGroupArray=_contactGroupArray;
@property(retain, nonatomic) NSString *keyword; // @synthesize keyword=_keyword;

@property(nonatomic) _Bool isFromAddFriendScene; // @synthesize isFromAddFriendScene=_isFromAddFriendScene;

- (void)newMessageFromContactInfo:(id)arg1;
- (void)startCommonWebSearch;
- (void)showContactInfoView:(id)arg1 resultRow:(unsigned int)arg2;
- (_Bool)hasFoundContact;
- (void)handleDidCancelSearch;
- (void)handleSearchResultDataSelectWithIndexPath:(id)arg1;
- (id)makeSearchResultCellInTableView:(id)arg1 atIndexPath:(id)arg2;
- (double)heightForRowInSearchResultAtIndexPath:(id)arg1;
- (long long)numberOfRowInSearchResultSection:(long long)arg1;
- (long long)numberOfSectionInSearchResult;
- (void)makeNoUserTipsCell:(id)arg1;
- (double)getNoUserTipsCellHeight;
- (id)makeContactGroups:(id)arg1;
- (id)initWithFoundContacts:(id)arg1 andSearchKeyword:(id)arg2 andSvrErrMsg:(id)arg3 andDelegate:(id)arg4;
- (id)initWithFoundContact:(id)arg1 andSearchKeyword:(id)arg2 andSvrErrMsg:(id)arg3 andDelegate:(id)arg4;
- (id)initWithBSContent:(id)arg1 andFoundContact:(id)arg2 andSearchKeyword:(id)arg3 andLocation:(id)arg4 andDelegate:(id)arg5;


@end

@interface ContactInfoViewController : MMUIViewController

@property(retain, nonatomic) CContact *m_contact; // @synthesize m_contact;

- (void)viewDidBePushed:(_Bool)arg1;

- (void)onAddToContact;

- (id)getContactVerifyLogic;

- (id)tagForCurrentPage;
- (id)tagForActivePage;

@end

@interface SendVerifyMsgViewController

- (void)viewDidBePoped:(_Bool)arg1;

- (void)onSendVerifyMsg;

- (void)viewDidAppear:(_Bool)arg1;

@end


@interface CBaseContactInfoAssist


- (void)onAddToContacts;

@end

@interface WeixinContactInfoAssist : CBaseContactInfoAssist


@end
