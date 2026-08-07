--WndPetsData.lua
--@brief	WndPets的数据模块
--@date		2015/03/26
--@author	qixiang_xie
--@note		宠物模块

WndPets = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPets:_init()
	self.m_root = nil	 	  			--场景根节点
  self.m_nLoadingId = nil             --菊花id
  self.m_tCurPetsInfo = nil           --当前正在显示的宠物
  self.m_nTag = 0                     --显示星级的tag,0为全部，1为1星，2为2星，3为3星，4为4星，5为5星 
  self.m_choicePetList = nil          --当前选择宠物栏
  self.m_isToWar = false              --是否进行出战操作
  self.m_tPets = {}                   --宠物列表
  self.b_isWarState = false           --是否处于出战按钮的更改 
  self.m_warPet = nil                 --当前出战的宠物
  self.m_bISAlter = false
  self.n_cellTag = 1                  --当前宠物cell的Tag
  self.t_cellPet = {}
  self.n_refreshState = 0             --刷新节目的状态值，0表示不需要，1表示在其它界面，2表示需要刷新
  self.n_openInterfaceTag = nil       --需要打开的子界面id         
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数 
function WndPets:_unInit()
	self.m_root = nil
	self.m_nLoadingId = nil
	self.m_tCurPetsInfo = nil
	self.m_nTag = nil
  self.m_choicePetList = nil
  self.m_isToWar = nil
  self.m_tPets = nil   
  self.b_isWarState = nil
  self.m_warPet = nil
  self.m_bISAlter = nil
  self.n_cellTag = nil
  self.t_cellPet = nil
  self.n_refreshState = nil
  self.n_openInterfaceTag = nil          
end

--@brief    根据tag显示宠物相关ui
--@param    tag : 2(显示宠物属性)
--@param    tag : 3(显示宠物升级)
--@param    tag : 4(显示宠物进阶)
--@param    tag : 5(显示宠物重生)
--@param    tag : 6(显示宠物技能)
function WndPets:showPetsForTag(tag)
    WZLog("WndPets:showPetsForTag")
    if self.m_root == nil then
       local scenePet =WndPets:createElement()
       replaceScene(scenePet)
    end 
    self.m_visbleChildTag = tag
end


--@brief 宠物界面刷新
function WndPets:doRefresh( )
  WZLog("WndPets:doRefresh", self.n_refreshState)
  if self.n_refreshState ~= 0 then
    self.n_refreshState = 0
    table.sort(CacheCenter:getPlayerPetInfo(),sortPets)
    self:setPetList()
  end
  -- body
end

--@brief  设置tag
function WndPets:setShowTag(tag)
    self.m_visbleChildTag = tag
end

--load菊花
function WndPets:showLoading()
  self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--关闭菊花
function WndPets:closeLoading()
  MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPets:createElement()
  if WndPets.m_root ~= nil then
    WindowManager:removeWindow(WndPets.m_root, WndPets, true)
  end
	local element = WZUISystem:getInstance():createElement("WndPets")
	assert(element, "WndPets create element failed!")
	self:_init()
	return element
end

--@brief	设置点击返回按钮返回的场景绑定的Lua表引用
--@param	tLuaObj，场景绑定的Lua表引用
--@note		点击返回按钮后切换到设置的场景，如果tLuaObj设置为nil，则禁用返回按钮
function WndPets:setBackSceneLuaObj(tLuaObj)
	self.m_tBackSceneLuaObj = tLuaObj
end

--@brief	设置返回按钮点击回调(可置空)
--@param	callback:回调函数引用
--@param	tLuaObj:回调函数所属表对象
--@note		主要用于退出场景时回调
function WndPets:setBackButtonCallback(callback, tLuaObj)
    self.m_lpBackButtonCallback = callback
	self.m_tCallBackLuaObjMap[callback] = tLuaObj
end

--@breief 宠物子界面的打开方法
--@param  tag子界面的id：3=升级，4=进化，5=重生， 6=技能
function WndPets:openPets(tag)
  local wndPets = WndPets:createElement()
  if wndPets ~= nil then
      WindowManager:addWindow(wndPets, WndPets, false)
  end
  self.n_openInterfaceTag = tag
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief     获取宠物列表成功
function WndPets:GetAllPetListOk(itemId, name, icon,animation, advancedLevel, upgradeLevel, property, giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId,num,petExp,fighting,birthSkill,skill, petSkinItemId, fetterStatus)
  	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    WZLog("WndPets:GetAllPetListOk:",Serialize(itemId))
  	if playerPetId ~= nil and #playerPetId > 0 then
        CacheCenter:clearPlayerPetInfo()
        for i=1,#playerPetId do
           CacheCenter:addPlayerPetInfo(itemId[i], name[i], icon[i],animation[i],advancedLevel[i],upgradeLevel[i] ,property[i],giftSkill[i], commonSkill1[i], commonSkill2[i], isInUsed[i], playerPetId[i],num[i],petExp[i],fighting[i],birthSkill[i],skill[i], petSkinItemId[i], fetterStatus[i])
        end
        table.sort(CacheCenter:getPlayerPetInfo(), sortPets)
        self:setPetList()
  	end

  	if WndPetsSkill.m_root ~= nil then
  		  CacheCenter:_updatePlayerPetInfoData()
  	end
  	--如果在宠物进化界面，刷新列表
  	WndAscending:updatePetList()
end

--@brief  设置宠物信息
function WndPets:setPetInfo(petInfo, table)
  if self.m_tCurPetsInfo ~= nil and self.m_tCurPetsInfo.playerPetId ~= nil then
    WZLog("WndPets:setPetInfo:", table:getPetId(), self.m_tCurPetsInfo.playerPetId)
    if table ~= nil and table:getPetId() ~=  self.m_tCurPetsInfo.playerPetId then
      if self.m_choicePetList ~= nil then
          self.m_choicePetList:setState(false)
      end
      self.m_choicePetList = table
    else
      WZLog("GGGGGGG")
      return
    end
  end
  self.m_tCurPetsInfo = petInfo
  self:showPetInfo()
end


-------------------------------------私有方法模块End----------------------------------------
