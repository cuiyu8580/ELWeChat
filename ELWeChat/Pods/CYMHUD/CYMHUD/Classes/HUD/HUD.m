//
//  HUD.m
//  geliwuliu
//
//  Created by Eli on 2017/5/5.
//  Copyright © 2017年 Eli. All rights reserved.
//

#import "HUD.h"

#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

@implementation HUD

+ (instancetype)shareInstance{
    
    static HUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HUD alloc] init];
    });
    
    return instance;
}

+ (void)show:(NSString *)msg inView:(UIView *)view mode:(HudProgressMode)myMode{
    
    [self show:msg inView:view mode:myMode customImgView:nil];
}

+ (void)show:(NSString *)msg inView:(UIView *)view mode:(HudProgressMode)myMode customImgView:(UIImageView *)customImgView{
    //如果已有弹框，先消失
    if ([HUD shareInstance].hud != nil) {
        [[HUD shareInstance].hud hideAnimated:YES];
        [HUD shareInstance].hud = nil;
    }
    
    
    [HUD shareInstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
   [HUD shareInstance].hud.label.text = msg;

    
    [HUD shareInstance].hud.bezelView.backgroundColor = UIColorFromHex(0xBEBEBE);
    
    
    switch ((NSInteger)myMode) {
        case HudProgressModeOnlyText: //仅文字
            [HUD shareInstance].hud.mode = MBProgressHUDModeText;
            break;
            
        case HudProgressModeLoading: //系统菊花
            [HUD shareInstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;
            
        case HudProgressModeCircle:{ //环形
            
            
            
            break;
        }
        case HudProgressModeCustomerImage://自定义图片
            [HUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [HUD shareInstance].hud.customView = customImgView;
            break;
            
        case HudProgressModeCustomAnimation://自定义加载动画（序列帧实现）
            //这里设置动画的背景色
            [HUD shareInstance].hud.bezelView.color = [UIColor yellowColor];
            
            
            [HUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [HUD shareInstance].hud.customView = customImgView;
            
            break;
            
        case HudProgressModeSuccess://成功
            [HUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [HUD shareInstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
            break;
            
        default:
            break;
    }
    
    
    
}


+ (void)hide{
    if ([HUD shareInstance].hud != nil) {
        [[HUD shareInstance].hud hideAnimated:YES];
    }
}


+ (void)showMessage:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:HudProgressModeOnlyText];
    [[HUD shareInstance].hud hideAnimated:YES afterDelay:HUDAfterDelayTime];
}



+ (void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg inView:view mode:HudProgressModeOnlyText];
    [[HUD shareInstance].hud hideAnimated:YES afterDelay:delay];
}

+ (void)showSuccess:(NSString *)msg inview:(UIView *)view{
    [self show:msg inView:view mode:HudProgressModeSuccess];
    [[HUD shareInstance].hud hideAnimated:YES afterDelay:HUDAfterDelayTime];
    
}

+ (void)showMsgWithImage:(NSString *)msg imageName:(NSString *)imageName inview:(UIView *)view{
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self show:msg inView:view mode:HudProgressModeCustomerImage customImgView:img];
    [[HUD shareInstance].hud hideAnimated:YES afterDelay:HUDAfterDelayTime];
}


+ (void)showProgress:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:HudProgressModeLoading];
}

+ (MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.detailsLabel.text = msg;
    return hud;
    
    
}

+ (void)showProgressCircleNoValue:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:HudProgressModeCircle];
    
}


+(void)showMsgWithoutView:(NSString *)msg{
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [self show:msg inView:view mode:HudProgressModeOnlyText];
    [[HUD shareInstance].hud hideAnimated:YES afterDelay:HUDAfterDelayTime];
    
}

+ (void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view{
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:view mode:HudProgressModeCustomAnimation customImgView:showImageView];
}





@end
