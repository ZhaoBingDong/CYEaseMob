//
//  ChatMessageBodies.h
//  环信及时通信
//
//  Created by dabing on 15/10/10.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  聊天消息体的模型
 */
@interface ChatMessageBodies : NSObject
/**
 *  text
 */
@property(nonatomic,copy)NSString *text;
/**
 *  type
 */
@property(nonatomic,assign)MessageBodyType messageBodyType;

/**
 *  大图的路径
 */
@property(nonatomic,copy)NSString *remotePath;

/**
 *  大图本地路径
 */
@property(nonatomic,copy)NSString *localPath;

/**
 *  大图的宽
 */
@property(nonatomic,assign)float localWidth;

/**
 *  大图的高
 */
@property(nonatomic,assign)float localHeight;

/**
 *  小图的路径
 */
@property(nonatomic,copy)NSString *thumbnailRemotePath;

/**
 *  thumbnailWidth
 */
@property(nonatomic,assign)float thumbnailWidth;
/**
 *  thumbnailHeight
 */
@property(nonatomic,assign)float thumbnailHeight;
/**
 *  小图本地的路径
 */
@property(nonatomic,copy)NSString *thumbnailLocalPath;
/**
 *  latitude
 */
@property(nonatomic,assign)float  latitude;
/**
 *  longitude
 */
@property(nonatomic,assign)float  longitude;
/**
 *  address
 */
@property(nonatomic,copy)NSString   *address;


/**
 *  voiceRemotePath
 */
@property(nonatomic,copy)NSString   *voiceRemotePath;
/**
 *  voicelocalPath
 */
@property(nonatomic,copy)NSString   *voicelocalPath;
/**
 *  secretKey
 */
@property(nonatomic,copy)NSString   *secretKey;
/**
 *  fileLength
 */
@property(nonatomic,assign)NSInteger  fileLength;
/**
 *  duration
 */
@property(nonatomic,assign)NSInteger duration;









@end
