//
//  GameModel.h
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import <Foundation/Foundation.h>
#import "AvatarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameModel : NSObject

- (instancetype) initWithGameData: (NSString *)name andRoot: (NSString *)phone andGameId: (NSInteger)gameId andAvatars: (NSArray *)avatars;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *root;
@property (nonatomic) NSInteger gameId;
@property (nonatomic) AvatarModel *object;
@property (nonatomic, strong) NSArray *avatars;

-(NSArray*) parseAvatarData;

@end

NS_ASSUME_NONNULL_END
