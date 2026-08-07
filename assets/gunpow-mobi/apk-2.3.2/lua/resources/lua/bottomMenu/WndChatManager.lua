--WndChatManager.lua
--@brief	聊天系统管理模块
--@date		2015/12/14
--@author	qixiang_xie

WndChatManager = {}


WndChatManager.autoPlayCurVoiceScene = {"SceneHall","SceneRoom","SceneBossRoom","WndMultiCopy","SceneCommunityMain","SceneWeddingChurch","SceneBattle","ScenePvpRank"}

WndChatManager.autoPlayGuildVoiceScene = {"SceneHall","SceneBossRoom","WndMultiCopy","SceneBattle","SceneCommunityMain","SceneWeddingChurch","SceneCity","SceneWorldBoss","SceneRoom","SceneWeddingDaily","ScenePvpRank"}


--@brief  根据场景名称判断是否可以自动当前频道播放语音
--@param  true : 可以自动播放否则不能
function WndChatManager:canAutoPlayCurVoice(sceneName)
	WZLog("WndChatManager:canAutoPlayVoice")
	local stats = false
	for i,v in ipairs(WndChatManager.autoPlayCurVoiceScene) do
		if v == scaneName then
			return true
		end
	end
	return stats
end


--@brief  根据场景名称判断是否可以自动公会频道播放语音
function WndChatManager:canAutoPlayGuldVoice(sceneName)
	WZLog("WndChatManager:canAutoPlayGuldVoice")
	local stats = false
	for i,v in ipairs(WndChatManager.autoPlayGuildVoiceScene) do
		if v == sceneName then
			return true
		end
	end
	return false
end