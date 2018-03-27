//
//  XSYEntityDetailRouter.m
//  ingage
//
//  Created by 郭源 on 2018/3/9周五.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEntityDetailRouter.h"
#import "XSYControllerKeyValueInterface.h"
#import "OrderForm.h"
#import "VisitRouteModel.h"
#import "Product.h"

@interface XSYEntityDetailRouter ()

@property (readonly, nonatomic, strong) UINavigationController *navigationController;

@end

@implementation XSYEntityDetailRouter

- (instancetype)initWithNavigationController:(UINavigationController *)controller {
    if (self = [super init]) {
        _navigationController = controller;
        _routerCompletedType = [XSYListenable listenableWithValue:@(XSYRouterCompletedTypeNone) setterAction:^(NSNumber *_Nonnull type) {

        }];
    }
    return self;
}

- (UIViewController *)topViewController {
    return self.navigationController.topViewController;
}

- (void)perform:(Class)targetClass configuration:(XSYRouteType (^)(id))configurationBlock {
    UIViewController *controller = [[targetClass alloc] init];
    XSYRouteType routeType = configurationBlock(controller);
    switch (routeType) {
        case XSYRouteTypePush:
            [self.navigationController pushViewController:controller animated:YES];
            break;
        case XSYRouteTypePresent:
            [self.navigationController presentViewController:controller animated:YES completion:^{

            }];
    }
}

@end

@implementation XSYEntityDetailRouter (DetailPerform)

- (void)performWithDataModel:(XSYDetailObjectApiDataModel *)dataModel {
    NSString *apiKey = dataModel.apiKey;
    itemType type = [dataModel.itemType integerValue];
    NSString *value = [[dataModel.data valueForKey:apiKey]description];
    NSMutableDictionary *keyValueDict = [NSMutableDictionary new];
    NSInteger referObjectId = [dataModel.referObjectId integerValue];
    NSString *controllerClass = @"";
    
    switch (type) {
        case ITEM_TYPE_PHONE:
        {
            [viewTool telClick:value message:YES sheetDelegate:[viewTool getMainController]];
        }
            break;
        case ITEM_TYPE_EMAIl:
        {
            [viewTool sendEmail:value sheetDelegate:[viewTool getMainController]];
        }
            break;
        case ITEM_TYPE_LINK:
        {
            if (![ingageTool isHttpAddress:value]) return;
            NSString *httpLink = [ingageTool appendHttp:value];
            controllerClass = @"QRScanURLViewController";
            [keyValueDict setObject:value forKey:@"requestUrl"];
        }
            break;
        case ITEM_TYPE_RELATION:
        {
            switch (referObjectId) {
                case ENTITY_BELONG_ACCOUNT: //客户
                {
                    controllerClass = @"AccountIndexViewController";
                    [keyValueDict setObject:value forKey:@"accountId"];
                    [keyValueDict setObject:MENU_KEY_ACCOUNT forKey:@"currentMenuName"];
                }
                    break;
                case ENTITY_BELONG_CONTACT: //联系人
                {
                    controllerClass = @"ContactIndexViewController";
                    [keyValueDict setObject:value forKey:@"contactId"];
                    [keyValueDict setObject:MENU_KEY_CONTACT forKey:@"currentMenuName"];
                }
                    break;
                case ENTITY_BELONG_OPPORTUNITY: //商机
                {
                    controllerClass = @"OpportunityIndexViewController";
                    [keyValueDict setObject:value forKey:@"opportunityId"];
                }
                    break;
                case ENTITY_BELONG_PRODUCT: //产品
                {
                    controllerClass = @"ProductDetailViewController";
                    Product *product = [[Product alloc] init];
                    product.productId = value;
                    product.name = [[dataModel.data valueForKey:@"referObjectId-name"]description];
                    [keyValueDict setObject:product forKey:@"productData"];
                }
                    break;
                case ENTITY_BELONG_CAMPAIGN: //市场活动
                {
                    controllerClass = @"CampaignIndexNewViewController";
                    [keyValueDict setObject:value forKey:@"campaignId"];
                }
                    break;
                case ENTITY_BELONG_PARTNER: //合作伙伴
                {
                    controllerClass = @"PartnerIndexController";
                    [keyValueDict setObject:value forKey:@"partnerId"];
                    NSString *parterName = [[dataModel.data valueForKey:@"referObjectId-name"]description];
                    [keyValueDict setObject:parterName forKey:@"parnterName"];
                }
                    break;
                case ENTITY_BELONG_LEAD: //销售线索
                {
                    controllerClass = @"LeadsIndexViewController";
                    [keyValueDict setObject:value forKey:@"leadId"];
                }
                    break;
                case ENTITY_BELONG_CONTRACT: //合同
                {
                    controllerClass = @"ContractIndexViewController";
                    [keyValueDict setObject:value forKey:@"contractId"];
                }
                    break;
                case ENTITY_BELONG_ORDER: //订单
                {
                    controllerClass = @"OrderFormIndexViewController";
                    OrderForm *orderForm = [[OrderForm alloc] init];
                    orderForm.orderFormId = value;
                    [keyValueDict setObject:orderForm forKey:@"orderForm"];
                    [keyValueDict setObject:MENU_KEY_ORDER forKey:@"currentMenuName"];
                }
                    break;
                case ENTITY_BELONG_USER: //用户
                {
                    controllerClass = @"UserNewViewController";
                    [keyValueDict setObject:value forKey:@"uid"];
                }
                    break;
                case ENTITY_BELONG_PAYMENTRECORD: //回款记录
                {
                    controllerClass = @"PaymentRecordIndexViewController";
                    [keyValueDict setObject:value forKey:@"paymentRecordId"];
                    [keyValueDict setObject:MENU_KEY_PAYMENTRECORD forKey:@"currentMenuName"];
                }
                    break;
                case ENTITY_BELONG_PAYMENTPLAN: //回款计划
                {
                    controllerClass = @"PaymentPlanIndexViewController";
                    [keyValueDict setObject:value forKey:@"paymentPlanId"];
                    [keyValueDict setObject:MENU_KEY_PAYMENTPLAN forKey:@"currentMenuName"];
                }

                    break;
                case ENTITY_BELONG_VISIT_ROUTE: //拜访路线
                {
                    controllerClass = @"VisitRouteDetailViewController";
                    VisitRoute *route = [[VisitRoute alloc] init];
                    route.name = [[dataModel.data valueForKey:@"referObjectId-name"]description];
                    route.routeId = value;
                    [keyValueDict setObject:route forKey:@"route"];
                }
                    break;
                default://自定义
                {
                    //                    [self toCustomIndexViewControllerWithItem:it];
                }
                    break;
            }
        }
            break;
            
        default:
            break;
    }
//    if ([serverName isEqualToString:@"expireTime"]) {
//        [self handleAlertTime];
//    }
//    if ([handler.serverName isEqualToString:@"approvalStatus"] && [self hasApprovalHistory]) {
//        [self toApprovalHistroy];
//    } else if ([serverName isEqualToString:@"address"]) {
//        [self toMap:handler.value];
//    }
    
    [self perform:NSClassFromString(controllerClass) configuration:^XSYRouteType(UIViewController<XSYControllerKeyValueInterface> *controller) {
        controller.keyValueDict = keyValueDict;
        return XSYRouteTypePush;
    }];
}

@end
