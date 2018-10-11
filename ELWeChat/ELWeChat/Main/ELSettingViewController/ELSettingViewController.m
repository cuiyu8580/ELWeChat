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


@interface ELSettingViewController ()

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
    
    self.title = @"微信助手";
    
    [self.tableViewInfo clearAllSection];
    
    [self addRedEnvelopSection];
    
    [self addGroupManageSection];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    MMTableView *tableView = [self.tableViewInfo getTableView];
    [self.view addSubview:tableView];
    
}


- (void)addRedEnvelopSection
{
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    [sectionInfo addCell:[self addRedEnvelopSectionCell]];
    
    [self.tableViewInfo addSection:sectionInfo];

}


- (MMTableViewCellInfo *)addRedEnvelopSectionCell
{
    
     return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(RedEnvelopClick:) target:self title:@"自动抢红包" on:[ELAppManage sharedManage].appConfig.autoRedEnvelop];
    
}

- (void)RedEnvelopClick:(UISwitch *)RedEnvelopSwitch
{

    [ELAppManage sharedManage].appConfig.autoRedEnvelop = RedEnvelopSwitch.on;
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
