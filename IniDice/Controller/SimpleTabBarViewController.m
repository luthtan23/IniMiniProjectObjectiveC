//
//  SimpleTabBarViewController.m
//  IniDice
//
//  Created by iei19100004 on 28/05/21.
//

#import "SimpleTabBarViewController.h"
#import "ViewController.h"
#import "CatatanViewController.h"
#import "ToDoViewController.h"

@interface SimpleTabBarViewController ()

@end

@implementation SimpleTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    ViewController *firstController = [[ViewController alloc] init];
    CatatanViewController *secondController = [[CatatanViewController alloc] init];
    ToDoViewController *thirdController = [[ToDoViewController alloc] init];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstController];
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:secondController];
    UINavigationController *thirddNav = [[UINavigationController alloc] initWithRootViewController:thirdController];
    
    firstNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Dice" image:[UIImage systemImageNamed:@"rectangle.grid.3x2"] tag:0];
    secondNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Member" image:[UIImage systemImageNamed:@"person.2"] tag:1];
    thirddNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"To-do List" image:[UIImage systemImageNamed:@"doc.on.doc"] tag:3];
    
    self.viewControllers = [NSArray arrayWithObjects:thirddNav, secondNav, firstNav, nil];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
