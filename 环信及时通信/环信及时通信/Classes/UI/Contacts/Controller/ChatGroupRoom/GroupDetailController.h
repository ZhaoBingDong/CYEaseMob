#import <UIKit/UIKit.h>
@class ChatDetailActionView;
/**
 *  群组详情的控制器
 */
@interface GroupDetailController : UIViewController
/**
 *  群组信息的模型
 */
@property(nonatomic,strong)EMGroup *emgroup;
/**
 *  表视图
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *   数据源数组
 */
@property(nonatomic,strong)NSMutableArray *dataArray;
/**
 *  actionView
 */
@property(nonatomic,strong)ChatDetailActionView *actionView;


@end