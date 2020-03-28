//
//  TWAvatarHome.h
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import <Foundation/Foundation.h>
#import "TWFileManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWAvatarHome : NSObject

// Method / Functions
- (void)loadGameAndAvatars;

- (void)listGamesAndAvatars;

- (void)loadRandomAvatars: (NSString*) game;

- (void)downloadAvatarsToDirectory: (NSString*) path;

- (void)processSelectedAvatar: (NSString*) selectedAvatar atPath: (NSString*)path;

@property (nonatomic, strong) NSMutableDictionary *gameMapperDictionary;

@end

NS_ASSUME_NONNULL_END
