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

@interface AddItemViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation AddItemViewController

@synthesize delegate, simpleTableView, datePicker, pickerView, pickerButton, timeBackgroundView, imageButton, itemEdit;

NSString *cellIdStatic = @"cellId", *titleText, *descText, *dateText, *timeText, *base64Str = @"";
NSArray* array;
NSInteger firstRow = 0, secondRow = 1, priority = 0;
BOOL collapse = NO;
NSMutableArray* expandableArray;
TodoListModel *item;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Add Item";
    
    self.tabBarController.tabBar.hidden = YES;
        
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SAVE" style:UIBarButtonItemStyleDone target:self action:@selector(addItem:)];
        
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAddItem:)];
    
    simpleTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    simpleTableView.delegate = self;
    simpleTableView.dataSource = self;
    simpleTableView.showsHorizontalScrollIndicator = NO;
    simpleTableView.showsVerticalScrollIndicator = NO;
    [simpleTableView registerNib:[UINib nibWithNibName:@"AddItemTableTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdStatic];
    
    expandableArray = @[@"One", @"Two"].mutableCopy;
    
    [self setConstraint];
    
    array = [[NSArray alloc] init];
    
    
    [self setValueItemTableCell];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.delegate = self;
    
    if (itemEdit != nil) {
        if (itemEdit.isEdit) {
            self.navigationItem.title = @"Edit Item";
        }
    } else {
        item = [[TodoListModel alloc] init];
        dateText = [[NSString alloc] init];
        timeText = [[NSString alloc] init];
        base64Str = [[NSString alloc] init];
    }
    
}

- (void) addItem:(UIBarButtonItem *) sender {
    [self setTextFieldValue:firstRow];
    [self setTextFieldValue:secondRow];
    if (![titleText  isEqual: @""]) {
        if (itemEdit.isEdit) {
            item = [[TodoListModel alloc] initWithName:titleText desc:descText date:dateText time:timeText priotiry:&priority image:base64Str isEdit:YES indexNumber:itemEdit.indexNumber isComplete:itemEdit.isComplete];
        } else {
            item = [[TodoListModel alloc] initWithName:titleText desc:descText date:dateText time:timeText priotiry:&priority image:base64Str isEdit:NO indexNumber:0 isComplete:NO];
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New ToDo Item" message:@"Are you sure to cancel?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) setConstraint{
    UIView *template = [[UIView alloc] init];
    timeBackgroundView = [[UIView alloc] init];
    pickerView = [[UIView alloc] init];
    template.backgroundColor = [UIColor secondarySystemBackgroundColor];
    [self.view addSubview:template];

    template.translatesAutoresizingMaskIntoConstraints = NO;
    [template.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [template.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [template.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [template.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;


    [template addSubview:simpleTableView];
    
    simpleTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [simpleTableView.topAnchor constraintEqualToAnchor:template.topAnchor].active = YES;
    [simpleTableView.bottomAnchor constraintEqualToAnchor:template.bottomAnchor].active = YES;
    [simpleTableView.leadingAnchor constraintEqualToAnchor:template.leadingAnchor constant:20].active = YES;
    [simpleTableView.trailingAnchor constraintEqualToAnchor:template.trailingAnchor constant:-20].active = YES;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSInteger defaultSection = 0;
     if (indexPath.section == 3) {
         return 300;
     } else {
         return 54;
     }
     return defaultSection;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddItemTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdStatic forIndexPath:indexPath];
    if (indexPath.section == 0) {
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
                if (![itemEdit.date isEqualToString:@""]) {
                    [cell.switchItemTable setOn:YES animated:YES];
                    cell.titleItemTable.text = itemEdit.date;
                }
                else [cell.switchItemTable setOn:NO animated:YES];
            } else [cell.switchItemTable setOn:NO animated:YES];
        }
        if (indexPath.row == 1) {
            [cell.switchItemTable addTarget:self action:@selector(setStatusSwitchRow1:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            if (itemEdit != nil) {
                if (![itemEdit.time isEqualToString:@""]) {
                    [cell.switchItemTable setOn:YES animated:YES];
                    cell.titleItemTable.text = itemEdit.time;
                }
                else [cell.switchItemTable setOn:NO animated:YES];
            } else [cell.switchItemTable setOn:NO animated:YES];
        }
    } else if (indexPath.section == 2) {
        [cell configurePriority];
    } else if (indexPath.section == 3) {
        [cell configureImageActivity];
        [self setButtonImageSelected:cell];
        if (itemEdit != nil) {
            if (![itemEdit.image isEqualToString:@""]) {
                [imageButton setImage:[self decodeBase64ToImage:itemEdit.image] forState:UIControlStateNormal];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //expand here
        }
    }
    if (indexPath.section == 2) {
        PriorityViewController *priority = [[PriorityViewController alloc] init];
        [self.navigationController pushViewController:priority animated:YES];
    }
    if (indexPath.section == 3) {
        [imageButton addTarget:self action:@selector(toDoAddImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger defaultSection = 0;
    if (section == 0) {
        return 2;
    } else if(section == 1) {
        return 2;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    }
    return defaultSection;
}

- (void) setValueItemTableCell {
    array = @[
        [[ItemTableCell alloc] initWithTitle:@"Date" detail:@"detail" imageItemTable:@"calendar"],
        [[ItemTableCell alloc] initWithTitle:@"Time" detail:@"detail" imageItemTable:@"timer"]
        
    ];
}

- (void) datePickerAttribute:(BOOL) isDateSelected {
    pickerView.backgroundColor = [UIColor blackColor];
    pickerView.alpha = 0.5;
    [self.view addSubview:pickerView];

    pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [pickerView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [pickerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [pickerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [pickerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.preferredDatePickerStyle = UIDatePickerStyleInline;
    datePicker.backgroundColor = [UIColor whiteColor];
    
    if (isDateSelected) {
        timeBackgroundView.backgroundColor = [UIColor whiteColor];
        timeBackgroundView.center = CGPointMake(self.view.frame.size.width  / 2, self.view.frame.size.height / 2);
        
        [self.view addSubview:timeBackgroundView];
        timeBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [timeBackgroundView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:self.view.frame.size.height/2-datePicker.frame.size.height/2-30].active = YES;
        [timeBackgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-self.view.frame.size.height/2+datePicker.frame.size.height/2+30].active = YES;
        [timeBackgroundView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20].active = YES;
        [timeBackgroundView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20].active = YES;
        
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker];
        
        datePicker.translatesAutoresizingMaskIntoConstraints = NO;
        [datePicker.topAnchor constraintEqualToAnchor:timeBackgroundView.topAnchor].active = YES;
        [datePicker.bottomAnchor constraintEqualToAnchor:timeBackgroundView.bottomAnchor constant:-20].active = YES;
        [datePicker.leadingAnchor constraintEqualToAnchor:timeBackgroundView.leadingAnchor].active = YES;
        [datePicker.trailingAnchor constraintEqualToAnchor:timeBackgroundView.trailingAnchor].active = YES;
        
        
    } else {
        timeBackgroundView.backgroundColor = [UIColor whiteColor];
        timeBackgroundView.center = CGPointMake(self.view.frame.size.width  / 2, self.view.frame.size.height / 2);
        
        [self.view addSubview:timeBackgroundView];
        timeBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [timeBackgroundView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:self.view.frame.size.height/2-40].active = YES;
        [timeBackgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-self.view.frame.size.height/2+40].active = YES;
        [timeBackgroundView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20].active = YES;
        [timeBackgroundView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20].active = YES;
        
        [datePicker setDatePickerMode:UIDatePickerModeTime];
        [datePicker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
        [timeBackgroundView addSubview:datePicker];
        
        datePicker.translatesAutoresizingMaskIntoConstraints = NO;
        [datePicker.topAnchor constraintEqualToAnchor:timeBackgroundView.topAnchor constant:10].active = YES;
        [datePicker.bottomAnchor constraintEqualToAnchor:timeBackgroundView.bottomAnchor constant:-10].active = YES;
        [datePicker.leadingAnchor constraintEqualToAnchor:timeBackgroundView.leadingAnchor].active = YES;
        [datePicker.trailingAnchor constraintEqualToAnchor:timeBackgroundView.leadingAnchor constant:150].active = YES;
        
    }
    
    pickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pickerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pickerButton setTitle:@"Done" forState:UIControlStateNormal];
    pickerButton.backgroundColor = [UIColor systemBlueColor];
    [pickerButton addTarget:self action:@selector(selectedDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickerButton];
    
    if (isDateSelected) {
        pickerButton.translatesAutoresizingMaskIntoConstraints = NO;
        [pickerButton.topAnchor constraintEqualToAnchor:timeBackgroundView.bottomAnchor constant:-60].active = YES;
        [pickerButton.bottomAnchor constraintEqualToAnchor:timeBackgroundView.bottomAnchor constant:-20].active = YES;
        [pickerButton.leadingAnchor constraintEqualToAnchor:timeBackgroundView.trailingAnchor constant:-120].active = YES;
        [pickerButton.trailingAnchor constraintEqualToAnchor:timeBackgroundView.trailingAnchor constant:-20].active = YES;
        
    } else {
        pickerButton.translatesAutoresizingMaskIntoConstraints = NO;
        [pickerButton.topAnchor constraintEqualToAnchor:timeBackgroundView.topAnchor constant:20].active = YES;
        [pickerButton.bottomAnchor constraintEqualToAnchor:timeBackgroundView.bottomAnchor constant:-20].active = YES;
        [pickerButton.leadingAnchor constraintEqualToAnchor:timeBackgroundView.trailingAnchor constant:-120].active = YES;
        [pickerButton.trailingAnchor constraintEqualToAnchor:timeBackgroundView.trailingAnchor constant:-20].active = YES;
    }
    
}

- (void) setStatusSwitchRow0:(UIButton*) sender withEvent:(UIEvent *) event{
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        dateText = [dateFormatter stringFromDate:today];
        [self setDateField:firstRow canceling:NO];
        [self datePickerAttribute:YES];
    } else {
        NSLog(@"TEST BUTTON ACTIVE");
        [self setDateField:firstRow canceling:YES];
        dateText = @"";
    }
}

- (void) setStatusSwitchRow1:(UIButton*) sender withEvent:(UIEvent *) event{
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        timeText = [dateFormatter stringFromDate:today];
        [self setDateField:secondRow canceling:NO];
        [self datePickerAttribute:NO];
    } else {
        NSLog(@"TEST BUTTON ACTIVE");
        [self setDateField:secondRow canceling:YES];
        timeText = @"";
    }
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    dateText = [dateFormatter stringFromDate:datePicker.date];
    [self setDateFieldOnChanged:firstRow];
}

- (void) timePickerChanged:(UIDatePicker *)datePicker{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    timeText = [dateFormatter stringFromDate:datePicker.date];
    [self setDateFieldOnChanged:secondRow];
}

- (void) setDateField:(NSInteger) rowAt canceling:(BOOL) cancel{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowAt inSection:1];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    if (!cancel) {
        if (rowAt == firstRow) {
            cell.titleItemTable.text = dateText;
        }
        if (rowAt == secondRow) {
            cell.titleItemTable.text = timeText;
        }
    } else {
        if (rowAt == firstRow) {
            cell.titleItemTable.text = @"Date";
        }
        if (rowAt == secondRow) {
            cell.titleItemTable.text = @"Time";
        }
    }
}

- (void) setDateFieldOnChanged:(NSInteger) rowAt{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowAt inSection:1];
    AddItemTableTableViewCell *cell = [simpleTableView cellForRowAtIndexPath:indexPath];
    if (rowAt == firstRow) {
        cell.titleItemTable.text = dateText;
    }
    if (rowAt == secondRow) {
        cell.titleItemTable.text = timeText;
    }
}

- (void) selectedDatePicker:(UIButton *) sender{
    [pickerView removeFromSuperview];
    [datePicker removeFromSuperview];
    [pickerButton removeFromSuperview];
    [timeBackgroundView removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return false;
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
            self.imagePicker.showsCameraControls = NO;
            [self presentViewController:self.imagePicker animated:YES completion: ^{
                [self.imagePicker takePicture];
            }];
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
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *imagedata =  UIImagePNGRepresentation(image);
    NSString *base64 = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    base64Str = base64;
    [imageButton setImage:image forState:UIControlStateNormal];
    imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageButton.imageView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error)
        {
            UILabel *error = [[UILabel alloc] initWithFrame:CGRectMake(70, 300, self.view.frame.size.width -90, 50)];
            error.text = @"ERROR IMAGE";
            [self.view addSubview:error];
            
        }
    /*else
        [self callAlertViewWithTitle:@"Success" andMessage:@"Image saved to Photo Album"];*/
}

- (void) setButtonImageSelected:(AddItemTableTableViewCell* ) cell {
    imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
    [imageButton setImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];
    imageButton.imageView.layer.transform = CATransform3DMakeScale(3, 3, 3);
    imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageButton addTarget:self action:@selector(toDoAddImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:imageButton];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
  NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
  return [UIImage imageWithData:data];
}

    
@end
