//
//  TodoTableViewCell.m
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import "TodoTableViewCell.h"
#import "TodoListModel.h"

@implementation TodoTableViewCell

- (void)configureCell:(TodoListModel*) item{
    _activityTodo.text = item.name;
    _descTodo.text = item.desc;
    if (![item.image isEqual:@""]) {
        _imageTodo.image = [self decodeBase64ToImage:item.image];
        NSLog(@"LOG GAMBAR");
    } else {
        _imageTodo.image = nil;
    }
    if (item.isComplete) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    if (![item.date isEqualToString:@""]) {
        _dateTodo.text = item.date;
        _dateTodo.textColor = [UIColor blackColor];
    }
    if (![item.time isEqualToString:@""]) {
        _timeTodo.text = item.time;
        _timeTodo.textColor = [UIColor blackColor];
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

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
  NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
  return [UIImage imageWithData:data];
}

@end
