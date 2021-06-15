//
//  ItemTableCell.h
//  IniDice
//
//  Created by iei19100004 on 14/06/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemTableCell : NSObject

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *detail;
@property(nonatomic, retain) NSString *imageItemTable;

-(id)initWithTitle: (NSString *)title
            detail: (NSString*) detail
    imageItemTable: (NSString*) imageItemTable;

@end

NS_ASSUME_NONNULL_END
