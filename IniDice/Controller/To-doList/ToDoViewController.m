//
//  ToDoViewController.m
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import "ToDoViewController.h"
#import "AddItemViewController.h"
#import "TodoTableViewCell.h"
#import "TodoListModel.h"
#import "TodoListDB.h"
#import "Util.h"

NSString *const isPermissionDenied = @"isPermissionDenied";
NSString *const isNeverShowAgain = @"isNeverShowAgain";

@interface ToDoViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@end

@implementation ToDoViewController

@synthesize items;

NSMutableArray * imageViewsArray;

NSString *cellId = @"cellId";
TodoListDB *todolistDB;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TodoTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
        
    self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor systemBlueColor]};
    
    self.title = @"TodoList";
        
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction:)];
    
    self.tableView.tableFooterView = [UIView new];

}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    todolistDB = [[TodoListDB alloc]init];
    items = [todolistDB showAllData];
    
    imageViewsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<[items count]; i++) {
        TodoListModel *item = items[i];
        if (!(item.image.length == 0)) [imageViewsArray addObject:[[Util new] decodeBase64ToImage:item.image]];
        else [imageViewsArray addObject:[NSNull null]];
        
        if (![item.date isEqual: @""] && [[NSUserDefaults standardUserDefaults] boolForKey:isPermissionDenied]) {
            [self setNotification: item];
        }
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:isPermissionDenied] && ![[NSUserDefaults standardUserDefaults] boolForKey:isNeverShowAgain]) {
        [self notificationPermissionAlert];
    }

}



- (void)addButtonAction:(UIBarButtonItem *) sender {
    AddItemViewController *addItem = [[AddItemViewController alloc] init];
    addItem.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addItem];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void) sendItem: (TodoListModel*) item {
    if (item.isEdit) {
        NSInteger number = item.indexNumber;
        [self.items replaceObjectAtIndex:number withObject:item];
        if (!(item.image.length == 0)) [imageViewsArray replaceObjectAtIndex:number withObject:[[Util new] decodeBase64ToImage:item.image]];
        else [imageViewsArray replaceObjectAtIndex:number withObject:[NSNull null]];
        [todolistDB updateData:item];
        [self.tableView reloadData];
    } else {
        if (!(item.image.length == 0)) [imageViewsArray addObject:[[Util new] decodeBase64ToImage:item.image]];
        else [imageViewsArray addObject:[NSNull null]];
        [todolistDB saveData:item];
        items = [todolistDB showAllData];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.items.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (![item.date isEqual:@""]) {
        [self setNotification: item];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    TodoListModel *item = items[indexPath.row];
    [cell configureCell:item image:imageViewsArray[indexPath.row]];
    cell.accessoryType = (item.isComplete) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddItemViewController *editItem = [[AddItemViewController alloc] init];
    TodoListModel *item = items[indexPath.row];
    item.isEdit = YES;
    item.indexNumber = indexPath.row;
    editItem.itemEdit = item;
    editItem.delegate = self;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editItem];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self alertDelete:indexPath];
        completionHandler(YES);
    }];
    
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    return configuration;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction *completeAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Complete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        TodoListModel *item = self.items[indexPath.row];
        BOOL completed = item.isComplete;
        item.isComplete = !completed;
        
        self.items[indexPath.row] = item;
        [todolistDB updateData:item];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = (item.isComplete) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        completionHandler(YES);
    }];
    
    completeAction.backgroundColor = [UIColor blueColor];
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[completeAction]];
    return configuration;
}


- (void) alertDelete:(NSIndexPath*) indexPath {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete Item" message:@"Are you sure to delete the item?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [todolistDB deleteData:self.items[indexPath.row]];
        [self.items removeObjectAtIndex:indexPath.row];
        [imageViewsArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"MEMORYLEAK");
}

- (void) notificationPermissionAlert{
    NSString *alertText = @"It looks like your privacy settings are preventing us from accessing your camera to do take image. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again.";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Permission Denied" message:alertText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* goSetting = [UIAlertAction actionWithTitle:@"Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction* nextTime = [UIAlertAction
                             actionWithTitle:@"Next Time"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isNeverShowAgain];
    }];
    
    UIAlertAction* notShow = [UIAlertAction
                             actionWithTitle:@"Don't show again"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isNeverShowAgain];
    }];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    [alert addAction:goSetting];
    [alert addAction:nextTime];
    [alert addAction:notShow];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) setNotification:(TodoListModel*) item {
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.sound = [UNNotificationSound defaultSound];
    content.title = item.name;

    if (item.desc != nil || ![item.desc isEqual:@""]) {
        content.body = item.desc;
    }

    NSDate *date = [[[Util new] dateFormatter] dateFromString:item.date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDateComponents *componentTime = nil;
    
    if (![item.time isEqual:@""]) {
        NSDate *time = [[[Util new] timeFormatter] dateFromString:item.time];
        componentTime = [calendar components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:time];
    } else {
        NSDate *now = [NSDate date];
        componentTime = [calendar components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:now];
        [componentTime setMinute:[componentTime minute]+1];
    }
        
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    [components setHour:[componentTime hour]];
    [components setMinute:[componentTime minute]];
    
    NSString *identifierId = [NSString stringWithFormat:@"%ld", (long)item.idTodoList];
        
    UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:identifierId content:content trigger:trigger];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"ERROR NOTIF");
        }
    }];
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter* )center willPresentNotification:(UNNotification* )notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog( @"Here handle push notification in foreground" );
    
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
}




@end
