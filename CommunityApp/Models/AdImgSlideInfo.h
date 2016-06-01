//
//  AdImgSlideInfo.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface AdImgSlideInfo : BaseModel

//@property (nonatomic, copy) NSString    *slideInfoId;   //幻灯片ID
@property (nonatomic, copy) NSString    *picPath;       //图片路径

@property (nonatomic, copy) NSString    *gmId;          //商品ID
@property (nonatomic, copy) NSString    *relatetype;    //关系类型 限时抢 3；普通商品 7；外部链接 9；物业通知 8；团购 4
@property (nonatomic, copy) NSString    *url;           //外部链接 Url

@property (nonatomic, copy) NSString    *title;         //标题

@end
