//
//  HttpClientManager.m
//  DailyReader
//
//  Created by limingming on 14/10/30.
//  Copyright (c) 2014年 SellaMoe. All rights reserved.
//

#import "HttpClientManager.h"

@implementation HttpClientManager

- (NSString*)requestPost:(NSURL *)url
{
    NSString* retData = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
//    NSString *str = @"type=focus-c";
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary* arrayResult =[dic objectForKey:@"DATA"];
    retData = [arrayResult objectForKey:@"detail"];
    return retData;
}

@end