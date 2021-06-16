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

- (void) configurePriority:(NSInteger) result {
    UILabel *priority = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, self.contentView.frame.size.height)];
    if (result == 0) _labelPriority.text = @"None";
    else if (result == 1) _labelPriority.text = @"Low";
    else if (result == 2) _labelPriority.text = @"Medium";
    else if (result == 3) _labelPriority.text = @"High";
    priority.text = @"Priority";
    [self.contentView addSubview:priority];
    [self setHidenAttribute:true];
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
