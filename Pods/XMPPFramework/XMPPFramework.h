#import "XMPP.h"

#import "XMPPReconnect.h"
#import "XMPPAutoPing.h"

#import "XMPPRoster.h"
#import "XMPPRosterMemoryStorage.h"  //遵循 XMPPRosterStorage接口
#import "XMPPUserMemoryStorageObject.h" //遵循 XMPPUser接口

//聊天记录模块的导入
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject.h" //最近联系人
#import "XMPPMessageArchiving_Message_CoreDataObject.h"

//文件传输
//接收文件
#import "XMPPIncomingFileTransfer.h"
//发送文件
#import "XMPPOutgoingFileTransfer.h"

//电子名片
#import "XMPPvCardTempModule.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardCoreDataStorage.h"
