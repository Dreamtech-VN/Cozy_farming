--WndCommunityPopContentData.lua
--@brief	WndCommunityPopContent的数据模块
--@date		2013/12/28
--@author	林庆凯
--@note		修改外部公告，修改内部宣言，战况，群发邮件共用的弹出框

WndCommunityPopContent = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityPopContent:_init()
	self.m_root = nil	 	  		   --场景根节点
	self.m_nCommunityId = nil          --公会ID
	self.nCurWindowTag  = nil          --窗口标记
	self.m_nEnemyCommunid  = nil       --战况敌对公会ID 
	self.tBattleSituationList = {}     --用来存储从服务器返回战况的数据表
	self.m_nSetEnemyImgFlag = nil      --设置敌对公会图片标记
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityPopContent:_unInit()
	self.m_root = nil
	self.nCurWindowTag = nil 
	self.tBattleSituationList = nil
	self.m_nEnemyCommunid  = nil       --战况敌对公会ID
	self.m_nSetEnemyImgFlag = nil      
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityPopContent:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityPopContent")
	assert(element, "WndCommunityPopContent create element failed!")
	self:_init()
	return element
end

--@brief	设置是那个窗口的标记方法
--@param  	nCurWindowTag  当前是那个窗口标记,1为修改外部宣言，2为修改内部公告
function WndCommunityPopContent:modifyCurWindow(nCurWindowTag )
	self.nCurWindowTag = nCurWindowTag 
end 

function WndCommunityPopContent:_policy()
	local tCell = nil 
	--
	tCell = self.m_root:getChildElement("editBoxInPutContent_WndCommunityPopContent")
	self:_setPolicyProperty(tCell)
	tCell = nil 
end

--中文策略属性
function WndCommunityPopContent:_setPolicyProperty(tCell,bPolicy)
	if self.m_root == nil or tCell == nil then
		return
	end
	bPolicy = bPolicy or false
	tCell = WZUIEditBox:luaTo(tCell)
	tCell:setSupportMultiChar(bPolicy)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
