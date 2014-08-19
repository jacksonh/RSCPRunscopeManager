RSCPRunscopeManager
===================

One weird trick to convert all your URLs to Runscope URLs


Usage
-----

In your AppDelegate - as early as possible - invoke ```startTrackingRequestsWithBucketKey``` with your Runscope Bucket Key.


    [[RSCPRunscopeManager sharedManager] startTrackingRequestsWithBucketKey:@"YOUR_KEY_HERE"];


Filtering
---------

If you'd like certain URLs to not be sent to Runscope, implement the ```RSCPRunscopeManagerDelegate``` protocol's ```runscopeManager:shouldTrackURL:``` method and return NO for URLs that should not be tracked.

```Obejctive-C
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    [[RSCPRunscopeManager sharedManager] startTrackingRequestsWithBucketKey:@"YOUR_KEY_HERE"];
    [RSCPRunscopeManager sharedManager] setDelegate:self];
}

- (BOOL)runscopeManager:(RSCPRunscopeManager *)manager shouldTrackURL:(NSURL *)URL
{
    // Only track URLs that do not have the password component set
    return (URL.password == nil);
}
```

Installing
----------

I recommend using [CocoaPods](http://cocoapods.org) :

    pod 'RSCPRunscopeManager'



