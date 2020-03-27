//
//  Utilities.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/27/20.
//

#import "Utilities.h"

@implementation Utilities

+ (NSArray *)generate:(int)n randomUniqueNumbersBetween:(int)lowerLimit upperLimit:(int)upperLimit {
  NSMutableArray *randomNumberArray = [NSMutableArray arrayWithCapacity: upperLimit - lowerLimit];
  for (int i = lowerLimit; i < upperLimit; i++) {
    [randomNumberArray addObject:@(i)];
  }
  for (NSUInteger i = 0; i < [randomNumberArray count]; i++) {
    int countAsInt =  (int)[randomNumberArray count];
    int j = arc4random_uniform(countAsInt);
    NSNumber *jNumber = randomNumberArray[j];
    NSNumber *iNumber = randomNumberArray[i];
    randomNumberArray[j] = iNumber;
    randomNumberArray[i] = jNumber;
  }
  return [randomNumberArray subarrayWithRange: NSMakeRange(0, n)];
}

+ (NSString *)fullPath: (NSString *)fileName {
  NSString *basePath = @"https://clientupdate-v6.cursecdn.com/Avatars/";
  NSString *fullPath = [basePath stringByAppendingString: fileName];
  return fullPath;
}
@end
