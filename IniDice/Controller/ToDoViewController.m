//
//  ToDoViewController.m
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import "ToDoViewController.h"
#import "AddItemViewController.h"
#import "TodoTableViewCell.h"

@interface ToDoViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *items;

@end

@implementation ToDoViewController

NSString *cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TodoTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.items = [[NSMutableArray alloc] init].mutableCopy;
    
    self.navigationItem.title = @"To-Do List";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;

}

- (void)addNewItem:(UIBarButtonItem *) sender {
    AddItemViewController *addItem = [[AddItemViewController alloc] init];
    addItem.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addItem];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

- (void) sendItem: (NSDictionary*) item {
    if (item[@"isEdit"]) {
        NSNumber *number = [item objectForKey:@"indexEdit"];
        int intValue = [number intValue];
        [self.items replaceObjectAtIndex:intValue withObject:item];
        [self.tableView reloadData];
    } else {
        [self.items addObject:item];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.items.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *item = self.items[indexPath.row];
    [cell configureCell:item];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *item = [self.items[indexPath.row] mutableCopy];
    item[@"isEdit"] = @(true);
    self.items[indexPath.row] = item;
    AddItemViewController *editItem = [[AddItemViewController alloc] initWithNibName:@"AddItemViewController" bundle:nil];
    editItem.itemEdit = self.items[indexPath.row];
    editItem.indexEdit = (int) indexPath.row;
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
            NSMutableDictionary *item = [self.items[indexPath.row] mutableCopy];
            BOOL completed = [item[@"completed"] boolValue];
            item[@"completed"] = @(!completed);
        
            self.items[indexPath.row] = item;
        
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = ([item[@"completed"] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            completionHandler(YES);
        }];
    
    completeAction.backgroundColor = [UIColor blueColor];
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[completeAction]];
    return configuration;
}


- (void) alertDelete:(NSIndexPath*) indexPath {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete Item" message:@"Are you sure to delete the item?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.items removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
