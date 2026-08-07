--WndCommunityInfoData.lua
--@brief	WndCommunityInfo的数据模块
--@date		2013/12/25
--@author	林庆凯
--@note		公会信息

WndCommunityInfo = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityInfo:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sCommunityName = nil --公会名称
	self.m_sCommunityId = nil   --公会ID
	self.m_sCurrenlyPresident = nil  --现任会长
	self.m_sCommunityLevel = nil    --公会等级
	self.m_sTotalNum  = nil       --人数
	self.m_nTotemLevel  = nil      --图腾等级
	self.m_sMoney = nil         --资金
	self.m_sEnemyListNameAndId = nil  --敌对公会名称ID
	self.m_sEnemySituationList = nil  --战绩
	self.m_bHaveEnemyComminityInfo = false --是否有敌对公会
	self.warRank = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityInfo:_unInit()
	self.m_root = nil
	self.m_sCommunityName = nil --公会名称
	self.m_sCommunityId = nil   --公会ID
	self.m_sCurrenlyPresident = nil  --现任会长
	self.m_sCommunityLevel = nil    --公会等级
	self.m_sTotalNum  = nil       --人数
	self.m_nTotemLevel  = nil      --威望
	self.m_sMoney = nil         --资金 
	self.m_sEnemyListNameAndId = nil  --敌对公会名称ID
	self.m_sEnemySituationList = nil  --战绩
	self.m_bHaveEnemyComminityInfo = nil --是否有敌对公会
	self.warRank = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityInfo:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityInfo")
	assert(element, "WndCommunityInfo create element failed!")
	self:_init()
	return element
end


--@brief	设置公会名称，公会ID，现任会长，公会等级，人数，威望，资金，敌对玩家数据的函数
--@param #1 sCommunityName 公会名称
--@param #2 sCommunityId 公会ID
--@param #3 sCurrenlyPresident  现任会长
--@param #4 sCommunityLevel 公会等级
--@param #5 sTotalNum 人数
--@param #6 totemLevel  图腾等级
--@param #7 sMoney  资金
--@param #7 sCommunityDeclare  公会宣言
--@param #8 bHaveEnemyComminityInfo  是否有敌对公会
function WndCommunityInfo:setFreeconText(sCommunityName,sCommunityId,sCurrenlyPresident,sCommunityLevel,sTotalNum,totemLevel,sMoney,sCommunityDeclare,bHaveEnemyComminityInfo,warRank)
	WZLog("WndCommunityInfo:setFreeconText", sCommunityName)
	self.m_sCommunityName = sCommunityName
	self.m_sCommunityId = sCommunityId
	self.m_sCurrenlyPresident = sCurrenlyPresident
	self.m_sCommunityLevel = sCommunityLevel
	self.m_sTotalNum = sTotalNum
	self.m_nTotemLevel = totemLevel
	self.m_sMoney = sMoney
	self.m_sCommunityDeclare = sCommunityDeclare
	self.m_bHaveEnemyComminityInfo = bHaveEnemyComminityInfo
	self.warRank = warRank
	self:_setCommunityInfo()
end 

--@brief	设置公会宣言数据的函数
--@param #1 sCommunityDeclare 公会宣言
function WndCommunityInfo:setFreeconsCommunityDeclareText(sCommunityDeclare)
	self.m_sCommunityDeclare = sCommunityDeclare
end 

--@brief	设置敌对公会名称ID，战绩的函数
--@param #1  sEnemyListNameAndId 敌对公会名称ID
--@param #2  sEnemySituationList 战绩
function WndCommunityInfo:setFreeconEnemyCommunityText(sEnemyListNameAndId,sEnemySituationList)
	self.m_sEnemyListNameAndId = sEnemyListNameAndId
	self.m_sEnemySituationList = sEnemySituationList
end 

--@brief	从服务器返回申请入会成功的函数
function WndCommunityInfo:applyJoinCommunityOk()
	WZLog("WndCommunityInfo:applyJoinCommunityOk()")
	MsgBoxManager:showTipBox(LocalStrings.ALREADAY_APPLAY_FOR_COMMUNITY_MESSAGE)
	self:setJoinCommunityBtnEnable(false)
end 

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	英文包适配函数
function WndCommunityInfo:_adaptLanguage_en()
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"chairMan1_WndCommunityInfo",WZUILabelTTF):setScaleX(0.8)
	GetElement(self.m_root,"chairMan_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.58))
	GetElement(self.m_root,"num_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.525))
end

--@brief	泰文包适配函数
function WndCommunityInfo:_adaptLanguage_th()
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"chairMan1_WndCommunityInfo",WZUILabelTTF):setScaleX(0.8)
	GetElement(self.m_root,"chairMan_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.58))
	GetElement(self.m_root,"num_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.525))
end

--@brief	泰文包适配函数
function WndCommunityInfo:_adaptLanguage_vn()
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"chairMan_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.58))
	GetElement(self.m_root,"num_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.525))
end

-------------------------------------私有方法模块End----------------------------------------
