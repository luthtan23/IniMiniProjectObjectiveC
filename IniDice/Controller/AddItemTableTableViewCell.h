//
//  AddItemTableTableViewCell.h
//  IniDice
//
//  Created by iei19100004 on 14/06/21.
//

#import <UIKit/UIKit.h>
#import "ItemTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddItemTableTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchItemTable;
@property (weak, nonatomic) IBOutlet UILabel *titleItemTable;
@property (weak, nonatomic) IBOutlet UIImageView *imageItemTable;
@property (weak, nonatomic) IBOutlet UIImageView *imageToPriority;
@property (weak, nonatomic) IBOutlet UILabel *labelPriority;

@property (nonatomic, retain) IBOutlet UITextField *activityTodo;
@property (strong, nonatomic) UIButton *imageButton;

- (void) configureCell;
- (void) configureSectionTwo:(ItemTableCell*) item;
- (void) configureImageActivity;
- (void) configurePriority:(NSInteger) result;

@end

NS_ASSUME_NONNULL_END
