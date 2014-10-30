//
//  HttpClientManager.h
//  DailyReader
//
//  Created by limingming on 14/10/30.
//  Copyright (c) 2014年 SellaMoe. All rights reserved.
//

#ifndef DailyReader_HttpClientManager_h
#define DailyReader_HttpClientManager_h

#import "../Foundation/Singleton.h"

@interface HttpClientManager : Singleton

-(NSString*) requestPost:(NSURL *)url;

@end

#endif
