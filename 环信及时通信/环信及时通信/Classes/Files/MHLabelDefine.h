//
//  MHLabelDefine.h
//  PerfectProject
//
//  Created by Meng huan on 14/12/4.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#ifndef PerfectProject_MHLabelDefine_h
#define PerfectProject_MHLabelDefine_h


/// 所有UILabel的textAlignment属性，都用以下宏定义赋值


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
#   define DEF_TextAlignmentCenter              NSTextAlignmentCenter
#   define DEF_TextAlignmentLeft                NSTextAlignmentLeft
#   define DEF_TextAlignmentRight               NSTextAlignmentRight
#   define DEF_LineBreakByWordWrapping          NSLineBreakByWordWrapping
#   define DEF_LineBreakByCharWrapping          NSLineBreakByCharWrapping
#   define DEF_LineBreakByClipping              NSLineBreakByClipping
#   define DEF_LineBreakByTruncatingHead        NSLineBreakByTruncatingHead
#   define DEF_LineBreakByTruncatingMiddle      NSLineBreakByTruncatingMiddle
#   define DEF_LineBreakByTruncatingTail        NSLineBreakByTruncatingTail
#else // older versions
#   define DEF_TextAlignmentCenter              UITextAlignmentCenter
#   define DEF_TextAlignmentLeft                UITextAlignmentLeft
#   define DEF_TextAlignmentRight               UITextAlignmentRight
#   define DEF_LineBreakByWordWrapping          UILineBreakModeWordWrap
#   define DEF_LineBreakByCharWrapping          UILineBreakModeCharacterWrap
#   define DEF_LineBreakByClipping              UILineBreakModeClip
#   define DEF_LineBreakByTruncatingHead        UILineBreakModeHeadTruncation
#   define DEF_LineBreakByTruncatingMiddle      UILineBreakModeMiddleTruncation
#   define DEF_LineBreakByTruncatingTail        UILineBreakModeTailTruncation
#endif



#endif
