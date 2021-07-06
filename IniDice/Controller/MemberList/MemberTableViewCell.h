//
//  MemberTableViewCell.h
//  IniDice
//
//  Created by iei19100004 on 03/06/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UIImageView *memberImage;
@property (weak, nonatomic) IBOutlet UILabel *memberRole;

@end

NS_ASSUME_NONNULL_END
