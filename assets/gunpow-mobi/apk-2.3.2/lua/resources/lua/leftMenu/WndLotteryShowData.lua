--WndLotteryShowData.lua
--@brief	WndLotteryShow的数据模块
--@date		2021/05/20
--@author	hyc
--@note		抽奖结果展示

WndLotteryShow = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLotteryShow:_init()
	self.m_root = nil	 	  			--场景根节点
	self.n_type = nil					--1装备，2宠物3坐骑4皮肤5足迹
	self.n_itemId = nil
	self.n_num = nil
	self.n_highCount = {}
	self.n_haveShow = 0
	self.n_tokenId = {}					--转换代币id
	self.n_tokenNum = {}
	self.conPlayer = nil
	self.m_mountSpine = nil
	self.m_skinSpine = nil
	self.m_footSpine = nil
	self.m_batch = nil
	self.m_tTargetPoint = nil 			--粒子特效飞往的目标位置
	self.m_nParticleIndex = 0			--粒子效果索引
	self.m_nRewardCount = 1 			--奖励数量
	self.m_nParticleRemoveIndex = 0 	--移除粒子的数量
	self.m_tRewardElement = nil 		--奖励
	self.m_bIsClickSkip = false 		--是否点击跳过动画
	self.m_natural = nil 				--宠物资质
	self.m_data = nil 					--宠物装备属性

	self.m_bIsClickTenSkip = false 		--是否点击跳过十连抽动画
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLotteryShow:_unInit()
	self.m_root = nil
	self.n_type = nil					--1装备，2宠物3坐骑4皮肤5足迹
	self.n_itemId = nil
	self.n_num = nil
	self.n_highCount = nil
	self.n_haveShow = nil
	self.n_tokenId = nil
	self.conPlayer = nil
	self.m_mountSpine = nil
	self.m_skinSpine = nil
	self.m_footSpine = nil
	self.m_batch = nil
	self.m_tTargetPoint = nil 			--粒子特效飞往的目标位置
	self.m_nParticleIndex = nil			--粒子效果索引
	self.m_nRewardCount = nil  			--奖励数量
	self.m_nParticleRemoveIndex = 0 	--移除粒子的数量
	self.m_tRewardElement = nil 
	self.m_bIsClickSkip = nil 		--是否点击跳过动画
	self.m_natural = nil 				--宠物资质
	self.m_data = nil 					--宠物装备属性

	self.m_bIsClickTenSkip = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLotteryShow:createElement()
	if WndLotteryShow.m_root ~= nil then
		WindowManager:removeWindow(WndLotteryShow.m_root, WndLotteryShow, true)
	end
	local element = WZUISystem:getInstance():createElement("WndLotteryShow")
	assert(element, "WndLotteryShow create element failed!")
	self:_init()
	return element
end

function WndLotteryShow:showLottery(ntype,itemId,num,highCount,tokenId,tokenNum,m_batch,natural, data)
	-- body
	WZLog("抽奖展示代币和数量",ntype,Serialize(itemId),Serialize(num),Serialize(natural))
	local parentRoot = WndLotteryShow:getLotteryRoot(ntype)
	local conLottery = GetElement(parentRoot, "conCenterContent_Lottery", WZUIContainer)
	WndBattleHud:_setContainerOpacity(conLottery, 120)
	WndLotteryShow.m_tLotteryData = {ntype = ntype, itemId = itemId, num = num, highCount = highCount, tokenId = tokenId, tokenNum = tokenNum, m_batch = m_batch,m_natural = natural,data=data}
	local scaleX = conLottery:getScaleX()
	local scaleY = conLottery:getScaleY()
	WndLotteryShow.m_nConLotteryScale = {scaleX = scaleX, scaleY = scaleY}

	local arrayAni = CCArray:create()
	local scaleTo = CCScaleTo:create(0.5, 0)
	local functionAni1 = CCCallFuncN:create(afterConScale)
	local functionAni2 = CCCallFuncN:create(afterLotteryBack)
	arrayAni:addObject(scaleTo)
	arrayAni:addObject(functionAni1)
	arrayAni:addObject(functionAni2)

	local sequence = CCSequence:create(arrayAni)

	conLottery:runAction(sequence)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    缩小动作播放完成后的回调
function afterConScale(element)
    -- body
    WndSummonEntrance.m_root:setVisible(false)
end

--@brief    特效播放完成后的回调
function afterLotteryBack(element)
    -- body
	local Wnd = WndLotteryShow:createElement()
	WndLotteryShow.n_type = WndLotteryShow.m_tLotteryData.ntype
	WndLotteryShow.n_itemId = WndLotteryShow.m_tLotteryData.itemId
	WndLotteryShow.n_num = WndLotteryShow.m_tLotteryData.num
	WndLotteryShow.n_highCount = WndLotteryShow.m_tLotteryData.highCount
	WndLotteryShow.n_tokenId = WndLotteryShow.m_tLotteryData.tokenId
	WndLotteryShow.n_tokenNum = WndLotteryShow.m_tLotteryData.tokenNum
	WndLotteryShow.m_natural = WndLotteryShow.m_tLotteryData.m_natural
	WndLotteryShow.m_data = WndLotteryShow.m_tLotteryData.data
	WndLotteryShow.m_tRewardElement = {}
	if WndLotteryShow.m_tLotteryData.ntype == 1 then
		WndLotteryShow.m_batch = WndLotteryShow.m_tLotteryData.m_batch
	end

    WindowManager:addWindow(Wnd , WndLotteryShow ,nil ,false)

    if element then
    	WndBattleHud:_setContainerOpacity(element, 255)
    	element:setScaleX(WndLotteryShow.m_nConLotteryScale.scaleX)
    	element:setScaleY(WndLotteryShow.m_nConLotteryScale.scaleY)
    	WndSummonEntrance.m_root:setVisible(true)
    end
end

--@brief 	根据类型获取相应抽奖界面根节点
function WndLotteryShow:getLotteryRoot(nType)
	-- body
	local parentRoot = nil 
    if nType == 1 then 
		parentRoot = WndEquipLottery.m_root
	elseif nType == 2 then 
		parentRoot = WndPetLottery.m_root
	elseif nType == 3 then 
		parentRoot = WndMountLottery.m_root
	elseif nType == 4 then 
		parentRoot = WndPhantomLottery.m_root
	elseif nType == 5 then 
		parentRoot = WndFootLottery.m_root
	elseif nType == 6 then 
		parentRoot = WndPetEquipLottery.m_root
	end

	return parentRoot
end


-------------------------------------私有方法模块End----------------------------------------
