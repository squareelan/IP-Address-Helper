//
//  IPAddressHelper.h
//
//  Created by Yongjun Yoo on 5/4/16.
//  Copyright © 2016 Yongjun Yoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPAddressHelper : NSObject
+ (NSString *)getIPAddress;
+ (NSString *)getSubNetMask;
+ (NSString*)getPublicIP;
@end
