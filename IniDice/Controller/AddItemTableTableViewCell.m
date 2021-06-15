//
//  AddItemTableTableViewCell.m
//  IniDice
//
//  Created by iei19100004 on 14/06/21.
//

#import "AddItemTableTableViewCell.h"

@implementation AddItemTableTableViewCell

@synthesize activityTodo;

- (void) configureCell {
    activityTodo = [[UITextField alloc]initWithFrame:CGRectMake(16, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
//    activityTodo = (UITextField*) [self.contentView viewWithTag:self.]
    activityTodo.textColor = [UIColor blackColor];
    [self.contentView addSubview:activityTodo];
    [self setHidenAttribute:false];
}

-(void) configureSectionTwo:(ItemTableCell*) item {
    _titleItemTable.text = item.title;
    _imageItemTable.image = [UIImage systemImageNamed:item.imageItemTable];
}

- (void) configureImageActivity {
    [self setHidenAttribute:false];
    
}

- (void) configurePriority {
    UILabel *priority = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, self.contentView.frame.size.height)];
    priority.text = @"Priority";
    [self.contentView addSubview:priority];
    [self setHidenAttribute:true];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setHidenAttribute:(BOOL) rowAtFour {
    if (rowAtFour) {
        _labelPriority.alpha = 1;
        _imageToPriority.alpha = 1;
    } else {
        _labelPriority.hidden = YES;
        _imageToPriority.hidden = YES;
    }
    _switchItemTable.enabled = NO;
    _titleItemTable.hidden = YES;
    _imageItemTable.hidden = YES;
    [_switchItemTable removeFromSuperview];
    _titleItemTable.enabled = NO;
}

@end
