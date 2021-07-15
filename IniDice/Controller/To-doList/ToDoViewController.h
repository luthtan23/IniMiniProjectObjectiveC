//
//  ToDoViewController.h
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoViewController : UITableViewController <UNUserNotificationCenterDelegate>

@property (nonatomic) NSMutableArray *items;

@end

NS_ASSUME_NONNULL_END
