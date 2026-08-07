--ProtocolProcessorWndAscending.lua
--@brief	强化研究院相关协议
--@date  	2016/9/19
--@author 	zsq
--@note 	强化研究院相关协议


ProtocolProcessorWndAscending = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndAscending:regAll()
	--@brief	蓝装升阶到紫装（ ADVANCED_MakePurpleEqui= 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_MakePurpleEqui, "ProtocolProcessorWndAscending:send_ADVANCED_MakePurpleEqui_ErrorProcess", "is" )
	--@brief	紫装升阶到橙装（ ADVANCED_MakeOrangeEqui= 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_MakeOrangeEqui, "ProtocolProcessorWndAscending:send_ADVANCED_MakeOrangeEqui_ErrorProcess", "is" )
	--@brief	调品（ ADVANCED_AdjustGrade= 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_AdjustGrade, "ProtocolProcessorWndAscending:send_ADVANCED_AdjustQuality_ErrorProcess", "is" )
	--@brief	保留原品级（ ADVANCED_KeepOldGrade= 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_KeepOldGrade, "ProtocolProcessorWndAscending:send_ADVANCED_KeepOldGrade_ErrorProcess", "is" )
	--@brief    获取祈福信息（PRAY_GetPrayMess = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMess, "ProtocolProcessorWndAscending:send_PRAY_GetPrayMess_ErrorProcess", "is" )
    --@brief	合成祈福珠（PRAY_MergePray = 22）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_MergePray, "ProtocolProcessorWndAscending:send_PRAY_MergePray_ErrorProcess", "is" )
	--@brief	紫宠进化到橙宠（ ADVANCED_EvoOrangePet= 8）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_EvoOrangePet, "ProtocolProcessorWndAscending:send_ADVANCED_EvoOrangePet_ErrorProcess", "is" )
	--@brief	坐骑升品（ ADVANCED_UpgradeMountQuality = 10）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_UpgradeMountQuality, "ProtocolProcessorWndAscending:send_ADVANCED_UpgradeMountQuality_ErrorProcess", "is" )
	--@brief	圣光-皮肤契约（ADVANCED_ShapeContract = 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_ShapeContract, "ProtocolProcessorWndAscending:send_ADVANCED_ShapeContract_ErrorProcess", "is" )
	--@brief	时装套装进阶（ADVANCED_FashionSuitAdvance = 15）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_FashionSuitAdvance, "ProtocolProcessorWndAscending:send_ADVANCED_FashionSuitAdvance_ErrorProcess", "is")


	--@brief	蓝装升阶到紫装结果（ ADVANCED_MakePurpleEquiOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_MakePurpleEquiOk, "ProtocolProcessorWndAscending:parse_ADVANCED_MakePurpleEquiOk", "b")
	--@brief	紫装升阶到橙装结果（ ADVANCED_MakeOrangeEquiOK = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_MakeOrangeEquiOK, "ProtocolProcessorWndAscending:parse_ADVANCED_MakeOrangeEquiOK", "b")
	--@brief	调品结果（ ADVANCED_AdjustGradeOK = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_AdjustGradeOK, "ProtocolProcessorWndAscending:parse_ADVANCED_AdjustQualityOK", "i")
	-- --@brief    获取祈福信息成功（PRAY_GetPrayMessOk = 2）
 --    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMessOk, "ProtocolProcessorWndAscending:parse_PRAY_GetPrayMessOk", "iviviviviviviviivivi")
    --@brief	合成祈福珠结果（PRAY_MergePrayOk = 23）
	self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_MergePrayOk, "ProtocolProcessorWndAscending:parse_PRAY_MergePrayOk", "vivivivivivivii")
	--@brief	紫装进化到橙装结果（ ADVANCED_EvoOrangePetOk = 9）
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_EvoOrangePetOk, "ProtocolProcessorWndAscending:parse_ADVANCED_EvoOrangePetOk", "i")
	--@brief	坐骑升品结果（ ADVANCED_UpgradeMountQualityOk = 11）
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_UpgradeMountQualityOk, "ProtocolProcessorWndAscending:parse_ADVANCED_UpgradeMountQualityOk", "i")
	--@brief	皮肤契约结果（ADVANCED_ShapeContractOK = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_ShapeContractOK, "ProtocolProcessorWndAscending:parse_ADVANCED_ShapeContractOK", "ii")
	--@brief	时装套装进阶OK（ADVANCED_FashionSuitAdvanceOk = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_FashionSuitAdvanceOk, "ProtocolProcessorWndAscending:parse_ADVANCED_FashionSuitAdvanceOk", "ivii")
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndAscending:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	蓝装升阶到紫装（ ADVANCED_MakePurpleEqui= 1）
function ProtocolProcessorWndAscending:send_ADVANCED_MakePurpleEqui(playerItemId, isKeep )
	WZLog("send_ADVANCED_MakePurpleEqui")
	local sender = Protocol:getSender( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_MakePurpleEqui )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 升阶装备的playerItemId
	sender:writeBoolean( isKeep )	-- 是否保留强化、升星等级
	SendProtocol(sender,false) --true:showLoading
end

--@brief	紫装升阶到橙装（ ADVANCED_MakeOrangeEqui= 3）
function ProtocolProcessorWndAscending:send_ADVANCED_MakeOrangeEqui(playerItemId )
	WZLog("send_ADVANCED_MakeOrangeEqui")
	local sender = Protocol:getSender( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_MakeOrangeEqui )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 升阶装备的playerItemId
	SendProtocol(sender,false) --true:showLoading
end

--@brief	调品（ ADVANCED_AdjustGrade= 5）
function ProtocolProcessorWndAscending:send_ADVANCED_AdjustQuality(playerItemId )
	WZLog("send_ADVANCED_AdjustQuality")
	local sender = Protocol:getSender( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_AdjustGrade )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 调品装备的playerItemId
	SendProtocol(sender,false) --true:showLoading
end

--@brief	保留原品级（ ADVANCED_KeepOldGrade= 7）
function ProtocolProcessorWndAscending:send_ADVANCED_KeepOldGrade(playerItemId, isKeep )
	WZLog("send_ADVANCED_KeepOldGrade")
	local sender = Protocol:getSender( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_KeepOldGrade )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 调品装备的playerItemId
	sender:writeBoolean( isKeep )	-- true保留原品，flase新品
	SendProtocol(sender,false) --true:showLoading
end

--@brief    获取祈福信息（PRAY_GetPrayMess = 1）
function ProtocolProcessorWndAscending:send_PRAY_GetPrayMess( )
    WZLog("send_PRAY_GetPrayMess")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMess )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	合成祈福珠（PRAY_MergePray = 22）
function ProtocolProcessorWndAscending:send_PRAY_MergePray(prayIds, mergePray )
	WZLog("send_PRAY_MergePray")
	local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_MergePray )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( prayIds )	-- 被合成的祈福珠唯一标示
	sender:writeInt( mergePray )	-- 合成后的祈福珠itemId
	SendProtocol(sender,false) --true:showLoading
end

--@brief	紫宠进化到橙宠（ ADVANCED_EvoOrangePet= 8）
function ProtocolProcessorWndAscending:send_ADVANCED_EvoOrangePet(playerPetId, cPlayerPetIdArr, cNum )
	WZLog("send_ADVANCED_EvoOrangePet")
	local sender = Protocol:getSender( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_EvoOrangePet )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerPetId )	-- 玩家进阶宠物的id
	sender:writeInts( cPlayerPetIdArr )	-- 被消耗的玩家宠物id
	sender:writeInts( cNum )	-- 消耗数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	坐骑升品（ ADVANCED_UpgradeMountQuality = 10）
function ProtocolProcessorWndAscending:send_ADVANCED_UpgradeMountQuality(mountId )
	WZLog("send_ADVANCED_UpgradeMountQuality")
	local sender = Protocol:getSender( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_UpgradeMountQuality )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mountId )	-- 坐骑id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	圣光-皮肤契约（ADVANCED_ShapeContract = 13）
function ProtocolProcessorWndAscending:send_ADVANCED_ShapeContract(shapeId)
	WZLog("send_ADVANCED_ShapeContract")
	local sender = Protocol:getSender( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_ShapeContract )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( shapeId )	-- 皮肤id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	时装套装进阶（ADVANCED_FashionSuitAdvance = 15）
function ProtocolProcessorWndAscending:send_ADVANCED_FashionSuitAdvance(fashionSuitId, subType)
	WZLog("send_ADVANCED_FashionSuitAdvance", fashionSuitId)
	local sender = Protocol:getSender( Protocol.MAIN_ADVANCED, Protocol.ADVANCED_FashionSuitAdvance )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(fashionSuitId)	-- 时装套装ID【tab_enchanting表的ID】
	sender:writeInt(subType)		-- 时装的sub_type
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	蓝装升阶到紫装结果（ ADVANCED_MakePurpleEquiOk = 2）
function ProtocolProcessorWndAscending:parse_ADVANCED_MakePurpleEquiOk(result)
	-- result : 升阶结果
	WZLog("ProtocolProcessorWndAscending:parse_ADVANCED_MakePurpleEquiOk")
	WndAscending:onAscendFinish()
end

--@brief	紫装升阶到橙装结果（ ADVANCED_MakeOrangeEquiOK = 4）
function ProtocolProcessorWndAscending:parse_ADVANCED_MakeOrangeEquiOK(result)
	-- result : 升阶结果
	WZLog("ProtocolProcessorWndAscending:parse_ADVANCED_MakeOrangeEquiOK")
	WndAscending:onAscendFinish()
end

--@brief	调品结果（ ADVANCED_AdjustGradeOK = 6）
function ProtocolProcessorWndAscending:parse_ADVANCED_AdjustQualityOK(result)
	-- result : 调品结果 1=品级降低 2=品级变高 3=图纸不足 4=消耗不足 5=品级属性都没变化
	WZLog("ProtocolProcessorWndAscending:parse_ADVANCED_AdjustQualityOK",result,WndGradeStrengthen.m_bRunning)

	WndGradeStrengthen.m_bRunning = false
	WZLog("设置为调品结束", WndGradeStrengthen.m_bRunning)
	WndGradeStrengthen:playSound()
	if result == 1 then
		WndGradeStrengthen:onSureFinish()
	elseif result == 5 then
		WndGradeStrengthen:updateLucky(WndGradeStrengthen.m_tEquipBefore)
		WndGradeStrengthen:popTip0()
	else
		WndGradeStrengthen:updateLucky(WndGradeStrengthen.m_tEquipBefore)
		WndGradeStrengthen:popTip()
	end
end

-- --@brief    获取祈福信息成功（PRAY_GetPrayMessOk = 2）
-- function ProtocolProcessorWndAscending:parse_PRAY_GetPrayMessOk(time, bagIds, bagExps, bagPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum, num, openlevel)
--     -- time : 距离下次免费抽奖时间（秒）
--     -- bagIds : 背包中祈福唯一标示id列表
--     -- bagExps : 背包中祈福经验列表
--     -- bagPrayIds : 背包中祈福id列表
--     -- prayNum : 装备祈福珠孔（从1开始，没有装备祈福珠就不发）
--     -- equipPrayId : 装备祈福珠id
--     -- equipId : 装备祈福珠唯一标示Id
--     -- equipExp : 装备祈福珠经验
--     -- fightNum : 祈福珠战斗力
--     -- num : 装备孔位置
--     -- openlevel : 装备孔位置开放等级
--     WZLog("ProtocolProcessorWndAscending:parse_PRAY_GetPrayMessOk")
--     if WndAscending.m_root then
--     	WndAscending:setData(time, bagIds, bagExps, bagPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum, num, openlevel) 
--     end
    
-- end

--@brief	合成祈福珠结果（PRAY_MergePrayOk = 23）
function ProtocolProcessorWndAscending:parse_PRAY_MergePrayOk(prayNum, equipPrayId, equipId, equipExp, bagIds, bagExps, bagPrayIds, fightNum)
	-- prayNum : 装备祈福珠孔（从1开始，没有装备祈福珠就不发）
	-- equipPrayId : 装备祈福珠id
	-- equipId : 装备祈福珠唯一标示Id
	-- equipExp : 装备祈福珠经验
	-- bagIds : 背包中祈福唯一标示id列表
	-- bagExps : 背包中祈福经验列表
	-- bagPrayIds : 背包中祈福id列表
	-- fightNum : 祈福珠战斗力
	WZLog("ProtocolProcessorWndAscending:parse_PRAY_MergePrayOk")
	WndAscending:setResetData(bagIds, bagExps, bagPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum)
end

--@brief	紫装进化到橙装结果（ ADVANCED_EvoOrangePetOk = 9）
function ProtocolProcessorWndAscending:parse_ADVANCED_EvoOrangePetOk(result)
	-- result : 1进阶成功
	WZLog("ProtocolProcessorWndAscending:parse_ADVANCED_EvoOrangePetOk",result)
	if result == 1 then
		WndRewardShow:showById({WndAscending.m_tGetPetID},{1})
	end
	if WndPets.m_root ~= nil then
		WndPets:doRefresh()
	end
	WndAscending:cleanWnd()
	WndAscending:updatePetList()
end

--@brief	坐骑升品结果（ ADVANCED_UpgradeMountQualityOk = 11）
function ProtocolProcessorWndAscending:parse_ADVANCED_UpgradeMountQualityOk(result)
	-- result : 1升品成功
	WZLog("ProtocolProcessorWndAscending:parse_ADVANCED_UpgradeMountQualityOk", result)
	if result == 1 then
		WndRewardShow:showById({WndAscending.m_tGetMountID},{1})
	end
	WndAscending:cleanWnd()
	WndAscending:updateMountList()
end

--@brief	皮肤契约结果（ADVANCED_ShapeContractOK = 14）
function ProtocolProcessorWndAscending:parse_ADVANCED_ShapeContractOK(result, shapeId)
	-- result : 1升品成功
	WZLog("ProtocolProcessorWndAscending:parse_ADVANCED_ShapeContractOK", result)
	if result == 1 then
		local itemId = GDatatab_shape_skins["id_" .. shapeId].channel
		WndRewardShow:showById({itemId},{-1})
	end
	WndAscending:cleanWnd()
	WndAscending:updatePhantomList()
end

--@brief	时装套装进阶OK（ADVANCED_FashionSuitAdvanceOk = 16）
function ProtocolProcessorWndAscending:parse_ADVANCED_FashionSuitAdvanceOk(result, advanceEnchantingIds, subType)
	-- result : 进阶结果【0=成功|非0失败】
	-- advanceEnchantingIds : 玩家已进阶了的时装套装Id集合
	-- subType : 2=时装；3=翅膀
	WZLog("ProtocolProcessorWndAscending:parse_ADVANCED_FashionSuitAdvanceOk", result, Serialize(VectorToTable(advanceEnchantingIds)), subType)

	if result == 0 then 
		PopupResult("ui/common/common_icon_jjz.png")
		if subType == 2 then 
			CacheCenter:setDressAdvanceId(VectorToTable(advanceEnchantingIds))
		elseif subType == 3 then 
			CacheCenter:setWingAdvanceId(VectorToTable(advanceEnchantingIds))
		end
		WndAscending:setDressData()
	end
end
-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------
--@brief	蓝装升阶到紫装（ ADVANCED_MakePurpleEqui= 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndAscending:send_ADVANCED_MakePurpleEqui_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndAscending:send_ADVANCED_MakePurpleEqui_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ADVANCED, Protocol.ADVANCED_MakePurpleEqui, nflag, sMessage)
end

--@brief	紫装升阶到橙装（ ADVANCED_MakeOrangeEqui= 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndAscending:send_ADVANCED_MakeOrangeEqui_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndAscending:send_ADVANCED_MakeOrangeEqui_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ADVANCED, Protocol.ADVANCED_MakeOrangeEqui, nflag, sMessage)
end

--@brief	调品（ ADVANCED_AdjustGrade= 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndAscending:send_ADVANCED_AdjustQuality_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndAscending:send_ADVANCED_AdjustQuality_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ADVANCED, Protocol.ADVANCED_AdjustGrade, nflag, sMessage)
end

--@brief	保留原品级（ ADVANCED_KeepOldGrade= 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndAscending:send_ADVANCED_KeepOldGrade_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndAscending:send_ADVANCED_KeepOldGrade_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ADVANCED, Protocol.ADVANCED_KeepOldGrade, nflag, sMessage)
end

--@brief    获取祈福信息（PRAY_GetPrayMess = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndAscending:send_PRAY_GetPrayMess_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndAscending:send_PRAY_GetPrayMess_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMess, nflag, sMessage)
end

--@brief	合成祈福珠（PRAY_MergePray = 22）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndAscending:send_PRAY_MergePray_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndAscending:send_PRAY_MergePray_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_MergePray, nflag, sMessage)
end

--@brief	紫宠进化到橙宠（ ADVANCED_EvoOrangePet= 8）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndAscending:send_ADVANCED_EvoOrangePet_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndAscending:send_ADVANCED_EvoOrangePet_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ADVANCED, Protocol.ADVANCED_EvoOrangePet, nflag, sMessage)
end

--@brief	坐骑升品（ ADVANCED_UpgradeMountQuality = 10）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndAscending:send_ADVANCED_UpgradeMountQuality_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndAscending:send_ADVANCED_UpgradeMountQuality_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ADVANCED, Protocol.ADVANCED_UpgradeMountQuality, nflag, sMessage)
end

--@brief	圣光-皮肤契约（ADVANCED_ShapeContract = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndAscending:send_ADVANCED_ShapeContract_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndAscending:send_ADVANCED_ShapeContract_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ADVANCED, Protocol.ADVANCED_ShapeContract, nflag, sMessage)
end

--@brief	时装套装进阶（ADVANCED_FashionSuitAdvance = 15）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndAscending:send_ADVANCED_FashionSuitAdvance_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndAscending:parse_ADVANCED_FashionSuitAdvance_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ADVANCED, Protocol.ADVANCED_FashionSuitAdvance, nflag, sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------
