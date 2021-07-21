//
//  Util.h
//  IniDice
//
//  Created by iei19100004 on 12/07/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Util : NSObject

- (NSDateFormatter*) dateFormatter;
- (NSDateFormatter*) timeFormatter;
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
- (NSString*)encodeImageToBase64:(UIImage *)image;
- (UIImage *) scaleAndRotateImage: (UIImage *)image;

@end

NS_ASSUME_NONNULL_END
