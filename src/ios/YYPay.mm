//
//  ViewController.m
//  UPPayDemo
//
//  Created by zhangyi on 15/11/19.
//  Copyright © 2015年 UnionPay. All rights reserved.
//

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "YYPay.h"
#import "UPPaymentControl.h"


#define KBtn_width        200
#define KBtn_height       80
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          80
#define kCellHeight_Normal  50
#define kCellHeight_Manual  145

#define kVCTitle          @"商户测试"
#define kBtnFirstTitle    @"获取订单，开始测试"
#define kWaiting          @"正在获取TN,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"


#define kMode_Development             @"01"
#define kURL_TN_Normal                @"http://101.231.204.84:8091/sim/getacptn"
#define kURL_TN_Configure             @"http://101.231.204.84:8091/sim/app.jsp?user=123456789"




@interface YYPay ()
{
    UIAlertView* _alertView;
    NSMutableData* _responseData;
    CGFloat _maxWidth;
    CGFloat _maxHeight;
    
    UITextField *_urlField;
    UITextField *_modeField;
    UITextField *_curField;
}

@property(nonatomic, copy)NSString *tnMode;

- (void)showAlertWait;
- (void)showAlertMessage:(NSString*)msg;
- (void)hideAlert;


@end


@implementation YYPay
@synthesize tnMode;

- (void)dealloc
{
    self.tnMode = nil;
    
}

#pragma mark -- CDVplugin Delegate
- (void) pay:(CDVInvokedUrlCommand*)command
{
    NSString* tn = kMode_Development;
    if (tn != nil && tn.length > 0)
    {
        
        NSLog(@"tn=%@",tn);
        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
//        id currentController = [[[delegate window] rootViewController] visibleViewController];
        [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo" mode:self.tnMode viewController:rootViewController];
        
    }
}

#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    NSString* msg = [NSString stringWithFormat:kResult, result];
    [self showAlertMessage:msg];
}

#pragma mark - Alert

- (void)showAlertWait
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alertView show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(_alertView.frame.size.width / 2.0f - 15, _alertView.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [_alertView addSubview:aiv];
    
}

- (void)showAlertMessage:(NSString*)msg
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:self cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    
}
- (void)hideAlert
{
    if (_alertView != nil)
    {
        [_alertView dismissWithClickedButtonIndex:0 animated:NO];
        _alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _alertView = nil;
}


@end

