//
//  ItemTableCell.m
//  IniDice
//
//  Created by iei19100004 on 14/06/21.
//

#import "ItemTableCell.h"

@implementation ItemTableCell

@synthesize title, detail, imageItemTable;

-(id) initWithTitle:(NSString *)title detail:(NSString *)detail imageItemTable:(NSString *)imageItemTable{
    self.title = title;
    self.detail = detail;
    self.imageItemTable = imageItemTable;
    return self;
}

@end
