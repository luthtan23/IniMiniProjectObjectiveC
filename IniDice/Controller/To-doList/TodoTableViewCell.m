//
//  TodoTableViewCell.m
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import "TodoTableViewCell.h"
#import "TodoListModel.h"

@implementation TodoTableViewCell

- (void)configureCell:(TodoListModel*) item image:(UIImage*)imageData{
    NSString* priorityString = @"";
    switch (item.priority) {
        case 3: priorityString = @"!!!"; break;
        case 2: priorityString = @"!!"; break;
        case 1: priorityString = @"!"; break;
        default: break;
    }
    _activityTodo.text = [NSString stringWithFormat:@"%@ %@", priorityString, item.name];
    _descTodo.text = item.desc;
    if (item.image.length == 0 || [item.image isEqual:@""]) [_imageTodo removeFromSuperview];
    else _imageTodo.image = imageData;
    if (item.isComplete) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    if (item.date.length == 0 || [item.date isEqualToString:@""]) {
        _dateTodo.text = @"none";
        _dateTodo.textColor = [UIColor secondaryLabelColor];
    } else {
        _dateTodo.text = item.date;
        _dateTodo.textColor = [UIColor colorNamed:@"text_dynamic"];
    }
    if (item.time.length == 0 || [item.time isEqualToString:@""]) {
        [_timeTodo removeFromSuperview];
        [_timeImage removeFromSuperview];
        _timeTodo.text = @"none";
        _timeTodo.textColor = [UIColor secondaryLabelColor];
    } else {
        _timeTodo.text = item.time;
        _timeTodo.textColor = [UIColor colorNamed:@"text_dynamic"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) justDateTime {
    UIView *parent = _contentViewCell;
    NSLayoutConstraint *trailing =[NSLayoutConstraint
                                    constraintWithItem:_activityTodo
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:parent
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0f
                                    constant:0.f];

    NSLayoutConstraint *leading = [NSLayoutConstraint
                                       constraintWithItem:_activityTodo
                                       attribute:NSLayoutAttributeLeading
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:parent
                                       attribute:NSLayoutAttributeLeading
                                       multiplier:1.0f
                                       constant:0.f];

    NSLayoutConstraint *bottom =[NSLayoutConstraint
                                     constraintWithItem:_activityTodo
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:parent
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                     constant:0.f];

    //Height to be fixed for SubView same as AdHeight
    NSLayoutConstraint *height = [NSLayoutConstraint
                                   constraintWithItem:_activityTodo
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:0
                                   constant:2];
    
    [parent addConstraint:trailing];
    [parent addConstraint:bottom];
    [parent addConstraint:leading];
    [_descTodo addConstraint:height];

}

@end
