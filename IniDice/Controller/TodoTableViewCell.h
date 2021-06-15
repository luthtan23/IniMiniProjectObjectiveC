//
//  TodoTableViewCell.h
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageTodo;
@property (weak, nonatomic) IBOutlet UILabel *activityTodo;
@property (weak, nonatomic) IBOutlet UILabel *timeTodo;
@property (weak, nonatomic) IBOutlet UILabel *dateTodo;
@property (weak, nonatomic) IBOutlet UILabel *descTodo;

- (void)configureCell:(NSDictionary *) item;

@end

NS_ASSUME_NONNULL_END
