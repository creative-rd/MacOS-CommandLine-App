//
//  AvatarParser.h
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import <Foundation/Foundation.h>
#import "TWGameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWAvatarParser : NSObject

// Initializer

-(instancetype)initWithJSONData:(NSArray *) array;

// Properties
-(NSArray*) gameModelData;

@end

NS_ASSUME_NONNULL_END
