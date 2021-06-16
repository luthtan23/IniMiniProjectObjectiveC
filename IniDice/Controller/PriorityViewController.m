//
//  PriorityViewController.m
//  IniDice
//
//  Created by iei19100004 on 14/06/21.
//

#import "PriorityViewController.h"

@interface PriorityViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PriorityViewController

@synthesize priorityTableView, delegate, priorityString, result;

NSString *cellIdPriority = @"priorityId", *priorityText = @"";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Select Priority";

    
    priorityTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    priorityTableView.delegate = self;
    priorityTableView.dataSource = self;
    priorityTableView.showsHorizontalScrollIndicator = NO;
    priorityTableView.showsVerticalScrollIndicator = NO;
    [priorityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdPriority];
    
    [self setConstraint];
    
}

- (void) setConstraint{
    UIView *templatePriority = [[UIView alloc] init];
    templatePriority.backgroundColor = [UIColor secondarySystemBackgroundColor];
    [self.view addSubview:templatePriority];

    templatePriority.translatesAutoresizingMaskIntoConstraints = NO;
    [templatePriority.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [templatePriority.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [templatePriority.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [templatePriority.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;

    [templatePriority addSubview:priorityTableView];
    
    priorityTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [priorityTableView.topAnchor constraintEqualToAnchor:templatePriority.topAnchor].active = YES;
    [priorityTableView.bottomAnchor constraintEqualToAnchor:templatePriority.bottomAnchor].active = YES;
    [priorityTableView.leadingAnchor constraintEqualToAnchor:templatePriority.leadingAnchor constant:20].active = YES;
    [priorityTableView.trailingAnchor constraintEqualToAnchor:templatePriority.trailingAnchor constant:-20].active = YES;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdPriority forIndexPath:indexPath];
    if (indexPath.row == result) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"None";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"Low";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"Medium";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"High";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [priorityTableView reloadData];
    for (int i = 0; i<=4; i++) {
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:newIndexPath];
        if (i == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            priorityText = cell.textLabel.text;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    result = (int) indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [delegate priorityData:result priorityText:priorityText];
}


@end
