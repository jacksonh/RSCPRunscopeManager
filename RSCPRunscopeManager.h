//
//  RSCPRunscopeManager.h
//  codereview
//
//  Created by Jackson Harper on 4/1/14.
//  Copyright (c) 2014 Harper Semiconductors, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSCPRunscopeManager : NSObject

+ (instancetype)sharedManager;

- (void)startTrackingRequestsWithBucketKey:(NSString *)bucketKey;
- (void)stopTrackingRequests;

@property (nonatomic, readonly) BOOL isTrackingRequests;

@end

