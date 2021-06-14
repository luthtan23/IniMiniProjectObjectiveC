//
//  AddItemViewController.h
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol sendData <NSObject>

-(void) sendItem:(NSDictionary *) item;

@end

@interface AddItemViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *activityTodo;
@property (weak, nonatomic) IBOutlet UIDatePicker *timeTodo;
@property (weak, nonatomic) IBOutlet UIButton *addImageTodo;
@property (strong, nonatomic)  UIImagePickerController *imagePicker;
@property (assign) NSDictionary *itemEdit;
@property (nonatomic) int indexEdit;

@property(nonatomic, assign)id delegate;

@end

NS_ASSUME_NONNULL_END
