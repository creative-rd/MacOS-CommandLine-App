//
//  Utilities.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/27/20.
//

#import "Utilities.h"

@implementation Utilities

+ (NSArray *)generate:(int)n randomUniqueNumbersBetween:(int)lowerLimit upperLimit:(int)upperLimit  previousArrayObjects:(NSArray*) prevArray{
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
  NSArray *filteredArray = [Utilities filterUniqueElemenentFrom: randomNumberArray and: prevArray];
  if ([filteredArray count] >= n) {
    return [filteredArray subarrayWithRange: NSMakeRange(0, n)];
  }
  return randomNumberArray;
}

+ (NSArray*) filterUniqueElemenentFrom: (NSArray*) array1 and:(NSArray*) array2 {
  NSArray *filtered = [array1 filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    return ![array2 containsObject:evaluatedObject];
  }]];
  return filtered;
}

+ (NSString *)fullPath: (NSString *)fileName {
  NSString *basePath = @"https://clientupdate-v6.cursecdn.com/Avatars/";
  NSString *fullPath = [basePath stringByAppendingString: fileName];
  return fullPath;
}
@end
