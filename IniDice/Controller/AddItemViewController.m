//
//  AddItemViewController.m
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import "AddItemViewController.h"

@interface AddItemViewController () <UIAlertViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation AddItemViewController

@synthesize delegate, activityTodo, timeTodo, addImageTodo, itemEdit, indexEdit;

NSDictionary *item;
NSString *base64Str = @"";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Add Item";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    if (itemEdit != nil) {
        if (itemEdit[@"isEdit"]) {
            self.navigationItem.title = @"Edit Item";
            [self editItemContent];
        }
    }
    
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SAVE" style:UIBarButtonItemStyleDone target:self action:@selector(addItem:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAddItem:)];
    
    activityTodo.delegate = self;
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.delegate = self;
    
    [addImageTodo addTarget:self action:@selector(toDoAddImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) addItem:(UIBarButtonItem *) sender {
    if (![activityTodo.text  isEqual: @""]) {
        NSString *dateString = [[self setFormatterDate] stringFromDate:timeTodo.date];
        if (itemEdit[@"isEdit"]) {
            item = @{@"name" : activityTodo.text, @"time" : dateString, @"date" : @"home", @"image" : base64Str, @"indexEdit" : [NSNumber numberWithInt:indexEdit], @"isEdit" : @(true)};
        } else {
            item = @{@"name" : activityTodo.text, @"time" : dateString, @"date" : @"home", @"image" : base64Str};
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

- (void) cancelAddItem:(UIBarButtonItem *) sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New ToDo Item" message:@"Are you sure to cancel?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
    [addImageTodo setImage:image forState:UIControlStateNormal];
    addImageTodo.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) editItemContent {
    activityTodo.text = itemEdit[@"name"];
    NSDate *timeDate = [[self setFormatterDate] dateFromString:itemEdit[@"time"]];
    [timeTodo setDate:timeDate];
    if (![itemEdit[@"image"] isEqual:@""]) {
        base64Str = itemEdit[@"image"];
        [addImageTodo setImage:[self decodeBase64ToImage:itemEdit[@"image"]] forState:UIControlStateNormal];
        addImageTodo.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        [addImageTodo setImage:[UIImage imageNamed:@"add-image-image"] forState:UIControlStateNormal];
    }
    
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
  NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
  return [UIImage imageWithData:data];
}

- (NSDateFormatter*) setFormatterDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    return formatter;
}



@end
