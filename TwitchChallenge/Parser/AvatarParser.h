//
//  AvatarParser.h
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import <Foundation/Foundation.h>
#import "GameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AvatarParser : NSObject

// Initializer

-(instancetype)initWithJSONData:(NSArray *) array;

// Properties
-(NSArray*) gameModelData;

@end

NS_ASSUME_NONNULL_END
