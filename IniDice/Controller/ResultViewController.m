//
//  ResultViewController.m
//  IniDice
//
//  Created by iei19100004 on 27/05/21.
//

#import "ResultViewController.h"
#import "CatatanViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

@synthesize result, textTotal;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

    textTotal = [[UILabel alloc] initWithFrame:CGRectMake(300, 300, 100, 100)];
    textTotal.text = [NSString stringWithFormat:@"%d", result];
    [self.view addSubview:textTotal];

}

-(void) backButtonClicked: (UIBarButtonItem *) sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
