//
//  YYPay.h
//  demo
//
//  Created by Axiba on 16/1/27.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>

@interface YYPay : CDVPlugin

- (void) pay:(CDVInvokedUrlCommand*)command;

@end
