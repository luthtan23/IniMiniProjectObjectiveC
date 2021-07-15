//
//  TableStaticSettingViewController.m
//  IniCatatanC
//
//  Created by iei19100004 on 10/06/21.
//

#import "AddItemViewController.h"
#import "AddItemTableTableViewCell.h"
#import "ItemTableCell.h"
#import "PriorityViewController.h"
#import "TodoListModel.h"
#import <Photos/Photos.h>
#import "Util.h"

@interface AddItemViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAdaptivePresentationControllerDelegate>

@end

@implementation AddItemViewController

@synthesize delegate, simpleTableView, datePicker, imageButton, itemEdit;

NSString *cellIdStatic = @"cellId";
NSString *titleText;
NSString *descText;
NSString *dateText;
NSString *timeText;
NSString *titleRightButton;
NSString *base64Str = @"";
NSArray* array;
NSInteger firstRow = 0;
NSInteger secondRow = 1;
NSInteger thirdRow = 2;
NSInteger priority = 0;
NSInteger heightDateExpandable = 0;
NSInteger heightTimeExpandable = 0;
BOOL switchDateStatus = NO;
BOOL switchTimeStatus = NO;
BOOL isExpandableDate = NO;
BOOL isExpandableTime = NO;
BOOL isDateScrolling = NO;
int sizeExpandDate = 330;
int sizeExpandTime = 54;
int sizeImageTable = 300;
int sizeDefaultTable = 54;
int constantNumberSimpleTableView = 20;
UIImage *editImage;
TodoListModel *item;

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.navigationItem.title = @"Add Item";

    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
        
    titleRightButton = @"Save";
        
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAddItem:)];
    
    simpleTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    simpleTableView.delegate = self;
    simpleTableView.dataSource = self;
    simpleTableView.showsHorizontalScrollIndicator = NO;
    simpleTableView.showsVerticalScrollIndicator = NO;
    [simpleTableView registerNib:[UINib nibWithNibName:@"AddItemTableTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdStatic];
    
    [self setConstraint];
    
    array = [[NSArray alloc] init];
    
    switchDateStatus = NO;
    switchTimeStatus = NO;
    heightDateExpandable = 0;
    heightTimeExpandable = 0;
    
    editImage = [UIImage systemImageNamed:@"plus"];
    imageButton.imageView.layer.transform = CATransform3DMakeScale(3, 3, 3);
    
    if (itemEdit != nil && itemEdit.isEdit) {
        titleRightButton = @"Done";
        self.navigationItem.title = @"Edit Item";
        if (!(itemEdit.date.length == 0) || ![itemEdit.date isEqualToString:@""]) switchDateStatus = YES;
        if (!(itemEdit.time.length == 0) || ![itemEdit.time isEqualToString:@""]) switchTimeStatus = YES;
        if (![itemEdit.image isEqual:@""]) {
            editImage = [[Util new] decodeBase64ToImage:itemEdit.image];
        }
        dateText = itemEdit.date;
        timeText = itemEdit.time;
        base64Str = itemEdit.image;
        titleText = itemEdit.name;
        descText = itemEdit.desc;
        priority = itemEdit.priority;
    } else {
        item = [[TodoListModel alloc] init];
        titleText = [[NSString alloc] init];
        descText = [[NSString alloc] init];
        dateText = [[NSString alloc] init];
        timeText = [[NSString alloc] init];
        base64Str = [[NSString alloc] init];
        priority = 0;
    }
    
    [self setValueItemTableCell];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:titleRightButton style:UIBarButtonItemStyleDone target:self action:@selector(addItem:)];
    
}

- (void)viewDidAppear:(BOOL)animated {
//    self.presentationController.delegate = self;
}


- (void)hideKeyboard {
    [self.view endEditing:YES];
}

//- (void)presentationControllerDidAttemptToDismiss:(UIPresentationController *)presentationController{
//    [self setCancelDialog];
//}
//
//- (BOOL)presentationControllerShouldDismiss:(UIPresentationController *)presentationController{
//    return NO;
//}

- (void)addItem:(UIBarButtonItem *) sender {
    if (![titleText isEqual: @""]) {
        if (itemEdit.isEdit) {
            item = [[TodoListModel alloc] initWithIdTodoList:itemEdit.idTodoList name:titleText desc:descText date:dateText time:timeText priotiry:priority image:base64Str isEdit:YES indexNumber:itemEdit.indexNumber isComplete:itemEdit.isComplete];
        } else {
            item = [[TodoListModel alloc] initWithIdTodoList:0 name:titleText desc:descText date:dateText time:timeText priotiry:priority image:base64Str isEdit:NO indexNumber:0 isComplete:NO];
        }
        [delegate sendItem:item];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Please fill your Activity" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)cancelAddItem:(UIBarButtonItem *) sender {
    [self setCancelDialog];
}

- (void)setCancelDialog {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Discard Changes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.simpleTableView reloadData];

    }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setConstraint {
    
    [self.view addSubview:simpleTableView];
    
    simpleTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [simpleTableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [simpleTableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [simpleTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:constantNumberSimpleTableView].active = YES;
    [simpleTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-constantNumberSimpleTableView].active = YES;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *defaultSection = nil;
    if (section == 3) {
        return @"Add Image Activity";
    }
    return defaultSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger defaultSection = 0;
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            return heightDateExpandable;
        } else if (indexPath.row == 3) {
            return heightTimeExpandable;
        } else {
            return sizeDefaultTable;
        }
    }
    else if (indexPath.section == 3) {
        return sizeImageTable;
    } else {
        return sizeDefaultTable;
    }
    return defaultSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger defaultSection = 0;
    if (section == 0) {
        return 2;
    } else if(section == 1) {
        return 4;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    }
    return defaultSection;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)textFieldDidChangeTitleText:(UITextField *)textField {
    titleText = textField.text;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:firstRow inSection:0];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    if ([titleText isEqual:@""]) {
        cell.activityTodo.placeholder = @"Title";
    }
}

- (void)textFieldDidChangeDescText:(UITextField *)textField {
    descText = textField.text;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:secondRow inSection:0];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    if ([descText isEqual:@""]) {
        cell.activityTodo.placeholder = @"Description";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddItemTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdStatic forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.activityTodo.delegate = self;
        [cell configureCell];
        if (indexPath.row == 0) {
            [cell.activityTodo addTarget:self action:@selector(textFieldDidChangeTitleText:) forControlEvents:UIControlEventEditingChanged];
            if (titleText.length == 0 || [titleText isEqual:@""]) {
                cell.activityTodo.placeholder = @"Title";
            } else {
                cell.activityTodo.text = titleText;
            }
        }
        if (indexPath.row == 1) {
            [cell.activityTodo addTarget:self action:@selector(textFieldDidChangeDescText:) forControlEvents:UIControlEventEditingChanged];
            if (descText.length == 0 || [descText isEqual:@""]) {
                cell.activityTodo.placeholder = @"Description";
            } else {
                cell.activityTodo.text = descText;
            }
        }
    } else if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ItemTableCell *itemTable = [[ItemTableCell alloc] init];
        itemTable = array[indexPath.row];
        [cell configureSectionTwo:itemTable];
        if (indexPath.row == 0) {
            [cell.switchItemTable addTarget:self action:@selector(setStatusSwitchRow0:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            if (![dateText isEqualToString:@""]) {
                [cell.switchItemTable setOn:YES animated:YES];
                cell.titleItemTable.text = dateText;
            }
            else [cell.switchItemTable setOn:NO animated:YES];
        }
        if (indexPath.row == 1) {
            if (!isDateScrolling) {
                [self setDateExpandable: cell];
                [cell configureImageActivity];
            }
        }
        if (indexPath.row == 2) {
            [cell.switchItemTable addTarget:self action:@selector(setStatusSwitchRow1:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            if (![timeText isEqualToString:@""]) {
                [cell.switchItemTable setOn:YES animated:YES];
                cell.titleItemTable.text = timeText;
            }
            else [cell.switchItemTable setOn:NO animated:YES];
        }
        if (indexPath.row == 3) {
            if (!isDateScrolling) {
                [self setTimeExpandable: cell];
                [cell configureImageActivity];
            }
            isDateScrolling = YES;
        }
    } else if (indexPath.section == 2) {
        [cell configurePriority:priority];
    } else if (indexPath.section == 3) {
        [cell configureImageActivity];
        [self setButtonImageSelected:cell];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideKeyboard];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [simpleTableView beginUpdates];
        if (indexPath.row == 0) {
            if (![dateText isEqual:@""]) {
                if (isExpandableDate) heightDateExpandable = sizeExpandDate;
                else heightDateExpandable = 0;
                isExpandableDate = !isExpandableDate;
            }
        }
        if (indexPath.row == 2) {
            if (![timeText isEqual:@""]) {
                if (isExpandableTime) heightTimeExpandable = sizeExpandTime;
                else heightTimeExpandable = 0;
                isExpandableTime = !isExpandableTime;
            }
        }
        [simpleTableView endUpdates];
    }
    if (indexPath.section == 2) {
        PriorityViewController *priorityViewController = [[PriorityViewController alloc] init];
        priorityViewController.delegate = self;
        priorityViewController.result = priority;
        [self.navigationController pushViewController:priorityViewController animated:YES];
    }
    if (indexPath.section == 3) {
        [imageButton addTarget:self action:@selector(toDoAddImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setValueItemTableCell {
    array = @[
        [[ItemTableCell alloc] initWithTitle:@"Date" detail:@"detail" imageItemTable:@"calendar"],
        [[ItemTableCell alloc] initWithTitle:@"" detail:@"" imageItemTable:@"timer"],
        [[ItemTableCell alloc] initWithTitle:@"Time" detail:@"detail" imageItemTable:@"clock"],
        [[ItemTableCell alloc] initWithTitle:@"" detail:@"" imageItemTable:@"clock"]
    ];
}

- (void)setStatusSwitchRow0:(UIButton*) sender withEvent:(UIEvent *) event {
    [simpleTableView beginUpdates];
    [self hideKeyboard];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    switchDateStatus = !switchDateStatus;
    if (switchDateStatus) {
        NSDate *today = [NSDate date];
        dateText = [[[Util new] dateFormatter] stringFromDate:today];
        [self setDateField:firstRow canceling:NO];
        heightDateExpandable = sizeExpandDate;
        
    } else {
        NSLog(@"TEST BUTTON NOT ACTIVE");
        [self setDateField:firstRow canceling:YES];
        [self setDateField:thirdRow canceling:YES];
        [cell.switchItemTable setOn:NO animated:YES];
        dateText = @"";
        timeText = @"";
        switchTimeStatus = NO;
        heightDateExpandable = 0;
        heightTimeExpandable = 0;
    }
    [simpleTableView endUpdates];
}

- (void)setStatusSwitchRow1:(UIButton *) sender withEvent:(UIEvent *) event {
    [simpleTableView beginUpdates];
    [self hideKeyboard];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    switchTimeStatus = !switchTimeStatus;
    if (switchTimeStatus) {
        [cell.switchItemTable setOn:YES animated:YES];
        NSDate *today = [NSDate date];
        dateText = [[[Util new] dateFormatter] stringFromDate:today];
        timeText = [[[Util new] timeFormatter] stringFromDate:today];
        switchDateStatus = YES;
        [self setDateField:firstRow canceling:NO];
        [self setDateField:thirdRow canceling:NO];
        heightTimeExpandable = sizeExpandTime;
    } else {
        NSLog(@"TEST BUTTON NOT ACTIVE");
        [self setDateField:thirdRow canceling:YES];
        timeText = @"";
        heightTimeExpandable = 0;
    }
    [simpleTableView endUpdates];
}

- (void)datePickerChanged:(UIDatePicker *)datePicker {
    dateText = [[[Util new] dateFormatter] stringFromDate:datePicker.date];
    [self setDateField:firstRow canceling:NO];
}

- (void)timePickerChanged:(UIDatePicker *)datePicker {
    timeText = [[[Util new] timeFormatter] stringFromDate:datePicker.date];
    [self setDateField:thirdRow canceling:NO];
}

- (void)setDateField:(NSInteger) rowAt canceling:(BOOL) cancel {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowAt inSection:1];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    if (!cancel) {
        if (rowAt == firstRow) {
            cell.titleItemTable.text = dateText;
        }
        if (rowAt == thirdRow) {
            cell.titleItemTable.text = timeText;
        }
    } else {
        if (rowAt == firstRow) {
            cell.titleItemTable.text = @"Date";
        }
        if (rowAt == thirdRow) {
            cell.titleItemTable.text = @"Time";
        }
    }
}

- (void)priorityData:(NSInteger) priorityInt priorityText:(NSString *) priorityText {
    priority = priorityInt;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    cell.labelPriority.text = priorityText;
}

- (void)toDoAddImageBtnAction:(id) sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Photo source"
                                      message:@"Please select your photo source method"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cameraRoll = [UIAlertAction
                             actionWithTitle:@"Choose photo"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        
        UIAlertAction* camera = [UIAlertAction
                             actionWithTitle:@"Take photo"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                            {
            BOOL test = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsCameraPermission"];
            if (test) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusAuthorized) {
                    [self popCamera:alert];
                }
                else if (authStatus == AVAuthorizationStatusNotDetermined) {
                    NSLog(@"%@", @"Camera access not determined. Ask for permission.");
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if (granted) [self popCamera: alert];
                        else [self camDenied];
                    }];
                }
                else if (authStatus == AVAuthorizationStatusRestricted) {
                    NSLog(@"You've been restricted from using the camera on this device.");
                }
                else {
                    [self camDenied];

                }
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsCameraPermission"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self popCamera: alert];
            }
        }];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:cameraRoll];
        [alert addAction:camera];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    
}

- (void)popCamera:(UIViewController *) alert {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    [alert dismissViewControllerAnimated:YES completion:nil];

}

- (void)camDenied {
    NSLog(@"%@", @"Denied camera access");
    
    NSString *alertText = @"It looks like your privacy settings are preventing us from accessing your camera to do take image. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again.";
        
    UIAlertController * alert =   [UIAlertController
                                  alertControllerWithTitle:@"Permission Denied"
                                  message:alertText
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* dialog = [UIAlertAction
                             actionWithTitle:@"Go"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Next Time"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:dialog];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageButton setImage:image forState:UIControlStateNormal];
    imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageButton.imageView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        image = [[Util new] scaleAndRotateImage:image];
    }
    base64Str = [[Util new] encodeImageToBase64:image];
    editImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setButtonImageSelected:(AddItemTableTableViewCell *) cell {
    imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
    if (![base64Str isEqual:@""]) {
        imageButton.imageView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    } else {
        imageButton.imageView.layer.transform = CATransform3DMakeScale(3, 3, 3);
    }
    [imageButton setImage:editImage forState:UIControlStateNormal];
    imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageButton addTarget:self action:@selector(toDoAddImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:imageButton];
}

- (void)setDateExpandable:(AddItemTableTableViewCell *) cell {
    [simpleTableView beginUpdates];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(8, 0, cell.contentView.bounds.size.width, sizeExpandDate)];
    if (@available(iOS 14.0, *)) {
        datePicker.preferredDatePickerStyle = UIDatePickerStyleInline;
    }
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    if (![dateText isEqual:@""]) {
        NSDate *dateBefore =[[[Util new] dateFormatter] dateFromString:dateText];
        [datePicker setDate:dateBefore];
    }
    [cell.contentView addSubview:datePicker];
    [datePicker reloadInputViews];
    [simpleTableView endUpdates];
}

- (void)setTimeExpandable:(AddItemTableTableViewCell *) cell {
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(8, 0, cell.contentView.bounds.size.width, sizeExpandTime)];
    if (@available(iOS 14.0, *)) {
        datePicker.preferredDatePickerStyle = UIDatePickerStyleInline;
    }
    [datePicker setDatePickerMode:UIDatePickerModeTime];
    [datePicker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
    if (![timeText isEqual:@""]) {
        NSDate *timeBefore =[[[Util new] timeFormatter] dateFromString:timeText];
        [datePicker setDate:timeBefore];
    }
    [cell.contentView addSubview:datePicker];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    BOOL limitStatus = NO;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:firstRow inSection:1];
//    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
//    if (textField == cell.activityTodo) {
//        if (textField.text.length < 5 || string.length == 0){ return limitStatus = YES; }
//        else{ return limitStatus = NO; }
//    }
//    return limitStatus;
//}


@end
