//
//  Singleton.m
//  DailyReader
//
//  Created by limingming on 14/10/30.
//  Copyright (c) 2014年 SellaMoe. All rights reserved.
//

#include "Singleton.h"

static Singleton *shareInstancePtr = nil;

@implementation Singleton

+ (Singleton *) sharedInstance
{
    @synchronized(self)
    {
        if (shareInstancePtr == nil)
        {
            shareInstancePtr = [[self alloc] init];
        }
    }
    return shareInstancePtr;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareInstancePtr == nil)
        {
            shareInstancePtr = [super allocWithZone:zone];
            return shareInstancePtr;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *) zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return NSUIntegerMax;
}

- (void)release
{
    
}

- (id)autorelease
{
    return self;
}

- (void)dealloc
{
    [super dealloc];
}



@end
