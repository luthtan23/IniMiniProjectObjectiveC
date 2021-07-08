//
//  NotificationTodo.h
//  IniDice
//
//  Created by iei19100004 on 08/07/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationTodo : NSObject <UNUserNotificationCenterDelegate>

- (BOOL) setNotificationTodo;

@end

NS_ASSUME_NONNULL_END
