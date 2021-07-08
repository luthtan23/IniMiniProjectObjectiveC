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
#import "RotateImage.h"

@interface AddItemViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation AddItemViewController

@synthesize delegate, simpleTableView, datePicker, imageButton, itemEdit;

NSString *cellIdStatic = @"cellId", *titleText, *descText, *dateText, *timeText, *base64Str = @"";
NSArray* array;
NSInteger firstRow = 0, secondRow = 1, thirdRow = 2, priority = 0, heightDateExpandable = 0, heightTimeExpandable = 0;
BOOL collapse = NO, switchDateStatus, switchTimeStatus, isExpandableDate = NO, isExpandableTime = NO;
TodoListModel *item;
int sizeExpandDate = 330, sizeExpandTime = 54;
UIImage *editImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Add Item";
    
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    
    NSString *titleRightButton = @"SAVE";
        
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAddItem:)];
    
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
    
    if (itemEdit != nil) {
        if (itemEdit.isEdit) {
            self.navigationItem.title = @"Edit Item";
            editImage = [self decodeBase64ToImage:itemEdit.image];
            if (!(itemEdit.date.length == 0) || ![itemEdit.date isEqualToString:@""]) switchDateStatus = YES;
            if (!(itemEdit.time.length == 0) || ![itemEdit.time isEqualToString:@""]) switchTimeStatus = YES;
            dateText = itemEdit.date;
            timeText = itemEdit.time;
            base64Str = itemEdit.image;
        }
    } else {
        item = [[TodoListModel alloc] init];
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

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void) addItem:(UIBarButtonItem *) sender {
    [self setTextFieldValue:firstRow];
    [self setTextFieldValue:secondRow];
    if (![titleText  isEqual: @""]) {
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

- (void) setTextFieldValue:(NSInteger) rowAt{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowAt inSection:0];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    cell.activityTodo.delegate = self;
    if (rowAt == firstRow) {
        titleText = cell.activityTodo.text;
    }
    if (rowAt == secondRow) {
        descText = cell.activityTodo.text;
    }
}

- (void) cancelAddItem:(UIBarButtonItem *) sender {
    [self setCancelDialog];
}

- (void) setCancelDialog{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Discard Changes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) setConstraint{
    
    [self.view addSubview:simpleTableView];
    
    simpleTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [simpleTableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [simpleTableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [simpleTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20].active = YES;
    [simpleTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20].active = YES;
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *defaultSection = nil;
    if (section == 3) {
        return @"Add Image Activity";
    }
    return defaultSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSInteger defaultSection = 0;
     if (indexPath.section == 3) {
         return 300;
     } else if (indexPath.section == 1) {
         if (indexPath.row == 1) {
             return heightDateExpandable;
         } else if (indexPath.row == 3) {
             return heightTimeExpandable;
         } else {
             return 54;
         }
     } else {
         return 54;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddItemTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdStatic forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.activityTodo.delegate = self;
        [cell configureCell];
        if (indexPath.row == 0) cell.activityTodo.placeholder = @"Title";
        if (indexPath.row == 1) cell.activityTodo.placeholder = @"Description";
        if (itemEdit.isEdit) {
            if (indexPath.row == 0) cell.activityTodo.text = itemEdit.name;
            if (indexPath.row == 1) cell.activityTodo.text = itemEdit.desc;
        }
    } else if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ItemTableCell *itemTable = [[ItemTableCell alloc] init];
        itemTable = array[indexPath.row];
        [cell configureSectionTwo:itemTable];
        if (indexPath.row == 0) {
            [cell.switchItemTable addTarget:self action:@selector(setStatusSwitchRow0:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            if (itemEdit != nil) {
                if (![dateText isEqualToString:@""]) {
                    [cell.switchItemTable setOn:YES animated:YES];
                    cell.titleItemTable.text = dateText;
                }
                else [cell.switchItemTable setOn:NO animated:YES];
            } else [cell.switchItemTable setOn:NO animated:YES];
        }
        if (indexPath.row == 1) {
            [self setDateExpandable: cell];
            [cell configureImageActivity];
        }
        if (indexPath.row == 2) {
            [cell.switchItemTable addTarget:self action:@selector(setStatusSwitchRow1:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            if (itemEdit != nil) {
                if (![timeText isEqualToString:@""]) {
                    [cell.switchItemTable setOn:YES animated:YES];
                    cell.titleItemTable.text = timeText;
                }
                else [cell.switchItemTable setOn:NO animated:YES];
            } else [cell.switchItemTable setOn:NO animated:YES];
        }
        if (indexPath.row == 3) {
            [self setTimeExpandable: cell];
            [cell configureImageActivity];
        }
    } else if (indexPath.section == 2) {
        if (itemEdit != nil) [cell configurePriority:item.priority];
        else [cell configurePriority:priority];
    } else if (indexPath.section == 3) {
        [cell configureImageActivity];
        [self setButtonImageSelected:cell];
        if (itemEdit != nil) {
            if (!(editImage == nil)) {
                [imageButton setImage:editImage forState:UIControlStateNormal];
                imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageButton.imageView.layer.transform = CATransform3DMakeScale(1, 1, 1);
            } else {
                [imageButton setImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];
                imageButton.imageView.layer.transform = CATransform3DMakeScale(3, 3, 3);
                imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (void) setValueItemTableCell {
    array = @[
        [[ItemTableCell alloc] initWithTitle:@"Date" detail:@"detail" imageItemTable:@"calendar"],
        [[ItemTableCell alloc] initWithTitle:@"" detail:@"" imageItemTable:@"timer"],
        [[ItemTableCell alloc] initWithTitle:@"Time" detail:@"detail" imageItemTable:@"clock"],
        [[ItemTableCell alloc] initWithTitle:@"" detail:@"" imageItemTable:@"clock"]
    ];
}

- (void) setStatusSwitchRow0:(UIButton*) sender withEvent:(UIEvent *) event{
    [simpleTableView beginUpdates];
    [self hideKeyboard];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    switchDateStatus = !switchDateStatus;
    if (switchDateStatus) {
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        dateText = [dateFormatter stringFromDate:today];
        [self setDateField:firstRow canceling:NO];
        heightDateExpandable = sizeExpandDate;
        
    } else {
        NSLog(@"TEST BUTTON ACTIVE");
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

- (void) setStatusSwitchRow1:(UIButton*) sender withEvent:(UIEvent *) event{
    [simpleTableView beginUpdates];
    [self hideKeyboard];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    switchTimeStatus = !switchTimeStatus;
    if (switchTimeStatus) {
        [cell.switchItemTable setOn:YES animated:YES];
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        timeText = [dateFormatter stringFromDate:today];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        dateText = [dateFormatter stringFromDate:today];
        switchDateStatus = YES;
        [self setDateField:firstRow canceling:NO];
        [self setDateField:thirdRow canceling:NO];
        heightTimeExpandable = sizeExpandTime;
    } else {
        NSLog(@"TEST BUTTON ACTIVE");
        [self setDateField:thirdRow canceling:YES];
        timeText = @"";
        heightTimeExpandable = 0;
    }
    [simpleTableView endUpdates];
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    dateText = [dateFormatter stringFromDate:datePicker.date];
    [self setDateField:firstRow canceling:NO];
}

- (void) timePickerChanged:(UIDatePicker *)datePicker{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    timeText = [dateFormatter stringFromDate:datePicker.date];
    [self setDateField:thirdRow canceling:NO];
}

- (void) setDateField:(NSInteger) rowAt canceling:(BOOL) cancel{
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

- (void) priorityData:(NSInteger) priorityInt priorityText:(NSString*) priorityText{
    priority = priorityInt;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    cell.labelPriority.text = priorityText;
}

- (void)toDoAddImageBtnAction:(id)sender {
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
                                 self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                                self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                                [self presentViewController:self.imagePicker animated:YES completion:nil];
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageButton setImage:image forState:UIControlStateNormal];
    imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageButton.imageView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        RotateImage *rotate = [[RotateImage alloc] init];
        image = [rotate scaleAndRotateImage:image];
    }
    NSData *imagedata = UIImagePNGRepresentation(image);
    NSString *base64 = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    base64Str = base64;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setButtonImageSelected:(AddItemTableTableViewCell* ) cell {
    imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
    [imageButton setImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];
    imageButton.imageView.layer.transform = CATransform3DMakeScale(3, 3, 3);
    imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageButton addTarget:self action:@selector(toDoAddImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:imageButton];
}

- (void) setDateExpandable:(AddItemTableTableViewCell* ) cell {
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(8, 0, cell.contentView.bounds.size.width, sizeExpandDate)];
    if (@available(iOS 14.0, *)) {
        datePicker.preferredDatePickerStyle = UIDatePickerStyleInline;
    }
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    if (![dateText isEqual:@""]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateBefore =[dateFormatter dateFromString:dateText];
        [datePicker setDate:dateBefore];
    }
    [cell.contentView addSubview:datePicker];
}

- (void) setTimeExpandable:(AddItemTableTableViewCell* ) cell {
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(8, 0, cell.contentView.bounds.size.width, sizeExpandTime)];
    if (@available(iOS 14.0, *)) {
        datePicker.preferredDatePickerStyle = UIDatePickerStyleInline;
    }
    [datePicker setDatePickerMode:UIDatePickerModeTime];
    [datePicker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
    if (![timeText isEqual:@""]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSDate *dateBefore =[dateFormatter dateFromString:timeText];
        [datePicker setDate:dateBefore];
    }
    [cell.contentView addSubview:datePicker];
}



- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
  NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
  return [UIImage imageWithData:data];
}

-(BOOL) textLimit:(NSString* ) existingText newText:(NSString*) newString limit:(NSInteger) limit{
    NSString* text = existingText ?: @"";
    BOOL isLimit = text.length + newString.length <= limit;
    return isLimit;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [self textLimit:textField.text newText:string limit:10];
}


    
@end
