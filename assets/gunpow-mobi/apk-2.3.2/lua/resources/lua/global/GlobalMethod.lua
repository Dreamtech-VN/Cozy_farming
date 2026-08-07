--GlobalMethod.lua
--@brief	公用方法定义
--@date		2013/12/09
--@author	叶威
--@note     定义全局公用方法
GlobalMethod =
{
     g_totalMemory = nil -- 系统总得内存大小
}
GlobalMethod.point = {}--ccp(0,0)
GlobalMethod.pointIndex = 1
GlobalMethod.size = {}--CCSize(0,0)
GlobalMethod.sizeIndex = 1
GlobalMethod.color = {}--ccc3(255,255,255)
GlobalMethod.colorIndex = 1

GlobalMethod.MaxSize = 200
--@breif 临时使用ccp 生命周期长的ccp 不能使用会自动覆盖
function GlobalMethod:ccp(x,y)
    local point = self.point[self.pointIndex] or ccp(0,0)
    if not self.point[self.pointIndex] then
        self.point[self.pointIndex] = point
    end

    self.pointIndex = self.pointIndex + 1
    if self.pointIndex > self.MaxSize then
        self.pointIndex = 1
    end

    point.x = x or 0
    point.y = y or 0
    return point
end

function GlobalMethod:CCSize(width,height)
    local size = self.size[self.sizeIndex] or CCSize(0,0)
    if not self.size[self.sizeIndex] then
        self.size[self.sizeIndex] = size
    end

    self.sizeIndex = self.sizeIndex + 1
    if self.sizeIndex > self.MaxSize then
        self.sizeIndex = 1
    end

    size.width = width or 0
    size.height = height or 0
    return size
end

function GlobalMethod:ccc3(red,green,blue)
     local color = self.color[self.colorIndex] or ccc3(255,255,255)
     if not self.color[self.colorIndex] then
        self.color[self.colorIndex] = color
    end

    self.colorIndex = self.colorIndex + 1
    if self.colorIndex > self.MaxSize then
        self.colorIndex = 1
    end

    color.r = red or 255
    color.g = green or 255
    color.b = blue or 255
    return color
end

--@brief	获得表的长度
function GetTableLen(t)
	local num = 0
	for k,v in pairs(t) do
		if v ~= nil then
			num = num + 1
		end
	end
	return num
end

WZLog = nil
--@brief 输出log定义
--@note	WZLog：必要调试和错误log， WZTempLog：临时调试log
function LogInit()
	--log定义
	function doNone(...) end --什么都不干
	WGameCmUtil:setEncryptProtocol(true)
	CCDirector:sharedDirector():setPrintFindFileLog(false)
	--只想要自已打印的时候
--	LOG_MYSELF = true
	if LOG_MYSELF then
		WZLog = doNone
		WZTempLog = CCLog
	else
		WGameCmUtil:setPrintLog(false)
		if ProjConfig.DEBUG == 1 then
			WGameCmUtil:setPrintLog(true)
			if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID or PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_WP8 or PlatformInfo:getCurrentPlatform() == 3 then
				--android平台
				WZLog = CCLog
				WZTempLog = CCLog
			else
				--ios，win32平台
				WZLog = FilterPrint
				WZTempLog = FilterPrint
			end
		end

		if WZLog == nil then
			WZLog = doNone
		end
		if WZTempLog == nil then
			WZTempLog = doNone
		end
	end
end

--@brief	根据脚本文件名动态加载脚本
--@param	fileName:脚本文件名
--@note		根据脚本文件名动态加载脚本
function include(fileName)
	WZResourceManager:getInstance():executeLuaFile(fileName)
end

--@brief	发送协议
--@param	data:协议要发送的数据
--@param	bShowLoading:是否显示loading窗口
--@note		发送协议的时候调用
function SendProtocol(data, bShowLoading, notCheckLogin)

    if notCheckLogin or GlobalGame.g_bisLogined  then
        KLuaMutiRegSocket:getInstance():send(data)
    else
        WZLog("SendProtocol 还没登录成功,不能发送协议!!!")
    end
end

--@brief  判断是否需要调用第三方渠道登入
function getLoginType()
  local curSdkObj = PassportSdkManager:getCurSdkObj()
  if curSdkObj then
    local config = curSdkObj.m_tConfig
    if config.SDKOtherConfig.isChannelLogin == "gp_fb" then --动态自定义支付界面
      	return 1,1,1
     elseif config.SDKOtherConfig.isChannelLogin == "fb" then
     	return 1,1,0
     elseif config.SDKOtherConfig.isChannelLogin == "gp" then
     	return 1,0,1
    end
  else
    return 0,0,0
  end
  return 0,0,0
end

--@brief	获取人物声音的类型
--@return #1声音类型
function GetRoleSound()
    if GlobalGame.g_nRoleSound == nil then
        local data = WZDataFile:getInstance():getUserData()
        if data ~=  nil then
            local soundType = data:getStringValue("SoundData", "soundType")
            if soundType ~= nil and soundType ~= "" then
                GlobalGame.g_nRoleSound = tonumber(soundType)
                return GlobalGame.g_nRoleSound
            end
        end
        GlobalGame.g_nRoleSound = 1
    end
	return GlobalGame.g_nRoleSound
end

--@brief	获取是否播放语音
--@return #1是否播放
function GetPlayTalk()
     local data = WZDataFile:getInstance():getUserData()
     if data ~=  nil then
		local playTalk = data:getStringValue("TalkData", "playTalk")
		if playTalk ~= nil and playTalk ~= "" then
			if playTalk == "0" then
				return 0
			end
		end
	end
	return 1
end

--@brief	根据UI节点名称创建UI节点
--@param	sName:UI节点名称
--@return   #1,UI节点
function CreateElement(sName)
    return WZUISystem:getInstance():createElement(sName) 
end

--@brief 获得宠物的名字
function GetPetNameById(id,advanceId)
	for k,v in pairs(GDatatab_pet_advanced) do
		if v.item_id == id and advanceId == v.level then
			return v.evo_name
		end
	end
	return GDatatab_item["id_"..id].name
end

--@brief 获取副本失败的跳转UI
function GetFailCopyUi()
	
	local ui_table = {}
	local level = CacheCenter:getPlayerInfo().level
	local gTable = {}
	--按优先级排序
	for k, v in pairs(GDatatab_lost) do
		table.insert(gTable, v)
	end
	function sortUI(a,b)
		return a.Priority > b.Priority
	end
	table.sort(gTable, sortUI)

	--条件判断
	function bCondition(tData)
		if tData.id == 1 then --等级低于60 
			if level < 60 then
				return true
			end
		elseif tData.id == 2 then --装备未穿戴齐全
			if #CacheCenter:getEquipedList() < 6 then
				return true
			end
		elseif tData.id == 3 then --未穿戴齐时装
			if #CacheCenter:getEquipedDecorationList() < 4 then
				return true
			end
		elseif tData.id == 4 then --有可装备的道具槽
			if WndSkillProp:hasNullCell() then
				return true
			end
		elseif tData.id == 5 then --穿戴中的装备等级低于角色等级
			for k, v in pairs(CacheCenter:getEquipedList()) do
				if v.extraInfo.strongLevel < level then
					return true
				end
			end
		elseif tData.id == 6 then --穿戴中的装备星数低于12
			for k, v in pairs(CacheCenter:getEquipedList()) do
				if v.extraInfo.starLevel < 12 then
					return true
				end
			end
		elseif tData.id == 7 then --穿戴中的装备星数低于12
			if not WBattleGlobal:getCurrent():isMyWeaponHaveSkill(SkillTableTypeConfig.FROZEN) and 
				not WBattleGlobal:getCurrent():isMyWeaponHaveSkill(SkillTableTypeConfig.TORNADO) then
				return true
			end
		elseif tData.id == 8 then --当前穿戴的武器没有镶嵌满宝石
			if not CacheCenter:weaponMountFull() then
				return true
			end
		elseif tData.id == 9 then --出战中的宠物低于角色等级
			local pet = CacheCenter:getPlayerInfo().petInfo
			if pet == nil or pet.upgradeLevel < level then
				return true
			end
		elseif tData.id == 10 then --穿戴中的装备星数低于12
			local lv,_ = CacheCenter:fightMountMaxUpOrStar()
			if not lv then
				return true
			end
		elseif tData.id == 11 then --出战中的宠物低于5星
			local pet = CacheCenter:getPlayerInfo().petInfo
			if pet == nil or pet.upgradeLevel < level then
				return true
			end
		elseif tData.id == 12 then --穿戴中的装备星数低于12
			local _,star = CacheCenter:fightMountMaxUpOrStar()
			if not star then
				return true
			end
		elseif tData.id == 13 then --是否首沖過
			if CacheCenter:getGameParam().gameStatus ~= "1" and tonumber(CacheCenter:getPlayerInfo().vipLevel) < 3 then
				return true
			end
		end
		return false 
	end
	--条件遍历
	for k, v in pairs(gTable) do
		if v.level <= level then --等级条件
			if bCondition(v) then
				table.insert(ui_table, v)
				if #ui_table >= 3 then
					return ui_table
				end
			end
		end 
	end
	--优先级遍历
	for k, v in pairs(gTable) do
		if v.level <= level then --等级条件
			table.insert(ui_table, v)
			if #ui_table >= 3 then
				return ui_table
			end
		end 
	end
end

--@brief	获取当前场景
--@return	#1，当前场景frame节点
function getRunningFrame()
	local rs = CCDirector:sharedDirector():getRunningScene()
	if rs ~= nil and rs:getChildrenCount() > 0 then
		return WZUIFrame:luaTo(tolua.cast(rs:getChildren():objectAtIndex(0),"CCNode"))
	end
	return nil
end

--@brief  获取当前运行的场景名称
function GetRunningSceneName()
	local sceneRoot = WindowManager:getSceneRoot()
	
	local sceneName = sceneRoot:getLuaObjectName()
	if sceneName == "SceneCopy" then
		if WndSingleCopy.m_root ~= nil then
			return "WndSingleCopy"
		elseif WndMultCopy.m_root ~= nil then
			return "WndMultCopy"
		elseif WndDailyCopy.m_root ~= nil then
			return "WndDailyCopy"
		elseif WndTowerScroll.m_root ~= nil then
			return "WndTowerScroll"
		end
	else
		local isExit = nil
		for i,v in ipairs(GlobalGame.chatScene) do
			if v == sceneName then
				isExit = true
			end
		end
		if isExit == nil then
			return "SceneCity"
		end
		return sceneName
	end
end

--@brief	获取场景根节点
function GetSceneRoot()
	return WindowManager:getSceneRoot()
end

--@brief	判断窗口是否为活动窗口(第一窗口)
--@param	tWndLuaObj,要判断的窗口绑定的lua表对象
function IfActiveWindow(tWndLuaObj)
	return WindowManager:ifActiveWindow(tWndLuaObj)
end

--@brief	将字符串转换成key存到tTable里(格式：变量=值)
--@param	tTable:存放的table
--@param	sValue:需要转换的字符串
--@note		转换后，tTable表中将多出一个key变量（主要针对人物动画使用）。
function StringIntsertToTable(tTable,sValue)
	--WZLog(debug.traceback())
    if tTable == nil or sValue == nil then
        return
    end
	local key = string.match(sValue,"^[%w_]+")
	if key ~= nil and key ~= "null" then
        WZLog("StringIntsertToTable one", sValue, key)
		tTable[key] = string.match(string.match(sValue,"\".+\""),"[%w_]+")
        WZLog("StringIntsertToTable two", sValue, key, tTable[key])
	end
end

--@brief	调用loadingstring
--@param	sStr:需要load的string
--@return	#1:返回str的返回
--@note		确保loadstring只load一次
function LoadConfigByString( sStr )
	if type(sStr) == "string" then
		return loadstring(sStr)()
	end
end

--@brief    延迟调用方法
--@param	func:要延迟调用的方法
--@param	tLuaObj:方法所属的Lua表，全局方法时赋空
--@param    nTime:延迟时间
--@param    ...:func入参列表
function DelayCallFunction(func, tLuaObj, nTime, ... )
    local arg = {...}
    local nId = 0
    local scheduleFunc = function ()
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nId)
        if tLuaObj then
            func(tLuaObj, unpack(arg))
        else
            func(unpack(arg))
        end
    end
    nId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(scheduleFunc, nTime, false)

    return nId
end

--brief 创建宠物动画
--@param element 动画父节点
--@param petId 宠物的id
--@param animation  宠物的动画文件，可为nil，当为nil时，根据petId得到宠物动画
--@brief petSkinItemId : 幻型后的宠物形象物品Id,0或nil没有幻型
function CreatePetAni(element, petId, animation,advanceLevel, petSkinItemId)
    WZLog("CreatePetAni one", tostring(element), tostring(petId), tostring(animation)) 
	if element == nil then
		return
	end

  	if element.removeAllChildrenWithCleanup then
    	element:removeAllChildrenWithCleanup(true)
  	end
  	local petAnimation = animation
  	if petSkinItemId and petSkinItemId > 0 then
  		local tempAnimation = GetPetAnimation(petSkinItemId, advanceLevel)
  		petAnimation = tempAnimation
  	end
	if petAnimation == nil then
		petAnimation = GDatatab_item["id_"..petId].animation_index_code
	end 
	--如果资源没有，则选择默认的幻化，并下载没有的宠物资源
	local existSpine = CheckEffectFile("armatures/pet/" .. petAnimation)
	if not existSpine then 
		local sIndex = string.gsub(petAnimation, "pet_", "")
        local downloadInfo = GetDownloadInfo(sIndex, "pet")
        if downloadInfo ~= nil then 
        	DownloadManager:addDownloadTask(8000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,sIndex, "DownloadResourceCallback", _G)
        end

		local tempAnimation = GetPetAnimation(11004, 1)
  		petAnimation = tempAnimation
	end
	local str = string.find(petAnimation, "_")
	local boolNewPet = (str ~= nil)
	local petAnimation = BattleAnimation:createAnimation(petAnimation, not boolNewPet)
	local animNode = petAnimation:getAnimNode()
	animNode:setRelativePosition(ccp(0.5,0.5))
	animNode:setAnchorPoint(ccp(0.5,0.5))
	animNode:setUseOriginSize(true)
	element:addChild(animNode)
	if  boolNewPet then
		petAnimation:play("wait",true)
	else
		petAnimation:play("0",true)
	end
	--添加特效
	local backFire = nil
	if advanceLevel and advanceLevel >= 6 then
		backFire = CCParticleSystemQuad:create("particle/pet_max_lizi.plist")
		backFire:setPositionType(kCCPositionTypeRelative)
		backFire:setAutoRemoveOnFinish(true)
		local posX,posY = animNode:getPosition()
		backFire:setPosition(posX,posY)
		element:addChild(backFire)
		--backFire:setPosition(posX,posY - 500)
	end
	WZLog("CreatePetAni two", tostring(element), tostring(petId), tostring(animation))
	return petAnimation, backFire
end

--@brief    节点中添加一个红色提示
--@param    element 节点
--@param    state 是否显示节点
--@param    pos 位置，可以为Nil
function  AddRemark(element, state, pos)
	if state then
		if element:getChildByTag(999) == nil then
			local img = WZUIImage:create()
			img:setFile("ui/common/common_icon_xiaodianzhui.png")
        	img:setTouchEnable(false)
			img:setUseOriginSize(true)
			img:setTag(999)
			img:setAnchorPoint(ccp(0.5,0.5))
			if pos == nil then 
				img:setRelativePosition(ccp(1,1))
			else
				img:setRelativePosition(pos)
			end
			element:addChild(img)
		end
	else
		if element:getChildByTag(999) then
			element:removeChildByTag(999, true)
		end
	end 
end  


--@brief	创建一个人物着装动画
--@param	nSex，主角性别，0:男，1:女
--@param	tEquip，字符串装备表，格式：{"bhead = "bhead8"","bbody = "bbody8"",...}
--@param	sAnimationName，动作名称，可赋空，默认为"room"
--@param	tWeaponInfo，武器信息，可赋空，格式：{proficiency=武器熟练度(百分比乘100所得),level=强化等级,icon=图片路径,nSkillType = 技能特效(可赋空)}
--@param	nPetId，宠物id，可赋空或-1
--@param	tBuff，buff表，可赋空，格式：{nRankLevel= 军衔等级 ,nVipLevel=会员等级 ,bDoubleExp=双倍经验,bDoubleGold=双倍金币,注:没有为空}
--@return	玩家着装动画的container
--@note
function CreataAPlayerAnimation( nSex , tEquip , sAnimationName , tWeaponInfo , nPetId , tBuff,tCell)
	--转换装备表
	local equip = {}
	for i=1,#tEquip do
		--StringIntsertToTable(equip,tEquip[i])
	end
    --设置默认显示，没有装备时显示新手装备
    --if equip.head == nil then
        StringIntsertToTable(equip, "bhead = \"bhead8\"")
    --end
    --if equip.face == nil then
        StringIntsertToTable(equip, "bface = \"bface8\"")
    --end
    --if equip.body == nil then
        StringIntsertToTable(equip, "bbody = \"bbody8\"")
    --end
    
	for i,data in pairs(equip) do 
		WZLog("个人物着装动画:",i,data)
	end
    
	--创建人物动画
	local con = AnimationManager:createRoleForShop(nSex, equip, sAnimationName)
	local conSize = con:getContentSize()
	if tCell then
		tCell:addChild(con)
	end
	local equipArmature = nil
	--	封装Buff列表:人物军衔等级，会员等级，双倍经验，双倍金币列表
	if tBuff ~= nil then
		local tBuffCell = {}
		--添加军衔等级
		if tBuff.nRankLevel ~= nil and tBuff.nRankLevel > 0 then
			local tTemp = {}
			local icon = "ui/main/qualifying/qualifying_%d.png"
			icon = string.format( icon , tBuff.nRankLevel )
			tTemp.icon = icon
			tTemp.name = "军衔等级"
			table.insert( tBuffCell , tTemp )
		end
		--添加VIP会员
		if tBuff.nVipLevel ~= nil and tBuff.nVipLevel > 0 and tBuff.bVipMark then
			local tTemp = {}
			local icon = "ui/rightMenu/vip/vip%d.png"
			icon = string.format( icon , tBuff.nVipLevel )
			tTemp.icon = icon
			table.insert( tBuffCell , tTemp )
		end
		--添加双倍经验
		if tBuff.bDoubleExp ~= nil and tBuff.bDoubleExp == true then
			local tTemp = {}
			local icon = "ui/bottomMenu/player/exp_2.png"
			icon = string.format( icon , tBuff.nVipLevel )
			tTemp.icon = icon
			table.insert( tBuffCell , tTemp )
		end
		--添加双倍金币
		if tBuff.bDoubleGold ~= nil and tBuff.bDoubleGold == true then
			local tTemp = {}
			local icon = "ui/bottomMenu/player/exp_2.png"
			icon = string.format( icon , tBuff.nVipLevel )
			tTemp.icon = icon
			table.insert( tBuffCell , tTemp )
		end
		if tBuffCell ~= nil and #tBuffCell ~= 0 then
			local x = 1.30
			local y = 0.80
			for i , v in pairs( tBuffCell ) do
				local nSpace = 80
				local image = createImage(v.icon,ccp(x,y),nil,true)
				con:addChild( image )
				local imageSize = image:getContentSize()
				y = y - nSpace / conSize.height
			end
		end
	end
	--创建宠物
	if nPetId ~= nil and ( type(nPetId) == "string" or nPetId > 0) then
		local conPetSprite , petSize = CreateAPetAnimation(nPetId,con)
		local conSize = con:getContentSize()
		local x = 0-petSize.width*0.5/conSize.width
		conPetSprite:setRelativePosition(ccp( x, 0))
		conPetSprite:setScale(0.8)
		conPetSprite:setZOrder(1)
	end
	--创建武器
	if tWeaponInfo then
		local weaponCon = WZUIContainer:create()
		weaponCon:setRelativeSize( CCSize(0.5 , 0.25) )
		weaponCon:setRelativePosition( ccp( 1.2 , 0.2 ) )
		local wIcon = nil
		if equip and equip.weapon then
			wIcon = "shopitems/"..equip.weapon..".png"
        end
		local icon = tWeaponInfo.icon or wIcon --图片路径
        if icon then
            local image = createImage(icon,nil,nil,true)
            image:setAnchorPoint(ccp(0.5,0.5))
            image:setScale( 0.6 )
            weaponCon:addChild(image)
            con:addChild( weaponCon )
        end
		--武器等级
		if tWeaponInfo.level ~= nil and tWeaponInfo.level ~= 0 then
			local tLabelImage = {}
			tLabelImage.icon = "image/common/num/weapon_level_number.png"
			local sLevel = ":%s"
			tLabelImage.desc = string.format( sLevel , tWeaponInfo.level )
			tLabelImage.pt = ccp( 1.20 , 0.24 )
			local imageLevel = createLevelImage( tLabelImage )
			imageLevel:setScale( 0.5 )
			con:addChild( imageLevel )
		end
		--武器熟练度文本
		if tWeaponInfo.proficiency ~= nil then
			--武器熟练度背景图
			local icon = "ui/common/common_black_bg.png"
			local imageSkilled = createImage(icon,ccp(1.2,0.07),CCSize(0.78,0.078))
			imageSkilled:setOpacity( 150 )
			con:addChild( imageSkilled )
			--武器熟练度文本
			local desc = string.format( "%5.2f" , tWeaponInfo.proficiency / 100 ) .. "%"
			local txtDesc = createLabel(desc,ccp(1.2,0.086))
			txtDesc:setZOrder(1)
			con:addChild( txtDesc )
		end
		--创建武器技能动画（放大转圈）
		if tWeaponInfo.nSkillType ~= nil and tWeaponInfo.nSkillType ~= 0 then
			local icon , nTime , color , isRotate , sName , pt , icon2  = getEquipActionDataByType( tWeaponInfo.nSkillType  )
			--添加武器被动技能(骨骼动画)
			equipArmature = equipArmatureAction( con,sName,pt )
		end
	end
	return con , equipArmature,pPetSprite
end

--@brief	创建一个宠物动画
--@param	nPetId，宠物id
function CreateAPetAnimation(nPetId,conPet)
	print(nPetId)
	if type(nPetId) == "number" then
		local sPetName = "pet%d"
		sPetName = string.format( sPetName , nPetId )
		WZLog("sPetName" , sPetName , sPetId,conPet)
		-- local petSprite = AnimationManager:createSpriteWithAnimation( sPetName , "stand")
		-- petSprite:playRepeat()

		if string.len(nPetId) == 1 then
			nPetId = "000" .. nPetId
		elseif string.len(nPetId) == 2 then
			nPetId = "00" .. nPetId
		end
		nPetId = "pet" .. nPetId
	end
	print(nPetId)
    local petAnim = BattleAnimation:createAnimation(nPetId,true)
    local petSprite = petAnim:getAnimNode()
    local size = petSprite:getContentSize()
    petSprite:setPosition(ccp(size.width/2, 0))

    local con = WZUIContainer:create()
    if conPet then
		conPet:addChild(con)
    end
    con:setUseAbsSize(true)
	con:setAbsContentSize(size)
    con:setAnchorPoint(ccp(0.5,0))
    con:addChild(petSprite)
	petAnim:play("0",true)
	for k,v in pairs(WPet.m_tPetDragonBone) do
		WZLog("pet:::::::::",k,nPetId)
		if k == nPetId then
			for _,effect in pairs(v) do
				petAnim:play("0",true,effect)
			end
			break
		end
	end
	return con , size
end
--@brief    获得字符串的utf8长度
--@param    sStr 字符串
--@return   #1,返回字符串的utf8长度
function ChineseStringLen(sStr)
	if not sStr then return 0 end
    local len = string.len(sStr)
    local i = 1
    local n = 0
    repeat
        local byte = string.byte(sStr,i)
        if BattleUtil:bitAnd(byte,0xC0) ~= 0x80 then
            n = n + 1
        end
        i = i + 1
    until i > len
    return n
end


function filterBadChar(str)
    --local str = "啊a̳̓̽̽̀҈̴̴̓̽̽拟稿t"
    --print("filterBadChar",string.len(str))
    if ProjConfig.LANGUAGE ~= "cn" then
    	return str
    end
    local length = string.len(str)
    local i = 1
    local tmpStr = ""
    repeat 
        local tmpByte = string.byte(str,i)
        if BattleUtil:bitAnd(tmpByte,0xE0) == 0xE0 then
            local tmpByte2 = string.byte(str,i+1)
            local tmpByte3 = string.byte(str,i+2)
            if BattleUtil:bitAnd(tmpByte2,0xC0) ~= 0x80 or BattleUtil:bitAnd(tmpByte3,0xC0) ~= 0x80 then 
                i = i + 1
                --print("filterBadChar bad")
            else 
                --print("filterBadChar chinese")
                tmpStr = tmpStr .. string.sub(str,i,i+2)
                i = i + 3
            end
        elseif tmpByte < 128 then 
        	--print("filterBadChar ascii")
            tmpStr = tmpStr .. string.sub(str,i,i)
            i = i + 1
        else 
            i = i + 1
            --print("filterBadChar bad")
        end
    until i > length
    return tmpStr
end

--@brief	切割字符串，并用“...”替换尾部
--@param	sName:要切割的字符串
--@return	nMaxCount，字符串上限,中文字为2的倍数
--@param	nShowCount：显示英文字个数，中文字为2的倍数,可为空
--@note
function GetShortName(sName,nMaxCount,nShowCount)
    if sName == nil or nMaxCount == nil then
        return
    end
    local sStr = sName
    local tCode = {}
    local tName = {}
    local nLenInByte = #sStr
    local nWidth = 0
    if nShowCount == nil then
       nShowCount = nMaxCount - 3
    end
    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = nil
        if byteCount > 0 then
            char = string.sub(sStr, i, i+byteCount-1)
            i = i + byteCount -1
        end
        if byteCount == 1 then
            nWidth = nWidth + 1
            table.insert(tName,char)
            table.insert(tCode,1)
            
        elseif byteCount > 1 then
            nWidth = nWidth + 2
            table.insert(tName,char)
            table.insert(tCode,2)
        end
    end
    
    if nWidth > nMaxCount then
        local _sN = ""
        local _len = 0
        for i=1,#tName do
            _sN = _sN .. tName[i]
            _len = _len + tCode[i]
            if _len >= nShowCount then
                break
            end
        end
        sName = _sN .. "..."
    end
    return sName
end
--@brief	根据分隔符拆分字符串
--@param	s:要分隔的字符串
--@param	sSeparator:分隔符
--@return	#1，拆分后的字符串数组
--@note
function SplitStringWithSeparator(s, sSeparator, sSeparator2, isNumber)
    if s == nil then return {} end
    if sSeparator == nil and isNumber then return {tonumber(s)} end 
    if sSeparator == nil then return {s} end
    
    local str = s .. sSeparator
    local findStr = string.match(str,"(.-)"..sSeparator)
    local result = {}
    local arrStr = {}
    while findStr do
        table.insert(arrStr,findStr)
        str = string.sub(str,string.len(findStr)+string.len(sSeparator)+1)
        findStr = string.match(str,"(.-)"..sSeparator)
    end
    
    if isNumber then 
        for _,str in ipairs(arrStr) do 
            table.insert(result,tonumber(str))
        end
    else 
        result = arrStr
    end
    return result
end

--@brief	将字符串数组按照分隔符组合成一个字符串
--@param	tArray:要组合的字符串数组
--@param	sSeparator:分隔符
--@return	#1，组合后的字符串
function CombineStringArrayWithSeparator(tArray, sSeparator)
    if type(tArray) == "string" then
        return tArray
    elseif type(tArray) ~= "table" or type(sSeparator) ~= "string" then
        return ""
    end
    local sResult = ""
    for i,s in ipairs(tArray) do
        if type(s) == "string" then
            if string.len(sResult) > 0 then
                sResult = sResult..sSeparator
            end
            sResult = sResult..s
        end
    end
    return sResult
end

--@brief	拆分物品字符串
--@param 	nSex : ~=nil 则配置为"[男物品Id,女物品Id,数量]&[男物品Id,女物品Id,数量]"
--@return	id数组和num数组
function SplitItemString(s, nSex)
	if s == nil then
		return
	end
	local array = SplitStringWithSeparator(s,"&")
	local ids = {}
	local nums = {}
	if nSex then 
		for i=1,#array do
			WZLog("SplitItemString",string.sub(array[i],2,-2))
			local string = string.sub(array[i],2,-2) 
			local id = SplitStringWithSeparator(string,",")[1]
			if nSex == 1 then 
				id = SplitStringWithSeparator(string,",")[2]
			end
			local num = SplitStringWithSeparator(string,",")[3]
			table.insert(ids,id)
			table.insert(nums,num)
		end
	else
		for i=1,#array do
			WZLog("SplitItemString",string.sub(array[i],2,-2))
			local string = string.sub(array[i],2,-2) 
			local id = SplitStringWithSeparator(string,",")[1]
			local num = SplitStringWithSeparator(string,",")[2]
			table.insert(ids,id)
			table.insert(nums,num)
		end
	end
	return ids,nums
end

--@brief	根据分隔符拆分爆炸动画字符串
--@param	s:要分隔的字符串
--@param	sSeparator:分隔符
--@return	#1，拆分后的字符串数组
--@note
function SplitExplodeStringWithSeparator(s)
    --WZLog("SplitExplodeStringWithSeparator one",s)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    local sSeparator = "FrameFile="

    while true do
        --WZLog("SplitExplodeStringWithSeparator two",nSplitIndex,tostring(nFindStartIndex),tostring(string.len(s)))
        nFindStartIndex = string.find(s, sSeparator, nFindStartIndex)

        if not nFindStartIndex then
            break
        end

        local nFindLastIndex = string.find(s, " GUID=", nFindStartIndex)

        nSplitArray[nSplitIndex] = "image/"..string.sub(s, nFindStartIndex + 11, nFindLastIndex - 2)
        nFindStartIndex = nFindLastIndex + string.len(sSeparator)
        nSplitIndex = nSplitIndex + 1

    end
    --"
    for i,v in pairs (nSplitArray) do
        WZLog("SplitExplodeStringWithSeparator three", i, v)
    end

    return nSplitArray
end

--@brief	根据分隔符拆分ai字符串"
--@param	s:要分隔的字符串
function SplitAiStringWithSeparator(s)
    --WZLog("SplitAiStringWithSeparator 0", s)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
    local sSeparator = " | "
    local sChange = "%),%("
    local sChanged = " | "
    
    s = string.gsub(s, " ", "")
    s = string.gsub(s, sChange, sChanged)
    s = string.gsub(s, "%(", "")
    s = string.gsub(s, "%)", "")
    --WZLog("SplitAiStringWithSeparator 1", s)
    
	nSplitArray = SplitStringWithSeparator(s, sSeparator)
    
    for i, v in pairs(nSplitArray) do
        if v == nil or v == "" then
            break
        end
        --WZLog("SplitAiStringWithSeparator array: ", tostring(v), i)
        nSplitArray[i] = SplitStringWithSeparator(v, ",")
        
        for j, u in pairs (nSplitArray[i]) do
           --WZLog("SplitAiStringWithSeparator array[j]: ", u, j)
        end
    end
    
    
	return nSplitArray
end

--@brief	根据分隔符拆分教学字符串
--@param	s:要分隔的字符串
function SplitTeachTalkStringWithSeparator(s)
    --WZLog("SplitTeachTalkStringWithSeparator 0", s)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
    local sSeparator = " | "
    local sChange = "%],%["
    local sChanged = " | "
    
    s = string.gsub(s, " ", "")
    s = string.gsub(s, sChange, sChanged)
    s = string.gsub(s, "%[", "")
    s = string.gsub(s, "%]", "")
    --WZLog("SplitTeachTalkStringWithSeparator 1", s)
    
	nSplitArray = SplitStringWithSeparator(s, sSeparator)
    
	return nSplitArray
end

--@brief	获得Element(带断言功能)
--@param	target:Element存在的节点
--@param	name:Element的名字
--@param	class:Element的类
--@note		name必须要在target下存在
function GetElement(target,name,class)
    if target == nil  then
    	WZLog("child node is nil ",name)
        WZLog(debug.traceback())
        return
    end
	local element = target:getChildElement(name)
	if element == nil then 
		--WZLog(debug.traceback())
        return
	end 
	assert(element,name.." is nil")
	if class ~= nil then
		element = class:luaTo(element)
		assert(element, name.." class error")
	end
	return element
end

--@brief	获得Element(不带断言功能)
--@param	target:Element存在的节点
--@param	name:Element的名字
--@param	class:Element的类
--@note		name必须要在target下存在
function GetElementWithoutAssert(target,name,class)
    if target == nil  then
        --WZLog(debug.traceback())
        WZLog("GetElementWithoutAssert",name)
    end
	local element = target:getChildElement(name)
	if element == nil then
        return
    end
	if class ~= nil then
		element = class:luaTo(element)
	end
	return element
end

--@brief	根据道具id获取本地数据信息
--@param	nId，道具id
--@note     从LocalData读取道具数据信息表
function GetItemLocalData(nId)
    if GDatatab_item == nil or type(nId) ~= "number" then
        WZLog(debug.traceback())
        return
    end
    return GDatatab_item["id_"..nId]
end

--@brief	数字转换为bit数组
--@param    n, 要转换的数字
--@param    nCount, 位数限制，例如nCount=3时只转换低3位, nil或0时没有限制
--@return   #1, bit数组, 从低位到高位
function NumberToBits(n, nCount)
    if n == nil or n < 0 then
        return {}
    end
    if n == 0 then
        return {0}
    end
    
    local tBits = {}
    if nCount == nil or nCount <= 0 then
        nCount = 128
    end
    while n > 0 and #tBits < nCount do
        table.insert(tBits, math.fmod(n, 2))
        n = math.floor(n/2)
    end
    return tBits
end

--@brief  带筛选功能的print，被筛选的字符串为 LogFilterString
LogFilterString = nil
function FilterPrint(...)
    local arg = {...}
	if LogFilterString == nil or string.find(tostring(arg[1]),LogFilterString) then
		local printResult = ""
		for i,v in ipairs(arg) do
			printResult = printResult .. tostring(v) .. "\t"
		end
		printResult = printResult .. "\n"
		printResult = "WZLuaLog:"..printResult
		io.write(printResult)
	end
end

--@brief	根据lua表生成Map
--@param	t,lua表,目前仅支持key和value都是字符串的表
--@return	#1,c++ map对象
function TableToMap(t)
	if t == nil then
		return
	end
	local map = WZLuaMap_string_string_:new()
	for i,v in pairs(t) do
		map:insert(i, v)
	end
	return map
end
--@brief	c++ vector转lua表
--@param	vec:c++ vector
--@return	#1:lua表
--@note		非数组时直接返回
function VectorToUserData(vec)
	if vec == nil then
		return nil
	end
	if type(vec) ~= "userdata" then
		return vec
	end
	local tTTt = {}
	for i=0,vec:size()-1 do
		tTTt[i+1] = vec:get(i)
	end
    function tTTt.get(a,x)
        local index = x+1
        return a[index]
    end
    function tTTt.size(a)
        return #a
    end
	return tTTt
end
--@brief	c++ vector转lua表
--@param	vec:c++ vector
--@return	#1:lua表
--@note		非数组时直接返回
function VectorToTable(vec)
	if vec == nil then
		return nil
	end
	if type(vec) ~= "userdata" then
		return vec
	end
	local tTTt = {}
	for i=0,vec:size()-1 do
		tTTt[i+1] = vec:get(i)
	end
	return tTTt
end

--@brief	lua表转根据c++ int vector
--@param	tTable:lua表
--@param	vecType:vector类型
--@return	#1:c++ vector
--@note		非table时直接返回
function TableToVector(tTable,vecType)
	if tTable == nil then
		return vecType:create()
	end
	if type(tTable) ~= "table" then
		return tTable
	end

	local vec = vecType:create()
	for i,value in ipairs(tTable) do
		vec:push(value)
	end

	return vec
end

--@brief	lua表转根据c++ int vector
--@param	tTable:lua表
--@return	#1:c++ int vector
--@note		非table时直接返回
function TableToIntVector(tTable)
	return TableToVector(tTable,WZLuaVector_int_)
end

--@brief	lua表转根据c++ byte vector
--@param	tTable:lua表
--@return	#1:c++ byte vector
--@note		非table时直接返回
function TableToByteVector(tTable)
	return TableToVector(tTable,WZLuaVector_byte_)
end

--@brief	lua表转根据c++ float vector
--@param	tTable:lua表
--@return	#1:c++ float vector
--@note		非table时直接返回
function TableToFloatVector(tTable)
	return TableToVector(tTable,WZLuaVector_float_)
end

--@brief	int型table 转 float型table
function IntTableToFloatTable( tTable )
	if tTable == nil then
		return nil
	end
	if type(tTable) ~= "table" then
		return tTable
	end
	local fTable = {}
	for key,value in pairs(tTable) do
		fTable[key] = BattleUtil:int2float(value)
	end
	return fTable
end

--@brief	c++ int vector 转 float型table
function IntVectorToFloatTable( tVec )
	local intTable = VectorToTable(tVec)
	return IntTableToFloatTable(intTable)
end

--@brief	float型table 转c++ int型vector
function FloatTableToIntVector( tTable )
	if tTable == nil then
		return nil
	end
	if type(tTable) ~= "table" then
		return tTable
	end

	local intVector = WZLuaVector_int_:create()
	for i,value in ipairs(tTable) do
		intVector:push(BattleUtil:float2int(value))
	end
	return intVector
end

--@brief	lua表转根据c++ string vector
--@param	tTable:lua表
--@return	#1:c++ string vector
--@note		非table时直接返回
function TableToStdStringVector(tTable)
	return TableToVector(tTable,WZLuaVector_std__string_)
end

--@brief	android下打印log的方法
--@note	    print在android不起作用
function CCLog( ... )
	local arg = {...}
	local printResult = ""
	for i,v in ipairs(arg) do
			printResult = printResult .. tostring(v) .. "\t"
	end
	printResult = "WZLuaLog:"..printResult
	CCLuaLog(printResult)
end

--@brief	table序列化成字符串
--@note	    用来打印table或储存table
function Serialize(obj,map__,bShow)
    local lua = ""
    if ProjConfig.DEBUG ~= 1 and not bShow then
        return lua
	end
	local map = map__ or {}
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
		if map[obj] ~= nil then return "{}" end
		map[obj] = 1
        lua = lua .. "{\n"
		for k, v in pairs(obj) do
			lua = lua .. "[" .. Serialize(k,map,bShow) .. "]=" .. Serialize(v,map,bShow) .. ",\n"
		end
		local metatable = getmetatable(obj)
			if metatable ~= nil and type(metatable.__index) == "table" then
			for k, v in pairs(metatable.__index) do
				lua = lua .. "[" .. Serialize(k,map,bShow) .. "]=" .. Serialize(v,map,bShow) .. ",\n"
			end
		end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        WZLog("can not serialize a " .. t .. " type.")
		--WZLog(debug.traceback())
    end
    return lua
end

--@brief	table序列化成字符串
--@note	    效率比上面的Serialize方法低
function TableToString(t)
    if ProjConfig.DEBUG ~= 1 then
        return ""
    end

    local address = {}
    if type(t) == "userdata" then
        return TableToString(getmetatable(t))
    end
    if type(t) ~= "table" then
        return t
    end
    address[t]=true
    local ret = ""
    local space, deep = string.rep(' ', 4), 0
    local function _dump(t)
        local temp = {}
        for k,v in pairs(t) do
            local key
            if type(k) == "string" then
                key = string.format("%q", k)
            else
                key = tostring(k)
            end
            if type(v) == "table" and not address[v] then
                address[v] = true
                deep = deep + 1
                ret = ret .. string.format("%s[%s] = {\n",string.rep(space, deep),key)
                _dump(v)
                ret = ret ..string.format("%s},\n",string.rep(space, deep))
                deep = deep - 1
            else
                if type(v) == "string" then
                    v = string.format("%q", v)
                else
                    v = tostring(v)
                end
                ret = ret ..string.format("%s[%s] = %s,\n",string.rep(space, deep + 1),key,v)
            end
        end
    end
    ret = ret ..(string.format("{\n"))
    _dump(t)
    ret = ret ..(string.format("}\n"))
    return ret
end

--@brief	table反序列化
--@note	    用来读取序列化后table
function Unserialize(lua)
    local t = type(lua)
    if t == "nil" or lua == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        lua = tostring(lua)
    else
        WZLog("can not unserialize a " .. t .. " type.")
    end
    lua = "return " .. lua
    local func = loadstring(lua)
    if func == nil then
        return nil
    end
    return func()
end

--@brief	根据下标获取vector中的元素
--@param	vec,c++ vector对象
--@param	nIndex,下标
--@return	#1,对应的元素
function getValueFromVector(vec, nIndex)
	if vec == nil or nIndex == nil then
		return
	end
	if vec:size() <= nIndex then
		return
	end
	return vec:get(nIndex)
end

--@brief	秒数转换成时间格式（11:11:11）
--@param	nSeconds,秒数
--@return	时间格式字符串
function returnToTimeFormat(nSeconds)
	local hours,minutes,seconds
    hours = math.floor(nSeconds/3600)
    minutes = math.floor((nSeconds%3600)/60)
    seconds = nSeconds%60
	return string.format("%02d:%02d:%02d",hours,minutes,seconds)
end

--@brief	时间格式转换成秒数（11:11）
--@param	时间格式字符串
--@return	nSeconds,秒数
function returnToSecond(sTime)
	local index = string.find(sTime,":")
	local hours = string.sub(sTime,1,index-1)
	local minutes = string.sub(sTime,index+1,string.len(sTime))
	return hours*3600+minutes*60
end

--@brief    时间格式转换成秒数（11:11:20）时：分：秒
--@param    时间格式字符串
--@return   nSeconds,秒数
function TimeToSeconds(sTime)
    local tTime = SplitStringWithSeparator(sTime,":")
    local hours = tonumber(tTime[1])
    local minutes = tonumber(tTime[2])
    local seconds = tonumber(tTime[3])
    return hours*3600 + minutes*60 + seconds
end

--@brief	秒数转换成时间格式（11:11:11）
--@param	nSeconds,秒数
--@param	bShowMinute,是否需要显示分钟
--@return	时间格式字符串
function returnToTimeFormat_Day(nSeconds, bShowMinute)
	local hours,minutes,seconds
	if nSeconds >= 24*3600 then 
		local nDays = math.floor(nSeconds/(24*3600))
		local hours = math.floor((nSeconds - nDays * 24 * 3600)/3600)
		if bShowMinute then 
			minutes = math.floor((nSeconds - nDays * 24 * 3600 - hours * 3600)/60)
			return nDays .. LocalStrings.DAY .. hours .. LocalStrings.HOUR1 .. minutes ..LocalStrings.MINUTE1
		else
			return nDays .. LocalStrings.DAY .. hours .. LocalStrings.HOUR1
		end
	else
	    return returnToTimeFormat(nSeconds)
	end
end

--@brief	根据物品主类型判断是否为装备
--@param	nMainType,主类型
--@return	#1,是否为装备
function IsEquip(nMainType)
    if nMainType >= ITEM_TYPE_WEAPON_THROW and nMainType <= ITEM_TYPE_HAIR then
        return true
    end
    return false
end

--@brief    创建一个页面切换按钮(上一页/下一页)的cell
--@param    nPageType，0:上一页，1:下一页
--@param    size，cell大小
--@param    nFontSize，字体大小
--@param    sClickFunc，响应方法名字
--@param    sNormalImg，正常情况下的背景图，可赋空使用默认图片
--@param    sSelImg，点击时的背景图，可赋空使用默认图片
--@param    sDisabledImg，被禁用时的背景图，可赋空
--@param    nRed,nGreen,nBlue 分别为红绿蓝三颜色
--@param    nImgTag 创建图片类型（若为空则为正常图片）其它为九宫格图片
function CreatePageSwitchCell(nPageType, size, nFontSize, sClickFunc, sNormalImg, sSelImg, sDisabledImg,nRed,nGreen,nBlue,nImgTag)
    local conCell = WZUIContainer:create()
    conCell:setUseAbsSize(true)
    conCell:setAbsContentSize(size)

    local txtCell = WZUILabelTTF:create()
    txtCell:setFontSize(nFontSize)
	if nRed ~= nil or nGreen ~= nil or nBlue ~= nil then 
		txtCell:setColor(ccc3(nRed,nGreen,nBlue))
	else
		txtCell:setColor(ccc3(0,0,0))
	end 
    if nPageType == 0 then
        txtCell:setText(LocalStrings.UPPAGE)
    else
        txtCell:setText(LocalStrings.DOWNPAGE)
    end
    conCell:addChild(txtCell, 1)

    if sNormalImg == nil then
        sNormalImg = "ui/main/shop/item_informatio_1_bg.png"
    end
    if sSelImg == nil then
        sSelImg = "ui/main/shop/item_informatio_1_bg_sel.png"
    end
	local imgNormal
	local imgSel 
	if nImgTag == nil then 
		imgNormal = WZUIImage:create()
		imgSel = WZUIImage:create()
	else 
		imgNormal = WZUI9Image:create()
		imgSel = WZUI9Image:create()
	end 
    imgNormal:setFile(sNormalImg)
    imgSel:setFile(sSelImg)
    local imgDisabled = WZUIImage:create()
    if sDisabledImg then
        imgDisabled:setFile(sDisabledImg)
    end

    local btnCell = WZUIButton:create()
    btnCell:setNormalElement(imgNormal)
    btnCell:setSelectElement(imgSel)
    btnCell:setDisableElement(imgDisabled)
    btnCell:setLuaDoneFunctionName(sClickFunc)
    conCell:addChild(btnCell)

    return conCell
end

--@brief    切换频道
--@param    nChannelId:频道id(具体常量id定义在GlobalDefine里)
function ChangeChatChannel(nChannelId)
    WZLog("ChangeChatChannel", nChannelId)
	if nChannelId~=nil then
		GlobalGame.g_nCurrentUIChannelId = nChannelId
		ProtocolProcessorGlobal:send_CHAT_ChangeChannel(nChannelId)
        
        local idStr = "id_" .. nChannelId
        if GDatatab_interface ~= nil and GDatatab_interface[idStr] ~= nil and GDatatab_interface[idStr].ismain == 1 then  
            GlobalGame.g_nLastMainChannelId = nChannelId
        end 
	end
end

--@brief    deep copy a table
--@param    _tab:原table
--@return	table:深拷贝table
--@note		重新建一个table(非引用)
function CopyTable(_tab,map_)
	if _tab == nil then
		return nil
	end
    local map = map_ or {}
    local tab = {}
    -- 如果已经拷贝过了 就直接返回原来拷贝了得 避免循环引用
    if map[_tab] ~= nil then 
        return map[_tab]
    end
    map[_tab] = tab
    for k, v in pairs(_tab) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = CopyTable(v,map)
        end
    end
    return tab
end

--brief 快速拷贝 table(原 table 不能有 metatable)
function QuickCopyTable(tab)
	if nil == tab then
		return
	end
	local tabNew = {}
	setmetatable(tabNew, {__index = tab})
	for k, v in pairs(tab) do
		if type(v) == "table" then
			tabNew[k] = QuickCopyTable(v)
		end
	end
	return tabNew
end

--@brief    把一个表的元素插入到另一个表中
--@param    tabTarget:被插入的table
--@param    tabSource:插入的table
function AddTableToTable(tabTarget,tabSource)
	for key,value in pairs(tabSource) do
		tabTarget[key] = value
	end
end

--@brief    创建武器等级图片图片
function createLevelImage( tImage )
	if tImage == nil then
		return
	end
	local labelImage = WZUILabelAtlasFont:create()
	labelImage:setCharMapFileName( tImage.icon )   	--图片路径
	labelImage:setHeight( 31 )						--字体图片的高度
	labelImage:setWidth( 24 )						--字体图片的宽度
	labelImage:setAnchorPoint( ccp( 0.5 , 0.5 ) ) 	--图片锚点
	labelImage:setRelativePosition( tImage.pt )		--图片相对位置
	labelImage:setText( tImage.desc )				--图片内容
	labelImage:setUseOriginSize( true )				--图片原始大小
	return labelImage
end

--@brief    创建图片
--@param    tImage:图片列表
--@return	image:图片节点
--@note		tImage.icon:图片路径
--@note		tImage.pt:图片相对位置
--@note		anPoint:锚点文字会
--@note		tImage.size:图片相对大小
function createImage(icon,pt,size,bOrigin, anPoint)
	if icon == nil then
		return
	end
	pt = pt or ccp(0.5,0.5)
	size = size or CCSize(1,1)
	bOrigin = bOrigin or false
	anPoint = anPoint or ccp( 0.5, 1)
	--创建图片
	local image = WZUIImage:create()		--创建图片
	image:setFile(icon) 					--图片路径
	image:setAnchorPoint(anPoint) 	--图片锚点
	image:setRelativePosition(pt)			--图片相对位置
	image:setUseOriginSize(bOrigin)			--图片原始大小
	image:setRelativeSize(size)				--图片相对大小
	return image
end

--@brief    创建创建文本
--@param    tLabel:文本列表
--@return	txt:返回文本节点
--@note		tLabel.desc  	--内容
--@note		tLabel.fontSize --字体大小
--@note		tLabel.pt    	--相对位置
--@note		tLabel.color 	--颜色
--@note		tLabel.anchorPt	--锚点
function createLabel(desc,pt,anchor,fontSize,color)
	fontSize = fontSize or 20--默认字体大小
	pt = pt or ccp(0.5,0.5)
	color = color or ccc3(255,255,255)--默认颜色
	anchor = anchor or ccp(0.5,1)--默认锚点
	local txt = WZUILabelTTF:create()
	txt:setText(desc) 			 --内容
	txt:setFontSize(fontSize)		 --字体大小
	txt:setRelativePosition(pt) --相对位置
	txt:setColor(color) 				 --颜色
	txt:setAnchorPoint(anchor) 		 --锚点
	return txt
end

--@brief    创建武器技能动画
--@param    con:人物动画节点
--@param    icon:动画图片路径
--@param    t:动画时间
--@param    color:动画图片颜色
--@param   isRotate:是否旋转
--@param   size:动画大小
--@param   postion:动画位置
--@return    con:返回人物动画节点
function createEquipAction( con , icon , t , color , isRotate , size , postion )
	--如果动画是椭圆循环转圈,获取转圈球图片路径
	if icon ~= nil then
		--创建容器
		size = size or CCSize( 0.12 , 0.12 )
		postion = postion or ccp( 1.2 , 0.2 )
		local equipCon = WZUIContainer:create()
		equipCon:setRelativeSize( size )
		equipCon:setRelativePosition( postion )
		equipCon:setZOrder(-1)
		--创建图片
		local tImage = {}
		tImage.icon = icon		--图片路径
		tImage.pt = ccp( 0.5 , 0.5 )		--图片相对位置
		local image = createImage( tImage.icon, tImage.pt )
		image:setColor( color )
		image:setAnchorPoint( ccp( 0.5 , 0.5 ) )
		image:setUseOriginSize(true)
		con:addChild( equipCon )
		equipCon:addChild( image )

		--创建序列动画
		local actionSequence = WZUIActionSequence:create()
		actionSequence:setIsLoop(true)
		--创建并列动画,用于透明和旋转
		local actionSpawn1 = WZUIActionSpawn:create()
		local actionSpawn2 = WZUIActionSpawn:create()
		local actionDelay = WZUIActionDelayTime:create()
		actionDelay:setDuration(0.35)
		--创建颜色渐变动作
		local actionFadeTo1 = WZUIActionFadeTo:create()
		actionFadeTo1:setDuration( t ) 	--渐变时间
		actionFadeTo1:setOpacity( 255 )	--渐变颜色
		--创建颜色渐变动作,颜色还原
		local actionFadeTo2 = WZUIActionFadeTo:create()
		actionFadeTo2:setDuration( t ) 	--渐变时间
		actionFadeTo2:setOpacity( 0 )	--渐变颜色
		--创建旋转
		local actionRotateTo = WZUIActionRotateTo:create()
		actionRotateTo:setDuration( t )		--旋转时间
		actionRotateTo:setAngle( 360 )		--旋转角度
		--创建旋转动画颜色渐变动作
		actionSpawn1:setChildAction( actionFadeTo1 )
		actionSpawn2:setChildAction( actionFadeTo2 )
		if isRotate == true then
			actionSpawn1:setChildAction( actionRotateTo )	--旋转动作
			actionSpawn2:setChildAction( actionRotateTo )	--旋转动作
		end
		actionSequence:setChildAction( actionSpawn2 )
		actionSequence:setChildAction( actionSpawn1 )
		actionSequence:setChildAction( actionSpawn2 )
		actionSequence:setChildAction( actionDelay )
		image:runUIAction( actionSequence )
		return con , image
	end
end

--@brief    创建武器被动技能技能动画(骨骼动画)
--@param    Con:人物动画节点
--@param    sName:武器动画名称
--@param    pt:武器动画位置
function equipArmatureAction( con,sName,pt)
	if con and sName then
		local armatureManager = CCArmatureDataManager:sharedArmatureDataManager()
		if armatureManager:getTextureData("white") == nil then
			armatureManager:addArmatureFileInfo("passiveSkill.png", "passiveSkill.plist", "passiveSkill.xml")
		end
		local equipArmature = WZArmature:create()
		equipArmature:setArmatureName( sName )
		equipArmature:setRelativePosition( pt )
		equipArmature:setUseOriginSize(true)
		con:addChild(equipArmature )
		equipArmature:play( 0 )
		return equipArmature
	end
	WZLog("骨骼动画:::end:::",sName)
end

--@brief    椭圆循环转圈动画图片的路径
--@param    nType:动画表现类型
--@param    t:动画周期时间
--@param    postion:动画位置
--@return   icon:返回动画图片的路径
function getEquipActionDataByType( nType , t , postion )
	if nType == nil or nType <= 0 then
		return
	end
	WZLog("getEquipActionDataByType:nType:",nType)
	local size = CCSize( 0.12 , 0.12 )
	local icon = nil
	local icon2 = nil
	local color = ccc3( 255 , 255 , 255 )
	t = t or 0.8
	local pt = ccp(1.2 , 0 )
	local isRotate = true
	local sName = nil
	if nType == 4 then 			--灼伤 黄光球在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/yellow.png"
		sName = "burn"
		isRotate = false
		pt = ccp(1.12 , 0.08)
	elseif nType == 5 then 		--疲劳 白球在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/white.png"
		sName = "fatigue"
		isRotate = false
		pt = ccp(1.2 , 0.08)
	elseif nType == 6 then		--重力 紫色光球在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/yellow.png"
		sName = "gravity"
	elseif nType == 7 then		--吸血 紫色光球在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/red.png"
		sName = "reds"
	elseif nType == 8 then 		--封印 黄球在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/thunder.png"
		sName = "seal"
		pt = ccp(1.26 , 0.148)
	elseif nType == 11 then 	--核弹 白球在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/white.png"
		icon2 = "common/animation/baptize/bomb.png"
		sName = "atomic"
		pt = ccp(1.14 , 0.148)
	elseif nType == 12 then 	--毒素 暗绿光球在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/green.png"
		sName = "toxin"
		pt = ccp(1.1 , 0.16)
	elseif nType == 13 then 	--寒冰 雪花在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/white.png"
		sName = "ice"
		pt = ccp(1.2 , 0.08)
	elseif nType == 14 then 	--锁足 黄球在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/green.png"
		sName = "lock"
		pt = ccp(1.2 , 0.09)
	elseif nType == 15 then		--眩晕 眩晕图案在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/yellow.png"
		sName = "dizzy"
		isRotate = false
		pt = ccp(1.2 , 0.08)
	elseif nType == 16 then		--击退 白色光球在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/white.png"
		sName = "white"
		pt = ccp(1.2 , 0.08)
	elseif nType == 17 then		--免坑 青色光球在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/yellow.png"
		sName = "anti"
	elseif nType == 18 then		--吸收 青色光球在武器右上角位置椭圆循环转圈
		icon = "common/animation/baptize/white.png"
		sName = "whites"
	elseif nType == 19 then		--免疫
		icon = "common/animation/baptize/white.png"
		sName = "immune"
	end
	postion = postion or pt
	return icon , t , color , isRotate , sName , postion , icon2
end

--@brief    增加彩条庆祝动画(自动加到父节点,但不会自动移除)
--@param    sTxtPngPath:文字图片路径
--@param    animParent:动画要addChild的父节点
--@param    tLuaTable:动画完成回调Table
--@param    sFunctionName:动画完成回调函数名
--@param    isLose:默认不用传参或者传nil（战斗专用，是否战败）
--@param    isShowAll:默认不ShowAll
--@return   动画元素Container
function CreateCelebrateWithColorBarAnimation(sTxtPngPath,animParent,tLuaTable,sFunctionName,isLose,isShowAll)
	local con = WZUIContainer:create()
	if isShow then
		con:setShowAll(true)
	end
	animParent:addChild(con)
	if not isLose then

		local psq = WZUISystem:getInstance():createElement("psqStar_WndUpgrade")
		psq:setRelativePosition(ccp(0.5,0.5))
		con:addChild(psq)

	end
	--彩条
	local spr = WZArmature:create()
	spr:setUseOriginSize(true)
	local action
	if not isLose then
		spr:setArmatureName("win")
		spr:setRelativePosition(ccp(0.5,0.42))
		action = WZUIArmatureAnimationById:create()
		action:setAnimationId(0)
		action:setLoop(1)
	else
        spr:setArmatureName("lose")
		spr:setRelativePosition(ccp(0.6,0.42))

		action = WZUIActionSpawn:create()
		local armature1 = WZUIArmatureAnimationById:create()
		armature1:setAnimationId(0)
		armature1:setLoop(1)

		local armature2 = WZUIArmatureAnimationById:create()
		armature2:setAnimationId(0)
		armature2:setLoop(1)
		armature2:setBone("lose_caidai")

		local armature3 = WZUIArmatureAnimationById:create()
		armature3:setAnimationId(0)
		armature3:setLoop(1)
		armature3:setBone("lose_piao")

		action:setChildAction(armature1)
		action:setChildAction(armature2)
		action:setChildAction(armature3)
	end
	con:addChild(spr)
	spr:runUIAction(action)

	--文字
	local txtImg = WZUIImage:create()
	txtImg:setFile(sTxtPngPath)
	txtImg:setUseOriginSize(true)
	con:addChild(txtImg)
	local jumpTo = WZUIActionJumpTo:create()
	jumpTo:setPosition( ccp( txtImg:getPositionX(),txtImg:getPositionY() ) )
	jumpTo:setHeight(40)
	jumpTo:setJumps(3)
	jumpTo:setDuration(5)
	jumpTo:setFinishLuaFunction(sFunctionName)
	jumpTo:setFinishLuaTable(tLuaTable)
	txtImg:runUIAction(jumpTo)

	if not isLose then
		 SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN)
		-- if WBattleGlobal:getCurrent():getMyHero().m_nBoyOrGirl == 0 then
  --           SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_BOY,false,true)
  --       else
  --           SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_GIRL,false,true)
  --       end
	else
		SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_LOSE)
	end

	return con
end


--@brief 需要下载时断开网络重新连接
function gotoFirstScene()
	WZLog("firstScene:  Scene_Splash::scene")
	IPDConnector.g_nNetConnectFlag = NET_FLAG_1
	local sceneSplashElement = WZUISystem:getInstance():createElement("splash")
	if sceneSplashElement ~= nil then
		replaceScene(sceneSplashElement)
	end
end

function SavePlayerLevel(level)
   CCUserDefault:sharedUserDefault():setIntegerForKey("CurrentLevel", level)
end

function LoadPlayerLevel()
   local level = CCUserDefault:sharedUserDefault():getIntegerForKey("CurrentLevel")
    return level
end
function saveCurrentOrder(jeson)
	-- body
	CCUserDefault:sharedUserDefault():setStringForKey("CurrentOrder", jeson)
end

function readLastOrder()
	-- body
	return CCUserDefault:sharedUserDefault():getStringForKey("CurrentOrder")
end

function SaveSophisticAttVisible(playerId, bValue)
   CCUserDefault:sharedUserDefault():setBoolForKey(string.format("SophisticAttVisible_%d", playerId), bValue)
end

function LoadDesiRedPointVisible(playerId)
   local bValue = CCUserDefault:sharedUserDefault():getBoolForKey(string.format("SophisticAttVisible_%d", playerId))
    return bValue
end

--@brief 根据大小显示相应的存储单位
--@param nsize:大小
--@return #1,返回大小描述字符串，如：1MB，2KB，3B
function GetMemoryStringOfSize( nsize )
	if nsize >= 1024 and nsize < 1024*1024  then
		return string.format("%.2fKB", nsize/1024)
	elseif nsize >= 1024*1024 then
		return string.format("%.2fMB",nsize/(1024*1024))
	else 
		return string.format("%.2fB",nsize)
	end
end

--@brief 重新加载所有资源
function KEngineReloadAll()
    if MsgBoxManager ~= nil then 
        MsgBoxManager:stop()
    end
    if NetManager ~= nil then
        NetManager:closeConnect()
    end
    KEngine:getInstance():reloadAll()
end

--===============================支付时使用==========================
--@brief 注册支付协议
--notice  
function RegisterProtolRecharge()
	-- body
   	local sPayment = WZFileUtil:getNodeValueFromXml("Payment")
    if sPayment == "WndRecharge" then
		ProtocolProcessorRecharge:regAll()
    	ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList(ProjConfig.CHANNEL_ID)
    elseif sPayment == "WndRechargeDefault" then
    	WZLog("支付短代列表的渠道号：",ProjConfig.CHANNEL_ID)
        ProtocolProcessorRecharge:regAll()
    	ProtocolProcessorSmsCode:regAll()
    	ProtocolProcessorSmsCode:send_GetSmsCodeNewList(ProjConfig.CHANNEL_ID)
    elseif sPayment == "WndRechargeAndroid" then
        ProtocolProcessorRecharge:regAll()
    	ProtocolProcessorSmsCode:regAll()
    	return
    end
	--ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList(tonumber(PassportSdkManager:getChannelId()))
end
--@brief 反注册支付协议
function UNRegisterProtolRecharge()
	-- body
	ProtocolProcessorRecharge:unregAll()
end
--@brief 保存苹果返回商品列表
function SaveProductedList()
	-- body
end

--@brief 向苹果或其他SDK请求列表
function QequestProductedFromAppStore()
	-- body
	WZLog("QequestProductedFromAppStore",GlobalGame.g_tProducteList,GlobalGame.g_tProducteList.ids)
    if GlobalGame.g_tProducteList == nil or GlobalGame.g_tProducteList.ids == nil then
        return
    end
    
    local tProductList = {ProductId = GlobalGame.g_tProducteList.ids}
    local tCurSdkObj = PassportSdkManager:getCurSdkObj()
	 WZLog("tCurSdkObj:::::::::::",tCurSdkObj,tProductList)
    if tCurSdkObj == nil then
        return
    end
    local sJsonArg = json.encode(tProductList)
    WZLog("sJsonArg:::::::~~~~~~~~~~~~~~~~~~~~~~~~~~~~",sJsonArg)
    tCurSdkObj:purchaseOthers(sJsonArg, PassportDefaultCallback.purchaseOthersCallback, PassportDefaultCallback)
end

--@brief	获取产品道具id列表成功的函数
function getProductIdFromGameServerOk(ids, icons, num,additional,price)
    -- ids : 产品id列表
	-- icons : 产品图片(选中效果在后面加“_sel”)
	-- pices : 产品价格
    GlobalGame.g_tProducteList.ids = ids        --产品Id
    GlobalGame.g_tProducteList.icons = icons      --产品icon
    GlobalGame.g_tProducteList.pices = num      --钻石数量
    GlobalGame.g_tProducteList.discount = additional   --赠送钻石数
    GlobalGame.g_tProducteList.productPrice = {}  --  价格
    GlobalGame.g_tProducteList.currency = ""     --价格后缀 （元，pp币，爱思币等）
    GlobalGame.g_tProducteList.currencySymbol = ""     --币种（人民币，美元的符号）
    
    local curSdkObj = PassportSdkManager:getCurSdkObj()
     if curSdkObj then
         local config = curSdkObj.m_tConfig
         if curSdkObj.m_tConfig ~= nil then
         	if config.SDKOtherConfig.currency ~= nil then
         		GlobalGame.g_tProducteList.currency = config.SDKOtherConfig.currency
         	else
         		GlobalGame.g_tProducteList.currencySymbol = "元"
         	end
         	GlobalGame.g_tProducteList.currencySymbol = config.SDKOtherConfig.currencySymbol
         	if config.SDKOtherConfig.currencySymbol == nil then
             	GlobalGame.g_tProducteList.currencySymbol = ""
         	end
         end

        local tProductdiscount = {ProductDiscount = GlobalGame.g_tProducteList.discount}
        local sJsonArg = json.encode(tProductdiscount)
        WZLog("sJsonArg:::::::gyq",sJsonArg,config.SDKOtherConfig.isNeedListToAppStore,#GlobalGame.g_tProducteList.productPrice)
        if config.SDKOtherConfig.isNeedListToAppStore == "true" and #GlobalGame.g_tProducteList.productPrice == 0 then
            QequestProductedFromAppStore()   -- 向苹果请求列表
        else
        	local currencySymbol = config.SDKOtherConfig.currencySymbol
            if currencySymbol == nil then
                currencySymbol = ""
            end
            for i = 1,#price do
                table.insert(GlobalGame.g_tProducteList.productPrice ,tostring(price[i]/1000))
                WZLog("价格=",price[i],i,price[i]/1000)
            end
        end
    end
    local sJsonArg = json.encode(GlobalGame.g_tProducteList)
    WZLog("sJsonArg:::::::gyq",sJsonArg)
end

--获取短代列表成功
function SaveSmsCodeListInfo(id,price,sms_code,itemId,itemName,ItemIcon,types,count)
	GlobalGame.g_tProducteList.ids = id        --产品短代号
    GlobalGame.g_tProducteList.icons = ItemIcon      --产品icon
    GlobalGame.g_tProducteList.pices = count      --钻石数量
    --GlobalGame.g_tProducteList.discount = discount   --产品折扣
    GlobalGame.g_tProducteList.productPrice = price -- {}  --  价格
    GlobalGame.g_tProducteList.itemId = itemId     --物品Id (钻石是27)
    GlobalGame.g_tProducteList.itemType = types     --物品类型（0 天数  1 个数  2月卡）
    GlobalGame.g_tProducteList.idsms = sms_code     --短代id
    GlobalGame.g_tProducteList.currency = ""     --价格后缀 （元，pp币，爱思币等）
    GlobalGame.g_tProducteList.currencySymbol = ""     --币种（人民币，美元的符号）


    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
         local config = curSdkObj.m_tConfig
         --越南语特殊情况处理
         if config.SDKOtherConfig.isNeedFastLogin == "true" then
         	GlobalGame.g_tProducteList.itemId = {27,27,27,27,27,27}
         	GlobalGame.g_tProducteList.ids = {"vn.goplay.bombom.105","vn.goplay.bombom.528","vn.goplay.bombom.1056","vn.goplay.bombom.2114","vn.goplay.bombom.5286","vn.goplay.bombom.10574"}--产品Id
    		GlobalGame.g_tProducteList.pices = {105,528,1056,2114,5286,10574}      --钻石数量
    		GlobalGame.g_tProducteList.productPrice = {"0.99","4.99","9.99","19.99","49.99","99.99"}  --  价格
    		GlobalGame.g_tProducteList.currency = ""     --价格后缀 （元，pp币，爱思币等）
    		GlobalGame.g_tProducteList.currencySymbol = ""     --币种（人民币，美元的符号）
         end 
         if curSdkObj.m_tConfig ~= nil then
         if config.SDKOtherConfig.currency ~= nil then
         	GlobalGame.g_tProducteList.currency = config.SDKOtherConfig.currency
         else
         	GlobalGame.g_tProducteList.currencySymbol = "元"
         end
         GlobalGame.g_tProducteList.currencySymbol = config.SDKOtherConfig.currencySymbol
         if config.SDKOtherConfig.currencySymbol == nil then
               GlobalGame.g_tProducteList.currencySymbol = ""
          end
            -- for i = 1 , #GlobalGame.g_tProducteList.productPrice do
            --     GlobalGame.g_tProducteList.productPrice[i] = GlobalGame.g_tProducteList.productPrice[i]
            -- end
         end
     end

    local sJsonArg = json.encode(GlobalGame.g_tProducteList)
    WZLog("sJsonArg:::::::gyq",sJsonArg)
	
end
--@退回后台
function ToBackGround()
	WZLog("ToBackGround", os.time())
	local  datet  = WGameCmUtil:GetCurrentDate()
    if ProtocolProcessorAccount ~= nil then
        ProtocolProcessorAccount:send_ACCOUNT_ToBackGround( datet )
    end
    if NetManager ~= nil then 
        g_beforeBackGroundEnableBreathNotify = not NetManager:isDisableBreathNotifyDisconnect()
        NetManager:disableBreathNotifyDisconnect()
    end
    --记录挂后台的时间
    g_TimeToBackground = os.time()
end

--@回到前台
function FromBackGround()
	WZLog("FromBackGround",os.time())
	local  datet  = WGameCmUtil:GetCurrentDate()
    if ProtocolProcessorAccount ~= nil then
        ProtocolProcessorAccount:send_ACCOUNT_FromBackGround( datet )
    end
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
 	--挂后台超过设定时间后，重连IPD
    if os.time() - g_TimeToBackground >= BACKGROUND_TIME_LIMIT and g_canReset and platForm ~= 3 then
    	--强制掉线
    	--IPDConnector.g_nNetConnectFlag = NET_FLAG_0
        KLuaMutiRegSocket:getInstance():closeSocket()
    	NetManager:pcb_ConnectFailed()
    	--MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_CONNECTION_FAILURE, IPDConnector, IPDConnector.toBackgroundTimeOutCallback, MSGBOXLEVEL_HIGH, nil,true)
    end                              
    if NetManager ~= nil and g_beforeBackGroundEnableBreathNotify == true then 
        NetManager:enableBreathNotifyDisconnect()
    end
    if SceneBattle ~= nil then 
        local touch = SceneBattle:getBattleTouch()
        touch = touch or SceneTeachBattle:getBattleTouch()
        if touch ~= nil and touch.m_tPoints ~= nil then
            for i=1,BattleTouch.MAX_TOUCH_NUM do
                touch.m_tPoints[i].status = BattleTouch.TOUCH_NONE
            end
        end
    end 
    --end
    g_beforeBackGroundEnableBreathNotify = false
end

--@brief    获取任务列表
--@param    #1 任务id,#2 任务状态，#3任务完成条件状态，#4玩家任务id
--@return   
function GetNeedTaskInfo(nTaskCount,tTaskId,tTaskStatus,tTaskTargetValue,tPtId)
    -- body
    GlobalGame.g_TeachTask.nTaskCount = nTaskCount
    GlobalGame.g_TeachTask.tTaskId = tTaskId
    GlobalGame.g_TeachTask.tTaskStatus = tTaskStatus
    GlobalGame.g_TeachTask.tTaskTargetValue = tTaskTargetValue
    GlobalGame.g_TeachTask.tPtId            = tPtId
    
    WZLog("GetNeedTaskInfo:::::::gyq",tostring(nTaskCount))
    for i=1,nTaskCount do
    	print(GlobalGame.g_TeachTask.tTaskId[i])
    	print(GlobalGame.g_TeachTask.tTaskStatus[i])
    end

    local tNeedTaskInfo = {TaskCount = GlobalGame.g_TeachTask.nTaskCount,tTaskId = GlobalGame.g_TeachTask.tTaskId,
    tTaskStatus = GlobalGame.g_TeachTask.tTaskStatus,tTaskTargetValue = GlobalGame.g_TeachTask.tTaskTargetValue,
    tPtId = GlobalGame.g_TeachTask.tPtId}
    local sJsonArg = json.encode(GlobalGame.g_TeachTask)
    WZLog("GetNeedTaskInfo:::::::gyq",sJsonArg)
end

--@brief	根据不同语言,调用相应适配函数
--@param	tLuaTable:适配界面的lua表对象
--@note		适配函数命名规则：“_adaptLanguage_” + project.conf中Language字段
function AdaptLanguage(tLuaTable)
	local language = ProjConfig.LANGUAGE
	
	if nil == language or type(language) ~= "string" or "" == language then
		WZLog("ProjConfig.LANGUAGE is invalid！")
	end

	if type(tLuaTable["_adaptLanguage_"..language]) == "function" then 
		tLuaTable["_adaptLanguage_"..language](tLuaTable)
	end 
end

--@brief	获取版本字符串的主版本和子版本
--@param	sVersion:版本字符串
--@return 	#1:主版本
--@return 	#2:子版本
--@note 	获取版本字符串的主版本和子版本
function GetVersion(sVersion)
	local i = 0
	local index = 0
	while i ~= nil do
		i = string.find(sVersion, "%.", i+1)
		if i ~= nil then
			index = i
		end
	end
	return string.sub(sVersion, 1, index-1), string.sub(sVersion, index+1, string.len(sVersion))
end

--@brief    检测指定模块所需lua资源是否完成，若未加载完成，则进行加载
--@param    nBlockID:模块ID（与界面ID一致）
function CheckLuaLoad(nBlockID)
	if g_bLuaFilesAllLoaded then
        return
    end
	
	if nil == LuaFilesList or 0 == #LuaFilesList then
		return
	end

    for _,v in pairs(LuaFilesList) do
        if v.belongBlock == nBlockID and v.loadFlag ~= LUALOAD_LOADED then
            WZResourceManager:getInstance():executeLuaFile(v.pathName)
            v.loadFlag = LUALOAD_LOADED
        end
    end
    WZLog("Block Lua Files All Loaded, nBlockID: ", nBlockID)
end

--@brief	断线重连后，特定界面跳转到上一级页面
--@note 	断线重连后，特定界面跳转到上一级页面
function TurnToUpLevelAfterReconnect()
    WZLog("TurnToUpLevelAfterReconnect", os.time(), GlobalGame.g_nUIChannelIdBeforeReconnect, RECONNECT_BATTLE_MODE)
    if WBattleGlobal:getCurrent():isReplayGame() then
    	return
    end

    if WBattleGlobal:getCurrent():isAudience() then
    	SceneBattle:leftBattle()
    	return
    end
    
    --单人副本
    if (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Loadding and RECONNECT_BATTLE_MODE == BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE)
    or (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Fighting_Single and RECONNECT_BATTLE_MODE == BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE) then
        --SceneCopy:showScene(1, RECONNECT_BATTLE_MAP,GlobalGame.g_nSingleCopyType)
    --日常副本
    elseif (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Loadding and RECONNECT_BATTLE_MODE == BattleConstants.g_tBossBattleMode.MODE_DAILY_STAGE)
    or (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Fighting_Daily and RECONNECT_BATTLE_MODE == BattleConstants.g_tBossBattleMode.MODE_DAILY_STAGE) then
        --SceneCopy:showScene(3)
    --爬塔副本
    elseif (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Loadding and RECONNECT_BATTLE_MODE == BattleConstants.g_tBossBattleMode.MODE_TOWER_STAGE)
    or (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Fighting_Tower and RECONNECT_BATTLE_MODE == BattleConstants.g_tBossBattleMode.MODE_TOWER_STAGE) then
        --SceneCopy:showScene(4)
    elseif WBattleGlobal:getCurrent():getBattleMode() ~= nil then
        --MsgBoxManager:showConfirmBox(LocalStrings.BATTLE_RECONNECT_FAIL, SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_NORMAL, nil, true)

		WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle = true
		if SceneBattle:getBattleLoop() then
			SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_NORMAL)
		end

        if g_nReconnectLoadingBoxID ~= -1 then
	        MsgBoxManager:stopLoadingBoxByMsgId(g_nReconnectLoadingBoxID)
	        g_nReconnectLoadingBoxID = -1
	    end

	    if WBattleGlobal:getCurrent().m_nRelinkLoading ~= -1 then
	        MsgBoxManager:stopLoadingBoxByMsgId(WBattleGlobal:getCurrent().m_nRelinkLoading)
	        WBattleGlobal:getCurrent().m_nRelinkLoading = -1
	    end

        if WndConfirmBox.m_root then
        	WindowManager:removeWindow(WndConfirmBox.m_root, WndConfirmBox, true)
        end
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_LINK_OUT)

        WBattleGlobal:getCurrent().m_nRelinkLoading = 99999999
        if WBattleGlobal:getCurrent().m_nNetLoading ~= -1 then
            MsgBoxManager:stopLoadingBoxByMsgId(WBattleGlobal:getCurrent().m_nNetLoading)
            WBattleGlobal:getCurrent().m_nNetLoading = -1
        end
        if SceneBattleLoading.m_root then
        	WBattleGlobal:getCurrent().m_nRelinkLoading = MsgBoxManager:showLoadingBox(9999999)
    	end

        local scene = 1
        if GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Loadding and SceneBattleLoading.__bReceiveEndLoading ~= true then
        	scene = 0
        end
        ProtocolProcessorBattleInterface:send_BATTLE_SynchronousBattleInfo(WBattleGlobal:getCurrent():getBattleId(), WBattleGlobal:getCurrent():getMyHero():getBattleId(), scene )

        --MsgBoxManager:showConfirmBox("test111!!!", SceneBattle, SceneBattle.leftBattle, MSGBOXLEVEL_NORMAL, nil, true)
        --[[
    	local delayTime = WZUIActionDelayTime:create()
	    delayTime:setDuration(3)
		delayTime:setFinishLuaFunction("synchronousBattleInfo")
		delayTime:setFinishLuaTable(WBattleGlobal)
		GetElement(WndBattleHud.m_root,"conWind_WndBattleHud"):runUIAction(delayTime)
		--]]
    end

    if WBattleGlobal:getCurrent():getBattleMode() ~= nil then
        return
    end

	--普通战斗、战斗房间返回战斗大厅
	if (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Loadding and RECONNECT_BATTLE_MODE == BattleConstants.g_nBATTLE_TYPE_NORMAL)
	   or (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Fighting_Normal and RECONNECT_BATTLE_MODE == BattleConstants.g_nBATTLE_TYPE_NORMAL)
	   or GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Room then
		local sceneHallElement = SceneHall:createElement()
		if sceneHallElement ~= nil then
			replaceScene(sceneHallElement)
		end
	--副本战斗、副本房间返回副本大厅
	elseif (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Loadding and RECONNECT_BATTLE_MODE == BattleConstants.g_nBATTLE_TYPE_BOSS)
	   or (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Fighting_Team_Boss and RECONNECT_BATTLE_MODE == BattleConstants.g_nBATTLE_TYPE_BOSS)
	   or GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Team_Copy_Room then
		SceneCopy:showScene(2)
	--世界Boss返回世界Boss大厅
	elseif (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Loadding and RECONNECT_BATTLE_MODE == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS)
	   or (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Fighting_World_Boss and RECONNECT_BATTLE_MODE == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS) then
		local worldBossElement = SceneCity:createElement()
		if worldBossElement ~= nil then
            SceneCity.m_bIsOpenWorldBoss = true
			replaceScene(worldBossElement)
		end
	--遗迹副本
	elseif (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Fighting_World_Boss and RECONNECT_BATTLE_MODE == MODE_REMAINSBOSS) then
		local SceneCity = SceneCity:createElement()
		if SceneCity ~= nil then
			replaceScene(SceneCity)
		end
	--公会Boss返回公会Boss大厅
	elseif (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Loadding and RECONNECT_BATTLE_MODE == BattleConstants.g_tBossBattleMode.MODEL_GUILD_STATE)
	   or (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Fighting_World_Boss and RECONNECT_BATTLE_MODE == BattleConstants.g_tBossBattleMode.MODEL_GUILD_STATE) then
		SceneCommunityMain:showInterface("copy")
    --公会战
    elseif (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Loadding and RECONNECT_BATTLE_MODE == BattleConstants.g_tBattleChannel.MODE_GUILD)
    or (GlobalGame.g_nUIChannelIdBeforeReconnect == Chat_Channel_Fighting and RECONNECT_BATTLE_MODE == BattleConstants.g_tBattleChannel.MODE_GUILD) then
        SceneCommunity:onJumpToCommunity()
	end

	GlobalGame.g_nUIChannelIdBeforeReconnect = -1
	RECONNECT_BATTLE_MODE = -1
    RECONNECT_BATTLE_MAP = nil
end

--@brief	设置关闭按钮位置
--@param	closeElement:关闭按钮节点引用
--@note 	设置关闭按钮距离屏幕右侧固定的距离（76像素）
function SetCloseButtonPos(closeElement)
	local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
	local screenWidth = screenSize.width
	local screenHeight = screenSize.height
	local scale = CCEGLView:sharedOpenGLView():getScaleX()
	local scaleY = CCEGLView:sharedOpenGLView():getScaleY()

	--ios480x320分辨率特殊处理
	if "iPhone OS" == WZDeviceInfo:systemName() and 480 == screenWidth and 320 == screenHeight then
		screenWidth = screenWidth * 2
		screenHeight = screenHeight * 2
		scale = scale * 2
		scaleY = scaleY * 2
	end
	
	if scaleY < scale then
		scale = scaleY
	end

	local conClosePosX = (screenWidth - (screenWidth-1136*scale)/2 - 76 )/scale
	
	closeElement:setAbsPosition(ccp(conClosePosX, closeElement:getAbsPosition().y))
end

--@brief	更新容器每个child（相对大小，位置）
--@param	tCell：节点
--@param	tData.oldSize：节点原来的相对大小
--@param	tData.curSize：节点当前的相对大小
--@note 	适合多语言控件大小变动，如果容器包含超过4级，最好不要调用
function updateAllChild(tCell,tData)
	if tCell == nil or tData == nil then
		return
	end
	local childArray = tCell:getChildren()--child数组
	local childCount = tCell:getChildrenCount()--child数量
	if childCount <=0 or childArray == nil then
		return
	end
	--遍历每一个child
	for i=0,childCount-1 do 
		local child = tolua.cast(childArray:objectAtIndex(i),"CCNode")
		child = WZUIElement:luaTo(child)
		if child then
			local size = child:getRelativeSize()--获取节点的相对大小
			local pt = child:getRelativePosition()--相对位置
			pt.x = pt.x*tData.curSize.width/tData.oldSize.width
			pt.y = pt.y*tData.curSize.height/tData.oldSize.height
			child:setRelativeSize(size)
			child:setRelativePosition(pt)
			updateAllChild(child,tData)
		end
	end
end

--@brief	移动MM——有数事件采集
--@param	eventName : 事件名称
--@param	eventValue : 事件值
function DataUUtil( eventName, eventValue )
	local curSdkObj = PassportSdkManager:getCurSdkObj()

    if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.useDataCollect == "true" then
        local config = curSdkObj.m_tConfig
    	curSdkObj:extraInterfaceAccessReturn("onEvent",json.encode({eventName=eventName,eventValue=eventValue}))
    end
end 

--@brief	sdk扩展接口管理
--@param	sdkType：扩展类型，account，purchase
--@param	funcType：调用SDK方法的名称
--@param     其他所需参数，如：playerId，serverCode，chinanelId.....
function sdkOthersManager( sdkType, funcType , ... )

    local curSdkObj = PassportSdkManager:getCurSdkObj()
    local config = curSdkObj.m_tConfig
    if curSdkObj then
        if sdkType == "account" then
         	local accountOthers = {}
            accountOthers.funType = funcType
            local sJson = json.encode(accountOthers)
            curSdkObj:accountOthers( sJson,nil,nil)
         elseif sdkType == "purchase" then
         	local purchaseOthers = {}
            purchaseOthers.funcode = funcType
            local sJson = json.encode(purchaseOthers)
            curSdkObj:purchaseOthers( sJson,nil,nil)
        end
    end
end

--@brief	本地推送所需信息列表请求
function scheduleCheckIsNeedPushList()
    do return end
	--regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetPushListOk, "ProtocolProcessorAccount:parse_ACCOUNT_GetPushListOk", "ssb")
	-- bodyos.time() - g_TimeToBackground >= BACKGROUND_TIME_LIMIT
    --WZLog("qqqqqqqqqqqqqqqqqq",os.time() - g_TimePlayerLogin)
    WZLog("是否是低端机",checkIsBadMachine())
	if checkIsBadMachine() == false then --PLAYERLOGIN_TIME_LIMIT then
		local version = CCUserDefault:sharedUserDefault():getStringForKey("pushVersion")
		WZLog("qqqqqqqqqqqqqqqqqq",version)
		if version == nil or version =="" then
            WZLog("qqqqqqqqqqqqqqqqqqversion=%d",0)
			ProtocolProcessorAccount:send_request_PushMessageList("0")
		else
			ProtocolProcessorAccount:send_request_PushMessageList(tostring(version))
		end
	end
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_checkPushNeedList)
end

--@brief	创建一个人物着装动画
--@param	element:添加人物的节点
--@param	nSex，主角性别，0:男，1:女
--@param	tEquip，字符串装备表，格式：{"bhead = "bhead8"","bbody = "bbody8"",...}
--@param	sAniName，动作名称，可赋空，默认为"room"
--@param	tWeapon，武器信息，可赋空，格式：tWeapon.id,武器id,tWeapon.weaponFun是武器点击回调
--@param	tPetId，宠物tPetId.id，可赋空或-1
--@param	tBuff，buff表，可赋空，格式：{nRankLevel= 军衔等级 ,nVipLevel=会员等级 ,bDoubleExp=双倍经验,bDoubleGold=双倍金币,注:没有为空}
--@return	玩家着装动画的container
function createPlayerAni(element,nSex,tEquip,sAniName,tWeapon,tBuff,tPetId)-- , tWeaponInfo , nPetId , tBuff,tCell
	--转换装备表
	local equip = {}
	for i=1,#tEquip do
		StringIntsertToTable(equip,tEquip[i])
	end
	--创建人物动画setAbsContentSize(CCSize(106,230))
	local conPlayer = AnimationManager:createRoleForShop(nSex, equip, sAniName)
	element:addChild(conPlayer)
	local a = conPlayer:getRelativePosition()
	local b = conPlayer:getUseAbsSize()
	local c = conPlayer:getAnchorPoint()
	--封装Buff列表:人物军衔等级，会员等级，双倍经验，双倍金币列表
	local conBuff = createBuff(conPlayer,tBuff)
	--创建武器
	createPlayerWeapon(conPlayer,tWeapon)
	--宠物
	createPlayerPet(conPlayer,tPetId)
	return conPlayer
end


--封装Buff列表:人物军衔等级，会员等级，双倍经验，双倍金币列表
function createBuff(element,tBuff,pt,anchor)
	tBuff = tBuff or {}
	local tData = {}
	if tBuff.rank == nil or tBuff.rank < 1 then--军衔等级
		local temp = {}
		temp.norIcon = "ui/main/qualifying/qualifying_1.png"
		temp.selIcon = "ui/main/qualifying/qualifying_1.png"
		temp.backFun = "onRankClick"
		tData[1] = temp
	else
		local temp = {}
		temp.norIcon = "ui/main/qualifying/qualifying_1.png"
		temp.selIcon = "ui/main/qualifying/qualifying_1.png"
		temp.backFun = "onRankClick" 
		tData[1] = temp
	end
	if tBuff.vipLevel == nil or tBuff.vipLevel < 1 then--vip等级0表示非VIP
		local temp = {}
		temp.norIcon = "ui/rightMenu/vip/vip1_not.png"
		temp.selIcon = "ui/rightMenu/vip/vip1_not.png"
		temp.backFun = "onVipClick"
		tData[2] = temp
	else
		local temp = {}
		temp.norIcon = string.format("ui/rightMenu/vip/vip%d.png",tBuff.vipLevel)
		temp.selIcon = string.format("ui/rightMenu/vip/vip%d.png",tBuff.vipLevel)
		temp.backFun = "onVipClick"
		tData[2] = temp
	end
	if tBuff.bDoubleExp == nil or tBuff.bDoubleExp == false then--双倍经验卡
		local temp = {}
		temp.norIcon = "ui/bottomMenu/player/exp_2_not.png"
		temp.selIcon = ""--"ui/bottomMenu/player/exp_2_not.png"
		temp.backFun = "onDoubleClick"
		tData[3] = temp
	else
		local temp = {}
		temp.norIcon = "ui/bottomMenu/player/exp_2.png"
		temp.selIcon = "ui/bottomMenu/player/exp_2.png"
		temp.backFun = "onDoubleClick"
		tData[3] = temp
	end
	tBuff = tData
	pt = pt or ccp(1.3,1)
	anchor = anchor or ccp(0.5,1)
	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(CCSize(40,120))
	con:setRelativePosition(pt)
	con:setAnchorPoint(anchor)
	element:addChild(con)
	local y = 1
	for i,data in pairs(tBuff) do 
		local conBtn = createPlayerBtn(data.norIcon,data.selIcon,data.backFun,ccp(0.5,y),CCSize(40,40),ccp(0.5,y),true)
		con:addChild(conBtn)
		y = y -0.5
	end
	return con
end

--创建武器
function createPlayerWeapon(con,tWeapon,pt,anchor)
	local items = CacheCenter:getPlayerItems()
	local index = 0 
	for i,data in pairs(items.id) do 
		if data == tWeapon.id then
			index = i
			break
		end
	end
	local tBasic = items.basicInfo[index]
	local tExtra = items.extraInfo[index] or {}
	local funName = tWeapon.weaponFun or ""
	pt = pt or ccp(1.3,0.25)
	anchor = anchor or ccp(0.5,0.5)
	local weaponCon = WZUIContainer:create()
	weaponCon:setUseAbsSize(true)
	weaponCon:setAbsContentSize(CCSize(81,76.8))--135,128
	weaponCon:setRelativePosition(pt)
	weaponCon:setAnchorPoint(anchor)
	weaponCon:setTouchEnable(false)
	con:addChild(weaponCon)
	local btn = createPlayerBtn(tBasic.icon,tBasic.icon,funName,ccp(0.5,1),CCSize(81,76.8))
	weaponCon:addChild(btn)
	if tExtra.strongLevel ~= nil and tExtra.strongLevel ~= 0 then--强化等级
		local desc = ":"..tExtra.strongLevel
		local levelElement = createAtlasFont(desc,nil,nil,nil,0.6)
		weaponCon:addChild(levelElement)
	end
	--武器熟练度背景图
	local icon = "ui/common/common_black_bg.png"
	local imageSkilled = createImage(icon,ccp(1.22,0.088),CCSize(0.78,0.084))
	imageSkilled:setOpacity(150)
	imageSkilled:setZOrder(-1)
	con:addChild( imageSkilled )
	--武器熟练度
	local desc = string.format("%5.2f",tExtra.proficiency/100).."%"
	local prolevel = createLabel(desc,ccp(1.22,0.098))
	con:addChild(prolevel)
	local skillId1 = 0--技能1
	if tExtra.skillId1 and WeaponSkills["id_"..tExtra.skillId1] then
		skillId1 = WeaponSkills["id_"..tExtra.skillId1].id
	end
	local skillId2 = 0--技能2
	if tExtra.skillId2 and WeaponSkills["id_"..tExtra.skillId2] then
		skillId2 = WeaponSkills["id_"..tExtra.skillId2].id
	end
	--添加武器被动技能(骨骼动画)
	local sName,pt,icon,icon2,isRotate = getWeaponSkillAniName(math.max(skillId1,skillId2),postion)
	equipArmature = equipArmatureAction(con,sName,pt)
	return weaponCon
end

function createPlayerPet(element,tPetId,pt,flip)
	flip = flip or false
	tPetId = tPetId or {}
	local nPetId = tPetId.id
	if element and nPetId ~= nil and nPetId > 0 then
		local petName = 10000
		petName = petName + nPetId
		nPetId = "pet" .. string.sub(tostring(petName),2)
		local beganFun = tPetId.beganFun or ""
		local moveFun = tPetId.moveFun or ""
		local endFun = tPetId.endFun or ""
		local conSize = element:getContentSize()
		local petAnim = BattleAnimation:createAnimation(nPetId,true)
		local petSprite = petAnim:getAnimNode()
		if flip then
			petSprite:setFlipX(true)
		end
		local size = petSprite:getContentSize()
		local conPet = WZUIWindow:create()
		pt = pt or ccp(0-0.45,0)
		petSprite:setPosition(ccp(size.width/2, 0))
		element:addChild(conPet)
		conPet:setUseAbsSize(true)
		conPet:setAbsContentSize(size)
		conPet:setAnchorPoint(ccp(0.5,0))
		conPet:setRelativePosition(pt)
		conPet:setLuaTouchBeganFunction(beganFun)
		conPet:setLuaTouchMovedFunction(moveFun)
		conPet:setLuaTouchEndedFunction(endFun)
		local petBtn = WZUIButton:create()
		petBtn:setNormalElement(petSprite)
		conPet:addChild(petBtn)
		petAnim:play("0",true)
		for k,v in pairs(WPet.m_tPetDragonBone) do
			if k == nPetId then
				for _,effect in pairs(v) do
					petAnim:play("0",true,effect)
				end
				break
			end
		end
        return petSprite
	end
end

--@brief	创建按钮
function createPlayerBtn(norIcon,selIcon,funName,pt,size,anchor,bOrigin)
	pt = pt or ccp(0.5,0.5)
	size = size or CCSize(40,40)
	funName = funName or ""
	norIcon = norIcon or ""
	selIcon = selIcon or ""
	anchor = anchor or ccp(0.5,0.5)
	bOrigin = bOrigin or false
	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(size)
	con:setRelativePosition(pt)
	con:setAnchorPoint(anchor)
	local imgNor = createImage(norIcon,nil,nil,bOrigin)
	local imgSel = createImage(selIcon,nil,nil,bOrigin)
	local btn = WZUIButton:create()
	btn:setNormalElement(imgNor)
	btn:setSelectElement(imgSel)
	btn:setLuaDoneFunctionName(funName)
	con:addChild(btn)
	return con,btn
end

--@brief    创建武器等级图片图片
function createAtlasFont(desc,pt,icon,anchor,scale)
	icon = icon or "image/common/num/weapon_level_number.png"
	anchor = anchor or ccp(0.5,0.5)
	pt = pt or ccp(0.5,0.5)
	scale = scale or 1
	local labelImage = WZUILabelAtlasFont:create()
	labelImage:setCharMapFileName(icon)   	--图片路径
	labelImage:setHeight(31)				--字体图片的高度
	labelImage:setWidth(24)					--字体图片的宽度
	labelImage:setAnchorPoint(anchor) 		--图片锚点
	labelImage:setRelativePosition(pt)		--图片相对位置
	labelImage:setText(desc)				--图片内容
	labelImage:setUseOriginSize(true)		--图片原始大小
	labelImage:setScale(scale)
	return labelImage
end

function getWeaponSkillAniName(id,postion)
	if id == nil or id <= 15 then
		return
	end
	local pt = ccp(0.5 , 0 )
	local sName = nil
	local isRotate = true
	local icon = nil 
	local icon2 = nil
	if id >= 16 and id <= 20 then--4灼伤 黄光球在武器右上角位置椭圆循环转圈
		sName = "burn"
		pt = ccp(0.45,0.35)
		icon = "common/animation/baptize/yellow.png"
		isRotate = false
	elseif id > 20 and id <= 25 then --5疲劳 白球在武器右上角位置椭圆循环转圈
		sName = "fatigue"
		pt = ccp(0.5,0)
		icon = "common/animation/baptize/white.png"
		isRotate = false
	elseif id > 25 and id <= 30 then		--6(30-34)重力 紫色光球在武器右上角位置椭圆循环转圈
		sName = "gravity"
		pt = ccp(0.5 , -0.35 )
		icon = "common/animation/baptize/yellow.png"
	elseif id > 30 and id <= 35 then		--7吸血 紫色光球在武器右上角位置椭圆循环转圈
		sName = "reds"
		icon = "common/animation/baptize/red.png"
	elseif id > 35 and id <= 40 then 		--8封印 黄球在武器右上角位置椭圆循环转圈
		sName = "seal"
		icon = "common/animation/baptize/thunder.png"
		pt = ccp(0.56,0.35)
	elseif id > 40 and id <= 50 then
		return 
	elseif id > 50 and id <= 55 then 	--11核弹 白球在武器右上角位置椭圆循环转圈
		sName = "atomic"
		icon = "common/animation/baptize/white.png"
		icon2 = "common/animation/baptize/bomb.png"
		pt = ccp(0.5,0.5)
	elseif id > 55 and id <= 60 then 	--12毒素 暗绿光球在武器右上角位置椭圆循环转圈
		sName = "toxin"
		icon = "common/animation/baptize/green.png"
		pt = ccp(0.45 , 0.35)
	elseif id > 60 and id <= 65 then 	--13寒冰 雪花在武器右上角位置椭圆循环转圈
		sName = "ice"
		icon = "common/animation/baptize/white.png"
		pt = ccp(0.5,0)
	elseif id > 65 and id <= 70 then 	--14锁足 黄球在武器右上角位置椭圆循环转圈
		sName = "lock"
		icon = "common/animation/baptize/green.png"
		pt = ccp(0.5,0.35)
	elseif id > 70 and id <= 75 then	--15眩晕 眩晕图案在武器右上角位置椭圆循环转圈
		sName = "dizzy"
		icon = "common/animation/baptize/yellow.png"
		pt = ccp(0.5,0)
		isRotate = false
	elseif id > 75 and id <= 80 then	--16击退 白色光球在武器右上角位置椭圆循环转圈
		sName = "white"
		icon = "common/animation/baptize/white.png"
		pt = ccp(0.5,0)
	elseif id > 80 and id <= 85 then	--17免坑 青色光球在武器右上角位置椭圆循环转圈
		sName = "anti"
		icon = "common/animation/baptize/yellow.png"
		pt = ccp(0.5,-0.15)
	elseif id > 85 and id <= 90 then	--18吸收 青色光球在武器右上角位置椭圆循环转圈
		sName = "whites"
		icon = "common/animation/baptize/white.png"
	elseif id > 90 and id <= 95 then	--19免疫
		sName = "immune"
		icon = "common/animation/baptize/white.png"
	end
	postion = postion or pt
	return sName,postion,icon,icon2,isRotate
end

--@brief 	战力变化动画
function upPlayerFightingAni(nExp,startPt,sDesc)
    WZLog("upPlayerFightingAni one", tostring(GlobalGame.g_tInfo.nFighting), tostring(GlobalGame.g_tInfo.m_nFighting), tostring(nExp))
	GlobalGame.g_bFightRage = false
	if CacheCenter:getPlayerInfo() == nil then
		return
	end
--    do return end
	--nExp = 0
	
	if tostring(GlobalGame.g_tInfo.m_nFighting) ~= "0" then
		nExp = nExp or GlobalGame.g_tInfo.m_nFighting
	end
	if tostring(GlobalGame.g_tInfo.nFighting) ~= "0" then
		nExp = nExp or GlobalGame.g_tInfo.nFighting
	end
	GlobalGame.g_tInfo.m_nFighting = 0
	GlobalGame.g_tInfo.nFighting = 0
	
	if tostring(nExp) == "0" then
        WZLog("Fighting ====== 1")
		return
	end 

    if nExp == 0 then
        WZLog("Fighting ====== 0")
        return
    end

    if tonumber(nExp) == nil then
        WZLog("Fighting ====== nil")
        return
    end

    if WndSingleCopy.m_root ~= nil then
    	g_bIsShowFightingLater = false
    end

    --登录时战斗力变化延迟到主城显示
    if g_bIsShowFightingLater then
        g_bIsShowFightingLater = false
        g_nLaterShowFighting = nExp
        return 
    end

	--如果还在进行战斗力动画，删除动画和消息队列
    if GlobalGame.g_tWndFightingList ~= nil and #GlobalGame.g_tWndFightingList ~= 0 then
        for i,v in pairs(GlobalGame.g_tWndFightingList) do
            if v and v.m_root and v.m_nType == "WndFighting" then
                WindowManager:removeWindow(v.m_root, v, true)
                GlobalGame.g_tWndFightingList[i] = nil
            end
        end
		MsgBoxManager:_removeMsgByType(MSGBOXTYPE_FIGHTANI)
    end
	
	local msg = {}
	msg.m_nExp = nExp
	msg.m_startPt = startPt
	msg.m_sDesc = sDesc
	--MsgBoxManager:showFightAni(msg)

	boxElement, tLuaObj = WndFighting:createElement()
    tLuaObj:setMsgData({sMsgBody=msg})
	WindowManager:addWindow(boxElement, tLuaObj,nil,nil,true,false) 
    WZLog("upPlayerFightingAni two")
end

--@brief 	动画完成后删除控件
function onFinishAniTemp(element,b)
	WZLog("Global:onFinishAniTemp one")
	element = WZUIContainer:luaTo(element)
	local tag = element:getTag()
	WZLog("onFinishAniTemp two",tag,element,b)
	if tonumber(tag) == 1 then
		element:setTag(2)
		local x,y = element:getPosition()
		local array = CCArray:create()
		array:addObject(CCFadeTo:create(0.8,255))
		array:addObject(CCScaleTo:create(0.2,1))
		local action = CCSpawn:create(array)
		local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onFinishAniTemp))
		element:runAction(actionSequence)
		return
	elseif tonumber(tag) == 2 then
		element:setTag(30)
		local x,y = element:getPosition()
		local array = CCArray:create()
		local endSpeed = 0.2
		array:addObject(CCMoveTo:create(endSpeed,ccp(x,y+120)))
		array:addObject(CCFadeTo:create(endSpeed,50))
		local action = CCSpawn:create(array)
		local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onFinishAniTemp))
		element:runAction(actionSequence)
		return
	end

    WZLog("Global:onFinishAniTemp three", #GlobalGame.g_tWndFightingList)

    for i,v in pairs(GlobalGame.g_tWndFightingList) do
        if v and v.m_root then
            WindowManager:removeWindow(v.m_root, v, true)
            GlobalGame.g_tWndFightingList[i] = nil
        end
    end

    if element then
        element:removeFromParentAndCleanup(true)
        element = nil
    end
end

--function createTempAni(tMsg)
--	local nExp = tMsg.sMsgBody.m_nExp
--	local startPt = tMsg.sMsgBody.m_startPt
--	local sDesc = tMsg.sMsgBody.m_sDesc
--	local labelColor = ccc3(255,255,255)
--	local color = ccc3(255,219,129)
--	local icon = "ui/common_num/commom_num_zdljia.png"
--	local wordImg = "ui/common/commom_icon_zdljia.png"
--	local symbolImg = "ui/common/commom_icon_zdljia2.png"
--	if tonumber(nExp) == 0 then
--		return
--	elseif tonumber(nExp) > 0 then
--		--nExp = ":"..tostring(nExp)
--		nExp = tostring(nExp)
--	else
--		--labelColor = ccc3(255,0,0)
--		color = ccc3(255,0,0)
--		nExp = tostring(nExp)
--		--nExp = ";"..nExp:gsub("-","")
--		nExp = nExp:gsub("-","")
--		icon = "ui/common_num/commom_num_zdljian.png"
--		wordImg = "ui/common/commom_icon_zdljian.png"
--		symbolImg = "ui/common/commom_icon_zdljian2.png"
--	end
--	WZLog("nExp::ABC:",nExp)
--	sDesc = sDesc or LocalStrings.COMBAT
--	startPt = startPt or ccp(0.5,0.4)
--	local con = WZUIContainer:create()
--	con:setUseAbsSize(true)
--	con:setAbsContentSize(CCSize(100,36))
--	con:setVisible(false)
--	con:setRelativePosition(startPt)
--	con:setTag(1)
--	con:setZOrder(99999999)
--	WindowManager:getSceneRoot():addChild(con,99999999)
--	local label = WZUILabelAtlasFont:create()
--	label:setCharMapFileName(icon)--图片路径
--	label:setHeight(44)--字体图片的高度
--	label:setWidth(30)--字体图片的宽度
--	label:setText(nExp)--图片内容
--	label:setUseOriginSize( true )--图片原始大小
--	label:setAnchorPoint(ccp(0,0.5))
--	label:setRelativePosition(ccp(0,0.5))
--	label:setColor(labelColor)
--	local txt = WZUIImage:create()
--	txt:setAnchorPoint(ccp(1,0.5))
--	txt:setRelativePosition(ccp(1,0.5))
--	txt:setFile(wordImg)
--	txt:setUseOriginSize(true)
--	con:addChild(txt)
--	local symbol = WZUIImage:create()
--	symbol:setAnchorPoint(ccp(1,0.5))
--	symbol:setRelativePosition(ccp(0,0.5))
--	symbol:setFile(symbolImg)
--	symbol:setUseOriginSize(true)
--	con:addChild(symbol)
--	con:addChild(label)
--	local txtSize = txt:getContentSize()
--	local labelSize = label:getContentSize()
--	con:setContentSize(CCSize(txtSize.width+labelSize.width,36))
--	txt:setRelativePosition(ccp(1,0.5))
--	label:setRelativePosition(ccp(0,0.5))
--	WZLog("txtSize:",txtSize.width,labelSize.width)
--	con:setVisible(true)
--	local x,y = con:getPosition()
--	local array = CCArray:create()
--	array:addObject(CCMoveTo:create(0.2,ccp(x,y+60)))
--	array:addObject(CCFadeTo:create(0.2,255))
--	array:addObject(CCScaleTo:create(0.2,1.5))
--	local action = CCSpawn:create(array)
--	local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onFinishAniTemp))
--	con:runAction(actionSequence)
--end
--
----@brief 	动画完成后删除控件
--function onFinishAniTemp(element,b)
--	element = WZUIContainer:luaTo(element)
--	local tag = element:getTag()
--	WZLog("onFinishAniTemp::",tag,element,b)
--	if tonumber(tag) == 1 then
--		element:setTag(2)
--		local x,y = element:getPosition()
--		local array = CCArray:create()
--		array:addObject(CCFadeTo:create(0.8,255))
--		array:addObject(CCScaleTo:create(0.2,1))
--		local action = CCSpawn:create(array)
--		local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onFinishAniTemp))
--		element:runAction(actionSequence)
--		return
--	elseif tonumber(tag) == 2 then
--		element:setTag(30)
--		local x,y = element:getPosition()
--		local array = CCArray:create()
--		array:addObject(CCMoveTo:create(0.25,ccp(x,y+120)))
--		array:addObject(CCFadeTo:create(0.25,50))
--		local action = CCSpawn:create(array)
--		local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onFinishAniTemp))
--		element:runAction(actionSequence)
--		return
--	end
--	element:removeFromParentAndCleanup(true)
--	element = nil 
--end

--@brief 	战力变化动画
function createFightingAni(lua,nExp,startPt,sDesc)
	local color = ccc3(0,246,36)
	if lua == nil then
		color = nil  
		startPt = nil 
		return
	elseif tonumber(nExp) == 0 then--没有变化就返回
		color = nil 
		startPt = nil 
		return
	elseif tonumber(nExp) > 0 then
		nExp = "+"..nExp
	else
		color = ccc3(255,0,0)
	end
	sDesc = sDesc or LocalStrings.COMBAT
	startPt = startPt or ccp(0.5,0.4)
	local txt = WZUILabelTTF:create()
	txt:setZOrder(99999)
	txt:setFontSize(45)
    if tonumber(nExp) == -1 then
        color = ccc3(0,246,36)
        txt:setText(sDesc)
    elseif tonumber(nExp) == -2 then
        color = ccc3(255,0,0)
        txt:setText(sDesc)
    else
        txt:setText(nExp..sDesc)
    end

	txt:setRelativePosition(startPt)
	txt:setColor(color)
	txt:setBoldFont(true)
	txt:setEnableStroke(true)
	txt:setStrokeColor(ccc3(36,0,0))
	txt:setStrokeSize(4)
	txt:setTag(1)
	lua:addChild(txt)
	local x,y = txt:getPosition()
	local array = CCArray:create()
	array:addObject(CCMoveTo:create(0.25,ccp(x,y+70)))
	array:addObject(CCFadeTo:create(0.25,255))
	local action = CCSpawn:create(array)
	local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onFightingFinishAni))
	txt:runAction(actionSequence)
	color = nil
	startPt = nil 
	WZLog("onFightingFinishAni:end:")
end

--@brief 	动画完成后删除控件
function onFightingFinishAni(element,b)
	element = WZUILabelTTF:luaTo(element)
	local tag = element:getTag()
	WZLog("onFightingFinishAni::",tag,element,b)
	if tonumber(tag) == 1 then
		element:setTag(2)
		local x,y = element:getPosition()
		local array = CCArray:create()
		array:addObject(CCFadeTo:create(0.5,255))
		local action = CCSpawn:create(array)
		local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onFightingFinishAni))
		element:runAction(actionSequence)
		return
	elseif tonumber(tag) == 2 then
		element:setTag(3)
		local x,y = element:getPosition()
		local array = CCArray:create()
		array:addObject(CCMoveTo:create(0.25,ccp(x,y+110)))
		array:addObject(CCFadeTo:create(0.25,255))
		local action = CCSpawn:create(array)
		local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onFightingFinishAni))
		element:runAction(actionSequence)
		return
	end
	element:removeFromParentAndCleanup(true)
	element = nil 
end

--@brief    创建活力值变化动画
function createActChangeAni(parentNode, sNumPath, sIcon, nAddNum)
    -- body
    local conResult = WZUIContainer:create()
    conResult:setAbsContentSize(CCSize(200, 36))
    conResult:setUseAbsSize(true)
    conResult:setRelativePosition(ccp(0.5, 0.4))
    --加号
    local imgAddSign = WZUIImage:create()
    imgAddSign:setFile("ui/common/common_num_yaoqianshujiahao.png")
    imgAddSign:setUseOriginSize(true)
    imgAddSign:setAnchorPoint(ccp(1, 0.5))
    imgAddSign:setRelativePosition(ccp(0.25, 0.5))
    conResult:addChild(imgAddSign)
    --增加的数值类型图标
    local imgIcon = WZUIImage:create()
    imgIcon:setFile(sIcon)
    imgIcon:setUseOriginSize(true)
    imgIcon:setAnchorPoint(ccp(1, 0.5))
    imgIcon:setRelativePosition(ccp(0.45, 0.5))
    conResult:addChild(imgIcon)
    --数值:增加的活力值
    local txtAtlasFont = WZUILabelAtlasFont:create()
    txtAtlasFont:setCharMapFileName(sNumPath)
    txtAtlasFont:setStartChar(48)
    txtAtlasFont:setHeight(34)
    txtAtlasFont:setWidth(26)
    txtAtlasFont:setUseOriginSize(true)
    txtAtlasFont:setAnchorPoint(ccp(0, 0.5))
    txtAtlasFont:setRelativePosition(ccp(0.5, 0.5))

    txtAtlasFont:setText(nAddNum)

    conResult:setTag(1)
    conResult:setZOrder(99999)
    conResult:addChild(txtAtlasFont)
    parentNode:addChild(conResult)

    local x,y = conResult:getPosition()
    local array = CCArray:create()
    array:addObject(CCMoveTo:create(0.25,ccp(x,y+70)))
    array:addObject(CCFadeTo:create(0.25,255))
    local action = CCSpawn:create(array)
    local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onChangeFinishAni))
    conResult:runAction(actionSequence)
end

function onChangeFinishAni(element,b)
    element = WZUIContainer:luaTo(element)
    WZLog("onChangeFinishAni::",element,b)
    local tag = element:getTag()
    if tonumber(tag) == 1 then
        element:setTag(2)
        local array = CCArray:create()
        array:addObject(CCFadeTo:create(0.5,255))
        local action = CCSpawn:create(array)
        local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onChangeFinishAni))
        element:runAction(actionSequence)
        return
    elseif tonumber(tag) == 2 then
        element:setTag(3)
        local x,y = element:getPosition()
        local array = CCArray:create()
        array:addObject(CCMoveTo:create(0.25,ccp(x,y+110)))
        array:addObject(CCFadeTo:create(0.25,255))
        local action = CCSpawn:create(array)
        local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onChangeFinishAni))
        element:runAction(actionSequence)
        return
    end
    
    element:removeFromParentAndCleanup(true)
    element = nil 
end

--@brief 	跳转到指定界面
--@param 	nUIMainId:界面主ID
--@param 	nUISubId:界面子ID
--@param    nJumpTypeIndex : 调用跳转的类型：1->任务；2->活动；3->觉醒任务；4->图鉴
function JumpByUIId(nUIMainId , nUISubId, taskId, nJumpTypeIndex, bActivityJump)
	WZLog("JumpByUIId", nUIMainId, nUISubId, CacheCenter:getPlayerInfo().guildId)
	if nUIMainId == "" then return end
	if nUIMainId == 262 then
    	OpenPartner(1)
    	return
    end
	local jumpData = JUMP_LIST["id_"..nUIMainId]  
	if not jumpData then return end
	
    local tTaskData = nil 
    if taskId and nJumpTypeIndex and nJumpTypeIndex == 1 then
        tTaskData = GDatatab_task["id_" .. taskId]
    end
    --噩梦副本和精英副本特殊处理
    if nUIMainId == 185 then
        JumpByUIId(12,nil,3)
        return 
    elseif nUIMainId == 187 then
        JumpByUIId(12,nil,2)
        return 
    elseif nUIMainId == 192 and CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().guildId == 0 then
    	MsgBoxManager:showTipBox(LocalStrings.TXT_NOSOCISY_FREND)
    	return 
    end
	--判断要跳转的界面是否已经开启
    if not CheckButtonOpen(jumpData.uiOpenID)  then
		WZLog("*******::",jumpData.uiChannelID)
		return false
	end
    --禁忌之地——章节
    if nUIMainId == 200 and nUISubId then
        if not CheckTabooSectionOpen(nUISubId) then
            return false
        end 
    end
    WZLog("********** JumpByUIId ************", GlobalGame.g_nCurrentUIChannelId, nUIMainId)
	if GlobalGame.g_nCurrentUIChannelId == nUIMainId and nUIMainId ~= 92 then  --判断跳转的界面是否已打开
		--单人副本跳转处理
		if GlobalGame.g_nCurrentUIChannelId == Chat_Channel_Single_Copy_Hall then 
			SceneCopy:showScene(1, nil, nil,true)
		end

        if nUIMainId == 198 then 
        	if WndStore.m_root then 
        		WindowManager:removeWindow(WndStore.m_root, WndStore, true)
        	end
        	return 
        end
        if not (nUIMainId == 43 and _G[jumpData.uiName].m_root) then
		else
            return 
        end
	end

    WZLog("JumpByUIId one", jumpData.uiType, nUIMainId, nUISubId, jumpData.uiName)

    --发送退出房间协议
    local m_bNeedExitFightRoom = false
    if jumpData.uiName=="SceneCopy" or jumpData.uiName=="WndAthShop" then 
    	m_bNeedExitFightRoom = true 
    end 

    if nUIMainId == 92 then
        if CheckButtonOpen(ISLAND_NPC_INSTRUCTOR) then
            WndStrong:showInterface()
        end
    elseif nUIMainId == 93 then
        local day = tonumber(CacheCenter:getGameParam().openDays)
        local openDay = CacheCenter:getGameParam().openMentoring and tonumber(CacheCenter:getGameParam().openMentoring) or 4
        if day >= openDay then
            if CheckButtonOpen(ISLAND_NPC_TEACHER) then
                WndMaster:showInterface()
            end
        else
            MsgBoxManager:showTipBox(string.format(LocalStrings.MASTEROPENTIPS,openDay-day))
        end
    --场景类型
    elseif 1 == jumpData.uiType then
        if jumpData.uiName=="SceneTabooBattle" then
            _G[jumpData.uiName]:show(nUISubId)
        else
		    replaceScene(_G[jumpData.uiName]:createElement())
        end
	--窗口类型
	elseif 2 == jumpData.uiType then
        if nUIMainId == 208 then
            if WndNewActivity:_bActivityStart() and WndNewActivity:_activityIsExit() then
                loadstring(jumpData.func)()
            else
                if not WndNewActivity:_bActivityStart() then
                    MsgBoxManager:showTipBox(LocalStrings.ANNIV_END2)
                    return false
                end

                if not WndNewActivity:_activityIsExit() then
                    MsgBoxManager:showTipBox(LocalStrings.ANNIV_END)
                    return false
                end
            end
        elseif tonumber(nUIMainId) == 229 then
        	_G[jumpData.uiName]:jumpTab(8,tonumber(nUISubId))
        else
            if jumpData.func then
                loadstring(jumpData.func)()
            else
        		local uiElement = _G[jumpData.uiName]:createElement()
        		WindowManager:addWindow(uiElement, _G[jumpData.uiName], jumpData.uiParam[1])
    	    end
        end
	--普通战斗房间类型
	elseif 3 == jumpData.uiType then
		ProtocolProcessorSceneHall:send_ROOM_CreateRoom(jumpData.uiParam[1], jumpData.uiParam[2], jumpData.uiParam[3], jumpData.uiParam[4],jumpData.uiParam[5],jumpData.uiParam[6],jumpData.uiParam[7],0)
		
	--副本战斗房间类型
	elseif 4 == jumpData.uiType then
		ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom(jumpData.uiParam[1], "-1", 1)
	
	--带标签的窗口界面
	elseif 5 == jumpData.uiType then
		_G[jumpData.uiName]:jumpTo(jumpData.uiParam[1])
	--通过任务打开二级弹窗
	elseif 6 == jumpData.uiType then 
        -- Add By Tianxiang_Xu
        if jumpData.uiName=="SceneCopy" then
            if SceneCopy.m_root ~= nil then
                WindowManager:removeAllWindow()
            end
        end
        if tTaskData then
            if tTaskData.script[1][1] == 15 then
                if tTaskData.script[1][2] > 0 then
                    g_mulCopyIndex = tTaskData.script[1][2]
                end
            end
        end
        if jumpData.uiName == "WndApartmentAct" then 
        --同是活动，用的是同一个协议获取活动列表，如果遇到先处理的会直接返回
            if WndGameActivity.m_root then 
                WZLog("9999999999999999")
                WndGameActivity:actionCallback_close()
            end
        end
        -- Add by peiting_mao
        if jumpData.uiName == "WndEquipmentLottery" then
        	if WndEquipmentLottery.m_root then
        		WindowManager:removeWindow(WndEquipmentLottery.m_root,WndEquipmentLottery,true)
        	end
        	if WndGoodsFull.m_root then
				WindowManager:removeWindow(WndGoodsFull.m_root,WndGoodsFull,true)
			end
        	if WndFastGetItems.m_root then
        		WindowManager:removeWindow(WndFastGetItems.m_root,WndFastGetItems,true)
        	end
        end
        --End Add 
		loadstring(jumpData.func)()
    elseif 7 == jumpData.uiType then
        if nJumpTypeIndex ~= 3 then
            if jumpData.uiName=="SceneCopy" then
                if SceneCopy.m_root ~= nil then
                    WindowManager:removeAllWindow()
                end
            end
        end
        if nJumpTypeIndex == 2 then   --从活动跳转到精英
            SceneCopy:showScene(1,nil,2)
        elseif nJumpTypeIndex == 3 then 
            if CopyManager:bJumpToSingleCopy(nUISubId) then 
                if jumpData.uiName=="SceneCopy" then
                    if SceneCopy.m_root ~= nil then
                        WindowManager:removeAllWindow()
                    end
                end
                _G[jumpData.uiName]:showScene(1, nil, nUISubId, false)
            end
        else
            local bTaskJump 
            if nJumpTypeIndex == 1 then 
                bTaskJump = true
            elseif nJumpTypeIndex == 4 then 
                bTaskJump = false 
            end
            
            if not taskId and not bTaskJump and nJumpTypeIndex == nil and nUISubId then
            	_G[jumpData.uiName]:showScene(1, nil, nil, nil, nUISubId)
            else
            	_G[jumpData.uiName]:showScene(1, nil, taskId, bTaskJump)
            end
        end
    elseif 8 == jumpData.uiType then 
        local bOpenResult = _G[jumpData.uiName]:jumpToShop()
        if bOpenResult == false then
            --图鉴系统跳转需要
            return bOpenResult 
        end
	end

    return true
end

--@brief   购买月卡
--@param   nCardType  月卡类型（1 初级月卡，2 高级月卡，3 至尊月卡）
--@param   nNeedMony  月卡所需金额
--@param   idsms      商品ID
--@param   sBuyShopName  商品名称
--@param   shopNum       商品数量
--@param   funcCallback 回调对象方法
--@param   tCallbackObj  回调方法所在lua表
function MonthCardBuy(productedId,nNeedMony,idsms,sBuyShopName,shopNum,funcCallback, tCallbackObj)
	local tPayParams = {}
	local nPurchaseType = 0
	local sShopName = sBuyShopName
	local needMony = nNeedMony
	WZLog("MonthCardBuy",nCardType,nNeedMony,idsms,tPayParams.productId)
    tPayParams.uid = GlobalGame.g_tPlayerInfo.nPlayerId
    tPayParams.money = tostring(needMony)
    tPayParams.rate = "-1"
    tPayParams.playerName = GlobalGame.g_tPlayerInfo.sPlayerName
    tPayParams.purchaseType = nPurchaseType
    tPayParams.purchaseMoney = nPurchaseMoney
    tPayParams.smsId = idsms
    tPayParams.sShopName = sShopName
    tPayParams.sShopNum = tostring(shopNum)
    tPayParams.productId = tostring(productedId)
    if PrefetchCache.m_tMonthlyCardInfo then
    	tPayParams.monthCardBuy = tostring(PrefetchCache.m_tMonthlyCardInfo.nHasBuy)
    	tPayParams.cardLastDays = tostring(PrefetchCache.m_tMonthlyCardInfo.lastDays)
	end
    local data = WZDataFile:getInstance():getUserData()
    if nil == data then
        tPayParams.userID = ""
        tPayParams.serverCode = ""
    else
        tPayParams.userID = data:getStringValue("AccountData", "account")
        tPayParams.serverCode = data:getStringValue("IPDParam", "ServerId")
    end

    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
        local config = curSdkObj.m_tConfig
        if config.SDKOtherConfig.isNeedFastLogin == "true" then
        	local accountInfo = CCUserDefault:sharedUserDefault():getStringForKey("AccountInfo_Vn")
        	local t_jsonArg = SDK_Util:decodeFromJson(accountInfo);
        	tPayParams.userId_vn = t_jsonArg.uid
        	tPayParams.userName_vn = t_jsonArg.userName
        	WZLog("越南语账号密码",tPayParams.userId_vn,tPayParams.userName_vn)
        end
    end
    WZLog("WndRecharge:onClickRecharge:",json.encode(tPayParams),funcCallback,tCallbackObj)
    --local tCurSdkObj = PassportSdkManager:getCurSdkObj()
    --tCurSdkObj:doPay(json.encode(tPayParams), self.doPayCallBack, self)
    --PassportSdkManager:setPurchaseType(nPurchaseType,needMony,idsms)
    if tCallbackObj ~= nil and funcCallback ~= nil then
    	PassportSdkManager:doPay(tPayParams, funcCallback, tCallbackObj)
    else
    	PassportSdkManager:doPay(tPayParams, WndRecharge.doPayCallBack, WndRecharge)
    end
    
end

--@brief	是否可以前往(可以进入功能模块)
--@param    nId, 按钮id
--@return   #1, 是否开放
function IfGoForId(nId)
	WZLog("IfGoForId one")
	local tPlayrInfo = CacheCenter:getPlayerInfo()
    --转生过都开放
    --if tPlayrInfo.zsLevel > 0 and tPlayrInfo.zsLevel < 10 then
    --    return true
    --end
    for i,v in ipairs(GlobalGame.g_tButtonInfo.buttonId) do
    	WZLog("IfGoForId two",v,nId)
        if v == nId then
        	 WZLog("IfGoForId three",GlobalGame.g_tButtonInfo.buttonStatus3Level[i])
            if tPlayrInfo.level and GlobalGame.g_tButtonInfo.buttonStatus3Level[i] and
                tPlayrInfo.level < GlobalGame.g_tButtonInfo.buttonStatus3Level[i] then
                WZLog("IfGoForId three",GlobalGame.g_tButtonInfo.buttonStatus3Level[i])
				MsgBoxManager:showTipBox(string.format(LocalStrings.ACTIVE_NOLEVEL,GlobalGame.g_tButtonInfo.buttonStatus3Level[i]))
				WZLog("IfGoForId four")
                return false
            else
                return true
            end
        end
    end
end

--@brief	产生一组不无重复的随机数
--@param    number:产生随机数的个数
--@param    maxNumber:随机数值上限
--@param    minNum:随机数值下限
function GetRandomNum(number, maxNumber, minNum)
    local tRandNum = {}
    local nMinNumber = minNum or 1
    local i = 1
    while(#tRandNum ~= number) do 
		local temp = math.random(nMinNumber, maxNumber)
		if checkRepeat(tRandNum, temp) == true then
			tRandNum[i] = temp
			i = i + 1
		end
	end 
	return tRandNum
end

--@brief    检查随机数是否重复
--@return	true：不重复，false：有重复
function checkRepeat( tab, num )
	for i=1, #tab do
		if tab[i] == num then 
			return false
		end 
	end 
	return true
end 

--@brief  根据传入的表生成相应不重复个数随机列表的函数
--@param  #1 传入的个数
--@param  #2 需要返回的值的个数
--@param  #3 是否保护原表（保护则效率略低 不保护则略高）
--@note
function randomIndex(tabNum,indexNum)
	indexNum = indexNum or tabNum
	local t = {}
	local rt = {}
	for i = 1,indexNum do
		local ri = math.random(1,tabNum + 1 - i)
		local v = ri
		for j = 1,tabNum do
			if not t[j] then
				ri = ri - 1
				if ri == 0 then
					table.insert(rt,j)
					t[j] = true
				end
			end
		end
	end
	return rt
end
--@brief	检查编辑框联想字，如果字数超过max，就显示max的文字
--@param    element:editbox的ui控件节点
function checkEditLenovoWord(element)
	if element == nil or WZUIEditBox:luaTo(element) == nil then
		return
	end
	element = WZUIEditBox:luaTo(element)
	local txt = element:getText()
	local maxLen = element:getMaxLength()
	if txt ~= "" then
		local txtLen = TeachChatDialog:strLenReally(txt)
		if txtLen > maxLen  and maxLen > 0 then
			txt = TeachChatDialog:subUtfStr(txt,maxLen)
			element:setText(txt)
		end
	end
	element = nil 
end

--@brief    判断机器是否是低端机器
--@return   true 低端机器  false 不是低端机器
function checkIsBadMachine()
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if platForm == 2 then --android
        if GlobalMethod.g_totalMemory == nil then
            -- local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("org/cocos2dx/hellolua/DandandaoUtils")
            -- if adapter then
                -- GlobalMethod.g_totalMemory = tonumber(adapter:callMethodByNameReturn("getTotalMemory","")) / 1024
                -- WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
            -- end
			GlobalMethod.g_totalMemory = WZDeviceInfo:getTotalMemory()/(1024*1024)
        end
        if GlobalMethod.g_totalMemory < 800 then
            return true
        end
    end
    return false
end

--@brief    获取当前设备内存大小
--@return   返回当前设备内存大小单位是(MB)
function getTotalMemory()
    if GlobalMethod.g_totalMemory == nil then
        GlobalMethod.g_totalMemory = WZDeviceInfo:getTotalMemory()/(1024*1024)
        CCLuaLog("getTotalMemory " .. GlobalMethod.g_totalMemory)
    end
    return GlobalMethod.g_totalMemory
end

--brief   获取SIM卡的状态
function getSimState()
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    local isNeedYifubao = "no"
    local config = nil
    if curSdkObj then
        config = curSdkObj.m_tConfig 
        if config.SDKOtherConfig.SMS ~= nil and config.SDKOtherConfig.SMS ~= "" then
            isNeedYifubao = "yes"
        else
        	return false,isNeedYifubao
        end  
        if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then
            local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("com/wyd/xingepush/WydXingeHelper")
            WZLog("adapter:-------------------------",adapter)
            local jsonArg = adapter:callMethodByNameReturn("getSmsState","{}")
            if adapter then
                WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
            end
            if jsonArg == "true" then
				return false,isNeedYifubao
			elseif jsonArg == "false" then
				return false,isNeedYifubao
			end

			local tResult = json.decode(jsonArg)
			WZLog("手机卡返回信息",jsonArg)
			
            if tResult ~= nil and tResult.sms_type == "true" then
                if (tResult.SMS == "Mobile" and config.SDKOtherConfig.SMS == "Mobile")or(tResult.SMS == "Unicom" and config.SDKOtherConfig.SMS == "Unicom")or(tResult.SMS == "Telecom" and config.SDKOtherConfig.SMS == "Telecom") then
                    return true,isNeedYifubao
                else
                    return false,isNeedYifubao
                end
            else
                return false,isNeedYifubao
            end
        end
    end
end

--@brief	判断自己是否在公会
--@return	true:在公会		false:不在公会
function checkInCommunity()
	local guildId = CacheCenter:getPlayerInfo().guildId
	--玩家不是公会成员
	if guildId == nil or guildId < 1 then
		return false
	else
		return true	
	end
end

--brief    判断商品是否上架
--@param	id:物品id
--@param	text:物品未上架时的提示信息
function checkIsOnSale(id,text)
	if WndPurchase.m_root ~= nil then return end
	local onSale = false
	local text = text or LocalStrings.ASCENDING22
	local onlyBuy 
	if GDatatab_item["id_"..id].quality == 4 then
		onlyBuy = true
	end
	if id == 171 or id == 119 then
		onlyBuy = true
	end
	--判断物品是否上架
	CacheCenter:getShopItems(function(t,shopItemList)
		for k,v in pairs(shopItemList)	do
				local mainType
				local subType
        		local curType = json.decode(v.mainType)
        		for k,v in pairs(curType) do
        		    mainType = tonumber(k)
					subType = tonumber(v)
        		end
			if v.shopItemId == tonumber(id) and v.isOnSale == true and mainType ~= 5 and mainType ~= 4 then
				--WZLog("快速购买", Serialize(v))
				if v.limitLeave == 0 then
					MsgBoxManager:showTipBox(LocalStrings.ASCENDING36)
					return false
				end
				onSale = true
			  	WndPurchase:showBuyInterface(6,tonumber(id),WndStrengthen,WndStrengthen.buyCallBack,nil,nil,nil,nil,onlyBuy)
				return true
			end
		end
	end)

	if onSale then
		WZLog("检测上架",GDatatab_item["id_"..id].name.."已上架")
	else
		WZLog("检测上架",GDatatab_item["id_"..id].name.."未上架")
		MsgBoxManager:showTipBox(text)
		local tData = GDatatab_item["id_"..id]
		if tData.main_type == 3 then
			WndFastGetItems:show(tData.basicInfo.id)
		end
	end
	--return onSale
end

--@brief	判断是否已经拥有礼包中所有皮肤
--@param	itemId:礼包的itemId
--@param	全部拥有返回true
function checkGiftOwnAllSkin(itemId)
	WZLog("checkGiftOwnAllSkin", Serialize(WndPhantom.m_tDataList))
	if WndPhantom.m_tDataList == nil then return false end
    local tBasicInfo = GDatatab_item["id_" .. itemId]
	if tBasicInfo.main_type ~= 3 or tBasicInfo.sub_type ~= 0 then
		WZLog(tBasicInfo.name.."不是礼包")
		return false
	end

	local sex = CacheCenter:getPlayerInfo().sex
	local sexIndex = {"man_item_id","woman_item_id"}
	local ownAll = true
	local run = false
	for k,v in pairs(GDatatab_gifts) do
		if v.item_id ==  itemId then
			local ownIt = false
			local giftId = v[sexIndex[sex+1]]
			local tItem = GDatatab_item["id_"..giftId]
			local skinId = tItem.property[1][1]
			for i=1,#WndPhantom.m_tDataList do
				if skinId == WndPhantom.m_tDataList[i].shapeId then
					ownIt = true
				end
			end
			ownAll = ownAll and ownIt
			run = true
		end
	end

	ownAll = ownAll and run
	return ownAll
end

--@brief	判断是否已经拥有礼包中所有坐骑
--@param	itemId:礼包的itemId
--@param	全部拥有返回true
function checkGiftOwnAllHorse(itemId)
	WZLog("checkGiftOwnAllHorse")
    local tBasicInfo = GDatatab_item["id_" .. itemId]
	if tBasicInfo.main_type ~= 3 or tBasicInfo.sub_type ~= 0 then
		WZLog(tBasicInfo.name.."不是礼包")
		return false
	end

	local sex = CacheCenter:getPlayerInfo().sex
	local sexIndex = {"man_item_id","woman_item_id"}
	local ownAll = true
	local run = false
	local tDataList = CacheCenter:getPlayerInfo().allMountsMessage
	for k,v in pairs(GDatatab_gifts) do
		if v.item_id ==  itemId then
			local ownIt = false
			local giftId = v[sexIndex[sex+1]]
			--礼包中有已拥有的坐骑
			for i=1,#tDataList do
				local tData = json.decode(tDataList[i])
				local mountsId = tData.mountsId
				WZLog("jklsssssss",mountsId)
				if giftId == GDatatab_mounts["id_"..mountsId].item_id then
					ownIt = true
				end
			end
			ownAll = ownAll and ownIt
			run = true
		end
	end
	WZLog("checkGiftOwnAllHorse1", ownAll)
	ownAll = ownAll and run
	return ownAll
end

--@brief	判断是否已经拥有礼包中所有坐骑兑换卡对应坐骑
--@param	itemId:礼包的itemId
--@param	全部拥有返回true
function checkGiftOwnAllHorse_1(itemId)
	WZLog("checkGiftOwnAllHorse_1")
    local tBasicInfo = GDatatab_item["id_" .. itemId]
	if tBasicInfo.main_type ~= 3 or tBasicInfo.sub_type ~= 0 then
		WZLog(tBasicInfo.name.."不是礼包")
		return false
	end

	local sex = CacheCenter:getPlayerInfo().sex
	local sexIndex = {"man_item_id","woman_item_id"}
	local ownAll = true
	local run = false
	local tDataList = CacheCenter:getPlayerInfo().allMountsMessage
	for k,v in pairs(GDatatab_gifts) do
		if v.item_id ==  itemId then
			local ownIt = false
			local giftId = v[sexIndex[sex+1]]
			--礼包中有已拥有的坐骑
			for i=1,#tDataList do
				local tData = json.decode(tDataList[i])
				local mountsId = tData.mountsId
				WZLog("jklsssssss",mountsId)
				if giftId == GDatatab_mounts["id_"..mountsId].item_id then
					ownIt = true
				end
			end
    			local tBasicInfo = GDatatab_item["id_" .. giftId]
				if tBasicInfo.main_type ~= 2 or tBasicInfo.sub_type ~= 11 then
					ownIt = true
				else
					if checkOwnMount(giftId) then
						ownIt = true
					end
				end
			ownAll = ownAll and ownIt
			run = true
		end
	end
	WZLog("checkGiftOwnAllHorse1", ownAll)
	ownAll = ownAll and run
	return ownAll
end

--@brief	判断礼包内是否有已拥有的无限期时装，或者已拥有的坐骑的兑换卡
--@param	itemId:礼包的itemId
--@param	已拥有返回true
function checkGiftOwn(itemId)
    local tBasicInfo = GDatatab_item["id_" .. itemId]
	if tBasicInfo.main_type ~= 3 or tBasicInfo.sub_type ~= 0 then
		WZLog(tBasicInfo.name.."不是礼包")
		return false
	end

	local own = false
	local text = ""

	local sex = CacheCenter:getPlayerInfo().sex
	local sexIndex = {"man_item_id","woman_item_id"}
	for k,v in pairs(GDatatab_gifts) do
		if v.item_id ==  itemId then
			local giftId = v[sexIndex[sex+1]]
			--礼包中有已拥有的时装或武器
			if gCheckHaveOrNot(giftId) then
				own = true
				text = text..GDatatab_item["id_" .. giftId].name.."、"
			end
			--礼包中有已拥有的坐骑
			if checkOwnMount(giftId) then
				own = true
			end
		end
	end
	text = string.sub(text, 1, -4)
	return own, text
end

--@brief	判断足迹兑换卡是否已拥有，或者对应足迹，升级足迹已拥有
--@param	itemId:兑换卡的itemId
--@param	已拥有返回true
function checkOwnFootMark(itemId)
	WZLog("checkOwnFootMark", itemId)
    local tBasicInfo = GDatatab_item["id_" .. itemId]
	if tBasicInfo.main_type ~= 23 then
		WZLog(tBasicInfo.name.."不是兑换卡")
		return false
	end
	--是否已经有该兑换卡
	local hasCard = false
	if CacheCenter:getPlayerItemCountById(itemId) > 0 then
		WZLog("已经有该兑换卡")
		hasCard = true
		return true
	end

	--是否有该兑换卡对应的足迹
	local hasMount = false
	local mountsItemId = {}
	--获得兑换卡可以直接兑换的足迹
	local exchangeId = -1
	for k,v in pairs(GDatatab_footmark) do
		if v.way ~= -1 and v.way[1][2] == 2 and v.way[2][2] == itemId then
			exchangeId = v.item_id 
			table.insert(mountsItemId, exchangeId)
			break
		end
	end
	WZLog("兑换卡对应的足迹id", Serialize(mountsItemId))
	local tDataList = CacheCenter:getPlayerInfo().footMark
	for i=1,#tDataList do
		local tData = json.decode(tDataList[i])
		local footmarkId = tData.footmarkId
		for k,v in pairs(mountsItemId) do
			if GDatatab_footmark["id_"..footmarkId].item_id == v then
				hasMount = true
				return true
			end
		end
	end

	return false
end

--@brief	检查背包物品是否无限期
--@param	id:LocalData表中的id
--@return	true:无限期    false:不是无限期
function checkIsIndefinite(id)
	local items = CacheCenter:getPlayerItems()
	local lastTime
	for _,v in pairs(items) do
		if v.id == id then
			lastTime = v.lastTime	
			break
		end
	end
	if lastTime == -1 then
		return true
	else
		return false
	end
end

--@brief	获得背包物品数量
--@param	id:LocalData表中的id
--@return	count:物品数量
function getBagItemCount(id)
	local items = CacheCenter:getPlayerItems()
	local count = 0
	for _,v in pairs(items) do
		if v.id == id then
			count = v.lastNum	
			break
		end
	end
	return count
end

function URLEscape(w)
    local pattern="[^%w%d%._%-%* ]"
    local s=string.gsub(w,pattern,function(c)
        local c=string.format("%%%02X",string.byte(c))
        return c
        end)
    s=string.gsub(s," ","+")
    return s
end

function pushScene(frame)
    print("pushScene", frame:getName())
    g_bIsPushScene = true
    print("pushScene::::::R:::", frame:getName())
	local scene = CCScene:create()
	scene:setContentSize(CCDirector:sharedDirector():getWinSize())
	if frame then
		scene:addChild(frame)
		--针对特殊分辨率屏幕将界面拉伸
		ScaleToAdjustSpecialScreen(frame)
		if WindowManager then
			WindowManager:setSceneRoot(frame)
		end
        if MsgBoxManager then
            MsgBoxManager:clear()
        end

		CCDirector:sharedDirector():pushScene(scene)

		return true
	end

	return false
end

function popScene()
    print("popScene one")
    g_bIsPopScene = true
    CCDirector:sharedDirector():popScene()

end

function popSceneEnd()
    if g_bIsPopScene ~= true then
        return
    end
    g_bIsPopScene = nil
    g_bIsPushScene = nil
	local frame = getRunningFrame()

	if frame then
        print("popScene two", frame:getName())
        frame:setEnableTouch(true)

		--针对特殊分辨率屏幕将界面拉伸
		ScaleToAdjustSpecialScreen(frame)
		if WindowManager then
			WindowManager:setSceneRoot(frame)
		end
        if MsgBoxManager then
            MsgBoxManager:clear()
        end

		return true
	end

	return false
end

--brief    转换已装备列表成为供生成人物动画的装备列表
function ConvertEquipmentList(tEquipmentList)
    local tEquip = {}
	for i,v in pairs(tEquipmentList) do
        local tBasicInfo = nil
        if type(v) == "table" then
            tBasicInfo = GetItemLocalData(v.id)
        elseif type(v) == "number" then
            tBasicInfo = GetItemLocalData(v)
        else
            return
        end
        local maintype = tBasicInfo.main_type
        local subtype = tBasicInfo.sub_type
        if maintype == 4 and subtype < 2 then --武器
            tEquip.weapon = tBasicInfo.animation_index_code
            tEquip.weaponType = subtype
        elseif maintype == 5 and subtype == 3 then-- 物品是否是翅膀装备
            tEquip.wing = tBasicInfo.animation_index_code
        elseif maintype == 5 and subtype == 2 then--物品是否是衣服 
            tEquip.body = tBasicInfo.animation_index_code
        elseif maintype == 5 and subtype == 1 then--物品是否是脸谱
            tEquip.face = tBasicInfo.animation_index_code
        elseif maintype == 5 and subtype == 0 then-- 物品是否是头部 
            tEquip.head = tBasicInfo.animation_index_code
        end
	end  
    return tEquip
end

--@brief   玩家信息
--@param  #1 容器
--@param  #2 缩放比例
function CreateHeadAnim(con, scale, equipList, sex)
    equipList = equipList
    sex = sex or CacheCenter.m_tPlayerInfo.sex--玩家性别
    local head = nil
    local face = nil

    local headAnim

    if equipList ~= nil then
        headAnim = CreatePlayerFigure(sex, equipList)
    else
        headAnim = CreatePlayerFigure(sex)
    end
    headAnim:getAnimNode():setScale(scale)
    headAnim:getAnimNode():setAnchorPoint(ccp(0.5,0))
    if con ~= nil then
        con:setVisible(true)
        if con:getChildByTag(77) ~= nil then
            con:removeChildByTag(77,true)
        end
        con:addChild(headAnim:getAnimNode(),0,77)
    end
    headAnim:play("avatar", false)
    headAnim:getAnimNode():setTouchEnable(false)
    return headAnim, con
end

--@brief	根据等级获取升级所需最大经验
--@param    nLevel,等级
--@return	#1，最大经验值
function GetMaxExpByLevel(nLevel)
    if nLevel == nil or GDatatab_player_upgrade["id_"..nLevel] == nil then
        return
    end

    local maxExp = GDatatab_player_upgrade["id_"..nLevel].exp
    local maxExpFormat = tostring(maxExp)
    if tonumber(maxExp) < 100000000 then 
    	maxExpFormat = tostring(maxExp)
    elseif tonumber(maxExp) >= 100000000 and tonumber(maxExp) <= 999999999 then 
        maxExpFormat = string.format("%9d", tonumber(maxExp))
    elseif tonumber(maxExp) >= 1000000000 and tonumber(maxExp) <= 9999999999 then 
        maxExpFormat = string.format("%10d", tonumber(maxExp))
    else
        maxExpFormat = string.format("%11d", tonumber(maxExp))
    end
    
    return tonumber(maxExp), maxExpFormat
end

--@brief    根据VIP等级，获取好友上限
--@param    nVipLevel 玩家的vip等级
function GetMaxFriends(nVipLevel)
    -- body
    if nVipLevel == nil or GDatatab_vip_restriction == nil or GDatatab_vip_restriction == {} then
        return
    end
    local nMaxFriendsNum = 100
    for i, value in pairs(GDatatab_vip_restriction) do
        if value.type == 9 and value.vip_level == nVipLevel then
            nMaxFriendsNum = value.count
            break
        end
    end

    nMaxFriendsNum = nMaxFriendsNum + CacheCenter:getPlayerInfo().level

    return nMaxFriendsNum
end

--@brief    根据VIP等级，获取可领取活力次数上限
--@param    nVipLevel 玩家的vip等级
function GetReceiveUpper(nVipLevel)
    -- body
    if nVipLevel == nil or GDatatab_vip_restriction == nil or GDatatab_vip_restriction == {} then
        return
    end
    local nReceiveUpper = 20
    for i, value in pairs(GDatatab_vip_restriction) do
        if value.type == 10 and value.vip_level == nVipLevel then
            nReceiveUpper = value.count
            break
        end
    end

    return nReceiveUpper
end

-- 获取最大的VIP等级表
function GetMaxVipLevel()
    local maxLv = 0
    for k,v in pairs(GDatatab_vip) do
        maxLv = maxLv + 1
    end
    return maxLv
end

--@brief	根据等级获取升级所需最大经验
--@param    nLevel,等级
--@return	#1，最大经验值
function GetPlayerMaxLevel()
    local maxLevel = tonumber(CacheCenter:getGameParam().gameMaxLevel)
    return maxLevel
end

--@brief  根据性别与武器创建玩家形象(默认显示站立动画,数据格式:{head = "1",face="1",body="1",weapon="1",wing="1"})
--@param  nSex : 性别
--@param  tEquip : 装备(需要包含装备类型 0 :炮弹 , 1:枪)
--@return conPlayer :添加到容器里需要获取conPlayer:getAnimNode()
function CreatePlayerAnim( nSex , tEquip)
    local sex = nSex == 0 and true or false
	local head = 2
	local face = 2
	local body = 2
	local weapon
	local weapType
	local wing
    local mount = 0
    if tEquip then
        if tEquip.head and tEquip.head ~= "" then head = tEquip.head end
        if tEquip.face and tEquip.face ~="" then face = tEquip.face end
        if tEquip.body and tEquip.body ~="" then  body = tEquip.body  end
        if tEquip.weapon and tEquip.weapon ~= "" then
            weapon = tEquip.weapon
            weapType = tEquip.weaponType
        end
        if tEquip.wing and tEquip.wing ~="" then wing = tEquip.wing  end
        if tEquip.mount and tEquip.mount ~="" then mount = tEquip.mount end
    end
	local conPlayer = YDPlayerAnimation:createAnimation(sex)
	conPlayer:setHead(head)
	conPlayer:setFace(face)
	conPlayer:setBody(body)

	if weapon and weapon ~= "" then
		if weapType == 0 then
			conPlayer:setWeaponBomb(weapon)
		else
			conPlayer:setWeaponGun(weapon)
		end
    end

	if wing  then conPlayer:setWing(wing) end

    conPlayer:setMount(mount)

	conPlayer:play("wait0",true)
	return conPlayer
end

--brief 创建宠物动画
--@param element 动画父节点
--@param petId 宠物的id
--@param animation  宠物的动画文件，可为nil，当为nil时，根据petId得到宠物动画
function CreatePetAni2(element, petId, animation,advanceLevel)
    WZLog("CreatePetAni one", tostring(element), tostring(petId), tostring(animation)) 
      if element == nil then
        return
      end

      if element.removeAllChildrenWithCleanup then
        element:removeAllChildrenWithCleanup(true)
      end
      local petAnimation = animation
      if petAnimation == nil then
        petAnimation = GDatatab_item["id_"..petId].animation_index_code
      end 
      local str = string.find(petAnimation, "_")
      local boolNewPet = (str ~= nil)
      local petAnimation = BattleAnimation:createAnimation(petAnimation, not boolNewPet)
      local animNode = petAnimation:getAnimNode()
      animNode:setRelativePosition(ccp(0.5,0.5))
      animNode:setAnchorPoint(ccp(0.5,0.5))
      animNode:setUseOriginSize(true)
      element:addChild(animNode)
      if  boolNewPet then
        petAnimation:play("wait",true)
      else
        petAnimation:play("0",true)
      end
      --添加特效
      local backFire = nil
      if advanceLevel and advanceLevel >= 6 then
          backFire = CCParticleSystemQuad:create("particle/pet_max_lizi.plist")
          backFire:setPositionType(kCCPositionTypeRelative)
          backFire:setAutoRemoveOnFinish(true)
          local posX,posY = animNode:getPosition()
          backFire:setPosition(posX,posY)
          animNode:addChild(backFire)
          --backFire:setPosition(posX,posY - 500)
       end
        WZLog("CreatePetAni two", tostring(element), tostring(petId), tostring(animation))
      return petAnimation
end


--@brief  根据性别与武器创建玩家形象
--@param  nSex : 性别，0:男 1:女
--@param  tEquip : 装备，装备id列表{3000,4300,4500,4700,...}
--@param  sAnimationName : 动画名称, 默认为wait0, 头像为"avatar"
--@param  bOnlyShowHead:是否只需要显示头部
--@return conPlayer :添加到容器里需要获取conPlayer:getAnimNode()
--@return 宠物的relativePosition,默认ccp(-0.5,1.5)
--@param    petAdvancedLevel:宠物进阶等级
--@param	是否幻化
function CreatePlayerFigure(nSex, tEquip, sAnimationName, nPetId, sPetAnimation, petCcp,bOnlyShowHead,bLoop,isBattle, petAdvancedLevel, headColor, bodyColor, isMonster, monsterId)
	WZLog("CreatePlayerFigure", WndPhantom.show == 1)
	local showMonster = isMonster or false
    local bIsBoy = nSex ~= 1 and true or false
	if tEquip ~= nil and #tEquip > 0 and type(tEquip[1]) ~= "table" then
		for i=1,#tEquip do
			if tEquip[i] < 0 then
				showMonster = true
				if monsterId == nil then
				monsterId = 0 - tEquip[i]
				end
				break
			end
		end
	end
    
	if tEquip ~= nil and #tEquip > 0 and type(tEquip[1]) == "table" then
		if CacheCenter:getPlayerInfo().shapeId > 0 then
			showMonster = true
			if monsterId == nil then
			monsterId = CacheCenter:getPlayerInfo().shapeId
			end
		end
	end
    if not tEquip then 
		if CacheCenter:getPlayerInfo().shapeId > 0 then
			showMonster = true
			if monsterId == nil then
			monsterId = CacheCenter:getPlayerInfo().shapeId
			end
		end
		tEquip = CacheCenter:getEquipmentList() 
	end

--	WZLog("CreatePlayerFigure:", WndPhantom.show, Serialize(tEquip), "showMonster", showMonster, monsterId)
	if showMonster == true and isMonster ~= false then
		local skins = GDatatab_shape_skins["id_" .. monsterId]
	    local mosterName = skins.animation
	    local file = "battle/monster/" .. mosterName
	    local bExist = WZFileUtil:isFileExist(file..".json")
	    if bExist then 
	    	conPlayer = YDPlayerAnimation:createAnimation(bIsBoy,isBattle,true)
			conPlayer:setMonsterId(monsterId)
	    	conPlayer:play("wait0", true)
			--conPlayer:getAnimNode():setDrawElementInfo(true)
	    	return conPlayer, nil, nil, true, showMonster
	    else 
	    	showMonster = false
	    	isMonster = false 
	    end
	end
    local conPlayer = YDPlayerAnimation:createAnimation(bIsBoy,isBattle)

    local head = nil
    local face = nil
    local body = nil
    local weapon
    local weapType
    local wing
    local mount = 0
	local headColor = headColor or 0
	local bodyColor = bodyColor or 0

    for i = 1, #tEquip do
		local nEquipId = tEquip[i]
		if nEquipId ~= nil then
			if type(nEquipId) == "table" then nEquipId = nEquipId.id end
		    local tEquipData = GetItemLocalData(nEquipId)

		    if tEquipData then
		        local maintype = tEquipData.main_type
		        local subtype = tEquipData.sub_type
		        if maintype == 4 and subtype == 0 then --投掷武器
		            weapType = 0
		            weapon = (tEquipData.animation_index_code)
		        elseif maintype == 4 and subtype == 1 then --射击武器
		            weapType = 1
		            weapon = (tEquipData.animation_index_code)
		        elseif maintype == 5 and subtype == 3 then -- 物品是否是翅膀装备
		            wing = (tEquipData.animation_index_code)
		        elseif maintype == 5 and subtype == 2 then --物品是否是衣服 
		            body = (tEquipData.animation_index_code)
		        elseif maintype == 5 and subtype == 1 then --物品是否是脸谱
		            face = (tEquipData.animation_index_code)
		        elseif maintype == 5 and subtype == 0 then -- 物品是否是头部 
		            head = (tEquipData.animation_index_code)
		        elseif maintype == 11 and subtype == 0 then -- 物品是否是头部
		            mount = (tEquipData.animation_index_code)
		            WZLog("CreatePlayerFigure two",mount)
		        end
		    end
		end
    end
   
    --设置默认显示
    local gameParam = CacheCenter:getGameParam()
    if bIsBoy == true then
        if head == nil then head = GDatatab_item["id_"..(gameParam.defaultManHeadId or 4903)].animation_index_code end
        if face == nil then face = GDatatab_item["id_"..(gameParam.defaultManFaceId or  4902)].animation_index_code end
        if body == nil then body = GDatatab_item["id_"..(gameParam.defaultManBodyId or  4901)].animation_index_code end
    else
        if head == nil then head = GDatatab_item["id_"..(gameParam.defaultWomanHeadId or 4906)].animation_index_code end
        if face == nil then face = GDatatab_item["id_"..(gameParam.defaultWomanFaceId or 4905)].animation_index_code end
        if body == nil then body = GDatatab_item["id_"..(gameParam.defaultWomanBodyId or 4904)].animation_index_code end
    end

    conPlayer:setHead(head, headColor)
    conPlayer:setFace(face)
    if not bOnlyShowHead then
    	conPlayer:setBody(body)
		conPlayer:setBodyRanSe(bodyColor)
		--conPlayer:setBodyRanSe(1)
        conPlayer:setMount(mount)
    end
    WZLog("CreatePlayerFigure three",mount)

    if weapon and weapon ~= "" then
        if weapType == 0 then
            conPlayer:setWeaponBomb(weapon)
        else
            conPlayer:setWeaponGun(weapon)
        end
    end

    if wing then conPlayer:setWing(wing) end
    if  bLoop == nil then --只显示头部不需要循环显示动画
    	bLoop = true
    end
    conPlayer:play(sAnimationName or "wait0", bLoop)

    local pet = nil
    if nPetId or sPetAnimation then
        pet,effect = CreatePetAni(conPlayer:getAnimNode(), nPetId, sPetAnimation, petAdvancedLevel)
        pet:getAnimNode():setAnchorPoint(ccp(0.5,0.5))
        pet:getAnimNode():setRelativePosition(ccp(-0.5,1.5))
        
        if petCcp then
            pet:getAnimNode():setRelativePosition(petCcp)
        end
        pet:getAnimNode():setZOrder(77)
    end
		--conPlayer:getAnimNode():setDrawElementInfo(true)
    return conPlayer, pet, effect ,showMonster
end

--@brief 	创建没有角色的坐骑跑动形象
-- pastureMountId 牧场用到的id
function CreateRunMountNoPlayer(mountId, sAnimationName, bLoop, pastureMountId)
	mountId = tonumber(mountId)
	WZLog("CreatePlayerFigure111", tostring(mountId))
	bLoop = bLoop or true
    local conPlayer = YDPlayerAnimation:createAnimation(true, false)

    local head,face,body = 999,999,999
    local mount = 0

    pastureMountId = pastureMountId or nil
    if pastureMountId == nil then
		local nEquipId = GDatatab_mounts["id_".. mountId].item_id
	    local tEquipData = GetItemLocalData(nEquipId)
	    mount = (tEquipData.animation_index_code)
	    WZLog("CreatePlayerFigure111 two",mount)
	else
		mount = tonumber(pastureMountId)
	end
    conPlayer:setHead(head, 0)
    conPlayer:setFace(face)

	conPlayer:setBody(body)
	conPlayer:setBodyRanSe(0)
    conPlayer:setMount(mount)

    conPlayer:play(sAnimationName or "wait0", bLoop)

    return conPlayer
end

--@brief  更新玩家形象
--@param  playerArmNode : 玩家形象
--@param  playerEquipData : 玩家形象装备(例如：头脸身)
function UpdatePlayerFigure(playerArmNode,playerEquipData,sex,headColor,bodyColor)
	if not playerArmNode then return	end
    --获取装备所对应的lua表
	local playerArmT = playerArmNode:getLuaObjectIndex()
	if not playerArmT then return end

    --设置默认显示
    local head,face,body,wing
    local headC = headColor or 0
	local bodyC = bodyColor or 0

	for i = 1, #playerEquipData do
		local nEquipId = playerEquipData[i]
		if type(nEquipId) == "table" then nEquipId = nEquipId.id end
        local tEquipData = GetItemLocalData(nEquipId)
        if tEquipData then
            local maintype = tEquipData.main_type
            local subtype = tEquipData.sub_type
            if maintype == 4 and subtype == 0 then --投掷武器
                playerArmT:setWeaponBomb(tEquipData.animation_index_code)
            elseif maintype == 4 and subtype == 1 then --射击武器
                playerArmT:setWeaponGun(tEquipData.animation_index_code)
            elseif maintype == 5 and subtype == 3 then -- 物品是否是翅膀装备
                wing = tEquipData.animation_index_code
                playerArmT:setWing(tEquipData.animation_index_code)
            elseif maintype == 5 and subtype == 2 then --物品是否是衣服
                body = tEquipData.animation_index_code
                playerArmT:setBody(tEquipData.animation_index_code)
                playerArmT:setBodyRanSe(bodyC)
            elseif maintype == 5 and subtype == 1 then --物品是否是脸谱
                face = tEquipData.animation_index_code
                playerArmT:setFace(tEquipData.animation_index_code)
            elseif maintype == 5 and subtype == 0 then -- 物品是否是头部
                head = tEquipData.animation_index_code
                playerArmT:setHead(tEquipData.animation_index_code,headC)
            end
        end
    end
    
    if sex ~= nil then
        local gameParam = CacheCenter:getGameParam()
        if sex == true then
            if not head then head = GDatatab_item["id_"..(gameParam.defaultManHeadId or 4903)].animation_index_code end
            if not face then face = GDatatab_item["id_"..(gameParam.defaultManFaceId or  4902)].animation_index_code end
            if not body then body = GDatatab_item["id_"..(gameParam.defaultManBodyId or  4901)].animation_index_code end
        else
            if not head then head = GDatatab_item["id_"..(gameParam.defaultWomanHeadId or 4906)].animation_index_code end
            if not face then face = GDatatab_item["id_"..(gameParam.defaultWomanFaceId or 4905)].animation_index_code end
            if not body then body = GDatatab_item["id_"..(gameParam.defaultWomanBodyId or 4904)].animation_index_code end
        end
        playerArmT:setBody(body)
        playerArmT:setFace(face)
    	playerArmT:setHead(head, headColor)
    end
    

    playerArmT:play("wait0", true)
end

-- 创建玩家自己的角色
--@return conPlayer :添加到容器里需要获取conPlayer:getAnimNode()
function CreateSelfAni()
    WZLog("CreateSelfAni one")
    local sex = CacheCenter:getPlayerInfo().sex

	--是否幻化
	if CacheCenter:getPlayerInfo().shapeId > 0 and WndPhantom.show == 1 then
		local skins = GDatatab_shape_skins["id_" .. CacheCenter:getPlayerInfo().shapeId]
	    local mosterName = skins.animation
	    local file = "battle/monster/" .. mosterName
	    local bExist = WZFileUtil:isFileExist(file..".json")
	    if bExist then 
	    	conPlayer = YDPlayerAnimation:createAnimation(bIsBoy,false,true)
			conPlayer:setMonsterId(CacheCenter:getPlayerInfo().shapeId)
	    	conPlayer:play("wait0", true)
	        conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
	        conPlayer:getAnimNode():setRelativePosition(ccp(0.5,0))
	    	return conPlayer
	    end
	end

    local equip = CacheCenter:getDecorationList()
    local data = {}
    for k, v in pairs(equip) do
        if  v.maintype == 5 and v.isUse then
            WZLog("CreateSelfAni two",v.id, v.subtype)
            local subType = v.subtype
            table.insert(data, v.id)
        end
    end
    if CacheCenter:getPlayerInfo().mountsInfo then
        data.mount = CacheCenter:getPlayerInfo().mountsId
    else
        data.mount = 0
	end

	local head,body = CacheCenter:getHeadAndBodyColor()
    local conPlayer = CreatePlayerFigure(sex, data,nil,nil,nil,nil,nil,nil,false,nil,head,body,false)
    return conPlayer
end

--@brief  创建剧情对话群
function CreateStoryTalkGroup(groupIndex, isBattle, teachGroupId, teachStepId, scene, isUpgrade, isReplace, isUpgradeTeach, trailerButtonId)
    WZLog("CreateStoryTalkGroup0", tostring(groupIndex), tostring(isBattle), tostring(teachGroupId), tostring(teachStepId))
    if teachGroupId == nil then
    	--return
    end

    if isBattle == true then
    	SceneBattle:disableSchedule()
    end

    local isConfirmActive = WindowManager:ifActiveWindow(WndConfirmBox)
    WZLog("CreateStoryTalkGroup1", tostring(GDatatab_story_talk), tostring(WndTeachTalk:IsNoExist()), tostring(isConfirmActive))
    if GDatatab_story_talk == nil or WndTeachTalk:IsNoExist() ~= true or isConfirmActive then
        return
    end

    local info
    local firstIndex
    for i ,v in pairs (GDatatab_story_talk) do
        if v.storyId == groupIndex and v.talkId == 1 then
            info = v
            firstIndex = i
            WZLog("CreateStoryTalkGroup2.1", firstIndex)
            firstIndex = string.gsub(firstIndex, "id_", "")
            WZLog("CreateStoryTalkGroup2.2", firstIndex)
            firstIndex=tonumber(firstIndex)
            break
        end
    end

    WZLog("CreateStoryTalkGroup2", firstIndex)
    local headList, headTypeList, headFaceList, headFacePosList = {}, {}, {}, {}
    for i=0,100 do
    	local index = "id_" .. (firstIndex + i)
    	local v = GDatatab_story_talk[index]

    	if i == 1 or v == nil or v.storyId ~= groupIndex then
    		break
    	end

    	if headList[1] == nil and v.objectType == 1 then
    		local head = nil
    		if v.headType == nil or v.headType == 1 then
	    		if v.headIndex ~= -1 then
		            if CacheCenter:getPlayerInfo().sex == 0 then
			            head = "common_pic_shuaige1_" .. v.headIndex
			        else
			            head = "common_pic_meinv1_" .. v.headIndex
			        end
		        elseif CacheCenter:getPlayerInfo().sex == 0 then
		            head = "common_pic_shuaige1"
		        else
		            head = "common_pic_meinv1"
		        end
		    elseif v.headType == 2 then
		    	if CacheCenter:getPlayerInfo().sex == 0 then
		            head = "master"
		        else
		            head = "instructor"
		        end
		    end
    		headList[1] = head
    		headTypeList[1] = v.headType
    		headFaceList[1] = v.face
    		headFacePosList[1] = v.facePos
    	end

    	if headList[2] == nil and v.objectType ~= 1 then
    		headList[2] = v.headIndex
    		headTypeList[2] = v.headType
    		headFaceList[2] = v.face
    		headFacePosList[2] = v.facePos
    	end

    	WZLog("CreateStoryTalkGroup3", i, groupIndex, "head1", tostring(headList[1]), tostring(headTypeList[1]), tostring(headFaceList[1]), tostring(headFacePosList[1]),
    		"head2", tostring(headList[2]), tostring(headTypeList[2]), tostring(headFaceList[2]), tostring(headFacePosList[2]))
    	if headList[1] and headList[2] then
    		break
    	end
    end

    local name,head,objectType
    if info.objectType == 1 then
        name = CacheCenter:getPlayerInfo().name
        objectType = false
        if info.headType == nil or info.headType == 1 then
			if info.headIndex ~= -1 then
	            if CacheCenter:getPlayerInfo().sex == 0 then
		            head = "common_pic_shuaige1_" .. info.headIndex
		        else
		            head = "common_pic_meinv1_" .. info.headIndex
		        end
	        elseif CacheCenter:getPlayerInfo().sex == 0 then
	            head = "common_pic_shuaige1"
	        else
	            head = "common_pic_meinv1"
	        end
	    elseif info.headType == 2 then
	    	if CacheCenter:getPlayerInfo().sex == 0 then
	            head = "master"
	        else
	            head = "instructor"
	        end
	    end
    else
        name = info.objectName
        head = info.headIndex
        objectType = true
    end
    local isJump = info.isjump
    local sound = info.soundIndex
    --isJump = 1

    CreateStoryTalk(name, head, objectType, isReplace == true, info.text, nil, groupIndex, 1, isBattle, teachGroupId, teachStepId, scene, isUpgrade, isReplace, isUpgradeTeach, headList, isJump, trailerButtonId, sound, headTypeList, headFaceList, headFacePosList, firstIndex)

end

--@brief  创建剧情对话
function CreateStoryTalk(name,icon,isRight,isReplaceScene,tableTxt, tableJump, groupIndex, talkIndex, isBattle, teachGroupId, teachStepId, 
	scene, isUpgrade, isReplace, isUpgradeTeach, headList, isJump, trailerButtonId, sound, headTypeList, headFaceList, headFacePosList, index)
    WZLog("CreateStoryTalk0",index,name,icon,isRight,tableTxt,isReplaceScene)

    local isConfirmActive = WindowManager:ifActiveWindow(WndConfirmBox)
    WZLog("SceneBattleLoading:onFinish", tostring(isConfirmActive))
    if isConfirmActive then
    return
    end

    tableTxt = SplitStoryTalk(tableTxt,"255,255,255")
    local wndTeachTalk = WndTeachTalk:createElement()
    WndTeachTalk:setDetail(tableTxt)
    WndTeachTalk:setImgRight(isRight)
    WndTeachTalk:setName(name)
    WndTeachTalk:setTeachStep(teachGroupId, teachStepId)
    WndTeachTalk:setIcon(icon)
    WndTeachTalk:setHeadList(headList)
    WndTeachTalk:setHeadType(headTypeList)
    WndTeachTalk:setHeadFace(headFaceList)
    WndTeachTalk:setHeadFacePos(headFacePosList)
    WndTeachTalk:setIndex(index)
    WndTeachTalk:setIsJump(isJump)
    WndTeachTalk:setScene(scene)
    WndTeachTalk:setReplaceScene(isReplaceScene)
    WndTeachTalk:setGroupIndex(groupIndex, talkIndex)
    WndTeachTalk:setBattle(isBattle)
    WndTeachTalk:setSound(sound)
    WndTeachTalk:setReplace(isReplace)
    WndTeachTalk:setUpgradeTeach(isUpgradeTeach)
    WndTeachTalk:setTrailerButtonId(trailerButtonId)
    WindowManager:addWindow(wndTeachTalk,WndTeachTalk)
    local zorder = WindowManager.m_nZOrderOffset
    if WndCurrentChat.m_root then
    	if WndCurrentChat.m_root:getZOrder() + 1 > zorder then
    		zorder = WndCurrentChat.m_root:getZOrder() + 1
    	end
    end
    wndTeachTalk:setZOrder(zorder)
	WndTeachTalk:setIsUpgrade(isUpgrade)
end

--@brief  创建带跳转的剧情对话
function CreateJumpStoryTalkGroup(groupIndex)
    local info
    for i ,v in pairs (GDatatab_story_talk) do
        if v.storyId == groupIndex and v.talkId == 1 then
            info = v
        end
    end

    local name,head,objectType
    name = info.objectName
    head = info.headIndex
    objectType = false

    local listName = SplitStringWithSeparator(info.buttonName, ",")
    local listId = SplitStringWithSeparator(info.buttonJump, ",")
    local btns = {}
    for i,v in ipairs(listName) do
    	if listId[i] ~= "-2" or ProjConfig.PLAY_LOGO == 1 and CheckButtonShow(123, true) then
    		--越南 ios不显示兑换码 安卓显示
    		if ProjConfig.LANGUAGE == "vn" then
    			if WZUISystem:getInstance():getPlatformInfo() == 1 then
	    			if listId[i] ~= "189" then
	    				table.insert(btns, {desc=v, data={uiMainId=listId[i]}})
	    			end
    			else
    				table.insert(btns, {desc=v, data={uiMainId=listId[i]}})
    			end
    		else
	    		table.insert(btns, {desc=v, data={uiMainId=listId[i]}})
	    	end
    	end
    end
    table.insert(btns, {desc=LocalStrings.BACK, data={uiMainId=-1}})

    --local btns = {{desc=info.buttonName, data={uiMainId=info.buttonJump}}, {desc=LocalStrings.BACK, data={uiMainId=-1}}}
    CreateJumpStoryTalk(name, head, objectType, false, info.text, btns)

end

--@brief  创建带跳转的剧情对话
function CreateJumpStoryTalk(name,icon,isRight,isReplaceScene,tableTxt,tableJump)
    WZLog("CreateJumpStoryTalk",name,icon,isRight,tableTxt,isReplaceScene)

    --[[
    local btn = {desc="游戏大厅", data={uiMainId=2}}
    local btn2 = {desc="商城", data={uiMainId=43}}
    local tableJump = {btn, btn2}
	--]]

    tableTxt = SplitStoryTalk(tableTxt)
    local wndTeachTalk = WndTeachJumpTalk:createElement()
    WndTeachJumpTalk:setDetail(tableTxt)
    WndTeachJumpTalk:setImgRight(isRight)
    WndTeachJumpTalk:setName(name)
    WndTeachJumpTalk:setIcon(icon)
    WndTeachJumpTalk:setBtn(tableJump)
    WndTeachJumpTalk:setReplaceScene(isReplaceScene)
    WindowManager:addWindow(wndTeachTalk,WndTeachJumpTalk)

end

--@brief  分割剧情对话
function SplitStoryTalk(s,fontColor)
    WZLog("SplitStoryTalk zero",s)

    local sColor = "127,70,26"
    if fontColor then
    	sColor = fontColor
    end

    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    local sSeparator = " | "
    local actionStart = [[<]]
    local actionEnd = [[>]]

    local actionSeparator = "|"

    local strSepar = ","
    if "cn" == ProjConfig.LANGUAGE then
        strSepar = "`"
        s = string.gsub(s, " ", "")
    else
        strSepar = "`"
    end
    s = string.gsub(s, "AAA", CacheCenter:getPlayerInfo().name)
    local storyList = SplitStringWithSeparator(s, actionSeparator)

    for i=1, #storyList do
        local s = storyList[i]
        local subStartIndex = string.find(s, actionStart)
        local subEndIndex = string.find(s, actionEnd)

        local strList = SplitStringWithSeparator(s, actionStart, actionEnd)
        for j=1, #strList do
            local s = strList[j]
            local strTable = SplitStringWithSeparator(s, strSepar)
            if #strTable > 1 then
                strList[j] = strTable
            end
        end
        WZLog("SplitStoryTalk one-0",Serialize(strList))

        local stringFormat = ""
        for k=1, #strList do
            local s = strList[k]
            WZLog("SplitStoryTalk one-1",k, stringFormat, s)
            if type(s) == "string" then
                stringFormat = stringFormat .. (string.format([[<T C="%s" S="22">]],sColor)..s..[[</T>]])
            elseif type(s) == "table" then
                stringFormat = stringFormat .. (string.format([[<T C="%s,%s,%s" S="22">]],s[2],s[3],s[4])..s[1]..[[</T>]])
            end
            WZLog("SplitStoryTalk one-2",k, stringFormat)
        end
        storyList[i] = stringFormat
        WZLog("SplitStoryTalk two", Serialize(strList),"\n", stringFormat)
    end

    WZLog("SplitStoryTalk end",Serialize(storyList))
    return storyList
end

--@brief    获得可写地址
--@param
--@return   #1: 返回路径，类型是string
--@note
function GetWriteablePath()
	local fileUtils = CCFileUtils:sharedFileUtils()
	if fileUtils == nil then
        WZLog("GetWriteablePath CCFileUtils:sharedFileUtils() = nil")
		return
	end

	local sWritablePath = fileUtils:getWritablePath()
	if sWritablePath ==  nil then
		WZLog("GetWriteablePath fileUtils:getWritablePath() = nil")
		return
	end

	return sWritablePath
end

--@brief    创建一个文件夹
--@param    sFolderName: 文件夹的名称
--@return   是否成功
--@note     一次只能创建一个文件夹
function CreateFolderOnce(sFolderName)
	local bHavedPath = WZFileUtil:isDirectoryExist(sFolderName)
	if bHavedPath == false then
		return WZFileUtil:makeDirectory(sFolderName)
	end
	return true
end

--@brief    创建一个文件夹
--@param    sFolderName: 文件夹的名称
--@return   是否成功
--@note     
function CreateFolder(sFolderName)
	local sWriteablePath = GetWriteablePath()
	if sWriteablePath == nil then
		WZLog("CreateFolder sWriteablePath is nil")
		return false
	end
    WZLog(sFolderName)
	local tPath = SplitStringWithSeparator(sFolderName, "/")
	local sPathNow = sWriteablePath
	for i = 1, #tPath do
        sPathNow = sPathNow.."/"..tPath[i]
        local bResult = CreateFolderOnce(sPathNow)
        if not bResult then
            return false
        end
	end
	return true
end

--@brief    获取文件全路径
--@param    sFileName: 文件的名称
--@param    sPathIn: 相对路径
--@return   文件全路径
--@note  
function GetFileFullPath(sFileName, sPathIn)
	local sPath = nil
	if sPathIn == nil or sPathIn == "" then
		sPath = "/"..sFileName
	else
		sPath = sPathIn.."/"..sFileName
        local bCreateFolder = CreateFolder(sPathIn)
        if bCreateFolder == false then
            WZLog("GetFileFullPath CreateFolder failure!")
            return
        end
	end
	return sPath
end

--@brief    将一个表写入文件
--@param    t: 需要写入的表
--@param    sFileName: 被写入的文件名
--@param    sPathIn: 从此目录下写文件,为空时取默认目录
--@param    bCrypt: 是否进行加密
--@return
--@note
function WriteTableToFile(t, sFileName, sPathIn, bCrypt)
	if t == nil or sFileName == nil then
        WZLog("WriteTableToFile", t, sFileName, "failure")
		return
    end
	local sStr = json.encode(t)
	if sStr then
        local sFullName = GetFileFullPath(sFileName, sPathIn)
        WZFileUtil:writeStringToFile(sFullName, sStr, bCrypt)
    else
        WZLog("WriteTableToFile failure! json.encode got nil string!")
	end
end

--@brief    将一个文件的内容写到table里面
--@param    sFileName: 需要读取的文件的文件名
--@param    sPathIn: 从此目录下读取文件,为空时取默认目录
--@param    bCrypt: 是否进行解密
--@return   #1: table
--@note
function ReadFileToTable(sFileName, sPathIn, bCrypt)
	if sFileName == nil or sFileName == "" then
		WZLog("ReadFileToTable file Name error")
		return
	end
	
    local sFullName = GetFileFullPath(sFileName, sPathIn)
	if WZFileUtil:isFileExist(GetWriteablePath()..sFullName) == false then
        WZLog("ReadFileToTable", sFullName, "file not exist")
		return
	end
    
	local sStr = WZFileUtil:getStringFromFile(sFullName, bCrypt)
	if sStr then
		return json.decode(sStr)
	end
end

--@brief 	空白面板提示内容
--@param    objNode  容器节点
--@param 	sText  提示内容
--@param    color 字体颜色
--@param    position 相对坐标
--@param    strokeColor 描边颜色
function ShowPanelNullTip( objNode, sText, color, strokeColor, fontSize, position, dimensions, bShowAll)
    if objNode:getChildByTag(100) then
        objNode:removeChildByTag(100,true)
    end
    if position == nil then
        position = ccp(0.5,0.5)
    end
    if fontSize == nil then
        fontSize = 24
    end

    if sText == nil then
        sText = LocalStrings.FRIENDS_SEND_TIP_3
    end
    if color == nil then
        color = ccc3(158,139,121)
    end
    if strokeColor == nil then
        strokeColor = ccc3(105,65,46)
    end

    local txtNoData = WZUILabelTTF:create()
    txtNoData:setAnchorPoint(ccp(0.5,0.5))
    txtNoData:setUseOriginSize(true)
    txtNoData:setRelativePosition(position)
    txtNoData:setColor(color)
    txtNoData:setFontSize(fontSize)
    txtNoData:setText(sText)
    txtNoData:setStrokeColor(strokeColor)
    txtNoData:setStrokeSize(4)
    txtNoData:setEnableStroke(false)

    if dimensions then
	    txtNoData:setDimensions(dimensions)
	end

    objNode:addChild(txtNoData, 100, 100)
	-- if bShowAll ~= false and bShowAll ~= nil then
	--     objNode:setShowAll(true)
	-- end
end

--@brief 	移除空白面板提示内容
--@param    objNode  容器节点
function removeShowPanelNullTip(objNode)
	if objNode:getChildByTag(100) then
        objNode:removeChildByTag(100,true)
    end
end

--@brief    语聊按钮是否显示
--@param    nBtnId, 按钮id
--@return   #1, 是否显示
function CheckTalkButtonShow(nBtnId)
	local btnInfo = GDatatab_talk_button_info
	if btnInfo then
        for i,v in pairs(btnInfo) do
            if v.type == nBtnId then
                if GlobalGame:getSecretNumberData("player_level") and v.show_level and
			        GlobalGame:getSecretNumberData("player_level") < v.show_level or checkTalkButtonChannel(v.channel) == false then
			        return false
			    else
			        return true
			    end
            end
        end
    end
end

function checkTalkButtonChannel(buttonChannel)
	local l = SplitStringWithSeparator(buttonChannel, ",")
--	WZLog("checkbuttonChannel", buttonChannel, ProjConfig.CHANNEL_ID)
	for i,v in ipairs(l) do
		v = tonumber(v)
		if v and (v == -1 or v == tonumber(ProjConfig.CHANNEL_ID)) then
			return true
		end
	end

	return false
end

--@brief    按钮是否显示
--@param    nBtnId, 按钮id
--@return   #1, 是否显示
function CheckButtonShow(nBtnId)
--	WZLog("CheckButtonShow zero", nBtnId)
	if nBtnId == 113 then
		if whetherCloseRecharge() then
	        return false
	    end
    end
	local btnInfo = GlobalGame:getBtnInfoByType()
--	WZLog("CheckButtonShow0", nBtnId)
	if btnInfo then
        for i,v in ipairs(btnInfo) do
            if v.buttonId == nBtnId then
            --	WZLog("CheckButtonShow1", nBtnId, v.buttonStatus1Level, GlobalGame:getSecretNumberData("player_level"), checkbuttonChannel(v.buttonChannel))
                if GlobalGame:getSecretNumberData("player_level") and v.buttonStatus1Level and
			        GlobalGame:getSecretNumberData("player_level") < v.buttonStatus1Level or checkbuttonChannel(v.buttonChannel) == false then
			        return false
			    else
			        return true
			    end
            end
        end
    end
end


--@brief	检查按钮是否开放
--@param    按钮id ,是否显示tip:nil显示,其他不显示
--@return   #1, 是否开放
function CheckButtonOpen(nBtnId,isTip)
--	WZLog("CheckButtonOpen", nBtnId)
	if nBtnId == 113 then
		if whetherCloseRecharge() then
	        return false
	    end
    end
	if TeachGroup1.ISTEACHMODE then return true end
	local btnInfo = GlobalGame:getBtnInfoByType()
    if btnInfo then
        local info = btnInfo[nBtnId]
--        WZLog("CheckButtonOpen two", tostring(info))
        local bFlag, lv = IfButtonOpen(info)

        if bFlag == false and isTip == nil then
--            WZLog("SceneCity:_checkBuildingOpen", nBtnId, tostring(info.buttonTips))
            MsgBoxManager:showTipBox(info.buttonTips)
        end
        --bFlag = bFlag and checkbuttonChannel(info.buttonChannel)
        return bFlag, lv
    end
    return true, lv
end

--@brief	检查按钮是否渠道开放
function CheckButtonChannelOpen(nBtnId)
	WZLog("CheckButtonChannelOpen", nBtnId)
	if TeachGroup1.ISTEACHMODE then return true end
	local btnInfo = GlobalGame:getBtnInfoByType()
    if btnInfo then
        local info = btnInfo[nBtnId]
        WZLog("CheckButtonOpen two", tostring(info))
        local bFlag = checkbuttonChannel(info.buttonChannel)
        return bFlag
    end
    return true
end

--@brief	按钮是否开放
--@param    tButtonInfo, 按钮信息表
--@return   #1, 是否开放
function IfButtonOpen(tButtonInfo)
    if CacheCenter.m_tPlayerInfo == nil or tButtonInfo == nil then
        return nil
    end

--    WZLog("SceneCity:ifBuildingOpen", GlobalGame:getSecretNumberData("player_level"), tButtonInfo.buttonStatus3Level, tButtonInfo.buttonId)

    if GlobalGame:getSecretNumberData("player_level") and tButtonInfo.buttonStatus3Level and
        GlobalGame:getSecretNumberData("player_level") < tButtonInfo.buttonStatus3Level then
        return false, tButtonInfo.buttonStatus3Level
    else
        return true, tButtonInfo.buttonStatus3Level
    end
end

function CheckInputTxtLen(inputTxt)
	-- body
	local sTxt = inputTxt
	local nInputTxtLen = 0

	WZLog("******** CheckInputTxtLen ******", inputTxt)

	local _,count = string.gsub(sTxt, "%w", "A") --统计字母数字的数量
	nInputTxtLen = nInputTxtLen + count 

	sTxt= inputTxt
	local _,count1 = string.gsub(sTxt, "%p", "A") 	--统计符号的数量
	nInputTxtLen = nInputTxtLen + count1 

	sTxt= inputTxt
	local _,count2 = string.gsub(sTxt,"%s", "A")		--统计空格的数量
	nInputTxtLen = nInputTxtLen + count2

	local nLen = string.len(inputTxt)
	nInputTxtLen = nInputTxtLen + 2 * math.floor((nLen - count - count1 - count2) / 3)

	return nInputTxtLen, count2
end

--@brief 	判断输入的内容是否合法,是否超长等
--@param 	1:判断角色名2:判断公会名3:判断战队名4:判断套装名 6联盟名字
function JudgeResultInClientForInputText(nUseType, txt)
	local result = 0

	local nInputTxtLen, spaceCnt = CheckInputTxtLen(txt)

	WZLog("****** JudgeResultInClientForInputText ********** ", nInputTxtLen, spaceCnt)

    if spaceCnt > 0 then
    	result = 14
    end
    if nUseType == 1 then
    	if nInputTxtLen > 12 then 
        	result = 5
        end
    elseif nUseType == 2 then
    	if nInputTxtLen > 16 then 
    		result = 8
    	end
    elseif nUseType == 3 then
    	if nInputTxtLen > 10 then
	    	result = 9
	    end
    elseif nUseType == 4 then
    	if nInputTxtLen > 8 then
	    	result = 10
	    end
    elseif nUseType == 5 then
    	if nInputTxtLen > 10 then
	    	result = 11
	    end
    elseif nUseType == 6 then
    	if nInputTxtLen > 14 then 
    		return 12
    	elseif nInputTxtLen < 4 then 
    		return 13 
    	end
    end

	if txt == "" then 
		result = 4 		--不能为空字符
	end
	if tonumber(txt) ~= nil then
		result = 7 		--纯数字
	end 

	return result 
end

--@brief    显示改名结果
--@param    #1返回的结果result : 1、成功，2、重名，3、非法字符，4、名字不能为空，5、名字太长, 6、名字太短,7、纯数字
function DisplayResult(result)
    WZLog("************** DisplayResult **************** ")

    if result == 1 then

    elseif result == 2 then

    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO3)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
    elseif result == 5 then

    elseif result == 6 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_TOO_SHOOT)
    elseif result == 7 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_CANT_BE_NUMBER)
    elseif result == 8 then 
       	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO5)
    elseif result == 9 then 
       	MsgBoxManager:showTipBox(LocalStrings.LEAGUE28)
    elseif result == 11 then 
       	MsgBoxManager:showTipBox(LocalStrings.TEAMCONSUME_TEXT1[20])
    elseif result == 12 then 
       	MsgBoxManager:showTipBox(LocalStrings.UNION_TEXT1[35])
    elseif result == 13 then 
       	MsgBoxManager:showTipBox(LocalStrings.UNION_TEXT1[36])
    elseif result == 14 then 
       	MsgBoxManager:showTipBox(LocalStrings.KID_TEXT147)
    end
end

--@brief	moneyType 货币种类 1钻石 2金币,11位竞技币,206兑换卡
--@brief	moneyCnt 当前需要的货币数量
--@brief	text	提示的文字
--@brief	nType	物品不足时的反馈，1快速购买，2弹出提示框    默认1
--@brief	nWindowId	窗口界面的id，具体值看配置表
--@param    tCell : 回调方法所属的表结构
--@param    func : 钻石不足点击确认后需要执行的回调方法
--@param    tCustomUIConfig : 确定按钮的按钮字
--@param    nBoxType : 默认使用confirmBox，1：使用confirmCaccelBox
--@brief    tCell2, func2:提示礼券不足时候，如果钻石足够的回调
--@brief	return true 表示货币充足，false表示货币不足
--@brief 	lottery 2抽奖蓝钻足够 1抽奖粉钻足够 3抽奖粉钻不足加上蓝钻足够
--@brief 	blueNum 需要蓝钻数量
function JudgeMoneyIsEnough(moneyType, moneyCnt, text, nType, nWindowId, tCell, func, tCustomUIConfig, nBoxType, tCell2, func2, lottery,blueNum)
	WZLog("-----------JudgeMoneyIsEnough----------", moneyType, moneyCnt, ntype)
	moneyType = tonumber(moneyType)
	moneyCnt = tonumber(moneyCnt)
	if moneyType == 70 then
		moneyType = nil
	end
	if moneyType == nil or moneyCnt == nil then
		WZLog("货币类型错误")
		return
	end
	nWindowId = nWindowId or GlobalGame.g_nCurrentUIChannelId
    -- 钻石不足
    local tCallBack = nil 
    if tCell and func then
        tCallBack = {}
        tCallBack[1] = tCell
        tCallBack[2] = func
    end
    local function diamondNotEnough(nId, nResType)
        if nResType == MSGBOXRESTYPE_CONFIRM then 
            if nWindowId then
            	PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep2, nWindowId)
            end
            if tCallBack then
                tCallBack[2](tCallBack[1])
            end
            WndVip:showWndUI(0, true)
        end
    end

    local function diamondNotEnough2(nId, nResType)
        if nResType == MSGBOXRESTYPE_CONFIRM then 
            if nWindowId then
            	PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep2, nWindowId)
            end
            if tCallBack then
                tCallBack[2](tCallBack[1])
            end
            WndVip:showWndUI(1, true)
        end
    end

    -- 金币不足
    local function goldNotEnough()
        WndBuyActivity:showBuyInterface(26)
	end

    local moneyList = CacheCenter:getMoneyList()
	local tData = GDatatab_item["id_"..moneyType]
    if moneyType == 1 then
        local pCnt = moneyList.blueDiamond
        if pCnt < moneyCnt then
        	if nWindowId then
        		PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep1, nWindowId)
        	end
            if nBoxType then
                MsgBoxManager:showConfirmCancelBox(LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, nil, diamondNotEnough, nil, tCustomUIConfig)
            else
                MsgBoxManager:showConfirmBox(LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, nil,diamondNotEnough, nil, tCustomUIConfig) -- 钻石不足
            end
            return false
        end
    elseif moneyType == 2 then
        local pCnt = moneyList.gold

        if pCnt < moneyCnt then
            MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, nil,goldNotEnough)-- 金币不足
            return false
		end
	elseif moneyType == 11 then
		local pCnt = moneyList.athMoney
		if pCnt < moneyCnt then
			MsgBoxManager:showConfirmBox(LocalStrings.ATHMONEY_NOT_ENOUGH, nil,nil, nil, nil,true) -- 竞技币不足
			return false
		end
	elseif moneyType == 166 then
		local pCnt = moneyList.reel
		if pCnt < moneyCnt then
			MsgBoxManager:showConfirmBox(LocalStrings.REEL_NOT_ENOUGH, nil,nil, nil, nil,true) -- 紫装卷轴不足
			return false
		end
    --elseif moneyType == 206 then
    --    local pCnt = CacheCenter:getPlayerItemCountById(moneyType)
    --    local itemInfo = GDatatab_item["id_"..moneyType]
    --    WZLog("-----------------card info----------------",pCnt,moneyCnt)
    --    if pCnt < moneyCnt then
    --        MsgBoxManager:showConfirmBox(string.format(LocalStrings.CARD_COUNT,itemInfo.name), nil,diamondNotEnough)-- 兑换卡不足
    --        return false
	--	end
	--elseif moneyType == 205 or moneyType == 312 then
	--	local pCnt = CacheCenter:getPlayerItemCountById(moneyType)
	--	local itemInfo = GDatatab_item["id_"..moneyType]
	--	WZLog("-----------------card info----------------",pCnt,moneyCnt)
	--	if pCnt < moneyCnt then
	--		MsgBoxManager:showConfirmBox(string.format(LocalStrings.CARD_COUNT1,itemInfo.name), nil,nil,nil,nil,true)-- 兑换卡不足
	--		return false
	--	end
    elseif moneyType == 57 then--恩赐币
        local pCnt = CacheCenter:getPlayerItemCountById(moneyType)
        local itemInfo = GDatatab_item["id_"..moneyType]
        WZLog("-----------------card info----------------",pCnt,moneyCnt)
        if pCnt < moneyCnt then
			MsgBoxManager:showConfirmBox(string.format(LocalStrings.CARD_COUNT1,itemInfo.name), nil,nil,nil,nil,true)
            return false
		end
    elseif moneyType == 71 then--钻石精华
        local pCnt = CacheCenter:getPlayerItemCountById(moneyType)
        local itemInfo = GDatatab_item["id_"..moneyType]
        WZLog("-----------------card info----------------",pCnt,moneyCnt)
        if pCnt < moneyCnt then
			MsgBoxManager:showConfirmBox(string.format(LocalStrings.CARD_COUNT1,itemInfo.name), nil,nil,nil,nil,true)
            return false
		end
    elseif moneyType == 72 then--礼钻精华
        local pCnt = CacheCenter:getPlayerItemCountById(moneyType)
        local itemInfo = GDatatab_item["id_"..moneyType]
        WZLog("-----------------card info----------------",pCnt,moneyCnt)
        if pCnt < moneyCnt then
			MsgBoxManager:showConfirmBox(string.format(LocalStrings.CARD_COUNT1,itemInfo.name), nil,nil,nil,nil,true)
            return false
		end
    elseif moneyType == 58 then --矿晶不足
        if CacheCenter:getMoneyList().gemCoin < moneyCnt then
            local basicInfo = GDatatab_item["id_" .. moneyType]
            
            -- 矿晶不足
            local function gemNotEnough()
                WndBuyActivity:showBuyInterface(58)
            end

            MsgBoxManager:showConfirmBox(string.format(LocalStrings.SWEEP_COPY_NOT_ITEM_TIP, basicInfo.name), nil,gemNotEnough)-- 矿晶不足
            return 
        end
    elseif moneyType == 61 then --幻化晶石不足
        if CacheCenter:getMoneyList().phantomCoin < moneyCnt then
            local basicInfo = GDatatab_item["id_" .. moneyType]

            if ProjConfig.LANGUAGE == "en" then            	
				MsgBoxManager:showTipBox(LocalStrings.NOT_ENABLE .. " " .. basicInfo.name)
			elseif ProjConfig.LANGUAGE == "tr" then  
				MsgBoxManager:showTipBox(basicInfo.name .. " " .. LocalStrings.NOT_ENABLE)
			else
				MsgBoxManager:showTipBox(basicInfo.name..LocalStrings.NOT_ENABLE)
			end

            return 
        end
    elseif moneyType == 66 or moneyType == 67 then --圣水或奇石不足
        local pCnt = CacheCenter:getPlayerItemCountById(moneyType)
        if pCnt < moneyCnt then
            local basicInfo = GDatatab_item["id_" .. moneyType]
            -- 圣水或奇石不足
            local function waterNotEnough()
                WndBuyActivity:showBuyInterface(moneyType)
            end

            MsgBoxManager:showConfirmBox(string.format(LocalStrings.SWEEP_COPY_NOT_ITEM_TIP, basicInfo.name), nil,waterNotEnough)-- 圣水或奇石不足
            return 
        end
    elseif moneyType == 70 then --礼钻不足
		WZLog("判断礼钻",moneyCnt, CacheCenter:getMoneyList().ticket)
        if CacheCenter:getMoneyList().ticket < moneyCnt then
            local tCallBack2 = nil 
            if tCell2 and func2 then
                tCallBack2 = {}
                tCallBack2[1] = tCell2
                tCallBack2[2] = func2
            end
            local basicInfo = GDatatab_item["id_" .. moneyType]
            local nTempNum = moneyCnt - CacheCenter:getMoneyList().ticket 
            if CacheCenter:getMoneyList().ticket < 0 then 
            	nTempNum = moneyCnt
            end
            local function sureToUseDiamondInstead(nId, nResType)
                -- body
                WZLog("sureToUseDiamondInstead", nId, nResType)
                if nResType == MSGBOXRESTYPE_CONFIRM then 
                    if JudgeMoneyIsEnough(1, nTempNum, nil, nil, nWindowId, tCell, func) then
                        if tCallBack2 then
                            tCallBack2[2](tCallBack2[1])
                        end
                    end                 
                end
            end
            g_nConfirmCancelBoxId = MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.TICKET_NOT_ENOUGH, nTempNum), nil, sureToUseDiamondInstead, nil, nil, "TICKET_NOT_ENOUGH")
            if TeachGroup1 and TeachGroup1.GROUP == 12 then
				TeachGroup1:removeTeach()
				TeachGroup1:setTeachFinish(TeachGroup1.GROUP, -1)
			end
            return false 
        end
    elseif moneyType == 96 or moneyType == 283 or moneyType == 284 then --抽奖代币不足
    	local lotteryType = lottery
    	local nblueNum = blueNum
    	WZLog("判断抽奖代币",moneyCnt,CacheCenter:getPlayerItemCountById(moneyType),nblueNum)
        if CacheCenter:getPlayerItemCountById(moneyType) < moneyCnt then
        	local drawExchangeRate = json.decode(CacheCenter:getGameParam()["drawExchangeRate"])
            local tCallBack2 = nil 
            if tCell2 and func2 then
                tCallBack2 = {}
                tCallBack2[1] = tCell2
                tCallBack2[2] = func2
            end
            local basicInfo = GDatatab_item["id_" .. moneyType]
            local nTempNum = moneyCnt
            if CacheCenter:getPlayerItemCountById(moneyType) < 0 then 
            	nTempNum = moneyCnt
            end
            local function sureToUseDiamondInstead(nId, nResType)
                -- body
                WZLog("sureToUseDiamondInstead", nId, nResType)
                if nResType == MSGBOXRESTYPE_CONFIRM then 
                    if JudgeMoneyIsEnough(1, nTempNum, nil, nil, nWindowId, tCell, func) then
                        if tCallBack2 then
                            tCallBack2[2](tCallBack2[1])
                        end
                    end                 
                end
            end
            local function sureToUsePinkDiamondInstead(nId, nResType)
                -- body
                WZLog("sureToUsePinkDiamondInstead", nId, nResType)
                if nResType == MSGBOXRESTYPE_CONFIRM then 
                    if JudgeMoneyIsEnough(177, nTempNum, nil, nil, nWindowId, tCell, func) then
                        if tCallBack2 then
                            tCallBack2[2](tCallBack2[1])
                        end
                    end                 
                end
            end
            local strings1
            if lotteryType == 2 then
            	if moneyType == 283 then
	            	g_nConfirmCancelBoxId = MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.LOTTERY_NOT_ENOUGH1 ,nTempNum), nil, sureToUseDiamondInstead, nil, nil)
            	elseif moneyType == 96 then
            		nTempNum = (nTempNum - CacheCenter:getPlayerItemCountById(moneyType)) * drawExchangeRate
	            	g_nConfirmCancelBoxId = MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.LOTTERY_NOT_ENOUGH4 ,nTempNum), nil, sureToUsePinkDiamondInstead, nil, nil)
            	end
            elseif lotteryType == 1 then
            	-- if moneyType == 283 then 
            	-- 	strings1 = LocalStrings.LOTTERY_NOT_ENOUGH2
            	-- elseif moneyType == 96 then
            	-- 	strings1 = LocalStrings.LOTTERY_NOT_ENOUGH5
            	-- end
            	if moneyType == 283 then
	            	g_nConfirmCancelBoxId = MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.LOTTERY_NOT_ENOUGH1 ,nTempNum), nil, sureToUseDiamondInstead, nil, nil)
            	elseif moneyType == 96 then
            		nTempNum = (nTempNum - CacheCenter:getPlayerItemCountById(moneyType)) * drawExchangeRate
	            	g_nConfirmCancelBoxId = MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.LOTTERY_NOT_ENOUGH4 ,nTempNum), nil, sureToUsePinkDiamondInstead, nil, nil)
            	end
            elseif lotteryType == 3 then
            	-- if moneyType == 283 then 
            	-- 	strings1 = LocalStrings.LOTTERY_NOT_ENOUGH3
            	-- elseif moneyType == 96 then
            	-- 	strings1 = LocalStrings.LOTTERY_NOT_ENOUGH6
            	-- end
            	if moneyType == 283 then
	            	g_nConfirmCancelBoxId = MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.LOTTERY_NOT_ENOUGH1 ,nTempNum), nil, sureToUseDiamondInstead, nil, nil)
            	elseif moneyType == 96 then
            		nTempNum = (nTempNum - CacheCenter:getPlayerItemCountById(moneyType)) * drawExchangeRate
	            	g_nConfirmCancelBoxId = MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.LOTTERY_NOT_ENOUGH4 ,nTempNum), nil, sureToUsePinkDiamondInstead, nil, nil)
            	end
            end
            return false 
        end
	--处理坐骑兑换卡
	elseif (tData.main_type == 2 and tData.sub_type == 11) or tData.main_type == 35 then
        local pCnt = CacheCenter:getPlayerItemCountById(moneyType)
        local itemInfo = GDatatab_item["id_"..moneyType]
        WZLog("-----------------card info----------------",pCnt,moneyCnt)
        if pCnt < moneyCnt then
			WndFastGetItems:show(tData.id)
            return false
		end
	elseif moneyType == 86 then 
		local pCnt = CacheCenter:getPlayerItemCountById(moneyType)
        local itemInfo = GDatatab_item["id_"..moneyType]
        WZLog("-----------------card info----------------",pCnt,moneyCnt)
        if pCnt < moneyCnt then
			WndFastGetItems:show(tData.id)
            return false
		end
    elseif moneyType == 177 then
        local pCnt = moneyList.vnPinkDiamond
        if pCnt < moneyCnt then
            if nBoxType then
                MsgBoxManager:showConfirmCancelBox(LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE_VN, nil, diamondNotEnough2, nil, tCustomUIConfig)
            else
                MsgBoxManager:showConfirmBox(LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE_VN, nil,diamondNotEnough2, nil, tCustomUIConfig)
            end
            return false
        end
	else 
        local pCnt = CacheCenter:getPlayerItemCountById(moneyType)
		local showText = text or LocalStrings.PETNOGOODS
		local nType = nType or 1
        WZLog("-----------------判断材料是否不足----------------",pCnt,moneyCnt,nType)
        if tonumber(pCnt) < tonumber(moneyCnt) then
			-- if nType == 1 then
   --          	checkIsOnSale(moneyType, text)
			-- else
   --          	MsgBoxManager:showConfirmBox(showText, nil, nil, nil, nil, true)
			-- end
			WndFastGetItems:show(tData.id, tonumber(moneyCnt))
            return false
		end
    end
    return true
end

--@brief 砖石是否足够
function DiamondIsEnoughNum(num)
	num = num or 0
	local nDiamond = CacheCenter:getPlayerItemCountById(70)
    local nDiamond2 = CacheCenter:getMoneyList().blueDiamond
	if nDiamond >= num or nDiamond2 >= num or nDiamond + nDiamond2 > num then
		return true
	end
	return false
end

--@brief    购买矿晶界面
function GemCoinNotEnough()
    -- body
    local nMaxCount, tCurIndex = WndDigGem:getBuyData(13)
    local nLeftTimes = nMaxCount - WndDigGem.m_nBuyGemCoinTimes
    MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.DIGGEM_TEXT34, tCurIndex.cost[1][2], tCurIndex.result[1][2], nLeftTimes), WndDigGem, WndDigGem._sureToBuy)
end

--@brief	弹出成功失败结果图片
--@param	x,y弹出图片的相对位置([0,1])
function PopupResult(icon, x, y)
	WZLog("PopupResult")
	--如果还在进行战斗力动画，删除动画和消息队列
    if GlobalGame.g_tWndFightingList ~= nil and #GlobalGame.g_tWndFightingList ~= 0 then
        for i,v in pairs(GlobalGame.g_tWndFightingList) do
            if v and v.m_root and v.m_nType ~= "WndFighting" then
                WindowManager:removeWindow(v.m_root, v, true)
                GlobalGame.g_tWndFightingList[i] = nil
            end
        end
		MsgBoxManager:_removeMsgByType(MSGBOXTYPE_POPUPRESULT)
    end
	if icon == nil then return end
	local x = x or 0.5
	local y = y or 0.5
	
	local msg = {}
	msg.m_sIcon = icon
	MsgBoxManager:showPopupResult(msg, x, y)
end

--@brief	弹出成就
function popupAchie(id, title)
	if title == nil then return end
	local msg = {}
    msg.id = id
	msg.m_sTitle = title
    --这些界面延时弹成就
    if WndSingleCopySettlement.m_root or WndTowerSettlement.m_root or WndDailyCopySettlement.m_root or WndMultiWin.m_root or WndMultiLose.m_root or WndArenaWin.m_root or WndArenaLose.m_root or WndArenaWinNew.m_root or SceneBattleLoading.m_root or SceneBattle.m_root or WndRelicSettlement.m_root then
        if g_tAchieData == nil then g_tAchieData = {} end
        table.insert(g_tAchieData, msg)
    else
	   MsgBoxManager:showAchie(msg)
    end
end

function getDeviceInfo()
    local sysName = WZDeviceInfo:systemName()			--系统名称
    local sysVersion = WZDeviceInfo:systemVersion()	    -- 系统版本
    local name = WZDeviceInfo:name()			        -- 名称
    local appVersion = WZDeviceInfo:appVersion()	    -- 应用版本
    local mac = ""                                     -- mac 地址
    if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_IOS then
        local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("DandandaoUtils")
        if adapter then
            mac = adapter:callMethodByNameReturn("getIDFA","")
            WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
        end
    end
    if mac == "" then  mac = WGameCmUtil:GetUDID() end
    local info = {sysName = sysName, sysVersion = sysVersion, name = name, appVersion = appVersion ,mac = mac }
    info = json.encode(info)
    return info
end

--@brief	unicode编码转成utf-8字符串
function unicode_to_utf8(convertStr)
    if type(convertStr)~="string" then
        return convertStr
    end
    local resultStr=""
    local i=1
    while true do
        local num1=string.byte(convertStr,i)
        local unicode
        if num1~=nil and string.sub(convertStr,i,i+1)=="\\u" then
            unicode=tonumber("0x"..string.sub(convertStr,i+2,i+5))
            i=i+6
        elseif num1~=nil then
            unicode=num1
            i=i+1
        else
            break
        end  
        if unicode <= 0x007f then

            resultStr=resultStr..string.char(bit.band(unicode,0x7f))

        elseif unicode >= 0x0080 and unicode <= 0x07ff then
            
            resultStr=resultStr..string.char(bit.bor(0xc0,bit.band(bit.rshift(unicode,6),0x1f)))
            
            resultStr=resultStr..string.char(bit.bor(0x80,bit.band(unicode,0x3f)))

        elseif unicode >= 0x0800 and unicode <= 0xffff then

            resultStr=resultStr..string.char(bit.bor(0xe0,bit.band(bit.rshift(unicode,12),0x0f)))
            
            resultStr=resultStr..string.char(bit.bor(0x80,bit.band(bit.rshift(unicode,6),0x3f)))
            
            resultStr=resultStr..string.char(bit.bor(0x80,bit.band(unicode,0x3f)))

        end
    end
    resultStr=resultStr..'\0'    
    return resultStr
end

--敏感词汇检查
function CheckYellow(tstr)
	WZLog("CheckYellow(tstr)")
	tstr = fullToHalf(tstr)
	if tostring(ProjConfig:getChannelId()) == "9" then 
		return CheckYellow_9You(tstr)
	elseif ProjConfig.LANGUAGE == "vn" then 
		return CheckYellow_vn(tstr)
	else
		local bIsHasMask = false 
		local yellowstr = tstr

		local tempSS = string.gsub(yellowstr, "%s*", "")

		local bIsExistSpace, tmpStr = checkBlankSpace(tempSS)
		if bIsExistSpace then
			tempSS = tmpStr
		end

		for k,v in ipairs(ChatKeyWords) do
			local nStart, nEnd = string.find(string.lower(tempSS), string.lower(v))

			if nStart and nEnd and nEnd >= nStart then 
				local strYellowWord = string.sub(tempSS, nStart, nEnd)
				WZLog("CheckYellow  oo", strYellowWord, tempSS, v, nStart, nEnd)
				tempSS = string.gsub(tempSS,strYellowWord,"xxx")
				bIsHasMask = true 
		    end
		end
		if bIsHasMask == true then
			yellowstr = tempSS
		end

		if not bIsHasMask then 
			local exchangeStr1 = string.gsub(tstr, "%w*", "")
			local exchangeStr2 = string.gsub(exchangeStr1, "%p*", "")

			local tempStr = Filter_spec_chars(exchangeStr2)
			WZLog("CheckYellow 333", tempStr)
			local yellowstr1 = ReplaceMaskWord(tempStr)
			bIsHasMask = HasMaskWord(tempStr)
			WZLog("CheckYellow 555", yellowstr1, bIsHasMask)

			if bIsHasMask then 
				yellowstr = yellowstr1
			end
		else
			local exchangeStr1 = string.gsub(yellowstr, "%w*", "")
			local exchangeStr2 = string.gsub(exchangeStr1, "%p*", "")

			local tempStr = Filter_spec_chars(exchangeStr2)
			WZLog("CheckYellow 333", tempStr)
			local bIsHasMask2 = HasMaskWord(tempStr)
			local yellowstr1 = ReplaceMaskWord(tempStr)
			if bIsHasMask2 then 
				yellowstr = yellowstr1
			end
		end
	    return yellowstr, bIsHasMask
	end
end

function CheckYellow_vn(tstr)
	WZLog("CheckYellow_vn(tstr)")
	local bIsHasMask = false 
	local yellowstr = tstr

	local tempSS = yellowstr
	WZLog("CheckYellow_vn(tstr) One", tempSS)
	for k,v in ipairs(ChatKeyWords) do
		local nStart, nEnd = string.find(string.lower(tempSS), string.lower(v))

		if nStart and nEnd and nEnd >= nStart then 
			local strYellowWord = string.sub(tempSS, nStart, nEnd)
			WZLog("CheckYellow_vn  oo", strYellowWord, tempSS, v, nStart, nEnd)
			tempSS = string.gsub(tempSS,strYellowWord,"xxx")
			bIsHasMask = true 
	    end
	end
	if bIsHasMask == true then
		yellowstr = tempSS
	end

	if not bIsHasMask then 
		local exchangeStr1 = tstr--string.gsub(tstr, "%w*", "")
		local exchangeStr2 = string.gsub(exchangeStr1, "%p*", "")

		local tempStr = exchangeStr2--Filter_spec_chars(exchangeStr2)
		WZLog("CheckYellow_vn 333", tempStr)
		local yellowstr1 = ReplaceMaskWord(tempStr)
		bIsHasMask = HasMaskWord(tempStr)
		WZLog("CheckYellow_vn 555", yellowstr1, bIsHasMask)

		if bIsHasMask then 
			yellowstr = yellowstr1
		end
	end
	WZLog("CheckYellow_vn 666", yellowstr, bIsHasMask)
    return yellowstr, bIsHasMask
end

-- --敏感词汇检查
-- function CheckYellow(tstr)
-- 	WZLog("CheckYellow(tstr)")
-- 	if tostring(ProjConfig:getChannelId()) == "9" then 
-- 		return CheckYellow_9You(tstr)
-- 	else
-- 		local yellowstr = tstr
-- 		for k,v in ipairs(ChatKeyWords) do
-- 			yellowstr = string.gsub(yellowstr,v,"xxx")
-- 	        if yellowstr ~= tstr then
-- 	            return yellowstr
-- 	        end
-- 		end
-- 	    return yellowstr
-- 	end
-- end

--敏感词汇检查
function CheckYellow_9You(tstr)
	local yellowstr = tstr
	yellowstr = ReplaceMaskWord(tstr)
	local bIsHasMask = HasMaskWord(tstr)

	if not bIsHasMask then 
		local exchangeStr1 = string.gsub(tstr, "%w*", "")
		local exchangeStr2 = string.gsub(exchangeStr1, "%p*", "")

		local tempStr = Filter_spec_chars(exchangeStr2)
		WZLog("CheckYellow_9You 333", tempStr)
		local yellowstr1 = ReplaceMaskWord(tempStr)
		bIsHasMask = HasMaskWord(tempStr)
		WZLog("CheckYellow_9You 555", yellowstr1, bIsHasMask)

		if bIsHasMask then 
			yellowstr = yellowstr1
		end
	else
		local exchangeStr1 = string.gsub(yellowstr, "%w*", "")
		local exchangeStr2 = string.gsub(exchangeStr1, "%p*", "")

		local tempStr = Filter_spec_chars(exchangeStr2)
		WZLog("CheckYellow_9You 333", tempStr)
		local bIsHasMask2 = HasMaskWord(tempStr)
		local yellowstr1 = ReplaceMaskWord(tempStr)
		if bIsHasMask2 then 
			yellowstr = yellowstr1
		end
	end
    return yellowstr, bIsHasMask
end

--敏感词汇检查
-- function CheckYellow(tstr)
-- 	WZLog("CheckYellow(tstr)")
-- 	local yellowstr = tstr
-- 	yellowstr = ReplaceMaskWord(tstr)
-- 	local bIsHasMask = HasMaskWord(tstr)

-- 	if not bIsHasMask then 
-- 		local exchangeStr1 = string.gsub(tstr, "%w*", "")
-- 		local exchangeStr2 = string.gsub(exchangeStr1, "%p*", "")
-- 		WZLog("CheckYellow 222", exchangeStr2)
		
-- 		bIsHasMask = HasMaskWord(exchangeStr2)
-- 		yellowstr1 = ReplaceMaskWord(exchangeStr2)
-- 		if not bIsHasMask then 
-- 			local tempStr = Filter_spec_chars(exchangeStr2)
-- 			WZLog("CheckYellow 333", tempStr)
-- 			local yellowstr1 = ReplaceMaskWord(tempStr)
-- 			bIsHasMask = HasMaskWord(tempStr)
-- 		end
-- 		if bIsHasMask then 
-- 			yellowstr = yellowstr1
-- 		end
-- 	end
--     return yellowstr, bIsHasMask
-- end

--@brief    购买活力流程
function judgeNotEnoughJump(tCell, callFunc)
    -- body
    local nUsedTimes = CacheCenter:getActivityUsedTimes()
    local nLeftTimes = getBuyActivityMaxTimes(1, CacheCenter:getPlayerInfo().vipLevel) - nUsedTimes
    WZLog("******** judgeNotEnoughJump *******", nUsedTimes, nLeftTimes)
    local tCanUseIdList = {102, 390, 167, 385, 389, 450}
    local nSweetNum = 0 
    local eatItemId = nil 
    for i = 1, #tCanUseIdList do
    	nSweetNum = getBagItemCount(tCanUseIdList[i])
    	if nSweetNum > 0 then 
    		eatItemId = tCanUseIdList[i]
    		break 
    	end
    end
    --判断是否有甜甜圈
    if nSweetNum > 0 then
        g_nCurVigor = CacheCenter:getPlayerInfo().vigor
        local basicInfo = GDatatab_item["id_" .. eatItemId]
        MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.EAT_SOME_SWEETS, basicInfo.name), tCell, WndOpenChest.showUseInterface, nil, nil, nil, eatItemId)
    else
        --判断是否有剩余的购买次数
        if nLeftTimes > 0 then
            MsgBoxManager:showConfirmCancelBox(LocalStrings.ENERGY_NOT_SHORTAGE, tCell, callFunc, nil, nil)
        else
             MsgBoxManager:showTipBox(LocalStrings.USED_TODAY_ACTIVITY)
        end
    end
end

function getBuyActivityMaxTimes(nType, nVipLevel)
    -- body
    local nMaxCount = 0
    local tMaxIndex = nil

    for k, v in pairs(GDatatab_vip_restriction) do 
        if v.type == nType and v.vip_level <= nVipLevel then 
            if v.count > nMaxCount and (tMaxIndex == nil or tMaxIndex.vip_level <= v.vip_level) then
                nMaxCount = v.count 
                tMaxIndex = { id = v.id, ntype = v.type, parameter = v.parameter, vip_level = v.vip_level, count = v.count, cost = v.cost,result = v.result}
            end
        end
    end
    WZLog("********* getBuyActivityMaxTimes *********", nType, nVipLevel, nMaxCount)
    return nMaxCount      --最大限购次数
end

function setPlayerCurWeapon(imgWeapon,spineWeapon)
    local equip = CacheCenter:getEquipmentList()
    local weapon
    for k,v in pairs(equip) do
        if v.maintype == 4 and (v.subtype == 1 or v.subtype == 0) then
            weapon = v
            break
        end
    end

    -- 武器图片
    local equipInfo = GDatatab_item["id_"..weapon.id]
    imgWeapon:setFile(equipInfo.icon)

    -- 特效
    local function getAniName()
        local starLevel = weapon.extraInfo.starLevel
        local star = {12,10,8,5}
        for i = 1, #star do
            if starLevel >= star[i] then return star[i] end
        end
        return nil
    end

    local aniName = getAniName()
    WZLog("--------------my weapon info----------------",weapon.extraInfo.starLevel,aniName)
    if aniName then
        spineWeapon:play(tostring(aniName),true)
        spineWeapon:setVisible(true)
    else
        spineWeapon:setVisible(false)
    end
end

--@brief    将获取的需弹出穿上提示的装备添加到消息列表
function pushEquipInList()
    -- body
    WZLog("****** pushEquipInList ******",#g_tTempItemForLaterShow)
	--if WndLoveLottery.m_root ~= nil then
	--	g_tTempItemForLaterShow = {}
	--end
    if g_tTempItemForLaterShow and g_bIsShowWndDressUp == false then
--        WZLog("------------------g_tTempItemForLaterShow---------------",Serialize(g_tTempItemForLaterShow))
        local itemId
        local repeatId = false
        table.sort(g_tTempItemForLaterShow, sortFastEquipList)

        for i = 1, #g_tTempItemForLaterShow do
            if g_tTempItemForLaterShow[i].maintype == 4 then
                local tCurItem = g_tTempItemForLaterShow[i]
                for j = i +1,#g_tTempItemForLaterShow do
                    if (tCurItem.subtype == 0 or tCurItem.subtype == 1) and (g_tTempItemForLaterShow[j].subtype == 0 or g_tTempItemForLaterShow[j].subtype == 1) then
                        repeatId = true
                    else
                        if tCurItem.subtype ~= 0 and tCurItem.subtype ~= 1 and g_tTempItemForLaterShow[j].subtype == tCurItem.subtype then
                            repeatId = true
                        end
                    end
                end
            else
                itemId = g_tTempItemForLaterShow[i].id
                for j = i +1,#g_tTempItemForLaterShow do
                    if itemId == g_tTempItemForLaterShow[j].id then
                        repeatId = true
                    end
                end
            end
            if not repeatId then
                MsgBoxManager:showEquipDressUp(g_tTempItemForLaterShow[i])
            end
            repeatId = false
        end
        g_tTempItemForLaterShow = {}
        -- g_bIsShowWndDressUp = true
    end
end

--@brief    g_tTempItemForLaterShow的排序函数
function sortFastEquipList(a, b)
    -- body
    local fightingA = rtnFighting(a)
    local fightingB = rtnFighting(b)

    return fightingA < fightingB 
end

--
function rtnFighting(a)
    -- body
    if a.nRiseFighting == nil or a.nRiseFighting == -1 then
        return 0
    else
        return a.nRiseFighting
    end
end

--@brief    计算竞技，师德，恩爱总值
--@param    nType:排行榜类型
--@param    nLevel:等级
function CaculateAllValue(nType, nLevel)
    -- body
    local nTotalValue = 0 

    if nType == 12 then       --竞技
        for i = 1, nLevel - 1 do
            local tTempValue =  GDatatab_integral["id_" .. i]
            if tTempValue then
                nTotalValue = nTotalValue + tTempValue.upgrade_integral
            end
        end
    elseif nType == 22 then   --师德
        for i = 1, nLevel do
            local tTempValue =  GDatatab_morality["id_" .. i]
            if tTempValue then
                nTotalValue = nTotalValue + tTempValue.exp
            end
        end
    elseif nType == 23 then   --恩爱
        for i = 1, nLevel - 1 do
            local tTempValue =  GDatatab_marry_love["id_" .. i]
            if tTempValue then
                nTotalValue = nTotalValue + tTempValue.exp
            end
        end
    end

    return nTotalValue
end

--@brief  进入语音聊天
function EnterRecordRoom()
	-- if #GlobalGame.g_tRecordRoomList > 0 and g_bLoginTalkSDK then
	-- 	WZLog("ProtocolProcessorGlobal:parse_CHAT_GetRoomListOK")
	-- 	for i,v in ipairs(GlobalGame.g_tRecordRoomList) do
	-- 		if SDK_Talk:getAppKey() == GlobalGame.g_sServerAppkey then
	-- 			SDK_Talk:setRoomState("enter",tostring(v[1]),WndChat.callbackEnterOrExitChatRoom,WndChat)
	-- 		else
	-- 			WZLog("THIS kEY:",SDK_Talk:getAppKey(),GlobalGame.g_sServerAppkey)
	-- 		end
	-- 	end
	-- end
end

--@brief 登录语音SDK成功时的回调
function LoginTalkSDKCallback()
	g_bLoginTalkSDK = true
	EnterRecordRoom()
end

-- 获取排位赛总的分数值
-- lv 当前段位等级，score当前等级剩余经验
function pvpGetCurAllScore(lv,score)
	local maxLv = 0
	for k, v in pairs(GDatatab_rank_segment) do
		maxLv = maxLv + 1
	end
	lv = lv > maxLv and maxLv or lv

	local allScore = 0
	for i = 1, lv-1 do
		local s = GDatatab_rank_segment["id_"..i].score
		allScore = allScore + s
	end
	allScore = allScore + score
	return allScore
end

--根据等级获取竞技等级图标
function GetIntegralName(level)
    -- body
    WZLog("*********** GetIntegralName ***********", level)
    if level == 0 or level == nil then
        level = 1
    end

    local tCurTable = GDatatab_integral[string.format("id_%d", level)]
    if tCurTable == nil then
        local nTableNum = 0
        for k, v in pairs(GDatatab_integral) do
            nTableNum = nTableNum + 1
        end
        WZLog("*********** GetIntegralName 111***********", nTableNum)
        tCurTable = GDatatab_integral[string.format("id_%d", nTableNum)]
    end

    return tCurTable
end

--是否跨服
function ISCrossService(serverId)
	WZLog("ISCrossService = ",serverId)
	if serverId == nil then
		return
	end
	local curServerName,curServerId = IPDhttpServer:getCurServerName()
	WZLog("ISCrossService 2 = ",serverId,curServerId)
	if tonumber(curServerId) ~= tonumber(serverId)  then
		return true
	end
	return false
end

--@brief 获取攻击语音
function getSoundByAttackType(typeId, guaiId)
	local d_type = GetRoleSound()
	local idList = {}
	for i, v in pairs (GDatatab_music) do
--		WZLog("getSoundByAttackType one", type(v.guai), typeId, guaiId, "d_type", d_type, tostring(v.d_type), tostring(v.attack))
		if type(v.guai) == "string" and v.d_type == d_type and v.attack == typeId then
			local animationName = string.gsub(v.guai, " ", "")
            local animNameList = SplitStringWithSeparator(animationName, ",")
			for j, u in pairs (animNameList) do
--				WZLog("getSoundByAttackType two", u, guaiId)
				if guaiId == u then
					table.insert(idList, v.name)
					WZLog("getSoundByAttackType three")
				end
			end
		end
	end

	if #idList == 0 then
		return
	end

	local index = #idList > 1 and math.random(1,#idList) or 1
	local name = d_type .. "/" ..(idList[index] or idList[index-1] or "") .. ".mp3"
	WZLog("getSoundByAttackType four", d_type, typeId, #idList, name)
	return name
end

--@brief 获取语音
function getSoundByType(typeId)
    local d_type = GetRoleSound()
	local idList = {}
	for i, v in pairs (GDatatab_music) do
		if (v.d_type == d_type or v.d_type == nil) and v.type == typeId then
			table.insert(idList, v.name)
		end
	end
	if #idList == 0 then
		for i, v in pairs (GDatatab_music) do
		if (v.d_type == 1) and v.type == typeId then
			table.insert(idList, v.name)
		end
	end
	end
	local index = #idList > 1 and math.random(1,#idList) or 1
	WZLog("getSoundByType1", tostring(d_type), typeId, #idList, tostring((idList[index] or idList[index-1])))
	d_type = d_type == nil and 1 or d_type
	local name = d_type .. "/" ..(idList[index] or idList[index-1]) .. ".mp3"
	WZLog("getSoundByType2", d_type, typeId, #idList, name)
	return name
end

function popFastRechargeUI(rId, price)
	WZLog("popFastRechargeUI id = ",rId)
	if not rId then rId = 50 end
	local list = CacheCenter:getVipList()
	local curData
	for k, v in pairs(list) do
		if v.itemId == rId then
			if nil == price then
				curData = v
				break
			elseif tonumber(price) == tonumber(v.price) then
				curData = v
				break
			end 
		end
	end

	if not curData then return end

	local itemInfo = GDatatab_item["id_"..curData.itemId]
	local productName = itemInfo.name
	local productDesc = curData.name
	local quantifier = LocalStrings.SHOP_IND
	local number = curData.number
	if curData.itemId == 50 or curData.itemId == 51 or curData.itemId == 52 or curData.itemId == 55 or curData.itemId == 56 or curData.itemId == 259 then
		quantifier = LocalStrings.Expand
		number = 1
	end
	local sdkData = {
		id = curData.ids,
		price = curData.price,
		payCode = curData.payCodeId,
		productName = productName,
		productDesc = productDesc,
		quantifier = quantifier,
		number = number,
	}
	PassportSdkManager:getOrderNum(sdkData)
	WZLog("popFastRechargeUI DATA:", Serialize(sdkData))
end

--@brief 购买月卡专用
function popFastRechargeUI50(rId, price)
	WZLog("popFastRechargeUI50 id = ",rId)
	if not rId then rId = 50 end
	local list = CopyTable(CacheCenter:getVipList())
    table.sort( list, function ( a,b )
            return tonumber(a.price) > tonumber(b.price)
        end )
	--WZLog("popFastRechargeUI50", Serialize(CacheCenter:getVipList()))
	local isCanBuySubscription = checkIsCanBuyIOSAutoRenewalSubscription()
	WZLog("popFastRechargeUI50 isCanBuySubscription = ",isCanBuySubscription)
	local curData
	for k, v in pairs(list) do
		if v.itemId == rId then
			--WZLog("popFastRechargeUI50", Serialize(v))
			if nil == price then
				curData = v
				--WZLog("popFastRechargeUI50 can buy subscription11")
				if v.itemId == 50 then
					--WZLog("popFastRechargeUI50 can buy subscription12")
				    local tRechargeData = GDatatab_recharge["id_" .. curData.ids]
				    if isCanBuySubscription ~= 0 then
					    if tRechargeData.type == 105 then
					    	WZLog("popFastRechargeUI50 can buy subscription13")			        
					        break 
					    end
					else
						if tRechargeData.type ~= 105 then
					    	--WZLog("popFastRechargeUI50 can buy subscription14")			        
					        break 
					    end
					end
				else
					--WZLog("popFastRechargeUI50 can buy subscription15")
					break
				end
			elseif tonumber(price) == tonumber(v.price) then
				curData = v
				--WZLog("popFastRechargeUI50 can buy subscription21")
				if v.itemId == 50 and isCanBuySubscription ~= 0 then	
					--WZLog("popFastRechargeUI50 can buy subscription22")	 
				    local tRechargeData = GDatatab_recharge["id_" .. curData.ids]
				    if isCanBuySubscription ~= 0 then
					    if tRechargeData.type == 105 then
					    	WZLog("popFastRechargeUI50 can buy subscription23")			        
					        break 
					    end
					else
						if tRechargeData.type ~= 105 then
					    	--WZLog("popFastRechargeUI50 can buy subscription24")			        
					        break 
					    end
					end
				else
					--WZLog("popFastRechargeUI50 can buy subscription25")
					break
				end
			end 
		end
	end

	if not curData then return end

	local itemInfo = GDatatab_item["id_"..curData.itemId]
	local productName = itemInfo.name
	local productDesc = curData.name
	local quantifier = LocalStrings.SHOP_IND
	local number = curData.number
	if curData.itemId == 50 or curData.itemId == 51 or curData.itemId == 52 or curData.itemId == 55 or curData.itemId == 56 then
		quantifier = LocalStrings.Expand
		number = 1
	end
	local sdkData = {
		id = curData.ids,
		price = curData.price,
		payCode = curData.payCodeId,
		productName = productName,
		productDesc = productDesc,
		quantifier = quantifier,
		number = number,
	}
	PassportSdkManager:getOrderNum(sdkData)
	WZLog("popFastRechargeUI50 DATA:", Serialize(sdkData))
end

--@brief 判断是否开启苹果自动续订订阅
function checkIsOpenIOSAutoRenewalSubscription()
    WZLog("checkIsOpenIOSAutoRenewalSubscription")
    local channelid = tonumber(ProjConfig:getChannelId())
    if channelid == 1102 then
        return true
    end
    return false
end

--@brief 判断是否可以购买苹果自动续订订阅月卡，否则购买普通月卡
--@return -2:无法进行购买（开放订阅且获取不到订阅状态，或其他错误）
--@return -1:无法进行购买（已订阅且在有效期内）
--@return 0:可购买普通月卡（订阅失败或者未开放订阅功能）
--@return 1:可进行订阅(已订阅且订阅已失效不在有效期内;未订阅且开放了订阅功能)
function checkIsCanBuyIOSAutoRenewalSubscription()
    WZLog("checkIsCanBuyIOSAutoRenewalSubscription")
    if checkIsOpenIOSAutoRenewalSubscription() == false then
        return 0
    else        
    	-- subscrip : 是否订阅ios月卡（1为订阅，0为没订阅）
        -- effective : 订阅是否在有效期内(1为有效，0为没效)
        -- 是否是从充值列表或福利卡月卡界面点击了购买月卡（订阅错误协议返回时立即跳转到购买普通月卡，为防止错误协议是检查漏单时返回的，故添加个变量判断）

        if GlobalGame.g_nSubscrip ~= nil and GlobalGame.g_nSubscripEffective ~= nil then
            WZLog("checkIsCanBuyIOSAutoRenewalSubscription 获取订阅状态成功")
            if GlobalGame.g_nSubscrip == 0 then
            	if GlobalGame.g_bIsSubscriptionFailed == true then
            		return 0
            	end
            	return 1
            elseif GlobalGame.g_nSubscripEffective == 0 then
            	if GlobalGame.g_bIsSubscriptionFailed == true then
            		return 0
            	end
            	return 1
            elseif GlobalGame.g_nSubscripEffective == 1 then
            	return -1
            else 
            	return -2
            end
        else
        	--检查订阅状态
        	--ProtocolProcessorRecharge:send_PURCHASE_IOSSubscrip()
            return -2
        end
    end
end

function sortRewards(a, b)
    -- body
    local qualityA = checkRewardQuality(a)
    local qualityB = checkRewardQuality(b)
    if qualityA ~= qualityB then
        return qualityA > qualityB
    else
        return a[1] < b[1]
    end
end

--@brief    根据id获取物品的品质
function checkRewardQuality(a)
    -- body
    local key = "id_"..a[1]
    return GDatatab_item[key].quality
end

--@brief    消除列表新增或删除会使容器位置变化
--@param    element:容器节点
--@param    lastPositionY:变化前移动容器的Y坐标
--@param    lastHeight:变化前移动容器的高度
function resetMoveElementPositionY(element, lastPositionY, lastHeight)
    -- body
    --重新设置列表位置
    local tCurSize = element:getMoveElement():getContentSize()
    local nTempPositionY = lastPositionY - (tCurSize.height - lastHeight)/2
    if nTempPositionY > element:getMaxPosition().y then
        nTempPositionY = element:getMaxPosition().y
    end

    element:getMoveElement():setPositionY(nTempPositionY)
end

--@brief    计算时装战力
-- isBool 坐骑灵石tips 
function caculateClothesFighting(extraInfo, isBool)
    -- body
    isBool = isBool or nil
	for i=1,20 do
		if extraInfo[tostring(i)] == nil then 
			extraInfo[tostring(i)] = 0 
		end 
	end
	if isBool == true then
		for i,v in pairs(extraInfo) do
			extraInfo[tostring(i)] = v
		end
	end
    local nFighting = 0
    nFighting = (10*extraInfo["12"]+10*extraInfo["13"]+9.6*(extraInfo["10"]+extraInfo["11"]+extraInfo["9"])+1*(extraInfo["1"]+4.8*extraInfo["3"]+6*extraInfo["4"]+8*extraInfo["5"]+8*extraInfo["7"]+12*extraInfo["19"]+12*extraInfo["20"])+9.6*(extraInfo["18"]-70)*(extraInfo["18"]/(extraInfo["18"]+1)))*0.75
    nFighting = math.ceil(nFighting)
    return nFighting
end

--全局的把聊天窗口添加到当前场景
function AddChatToCurScene()
	WZLog("AddChatToCurScene")
	if WndChat then
		WndChat:addChatWindowToCurScene()
	end
end

--在指定的场景添加底部的聊天信息
function AddButtomChatToRoot(sceneName,rootObject)
	WZLog("AddButtonChatToRoot ",sceneName,rootObject)
	if WndCurrentChat then
		WndCurrentChat:addWndCurrentChatToCurScene(sceneName,rootObject)
	end
end

--@brief    根据称号名称，获取称号的特效
--@param    sTitle:当前称号
--@note     返回称号特效资源路径
function BeSpecifyTitle(sTitle)
    -- body
    if sTitle == nil or sTitle == "" then 
        return -1
    end

    for idx, value in pairs(GDatatab_achievement) do
        if value.name == sTitle then
            return value.icon
        end
    end
end

--@brief    创建称号特效动画
--@param    parentNode:特效添加到的父节点
--@param    nodeLabel:称号的label节点
--@param    sTitle:称号的内容
--@param    relativePoint:特效的相对坐标
--@param    bStrokeColor:称号是否需要描边
function CreateDesiSpine(parentNode, nodeLabel, sTitle, relativePoint, bStrokeColor, nScale)
    -- body
    local sTitleName = SplitStringWithSeparator(sTitle,"&")
    local sNewTitle, nLetterNum = string.gsub(sTitle, "&", ",")
    local titleLen = string.len(sTitleName[1])
    local actScale = nScale or 1
    relativePoint = relativePoint or GlobalMethod:ccp(0.5,0.5)
    if parentNode:getChildByTag(444) then
        parentNode:removeChildByTag(444, true)
    end
    if bStrokeColor then
    	if nodeLabel then
	        nodeLabel:setEnableStroke(bStrokeColor)
	    end
    end

    if sTitleName[2] ~= nil and sTitleName[2] ~= "" then
        if tonumber(sTitleName[2]) == nil or nLetterNum > 2 then
            local sTitleContent = string.gsub(sTitle, "&", "＆")
            if nodeLabel then
	            nodeLabel:setText(sTitleContent)
	        end
        else
            local bExist = WZFileUtil:isFileExist(string.format(g_sTitleSpineName, sTitleName[2]) .. ".json")
            if bExist then
                local spineDesi = WZUISpine:create()
                spineDesi:setScale(actScale)
                spineDesi:setLoop(true)
                spineDesi:setRelativePosition(relativePoint)
                spineDesi:setVisible(true)
                spineDesi:setTouchEnable(false)
                spineDesi:setFileJson(string.format(g_sTitleSpineName, sTitleName[2]) .. ".json")
                spineDesi:setFileAtlas(string.format(g_sTitleSpineName, sTitleName[2]) .. ".atlas")
                if titleLen <= 15 then
                    spineDesi:setAnimationName("size_1")
                else
                    spineDesi:setAnimationName("size_2")
                end
                parentNode:addChild(spineDesi, -1, 444)

                if sTitleName[1] ~= nil then
                	if nodeLabel then
	                    nodeLabel:setText(sTitleName[1])
	                end
                end
            else
            	-- local sIndex = string.format("%04d", tonumber(sTitleName[2]))	
	            -- local downloadInfo = GetDownloadInfo(sIndex, "titleFrame")
	            -- if downloadInfo == nil then return end 

	            -- DownloadManager:addDownloadTask(5000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,sIndex,"DownloadResourceCallback",_G)

                local sTitleContent = string.gsub(sTitle, "&", "＆")
                if nodeLabel then
	                nodeLabel:setText(sTitleContent)
	            end
            end
        end
    else
        local sTitleContent = string.gsub(sTitle, "&", "＆")
        if nodeLabel then
	        nodeLabel:setText(sTitleContent)
	    end
    end
    if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "hk" then
    	if nodeLabel then
	    	nodeLabel:setFontSize(16)
	    end
    elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" then
    	nodeLabel:setFontSize(14)
    	nodeLabel:setDimensions(GlobalMethod:CCSize(180))
    end
end

--@brief    获取月卡时间剩余天数
function GetMonthCardTime()
    --body
    local tPlayerItemsList = CacheCenter:getPlayerItems()
    if tPlayerItemsList == nil or tPlayerItemsList == {} then return end
    local nLastTime = 0
    for i = 1, #tPlayerItemsList do
        if tPlayerItemsList[i].id == 50 or tPlayerItemsList[i].id == 51 then
            nLastTime = nLastTime + tPlayerItemsList[i].lastTime
        end
    end

    WZLog("********* GetMonthCardTime *********", nLastTime)

    local nLastDays = nLastTime / (24 * 3600)

    return math.ceil(nLastDays)
end

--@brief    根据时间判断结婚折扣活动是否存在
--@note     返回true表示结婚打折活动存在
function JudgeMarryDiscountExist()
    --body
    local nCurServerTime = SystemTime:getServerTime()

    if g_tMarryDiscountTime == nil then
        return false
    end
    WZLog("JudgeMarryDiscountExist", g_tMarryDiscountTime.startTime, g_tMarryDiscountTime.endTime, nCurServerTime)
    if nCurServerTime >= g_tMarryDiscountTime.startTime and nCurServerTime <= g_tMarryDiscountTime.endTime then
        return true
    end

    return false
end


function judgeMapIdIsMarryCopy(mapId)
	for k,v in pairs(GDatatab_team_map) do
		local mId = v.id
		if mId == mapId then
			if v.map_num == 0 then
				return true
			else
				return false
			end
		end
	end

	return false
end 

function goGoogleUrl(elementTable)
	WZLog("goGoogleUrl")
	local data = WZDataFile:getInstance():getUserData()
	if data then
        local key = data:getStringValue("UrlData", "googleUrl")
        if key == nil or key == "" then 
		 	data:setStringValue("UrlData", "googleUrl", "true")
			data:flush()
			local packageName = WGameCmUtil:GetBundleIdentifier()
			WZLog("packageName:", packageName)
	    	if packageName == "com.wyd.gplay.bombheroes" or packageName == "com.wyd.brgp.bombheroes" or packageName == "com.wyd.gplay.bombheroesen"  or packageName == "com.wyd.gplay.heroibomba" then
	    		WZLog("packageName222")
	    		local msg = LocalStrings.APPLETIPS or "Hi dear Bomber,\nYour appreciation will help us more forward. Please rate us in Apple Store. Thanks you!"
				MsgBoxManager:showConfirmBox(msg, elementTable, doGoogleUrl)
	    	elseif packageName == "com.wyd.appstore.bombheroes" or  packageName == "com.edo.ios.Ihabombom" then
	    		WZLog("packageName333")
				local msg = LocalStrings.GOOGLETIPS or "Hi dear Bomber,\nYour appreciation will help us more forward. Please rate us in GooglePlay. Thanks you!"
				MsgBoxManager:showConfirmBox(msg, elementTable, doGoogleUrl)
			end
		end
	end
end

--把字符串转成富文本字符串
--fontColor : 字体颜色
--sc : 描边颜色
--ss : 描边大小
--se : 是否使用描边
--fontSize : 字体大小
function ToChangeFreeText(str,fontColor,sc,ss,se,fontSize,channel)
	WZLog("ToChangeFreeText =",str)
	if string.gsub(str," ","") == "" then
		return str
	end

	str = string.gsub(str,"<","&lt;")
	str = string.gsub(str,">","&gt;")

	if not fontColor then
		fontColor = "62,34,8"
	end

	if not sc then
		sc = "255,255,255"
	end

	if not ss then
		ss = "2"
	end

	if not se then
		se = "0"
	end

	if not fontSize then
		fontSize = 20
	end
	fontSize = tostring(fontSize)
	local char = str

	local tempTable = {}
	local startIndex = 1
	local len = string.len(str)
	if WndChat == nil then
		return str
	end
	for i,v in pairs(WndChat.FACEIMASK) do
		for j=1,len do
			local strIndex = string.find(char,v,j)
			if strIndex ~= nil then
				local bExit = false
				for n,m in ipairs(tempTable) do
					if m == strIndex then
						bExit = true
					end
				end
				if not bExit then
					table.insert(tempTable,strIndex)
				end
			end
		end
	end

	table.sort(tempTable,function (a,b)
		if a < b then
			return true
		end
		return false
	end)

	local freeText = ""
	local endIndex = nil
	if #tempTable > 0 then --有表情
		for i,v in ipairs(tempTable) do --循环拼接富文本
			if v ~= startIndex  then
				local str =  string.sub(char,startIndex,v-1)
				--local tempstr = "<T S=\"" .. fontSize .. "\" C=\"" .. fontColor .. "\" P=\"1\" SC=\"".. sc .."\" SS = \"" .. ss .. "\" SE = \"".. se .. "\" >" .. str .. "</T>"
				local tempstr = "<T S=\"%s\" C=\"%s\" P=\"1\" SC=\"%s\" SS =\"%s\" SE =\"%s\" >%s</T>"
				tempstr = string.format(tempstr,fontSize,fontColor,sc,ss,se,str)
				freeText = freeText .. tempstr
			end
			startIndex = v + 3
			local tempSt=  string.sub(char,v,v+2)

			for j,k in pairs(WndChat.FACEIMASK) do
				if tempSt == k then
					local temppp = FACE_ANIM[j]
					freeText = freeText .. temppp
				end
			end
		    endIndex = v
		end
		if endIndex ~= nil then
		    endIndex = endIndex + 3
		    if endIndex <= string.len(char) then
			    local str =  string.sub(char,endIndex)
				--local tempstr = "<T S=\"" .. fontSize .. "\" C=\"" .. fontColor .. "\" P=\"1\" SC=\"".. sc .."\" SS = \"" .. ss .. "\" SE = \"".. se .. "\" >" .. str .. "</T>"
				local tempstr = "<T S=\"%s\" C=\"%s\" P=\"1\" SC=\"%s\" SS =\"%s\" SE =\"%s\" >%s</T>"
                tempstr = string.format(tempstr,fontSize,fontColor,sc,ss,se,str)
				freeText = freeText .. tempstr
		    end
		end
	else --没有表情
	    -- if channel == CHANNEL_SYSTEM then
	    -- 	local strIndex,endIndex = string.find(char,"(*)")
		   --  if strIndex then --本服玩家送礼物给跨服玩家(系统发的公告信息)
		   --  	local tempS = string.sub(char,1,strIndex-2)
		   --  	local temppp = "<T S=\"%s\" C=\"%s\" P=\"1\" SC=\"%s\" SS =\"%s\" SE =\"%s\" >%s</T>"
		   --  	tempS = string.format(temppp,fontSize,fontColor,sc,ss,se,tempS)
		   --  	local tempSS = string.sub(char,strIndex+2)
		   --  	tempSS = string.format(temppp,fontSize,fontColor,sc,ss,se,tempSS)
		   --  	local tempSSS = "<I>ui/chat/chat_common_icon_kuafu.png</I>"
		   --  	freeText = freeText .. tempS .. tempSSS .. tempSS
		   --  	WZLog("result freeText = ",freeText)
		   --  	return freeText
		   --  end
	    -- end

	    --local tempstr = "<T S=\"" .. fontSize .. "\" C=\"" .. fontColor .. "\" P=\"1\" SC=\"".. sc .."\" SS = \"" .. ss .. "\" SE = \"".. se .. "\" >" .. char .. "</T>"
	    local tempstr = "<T S=\"%s\" C=\"%s\" P=\"1\" SC=\"%s\" SS =\"%s\" SE =\"%s\" >%s</T>"
        tempstr = string.format(tempstr,fontSize,fontColor,sc,ss,se,char)
        freeText = freeText .. tempstr
	end
	if freeText ~= "" then
		WZLog("result freeText = ",freeText)
		return freeText
	end

	return char	
end

--@brief	队列下载图片
--@brief 	新增下载文件任务
--@param	fileName文件名,tCell设置图片的Cell,size图片大小
function addDownloadFileList(fileName, tCell, size) 
	WZLog("WndSpaceMain:addDownloadFileList",fileName)
	if fileName == nil or fileName == "" then WZLog("文件名参数为nil") return end
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."1/"..fileName
	--如果文件存在，不下载，直接使用
	local bExist = WZFileUtil:isFileExist(path)
	if bExist then
		WZLog("文件存在",tCell)
		local fileError = false
		if tCell ~= nil then 
			tCell:setFile(path) 
			if size ~= nil then
				local imgSize = tCell:getContentSize()
				local x = size/imgSize.width 
				local y = size/imgSize.height
				WZLog("缩放比例",size,imgSize.width,imgSize.height,math.max(x,y))
				tCell:setScale(math.max(x,y))
				if imgSize.width < 10 or imgSize.width > 1000 then fileError = true end
				if imgSize.height < 10 or imgSize.height > 1000 then fileError = true end
			end
		end
	else
		--在下载列表中新增记录
		if tDownloadFileList == nil then tDownloadFileList = {} end
		--检测是否是重复任务
		for i=1,#tDownloadFileList do
			if fileName == tDownloadFileList[i].fileName then
				WZLog("重复下载",fileName)
				return
			end
		end
		local tempTable = {fileName=fileName,tCell=tCell,status="init",size=size}
		table.insert(tDownloadFileList,tempTable)
		WZLog("添加下载任务",Serialize(tDownloadFileList))
	end
	downloadFile()
end

--@brief	下载文件
function downloadFile()
	--WZLog("SceneLeagueMain:downloadFile")
	--列表中没有任务，返回
	if tDownloadFileList == nil or #tDownloadFileList == 0 then return end
	--有文件正在下载，返回
	for i=1,#tDownloadFileList do
		if tDownloadFileList[i].status=="downloading" then return end
	end
	--没有文件正在下载，开始下载第一个任务
	local fileName = tDownloadFileList[1].fileName
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."1/"..fileName
	local s = {}
	s.filePath = path
	s.objName = fileName

	local tCell = tDownloadFileList[1].tCell
	DSSdkManager:downFile(json.encode(s), tCell.downloadFileFinish, tCell)
	WZLog("调用sdk下载文件",fileName)
	tDownloadFileList[1].status="downloading"
end

--@brief 是否需要显示fyber广告按钮
function NeedFyber(id)
	local curSdkObj = PassportSdkManager:getCurSdkObj()
--	WZLog("NeedFyber:", curSdkObj.m_tConfig.SDKOtherConfig)
  	if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needFyber == "true" then
        --android上传玩家信息
      	local info = GDatatab_advertising_reward["id_"..id]
      	local count = nil
      	for k,v in pairs(CacheCenter.m_fyberInfo.tData) do
			if v.adId == id then
				count = v.rewardCount
				break
			end
		end
		WZLog("NeedFyber:", info.vip_level, CacheCenter:getPlayerInfo().vipLevel,info.create_days, CacheCenter.m_fyberInfo.createDays, info.reward_count,count)
    	if info.vip_level >= CacheCenter:getPlayerInfo().vipLevel and info.create_days < CacheCenter.m_fyberInfo.createDays then
      		return true
  		end
  	end
	return false
end

--@brief 获取fyber的cd时间
function GetFyberTime(id)
    local cdTime = 3600
    if GDatatab_advertising_reward then
	   cdTime = GDatatab_advertising_reward["id_"..id].interval
    else
        return cdTime
    end
	WZLog("GetFyberTime:",id,cdTime)
	local time = 0
	for k,v in pairs(CacheCenter.m_fyberInfo.tData) do
		if v.adId == id then
			time = v.lastTime
			break
		end
	end
	WZLog("GetFyberTime:", SystemTime:getServerTime(), time)
	local serverTime = SystemTime:getServerTime()
	return cdTime - (serverTime - time)
end

--@brief 获取按钮的奖励时间
function DoFyberReward(id)
	WndFyber:show(id)
end
--@brief	检查宠物是否能进化
function checkPetEvolution(tData)
	if tData.upgradeLevel == nil or tonumber(tData.upgradeLevel) < tonumber(CacheCenter:getGameParam().evoOrangePetNeedPetLevel) then
		return false
	end
	if tData.advancedLevel == nil or  tonumber(tData.advancedLevel) <  tonumber(CacheCenter:getGameParam().evoOrangePetNeedAdLevel) then
		return false
	end
	if tData.quality == nil or tData.quality ~= 3 then
		return false
	end
	return true
end

--@brief    如果出售的是武器或时装，检测是否已经永久拥有
function gCheckHaveOrNot(itemId)
    -- body
    local bIsHaved = false

    if itemId ~= nil then
        local tBasicInfo = GDatatab_item["id_" .. itemId]
        local nLastNum = CacheCenter:getPlayerItemCountById(itemId)
        if tBasicInfo then
            if tBasicInfo.main_type == 4 then
                if nLastNum > 0 then
                    bIsHaved = true
                end
            elseif tBasicInfo.main_type == 5 then
                if nLastNum == -1 then
                    bIsHaved = true
                end
            end
        end
    end

    return bIsHaved 
end

--@brief    创建关系图标
function CreateRelationIcon(nType, tData, parentNode)
    -- body
    local element, objNew = CellRelation:createElement()
    if element and objNew then
        objNew:setData(nType, tData, parentNode, CacheCenter:getPlayerInfo())
    end

    return element, objNew
end

--@brief    添加关系图标
function AddRelationIcon(rootNode, nMate, nBestFriend, nMentoring, tData, parentNode, relationPt, nScale, width)
    -- body
    --关系图标
    local nTempNum = 0 
    if nMentoring > 0 then
        nTempNum = nTempNum + 1
    end
    if nMate > 0 then
        nTempNum = nTempNum + 1
    end
    if nBestFriend > 0 then
        nTempNum = nTempNum + 1
    end

    if rootNode:getChildByTag(888) then
        rootNode:removeChildByTag(888, true)
    end

    local scaleValue = nScale or 1
    local nWidth = width or 50

    if nTempNum > 0 then
        WZLog("CellFriends:_showName", nTempNum)
        local conTemp = WZUIContainer:create()
        conTemp:setUseAbsSize(true)
        conTemp:setAbsContentSize(GlobalMethod:CCSize(nWidth,nWidth * scaleValue))
        local nIndex = 0
        local nIconX = 0
        --婚姻
        if nMate > 0 then    
            local element, objNew = CreateRelationIcon(1, tData, parentNode)
            nIconY = (1+2*nIndex)/(nTempNum * 2)
            element:setRelativePosition(GlobalMethod:ccp(0.5, nIconY))
            element:setScale(scaleValue)
            conTemp:addChild(element)

            nIndex = nIndex + 1
        end
        --蜜友
        if nBestFriend > 0 then
            local element, objNew = CreateRelationIcon(2, tData, parentNode)
            nIconY = (1+2*nIndex)/(nTempNum * 2)
            element:setRelativePosition(GlobalMethod:ccp(0.5, nIconY))
            element:setScale(scaleValue)
            conTemp:addChild(element)

            nIndex = nIndex + 1
        end
        --师徒
        if nMentoring == 1 then
            local element, objNew = CreateRelationIcon(3, tData, parentNode)
            nIconY = (1+2*nIndex)/(nTempNum * 2)
            element:setRelativePosition(GlobalMethod:ccp(0.5, nIconY))
            element:setScale(scaleValue)
            conTemp:addChild(element)
        elseif nMentoring == 2 then
            local element, objNew = CreateRelationIcon(4, tData, parentNode)
            nIconY = (1+2*nIndex)/(nTempNum * 2)
            element:setRelativePosition(GlobalMethod:ccp(0.5, nIconY))
            element:setScale(scaleValue)
            conTemp:addChild(element)
        end
        conTemp:setAnchorPoint(GlobalMethod:ccp(0,0.5))
        conTemp:setRelativePosition(relationPt)
        conTemp:setTag(888)
        rootNode:addChild(conTemp)
    end
end

function checkbuttonChannel(buttonChannel, btnId)
	local l = SplitStringWithSeparator(buttonChannel, ",")
--	WZLog("checkbuttonChannel", tostring(btnId), buttonChannel, ProjConfig.CHANNEL_ID)
	for i,v in ipairs(l) do
		v = tonumber(v)
		if v and (v == -1 or v == tonumber(ProjConfig.CHANNEL_ID)) then
			return true
		elseif v and v < -1 and math.abs(v) == tonumber(ProjConfig.CHANNEL_ID) then
			return false
		end
	end

	return false
end

--@brief    
function SplashSpineOffset()
    -- body
    local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
    local designSize = CCEGLView:sharedOpenGLView():getDesignResolutionSize()
    WZLog("caculate", screenSize.width, screenSize.height, designSize.width, designSize.height)

    local nScaleX = screenSize.width / designSize.width
    local nScaleY = screenSize.height / designSize.height

    if nScaleX > nScaleY then
        local cutYHeight = (nScaleX - nScaleY) * designSize.height / (2 *nScaleX)
        if cutYHeight > 20 then
            return (cutYHeight - 20) / designSize.height
        end
    end

    return 0
end

--@brief	在当前场景播放红包雨
--@param    redEnvelopeType:1->为红包雨；2->为口令红包
function ShowRedEnvelopesRain(redEnvelopeType)
    WZLog("WindowManager:showGlobalWeddingMes ")
    if WindowManager:isHaveTeachTouchLayer() == true or WndTeachTalk.m_root ~= nil then
    	return
    end
	if (ENVELOPES == nil or #ENVELOPES == 0) and (#g_tRedPackList == 0 or SceneCity.m_root == nil) and (WORSHIPGOD_ENVELOPES == nil or #WORSHIPGOD_ENVELOPES == 0) then return end
	if WndRedEnvelopesRain.m_root ~= nil then return end
	local redEnvelopeType = redEnvelopeType or 1
    local animationName1  =  "redEnvelope01"
    local animationName2  =  "redEnvelope02"
    local animationName3  =  "redEnvelope06"

    --如果口令红包和红包雨冲突的话红包雨优先
    if ENVELOPES ~= nil and #ENVELOPES > 0 then
        redEnvelopeType = 1
    elseif #g_tRedPackList > 0 then
        redEnvelopeType = 2
    elseif #WORSHIPGOD_ENVELOPES > 0 then 
        redEnvelopeType = 3
    end
    
    if redEnvelopeType == 1 then
        local element2 = WZUISystem:getInstance():createElement(animationName1)
        element2:setTouchEnable(true)
        WindowManager:getSceneRoot():addChild(element2,99999,2*6*8)
            
        DelayCallFunction(function ()
            local sceneRoot = WindowManager:getSceneRoot()
            local child2 = sceneRoot:getChildByTag(2*6*8)
            if child2 then
                sceneRoot:removeChildByTag(2*6*8,true)
            end
    WZLog("WindowManager:showGlobalWeddingMes1", Serialize(ENVELOPES))
			if (ENVELOPES == nil or #ENVELOPES == 0) then return end
			WndRedEnvelopesRain:show(1)
        end,nil,3.9)
    elseif redEnvelopeType == 2 then
        local element2 = WZUISystem:getInstance():createElement(animationName1)
        element2:setTouchEnable(true)
        WindowManager:getSceneRoot():addChild(element2,99999,2*6*8)
            
        DelayCallFunction(function ()
            local sceneRoot = WindowManager:getSceneRoot()
            local child2 = sceneRoot:getChildByTag(2*6*8)
            if child2 then
                sceneRoot:removeChildByTag(2*6*8,true)
            end
            WndRedEnvelopesRain:show(2)
        end,nil,5)
    elseif redEnvelopeType == 3 then --拜财神-红包雨
    	if WndChallengeLevel.m_root ~= nil then return end 
	    local element2 = WZUISystem:getInstance():createElement(animationName3)
	        element2:setTouchEnable(true)
	        WindowManager:getSceneRoot():addChild(element2,99999,2*6*8)
	            
	        DelayCallFunction(function ()
	            local sceneRoot = WindowManager:getSceneRoot()
	            local child2 = sceneRoot:getChildByTag(2*6*8)
	            if child2 then
	                sceneRoot:removeChildByTag(2*6*8,true)
	            end
	    		WZLog("WindowManager:showGlobalWeddingMes3", Serialize(WORSHIPGOD_ENVELOPES))
				if (WORSHIPGOD_ENVELOPES == nil or #WORSHIPGOD_ENVELOPES == 0) then return end
				WndRedEnvelopesRain:show(3)
	        end,nil,2)
    end
end

--@brief	在当前场景播放烟花
function ShowFirework(fireworkType)
    WZLog("ShowFirework")
    if WindowManager:isHaveTeachTouchLayer() == true or WndTeachTalk.m_root ~= nil then
		--删除粒子
        local sceneRoot = WindowManager:getSceneRoot()
		local cellFireworkContainer = GetElement(sceneRoot,"CellFireworkContainer",WZUIContainer)
		if cellFireworkContainer then
			cellFireworkContainer:removeFromParentAndCleanup(true)
		end
		
		FIREWORKS = {}
		FIREWORKTIME = 0
    	return
    end
	--if SETSHOWFIREWORK ~= 1 then return end
	--判断烟花是否播放完
	if FIREWORKTIME <= 0 then 
		--删除粒子
		if FIREWORKS ~= nil and #FIREWORKS > 0 then
			table.remove(FIREWORKS, 1)
		end
		if FIREWORKS ~= nil and #FIREWORKS > 0 then 
			local size = FIREWORKS[1] 
			if size == 1 then
				FIREWORKTIME = 40
				FIREWORKINTERVAL = 0.1
				ShowFirework(1)
				return
			elseif size == 2 then
				FIREWORKTIME = 80
				FIREWORKINTERVAL = 0.1
				ShowFirework(2)
				return
			elseif size == 3 then
				FIREWORKTIME = 80
				FIREWORKINTERVAL = 0.15
				ShowFirework(3)
				return
			end
		end
	end
	
	if FIREWORKTIME <= 0 then return end

	if FIREWORKTIME > 0 then
		FIREWORKTIME = FIREWORKTIME - 1
	end

	if FIREWORKS == nil or #FIREWORKS == 0 then return end

	--礼炮播放的随机位置
	local salutePs = {{0.230729,0.889865},{0.486205,0.619292},{0.736896,0.846371},{0.602471,0.71346},{0.753787,0.39232},
                  {0.207926,0.378596},{0.591752,0.110117},{0.451009,0.866956},{0.229314,0.637555},{0.483102,0.334784}}

	local fireworkType = fireworkType or 1
	local animationName = {"redEnvelope03","redEnvelope04","redEnvelope05"}
	
	--local totalNum = math.random(2+fireworkType*2,4+fireworkType*2)
	local totalNum = math.random(1+math.floor(fireworkType*0.4),3+math.floor(fireworkType*0.4))
    
    WZLog("WindowManager:showGlobalWeddingMes1", fireworkType)
    local fireworkContainer,luaObject = CellFireworkContainer:createElement()
    luaObject:setFireworkInfo(fireworkType)
    if fireworkContainer then
    	WindowManager:getSceneRoot():addChild(fireworkContainer,99999)
    	for i=1,totalNum do
		    local element2 = WZUISystem:getInstance():createElement(animationName[fireworkType])
			element2:setVisible(false)
		    element2:setTouchEnable(true)
			local index = math.random(1,2)
			local par = GetElement(element2,"particle"..index,WZUIParticle)
			par:setVisible(true)
			local indexPs = math.random(1,10)
		    local ps = salutePs[indexPs]
		    element2:setRelativePosition(GlobalMethod:ccp(ps[1],ps[2]))
		    fireworkContainer:addChild(element2)
			element2:setVisible(true)
	    end
    end
    DelayCallFunction(function ()
		ShowFirework(fireworkType)
    end,nil,FIREWORKINTERVAL)
end

--@brief	在当前场景播放烟花_7周年烟花
function ShowFirework_7zn(fireworkType)
    WZLog("ShowFirework_7zn", FIREWORKTIME)
    if WindowManager:isHaveTeachTouchLayer() == true or WndTeachTalk.m_root ~= nil then
		--删除粒子
        local sceneRoot = WindowManager:getSceneRoot()
		local cellFireworkContainer = GetElement(sceneRoot,"CellFireworkContainer",WZUIContainer)
		if cellFireworkContainer then
			cellFireworkContainer:removeFromParentAndCleanup(true)
		end
		
		FIREWORKS = {}
		FIREWORKTIME = 0
    	return
    end
	--if SETSHOWFIREWORK ~= 1 then return end
	--判断烟花是否播放完
	if FIREWORKTIME <= 0 then 
		--删除粒子
		if FIREWORKS ~= nil and #FIREWORKS > 0 then
			table.remove(FIREWORKS, 1)
		end
		if FIREWORKS ~= nil and #FIREWORKS > 0 then 
			local size = FIREWORKS[1] 
			if size == 1 then
				FIREWORKTIME = 4
				FIREWORKINTERVAL = 1
				ShowFirework_7zn(1)
				return
			elseif size == 2 then
				FIREWORKTIME = 10
				FIREWORKINTERVAL = 1
				ShowFirework_7zn(2)
				return
			elseif size == 3 then
				FIREWORKTIME = 12
				FIREWORKINTERVAL = 1
				ShowFirework_7zn(3)
				return
			end
		end
	end
	WindowManager:addBackgroundImg(99998, 150)
	if FIREWORKTIME <= 0 then 
	    DelayCallFunction(function ()
	  		WindowManager:removeBackgroundImg()
	    end,nil,1)
		return 
	end

	if FIREWORKTIME > 0 then
		FIREWORKTIME = FIREWORKTIME - 1
	end

	if FIREWORKS == nil or #FIREWORKS == 0 then return end

	--礼炮播放的随机位置
	local salutePs = {{0.230729,0.889865},{0.486205,0.619292},{0.736896,0.846371},{0.602471,0.71346},{0.753787,0.39232},
                  {0.207926,0.378596},{0.591752,0.110117},{0.451009,0.866956},{0.229314,0.637555},{0.483102,0.334784}}
    -- local spinePs = {{0.5,-0.5},{0.5,-0.4},{0.5,-0.1}}
    local spinePss = {{0.5,0},{0.5,0.1},{0.5,0.4}}
	local fireworkType = fireworkType or 1
	local animationName = {"redEnvelope03","redEnvelope04","redEnvelope05"}
	local strYanhuaPath = {"ui/yanhua/scene_yanhua_01", "ui/yanhua/scene_yanhua_02", "ui/yanhua/scene_9zhounian_yanhua03"} -- 显示周年庆烟花
	-- local strYanhuaPath = {"", "", ""} -- 显示普通烟花
	local tAnimName = {"wait", "wait", "wait"}
	--local totalNum = math.random(2+fireworkType*2,4+fireworkType*2)
	local totalNum = math.random(1+math.floor(fireworkType*0.4),3+math.floor(fireworkType*0.4))
    
    WZLog("WindowManager:showGlobalWeddingMes1", fireworkType)
    local fireworkContainer,luaObject = CellFireworkContainer:createElement()
    luaObject:setFireworkInfo(fireworkType)
    luaObject:setFlowerTime(3)
    if fireworkContainer then
    	WindowManager:getSceneRoot():addChild(fireworkContainer,99999)
    	for i=1,1 do
		    local element2 = WZUISystem:getInstance():createElement(animationName[fireworkType])
			element2:setVisible(false)
		    element2:setTouchEnable(true)
			local index = math.random(1,2)
			local par = GetElement(element2,"particle"..index,WZUIParticle)
			local spine = GetElement(element2,"spine1",WZUISpine)
			local isExist = CheckEffectFile(strYanhuaPath[fireworkType])
			if spine and isExist then
				spine:setFileJson(strYanhuaPath[fireworkType] .. ".json")
				spine:setFileAtlas(strYanhuaPath[fireworkType] .. ".atlas")
				spine:play(tAnimName[fireworkType], true)
				par = spine
			end
			par:setVisible(true)
			local indexPs = math.random(1,10)
		    local ps = salutePs[indexPs]
		    element2:setRelativePosition(GlobalMethod:ccp(ps[1],ps[2]))
		    fireworkContainer:addChild(element2)
			element2:setVisible(true)
	    end
    end
    DelayCallFunction(function ()
		ShowFirework_7zn(fireworkType)
    end,nil,FIREWORKINTERVAL)
end

--@brief 	解析"[12,456]"为{12,,456}
function SplitStringToTable(sSource)
	WZLog("SplitStringToTable ")
	local tValue = {}
	local nStart, nEnd = string.find(sSource, ",")
	local sFirst = string.sub(sSource, 2, nStart-1)
	local nSt, nEd = string.find(sSource, "]")
	local sSecond = string.sub(sSource, nEnd + 1, nSt - 1)

	tValue[1] = tonumber(sFirst)
	tValue[2] = tonumber(sSecond)

	return tValue
end

function ShowFlower(  )
	local fireworkContainer,luaObject = CellFireworkContainer:createElement()
	luaObject:setFlowerTime(3)
	if fireworkContainer then
    	WindowManager:getSceneRoot():addChild(fireworkContainer,123456)
	    local element = WZUISystem:getInstance():createElement("qiuhun03")
		element:setVisible(false)
	    element:setTouchEnable(true)
	    element:setRelativePosition(GlobalMethod:ccp(0.5,1))
	    fireworkContainer:addChild(element)
		element:setVisible(true)
    end
end

--@brief    根据等级获取相应的配位数据
function GetPvpDataByLevel(pvpLevel)
    -- body
    local tMaxData = GDatatab_trio_rank_match_config["id_999"]
    for i, value in pairs(GDatatab_trio_rank_match_config) do
        if pvpLevel <= tMaxData.level3 then
            if value.level3 == pvpLevel then
                return value
            end
        else
            local tTempData = CopyTable(tMaxData)
            tTempData.level = pvpLevel - tMaxData.level3 + 1
            return tTempData
        end
    end
end

--@brief    根据等级获取相应的配位数据
function GetZlsPvpDataByLevel(level)
	local tLevelInfo
	for k,v in pairs(GDatatab_zls_level) do
		if v.level == level then
			tLevelInfo = CopyTable(v)
			tLevelInfo.star = nil
			break
		end
	end
	if tLevelInfo == nil and level >= 0 then
		local zlsinfo = GDatatab_zls_level["id_999"]
		tLevelInfo = CopyTable(zlsinfo)
		tLevelInfo.level = level
		tLevelInfo.star = level - zlsinfo.level
	end
	return tLevelInfo
end

--@brief 添加微信按钮
--@param element:按钮的父节点
--@param id:配表的id
--@param bOnlyJudge：玩家信息界面，用于判断是否添加分享按钮
--@param bChangeStyle : 是否改变按钮样式
function addWeChatBtn(element,id,post,scale,bOnlyJudge, bChangeStyle)
	WZLog("addWeChatBtn", Serialize(SNSSdkManager.m_tSdkNameList))
	if SNSSdkManager.m_tSdkNameList == nil then
		return
	end
	local hasSdk = false
	for i = 1,#SNSSdkManager.m_tSdkNameList do
        sSdkName = SNSSdkManager.m_tSdkNameList[i]
        if sSdkName == nil then
            return
        end
        if sSdkName == "com/wyd/weChat/AsynSns" or sSdkName == "wyd_weChat_adapter" then
        	hasSdk = true
        	break
        end
    end
	if hasSdk and CheckButtonShow(109) and SNSSdkManager.getWeChatKey ~= nil and SNSSdkManager:getWeChatKey() then
		if bOnlyJudge then return true end 

		if element:getChildByTag(888) then
			element:removeChildByTag(888, true)
		end
		local cell, tcell = CellWeChat:createElement()
		tcell:setTag(id)
		cell:setTag(888)
		if bChangeStyle then 
			tcell:setNewBg()
		end
		if scale then
			cell:setScale(scale)
		end
  		element:addChild(cell,888)
  		local post = post or GlobalMethod:ccp(0.5,0.5)
  		cell:setRelativePosition(post)
	end

	return nil 
end

--@brief 判断是否能微信分享
--@param element:按钮的父节点
function CanWeChatShare()
	WZLog("CanWeChatShare")
	if SNSSdkManager.m_tSdkNameList == nil then
		return false
	end
	local hasSdk = false
	for i = 1,#SNSSdkManager.m_tSdkNameList do
        sSdkName = SNSSdkManager.m_tSdkNameList[i]
        if sSdkName == nil then
            return false
        end
        if sSdkName == "com/wyd/weChat/AsynSns" or sSdkName == "wyd_weChat_adapter" then
        	hasSdk = true
        	break
        end
    end
	if hasSdk and CheckButtonShow(109) and SNSSdkManager.getWeChatKey ~= nil and SNSSdkManager:getWeChatKey() then
		return true
	end
	return false
end

--@brief 执行微信分享
--@param element:按钮的父节点
function DoWeChatShare(tag)
	WZLog("DoWeChatShare")
	local con = WZUIContainer:create()
    con:setUseAbsSize(true)
    con:setAbsContentSize(GlobalMethod:CCSize(1136,720))   --Õâ¸öÈÝÆ÷µÄ´óÐ¡ÒªºÍcellµÄ´óÐ¡Ò»ÖÂ
    con:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	con:setRelativePositionLuaTo(0.5,0.5)
	con:setShowAll(true)
	con:setTag(99999)
    WindowManager:getSceneRoot():addChild(con,WindowManager.m_nZOrderOffset+1)
    local date = GDatatab_sociality_share["id_"..tag]
    if date.img ~= "screenshots" then
    	local imgBg = WZUIImage:create()
		imgBg:setFile(date.img)
		imgBg:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
		imgBg:setRelativePositionLuaTo(0.5,0.5)
		con:addChild(imgBg)
    end
    local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."shareImage.png"
	WZDeviceHelper:sharedDeviceHelper():saveScreen(path)
    if tonumber(date.QR_code) == 1 then
		local img = WZUIImage:create()
		local imgPath = "Download_share.png"
		local packName = WGameCmUtil:GetBundleIdentifier()
		local tab = GDatatab_share_binding or {}
	    for k ,v in pairs(tab) do
	        if v.app_name == packName then
	        	WZLog("imgPath:",v.img_QR_code)
	        	if tostring(v.img_QR_code ) ~= "1" then --英雄包的处理
	            	imgPath = v.img_QR_code
	            end
	            break
	        end
	    end
	    WZLog("imgPath:",imgPath)
	    if string.len(imgPath)>2 then
			img:setFile("ui/weChat/"..imgPath)
			img:setUseOriginSize(true)
			img:setAnchorPoint(GlobalMethod:ccp(1,0))
			img:setRelativePositionLuaTo(0.92,0.1)
			img:setScale(0.3)
			con:addChild(img)
		end
	end
	local mSharePath = CCFileUtils:sharedFileUtils():getTmpWritablePath().."shareImage2.png"
	WZDeviceHelper:sharedDeviceHelper():saveScreen(mSharePath)
	 local wndWeChat = WndWeChat:createElement()
    WindowManager:addWindow(wndWeChat, WndWeChat)
    WndWeChat:setInfo({tag = tag, imgPath = path, sharePath = mSharePath})
    if WindowManager:getSceneRoot():getChildByTag(99999) then
		WindowManager:getSceneRoot():removeChildByTag(99999, true)
	end
end

--@brief 添加微信按钮
--@param element:按钮的父节点
--@param id:配表的id
function ShareChat()
	local con = WZUIContainer:create()
    con:setUseAbsSize(true)
    con:setAbsContentSize(GlobalMethod:CCSize(1136,720))   --Õâ¸öÈÝÆ÷µÄ´óÐ¡ÒªºÍcellµÄ´óÐ¡Ò»ÖÂ
    con:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	con:setRelativePositionLuaTo(0.5,0.5)
	con:setShowAll(true)
	con:setTag(99999)
    WindowManager:getSceneRoot():addChild(con,WindowManager.m_nZOrderOffset+1)
    local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."shareImage.png"
	WZDeviceHelper:sharedDeviceHelper():saveScreen(path)
	 local wndWeChat = WndWeChat:createElement()
    WindowManager:addWindow(wndWeChat, WndWeChat)
    WndWeChat:setInfo({tag = -1, imgPath = path})
    if WindowManager:getSceneRoot():getChildByTag(99999) then
		WindowManager:getSceneRoot():removeChildByTag(99999, true)
	end
end

function GlobalMethod:SetWndChatInfo(luaObjectName,rootNode,chatChannel,roomType,roomId)
	WZLog("GlobalMethod:SetWndChatInfo")
	if chatChannel then
		ChangeChatChannel(Chat_Channel_Pvp_Amuse)
	end
	if luaObjectName and rootNode then
		WndCurrentChat:addWndCurrentChatToCurScene(luaObjectName,rootNode)
		
	end
    WndChat:addChatWindowToCurScene()
end

--@brief    播放需要延时的成就特效
function ShowDelayAchie()
    -- body
    if g_tAchieData == nil or #g_tAchieData == 0 then return end 

    WZLog("ShowDelayAchie", Serialize(g_tAchieData))
    for i = 1, #g_tAchieData do
        popupAchie(g_tAchieData[i].id, g_tAchieData[i].m_sTitle)
    end

    g_tAchieData = {}
end

--根据属性值获取战斗力
function GlobalMethod:getCombatEffect(attribute)
	WZLog("GlobalMethod:getCombatEffect", Serialize(attribute))
	local arr1 = attribute["12"]
	local arr2 = attribute["13"]
	local arr3 = attribute["10"]
	local arr4 = attribute["11"]
	local arr5 = attribute["9"]
	local arr6 = attribute["1"]
	local arr7 = attribute["3"]
	local arr8 = attribute["4"]
	local arr9 = attribute["5"]
	local arr10 = attribute["7"]
	local arr11 = attribute["19"]
	local arr12 = attribute["20"]

	if arr1 == nil then arr1 = 0 end
	if arr2 == nil then arr2 = 0 end
    if arr3 == nil then arr3 = 0 end
    if arr4 == nil then arr4 = 0 end
	if arr5 == nil then arr5 = 0 end
    if arr6 == nil then arr6 = 0 end
    if arr7 == nil then arr7 = 0 end
	if arr8 == nil then arr8 = 0 end
    if arr9 == nil then arr9 = 0 end
    if arr10 == nil then arr10 = 0 end
	if arr11 == nil then arr11 = 0 end
    if arr12 == nil then arr12 = 0 end
    local nFighting = 0 
    nFighting = (10*arr1+10*arr2+9.6*(arr3+arr4+arr5)+1*(arr6+4.8*arr7+6*arr8+8*arr9+8*arr10+12*arr11+12*arr12)+9.6*(0-70)*(0/(0+1)))*0.75
    WZLog("nFighting = ",nFighting)
    nFighting = math.ceil(nFighting)
    return nFighting
end

--把秒 转化成XX时XX分XX秒
function GlobalMethod:formatTime(time)
	WZLog("GlobalMethod:formatTime")
	local hour = math.floor(time/3600)
	local minute = math.fmod(math.floor(time/60),60)
	local second = math.fmod(time,60)
	local rtTime = string.format("%s:%s:%s",hour,minute,second)
    
    return rtTime
end

--@brief 功能解锁动画
--@param buttonId:按钮ID
function addTrailerAnim(info)
	WindowManager:removeTeachShelterLayer()
	local UIObj = GlobalGame.g_tWndBottomBarObj or SceneCity.m_tWndBottomBarObj
	WZLog("addTrailerAnim", tostring(UIObj), tostring(UIObj and UIObj.m_root))
	if UIObj == nil or UIObj.m_root == nil then
		return
	end

	WindowManager:addTeachShelterLayer( 999999, 0 )
	local call=CCCallFunc:create(function() 
				trailerAnimCall1(info)
			end)
	local move =  CCDelayTime:create(0.1)
	local array = CCArray:create()
	array:addObject(move)
	array:addObject(call)
    UIObj.m_root:runAction(CCSequence:create(array))
end

--@brief 功能解锁动画前清除部分界面
function trailerAnimCall1(info)
	local buttonId = info.buttonId
	local icon = info.icon
	trailerAnimRemoveWnd()
	local UIObj
	local btn
	local layer
	local layerLocal
	local anim
	local anim1
	local posx, posy
	local type
	
	local isBuilding = GDatatab_button_info["id_" .. buttonId].type == 0
	UIObj = GlobalGame.g_tWndBottomBarObj or SceneCity.m_tWndBottomBarObj

	if UIObj == nil then
		WindowManager:removeTeachShelterLayer()
		return
	end
	local isCity = UIObj == SceneCity.m_tWndBottomBarObj
	if isBuilding then
		UIObj = SceneCity

		if UIObj.m_root == nil then
			WindowManager:removeTeachShelterLayer()
			return
		end
		
		if icon ~= "" then
			GetElement(UIObj.m_root, "imgTrailer_SceneCity", WZUIImage):setFile(icon)
		end
		layer = GetElement(UIObj.m_root, "conBuilding_SceneCity", WZUIContainer)
		anim = GetElement(UIObj.m_root, "conTrailer_SceneCity", WZUIContainer)
		btn = GetElementWithoutAssert(UIObj.m_root, "building"..buttonId , WZUIImage)
		layerLocal = btn:getParent()
		anim:setVisible(true)
		anim1 = GetElement(UIObj.m_root,"animTrailer1_SceneCity",WZUISpine)
		local offsety = 50
		local offsetx = 50
		if buttonId == 3 then
			offsety = 80
		elseif buttonId == 4 then
			offsety = 50
			offsetx = 100
		end
		posx, posy = btn:getPositionX() + offsetx, btn:getPositionY()-70 + offsety
		type = 1
	elseif isCity then
		if UIObj.m_nMoveDirection ~= 0 then
			if icon ~= "" then
				GetElement(UIObj.m_root, "imgTrailer_WndBottomBar", WZUIImage):setFile(icon)
			end
			layer = GetElement(UIObj.m_root, "conAll_WndBottomBar", WZUIContainer)
			anim = GetElement(UIObj.m_root, "conTrailer_WndBottomBar", WZUIContainer)
			btn = GetElement(UIObj.m_root, "btnSwitch_WndBottomBar", WZUIButton)
			layerLocal = btn:getParent()
			anim:setVisible(true)
			anim1 = GetElement(UIObj.m_root,"animTrailer1_WndBottomBar",WZUISpine)
			posx, posy = btn:getPositionX(), btn:getPositionY()
			type = 2
		else
			if icon ~= "" then
				GetElement(UIObj.m_root, "imgTrailer_WndBottomBar", WZUIImage):setFile(icon)
			end
			WZLog("trailerAnimCall1trailerAnimCall1", buttonId)
			btn = GetElement(UIObj.m_root, "btn" .. WndBottomBarBtnIndex[buttonId] .. "_WndBottomBar", WZUIButton)
			layer = GetElement(UIObj.m_root, "conAll_WndBottomBar", WZUIContainer)
			anim = GetElement(UIObj.m_root, "conTrailer_WndBottomBar", WZUIContainer)
			layerLocal = btn:getParent()
			anim:setVisible(true)
			anim1 = GetElement(UIObj.m_root,"animTrailer1_WndBottomBar",WZUISpine)
			posx, posy = btn:getPositionX(), btn:getPositionY() + 30
			type = 3

			if buttonId == ISLAND_BUILDING_RANK or buttonId == ISLAND_EXTEND_CHARM then
				type = 2
			end
		end
	else
		if UIObj.m_nMoveDirection ~= 0 then
			if icon ~= "" then
				GetElement(UIObj.m_root, "imgTrailer_WndBottomBar", WZUIImage):setFile(icon)
			end
			layer = GetElement(UIObj.m_root, "conAll_WndBottomBar", WZUIContainer)
			anim = GetElement(UIObj.m_root, "conTrailer_WndBottomBar", WZUIContainer)
			btn = GetElement(UIObj.m_root, "conSwitch_WndBottomBar", WZUIContainer)
			layerLocal = btn:getParent()
			anim:setVisible(true)
			anim1 = GetElement(UIObj.m_root,"animTrailer1_WndBottomBar",WZUISpine)
			posx, posy = btn:getPositionX()-31, btn:getPositionY()-30
			type = 4
		else
			if icon ~= "" then
				GetElement(UIObj.m_root, "imgTrailer_WndBottomBar", WZUIImage):setFile(icon)
			end
			layer = GetElement(UIObj.m_root, "conAll_WndBottomBar", WZUIContainer)
			anim = GetElement(UIObj.m_root, "conTrailer_WndBottomBar", WZUIContainer)
			btn = GetElement(UIObj.m_root, "btn" .. WndBottomBarBtnIndex[buttonId] .. "_WndBottomBar", WZUIButton)
			layerLocal = btn:getParent()
			anim:setVisible(true)
			anim1 = GetElement(UIObj.m_root,"animTrailer1_WndBottomBar",WZUISpine)
			posx, posy = btn:getPositionX(), btn:getPositionY()
			type = 5

			if buttonId == ISLAND_RIGHT_PET then
				type = 4
			end
		end
	end

	GlobalGame.m_tAnimTrailer = anim1
	anim1:play("icon_chongwu_1",false)

	local posAnimx, posAnimy = anim:getPosition()
	local pos = GlobalMethod:ccp(posx, posy)

	local pos1 = layerLocal:convertToWorldSpace(pos)
	local pos2 = layer:convertToNodeSpace(pos1)
	local posUi = CCDirector:sharedDirector():convertToUI(GlobalMethod:ccp(posx, posy))
	WZLog("trailerAnimCall1", buttonId, icon, tostring(isCity), tostring(isReplace), tostring(isBuilding), tostring(UIObj), tostring(btn))
	WZLog("trailerAnimCall1", posx, posy, pos1.x, pos1.y, pos2.x, pos2.y, posUi.x, posUi.y)

	local delay0 =  CCDelayTime:create(0.5)
	local call2=CCCallFunc:create(function() 
				trailerAnimCall2(anim, type)
			end)
	local call3=CCCallFunc:create(function() 
				trailerAnimCall3(anim)
			end)
	local move =  CCMoveTo:create(0.5, pos2)
	local delay =  CCDelayTime:create(0.5)
	local array = CCArray:create()
	array:addObject(delay0)
	array:addObject(move)
	array:addObject(call2)
	array:addObject(delay)
	array:addObject(call3)
    anim:runAction(CCSequence:create(array))
end

--@brief 功能解锁动画,显示新功能文字
function trailerAnimCall2(anim, type)
	WZLog("trailerAnimCall2", tostring(anim), type)
	local dir
	local offset
	if type == 1 then
		offset = GlobalMethod:ccp(-45,110)
		dir = 2
	elseif type == 2 then
		offset = GlobalMethod:ccp(-80,-110)
		dir = 1
	elseif type == 3 then
		offset = GlobalMethod:ccp(-40,-110)
		dir = 1
	elseif type == 4 then
		offset = GlobalMethod:ccp(-80,110)
		dir = 2
	elseif type == 5 then
		offset = GlobalMethod:ccp(-80,110)
		dir = 2
	end
	GlobalGame.m_tButtonTipsDialog1 = Teach:showDialog( anim , anim , TeachGroup1:getTeachText(180) , dir , offset, 1, 2.2,nil , true )            
end

--@brief 功能解锁动画,清除元素
function trailerAnimCall3(param)
	WZLog("trailerAnimCall3", tostring(param))
	WindowManager:removeTeachShelterLayer()
	GlobalGame.m_nTrailerId = nil
	WndUpgrade:teach(true)
	GlobalGame.m_tButtonTipsDialog1:removeFromParentAndCleanup(true)
	GlobalGame.m_tButtonTipsDialog1 = nil
	GlobalGame.m_tAnimTrailer = nil
	--param:removeFromParentAndCleanup(true)
	param:setVisible(false)
	param:setRelativePositionLuaTo(0.5,0.5)

end

--@brief 功能解锁动画前清除部分界面
function trailerAnimRemoveWnd()
	if WndCheckOther.m_root then
        WindowManager:removeWindow(WndCheckOther.m_root, WndCheckOther, true)
    end

	if WndSweepResult.m_root then
        WindowManager:removeWindow(WndSweepResult.m_root, WndSweepResult, true)
    end

    if WndAthReward.m_root then
        WindowManager:removeWindow(WndAthReward.m_root, WndAthReward, true)
    end

    if WndAthRank.m_root then
        WindowManager:removeWindow(WndAthRank.m_root, WndAthRank, true)
    end

    if WndSingleCopyInfo.m_root then
        WindowManager:removeWindow(WndSingleCopyInfo.m_root, WndSingleCopyInfo, true)
    end

    if WndSummonEntrance.m_root then
        WindowManager:removeWindow(WndSummonEntrance.m_root, WndSummonEntrance, true)
    end

    if WndTask.m_root then
        WndTask.m_bIsTeach = true
        WindowManager:removeWindow(WndTask.m_root , WndTask , true)
    end

    if WndRewardShow.m_root then
        WndRewardShow.m_bIsTeach = true
        WindowManager:removeWindow(WndRewardShow.m_root , WndRewardShow , true)
    end

    if WndTrainingCamp.m_root then
        WindowManager:removeWindow(WndTrainingCamp.m_root, WndTrainingCamp, true)
    end
end
--@brief 同步语音聊天室玩家状态
function synchronousVoicePlayerState(playerId, voiceState)
	WZLog("synchronousVoicePlayerState", playerId, voiceState[1], voiceState[2])
	if voiceState[1] == 1 then
		synchronousVoicePlayerId(playerId, voiceState[2])
	elseif voiceState[1] == 2 or voiceState[1] == 3 then
		synchronousVoicePlayerImg(playerId, voiceState[1], voiceState[2])
	end

end

--@brief 同步语音聊天室玩家图标
function synchronousVoicePlayerImg(playerId, openType, openState)
	WZLog("synchronousVoicePlayerImg zero", playerId, openType, openState)

	if WndBattleHud.m_root then
		local hero = WBattleGlobal:getCurrent():getHeroWithId(playerId)
		if hero then
			local ctb = hero.m_tCtb
			if ctb then
				if openType == 2 then
					ctb.m_nVoiceState = openState
					if openState == 0 then
						ctb.m_nMicState = openState
					end
				elseif openType == 3 then
					ctb.m_nMicState = openState
					if openState == 1 then
						ctb.m_nVoiceState = openState
					end
				end
				local anim = GetElement(ctb.m_root,"animFigureVoice_CellBattleCtb",WZUISpine)
				local img = GetElement(ctb.m_root,"imgFigureVoice_CellBattleCtb",WZUIImage)
				local file
				local isGray
				if ctb.m_nVoiceState == 0 then
					WZLog("synchronousVoicePlayerImg one-1")
					file = "ui/common/common_icon_yuying_02.png"
					isGray = true
					anim:setVisible(false)
				elseif ctb.m_nMicState == 1 then
					WZLog("synchronousVoicePlayerImg one-2")
					file = "ui/common/common_icon_yuying02.png"
					isGray = false
				elseif ctb.m_nVoiceState == 1 then
					WZLog("synchronousVoicePlayerImg one-3")
					file = "ui/common/common_icon_yuying_02.png"
					isGray = false
					anim:setVisible(false)
				end
				img:setFile(file)
				img:setGrayRender(isGray)
				img:setVisible(true)
			end

		end
	end

	if SceneRoom.m_root then
		local index
		for i,v in pairs(SceneRoom.m_tData.playerId) do
			if playerId == v then
				index = i
				break
			end
		end

		if openType == 2 then
			SceneRoom.m_tVoiceState[index] = openState
			if openState == 0 then
				SceneRoom.m_tMicState[index] = openState
			end
		elseif openType == 3 then
			SceneRoom.m_tMicState[index] = openState
			if openState == 1 then
				SceneRoom.m_tVoiceState[index] = openState
			end
		end

		WZLog("synchronousVoicePlayerImg two-0", index, SceneRoom.m_tVoiceState[index], SceneRoom.m_tMicState[index])

		local conCenter = GetElement(SceneRoom.m_root,"conCenter_SceneRoom",WZUIContainer)
		local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneRoom",WZUIContainer)
		local conFigureVoice = GetElement(conSeat,"conFigureVoice_SceneRoom",WZUIContainer)

		local anim = GetElement(conFigureVoice,"animFigureVoice_SceneRoom",WZUISpine)
		local img = GetElement(conFigureVoice,"imgFigureVoice_SceneRoom",WZUIImage)
        local file
		local isGray
		if SceneRoom.m_tVoiceState[index] == 0 then
			WZLog("synchronousVoicePlayerImg two-1")
			file = "ui/common/common_icon_yuying_02.png"
			isGray = true
			anim:setVisible(false)
		elseif SceneRoom.m_tMicState[index] == 1 then
			WZLog("synchronousVoicePlayerImg two-2")
			file = "ui/common/common_icon_yuying02.png"
			isGray = false
		elseif SceneRoom.m_tVoiceState[index] == 1 then
			WZLog("synchronousVoicePlayerImg three-3")
			file = "ui/common/common_icon_yuying_02.png"
			isGray = false
			anim:setVisible(false)
		end
		img:setFile(file)
		img:setGrayRender(isGray)
		img:setVisible(true)
	end

	if WndLeagueTeamDetail.m_root then
		local obj = WndLeagueTeamDetail
		local index
		for i,v in pairs(obj.m_tData.readyPlayerId) do
			if playerId == v then
				index = i
				break
			end
		end

		if openType == 2 then
			obj.m_tVoiceState[index] = openState
			if openState == 0 then
				obj.m_tMicState[index] = openState
			end
		elseif openType == 3 then
			obj.m_tMicState[index] = openState
			if openState == 1 then
				obj.m_tVoiceState[index] = openState
			end
		end

		WZLog("synchronousVoicePlayerImg two-0", index, obj.m_tVoiceState[index], obj.m_tMicState[index])

		local anim = GetElement(obj.m_root,"animFigureVoice" .. index .. "_WndLeagueTeamDetail",WZUISpine)
		local img = GetElement(obj.m_root,"imgFigureVoice" .. index .. "_WndLeagueTeamDetail",WZUIImage)
        local file
		local isGray
		if obj.m_tVoiceState[index] == 0 then
			WZLog("synchronousVoicePlayerImg two-1")
			file = "ui/common/common_icon_yuying_02.png"
			isGray = true
			anim:setVisible(false)
		elseif obj.m_tMicState[index] == 1 then
			WZLog("synchronousVoicePlayerImg two-2")
			file = "ui/common/common_icon_yuying02.png"
			isGray = false
		elseif obj.m_tVoiceState[index] == 1 then
			WZLog("synchronousVoicePlayerImg three-3")
			file = "ui/common/common_icon_yuying_02.png"
			isGray = false
			anim:setVisible(false)
		end
		img:setFile(file)
		img:setGrayRender(isGray)
		img:setVisible(true)
	end

	if SceneGuildWarRoom.m_root then
		local obj = SceneGuildWarRoom
		local index
		for i,v in pairs(obj.m_tData.playerId) do
			if playerId == v then
				index = i
				break
			end
		end

		if openType == 2 then
			obj.m_tVoiceState[index] = openState
			if openState == 0 then
				obj.m_tMicState[index] = openState
			end
		elseif openType == 3 then
			obj.m_tMicState[index] = openState
			if openState == 1 then
				obj.m_tVoiceState[index] = openState
			end
		end

		WZLog("synchronousVoicePlayerImg two-0", index, obj.m_tVoiceState[index], obj.m_tMicState[index])
		local conCenter = GetElement(obj.m_root,"conCenter_SceneGuildWarRoom",WZUIContainer)
		local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneGuildWarRoom",WZUIContainer)
		local conFigureVoice = GetElement(conSeat,"conFigureVoice_SceneGuildWarRoom",WZUIContainer)

		local anim = GetElement(conFigureVoice,"animFigureVoice_SceneGuildWarRoom",WZUISpine)
		local img = GetElement(conFigureVoice,"imgFigureVoice_SceneGuildWarRoom",WZUIImage)
        local file = nil
		local isGray = nil
		if obj.m_tVoiceState[index] == 0 then
			WZLog("synchronousVoicePlayerImg two-1")
			file = "ui/common/common_icon_yuying_02.png"
			isGray = true
			anim:setVisible(false)
		elseif obj.m_tMicState[index] == 1 then
			WZLog("synchronousVoicePlayerImg two-2")
			file = "ui/common/common_icon_yuying02.png"
			isGray = false
		elseif obj.m_tVoiceState[index] == 1 then
			WZLog("synchronousVoicePlayerImg three-3")
			file = "ui/common/common_icon_yuying_02.png"
			isGray = false
			anim:setVisible(false)
		end
		img:setFile(file)
		img:setGrayRender(isGray)
		img:setVisible(true)
	end
end

--@brief 同步语音聊天室玩家id
function synchronousVoicePlayerId(playerId, voiceId)
	WZLog("synchronousVoicePlayerId one", playerId, voiceId, tostring(WndBattleHud.m_root))
	if WndBattleHud.m_root then
		local hero = WBattleGlobal:getCurrent():getHeroWithId(playerId)
		if hero then
			local ctb = hero.m_tCtb
			local ctb1 = hero.m_tBigCtb
			if ctb then
				ctb.m_nVoiceId = voiceId
			end
			if ctb1 then
				ctb1.m_nVoiceId = voiceId
			end
		end

		for i,v in pairs(WndBattleHud.m_tForbidMembers) do
			if v.playerId == playerId then
				if v.isVoice == false then
					WGCloudVoiceNotify:ForbidMemberVoice(voiceId,false)
					WZLog("synchronousVoicePlayerId two")
				end
				table.remove(WndBattleHud.m_tForbidMembers, i)
				break
			end
		end
	end

	if SceneRoom.m_root then
		for i,v in pairs(SceneRoom.m_tData.playerId) do
			if playerId == v then
				SceneRoom.m_tVoiceId[i] = voiceId
				SceneRoom.m_tVoiceState[i] = 1
				SceneRoom.m_tMicState[i] = 1

				if CacheCenter:getPlayerInfo().id ~= playerId then
					local conCenter = GetElement(SceneRoom.m_root,"conCenter_SceneRoom",WZUIContainer)
					local conSeat = GetElement(conCenter,"conSeat" .. i .. "_SceneRoom",WZUIContainer)
					GetElement(conSeat,"conFigureVoice_SceneRoom",WZUIContainer):setVisible(true)
				end
			end
		end
	end

	if WndLeagueTeamDetail.m_root then
		local obj = WndLeagueTeamDetail
		for i,v in pairs(obj.m_tData.readyPlayerId) do
			if playerId == v then
				obj.m_tVoiceId[i] = voiceId
				obj.m_tVoiceState[i] = 1
				obj.m_tMicState[i] = 1

				if CacheCenter:getPlayerInfo().id ~= playerId then
					GetElement(obj.m_root,"conFigureVoice" .. i .. "_WndLeagueTeamDetail",WZUIContainer):setVisible(true)
				end
			end
		end
	end

	if SceneGuildWarRoom.m_root then
		local obj = SceneGuildWarRoom
		for i,v in pairs(obj.m_tData.playerId) do
			if playerId == v then
				obj.m_tVoiceId[i] = voiceId
				obj.m_tVoiceState[i] = 1
				obj.m_tMicState[i] = 1

				if CacheCenter:getPlayerInfo().id ~= playerId then
					local conCenter = GetElement(SceneGuildWarRoom.m_root,"conCenter_SceneGuildWarRoom",WZUIContainer)
					local conSeat = GetElement(conCenter,"conSeat" .. i .. "_SceneGuildWarRoom",WZUIContainer)
					GetElement(conSeat,"conFigureVoice_SceneGuildWarRoom",WZUIContainer):setVisible(true)
				end
			end
		end
	end
end

--@brief 加入语音聊天室回调
--1:语音Id;2:语音状态,1打开听筒/2关闭听筒/3打开麦
function joinVoiceRoom(id)
	WZLog("joinVoiceRoom", id)
	local obj
	if WndBattleHud.m_root then
		obj = WndBattleHud
	elseif SceneRoom.m_root then
		obj = SceneRoom
	elseif WndLeagueTeamDetail.m_root then
		obj = WndLeagueTeamDetail
	elseif SceneGuildWarRoom.m_root then
		obj = SceneGuildWarRoom
	end

	GlobalGame.m_nVoiceId = id
	ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "1," .. id, 0 )

	if obj then
		if obj.m_nMicState == 1 then
        	WGCloudVoiceNotify:OpenMic()
        else
        	WGCloudVoiceNotify:CloseMic()
    	end

    	if obj.m_nSpeakerState == 1 then
        	WGCloudVoiceNotify:OpenSpeaker()
        else
        	WGCloudVoiceNotify:CloseSpeaker()
    	end

		ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "2," .. obj.m_nSpeakerState, 0 )
		ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "3," .. obj.m_nMicState, 0 )
	end

end

--@brief 语音聊天室状态回调
function voiceMemberState(state)
	WZLog("voiceMemberState", state, tostring(WndBattleHud.m_root))
	state = json.decode(state)
	state.members = SplitStringWithSeparator(state.members, ",", nil, true)
	if WndBattleHud.m_root then
		WndBattleHud:voiceMemberState(state)
	end

	if SceneRoom.m_root then
		SceneRoom:voiceMemberState(state)
	end

	if WndLeagueTeamDetail.m_root then
		WndLeagueTeamDetail:voiceMemberState(state)
	end

	if SceneGuildWarRoom.m_root then
		SceneGuildWarRoom:voiceMemberState(state)
	end
end

--@brief 读表奖励获取（按品质排序）item 格式{id = int,count = int}
function GetSortRewardItemList(tdrop)
	local list = {}
	for i = 1 ,#tdrop do
        local info = {}
        info.id = tdrop[i].id
        info.count = tdrop[i].count
        local tmp = GDatatab_item["id_"..info.id]
        info.quality = tmp and tmp.quality or 1
        table.insert(list,info)
    end
    return list
end

--@brief    检查禁忌之地某一章节是否开启
--@param    nSection:章节
function CheckTabooSectionOpen(nSection)
    -- body
    WZLog("CheckTabooSectionOpen", nSection)
    if nSection == nil or nSection == -1 or nSection == 0 then return true end

    local tData = GDatatab_forbidden_chapter["id_" .. nSection]

    if tData.level > CacheCenter:getPlayerInfo().level then
        MsgBoxManager:showTipBox(string.format(LocalStrings.ACTIVE_NOLEVEL, tData.level))
        return false
    else
        return true
    end
end

--跨服功能是否开启 (0 :未开启 1：已开启)
function GlobalMethod:crossServiceOpen()
	-- body
	WZLog("GlobalMethod:crossServiceOpen")
	local serverStatus = CacheCenter:getGameParam()["crossServiceStatus"]
	if serverStatus ~= nil then
		serverStatus = tonumber(serverStatus)
	end
	--local serverStatus = CacheCenter:getServerStatusByServerId(CacheCenter:getPlayerInfo().serverId)
	return serverStatus
end

--英雄sdk入口是否为新控制方法的判断
function IsNewHeroControl()
	if ProjConfig.SDK_CODE then
	 	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	 	if platForm == 2 or tonumber(ProjConfig.ChannelId) == 106 then 
	 		if ProjConfig.SDK_CODE >= 2 then
	 			return true
	 		end
	 	else
	 		--由于老版本越狱包sdkcode过大的处理
	 		if ProjConfig.SDK_CODE >= 3 then
	 			return true
	 		end
	 	end
	 end
	 return false
end

--应用宝BBS功能
function EnterSDKBBS()
	if ProjConfig.SDK_CODE then
	    --由于老版本越狱包sdkcode过大的处理
	 	if ProjConfig.SDK_CODE >= 5 then
	 		local sdkTab = {}
            sdkTab.funType = "enterbbs"
	 		PassportSdkManager:Others(sdkTab)
	 		return
	 	end
	 end
    MsgBoxManager:showTipBox(LocalStrings.NEED_UPDATE_VERSION)
end

function getMondayPlanCardState(activityType)
	WndFreeca.g_bIsMondayPlanCard = false
	for i=1,#activityType do
		if activityType[i] == g_tGameActivityTypes.ACTIVITY_MONDAY_PLAN_CARD then
			WndFreeca.g_bIsMondayPlanCard = true
			return
		end
	end
end

--获得新手在线活动当前在线时间
function getNewOnlineRewardState()
	WZLog("getNewOnlineRewardState", WndGameActivity.m_bNewOnlineState)
	if WndGameActivity.m_bNewOnlineState == nil or WndGameActivity.m_bNewOnlineState == 0 then
		WndGameActivity.m_bNewOnlineState = 1
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo(0)
	end
end

function getNewOnlineRewardState1(activityId, activityType)
	WZLog("getNewOnlineRewardState1",WndGameActivity.m_bNewOnlineState , Serialize(activityId), Serialize(activityType))
	if WndGameActivity.m_bNewOnlineState ~= 1 then return end
	WndGameActivity.m_bNewOnlineState = 2
	for i=1,#activityType do
		if activityType[i] == g_tGameActivityTypes.ACTIVITY_TYPE_5009 then
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(activityId[i] ,activityType[i])
			return
		end
	end
	WndGameActivity.m_bNewOnlineState = 0
end

function getNewOnlineRewardState2(rewardItems, rewardCounts, count, target, status, activityId)
	WZLog("getNewOnlineRewardState2", WndGameActivity.m_bNewOnlineState, count)
	if WndGameActivity.m_bNewOnlineState == 2 or (WndGameActivity.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_TYPE_5009 and WndGameActivity.m_nSelectedActivityId == activityId) then
		WZLog("getNewOnlineRewardState2刷新")
		WndGameActivity.m_bNewOnlineState = 0
		WndGameActivity.param1 = count
		WndGameActivity.param2 = {-1, -1}

		local state = {-1,-1}
		local index = 1
		for i=1,#rewardCounts do
			for j=1,rewardCounts[i] do
				local tItem = GDatatab_item["id_"..rewardItems[index]]
				if tItem.main_type == 4 then
					WndGameActivity.param2[1] = target[i]
					state[1] = status[i]
				end
				if tItem.main_type == 14 then
					WndGameActivity.param2[2] = target[i]
					state[2] = status[i]
				end
				index = index + 1
			end
		end

		--TODO 显示新手在线奖励指引
		SceneCity:showActivityLingth(WndGameActivity.param1, WndGameActivity.param2, state)
	end
end
function doGoogleUrl()
    local url = "https://play.google.com/store/apps/details?id=com.wyd.gplay.bombheroes"
    if WGameCmUtil:GetBundleIdentifier() == "com.wyd.appstore.bombheroes" then
    	url = "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1175720327&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"	
    end
    if WGameCmUtil:GetBundleIdentifier() == "com.wyd.gplay.bombheroesen" then
    	url = "https://play.google.com/store/apps/details?id=com.wyd.gplay.bombheroesen"	
    end
    if WGameCmUtil:GetBundleIdentifier() == "com.wyd.gplay.heroibomba" then
    	url = "https://play.google.com/store/apps/details?id=com.wyd.gplay.heroibomba"	
    end
    WndActivities:showView()
    WndActivities:_setActivityUrl(url)
end

--@brief 邀请fb（越南）
function DoLinkVn()
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needShareVn == "true" then
  		local postData = {}
  		if g_loginType == "facebook" then
     		postData.funType = "linkFb_vn"
     	else
     		postData.funType = "linkZalo_vn"
     	end
     	postData.title = "GunPow"
     	postData.desc = "Let us play GunPow!"
     	local filePath = "image/share/shareVn.png"
        postData.path = "shareImg.png"
        local platForm = WZUISystem:getInstance():getPlatformInfo()
     	if platForm == 2 then--android 
     		filePath = "assets/gameresources/resources/"..filePath
      		if curSdkObj.m_tConfig.SDKOtherConfig.needShareVn2 == "true" then
      			WZLog("hhhhhhhh:",YYYYY)
      			postData.filePath = filePath
     			PassportSdkManager:Others(postData)
    		else
    			MsgBoxManager:showTipBox(LocalStrings.NEED_UPDATE_VERSION)
     		end
     	else
     		postData.filePath = "gameresources/resources/"..filePath
     		PassportSdkManager:Others(postData)
     	end
    else
      MsgBoxManager:showTipBox(LocalStrings.NEED_UPDATE_VERSION)
    end
end

--@brief 分享fb（越南）
function DoShareVn()
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needShareVn == "true" then
  		local postData = {}
  		if g_loginType == "facebook" then
     		postData.funType = "shareFb_vn"
     	else
     		postData.funType = "shareZalo_vn"
     	end
     	postData.title = "GunPow"
     	postData.desc = "Let us play GunPow!"
     	local filePath = "image/share/shareVn.png"
     	postData.path = "shareImg.png"
     	if WZUISystem:getInstance():getPlatformInfo() == 2 then
     		postData.link = "https://goo.gl/8NSwR7"
     	else
     		postData.link = "https://goo.gl/Je4Cy2"
     	end
     	postData.picture = "http://adtest2.oss-cn-shanghai.aliyuncs.com/%E7%99%BB%E5%BD%95%E5%B9%BF%E5%91%8A4-6%E6%9C%88/ad2.jpg"
     	local platForm = WZUISystem:getInstance():getPlatformInfo()
     	if platForm == 2 then--android 
     		filePath = "assets/gameresources/resources/"..filePath
      		if curSdkObj.m_tConfig.SDKOtherConfig.needShareVn2 == "true" then
      			WZLog("hhhhhhhh:",YYYYY22)
      			postData.filePath = filePath
     			PassportSdkManager:Others(postData)
    		else
    			MsgBoxManager:showTipBox(LocalStrings.NEED_UPDATE_VERSION)
     		end
     	else
     		postData.filePath = "gameresources/resources/"..filePath
     		PassportSdkManager:Others(postData)
     	end
    else
    	MsgBoxManager:showTipBox(LocalStrings.NEED_UPDATE_VERSION)
    end
end

--@brief 根据包名修改战斗成功分享到Facebook内容
--@param type:场景类型,2为单人副本或组队副本
--@param content:关卡
function SetFBShareByPackage(type, content) 
    local packageName = WGameCmUtil:GetBundleIdentifier()
    local t
	if type == 1 then
	    if packageName == "com.bombmaster.mg" or packageName == "com.sao.ios.bmmj" or packageName == "com.sfrz.ddd" 
	    	or packageName == "com.ddd.haiwai" or packageName == "com.overseas.dan" then
	    	t = {title = "Bomb Master - Play with global friend now!",
	                desc = "I just won a battle in Bomb Master. Let us enjoy ourselves in the bomb man wonderland together!",
	                imgUrl = "http://db.ddd2.bombomg.com/ios/1.jpg"}
	    else
	    	t = {title = "Bomb Man - Play with global friend now!",
	                desc = "I just won a battle in Bomb Man. Let us enjoy ourselves in the bomb man wonderland together!",
	                imgUrl = "http://adtest2.oss-cn-shanghai.aliyuncs.com/4.jpg"}
	    end
	elseif type == 2 then
	    if packageName == "com.bombmaster.mg" or packageName == "com.sao.ios.bmmj" or packageName == "com.sfrz.ddd" 
	    	or packageName == "com.ddd.haiwai" or packageName == "com.overseas.dan" then
	        t = {title = "Bomb Master - You come, you see, you conquer!",
	                desc = "I just finished ".. content .." in Bomb Master. It is EASY and FUN! Come and join me to explore much more in Bomb Master!",
	                imgUrl = "http://db.ddd2.bombomg.com/ios/1.jpg"}
	    else
	    	t = {title = "Bomb Man - Play with global friend now!",
	                desc = "I just finished ".. content .." dungeon of Bomb Man. Let us enjoy ourselves in the bomb man wonderland together!",
	                imgUrl = "http://adtest2.oss-cn-shanghai.aliyuncs.com/4.jpg"}
	    end
	end

    PassportSdkManager:facebookTask("shareFacebook",t)
end

--@brief    判断坐骑兑换卡是否已拥有，或者对应坐骑，升级坐骑已拥有
--@param    itemId:兑换卡的itemId
--@param    已拥有返回true
function checkOwnMount(itemId)
    local tBasicInfo = GDatatab_item["id_" .. itemId]
    if tBasicInfo.main_type ~= 2 or tBasicInfo.sub_type ~= 11 then
        WZLog(tBasicInfo.name.."不是兑换卡")
        return false
    end
    --是否已经有该兑换卡
    local hasCard = false
    if CacheCenter:getPlayerItemCountById(itemId) > 0 then
        hasCard = true
        return true
    end

    --是否有该兑换卡对应的坐骑
    local hasMount = false
    local mountsItemId = {}
    --获得兑换卡可以直接兑换的坐骑
    local exchangeId = -1
    for k,v in pairs(GDatatab_mounts) do
        if v.way ~= -1 and v.way[1][2] == 2 and v.way[2][2] == itemId then
            exchangeId = v.item_id 
            table.insert(mountsItemId, exchangeId)
            break
        end
    end
    --获得兑换卡兑换的坐骑之后可以进化的坐骑
    if exchangeId ~= -1 then
        local tempId = exchangeId
        while GDatatab_mounts_quality_upgrade["id_"..tempId] ~= nil do
            tempId = GDatatab_mounts_quality_upgrade["id_"..tempId].id1
            table.insert(mountsItemId, tempId)
        end
    end
    WZLog("兑换卡对应的坐骑id", Serialize(mountsItemId))
    local tDataList = CacheCenter:getPlayerInfo().allMountsMessage
    for i=1,#tDataList do
        local tData = json.decode(tDataList[i])
        local mountsId = tData.mountsId
        for k,v in pairs(mountsItemId) do
            if GDatatab_mounts["id_"..mountsId].item_id == v then
                hasMount = true
                return true
            end
        end
    end

    return false
end

--@brief 网页支付（越南）
function DoWebPayVn()
	if CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().id then
		PostPlayerEvent:postEvent(PostPlayerEvent.event_payVnWeb)
		local roleId = CacheCenter:getPlayerInfo().id
		local privatekey = "PhZf2DxKfKQuKkWTh2AVU68df9pvMHVgs4pX"
		local time = SystemTime:getServerTime()
		local timestamp = os.time().."000"
		local sig = string.lower(WZDeviceInfo:md5Generate(privatekey..roleId..timestamp))
		local url = string.format("https://mobi.pay.zing.vn/gunga/quick/login?gameID=gunga&sig=%s&timestamp=%s&roleId=%s&direct=true",sig,timestamp,roleId)
		WZLog("DoWebPayVn:",url,roleId,privatekey,timestamp,time)
		WZPush:openURL(url)
	end
end

--@brief 游客绑定（越南）
function DoTouristsVn()
	local userId = g_vn_userId or ""
	local privatekey = g_vn_sessionId
	local time = SystemTime:getServerTime()
	local timestamp = os.time().."000"
	local sig = string.lower(WZDeviceInfo:md5Generate("jfSBhY6BIxw1dDWK2Z8ROIgunga"..userId..privatekey..timestamp))
	local url = string.format("https://pp.m.zing.vn/web/guestMapSocial?gameID=gunga&session=%s&userID=%s&timestamp=%s&sig=%s",privatekey,userId,timestamp,sig)
	WZLog("DoWebPayVn:",url,userId,privatekey,timestamp,sig)
	WZPush:openURL(url)
end

--@brief 	新手礼包保留
function CreateLimitPackage(funcId, parentNode, relativePoint, bShowAll)
	-- body
	local tNewUserPackageList = CacheCenter:getNewUserPackageList()
	if tNewUserPackageList == nil or #tNewUserPackageList == 0 then return end 

	local nCurServerTime = SystemTime:getServerTime()
	local curPackage = nil 
	for i = 1, #tNewUserPackageList do
		if tNewUserPackageList[i].funcId == funcId and tNewUserPackageList[i].lastNum ~= 0 and tNewUserPackageList[i].endTime > nCurServerTime then 
			curPackage = tNewUserPackageList[i]
			break 
		end
	end

	WZLog("CreateLimitPackage", Serialize(curPackage))
	if curPackage then 
		local btnPackage = WZUIButton:create()
		btnPackage:setAbsContentSize(GlobalMethod:CCSize(100,80))
		btnPackage:setUseAbsSize(true)
		btnPackage:setRelativePosition(relativePoint)
		btnPackage:setVisible(true)
		if bShowAll then 
			btnPackage:setShowAll(bShowAll)
		end
		local imgNormal = WZUIImage:create()
		imgNormal:setUseOriginSize(true)
		imgNormal:setFile("ui/city/beta/commom_icon_wz_tuijian.png")

	    local imgSel = WZUIImage:create()
	    imgSel:setUseOriginSize(true)
	    imgSel:setFile("ui/city/beta/commom_icon_wz_tuijian.png")
	    imgSel:setScale(1.1)
	    
	    btnPackage:setNormalElement(imgNormal)
	    btnPackage:setSelectElement(imgSel)
	    btnPackage:setLuaDoneFunctionName("OpenNewUserPackage")

	    local spineBtn = WZUISpine:create()
        spineBtn:setLoop(true)
        spineBtn:setRelativePosition(GlobalMethod:ccp(0.5,1))
        spineBtn:setVisible(true)
        spineBtn:setTouchEnable(false)
        spineBtn:setFileJson("city/ui_main_iconeffect.json")
        spineBtn:setFileAtlas("city/ui_main_iconeffect.atlas")
        spineBtn:setAnimationName("animation")
        btnPackage:addChild(spineBtn)


	    local txtBtn = WZUILabelTTF:create()
	    txtBtn:setText(LocalStrings.VIPWEEK_PACKAGE3)
	    txtBtn:setColor(GlobalMethod:ccc3(255,236,193))
	    txtBtn:setStrokeColor(GlobalMethod:ccc3(79,60,48))
	    txtBtn:setRelativePosition(GlobalMethod:ccp(0.5, 0))
	    txtBtn:setFontSize(18)
	    txtBtn:setEnableStroke(true)
	    txtBtn:setStrokeSize(4)
	    btnPackage:addChild(txtBtn)

	    if ProjConfig.LANGUAGE == "en" then
	    	if WndImproveStrengthen.m_root then
	    		txtBtn:setRelativePosition(GlobalMethod:ccp(0.8, 0))
	    	end
	    end
	    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "ug" then
	    	txtBtn:setScale(0.7)
    		txtBtn:setDimensions(GlobalMethod:CCSize(120))
	    end

	    parentNode:addChild(btnPackage, 0, tonumber(funcId))

	    if ProjConfig.LANGUAGE == "vn" then
	    	txtBtn:setScale(0.7)
			txtBtn:setDimensions(GlobalMethod:CCSize(120))
	    	if WndFamilyOperate.m_root then
	    		btnPackage:setRelativePosition(GlobalMethod:ccp(0.3,0.45))
			end
		end
	end
end

--@brief 	打开新手定推礼包按钮回调
function OpenNewUserPackage(element)
	-- body
	WZLog("OpenNewUserPackage")
	local nTag = element:getTag()
	local tNewUserPackageList = CacheCenter:getNewUserPackageList()
	if tNewUserPackageList == nil or #tNewUserPackageList == 0 then return end 

	local nCurServerTime = SystemTime:getServerTime()
	local curPackage = nil 
	for i = 1, #tNewUserPackageList do
		if tNewUserPackageList[i].funcId == nTag then 
			curPackage = tNewUserPackageList[i]
			break 
		end
	end
	if curPackage then
		local pushInfo = {}
		table.insert(pushInfo, curPackage.pushInfo)
		local lastNum = {}
		table.insert(lastNum, curPackage.lastNum)
		local originPrice = {}
		table.insert(originPrice, curPackage.originPrice)
		local endTime = {}
		table.insert(endTime, curPackage.endTime)

		WndVipGift:showInterface(pushInfo, lastNum, 2, originPrice, nTag, endTime)
	end
end

--@brief 判断是否iponex
function IsIphoneX()
	if WZDeviceInfo:systemName() == "iPhone10,3" or WZDeviceInfo:systemName() == "iPhone10,6" or WZDeviceInfo:systemName() == "iPhone12,1" or WZDeviceInfo:systemName() == "iPhone12,3" or WZDeviceInfo:systemName() == "iPhone13,2" or WZDeviceInfo:systemName() == "iPhone12,5" or WZDeviceInfo:systemName() == "iPhone14,4" or WZDeviceInfo:systemName() == "iPhone14,5" or WZDeviceInfo:systemName() == "iPhone14,7" or WZDeviceInfo:systemName() == "iPhone14,8" then
       return true
    end

    if WZDeviceInfo:systemName() == "PAAM00" 
    	or WZDeviceInfo:systemName() == "PAAT00"
    	or WZDeviceInfo:systemName() == "PACM00"
    	or WZDeviceInfo:systemName() == "PACT00"
    	or WZDeviceInfo:systemName() == "CPH1831"
    	or WZDeviceInfo:systemName() == "CPH1833" 
    	or WZDeviceInfo:systemName() == "PD1728" then
    	return true
    end

    if ProjConfig and ProjConfig.DEBUG == 1 and ProjConfig.IPHONEX_TEST == 1 then
        local platForm =  WZUISystem:getInstance():getPlatformInfo()
        local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
        local screenRate = screenSize.width / screenSize.height
        if platForm == 3 and screenRate >= 1.9 and screenRate <= 2.2 then
            return true
        end
    end

	return false
end

--是否需要禁赛(仅限排位赛)
function IsShowPunishTime(bShowPunishTime)
    WZLog("IsShowPunishTime ",GlobalGame.g_pvpPunishTime)
    local channel = GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW
    if GlobalGame.g_pvpPunishTime == nil then
        ProtocolProcessorGlobal:send_ROOM_CheckPwPunish(channel)
        return true
    elseif GlobalGame.g_pvpPunishTime > 0 then
        local curSystemTime = SystemTime:getServerTime()
        if curSystemTime - GlobalGame.g_pvpPunishTimeCurServiceT < GlobalGame.g_pvpPunishTime then
        	if bShowPunishTime then
        		local curTime = GlobalGame.g_pvpPunishTime - (curSystemTime - GlobalGame.g_pvpPunishTimeCurServiceT)
        		WndSuspension:showByTime(curTime,1)
        	end
            return true
        else
            GlobalGame.g_pvpPunishTime = nil
            ProtocolProcessorGlobal:send_ROOM_CheckPwPunish(channel)
        end
    elseif GlobalGame.g_pvpPunishTime <= 0 then
    	ProtocolProcessorGlobal:send_ROOM_CheckPwPunish(channel)
    end
    return false
end

--是否需要禁赛(仅限战略赛)
function IsShowZlsPunishTime(bShowPunishTime)
    WZLog("IsShowZlsPunishTime ",GlobalGame.g_pvpZlsPunishTime)
    local channel = GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS
    if GlobalGame.g_pvpZlsPunishTime == nil then
        ProtocolProcessorGlobal:send_ROOM_CheckPwPunish(channel)
        return true
    elseif GlobalGame.g_pvpZlsPunishTime > 0 then
        local curSystemTime = SystemTime:getServerTime()
        if curSystemTime - GlobalGame.g_pvpZlsPunishTimeCurServiceT < GlobalGame.g_pvpZlsPunishTime then
        	if bShowPunishTime then
        		local curTime = GlobalGame.g_pvpZlsPunishTime - (curSystemTime - GlobalGame.g_pvpZlsPunishTimeCurServiceT)
        		WndSuspension:showByTime(curTime,2)
        	end
            return true
        else
            GlobalGame.g_pvpZlsPunishTime = nil
            ProtocolProcessorGlobal:send_ROOM_CheckPwPunish(channel)
        end
    elseif GlobalGame.g_pvpZlsPunishTime <= 0 then
    	ProtocolProcessorGlobal:send_ROOM_CheckPwPunish(channel)
    end
    return false
end

--打开伙伴
function OpenPartner(index)
	if index == nil then
		local isRedPet = CacheCenter:getRedState("btnPet") and CheckButtonOpen(ISLAND_RIGHT_PET, false) or GlobalGame.g_tRedPointList.petFetter
		local isRedMount = CacheCenter:getRedState("btnMount") and CheckButtonOpen(ISLAND_RIGHT_MOUNT, false)
		local isRedFoot = CacheCenter:getRedState("btnFootMark") and CheckButtonOpen(ISLAND_RIGHT_FOOTMARK, false) 
		local isPhantom = CheckButtonOpen(ISLAND_RIGHT_PHANTOM,false)
		-- index = isRedPet and 1 or isRedMount and 2 or isRedFoot and 3 or isPhantom and 4 or nil
		if isRedPet then
			index = 1
		elseif isRedMount then
			index = 2 
		elseif isRedFoot then
			index = 3
		elseif isPhantom then
			index = 4
		else 
			index = nil 
		end


		WZLog("OpenPartner one", index, isRedPet, isRedMount, isRedFoot)
	end
	WZLog("OpenPartner two", index)
	if index == 1 or index == nil then
		WndPets:showInterface(1)
	elseif index == 2 then
		WndPets:showInterface(2)
	elseif index == 3 then
		WndPets:showInterface(3)
	elseif index == 4 then
		WndPets:showInterface(4)
	end
end

--@brief 	根据宠物的物品id和进阶等级获取形象动画
function GetPetAnimation(petItemId, adavancedLevel)
	-- body
	local animation  
	local tBasicData = GDatatab_item["id_" .. petItemId]

	if tBasicData and tBasicData.quality == 4 then
		animation = tBasicData.animation_index_code
	else
		for i, v in pairs(GDatatab_pet_advanced) do
			if v.item_id == petItemId and v.level == adavancedLevel then
				animation = v.animation
				break 
			end
		end
	end

	return animation 
end

--@brief 	筛选称号
--@param 	title : 当前称号
function WhetherShowDesignation(title)
	-- body
	local showTitleList = CacheCenter:getGameParam().chatShowTitle
	local tIdList = SplitStringWithSeparator(showTitleList, ",", nil, true)
	WZTempLog(Serialize(tIdList))
	for i = 1, #tIdList do
		local tData = GDatatab_achievement["id_" .. tIdList[i]]
		if tData and tData.name == title then
			return true
		end
	end

	return false 
end

--@brief 	判断当前私聊信息是否拜师或收徒信息
function WhetherMasterMessage(chatChannel, sMsgContent)
	-- body
	local bMasterMessage = false    --是否是拜师或收徒的信息
    if chatChannel == CHANNEL_WHISPER then
        local sTempMsg = string.sub(sMsgContent, 1, 6)
        if sTempMsg == g_MasterMessage_Mark then
            bMasterMessage = true
        end
    end

    return bMasterMessage 
end

--@brief	bit数组转换为数字
--@param    tBits, 要转换的数组
--@return   #1, bit数组, 从低位到高位
function BitsToNumber(tBits)
	local nNum = 0

    for i = 1, #tBits do
    	nNum = nNum + tBits[i] * math.pow(2, i - 1)
    end

    return nNum
end

--@brief  根据性别创建玩家孩子形象
--@param  nSex : 性别，0:男 1:女
--@param  tEquip : 装备，装备id列表{3000,4300,4500,4700,...}
--@param  sAnimationName : 动画名称, 默认为wait0, 头像为"avatar"
--@param  bOnlyShowHead:是否只需要显示头部
--@return conPlayer :添加到容器里需要获取conPlayer:getAnimNode()
--@return 宠物的relativePosition,默认ccp(-0.5,1.5)
--@param	是否幻化
function CreatePlayerBabyFigure(nSex, tEquip, sAnimationName, bOnlyShowHead, bLoop)
	WZLog("CreatePlayerBabyFigure")
    local bIsBoy = nSex ~= 1 and true or false
    
	WZLog("CreatePlayerBabyFigure:", Serialize(tEquip))
	
    local conPlayer = YDBabyAnimation:createAnimation(bIsBoy)

    local head = nil
    local face = nil
    local body = nil

    for i = 1, #tEquip do
		local nEquipId = tEquip[i]
		if nEquipId ~= nil then
			if type(nEquipId) == "table" then nEquipId = nEquipId.id end
		    local tEquipData = GetItemLocalData(nEquipId)

		    if tEquipData then
		        local maintype = tEquipData.main_type
		        local subtype = tEquipData.sub_type
		        if maintype == 31 and subtype == 3 then --物品是否是衣服 
		            body = (tEquipData.animation_index_code)
		        elseif maintype == 31 and subtype == 2 then --物品是否是脸谱
		            face = (tEquipData.animation_index_code)
		        elseif maintype == 31 and subtype == 1 then -- 物品是否是头部 
		            head = (tEquipData.animation_index_code)
		        end
		    end
		end
    end
   
    --设置默认显示
    local gameParam = CacheCenter:getGameParam()
    if bIsBoy == true then
        if head == nil then head = GDatatab_item["id_"..(gameParam.defaultmaleHeadId or 51000)].animation_index_code end
        if face == nil then face = GDatatab_item["id_"..(gameParam.defaultmaleFaceId or 51200)].animation_index_code end
        if body == nil then body = GDatatab_item["id_"..(gameParam.defaultmaleBodyId or 51400)].animation_index_code end
    else
        if head == nil then head = GDatatab_item["id_"..(gameParam.defaultfemaleHeadId or 51100)].animation_index_code end
        if face == nil then face = GDatatab_item["id_"..(gameParam.defaultfemaleFaceId or 51300)].animation_index_code end
        if body == nil then body = GDatatab_item["id_"..(gameParam.defaultfemaleBodyId or 51500)].animation_index_code end
    end

    conPlayer:setHead(head)
    conPlayer:setFace(face)
    if not bOnlyShowHead then
    	conPlayer:setBody(body)
    end

    if  bLoop == nil then --只显示头部不需要循环显示动画
    	bLoop = true
    end
    conPlayer:play(sAnimationName or "wait", bLoop)


    return conPlayer
end

--@brief 过滤特殊字符
--@param    s, 要转换的字符串
--@return   #1, 去除了特殊字符的字符串
function Filter_spec_chars(s)
    local ss = {}
    local k = 1
    while true do
        if k > #s then break end
        local c = string.byte(s,k)
        if not c then break end
        if c<192 then
            if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then
                table.insert(ss, string.char(c))
            end
            k = k + 1
        elseif c<224 then
            k = k + 2
        elseif c<240 then
            if c>=228 and c<=233 then
                local c1 = string.byte(s,k+1)
                local c2 = string.byte(s,k+2)
                if c1 and c2 then
                    local a1,a2,a3,a4 = 128,191,128,191
                    if c == 228 then a1 = 184
                    elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165
                    end
                    if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then
                        table.insert(ss, string.char(c,c1,c2))
                    end
                end
            end
            k = k + 3
        elseif c<248 then
            k = k + 4
        elseif c<252 then
            k = k + 5
        elseif c<254 then
            k = k + 6
        end
    end
    print("change:",table.concat(ss))
    return table.concat(ss)
end

--@brief 	获取配置的公会最大等级
function GetMaxGuildLevel()
	-- body
	local nMaxLevel = 1

	for i, v in pairs(GDatatab_guild_level) do
		if v.level > nMaxLevel then
			nMaxLevel = v.level
		end
	end

	return nMaxLevel
end

--@brief 执行android返回键的功能
function DoAndroidBackEvent()
	if ProjConfig.AndroidBack == nil or ProjConfig.AndroidBack == 0 then return end
	--有提示框则不弹出该操作
	if MsgBoxManager then
		if #MsgBoxManager.m_tHighLevelMsgList > 0 or #MsgBoxManager.m_tNormalLevelMsgList > 0 or
			#MsgBoxManager.m_tLowLevelMsgList > 0 or #MsgBoxManager.m_tTipBoxList > 0 then
			SDKBackEvent("false")
			return
		end
	end
	local firstWidow = nil
	local funBack = nil
	--当度scene的特殊处理
	if SceneCopy.m_root ~= nil then
		firstWidow = SceneCopy
		funBack = g_SceneCopyCallback
	elseif ScenePvp.m_root ~= nil then 
		firstWidow = ScenePvp
		funBack = ScenePvp.onTempClose
	elseif SceneRoom.m_root ~= nil then
		firstWidow = SceneRoom
		funBack = SceneRoom.onCloseClick
	elseif SceneHall.m_root ~= nil then
		firstWidow = SceneHall
		funBack = g_SceneHallCallback
	end
	--便利查找出第一个需要关闭的windows
    for k,v in pairs(WindowManager.m_tWndLuaObjStack) do
    	if v.onCloseClick or v.onClose or v.onBack or v.onTempClose or v.onColseWnd or v.removeWindow or v.onBtnCloseClick or v.OnClose or v.onClikClose
    		or v.onCloseInn or v.onClickClose or v.OnReturn or v.onBtnClose or v.onCloseBtn or v.onBtnReturn or v.onCloseWindowBtn then
    		if v ~= WndBag and v ~= Wndwardrobe and v ~= WndPhantom and v ~= WndChat then
	    		if v.onCloseClick then
	    			funBack = v.onCloseClick
	    		elseif v.onClose then
	    			funBack = v.onClose
	    		elseif v.onBack then
	    			funBack = v.onBack
	    		elseif v.onTempClose then
	    			funBack = v.onTempClose
	    		elseif v.onColseWnd then
	    			funBack = v.onColseWnd
	    		elseif v.removeWindow then
	    			funBack = v.removeWindow
	    		elseif v.onBtnCloseClick then
	    			funBack = v.onBtnCloseClick
	    		elseif v.onCloseInn then
	    			funBack = v.onCloseInn
	    		elseif v.onClickClose then
	    			funBack = v.onClickClose
	    		elseif v.OnReturn then
	    			funBack = v.OnReturn
	    		elseif v.onBtnClose then
	    			funBack = v.onBtnClose
	    		elseif v.onCloseBtn then
	    			funBack = v.onCloseBtn
	    		elseif v.onBtnReturn then
	    			funBack = v.onBtnReturn
	    		elseif v.onCloseWindowBtn then
	    			funBack = v.onCloseWindowBtn
	    		elseif v.OnClose then
	    			funBack = v.OnClose
	    		elseif v.onClikClose then
	    			funBack = v.onClikClose
	    		end
	    		firstWidow = v
	    		break
	    	end
    	end
    end
    if firstWidow then 
    	funBack(firstWidow)
	    SDKBackEvent("true")
	else
		SDKBackEvent("false")
	end
	
end

function SDKBackEvent(sResult)
	--执行sdk函数
    if PassportSdkManager:getCurSdkObj() then
    	local postData = {}
      	postData.funType = "AndroidBack"
      	postData.value = sResult
      	--local sJsonArg = json.encode(postData)
        PassportSdkManager:Others(postData, nil,nil)
    end
end

function BubbleSort(arr,func)
    if func == nil then
        return nil
    end

    for i=1,#arr do
        for j=1,#arr -i do
            local bTemp = func(arr[j],arr[j+1])
            if not bTemp then
                arr[j+1],arr[j] = arr[j],arr[j+1]
            end
        end
    end
end

--@brief 	判断记录中是否有记录该字符传
--@param 	sContent : 记录的内容
--@param 	bAdd : 是否添加到表中
function judgeHavedRecordString(sContent, bAdd)
	-- body
	--本次登陆显示过就不显示了
    if g_bShowWndMsgConfirmBox ~= nil then
        for k,v in pairs(g_bShowWndMsgConfirmBox) do
            if v == sContent then
                return true 
            end
        end
    end

    if g_bShowWndMsgConfirmBox == nil then g_bShowWndMsgConfirmBox = {} end
    local bIsExist = false 
    for k,v in pairs(g_bShowWndMsgConfirmBox) do
        if v == sContent then 
            bIsExist = true
            break 
        end
    end
    --没有保存这次提示的句子，加入这句
    if not bIsExist and bAdd then 
        table.insert(g_bShowWndMsgConfirmBox, sContent)
    end

    return bIsExist 
end

--@brief 	当前渠道是否关闭充值
function whetherCloseRecharge()
	-- body
	if g_tCloseRechargeChannel == nil then return false end
	
	for i = 1, GetTableLen(g_tCloseRechargeChannel) do 
		if tostring(ProjConfig:getChannelId()) == g_tCloseRechargeChannel[i] then 
			return true
		end
	end

	return false 
end

function GetWordCount(str)
    local _, count = string.gsub(str, "[^\128-\193]", "")
    return count;
end

--内部接口：将字符串中的敏感字替换成*(替换一个)
function ReplaceSensitiveWord(originStr, sensitiveWord)
    local resultStr = originStr;
    --1:从索引1开始搜索 true:关闭模式匹配
    local startIndex, endIndex = string.find(string.lower(originStr), string.lower(sensitiveWord), 1, true);
    if (startIndex and endIndex) then
        local strLen = string.len(originStr);
        local maskWordCount = GetWordCount(sensitiveWord);
        local maskWord = "";
        for i=1,maskWordCount do
            maskWord = maskWord .. "X";
        end

        if (startIndex == 1) then
            resultStr = maskWord .. string.sub(originStr, endIndex + 1, -1);
        elseif (endIndex == strLen) then
            resultStr = string.sub(originStr, 1, startIndex - 1) .. maskWord;
        else
            local str = string.sub(originStr, 1,startIndex - 1);
            local str2 = string.sub(originStr, endIndex + 1, -1);
            resultStr = str .. maskWord .. str2;
        end
    end
    return resultStr;
end

--内部接口：将字符串中的敏感字替换成*(替换所有)
function ReplaceSensitiveWordAll(originStr, sensitiveWord)
    local str = originStr;
    local str2 = ReplaceSensitiveWord(originStr, sensitiveWord);
    while (str ~= str2) do
        str = str2;
        str2 = ReplaceSensitiveWord(str2, sensitiveWord);
    end
    return str2;
end

--内部接口：是否有该敏感字
function HasSensitiveWord(originStr, sensitiveWord)
    local startIndex, endIndex = string.find(originStr, sensitiveWord, 1, true);
    if (startIndex and endIndex) then
        -- print("敏感字：" .. sensitiveWord);
        return true;
    else
        return false;
    end
end

--外部接口：敏感字替换
function ReplaceMaskWord(content)
    for k,v in pairs(ChatKeyWords) do
	    content = ReplaceSensitiveWordAll(content, v)
    end
    return content;
end

--外部接口：是否有敏感字
function HasMaskWord(content)
    for k,v in pairs(ChatKeyWords) do
    	--不区分大小写
		local s1 = string.lower(content)
		local s2 = string.lower(v)
		
        if (HasSensitiveWord(content, v)) then
            return true;
        end
    end
    return false;
end

--@brief 	当前渠道是否关闭登陆
function whetherCloseLoginIn(channelId)
	-- body
	if g_tCloseLoginInChannel == nil then return false end
	
	for i = 1, GetTableLen(g_tCloseLoginInChannel) do 
		if tostring(channelId) == g_tCloseLoginInChannel[i] then 
			return true
		end
	end

	return false 
end

--@brief    获取月卡时间剩余天数
function whetherHaveWelfareCard()
    --body
    local tPlayerItemsList = CacheCenter:getPlayerItems()
    if tPlayerItemsList == nil or tPlayerItemsList == {} then return false end
    
    for i = 1, #tPlayerItemsList do
        if tPlayerItemsList[i].id == 50 or tPlayerItemsList[i].id == 55 then
        	WZLog("whetherHaveWelfareCard", tPlayerItemsList[i].id, tPlayerItemsList[i].lastTime)
        	if tPlayerItemsList[i].lastTime > 0 then 
            	return true
            end
        elseif tPlayerItemsList[i].id == 52 or tPlayerItemsList[i].id == 56 then
        	if tPlayerItemsList[i].lastTime == -1 then 
            	return true
            end
        end
    end

    return false
end

--@brief 	有玩防沉迷激活与关闭，防止对战状态下被强制下线
--@param 	bIsOpen : 是否激活
function GlobalMethod:YWFangchenmi(bIsActive)
	--执行sdk函数	
	WZLog("GlobalMethod:YWFangchenmi")
	local packName = WGameCmUtil:GetBundleIdentifier()
	if packName ~= "com.gzyw.ddd.mgtv" and packName ~= "com.tjyw.ddd2online.gzml" then
		return
	end
    if PassportSdkManager:getCurSdkObj() then
    	local postData = {}
      	postData.funType = "YWFangchenmi"
      	if bIsActive == true then
      		postData.value = "true"
      	else
      		postData.value = "false"
      	end
      	--local sJsonArg = json.encode(postData)
        PassportSdkManager:Others(postData, nil,nil)
    end
end

--@brief 	判断能不能私聊
function whetherCanPrivateChat(playerId)
	-- body
	local chatConfig = CacheCenter:getGameParam().chatlimit
	local ids, nums = SplitItemString(chatConfig)
	if CacheCenter:getPlayerInfo().level >= tonumber(nums[2]) then 
		return true 
	end
	--如果是好友，可以私聊
	if CacheCenter:judgeIsContainsById(playerId) then 
		return true
	end
	--是否满足限制条件
	--副本条件
	local tMultiCopyData = CacheCenter:getMultiCopyData() or {}
	local copyData = GDatatab_team_map["id_" .. ids[1]]
	local bPassed = false 
	for i,v in ipairs(tMultiCopyData) do
        local nMapId = v.mapId
        if copyData.map_num == nMapId and copyData.difficulty <= v.starLevel then
            bPassed = true
            break 
        end
    end
    --vip等级条件
    local bVipOverConfig = tonumber(nums[1]) <= CacheCenter:getPlayerInfo().vipLevel
    if bPassed or bVipOverConfig then 
    	--私聊次数是否过大
    	local chatNum = GetTableLen(g_tWhisperChatPlayerId)
    	WZLog("whetherCanPrivateChat", chatNum, ids[2])
    	if chatNum >= tonumber(ids[2]) then 
    		MsgBoxManager:showTipBox(LocalStrings.CHAT_TOO_MUCH)
    		return false 
    	else
    		return true
    	end
    else
    	local tDifficulty = {
            LocalStrings.COMMON,
            LocalStrings.DIFFICULTY,
            LocalStrings.HELL  
        }

    	MsgBoxManager:showTipBox(string.format(LocalStrings.CHAT_LIMIT, copyData.map_name, tDifficulty[copyData.difficulty], tonumber(nums[1])))
    	return false 
    end
end

--@brief 	记录本次登陆私聊的陌生人ID
--@param 	playerId: 私聊的玩家Id
--@param 	chatText:私聊内容 
function saveChatStrangerId(playerId, chatText)
	-- body
	--检测私聊内容是不是拜师，是就不保存
	local bMasterMessage = false    --是否是拜师或收徒的信息
    local sTempMsg = string.sub(chatText, 1, 6)
    if sTempMsg == g_MasterMessage_Mark then
        return 
    end
	--如果是好友，可以私聊
	if CacheCenter:judgeIsContainsById(playerId) then 
		return 
	end
	if g_tWhisperChatPlayerId == nil then 
		g_tWhisperChatPlayerId = {}
	end

	local bHaved = false 
	for i = 1, #g_tWhisperChatPlayerId do
		if g_tWhisperChatPlayerId[i] == playerId then 
			bHaved = true
			break 
		end
	end

	if not bHaved then 
		table.insert(g_tWhisperChatPlayerId, playerId)
	end
end

--@brief 	空白面板提示内容
--@param    objNode  容器节点
--@param 	sText  提示内容
--@param    color 字体颜色
--@param    position 相对坐标
--@param    strokeColor 描边颜色
function ShowPanelNullTip2( objNode, sText, color, imgScale, position, strokeColor)
    if objNode:getChildByTag(100) then
        objNode:removeChildByTag(100,true)
    end
    if position == nil then
        position = ccp(0.5,0.5)
    end

    if sText == nil then
        sText = LocalStrings.FRIENDS_SEND_TIP_3
    end
    if color == nil then
        color = ccc3(127,70,26)
    end
    if strokeColor == nil then
        strokeColor = ccc3(105,65,46)
    end

    local conOutSide = WZUIContainer:create()
    conOutSide:setAbsContentSize(GlobalMethod:CCSize(250, 300))
    conOutSide:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    conOutSide:setTouchEnable(false)
    conOutSide:setUseAbsSize(true)

    local imgNPC = WZUIImage:create()
    imgNPC:setFile("ui/gameActivity/common_pic_tnlgg.png")
    imgNPC:setUseOriginSize(true)
    imgNPC:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    imgNPC:setRelativePosition(GlobalMethod:ccp(0.5, 0))
    imgNPC:setOpacity(125)
    imgNPC:setScale(imgScale or 1)
    imgNPC:setTouchEnable(false)
    conOutSide:addChild(imgNPC)

    local conForText = WZUIContainer:create()
    conForText:setAbsContentSize(GlobalMethod:CCSize(224, 142))
    conForText:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
    conForText:setRelativePosition(GlobalMethod:ccp(1.1, 0.9))
    conForText:setTouchEnable(false)
    conForText:setUseAbsSize(true)

    local img9Dia = WZUI9Image:create()
    img9Dia:setFile("ui/common/common_tan_01.png")
    img9Dia:setTouchEnable(false)
    conForText:addChild(img9Dia)

    local txtNoData = WZUILabelTTF:create()
    txtNoData:setAnchorPoint(ccp(0.5,0.5))
    txtNoData:setUseOriginSize(true)
    txtNoData:setRelativePosition(GlobalMethod:ccp(0.5, 0.6))
    txtNoData:setColor(color)
    txtNoData:setFontSize(22)
    txtNoData:setText(sText)
    txtNoData:setStrokeColor(strokeColor)
    txtNoData:setStrokeSize(4)
    txtNoData:setEnableStroke(false)
    txtNoData:setDimensions(GlobalMethod:CCSize(210,0))

    conForText:addChild(txtNoData)
    conOutSide:addChild(conForText)

    conOutSide:setRelativePosition(position)
    objNode:addChild(conOutSide, 100, 100)
end

--@brief 	获取皮肤幻力最大等级上限
function getMaxPhantomLevel()
	-- body
	return GetTableLen(GDatatab_shape_level) - 1
end

--@brief 	判断是否显示oppo琥珀大玩家专属福利活动
function GlobalMethod:getIsShowOVAmberPlayer()
	-- body
	g_oppo_isAmberPlayer = false
	if g_cityExtenInfo and g_cityExtenInfo.oppoActivity and tonumber(g_cityExtenInfo.oppoActivity) ~= 0 and ProjConfig.CHANNEL_ID == 23 and CheckButtonShow(ISLAND_UP_OPPO_AMBERPLAYER, true) then
        g_oppo_isAmberPlayer = true
        return true
    end
    return false
end
--信誉积分的一些处理
--[[
_type 玩法
1：任务
2：对战赛
3：娱乐赛
4：排位赛 
5：组队副本
6:战略赛
]]
function GlobalMethod:HonorPointStatus(_type)
	local point = 0
	if CacheCenter:getPlayerInfo() then
		point = CacheCenter:getPlayerInfo().honourPoint or 0
	end

	--如果存在分数过低就会不然进入游戏的玩法
	local info = GDatatab_credit_limit
	local point_list = {GDatatab_credit_limit["id_1"].point_min, GDatatab_credit_limit["id_2"].point_min, GDatatab_credit_limit["id_3"].point_min, 
		GDatatab_credit_limit["id_4"].point_min, GDatatab_credit_limit["id_5"].point_min, GDatatab_credit_limit["id_6"].point_min}
		WZLog("信誉积分的一些处理",point,point_list[_type])
	if tonumber(point) >= point_list[_type] then
		return true, point_list[_type]
	end
	return false, point_list[_type]
end
function delayRun(obj, delay_time, fun)
    if not tolua.isnull(obj) then
    	local array = CCArray:create()
    	local act1 = CCDelayTime:create(delay_time)
    	local act2 = CCCallFunc:create(function() 
    		if not tolua.isnull(obj) and fun ~= nil then
                fun()
            end
    	end)
    	array:addObject(act1)
    	array:addObject(act2)
    	obj:runAction(CCSequence:create(array))
    end
end
function doStopAllActions(node)
    if tolua.isnull(node) then return end
    node:stopAllActions()
end
--排序
function taskTableSort(data_sort)
	local temp = {
		[0] = 2, --未领取
		[1] = 1, --可领取
		[2] = 3, --已领取
	}
	local function testFunc(a,b)
		if a.status ~= b.status then
			if temp[a.status] and temp[b.status] then
				return temp[a.status] < temp[b.status]
			else
				return false
			end
		else
			return a.id < b.id
		end
	end
	table.sort(data_sort, testFunc)
end
--获取真实的长度
function getnTableCount(nums)
	if not nums or next(nums) == nil then return 0 end

	local count = 0
	for i,v in pairs(nums) do
		if v ~= nil then
			count = count + 1
		end
	end
	return count
end

--@brief 	获取payCodeId通过渠道Id
--@param 	vipData: 某一条充值数据
function GetPayCodeIdByChannelId(vipData)
	-- body
	local payCodeIdList = SplitStringWithSeparator(vipData.pay_code_id, ",")
	local channelIdList = SplitStringWithSeparator(vipData.channel_id, ",")
	local myChannelId = tostring(ProjConfig:getChannelId())

	local payCode = payCodeIdList[1]
	for i = 1, #channelIdList do
		if channelIdList[i] == myChannelId then 
			payCode = payCodeIdList[i]
			break 
		end
	end

	return payCode
end

function showUserAgreement(tag)
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	local config = curSdkObj.m_tConfig
    local urlList = {"http://privacy.youwanplay.com/2021/agreement_global.html","http://privacy.youwanplay.com/2021/per_adu.html","http://privacy.youwanplay.com/2021/per_child.html","https://privacy.mi.com/xiaomigame-sdk/zh_CN/"}
	if ProjConfig.LANGUAGE == "vn" then
		urlList = {"https://gunpow.vnggames.net/content/gioi-thieu/dieu-khoan-su-dung.html","https://privacy.vnggames.net/vn","https://privacy.vnggames.net/vn/","https://privacy.vnggames.net/vn/"}  
	end
	if curSdkObj then
		if ProjConfig.LANGUAGE == "vn" then		
	    	if config and config.SDKOtherConfig and config.SDKOtherConfig.isSupportWebView then
	    --	if not config or not config.SDKOtherConfig or not config.SDKOtherConfig.isSupportWebView or config.SDKOtherConfig.isSupportWebView ~= "true"  then
    			print("sun---showUserAgreement--config nil or isSupportWebView not true")
				local url = urlList[tag] or ""
		  		WZPush:openURL(url)
    			return
	    	end
		end
        local data ={}
        data.funType = "showUserAgreement"
        data.tag = tag
        data.url = urlList[tag] or ""
        data.force = "false"
        --SCREEN_ORIENTATION_SENSOR_LANDSCAPE = 6;  SCREEN_ORIENTATION_SENSOR_PORTRAIT = 7;
        data.oreintation = "6"
        if tag == 5 then
        	data.force = "true"
        	data.oreintation = "7"
        end
        local sJsonArg = json.encode(data)
       	curSdkObj:accountOthers(sJsonArg, nil,nil)
	else
		local url = urlList[tag] or ""
  		WZPush:openURL(url)
	end
end

--[[------------------------------------------------------------------------------
-** 设置table只读 出现改写会抛出lua error
-- 用法 local cfg_proxy = read_only(cfg) retur cfg_proxy
-- 增加了防重置设置read_only的机制
-- lua5.3支持 1）table库支持调用元方法，所以table.remove table.insert 也会抛出错误，
--  2）不用定义__ipairs 5.3 ipairs迭代器支持访问元方法__index，pairs迭代器next不支持故需要元方法__pairs
-- 低版本lua此函数不能完全按照预期工作
*]]
function read_only(inputTable)
	local travelled_tables = {}
	local function __read_only(tbl)
		if not travelled_tables[tbl] then
			local tbl_mt = getmetatable(tbl)
			if not tbl_mt then
				tbl_mt = {}
				setmetatable(tbl, tbl_mt)
			end

			local proxy = tbl_mt.__read_only_proxy
			if not proxy then
				proxy = {}
				tbl_mt.__read_only_proxy = proxy
				local proxy_mt = {
				__index = tbl,
				__newindex = function (t, k, v) error("error write to a read-only table with key = " .. tostring(k)) end,
				__pairs = function (t) return pairs(tbl) end,
				-- __ipairs = function (t) return ipairs(tbl) end, 5.3版本不需要此方法
				__len = function (t) return #tbl end,
				__read_only_proxy = proxy,
				}
				setmetatable(proxy, proxy_mt)
			end
			travelled_tables[tbl] = proxy
			for k, v in pairs(tbl) do
				if type(v) == "table" then
				tbl[k] = __read_only(v)
				end
			end
		end
		return travelled_tables[tbl]
	end
	return __read_only(inputTable)
end

local function dump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end
local function split(str, d) --str是需要查分的对象 d是分界符
	local lst = { }
	local n = string.len(str)--长度
	local start = 1
	while start <= n do
		local i = string.find(str, d, start) -- find 'next' 0
		if i == nil then 
			table.insert(lst, string.sub(str, start, n))
			break 
		end
		table.insert(lst, string.sub(str, start, i-1))
		if i == n then
			table.insert(lst, "")
			break
		end
		start = i + 1
	end
	return lst
end
local function trim(s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end
--[[
新增加的打印信息
]]
function dump(value, desciption, nesting)
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local traceback = split(debug.traceback("", 2), "\n")
    print("dump from: " .. trim(traceback[3]))

    local function dump_(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, dump_value_(desciption), spc, dump_value_(value))
        elseif lookupTable[tostring(value)] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, dump_value_(desciption), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, dump_value_(desciption))
            else
                result[#result +1 ] = string.format("%s%s = {", indent, dump_value_(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    dump_(value, desciption, "- ", 1)

    for i, line in ipairs(result) do
        print(line)
    end
end

--创建特效动画
--[[
data传进来的数据
data.path  文件路径
data.play  动作
data.loop  是否循环
data.ccp   相对位置
]]
function createEffectSpine(node,data)
	if not node then return end

	data = data or {}
	local path = data.path or "ui/otherUI/ui_common_zhaohuan" --文件路径
	local play_name = data.play or "ui_common_zhaohuan"  --动作的play
	local isLoop = data.loop or false --是否循环 默认false
	local ccp = data.ccp or GlobalMethod:ccp(0.5,0.5)
	local zOrder = data.zOrder or 0 --层级
	local bExist = CheckEffectFile(path)
	if bExist == true then
		local spine = WZUISpine:create()
		spine:setTouchEnable(false)
		spine:setFileJson(path..".json")
		spine:setFileAtlas(path..".atlas")
		spine:play(play_name, isLoop)
		spine:setRelativePosition(ccp)
		if data.tag then 
			spine:setTag(data.tag)
		end
		node:addChild(spine, zOrder)

		return spine
	else
		WZTempLog(path .. "文件不存在")
	end
end

--@brief 	发送领取任务奖励事件
function postGetTaskRewardEvent(taskId)
	-- body
	if taskId == 1110000001 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask1_1)
    elseif taskId == 1110000020 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask1_2)
    elseif taskId == 1110000021 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask1_3)
    elseif taskId == 1110000022 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask1_4)
    elseif taskId == 1110000023 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask1_5)
    elseif taskId == 1110000024 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask2_1)
    elseif taskId == 1110000025 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask2_2)
    elseif taskId == 1110000026 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask2_3)
    elseif taskId == 1110000027 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask2_4)
    elseif taskId == 1110000028 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask2_5)
    elseif taskId == 1110000029 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask2_6)
    elseif taskId == 1110000030 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask2_7)
    elseif taskId == 1110000031 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_finishTask2_8)
    elseif taskId == 1120000033 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_threeLvFinishTask)
    elseif taskId == 1110000002 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_fourLvFinishTask)
    elseif taskId == 1110000003 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_fourLvFinishTask2)
    elseif taskId == 1110000006 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_eightLvFinishTask)
    elseif taskId == 1110000010 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_tenLvFinishTask)
    elseif taskId == 1110000004 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_nineLvFinishEquipStrengthen)
    end
end

--@brief 	发送前往任务事件
function postGotoTaskEvent(taskId)
	-- body
	if taskId == 1110000020 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_oneLvGotoTask)
    elseif taskId == 1110000021 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy1_3)
    elseif taskId == 1110000022 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy1_4)
    elseif taskId == 1110000023 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy1_5)
    elseif taskId == 1110000024 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy2_1)
    elseif taskId == 1110000025 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy2_2)
    elseif taskId == 1110000026 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy2_3)
    elseif taskId == 1110000027 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy2_4)
    elseif taskId == 1110000028 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy2_5)
    elseif taskId == 1110000029 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy2_6)
    elseif taskId == 1110000030 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy2_7)
    elseif taskId == 1110000031 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy2_8)
    elseif taskId == 1110000003 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_fourLvGotoTask)
    elseif taskId == 1110000004 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_nineLvGotoTask2)
    end
end

--@brief 	根据等级设置vip的图标
function setVipIconByVipLevel(vipNode, vipLevel)
	-- body
	local iconPath = ""
	if vipLevel <= 15 then 
		iconPath = "ui/newvip/common_icon_hgg.png"
	elseif vipLevel > 15 and vipLevel <= 19 then 
        iconPath = "ui/newvip/common_icon_hgg_1.png"
	elseif vipLevel > 19 and vipLevel <= 22 then 
        iconPath = "ui/newvip/common_icon_hgg_2.png"
    elseif vipLevel > 22 then 
        iconPath = "ui/newvip/common_icon_hgg_3.png"
	end
	if vipNode then 
		vipNode:setFile(iconPath)
	else
		return iconPath
	end
end

--@brief 	根据性别获取礼包中的数据
function getItemsInGift(itemId)
	-- body
	local giftList = {}
	local sex = CacheCenter:getPlayerInfo().sex
	local sexIndex = {"man_item_id","woman_item_id"}
	for k,v in pairs(GDatatab_gifts) do
		if v.item_id == itemId then
			local temp = {}
			temp.id = v[sexIndex[sex+1]]
			temp.count = v["count"]
			temp.quality = GDatatab_item["id_"..v[sexIndex[sex+1]]].quality
			temp.main_type = GDatatab_item["id_"..v[sexIndex[sex+1]]].main_type
			temp.sub_type = GDatatab_item["id_"..v[sexIndex[sex+1]]].sub_type
			
			table.insert(giftList,temp)
		end
	end

	return giftList 
end

--@brief    进行权限申请-拍照存储
function checkPermission_photo()
    CCLuaLog("GlobalMethod:checkPermission_photo")
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if platForm ~= 2 then
        return 
    end
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
    	CCLuaLog("GlobalMethod:checkPermission_photo-2")
        local postData = {}
        postData.funType = "checkPermission_photo"
        local sJsonArg = json.encode(postData)
        curSdkObj:accountOthers(sJsonArg, nil, nil)
	end  
end

--@brief    进行权限申请-回调
function checkPermission_exist_callback(result,message,funType)
    WZLog("GlobalMethod:checkPermission_exist_callback", result, message, funType)
    if result == "true" then
    	WndPopupMenu:show()
    	if WndPopupMenu then
    		WZLog("GlobalMethod:checkPermission_exist_callback 1 - 1")    		
    	end
    elseif result == "false" then
    	local tips = ""
    	local tips1 = ""
    	local tips2 = ""
    	if LocalStrings.UPLOAD_IMAGE_PERMISSION then
    		tips1 = LocalStrings.UPLOAD_IMAGE_PERMISSION
    	end
    	if LocalStrings.UPLOAD_IMAGE_PERMISSION_1 then
    		tips2 = LocalStrings.UPLOAD_IMAGE_PERMISSION_1
    	end
    	tips = tips1
    	local result = string.find(message, "CAMERA")
    	if result == nil then 
    		tips = tips2
    	end
        WZLog("GlobalMethod:checkPermission_exist_callback tips result", tips, result)
    	--MsgBoxManager:showTipBox(tips)
    	local curSdkObj = PassportSdkManager:getCurSdkObj()
        if curSdkObj and funType == "requestPermission1" then
            --android - 交互打开弹窗
            CCLuaLog("GlobalMethod:checkPermission_exist_callback-2")
            local postData = {}
            postData.funType = "showDialog_Setting"
            postData.message = tips
            postData.title = ""
            postData.type = "1"
            postData.confirm = "前往设置"
            postData.cancel = "取消"
            --postData.funType = "showDialog"
            local sJsonArg = json.encode(postData)
            curSdkObj:accountOthers(sJsonArg, nil, nil)
            --self:Others(postData)
        end
    else

    end
end

--@brief    进行权限申请-检查权限
function checkPermission_exist()
    WZLog("GlobalMethod:checkPermission_exist")
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if platForm ~= 2 then
        return
    end
	local appVersion = WZDeviceInfo:appVersion()
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
        CCLuaLog("GlobalMethod:checkPermission_exist-2")
        local postData = {}
        postData.funType = "checkPermission_exist"
        postData.value = "android.permission.CAMERA,android.permission.WRITE_EXTERNAL_STORAGE,android.permission.READ_EXTERNAL_STORAGE"
        --20210805 NJL 版本号大于304检查权限时只检查相机
        if appVersion >= "3.0.4" then
	    	WZLog("GlobalMethod:checkPermission_exist appVersion >= 3.0.4")
        	postData.value = "android.permission.CAMERA"
		end
        local sJsonArg = json.encode(postData)
        curSdkObj:accountOthers(sJsonArg, nil, nil)
	end
end

--@brief    进入主城进行安卓权限申请
function requestPermission()
    --判断是否为android，版本号高于296才去检查权限，否则直接请求权限
    CCLuaLog("GlobalMethod:requestPermission")
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if platForm ~= 2 then
        return
    end
	local appVersion = WZDeviceInfo:appVersion()	
    WZLog("GlobalMethod:requestPermission appVersion:", appVersion)
	if appVersion < "2.9.6" then
    	WZLog("GlobalMethod:requestPermission appVersion < 2.9.6")
    	checkPermission_photo()--请求权限
		return
	end
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
    	local config = curSdkObj.m_tConfig
        if config then
        	--判断sdk配置是否包含checkPermission字段,否则直接请求权限
            if config.SDKOtherConfig.checkPermission == "true" then
            	WndPopupMenu:disappear()
		        --android
		        CCLuaLog("GlobalMethod:requestPermission-2")
		        --curSdkObj:setCallbackByName("others",PassportSdkManager.getGoogleAdIdCallback, PassportSdkManager)
		        local postData = {}
		        postData.funType = "requestPermission"
		        postData.value = "android.permission.CAMERA,android.permission.WRITE_EXTERNAL_STORAGE,android.permission.READ_EXTERNAL_STORAGE"
		        --20210805 NJL 版本号大于304检查权限时只检查相机
		        if appVersion >= "3.0.4" then
			    	WZLog("GlobalMethod:requestPermission appVersion >= 3.0.4")
		        	postData.value = "android.permission.CAMERA"
				end
		        local sJsonArg = json.encode(postData)
		        curSdkObj:accountOthers(sJsonArg, nil, nil)
		        --self:Others(postData)
		    else
		    	checkPermission_photo()--请求权限
		    end
		end
    end
end

--brief 	判断聊天内容里面是否有未满足使用条件的专属表情
function HaveLimitFace(str)
	-- body
	WZLog("HaveLimitFace =",str)
	local bIsHaveLimitFace = false 

	if string.gsub(str," ","") == "" then
		return bIsHaveLimitFace
	end

	str = string.gsub(str,"<","&lt;")
	str = string.gsub(str,">","&gt;")

	local char = str

	local tempTable = {}
	local startIndex = 1
	local len = string.len(str)
	if WndChat == nil then
		return str
	end
	for i,v in pairs(WndChat.FACEIMASK) do
		for j=1,len do
			local strIndex = string.find(char,v,j)
			if strIndex ~= nil then
				local bExit = false
				for n,m in ipairs(tempTable) do
					if m == strIndex then
						bExit = true
					end
				end
				if not bExit then
					table.insert(tempTable,strIndex)
				end
			end
		end
	end

	table.sort(tempTable,function (a,b)
		if a < b then
			return true
		end
		return false
	end)
	if #tempTable > 0 then --有表情
		for i,v in ipairs(tempTable) do --循环拼接富文本
			startIndex = v + 3
			local tempSt=  string.sub(char,v,v+2)

			for j,k in pairs(WndChat.FACEIMASK) do
				if tempSt == k then
					if not WndChat:_canUseFace(j) then 
						bIsHaveLimitFace = true 
						if WndChat.FACELIMIT[j] and WndChat.FACELIMIT[j][1] == 1 then 
							MsgBoxManager:showTipBox(string.format(LocalStrings.VIP_FACE_MSG, WndChat.FACELIMIT[j][2]))
						end
						return bIsHaveLimitFace
					end
				end
			end
		end
	end

	return bIsHaveLimitFace 
end

--@brief    创建富文本
--@param    tLabel:文本列表
--@return	txt:返回文本节点
--@note		tLabel.desc  	--内容
--@note		tLabel.fontSize --字体大小
--@note		tLabel.pt    	--相对位置
--@note		tLabel.color 	--颜色
--@note		tLabel.anchorPt	--锚点
function createFreeTextBox(desc, pt, anchor, maxWidth)
	pt = pt or ccp(0.5,0.5)
	anchor = anchor or ccp(0.5,1)--默认锚点
	maxWidth = maxWidth or 500
	local txt = WZUIFreeTextBox:create()
	txt:setMaxWidth(maxWidth)
	txt:setShowText(desc) 			 --内容
	txt:setRelativePosition(pt) --相对位置
	txt:setAnchorPoint(anchor) 		 --锚点

	return txt
end
--崛起之路的选择礼包数据保存
function setRiseChooseGiftData(_type)
	g_tRiseChooseGiftType = _type
end
function getRiseChooseGiftData()
	if g_tRiseChooseGiftType and g_tRiseChooseGifyData[g_tRiseChooseGiftType] then
		g_tRiseChooseGifyData[g_tRiseChooseGiftType] = {}
	end
end

--@brief 	解析活动的奖励
--@param 	data:奖励配置
function analyzeActivityReward(data)
	-- body
	local temp = {}
	for i=1, #data do
		local tab = {}
		local array = SplitStringWithSeparator(data[i],"rank:")
		for j=1,#array do
			if j > 1 then
				local start1,endpos1 = string.find(array[j], ",reward:", 1)
				local sub1 = string.sub(array[j], 1, start1-1)
				local sub1 = string.sub(sub1,2,-2)
				local rank1 = SplitStringWithSeparator(sub1,",")[1]
				local rank2 = SplitStringWithSeparator(sub1,",")[2]
				tab.rank1 = rank1
				tab.rank2 = rank2
				local sub2 = string.sub(array[j], endpos1+1)
				tab.ids, tab.nums = SplitItemString(sub2)
			end
		end
		temp[i] = tab
	end

	return temp
end

--brief 	获取聊天内容里面需要调整宽度的表情数量
function getLimitFaceNum(str)
	-- body
	WZLog("getLimitFaceNum =",str)
	local tSpecialFace = {}

	if string.gsub(str," ","") == "" then
		return tSpecialFace
	end

	str = string.gsub(str,"<","&lt;")
	str = string.gsub(str,">","&gt;")

	local char = str

	local tempTable = {}
	local startIndex = 1
	local len = string.len(str)
	if WndChat == nil then
		return str
	end
	for i,v in pairs(WndChat.FACEIMASK) do
		for j=1,len do
			local strIndex = string.find(char,v,j)
			if strIndex ~= nil then
				local bExit = false
				for n,m in ipairs(tempTable) do
					if m == strIndex then
						bExit = true
					end
				end
				if not bExit then
					table.insert(tempTable,strIndex)
				end
			end
		end
	end

	table.sort(tempTable,function (a,b)
		if a < b then
			return true
		end
		return false
	end)
	if #tempTable > 0 then --有表情
		for i,v in ipairs(tempTable) do --循环拼接富文本
			startIndex = v + 3
			local tempSt=  string.sub(char,v,v+2)
			-- local faceLimit = GetChatFaceLimit()
			for j,k in pairs(WndChat.FACEIMASK) do
				if tempSt == k then
					tSpecialFace[j] = tSpecialFace[j] or 0
					if j == 32 or j == 33 or j == 34 or j == 35 or j == 41 or j == 42 or j == 43 or j == 45 or j == 47 or j == 48 then 
						tSpecialFace[j] = tSpecialFace[j] + 1
					end
				end
			end
		end
	end

	return tSpecialFace
end

--@brief 	是否新服专属活动
function wetherNewServerActivity(nActivityType)
	-- body
	local tNewServerActivityList = {5004,3025,3026,5005,5007,5010,6121,7003,7022,7032}

	if utilsValueInTable(nActivityType, tNewServerActivityList) then
		return true 
	end

	return false 
end

--@brief    是否使用GME语音
function isUseGMEVoiceEngine()
	if WGMEVoiceNotify then
		return true
	end
	return false
end

--@brief 	是否要显示限时
function wetherTimeLimitActivity(nActivityType)
	-- body
	local tNewServerActivityList = {7066}

	if utilsValueInTable(nActivityType, tNewServerActivityList) then
		return true 
	end

	return false 
end

--@brief    商业埋点
--@param 	byDate: 是否每日触发
function SendBusinessCode(nType, actInfo, byDate)
	WZLog("SendBusinessCode", nType, actInfo)
	if g_tBusinessCode == nil then 
		local tempString = string.format(BUSINESSCODE_FILENAME, CacheCenter:getPlayerInfo().id)
		g_tBusinessCode = ReadFileToTable(tempString, "ddd2", false)
	end
	if g_tBusinessCode == nil or type(g_tBusinessCode) ~= "table" then
		g_tBusinessCode = {}
	end
	--@brief 检测是否需要post
	local function _check(nEventId, byDate)
		if g_tBusinessCode == nil or type(g_tBusinessCode) ~= "table" then 
			g_tBusinessCode = {}
			return true
		end
		if byDate then 
			local serverTime = SystemTime:getServerTime()
			local timeTemp = os.date("*t", serverTime)
			local dateString = timeTemp.year .. timeTemp.month .. timeTemp.day
			if g_tBusinessCode[tostring(nEventId)] == nil then 
				return true 
			elseif g_tBusinessCode[tostring(nEventId)] ~= dateString then 
				return true 
			end

			return false 
		end
		return g_tBusinessCode[tostring(nEventId)] == nil
	end

	--@brief 记录发送的次数
	local function _record(nEventId, byDate)
	    WZLog("_record", nEventId)
		if nEventId then
			local tempString = string.format(BUSINESSCODE_FILENAME, CacheCenter:getPlayerInfo().id)
			local value = 1
			if byDate then 
				local serverTime = SystemTime:getServerTime()
				local timeTemp = os.date("*t", serverTime)
				local dateString = timeTemp.year .. timeTemp.month .. timeTemp.day

				value = dateString
			end
			g_tBusinessCode[tostring(nEventId)] = value
	        WriteTableToFile(g_tBusinessCode, tempString, "ddd2", false)
	        WZLog("_record finished", Serialize(g_tBusinessCode))
		end
	end

	if not _check(nType .. "_" .. actInfo, byDate) then 
		return 
	end
	_record(nType .. "_" .. actInfo, byDate)
	ProtocolProcessorGlobal:send_PLAYER2_LogOpenAct(nType, actInfo)
end

-- 判断utf8字符byte长度
-- 0xxxxxxx - 1 byte
-- 110yxxxx - 192, 2 byte
-- 1110yyyy - 225, 3 byte
-- 11110zzz - 240, 4 byte
function chsize(char)
	if not char then
		print("not char")
		return 0
	elseif char > 240 then
		return 4
	elseif char > 225 then
		return 3
	elseif char > 192 then
		return 2
	else
		return 1
	end
end
 
-- 计算utf8字符串字符数, 各种字符都按一个字符计算
-- 例如utf8len("1你好") => 3
function utf8len(str)
	local len = 0
	local currentIndex = 1
	while currentIndex <= #str do
		local char = string.byte(str, currentIndex)
		currentIndex = currentIndex + chsize(char)
		len = len +1
	end
	return len
end
 
-- 截取utf8 字符串
-- str:			要截取的字符串
-- startChar:	开始字符下标,从1开始
-- numChars:	要截取的字符长度
function utf8sub(str, startChar, numChars)
	local startIndex = 1
	while startChar > 1 do
		local char = string.byte(str, startIndex)
		startIndex = startIndex + chsize(char)
		startChar = startChar - 1
	end
 
	local currentIndex = startIndex
 
	while numChars > 0 and currentIndex <= #str do
		local char = string.byte(str, currentIndex)
		currentIndex = currentIndex + chsize(char)
		numChars = numChars -1
	end
	return str:sub(startIndex, currentIndex - 1)
end

--==============================--
--desc:延时执行
function delayTimer(func, time)
    local timer_id
    timer_id = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
        if timer_id then    -- 撤销定时器
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timer_id)
            timer_id = nil
        end
        func()
    end, time, false)
end

--@brief	获取当前经验的string(防止变成科学计数法)
function GetCurExpStr(nCurExp)
    local curExpFormat = tostring(nCurExp)
    if tonumber(nCurExp) < 100000000 then 
    	curExpFormat = tostring(nCurExp)
    elseif tonumber(nCurExp) >= 100000000 and tonumber(nCurExp) <= 999999999 then 
        curExpFormat = string.format("%9d", tonumber(nCurExp))
    elseif tonumber(nCurExp) >= 1000000000 and tonumber(nCurExp) <= 9999999999 then 
        curExpFormat = string.format("%10d", tonumber(nCurExp))
    else
        curExpFormat = string.format("%11d", tonumber(nCurExp))
    end
    
    return curExpFormat
end

--@brief 	当前渠道是否关闭创角
function whetherCloseCreateRole()
	-- body
	if g_tCloseCreateRoleChannel == nil then return false end
	
	for i = 1, GetTableLen(g_tCloseCreateRoleChannel) do 
		if tostring(ProjConfig:getChannelId()) == g_tCloseCreateRoleChannel[i] then 
			return true
		end
	end

	return false 
end

function GetDownloadInfo(sIndex, aninName)
	WZLog("GetDownloadInfo zero", sIndex)
	-- local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig.xml"
 --    local ConfigExist = WZDataFile:getInstance():checkFileExist(path)
	-- if not GlobalGame.g_xmlDoc and ConfigExist then
	-- 	GlobalGame.g_xmlDoc = WZDataFile:getInstance():createXmlDocument(path)
	-- 	GlobalGame.g_xmlDoc:retain()
	-- end
 --    local sAnimName = aninName 
	-- if ConfigExist then
	-- 	--local xmlDoc = WZDataFile:getInstance():createXmlDocument(path)
	-- 	--没有下载配置文件成功，直接返回
	-- 	if not GlobalGame.g_xmlDoc then return nil end
 --    	local rootElement = GlobalGame.g_xmlDoc:getRootElement()
 --    	local xmlName = "File"
 --    	local element = rootElement:findChildElement(xmlName)
	-- 	while element do
 --    	    local index = element:attributeString("index")
 --    	    local sex = element:attributeString("sex")
	-- 		if index == tostring(sIndex) and sex == sAnimName then
	-- 			local downloadInfo = {}
 --    	        downloadInfo.url = element:attributeString("url")
 --    	        downloadInfo.md5 = element:attributeString("md5")
 --    	        WZLog("GetDownloadInfo one",downloadInfo.url,downloadInfo.md5,index)
	-- 			return downloadInfo
	-- 		end
 --    	    element = element:nextSiblingElement(xmlName)
 --    	end
	-- end
	return nil
end

--@brief 	动态下载资源回调
function DownloadResourceCallback(taskId,extraData,failed)
	WZLog("DownloadResourceCallback", taskId, extraData, failed)
end

--@brief 	设置QQ大厅蓝钻图标
--@param 	qqHallData:蓝钻数据   {is_blue_vip=false, is_blue_year_vip=false, blue_vip_level=8, is_super_blue_vip=false}
--@param 	tBlueNodeName[1]:蓝钻图标节点名字
--@param 	tBlueNodeName[2]:年费图标节点名字
--@param 	tNodeChangePos:需要调整坐标的节点的名字
--@param 	tNodeType:tNodeChangePos对应的节点类型
function SetQQHallBlueIcon(element, qqHallData, tBlueNodeName, tNodeChangePos, tNodeType, addGapping)
	addGapping = addGapping or 0
	if tonumber(ProjConfig:getChannelId()) ~= 1118 then return end 

	local imgQQBlue = GetElement(element, tBlueNodeName[1], WZUIImage)
    local imgQQYear = GetElement(element, tBlueNodeName[2], WZUIImage)
    local nAddPosX = 0 
	if qqHallData then 
        if qqHallData.is_blue_vip or qqHallData.is_super_blue_vip then 
            nAddPosX = nAddPosX + addGapping
            if qqHallData.is_super_blue_vip and imgQQBlue then 
                imgQQBlue:setFile("ui/qqHall/hh_" .. qqHallData.blue_vip_level .. ".png")
            elseif imgQQBlue then 
                imgQQBlue:setFile("ui/qqHall/pz_" .. qqHallData.blue_vip_level .. ".png")
            end
            if qqHallData.is_blue_year_vip and imgQQYear then 
                nAddPosX = nAddPosX + addGapping
                imgQQYear:setFile("ui/qqHall/nian.png")
            elseif imgQQYear then 
                imgQQYear:setFile("")
            end

            if tNodeChangePos then 
	            for i = 1, #tNodeChangePos do
	            	local nodeTemp = GetElement(element, tNodeChangePos[i], tNodeType[i])
	            	if nodeTemp then 
	            		local nodePos = nodeTemp:getRelativePosition()
	            		nodeTemp:setRelativePosition(GlobalMethod:ccp(nodePos.x + nAddPosX, nodePos.y))
	            	end
	            end
	        end
        elseif imgQQBlue then 
            imgQQBlue:setFile("")
        end
    end
end

--@brief 	动态创建玩家等级、名字、QQ蓝钻图标
function CreatePlayerLvNameAndBlueIcon(parentNode, relativePt, level, lvColor, lvStrokeColor, lvSize, qqHallData, name, nameColor, nameStrokeColor, nameSize)
	--创建容器放玩家职业图标、蓝钻特权和年费图标、玩家名字
    local conName = WZUIContainer:create()
    conName:setUseAbsSize(true)
    conName:setAbsContentSize(GlobalMethod:CCSize(100, 40))
    conName:setRelativePositionLuaTo(relativePt[1], relativePt[2])
    parentNode:addChild(conName)
    local namePosX = 0 
    --添加职业图标

    if level ~= nil then
        local ttfLv = WZUILabelTTF:create()
	    ttfLv:setText(LocalStrings.LV .. level)
	    ttfLv:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	    --Modify By Tianxiang_Xu
	    ttfLv:setColor(lvColor)
	    if lvStrokeColor then 
		    ttfLv:setEnableStroke(true)
		    ttfLv:setStrokeColor(lvStrokeColor)
		    ttfLv:setStrokeSize(4)
		end
	    ttfLv:setFontSize(lvSize)
	    ttfLv:setUseAbsCoordinate(true)
	    ttfLv:setAbsPosition(GlobalMethod:ccp(namePosX, 20))
	    conName:addChild(ttfLv)
	    local nameSize = ttfLv:getContentSize()

	    namePosX = namePosX + nameSize.width + 5
    end

    local bShowQQInfo = true 
    if tonumber(ProjConfig:getChannelId()) ~= 1118 then 
    	bShowQQInfo = false 
    end 
    if qqHallData and bShowQQInfo then 
        if qqHallData.is_blue_vip or qqHallData.is_super_blue_vip then 
	        local imgQQBlue = WZUIImage:create()
	        imgQQBlue:setUseOriginSize(true)
	        imgQQBlue:setScale(0.6)
	        imgQQBlue:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
	        imgQQBlue:setUseAbsCoordinate(true)
	        imgQQBlue:setAbsPosition(GlobalMethod:ccp(namePosX, 20))
	        conName:addChild(imgQQBlue)
            if qqHallData.is_super_blue_vip then 
                imgQQBlue:setFile("ui/qqHall/hh_" .. qqHallData.blue_vip_level .. ".png")
            else
                imgQQBlue:setFile("ui/qqHall/pz_" .. qqHallData.blue_vip_level .. ".png")
            end
            namePosX = namePosX + 30
            if qqHallData.is_blue_year_vip then 
		        local imgQQYear = WZUIImage:create()
                imgQQYear:setFile("ui/qqHall/nian.png")
		        imgQQYear:setUseOriginSize(true)
		        imgQQYear:setScale(0.6)
		        imgQQYear:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
		        imgQQYear:setUseAbsCoordinate(true)
		        imgQQYear:setAbsPosition(GlobalMethod:ccp(namePosX, 20))
		        conName:addChild(imgQQYear)
                namePosX = namePosX + 30
            end
        end
    end
    if name then 
	    local ttfName = WZUILabelTTF:create()
	    ttfName:setText(name)
	    ttfName:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	    --Modify By Tianxiang_Xu
	    if nameStrokeColor then 
		    ttfName:setEnableStroke(true)
		    ttfName:setStrokeColor(nameStrokeColor)
		    ttfName:setStrokeSize(4)
		end
		ttfName:setColor(nameColor)
	    ttfName:setFontSize(nameSize)
	    ttfName:setUseAbsCoordinate(true)
	    ttfName:setAbsPosition(GlobalMethod:ccp(namePosX, 20))
	    conName:addChild(ttfName)
	    local nameSize = ttfName:getContentSize()
	    namePosX = namePosX + nameSize.width
	end
    conName:setAbsContentSize(GlobalMethod:CCSize(namePosX, 40))
    conName:updateRelativeSize()
end

--@brief 	屏蔽掉大于等于8位数的数字
function shieldQQQunNum(words)
	local newWords, nCount = string.gsub(words, "%d", "X")
	if nCount and nCount >= 8 then 
		return newWords
	end
	return nil 
end

--@brief 	适配玩家上传照片，防止超框
function adaptPhoto(imgSpaceView)
	local sizeContent = imgSpaceView:getContentSize()
	local screenSize = CCEGLView:sharedOpenGLView():getDesignResolutionSize()
	local hScale = sizeContent.height / screenSize.height
	local wScale = sizeContent.width / screenSize.width
	WZLog("adaptPhotoadaptPhoto", sizeContent.width, sizeContent.height, hScale, wScale)
	if hScale > 1 or wScale > 1 then 
		local maxScale = math.max(hScale, wScale)
		imgSpaceView:setScale(1/maxScale)
	end
end

--@brief    添加保存是否该活动的首次抽奖
function SaveOperateTimes(ActivityKey, activityId)
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = ActivityKey .. tostring(CacheCenter:getPlayerInfo().id)
   
    local curValue = activityId
    data:setStringValue("CALABASH_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取是否该活动的首次抽奖
--@return 	1:非首次抽奖；0首次抽奖
function GetOperateTimes(ActivityKey, activityId)
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = ActivityKey .. tostring(CacheCenter:getPlayerInfo().id)
    
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" and tonumber(strValue) == activityId then 
		return 1
	else
		return 0
	end
end

--@brief    添加保存某活动上次选择的模式
--@param 	ActivityKey:key
--@param 	modeType:需要保存的值
function SaveActivityPoleType(ActivityKey, modeType)
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = ActivityKey .. tostring(CacheCenter:getPlayerInfo().id)
    local curValue = modeType
    data:setStringValue("CALABASH_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取上次保存的模式
function GetActivityPoleType(ActivityKey)
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = ActivityKey .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" then 
		return tonumber(strValue)
	end

	return 0 
end

--@brief 	加载图集资源
function LoadNewActivityRes(bAdd)
	if bAdd then 
		if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_0.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/newActivity/pack_newActivity_0.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_1.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/newActivity/pack_newActivity_1.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_2.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/newActivity/pack_newActivity_2.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_3.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/newActivity/pack_newActivity_3.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_4.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/newActivity/pack_newActivity_4.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_5.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/newActivity/pack_newActivity_5.plist")
	    end
	else
		if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_0.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/newActivity/pack_newActivity_0.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_1.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/newActivity/pack_newActivity_1.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_2.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/newActivity/pack_newActivity_2.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_3.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/newActivity/pack_newActivity_3.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_4.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/newActivity/pack_newActivity_4.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_5.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/newActivity/pack_newActivity_5.plist")
	    end
	end
	LoadActivityWordsRes(bAdd)
end

--@brief 	加载图集资源
function LoadActivityWordsRes(bAdd)
	if bAdd then 
		if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_0.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/activityWords/pack_activityWords_0.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_1.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/activityWords/pack_activityWords_1.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_2.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/activityWords/pack_activityWords_2.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_3.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/activityWords/pack_activityWords_3.plist")
	    end
	else
		if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_0.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/activityWords/pack_activityWords_0.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_1.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/activityWords/pack_activityWords_1.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_2.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/activityWords/pack_activityWords_2.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_3.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/activityWords/pack_activityWords_3.plist")
	    end
	end
end

function GetLimitData(soldNum, limitNum, dailyLimit, dailyBuyNum)
	local visible = false
	local str_title, num1, num2 = "",0,0
	local str = [[%s:%d/%d]]
	if limitNum == -1 and dailyLimit == -1 then
		visible = false
		num1,num2 = 0,1
	elseif limitNum ~= -1 and dailyLimit ~= -1 then
		visible = true
		str_title = LocalStrings.SHOP_LIMIT_TITLE
		num1 = soldNum
		num2 = limitNum
	elseif limitNum == -1 and dailyLimit ~= -1 then
		visible = true
		str_title = LocalStrings.WATERMELON_TEXT1[25]
		num1 = dailyBuyNum
		num2 = dailyLimit
	elseif limitNum ~= -1 and dailyLimit == -1 then
		visible = true
		str_title = LocalStrings.SHOP_LIMIT_TITLE
		num1 = soldNum
		num2 = limitNum
	end
	local strLimit = string.format(str,str_title, num1, num2)
	local bIsSoldOut = false 
	if num1 >= num2 then
		bIsSoldOut = true
	end
	return visible, strLimit, bIsSoldOut
end

--@brief 	检测特效文件是否存在
--@param 	bIsDragonBone:是否骨骼动画
--@param 	bIsLizi:是否粒子特效
function CheckEffectFile(path, bIsDragonBone, bIsLizi)
	if bIsDragonBone then 
		local bIsExist = WZDataFile:getInstance():checkFileExist(path .. ".xml")
		if bIsExist then 
			bIsExist = WZDataFile:getInstance():checkFileExist(path .. ".plist")
		end
		if bIsExist then 
			bIsExist = WZDataFile:getInstance():checkFileExist(path .. ".png")
		end

		return bIsExist
	elseif bIsLizi then 
		local bIsExist = WZDataFile:getInstance():checkFileExist(path .. ".plist")
		if bIsExist then 
			bIsExist = WZDataFile:getInstance():checkFileExist(path .. ".png")
		end

		return bIsExist
	else
		local bIsExist = WZFileUtil:isFileExist(path .. ".json")
		if bIsExist then 
			bIsExist = WZFileUtil:isFileExist(path .. ".atlas")
		end
		if bIsExist then 
			bIsExist = WZFileUtil:isFileExist(path .. ".png")
		end
		--添加判断有多张图集的情况
		if bIsExist then 
			local pngNum = GetSpinePngNum(path)
			WZLog("CheckEffectFile", path, pngNum)
			if pngNum and pngNum > 1 then 
				for i = 2, pngNum do
					bIsExist = WZFileUtil:isFileExist(path .. i .. ".png")
					if not bIsExist then 
						break 
					end
				end
			end
		end

		return bIsExist
	end
end

--@brief 	如果玩家尚未评分，满足条件，弹评分界面
function ShowStoreRating()
	local praiseRewardStatus = CacheCenter:getPlayerInfo().praiseRewardStatus
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	local praiseRewardOpen = tonumber(CacheCenter:getGameParam().praiseRewardStatus)
	if praiseRewardOpen == 1 then 
		if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.isStoreRating == "true" then 
			if ProjConfig.LANGUAGE == "vn" and praiseRewardStatus == 0 and WndSweep then 
				WndSweep:showInterface() 
			end
		end
	end
end
-------------------------------------私有方法模块End---------------------------------------

-- 判断是否为qq大厅
function isChannelQQHall()
    local channelId = ProjConfig:getChannelId()
    if WZUISystem:getInstance():getPlatformInfo() == 3 and channelId == 1118 then
        return true
    end
    return false
end

-- 判断是否为Flash大厅
function isChannelFlashHall()
    local channelId = ProjConfig:getChannelId()
    if WZUISystem:getInstance():getPlatformInfo() == 3 and channelId == 1119 then
        return true
    end
    return false
end

-- 判断是否为360大厅
function isChannel360Hall()
    local channelId = ProjConfig:getChannelId()
    if WZUISystem:getInstance():getPlatformInfo() == 3 and channelId == 1120 then
        return true
    end
    return false
end

-- 判断是否为PC渠道
function isChannelPC()
    if isChannelQQHall() or isChannelFlashHall() or isChannel360Hall() then
        return true
    end
    return false
end

-- 是否登录时进入消消乐特殊处理
function isYLGYLoginChannel()
	do return false end

    local channelId = ProjConfig:getChannelId()
    if WZUISystem:getInstance():getPlatformInfo() == 1 then
        return true
    end
    return false
end

-- qq大厅下win32的editbox样式(0:老样式 1:新加的输入框样式)
-- 引擎端调用以设置默认样式
function GlobalMethod:getGBoxStyle()
    return 1
end

-- qq大厅下win32的editbox样式(0:老样式 1:新加的输入框样式)
-- 引擎端调用以设置默认样式
function GlobalMethod:qqHallCheckDownloadResAllFinish()
	CCLog("GlobalMethod:qqHallCheckDownloadResAllFinish ---- ")
    -- if isChannelQQHall() and GlobalMethod and GlobalMethod:qqHallCheckDownloadResAllFinish() == false then
    --     WZLog("WndDownLoad:checkIsNeedUpdate()")
    --     return
    -- end
	if isChannelPC() == false then
		return true
	end
	local userData = WZDataFile:getInstance():getUserData()
	if userData and ProjConfig then
		local isFinish = userData:getStringValue("DownloadCache_"..ProjConfig.INSTALLVERSION, "isFinish") or "0"
		if isFinish == "1" or isFinish == "true" then
			return true
		end
		local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig_All.xml"
	    local ConfigExist = WZDataFile:getInstance():checkFileExist(path)
	    if not ConfigExist then
	    	return false
	    end
		if not GlobalGame.g_xmlDoc_All then
			GlobalGame.g_xmlDoc_All = WZDataFile:getInstance():createXmlDocument(path)
			GlobalGame.g_xmlDoc_All:retain()
		end
		--没有下载配置文件成功，直接返回
		if not GlobalGame.g_xmlDoc_All then 
			return false 
		end
		isFinish = "1"
    	local rootElement = GlobalGame.g_xmlDoc_All:getRootElement()
    	local xmlName = "File"
    	local element = rootElement:findChildElement(xmlName)
		while element do
    	    local index = element:attributeString("index")
    	    local sex = element:attributeString("sex")
    	    local md5 = element:attributeString("md5")
			local downloadCache = userData:getStringValue("DownloadCache_"..ProjConfig.INSTALLVERSION, sex..'_'..index)
			if downloadCache == nil or downloadCache ~= md5 then
				CCLog("qqHallCheckDownloadResAllFinish ---- ", sex, index)
				if tonumber(index) ~= 0 then
					isFinish = "0"
				end
			else				
				WZLog("qqHallCheckDownloadResAllFinish ---- downloaded -> ", sex.."_"..index..'#'..md5)
			end
			
    	    element = element:nextSiblingElement(xmlName)
    	end
		CCLog("qqHallCheckDownloadResAllFinish ---- isFinish", isFinish)
		userData:setStringValue("DownloadCache_"..ProjConfig.INSTALLVERSION, "isFinish", isFinish)       
   		userData:flush()
    	return isFinish
	end
	return false
end

--全角转半角
function fullToHalf(str)
    local newStr = ""
    local pos = 1
    while pos <= #str do
    	local oneCount = getOneCount(string.byte(str, pos))
    	local nextStr = ""
--    	WZLog("fullToHalffullToHalffullToHalf One", oneCount)
    	if oneCount == 3 then 
    		local char = string.sub(str, pos, pos+2)
    		local unicodeNum = utf8ToNum(char)
--    		WZLog("fullToHalffullToHalffullToHalf Two", unicodeNum)
    		if unicodeNum == 12288 then --全角空格
    			unicodeNum = 32
    			nextStr = string.char(unicodeNum)
    			pos = pos + oneCount
    		elseif unicodeNum >= 65281 and unicodeNum <= 65374 then  --其他全角字符
    			unicodeNum = unicodeNum - 65248
    			nextStr = string.char(unicodeNum)
    			pos = pos + oneCount
    		elseif unicodeNum >= 9312 and unicodeNum <= 9321 then 
    			unicodeNum = unicodeNum - 9263
    			nextStr = string.char(unicodeNum)
    			pos = pos + oneCount
    		elseif unicodeNum >= 9332 and unicodeNum <= 9351 then 
    			unicodeNum = unicodeNum - 9283
    			nextStr = string.char(unicodeNum)
    			pos = pos + oneCount
    		elseif unicodeNum >= 9352 and unicodeNum <= 9371 then 
    			unicodeNum = unicodeNum - 9303
    			nextStr = string.char(unicodeNum)
    			pos = pos + oneCount
    		else
    			nextStr = string.sub(str, pos, pos)
    			pos = pos + 1
    		end
    	else
    		nextStr = string.sub(str, pos, pos)
    		pos = pos + 1
    	end
    	newStr = newStr .. nextStr
    end

    return newStr
end

function utf8ToNum(char)
    local num = 0
    local pos = 1
    while pos <= #char do
    	local oneCount = getOneCount(string.byte(char, pos))
    	if oneCount < 1 then 
    		num = string.byte(char, pos)
    		oneCount = 1
    	else
    		local boundary = 8
    		local i = oneCount + 1
    		while i < boundary * oneCount do
    			if i % 8 == 0 then --8位后处理下一字节，根据编码规则跳过首两位
    				i = i + 2
    			end
    			local weiCount = boundary - i % boundary --一个字节的剩余位数
    			local val1 = 2^(weiCount - 1)
    			local val2 = string.byte(char, pos + math.floor(i/boundary)) --获取当前字节
    			local newNum = num * 2
    			if BattleUtil:bitAnd(val1, val2) ~= 0 then 
    				if newNum % 2 == 0 then 
    					num = newNum + 1
    				else
    					num = newNum
    				end
    			else
    				num = newNum
    			end
    			i = i + 1
    		end
    	end
    	pos = pos + oneCount
    end

    return num 
end

--获取一个字节中，从高位开始连续的1的个数
function getOneCount(num)
	if num == nil then 
		return -1
	end
	local count = 0
	while BattleUtil:bitAnd(num,0x80) ~= 0 do --与10000000进行与操作判断最高位是否位1
		count = count + 1

		--左移一位
		num = (num - 2^7)*2
	end

	return count
end

--@brief 	用于限制特定时间某些功能禁用
function judgeWetherForbid()
	local bIsForbid = false 
	local curDate = SystemTime:getTimeTabelByServerTimestamp(SystemTime:getServerTime())
	if tonumber(curDate.year) == 2023 and tonumber(curDate.month) == 11 and tonumber(curDate.day) >= 2 and tonumber(curDate.day) < 3 then 
		bIsForbid = true 
		MsgBoxManager:showTipBox(LocalStrings.DRESSGIVE_TEXT1[5])
	end

	return bIsForbid
end

--@brief    显示夫妻互动动画
function ShowCoupleAni(node, bShow, pos, scale)
    if not node then
        return
    end
    pos = pos or GlobalMethod:ccp(0.5,1.7)
    scale = scale or 1

    if bShow then
        if not node:getChildByTag(-1001) then
        	local spinePath = "ui/otherUI/ui_feiwen_01"
			local existSpine = CheckEffectFile(spinePath)
			if existSpine then 
	            local spine = WZUISpine:create()
	            spine:setTouchEnable(false)
	            spine:setTouchSwallow(false)
	            spine:setFileJson(spinePath .. ".json")
	            spine:setFileAtlas(spinePath .. ".atlas")
	            spine:play("wait",true)
	            spine:setUseOriginSize(true)
	            spine:setRelativePosition(pos)
	            spine:setScale(scale)
	            node:addChild(spine,2)
	            spine:setVisible(true)
	            spine:setTag(-1001)
	        end
        end
    else
        if node:getChildByTag(-1001) then
            node:removeChildByTag(-1001,true)
        end
    end
end

--@brief    打印程序执行到哪行
--@note     会影响效率,查bug的时候用
--@param    bFlag 默认为开启打印行号 false:关闭打印行号
function OpenPrintLine(bFlag)
	if ProjConfig.DEBUG ~= 1 then
		return
	end
	
	bFlag = bFlag or true
	local mask = "l"
	if bFlag == false then
		mask = ""
	end
	debug.sethook(function (event, line)
		WZLog(debug.getinfo(2).short_src .. ":" .. line)
	end,mask)
end

--@brief	判断皮肤是否已拥有，或者对应升品皮肤已拥有
--@param	itemId:皮肤卡的itemId
--@param	已拥有返回true
function checkOwnPhantom(itemId)
	WZLog("checkOwnPhantom", itemId)
    local tBasicInfo = GDatatab_item["id_" .. itemId]
	if tBasicInfo.main_type ~= 20 then
		WZLog(tBasicInfo.name.."不是皮肤卡")
		return false
	end

	local tProperty = tBasicInfo.property
	local ownSkin = CacheCenter:getPlayerInfo().shape
	local nOwnCount = #ownSkin
	local bIsOwn = false 
	if nOwnCount > 0 then 
		for i = 1, #tProperty do
			local configData = GDatatab_shape_skins["id_" .. tProperty[i][1]]
			for j, value in pairs(ownSkin) do
				local ownData = json.decode(value)
				if tonumber(ownData.shapeId) == tProperty[i][1] then 
					bIsOwn = true  
					break 
				end 
			end
			if not bIsOwn then 
				local tempValue 
				local nextShape = configData.next_shape
				while nextShape ~= -1 do
					configData = GDatatab_shape_skins["id_" .. nextShape]
					for j, value in pairs(ownSkin) do
						local ownData = json.decode(value)
						nextShape = configData.next_shape
						if tonumber(ownData.shapeId) == configData.id then 
							bIsOwn = true  
							break 
						end 
					end
					if bIsOwn then 
						break 
					end
				end
			else
				break 
			end
		end
	end

	return bIsOwn
end


--@brief 	整合物品数据 把{{1,1},{1,1}}变成{1,2}
function consolidateItemData(tData)
	local tItemList = {}
	local tempData = {}
	for i=1,#tData do
		if tempData[tData[i][1]] == nil then
			tempData[tData[i][1]] = tData[i][2]
		else
			tempData[tData[i][1]] = tempData[tData[i][1]] + tData[i][2]
		end
	end
	for k,v in pairs(tempData) do
		table.insert(tItemList,{k,v})
	end
	return tItemList
end

--@brief    检查字符串是否有空格,有的话就把空格
--@param    sContent 要检测的字符串
--@return    bIsExistSpace 是否发现空格
--@return    tmpStr 如果检查到有空格就把空格去掉再返回
function checkBlankSpace(sContent)
	if ProjConfig.LANGUAGE == "vn" then
		return false, sContent
	end
    local tmpStr = sContent
    local strSpace = {" ","　","ㅤ"} --用来匹配的空格
    local bIsExistSpace = false

    for i=1,#strSpace do
        local nStart,nEnd = string.find(tmpStr, strSpace[i])
        if nStart and nEnd then
            bIsExistSpace = true
            tmpStr = string.gsub(tmpStr, strSpace[i], "")
        end  
    end

    return bIsExistSpace, tmpStr
end

--@brief    将时间字符串转换为时间戳
function TimeStrToTime(timeStr)
    local ts = nil
    local y  = string.sub(timeStr,1, 4 )
    local m  = string.sub(timeStr,6, 7 )
    local d  = string.sub(timeStr,9, 10)
    local h  = string.sub(timeStr,12,13)
    local mm = string.sub(timeStr,15,16)
    local s  = string.sub(timeStr,18,19)
    ts = {year = y,month = m,day = d,hour = h,min = mm,sec = s}
    return os.time(ts)
end
--@brief 	获取一个spine动画的png图集数量
function GetSpinePngNum(fileName)
    local fileContent = WZFileUtil:getFileContent(fileName .. ".atlas")
	local _, pngNum = string.gsub(fileContent, "%.png", "")

    return pngNum
end

--@brief    添加保存是否该活动的首次抽奖
function SaveOperateTimes(ActivityKey, activityId)
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = ActivityKey .. tostring(CacheCenter:getPlayerInfo().id)
   
    local curValue = activityId
    data:setStringValue("CALABASH_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取是否该活动的首次抽奖
--@return 	1:非首次抽奖；0首次抽奖
function GetOperateTimes(ActivityKey, activityId)
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = ActivityKey .. tostring(CacheCenter:getPlayerInfo().id)
    
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" and tonumber(strValue) == activityId then 
		return 1
	else
		return 0
	end
end

--@brief    添加保存某活动上次选择的模式
--@param 	ActivityKey:key
--@param 	modeType:需要保存的值
function SaveActivityPoleType(ActivityKey, modeType)
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = ActivityKey .. tostring(CacheCenter:getPlayerInfo().id)
    local curValue = modeType
    data:setStringValue("CALABASH_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取上次保存的模式
function GetActivityPoleType(ActivityKey)
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = ActivityKey .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" then 
		return tonumber(strValue)
	end

	return 0 
end

--@brief 	根据品质、部位、来源获取宠物装备的随机属性
function GetPetEquipRamPro(quality, subType, origin)
	local pro = {}
	for i, value in pairs(GDatatab_pet_random) do
		if value.quality == quality and value.sub_type == subType then 
			for j = 1, #value.origin[1] do 
				if value.origin[1][j] == origin then 
					table.insert(pro, {proType = value.type, min = value.min, max = value.max, desc = value.desc, name = value.name})
				end
			end
		end
	end

	return pro
end

--@brief 	加载图集资源
function LoadNewActivityRes(bAdd)
	if bAdd then 
		if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_0.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/newActivity/pack_newActivity_0.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_1.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/newActivity/pack_newActivity_1.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_2.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/newActivity/pack_newActivity_2.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_3.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/newActivity/pack_newActivity_3.plist")
	    end
	else
		if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_0.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/newActivity/pack_newActivity_0.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_1.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/newActivity/pack_newActivity_1.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_2.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/newActivity/pack_newActivity_2.plist")
	    end
	    if WZFileUtil:isFileExist("pack/newActivity/pack_newActivity_3.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/newActivity/pack_newActivity_3.plist")
	    end
	end
	LoadActivityWordsRes(bAdd)
end

--@brief 	加载图集资源
function LoadActivityWordsRes(bAdd)
	if bAdd then 
		if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_0.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/activityWords/pack_activityWords_0.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_1.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/activityWords/pack_activityWords_1.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_2.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/activityWords/pack_activityWords_2.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_3.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/activityWords/pack_activityWords_3.plist")
	    end
	else
		if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_0.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/activityWords/pack_activityWords_0.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_1.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/activityWords/pack_activityWords_1.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_2.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/activityWords/pack_activityWords_2.plist")
	    end
	    if WZFileUtil:isFileExist("pack/activityWords/pack_activityWords_3.plist") then
	        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/activityWords/pack_activityWords_3.plist")
	    end
	end
end

function GetLimitData(soldNum, limitNum, dailyLimit, dailyBuyNum)
	local visible = false
	local str_title, num1, num2 = "",0,0
	local str = [[%s:%d/%d]]
	if limitNum == -1 and dailyLimit == -1 then
		visible = false
		num1,num2 = 0,1
	elseif limitNum ~= -1 and dailyLimit ~= -1 then
		visible = true
		str_title = LocalStrings.SHOP_LIMIT_TITLE
		num1 = soldNum
		num2 = limitNum
	elseif limitNum == -1 and dailyLimit ~= -1 then
		visible = true
		str_title = LocalStrings.WATERMELON_TEXT1[25]
		num1 = dailyBuyNum
		num2 = dailyLimit
	elseif limitNum ~= -1 and dailyLimit == -1 then
		visible = true
		str_title = LocalStrings.SHOP_LIMIT_TITLE
		num1 = soldNum
		num2 = limitNum
	end
	local strLimit = string.format(str,str_title, num1, num2)
	local bIsSoldOut = false 
	if num1 >= num2 then
		bIsSoldOut = true
	end
	return visible, strLimit, bIsSoldOut
end

--@brief	判断自己是否在联盟
--@return	true:在联盟		false:不在联盟
function checkInUnion()
	local unionInfo = CacheCenter:getPlayerInfo().unionInfo
	--玩家不是联盟成员
	if unionInfo == nil or unionInfo.id == nil or unionInfo.id < 1 then
		return false
	else
		return true	
	end
end

--@brief 	根据时装物品Id获取该时装是否可进阶
--@note 	返回是否可以进阶，套装Id
function GetDressAdvanceData(itemId)
	local bIsConfigAdvance = false 
	local bIsAdvance = false 
	local suitId = nil 
	local nSex = CacheCenter:getPlayerInfo().sex
	local basicInfo = GDatatab_item["id_" .. itemId]
	local configIds = nil 
	local havedAdvanceIds = nil 
	if basicInfo.main_type == 5 and basicInfo.sub_type ~= 3 then 
		configIds = CacheCenter:getAllConfigDressAdvanceIds()
		havedAdvanceIds = CacheCenter:getDressAdvanceId()
		--如果是在玩家信息界面，需要显示当前玩家的相应状态
		if WndCheckOther and WndCheckOther.m_root and not WndCheckOther.m_bIsHost then 
			nSex = WndCheckOther.m_tPlayerInfo.sex
			havedAdvanceIds = WndCheckOther:getDressAdvanceId()
		end
		for i = 1, #configIds do
			local configData = GDatatab_enchanting["id_" .. configIds[i]]
			if type(configData["item_id" .. (nSex + 1)]) == "table" then 
				local itemIds = configData["item_id" .. (nSex + 1)][1]
				if itemIds then 
					for j = 1, #itemIds do
						if itemIds[j] == itemId then 
							bIsConfigAdvance = true 
							break 
						end
					end
				end

				if bIsConfigAdvance then 
					suitId = configIds[i]
					break 
				end
			end
		end
	elseif basicInfo.main_type == 5 and basicInfo.sub_type == 3 then --翅膀
		configIds = CacheCenter:getAllConfigWingAdvanceIds()
		havedAdvanceIds = CacheCenter:getWingAdvanceId()
		--如果是在玩家信息界面，需要显示当前玩家的相应状态
		if WndCheckOther and WndCheckOther.m_root and not WndCheckOther.m_bIsHost then 
			havedAdvanceIds = WndCheckOther:getWingAdvanceId()
		end
		for i = 1, #configIds do
			local configData = GDatatab_enchanting["id_" .. configIds[i]]
			if itemId == configData.item_id3 then 
				bIsConfigAdvance = true 
				suitId = configIds[i]
				break 
			end
		end
	end

	if bIsConfigAdvance and suitId then 
		if utilsValueInTable(suitId, havedAdvanceIds) then 
			bIsAdvance = true 
		end
	end

	return bIsConfigAdvance, suitId, bIsAdvance
end
-------------------------------------私有方法模块End---------------------------------------
