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
@property (strong, nonatomic) NSString* m_nsFromUsr;            ///< 發信人，可能是群或個人
@property (retain, nonatomic) NSString* m_nsToUsr;              ///< 收信人
@property (assign, nonatomic) NSUInteger m_uiStatus;
@property (retain, nonatomic) NSString* m_nsContent;            ///< 消息内容
@property (retain, nonatomic) NSString* m_nsRealChatUsr;        ///< 群消息的發信人，具体是群里的哪個人
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
- (void)initData:(unsigned int)arg1;
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

@interface NewSettingViewController: MMUIViewController

- (void)reloadTableData;

@end

@interface ContactInfoViewController : MMUIViewController

@property(retain, nonatomic) CContact *m_contact; // @synthesize m_contact;

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


@interface WAStarLinearListViewController : MMUIViewController



@end
