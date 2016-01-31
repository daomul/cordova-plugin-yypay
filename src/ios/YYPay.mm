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


#define kMode_Development             @"201601271431425671858"
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
@property (nonatomic, copy) NSString *currentCallbackId;

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
    //拿到传入的参数
    _currentCallbackId = command.callbackId;
    NSMutableDictionary* pathArr = [command argumentAtIndex:0 withDefault:nil];
    NSString *tradeCode = [pathArr objectForKey:@"tradeCode"];
    NSString *payCode = [pathArr objectForKey:@"payCode"] ? [pathArr objectForKey:@"payCode"] : @"01";

    if (tradeCode != nil && tradeCode.length > 0)
    {
        NSLog(@"tn=%@",tradeCode);
        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
//        id currentController = [[[delegate window] rootViewController] visibleViewController];
        [[UPPaymentControl defaultControl] startPay:tradeCode fromScheme:@"975052664" mode:payCode viewController:rootViewController];

        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UPPayPluginResultBack:) name:@"UPPaymentDidBackNotification" object:nil];


    }else {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        result[@"code"] = @"-1";
        result[@"msg"] = @"支付失败";
        [self failWithCallbackID:result];
    }
}

#pragma mark UPPayPluginResult
- (void)UPPayPluginResultBack:(NSNotification *)notification
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    NSString *resultCode = notification.userInfo[@"code"];
    if ([resultCode isEqualToString:@"success"]) {
        result[@"code"] = 0;
        result[@"msg"] = @"支付成功";
        [self successWithCallbackID:result];
    }else if([resultCode isEqualToString:@"fail"]) {
        //交易失败
        result[@"code"] = @"-1";
        result[@"msg"] = @"支付失败";
        [self failWithCallbackID:result];
    }
    else if([resultCode isEqualToString:@"cancel"]) {
        //交易取消
        result[@"code"] = @"-2";
        result[@"msg"] = @"支付取消";
        [self failWithCallbackID:result];
    }
}

#pragma mark -- callBack delegate

- (void)successWithCallbackID:(NSDictionary *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:_currentCallbackId];
}

- (void)failWithCallbackID:(NSDictionary *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:_currentCallbackId];
}


@end
