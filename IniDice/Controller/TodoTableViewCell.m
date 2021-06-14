//
//  TodoTableViewCell.m
//  IniDice
//
//  Created by iei19100004 on 08/06/21.
//

#import "TodoTableViewCell.h"

@implementation TodoTableViewCell

- (void)configureCell:(NSDictionary*) item{
    _activityTodo.text = item[@"name"];
    _timeTodo.text = item[@"time"];
    if (![item[@"image"] isEqual:@""]) {
        _imageTodo.image = [self decodeBase64ToImage:item[@"image"]];
        NSLog(@"LOG GAMBAR");
    } else {
        _imageTodo.image = nil;
    }
    if ([item[@"completed"] boolValue]) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            self.accessoryType = UITableViewCellAccessoryNone;
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
