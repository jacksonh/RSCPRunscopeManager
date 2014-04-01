RSCPRunscopeManager
===================

One weird trick to convert all your URLs to Runscope URLs


Usage
-----

In your AppDelegate - as early as possible - invoke ```startTrackingRequestsWithBucketKey``` with your Runscope Bucket Key.


    [[RSCPRunscopeManager sharedManager] startTrackingRequestsWithBucketKey:@"YOUR_KEY_HERE"];

