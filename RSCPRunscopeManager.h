//
//  RSCPRunscopeManager.h
//  codereview
//
//  Created by Jackson Harper on 4/1/14.
//  Copyright (c) 2014 Harper Semiconductors, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSCPRunscopeManager;


@protocol RSCPRunscopeManagerDelegate <NSObject>

@optional

- (BOOL)runscopeManager:(RSCPRunscopeManager *)manager shouldTrackURL:(NSURL *)URL;

@end


@interface RSCPRunscopeManager : NSObject

+ (instancetype)sharedManager;

- (void)startTrackingRequestsWithBucketKey:(NSString *)bucketKey;
- (void)stopTrackingRequests;

@property (nonatomic, readonly) BOOL isTrackingRequests;
@property (weak, nonatomic) id<RSCPRunscopeManagerDelegate> delegate;

@end

