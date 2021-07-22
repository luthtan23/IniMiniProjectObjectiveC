//
//  AppDelegate.m
//  IniDice
//
//  Created by iei19100004 on 24/05/21.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setNotificationPermission];

    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    UISceneConfiguration *configuration = [[UISceneConfiguration alloc] init];
    configuration.delegateClass = SceneDelegate.class;
    return configuration;
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) setNotificationPermission{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
            NSLog( @"Push registration success." );
            if (granted) {
                NSLog( @"Push granted success." );
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPermissionDenied"];
            } else {
                NSLog( @"Push granted FAILED." );
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPermissionDenied"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            NSLog( @"Push registration FAILED" );
        }
    }];
}


@end
