//
//  MemberDetailViewController.m
//  IniDice
//
//  Created by iei19100004 on 03/06/21.
//

#import "MemberDetailViewController.h"
#import "MemberModel.h"

@interface MemberDetailViewController ()

@end

@implementation MemberDetailViewController

@synthesize memberModel, imageDetail, nameDetail, roleDetail, birthDetail, locationDetail, hobbyDetail, motivationDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationItem.title = @"Profile";
    
    imageDetail.image = [UIImage imageNamed:memberModel.image];
    nameDetail.text = memberModel.name;
    roleDetail.text = memberModel.role;
    birthDetail.text = memberModel.birthPlace;
    locationDetail.text = memberModel.address;
    hobbyDetail.text = memberModel.hobby;
    motivationDetail.text = memberModel.motivation;
    
}


@end
