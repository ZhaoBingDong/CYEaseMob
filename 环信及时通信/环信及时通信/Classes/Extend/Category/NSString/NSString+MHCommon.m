//
//  NSString+MHCommon.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "NSString+MHCommon.h"

// MD5加密
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (MHCommon)

#pragma mark - 过滤html特殊字符
- (NSString *)ignoreHTMLSpecialString
{
    NSString *returnStr = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
  
    
    return returnStr;
}



#pragma mark - MD5加密
- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    // 先转MD5，再转大写
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - URL编码
- (NSString *)urlCodingToUTF8
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - URL解码
- (NSString *)urlDecodingToUrlString
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
/**
 *  动态计算文字大小
 *
 *  @param font   字体
 *  @param width  限制宽度
 *  @param string 文字内容
 *
 *  @return 返回大小
 */
-(CGSize)getTextSizeWithFont:(UIFont*)font restrictWidth:(float)width     withString:(NSString*)string
{
    //动态计算文字大小
    NSDictionary *oldDict = @{NSFontAttributeName:font};
    CGSize oldPriceSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:oldDict context:nil].size;
    return oldPriceSize;
}
/**
 *  计算富文本的尺寸
 *
 *  @param width  限制宽度
 *  @param string 高度
 *
 *  @return 返回CGSize
 */
-(CGSize)getAttributedTextSizeWithRestrictWidth:(float)width  withString:(NSAttributedString*)string
{
    CGFloat titleHeight = 0.0f;
    CGFloat titleWidth  = 0.0f;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                       options:options
                                       context:nil];
    
    titleHeight = ceilf(rect.size.height);
    titleWidth  = ceilf(rect.size.width);
    CGSize size = {titleWidth,titleHeight};
    
    return size;  // 加两个像素,防止emoji被切掉.
    
}
@end
