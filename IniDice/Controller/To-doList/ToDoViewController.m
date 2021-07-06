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
    
    self.navigationItem.title = @"To-Do List";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    
    self.tableView.tableFooterView = [UIView new];

}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    todolistDB = [[TodoListDB alloc]init];
    items = [todolistDB showAllData];
    
    imageViewsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<[items count]; i++) {
        TodoListModel *item = items[i];
        if (!(item.image.length == 0)) [imageViewsArray addObject:[self decodeBase64ToImage:item.image]];
        else [imageViewsArray addObject:[NSNull null]];
    }

}

- (void)addNewItem:(UIBarButtonItem *) sender {
    AddItemViewController *addItem = [[AddItemViewController alloc] init];
    addItem.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addItem];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

- (void) sendItem: (TodoListModel*) item {
    if (item.isEdit) {
        NSInteger number = item.indexNumber;
        [self.items replaceObjectAtIndex:number withObject:item];
        if (!(item.image.length == 0)) [imageViewsArray replaceObjectAtIndex:number withObject:[self decodeBase64ToImage:item.image]];
        else [imageViewsArray replaceObjectAtIndex:number withObject:[NSNull null]];
        [todolistDB updateData:item];
        [self.tableView reloadData];
    } else {
        if (!(item.image.length == 0)) [imageViewsArray addObject:[self decodeBase64ToImage:item.image]];
        else [imageViewsArray addObject:[NSNull null]];
        [todolistDB saveData:item];
        items = [todolistDB showAllData];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.items.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 180;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"MEMORYLEAK");
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
  NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
  return [UIImage imageWithData:data];
}

@end
