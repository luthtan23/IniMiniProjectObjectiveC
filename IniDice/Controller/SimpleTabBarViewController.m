//
//  SimpleTabBarViewController.m
//  IniDice
//
//  Created by iei19100004 on 28/05/21.
//

#import "SimpleTabBarViewController.h"
#import "DiceGenerator/DiceViewController.h"
#import "MemberList/MemberTableViewController.h"
#import "To-doList/ToDoViewController.h"

@interface SimpleTabBarViewController ()

@end

@implementation SimpleTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    DiceViewController *firstController = [[DiceViewController alloc] init];
    MemberTableViewController *secondController = [[MemberTableViewController alloc] init];
    ToDoViewController *thirdController = [[ToDoViewController alloc] init];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstController];
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:secondController];
    UINavigationController *thirddNav = [[UINavigationController alloc] initWithRootViewController:thirdController];
    
    firstNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Dice" image:[UIImage systemImageNamed:@"rectangle.grid.3x2"] tag:0];
    secondNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Member" image:[UIImage systemImageNamed:@"person.2"] tag:1];
    thirddNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"To-do List" image:[UIImage systemImageNamed:@"doc.on.doc"] tag:3];
    
    self.viewControllers = [NSArray arrayWithObjects:thirddNav, secondNav, firstNav, nil];

}

@end
