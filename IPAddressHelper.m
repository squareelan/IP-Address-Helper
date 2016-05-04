//
//  IPAddressHelper.m
//
//  Created by Yongjun Yoo on 5/4/16.
//  Copyright © Yongjun Yoo. All rights reserved.
//

#import "IPAddressHelper.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation IPAddressHelper

+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }

            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)getSubNetMask
{
    NSString *mask = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    mask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }



            temp_addr = temp_addr->ifa_next;
        }
    }

    // Free memory
    freeifaddrs(interfaces);
    return mask;
}

+ (NSString*)getPublicIP
{
    NSString *externalIP;
    NSArray *ipItemsArray = [[NSArray alloc] init];

    // get public ip from dynsns.org
    NSURL *iPURL = [NSURL URLWithString:@"http://www.dyndns.org/cgi-bin/check_ip.cgi"];
    if (iPURL)
    {
        NSError *error = nil;
        NSString *theIpHtml = [NSString stringWithContentsOfURL:iPURL encoding:NSUTF8StringEncoding error:&error];

        if (!error)
        {
            NSScanner *theScanner;
            NSString *text = nil;
            theScanner = [NSScanner scannerWithString:theIpHtml];

            // parse HTML and find IP address
            while ([theScanner isAtEnd] == NO)
            {
                // remove html tags
                [theScanner scanUpToString:@"<" intoString:NULL] ;
                [theScanner scanUpToString:@">" intoString:&text] ;
                theIpHtml = [theIpHtml stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];

                // grab only ip address from html string.
                ipItemsArray = [theIpHtml componentsSeparatedByString:@" "];
                int an_Integer= (int)[ipItemsArray indexOfObject:@"Address:"];
                externalIP =[ipItemsArray objectAtIndex: ++an_Integer];
            }

            if (externalIP.length == 0)
            {
                return nil;
            }
            return externalIP;
        }
    }
    return externalIP;
}

@end
