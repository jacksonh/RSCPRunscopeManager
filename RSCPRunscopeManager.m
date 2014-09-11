//
//  RSCPRunscopeManager.m
//  codereview
//
//  Created by Jackson Harper on 4/1/14.
//  Copyright (c) 2014 Harper Semiconductors, Inc. All rights reserved.
//

#import "RSCPRunscopeManager.h"

#import <objc/runtime.h>

@interface RSCPRunscopeManager()

@property (strong, nonatomic, readwrite) NSString *bucketKey;

@end

@implementation RSCPRunscopeManager


+ (instancetype)sharedManager
{
	static id singleton;
    static dispatch_once_t pred;
	
    dispatch_once (&pred, ^{
        singleton = [[self alloc] init];
    });
	
    return singleton;
}

- (BOOL)isTrackingRequests
{
	return ([self bucketKey] != nil);
}

- (void)startTrackingRequestsWithBucketKey:(NSString *)bucketKey
{
#ifdef DEBUG
	[self setBucketKey:bucketKey];
#endif
}

- (void)stopTrackingRequests
{
	[self setBucketKey:nil];
}

- (BOOL)shouldTrackURL:(NSURL *)URL
{
	if (![[URL scheme] hasPrefix:@"http"])
		return NO;
	if ([self.delegate respondsToSelector:@selector (runscopeManager:shouldTrackURL:)])
		return [self.delegate runscopeManager:self shouldTrackURL:URL];
	return YES;
}

- (NSURL *)bucketURLForURL:(NSURL *)URL
{
	if (![self bucketKey] || ![self shouldTrackURL:URL])
		return URL;

	// Avoid double runscoping URLs
	if (objc_getAssociatedObject (URL, _cmd) || [self isRunscopedURL:URL])
		return URL;

	NSString *host = [URL host];

	// TODO: Could do this in a single pass, and avoid a copy if no '-'s are present
	host = [host stringByReplacingOccurrencesOfString:@"-" withString:@"--"];
	host = [host stringByReplacingOccurrencesOfString:@"." withString:@"-"];
	host = [host stringByAppendingFormat:@"-%@.runscope.net", [self bucketKey]];

	NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:YES];
	[URLComponents setHost:host];

	URL = [URLComponents URL];
	objc_setAssociatedObject (URL, _cmd, @(YES), OBJC_ASSOCIATION_COPY);

	return URL;
}

- (BOOL)isRunscopedURL:(NSURL *)URL
{
	return [URL.host hasSuffix:@".runscope.net"];
}

@end


#ifdef DEBUG

@implementation NSURLRequest (RSCPTracking)

+ (void)load
{
	[self swizzleSelector:@selector(initWithURL:cachePolicy:timeoutInterval:)
			   toSelector:@selector(rscp_initWithURL:cachePolicy:timeoutInterval:)
				  inClass:[self class]];
}

+ (void)swizzleSelector:(SEL)originalSelector toSelector:(SEL)swizzledSelector inClass:(Class)class
{
	Method originalMethod = class_getInstanceMethod (class, originalSelector);
	Method swizzledMethod = class_getInstanceMethod (class, swizzledSelector);

	BOOL didAddMethod = class_addMethod (class,
										 originalSelector,
										 method_getImplementation (swizzledMethod),
										 method_getTypeEncoding (swizzledMethod));
	
	if (didAddMethod) {
		class_replaceMethod(class,
							swizzledSelector,
							method_getImplementation (originalMethod),
							method_getTypeEncoding (originalMethod));
	} else
		method_exchangeImplementations (originalMethod, swizzledMethod);
}

- (id)rscp_initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
{
	NSURL *bucketURL = [[RSCPRunscopeManager sharedManager] bucketURLForURL:URL];

	return [self rscp_initWithURL:bucketURL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
}

@end


@implementation NSMutableURLRequest (RSCPTracking)

+ (void)load
{
	[self swizzleSelector:@selector(setURL:)
			   toSelector:@selector(rscp_setURL:)
				  inClass:[self class]];
}

- (void)rscp_setURL:(NSURL *)URL
{
	NSURL *bucketURL = [[RSCPRunscopeManager sharedManager] bucketURLForURL:URL];
	return [self rscp_setURL:bucketURL];
}

@end

#endif


