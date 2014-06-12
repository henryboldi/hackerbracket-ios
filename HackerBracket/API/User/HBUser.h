//
//  HBUser.h
//  HackerBracket
//
//  Created by Ryan Cohen on 6/6/14.
//  Copyright (c) 2014 HackerBracket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HackerBracket.h"

@interface HBUser : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *gravatar;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *linkedin;
@property (nonatomic, copy) NSString *twitter;
@property (nonatomic, copy) NSString *github;
@property (nonatomic, copy) NSString *site;

@property (nonatomic, copy) NSString *languages;
@property (nonatomic, copy) NSString *interests;
@property (nonatomic, copy) NSString *hackathons;

/*!
 Creates a new HBUser object.
 */
- (id)initWithId:(NSString *)userId
           email:(NSString *)email
            name:(NSString *)name
        username:(NSString *)username
        gravatar:(NSString *)gravatar
          school:(NSString *)school
        location:(NSString *)location
           phone:(NSString *)phone
        linkedin:(NSString *)linkedin
         twitter:(NSString *)twitter
          github:(NSString *)github
            site:(NSString *)site
       languages:(NSString *)languages
       interests:(NSString *)interests
      hackathons:(NSString *)hackathons;

/*!
 Returns a user object if the user was logged in successfully.
 */
+ (void)login:(NSString *)email password:(NSString *)password block:(void(^)(HBUser *user))block;

/*!
 Logs out the user.
 */
+ (void)logOutWithBlock:(void(^)(BOOL success))block;

/*!
 Gets user by id.
 */
+ (void)getUser:(NSString *)userId block:(void(^)(HBUser *user))block;

/*!
 Gets user's avatar by their id.
 */
+ (void)getUserAvatar:(NSString *)userId block:(void(^)(NSString *gravatar))block;

/*!
 Follows a user by their id.
 */
+ (void)followUser:(NSString *)userId block:(void(^)(BOOL success))block;

/*!
 Gets current users' followers.
 */
+ (void)getFollowers:(NSString *)userId block:(void(^)(NSArray *followers))block;

/*!
 Unfollows user by their id.
 */
+ (void)unfollowUser:(NSString *)userId block:(void(^)(BOOL success))block;

/*!
 Updates user.
 */
+ (void)updateUser:(NSString *)userId withInfo:(NSDictionary *)info;

@end