//
//  Utilities.h
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/27/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utilities : NSObject

+ (NSArray *)generate:(int)n randomUniqueNumbersBetween:(int)lowerLimit upperLimit:(int)upperLimit;

+ (NSString *)fullPath: (NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
