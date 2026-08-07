--WndDailyCopyData.lua
--@brief	WndDailyCopy的数据模块
--@date		2015-6-17
--@author	binshao
--@note		日常副本

WndDailyCopy = {
	--请不要在这里定义变量
}

GDailyCopy_Modle =  {0,0,0}
GDailyCopy_Modle2 =  nil
--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDailyCopy:_init()
	self.m_root = nil	 	  			--场景根节点
    
    self.m_tCopyData = nil              --副本数据
    self.m_tCellCopyList = nil          --副本单元格绑定的lua对象列表，key为副本序号

    self.tData = nil
    self.cellData = {}
    self.difficult = 1
    self.curTag = 0
    self.m_nLoadingId = nil             --副本LoadingId
	self.m_nResetNum = nil
	self.curInfo = nil
	self.m_tCleanoutCost = nil  		--扫荡消耗
	self.m_bSweepFinish = true           --记录是否已成功接收扫荡成功协议，防止多次点击扫荡按钮
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDailyCopy:_unInit()
	self.m_root = nil
    
    self.m_tCopyData = nil
    self.m_tCellCopyList = nil

    self.tData = nil
    self.cellData = nil
    self.difficult = nil
    self.curTag = nil
    self.m_nLoadingId = nil
	self.m_nResetNum = nil
	self.curInfo = nil
	self.m_tCleanoutCost = nil 
	self.m_bSweepFinish = nil
end

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDailyCopy:createElement()
	local element = WZUISystem:getInstance():createElement("WndDailyCopy")
	assert(element, "WndDailyCopy create element failed!")
	self:_init()
	return element
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
----@brief	初始化数据
--function WndDailyCopy:_initData()
--    self.tData = {}
--    for i = 1, 3 do
--        local selcet = i == 1 and true or false
--        local open = i ~= 3 and true or false
--        local data = {id = i, name = "日常副本"..i,open = open, select = selcet,
--            desc = "该副本感觉很NB"..i, num = "今日挑战次数 "..i, power = "消耗活力 "..i}
--        table.insert(self.tData, data)
--    end
--end

function WndDailyCopy:setData(data) 
    WZLog("WndDailyCopy:setData")
    self.tData = data
    self:_createCopyTable()
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

function WndDailyCopy:_initLocalData()

end

function WndDailyCopy:_initPlayerData()

end

function WndDailyCopy:_addCell(tag,cell,tcell)
    if not self.cellData[tag] then self.cellData[tag] = {} end
    self.cellData[tag].cell = cell
    self.cellData[tag].tcell = tcell
end

function WndDailyCopy:_getOpenCopyIndex()
    if GDailyCopy_Modle2 ~= nil then return GDailyCopy_Modle2 end

    for i = 1, #self.tData do
        local minDiff = self.tData[i].diff[1]
        if minDiff.isOpen then
            return i - 1
        end
    end
    return 0
end

function WndDailyCopy:onReset(element) 
	WZLog("WndDailyCopy:onReset", Serialize(self.curInfo))
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local needVip = 0
	local cost = {{70, 100}}
	local vipLevel = tonumber(CacheCenter:getPlayerInfo().vipLevel)
	for i=820,860 do
		local t = GDatatab_vip_restriction["id_"..i]
		if t ~= nil and t.type == 21 then
			needVip = t.vip_level
			break
		end
	end

	if CacheCenter:getPlayerInfo().vipLevel < needVip then
    	local sMsg = string.format(LocalStrings.MULTI_SWEEP_TIP, needVip)
        MsgBoxManager:showConfirmCancelBox(sMsg, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
		return
	end

	self.m_nResetNum = self.curInfo.resetTimes

	--判断剩余次数
	if self.m_nResetNum <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.DAILYRESET1)
		return
	end
	
	for i=820,860 do
		local t = GDatatab_vip_restriction["id_"..i]
		local count = self.curInfo.count + 1
		if t ~= nil and t.type == 21 and count == t.count then
			cost = t.cost
			break
		end
	end
	

	--弹出提示框
	local msg1 = string.format(LocalStrings.DAILYRESET2, tostring(cost[1][2])..GDatatab_item["id_"..cost[1][1]].name)
    MsgBoxManager:showConfirmCancelBox(msg1, self, self.resetConfirm, MSGBOXLEVEL_HIGH,nil)
	
end

--@brief	vip提示框的回调
function WndDailyCopy:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
    end
end

--@brief	提示框的回调
function WndDailyCopy:resetConfirm(nId, nResType)
	WZLog("WndDailyCopy:resetConfirm")
    if nResType == MSGBOXRESTYPE_CONFIRM then
		self.m_root:enableSchedule("resetConfirm1",0.01)
    end
end

function WndDailyCopy:resetConfirm1()
	WZLog("WndDailyCopy:resetConfirm1")
	self.m_root:disableSchedule()

	local cost = {{70, 0}}
	for k,v in pairs(GDatatab_vip_restriction) do
		local count = self.curInfo.count + 1
		if v.type == 21 and count == v.count then
			cost = v.cost
			break
		end
	end
	--判断货币不足
	if not JudgeMoneyIsEnough(tonumber(cost[1][1]), tonumber(cost[1][2]), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onResetFinish) then 
		return 
	end
	self:onResetFinish()
end

--确定重置
function WndDailyCopy:onResetFinish() 
	WZLog("WndDailyCopy:onResetFinish", self.curInfo.section)
	--MsgBoxManager:showTipBox("发送重置协议")	
	ProtocolProcessorSingleMap:send_MAP_GetDailyMap(self.curInfo.section )
end

--@brief 	返回错误协议时候，重置扫荡状态
function WndDailyCopy:resetSweepLab(bBool)
	-- body
	if self.m_root == nil then return end 

	self.m_bSweepFinish = bBool
end

--@brief 显示扫荡结果
function WndDailyCopy:showSweepResult(pointId, times, rewardId, rewardCount)
    WZLog("WndDailyCopy:showSweepResult")
    if self.m_root == nil then return end
    self.m_bSweepFinish = true
    WndSweepResult:showWindow({
        pointId = pointId,
        rewardNum = {#rewardId},
        rewardId = rewardId,
        rewardCount = rewardCount,
    }, 1)

    local index = self.curTag + 1
    local data = self.tData[index].diff[self.difficult]
    self.tData[index].passTime = self.tData[index].passTime + 1
    local nNum = data.localData.pass_times - self.tData[index].passTime 
    if nNum < 0 then nNum = 0 end
    --更新次数显示
    self:_showLeftTimes(nNum)
end
-------------------------------------私有方法模块End----------------------------------------
