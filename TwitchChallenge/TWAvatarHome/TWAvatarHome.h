//
//  TWAvatarHome.h
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWAvatarHome : NSObject

// Method / Functions
- (void)loadGameAndAvatars;

- (void)listGamesAndAvatars;

- (void) loadRandomAvatars: (NSString*) game;

@property (nonatomic, strong) NSMutableDictionary *gameMapperDictionary;

@end

NS_ASSUME_NONNULL_END
