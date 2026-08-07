--ProtocolProcessorFootMark.lua
--@brief    成长基金相关协议
--@date     2016/4/14
--@author   Tianxiang_Xu
--@note     成长基金相关协议


ProtocolProcessorFootMark = ProtocolProcessorBase:new()


--@brief    注册协议组所有协议
--@note     注册协议组所有协议
function ProtocolProcessorFootMark:regAll()
    --@brief	获取足迹列表（FOOTMARK_GetFootmark = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootmark, "ProtocolProcessorFootMark:send_FOOTMARK_GetFootmark_ErrorProcess", "is" )
	--@brief	使用足迹物品（FOOTMARK_UseFootmark = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UseFootmark, "ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark_ErrorProcess", "is" )
	--@brief	足迹升级（FOOTMARK_UpgradeFootmark = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UpgradeFootmark, "ProtocolProcessorFootMark:send_FOOTMARK_UpgradeFootmark_ErrorProcess", "is" )
	--@brief	足迹进阶（FOOTMARK_AdvancedFootmark = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_AdvancedFootmark, "ProtocolProcessorFootMark:send_FOOTMARK_AdvancedFootmark_ErrorProcess", "is" )
	--@brief	足迹改变状态（FOOTMARK_ChangeState = 8）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_ChangeState, "ProtocolProcessorFootMark:send_FOOTMARK_ChangeState_ErrorProcess", "is" )
	--@brief	获取足迹打卡城市 167+（FOOTMARK_GetFootMarkCityInfo = 11）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootMarkCityInfo, "ProtocolProcessorFootMark:send_FOOTMARK_GetFootMarkCityInfo_ErrorProcess", "is")
	--@brief	领取足迹城市打卡奖励 167+（FOOTMARK_ReceiveFootMarkCityReward = 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_ReceiveFootMarkCityReward, "ProtocolProcessorFootMark:send_FOOTMARK_ReceiveFootMarkCityReward_ErrorProcess", "is")
	--@brief	获取足迹城市商城 167+（FOOTMARK_GetFootMarkCityShop = 15）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootMarkCityShop, "ProtocolProcessorFootMark:send_FOOTMARK_GetFootMarkCityShop_ErrorProcess", "is")
	--@brief	购买足迹城市商城 167+（FOOTMARK_BuyFootMarkCityShopItem = 17）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_BuyFootMarkCityShopItem, "ProtocolProcessorFootMark:send_FOOTMARK_BuyFootMarkCityShopItem_ErrorProcess", "is")
	--@brief	获取所有足迹星辰（FOOTMARK_FootmarkStarsAllInfo = 19）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsAllInfo, "ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsAllInfo_ErrorProcess", "is")
	--@brief	足迹宝石镶嵌（FOOTMARK_FootmarkStarsStoneMosaic = 21）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneMosaic, "ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneMosaic_ErrorProcess", "is")
	--@brief	足迹星辰拆除宝石（FOOTMARK_FootmarkStarsStoneDown = 23）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneDown, "ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneDown_ErrorProcess", "is")
	--@brief	足迹宝石合成（FOOTMARK_FootmarkStarsStoneMerge = 25）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneMerge, "ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneMerge_ErrorProcess", "is")

	--@brief	获取足迹列表成功（FOOTMARK_GetFootmarkOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootmarkOk, "ProtocolProcessorFootMark:parse_FOOTMARK_GetFootmarkOk", "vivivivivsviviviivis")
	--@brief	使用足迹物品（FOOTMARK_UseFootmarkOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UseFootmarkOk, "ProtocolProcessorFootMark:parse_FOOTMARK_UseFootmarkOk", "vivi")
	--@brief	足迹更新（FOOTMARK_UpdataFootmark = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UpdataFootmark, "ProtocolProcessorFootMark:parse_FOOTMARK_UpdataFootmark", "iiiisiiiiii")
	--@brief	足迹改变状态成功信息（FOOTMARK_ChangeStateOK = 9）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_ChangeStateOK, "ProtocolProcessorFootMark:parse_FOOTMARK_ChangeStateOK", "i")
	--@brief	坐骑升级成功信息（FOOTMARK_UpgradeRecordOk = 10）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UpgradeRecordOk, "ProtocolProcessorFootMark:parse_FOOTMARK_UpgradeRecordOk", "vivsvtviviivi")
	--@brief	获取足迹打卡城市（FOOTMARK_GetFootMarkCityInfoOk = 12）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootMarkCityInfoOk, "ProtocolProcessorFootMark:parse_FOOTMARK_GetFootMarkCityInfoOk", "viivi")
	--@brief	领取足迹城市打卡奖励（FOOTMARK_ReceiveFootMarkCityRewardOk = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_ReceiveFootMarkCityRewardOk, "ProtocolProcessorFootMark:parse_FOOTMARK_ReceiveFootMarkCityRewardOk", "iivivi")
	--@brief	获取足迹城市商城（FOOTMARK_GetFootMarkCityShopOk = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootMarkCityShopOk, "ProtocolProcessorFootMark:parse_FOOTMARK_GetFootMarkCityShopOk", "vivivivivivivi")
	--@brief	购买足迹城市商城（FOOTMARK_BuyFootMarkCityShopItemOk = 18）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_BuyFootMarkCityShopItemOk, "ProtocolProcessorFootMark:parse_FOOTMARK_BuyFootMarkCityShopItemOk", "ivivi")
	--@brief	获取所有足迹星辰（FOOTMARK_FootmarkStarsAllInfoOk = 20）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsAllInfoOk, "ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsAllInfoOk", "vivsvi")
	--@brief	足迹宝石镶嵌（FOOTMARK_FootmarkStarsStoneMosaicOK = 22）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneMosaicOK, "ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneMosaicOK", "ii")
	--@brief	协议号名字（FOOTMARK_FootmarkStarsStoneDownOK = 24）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneDownOK, "ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneDownOK", "i")
	--@brief	足迹宝石合成（FOOTMARK_FootmarkStarsStoneMergeOK = 26）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneMergeOK, "ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneMergeOK", "iiii")

end



--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorFootMark:unregAll()
    self:clearReg()
end


---------------------------------客户端到服务器协议发送方法模块----------------------------------
--@brief	获取足迹列表（FOOTMARK_GetFootmark=1）
function ProtocolProcessorFootMark:send_FOOTMARK_GetFootmark( )
	WZLog("send_FOOTMARK_GetFootmark")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootmark )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	使用足迹物品（FOOTMARK_UseFootmark=3）
function ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark(itemId )
	WZLog("send_FOOTMARK_UseFootmark:",itemId)
	g_curbuy_footmark = itemId
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UseFootmark )
	if sender==nil then WZLog("sender == nil") return end
  
	sender:writeInt( itemId )	-- 物品id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	足迹升级（FOOTMARK_UpgradeFootmark=5）
function ProtocolProcessorFootMark:send_FOOTMARK_UpgradeFootmark(footmarkId, num )
	WZLog("send_FOOTMARK_UpgradeFootmark")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UpgradeFootmark )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( footmarkId )	-- 足迹id
	sender:writeInt( num )	-- 次数
	SendProtocol(sender,false) --true:showLoading
end

--@brief	足迹进阶（FOOTMARK_AdvancedFootmark=7）
function ProtocolProcessorFootMark:send_FOOTMARK_AdvancedFootmark(footmarkId )
	WZLog("send_FOOTMARK_AdvancedFootmark")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_AdvancedFootmark )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( footmarkId )	-- 足迹id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	足迹改变状态（FOOTMARK_ChangeState=8）
function ProtocolProcessorFootMark:send_FOOTMARK_ChangeState(footmarkId )
	WZLog("send_FOOTMARK_ChangeState")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_ChangeState )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( footmarkId )	-- 足迹id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取足迹打卡城市 167+（FOOTMARK_GetFootMarkCityInfo = 11）
function ProtocolProcessorFootMark:send_FOOTMARK_GetFootMarkCityInfo()
	WZLog("send_FOOTMARK_GetFootMarkCityInfo")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootMarkCityInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取足迹城市打卡奖励 167+（FOOTMARK_ReceiveFootMarkCityReward = 13）
function ProtocolProcessorFootMark:send_FOOTMARK_ReceiveFootMarkCityReward(id)
	WZLog("send_FOOTMARK_ReceiveFootMarkCityReward")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_ReceiveFootMarkCityReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(id)	-- 城市id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取足迹城市商城 167+（FOOTMARK_GetFootMarkCityShop = 15）
function ProtocolProcessorFootMark:send_FOOTMARK_GetFootMarkCityShop()
	WZLog("send_FOOTMARK_GetFootMarkCityShop")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootMarkCityShop )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买足迹城市商城 167+（FOOTMARK_BuyFootMarkCityShopItem = 17）
function ProtocolProcessorFootMark:send_FOOTMARK_BuyFootMarkCityShopItem(id, num)
	WZLog("send_FOOTMARK_BuyFootMarkCityShopItem")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_BuyFootMarkCityShopItem )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(id)	-- 商品id
	sender:writeInt(num)	-- 购买数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取所有足迹星辰（FOOTMARK_FootmarkStarsAllInfo = 19）
function ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsAllInfo()
	WZLog("send_FOOTMARK_FootmarkStarsAllInfo")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsAllInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	足迹宝石镶嵌（FOOTMARK_FootmarkStarsStoneMosaic = 21）
function ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneMosaic(starsId, pos, stoneId)
	WZLog("send_FOOTMARK_FootmarkStarsStoneMosaic", starsId, pos, stoneId)
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneMosaic )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(starsId)	-- 星辰id
	sender:writeInt(pos)	-- 槽位
	sender:writeInt(stoneId)	-- 星辰宝石itemId
	SendProtocol(sender,false) --true:showLoading
end

--@brief	足迹星辰拆除宝石（FOOTMARK_FootmarkStarsStoneDown = 23）
function ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneDown(starsId, pos)
	WZLog("send_FOOTMARK_FootmarkStarsStoneDown", starsId, pos)
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneDown )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(starsId)	-- 星辰id
	sender:writeInt(pos)	-- 槽位
	SendProtocol(sender,false) --true:showLoading
end

--@brief	足迹宝石合成（FOOTMARK_FootmarkStarsStoneMerge = 25）
function ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneMerge(starsId, pos, stoneId, stoneNum)
	WZLog("send_FOOTMARK_FootmarkStarsStoneMerge", starsId, pos, stoneId, stoneNum)
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneMerge )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(starsId)	-- 星辰id 宝石为镶嵌状态：星辰id 否则：0
	sender:writeInt(pos)	-- 星辰槽位 宝石为镶嵌状态：槽位 否则：0
	sender:writeInt(stoneId)	-- 星辰 宝石id
	sender:writeInt(stoneNum)	-- 星辰 宝石数量
	SendProtocol(sender,false) --true:showLoading
end

---------------------------------服务器到客户端协议回调方法模块----------------------------------
--@brief	获取足迹列表成功（FOOTMARK_GetFootmarkOk=2）
function ProtocolProcessorFootMark:parse_FOOTMARK_GetFootmarkOk(footmarkId, upgradeLevel, advancedLevel, fighting, extMap, upgradeBlessingValue, advancedBlessingValue, remainingTime, useFootmark, collectStatus, starsSpecialAttr)
	-- footmarkId : 足迹id
	-- upgradeLevel : 足迹等级
	-- advancedLevel : 进阶等级
	-- fighting : 战斗力
	-- extMap : 属性,json格式{"1":200, "2":500}
	-- upgradeBlessingValue : 升级幸运值
	-- advancedBlessingValue : 进阶幸运值
	-- remainingTime : 剩余时间秒（-1为永久）
	-- useFootmark : 使用中足迹
	-- starsSpecialAttr : 星辰特殊属性
--	WZLog("获取足迹协议",Serialize(VectorToTable(collectStatus)))
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_GetFootmarkOk")

	CacheCenter:setFootMarkData(VectorToTable(footmarkId), VectorToTable(upgradeLevel), VectorToTable(advancedLevel), VectorToTable(advancedBlessingValue), VectorToTable(extMap), VectorToTable(upgradeBlessingValue), VectorToTable(fighting), VectorToTable(remainingTime), useFootmark, VectorToTable(collectStatus), starsSpecialAttr)
end

--@brief	使用足迹物品（FOOTMARK_UseFootmarkOk=4）
function ProtocolProcessorFootMark:parse_FOOTMARK_UseFootmarkOk(itemId, num)
	-- itemId : 转换后的物品Id
	-- num : 物品数量
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_UseFootmarkOk")

	local tItemId = {}
	tItemId[1] = g_nUseFootMarkId
	local tItemNum = {}
	tItemNum[1] = 1
	WndRewardShow:showById(tItemId, tItemNum, nil, nil, true)
end

--@brief	足迹更新（FOOTMARK_UpdataFootmark=6）
function ProtocolProcessorFootMark:parse_FOOTMARK_UpdataFootmark(footmarkId, upgradeLevel, advancedLevel, fighting, extMap, upgradeBlessingValue, advancedBlessingValue, remainingTime, originType, result, collectStatus)
	-- footmarkId : 足迹id
	-- upgradeLevel : 足迹等级
	-- advancedLevel : 进阶等级
	-- fighting : 战斗力
	-- extMap : 属性,json格式{"1":200, "2":500}
	-- upgradeBlessingValue : 升级幸运值
	-- advancedBlessingValue : 精炼幸运值
	-- remainingTime : 剩余时间秒（-1为永久）
	-- originType : 状态（1、新增【新获得足迹或时效改变】，2、升级，3、进阶）
	-- result : 结果：1->成功；0->失败
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_UpdataFootmark", footmarkId, remainingTime, collectStatus)

	CacheCenter:updateFootMarkInfoOK(footmarkId, upgradeLevel, advancedLevel, advancedBlessingValue, extMap, fighting, originType, remainingTime, upgradeBlessingValue, collectStatus)
	WndFootMark:updateNewFootMarkData(footmarkId, originType, result)
end

--@brief	足迹改变状态成功信息（FOOTMARK_ChangeStateOK=9）
function ProtocolProcessorFootMark:parse_FOOTMARK_ChangeStateOK(useFootmark)
	-- useFootmark : 使用中足迹id
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_ChangeStateOK")

	CacheCenter:resetFootMarkState(useFootmark)
end

--@brief	坐骑升级成功信息（FOOTMARK_UpgradeRecordOk = 10）
function ProtocolProcessorFootMark:parse_FOOTMARK_UpgradeRecordOk(level, cost, result, item, num, uplevel, rate)
	-- level : 升级前等级
	-- cost : 消耗
	-- result : 是否成功（0为失败1为成功）
	-- item : 总消耗物品Id
	-- num : 总消耗物品数量
	-- uplevel : 升级的等级
	-- rate : 概率
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_UpgradeRecordOk")

	local level = VectorToTable(level)
	local cost = VectorToTable(cost)
	local result = VectorToTable(result)
	local item = VectorToTable(item)
	local num = VectorToTable(num)
	local rate = VectorToTable(rate)
	WZLog("parse_FOOTMARK_UpgradeRecordOk ",#rate,#cost,#item,#num)
	local info = {}
	info.uplevel = uplevel
	info.log = {}
	info.cost = {}
	for i = 1, #level do
		local costInfo = json.decode(cost[i])
		local data = {level = level[i],cost = costInfo[2], result = result[i], rate = rate[i]}
		table.insert(info.log ,data)
	end
	for i = 1, #item do
		WZLog("parse_FOOTMARK_UpgradeRecordOk HHH ",item[i],num[i])
		local cost = {costId = item[i], costNum = num[i]}
		table.insert(info.cost,cost)
	end
	WndFootMarkUpgrade:updateUpLog(info)
end

--@brief	获取足迹打卡城市（FOOTMARK_GetFootMarkCityInfoOk = 12）
function ProtocolProcessorFootMark:parse_FOOTMARK_GetFootMarkCityInfoOk(ids, footmarkCount, status)
	-- ids : 城市id
	-- footmarkCount : 收集足迹数量
	-- status : 奖励领取状态 -1不可领取 0可领取 1已经领取
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_GetFootMarkCityInfoOk")

	WndFootBeatCard:getCityCardListOK(VectorToTable(ids), footmarkCount, VectorToTable(status))
end

--@brief	领取足迹城市打卡奖励（FOOTMARK_ReceiveFootMarkCityRewardOk = 14）
function ProtocolProcessorFootMark:parse_FOOTMARK_ReceiveFootMarkCityRewardOk(id, result, itemId, itemNum)
	-- id : 城市id
	-- result : 购买结果 1成功 2已经领取了 3城市不存在 4未达到领取条件 5领取失败
	-- itemId : 物品id
	-- itemNum : 物品数量
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_ReceiveFootMarkCityRewardOk")

	WndFootBeatCard:getBeatCardRewardOK(id, result, VectorToTable(itemId), VectorToTable(itemNum))
end

--@brief	获取足迹城市商城（FOOTMARK_GetFootMarkCityShopOk = 16）
function ProtocolProcessorFootMark:parse_FOOTMARK_GetFootMarkCityShopOk(ids, itemIds, nums, dayLimits, canBuys, costItemIds, costNums)
	-- ids : 商品id 购买时发送
	-- itemIds : 商品对应的物品id
	-- nums : 物品数量
	-- dayLimits : 每日限购数量 -1不限购
	-- canBuys : 玩家可购买数量 -1无限
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_GetFootMarkCityShopOk")

	WndFootShop:setShopItemData(VectorToTable(ids), VectorToTable(itemIds), VectorToTable(nums), VectorToTable(dayLimits), VectorToTable(canBuys), VectorToTable(costItemIds), VectorToTable(costNums))
end

--@brief	购买足迹城市商城（FOOTMARK_BuyFootMarkCityShopItemOk = 18）
function ProtocolProcessorFootMark:parse_FOOTMARK_BuyFootMarkCityShopItemOk(result, itemId, itemNum)
	-- result : 购买结果 1成功 2物品数量不足 3商品不存在 4超出限购数量 5购买失败
	-- itemId : 物品id
	-- itemNum : 物品数量
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_BuyFootMarkCityShopItemOk")

	WndFootShop:buySuccess(result, VectorToTable(itemId), VectorToTable(itemNum))
end

--@brief	获取所有足迹星辰（FOOTMARK_FootmarkStarsAllInfoOk = 20）
function ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsAllInfoOk(starsId, posInfo, unLock)
	-- starsId : 星辰id
	-- posInfo : 槽位信息：{槽位：镶嵌宝石itemId,槽位：镶嵌宝石itemId,...}
	-- unLock : 星图是否解锁 0未解锁 1已解锁
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsAllInfoOk", 
		"\n starsId =",Serialize(VectorToTable(starsId)), 
		"\n posInfo =",Serialize(VectorToTable(posInfo)),
		"\n unLock =",Serialize(VectorToTable(unLock))
		)
	WndFootStar:getFootmarkStarsAllInfoOk(VectorToTable(starsId), VectorToTable(posInfo), VectorToTable(unLock))
end

--@brief	足迹宝石镶嵌（FOOTMARK_FootmarkStarsStoneMosaicOK = 22）
function ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneMosaicOK(code, nextStarsId)
	-- code : 镶嵌宝石状态：0 成功 1：失败
	-- nextStarsId : 解锁下一个星图
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneMosaicOK", code, nextStarsId)
	WndFootStar:getFootmarkStarsStoneMosaicOK(code, nextStarsId)
end

--@brief	拆除宝石（FOOTMARK_FootmarkStarsStoneDownOK = 24）
function ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneDownOK(code)
	-- code : 拆除宝石状态：0 成功 1：失败
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneDownOK", code)
	WndFootStar:getFootmarkStarsStoneDownOK(code)
end

--@brief	足迹宝石合成（FOOTMARK_FootmarkStarsStoneMergeOK = 26）
function ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneMergeOK(code, itemId, num, nextStarsId)
	-- code : 合成宝石状态：0 成功 1：失败
	-- itemId : 物品id
	-- num : 物品数量
	-- nextStarsId : 解锁下一个星图
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneMergeOK", code, nextStarsId)
	WndFootStar:getFootmarkStarsStoneMergeOK(code, itemId, num, nextStarsId)
end

---------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取足迹列表（FOOTMARK_GetFootmark=1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_GetFootmark_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:send_FOOTMARK_GetFootmark_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootmark, nflag, sMessage)
end

--@brief	使用足迹物品（FOOTMARK_UseFootmark=3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_UseFootmark, nflag, sMessage)
end

--@brief	足迹升级（FOOTMARK_UpgradeFootmark=5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_UpgradeFootmark_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:send_FOOTMARK_UpgradeFootmark_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_UpgradeFootmark, nflag, sMessage)
end

--@brief	足迹进阶（FOOTMARK_AdvancedFootmark=7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_AdvancedFootmark_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:send_FOOTMARK_AdvancedFootmark_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_AdvancedFootmark, nflag, sMessage)
end

--@brief	足迹改变状态（FOOTMARK_ChangeState=8）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_ChangeState_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:send_FOOTMARK_ChangeState_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_ChangeState, nflag, sMessage)
end

--@brief	获取足迹打卡城市 167+（FOOTMARK_GetFootMarkCityInfo = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_GetFootMarkCityInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_GetFootMarkCityInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootMarkCityInfo, nflag, sMessage)
end

--@brief	领取足迹城市打卡奖励 167+（FOOTMARK_ReceiveFootMarkCityReward = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_ReceiveFootMarkCityReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_ReceiveFootMarkCityReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_ReceiveFootMarkCityReward, nflag, sMessage)
end

--@brief	获取足迹城市商城 167+（FOOTMARK_GetFootMarkCityShop = 15）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_GetFootMarkCityShop_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_GetFootMarkCityShop_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootMarkCityShop, nflag, sMessage)
end

--@brief	购买足迹城市商城 167+（FOOTMARK_BuyFootMarkCityShopItem = 17）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_BuyFootMarkCityShopItem_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_BuyFootMarkCityShopItem_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_BuyFootMarkCityShopItem, nflag, sMessage)
end

--@brief	获取所有足迹星辰（FOOTMARK_FootmarkStarsAllInfo = 19）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsAllInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsAllInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsAllInfo, nflag, sMessage)
end

--@brief	足迹宝石镶嵌（FOOTMARK_FootmarkStarsStoneMosaic = 21）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneMosaic_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneMosaic_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneMosaic, nflag, sMessage)
end

--@brief	足迹星辰拆除宝石（FOOTMARK_FootmarkStarsStoneDown = 23）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneDown_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneDown_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneDown, nflag, sMessage)
end

--@brief	足迹宝石合成（FOOTMARK_FootmarkStarsStoneMerge = 25）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneMerge_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_FootmarkStarsStoneMerge_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_FootmarkStarsStoneMerge, nflag, sMessage)
end
