//
//  HBUser.m
//  HackerBracket
//
//  Created by Ryan Cohen on 6/6/14.
//  Copyright (c) 2014 HackerBracket. All rights reserved.
//

#import "HBUser.h"

@implementation HBUser

#pragma mark - Init

- (id)initWithId:(NSString *)userId
           email:(NSString *)email
           admin:(BOOL)admin
             pro:(BOOL)pro
           owner:(BOOL)owner
     isFollowing:(BOOL)isFollowing
       followers:(NSNumber *)followers
       following:(NSNumber *)following
            name:(NSString *)name
        username:(NSString *)username
        gravatar:(NSURL *)gravatar
          school:(NSString *)school
        location:(NSString *)location
           phone:(NSString *)phone
        linkedin:(NSString *)linkedin
         twitter:(NSString *)twitter
          github:(NSString *)github
    personalSite:(NSString *)personalSite
       createdAt:(NSDate *)createdAt
       languages:(NSString *)languages
       interests:(NSString *)interests
             bio:(NSString *)bio
      attended:(NSString *)attended {
    
    self = [super init];
    if (self) {
        self.userId = userId;
        self.email = email;
        self.admin = admin;
        self.owner = owner;
        self.isFollowing = isFollowing;
        self.followers = followers;
        self.following = following;
        self.name = name;
        self.username = username;
        self.gravatar = gravatar;
        self.school = school;
        self.location = location;
        self.phone = phone;
        self.linkedin = linkedin;
        self.twitter = twitter;
        self.github = github;
        self.personalSite = personalSite;
        self.createdAt = createdAt;
        self.languages = languages;
        self.interests = interests;
        self.bio = bio;
        self.attended = attended;
    }
    return self;
}

#pragma mark - Login

+ (void)login:(NSString *)email password:(NSString *)password block:(void (^)(HBUser *user))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{ @"email"   : email,
                                  @"password": password };
    
    [manager POST:[NSString stringWithFormat:@"%@/login",API_BASE_URL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([operation.response statusCode] == 200) {
            NSDictionary *user = responseObject[@"user"];
            if (!user) return;
            HBUser *theUser = [[HBUser alloc]
                               initWithId:user[@"id"]
                               email:user[@"email"]
                               admin:[user[@"admin"] boolValue]
                               pro:[user[@"pro"] boolValue]
                               owner:[user[@"isOwner"] boolValue]
                               isFollowing:[responseObject[@"isFollowed"] boolValue]
                               followers:user[@"followers"]
                               following:user[@"following"]
                               name:user[@"name"]
                               username:user[@"username"]
                               gravatar:[NSURL URLWithString:user[@"gravatar"]]
                               school:user[@"school"]
                               location:user[@"location"]
                               phone:user[@"phone"]
                               linkedin:user[@"linkedIn"]
                               twitter:user[@"twitter"]
                               github:user[@"github"]
                               personalSite:user[@"personalSite"]
                               createdAt:[NSDate alloc]
                               languages:user[@"languages"]
                               interests:user[@"interests"]
                               bio:user[@"bio"]
                               attended:user[@"attended"]];

            block(theUser);
            [[NSUserDefaults standardUserDefaults] setObject:@{
                                                               @"username": theUser.username,
                                                               @"name": theUser.name,
                                                               @"gravatar": [theUser.gravatar absoluteString]
                                                               }
              forKey:@"currentUser"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

#pragma mark - Logout

+ (void)logOutWithBlock:(void(^)(BOOL success))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/logout",API_BASE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([operation.response statusCode] == 200) {
            block(true);
        } else {
            block(false);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

#pragma mark - Get User

+ (void)getUser:(NSString *)username block:(void(^)(HBUser *user))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/accounts/users/%@",API_BASE_URL,username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *user = responseObject[@"user"];
        HBUser *theUser = [[HBUser alloc]
                           initWithId:user[@"id"]
                           email:user[@"email"]
                           admin:[user[@"admin"] boolValue]
                           pro:[user[@"pro"] boolValue]
                           owner:[responseObject[@"isOwner"] boolValue]
                           isFollowing:[responseObject[@"isFollowed"] boolValue]
                           followers:user[@"followers"]
                           following:user[@"following"]
                           name:user[@"name"]
                           username:user[@"username"]
                           gravatar:[NSURL URLWithString:user[@"gravatar"]]
                           school:user[@"school"]
                           location:user[@"location"]
                           phone:user[@"phone"]
                           linkedin:user[@"linkedIn"]
                           twitter:user[@"twitter"]
                           github:user[@"github"]
                           personalSite:user[@"personalSite"]
                           createdAt:[NSDate alloc]
                           languages:user[@"languages"]
                           interests:user[@"interests"]
                           bio:user[@"bio"]
                           attended:user[@"attended"]];
        
        block(theUser);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

#pragma mark - Follow User

+ (void)followUser:(NSString *)userId block:(void(^)(BOOL success))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/accounts/users/%@/followers",API_BASE_URL, userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(true);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

#pragma mark - Unfollow User

+ (void)unfollowUser:(NSString *)userId block:(void (^)(BOOL))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager DELETE:[NSString stringWithFormat:@"%@/accounts/users/%@/followers",API_BASE_URL, userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(true);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        block(false);
    }];
}

+ (BOOL)isCurrentUser:(HBUser *)user {
    if (user.username == [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"] objectForKey:@"username"]) return YES;
    return NO;
}

+ (void)currentUserMeta:(void(^)(NSString *, NSString *, NSURL *))current updatedMeta:(void(^)(NSString *, NSString *, NSURL *))updated {
    NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"] objectForKey:@"username"];
    NSString *name = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"] objectForKey:@"name"];
    NSURL *gravatar = [NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"] objectForKey:@"gravatar"]];
    NSLog(@"found");
    NSLog(@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"] objectForKey:@"gravatar"]);
    current(username, name,gravatar);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/session",API_BASE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"found");
        NSLog(@"%@",[responseObject objectForKey:@"gravatar"]);
        updated([responseObject objectForKey:@"username"],[responseObject objectForKey:@"name"],[NSURL URLWithString:[responseObject objectForKey:@"gravatar"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

#pragma mark - Update User

+ (void)updateUser:(NSString *)userId withInfo:(NSDictionary *)info {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{ @"username"  : [info valueForKey:@"username"],
                                  @"name"      : [info valueForKey:@"name"],
                                  @"email"     : [info valueForKey:@"email"],
                                  @"school"    : [info valueForKey:@"school"],
                                  @"location"  : [info valueForKey:@"location"],
                                  @"phone"     : [info valueForKey:@"phone"],
                                  @"attended"  : [info valueForKey:@"attended"],
                                  @"languages" : [info valueForKey:@"languages"],
                                  @"interests" : [info valueForKey:@"interests"],
                                  @"phone"     : [info valueForKey:@"phone"],
                                  @"twitter"   : [info valueForKey:@"twitter"],
                                  @"personalSite" : [info valueForKey:@"personalSite"],
                                  @"linkedIn"  : [info valueForKey:@"linkedIn"],
                                  @"github"    : [info valueForKey:@"github"],
                                };
    
    [manager PUT:[NSString stringWithFormat:@"%@/accounts/users/%@",API_BASE_URL, userId] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"res: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

@end
