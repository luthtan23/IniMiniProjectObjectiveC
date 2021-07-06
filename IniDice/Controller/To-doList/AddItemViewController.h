//
//  AddItemViewController.h
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import <UIKit/UIKit.h>
#import "TodoListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol sendData <NSObject>

-(void) sendItem:(TodoListModel *) item;

@end

@interface AddItemViewController : UIViewController

@property(nonatomic, retain) UITableView *simpleTableView;
@property(nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic,retain) UIView *pickerView;
@property(nonatomic,retain) UIView *timeBackgroundView;
@property(nonatomic,retain) UIButton *pickerButton;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (assign) TodoListModel *itemEdit;

@property (strong, nonatomic) UIButton *imageButton;

@property(nonatomic, assign)id delegate;

@end

NS_ASSUME_NONNULL_END
