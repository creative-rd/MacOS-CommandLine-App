//
//  Utilities.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utilities : NSObject

+ (NSArray *)generate:(int)n randomUniqueNumbersBetween:(int)lowerLimit upperLimit:(int)upperLimit  previousArrayObjects:(NSArray*) prevArray;

+ (NSString *)fullPath: (NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
