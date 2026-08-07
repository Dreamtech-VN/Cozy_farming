--ProtocolProcessorHolidayVillage.lua
--@brief    成长基金相关协议
--@date     2016/4/14
--@author   Tianxiang_Xu
--@note     成长基金相关协议


ProtocolProcessorHolidayVillage = ProtocolProcessorBase:new()


--@brief    注册协议组所有协议
--@note     注册协议组所有协议
function ProtocolProcessorHolidayVillage:regAll()
   --@brief 获取所有土坑（HOLIDAYVILLAGE_GetAllPits = 1）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetAllPits, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetAllPits_ErrorProcess", "is")
   --@brief   原石操作（HOLIDAYVILLAGE_PitStone = 5）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_PitStone, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitStone_ErrorProcess", "is")
   --@brief 商店操作（HOLIDAYVILLAGE_ShopOp = 9）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ShopOp, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ShopOp_ErrorProcess", "is")
   --@brief 操作图鉴（HOLIDAYVILLAGE_PictureOp = 11）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_PictureOp, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PictureOp_ErrorProcess", "is")
   --@brief 仓库操作（HOLIDAYVILLAGE_WarehouseOp = 13）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_WarehouseOp, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WarehouseOp_ErrorProcess", "is")
   --@brief 土坑操作（HOLIDAYVILLAGE_PitOp = 15）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_PitOp, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp_ErrorProcess", "is")
   --@brief 获取访客记录（HOLIDAYVILLAGE_GetVisitorRecord = 17）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetVisitorRecord, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetVisitorRecord_ErrorProcess", "is")
   --@brief 获取排行榜（HOLIDAYVILLAGE_GetRanks = 19）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetRanks, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetRanks_ErrorProcess", "is")
   --@brief 点赞（HOLIDAYVILLAGE_ThumbsUp = 21）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ThumbsUp, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ThumbsUp_ErrorProcess", "is")
   --@brief 进入度假村（HOLIDAYVILLAGE_HolidayVillageOp = 23）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_HolidayVillageOp, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_HolidayVillageOp_ErrorProcess", "is")
   --@brief 获取鲜花大亨榜（HOLIDAYVILLAGE_GetFlowerTycoonRanks = 34）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerTycoonRanks, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerTycoonRanks_ErrorProcess", "is")
   --@brief 获取订单大亨历届榜（HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks = 36）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks_ErrorProcess", "is")
   --@brief 获取鲜花订单（HOLIDAYVILLAGE_GetFlowerOrder = 38）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerOrder, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerOrder_ErrorProcess", "is")
   --@brief 膜拜（HOLIDAYVILLAGE_MobaiFlowerTycoon = 40）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_MobaiFlowerTycoon, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_MobaiFlowerTycoon_ErrorProcess", "is")
   --@brief 精灵升级（HOLIDAYVILLAGE_SpiritUpgrade = 42）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritUpgrade, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritUpgrade_ErrorProcess", "is")
   --@brief 精灵进阶（HOLIDAYVILLAGE_SpiritStep = 44）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritStep, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritStep_ErrorProcess", "is")
   --@brief 精灵喂养（HOLIDAYVILLAGE_SpiritFeed = 46）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritFeed, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritFeed_ErrorProcess", "is")
   --@brief 精灵详细数据（HOLIDAYVILLAGE_GetSpiritDetail = 48）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetSpiritDetail, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetSpiritDetail_ErrorProcess", "is")
   --@brief 回收精灵（HOLIDAYVILLAGE_RecoverySpirit = 52）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_RecoverySpirit, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_RecoverySpirit_ErrorProcess", "is")
   --@brief 激活精灵槽（HOLIDAYVILLAGE_ActivationSpiritSlot = 54）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ActivationSpiritSlot, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ActivationSpiritSlot_ErrorProcess", "is")
   --@brief 激活精灵（HOLIDAYVILLAGE_ActivationSpirit = 56）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ActivationSpirit, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ActivationSpirit_ErrorProcess", "is")
   --@brief 鲜花回收（HOLIDAYVILLAGE_FlowerRecovery = 58）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FlowerRecovery, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FlowerRecovery_ErrorProcess", "is")
   --@brief 装饰饰品（HOLIDAYVILLAGE_Decorations = 60）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_Decorations, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_Decorations_ErrorProcess", "is")
   --@brief 神树和果实加速（HOLIDAYVILLAGE_AccelerationOp = 62）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_AccelerationOp, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_AccelerationOp_ErrorProcess", "is")
   --@brief 果实操作（HOLIDAYVILLAGE_FruitOp = 64）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FruitOp, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FruitOp_ErrorProcess", "is")
   --@brief 请求果实列表（HOLIDAYVILLAGE_FruitList = 66）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FruitList, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FruitList_ErrorProcess", "is")
   --@brief 请求树详情（HOLIDAYVILLAGE_TreeDetails = 68）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_TreeDetails, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_TreeDetails_ErrorProcess", "is")
   --@brief 神树许愿（HOLIDAYVILLAGE_WishingTree = 70）错误处理(S->C)
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_WishingTree, "ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WishingTree_ErrorProcess", "is")

   --@brief 获取所有土坑（HOLIDAYVILLAGE_GetAllPitsOk = 2）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetAllPitsOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetAllPitsOk", "itvtvtvivivtvivivivivivivivivbvbvivsvivitvi")
   --@brief 商店操作（HOLIDAYVILLAGE_ShopOpOk = 10）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ShopOpOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ShopOpOk", "tvitvivs")
   --@brief 操作图鉴（HOLIDAYVILLAGE_PictureOpOk = 12）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_PictureOpOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_PictureOpOk", "tvivi")
   --@brief 仓库操作（HOLIDAYVILLAGE_WarehouseOpOk = 14）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_WarehouseOpOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_WarehouseOpOk", "ivivit")
   --@brief 获取访客记录（HOLIDAYVILLAGE_GetVisitorRecordOk = 18）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetVisitorRecordOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetVisitorRecordOk", "vivivtvivsvivi")
   --@brief 获取排行榜（HOLIDAYVILLAGE_GetRanksOk = 20）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetRanksOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetRanksOk", "vivivsvivivivtviviviviviviviittvb")
   --@brief 个人基础数据（HOLIDAYVILLAGE_HolidayVillageBaseInfoOk = 26）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_HolidayVillageBaseInfoOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_HolidayVillageBaseInfoOk", "iisiiitiiiiiiiiiii")
   --@brief 同步浏览者（HOLIDAYVILLAGE_HolidayVillageBrowserOk = 27）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_HolidayVillageBrowserOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_HolidayVillageBrowserOk", "vivivsvivivivtvivivsvivivivivsvst")
   --@brief 商店购买结果（HOLIDAYVILLAGE_ShopBuyResultOk = 30）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ShopBuyResultOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ShopBuyResultOk", "tiii")
   --@brief 土坑操作结果（HOLIDAYVILLAGE_PitOpResultOk = 33）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_PitOpResultOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_PitOpResultOk", "tnvivi")
   --@brief 获取鲜花大亨榜（HOLIDAYVILLAGE_GetFlowerTycoonRanksOk = 35）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerTycoonRanksOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerTycoonRanksOk", "vivivsvivivivtvivivivivivsiii")
   --@brief 获取订单大亨历届榜（HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanksOk = 37）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanksOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanksOk", "vivivivsvivivivtvivivsvivivivivsvivi")
   --@brief 获取鲜花订单（HOLIDAYVILLAGE_GetFlowerOrderOk = 39）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerOrderOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerOrderOk", "ivivivivtiiii")
   --@brief 膜拜（HOLIDAYVILLAGE_MobaiFlowerTycoonOK = 41）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_MobaiFlowerTycoonOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_MobaiFlowerTycoonOK", "iii")
   --@brief 精灵升级（HOLIDAYVILLAGE_SpiritUpgradeOK = 43）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritUpgradeOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritUpgradeOK", "")
   --@brief 精灵进阶（HOLIDAYVILLAGE_SpiritStepOK = 45）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritStepOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritStepOK", "")
   --@brief 精灵喂养（HOLIDAYVILLAGE_SpiritFeedOK = 47）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritFeedOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritFeedOK", "")
   --@brief 精灵详细数据（HOLIDAYVILLAGE_GetSpiritDetailOK = 49）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetSpiritDetailOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetSpiritDetailOK", "tivtvtvivivivivi")
   --@brief 回收精灵（HOLIDAYVILLAGE_RecoverySpiritOK = 53）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_RecoverySpiritOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_RecoverySpiritOK", "vivi")
   --@brief 激活精灵槽（HOLIDAYVILLAGE_ActivationSpiritSlotOK = 55）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ActivationSpiritSlotOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ActivationSpiritSlotOK", "")
   --@brief 激活精灵（HOLIDAYVILLAGE_ActivationSpiritOK = 57）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ActivationSpiritOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ActivationSpiritOK", "")
   --@brief 鲜花回收（HOLIDAYVILLAGE_FlowerRecoveryOK = 59）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FlowerRecoveryOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FlowerRecoveryOK", "vivivivi")
   --@brief 装饰饰品（HOLIDAYVILLAGE_DecorationsOK = 61）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_DecorationsOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_DecorationsOK", "ii")
   --@brief 神树和果实加速（HOLIDAYVILLAGE_AccelerationOpOK = 63）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_AccelerationOpOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_AccelerationOpOK", "iiii")
   --@brief 果实操作（HOLIDAYVILLAGE_FruitOpOK = 65）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FruitOpOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FruitOpOK", "iiivivi")
   --@brief 请求果实列表（HOLIDAYVILLAGE_FruitListOK = 67）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FruitListOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FruitListOK", "vivivivivi")
   --@brief 请求树详情（HOLIDAYVILLAGE_TreeDetailsOk = 69）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_TreeDetailsOk, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_TreeDetailsOk", "iivivivivi")
   --@brief 神树许愿（HOLIDAYVILLAGE_WishingTreeOK = 71）
   self:regProtocolCallbackFunction( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_WishingTreeOK, "ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_WishingTreeOK", "iivii")
end

--@brief 反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorHolidayVillage:unregAll()
   self:clearReg()
end

---------------------------------客户端到服务器协议发送方法模块----------------------------------
--@brief 获取所有土坑（HOLIDAYVILLAGE_GetAllPits = 1）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetAllPits(index)
   WZLog("send_HOLIDAYVILLAGE_GetAllPits")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetAllPits )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeByte(index) -- -1全部，0-8具体某个坑
   SendProtocol(sender,false) --true:showLoading
end

--@brief 原石操作（HOLIDAYVILLAGE_PitStone = 5）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitStone(pitIndex, position, stoneId)
   WZLog("send_HOLIDAYVILLAGE_PitStone")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_PitStone )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(pitIndex)  -- 土坑位置
   sender:writeInt(position)  -- 位置
   sender:writeInt(stoneId)   -- 石头id
   SendProtocol(sender,false) --true:showLoading
end

--@brief 商店操作（HOLIDAYVILLAGE_ShopOp = 9）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ShopOp(opType, itemId, num)
   WZLog("send_HOLIDAYVILLAGE_ShopOp")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ShopOp )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeByte(opType)   -- 1-查看种子商店，2-查看道具商店，3-购买
   sender:writeInt(itemId) -- 道具id
   sender:writeInt(num) -- 数量
   SendProtocol(sender,false) --true:showLoading
end

--@brief 操作图鉴（HOLIDAYVILLAGE_PictureOp = 11）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PictureOp(opType, plantId)
   WZLog("send_HOLIDAYVILLAGE_PictureOp")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_PictureOp )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeByte(opType)   -- 操作：1-请求图鉴数据，2-激活/升级图鉴
   sender:writeInt(plantId)   -- 植物id
   SendProtocol(sender,false) --true:showLoading
end

--@brief 仓库操作（HOLIDAYVILLAGE_WarehouseOp = 13）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WarehouseOp(opType)
   WZLog("send_HOLIDAYVILLAGE_WarehouseOp")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_WarehouseOp )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeByte(opType)   -- 0-全部，1-请求种子仓库，2-请求道具仓库
   SendProtocol(sender,false) --true:showLoading
end

--@brief 土坑操作（HOLIDAYVILLAGE_PitOp = 15）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp(playerId, opType, index, itemId)
   WZLog("send_HOLIDAYVILLAGE_PitOp", playerId, opType, index, itemId)
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_PitOp )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(playerId)  -- 被操作的玩家
   sender:writeByte(opType)   -- 执行的操作：1-播种，2-施肥，3-浇水，4-抓虫，5-收获，6-偷花，7-升级，8-挖坑，9-解锁土坑，10-花盆
   sender:writeByte(index) -- 土坑下标，从0开始
   sender:writeInt(itemId) -- 当opType=1-种子，2-肥料，10-花盆id卸下传-1
   SendProtocol(sender,false) --true:showLoading
end

--@brief 获取访客记录（HOLIDAYVILLAGE_GetVisitorRecord = 17）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetVisitorRecord()
   WZLog("send_HOLIDAYVILLAGE_GetVisitorRecord")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetVisitorRecord )
   if sender==nil then WZLog("sender == nil") return end

   SendProtocol(sender,false) --true:showLoading
end

--@brief 获取排行榜（HOLIDAYVILLAGE_GetRanks = 19）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetRanks(type, friendId)
   WZLog("send_HOLIDAYVILLAGE_GetRanks")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetRanks )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeByte(type)  -- 1-好友排名，2-全服排行榜
   sender:writeInt(friendId or -1)  -- 查找的玩家id
   SendProtocol(sender,false) --true:showLoading
end

--@brief 点赞（HOLIDAYVILLAGE_ThumbsUp = 21）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ThumbsUp(friendId)
   WZLog("send_HOLIDAYVILLAGE_ThumbsUp")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ThumbsUp )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(friendId)  -- 被点赞的玩家id
   SendProtocol(sender,false) --true:showLoading
end

--@brief 进入度假村（HOLIDAYVILLAGE_HolidayVillageOp = 23）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_HolidayVillageOp(enter, playerId)
   WZLog("send_HOLIDAYVILLAGE_HolidayVillageOp", enter, type(playerId))
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_HolidayVillageOp )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeBoolean(enter) -- 进出度假村
   sender:writeInt(playerId)  -- 谁的度假村
   SendProtocol(sender,false) --true:showLoading
end

--@brief 获取鲜花大亨榜（HOLIDAYVILLAGE_GetFlowerTycoonRanks = 34）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerTycoonRanks()
   WZLog("send_HOLIDAYVILLAGE_GetFlowerTycoonRanks")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerTycoonRanks )
   if sender==nil then WZLog("sender == nil") return end

   SendProtocol(sender,false) --true:showLoading
end

--@brief 获取订单大亨历届榜（HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks = 36）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks()
   WZLog("send_HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks )
   if sender==nil then WZLog("sender == nil") return end

   SendProtocol(sender,false) --true:showLoading
end

--@brief 获取鲜花订单（HOLIDAYVILLAGE_GetFlowerOrder = 38）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerOrder(opType, orderId)
   WZLog("send_HOLIDAYVILLAGE_GetFlowerOrder")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerOrder )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeByte(opType)   -- 请求类型：0-请求数据，1-接受订单，2-提交订单
   sender:writeInt(orderId)   -- 订单id
   SendProtocol(sender,false) --true:showLoading
end

--@brief 膜拜（HOLIDAYVILLAGE_MobaiFlowerTycoon = 40）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_MobaiFlowerTycoon(index, playerId)
   WZLog("send_HOLIDAYVILLAGE_MobaiFlowerTycoon")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_MobaiFlowerTycoon )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(index)  -- 第几届
   sender:writeInt(playerId)  -- 玩家id
   SendProtocol(sender,false) --true:showLoading
end

--@brief 精灵升级（HOLIDAYVILLAGE_SpiritUpgrade = 42）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritUpgrade(spiritId, itemId, num)
   WZLog("send_HOLIDAYVILLAGE_SpiritUpgrade", spiritId, itemId, num)
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritUpgrade )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(spiritId)  -- 精灵id
   sender:writeInt(itemId) -- 道具id
   sender:writeInt(num) -- 数量
   SendProtocol(sender,false) --true:showLoading
end

--@brief 精灵进阶（HOLIDAYVILLAGE_SpiritStep = 44）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritStep(spiritId)
   WZLog("send_HOLIDAYVILLAGE_SpiritStep", spiritId)
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritStep )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(spiritId)  -- 精灵id
   SendProtocol(sender,false) --true:showLoading
end

--@brief 精灵喂养（HOLIDAYVILLAGE_SpiritFeed = 46）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritFeed(spiritId, itemId, num)
   WZLog("send_HOLIDAYVILLAGE_SpiritFeed", spiritId, itemId, num)
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritFeed )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(spiritId)  -- 精灵id
   sender:writeInt(itemId) -- 道具id
   sender:writeInt(num) -- 数量
   SendProtocol(sender,false) --true:showLoading
end

--@brief 精灵详细数据（HOLIDAYVILLAGE_GetSpiritDetail = 48）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetSpiritDetail(opType, spiritId)
   WZLog("send_HOLIDAYVILLAGE_GetSpiritDetail", opType, spiritId)
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetSpiritDetail )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeByte(opType)   -- 0-全部，1-某个
   sender:writeInt(spiritId)  -- 精灵id
   SendProtocol(sender,false) --true:showLoading
end

--@brief 回收精灵（HOLIDAYVILLAGE_RecoverySpirit = 52）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_RecoverySpirit(spiritId)
   WZLog("send_HOLIDAYVILLAGE_RecoverySpirit", spiritId)
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_RecoverySpirit )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(spiritId)  -- 精灵id
   SendProtocol(sender,false) --true:showLoading
end

--@brief 激活精灵槽（HOLIDAYVILLAGE_ActivationSpiritSlot = 54）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ActivationSpiritSlot(index)
   WZLog("send_HOLIDAYVILLAGE_ActivationSpiritSlot", index)
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ActivationSpiritSlot )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeByte(index) -- 下标，从0开始
   SendProtocol(sender,false) --true:showLoading
end

--@brief 激活精灵（HOLIDAYVILLAGE_ActivationSpirit = 56）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ActivationSpirit(index, spiritId)
   WZLog("send_HOLIDAYVILLAGE_ActivationSpirit", index, spiritId)
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ActivationSpirit )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeByte(index) -- 下标，从0开始
   sender:writeByte(spiritId) -- 精灵id
   SendProtocol(sender,false) --true:showLoading
end

--@brief 鲜花回收（HOLIDAYVILLAGE_FlowerRecovery = 58）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FlowerRecovery(plantId, num, spiritCardId, cardNum)
   WZLog("send_HOLIDAYVILLAGE_FlowerRecovery")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FlowerRecovery )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(plantId)   -- 植物id
   sender:writeInt(num) -- 束量
   sender:writeInt(spiritCardId) -- 精灵卡itemId，不使用传-1
   sender:writeInt(cardNum)   -- 精灵卡数量，不使用传-1
   SendProtocol(sender,false) --true:showLoading
end

--@brief 装饰饰品（HOLIDAYVILLAGE_Decorations = 60）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_Decorations(itemId)
   WZLog("send_HOLIDAYVILLAGE_Decorations")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_Decorations )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(itemId) -- 装饰的道具id
   SendProtocol(sender,false) --true:showLoading
end

--@brief 神树和果实加速（HOLIDAYVILLAGE_AccelerationOp = 62）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_AccelerationOp(opType, itemId, num, index)
   WZLog("send_HOLIDAYVILLAGE_AccelerationOp")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_AccelerationOp )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(opType) -- 1-神树，2-果实
   sender:writeInt(itemId) -- 道具id
   sender:writeInt(num) -- 道具数量
   sender:writeInt(index)  -- opType=2-坑位下标（0开始）
   SendProtocol(sender,false) --true:showLoading
end

--@brief 果实操作（HOLIDAYVILLAGE_FruitOp = 64）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FruitOp(opType, index, fruitId)
   WZLog("send_HOLIDAYVILLAGE_FruitOp")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FruitOp )
   if sender==nil then WZLog("sender == nil") return end

   sender:writeInt(opType) -- 1-选择果实，2-采摘果实
   sender:writeInt(index)  -- 坑位下标，从0开始
   sender:writeInt(fruitId)   -- opType=1-果实id，2-0
   SendProtocol(sender,false) --true:showLoading
end

--@brief 请求果实列表（HOLIDAYVILLAGE_FruitList = 66）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FruitList()
   WZLog("send_HOLIDAYVILLAGE_FruitList")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FruitList )
   if sender==nil then WZLog("sender == nil") return end

   SendProtocol(sender,false) --true:showLoading
end

--@brief 请求树详情（HOLIDAYVILLAGE_TreeDetails = 68）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_TreeDetails()
   WZLog("send_HOLIDAYVILLAGE_TreeDetails")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_TreeDetails )
   if sender==nil then WZLog("sender == nil") return end

   SendProtocol(sender,false) --true:showLoading
end

--@brief 神树许愿（HOLIDAYVILLAGE_WishingTree = 70）
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WishingTree()
   WZLog("send_HOLIDAYVILLAGE_WishingTree")
   local sender = Protocol:getSender( Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_WishingTree )
   if sender==nil then WZLog("sender == nil") return end

   SendProtocol(sender,false) --true:showLoading
end
---------------------------------服务器到客户端协议回调方法模块----------------------------------
--@brief 获取所有土坑（HOLIDAYVILLAGE_GetAllPitsOk = 2）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetAllPitsOk(playerId, synType, indexs, statues, lvls, plantIds, steps, stepEndTimes, bugs, bugEncroachTimes, reduceStartTimes, lastReduceTimes, reduceNumes, yields, totalYields, waterings, digs, fertilizerIds, stone, refines, exps, opType, flowerpotIds)
   -- playerId : 玩家id
   -- synType : 同步类型，0-同步，1-增，2-更新，3-删
   -- indexs : 下标：0开始
   -- statues : 状态：0-待解锁，1-已解锁
   -- lvls : 等级
   -- plantIds : 植物id
   -- steps : 当前阶段：0-种子，1-嫩芽，2-成熟
   -- stepEndTimes : 阶段结束时间
   -- bugs : 害虫id
   -- bugEncroachTimes : 害虫侵害开始时间
   -- reduceStartTimes : 减产开始时间
   -- lastReduceTimes : 上一次减产时间
   -- reduceNumes : 减少的次数累计
   -- yields : 产量
   -- totalYields : 总产量
   -- waterings : 浇水
   -- digs : 挖坑
   -- fertilizerIds : 增产化肥id
   -- stone : 原石，所有原石一个json
   -- refines : 土坑精炼
   -- opType : 执行的操作：1-播种，2-施肥，3-浇水，4-抓虫，5-收获，6-偷花，7-升级，8-挖坑，9-解锁土坑
   -- flowerpotIds : 土坑花盆Id
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetAllPitsOk")

   GlobalGame:getGameEventDispathcer():Dispatch(HolidayVEvent.HolidayVEvent_AllPits, playerId, synType, VectorToTable(indexs), VectorToTable(statues), VectorToTable(lvls), VectorToTable(plantIds), VectorToTable(steps), VectorToTable(bugs), VectorToTable(stepEndTimes), VectorToTable(yields), VectorToTable(stone), VectorToTable(totalYields), VectorToTable(refines), VectorToTable(waterings), VectorToTable(digs), VectorToTable(exps), VectorToTable(fertilizerIds), VectorToTable(reduceNumes), opType, VectorToTable(flowerpotIds))
end

--@brief 商店操作（HOLIDAYVILLAGE_ShopOpOk = 10）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ShopOpOk(opType, statues, synType, rest, data)
   -- opType : 1-种子，2-道具
   -- statues : 状态
   -- synType : 同步类型，0-全部，1-增，2-更新，3-删
   -- rest : 剩余可购买数量，-1-无限
   -- data : 配置数据
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ShopOpOk", synType)
   if WndHVShop.m_root then 
      WndHVShop:setShopData(opType, synType, VectorToTable(statues), VectorToTable(rest), VectorToTable(data))
   end
end

--@brief 操作图鉴（HOLIDAYVILLAGE_PictureOpOk = 12）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_PictureOpOk(synType, pictureIds, lvls)
   -- synType : 同步类型，0-同步，1-增，2-更新，3-删
   -- pictureIds : 图鉴id
   -- lvls : 图鉴等级
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_PictureOpOk", synType, Serialize(VectorToTable(pictureIds)), Serialize(VectorToTable(lvls)))

   if WndHVLibrary.m_root then 
      WndHVLibrary:setLibraryData(synType, VectorToTable(pictureIds), VectorToTable(lvls))
   end
end

--@brief 仓库操作（HOLIDAYVILLAGE_WarehouseOpOk = 14）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_WarehouseOpOk(warehouseType, itemIds, nums, synType)
   -- warehouseType : 1-种子，2-仓库
   -- itemIds : 道具id
   -- nums : 数量
   -- synType : 同步类型，0-全部，1-增，2-更新，3-删
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_WarehouseOpOk", warehouseType, synType, Serialize(VectorToTable(itemIds)), Serialize(VectorToTable(nums)))

   GlobalGame:getGameEventDispathcer():Dispatch(HolidayVillageEvent.HolidayVillageEvent_Store, warehouseType, VectorToTable(itemIds), VectorToTable(nums), synType)
   WndHVStore:setStoreData(warehouseType, VectorToTable(itemIds), VectorToTable(nums), synType)
   WndHVSpirit:setStoreData(warehouseType, VectorToTable(itemIds), VectorToTable(nums), synType)
end

--@brief 获取访客记录（HOLIDAYVILLAGE_GetVisitorRecordOk = 18）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetVisitorRecordOk(friendIds, times, eventIds, serverIds, names, itemIds, nums)
   -- friendIds : 好友id
   -- times : 时间
   -- eventIds : 事件：1-偷菜，2-抓虫 3-阻止偷菜
   -- serverIds : 服务器id
   -- names : 玩家名字
   -- itemIds : 物品id
   -- nums : 数量 [eventIds为3时,这里传的是精灵id]
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetVisitorRecordOk")

   if WndHVOperate.m_root then 
      WndHVOperate:setLogData(VectorToTable(times), VectorToTable(friendIds), VectorToTable(serverIds), VectorToTable(names), VectorToTable(eventIds), VectorToTable(itemIds), VectorToTable(nums))
   end
end

--@brief 获取排行榜（HOLIDAYVILLAGE_GetRanksOk = 20）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetRanksOk(playerIds, serverIds, names, faceIds, headIds, headColors, sexs, levels, vipLevels, profileFrames, thumbUps, achievementValues, holidayVillageLvls, hvCoolValue, rank, synType, rankType, canSteal)
   -- playerIds : 玩家id
   -- serverIds : 玩家服务器id
   -- names : 玩家名字
   -- faceIds : 玩家脸id
   -- headIds : 玩家头id
   -- headColors : 玩家头颜色
   -- sexs : 玩家性别
   -- levels : 玩家等级
   -- vipLevels : 玩家vip等级
   -- profileFrames : 头像框
   -- thumbUps : 点赞
   -- achievementValues : 成就
   -- holidayVillageLvls : 度假村等级
   -- rank : 排名
   -- synType : 同步类型，0-全部，1-增，2-更新，3-删
   -- rankType : 1-好友排名，2-全服排行榜
   -- canSteal : 是否能偷
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetRanksOk", rankType, synType, rank, Serialize(VectorToTable(canSteal)))
   if rankType == 1 then 
      WndHVOperate:setData(synType, VectorToTable(playerIds), VectorToTable(serverIds), VectorToTable(names), VectorToTable(levels), VectorToTable(headIds), VectorToTable(faceIds), VectorToTable(sexs), VectorToTable(headColors), VectorToTable(profileFrames), VectorToTable(vipLevels), VectorToTable(thumbUps), VectorToTable(achievementValues), VectorToTable(holidayVillageLvls), VectorToTable(canSteal))
   elseif rankType == 2 then 
      GlobalGame:getGameEventDispathcer():Dispatch(HolidayVillageEvent.HolidayVillageEvent_Rank, synType, rank, VectorToTable(playerIds), VectorToTable(serverIds), VectorToTable(names), VectorToTable(levels), VectorToTable(headIds), VectorToTable(faceIds), VectorToTable(sexs), VectorToTable(headColors), VectorToTable(profileFrames), VectorToTable(vipLevels), VectorToTable(thumbUps), VectorToTable(achievementValues), VectorToTable(hvCoolValue))
   end
end

--@brief 个人基础数据（HOLIDAYVILLAGE_HolidayVillageBaseInfoOk = 26）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_HolidayVillageBaseInfoOk(playerId, serverId, name, faceId, headId, headColor, sex, profileFrames, level, vipLevel, gold, lvl, power, exp, value, achievementId, houseId, waterWheelId)
   -- playerId : 玩家id
   -- serverId : 区服id
   -- name : 名称 
   -- faceId : 脸部id
   -- headId : 头部id
   -- headColor : 头部颜色
   -- sex : 性别
   -- profileFrames : 头像框
   -- level : 玩家等级
   -- vipLevel : 玩家vip等级
   -- gold : 度假币
   -- lvl : 度假等级
   -- power : 度假能量
   -- exp : 度假经验
   -- value : 度假爽值
   -- achievementId : 正在使用的成就id
   -- houseId : 正在使用的小屋id
   -- waterWheelId : 正在使用的水车id
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_HolidayVillageBaseInfoOk")
   GlobalGame:getGameEventDispathcer():Dispatch(HolidayVEvent.HolidayVEvent_HostInfo, playerId, name, headId, faceId, headColor, profileFrames, sex, vipLevel, serverId, level, lvl, exp, power, achievementId, value, houseId, waterWheelId)
end

--@brief 同步浏览者（HOLIDAYVILLAGE_HolidayVillageBrowserOk = 27）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_HolidayVillageBrowserOk(playerIds, serverIds, names, faceIds, headIds, headColors, sexs, levels, vipLevels, title, bodyId, wingId, bodyColor, footmark, blueVipInfo, spirits, synType)
   -- playerIds : 玩家id
   -- serverIds : 玩家服务器id
   -- names : 玩家名字
   -- faceIds : 玩家脸id
   -- headIds : 玩家头id
   -- headColors : 玩家头颜色
   -- sexs : 玩家性别
   -- levels : 玩家等级
   -- vipLevels : 玩家vip等级
   -- title : 角色称号
   -- bodyId : 角色身体装备id
   -- wingId : 角色翅膀装备id
   -- bodyColor : 身体颜色
   -- footmark : 足迹
   -- blueVipInfo : QQ蓝砖
   -- spirits : 精灵数据
   -- synType : 0=全部，2=更新，3=删除
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_HolidayVillageBrowserOk", 
      "\n playerIds=",Serialize(VectorToTable(playerIds)), 
      "\n serverIds=",Serialize(VectorToTable(serverIds)), 
      "\n names=",Serialize(VectorToTable(names)), 
      "\n faceIds=",Serialize(VectorToTable(faceIds)), 
      "\n headIds=",Serialize(VectorToTable(headIds)), 
      "\n headColors=",Serialize(VectorToTable(headColors)), 
      "\n sexs=",Serialize(VectorToTable(sexs)), 
      "\n levels=",Serialize(VectorToTable(levels)), 
      "\n vipLevels=",Serialize(VectorToTable(vipLevels)), 
      "\n title=",Serialize(VectorToTable(title)), 
      "\n bodyId=",Serialize(VectorToTable(bodyId)), 
      "\n wingId=",Serialize(VectorToTable(wingId)), 
      "\n bodyColor=",Serialize(VectorToTable(bodyColor)), 
      "\n footmark=",Serialize(VectorToTable(footmark)), 
      "\n blueVipInfo=",Serialize(VectorToTable(blueVipInfo)), 
      "\n spirits=",Serialize(VectorToTable(spirits)), 
      "\n synType=",Serialize(VectorToTable(synType)))

   GlobalGame:getGameEventDispathcer():Dispatch(HolidayVillageEvent.HolidayVillageEvent_Visitors, VectorToTable(playerIds), VectorToTable(sexs), VectorToTable(names), VectorToTable(faceIds), VectorToTable(headIds), VectorToTable(headColors), VectorToTable(bodyId), VectorToTable(bodyColor), VectorToTable(wingId), VectorToTable(serverIds), VectorToTable(levels), VectorToTable(vipLevels), VectorToTable(title), VectorToTable(footmark), VectorToTable(blueVipInfo), VectorToTable(spirits), synType)
end

--@brief 商店购买结果（HOLIDAYVILLAGE_ShopBuyResultOk = 30）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ShopBuyResultOk(result, shopId, num, rest)
   -- result : 结果：1-成功，2-未解锁，3-购买数量超过全局日限量，4-购买数量超过个人日限量，5-所需道具不足
   -- shopId : 商品id
   -- num : 数量
   -- rest : 剩余可购数量
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ShopBuyResultOk", result, shopId, rest, num)

   WndHVShop:buyGoodsResult(result, shopId, rest, num)
end

--@brief 土坑操作结果（HOLIDAYVILLAGE_PitOpResultOk = 33）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_PitOpResultOk(opType, result, itemIds, nums)
   -- opType : 同步类型：0-全部，请求和主动同步；2-更新，其它土坑操作（偷取，捕捉、采摘）
   -- result : 结果：0-成功，-1001-未开启度假村，-1004-土坑未解锁，-1005-土坑未挖，-1006-成长后才能施肥，-1007-不能重复施肥，-1008-未成熟，-1009-超过每天偷采的限制，-1010-超过每天个人偷采的限制，-1011-不能多次采摘，-1012-被采摘完了，-1013-没有害虫了
   -- itemIds : 物品id
   -- nums : 数量
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_PitOpResultOk", opType, result, Serialize(VectorToTable(itemIds)), Serialize(VectorToTable(nums)))

   GlobalGame:getGameEventDispathcer():Dispatch(HolidayVEvent.HolidayVEvent_PitOpResult, opType, result, VectorToTable(itemIds), VectorToTable(nums))
end

--@brief 获取鲜花大亨榜（HOLIDAYVILLAGE_GetFlowerTycoonRanksOk = 35）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerTycoonRanksOk(playerIds, serverIds, names, faceIds, headIds, headColors, sexs, levels, vipLevels, profileFrames, flower, ranks, blueVip, myRank, resetTimes, myFlower)
   -- playerIds : 玩家id
   -- serverIds : 玩家服务器id
   -- names : 玩家名字
   -- faceIds : 玩家脸id
   -- headIds : 玩家头id
   -- headColors : 玩家头颜色
   -- sexs : 玩家性别
   -- levels : 玩家等级
   -- vipLevels : 玩家vip等级
   -- profileFrames : 头像框
   -- flower : 订单值
   -- ranks : 排名
   -- myRank : 我的排名
   -- resetTimes : 剩余膜拜次数
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerTycoonRanksOk")
   GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GetRankResult, 0, nil, 38, myFlower, myRank, 
      "{}", VectorToTable(playerIds), VectorToTable(ranks), VectorToTable(flower), VectorToTable(names), VectorToTable(headIds), VectorToTable(headColors),
      VectorToTable(faceIds), VectorToTable(sexs), VectorToTable(vipLevels), VectorToTable(levels), nil, nil, nil, 
      VectorToTable(serverIds), nil, nil, VectorToTable(profileFrames), VectorToTable(blueVip))
end

--@brief 获取订单大亨历届榜（HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanksOk = 37）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanksOk(index, playerIds, serverIds, names, faceIds, headIds, headColors, sexs, levels, vipLevels, title, bodyId, wingId, bodyColor, footmark, blueVipInfo, flower, mobai)
   -- index : 序号
   -- playerIds : 玩家id
   -- serverIds : 玩家服务器id
   -- names : 玩家名字
   -- faceIds : 玩家脸id
   -- headIds : 玩家头id
   -- headColors : 玩家头颜色
   -- sexs : 玩家性别
   -- levels : 玩家等级
   -- vipLevels : 玩家vip等级
   -- title : 角色称号
   -- bodyId : 角色身体装备id
   -- wingId : 角色翅膀装备id
   -- bodyColor : 身体颜色
   -- footmark : 足迹
   -- blueVipInfo : QQ蓝砖
   -- flower : 订单收益
   -- mobai : 膜拜数量
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanksOk")
   WndHVOrderFirst:onGetOtherData(VectorToTable(index), VectorToTable(playerIds), VectorToTable(serverIds), VectorToTable(names), VectorToTable(faceIds), VectorToTable(headIds), VectorToTable(headColors), VectorToTable(sexs), VectorToTable(levels), VectorToTable(vipLevels), VectorToTable(title), VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(bodyColor), VectorToTable(footmark), VectorToTable(blueVipInfo), VectorToTable(flower), VectorToTable(mobai))
end

--@brief 获取鲜花订单（HOLIDAYVILLAGE_GetFlowerOrderOk = 39）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerOrderOk(synType, orderIds, processes, seedNums, status, season, endTime, leftWorshipTimes, opType)
   -- synType : 同步类型：0-所有，2-更新
   -- orderIds : 订单id
   -- processes : 订单进度
   -- seedNums : 剩余种子数量
   -- status : 订单状态：1-已接单，2-可领取，3-已领取
   -- season : 赛季
   -- endTime : 结束时间戳
   -- leftWorshipTimes : 剩余膜拜次数
   -- opType : 请求类型：0-请求数据，1-接受订单，2-提交订单
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerOrderOk", seedNums:size())

   WndHVOperate:setFlowerOrderList(synType, VectorToTable(orderIds), VectorToTable(processes), VectorToTable(seedNums), VectorToTable(status), season, endTime)
   WndHVFlowerOrder:setFlowerOrderList(synType, VectorToTable(orderIds), VectorToTable(processes), VectorToTable(seedNums), VectorToTable(status), season, endTime, leftWorshipTimes, opType)
end

--@brief 膜拜（HOLIDAYVILLAGE_MobaiFlowerTycoonOK = 41）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_MobaiFlowerTycoonOK(mobaiNum, season, playerId)
   -- mobaiNum : 被膜拜的次数
   -- season : 第几届
   -- playerId : 玩家id
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_MobaiFlowerTycoonOK")
   WndHVOrderFirst:worshipOK(mobaiNum, season, playerId)
end


--@brief 精灵升级（HOLIDAYVILLAGE_SpiritUpgradeOK = 43）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritUpgradeOK()
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritUpgradeOK")
   WndHVSpirit:spiritUpgradeOK()
end

--@brief 精灵进阶（HOLIDAYVILLAGE_SpiritStepOK = 45）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritStepOK()
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritStepOK")
   WndHVSpirit:spiritStepOK()
end

--@brief 精灵喂养（HOLIDAYVILLAGE_SpiritFeedOK = 47）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritFeedOK()
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritFeedOK")
   WndHVSpirit:spiritFeedOK()
end

--@brief 精灵详细数据（HOLIDAYVILLAGE_GetSpiritDetailOK = 49）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetSpiritDetailOK(synType, playerId, index, status, spiritId, satiety, level, exp, step)
   -- synType : 0-全部，2-更新
   -- playerId : 玩家id
   -- index : 下标，0开始
   -- status : 状态：0-未解锁，1-解锁
   -- spiritId : 精灵id
   -- satiety : 饱食度
   -- level : 等级
   -- exp : 经验
   -- step : 阶
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetSpiritDetailOK", 
      "\n synType =",Serialize(VectorToTable(synType)), 
      "\n playerId =",Serialize(VectorToTable(playerId)), 
      "\n index =",Serialize(VectorToTable(index)), 
      "\n status =",Serialize(VectorToTable(status)), 
      "\n spiritId =",Serialize(VectorToTable(spiritId)), 
      "\n satiety =",Serialize(VectorToTable(satiety)), 
      "\n level =",Serialize(VectorToTable(level)), 
      "\n exp =",Serialize(VectorToTable(exp)), 
      "\n step =",Serialize(VectorToTable(step))
      )

   WndHVSpirit:getSpiritDetailOK(synType, playerId, VectorToTable(index), VectorToTable(status), VectorToTable(spiritId), VectorToTable(satiety), VectorToTable(level), VectorToTable(exp), VectorToTable(step))
end

--@brief 回收精灵（HOLIDAYVILLAGE_RecoverySpiritOK = 53）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_RecoverySpiritOK(itemIds, itemNums)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_RecoverySpiritOK", 
      "\n itemIds =",Serialize(VectorToTable(itemIds)), 
      "\n itemNums =",Serialize(VectorToTable(itemNums)))

   WndHVSpirit:recoverySpiritOK(VectorToTable(itemIds), VectorToTable(itemNums))
end

--@brief 激活精灵槽（HOLIDAYVILLAGE_ActivationSpiritSlotOK = 55）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ActivationSpiritSlotOK()
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ActivationSpiritSlotOK")
   WndHVSpirit:activationSpiritSlotOK()
end

--@brief 激活精灵（HOLIDAYVILLAGE_ActivationSpiritOK = 57）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ActivationSpiritOK()
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ActivationSpiritOK")
   WndHVSpirit:activationSpiritOK()
end

--@brief 鲜花回收（HOLIDAYVILLAGE_FlowerRecoveryOK = 59）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FlowerRecoveryOK(itemIds, nums, extrItemIds, extrItemNums)
   -- itemIds : 道具id
   -- nums : 数量
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FlowerRecoveryOK")
   WndHVStore:sellFlowerResult(VectorToTable(itemIds), VectorToTable(nums), VectorToTable(extrItemIds), VectorToTable(extrItemNums))
end

--@brief 装饰饰品（HOLIDAYVILLAGE_DecorationsOK = 61）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_DecorationsOK(opType, updateId)
   -- opType : 3:小屋，4：水车
   -- updateId : 操作后的值
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_DecorationsOK")
   WndHVOperate:operateDecorationResult(opType, updateId)
end

--@brief 神树和果实加速（HOLIDAYVILLAGE_AccelerationOpOK = 63）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_AccelerationOpOK(opType, itemId, itemNum, index)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_AccelerationOpOK")
   -- opType : 1-果树，2-果实
   -- itemIds : 道具id
   -- nums : 数量
   -- index : 坑  0开始
   GlobalGame:getGameEventDispathcer():Dispatch(HolidayVEvent.HolidayVEvent_SpeedFruit, opType, itemId, itemNum, index)
end

--@brief 果实操作（HOLIDAYVILLAGE_FruitOpOK = 65）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FruitOpOK(opType, fruitId, index, itemId, num)
   -- opType : 1-选择果实，2-采摘果实
   -- itemId : 道具id
   -- num : 道具数量
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FruitOpOK")

   GlobalGame:getGameEventDispathcer():Dispatch(HolidayVEvent.HolidayVEvent_ChooseFruit, opType, fruitId, index, VectorToTable(itemId), VectorToTable(num))
end

--@brief 请求果实列表（HOLIDAYVILLAGE_FruitListOK = 67）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FruitListOK(ids, lvls, itemIds, nums, time)
   -- ids : 果实id
   -- lvls : 等级
   -- itemIds : 道具id
   -- nums : 数量
   -- time : 果实成熟时间
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FruitListOK")
end

--@brief 请求树详情（HOLIDAYVILLAGE_TreeDetailsOk = 69）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_TreeDetailsOk(lvl, exp, index, ids, endTimes, wishingTimes)
   -- lvl : 等级
   -- exp : 经验
   -- index : 坑位下标，从0开始
   -- ids : 果实id
   -- endTimes : 果实成熟结束时间，时间戳
   -- wishingTimes : 许愿，[0]今日许愿次数；[1]许愿时间
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_TreeDetailsOk")
   GlobalGame:getGameEventDispathcer():Dispatch(HolidayVEvent.HolidayVEvent_GetDivineTreeInfo, lvl, exp, VectorToTable(index), VectorToTable(ids), VectorToTable(endTimes), VectorToTable(wishingTimes))
end

--@brief 神树许愿（HOLIDAYVILLAGE_WishingTreeOK = 71）
function ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_WishingTreeOK(itemId, itemNum, wishingTimes, result)
   -- itemId : 物品id
   -- itemNum : 物品数量
   -- wishingTimes : 许愿，[0]今日许愿次数；[1]许愿时间
   -- result : 结果：0=成功;1=许愿上限;2=冷却时间,3=数据异常
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_WishingTreeOK", itemId, itemNum, result, Serialize(VectorToTable(wishingTimes)))

   GlobalGame:getGameEventDispathcer():Dispatch(HolidayVEvent.HolidayVEvent_WishResult, itemId, itemNum, result, VectorToTable(wishingTimes))
end
---------------------------------------协议错误处理方法模块--------------------------------------
--@brief 获取所有土坑（HOLIDAYVILLAGE_GetAllPits = 1）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetAllPits_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetAllPits_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetAllPits, nflag, sMessage)
end

--@brief 原石操作（HOLIDAYVILLAGE_PitStone = 5）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitStone_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_PitStone_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_PitStone, nflag, sMessage)
end

--@brief 商店操作（HOLIDAYVILLAGE_ShopOp = 9）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ShopOp_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ShopOp_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ShopOp, nflag, sMessage)
end

--@brief 操作图鉴（HOLIDAYVILLAGE_PictureOp = 11）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PictureOp_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_PictureOp_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_PictureOp, nflag, sMessage)
end

--@brief 仓库操作（HOLIDAYVILLAGE_WarehouseOp = 13）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WarehouseOp_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_WarehouseOp_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_WarehouseOp, nflag, sMessage)
end

--@brief 土坑操作（HOLIDAYVILLAGE_PitOp = 15）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_PitOp_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_PitOp, nflag, sMessage)
end

--@brief 获取访客记录（HOLIDAYVILLAGE_GetVisitorRecord = 17）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetVisitorRecord_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetVisitorRecord_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetVisitorRecord, nflag, sMessage)
end

--@brief 获取排行榜（HOLIDAYVILLAGE_GetRanks = 19）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetRanks_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetRanks_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetRanks, nflag, sMessage)
end

--@brief 点赞（HOLIDAYVILLAGE_ThumbsUp = 21）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ThumbsUp_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ThumbsUp_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ThumbsUp, nflag, sMessage)
end

--@brief 进入度假村（HOLIDAYVILLAGE_HolidayVillageOp = 23）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_HolidayVillageOp_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_HolidayVillageOp_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_HolidayVillageOp, nflag, sMessage)
end

--@brief 获取鲜花大亨榜（HOLIDAYVILLAGE_GetFlowerTycoonRanks = 34）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerTycoonRanks_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerTycoonRanks_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerTycoonRanks, nflag, sMessage)
end

--@brief 获取订单大亨历届榜（HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks = 36）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerTycoonHistoryRanks, nflag, sMessage)
end

--@brief 获取鲜花订单（HOLIDAYVILLAGE_GetFlowerOrder = 38）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerOrder_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetFlowerOrder_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetFlowerOrder, nflag, sMessage)
end

--@brief 膜拜（HOLIDAYVILLAGE_MobaiFlowerTycoon = 40）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_MobaiFlowerTycoon_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_MobaiFlowerTycoon_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_MobaiFlowerTycoon, nflag, sMessage)
end


--@brief 精灵升级（HOLIDAYVILLAGE_SpiritUpgrade = 42）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritUpgrade_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritUpgrade_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritUpgrade, nflag, sMessage)
end

--@brief 精灵进阶（HOLIDAYVILLAGE_SpiritStep = 44）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritStep_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritStep_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritStep, nflag, sMessage)
end

--@brief 精灵喂养（HOLIDAYVILLAGE_SpiritFeed = 46）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritFeed_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_SpiritFeed_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_SpiritFeed, nflag, sMessage)
end

--@brief 精灵详细数据（HOLIDAYVILLAGE_GetSpiritDetail = 48）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetSpiritDetail_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_GetSpiritDetail_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_GetSpiritDetail, nflag, sMessage)
end

--@brief 回收精灵（HOLIDAYVILLAGE_RecoverySpirit = 52）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_RecoverySpirit_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_RecoverySpirit_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_RecoverySpirit, nflag, sMessage)
end

--@brief 激活精灵槽（HOLIDAYVILLAGE_ActivationSpiritSlot = 54）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ActivationSpiritSlot_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ActivationSpiritSlot_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ActivationSpiritSlot, nflag, sMessage)
end

--@brief 激活精灵（HOLIDAYVILLAGE_ActivationSpirit = 56）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ActivationSpirit_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_ActivationSpirit_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_ActivationSpirit, nflag, sMessage)
end

--@brief 鲜花回收（HOLIDAYVILLAGE_FlowerRecovery = 58）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FlowerRecovery_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FlowerRecovery_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FlowerRecovery, nflag, sMessage)
end

--@brief 装饰饰品（HOLIDAYVILLAGE_Decorations = 60）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_Decorations_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_Decorations_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_Decorations, nflag, sMessage)
end

--@brief 神树和果实加速（HOLIDAYVILLAGE_AccelerationOp = 62）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_AccelerationOp_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_AccelerationOp_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_AccelerationOp, nflag, sMessage)
end

--@brief 果实操作（HOLIDAYVILLAGE_FruitOp = 64）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FruitOp_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FruitOp_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FruitOp, nflag, sMessage)
end

--@brief 请求果实列表（HOLIDAYVILLAGE_FruitList = 66）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FruitList_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_FruitList_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_FruitList, nflag, sMessage)
end

--@brief 请求树详情（HOLIDAYVILLAGE_TreeDetails = 68）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_TreeDetails_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_TreeDetails_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_TreeDetails, nflag, sMessage)
end

--@brief 神树许愿（HOLIDAYVILLAGE_WishingTree = 70）错误处理函数(S->C)
--@param nFlag:标志位
--@param sMessage:错误信息
--@note  在此对协议错误进行相应处理
function ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WishingTree_ErrorProcess(nFlag, sMessage)
   WZLog("ProtocolProcessorHolidayVillage:parse_HOLIDAYVILLAGE_WishingTree_ErrorProcess")
   ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOLIDAYVILLAGE, Protocol.HOLIDAYVILLAGE_WishingTree, nflag, sMessage)
end