//
//  ELSettingViewController.m
//  ELWeChat
//
//  Created by Eli on 2018/10/9.
//  Copyright © 2018年 eli. All rights reserved.
//

#import "ELSettingViewController.h"
#import <objc/runtime.h>
#import "ELWeChatConfig.h"
#import "ELWeChatHeaderinfo.h"
#import "WBMultiSelectGroupsViewController.h"

@interface ELSettingViewController ()<MultiSelectGroupsViewControllerDelegate>

@property (nonatomic, strong) MMTableViewInfo *tableViewInfo;

@end

@implementation ELSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _tableViewInfo = [[objc_getClass("MMTableViewInfo") alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    FindContactSearchViewCellInfo *mm = [NSClassFromString(@"FindContactSearchViewCellInfo") new];
//
//    NSLog(@"------%@",mm);
//
//    [mm doSearch:@"15993126618" Pre:YES];
//
//
//    [mm doSearch];
    
//    CContactMgr *contactManager = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CContactMgr")];
//
//    CContact *mm = [contactManager getContactForSearchByName:@"15993126618"];
    
    self.title = @"微信助手";
    
    [self reloadTableViewData];
    
    MMTableView *tableView = [self.tableViewInfo getTableView];
    [self.view addSubview:tableView];
}

- (void)reloadTableViewData
{
    [self.tableViewInfo clearAllSection];
    
    [self addRedEnvelopSection];
    
    [self addGroupManageSection];
    
    [self addMessageSection];
    
    [self addStepSection];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    MMTableView *tableView = [self.tableViewInfo getTableView];
    [tableView reloadData];
    
}




- (void)addStepSection
{
    
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    [sectionInfo addCell:[self addStepSectionCell]];
    
    if ([ELAppManage sharedManage].appConfig.StepManage)
    {
        [sectionInfo addCell:[self addStepNumberSectionCell]];
    }
    
    
    [self.tableViewInfo addSection:sectionInfo];
    
}


- (MMTableViewCellInfo *)addStepSectionCell
{
    
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(SetpClick:) target:self title:@"修改步数" on:[ELAppManage sharedManage].appConfig.StepManage];
    
}

- (void)SetpClick:(UISwitch *)setpSwitch
{
    [ELAppManage sharedManage].appConfig.StepManage = setpSwitch.on;
    
    [self reloadTableViewData];
}



- (MMTableViewCellInfo *)addStepNumberSectionCell
{
    
    
    WCDeviceBrandMgr *BrandMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("WCDeviceBrandMgr")];
    
    
    //WCDeviceM7Logic *m7Logic = [BrandMgr valueForKey:@"_m7Logic"];
    
    
    
    
    NSInteger LastSetp = [BrandMgr getLastM7Step];
    
    NSInteger curSetp = LastSetp > [ELAppManage sharedManage].appConfig.ResetStepNum ? LastSetp : [ELAppManage sharedManage].appConfig.ResetStepNum;
    
    
    return [objc_getClass("MMTableViewCellInfo")  normalCellForSel:@selector(setStepNumber) target:self title:@"微信运动步数" rightValue:[NSString stringWithFormat:@"%ld",(long)curSetp] accessoryType:1];
    
}


- (void)addRedEnvelopSection
{
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    [sectionInfo addCell:[self addRedEnvelopSectionCell]];
    
    if ([ELAppManage sharedManage].appConfig.autoRedEnvelop)
    {
        [sectionInfo addCell:[self addBlackListCell]];
    }
    
    [self.tableViewInfo addSection:sectionInfo];

}


- (MMTableViewCellInfo *)addRedEnvelopSectionCell
{
    
     return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(RedEnvelopClick:) target:self title:@"自动抢红包" on:[ELAppManage sharedManage].appConfig.autoRedEnvelop];
    
}

- (MMTableViewCellInfo *)addBlackListCell
{
    
    if ([ELAppManage sharedManage].appConfig.blackList.count == 0) {
        return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(showBlackList) target:self title:@"群聊过滤" rightValue:@"已关闭" accessoryType:1];
    } else {
        NSString *blackListCountStr = [NSString stringWithFormat:@"已选择 %lu 个群", (unsigned long)[ELAppManage sharedManage].appConfig.blackList.count];
        return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(showBlackList) target:self title:@"群聊过滤" rightValue:blackListCountStr accessoryType:1];
    }

    
}


- (void)showBlackList {
    WBMultiSelectGroupsViewController *contactsViewController = [[WBMultiSelectGroupsViewController alloc] initWithBlackList:[ELAppManage sharedManage].appConfig.blackList];
    contactsViewController.delegate = self;
    
    MMUINavigationController *navigationController = [[objc_getClass("MMUINavigationController") alloc] initWithRootViewController:contactsViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)RedEnvelopClick:(UISwitch *)RedEnvelopSwitch
{

    [ELAppManage sharedManage].appConfig.autoRedEnvelop = RedEnvelopSwitch.on;
    
    [self reloadTableViewData];
}

- (void)addGroupManageSection
{
    
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    [sectionInfo addCell:[self addGroupManageSectionCell]];
    
    [self.tableViewInfo addSection:sectionInfo];
}

- (MMTableViewCellInfo *)addGroupManageSectionCell
{
    
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(GroupManageClick:) target:self title:@"群管理" on:[ELAppManage sharedManage].appConfig.groupManage];
    
}

- (void)GroupManageClick:(UISwitch *)GroupManageSwitch
{
    
    [ELAppManage sharedManage].appConfig.groupManage = GroupManageSwitch.on;
    
    
}


- (void)addMessageSection
{
    
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    [sectionInfo addCell:[self addMessageSectionCell]];
    
    [self.tableViewInfo addSection:sectionInfo];
}

- (MMTableViewCellInfo *)addMessageSectionCell
{
    
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(MessageClick:) target:self title:@"消息防撤回" on:[ELAppManage sharedManage].appConfig.Message];
    
}

- (void)MessageClick:(UISwitch *)MessageSwitch
{
    
    [ELAppManage sharedManage].appConfig.Message = MessageSwitch.on;
    
    
}


- (void)setStepNumber
{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"微信运动设置" message:@"微信最大步数98800,请输入比当前步数更大的步数" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入步数";
        textField.keyboardType = UIKeyboardTypePhonePad;
    }];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *step = alertController.textFields[0].text;
        
        [ELAppManage sharedManage].appConfig.ResetStepNum = [step integerValue];
        
        [self reloadTableViewData];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    [alertController addAction:cancel];
    
    [alertController addAction:sure];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MultiSelectGroupsViewControllerDelegate
- (void)onMultiSelectGroupCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)onMultiSelectGroupReturn:(NSArray *)arg1 {
    [ELAppManage sharedManage].appConfig.blackList = arg1;
    
    [self reloadTableViewData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
