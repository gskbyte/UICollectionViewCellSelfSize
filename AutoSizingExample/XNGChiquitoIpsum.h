#import <UIKit/UIKit.h>

@interface XNGChiquitoIpsum : NSObject

+ (NSString*) stringWithWordCountSinceBeginning:(NSUInteger)wordCount;
+ (NSString*) stringWithWordCount:(NSUInteger)wordCount;
+ (NSString*) stringWithWordCountBetween:(NSUInteger)min and:(NSUInteger)max;

@end
