--CellMarryLetter.lua
--@brief	CellMarryLetter的UI模块
--@date		2014/01/15
--@author	叶威
--@note		求婚信列表项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMarryLetter:onEnter(element)
	self.m_root = element
    self:_update()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMarryLetter:onExit(element)
	self:_unInit()
end

--@brief 点击文本的响应函数
--@brief element:WZUILabelTTF
function CellMarryLetter:onBriefClick(element)
    WZLog("CellMarryLetter:onBriefClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --获取求婚信内容，协议回调处理在WndMarryManager
    ProtocolProcessorWndMarry:send_WEDDING_GetLoveLetterInfo(self.m_nLetterId)
end

--@brief  点击头像查看人物信息
function CellMarryLetter:onClickHead(element)
	WZLog("CellMarryLetter:onClickHead")
	local parentElement = element:getParent()
	local playerId = parentElement:getTag()
	if playerId ~= nil and playerId > 0 then
		WndCheckOther:show(playerId)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 更新界面
function CellMarryLetter:_update()
	if self.m_sPlayerName ~=nil then
		GetElement(self.m_root,"txtPlayerName_CellMarryLetter",WZUILabelTTF):setText(self.m_sPlayerName)
	end

	if self.m_sPlayerLevel ~= nil then
		GetElement(self.m_root,"txtPlayerLevel_CellMarryLetter",WZUILabelTTF):setText("Lv" .. self.m_sPlayerLevel)
	end

	if self.m_sLetterT ~= nil then
		GetElement(self.m_root,"txtSendT_CellMarryLetter",WZUILabelTTF):setText(self.m_sLetterT)
	end

	if self.m_sLetterName ~= nil then
		GetElement(self.m_root,"txtMarrayInfo_CellMarryLetter",WZUILabelTTF):setText(self.m_sLetterName)
	end

	if self.m_nHeadId and  self.m_nFaceId  then
		local conPlayerHead = GetElement(self.m_root,"conPlayerHead_CellMarryLetter",WZUIContainer)
		local nSex = CacheCenter:getPlayerInfo().sex
        if nSex == 0 then
            nSex = 1
        else
            nSex = 0
        end
        if self.m_nPlayerId ~= nil  then
		    conPlayerHead:setTag(self.m_nPlayerId)
	    end
        
        CellHead:show(conPlayerHead,self.m_nHeadId,self.m_nFaceId,nSex,nil,nil,nil,self.m_nHeadColor)
	end
end



-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin------------------------------------------
function CellMarryLetter:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtPlayerLevel_CellMarryLetter",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtPlayerName_CellMarryLetter",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtMarrayInfo_CellMarryLetter",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtSendT_CellMarryLetter",WZUILabelTTF):setScale(0.8)
end

function CellMarryLetter:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtMarrayInfo_CellMarryLetter",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(260))
end

function CellMarryLetter:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtMarrayInfo_CellMarryLetter",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(260))
end

function CellMarryLetter:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtMarrayInfo_CellMarryLetter",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(260))
end

-------------------------------------语言适配End--------------------------------------------