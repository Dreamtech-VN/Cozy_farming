--LocalStrings.lua
--@brief界面文字字符串定义文件，不同的语言具有相同的键。
LocalStrings =
{
LOGIN = "Đăng nhập",
PASSWORD = "Mật khẩu",
INBOX = "Nhận",
OUTBOX = "Gửi",
WRITEBOX = "Viết thư",
SEND = "Gửi",
SUCCESS = "Thành công",
FAIL = "Thất bại",
EDIT = "Xóa hết",
DELECT = "Xóa",
COMPLETE = "Hoàn thành",
REPLY = "Trả lời",
UPPAGE = "Trước",
DOWNPAGE = "Sau",
SENDER = "Người gửi: ",
TIME = "Thời gian: ",
EDITMAILID = "Chọn người nhận",
EDITMAILTHEME = "Nhập chủ đề thư",
EDITMAILCONTENT = "Nhập nội dung thư",
NOTDESIGNAME = "Chưa nhận danh hiệu này!",
MAIL_THEME = "Chủ đề: ",
MAIL_RECV = "Người nhận: ",
MAIL_SENDER = "Người gửi: ",
MAIL_GETALL = "Nhận",
REINC_REINCTXT = "Chuyển sinh",
VIP_CURDAYRECV = "Đã nhận",
VIP_RECVSUCCESS = "Nhận thành công",
VIP_INFOFAIL = "Nhận thông tin VIP thất bại",
INVITE_RECEIVE = "Nhận",
INVITE_SERVER = "Máy chủ",
NAME = "Tên",
CURSERVER = "Máy chủ: ",
BACKGROUND = "Nhạc nền",
GAME = "Âm thanh",
MUSIC = "Nhạc",
ABOUT = "Giới thiệu game",
REGISTER = "Đăng ký",
SETTING_ACCOUNT = "Tài khoản",
HELP = "Hỗ trợ",
INPUTDETAIL = "Nhập nội dung",
EXCHANGE = "Đổi",
CURNUM = "Số người tham chiến: %d",
URLFAIL = "Mở URL thất bại!" ,
QUALIFYING_ORDER = "Thứ tự",
QUALIFYING_NAME = "Tên",
INTEGRATION = "Điểm",
HURTOUTPUT = "Sát thương gây ra",
MATCHFAIL = "Ghép thất bại",
TEACH_BOSSMAP = "Hãy cùng chiến hữu vừa nhận được thám hiểm phó bản",
TEACH_BOSSMAP_CHALLENGE = [[Nhấp "Ải khiêu chiến" chọn độ khó phó bản]],
TEACH_BOSSMAP_SIMPLE = "Chọn độ khó là dễ. Sau khi vượt ải sẽ tự mở khóa độ khó kế",
TEACH_BOSSMAP_SURE = "Tạo phòng phó bản",
TEACH_STRENGTHEN = "Muốn tăng lực chiến nhanh không? Hãy cường hóa trang bị",
TEACH_STRENGTHENSTART = "Bắt đầu cường hóa trang bị",
TEACH_STRENGTHEN_WEAPON = "Chọn vũ khí cần cường hóa",
TEACH_STRENGTHEN_OTHER = "Chọn đạo cụ cần cường hóa",
TEACH_STRENGTHEN_SELECTSTONE = "Chọn Đá Cường Hóa",
TEACH_STRENGTHEN_START = "Nhấp cường hóa tăng cấp vũ khí",
TEACH_STRENGTHEN_CLOSE = "Hoàn thành cường hóa, quay về Sảnh",
--登录界面
LOGINING = "Đang đăng nhập",
GET_ROLELIST_SUCCESS = "Nhận nhân vật thành công",
--创建角色界面
PLEASE_INPUT_ACTORNAME = "Nhập tên nhân vật",
REGISTER_AGAIN = "Đăng ký lại",
LOGIN_AGAIN = "Nhập lại",
--账号界面
FINDBACK_PSW = "Tìm lại mật khẩu",
CHANGE_ACCOUNT = "Đổi tài khoản",
CHANGE_PSW = "Đổi mật khẩu",
FINDBACK_PSW_TIP = "Chú ý: Nhập địa chỉ hộp thư khi đăng ký có thể tìm lại được tài khoản và mật khẩu",
EMAIL_SENDED = "Đã gửi thư",
OLD_PSW = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Mật khẩu cũ: </T>]],
NEW_PSW = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Mật khẩu mới: </T>]],
PASSWORD_CONFIRM = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Xác nhận mật khẩu: </T>]],
PLEASE_INPUT_OLD_PSW = "Nhập mật khẩu cũ",
PLEASE_INPUT_NEW_PSW = "Nhập mật khẩu mới",
PLEASE_INPUT_PSWCONFIRM = "Nhập mật khẩu xác nhận",
CHANGE_PSW_SUCCESS = "Sửa mật khẩu thành công",
VERIFICATION_FAILED = "Mật khẩu tài khoản sai",
--注册界面
CLICK_INPUT_ACCOUNT = "Nhập tài khoản",
CLICK_INPUT_PASSWORD = "Nhập mật khẩu",
CLICK_INPUT_MAIL = "Nhập email",
CLICK_INPUT_INVITECODE = "Nhập Code mời",
ACCOUNT= [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Tài khoản: </T>]],
PASSWORD1 = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Mật khẩu: </T>]],
PSW_CONFIRM= [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Xác nhận mật khẩu: </T>]],
MAIL = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Email: </T>]],
INVITE_CODE = [[<T C="80,38,3" S="30" P="0">Code: </T>]],
STAR_MEANS_ESSENTIAL = [[<T C="255,0,0" S="24" P="0">*</T><T C="80,38,3" S="24" P="0">Số chỉ mục cần điền vào</T>]],
PLEASE_INPUT_ACCOUNT = "Nhập tài khoản",
ONLY_NUM_AND_LETTER = "Chỉ được nhập số và chữ",
ACCOUNT_LEN_ILLEGAL = "Độ dài tài khoản không hợp yêu cầu",
PLEASE_INPUT_PSW = "Nhập mật khẩu",
PSW_LEN_ILLEGAL = "Độ dài mật khẩu không hợp yêu cầu",
PSWCONFIRM_NOT_THE_SAME = "Mật khẩu không thống nhất",
PLEASE_INPUT_MAIL = "Nhập email",
PLEASE_INPUT_CORRECT_MAIL = "Nhập email chính xác",
--成长基金界面
BUY_FUND = "Mua quỹ",
INTRODUCTION = "Thông tin",
--每日签到界面
SIGN = "Điểm danh",
--物品回收界面
RECYCLING = "Thu hồi",
WEAPON = "Vũ khí",
CLOTH = "Trang phục",
OTHERS = "Khác",
SALE_SUCCESS = "Bán thành công",
--强化研究院
ENTER = "Vào",
--强化界面
HOLY_STONE = "Đá Thánh",
--镶嵌界面
EQUIPMENT = "Trang bị",
ATTACK_STONE = "Công",
DEFENSE_STONE  = "Phòng",
GEMMOUNTING = "Khảm",
PLEASE_ADD_WEAPON_FIRST = "Đặt trang bị vào!",
--升星界面
IMPROVE = "Tăng sao",
STAR_STONE = "Đá Tăng Sao",
--重铸界面
FIRE = "Tôi luyện",
LOCK = "Khóa",
--继承界面
TRANSFER = "Kế thừa",
--合成界面
MATERIAL = "N.Liệu",
SYNTHESIS = "Ghép",
--链接游戏服务器提示
NETWORK_UNAVAILABLE = "Kết nối thất bại, thử lại sau! (PS: Hãy chơi game khi mạng ổn định để trải nghiệm game tốt hơn)",
SERVER_MAINTAINING = "Máy chủ đang bảo trì",
--好友
TXT_NOSOCISY_FREND = [[Chưa vào Công Hội]],
FRONT_PAGE = "Trượt trang xuống",
NEXT_PAGE = "Trượt trang lên",
--排行榜
BATTLE = "Lực chiến",
WIN = "Chiến thắng",
--公会
CUR_PRESIDENT = "Chủ Công Hội",
PRESTIGE = "Danh vọng",
FUNDS = "Quỹ",
RANK = "Hạng",
MY_COMMUNITY = "Công Hội",
CREATE_COMMUNITY = "Tạo Công Hội",
COMMUNITY_NAME = "Tên: ",
COMMUNITY_LEVEL = "Cấp Công Hội",
COMMUNITY_PRESTIGE = "Danh vọng",
WIN_RATE = "Thắng",
PLEASE_INPUT_COMMUNITY_ID = "Nhập ID Công Hội",
COMMUNITY_ID_INPUT_MUST_ALL_NUMBER = "ID Công Hội phải là số",
CREATE_COMMUNITY_SUCCESS = "Đã tạo Công Hội!",
CLICK_INPUT_NAME = "Nhập tên",
ALREADAY_APPLAY_FOR_COMMUNITY_MESSAGE = "Đã gửi thông tin xin vào Công Hội",
GOLD_COIN = "Vàng: ",
DIAMOND = "Kim Cương: ",
ASK_YES_OR_NO_GIVEWAY = "Xác nhận nhường chức Chủ Hội?\nBạn và mục tiêu sẽ đổi chức cho nhau!",
MAIL_SEND_SUCCUSS = "Đã gửi thư!",
PRESIDENT = "Hội Trưởng",
VICE_PRESIDENT = "Phó Hội",
ELDERS = "Trưởng Lão",
PICK = "Tinh Anh",
NORMAL_COMMUNITY_MEMBER = "Hội viên",
ENEMY_COMMUNITY = "Công Hội địch",
SET_EMEMY_COMMUNITY_SUCCESS = "Đã thiết lập Công Hội địch!",
FRIEND_ADD_SUCCESS = "Đã thêm bạn",
SUCCESS_UP_JOB = "Đã thăng chức!",
SUCCESS_DOWN_JOB = "Đã giáng chức!",
ARE_YOU_SURE_DISMISS_THIS_PLAYER = "Xác nhận trục xuất %s?",
ALREADY_REMOVE_COMMUNITY = " bị trục xuất khỏi Công Hội!",
ALREADY_EXIT_COMMUNITY = " đã rời Công Hội!",
COMMUNITY_ALREADY_DISSMISS = "Công Hội đã giải tán!",
SUCESS_AS_PRESIDENT = " đã trở thành chủ Công Hội",
NOT_REACH_LEVEL_CANNOT_BUILD_GUILD = "Đạt Lv15 mới được tạo Công Hội",
DISMISS_COMMUNITY = "Giải tán Công Hội",
--密境探险
YES_OR_NO_SPEND = "Đồng ý dùng ",
DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE = "Kim Cương không đủ, cần thêm không?",
MEDAL_NOT_ENOUGH_PLEASE_GET_MORE_MEDAL = "Huy Hiệu không đủ, cần thêm không?",
GAME_HALL = "Sảnh trò chơi",
START = "Bắt đầu",
GOLD_COIN_NOT_ENOUGH = "Vàng không đủ, cần thêm không?",
--副本大厅
COPY_HALL = "Sảnh phó bản",
FIND_ROOM = "Tìm",
QUICK_JOIN ="Vào nhanh",
QUICK_JOIN1 ="Vào nhanh",
COMMON = "Dễ",
DIFFICULTY = "Khó",
HELL = "Địa Ngục",
MODEL = "Dạng",
SIMPLE_MODEL_EXPLAIN = "Độ khó thường, thưởng cũng bình thường.",
DIFFICULTY_MODEL_EXPLAIN = "Độ khó càng cao thưởng càng nhiều.",
HELL_MODEL_EXPLAIN = "Thưởng cao nhất chỉ dành cho đội dũng cảm nhất!",
DIFFICULTY_MODLE_SHOW_ERROR_MEESSAGE = "Chưa vượt dạng Dễ, không thể khiêu chiến dạng Khó.",
HELL_MODLE_SHOW_ERROR_MESSAGE = "Chưa vượt dạng Khó, không thể khiêu chiến dạng Địa Ngục.",
UNABLE_PASS_THIS_CHECKPOINT_ERR_MESSAGE = "Chưa vượt ải trước, không thể khiêu chiến ải này",
LEVEL_OPEN_THIS_FUNCTION = " cấp mở chức năng này",
QUICKEN = "Tăng tốc",
--弹王挑战赛
EXIT = "Thoát",
PLAYER_NAME = "Tên",
PEOPLE_NUM = "Số người:",
WHERE_THE_SERVER = "Máy chủ",
PLAYER_LEVEL = "Cấp người chơi",

--任务，每日签到
BACK = "Quay về",
CONFIRM = "Xác nhận",
SAVE = "Lưu",
CANCEL = "Hủy",
CALENDAR_WEEK = {
"CN",
"1",
"2",
"3",
"4",
"5",
"6",
},
TASK_JUQING = "Chính",
TASK_MEIRI = "Hàng Ngày",
TASK_TARGET = "Mục tiêu",
TASK_DESCRIPTION = "Miêu tả",
TASK_REWARD = "Thưởng nhiệm vụ",
ACTIVE_TIME = "Thời gian hoạt động",
EXP = "EXP: ",
GOLD = "Tiền:",
GET_REWARD = "Nhận thưởng",
IMMEDIATELY_RECHARGE = "Nạp ngay",
START_FIGHTING = "Chiến đấu",
CONTINUE_GAME = "Tiếp tục",
GOODS_INFO = "Thông tin vật phẩm",
RENEWAL = "Gia hạn",
USE = "Dùng",
NOLIMIT = "Vĩnh viễn",
INPUT_NEW_NAME = "Hãy nhập tên mới: ",
CLICK_TO_INPUT_NAME = "Nhập tên mới",
USE_RESET_FAIL_NUM = "Dùng sẽ xóa số lần chiến đấu thất bại",
GIFTBAG_LEVEL_NO = "Cấp chưa đạt điều kiện",
SPREE_SUCCESS = "Chúc mừng nhận vật phẩm sau",
IMPROVE_REWARD = "Tăng thưởng",
--背包
COMBAT = "Lực chiến",
COMMUNITY = "Công Hội",
POST = "Chức",
DESIGNATION = "Danh hiệu",
LEVEL = "Cấp",
HEALTH = "S.Lực",
DEFENSE = "P.Thủ",
CRIT = "Bạo kích",
PHYSICAL = "Thể lực",
ATTACK = "T.Công",
FREESTORM = "Miễn bạo",
ANTIBREAKING = "Phá giáp",
LUCKY = "M.Mắn",
STRENGTEN = "Cường hóa",
BAG1 = "Vật phẩm",
SHOP = "Cửa Hàng",
NONE = "Không",
HEAD = "Đầu",
FACE = "Biểu cảm",
BODY = "Thân",
WING = "Cánh",
RING = "Nhẫn",
NECKLACE = "Dây chuyền",
--游戏大厅
PRIMARY = "Kênh sơ cấp",
ADVANCE = "Kênh cao cấp",
ROOM_PASSWORD = "Mật khẩu: ",
ROOM_PEOPLO_NUM = "Số người trong phòng",
MACTH_TYPE = "Trung gian",
RANDOM = "Ghép",
TEAM = "Đội",
ROOM_NAME_RANDOM = {"Hãy cùng vui chơi!",
"Hãy cảm nhận trận đấu ác liệt!",
"Dám đấu chứ?!",
"Hãy cùng thi đấu!",
"Đánh một trận tơi bời nào!"},
NO_PASSWORD = "Không mật khẩu",
INPUT_ROOM_ID = "Hãy nhập ID phòng",
ROOM_ID = "ID phòng",
CLICK_TO_INPUT_ID = "Nhập ID phòng",
CLICK_TO_INPUT_PASSWORD = "Nhập mật khẩu phòng",
PASSWORD_NOT_MATCH = "Mật khẩu không đúng",
ROOM_BATTLEING = "Người khác đang chơi game!~",
ROOM_FULL = "Phòng đầy người",
OPEN_ON_ADVANCED_CHANNEL = "Mở kênh cao cấp",
SKILL = "Lĩnh ngộ",
PROP = "Đạo cụ",
INVITATION_HAS_BEEN_SENT = "Đã gửi lời mời",
READY_GAME = "Chuẩn bị vào game",
START_GAME = "Chơi ngay",
MATCH_FAILED = "Thao tác thất bại",
TIPS = "Nhắc nhở",
ROOM = "Danh sách phòng",
PRIMAY_CHANNEL = "Kênh sơ cấp",
ADVANCE_CHANNEL = "Kênh cao cấp",
TARGET_VIP_LEVEL_OVER_THEN_YOU = "Cấp VIP không đủ, không thể mời đối phương ra",
--聊天
CHAT_SENDMORE = "Tin chat gửi quá nhiều!",
CHAT_CONTENTNULL = "Nhập nội dung chat",
CHAT_ALL = "Toàn bộ",
CHAT_COLORLIAO = "Chat màu",
CHAT_WORLD = "Thế Giới",
CHAT_PRIVATE = "Chat riêng",
CHAT_CURRENT = "Hiện tại",
CHAT_MSG_CONTENT = "Nhập nội dung chat!",
CHAT_MSG_ID = "Không thể chat riêng với trợ thủ!",
CHAT_SYSTEM = "Hệ thống",
CHAT_RIGHT = "với",
CHAT_COLORLIAOK = "[Chat màu]",
CHAT_WORLDK = "[Thế Giới]",
CHAT_GONGHUIK = "[Công Hội]",
CHAT_PRIVATEK = "[Chat riêng]",
CHAT_CURRENTK = "[Hiện tại]",
CHAT_SYSTEMK = "[Hệ thống]",
CHAT_NOCOLORLABA = "Loa Liên Server không đủ, hãy đi mua!",
CHAT_NOLABA = "Loa không đủ, hãy đi mua!",
--爱心许愿
STRENGTHENTIP = "6 trang bị %s +%d",
REWARD_CURRENTLOTTERYTIMES = "Số lần rút thưởng hiện tại: ",
REWARD_NEXTZUAN = "Số Kim Cương cần nạp cho thưởng bậc kế: ",
REWARD_NEXTLOTTERYTIMES = "Số lần rút thưởng bậc kế: ",
REWARD_MSGCHONGZHI = "Không thể rút thưởng, hãy nạp.",
REWARD_BTN_FIRSTGET = "Nhận thưởng",
REWARD_BTN_GET = "Nạp",
REWARD_BTN_REWARD = "Rút thưởng",
REWARD_FIRST_INTORDUCE = "Nạp lần đầu sẽ nhận: ",
--商城
SHOP_LIFT = "S.Lực: ",
SHOP_GONGJI = "T.Công: ",
SHOP_BAOJI = "B.Kích:",
SHOP_DEFEND = "P.Thủ: ",
SHOP_NOCHENGHAO = "<Không danh hiệu>",
SHOP_NOGONGHUI = "Chưa vào Công Hội",
SHOP_GOODSSHEGN = "Còn ",
SHOP_CISHU = " lần",
--活跃度
ACTIVE_BTN_GET = "Nhận",
ACTIVE_BTN_GO = "Đến ",
ACTIVE_FINISH = "Đã hoàn thành",
ACTIVE_GET = "Đã nhận",
--砸蛋
THROWINGEGGS_MSG_ZUAN = "Lần đập trứng này trừ Kim Cương",
THROWINGEGGS_MSG_THROWEGG = "Đang đợi người chơi khác đập trứng: ",
--结婚
MARRY_DREAM_CONTENT = "Mình nghĩ rằng không ai có thể thích hợp sở hữu nó hơn bạn.",
MARRY_ROMAN_CONTENT = "999 đóa hoa hồng tượng trưng cho mãi ở bên nhau, mà bạn thì nên có đầy trời hoa hồng, có tất cả mọi điều hạnh phúc.",
MARRY_WARM_CONTENT = "Mình chỉ muốn đeo nó lên tay bạn, cả đời mãi có nhau!",
MARRY_SIMPLE_CONTENT = "Mình chắc chắn nó sẽ hợp với bạn, vì nó là lời ước hẹn rằng bạn sẽ luôn có mình ở bên cạnh.",
AGREE = "Đồng ý",
REJECT = "Từ chối",
MARRY_ITEM_NOT_ENOUGH = "Chưa có đạo cụ cầu hôn, đồng ý mua?",
MARRY_OK = "Chúc mừng, %s và bạn đính hôn thành công!",
MARRY_FAILD = "Cầu hôn thất bại, %s từ chối lời cầu hôn của bạn!",
MARRY_END = {"Để kết hôn cần phải đợi sau %s", "Đổi đạo cụ tiêu hao", "Kết hôn lần tiếp theo cần đợi sau", "Tiệm Đổi Sự Kiện", "Tiệm Đổi Bí Ẩn", "Tiệm Đổi Đặc Biệt", "Lò Rèn Thần Thoại", "Cảnh Báo!", "Đổi Vật Phẩm", "Đổi tiêu hao tất cả vật phẩm"},
MARRY_END_TIPS = "Hủy quan hệ sẽ nộp phí %d Kim Cương, đồng ý chứ?",
MARRY_END_SUCCESS = "%s đã xin phép hủy đính hôn thành công, quan hệ đính hôn của các bạn đã bị xóa.",
WEDDING_LUXURY = "Hôn Lễ Xa Hoa",
WEDDING_RICH = "Hôn Lễ Hào Hoa",
WEDDING_ROMAN = "Hôn Lễ Lãng Mạn",
WEDDING_ORIGINAL = "Hôn Lễ Thường",
WEDDING_ASK_TIPS = "Người yêu muốn cùng bạn tổ chức %s",
WILLING = "Đồng ý",
THINK_ABOUT = "Suy nghĩ lại",
WEDDING_SUCCUSS = 
[[
Chúc mừng, kết hôn thành công với %s, 
Chúc hai bạn trăm năm hạnh phúc!
]],
WEDDING_FAILD = "Hôn lễ thất bại, người yêu của bạn cần thêm thời gian để suy nghĩ!",
WEDDING_DIVORCE = "Ly hôn",
WEDDING_END_REQUEST = "Xin phép ly hôn sẽ nộp phí %d Kim Cương, sau khi ly hôn sẽ mất lễ phục, đồng ý?",
WEDDING_END_TIPS = "%s đã xin phép ly hôn thành công, quan hệ hôn nhân và lễ phục của các bạn đã bị xóa.",
GIVE = "Tặng",
GIVE_DIAMOND_TIPS = "%s tặng bạn %d Kim Cương.",
--战斗
BATTLE_EXIT_WARNING = "Nhắc nhở: Cố ý thoát sẽ trừ EXP thi đấu!",
BATTLE_EXIT_WARNING2 = "Đừng bỏ rơi đồng đội chứ!",
BATTLE_EXIT_WARNING3 = "Vượt phó bản sẽ nhận thưởng!",
BATTLE_EXIT = "Thoát",
BATTLE_EXT_ITEMSKILL_LIMIT = "VIP1 sẽ mở tính năng này",
BATTLE_ANGER_LIMIT = "Nộ Khí chưa đầy",
BATTLE_USE_BIGSKILL = "Dùng POW",
BATTLE_FAIL_BIGSKILL = "Đã dùng kỹ năng, không thể tiếp tục dùng POW",
--副本房间
BOSSROOM_SKILLPROP = "Đạo cụ kỹ năng",
BOSSROOM_INVITATION_HAS_BEEN_SENT = "Đã gửi lời mời",
BOSSROOM_MATCH_FAILED = "Thao tác thất bại",
BOOSROOM_KICKEDOUT= "Bạn bị chủ phòng mời khỏi phòng",

BATTLETEAM_PLAYER_ALREADY_ROOM = "Người chơi đã ở trong phòng",
--显示炮弹的高度
BULLET_HEIGHT = "Độ cao: %dm",
--新手战斗教学
SKILL_DIVIDE_THREE = "Bắn Lan Tỏa x3",
SKILL_ATTACKUP_FIVE = "Tấn Công +50%",
SKILL_ADDTIMES_ONE = "Bắn Liên Tục +1",
ITEM_BLOOD = "Túi Trị Liệu",
START_MY_TURN = "Đến lượt bạn",
START_OTHER_TURN = "Đến lượt đối phương",
TEACH_GUIDE_USEFLY = "Nhấn máy bay sẽ có thể khiến nhân vật bay ở lượt tiếp theo",
TEACH_GUIDE_FLY = "Nhấn tay vào nhân vật và kéo theo hướng ngược hướng bay sẽ khiến nhân vật bay đến đó",
TEACH_GUIDE_BIGSKILL = "Khi Nộ Khí đầy, nhấn Power sẽ dùng tuyệt chiêu gây sát thương mạnh.",
REACH_TOP_STRENGTHENLEVEL = "Trang bị đã cường hóa đến cấp tối đa, không thể tiếp tục cường hóa!",
BOSSROOM_SWITCH_DIFFICULTY_TIPS1 = "Chưa vượt dạng Dễ, không thể khiêu chiến dạng Khó ",
BOSSROOM_SWITCH_DIFFICULTY_TIPS2 = "Chưa vượt dạng Khó, không thể khiêu chiến dạng Địa Ngục ",
BOSSROOM_SWITCH_DIFFICULTY_TIPS3 = "Đổi thất bại, phòng có thành viên chưa đủ điều kiện",
SOUND = "Âm thanh",
DIALOG_GUIDE_FAST_ENTER = "Nhấn ở đây để vào phòng nhanh!",
BUY_STARSTONE_MESSAGE = "Đá Tăng Sao không đủ, muốn mua chứ?",
CANCEL_ENEMY_COMMUNITY_SUCESS = "Hủy Công Hội địch thành công",
WND_EXISTACCOUNT_ACCOUNT = "Tài khoản: ",
WND_EXISTACCOUNT_PASSWORD = "Mật khẩu: ",
E_BATTLE_GIFTYES = "Có ",
SHOP_PAY = [[<T C="255,255,255" S="30" >]]..[[%d ngày: ]]..[[</T>]]..[[<I>%s</I><T C="232,223,0" S="30" >]]..[[%d]]..[[</T>]]..[[<T C="255,255,255" S="30" >]]..[[Kim Cương]]..[[</T>]],
LOADING_TIP = "Có thể cường hóa để tăng thuộc tính cơ bản cho vũ khí, trang phục",
BATTLE_MODEL_SPORT = "Dạng Thi Đấu",
BATTLE_MODEL_REVIVE = "Dạng Hồi Sinh",
BATTLE_MODEL_MIX = "Dạng Giao Chiến",
BATTLE_MODEL_COMMUNITY = "Dạng Công Hội",
ROOM_BEINVITED = "%s mời tham gia\n%s (%s)",
BATTLE_NOT_MY_TURN = "Chưa đến lượt thao tác",
LEVEL_NOT_ENOUGH_CHALLENGE = "Chưa đạt Lv%d, không thể khiêu chiến ải này",
ACCELERATE_SUCCESS = "Tăng tốc thành công",
ONLY_ROOMOWNER_CAN_SELECT = "Chỉ có chủ phòng mới có thể chọn độ khó!",
DOWNLOAD_RES_FAIL_TIPS = "Không thể kết nối đường truyền, hãy kiểm tra lại",
NO_SPACE_TO_DOWNLOAD_TIPS = "Dung lượng không đủ, hãy sắp xếp lại thiết bị rồi thử lại",
ACTIVE_NOLEVEL = [[Cấp không đủ, cần đạt Lv%d mới mở tính năng này]],
NEED_DOWNLOAD_TIPS = "Lần cập nhật này cần tải %0.2fMB. (Gợi ý: File khá lớn, kiến nghị dùng WIFI để tải)",
NEED_DOWNLOAD_TIPS_V16 = "Game đang cập nhật, vui lòng đợi.",
SIGN_REWARD = "Nhận: ",
SHOP_DAY = [[%d ngày]],
RESOURCES_LOADING = "Đang tải",
DAILYSIGN_REWARD = "Thưởng điểm danh ngày",
CONTINUALSIGN = "Điểm danh liên tục",
MONTHLYSIGN = "Điểm danh tháng",
DAILYSIGN_MSG = " ngày có thể nhận",
STAR_LEVEL = "Cấp sao",
POWER = "S.Mạnh",
AGILITY = "Tốc độ",
TIZHI = "T.Chất",
SHI = "Đá",
SUGGESTION_INIT = "Nhập nội dung (150 ký tự)",
CHECK_VESION = "Đang kiểm tra tài nguyên",
LOADING_TIPS = {
[[Có thể rèn để tăng thuộc tính cơ bản trang bị.]],
[[Trong chiến đấu, có thể dùng hai ngón tay để thu nhỏ phóng to]],
[[Đạt Lv15 có thể tạo Công Hội!~]],
[[Bạn bè có thể tặng Thể Lực cho nhau mỗi ngày!~]],
[[Nhấn giữ hai bên nhân vật có thể di chuyển trái phải!]],
},
RECHARGE_FAIL = "Nạp thất bại!",
SELECT_ALL = "Chọn hết",
BATTLE_RECONNECT_FAIL = "Kết nối chiến đấu thất bại, quay về sảnh",
RECHARGE_SUCCESS = "Nạp thành công!",
REWARD_FIRST = "Nhận thưởng nạp lần đầu thành công",
SHOOT_GUIDE_CLOSE = "Chúc mừng đạt Lv%d! Hệ thống sẽ không hiện chỉ dẫn tự động nữa!",
LOGIN_FAILD = "Hãy dùng tài khoản đúng để đăng nhập.",
ROLEINFO_MATE ="Người yêu",
MARRY_PROPOSE = "Cầu hôn",
WEDDING_LIST = "Danh sách hôn lễ",
WEDDING = "Cử hành hôn lễ",
RECHARGETIP = "Nạp nhận thưởng bạo kích",
TASK_UPEXP_LIMIT = "Nhiệm vụ này đã đạt cấp tăng tối đa",
BRIGE_GROOM_NAME = "Chú rể: ",
BRIGE_NAME = "Cô dâu: ", 
START_TIME = "Bắt đầu: ",
UPPHOTO = "UploadAvatar: ",
RECHARGEFAIL = "Chưa thể nhận phúc lợi hoàn trả!",
RECHARGESUCCESS = "Chúc mừng nhận hoàn trả nạp bạo kích Kim Cương!",
EXIT_WEDDING_SCENE = "Thoát Sảnh Hôn Lễ?",
NOT_WEDDING_LIST = "Tạm chưa có thông tin tổ chức Hôn Lễ",
LEO = "Sư Tử",
PHOTO = " Avatar",
SEX = "Giới tính",
DISTANCE = "Cự ly",
SINGLE_MAP_USEVIGOR = "Thể Lực tốn: ",
SINGLE_MAP_VIGOR = "Thể Lực: ",
SINGLE_MAP_CHALLENGE = "Lần khiêu chiến: ",
RECHARGEDESC = "Nạp Kim Cương sẽ tích lũy bạo kích, đạt bạo kích nhất định sẽ nhận thưởng hoàn trả! Mức nạp càng lớn, mức hoàn trả càng cao!",
WEDDING_OVER = "Hôn lễ này đã kết thúc!",
NEXT_PAGE_TIP = "Kéo lên trên sẽ tải trang sau",
FRONT_PAGE_TIP = "Kéo xuống dưới sẽ tải trang trước",
VOICECHAT = "Ngăn Voice",
SUGGESTTYPE="Loại ý kiến:",
UPPHOTOFAIL = "Chụp thất bại!",
SUGGESTTYPE_SUGGEST="Kiến nghị",
SUGGESTTYPE_QUESTIONASK="Trưng cầu vấn đề",
SUGGESTTYPE_PAYASK="Trưng cầu nạp",
LITLE_MAP = "Bản đồ",
NEED_UPDATE_VERSION = "Hãy cập nhật phiên bản mới.",
TIP_INPUT_ACCOUNT = "Gồm chữ cái (Hoa và thường) và chữ số, 6-16 ký tự",
TIP_INPUT_PASSWORD = "Gồm chữ cái (Hoa và thường) và ký hiệu đặc biệt, 6-12 ký tự",
TIP_INPUT_PASSWORD_CONFIRM = "Nhập lại mật khẩu",
TIP_INPUT_MAIL = "Nhập email để dùng khi tìm lại mật khẩu",
ExchangeGift = "Hãy nhập code:",
INVITECODE = "Code",
PURCHASE = "Mua vật phẩm",
CHALLENGE = "Ải khiêu chiến",
WIPE_OUT = "Càn quét",
REFRESH = "Tạo mới",
ADDFRIEND = "Kết bạn",
DELFRIEND = "Xóa bạn",
MARRY_GUEST = "Khách",
APPLY_ATTEND_COMMUNITY = "Xin vào Công Hội",
DAY = " ngày",
RECHARGE_ORDER_FAIL = "Kiểm tra thất bại",
RECHARGE__IN_PROCESS = "Đang xử lý",
DOWNROAD_REQUIRE_SD_CARD = "Dùng ứng dụng này cần có thẻ SD",
SELECTROLE_ENTER_GAME = "Vào game",
YES = "Đúng",
DOWNLOADREWARD_BADGE = "Huy Hiệu",
DOWNLOADREWARD_TIP = 
[[
Đang cập nhật, cập nhật xong nhận được: 
(Chú ý: Thưởng chỉ phát 1 lần)
]],
NO_BLACKCHAR = "Tài khoản hoặc mật khẩu không thể có khoảng trắng",
NO_CONTROLCHAR = "Mật khẩu không thể có ký hiệu đặc biệt",
GOTOPROTOCOL = "Xem Điều khoản người dùng",
ISBLANKKEY= "Nội dung không thể để trống!",
PLAYER_RENAME = "Đổi tên nhân vật thành công",
COMMUNITY_RENAME = "Đổi tên Công Hội thành công",
MULTI_SCRIPT = "Phó bản nhóm",
SINGLE_SCRIPT = "Vùng Mạo Hiểm",
BAG = "Túi",
CARDS = "Thẻ",
PRACTICE = "Tu luyện",
BSTRONG = "Mạnh lên",
CLOSE_SCRIPT = "Chưa mở",
PRACTICE_BLOOD = "S.Lực",
PRACTICE_ARMOR = "H.Giáp",
NOSTONE_STRENGTHEN = "Chưa khảm đá",
AVOIDINJURY= "M.Thương",
XH_REDUCEBURY = "Chống đào",
ACTIVITY = "Năng động",
UNLIMITE = "Không giới hạn",
CHOISE_CARTON = "Chọn phó bản",
REWARD_CARTON = "Thưởng phó bản",
SWEEP_TIME = "Số lần càn quét",
NEED_ACTIVITY = "Thể Lực cần",
LEFT_ACTIVITY = "Thể Lực còn ",
SWEEP_DESC = 
[[
1. Ải đã vượt mới được càn quét.
2. Có thể chọn số lần càn quét.
3. Đang càn quét không thể dừng.
4. Thưởng sẽ tự gửi vào Túi.
5. Càn quét xong có thể xem phần thưởng được nhận.
]],
OVER_SWEEP_COUNT = "Không thể vượt số lần càn quét tối đa!",
SWEEPING_NOT_SHUT = "Đang càn quét, không thể đóng!",
SWEEPING_NOW = [[<T C="255,255,255" S="25" P="0">Đang càn quét...</T>]],
SWEEPTIME_EXP = [[<T C="255,255,255" S="25" P="0">Lần </T><T C="0,246,34" S="25" P="0">%d</T><T C="255,255,255" S="25" P="0">: Nhận </T><T C="0,246,34" S="25" P="0">%d</T><T C="255,255,255" S="25" P="0"> EXP, </T>]],
SWEEP_GET_SWARD = [[<T C="255,255,255" S="25" P="0">Nhận</T><T C="0,246,34" S="25" P="0"> %s </T>]],
SWEEP_TIMMING = [[<T C="255,255,255" S="25" P="0">Đang càn quét </T><T C="0,246,34" S="25" P="0">［%s］</T><T C="255,255,255" S="25" P="0"> sau kết thúc</T>]],
CHECK_REWARD = "Xem thưởng",
NO_LESS_ONE = "Số lần càn quét không thể dưới 1!",
SWEEP_ENDIND = [[<T C="255,255,255" S="25" P="1">Càn quét kết thúc</T>]],
SWEEP_MAPNAME = [[<T C="255,255,255" S="25" P="0">Ải càn quét: </T><T C="0,246,34" S="25" P="0">%s</T>]],
SWEEP_TIMES = [[<T C="255,255,255" S="25" P="0">Lần khiêu chiến còn: </T><T C="0,246,34" S="25" P="0">%s</T>]],
SWEEP_USEDACT = [[<T C="255,255,255" S="25" P="0">Thể Lực tốn: </T><T C="0,246,34" S="25" P="0">%d</T>]],
SWEEP_WINEXP = [[<T C="255,255,255" S="25" P="0">Tổng EXP nhận: </T><T C="0,246,34" S="25" P="0">%d</T>]],
--在线奖励
REWARD_BTN_LOGIN = "Đăng nhập",
REWARD_BTN_ONLINE = "Online",
BUY_UNSUCCESS = "Số lần mua hôm nay đã đạt tối đa, hãy tăng cấp VIP để tăng số lần mua!",
TASK_QUICKCOMPLETE = "Xong nhanh",
TASK_DOING = "Đang làm",
SPECIAL = "Đặc biệt",
CONTINUOUSATTACKS = "Liên tục tấn công",
MIGHTHIT = "Uy lực",
TRACKPOSITION = "Định vị",
UNMOUNTED = "Chưa khảm",
RENEWALS = "Gia hạn",
RANGE  = "Phạm vi",
SKAT = "POW",
GEM = "Đá",
WEAR = "Mặc",
UNROYAL = "Tháo",
SELL = "Bán",
TRYWEAR = "Mặc thử",
VIP = "Hội viên",
STRENGTENRECV = "Cường hóa đạt Lv%d nhận",
PRACTICE_NOLEVEL= "Cấp tu luyện đã đầy, hãy tăng đến Lv%d",
LAY = "Thiết lập",
DAILY_FRIST_RECHARGE = "Nạp lần đầu mỗi ngày sẽ nhận đạo cụ sau",
NO_CHALLENGE_TIMES = "Số lần khiêu chiến không đủ để càn quét!",
CANNOT_BUY_VIGOR = "Thể Lực đã cao nhất, không thể mua tiếp",
UPGRADE = "Tăng cấp",
MAP_EVENT = "Sự kiện đặc biệt",
MAP_EVENT_ON = "Mở",
TEACH_CHICK = "Nhấp đồng ý",
MAINTASK_UPLEVEL_TITLE = "Đạt Lv%d",
MAINTASK_UPLEVEL_GOALS = [[<T C="0,246,34" S="24" P="0">Đạt Lv%d </T><T C="255,0,0" S="24" P="0">(%d/%d)</T>]],
IKNOW = "Đã xem",
DAILY_RECHARGE = "Nạp ngày",
TZSX = "Thuộc tính bộ",
IMPROVE_REWARD_NEED = "Tăng thưởng cần tốn ",
NOMORETIP = "Không nhắc lại",
MONTH_CARDS_TIP6 = "Hết hạn",
MONTH_CARDS_DIAMOND = "Kim Cương",
CONTINUOUS = "Liên tục ",
BUY = "Mua",
COMPLETE_TASK = "Hoàn thành",
RINGLEFT = "Nhẫn",
VIP_TIP02 = "Cấp VIP đã đủ, cảm ơn đã ủng hộ!",
VIP_TIP04 = "Hiện tại: ",
VIP_TIP06 = "Nạp tiếp",
VIP_TIP08 = [[<T C="255,255,255" S="32" P="0">Cần đạt </T><T C="255,255,0" S="32" P="0">VIP%d</T><T C="255,255,255" S="32" P="0"> mới được nhận</T>]],
VIP_POWER = "Đặc quyền",
PRACTICE_DAY_COST_TIP = "Không đủ huy chương, cấp hiện tại mỗi ngày tốn %d huy chương",
RINGLEFTEXP = "Nhẫn",
REWARD_EXPLAIN_MESSAGE = 
[[
1. Nạp lần đầu hằng ngày nhận thưởng tương ứng.
2. Tối đa nhận thưởng %d lần.
3. %d-%d Kim Cương nhận %d lần, %d-%d Kim Cương nhận %d lần, %d Kim Cương trở lên nhận %d lần.
]],
TEACH_OPEN = "Mở tính năng mới",
PRACTICE_HELP = 
[[
1. Lv35 mở Tu Luyện.
2. Tu luyện gồm 80 cấp.
3. Hoàn thành nhiệm vụ ngày và nhận quà VIP được nhận Huy Hiệu.
4. Huy Hiệu dùng để tăng tu luyện, tăng cấp tu luyện nhận thuộc tính tương ứng.
]], 
ATGHLETICS = "Thi Đấu",
QUICK_COMPLETE_NEED = "Xong nhanh nhiệm vụ này cần tốn",
GIRL = "Giới tính (Nữ)",
BOY = "Giới tính (Nam)",
DEFAULT = "Mặc định",
TIP_INPUT_OLD_PASSWORD = "Nhập mật khẩu cũ",
ISFRIEND = "Người chơi này đã trong danh sách bạn bè",
PRACTICE_ATTRIBUTE_NAME = "Thuộc tính tu luyện",
PRACTICE_NEED_NAME = "Tu luyện cần",
TIP_WILLBE_OPEN_MULTILPE = "Lv%d mở phó bản nhóm",
MONEY_UNIT = " Đồng",
NONE_CHALLENGE_TIMES = "Lượt khiêu chiến không đủ!",
ZSLEVEL_NOT_ENOUGH_CHALLENGE = "Chưa đạt chuyển sinh Lv%d, không thể khiêu chiến ải này",
ENERGY = "Thể Lực",
BUY_VIGORS = "Thể Lực không đủ, hãy dùng Bánh Donut hoặc mua trực tiếp.",
GETREWARD_GOLDS = [[<T C="0,246,34" S="25" P="0"> %d </T><T C="255,255,255" S="25" P="0">Vàng, </T>]],
SWEEP_WINGOLDS = [[<T C="255,255,255" S="25" P="0">Vàng nhận: </T><T C="0,246,34" S="25" P="0">%d</T>]],
MAILMAXLENG = "Nhấn viết nội dung thư, tối đa 200 ký tự",
MAILTITELENT = "Nhập tiêu đề thư",
NUM1 = "Số lượng ",
Praticefull = "Cấp tu luyện thuộc tính hiện tại đã đầy!",
MONTH_CARDS = "Thẻ Tháng",
DIALOG_TASK_ISLAND = "Hiện tại còn nhiệm vụ chưa hoàn thành!",
CAN_NOT_MATERIALS = "Nguyên liệu ghép không đủ!",
TEACH_BOSS_NAME = "Nấm Tròn",
TEACH_BATTLE_TALK_TEXT_8 = "Nấm Nhỏ đợi hiệu lệnh của ta, bay nào!",
CONNECTED_SERVER = "Đang kết nối máy chủ",
DOWNLOAD_RESOURCE = "Đang dữ liệu",
SETTLMENT_KILL = "Diệt", 
SETTLMENT_DAMAGE = "Sát thương", 
SETTLMENT_HIT = "Chính xác", 
SETTLMENT_GANGFIGHT = "Công Hội Chiến ",  
LOTTERY_OPEN = "Mở ô thần bí",
LOTTERY_OPENNING = "Đang mở thưởng",
duihuan = "Đổi",
USEPASSWORD = "Dùng mật khẩu",
SetPASSWORD = "Đặt mật khẩu",
MAINTASK_UPLEVEL_GOALS_NEEDZS = [[<T C="0,246,34" S="24" P="0">Chuyển sinh Lv%d </T><T C="255,0,0" S="24" P="0">(%s %d/%s %d)</T>]],
MAINTASK_UPLEVEL_ZS_TITLE = "Tăng cấp đến chuyển sinh Lv%d",
TASK_BRANCH = "Phụ",
SINGLEMAP_DESC = 
[[
1. Vào Vùng Mạo Hiểm cần tốn Thể Lực, Thể Lực mỗi 6 phút hồi 1 điểm.
2. Mỗi ải tốn Thể Lực khác nhau.
3. Số lần vượt ải mỗi ải khác nhau.
4. Số lần vượt ải tạo mới mỗi ngày.
5. Mở ải cần cấp nhất định.
6. Đạt cấp yêu cầu cần vượt ải trước mới được khiêu chiến ải kế tiếp.
7. Vùng Mạo Hiểm đã vượt có thể càn quét, mỗi lần tốn Vé Càn Quét.
8. VIP4 được càn quét liên tục.
]],
STAR_SOUL_BUTTON_UPDATE = "Tăng cấp", 
STAR_SOUL_LIGHT_FAIL = "Tăng cấp thất bại",
ACTIVITY_END_COUNTDOWN = "Kết thúc còn ",
ACTIVITY_START_COUNTDOWN = "Bắt đầu đếm ngược",
ACTIVITY_EATTING_TXT = "Thưởng thức",
ACTIVITY_TASTEOK_TIPS = "Thêm Thể Lực thành công",
BATTLE_MODEL_RANK = "Đấu Hạng",
CHESTTITLE = "Hãy chọn số rương mở",
CHEXTTIP = "Một lần mở tối đa %d",
ACITIVITY_RECHARGE_MSG = "Không có nhật ký nạp, không thể nhận thưởng.",
SALETIP = "Vật phẩm bán có thuộc tính cường hóa, tăng sao hoặc khảm, đồng ý bán?",
CARD_ADVANCE = "Tiến giới",
PLAYER = "Người chơi",
OFFLINE = "Không online.",
WIPE_OUT_MULTI = "Càn quét %d lần",
WIPEOUTNUM = "Vé Càn Quét không đủ",
ACTIVITY_TIME_KEY = "Thời gian hoạt động",
ACTIVITY_TIMELINE_KEY = "%d/%d - %d/%d",
ACTIVITY_COST_KEY = "Tích lũy tiêu phí",
ACTIVITY_CURRENT_COMPETILIVE_LEVEL = "Cấp thi đấu: ",
ACTIVITY_CURRENT_FIGHTING = "Lực chiến: ",
ACTIVITY_SHOW_LEVEL = "Lv%d",
ACTIVITY_BIG_GIFTPACKS = "Đạt ",
ACTIVITY_CUMULATIVE_LOGIN = "Đã tích lũy đăng nhập ",
ACTIVITY_CUMULATIVE_LOGIN_CP = " ngày",
ACTIVITY_SUCCESSFUL_STRENGTHEN_ANY = "Thành công cường hóa ",
ACTIVITY_EQUIPMENT_NUMBER = "%d món",
ACTIVITY_EQUIPMENT_TO = "Trang bị đến ",
ACTIVITY_EQUIPMENT_TOTARGET = "+%d",
ACTIVITY_CURRENT_CONSUMPTION = "Đã tốn ",
ACTIVITY_PREPAID_PHONE = "Đã nạp ",
CHESTMAXNUM = "Đã đạt tối đa",
CHESTMINNUM = "Đã đạt tối thiểu",
CHESTNOKEY = "Chìa Khóa không đủ",
ROOM_FIND_TIPS = "Hãy nhập đúng số phòng",
EQUIP = "Trang bị",
BRACELET = "Bao tay",
MEDAL = "Huy hiệu",
TREASURE = "Bảo vật",
CREATE_ROOM = "Tạo phòng",
CHANGE = "Sửa",
BAGBTNTEXT3 = "Kết bạn",
CLOTHES = "Trang phục",
HALL = "Sảnh",
MASTER_APPRENTICE = "Sư đồ",
MASTER = "Sư phụ",
APPRENTICE = "Đệ tử",
COMBATTING = "Chiến đấu",
ROOM_NUMBER = "Số phòng: ",
ROOM_NAME_BATTLE = "Tên phòng: ",
EVOLUTION = "Tiến hóa",
REBIRTH = "Trùng sinh",
MY_PETS = "Pet",
INTELLIGENCE = "Tư chất",
EXTRACTING_PETS = "Nhận Pet",
EXTRACTION = "Rút",
EXTRACTION_AGAIN = "Lần nữa",
PET_REBIRTH = "Trùng sinh",
DRESS = "Thời trang",
ROOM_SETTING = "Thiết lập phòng",
INVITE_PLAYER = "Mời",
PUT_SYNTHESIS_MATERIAL = "Hãy bỏ vào vật phẩm cần ghép",
CANNOT_FIND_SYNTHESIS_DATA = "Không thể ghép",
PLAYER_RANK_SCENEWORLDBOSS = "Hạng: ",
MAYBE_SUCCESS_SCENEWORLDBOSS = "Tỉ lệ thành công",
RANK_TIPS_1 = "Hạng %d",
RANK_TIPS_2 = "%d + Tên",
RANK_TIPS_3 = "Hạng %d-%d",
HURT_RANK_INFO = "Hạng ST: ",
COPY_VIGOUR_COST = "Thể Lực tốn: ",
NORMAL = "Thường",
PROBABILITY_DROP = "Tỉ lệ rơi",
MUST_SUCCESS_SCENEWORLDBOSS = "Chắc chắn thành công",
HURTTIPS_MSG_1 = "Người chơi top 3 sát thương được thưởng phong phú",
HURTTIPS_MSG_2 = "Diệt Khuyển Vực Sâu được nhận thêm thưởng tiêu diệt",
CHALLENGE_NOT_ENOUGH = "Lượt khiêu chiến ải không đủ",
SWEEP_INDEX = "Trận thứ %d",
FIRST_PASS = "Lần đầu vượt ải",
PASS_REWARD = "Thưởng vượt ải",
BACK_TIME = "%02d giây sau tự quay về",
LEVEL_LOCKED = "Vượt ải trước mới được khiêu chiến ải này",
LEVEL_UNREACHED = "Lv%d mở",
ACHIE_TITLE = "Thành tựu",
ACHIE_EFFECT = "Thuộc tính danh hiệu",
DESIGNATION_NO = "Không có danh hiệu",
DESIGNATION_SHOW = "Hiện tại",
DESIGNATION_ASSOCITION = "Công Hội",
DESIGNATION_ACTIVITY = "Hoạt Động",
DESIGNATION_SPECIAL = "Đặc Biệt",
DESIGNATION_SHIP = "Kết Hôn",
MASTER_DESIGNATION = "Danh hiệu sư đồ",
DESIGNATION_ACHIE = "Thành Tựu",
PLAYER_LEVEL_UNREACHED = "Lv%d mở Chat Thế Giới",
WAITING = "Đang đợi",
CREATE_COPY = "Tạo phó bản",
DIFFICULTY_LEVEL = "Độ khó",
RESET = "Tạo mới",
RESET_TIPS = [[<T S="24" C="220,211,185">Số lần khiêu chiến phó bản này = </T><T S="24" C="220,0,0">%d </T><BR>10</BR><T S="24" C="220,211,185" P="0">Tốn </T><I>%s </I><T S="25" C="246,246,0" P="0">%d%s</T><T S="24" C="220,211,185" P="0"> có thể tạo mới phó bản tiếp tục khiêu chiến</T>]],
WAITING_OTHERS_TURN_CARD = "Đang đợi người chơi khác lật thẻ: ",
TURN_CARD_COST = [[<T S="26" C="220,211,185" P="0">Lật thẻ trừ </T><I P="0">%s </I><T S="24" C="246,246,0" P="0">%d Kim Cương</T>]],
PLAYER_LEVEL_UNLOCK_COPY = "Lv%d mở",
COPY_LOCKED = "Vượt phó bản trước mới được khiêu chiến",
PET_REBRITH_EXPLAIN = "Trùng sinh Pet có thể nhận EXP Pet và Pet cần để tiến hóa",
RESET_NOT_ENOUGH = "Số lần tạo mới không đủ",
CONFORM_CHANGE = "Đồng ý sửa",
LEVEL_UNLOCK = "Lv%d mở",
LOCKED = "Chưa mở khóa",
RANKLIST_ITEM_MRT = "Top 3",
RANKLIST_ITEM_RYD = "Điện Vinh Dự",
RANKLIST_ITEM_SJH = "DHUB",
RANKLIST_ITEM_ZHANLI = "Lực Chiến",
RANKLIST_ITEM_DENGJI = "Cấp",
RANKLIST_ITEM_CHONGWU = "Pet",
RANKLIST_ITEM_ZUOQI = "Thú Cưỡi",
RANKLIST_ITEM_ZHANJI = "Chiến Tích",
RANKLIST_ITEM_CHENGJIU = "Thành Tựu",
RANKLIST_ITEM_GONGHUI = "Công Hội",
RANKLIST_ITEM_MEILI = "Hấp Dẫn",
RANKLIST_ITEM_SHIDE = "Sư Đức",
RANKLIST_ITEM_ENAI = "Tình Cảm",
POPUPMENUSTRING1 = "Thêm bạn",
POPUPMENUSTRING2 = "Đưa vào sổ đen",
POPUPMENUSTRING3 = "Chat riêng",
POPUPMENUSTRING4 = "Xóa",
POPUPMENUSTRING5 = "Giáng chức",
POPUPMENUSTRING6 = "Trục xuất",
POPUPMENUSTRING7 = "Đưa vào Bạn bè",
POPUPMENUSTRING8 = "Thông tin",
POPUPMENUSTRING9 = "Gửi thư",
POPUPMENUSTRING10 = "Thăng chức",
POPUPMENUSTRING11 = "Đồng ý chọn",
POPUPMENUSTRING12 = "Mời ra",
POPUPMENUSTRING13 = "Nhường",
DAILYCOPY_NOT_OPEN_TIPS = "Phó bản %s, hôm nay không thể khiêu chiến",
DAILYCOPY_LOCKED_TIPS = "Chưa mở, không thể khiêu chiến",
DAILYCOPY_OPEN_DAY = "Thứ %s mở",
OPEN_EVERYDAY = "Mở hằng ngày",
NUMBER_LEVEL = "Tầng %d",
PASS_CONDITION = "Yêu cầu: ",
SWEEPING = "Đang càn quét",
REMAIN_TIME = "Thời gian: ",
REMAIN_RESET_COUNT = "Tạo mới còn: ",
BELONG_TO_COMMUNITY = "Công Hội ",
CURRENT_PET = "Pet",
PET_COMBAT = "Lực chiến",
MOUNT_LEVEL = "Cấp thú cưỡi",
MOUNT_GRADE = "Điểm thú cưỡi",
KING_COMPETITION = "Vua Xạ Thủ",
COMPETITION_TIMES = "Đấu Trường",
REACH_ACHIEVEMENT = "Đạt thành tựu",
COMBAT_IN_ALL = "Tổng lực chiến",
USERRCP = "Hấp Dẫn",
DISCIPLE = "Đệ tử xuất sư",
HUSBAND = "Chồng",
WIFE = "Vợ",
COUPLE_LOVE = "Tình cảm",
SETTING_GAME_SETTING = "Thiết lập",
SETTING_CREATE_ACCOUNT = "Tạo tài khoản",
SETTING_INPUT_ACCOUNT = "Nhập tên tài khoản",
SETTING_INPUT_PASSWORD = "Nhập mật khẩu",
SETTING_INPUT_SUREWORD = "Nhập lại mật khẩu",
SETTING_INPUT_MAIL = "Hãy nhập hộp thư liên kết",
SETTING_SERVERS_STATE_FULL = "Hot",
SETTING_SERVERS_STATE_CROWD = "Đầy",
SETTING_SERVERS_STATE_GOOD = "Tốt",
SETTING_SERVER_AREA = "Server",
SETTING_EXCHANGEWORD = "Code",
COMMUNITYLOG1 = [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22" P="0"> đã vào Công Hội</T>]], 
COMMUNITYLOG2 = [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22"> tăng chức cho  </T><T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22" P="0"> lên làm  </T><T S="20" C="229,105,22" P="0">%s</T>]], 
COMMUNITYLOG3 = [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22"> đã rời Công Hội</T>]], 
COMMUNITYLOG4 = [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22"> giáng chức </T><T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22" P="0"> xuống làm </T><T S="20" C="229,105,22" P="0">%s</T>]],
COMMUNITYLOG5 = [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22"> tăng </T><T S="20" C="229,105,22" P="0"> Công Hội </T><T S="20" C="229,105,22" P="0"> đến </T><T S="20" C="229,105,22" P="0"> Lv%d</T>]], 
COMMUNITYLOG6 = [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22"> tăng </T><T S="20" C="229,105,22" P="0"> Tiệm Công Hội </T><T S="20" C="229,105,22" P="0"> đến </T><T S="20" C="229,105,22" P="0"> Lv%d</T>]], 
COMMUNITYLOG7 = [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22"> trục xuất  </T><T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22" P="0"> khỏi Công Hội</T>]], 
COMMUNITYLOG8 = [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22"> góp </T><T S="20" C="229,105,22" P="0">%d Kim Cương </T><T S="20" C="229,105,22" P="0"> nhận </T><T S="20" C="229,105,22" P="0"> %d Cống Hiến</T>]], 
COMMUNITYLOG9 = [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22"> góp </T><T S="20" C="229,105,22" P="0">%d Vàng </T><T S="20" C="229,105,22" P="0"> nhận </T><T S="20" C="229,105,22" P="0">%%d Cống Hiến</T>]], 
COMMUNITYLOG10 = [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22"> tăng </T><T S="20" C="229,105,22" P="0"> Vật Tổ Công Hội </T><T S="20" C="229,105,22" P="0"> đến </T><T S="20" C="229,105,22" P="0"> Lv%d</T>]], 
COMMUNITYLOG11 = [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22"> tăng </T><T S="20" C="229,105,22" P="0"> Trường Kỹ Năng </T><T S="20" C="229,105,22" P="0"> đến </T><T S="20" C="229,105,22" P="0"> Lv%d</T>]],
FRIEND = "Bạn bè",
RANKING = "Xếp hạng",
FRIENDNUM = "S.Lượng bạn",
TODAYRECV = "Lần nhận Thể Lực còn ",
INVITE = "Mời",
AKEYGIFT = "Tặng nhanh",
TOWER_MY_RECORD = "Nhật ký: ",
PET_SUM_EXCEED_ALTER ="Tối đa có thể có 200 Pet",
CHAT_ME = "Tôi",
SINGLECOPY_LOCKED_TIPS = "Vượt tất cả ải phó bản trước mới được xem phó bản kế",
HOUR = " giờ",
MINUTE = " phút",
SECOND = " giây",
AGING = "Hiệu lực",
APPFRIEND = "Xin phép bạn bè",
COMMUNITYINFO1 = "Tạm chưa có thông tin Công Hội, bạn có thể tự tạo Công Hội!",
COMMUNITYINFO2 = "Tên Công Hội không thể để trống",
COMMUNITYINFO3 = "Tên chứa từ không hợp lệ",
COMMUNITYINFO4 = "Tên Công Hội này đã tồn tại, hãy đặt lại",
COMMUNITYINFO5 = "Tên quá 8 ký tự",
COMMUNITYINFO6 = "Công Hội bạn nhập không tồn tại",
COMMUNITYINFO9 = "Đã gửi xin phép, vui lòng đợi",
COMMUNITYINFO17 = "Công Hội đã đủ người, không thể vào",
COMMUNITYINFO22 = "Thông tin Công Hội",
COMMUNITYINFO23 = "Hãy nhường chức chủ Công Hội trước",
COMMUNITYINFO24 = "Xác nhận rời Công Hội?\nCông Hội sẽ bị giải tán  ",
COMMUNITYINFO27 = "Tăng cấp Vật Tổ Công Hội thành công",
COMMUNITYINFO29 = "Vật Tổ Công Hội đã đạt cấp tối đa",
COMMUNITYINFO30 = "Hãy tăng cấp Công Hội",
COMMUNITYINFO31 = "Danh vọng Công Hội không đủ",
COMMUNITYINFO32 = "Tăng cấp Trường Kỹ Năng thành công",
COMMUNITYINFO33 = "Trường Kỹ Năng đã đạt cấp tối đa",
COMMUNITYINFO34 = "Học kỹ năng thành công",
COMMUNITYINFO35 = "Tăng cấp Tiệm Công Hội thành công",
COMMUNITYINFO37 = "Cống hiến cá nhân không đủ",
COMMUNITYINFO38 = "Tiệm Công Hội không đủ cấp, không thể mua",
COMMUNITYINFO39 = "Tiệm Công Hội đã đạt cấp tối đa",
COMMUNITYINFO40 = "Hội viên tăng %s: ",
COMMUNITYINFO41 = "Hãy tăng cấp Trường Kỹ Năng",
COMMUNITYINFO42 = "Đã đạt cấp tối đa",
COMMUNITYINFO43 = "Công Hội cần đạt Lv%d mới mở kiến trúc này",
COMMUNITYINFO44 = "Nhập nội dung tuyên ngôn",
COMMUNITYINFO45 = "Công Hội đã đạt cấp tối đa",
COMMUNITYINFO46 = "Dùng %d Kim Cương để tạo mới?",
COMMUNITYINFO47 = "Thiết lập cấp cơ bản thành viên vào Công Hội: ",
COMMUNITYINFO48 = "Cấp thiết lập phải là số",
COMMUNITYINFO49 = "Bạn chưa đủ cấp để vào Công Hội này",
COMMUNITYINFO50 = "C.Hiến ngày",
COMMUNITYINFO51 = "Trạng thái",
COMMUNITYINFO53 = "Rời Công Hội sẽ xóa cống hiến,\nxác nhận rời Công Hội?",
COMMUNITYINFO54 = "Nhập nội dung thư (tối đa 200 ký tự)",
COMMUNITYINFO55 = "Hội Trưởng: ",
COMMUNITYINFO56 = "Tuyên ngôn: ",
COMMUNITYINFO57 = "Danh vọng: ",
COMMUNITYINFO58 = "Tuyên ngôn Công Hội: ",
COMMUNITYINFO59 = "C.Hiến cá nhân: ",
COMMUNITYINFO60 = [[<I Z="0.5">%s</I><T S="18" C="127,70,26" P="1">%d, nhận </T><I Z="1" P="1">ui/common/common_icon_ghgx.png</I><T S="18" C="127,70,26" P="1">%d và </T><I Z="0.9" P="1">ui/common/common_icon_gzww.png</I><T S="18" C="127,70,26" P="1">%d</T>]],
COMMUNITYINFO61 = [[<T S="20" C="127,70,26" P="0">Góp </T><I Z="0.5">ui/common/common_icon_jinbi.png</I><T S="20" C="127,70,26" P="0">%d, nhận </T><I Z="1">ui/common/common_icon_ghgx.png</I><T S="20" C="127,70,26" P="0">%d và </T><I Z="1">ui/common/common_icon_gzww.png</I><T S="20" C="127,70,26" P="0">%d</T>]],
COMMUNITYINFO62 = "Thuộc tính Vật Tổ ",
COMMUNITYINFO63 = "Cấp thiết lập phải nhỏ hơn hoặc bằng %s",
COMMUNITYINFO64 = "(PS: Xếp hạng chiến tích Công Hội tạo mới mỗi tuần!)",
COMMUNITYINFO65 =
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Thứ 2 đến thứ 7 mở Công Hội Chiến</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Công Hội Chiến là dạng ghép đội 3V3</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Công Hội Chiến sẽ chỉ chiến đấu với đội của Công Hội khác, cùng Công Hội không xếp chiến đấu với nhau</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Công Hội Chiến kết thúc, người chơi sẽ được nhận Điểm Công Hội Chiến tương ứng biểu hiện trong trận chiến</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Điểm Công Hội Chiến được thống kê để tính Hạng Chiến Tích Công Hội và Hạng Cá Nhân</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Chiến tích cá nhân tạo mới hằng ngày, phát thưởng hằng ngày</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Chiến tích Công Hội tạo mới hằng tuần, phần thưởng phát vào chủ nhật</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Thưởng hạng chiến tích được gửi qua thư</T><BR></BR>
]],
COMMUNITYINFO66 = "(PS: Xếp hạng chiến tích cá nhân tạo mới sáng mỗi ngày!)",
COMMUNITYINFO67 = "%d trận thắng %d",
COMMUNITYINFO68 = "Thứ 2 đến thứ 7 mở Công Hội Chiến",
COMMUNITYINFO69 = "Công Hội đạt Lv%d mới mở tính năng này",
COMMUNITY1 = "Duyệt hội viên",
COMMUNITY2 = "Sửa tuyên ngôn",
COMMUNITY3 = "Tăng cấp Công Hội",
COMMUNITY4 = "Thiết lập Công Hội",
COMMUNITY5 = "Gửi thư nhóm",
COMMUNITY6 = "Rời Công Hội",
CommunityExplain1 =
[[
<T C="229,105,22" S="22">Lễ bái Vật Tổ</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="22" P="0">Vật Tổ Công Hội có thể tăng thuộc tính công, thủ, sinh lực thành viên</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="22" P="0">Vật Tổ Công Hội cấp càng cao tăng càng nhiều thuộc tính</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="22" P="0">Tăng cấp Vật Tổ Công Hội cần tốn Danh Vọng Công Hội</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="22" P="0">Cấp Vật Tổ Công Hội ≤ Cấp Công Hội</T><BR></BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="22" P="0">Thành viên Công Hội muốn nhận tăng thuộc tính, cần lễ bái Vật Tổ Công Hội</T><BR></BR>
<T C="229,105,22" S="20" P="0">6. </T><T C="127,70,26" S="22" P="0">Mỗi người mỗi ngày chỉ có thể lễ bái 1 lần</T><BR></BR>
<T C="229,105,22" S="20" P="0">7. </T><T C="127,70,26" S="22" P="0">Lễ bái thành công sẽ được nhận tăng thuộc tính, kéo dài đến 24:00 trong ngày</T><BR></BR>
<T C="229,105,22" S="20" P="0">8. </T><T C="127,70,26" S="22" P="0"> Có thể trả Kim Cương Đỏ tiến hành Lễ Bái x2, Lễ Bái x2 có thể nhận thuộc tính tăng và thưởng x2.</T><BR></BR>
<T C="229,105,22" S="22">Vật Tổ Ban Phúc</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="22" P="0"> Cống hiến cá nhân đạt 40000 mở tính năng Thử Thách Vật Tổ</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="22" P="0"> Sau khi tính năng Thử Thách mở, có thể trả Cống hiến cá nhân để thử thách Vật Tổ</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="22" P="0"> Thử thách Vật Tổ tăng tỉ lệ thuộc tính tăng Công Phòng HP và thuộc tính Tấn Công Nhân Vật</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="22" P="0"> Cấp Vật Tổ càng cao, thử thách tăng càng cao.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="22" P="0">Vật Tổ Ban Phúc duy trì 24 giờ</T><BR></BR>
]],

CommunityExplain2 =
[[
<T C="229,105,22" S="22" P="0">1. </T><T C="127,70,26" S="22" P="0">Có thể học kỹ năng trong Trường Kỹ Năng để tăng thuộc tính</T><BR></BR>
<T C="229,105,22" S="22" P="0">2. </T><T C="127,70,26" S="22" P="0">Cấp Trường Kỹ Năng càng cao, cấp kỹ năng có thể học càng cao</T><BR></BR>
<T C="229,105,22" S="22" P="0">3. </T><T C="127,70,26" S="22" P="0">Học kỹ năng cần tốn cống hiến cá nhân</T><BR></BR>
<T C="229,105,22" S="22" P="0">4. </T><T C="127,70,26" S="22" P="0"> Cấp Trường cứ tăng 1 cấp, giới hạn Kỹ Năng Công Hội được học tăng 10 cấp</T><BR></BR>
<T C="229,105,22" S="22" P="0">5. </T><T C="127,70,26" S="22" P="0"> Trường Kỹ Năng Lv15 có thể học Kỹ Năng Lv180</T><BR></BR>
]],

CommunityExplain3 =
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Cấp Tiệm Công Hội càng cao, thành viên hưởng ưu đãi càng cao</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Thành viên nhận Xu Khiêu Chiến từ phó bản Công Hội</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Chỉ khi BOSS phó bản Công Hội tử vong, Tiệm Công Hội mới dùng thưởng rơi BOSS tương ứng bán cho thành viên</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Mỗi ngày được mua 2 món hàng trong Tiệm Phó Bản Công Hội</T><BR></BR>
]],

PASS_ALL_TOWER_TIPS = "Chúc mừng đã vượt tất cả Tháp Thí Luyện",
SWEEP_RESULT_TIPS = "Càn quét tầng %s đã kết thúc, nhận thưởng: ",
APPROVALFRIEND = "Duyệt bạn bè",
FRIENDDYNAMIC = "H.Động",
NEXT_FLOOR = "Tầng kế",
ISGIVE = "Đã tặng",
EMPTYFRIENDTIP1 = [[Chưa có thông tin bạn bè]],
EMPTYFRIENDTIP2 = [[Chưa có thông tin động thái bạn]],
EMPTYFRIENDTIP3 = [[Chưa có thông tin xin phép bạn bè]],
DIITSUCCESS = "Tặng thành công",
REBATE = "Tặng lại",
FRIEND_MAX = "Bạn bè đã đạt tối đa",
FRIEND_EXIST = "Người chơi này và bạn đã là bạn bè",
FRIEND_WAIT = "Đã gửi xin phép bạn bè, vui lòng đợi",
FRIEND_SUC = "Đã gửi xin phép thêm bạn",
FRIEND_APPSUC = "Duyệt thêm bạn thành công",
FRIEND_OTHERMAX = "Số lượng bạn của mục tiêu đã đầy",
FRIEND_NOFRIENDVIGOR = "Tạm chưa có bạn bè tặng Thể Lực",
FRIEND_OVERVIGOR = "Lượt nhận hôm nay đã hết",
FRIEND_REFUSESUC = "Từ chối thêm bạn thành công",
LOVING_LEVEL = "Cấp tình cảm",
SEND_GIFT = "Tặng quà",
LOVING_BLOG = "Nhật ký",
ADVANCED_SUCCESS = "Thành công",
ADVANCED_ERROR = "Thất bại",
PET_REBORN_SUCCESS = "Trùng sinh Pet thành công",
PET_REBORN_ERROR = "Trùng sinh Pet thất bại",
RAFFLE_PET_ERROR = "Rút Pet thất bại",
CHANGE_PET_SKILL_ERROR = "Tẩy luyện kỹ năng Pet thất bại",
STRENGTHENINFO1 = "Trang bị cùng loại mới được kế thừa",
KING_DAYAWARD_TITLE = "Mỗi ngày nhận thưởng Điểm Vua Xạ Thủ",
KING_NO_MATCH = "Không có đối thủ thật là chán...",
KING_MATCHING = "Đang ghép...",
KING_TODAY_SCORE = "Điểm: ",
KING_WILL_AWARD = "Có thể nhận",
KING_REST_TIMES = "Số lần còn: ",
KING_SEASONSCORE = "Điểm mùa giải: ",
KING_SEASONRANK = "Hạng mùa giải: ",
KING_BATTLE_MATCH_OTHER = "Ghép đối thủ Tranh Bá",
KING_BATTLE = "Tranh Bá",
KING_SCORE_RANK = "Hạng điểm",
KING_STOP = "Kết thúc",
KING_GO_ON_MATCHING = "Ghép tiếp",
KING_JOIN_BATTLE = "Vào chiến trường",
KING_REST_OPEN_TIME = "Mở còn: ",
KING_REST_CLOSE_TIME = "Kết thúc còn: ",
KING_BATTLE_INTRODUCE = "Hướng dẫn Tranh Bá",
KING_BATTLE_OPENTIME = [[<T C="255,255,255" S="34">Thứ 2 đến Thứ 7 </T><T C="255,255,0" S="34">21:30 </T><T C="255,255,255" S="34">mở</T>]],
KING_END = "Tranh Bá kết thúc",
KING_END_TODAY = "Tranh Bá đã kết thúc",
KING_END_BATTLE_RESULT = "Chiến tích",
KING_END_HIGHEST_WINNING_STREAK = "Số lần liên thắng cao nhất",
KING_END_TODAY_SCORE = "Điểm Vua Xạ Thủ",
KING_END_TODAY_MONEY = "Lệnh Vua Xạ Thủ",
NOW_RANK = "Hạng hiện tại",
KING_FAMOUS = "Vua Xạ Thủ",
FIRST_PLACE = "Quán Quân",
SECOND_PLACE = "Hạng 2",
THIRD_PLACE = "Hạng 3",
WHAT_SEASON = "Mùa %d",
BATTLE_RESULT = "Chiến tích",
KING_RANK_MY_SCORE = "Điểm: ",
KING_RANK_MY_RANK = "Hạng: ",
KING_RANK_NO_PLAYER = "Đấu Vua Xạ Thủ mùa mới chưa mở, chưa có bảng điểm",
KING_RANK_TITLE = "Điểm Vua Xạ Thủ",
KING_RANK_BATTLERESULT = "%d trận thắng %d (Thắng: %d%s)",
KING_RANK_SUB_TITLE = [[<T C="255,255,255" S="20">Thứ 7 23:00 </T><T C="255,238,144" S="20">tổng kết hạng điểm và phát thưởng, Top 5 thưởng rất phong phú!~</T>]],
WIN_LOSE = "Thắng bại",
GET_AWARD = "Nhận thưởng",
KING_SCORE = "Điểm Vua Xạ Thủ",
KING_AWARD_SUBTITLE = "23:00 thứ 7 phát thưởng hạng căn cứ hạng Vua Xạ Thủ của người chơi",
KING_AWARD_TITLE = "Thưởng hạng Đấu Vua Xạ Thủ",
KING_AWARD_RANK = "Hạng %s",
KING_SHOP = "Tiệm Vua Xạ Thủ",
KING_MONEY = "Lệnh Vua Xạ Thủ",
ITEMNOTSALE = "Vật phẩm chưa bày bán",
TOWER_SWEEPING = "Đang càn quét...",
BAGBTNTEXT5 = "Xóa bạn bè",
RECHALLENGE = "Khiêu chiến lại",
GET = "Nhận",
MASTERINFO1 = [[<T C="255,236,193" S="20" P="1">1:</T><T C="255,236,193" S="20" P="1">Được thu nhận %d đệ tử</T><BR>16</BR> <T C="255,236,193" S="20" P="1">2:</T><T C="255,236,193" S="20" P="1">Thuộc tính tăng: S.Lực </T><T C="255,227,116" S="20" P="1">+%d%s</T><T C="255,236,193" S="20" P="1">Công</T><T C="255,227,116" S="20" P="1">+%d%s</T><T C="255,236,193" S="20" P="1">Phòng</T><T C="255,227,116" S="20" P="1">+%d%s</T><BR>16</BR> <T C="255,236,193" S="20" P="1">3:</T><T C="255,236,193" S="20" P="1">Thuộc tính đệ tử tăng: S.Lực</T><T C="255,227,116" S="20" P="1">+%d%s</T><T C="255,236,193" S="20" P="1">Công</T><T C="255,227,116" S="20" P="1">+%d%s</T><T C="255,236,193" S="20" P="1">Phòng</T><T C="255,227,116" S="20" P="1">+%d%s</T> ]],
MASTERINFO2 = 
[[
Cách nhận sư đức
1. Đệ tử tăng cấp sư phụ có thể nhận sư đức, 
cấp càng cao nhận sư đức càng nhiều
2. Đệ tử xuất sư sư phụ có thể nhận sư đức, 
cấp khi bái sư càng thấp nhận sư đức càng nhiều
]],
MASTERINFO3 =
[[
<T C="229,105,22" S="20">Bái Sư</T><BR></BR>
<T C="229,105,22" S="18">1.</T><T C="127,70,26" S="18">Hiện tại không có sư phụ có thể bái sư</T><BR></BR>
<T C="229,105,22" S="18">2.</T><T C="127,70,26" S="18">Người chơi có thể được bái sư, có cấp ≥ Lv35 và còn có thể thu nhận đệ tử</T><BR></BR>
<T C="229,105,22" S="18">3.</T><T C="127,70,26" S="18">Khi bái sư, cấp và lực chiến của sư phụ cần lớn hơn đệ tử.</T><BR></BR>
<T C="229,105,22" S="20">Phúc Lợi Sư Đồ</T><BR></BR>
<T C="229,105,22" S="18">1.</T><T C="127,70,26" S="18">Đệ tử có thể nhận BUFF Sư Môn, cấp sư đức sư phụ càng cao hiệu quả BUFF càng cao</T><BR></BR>
<T C="229,105,22" S="18">2.</T><T C="127,70,26" S="18">Đệ tử lên cấp, có thể nhận Quà Cấp (Lv15-Lv25)</T><BR></BR>
<T C="229,105,22" S="18">3.</T><T C="127,70,26" S="18">Sư phụ có thể được tăng thuộc tính từ cấp Sư Đức, cấp Sư Đức càng cao nhận càng nhiều thuộc tính</T><BR></BR>
<T C="229,105,22" S="18">4.</T><T C="127,70,26" S="18">Đệ tử tốn Thể Lực, sư phụ sẽ nhận Thể Lực</T><BR></BR>
<T C="229,105,22" S="18">5.</T><T C="127,70,26" S="18">Sư phụ có thể thiết lập 1 kỹ năng của bản thân thành kỹ năng sư môn. Sau khi thiết lập, đệ tử mỗi ngày có thể dùng kỹ năng này trong giao diện Sư Môn.</T><BR></BR>
<T C="229,105,22" S="18">6.</T><T C="127,70,26" S="18">Đệ tử nhận được cấp kỹ năng tương tự như sư phụ (Kỹ Năng Hệ sẽ tự động thay thế thành Kỹ Năng Thường, tối đa đạt Lv7).</T><BR></BR>
<T C="229,105,22" S="18">7.</T><T C="127,70,26" S="18">Đệ tử mỗi ngày có thể mở giao diện Sư Đồ mua 1 Rương Sư Đồ. Sau khi mua, Sư Đồ tổ đội vào phó bản, khiêu chiến Đấu Trường sẽ nhận được Điểm Năng Động mở khóa rương báu.</T><BR></BR>
<T C="229,105,22" S="18">8.</T><T C="127,70,26" S="18">Rương báu chia làm Rương Đồng, Rương Bạc, Rương Vàng. Cần tốn Vàng, Kim Cương Đỏ, Kim Cương để mua. Rương càng quý hiếm, sau khi mở thưởng nhận được càng tốt.</T><BR></BR>
<T C="229,105,22" S="20">Sư Đức</T><BR></BR>
<T C="229,105,22" S="18">1.</T><T C="127,70,26" S="18">Đệ tử lên cấp, sư phụ nhận Sư Đức</T><BR></BR>
<T C="229,105,22" S="18">2.</T><T C="127,70,26" S="18">Sư phụ mỗi ngày cho thể Truyền Dạy 1 lần cho mỗi đệ tử, sau khi Truyền Dạy sư phụ nhận sư đức, đệ tử nhận EXP</T><BR></BR>
<T C="229,105,22" S="18">3.</T><T C="127,70,26" S="18">Đệ tử mỗi cách 5 phút có thể Kính Biếu sư phụ 1 lần. Sau khi Kính Biếu xong, sư phụ nhận được sư đức.</T><BR></BR>
<T C="229,105,22" S="20">Hệ Thống Tông Môn</T><BR></BR>
<T C="229,105,22" S="18">1.</T><T C="127,70,26" S="18">Người chơi sau khi bái sư, tự động gia nhập Tông Môn của sư phụ.</T><BR></BR>
<T C="229,105,22" S="18">2.</T><T C="127,70,26" S="18">Tông Môn khởi tạo là Lv0, có thể tốn Kim Cương Khóa lên thành Lv1, sau đó lên cấp cần tốn EXP Tông Môn.</T><BR></BR>
<T C="229,105,22" S="18">3.</T><T C="127,70,26" S="18">Tông Môn lên cấp tăng giới hạn bậc đệ tử, thuộc tính cơ bản và buff tổ đội.</T><BR></BR>
<T C="229,105,22" S="18">4.</T><T C="127,70,26" S="18">Trong Tông Môn có từ 2 thành viên trở lên tổ đội sẽ nhận buff Tông Môn.</T><BR></BR>
<T C="229,105,22" S="18">5.</T><T C="127,70,26" S="18">Đệ tử có thể dùng Cống Hiến Tông Môn tăng bậc Tông Môn của bản thân, bậc Tông Môn càng cao, thuộc tính Tông Môn càng cao.</T><BR></BR>
<T C="229,105,22" S="18">6.</T><T C="127,70,26" S="18">Đệ tử sau khi giải trừ quan hệ sư đồ, nếu bậc Tông Môn lớn hơn bậc 10 thì giảm 1 bậc.</T><BR></BR>
<T C="229,105,22" S="18">7.</T><T C="127,70,26" S="18">Nếu sau khi người chơi bái sư, bậc Tông Môn cao hơn giới hạn bậc Tông Môn hiện tại, thì sẽ nhận thuộc tính giới hạn bậc tương ứng.</T><BR></BR>
<T C="229,105,22" S="18">8.</T><T C="127,70,26" S="18">EXP Tông Môn và Nhiệm Vụ Tông Môn có thể nhận từ hoàn thành Nhiệm Vụ Tông Môn.</T><BR></BR>
<T C="229,105,22" S="20">Nhiệm Vụ Tông Môn</T><BR></BR>
<T C="229,105,22" S="18">1.</T><T C="127,70,26" S="18">Sư phụ có thể công bố Nhiệm Vụ Ngày của Tông Môn, có thể công bố tối đa nhiệm vụ trong 3 ngày.</T><BR></BR>
<T C="229,105,22" S="18">2.</T><T C="127,70,26" S="18">Sư phụ có thể tốn Kim Cương Khóa tạo mới Nhiệm Vụ Tông Môn đã công bố, nhiệm vụ khóa càng nhiều, Kim Cương Khóa cần để tạo mới càng nhiều.</T><BR></BR>
<T C="229,105,22" S="18">3.</T><T C="127,70,26" S="18">Tất cả thành viên trong Tông Môn đều có thể hoàn thành Nhiệm Vụ Tông Môn, bao gồm sư phụ và đệ tử.</T><BR></BR>
<T C="229,105,22" S="18">4.</T><T C="127,70,26" S="18">Sau khi xong nhiệm vụ, sư phụ có thể nhận thưởng Tông Môn, đệ tử đăng nhập trong ngày nhận thưởng đệ tử, tất cả thường đều gửi qua thư.</T><BR></BR>
]],
MASTERINFO4 = 
[[
2015/6/1 6:00 Lv.66
%s
]],
MASTERINFO6 = "Bạn làm sư phụ tôi nhé!!!",
MASTERINFO7 = "Tôi rất ngưỡng mộ bạn, làm sư phụ tôi nhé!!",
MASTERINFO8 = "Tôi thật sự rất ngưỡng mộ bạn, làm sư phụ tôi đi!",
MASTERINFO9 = "Làm sư phụ và dẫn tôi đi ăn nha, tôi sẽ cố gắng lên cấp mà!",
MASTERINFO10 = "Tôi rất có tiềm năng, hãy nhận tôi đi.",
MASTERINFO11 = "Để tôi hướng dẫn bạn, làm đệ tử tôi nha",
MASTERINFO12 = "Tôi muốn nhận đệ tử, bạn đồng ý không?",
MASTERINFO13 = "Làm đệ tử tôi đi, đừng từ chối duyên phận này",
MASTERINFO14 = "Tôi là sư phụ tốt, hiện cần tuyển đệ!",
MASTERINFO15 = "Hãy cùng tôi ngao du khắp nơi nào",
MASTERINFO16 = "Hãy nhập ID người chơi",
MASTERINFO17 = [[<T C="151,64,19" S="20">Xác nhận hủy quan hệ sư đồ với %s?</T><BR></BR><T C="134,113,92" S="20">Đối phương rời mạng dưới </T><T C="158,0,0" S="20"> 72 </T><T C="134,113,92" S="20"> giờ, cưỡng chế hủy quan hệ sư đồ, trong </T><T C="158,0,0" S="20"> %d </T><T C="134,113,92" S="20"> giờ tới không thể %s lại. </T><T C="158,0,0" S="20">(Hủy Kim Cương không hạn chế thời gian)</T>  ]],
MASTERINFO18 = "Bái sư",
MASTERINFO19 = "Nhận đệ tử",
MASTERINFO20 = "Hủy quan hệ",
MASTERINFO21 = "Tăng cấp sư đức",
MASTERINFO22 = "ID người chơi chỉ được là số",
MASTERINFO23 = "Bạn có %d đệ tử, hãy xem họ xuất sư",
MASTERINFO24 = "Tin tức",
MASTERINFO25 = "Đổi",
MASTERINFO26 = "Bạn đã có sư phụ",
MASTERINFO27 = "Đã bái sư",
MASTERINFO28 = "Đã nhận đệ tử",
MASTERINFO29 = "Thổ lộ chân tình để cảm động %s tương lai",
MASTERINFO30 = "Yêu cầu",
SUREDELFRIEND = "Xóa bạn sẽ xóa thân mật, tiếp tục không?",
WEDDING_DIARY_1= [[<T C="229,105,22" S="22">%s </T><T C="127,70,26" S="22"> đã vào lễ đường </T><T C="79,49,68" S="20"> %s</T>]],
WEDDING_DIARY_2= [[<T C="229,105,22" S="22">%s </T><T C="127,70,26" S="22"> đã vào lễ đường </T><T C="79,49,68" S="20"> %s</T>]],
WEDDING_DIARY_3= [[<T C="229,105,22" S="22">%s </T><T C="127,70,26" S="22"> đã phát Lì Xì </T><T C="79,49,68" S="20"> %s</T>]],
WEDDING_DIARY_4= [[<T C="229,105,22" S="22">%s </T><T C="127,70,26" S="22"> đã giành được Lì Xì, nhận </T><T C="229,105,22" S="22">%d</T> <T C="127,70,26" S="22"> Vàng </T><T C="79,49,68" S="20"> %s</T>]],
WEDDING_DIARY_5= [[<T C="229,105,22" S="22">%s </T><T C="127,70,26" S="22"> đã phát Kẹo Hỉ </T><T C="79,49,68" S="20"> %s</T>]],
WEDDING_DIARY_6= [[<T C="229,105,22" S="22">%s </T><T C="127,70,26" S="22"> đã giành được Kẹo Hỉ, nhận </T><T C="229,105,22" S="22">%d</T> <T C="127,70,26" S="22"> Thể Lực </T><T C="79,49,68" S="20">%s</T>]],
WEDDING_DIARY_7= [[<T C="229,105,22" S="22">%s </T><T C="127,70,26" S="22"> đã bắn Pháo Hoa, tăng </T><T C="229,105,22" S="22">%d</T> <T C="127,70,26" S="22"> EXP </T><T C="79,49,68" S="20">%s</T>]],
WEDDING_DIARY_8= [[<T C="229,105,22" S="22">%s </T><T C="127,70,26" S="22"> đã tặng Chúc phúc, tăng </T><T C="229,105,22" S="22">%d</T> <T C="127,70,26" S="22"> EXP </T><T C="79,49,68" S="20"> %s</T>]],
WEDDING_DIARY_9= [[<T C="229,105,22" S="22">%s</T><T C="127,70,26" S="22"> và </T><T C="229,105,22" S="22">%s </T><T C="255,236,193" S="22"> đã tăng </T><T C="229,105,22" S="22">%d</T> <T C="127,70,26" S="22"> tình cảm </T><T C="79,49,68" S="20"> %s</T>]],
LOVING_DIARY_1 = [[
<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">Bạn tặng %s 1 %s, tăng </T>
<T C="99,255,95" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>
<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">Tình cảm%s</T>
]],
LOVING_DIARY_2 = [[
<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s tặng bạn 1 %s, tăng </T>
<T C="99,255,95" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>
<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">Tình cảm%s</T>
]],
LOVING_DIARY_3 = [[
<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">Vợ chồng cùng hoàn thành 1 trận chiến, tăng </T>
<T C="99,255,95" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>
<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">Tình cảm%s</T>
]],
LOVING_DIARY_4 = [[
<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s tặng %s 1 %s, tăng </T>
<T C="99,255,95" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>
<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">Tình cảm%s</T>
]],
WEDDING_INVITE_TIPS = "%s mời bạn dự Hôn Lễ, bây giờ đồng ý đi chứ?",
SEND_BLESSING_1 = "Chúc cô dâu chú rể trăm năm hạnh phúc",
SEND_BLESSING_2 = "Chúc cô dâu chú rể răng long đầu bạc",
SEND_BLESSING_3 = "Chúc cô dâu chú rể hạnh phúc mỹ mãn",
ROB_TRUE_RED = "Chúc mừng bạn giành được 1 Lì Xì\n Nhận %d Vàng",
ROB_TRUE_CADDIES = "Chúc mừng bạn giành được 1 Kẹo Hỉ\n Nhận %d Thể Lực",
CANDIES_FALSE = "Chậm quá, Kẹo Hỉ đã bị giành hết",
ROB_FALSE = "Chậm quá, Lì Xì đã bị giành hết",
WEDDING_FILLED = "Hội trường đông nghịt",
WHAT_WORLD_TIPS = "Cách 15 giây mới được phát!!",
SHOP_RECOMMEND = "Đề cử",
SHOP_SAVE_IMG = "Giỏ Hàng",
SHOP_NEW = "Vật phẩm mới",
SHOP_HOT = "Bán chạy",
SHOP_DAY_LIMITED = "Lượt mua hôm nay đã đạt tối đa",
SHOP_DAY_LIMIT = "Giới hạn mua hôm nay",
SHOP_IND = " cái",
SHOP_NO_NEED = "Bạn có vật phẩm này vô thời hạn, không cần mua",
MATCHES_MODE = "Dạng Ghép",
FREE_MODE = "Dạng Tổ Đội",
SCUFFLE_MODE = "Dạng Giao Chiến",
HOMEOWNER = "Chủ phòng",
READY = "Chuẩn bị",
CHANGE_MATCH_ERROR = "Số người trong phòng quá nhiều, không thể ghép, đổi thất bại",
OFFLINESTATE = "Rời mạng",
QUALIFYING_SEASON = "Chiến tích mùa giải",
QUALIFYING_REWARDDESC = "Hướng dẫn thưởng",
QUALIFYING_RANK = "BXH đơn",
QUALIFYING_LOG = "Nhật ký chiến tích",
QUALIFYING_SHOP = "Tiệm Xếp Hạng",
QUALIFYING_MAKEPAIR = "Đang tìm đối thủ",
QUALIFYING_FIGHT = "Khai chiến",
QUALIFYING_CLOSETIPS = "Thứ 2 đến Thứ 7 12:00-21:00 mở",
QUALIFYING_WIN = "Thắng: %d trận thắng %d (%d%%)",
QUALIFYING_WINSTREAK = "Liên thắng cao nhất: %d trận",
QUALIFYING_CURRENCY = "Cấp bậc Xu: %d",
QUALIFYING_SCORE = "Điểm hạng: %d",
QUALIFYING_TITLE = [[<T C="255,255,255" S="22">Danh hiệu bậc: </T><T C="%d,%d,%d" S="22">%s</T>]],
QUALIFYING_DAILY = [[<T C="127,70,26" S="20">Chiến tích hôm nay: </T><T C="158,0,0" S="20"> %d trận, thắng %d</T>]],
LOVING_DAILY = "Không có nhật ký tình cảm",
RELIEVE_RELATT_SUCCESS = "Hủy quan hệ thành công",
ROOM_NAME = "Tên phòng",
ROOM_PASS = "Mật khẩu",
SELECT_MAP_TIPS = "Dạng ghép đội chỉ được dùng bản đồ ngẫu nhiên",
ROOM_PASS_ERROR = "Mật khẩu phòng chỉ được dùng số và chữ cái",
ROOM_PASS_ERROR2 = "Mật khẩu phòng tối đa 8 ký tự",
ROOM_NAME_ERROR = "Tên phòng tối đa 8 ký tự",
ROOM_NAME_ERROR2 = "Tên phòng không thể có khoảng trống",
COST_GOODS_TIPS1 = "Vật phẩm cần không đủ, tốn Kim Cương %d",
COST_GOODS_TIPS2 = "Vật phẩm cần không đủ, tốn Vàng %d",
SEND_WEDDING_GOODS1 = "Đang phát Lì Xì",
SEND_WEDDING_GOODS2 = "Đang phát Kẹo Hỉ",
SEND_WEDDING_GOODS3 = "Đã có người đang tặng Chúc phúc",
SEND_WEDDING_GOODS4 = "Đã có người đang bắn súng chào",
SEND_PROPOSAL_LETTER1 = "Gửi thư cầu hôn thành công",
SEND_PROPOSAL_LETTER2 = "Đạo cụ không đủ",
SEND_PROPOSAL_LETTER3 = "Đối phương không online",
SEND_PROPOSAL_LETTER4 = "Đối phương không đủ cấp",
SEND_PROPOSAL_LETTER5 = "Đối phương đang chiến đấu",
SEND_PROPOSAL_LETTER6 = "Đã gửi cầu hôn",
SEND_PROPOSAL_LETTER7 = "Mục tiêu đã đính hôn hoặc đã kết hôn",
SEND_PROPOSAL_LETTER8 = "Trong 10 phút chỉ có thể tổ chức hôn lễ 1 lần",
PROPOSE_TIPS = "Cầu hôn thành công hay không cũng tốn đạo cụ cầu hôn",
CHANGE_LOVER= "Hãy chọn bạn đời!",
PROPPSE_LIST_TIPS = " gửi %s cầu hôn.",
MINUTE_BEFORE = "%d phút trước",
HOUR_BEFORE = "%d giờ trước",
DAY_BEFORE = "%d ngày trước",
QUALIFYING_REFRESHTIME = "Tự tạo mới: 21:00 hằng ngày",
QUALIFYING_MYCOIN = "Xu Xếp Hạng: ",
SWEEP_CARD = "Vé càn quét",
MULTI_SWEEP = "Càn quét nhiều",
COPY_ENEMY = "Xuất hiện địch",
COPY_PROBABLE_DROP = "Có thể nhận",
COPY_GOAL = "Mục tiêu",
COPY_VIGOUR = [[<T S="21" C="83,56,29" P="1">Tốn Thể Lực: </T><I>ui/common/015.png</I><T S="21" C="83,56,29" P="1">%d</T>]],
COPY_GOAL1 = "Vượt phó bản",
COPY_GOAL2 = "Sinh lực trên %d%%",
COPY_GOAL3 = "Thắng sau %d lượt",
COPY_SWEEP = "Càn quét",
COPY_GOAL2_2 = "Còn %d%% sinh lực",
COPY_GOAL3_2 = "%d lượt",
MY_EQUIP = "Trang bị",
ON_BODY = "Trên người",
REACH_MAX_STRONG_LEVLE = "Đã cường hóa tối đa",
OWN = "Có ",
EQUIP_REACHED_MAX_STAR_LEVEL = "Đã tăng sao tối đa",
ATTACK_STONE_1 = "Đá Tấn Công",
DEFENSE_STONE_1 = "Đá Phòng Thủ",
HP_STONE = "Đá Sinh Lực",
CLICK_TO_REMOVE = "Tháo",
CLICK_TO_ADD = "Thêm",
TRANSFER_COST = "Kế thừa tốn ",
BUY_TRANSFERSTONE_MESSAGE = "Đá Kế Thừa không đủ, mua ngay?",
PLEASE_SELECT_TRANSFER_EQUIP = "Chọn trang bị kế thừa",
EQUIPONE_LESS_THAN_EQUIPTWO = "Cấp cường hóa và tăng sao cần lớn hơn trang bị kế thừa",
IN_USE = "Đang dùng",
MY_GEM = "Đá Quý",
TURNCARD_VIP_TIPS = "VIP5 mới được lật thẻ",
ATH_DAILY_REWARD = "Thưởng Cấp Thi Đấu",
ATH_REFRESH_LIMIT = "Lần tạo mới hiện tại của bạn đã đạt tối đa",
ATH_SHOP = "Tiệm",
ATH_SHOP_REFRESH = "Tạo mới vào 24:00 mỗi ngày",
ATH_REWARD_CHECK = "Thưởng",
ATH_FREE = "Tổ đội",
ATH_MIX = "Giao Chiến",
SETTING_EXCHANGEWORD1 = "Code này đã được sử dụng",
SETTING_EXCHANGEWORD2 = "Bạn đã sử dụng code rồi",
SETTING_EXCHANGEWORD3 = "Hãy nhập chính xác code",
WNDPLAYERINFO1 = "Thuộc tính của tôi",
WNDPLAYERINFO2 = "Thông tin",
WNDPLAYERINFO3 = "Thuộc tính",
WNDPLAYERINFO4 = "Chữ ký",
WNDDRESS1 = "Biểu cảm",
WNDDRESS2 = "Thời trang",
OPAN_FOR_LEVEL = "Lv%d mở",
SERVER_TIME = "Thời gian máy chủ: ",
REVIVE_MODES = "Hồi sinh",
ATH_SHOP_HAVE_NUM = [[<T C="79,60,48" S="22" P="0">Có </T><T C="158,0,0" S="22" P="0">%d</T><T C="79,60,48" S="22" P="0"> món</T>]],
ATH_SHOP_COST = "Tốn ",
ATH_WAIT = "Đợi",
SHOP_BUY_DESC = [[<T C="79,60,48" S="20" P="0">Gồm %d vật phẩm, cần chi trả </T><I Z="0.8">ui/common/common_icon_zuanshi.png</I><T C="79,60,48" S="20" P="0">%d</T>]],
WAITING_MATCHES = "Ghép chiến đấu",
ROOM_INFO = "Thông tin phòng",
FRIENDS_SEND_TIP_1 = " tặng bạn ",
FRIENDS_SEND_TIP_2 = " Thể Lực",
FRIENDS_SEND_TIP_3 = [[Chưa có dữ liệu]],
PLEASE_INPUT_ID_FIRST = "Nhập ID người chơi",
PLEASE_CHOOSE_PLAYER = "Hãy chọn người chơi",
NO_PLAYER_IN_HALL = [[Sảnh không có người khác]],
NO_VATALITY_CAN_GET = "Không có Thể Lực để nhận",
PLEASE_SEND_AFTER_GETTING = "Hãy nhận rồi tặng",
DAILY_KILL_SMALLM = "Diệt quái nhỏ",
DAILY_KILL_BIGM = "Diệt quái Tinh Anh",
DAILY_KILL_BOSS = "Diệt BOSS",
ATH_JINGJI_DESC = "Dạng ghép, hệ thống sẽ ghép kẻ địch thích hợp nhất, chiến thắng được nhận điểm thi đấu",
ATH_SAFE_DESC = "Được tự do chọn đồng đội và đối thủ, dạng này không được điểm thi đấu",
ATH_SAFE_DESC2 = "Đấu tập có thể đấu với người chơi chỉ định nhưng sẽ không nhận thưởng, dùng để tập luyện cách đấu hoặc hẹn chiến",
ATH_SAFE_DESC3 = "Dạng Giao Chiến không có mục chọn",
RESULT_DOWN_TIME = [[<T C = "255,255,255" S = "24" P = "0">%02d</T><T C = "255,255,255" S = "22" P = "0"> giây sau quay về</T><T C = "255,255,255" S = "20" P = "0">(Nhấn khoảng trống để bỏ qua)</T>]],
RESULT_DOWN_TIME2 = [[<T C = "255,255,255" S = "24" P = "0">%02d</T><T C = "255,255,255" S = "22" P = "0"> giây sau quay về</T>]],
NOT_START_GAME = "Số người 2 đội không bằng nhau, không thể bắt đầu",
CLOSE_SETAT_TIP = "Vị trí này đã có người chơi, không thể đóng chỗ này",
BATTLE_SKILL = "Đạo cụ chiến đấu",
SKILL_TIP = "Chọn đạo cụ cần từ danh sách đạo cụ, dùng trong chiến đấu",
SKILL_CELL_FULL = "Đã đạt tối đa",
SKILL_OPEN = "Mở",
LOADING_NICKNAME = "Tên",
EQUIPPED = "Đã trang bị",
UNEQUIPPED = "Chưa trang bị",
MAIL_NAME = "Thư",
HIGHEST_RECORD = "Kỷ lục cao nhất: ",
SWEPT_LEAVE_TIEM = "Thời gian càn quét còn lại ",
TOWER_LEVEL = "Tầng tháp",
HAVE_NOT_ROOM = "Chưa có phòng",
TOWER_LEVEL2 = "Tầng",
CHALLEGE_OVER = "Lượt khiêu chiến đã hết",
SWEEPING_TIP = "Trạng thái càn quét không thể chủ động chiến đấu",
MOVING = "Đang di chuyển",
TEAM_MAYBE_GET = "Có thể\nnhận",
STOP_SWEEPING = "Dừng càn quét",
CHANGE_SEAT_TIPS = "Chuẩn bị vào game, không thể đổi chỗ!",
NOT_ENABLE = "Không đủ",
SWEEPING_TIP2 = "Ải dưới kỷ lục cao nhất mới được càn quét",
ATHMONEY_NOT_ENOUGH = "Xu Thi Đấu không đủ, mau hoàn thành mục tiêu thi đấu",
SELL_CONFIRM = "Có vật phẩm tốt\nĐồng ý bán?",
NOT_ATTENTION_TODAY = "Hôm nay không nhắc lại",
TODAY_REST_COUNT = "Số lần hôm nay còn: ",
CHALLENGE_AGAIN = "Khiêu chiến lại",
SHARE = "Chia sẻ",
CONTINUE = "Tiếp tục",
CURRENT_LEVEL = [[<T C="79,60,48" S="22" P="0">Hiện ở tầng </T><T C="99,255,95" S="22" P="0">%d</T><T C="79,60,48" S="22" P="0"></T>]],
RESERT_TIPS2 = "Tạo mới sẽ quay về tầng 1 và khôi phục số lần khiêu chiến",
MAIL_NOLIST = "Danh sách thư trống, không thể biên tập",
MAIL_ISWRITE = "Không thể sửa thư đang viết",
MAIL_GETANNEX = "Hãy lấy đính kèm",
MAIL_OUTTHEME = "Tiêu đề không được quá 36 ký tự!",
MAIL_OUTTEXT = "Nội dung thư không được quá 200 ký tự!",
DAILYCOPY_NOOPEN = "Phó bản hiện tại chưa mở",
DAILYCOPY_OPENLEVEL = "Độ khó phó bản này Lv%d mở",
SWEEP_ENDIND2 = "Càn quét kết thúc",
ROOM_HAVE_NOT_READY = "Phòng có người chơi chưa chuẩn bị",
BAGINFO1 = "Không có thời trang quá hạn",
ROOM_BEINVITED_2 = "%s mời tham gia\nđấu đội %s",
FAST_SWEEP_TIP = "Dùng %d Kim Cương hủy CD càn quét",
OPEN_SKILL_TAB_TIP = "Dùng 50 Kim Cương mua ô đạo cụ",
SHOP_LIMIT_TITLE = "Giới hạn",
LV = "Lv",
INTERACTIVE = "Tương tác",
CONTEXT = "Nội dung",
TURNCARD_DIAMOND_TIPS = "Kim Cương không đủ, không thể lật thẻ!",
WHISPER_TO_ME = " với tôi",
ME_TO_WHISPER = "Tôi với",
COST = "Tốn: ",
TOWER_SEND_DESC = [[<T C="127,70,26" S="20" P="0">Mỗi ngày</T> <T C="255,89,74" S="20" P="0"> %s </T><T C="127,70,26" S="20" P="0"> phát thưởng Tháp Thí Luyện theo hạng server</T>]],
MOUNTS_UP = "Cưỡi",
TXT_ONLINEFRIEND_ISNULL = [[Chưa có bạn bè online]],
TXT_ONLINEGUILD_ISNULL = [[Chưa có thành viên Công Hội online]],
MOUNTS_LEVEL = "Cấp: %d",
MOUNTS_PRE_ADD = "Tổng thuộc tính tăng",
HAS_GET = "Đã nhận ",
INHERIT = "Kế thừa",
NO_CHALLENGE_TIMES2 = "Lượt khiêu chiến không đủ, không thể khiêu chiến!",
SHOP_MIANBAO = "Miễn Bạo: ",
MOUNTS_TITLE_STAR = "Tiến Giới Thú Cưỡi",
MOUNTS_TITLE_UPGRAGE = "Tăng cấp thú cưỡi",
DISAPPEAR = "mất",
MOUNTS_MAX_UPGRADE = "Thú cưỡi này đã đạt cấp cao nhất",
MOUNTS_MAX_STAR = "Thú cưỡi này đã đạt sao cao nhất",
MOUNTS_STAR_NOLEVEL = "Thú cưỡi cần đạt Lv%d mới được tăng sao",
DESIGNATION_ATTENTION = "Trang bị ô chọn đã có danh hiệu, nhận tăng thuộc tính!",
STRENGTHEN_TOP = "Cấp cường hóa đạt tối đa! Giỏi quá!",
PETHEALTH = "S.Lực: ",
PETDEFENSE = "P.Thủ: ",
PETATTACK = "T.Công: ",
PETINTELLIGENCE = "Tư chất: ",
PETLOOK = "Xem",
PETEATFORUP = "Pet gộp tăng cấp",
PETEATFORADVANCE = "Pet gộp tiến hóa",
PETONECHOICE = "Chọn nhanh",
PETTOUP = "Tăng cấp",
PETADCANCE = "Tiến Hóa",
PETUSE = "Tốn",
PETHASNUM = "(Có %d)",
PETHAS = "Có :",
PETSKILL = "Lĩnh ngộ",
PETOPENEGE = "Đập trứng",
PETTOFREE = " sau miễn phí",
SHOP_NAME_AND_LEVEL = [[<T C="255,227,116" S="22" P="0">Lv%d </T><T C="255,255,255" S="22" P="0">%s</T>]],
MOUNTS_STAR_MAX = "Tăng bậc giới hạn",
CLICKCONTINUE = "Nhấp tiếp tục",
ACHIE_DISCRIPTION_TITLE = "Điều kiện nhận: ",
ACTOR_NAME_ERROR = "Tên nhân vật không được có khoảng trống",
ACTOR_MAX_NAME = "Tên nhân vật không quá %d ký tự",
ATH_REFRESH_COST = [[<T S="24" C="127,70,26" P="1">Muốn dùng %d Kim Cương tạo mới Tiệm?</T><BR></BR><BL>48</BL><T S="24" C="127,70,26" P="1">(Hôm nay đã tạo mới %d lần)</T>]], 
FailToBag = "Tăng các loại thuộc tính",
FailToTak = "Hoàn thành nhiệm vụ, tăng cấp",
FailToEquie = "Cường hóa trang bị, tăng các loại thuộc tính",
FailToItem = "Khác chờ mở rộng",
LOGIN_MY_SERVER = "Máy chủ của tôi",
LOGIN_RECOMMEND_SERVER = "Máy chủ đề cử",
SHOP_STONE = "Rương",
LOGIN_SERVER_STATE_CLOSE = "Bảo trì",
PET_1 = "Tư chất (Ảnh hưởng cấp sao)",
PET_2 = "Thuộc tính",
PET_3 = "Chiến Đấu",
PET_4 ="%d%s thuộc tính của Pet sẽ tăng cho nhân vật",
PET_5 = "Pet tấn công gây %d%s sát thương thường của nhân vật",
LEVEL1 = "",
PETOPENEGE1 = "Đập (Mảnh)",
PETOPENEGE2 = "Đập (KC)",
PETOPENEGE3 = "Đập x10",
Wedding_CountDown = "Hôn lễ còn ",
Wedding_Desc = "Tổ chức hôn lễ càng hào hoa, số lần tặng quà hằng ngày càng nhiều!",
Propose_Desc = 
[[
<T C="229,105,22" S="22" P="0">Sau khi kết hôn được nhận thời trang vĩnh viễn tăng lực chiến</T><T C="127,70,26" S="22" P="0"></T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Mỗi lần cầu hôn đều tốn đạo cụ cầu hôn</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Mỗi loại đạo cụ tương ứng một cách cầu hôn</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Đối tượng cầu hôn cần Lv21 trở lên</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Điểm thân mật với đối tượng cầu hôn phải trên 1000</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">5. </T><T C="127,70,26" S="22" P="0">Đối tượng cầu hôn phải đang online</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">6. </T><T C="127,70,26" S="22" P="0">Hằng ngày tặng quà, tặng thể lực, cùng hoàn thành chiến đấu sẽ tăng điểm thân mật</T><BR>20</BR>
]],
Engagement_Desc = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Đính hôn thành công sẽ nhận danh hiệu tương ứng</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Hôn Lễ gồm: Hôn Lễ Xa Hoa, Hôn Lễ Hào Hoa, Hôn Lễ Lãng Mạn</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Cấp Hôn Lễ càng cao, áo cưới càng đẹp</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Cấp Hôn Lễ càng cao, thời gian chờ phát Lì Xì, Kẹo Hỉ, Pháo, tặng chúc phúc càng ngắn</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0"> Cấp Hôn Lễ càng cao, lợi ích nhận được càng nhiều</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> Cấp Hôn Lễ càng cao, tương tác vợ chồng hằng ngày càng nhiều (Có thể tăng nhanh cấp tình cảm để kích hoạt kỹ năng tương ứng)</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0"> Chọn loại hỗn lễ và thời gian cử hành, sẽ có thể gửi thiệp mời cho bạn bè và thành viên Công Hội</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">8.</T><T C="127,70,26" S="20" P="0"> Gửi thiệp mời thành công, người nhận được thiệp đến tham dự hôn lễ, cả người nhận và người gửi đều được nhận Vàng tương ứng</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">9.</T><T C="127,70,26" S="20" P="0"> Vàng nhận được nhiều hay ít tùy vào loại thiệp mời, thiệp mời giá càng cao Vàng nhận được càng nhiều</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">10.</T><T C="127,70,26" S="20" P="0">Trong Hôn Lễ không được gửi thiệp mời</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">11.</T><T C="127,70,26" S="20" P="0">Có thể đơn phương hủy quan hệ, nhưng sẽ tốn 333 Kim Cương </T><BR></BR>
]],
Propose_Item1 = "Đóa Hồng",
Propose_Item2 = "Giày Thủy Tinh",
Propose_Item3 = "Thế Kỷ Giai Duyên",
Propose_Item4 = "Nhẫn Kim Cương",
My_Love = "Thân yêu: ",
Love = "Người yêu: ",
MOUNTS_LEVEL_GET = "Lv%d nhận",
MOUNTS_GM_GET = "Hoạt động tặng",
BUY_ACTIVITY_LIMIT = "Có thể mua: ",
FULL_RECOVERY = "Hồi phục hoàn toàn",
NEXT_RECOVERY = "Hồi phục tiếp",
BUY_GOLD_LIMIT = "Có thể gọi: ",
SHAKE_TIMES = "Gọi %d lần",
RANDOM_MAP = "Bản đồ ngẫu nhiên",
SEND_INVITATION = "Gửi lời mời",
RICH_INVITAION = "Thiệp Phú Hào",
BEAUTIFUL_INVITAION = "Thiệp Tinh Xảo",
COMMON_INVITATION = "Thiệp Thường",
SELECT_WEDDING_TYPE = "Chọn hôn lễ muốn tổ chức",
SELECT_WEDDING_INV = "Chọn loại thiệp mời",
MARRY_INV_INFO = "Sự hiện diện của bạn là niềm vinh dự cho gia đình chúng tôi!",
INVITATION_CARD = "Thiệp Mời",
INVITATION_TIP = "Mời bạn tham dự hôn lễ của chúng tôi",
INVITATION_TIP2 = "Tổ chức hôn lễ",
WEDDING_TIME = "Thời gian: ",
SingInDesc = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Tích lũy điểm danh, nhận thưởng tương ứng</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Trong thời gian cố định đạt cấp VIP yêu cầu được nhận thưởng x2</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Thưởng 2 (Thưởng VIP x2) có thể nhận bù trong ngày khi tăng cấp VIP</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Thưởng điểm danh ngày tính lại vào lúc 24:00 mỗi ngày, thưởng trong ngày chưa nhận sẽ không thể nhận bù vào hôm sau</T><BR>20</BR>
]],
SingInTitle = "Thưởng điểm danh",
SingInDAYS = "Ngày %d",
SingInVipTips = "Đã nhận thưởng điểm danh trong ngày, tăng đến VIP%d có thể nhận thưởng x2, đồng ý nạp?",
SingInProgress = [[<T S="22" C="255,236,193" P="0">Điểm danh tích lũy tháng: </T><T S="22" C="255,227,116" P="0">%d</T><T S="22" C="255,236,193" P="0"> ngày</T>]],
ACTIVITY_HAVED_FULL = "Thể Lực đã đầy",
HOUR1 = " giờ",
MINUTE1 = " phút",
BEFORE = "Trước",
VIP_FIRST_DOUBLE = "Nạp lần đầu",
OppositeSexFriend = "Bạn khác giới",
LevelAndNameFormat = [[<T S="22" C="229,105,22" P="0">Lv%d</T><BL>10</BL><T S="22" C="127,70,26" P="0">%s</T>]],
BeStrongBtnNameArrays = {"Mạnh Hơn","Thêm Vàng","Thêm Trang Bị","Muốn Lên Cấp","Thêm Đá Quý","Thú Cưng Mạnh","Chiến Thắng","Hỏi Đáp Tân Thủ","Dự Báo Tính Năng"},
BUY_FIVE_ATTENTION = [[<T C="255,236,193" S="18" P="0">Liên tục chiêu </T><T C="233,166,62" S="18" P="0">%d lần</T><T C="255,236,193" S="18" P="0"> Mèo Chiêu Tài</T>]],
BUY_FIVE_NEED_CONSUME = "Cần tốn ",
BUY_FIVE_CAN_GET = "Tối thiểu nhận ",
BUY_FIVE_AFFIRM = "Đồng ý",
PETREST = "Nghỉ",
PETATWAR = "Chiến",
PETNOREBIIRTH = "Pet chiến đấu không thể trùng sinh",
PETNOADVANCEGOODS = "Thuốc không đủ", 
PETNOENOUGHNUM = "Số Pet không đủ",
PETENOUGHNUM = "Ô gộp đã đầy, hãy dùng bớt",
PETNOADVANCELEVEL = "Pet chưa đạt cấp %s, hãy tăng cấp",
PETNOGOODS = "Nguyên liệu tiêu hao không đủ",
PETSKILL1 = "Ô kỹ năng 1",
PETSKILL2 = "Ô kỹ năng 2",
PETNOSKILL = "Kích hoạt kỹ năng mới có thể tẩy luyện",
PETSKILLSUC = "Tẩy luyện kỹ năng thành công",
PETENOUGHEXP = "EXP đã đủ để tăng cấp",
PETNOUPEXP = "Chưa thêm Pet",
PETUPTOLEVEL = "Cấp Pet không được hơn nhân vật",
PETMAXNUM = "Tối đa có 200 Pet",
PETNORAFFLEGOODS = "Mảnh Pet không đủ",
PETMAXEXP = "EXP: ",
PETFREE2 = "M.Phí",
PETRAFFLEDESC1 = [[
<T C="255,236,193" S="24" P="0" SC="132,66,29" SE="1" SS="4">Có cơ hội nhận </T>
<T C="93,222,254" S="24" P="0" SC="132,66,29" SE="1" SS="4">Pet Lam</T>
]],
PETRAFFLEDESC2 = [[
<T C="255,236,193" S="24" P="0" SC="132,66,29" SE="1" SS="4">Có cơ hội nhận </T>
<T C="93,222,254" S="24" P="0" SC="132,66,29" SE="1" SS="4">Pet Lam</T>
]],
PETRAFFLEDESC3 = [[
<T C="255,236,193" S="24" P="0" SC="132,66,29" SE="1" SS="4">Chắc chắn nhận </T>
<T C="93,222,254" S="24" P="0" SC="132,66,29" SE="1" SS="4">Pet Lam</T>
]],
PETFULLADVANCELEVEL = "Đã đạt bậc cao nhất",
NO_GIFT = "Chưa có vật phẩm này, đồng ý mua?",
CONJUGAL_RELATION_TIP = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Vợ chồng mỗi ngày tặng quà cho nhau nhận điểm tình cảm, tăng cấp tình cảm</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Cấp tình cảm càng cao, kích hoạt càng nhiều kỹ năng vợ chồng</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3. </T><T C="127,70,26" S="22" P="0">Thuộc tính thêm của kỹ năng vợ chồng chỉ có hiệu lực khi hôm nay bên kia đã tặng quà.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Ly hôn sẽ trừ 886 Kim Cương phí thủ tục của bên đề nghị</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Sau khi ly hôn sẽ hủy kỹ năng vợ chồng, cấp tình cảm sẽ tính lại từ đầu</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> Sau khi ly hôn, áo cưới của cả hai cũng sẽ biến mất</T><BR>20</BR>
]],
VIP_LEVEL_1 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 35 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. Nhận đặc quyền thêm ô đạo cụ</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. Nhận đặc quyền Rèn-Cường Hóa 5 lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">50</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">22</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">9</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">11</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 1, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">20</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">1</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_2 =
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 500 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP1</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. Nhận đặc quyền càn quét Vùng Mạo Hiểm 10 lần liên tục</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">55</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">24</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">15</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">13</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">12</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">15</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 2, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">13</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">25</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_3 =
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 1000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP2</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. Nhận đặc quyền ghép nhanh</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">60</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">26</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">20</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">12</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">17</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">13</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">20</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 3, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">8</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">17</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">30</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">8</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">7</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_4 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 2000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP3</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. Nhận đặc quyền dùng nhanh "Mèo Chiêu Tài"</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. Nhận đặc quyền tặng quà Cửa Hàng</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">65</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">28</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">25</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">14</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">21</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">14</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">25</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 4, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">19</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">5</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">35</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">7</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_5 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 5000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP4</T><BR></BR>
<T C="5,180,0" S="20" P="0">2.Nhận đặc quyền lật thẻ thêm trong Phó Bản Nhóm</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">70</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">30</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">30</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">16</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">23</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">15</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">30</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 5, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">12</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">21</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">1</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">40</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">5</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">12</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">8</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_6 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 20000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP5</T><BR></BR>
<T C="5,180,0" S="20" P="0">2.  Nhận thú cưỡi VIP</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">75</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">32</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">35</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">18</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">25</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">16</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">35</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 6, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">14</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">23</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">1</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">7</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">45</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">14</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">8</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_7 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 50000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP6</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">80</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">34</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">40</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">20</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">27</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">5</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">17</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">40</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 7, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">16</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">25</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">1</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">8</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">48</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">7</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">16</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">9</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20. Có quyền dùng Hình Nền dành riêng</T><BR></BR>
]],

VIP_LEVEL_8 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 150000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP7</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. Nhận Cánh VIP</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">85</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">36</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">45</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">22</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">29</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">5</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">18</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">45</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 8, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">18</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">27</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">1</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">9</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">51</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">8</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">18</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">9</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_9 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 300000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP8</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">90</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">38</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">50</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">24</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">31</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">3</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">19</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">50</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 9, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">20</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">29</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">1</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">54</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">9</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">20</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">9</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20. Có quyền dùng Hình Nền dành riêng</T><BR></BR>
]],

VIP_LEVEL_10 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 500000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP9</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Bạn bè tối đa </T><T C="5,180,0" S="20" P="0">200</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">95</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">55</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">26</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">33</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">7</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">20</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">55</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 10, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">22</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">31</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">11</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">57</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">22</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_11 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 750000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP10</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">100</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">42</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">60</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">28</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">35</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">8</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">21</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">60</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 11, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">24</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">33</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">12</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">60</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">11</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">24</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_12 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 1000000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP11</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">105</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">44</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">65</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">30</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">37</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">9</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">22</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">65</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 12, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">26</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">35</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">13</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">63</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">12</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">26</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_13 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 1500000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP12</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">110</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">46</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">70</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">32</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">39</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">23</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">70</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 13, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">28</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">37</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">14</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">66</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">13</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">28</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_14 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 2000000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP13</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">115</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">48</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">75</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">34</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">41</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">11</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">24</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">75</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 14, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">30</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">39</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">15</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">68</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">14</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">30</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
]],

VIP_LEVEL_15 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 2500000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Gồm tất cả đặc quyền VIP14</T><BR></BR>
<T C="5,180,0" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0"> 120</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Mỗi ngày nhận Thể Lực tối đa </T><T C="5,180,0" S="20" P="0"> 50</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0"> 80</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0"> 40</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0"> 41</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0"> 4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0"> 5</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0"> 12</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0"> 25</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0"> 80</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12.</T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 15, mỗi ngày tối đa mua Xúc Xắc </T><T C="5,180,0" S="20" P="0"> 32</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0"> 14</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0"> 2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0"> 16</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được giở mánh khóe thêm </T><T C="5,180,0" S="20" P="0"> 70</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17.</T><T C="127,70,26" S="20" P="0">Mỗi ngày có thể mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0"> 15</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18.</T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0"> 32</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0"> 10</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20.Có quyền dùng Bong Bóng Chat dành riêng</T><BR></BR>
]],
VIP_LEVEL_16 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 3000000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP15</T><BR></BR>
<T C="5,180,0" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0"> 125</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0"> 52</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0"> 81</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0"> 45</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0"> 42</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0"> 4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0"> 6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0"> 13</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0"> 26</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0"> 85</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12.</T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 16, mỗi ngày tối đa mua Xúc Xắc </T><T C="5,180,0" S="20" P="0"> 36</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0"> 42</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0"> 2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0"> 17</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0"> 71</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0"> 16</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18.</T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0"> 33</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0"> 11</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20.Thú cưỡi dành cho VIP16</T><BR></BR>
]],


VIP_LEVEL_17 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 3700000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP16</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">125</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày nhận Thể Lực tối đa </T><T C="5,180,0" S="20" P="0"> 52</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">82</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0">46</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">43</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0">14</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">27</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">86</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 17, mỗi ngày tối đa mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">37</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">43</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">18</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được dùng mánh khóe thêm </T><T C="5,180,0" S="20" P="0">72</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày có thể mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">17</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">34</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">11</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20. Có quyền dùng biểu cảm dành riêng x2</T><BR></BR>
<T C="5,180,0" S="20" P="0">21. Có skin dành cho VIP17</T><BR></BR>
]],


VIP_LEVEL_18 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 4500000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP17</T><BR></BR>
<T C="5,180,0" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0"> 125</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0"> 52</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0"> 83</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0"> 47</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0"> 44</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0"> 4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0"> 6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0"> 15</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0"> 28</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0"> 87</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12.</T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 18, mỗi ngày tối đa mua Xúc Xắc </T><T C="5,180,0" S="20" P="0"> 38</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0"> 44</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0"> 2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0"> 19</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được giở mánh khóe thêm </T><T C="5,180,0" S="20" P="0"> 73</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17.</T><T C="127,70,26" S="20" P="0">Mỗi ngày có thể mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0"> 18</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18.</T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0"> 35</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0"> 11</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20.Có quyền dùng biểu cảm dành riêng x4</T><BR></BR>
<T C="5,180,0" S="20" P="0">21.Có pet dành cho VIP18</T><BR></BR>
<T C="5,180,0" S="20" P="0">22.Có vòng sáng dành cho VIP18</T><BR></BR>
<T C="5,180,0" S="20" P="0">23.Có hiệu ứng vào phòng dành cho VIP18</T><BR></BR>
]],
VIP_LEVEL_19 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 5400000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP18</T><BR></BR>
<T C="5,180,0" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0"> 125</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0"> 52</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0"> 85</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0"> 48</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0"> 45</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0"> 4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0"> 6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0"> 16</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0"> 29</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0"> 88</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12.</T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 19, mỗi ngày tối đa mua Xúc Xắc </T><T C="5,180,0" S="20" P="0"> 39</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0"> 45</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0"> 2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0"> 20</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được giở mánh khóe thêm </T><T C="5,180,0" S="20" P="0"> 74</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17.</T><T C="127,70,26" S="20" P="0">Mỗi ngày có thể mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0"> 19</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18.</T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0"> 36</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0"> 11</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20.Có quyền dùng biểu cảm dành riêng x4</T><BR></BR>
]],
VIP_LEVEL_20 = 
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Nạp đủ 6400000 Kim Cương sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP19</T><BR></BR>
<T C="5,180,0" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0"> 125</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0"> 52</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0"> 85</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0"> 49</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0"> 46</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0"> 4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0"> 6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Vùng Mạo Hiểm-Tinh Anh </T><T C="5,180,0" S="20" P="0"> 17</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0"> 30</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0"> 89</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12.</T><T C="127,70,26" S="20" P="0">Giới hạn Xúc Xắc Đất Cấm tăng 20, mỗi ngày tối đa mua Xúc Xắc </T><T C="5,180,0" S="20" P="0"> 40</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0"> 46</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0"> 2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0"> 21</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được giở mánh khóe thêm </T><T C="5,180,0" S="20" P="0"> 75</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17.</T><T C="127,70,26" S="20" P="0">Mỗi ngày có thể mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0"> 20</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18.</T><T C="127,70,26" S="20" P="0">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0"> 37</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0"> 11</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20.Có quyền dùng biểu cảm dành riêng x4</T><BR></BR>
<T C="5,180,0" S="20" P="0">21.Có thời trang dành cho VIP20</T><BR></BR>
<T C="5,180,0" S="20" P="0">22.Đang cập nhật</T><BR></BR>
]],
VIP_LEVEL_21 =
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Tích lũy nạp 7500000 Xu sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Gồm tất cả đặc quyền VIP20</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa +</T><T C="5,180,0" S="20" P="0"> 125</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày nhận Thể Lực tối đa </T><T C="5,180,0" S="20" P="0"> 52</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0"> 85</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0"> 50</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0"> 47</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0"> 4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0"> 6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập phó bản Tinh Anh Vùng Mạo Hiểm </T><T C="5,180,0" S="20" P="0"> 18</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0"> 31</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0"> 90</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Xúc Xắc Đất Cấm tối đa +21, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0"> 41</T><T C="127,70,26" S="20" P="0">  lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0"> 47</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0"> 2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được săn báu thêm </T><T C="5,180,0" S="20" P="0"> 22</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được giở mánh khóe thêm </T><T C="5,180,0" S="20" P="0"> 76</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0"> 21</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0"> 38</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt vào Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0"> 12</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20.Có quyền dùng biểu cảm dành riêng x4</T><BR></BR>
<T C="5,180,0" S="20" P="0">21.Có Khung Avatar dành cho VIP21</T><BR></BR>
]],
VIP_LEVEL_22 =
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Tích lũy nạp 8700000 Xu sẽ tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Gồm tất cả đặc quyền VIP21</T><BR></BR>
<T C="5,180,0" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa +</T><T C="5,180,0" S="20" P="0"> 125</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày nhận Thể Lực tối đa </T><T C="5,180,0" S="20" P="0"> 52</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0"> 85</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Thể Lực </T><T C="5,180,0" S="20" P="0"> 51</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0"> 48</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0"> 4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0"> 6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập phó bản Tinh Anh Vùng Mạo Hiểm </T><T C="5,180,0" S="20" P="0"> 19</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0"> 32</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0"> 91</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12. </T><T C="127,70,26" S="20" P="0">Xúc Xắc Đất Cấm tối đa +22, mỗi ngày tối đa được mua Xúc Xắc </T><T C="5,180,0" S="20" P="0"> 42</T><T C="127,70,26" S="20" P="0">  lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0"> 48</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14. </T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0"> 2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được săn báu thêm </T><T C="5,180,0" S="20" P="0"> 23</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16. </T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được giở mánh khóe thêm </T><T C="5,180,0" S="20" P="0"> 77</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0"> 22</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được tạo mới đối thủ trong Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0"> 39</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt vào Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0"> 12</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20.Có quyền dùng biểu cảm dành riêng x4</T><BR></BR>
<T C="5,180,0" S="20" P="0">21.Sở hữu Danh Hiệu VIP 22 độc quyền có thể tự tùy chỉnh Danh Hiệu</T><BR></BR>
]],
VIP_LEVEL_23 =
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Tích lũy nạp 10000000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP22</T><BR></BR>
<T C="5,180,0" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">125</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">52</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">85</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa mua Thể Lực </T><T C="5,180,0" S="20" P="0">52</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">49</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tái lập Vùng Mạo Hiểm Phó bản Tinh Anh </T><T C="5,180,0" S="20" P="0">20</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">33</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">92</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12.</T><T C="127,70,26" S="20" P="0">Xúc Xắc Đất Cấm tối đa +23, mỗi ngày tối đa mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">43</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">49</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">24</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được giở mánh khóe thêm </T><T C="5,180,0" S="20" P="0">78</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">23</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được tạo mới đối thủ Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">40</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">13</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20.Có quyền dùng biểu cảm dành riêng x4</T><BR></BR>
<T C="5,180,0" S="20" P="0">21.Sở hữu thú cưỡi VIP23, có thể tự chọn thú cưỡi</T><BR></BR>
]],
VIP_LEVEL_24 =
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Tích lũy nạp 4300000 KC để tăng đến Cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Bao gồm tất cả đặc quyền VIP23</T><BR></BR>
<T C="5,180,0" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">125</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được nhận quà Thể Lực </T><T C="5,180,0" S="20" P="0">52</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">85</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa mua Thể Lực </T><T C="5,180,0" S="20" P="0">53</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0">50</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tái lập Vùng Mạo Hiểm Phó bản Tinh Anh </T><T C="5,180,0" S="20" P="0">21</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0">34</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0">93</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12.</T><T C="127,70,26" S="20" P="0">Xúc Xắc Đất Cấm tối đa +24, mỗi ngày tối đa mua Xúc Xắc </T><T C="5,180,0" S="20" P="0">44</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0">50</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0">25</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được giở mánh khóe thêm </T><T C="5,180,0" S="20" P="0">79</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0">24</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được tạo mới đối thủ Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0">41</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">13</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20.Có quyền dùng biểu cảm dành riêng x4</T><BR></BR>
<T C="5,180,0" S="20" P="0">21.Sở hữu Khung Avatar VIP24, có thể tự chọn Khung Avatar</T><BR></BR>
<T C="5,180,0" S="20" P="0">21.Sở hữu Khung Avatar VIP24, có thể tự chọn Khung Hiệu Ứng</T><BR></BR>
<T C="5,180,0" S="20" P="0">21.Sở hữu Khung Chat VIP24, có thể tự chọn Khung Chat</T><BR></BR>
]],

VIP_LEVEL_25 =
[[
<T C="255,227,116" S="20" P="0" SC="132,66,29" SE="1" SS="4">Tích lũy nạp 5500000 KC để tăng đến Cấp VIP này</T><BR></BR>
<T C="5,180,0" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Bao gồm tất cả đặc quyền VIP24</T><BR></BR>
<T C="5,180,0" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Số bạn bè tối đa tăng </T><T C="5,180,0" S="20" P="0">125</T><T C="127,70,26" S="20" P="0"> người</T><BR></BR>
<T C="5,180,0" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Mỗi ngày nhận Thể Lực tối đa </T><T C="5,180,0" S="20" P="0"> 52</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Vàng </T><T C="5,180,0" S="20" P="0">85</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa mua Thể Lực </T><T C="5,180,0" S="20" P="0"> 54</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="5,180,0" S="20" P="0"> 51</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Tháp Thí Luyện </T><T C="5,180,0" S="20" P="0">4</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">8.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Phó Bản Nhóm </T><T C="5,180,0" S="20" P="0">6</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">9.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tái lập Vùng Mạo Hiểm Phó bản Tinh Anh </T><T C="5,180,0" S="20" P="0"> 22</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">10.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="5,180,0" S="20" P="0"> 35</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">11.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được mua Pha Lê </T><T C="5,180,0" S="20" P="0"> 94</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">12.</T><T C="127,70,26" S="20" P="0">Xúc Xắc Đất Cấm tối đa +25, mỗi ngày tối đa mua Xúc Xắc </T><T C="5,180,0" S="20" P="0"> 45</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">13.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="5,180,0" S="20" P="0"> 51</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">14.</T><T C="127,70,26" S="20" P="0">Mỗi ngày tối đa được tái lập Bí Cảnh </T><T C="5,180,0" S="20" P="0">2</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">15.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được Săn Báu thêm </T><T C="5,180,0" S="20" P="0"> 26</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">16.</T><T C="127,70,26" S="20" P="0">Chú Hề Săn Báu mỗi ngày được giở mánh khóe thêm </T><T C="5,180,0" S="20" P="0"> 80</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">17.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Vé Lãnh Chúa Vực Sâu </T><T C="5,180,0" S="20" P="0"> 25</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">18.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được tạo mới đối thủ Tháp Anh Hùng </T><T C="5,180,0" S="20" P="0"> 42</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">19.</T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua lượt vào Ảo Cảnh Không Gian </T><T C="5,180,0" S="20" P="0">13</T><T C="127,70,26" S="20" P="0"> lần</T><BR></BR>
<T C="5,180,0" S="20" P="0">20. Có quyền dùng biểu cảm dành riêng x4</T><BR></BR>
<T C="5,180,0" S="20" P="0">21.Sở hữu Thời Trang VIP25, có thể tự chọn Thời Trang</T><BR></BR>
]],



EQUIP_STRA_LEVEL_UP = "Tăng cấp tăng sao",
EQUIP_REACHED_MAX_STAR_LEVEL = "Đã tăng đến cấp sao tối đa",
SEND_GIFT_TIP = "Số lần tặng quà hôm nay đã hết",
ATT_ROUND = "Số lượt: ", 
MY_GEM = "Chọn đá",
BESTRONG_NAME = "Cẩm nang",
TASK_UINAME = "Nhiệm vụ",
SETTING_GAME_NAME = "Tên nhân vật: ",
SETTING_SERVE_NAME = "Server: ",
SETTING_SOUND = "Âm thanh:",
SETTING_SHIELD_PLAEYER = "Người gần: ",
SETTING_SHIELD_INVITE = "Mời bạn bè: ",
SETTING_SHIELD_INVITE2 = "Mời đội:",
SETTING_EXCHANGE_GIFT = "Đổi Quà",
SETTING_SHARE_GAME = "Chia sẻ game: ",
SETTING_ADVISE_MAIL = "Góp ý",
SETTING_EXIT = "Thông báo",
SETTING_SYSTEM = "Thiết lập hệ thống",
SETTING_GAME = "Thiết lập tính năng",
SETTING_MUSIC = "Nhạc: ",
SEND_WEDDING_CARD_TIP = "Gửi thiệp mời thành công",
APPLY = "Xin phép",
ATH_REWARD_SEND = [[<T C="79,60,48" S="18" P="0">Đạt cấp thi đấu tương ứng sẽ nhận thưởng (Một lần)</T>]],
ATH_SHOP_CHANGE = [[<T C="127,70,26" S="22" P="0">Thời gian tự tạo mới: </T><T C="158,0,0" S="22" P="0">%s</T>]],
VIP_DESC2 = [[<T C="255,236,193" S="20" P="0">Nạp thêm </T><T C="99,255,95" S="22" P="0">%d</T><I Z="0.7">ui/common/common_icon_zuanshi.png</I><T C="255,236,193" S="20" P="0"> sẽ thành </T><T C="99,255,95" S="22" P="0">VIP%d</T>]],
STRENGTHENTIP = "Cả set %s +%d",
STRENGTHENTIP1 = "Thuộc tính set khóa",
BAGTIP1 = "Tên này rất lười, chả để lại gì cả!",
SELECT_GIFT_TYPE = "Hãy chọn quà muốn tặng",
PUPIL_REWARD = "Thưởng đệ tử",
DAILY_COPY_GOLD_DESC1 = "Gây sát thương",
DAILY_COPY_GOLD_DESC2 = "Vàng Lớn",
DAILY_COPY_GOLD_DESC3 = "Vàng Nhỏ",
DAILY_COPY_GOLD_DESC4 = "Diệt Quái Rương",
DAILY_COPY_CLICK_CONTINUE = "Nhấn màn hình tiếp tục",
NAME_TOO_SHOOT = "Tên quá ngắn, hãy nhập lại!",
NAME_HAVED_EXIST = "Trùng tên, hãy nhập lại!",
NAME_CANT_BE_NUMBER = "Tên không được dùng số!",
SHAKE_TIMES_FINISH = "Đã hết lượt chiêu tài",
BUY_ACTIVITY_TIMES_FINISH = "Đã hết số lần mua Thể Lực!",
WEDDING_HALL_PASS = "Mật khẩu lễ đường: ",
SETTING_WEDDING_HALL_PASS = "Thiết lập mật khẩu lễ đường thành công", 
YOU_CANT_CHANGE_NAME = "Không phải chủ Công Hội, không thể sửa tên Công Hội!",
WEDDING_NO_GUEST = "Hiện chưa có khách",
PRIEST_SAY = {"Cô dâu chú rể có thể tặng Lì Xì Vàng!",
"Đoạt Lì Xì nhận Vàng thử vận may!",
"Mỗi Lì Xì có thể nhận số Vàng ngẫu nhiên!",
"Cô dâu chú rể có thể phát Kẹo Hỉ tặng Thể Lực!",
"Đoạt Kẹo Hỉ nhận ngay Thể Lực!",
"Đốt Pháo có thể nhận EXP!",
"Tặng chúc phúc cho cô dâu chú rể sẽ tăng tình cảm cho họ!",
"Tặng chúc phúc cũng được nhận EXP!"},
GET_OUT_WEDDING_HALL = "Bị chủ nhân hôn lễ trục xuất",
SINGCOPY_FAIL = "Thắng thua là chuyện bình thường thôi, biết không?",
LOSE_TIPS = "Thử lại đi! Biết đâu thành công?",
ENERGY_NOT_SHORTAGE = "Thể Lực không đủ, cần thêm không?",
WIPEOUTNUM = "Vé Càn Quét không đủ, mua thêm không?",
TOWER_DAILY_RANKING = "Hạng mỗi ngày",
TEAM_COPY_COUNTDOWN = "Khiêu chiến còn",
TEAM_COPY_COUNTDOWN2 = "Đếm ngược",
REMOVE = "Giải trừ",
COMPETIVITY_LEVEL = "Cấp thi đấu",
COMPETIVITY_DATA  = "Dữ liệu thi đấu",
COMPETIVITY_INTEGRAL = "Điểm thi đấu",
COMPETIVITY_RESULT = "Thắng %d trận\n(Tỷ lệ thắng: %d%%)",
ACHIE_NUMBER = "Số thành tựu",
TEACHER_LEVEL = "Cấp Sư Đức",
TEACHER_PUPIL_NUMBER = "Số đệ tử tốt nghiệp",
TEACHER_VALUE = "Sư Đức",
WORLD_BOSS_DESC1 = "Khiêu chiến BOSS Thế Giới, nhận thưởng lớn!", 
JUST_NOW = "Vừa online",
MINITE_AGO = "%d phút trước",
HOURS_AGO = "%d giờ trước",
DAYS_AGO = "%d ngày trước",
LONG_AGO = "Trước đó khá lâu",
XX_WORSHIP_XX = "Đã thích",
HAVED_WORSHIP_TODAY = "Hôm nay đã thích",
WORSHIP_SUCCESS = "Thích thành công, nhận %d điểm Thể Lực",
CANT_WORSHIP_SELF = "Không thể tự yêu bản thân!",
OPENCHEST = "Mở rương",
OPENCHEST1 = "Hãy chọn số lượng (1 lần tối đa 100)",
DAILY_LOSE_DESC1 = [[<T C="255,223,116" S="26" P="0">Sát thương thấp nhất:  </T><T C="255,236,193" S="26" P="0">%s</T>]],
DAILY_LOSE_DESC2 = [[<T C="255,223,116" S="26" P="0">Quái bỏ trốn:  </T><T C="255,236,193" S="26" P="0">%s</T>]],
DAILY_LOSE_DESC3 = "Thưởng Vàng: ",
DAILY_LOSE_DESC4 = [[<T C="255,223,116" S="16" P="0">Sát thương thấp nhất:  </T><T C="255,236,193" S="16" P="0">%s</T>]],
WORSHIP_WORD = "Thích",
CHECK_HUSBAND = "Xem chồng",
CHECK_WIFE = "Xem vợ",
UPGRADE_TIPS0 = "Giờ hãy tìm hiểu tính năng mới nào!~",
UPGRADE_TIPS1 = "Mạnh hơn rồi, nhớ kết thêm bạn đấy",
UPGRADE_TIPS2 = "Trên con đường rèn luyện luôn cô độc, nhưng phong cảnh luôn là đẹp nhất",
UPGRADE_TIPS3 = "Đúng là dũng sĩ ta chọn, thật dũng mãnh",
UPGRADE_TIPS4 = "Tiếp tục cố gắng, ngươi đã có thực lực rất mạnh",
TEACH_1 = "Vào ải phó bản",
TEACH_2 = "Chọn ải 1",
TEACH_3 = "Bắt đầu khiêu chiến nào",
TEACH_4 = "Ngón tay nhấn giữ nhân vật, kéo ngược hướng mục tiêu tấn công, ngắm kỹ tấn công",
TEACH_5 = "Chọn kỹ năng tấn công",
TEACH_6 = "Luyện tập thao tác tấn công lần nữa",
TEACH_7 = "Mở thanh hướng dẫn",
TEACH_8 = "Xem nhiệm vụ",
TEACH_9 = "Nhiệm vụ đã hoàn thành, hãy nhận thưởng",
TEACH_10 = "Đã có nhiệm vụ mới, nhấn vào",
TEACH_11 = "Nhấn vào ải",
TEACH_12 = "Bắt đầu khiêu chiến nào",
TEACH_13 = "Dùng đạo cụ bay",
TEACH_14 = "Vuốt màn hình, kéo ngược hướng muốn bay",
TEACH_15 = "Nhấn giữ màn hình để di chuyển, di chuyển theo hướng chỉ định",
TEACH_16 = "Tấn công địch",
TEACH_17 = "Mở thanh hướng dẫn",
TEACH_18 = "Xem tính năng kỹ năng",
TEACH_19 = "Chọn đạo cụ nộ khí",
TEACH_20 = "Hoàn thành",
TEACH_21 = "Mở nhiệm vụ",
TEACH_22 = "Nhấn nhận thưởng nhiệm vụ",
TEACH_23 = "Hãy tới nhiệm vụ mới",
TEACH_24 = "Vào phó bản Tinh Anh",
TEACH_25 = "Bắt đầu khiêu chiến nào",
TEACH_26 = "Dùng đạo cụ nộ khí sẽ thi triển POW nhanh hơn",
TEACH_27 = "Nhấn dùng POW, có thể gây sát thương lớn",
TEACH_28 = "Hãy tiêu diệt hắn",
TEACH_29 = "Nhấn mở rương",
TEACH_30 = "Đóng giao diện nhiệm vụ",
TEACH_31 = "Nhấn thanh hướng dẫn",
TEACH_32 = "Nhấp nhân vật",
TEACH_33 = "Nhấn trang bị",
TEACH_34 = "Nhấn mặc",
TEACH_35 = "Quay về",
TEACH_36 = "Mở thanh hướng dẫn",
TEACH_37 = "Nhấn rèn",
TEACH_38 = "Chọn vũ khí",
TEACH_39 = "Đây là nguyên liệu cần tốn khi cường hóa trang bị",
TEACH_40 = "Nhấn cường hóa",
TEACH_41 = "Nhấn quay về",
TEACH_42 = "Mở thanh hướng dẫn",
TEACH_43 = "Nhấn rèn",
TEACH_44 = "Chọn trang Tăng Sao",
TEACH_45 = "Chọn vũ khí",
TEACH_46 = "Nhấn tăng sao",
TEACH_47 = "Mở thanh hướng dẫn",
TEACH_48 = "Nhấn rèn",
TEACH_49 = "Chọn trang Khảm",
TEACH_50 = "Chọn vũ khí",
TEACH_51 = "Khảm đá tấn công",
TEACH_52 = "Chọn đá tấn công",
TEACH_53 = "Khảm",
TEACH_54 = "Mở thanh hướng dẫn",
TEACH_55 = "Nhấn Pet",
TEACH_56 = "Nhấn nhận Pet",
TEACH_57 = "Nhận miễn phí",
TEACH_58 = "Dùng đạo cụ",
TEACH_59 = "Bắt đầu",
TEACH_60 = "Khiêu chiến",
TEACH_61 = "Khiêu chiến",
TEACH_62 = "Khiêu chiến",
TEACH_63 = "Bắt đầu",
TEACH_64 = "Nhấn vào tượng Vua Lực Chiến",
TEACH_65 = "Nhấn nút hướng dẫn",
TEACH_66 = "Nhấn nút thú cưỡi",
TEACH_67 = "Mở thanh hướng dẫn",
TEACH_68 = "Nhấn nút nhiệm vụ",
TEACH_69 = "Nhấn trang phụ tuyến",
TEACH_70 = "Vào Đấu Trường",
TEACH_71 = "Nhấn nút tạo phòng",
TEACH_72 = "Nhấn nút xác nhận",
TEACH_73 = "Nhấn nút chơi ngay",
TEACH_74 = "Nhấn nút thú cưỡi",
TEACH_75 = "Nhấn hình năng động",
TEACH_76 = "Nhấn kiến trúc Công Hội",
TEACH_77 = "Nhấn kiến trúc kết hôn",
TEACH_78 = "Nhấn kiến trúc Cửa Hàng",
TEACH_79 = "Mở thanh hướng dẫn",
TEACH_80 = "Nhấn túi",
TEACH_81 = "Nhấn thời trang",
TEACH_82 = "Nhấn mặc",
TEACH_83 = "Khiêu chiến",
TEACH_84 = "Nhấn quay về",
TEACH_85 = "Nhấn xuất chiến",
TEACH_86 = "Mau đến bắt đầu Mạo Hiểm mới nào!",
TEACH_87 = "Rất nhiều nhiệm vụ đang đợi bạn!",
TEACH_88 = "Dùng đạo cụ nộ khí sẽ tăng nộ khí!",
TEACH_89 = "Nhớ dùng Túi Sinh Lực để tăng sinh lực!",
TEACH_90 = "Đồng ý dùng",
TEACH_91 = "Gió sẽ ảnh hướng tới quỹ đạo ném, phải kiểm soát tốt lực ném",
TEACH_92 = "Gió cấp 3 khá mạnh, hãy tính toán kỹ lực tấn công",
TEACH_93 = "Gió cấp 3 khá mạnh, hãy tính toán kỹ lực tấn công",
TEACH_94 = "Gió cấp 4 rất mạnh, hãy tính toán kỹ lực tấn công",
TEACH_95 = "Gió cấp 4 rất mạnh, hãy tính toán kỹ lực tấn công",
TEACH_96 = "Gió cấp 5 siêu mạnh, hãy tính toán kỹ lực tấn công",
TEACH_97 = "Gió cấp 5 siêu mạnh, hãy tính toán kỹ lực tấn công",
TEACH_98 = "Gió cấp 6 gió lốc, hãy tính toán kỹ lực tấn công",
TEACH_99 = "Gió cấp 6 gió lốc, hãy tính toán kỹ lực tấn công",
TEACH_100 = "Vào",
TEACH_101 = "Chọn dạng Tinh Anh",
TEACH_102 = "Chọn ải 1",
TEACH_103 = "Nhấn mặc",
SUIT = "Set",
NOT_IN_RANKLIST = "Chưa vào BXH",
MAIL_FULLBAG = "Túi đã đầy, một số thưởng chưa nhận",
DAILY_Fail_MONSTER = "Quái bỏ trốn",
HALL_NO_SEAT = "Phòng không đủ chỗ",
NOTENOUTH1 = "Quà không đủ",
NOTENOUTH2 = "Rương không đủ",
NOTENOUTH3 = "Chìa khóa không đủ",
OPENGIFT = "Mở quà",
CURRENT_LEVEL2 = [[<T C="79,60,48" S="22" P="0">Hiện ở tầng </T><T C="99,255,95" S="22" P="0">%s</T><T C="79,60,48" S="22" P="0"></T>]],
START_LEVEL = "Bắt đầu",
ATHLETICS_LIST = "BXH Thi Đấu",
RANK_NO_DATA_ATT = "BXH này chưa ai lọt vào",
MUL_RESET_COPY = "Không đủ lượt, dùng %d Kim Cương Khóa tạo mới phó bản %s? (Hôm nay còn được tạo mới %d lần)",
PET_MSG1 = "Tăng thêm %d cấp mở",
WORLD_BOSS_TITLE = "BOSS Thế Giới",
OPENGIFTLEVEL = "Chưa đạt cấp, không thể dùng",
ATTRTIP1 = "Lượng sinh lực của nhân vật",
ATTRTIP2 = "Ảnh hưởng sát thương nhân vật gây ra",
ATTRTIP3 = "Kháng và giảm sát thương cho nhân vật",
ATTRTIP4 = "Tỉ lệ bạo kích và sát thương bạo kích",
ATTRTIP5 = "Giảm tỉ lệ bị bạo kích và sát thương bạo kích",
ATTRTIP6 = "Tăng sát thương, giảm sát thương nhận vào",
ATTRTIP7 = "Tăng tấn công nhân vật",
ATTRTIP8 = "Tăng phòng thủ nhân vật",
ATTRTIP9 = "Ảnh hưởng thứ tự ra tay trong chiến đấu",
ATTRTIP10 = "Ảnh hưởng thứ tự ra tay khi bắt đầu trận",
ATTRTIP11 = "Giảm phòng thủ của đối thủ",
ATTRTIP12 = "Giảm sát thương nhận vào",
ATTRTIP13 = "Khả năng phá địa hình của vũ khí",
IMPROVE_TOP = "Cấp sao đã đạt tối đa! Giỏi quá!",
BELONG_PLAYER = "Người sở hữu",
RANKLIST_TITLE = "Xếp hạng",
RANKLIST_LAOGONG = "Chồng",
RANKLIST_LAOPO = "Vợ",
STRENGTENTIP2 = "(Thêm Đá Thánh sẽ đảm bảo thất bại không giảm cấp)",
MASTEROPENTIPS = "%d ngày sau mở",
HURT_ALL_VALUE = "Tổng ST: ",
GET_RANK_REWARD = "Nhận thưởng hạng",
GET_KILL_REWARD = "Nhận thưởng tiêu diệt",
LOGIN_YOUKE = "Chơi ngay",
LOGIN_REGIST = "Đăng ký",
LOGIN_SAVE_ACCOUNT = "Nhớ tài khoản",
FIGHTADD = "Lực chiến tăng: ",
LOGIN_PASSWORD_SURE = "Xác nhận mật khẩu: ",
LOGIN_MAIL = "Email: ",
LOGIN_REGIST_SUCCESS = "Đăng ký thành công",
LOGIN_ERROR = "Tài khoản hoặc mật khẩu sai",
LOGIN_REGISTED = "Tài khoản đã được đăng ký",
LOGIN_REGIST_FAIL = "Tài khoản đăng ký thất bại",
UP_TO_LOAD_MORE = "Vuốt lên tải thêm",
RELAX_TO_LOAD = "Thả ra tải",
POWER_NOT_ENOUGH = "Thể Lực không đủ, cần thêm không?",
WORSHIP_INFO = "Thông tin thích",
ACTIVITY_TARGET_TYPE_1 = {"Cấp thi đấu đạt %s","bậc"},
ACTIVITY_TARGET_ARRAYS = {"Đồng","Bạc","Vàng","Bạch Kim","Bậc Thầy"},
VOICE_CHAT = "Ấn   nói",
STOP_SWEEPING2 = "Dừng càn quét?",
SWEEP_RESULT_TIPS2 = "Càn quét tầng %s chưa kết thúc, chưa nhận được thưởng: ",
SEND_RECORDING = "Thả   gửi",
RECODRING_ERROR = "Ghi âm thất bại, thời gian ngắn nhất 1 giây",
LOOSEN_YOUR_FINGER_CANCEL = "Thả tay ra, hủy gửi",
WORLD_BOSS_KILL = "Đã diệt thành công %s",
WORLD_BOSS_KILLED = "%s đã diệt %s",
WORLD_BOSS_NOTKILL = "Bạn không diệt BOSS, không thể nhận thưởng!",
WORLD_BOSS_NOKILL = "Yếu quá, không ai diệt được BOSS. %s thất vọng bỏ đi!",
TOWER_DESC = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 00:00 mỗi ngày hệ thống tạo mới, sau khi tạo mới sẽ quay về tầng 1, hồi phục số lần khiêu chiến. (Người chơi đang càn quét sẽ dừng càn quét, trở về tầng 1)</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 00:00 mỗi ngày phát thưởng theo hạng Tháp Thí Luyện.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Tháp Thí Luyện có 3 lần khiêu chiến, khiêu chiến thất bại trừ 1 lần, khi còn 0 lần sẽ kết thúc khiêu chiến.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Tháp Thí Luyện cần đạt mục tiêu của tầng hiện tại, nếu không sẽ khiêu chiến thất bại.</T><BR>20</BR>
]],
MULTI_SWEEP_TIP = "VIP%d mở tính năng này, nạp?",
COMMUNITY_HISTORY_FIGHT = [[<T C="62,34,8" S="22" P="0">Chiến tích: </T><T C="128,54,13" S="22" P="0">%d trận %d thắng (%s)</T>]],
COMMUNITY_HISTORY_FIRST = [[<T C="62,34,8" S="22" P="0">Hạng 1: </T><T C="128,54,13" S="22" P="0">%d lần</T>]],
COMMUNITY_HISTORY_SECOND = [[<T C="62,34,8" S="22" P="0">Hạng 2:</T><T C="128,54,13" S="22" P="0">%d lần</T>]],
COMMUNITY_HISTORY_THIRD = [[<T C="62,34,8" S="22" P="0">Hạng 3: </T><T C="128,54,13" S="22" P="0">%d lần</T>]],
COMMUNITY_CUR_DATA = [[<T C="62,34,8" S="22" P="0">Chiến tích tuần: </T><T C="128,54,13" S="22" P="0">%d trận %d thắng (%s)</T>]],
COMMUNITY_CUR_SCORE = [[<T C="62,34,8" S="22" P="0">Điểm hiện tại: </T><T C="128,54,13" S="22" P="0">%d</T>]],
COMMUNITY_CUR_RANK = [[<T C="62,34,8" S="22" P="0">Hạng hiện tại: </T><T C="128,54,13" S="22" P="0">%d</T>]],
COMMUNITY_CUR_RESULT = [[<T C="110,89,67" S="20" P="0">(Công Hội Chiến sẽ tổng kết sau %d%s)</T>]],
COMMUNITY_MY_FIGHT = "Chiến tích Công Hội",
WORLD_BOSS_DESC = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Boss Rồng xuất hiện vào 19h mỗi ngày. Toàn bộ người chơi đều có thể khiêu chiến. Nhận nhiều điểm cống hiến Guild.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Có thể dùng Cổ Vũ để tăng sát thưởng trong ngày, tối đa 100%. Dùng và có tỉ lệ thành công nhỏ, dùng Kim Cương chắc chắn thành công.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Nếu bị hạ gục, cần đợi để vào tiếp hoặc có thể dùng Kim Cương để vào nhanh.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Sau khi kết thúc, thưởng Hạng sẽ gửi qua Thư.</T><BR>20</BR>
]],
WORLD_BOSS_END_TITLE = "Hoạt động kết thúc",
WORLD_BOSS_WIN_DESC = [[<T C="255,236,193" S="22" P="0"></T><T C="99,255,95" S="22" P="0"> %s </T><T C="255,236,193" S="22" P="0"> đã diệt BOSS %s !</T>]],
WORLD_BOSS_FAIL_DESC = [[<T C="255,236,193" S="22" P="0">BOSS %s đã rời khỏi, hãy đợi BOSS trở lại!</T>]],
WORLD_BOSS_TITLE_DEAC = "Ngày mai %s hãy diệt quái %s tiếp!",
WORLD_BOSS_OPEN_TIME = [[<T C="255,236,193" S="22" P="0"></T><T C="255,89,74" S="22" P="0">%s-%s</T><T C="255,236,193" S="22" P="0"> mỗi ngày mở</T>]],
WORLD_BOSS_NOT_OPEN = [[<T C="255,236,193" S="22" P="0">19h00 Mở</T>]],
WORLD_BOSS_OPEN_TIME_DOWN = "Mở còn: ",
WORLD_BOSS_TIME_DOWN1 = [[<T C="255,236,193" S="20" P="1"  SC="79,60,48" SS="2" SE="1">Đang chờ </T><T C="255,89,74" S="20" P="1"  SC="79,60,48" SS="2" SE="1">%s</T>]],
WORLD_BOSS_INSPIRE =  [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="128,54,13" SS="4" SE="1">%d Cổ vũ</T>]],
WORLD_BOSS_TIME_DOWN2 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Đang chờ </T><T C="255,89,74" S="20" P="1"  SC="79,60,48" SS="4" SE="1">%s</T>]],
WORLD_BOSS_SUB_TIME = "%d xóa",
WORLD_INSPIRE_ADD = [[<T C="255,227,116" S="22" P="1" SC="127,70,26" SS="4" SE="1">Sát thương tăng: </T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">%s</T>]],
WORLD_INSPIRE_GOLD_LAST = "Cổ vũ Vàng đang chờ...",
WORLD_INSPIRE_INSPIRE_NO = "BOSS Thế Giới chưa mở, cổ vũ vô hiệu!",
WORLD_INSPIRE_ADD_SUCCESS = "Cổ vũ thành công",
WORLD_INSPIRE_ADD_Fail = "Cổ vũ thất bại",
WORLD_BOSS_DEAD = "BOSS Thế Giới đã tử vong!",
WORLD_BOSS_DEAD1 = "BOSS Thế Giới đã trốn thoát!",
SHOP_LIMIT = "[Còn %d]",
COMMUNITY_BATTLE = "Công Hội: ",
COMMUNITY_FIGHT_END = "Công Hội Chiến đã kết thúc!",
DOWN_LOADING_PRO = "Tiến độ: %dKB/%dKB  (%s)",
APPLY1 = "Đã xin phép",
SEND_RECORD_CHAT_ERROR  = "Gửi voice thất bại",
NPC_NAME_1 = "Mirya",
NPC_NAME_2 = "Giáo Sư",
ACCOUNT_NOT_EXIST = "Tài khoản không tồn tại",
PASSWORD_ERROR = "Mật khẩu sai",
NOTCHOOSEEQUIP = "Chưa chọn trang bị",
LOGIN_ALL_SERVER = "Tất cả máy chủ",
LOGIN_TIPS_ACCOUNT = "6-16 ký tự, có thể dùng thư, chữ cái, số, gạch dưới",
LOGIN_TIPS_PASSWORD = "6-12 ký tự, phân biệt hoa thường",
LOGIN_TIPS_PASSWORD1 = "Hãy nhập lại mật khẩu",
EVERYDAY = "Mỗi ngày",
DANADNDAO_WELCOME = "Xin chào! Hãy cùng nhau vui chơi thỏa thích!",
RECHARGE_SUCCESS1 = "Nạp thành công",
RECHARGE_SUCCESS2 = [[<T C="62,34,8" S="22" P="0">Hiện là </T><I Z="0.6">ui/common/commom_icon_v_gz.png</I><A IMG = "ui/common_num/common_num_vip.png" Z ="0.6" W = "22" H = "40" CHAR = "0">%d</A><T C="62,34,8" S="22" P="0">, nhận %d</T><I Z="0.7">ui/common/common_icon_zuanshi.png</I>]],
RECHARGE_SUCCESS3 = [[<T C="62,34,8" S="22" P="0">Nạp thêm </T><T C="158,0,0" S="22" P="0">%d</T><I Z="0.7">ui/common/common_icon_zuanshi.png</I><T C="62,34,8" S="22" P="0">, sẽ thành </T><I Z="0.6">ui/common/commom_icon_v_gz.png</I><A IMG = "ui/common_num/common_num_vip.png" Z ="0.6" W = "22" H = "40" CHAR = "0">%d</A>]],
ANNOUNCE  = "Thông báo",
CAN_GET = "Có thể nhận",
WILL_BECOME = "Sẽ trở thành ",
FUNDINFO1 = [[<T C="255,255,255" S="20" P="0">Nạp thẻ nhận </T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0"> có thể mua!</T>]],
FUNDINFO2 = [[<T C="255,255,255" S="20" P="0">Nạp </T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0">, tích lũy nhận hoàn trả </T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0">!</T>]],
FUNDINFO3 = [[<T C="255,255,255" S="20" P="0">Đã mua quỹ trưởng thành, đã nhận </T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0">!</T>]],
FUNDINFO4 = "Cấp VIP không đủ, không thể mua quỹ, tăng cấp VIP?",
FUNDINFO5 = "Nhận hoàn trả thành công",
FUNDINFO6 = "Quỹ trưởng thành",
LIMETED_LOGIN_REWARD = "Thưởng đăng nhập %s-%s",
FORBIT_RECORD_VOICE = "Đã cấm quyền ghi âm!",
FIRST_RECHARGE_ACTIVITY = "Thưởng nạp lần đầu",
MONTHCARDINFO1 = "Chưa vào Công Hội, không thể dùng đạo cụ này",
MONTHCARDINFO2 = "Hãy chọn mục tiêu dùng",
ACTIVITY_TOTAL_RECHARGE = "Tích lũy nạp",
TOO_FULL = "No quá",
EACH_DAY_TO_GET = "Ăn thịt nướng mỗi ngày, tăng nhiều Thể Lực!",
WORD_E = "Ồ!!",
TASTE_NEXT_TIME = "Hãy chờ bữa sau!",
LIMITE_TIME_GIFT = "Quà ưu đãi hạn giờ: ",
CAN_BUY_GIFT = "Quà có thể mua",
BATTLE_PASS = "Điều kiện vượt: ",
BATTLE_SINGLE_PASS= "Vượt phó bản",
BD_ACCOUNT_OK = "Khóa tài khoản thành công",
WOLRD_BOSS_INSPIRE_FULL = "Sát thương cổ vũ đã tăng tối đa",
WOLRD_BOSS_DEAD_NOT_INSPIRE = "BOSS đã bị diệt, không thể cổ vũ",
CONSUME = "Tốn: ",
RECHARGE_TODAY = "Hôm nay nạp ",
GET_BIG_GIFT = ", sẽ nhận quà lớn!",
CAN_GET_ONCE = "Trong hoạt động chỉ được nhận 1 lần",
RECHARGE_BETWEEN = "Nạp ",
ANY_MONEY = "mức bất kỳ",
CAN_RECEIVE = "nhận: ",
RANK_DAY_DATA = [[<T C="255,228,108" S="24" P="0">Chiến tích: </T><T C="255,89,74" S="24" P="0">%d</T><T C="255,237,192" S="24" P="0"> trận </T><T C="255,89,74" S="24" P="0">thắng %d</T><T C="255,237,192" S="24" P="0"></T><T C="255,228,108" S="24" P="0">Liên thắng: </T><T C="255,89,74" S="24" P="0">%d</T>]],
RANK_BOX_DESC1 = "Tham chiến %d lần",
RANK_BOX_DESC2 = "Chiến thắng %d lần",
ITEM_NOT_ENOUGH = "Tim không đủ, không thể mua đạo cụ này?",
VIP_NOT_GET = "Chưa nhận được",
NO_ANNOUNCE_MES = "Không có thông báo",
RECHARGE_DESC =
[[
<T C="229,105,22" S="22">Quy tắc VIP</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> EXP trưởng thành VIP bằng số Kim Cương thực tế đã nạp, không bao gồm Kim Cương được tặng thêm và Kim Cương nhận được từ hệ thống.</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Mua vật phẩm trong trang quà không tăng EXP VIP</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Thẻ Tháng, Thẻ Tháng Công Hội gồm số Kim Cương nhận 1 lần và số Kim Cương nhận liên tục</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Thẻ Tháng mua ngay là 420 Kim Cương, tức sau khi mua nhận ngay 420 Kim Cương</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Thẻ Tháng Công Hội mua ngay là 200 Kim Cương, tức sau khi mua nhận ngay 200 Kim Cương</T><BR></BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> Số Kim Cương được nhận liên tục khi mua Thẻ Tháng và Thẻ Tháng Công Hội sẽ được nhận qua hình thức thưởng nhiệm vụ ngày (Lv10 mở). Sau khi mua, trong 30 ngày liên tiếp, mỗi ngày đăng nhập được nhận 100 Kim Cương.</T><BR></BR>
<T C="229,105,22" S="22" P="0">7.</T><T C="127,70,26" S="22" P="0"> Thẻ Tháng khác Thẻ Tháng Công Hội ở chỗ Thẻ Tháng chỉ dùng cho bản thân, Thẻ Tháng Công Hội có thể tặng cho các hội viên khác, tức là tặng Kim Cương thưởng đăng nhập 30 ngày</T><BR>10</BR>
<T C="229,105,22" S="22">Huy Chương VIP</T><BR></BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Mỗi kích hoạt Huy Chương của một giai đoạn, sẽ nhận được Điểm Huy Chương cố định. Điểm Huy Chương dùng để tăng cấp Huy Chương. Hoàn thành tiến độ mỗi cấp, sẽ nhận được thưởng tương ứng, tăng mức lực chiến nhất định.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Huy Chương VIP chủ đề "Vua Danh Hiệu", không thống kê tất cả danh hiệu, mà chỉ tính các danh hiệu chỉ định</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Sau khi cập nhật, nhận được cùng một danh hiệu lần nữa, sẽ được tính như mới</T><BR>10</BR>
<T C="229,105,22" S="22">BXH Xạ Thủ VIP</T><BR></BR>
<T C="127,70,26" S="20" P="0"> Xếp hạng theo mức điểm VIP nhận được khi Nạp Kim Cương/Tốn Kim Cương/Mua Quà, Top 200 có thể nhận thưởng hấp dẫn</T><BR></BR>
]],
SKILL_COOL_TIME = "Kỹ năng đang chờ",
RANK_FIGHT_WIN = [[<T C="158,0,0" S="22" P="0">%d</T><T C="62,34,8" S="22" P="0"> trận </T><T C="158,0,0" S="22" P="0">thắng %d</T><T C="62,34,8" S="22" P="0"></T>]],
RANK_WIN_STREAK = "(%d liên thắng)",
SELECT_VIP_GIFT_ATT = "Hưởng đặc quyền VIP sẽ có thưởng phong phú! Nạp ngay?",
SETTING_TALK = "Chat voice: ",
RANK_SEGMENT = "Hạng bậc",
RANK_WEEK_REWARD = "Thưởng bậc tuần",
RANK_SEGMENT_REWARD = "Thưởng bậc",
RANK_REWARD_SEGMENT = "Thưởng tăng bậc",
RANK_WEEK_RANK = "BXH Đấu Hạng",
RANK_REWARD_WEEK = "Thưởng hạng tuần",
RANK_REWARD_GET = [[<T C="127,70,26" S="22" P="0"></T><T C="255,89,72" S="22" P="0"></T><T C="127,70,26" S="22" P="0">Kết thúc mùa giải, sẽ thưởng theo hạng hiện tại</T>]],
RANK_LOG = "Nhật ký chiến tích",
RANK_LOG_FAIL = "%s trước, bạn bị đánh bại bởi ",
RANK_LOG_WIN = "%s trước, bạn đánh bại người chơi ",
RANK_LOG_LV_UP = "Tăng cấp hạng, hiện tại là  ",
RANK_LOG_LV_Down = "Giảm cấp hạng, hiện tại là ",
RANK_LOG_DESC1 = [[<T C="255,236,193" S="22" P="0">Đánh bại %s</T><T C="254,167,48" S="22" P="0">, điểm bậc </T><T C="0,255,78" S="22" P="0"> %s</T>]],
RANK_KING_DESC1 = [[<T C="99,255,95" S="22" P="0">%s</T><T C="255,237,192" S="22" P="0">Giành hạng 1 trong Đấu Hạng!</T>]],
RANK_KING_DESC2 = "Chiến tích mùa giải: ",
RANK_KING_DESC3 = "Thắng: ",
RANK_KING_DESC4 = "Liên thắng hiện tại: ",
RANK_KING_WORSHIP_CNT = [[<T C="255,228,108" S="22" P="0">Được thích </T><T C="0,255,78" S="22" P="0"> %d </T><T C="255,228,108" S="22" P="0"> lần</T>]],
RANK_KING_GOLD_CNT = [[<T C="255,228,108" S="22" P="0">Có thể nhận </T><I Z="0.6">ui/common/common_icon_jinbi.png</I><T C="0,255,78" S="22" P="0"> %d</T>]],
ACCOUNT_BD_DESC = "Chưa khóa tài khoản, nếu đổi thiết bị sẽ mất hết dữ liệu",
ACCOUNT_BD = "Khóa tài khoản",
ACCOUNT_BD1 = "Khóa",
PET_HIGH_QULITY = "Pet tốt không thể chọn nhanh",
TOTAL_COUNT = "Tích lũy",
RANK_KING_WORSHIP = [[<T C="255,236,193" S="22" P="0">%s </T><T C="254,167,48" S="22" P="0">%s trước đã thích</T>]],
RANK_OPEN_DESC1 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">(%s đến %s)</T><T C="255,89,74" S="22" P="0" SC="79,60,48" SE="1" SS="4"> %s-%s</T><T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Mở</T>]],
RANK_END_DESC1 = "Chiến tích hôm nay",
RANK_END_DESC2 = "Số lần liên thắng",
RANK_END_DESC3 = "Điểm nhận",
RANK_END_DESC4 = "Điểm nhận: ",
WEEK_FIGHT_RESULT = "Chiến tích mùa giải:",
PVP_RANK_DESC =
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Điểm Dũng Sĩ khi tích lũy đến mức quy định sẽ tự dùng để nâng cấp 1 bậc</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Điểm Dũng Sĩ nhận từ tăng thành tựu, tăng MVP, tăng liên thắng trong Đấu Hạng</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Khi bị giáng cấp, sẽ ưu tiên khấu trừ Điểm Dũng Sĩ thay cho hiệu quả giáng cấp lần này (Điểm không đủ sẽ bị giáng cấp)</T><BR>20</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Khi đạt đến bậc Vinh Dự, nếu liên tục 7 ngày không tham gia Đấu Hạng, sẽ tự động giảm 1 cấp bậc.</T><BR>20</BR>
<T C="229,105,22" S="22">Hướng dẫn</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Mùa giải sẽ bắt đầu vào ngày đầu mỗi tháng, kết thúc vào ngày cuối mỗi tháng</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Khi Mùa Giải mới mở, cấp bậc sẽ giảm một mức nhất định</T><BR>20</BR>
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Kết thúc mùa giải, người hạng 1 sẽ nhận thưởng đặc biệt và thiết lập tượng thành chủ</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Mỗi mùa giải đạt cấp bậc chỉ định sẽ nhận thưởng (Tạo mới mỗi mùa giải)</T><BR>10</BR>
]],
WORD_FIGHTING = "Đấu",
WORD_WIN = "Thắng",
CURRENT_WIN_STREAK = "Liên thắng: ",
NICKNAME = "Tên: ",
COMEFROM = "Giới tính: ",
SHARE_SUCCESS = "Chia sẻ thành công",
DRESSSTATE = "Trạng thái trang bị",
LEVELSTATE1 = "Sơ",
LEVELSTATE2 = "Thường",
LEVELSTATE3 = "Cao",
LEVELSTATE4 = "Hiếm",
ANDROID_RECORD_ERROR = "Microphone bị cấm dùng, hãy thiết lập quyền sử dụng",
IOS_RECORD_ERROR = "[Thiết lập-Riêng-Microphone], cho phép dùng microphone",
NO_GET_WORDS = "Chưa nhận",
TIPSWORD1 = "Hành động: ",
TIPSWORD2 = "Chờ khởi tạo: ",
TIPSWORD3 = "Hiệu quả: ",
TIPSWORD4 = "VIP%d mở đạo cụ này",
TIPSWORD5 = "Lv%d mở đạo cụ này",
TIPSWORD6 = "Mở khóa",
DIVORCE_WEDDING_NOT_ENOUGH = "Xin ly hôn cần tốn %d Kim Cương, Kim Cương không đủ! Tăng thêm?",
ONEKEY_GIFTBACK = "Tặng lại",
ACCOUNT_NOT_MAIL = "Tài khoản hiện chưa khóa với hộp thư!",
FRIENDS_FULL_ATT = "Bạn bè đã đạt tối đa, tăng cấp VIP để tăng thêm?",
RECEIVE_TIMES_OUT = "Lượt nhận hôm nay đã hết, tăng cấp VIP để tăng thêm?",
ONEKEYSTRENGTEN = "Cường hóa nhanh",
PASSWORD_FORGET = "Quên mật khẩu",
PASSWORD_CHANGE = "Sửa mật khẩu: ",
PASSWORD_NEW = "Mật khẩu mới: ",
CHALLENGE_ELITE_ERROR = "Vượt ải thường hiện tại sẽ mở",
SETTING_BIND_MAIL = "Khóa hộp thư: ",
SETTING_BIND_MAIL1 = "Khóa hộp thư",
PASSWORD_FORGET_ACCOUNT = "Thông tin: ",
PASSWORD_MAIL_ERROR = "Hộp thư không đúng", 
SETTING_BINDED_MAIL = "Tài khoản đã khóa với hộp thư!",
SETTING_INPUT_PASS = "Mật khẩu: ",
SETTING_INPUT_MAIL = "Hộp thư: ",
SETTING_MAIL_DESC = "Hãy nhập hộp thư dùng khi cần tìm lại mật khẩu",
SETTING_MAIL_BIND_SUCCESS = "Khóa hộp thư thành công",
SETTING_MAIL_BIND_FAIL = "Mật khẩu sai, khóa hộp thư thất bại",
SINGLE_RESERT_TIP = "Dùng %s Kim Cương để tạo mới? (Đã tạo mới %s/%s lần)",
SINGLE_RESERT_TIP2 = "VIP%s được tạo mới nhiều lần hơn, nạp?",
TODAY_RESERT_NOT_ENOUGH = "Số lần tạo mới hôm nay đã dùng hết",
HOMEOWNER_TIP = "Bạn đã trở thành chủ phòng",
STRENGTHEN1 = "Tăng sao trang bị phải tốn Đá Tăng Sao, không thể tháo",
STRENGTHEN2 = "Cường hóa tối đa không thể quá cấp nhân vật",
STRENGTHEN3 = "Tăng cấp nhân vật mới được tiếp tục cường hóa",
STRENGTHEN4 = "Đã đạt cấp tối đa, không cần cường hóa nữa",
STRENGTHEN5 = "Cường hóa đã đạt giới hạn cấp nhân vật",
MAIL_INFO = "Thông tin hộp thư: ",
MAIL_ACCOUNT = "Hãy nhập hộp thư khóa chung với tài khoản",
SETTING_BIND_MAIL_AGAIN = "Hộp thư khóa lại: ",
UPGRADE_LEVEL_UNREACHED = "Lv%d mở",
MOUNT_LIST = "Danh sách thú cưỡi",
MOUNT_CAN_LOCK = "Có thể nhận",
MOUNT_CANNOT_LOCK = "Chưa nhận",
PASS_COMMON_SECTION_TIP = "Vượt ải dạng thường chương này sẽ mở",
MOUNTS_SUCCESS1 = "Tỉ lệ thành công: ",
MOUNTS_LV_LIMIT = "Cấp thú cưỡi đã đạt giới hạn cấp nhân vật",
MOUNTS_LV_LIMIT = "Tăng cấp nhân vật mới được tiếp tục tăng cấp thú cưỡi",
MOUNTS_LV_MAX = "Tăng cấp thú cưỡi đã đạt tối đa! Giỏi lắm!",
MOUNTS_STAR_MAX = "Tiến giới đạt tối đa",
MOUNT_LEVEL1 = "Cấp: ",
MOUNT_Star1 = "Tiến giới:",
MOUNT_PILL_CNT = "(Có %d)",
MOUNT_BUY_DESC1 = "Dùng %s %d nhận thú cưỡi này",
GET_ACHIE_POINTS = "Thành tựu: ",
LEFT_ACHIE_POINTS = "Thành tựu còn: ",
TOTAL_PROGRESS = "Tổng tiến độ: ",
BADGE_FULL_LEVEL = "Huy Hiệu đạt cấp tối đa.",
BADGE_UPGRADE_FAILED = "Điểm thành tựu không đủ, hãy hoàn thành thêm thành tựu.",
RANK_DAY_DATA = "Chiến tích: ",
RANK_WIN_AGAIN = "Liên thắng: ",
RANK_SCORE_RANK = "Hạng: ",
PETADVANCESHOW = "Xem trước",
PETSHOW = "Xem trước",
PETSKILL3 = "Kỹ năng thiên phú",
PETSKILLDESC1 = "Tiến hóa Pet +1 mở",
PETSKILLDESC2 = "Tiến hóa Pet +3 mở",
PETSKILLDESC3 = "Kỹ năng thiên phú nhận ngẫu nhiên",
PETSHOWNAME1 = [[<T C="6,180,0" S="20" P="0">+2</T> <T C="127,70,26" S="20" P="0">(Đang lớn)</T>]],
PETSHOWNAME2 = [[<T C="6,180,0" S="20" P="0">+4</T> <T C="127,70,26" S="20" P="0">(Trưởng thành)</T>]],
PETSHOWNAME3 = [[<T C="6,180,0" S="20" P="0">+6</T> <T C="127,70,26" S="20" P="0">(Hoàn chỉnh)</T>]],
RECORD_NET_ERROR = "Voice đang bận, hãy thử lại sau~",
PETNOREBIRTH = "Pet từng tăng cấp hoặc tiến hóa mới được trùng sinh.",
PETNOSKILL1 = "Tiến hóa Pet được mở khóa kỹ năng",
PETNOSKILL2 = "Hiện tại chưa mở khóa kỹ năng nào",
PETCONFIRMREBIRTH = "Trùng sinh Pet sẽ mất cấp và hiệu quả tiến hóa, tiếp tục?",
PETSHOWTIP1 = 
--<T C="255,236,193" S="22" P="0">Kích hoạt kỹ năng Pet</T>
--<T C="99,255,96" S="22" P="0">1</T>
[[
<T C="229,105,22" S="20" P="0">Tăng bậc</T>
<T C="6,180,0" S="20" P="0">+1</T>
<T C="127,70,26" S="20" P="0">: </T>
<T C="127,70,26" S="20" P="0">Mở khóa Pet</T>
<T C="6,180,0" S="20" P="0">Kỹ năng 1</T>
<T C="127,70,26" S="20" P="0">, tăng </T>
<T C="6,180,0" S="20" P="0">7%</T>
<T C="127,70,26" S="20" P="0">Tất cả thuộc tính</T>


]],
PETSHOWTIP2 = 
[[
<T C="229,105,22" S="20" P="0">Tiến hóa </T>
<T C="6,180,0" S="20" P="0">+2</T>
<T C="127,70,26" S="20" P="0">:</T>
<T C="127,70,26" S="20" P="0"> Ngoại hình thay đổi</T>
<T C="127,70,26" S="20" P="0">, tăng</T>
<T C="6,180,0" S="20" P="0">13%</T>
<T C="127,70,26" S="20" P="0"> tất cả thuộc tính</T>
]],
--<T C="255,236,193" S="22" P="0">Kích hoạt kỹ năng </T>
--<T C="99,255,96" S="22" P="0">2</T>
PETSHOWTIP3 = 
[[
<T C="229,105,22" S="20" P="0">Tiến hóa </T>
<T C="6,180,0" S="20" P="0">+3</T>
<T C="127,70,26" S="20" P="0">:</T>
<T C="127,70,26" S="20" P="0"> Mở khóa </T>
<T C="6,180,0" S="20" P="0">kỹ năng 2</T>
<T C="127,70,26" S="20" P="0">, tăng</T>
<T C="6,180,0" S="20" P="0">25%</T>
<T C="127,70,26" S="20" P="0"> tất cả thuộc tính</T>
]],
PETSHOWTIP4 = 
[[
<T C="229,105,22" S="20" P="0">Tiến hóa </T>
<T C="6,180,0" S="20" P="0">+4</T>
<T C="127,70,26" S="20" P="0">:</T>
<T C="127,70,26" S="20" P="0"> Ngoại hình thay đổi</T>
<T C="127,70,26" S="20" P="0">, tăng</T>
<T C="6,180,0" S="20" P="0">50%</T>
<T C="127,70,26" S="20" P="0"> tất cả thuộc tính</T>
]],
PETSHOWTIP5 = 
[[
<T C="229,105,22" S="20" P="0">Tiến hóa </T>
<T C="6,180,0" S="20" P="0">+5</T>
<T C="127,70,26" S="20" P="0">:</T>
<T C="127,70,26" S="20" P="0"> Mở khóa </T>
<T C="6,180,0" S="20" P="0">kỹ năng 3</T>
<T C="127,70,26" S="20" P="0">, tăng</T>
<T C="6,180,0" S="20" P="0">75%</T>
<T C="127,70,26" S="20" P="0"> tất cả thuộc tính</T>
]],
PETSHOWTIP6 = 
[[
<T C="229,105,22" S="20" P="0">Tiến hóa </T>
<T C="6,180,0" S="20" P="0">+6</T>
<T C="127,70,26" S="20" P="0">:</T>
<T C="127,70,26" S="20" P="0"> Mở khóa </T>
<T C="6,180,0" S="20" P="0">kỹ năng 4</T>
<T C="127,70,26" S="20" P="0">, tăng</T>
<T C="6,180,0" S="20" P="0">100%</T>
<T C="127,70,26" S="20" P="0"> tất cả thuộc tính</T>
]],
RANK_NO_WIN = "(Bắn tỉa liên thắng)",
ISEXPPET = "Pet EXP không thể thao tác",
GET_WORSHIP_GOLD = "Nhận Vàng thành công",
PVPRANK_LIST_DESC1 = "BXH sẽ tạo mới theo giờ",
PVPRANK_LIST_DESC2 = "Thi đấu kết thúc sẽ thưởng theo hạng",
PVPRANK_LIST_DESC3 = "Thưởng tăng bậc (Gửi qua thư, chỉ được nhận 1 lần)",
PVPRANK_LIST_DESC4 = "Dữ liệu BXH mùa trước",
NO_CHANGE = "Không đổi",
CAN_GET_DESIGNATION = "Nhận danh hiệu",
HAVED_SEND = "Đã gửi",
WHERE_GET_COPY = "Vượt Vùng Mạo Hiểm có thể nhận nhiều Tinh Hồn Thám Hiểm, vượt phó bản nhóm có thể nhận Tinh Hồn Vinh Dự",
STAR_SOUL_HAVED_ACTIVE = "Đã mở",
STAR_SOUL_NOT_ACTIVE = "Khóa",
STAR_PROPERTY_ADD = "Tăng Tinh Hồn",
TOTAL_FIGHTING_ADD = "Tổng Tinh Hồn tăng",
STARSOUL_ACTIVITY_SUCCESS = "Kích hoạt thành công",
STARSOUL_LOCKED_TIPS = "Kích hoạt tất cả Tinh Hồn của hệ sao trước đó mới có thể xem hệ kế.",
CHECKOTHER1 = "Thú Cưỡi",
CHECKOTHER2 = "Tinh Hồn",
CHECKOTHER3 = "Thẻ Bài",
CHECKOTHER4 = "Ký Tên",
CHECKOTHER5 = "Tăng Tinh Hồn",
CHECKOTHER6 = "Huân Chương",
CHECKOTHER7 = "Trang Bị",
CHECKOTHER8 = "Thời Trang",
KNOW = "Đã xem",
REMOVE_STONE = "Tháo",
TIPS1 = "Nguyên liệu Đá Thánh không đủ, tiếp tục tăng sao sẽ giảm cấp.",
WOLRD_BOSS_LEFT_NOT_INSPIRE = "BOSS đã chạy trốn, không thể cổ vũ",
NOT_ATTENTION_THISTIME = "Không nhắc lại",
TIPS2 = "Điểm may mắn đạt tối đa sẽ tăng sao thành công, điểm may mắn mỗi ngày đều xóa hết.",
SETTING_SERVERS_STATE_FULL1 = "Đủ người",
SETTING_SERVERS_LIST = "Danh sách máy chủ",
CLICK_OPEN = "Nhấp mở",
SEARCH_STAR_SOUL = "Tinh Hồn Thám Hiểm",
HONOUR_STAR_SOUL = "Tinh Hồn Vinh Dự",
NEED_STAR = "Cần",
TEACH_104 = "Nhấn giữ màn hình để di chuyển, di chuyển theo hướng chỉ định",
TEACH_105 = "Hiện năng lượng Nộ Khí",
TEACH_106 = "Nhấn màn hình tiếp tục",
TEACH_107 = "Nhấn giữ vào nhân vật, kéo về hướng ngược lại với mục tiêu, sau đó nhắm bắn (Lên xuống chỉnh góc ngắm)",
TEACH_108 = "Đạn Liên Tục: 1 lần bắn 2 viên đạn, liên tục tấn công địch",
TEACH_109 = "Đạn Lan Tỏa: Phân tán bắn 2 viên đạn vào kẻ địch, tấn công phạm vi",
TEACH_110 = "Đạn Uy Lực: Tấn công cực mạnh, gây sát thương lớn lên kẻ địch",
TEACH_111 = "Đạn Truy Đuổi: Truy đuổi và tấn công địch trong phạm vi nhất định (Trước Lv7 tự động có hiệu quả này)",
TEACH_112 = "POWER: Gây sát thương nặng lên kẻ địch (Vũ khí khác nhau, có POW và kỹ năng khác nhau)",
TEACH_113 = "Nhấn tay vào nhân vật và kéo theo hướng ngược hướng bay sẽ khiến nhân vật bay đến đó",
TEACH_114 = "Trượt ra ngoài để thu nhỏ, kéo vào trong để phóng to",
TEACH_115 = "Thanh hành động đầy sẽ đến lượt tấn công",
TEACH_116 = "Hiện thời gian lượt còn lại và ký hiệu hướng gió",
TEACH_117 = "Nút thiết lập nhạc trong game và hủy lượt hiện tại.",
TEACH_118 = "Chat sẽ hiện ở khu vực này",
TEACH_119 = "Khu thao tác đạo cụ chiến đấu và kỹ năng",
TEACH_120 = "Vào Cửa Hàng",
TEACH_121 = "Chọn thời trang",
TEACH_122 = "Mặc thử",
TEACH_123 = "Mua",
TEACH_124 = "Đồng ý mua",
TEACH_125 = "Mở thanh hướng dẫn",
TEACH_126 = "Mở túi",
TEACH_127 = "Nhấn thời trang",
TEACH_128 = "Chọn mặc",
TEACH_129 = "Nhấn quay về",
TEACH_130 = "Mở nhiệm vụ",
TEACH_131 = "Cấp 1-7 là thời gian bảo vệ người mới, tấn công sẽ kèm hiệu quả Truy Đuổi.",
TEACH_132 = "Mở thanh hướng dẫn",
TEACH_133 = "Nhấn rèn",
TEACH_134 = "Chọn tẩy luyện",
TEACH_135 = "Chọn vũ khí",
TEACH_136 = "Tẩy luyện",
TEACH_137 = "Chọn kế thừa",
TEACH_138 = "Chọn vũ khí",
TEACH_139 = "Chọn vũ khí cần kế thừa",
TEACH_140 = "Chọn vũ khí được kế thừa",
TEACH_141 = "Chọn vũ khí",
TEACH_142 = "Nhấp đồng ý",
TEACH_143 = "Nhấn nút kế thừa",
TEACH_144 = "Dùng Đạn Liên Tục tấn công liên tục",
TEACH_145 = "Dùng Đạn Lan Tỏa tấn công phân tán",
TEACH_146 = "Dùng Đạn Uy Lực tấn công kết liễu",
TEACH_147 = "Tại biên màn hình có thể phóng to khu vực thao tác",
TEACH_148 = "Từ biên Dấu Chân bắt đầu kéo dây sẽ có phạm vi thao tác rộng hơn",
TEACH_149 = "Rương May Mắn",
TEACH_150 = "Gọi thử",
TEACH_151 = "Đổi trang bị mới",
TEACH_152 = "Gọi cấp cao hơn",
TEACH_153 = "Mở thanh hướng dẫn",
TEACH_154 = "Tiếp tục làm nhiệm vụ",
TEACH_155 = "Nhận thưởng nhiệm vụ trước",
TEACH_156 = "Trải nghiệm uy lực trang bị mới",
TEACH_157 = "Mở giao diện Cầu Phúc",
TEACH_158 = "Hãy cầu phúc!",
TEACH_159 = "Nhặt Cầu Phúc này",
TEACH_160 = "Đến Túi để đeo Cầu Phúc",
TEACH_161 = "Chọn Cầu Phúc nhận được",
TEACH_162 = "Hãy trang bị vào",
TEACH_163 = "Xem thêm",
TEACH_164 = "Mở giao diện Tu Luyện",
TEACH_165 = "Tu luyện 1 lần nào",
TEACH_166 = "Vào hệ thống Thẻ Bài",
TEACH_167 = "Mở Bộ Thẻ",
TEACH_168 = "Chọn Bộ Thẻ",
TEACH_169 = "Nhấp để mở",
WORLD_BOSS_NO_OPEN = "Chưa đến giờ để khiêu chiến BOSS TG.",
STAR_PROPERTY_ADD = "Tăng",
VIPTIP1 = "Nạp VIP",
VIPTIP2 = "Đặc quyền",
LUCKVALUE = "Điểm may mắn",
HAVE = "Đã có",
RANK_KING_DESC5 = "Chiến tích: ",
RANK_KING_DESC6 = "Thuộc tính tăng: ",
TIPS3 = [[<T C="138,122,106" S="20" P="0">Chưa tham gia Thi Đấu</T>]],
TIPS4 = [[<T C="138,122,106" S="20" P="0">Chưa tham gia Đấu Hạng</T>]],
RANK_KING_DESC7 = "Chức: ",
TIPS5 = [[<T C="138,122,106" S="20" P="0">Chưa vào Công Hội</T>]],
TIPS6 = "Vật Tổ Công Hội ", 
RANK_KING_DESC8 = "Bạn đời: ",
RANK_KING_DESC9 = "Tên sư phụ: ",
RANK_KING_DESC10 = "Tên đệ tử: ",
RANK_KING_DESC11 = [[Sư đức Lv%d]],
RANK_KING_DESC12 = [[BUFF sư đồ]],
TIPS7 = [[<T C="138,122,106" S="20" P="0">Độc thân</T>]], 
TIPS8 = [[<T C="138,122,106" S="20" P="0">Chưa bái sư</T>]], 
TIPS9 = [[<T C="138,122,106" S="20" P="0">Chưa nhận đệ tử</T>]],
SERVER_FULL_PERSON = "Máy chủ đủ người",
MOREDRESS = "Cửa Hàng",
BATCHBUY = "Gia hạn nhanh",
TOUCH_TO_INPUT = "Nhập ID người chơi",
WEDDING_HOLD_TIME = "Chọn thời gian muốn tổ chức hôn lễ",
WEDDING_HOLE_TIPS = "Nếu thời gian chọn đã bắt đầu hoặc kết thúc sẽ cử hành vào ngày mai cùng giờ",
EDIT_MAIL = "Viết thư",
ACTIVITY_REWARD_ATT = "Đăng nhập vào các ngày chỉ định sẽ nhận thưởng",
GOTO_RECHARGE = "Nạp",
FIGHTING_TO = "Lực chiến đạt",
CLICK_CLOSE = "Đóng",
SPACE1 = "Trang cá nhân",
NOT_RECORD_VOICE = "Vuốt ngón tay hủy gửi",
EQUIPMENG_SKILL_LIST = "Đạo cụ",
SOPHISTIC = "Tẩy luyện",
SOPHISTIC_LOCK_ATT = "(Khóa kỹ năng khi tẩy luyện để không bị tẩy luyện)",
SOPHISTIC_PUT_WEAPON = "Hãy thiết lập vũ khí cần tẩy luyện trước",
SOPHISTIC_STONE_NOT_ENOUGH = "Đá Tẩy Luyện không đủ, đồng ý mua?",
SOPHISTIC_LOCK_ASK = "Bạn có kỹ năng cao cấp chưa khóa, tiếp tục tẩy luyện không?",
SOPHISTIC_COST = [[<T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >Tốn: </T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(Có %d)  </T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(Có %d)</T>]],
SETTING_TITLE = "Thiết lập",
ACTIVATION = "Kích hoạt",
SPACE2 = "Lịch sử chọc",
SPACE3 = "Lịch sử nhận hoa",
GET_ACCESS = "Cách nhận",
EXP_PETDESC = "Có thể tăng EXP cho Pet đã tăng cấp (Không thể xuất chiến, tăng cấp, tiến hóa)",
WORD_LOCK = "Khóa",
SHOP_NAME_AND_LEVEL1 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4" >Lv%d </T><T C="255,255,255" S="22" P="0" SC="79,60,48" SE="1" SS="4">%s</T>]],
PROPOSE_TIPS2 = "Chúng ta mãi bên nhau nhé?",
SKILL_UPGRADE_FULL = "Đã đạt cấp cao nhất",
SOPHISTIC_LOCK_NOT_ENOUGH = "Khóa kỹ năng không đủ, mua đạo cụ không?",
SPACE4 = " phần",
ACTIVE_SKILL_TIPS = "Không đủ vật phẩm kích hoạt kỹ năng đạo cụ ",
SPACE5 = "Gần đây",
SPACE6 = "Tổng lượng khách",
SPACE7 = "Khách hôm nay",
SPACE8 = "Người",
SPACE9 = "Nổi Tiếng",
SPACE10 = "Quà đã tặng",
SPACE11 = "Số lần nhận hoa",
SPACE12 = "Hấp Dẫn",
SERVER_PLAYER_FULL = "Số người đăng nhập máy chủ đã đạt tối đa",
VERSION_LOW = "Có nội dung cập nhật mới, hãy đăng nhập lại để cập nhật!",
NETWORK_CONNECTION_FAILURE = "Đã offline, hãy đăng nhập lại!",
SPACE13 = "Nhận quà",
SPACE14 = "Chọc",
SPACE15 = [[Tặng bạn %d Hoa Hồng]],
SPACE16 = [[Chọc thành công, nhưng không nhận được quà o~|>_<|~o]],
SPACE17 = [[Hôm nay đã chọc đối phương]],
SPACE18 = [[Đã tặng %d Hoa Hồng cho đối phương, Thể Lực +%d]],
SPACE19 = [[Số lần tặng hoa hôm nay quá nhiều!]],
SPACE20 = "Để lại lời nhắn",
SPACE21 = "Hãy nhập tin nhắn",
SPACE22 = "Xem hình",
SPACE23 = "Máy ảnh",
SPACE24 = "Upload",
SPACE25 = [[Tặng Hoa Hồng]],
SPACE26 = [[Hoa Hồng]],
SPACE27 = [[Hấp Dẫn]],
SPACE28 = [[Thể lực bản thân]],
SPACE29 = [[Nhận Quà Zone.~]],
SPACE30 = [[Năm]],
SPACE31 = [[Tháng]],
SPACE32 = [[Ngày]],
SETTING_CHANGE_SERVER_CONFIRM = "Đổi máy chủ không?",
MOUNTS_LEVEL_GET5 = "Thi Đấu đạt Lv%s nhận",
MOUNTS_LEVEL_GET6 = "Tình cảm đạt Lv%d nhận",
MOUNTS_LEVEL_GET7 = "Công Hội đạt Lv%d nhận",
MOUNTS_LEVEL_GET8 = "Xếp hạng đạt Lv%d nhận",
COMMUNITYINFO70 = "Tăng cấp Vật Tổ",
COMMUNITYINFO71 = "Tăng cấp",
COMMUNITYINFO72 = "Tăng cấp Tiệm Công Hội",
SHOP_BUY_SUCCESS = "Mua thành công",
SHOP_BUY_FAIL = "Mua thất bại",
SPACE33 = [[Đã tặng hoa rồi]],
TIME_NOT_UP = "Chưa đến giờ",
MOUNT_SPEED = "Tốc độ: ",
MOUNT_LUCKY = "May mắn: ",
HURDLES_NOT_OPEN = "Chưa vượt ải này",
ATH_GOAL_RESET_TIME = [[<T C="79,60,48" S="22" P="0">Mỗi ngày </T><T C="158,0,0" S="22" P="0">24:00</T><T C="79,60,48" S="22" P="0"> tạo mới</T>]],
ATH_GOAL = "Mục tiêu Đấu Điểm mỗi ngày",
COMMUNITYINFO73 = [[(Tiệm Lv%d có thể mua)]],
COMMUNITYINFO74 = [[Nhật ký]],
COMMUNITYINFO75 = [[Quản lý]],
COMMUNITYINFO76 = [[Góp]],
COMMUNITYINFO77 = [[Nhật ký góp]],
COMMUNITYINFO78 = [[Nhật ký thao tác]],
COMMUNITYINFO79 = [[Góp]],
COMMUNITYINFO80 = [[Cấp Vật Tổ: ]],
COMMUNITYINFO81 = [[Tăng Vật Tổ]],
COMMUNITYINFO82 = [[Lễ bái tốn]],
COMMUNITYINFO83 = [[Lễ bái Vật Tổ]],
COMMUNITYINFO84 = [[Cấp Trường: ]],
COMMUNITYINFO85 = [[Học kỹ năng]],
COMMUNITYINFO86 = [[Tên Công Hội]],
COMMUNITYINFO87 = [[Chiến tích]],
COMMUNITYINFO88 = [[Hạng chiến tích]],
COMMUNITYINFO89 = [[Chiến tích Công Hội]],
COMMUNITYINFO90 = [[Chiến tích cá nhân]],
COMMUNITYINFO91 = [[Thưởng Công Hội]],
COMMUNITYINFO92 = [[Thưởng cá nhân]],
COMMUNITYINFO93 = [[Cấp Tiệm: ]],
COMMUNITYINFO94 = [[Miễn phí tạo mới: ]],
COMMUNITYINFO95 = [[Tự tạo mới: ]],
DOWN_TO_LOAD_MORE = "Kéo xuống tải thêm",
SPACE34 = [[Nam]],
SPACE35 = [[Nữ]],
SPACE36 = [[Bảo mật]],
PETUP = "Tăng cấp Pet",
CAN_EQUIPPED_PROPS = "Đạo cụ có thể trang bị",
STAR_NOT_ENOUGH1 = "Sao Thám Hiểm không đủ, đến Vùng Mạo Hiểm nhận sao?",
STAR_NOT_ENOUGH2 = "Sao Vinh Dự không đủ, đến Phó bản nhóm nhận sao?",
ATH_CNT_NOT_ENOUGH = "Số lần không đủ",
ATH_REWARD_SEND1 = [[<T C="127,70,26" S="20" P="0">Mỗi CN lúc </T><T C="255,105,22" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0"> căn cứ điểm hiện tại phát thưởng</T>]],
ATH_DESC_1 = "Hạng Đấu Điểm-Tuần",
ATH_DESC_2 = "Thưởng Hạng Đấu Điểm",
ATH_DESC_3 = "Nhật ký",
ATH_DESC_4 = "Nhật ký Hạng Đấu Điểm",
ATH_DESC_5 = [[<T C="127,70,26" S="20" P="0">Dữ liệu hạng Đấu Điếm tuần trước, tạo mới lúc </T><T C="255,105,22" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0"> CN hằng tuần</T>]],
SUGGESTCLICK = "Thiết lập",
ATH_DESC_6 = "Không",
ATH_DESC_7 = "Đấu %d thắng %d\n(Thắng: %d%%)",
ATH_DESC_8 = [[<T C="127,70,26" S="20" P="0">Mỗi CN lúc </T><T C="255,105,22" S="20" P="0"> 24:00</T><T C="127,70,26" S="20" P="0"> tạo mới</T>]],
ATH_DESC_9 = "Hạng",
ATH_DESC_10 = "Thưởng",
BAG2 = "Tăng thuộc tính",
SEND_MAIL_SUCCESS = "Gửi thư thành công",
DEL_MAIL_SUCCESS = "Xóa thư thành công",
SELECT_MARRYGIFT_ITEM = "Hãy chọn đạo cụ cầu hôn",
ILLEGAL_CHARACTER = "Chứa ký tự không hợp lệ",
INTRODUCTION1 = "Giới thiệu",
MAIL_ALL = "Chọn hết",
EAT_SOME_SWEETS = "Thể Lực không đủ, cần thêm %s không?",
USED_TODAY_ACTIVITY = "Thể Lực không đủ, hãy tăng cấp VIP hoặc mua Bánh Donut bổ sung thể lực",
USE_THINGS = "Dùng vật phẩm",
ROOM1 = "Phòng",
INFO = "Thông tin",
REWARD_DESC = "Xem thưởng: ",
BEWORSHIP_TIMES = [[<T C = "255,236,193" S = "20">Được thích</T><T C = "99,255,95" S = "20">%d</T><T C = "255,236,193" S = "20"> lần</T>]],
MOUNT_GET_COST1 = [[<T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%d</T><I P="1" Z="0.45">%s</I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">Có thể nhận</T>]],
MOUNT_GET_COST2 = [[<I P="1" Z="0.45">%s</I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">x%d có thể nhận</T>]],
GOLD1 = "Vàng",
CARD_COUNT = "%s không đủ, có tăng cấp VIP để nhận không?",
LOGIN_TIPS_ACCOUNT1 = "6-16 ký tự",
LOGIN_TIPS_ACCOUNT2 = "Dùng email, ký tự, chữ số, gạch dưới",
HALL_GET_RAEARD = "Đấu thêm %d trận có thể nhận thưởng",
HALL_GET_RAEARD1 = "Thắng thêm %d trận có thể nhận thưởng",
PASSWORD_CHANGE1 = "Sửa mật khẩu",
SETTING_ADVISE_MAIL1 = "Góp ý",
HALL_MATCH_1 = "Đấu Điểm",
HALL_MATCH_2 = "Đấu Tập",
HALL_WAIT = "Đợi",
HALL_01 = "Có mục tiêu Thi Đấu chưa xong",
WNDPLAYERINFO5 = "Túi",
SPACE37 = [[Đang nhận]],
MATCHES_TIMEOUT = "Hiện tại số người quá ít",
MATCHES_TIMEOUT2 = "Hiện tại số người quá ít",
CANCEL_READY_ERROR = "Sắp chơi ngay, không thể hủy",
COMMUNITYINFO96 = "Sửa chức thành công",
COMMUNITYINFO97 = "Trục xuất thành công",
COMMUNITYINFO98 = "Đã nộp nội dung tuyên ngôn Công Hội mới, đang chờ duyệt.",
COMMUNITYINFO99 = "Thư Công Hội đã được gửi, vui lòng chờ duyệt.",
COMMUNITYINFO100 = "Thiết lập Công Hội thành công",
COMMUNITYINFO101 = "Góp cho Công Hội thành công",
COMMUNITYINFO102 = "Bái thành công",
Entries = " cái",
Expand = " Tờ",
REWARD_HAVED_GET = "Đã nhận thưởng!",
SELLGET = "Bán nhận:",
SIXIN = "Thư riêng",
SENDMAIL = "Gửi thư",
PET_MAJOR = "Thư Viện Triệu Hồi",
BATTLE_LEFT_HP = "% sinh lực còn: ",
BATTLE_ATT_TIME = " lượt: ",
SHOP_DRESS_FULL = "Đã có Set mặc thử này",
FIRST_SOPHISTIC_ATT = "Sau khi tẩy luyện, kỹ năng trước sẽ bị thay thế bằng kỹ năng mới, tiếp tục?",
FIRST_LOCK_ATT = "(Nhấp kỹ năng để khóa sẽ không bị thay thế)",
SPACE38 = [[Tặng Hoa]],
SPACE39 = [[Xem nhân vật]],
SPACE40 = [[Xác nhận xóa tin nhắn này]],
SPACE41 = [[Xóa tin nhắn thành công]],
SPACE42 = [[Tối đa thiết lập 100 quà, không thể thêm nữa~]],
SPACE43 = [[Bạn cần thiết lập thêm bảo nhiêu ô quà?]],
COMMUNITYINFO103 = "Hôm nay đã góp rồi",
LOGIN_QUEUE = "Xếp hàng đăng nhập",
LOGIN_QUEUE1 = [[<T C="128,54,13" S="22" P="0">Máy chủ [%s] đã đủ người</T>]],
LOGIN_QUEUE2 = [[<T C="105,65,46" S="24" P="0">Hiện đang xếp </T><T C="1,72,4" S="24" P="0"> hạng %s</T>]],
LOGIN_QUEUE3 = [[<T C="105,65,46" S="22" P="0">Thời gian chờ dự kiến </T><T C="158,0,0" S="22" P="0"> %s...</T>]],
LOGIN_QUEUE4 = "Hủy xếp hàng thành công",
LOGIN_QUEUE5 = "Hủy xếp hàng thất bại",
LOGIN_QUEUE6 = "Nhận danh sách xếp hàng thất bại",
LOGIN_EXIT_QUEUE = "Thoát xếp hàng",
SUG_FIGHT1 = [[<T C="127,70,26" S="22" P="0">Lực Chiến đội đề cử: </T><T C="158,0,0" S="22" P="0"> %d</T>]],
SUG_FIGHT2 = [[<T C="127,70,26" S="22" P="0">Lực Chiến đội đề cử: </T><T C="0,72,3" S="22" P="0"> %d</T>]],
SPACE44 = [[Khung ảnh hiện tại đang khóa, đạt VIP Lv%d sẽ mở]],
RECHARGE_DESC1 = "(PS: Đến nhiệm vụ ngày nhận hoàn trả thẻ tháng)",
RECHARGE_DESC2 = "(PS: Mau vào túi dùng thẻ tặng thành viên Công Hội)",
ABOUT2 = "Giới thiệu game: ",
SPACE45 = [[Xóa hình thành công]],
SPACE46 = [[Dung lượng không đủ, không thể chụp hình]],
SPACE47 = [[Upload ghi âm thành công]],
SPACE48 = [[Upload ghi âm thất bại]],
SPACE49 = [[Xóa ghi âm thành công]],
SPACE50 = [[Chụp thành công, hệ thống duyệt xong mọi người sẽ thấy hình của bạn.]],
SPACE51 = [[Chụp thất bại]],
SPACE52 = [[Xóa hình này không?]],
SPACE53 = [[Đồng ý xóa ghi âm?]],
SPACE54 = [[Chọn ngày sinh, hệ thống sẽ tự chuyển thành tuổi và cung]],
SPACE55 = [[Tuổi: ]],
SPACE56 = [[Cung: ]],
SPACE57 = [[Thiết lập tin cá nhân]],
SPACE58 = [[Tên: ]],
SPACE59 = [[Hiệu: ]],
SPACE60 = [[Cự ly: ]],
SPACE61 = [[Voice: ]],
SPACE62 = [[Bạn đời: ]],
SPACE63 = [[Chưa upload]],
SPACE64 = [[Nhắn tin]],
SPACE65 = [[Thông tin]],
SPACE66 = [[Tin nhắn]],
SPACE67 = [[Album ảnh]],
SPACE68 = [[Những người vào có thể nhận được quà của bạn]],
SPACE69 = [[Thiết lập ô quà]],
SPACE70 = [[Tặng Hoa]],
SPACE71 = [[Còn lại: ]],
SPACE72 = [[Voice giới thiệu: ]],
SPACE73 = [[Upload]],
SPACE74 = [[Hình upload cần được duyệt mới có hiệu lực]],
SPACE75 = [[Chọn lại]],
SPACE76 = [[Đồng ý Upload]],
SPACE77 = [[Upload]],
SPACE78 = [[Mạng quá chậm, upload thất bại]],
SPACE79 = [[Bạch Dương]],
SPACE80 = [[Kim Ngưu]],
SPACE81 = [[Song Tử]],
SPACE82 = [[Cự Giải]],
SPACE83 = [[Sư Tử]],
SPACE84 = [[Xử Nữ]],
SPACE85 = [[Thiên Bình]],
SPACE86 = [[Thiên Hạt]],
SPACE87 = [[Xạ Thủ]],
SPACE88 = [[Ma Kết]],
SPACE89 = [[Thủy Bình]],
SPACE90 = [[Song Ngư]],
SPACE91 = [[Tuổi]],
SPACE92 = [[Cách thức sau]],
BAGTIP2 = "Đã đính hôn",
MARRY_TIPS = "Chúng ta đang chìm đắm trong hạnh phúc!",
SPACE93 = [[Công khai thông tin cá nhân]],
SPACE94 = [[Bạn bè mới thấy avatar bản thân]],
SPACE95 = [[Bạn bè mới nhắn vào trang cá nhân]],
CLOSE_VIP = "Tạm chưa mở nạp",
BAGTIP3 = "Danh sách thu hồi",
BAGTIP4 = "Danh sách thu hồi đã đầy",
PVP_RANK_1 = "Cấp bậc",
PVP_RANK_2 = "Hướng dẫn: ",
PVP_RANK_3 = "Hạng hiện tại: ",
PVP_RANK_4 = "%d liên thắng",
SEND_PROPOSAL_LETTER9 = "Thân mật %d mới được cầu hôn",
DEVOUR_GET = "Nhận EXP: ",
DEVOUR_CHOOSE = "Chọn gộp",
SURE_CHOOSE = "Xác nhận",
DEVOUR_WORDS = "Gộp",
SURE_DEVOUR = "Đồng ý",
WAIT_FOR_DEVOUR = "Chúc phúc chờ gộp",
BLESS_CALL = "Gọi",
BLESS_ONCE = "Cầu phúc 1 lần",
BLESS_QUICK = "Cầu phúc nhanh",
DEVOUR_ALL = "Gộp nhanh",
SELL_ALL = "Bán nhanh",
PICK_ALL = "Nhặt nhanh",
BLESS_BAG = "Túi Cầu Phúc",
BLESS_SHOP = "Tiệm Cầu Phúc",
GOTO_BLESS = "Cầu phúc",
BLESS_FIGHTING = "Lực chiến: ",
BLESS_BAG_FULL1 = "Túi đã đầy, tháo thất bại",
DEVOUR_MOST = "Mỗi lần chỉ gộp 8 chúc phúc",
BLESS_BAG_FULL2 = "Túi Chúc Phúc không đủ chỗ",
BLESS_BAG_FULL3 = "Túi Chúc Phúc đã đầy",
DEVOUR_ATT = "Chúc phúc %s sẽ gộp chúc phúc khác, tiếp tục?",
BLESS_LEVEL_ATT = "Cấp chúc phúc không thể vượt cấp nhân vật",
BLESS_FAILED_BACK = "Cầu phúc thất bại, trả lại %d Vàng",
BLESS_HOUSE_FULL = "Túi đã đầy, sắp xếp rồi quay lại sau",
BLESSEDMEN_LEVEL_ATT = "Thầy Cầu Phúc đã đạt Lv%d, tiếp tục gọi Thầy Cầu Phúc?",
PVP_RANK_5 = "Điểm: ",
PVP_RANK_6 = "Thưởng Đấu Hạng-Ngày",
PVP_RANK_7 = "Chiến tích hôm nay: %d trận %d thắng",
PVP_RANK_8 = "Thưởng Đấu Hạng-Mùa",
PVP_RANK_9 = "Thưởng Hạng Mùa",
PVP_RANK_10 = "Thưởng Mùa",
PVP_RANK_11 = "Thưởng hạng",
PVP_RANK_12 = "Hạng Mùa",
PVP_RANK_13 = "Nhật ký hạng",
PVP_RANK_14 = "BXH Đấu Hạng-Mùa",
PVP_RANK_15 = "BXH Đấu Hạng-Tất Cả",
PVP_RANK_16 = "Chiến tích mùa giải: %d trận %d thắng",
CLICK_TO_CHANGE = "Nhấp đổi",
MASTERINFO31 = [[Xem trước phúc lợi sư đức Lv%d]],
MASTERINFO32 = [[Chưa có sư phụ]],
MASTERINFO33 = [[Chưa có đệ tử]],
MASTERINFO34 = [[Đã bái sư]],
MASTERINFO35 = [[Chưa bái sư]],
MASTERINFO36 = [[Số đệ tử nhận]],
MASTERINFO37 = [[<T C="158,139,121" S="22" >Đệ tử tốn: </T><I Z="0.7">ui/common/common_icon_huoli.png</I><T C="232,236,193" S="22" >%d</T>]],
MASTERINFO38 = [[<T C="158,139,121" S="22" >Nhận: </T><I Z="0.7">ui/common/common_icon_huoli.png</I><T C="232,236,193" S="22" >%d</T>]],
MASTERINFO39 = [[<T C="255,236,193" S="22" >Số đệ tử nhận:</T><T C="99,255,95" S="22" >%s</T>]],
MASTERINFO40 = [[<T C="236,209,108" S="20">BUFF Sư Môn: </T><T C="255,236,195" S="20">Sinh Lực</T><T C="95,255,99" S="20"> +%s</T><T C="255,236,195" S="20">Tấn Công</T><T C="95,255,99" S="20"> +%s</T><T C="255,236,195" S="20">Phòng Thủ</T><T C="95,255,99" S="20"> +%s</T>]],
MASTERINFO41 = [[<T C="236,209,108" S="20">Số đệ tử tối đa:</T><T C="255,236,195" S="20"> %d người</T>]],
MASTERINFO42 = [[<T C="236,209,108" S="20">Nhận danh hiệu:</T><T C="241,115,30" S="20"> %s</T>]],
MASTERINFO43 = [[<T C="236,209,108" S="20">Thuộc tính tăng: </T><BR></BR><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T>]],
MASTERINFO44 = [[<T C="236,209,108" S="20">BUFF Đệ Tử: </T><BR></BR><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T>]],
TO_YOU = [[<T C="229,105,22" S="20">%s</T><T C="127,70,26" S="20" P="1"> đã gửi bạn </T>]],
YOU_TO = [[<T C="127,70,26" S="20">Bạn gửi cho </T><T C="229,105,22" S="20">%s</T>]],
VIGOR_ADD_FRIENDLINESS = [[<T C="105,65,46" S="20" P="1"></T><T C="229,105,22" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> điểm Thể Lực, tăng </T><T C="229,105,22" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> điểm Thân Mật.</T>]],
GIFT_ADD_FRIENDLINESS = [[<T C="105,65,46" S="20" P="1"> phần quà, tăng</T><T C="229,105,22" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> điểm Thân Mật</T>]],
ADD_FRIENDLINESS = [[<T C="127,70,26" S="20" P="1">Thân mật </T><T C="5,180,0" S="20" P="1">+%d</T>]],
WITH_YOU = [[<T C="127,70,26" S="20">%s </T><T C="105,65,46" S="20" P="1"> và bạn </T>]],
FIGHT_TOGETHER_FRIENDLINESS = [[<T C="105,65,46" S="20" P="1">đã cùng hoàn thành chiến đấu, tăng</T><T C="229,105,22" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> điểm Thân Mật.</T>]],
FRIENDLINESS = "Thân mật: ",
MY_SPACE = "Trang cá nhân",
GIVE_GIFT = "Tặng quà",
ADD_FRIENDLINESS = [[<T C="105,65,46" S="24" P="1">Tăng</T><T C="158,0,0" S="24" P="1"> %d</T><T C="105,65,46" S="24" P="1"> thân mật</T>]],
EMPTY_INFO = "Không có thông tin",
FRIEND_GIFT_NOT_ENOUGH = "%s không đủ, có mua quà này không?",
GIVE_GIFT_SUCCESS = "Tặng quà thành công, tăng %d thân mật.",
GIVE_VIGOR_SUCCESS = "Tặng Thể Lực thành công, tăng %d thân mật.",
GET_VIGOR_OK = "Đã nhận %d Thể Lực",
MASTERINFO45 = "Đã xin nhận đệ tử",
MASTERINFO46 = "Xin nhận đệ tử thành công",
MASTERINFO47 = [[%d giờ nữa mới được nhận đệ tử]],
MASTERINFO48 = [[Đối phương %d giờ nữa mới có thể bái sư]],
MASTERINFO49 = [[Đối phương đã có sư phụ]],
MASTERINFO50 = [[Đã xin bái sư]],
MASTERINFO51 = [[Xin bái sư thành công]],
MASTERINFO52 = [[%d giờ nữa mới có thể bái sư]],
MASTERINFO53 = [[Đối phương %d giờ nữa mới có thể nhận đệ tử]],
MASTERINFO54 = [[Đệ tử đối phương đã đạt tối đa]],
MASTERINFO55 = [[Thao tác thành công]],
MASTERINFO56 = [[Đối phương đã có sư phụ]],
MASTERINFO57 = [[Đệ tử đối phương đã đạt tối đa]],
MASTERINFO58 = [[Đã hủy quan hệ sư đồ]],
MASTERINFO59 = [[<T C="151,64,19" S="20">Đồng ý hủy quan hệ sư đồ với %s? </T><BR>22</BR><T C="134,113,92" S="20">Đối phương rời mạng trên </T><T C="158,0,0" S="20">72 </T><T C="134,113,92" S="20">giờ, hủy quan hệ không bị trừng phạt, đồng ý hủy không</T> ]],
SPACE96 = "Đang chiến đấu không thể vào trang cá nhân",
CLICK_ME_TOTRY = "Nhấn vào xem thử",
BLESS_LEVEL_MAX = "Cấp chúc phúc đạt tối đa, không thể gộp nữa",
BLESS_PICK = "Nhặt",
BLESS_CHOOSE_NIL = "Hãy chọn chúc phúc muốn gộp",
DEVOUR_GET_EXP = [[<T C="127,70,26" S="22" P="1">EXP có thể nhận: </T><T C="5,180,0" S="22" P="1">%d</T>]],
BLESS_EQUIP_OPEN_ATT = [[<T C="255,239,193" S="22" P="1" SC="79,60,48" SE="1" SS="4">Lv%d</T><BR></BR><T C="255,239,193" S="22" P="1" SC="79,60,48" SE="1" SS="4"> mở</T>]],
NO_BLESS_TO_DEVOUR = "Không có chúc phúc có thể gộp",
ENOUGH_TO_DEVOUR = "Chúc phúc đã đạt tối đa, không thể chọn nữa",
PLAYER_MOVING = "Đang đi...",
NO_USE_EQUIP_RECT = "Không đủ ô trang bị",
WEDDING_PRIVILEGE = "Đặc quyền hôn lễ",
GET_DRESS = "Nhận thời trang",
WEDDING_TYPE_1_TIP =
[[
<T C="255,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Nhận Lễ Phục Hôn Lễ Xa Hoa</T><BR></BR>
<T C="255,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ phát Lì Xì chờ 80 giây</T><BR></BR>
<T C="255,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ phát Kẹo Hỉ chờ 80 giây</T><BR></BR>
<T C="255,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ bắn Pháo chờ 80 giây</T><BR></BR>
<T C="255,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ tặng chúc phúc chờ 80 giây, mỗi lần bản thân được +15 EXP, tân lang tân nương +3 tình cảm</T><BR></BR>
<T C="255,105,22" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> Sau khi kết hôn, mỗi ngày vợ chồng tặng quà cho nhau 15 lần sẽ tăng tình cảm</T><BR></BR>
]],
WEDDING_TYPE_2_TIP =
[[
<T C="255,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Nhận Lễ Phục Hôn Lễ Hào Hoa</T><BR></BR>
<T C="255,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ phát Lì Xì chờ 100 giây</T><BR></BR>
<T C="255,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ phát Kẹo Hỉ chờ 100 giây</T><BR></BR>
<T C="255,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ bắn Pháo chờ 100 giây</T><BR></BR>
<T C="255,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ tặng chúc phúc chờ 100 giây, mỗi lần bản thân được +10 EXP, tân lang tân nương +2 tình cảm</T><BR></BR>
<T C="255,105,22" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> Sau khi kết hôn, mỗi ngày vợ chồng tặng quà cho nhau 10 lần sẽ tăng tình cảm</T><BR></BR>
]],
WEDDING_TYPE_3_TIP =
[[
<T C="255,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Nhận Lễ Phục Áo Hôn Lễ Lãng Mạn</T><BR></BR>
<T C="255,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ phát Lì Xì chờ 120 giây</T><BR></BR>
<T C="255,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ phát Kẹo Hỉ chờ 120 giây</T><BR></BR>
<T C="255,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ bắn Pháo chờ 120 giây</T><BR></BR>
<T C="255,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0"> Nơi hôn lễ tặng chúc phúc chờ 120 giây, mỗi lần bản thân được +5 EXP, tân lang tân nương +1 tình cảm</T><BR></BR>
<T C="255,105,22" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> Sau khi kết hôn, mỗi ngày vợ chồng tặng quà cho nhau 5 lần sẽ tăng tình cảm</T><BR></BR>
]],
PVP_RANK_17 = "Thưởng ngày",
PVP_RANK_18 = "Thưởng Mùa",
PVP_RANK_19 = "Hướng dẫn",
BLESS_HOUSE_NIL = "Không có chúc phúc có thể dùng",
ORDER_HUSBAND = "Chồng chưa cưới",
ORDER_WIFE = "Vợ chưa cưới",
CANCEL_READY = "Hãy hủy sẵn sàng",
NO_BLESS_TOSELL = "Không có chúc phúc có thể bán",
NO_BLESS_TOPICK = "Không có chúc phúc có thể nhặt",
NO_BLESS_TOP1 = "Hiện đã kết hôn không thể xóa bạn",
NO_BLESS_TOP2 = "Hiện là sư đồ không thể xóa bạn",
HALL_DESC1 = "Đang ghép...",
HALL_DESC2 = 
{
[[Khi gió lớn thì lực tấn công cũng phải lớn để tránh đạn bị thổi bay mất!]],
[[Kỹ năng khác nhau tốn  điểm hành động khác nhau, cần tính kỹ thời cơ ra tay.]],
[[Thi đấu nhiều người đòi hỏi sự phối hợp ăn ý, tinh thần đồng đội làm nên tất cả!]],
[[Dùng đạo cụ và kỹ năng hợp lý, có thể đảo ngược thế cờ! Hãy nhắm đúng thời cơ xuất kích!]],
[[Trong Đấu Hạng, thuộc tính người chơi hoàn toàn giống nhau, không có chênh lệch lực chiến.]],

},
FIGHT_POWER = [[<I Z="1">ui/common/common_icon_zhandouli.png</I><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]],
FIGHT_POWER1 = [[<A IMG = "ui/common_num/zdl_0-9.png" Z="1" W="21" H="26" CHAR="0">%d</A>]],
FIGHT_POWER2 = [[<A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]],
SPACE97 = "Trong phòng không thể xem trang cá nhân",
CALL_TIMES_FINISH = "Số lần gọi hôm nay đã hết",
CALL_UNSUCCESS = "Số lần gọi đã đạt tối đa, tăng cấp VIP sẽ tăng giới hạn!",
CALL_TIMES_COST = "Muốn tốn %d Kim Cương gọi Thầy Cầu Phúc?(Đã gọi %d  lần)", 
CALL_FREE_ATT = "Lần đầu gọi hôm nay sẽ miễn phí, tiếp tục?",
SHOP_BUY_DESC1 = "Đòi",
SHOP_BUY_DESC2 = [[<T C="79,60,48" S="20" P="0">Gồm %d vật phẩm, cần chi trả </T><I Z="0.8">ui/common/common_icon_jinbi.png</I><T C="5,180,0" S="24" P="0">%d</T>]],
SHOP_DESC1 = "Nhắn tin: ",
SHOP_DESC2 = [[<T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4">Mua vật phẩm cần trả </T><I Z="0.8">ui/common/common_icon_zuanshi.png</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4">%d</T>]],
SHOP_DESC3 = "Nhấp soạn tin nhắn",
VIP_DESC3 = "Tặng",
SPACE98 = "Nhấn tải lên",
SPACE99 = "Đang duyệt",
NETTIP1 = "Đường truyền ổn định",
NETTIP2 = "Đường truyền bình thường",
NETTIP3 = "Đường truyền kém, dễ rớt mạng",
FRIEND_ONLINE_ATT = "Nhắc nhở online",
SELECT_ONLINE_HINT= "Hãy chọn bạn cần nhắc nhở online: ",
SELECT_ONLINE_TITLE = "Nhắc nhở online",
SET_SUCCESS = "Thiết lập thành công",
COMMUNITYINFO104 = "Cống hiến hội viên",
COMMUNITYINFO105 = "Tổng",
COMMUNITYINFO106 = "Tuần này",
COMMUNITYINFO107 = "Tuần trước",
COMMUNITYINFO108 = "Cống hiến",
TIP = "[Nhắc nhở]",
FRIENG_ONLINE_TIP = "%s đã online!",
SHOP_DESC4 = "Vật phẩm không thể mua",
SHOP_DESC5 = "Chọn bạn bè",
SHOP_DESC6 = "Yêu cầu gửi quà thành công",
SHOP_DESC7 = "Tặng thành công",
SPACE100 = "Chưa mở",
HURT = "Sát thương: ",
MAIL_SHOP = "Quà Tặng",
MAIL_PAY = "Cần trả",
MAIL_DOPAY = "Chi trả",
BATTLE_LINK_OUT = "Đường truyền đã khôi phục, đang kết nối máy chủ", 
BATTLE_RELINK_OK = "Kết nối lại",
BATTLE_RELINK_FAILURE = "Kết nối lại quá hạn, hãy về Sảnh", 
MUL_ID = "ID: ",
MAIL_HASPAY = "Đã tặng",
STRENGTENTIP3 = "May mắn đầy sẽ thành công, mỗi ngày quay về 0!",
STRENGTENTIP4 = "Trước",
STRENGTENTIP5 = "Sau",
STRENGTENTIP6 = "Chọn trang bị kế thừa",
SPACE101 = "Quà: ",
SHOP_DESC8 = "Vật phẩm này không thể đòi",
NO_INBATTLE_TIP = "Chưa có đội",
PROBABILITY_GET = "Có cơ hội nhận ",
PURPLE = "T.Bị Tím",
TAKE_OUT_AGAIN = "Rút thêm %d lần chắn chắn được",
CHOOSE_BLESSITEM = "Chọn chúc phúc",
CHOOSE_EQUIP_BLESSITEM = "Hãy chọn chúc phúc cần dùng",
NO_BLESSITEM_CAN_EQUIP = "Không có Chúc Phúc có thể trang bị, mau đến Tiệm Cầu Phúc mua đi",
COPY_LIFT = "Tăng lực chiến",
SHOP_DESC9 = "Cấp VIP không đủ để tặng quà, tăng cấp VIP ngay?",
SHOP_DESC10 = "Tặng",
SHOP_DESC11 = "Đòi",
SETTING_SHIELD_ALLINVITE = "Người lạ mời: ",
MAIL_SHOPTIPS = "Thông tin tặng và đòi quà Cửa Hàng",

SHOP_DESC12 = "Bạn bè Lv%d và VIP%d trở lên, thân mật %d",
SHOP_DESC13 = "Thân mật %d trở lên",
GOODS_FULL = "Thư Viện Triệu Hồi",
FRAGMENT_BLESS_SHOW = "Xem trước (Mảnh)",
DIAMONDS_BLESS_SHOW = "Xem trước (Kim Cương)",
HAVED_INVITED = "Đã mời",
BATTLE_OTHER_RELINK_OK = "Đã khôi phục  %s",
SPACE102 = "Nhấp nút phía trên để ghi âm",
SPACE103 = "Vuốt ngón tay lên hủy ghi âm",
REEL_NOT_ENOUGH = "Quyển Đồ Tím không đủ",
TEN_RAFFLE = "Mở x10 nhận",
CALL = "Triệu Hồi",
ISONLINE = "Đang online",
ISOFFLINE = "Chưa online",
WEEK_BEFORE = "%d tuần trước",
MONTH_BEFORE = "%d tháng trước",
YEAR_BEFORE = "%d năm trước",
LASTONLINE = "",
REPLACE_RAFFLE_TIP = "Mở thay thế Kim Cương",
FRAGMENT_NOT_ENOUGH = "Mảnh không đủ",
COMMUNITYINFO109 = "Học kỹ năng thành công",
ALL_SERCER_RANK_NAME = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="127,70,26" S="20" P="0">%s</T>]],
SPACE104 = "Người chơi liên server không thể thực hiện thao tác này",
PET_KAPIAN = "Có thể dùng đập trứng thay Kim Cương ",
PETOPENEGE4 = "Đập Vé", 
ITEM_TYPE1 = "Vũ khí", 
ITEM_TYPE2 = "Set Lục Bảo",
ITEM_TYPE3 = "Set Hoàng Kim",
ITEM_TYPE4 = "Set Lam Bảo",
ITEM_TYPE5 = "Set Rừng Xanh",
ITEM_TYPE6 = "Món Biển Cả",
ITEM_TYPE7 = "Set Sa Mạc",
ITEM_TYPE8 = "Set Sấm Sét ", 
ITEM_TYPE9 = "Set Băng",
ITEM_TYPE10 = "Set Trắng",
ITEM_TYPE11 = "Món Đen",
ITEM_TYPE12 = "Set Ma Ảo",
ITEM_TYPE13 = "Set Bóng Tối",
ITEM_TYPE14 = "Set Tương Lai",
ITEM_TYPE15 = "Set Ác Quỷ",
ITEM_TYPE16 = "Món Chú Hề",
NOT_OPEN_CHAN = "Kênh chưa mở", 
CLICK_CLOSE_CONTAINER = "Nhấp đóng tiếp tục",
COLOR_CHAT_NOT_CROSS_SERVER = "Liên server không hỗ trợ chat voice",
NOT_RECORD_VOICE2 = "Vuốt ngón tay lên hủy gửi, chỉ có hiệu lực ở server này",
GET_BLESS_COIN = "Nhận Xu Cầu Phúc",
CHAT_TEAM = "[Đội]",
ITEM_PRODUCT = "Vật phẩm này tạm không có nguồn ra",
ALL_SERCER_RANK_NAME1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,236,193" S="24" P="0">%s</T>]],
LUCK_DRAW_AGAIN = "Gọi lại 1 lần",
LUCK_DRAW_AGAIN_TIP = "Gọi tiếp",
LUACK_DRAW_AGAIN_TIP2 = " lần nhận",
LUACK_DRAW_AGAIN_TIP3 = "Mở lần này chắc chắn nhận",
MAIL_FULLBAG2 = "Túi đã đầy, sắp xếp rồi quay lại",
BLESSCOIN_NOT_ENOUGH = "Xu Cầu Phúc không đủ",
BATTLE_ACTION_VALUE_NO_ENOUGH = "Điểm hành động không đủ",
WIFFTP1 = "Đang kết nối lại",
WIFFTP2 = "Đợi %s phản hồi",
LOVELOTTERY = "Ước Nguyện Yêu Thương",
MONTHCARD_LEFTTIME = "Thẻ Tháng còn: ",
BUY_NOW = "Mua ngay",

INVITE_FRIENDS = "Code Bạn bè",
INVITE_REWARDS = "Thưởng mời",
COPY_SUCCESS = "Copy thành công",
SUBMIT_OK = "Đã gửi code",
INPUT_INVITE_CODE = "Hãy nhập code",
INVITE_CODE_NOT_EXIST = "Code không tồn tại",
IS_MY_INVITE_CODE = "Không thể nhập code của bản thân",
INVITE_GET_SUCCESS = "Nhận thưởng thành công",
WRITE_INVIDE_CODE = "Nhập code",
MY_INVITE_CODE = "Code: ",
COPY = "Copy",
WRITE_INVITE_CODE_ATT = "Nhập code, sẽ nhận phần thưởng sau",
INVITE_CODE_ATT1 = "Code nhập: ",
INVITE_CODE_ATT2 = "Code bạn bè: ",
INVITE_CODE_ATT3 = "Đã nhận thưởng code: ",
MOUNT_UP_FIVE = "Tăng cấp %d lần",
MOUNT_UP_LOG1 = "Nhật ký",
MOUNT_UP_LOG2 = [[<T C="195,171,148" S="18" P="0">Tăng lần thứ %d, %d->%d, tốn %d Vàng, tỉ lệ thành công %s,</T><T C="99,255,95" S="18" P="0">Thành công</T>]],
MOUNT_UP_LOG3 = [[<T C="195,171,148" S="18" P="0">Tăng lần thứ %d, %d->%d, tốn %d Vàng, tỉ lệ thành công %s,</T><T C="255,89,74" S="18" P="0">Thất bại</T>]],
MOUNT_UP_LOG4 = [[<T C="195,171,148" S="18" P="0">Tăng cấp %d lần, thú cưỡi đã tăng %d Lv, tốn %d Vàng </T>]],
LUACK_DRAW_BOX_UNLOCK_TIP_FRONT = "Rương thưởng chương trước chưa nhận!",
LUACK_DRAW_BOX_UNLOCK_TIP_BEHINE = "Rương thưởng chương sau chưa nhận!",
BATTLE_ACTION_VALUE_NO_ENOUGH_BIG = "Không đủ 8 điểm hành động",
LOOK_VIDEO = "Xem",
TEAM_FIGHT = "Lực chiến đội: ",
FIGHT_VIDEO = "Video",
BEST_VIDEO = "Video vượt ải hay nhất",
BEST_VIDEO_DIF1 = "Dễ",
BEST_VIDEO_DIF2 = "Khó",
BEST_VIDEO_DIF3 = "Địa Ngục",
INVITE_CODE_ATT4 = "Tạm không có bạn code",
LIBRARY_NAME = "Thư Viện",
LEAGUE1 = "Thi Đấu",
LEAGUE2 = "Chiến Đội",
LEAGUE3 = "Vinh Dự",
LEAGUE4 = "Phát Lại",
LEAGUE5 = "Hạng Vòng Loại",
LEAGUE6 = "Tình hình đấu bảng",
LEAGUE7 = "Top 16",
LEAGUE8 = "Quyết đấu Top 8",
LEAGUE9 = "Hướng dẫn",
ATH_DAILY_GOAL = "Mục tiêu ngày",
INVITE_SUBMIT = "Giao",
LEAGUE10 = [[Xạ Thủ Liên Đấu]],
LEAGUE11 = 
[[
<T C="255,227,116" S="22">[Lịch thi đấu]</T><BR></BR>
<T C="255,236,193" S="18">01/09-07/09 Vòng loại</T><BR></BR>
<T C="255,236,193" S="18">08/09-09/09 Báo danh thi đấu</T><BR></BR>
<T C="255,236,193" S="18">10/09-10/09 Đấu Top 32 (Đấu bảng)</T><BR></BR>
<T C="255,236,193" S="18">11/09 Đấu Top 16</T><BR></BR>
<T C="255,236,193" S="18">16/09 Đấu Top 8</T><BR></BR>
<T C="255,236,193" S="18">17/09 Đấu Top 4</T><BR></BR>
<T C="255,236,193" S="18">18/09 Đấu Quán Quân, Đấu Hạng 3</T><BR>30</BR>

<T C="255,227,116" S="22">[Thưởng giải đấu]</T><BR></BR>
<T C="255,236,193" S="18">Quán Quân: Kim Cương *20000,Túi Vàng Lớn  *100, Danh Hiệu Quán Quân Xạ Thủ *1,Quà Thời Trang Đấu Sĩ *1</T><BR></BR>
<T C="255,236,193" S="18">Á Quân: Kim Cương *10000,Túi Vàng Lớn  *80, Danh Hiệu Á Quân Xạ Thủ *1</T><BR></BR>
<T C="255,236,193" S="18">Quý Quân: Kim Cương *5000,Túi Vàng Lớn  *70, Danh Hiệu Qúy Quân Xạ Thủ *1</T><BR></BR>
<T C="255,236,193" S="18">Giải Tư: Đá Sao - Thánh Quang *100,Đá Vô Cực L4  *5, Túi Vàng Lớn *40</T><BR></BR>
<T C="255,236,193" S="18">Top 8 Giải 5-8: Đá Sao - Thánh Quang *50,Đá Vô Cực L4  *4, Túi Vàng Lớn *30</T><BR></BR>
<T C="255,236,193" S="18">Top 16 Giải 9-16: Đá Sao - Thánh Quang *50,Đá Vô Cực L4  *4, Túi Vàng Lớn *30</T><BR></BR>
<T C="255,236,193" S="18">Top 32 Giải 17-32: Đá Sao - Thánh Quang *30,Đá Vô Cực L4 *2,Túi Vàng Lớn *10</T><BR></BR>
<T C="255,236,193" S="18">Thưởng đặc biệt: Hạng Vòng Loại 1-2000 có thể nhận danh hiệu cá nhân [Cao Thủ Độc Hành]</T><BR></BR>

<T C="255,227,116" S="22">[Quy tắc bầu cử biển]</T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18">Phải mất 100 viên kim cương nghi lễ / viên kim cương để tạo ra một đội và tuyển dụng những người chơi giỏi.Trong giai đoạn mở đầu của cuộc bầu cử biển, ba thành viên trong nhóm có thể phù hợp bất cứ lúc nào;</T><BR></BR>
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18">Sau khi kết thúc cuộc thử nghiệm trên biển, bạn có thể đăng ký vào cuộc thi 32-strong sau khi đạt được các điểm được chỉ định Hệ thống cuối cùng sẽ sàng lọc 32 đội có số điểm cao nhất trong cuộc bầu cử trên biển;</T><BR></BR>
<T C="255,236,193" S="20">3.</T><T C="255,236,193" S="18">Nếu các điểm của cuộc bầu cử biển là như nhau, các bảng xếp hạng sẽ được xếp hạng theo các yếu tố toàn diện như thắng và tỷ lệ chiến thắng, và cuối cùng là đội được hệ thống lựa chọn sẽ thắng thế.</T><BR>30</BR>

<T C="255,227,116" S="22">Quy tắc</T><BR></BR>
<T C="255,227,116" S="18">Top 32 Đấu Bảng: </T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Đấu bảng do 32 đội báo danh thành công chia ra 8 nhóm, mỗi nhóm 4 đội.</T><BR></BR>
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18"> Đấu bảng gồm 3 lượt đấu, mỗi đội của mỗi nhóm lần lượt đấu 1 lần với 3 đội khác, cuối cùng chọn ra 2 đội có số lần chiến thắng nhiều nhất để vào vòng trong.</T><BR></BR>
<T C="255,236,193" S="20">3.</T><T C="255,236,193" S="18"> Nếu nhiều đội trong cùng 1 nhóm có số lần thắng giống nhau thì chọn đội có số điểm vòng loại cao hơn để vào vòng trong.</T><BR></BR>
<T C="255,227,116" S="18">Đấu Top 16 :</T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Các đội vào Top 16 chia thành 8 nhóm, dùng cơ chế 3 trận thắng 2, 8 đội thắng sẽ vào vòng trong.</T><BR></BR>
<T C="255,227,116" S="18">Đấu Top 8: </T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Các đội vào Top 8 chia thành 4 nhóm, dùng cơ chế 3 trận thắng 2, 4 đội thắng sẽ vào vòng trong.</T><BR></BR>
<T C="255,227,116" S="18">Chung Kết Top 4: </T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Top 4 chia thành 2 nhóm, dùng cơ chế 3 trận thắng 2, 2 đội thắng sẽ đấu tổng chung kết, 2 đội thua sẽ đấu hạng 2.</T><BR></BR>
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18"> Đấu hạng 3 và đấu tổng chung kết, dùng cơ chế 3 trận thắng 2, đội thắng 2 trận sẽ giành chiến thắng.</T><BR></BR>
<T C="255,227,116" S="18">Tranh Quán Quân và Tranh Hạng 3: </T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Đấu Quán Quân chia thành 2 nhóm, dùng cơ chế 3 trận thắng 2, thắng sẽ là quán quân, thua sẽ là hạng 2.</T><BR></BR>
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18"> Đấu Hạng 3 chia thành 2 nhóm, dùng cơ chế 3 trận thắng 2, phe thắng sẽ giành hạng 3.</T>
<T C="255,236,193" S="20">3.</T><T C="255,236,193" S="18">Tranh Quán Quân và Tranh Hạng 3 sẽ tiến hành cùng lúc, hãy tham gia đúng giờ</T><BR>30</BR>

<T C="255,227,116" S="22">Hướng dẫn: </T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Mỗi lượt đấu cần hoàn thành trong thời gian quy định, vượt quá thời gian sẽ thất bại.</T><BR></BR>
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18"> Trong vòng loại và đấu chính thức, thuộc tính nhân vật sẽ chia đều, chỉ hiệu lực trong Liên Đấu.</T><BR></BR>
<T C="255,236,193" S="20">3.</T><T C="255,236,193" S="18"> Thời gian mỗi trận là 15 phút, vượt quá giờ sẽ dựa vào số người sống sót và sinh lực còn lại để chọn ra bên thắng.</T><BR>30</BR>
<T C="255,236,193" S="20">4.</T><T C="255,236,193" S="18">Trong thời gian diễn ra sự kiện, hoàn toàn bị cấm hành động thay mặt cho trò chơi, và nếu nó được tìm thấy, nó sẽ trực tiếp hủy bỏ các bằng cấp và phần thưởng liên quan.</T><BR>30</BR>
]],
LEAGUE12 = "Lập chiến đội",
VIDEO_FIGHT_ONE = "Đơn Đấu",
VIDEO_FIGHT_TWO = "Song Đấu",
VIDEO_FIGHT_THREE = "Tam Đấu",
VIDEO_FIGHT_MY = "Video",
VIDEO_FIGHT_ONE_LOOK = "Phát lại Đơn Đấu",
VIDEO_FIGHT_TWO_LOOK = "Phát lại Song Đấu",
VIDEO_FIGHT_THREE_LOOK = "Phát lại Tam Đấu",
VIDEO_FIGHT_MY_LOOK = "Phát lại Video",
SINGLE_FIGHT = "Lực chiến cá nhân: ",
LEAGUE13 = 
[[
<T C="255,227,116" S="20" P="0"> Vòng loại:</T><T C="195,171,48" S="20" P="0">2021.12.10 - 2021.12.16</T><BR>10</BR>
<T C="255,227,116" S="20" P="0"> Thời gian tham gia:</T>
<T C="195,171,48" S="20" P="0">08:00-23:59 Điểm chiến thắng </T>
<T C="99,255,95" S="20" P="0">+30</T>
<T C="195,171,48" S="20" P="0"> , điểm thất bại </T>
<T C="99,255,95" S="20" P="0">-10</T>
<T C="195,171,48" S="20" P="0"> 0</T>
]],
LEAGUE14 = 
[[
<T C="158,0,0" S="22" P="0"></T><T C="62,34,8" S="22" P="0"> Đội online: 3</T><BR></BR>
]],
LEAGUE15 = 
[[
<T C="158,0,0" S="22" P="0"></T><T C="127,70,26" S="22" P="0">Đấu bảng</T><BR></BR>
<T C="158,0,0" S="22" P="0"></T><T C="127,70,26" S="22" P="0">(Thứ 7)</T><BR></BR>
<T C="158,0,0" S="22" P="0"></T><T C="127,70,26" S="22" P="0">2016.6.6</T><BR></BR>
]],
LEAGUE16 = 
[[
<T C="79,60,48" S="22" P="0">1. Sau khi báo danh căn cứ điểm chọn ra 32 đội, thông báo sẽ gửi qua Thư</T><BR>13</BR>
<T C="79,60,48" S="22" P="0">2. Nếu trong thời gian Thi Đấu không tham chiến sẽ coi như bỏ cuộc</T><BR>13</BR>
<T C="79,60,48" S="22" P="0">3. Báo danh phải đạt %d điểm</T><BR></BR>
]],
SHARE_GAME = "Chia sẻ trò chơi",
SHARE_FRIEND = "Chia sẻ bạn bè",
SHARE_MOMENTS = "Chia sẻ khoảnh khắc",
LANGUAGE_CHANGE = "Đổi ngôn ngữ: ",
LANGUAGE_CHANGE2 = "Đổi ngôn ngữ",
LANGUAGE_CHANGE3 = "Sau khi đổi sẽ đăng nhập lại",
LEAGUE17 = " trận",
LEAGUE18 = "Vòng loại",
CITY_SCENE_NOT_SUPPORT_CHAT = "Phát ngôn kênh thành chính cần đạt Lv12",
LEAGUE_HONOUR_TITLE = "Quán Quân Liên Đấu mùa %d",
LEAGUE_REPLAY_ITEM1 = "Đang diễn ra",
LEAGUE_REPLAY_ITEM2 = "Đặc sắc",
LEAGUE_REPLAY_ITEM3 = "Quyết đấu",
LEAGUE_REPLAY_ITEM4 = "Cá nhân",
LEAGUE_REPLAY_TEXT1 = "ID chiến đội:",
LEAGUE_REPLAY_TEXT2 = " người xem",
LEAGUE_REPLAY_TEXT3 = " vạn người xem",
LEAGUE_REPLAY_TEXT4 = "Đã xem",
LEAGUE_REWARD_ITEM1 = "Thưởng vòng loại",
LEAGUE_REWARD_ITEM2 = "Thưởng hạng vòng loại",
LEAGUE_REWARD_ITEM3 = [[Xạ Thủ Liên Đấu]],
LEAGUE_REWARD_ITEM4 = "Thưởng tiêu diệt",
LEAGUE_REWARD_TEXT1 = [[<T C="255,227,116" S="22" P="1">Chiến tích hôm nay: </T><T C="255,236,193" S="22" P="1">Đấu %d thắng %d</T>]],
LEAGUE_REWARD_TEXT2 = [[<T C="255,227,116" S="22" P="1">Mỗi ngày </T><T C="255,89,74" S="22" P="1">00:00</T><T C="255,227,116" S="22" P="1"> tạo mới</T>]],
PLAY_AGAIN = "Phát lại",
BATTLE_SURE_REPLAY_EXIT = "Muốn thoát Video trận này?",
YOU_HAVE_NO_COMMUNITY = "Vẫn chưa vào Công Hội",
LEAGUE19 = "Vòng 1",
LEAGUE20 = "Vòng 2",
LEAGUE21 = "Vòng 3",
NO_BLESS_NEED_DEVOUR = "Không có chúc phúc để gộp",
LEAGUE_REWARD_TEXT3 = [[<T C="255,227,116" S="22" P="1">Vòng loại </T><T C="255,89,74" S="22" P="1">%s</T><T C="255,236,193" S="22" P="1">Phát thưởng hạng</T>]],
LEAGUE_REWARD_TEXT4 = [[<T C="255,227,116" S="22" P="1">Hạng đội: </T><T C="255,236,193" S="22" P="1">%s</T>]],
LEAGUE_REWARD_TEXT5 = [[<T C="255,227,116" S="22" P="1">Số diệt: </T><T C="255,236,193" S="22" P="1">%d</T>]],
LEAGUE_REPLAY_TEXT5 = "Không có trận đang đấu",
LEAGUE_REPLAY_TEXT6 = "Không có video đặc sắc",
LEAGUE_LEAVETEAM_TIMES = "Số lần rời đội: %d",
LEAGUE22 = "Thưởng",
ROLESOUND = "Đổi giọng nhân vật",
ROLESOUND2 = "Nhân vật:",
ROLESOUND_1 = "Trang chủ",
ROLESOUND_2 = "Cá tính",
ROLESOUND_3 = "Dễ thương",

LEAGUE_PLAYER_KF1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,255,255" S="22" P="1">%s</T>]],
LEAGUE_PLAYER_1 = [[<T C="255,255,255" S="22" P="0">%s</T>]],
LEAGUE_WAIT_PLAYER = "Đang đợi đối thủ...",
LEAGUE_NO_JOIN = "(Đội chưa vào xem như bỏ cuộc)",
LEAGUE_READY_JOIN = "%d giây sau vào đấu",
LEAGUE23 = "Thiết lập tham chiến",
LEAGUE24 = "Thiết lập ứng viên",
LEAGUE25 = "Mời vào ",
LEAGUE26 = "Mời khỏi Đội",
LEAGUE27 = "Tên chiến đội không thể để trống",
LEAGUE28 = "Tên chiến đội tối đa 5 ký tự",
LEAGUE29 = "Chọn hình chiến đội",
ATH_GOAL_DESC1 = "Tổ đội vợ chồng tham chiến",
ATH_GOAL_DESC2 = "Tổ đội vợ chồng chiến thắng",
ATH_GOAL_DESC3 = "Tổ đội Công Hội tham chiến",
ATH_GOAL_DESC4 = "Tổ đội Công Hội chiến thắng",
ATH_GOAL_DESC5 = "Tổ đội bạn bè tham chiến",
ATH_GOAL_DESC6 = "Tổ đội bạn bè chiến thắng",
ATH_DESC_11 = [[<T C="127,70,26" S="20" P="0">Mỗi ngày </T><T C="158,0,0" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0"> tạo mới</T>]],
COMMUNITYINFO110 = "Nhiệm vụ Công Hội",
COMMUNITYINFO111 = "Quỹ",
COMMUNITYINFO112 = "%d Quỹ trở lên",
COMMUNITYINFO113 = "Quỹ hiện tại: \n%d",
COMMUNITYINFO114 = [[24:00 Chủ Nhật mỗi tuần thống kê cấp Quỹ, phát thưởng qua thư theo chức Công Hội]],
COMMUNITYINFO115 = [[10 tin gần nhất]],
COMMUNITYINFO116 = [[Hôm nay chưa phát nhiệm vụ Công Hội, nhiệm vụ Công Hội có thể tăng nhanh danh vọng Công Hội, hội viên có thể nhận thưởng phong phú]],
COMMUNITYINFO117 = [[Đến phát]],
COMMUNITYINFO118 = [[Khóa không tạo mới]],
COMMUNITYINFO119 = [[Cá nhân]],
COMMUNITYINFO120 = [[Phát nhiệm vụ]],
COMMUNITYINFO121 = [[Đợi phát]],
COMMUNITYINFO122 = [[Phát nhiệm vụ thành công]],
COMMUNITYINFO123 = [[Khóa nhiệm vụ thành công]],
COMMUNITYINFO124 = [[Mở khóa nhiệm vụ thành công]],

BLESS_MEDAL_NOT_ENOUGH = "Huy Chương cầu phúc không đủ",
MARRYSKILL = "Kỹ năng vợ chồng",
WELFARE_COMPETE_TEXT1 = "Vui lòng đợi...",
WELFARE_COMPETE_TEXT2 = "Đang đấu Vòng Loại",
WELFARE_COMPETE_TEXT3 = "Đang đấu Vòng Bảng",
WELFARE_COMPETE_TEXT4 = "Đang đấu Top 16",
WELFARE_COMPETE_TEXT5 = "Đang đấu Top ",
LEAGUE_REWARD_TEXT6 = "Chưa đạt điều kiện",
LEAGUE_REWARD_TEXT7 = "Đã phát",
LEAGUE_REWARD_TEXT8 = "Rời đội sẽ tính lại số tiêu diệt, mùa giải kết thúc sẽ xóa",
LEAGUE_REPLAY_TEXT7 = "Vòng loại",
LEAGUE_REPLAY_TEXT8 = "Đấu bảng",
LEAGUE_REPLAY_TEXT9 = "Top 16",
LEAGUE_REPLAY_TEXT10 = "Top 8",
LEAGUE_REPLAY_TEXT11 = "Bán kết",
LEAGUE_REPLAY_TEXT12 = "Chung kết",
LEAGUE_REPLAY_TEXT13 = "Không có video quyết đấu",
LEAGUE_REPLAY_TEXT14 = "Không có nhật ký phát lại",
SHOP_DESC14 = "Cấp nhân vật chưa đạt Lv%d không thể tặng",
LEAGUE_HONOUR_TEXT1 = "Vẫn chưa tìm được Quán Quân, cố gắng giành danh hiệu nào",
LEAGUE30 = "Lập chiến đội",
LEAGUE31 = "Thiết lập chiến đội",
LEAGUE32 = [[Muốn giải tán đội, giải tán không thể quay lại, tiêu phí không hoàn trả, sau khi giải tán đội viên sẽ rời đội?]],
LEAGUE33 = [[Muốn rời chiến đội %s, đội này hơn 48 giờ chưa thi đấu, thoát không bị phạt, đồng ý thoát?]],
LEAGUE34 = [[Muốn rời chiến đội %s, đội này trong 48 giờ có thi đấu, sau khi thoát trong %d phút không thể vào đội khác, đồng ý thoát?]],
EXPLAIN1 = "Gửi biểu cảm ở trạng thái tàng hình sẽ bị lộ vị trí",
EXPLAIN2 = "Trạng thái cưỡi của thú cưỡi không ảnh hưởng lực chiến thú cưỡi cộng thêm",
COMMUNITYINFO125 = [[Nhiệm vụ đã phát, đếm ngược ]],
COMMUNITYINFO127 = [[Hãy chọn nhiệm vụ]],
LEAGUE35 = [[Chiến đội không tồn tại]],
LEAGUE_REPLAY_TEXT15 = "Xem chiến",
LEAGUE36 = [[Tuyên ngôn quá dài]],
LEAGUE37 = [[Tuyên ngôn chiến đội]],
LEAGUE38 = [[Bị đuổi khỏi chiến đội]],
LEAGUE39 = [[Người chơi rời mạng lâu hơn 48 giờ, mời khỏi đội không bị phạt, đồng ý mời khỏi?]],
LEAGUE40 = [[Người chơi rời mạng ít hơn 48 giờ, mởi khỏi đội sẽ không thể ghép trong %d phút, đồng ý mời khỏi?]],
LEAGUE41 = [[Thi đấu chưa bắt đầu]],
COMMUNITYINFO126 = [[Xác nhận phát 4 nhiệm vụ này?]],
LEAGUE42 = [[Không được chứa ký tự đặc biệt]],
LEAGUE43 = [[Bạn chưa có đội liên đấu]],
LEAGUE44 = [[Chiến đội đã đủ người]],
LEAGUE45 = [[ sau bắt đầu]],
LEAGUE46 = [[Đội %d điểm trở lên mới được báo danh]],
LEAGUE47 = [[Sau khi kết thúc vòng loại mới được báo danh]],
LEAGUE48 = [[Chỉ đội trưởng có thể báo danh]],
LEAGUE49 = [[Báo danh thành công, lấy danh sách tham gia gửi qua Thư làm chuẩn]],
LEAGUE50 = [[Đã báo danh thành công]],
GOTO_ATHLETICS = "Đến thi Đấu",
GOTO_SECRETSCENE = "Đến Bí Cảnh",
LEAGUE51 = [[Trong thời gian Liên Đấu không thể đuổi thành viên]],
LEAGUE52 = [[Trong thời gian Liên Đấu không thể thoát]],
LEAGUE53 = [[Chưa nhận tư cách đấu vòng này]],
LEAGUE54 = [[Chưa đến thời gian thi đấu, không thể chiến đấu]],
LEAGUE55 = [[Số người trong phòng chưa đủ 3 người, không thể khai chiến]],
VOICE_CHAT_STOP = "Bạn chưa bật Voice Chat, hãy bật trong phần thiết lập để nghe Voice nhé.",
LEAGUE56 = [[Đội tối đa 4 người, đừng tham quá nhé]],
LEAGUE57 = [[Thiết lập đội phó]],
LEAGUE58 = [[Thiết lập đội viên]],
LEAGUE59 = [[Hủy chuẩn bị]],
ACTIVITY_WINWORDS = "Trận thắng",
LEAGUE_TEAM_SEND_MSG = "Giao diện này không thể chat đội",
BLESS_RULE =
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Huy Chương cầu phúc nhận qua thưởng mục tiêu Thi Đấu, có thể mua ở Tiệm Thi Đấu</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Cầu phúc tốn Huy Chương cầu phúc nhận chúc phúc, Thầy Cầu Phúc cấp càng cao huy chương cầu phúc tốn càng nhiều</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Trong quá trình cầu phúc có xác suất kích hoạt Thầy Cầu Phúc cấp cao hơn, nếu không sẽ khôi phục Thầy Cầu Phúc ban đầu</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Cầu phúc có xác suất nhận Mảnh Cầu Phúc, Mảnh Cầu Phúc có thể vào Tiệm Cầu Phúc mua Cầu Phúc phẩm chất cao</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Cầu phúc khác nhau tương ứng các thuộc tính khác nhau, đồng thời chỉ được trang bị Cầu Phúc có 1 loại hiệu quả thuộc tính</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> Cầu phúc có thể tăng cấp thông qua gộp cầu phúc khác, cấp càng cao thuộc tính cầu phúc càng cao</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">7.</T><T C="127,70,26" S="22" P="0"> Cầu phúc có phân biệt phẩm chất, phẩm chất càng cao thuộc tính càng tốt, EXP tăng cấp cũng nhiều hơn</T><BR>20</BR>
]],
LEAGUE60 = [[Kéo tạo mới]],
WELFARE_COMPETE_TEXT6 = "Bắt đầu vòng loại",
UNITY = " đến ",
LEAGUE61 = [[Tên không được chứa khoảng trắng]],
WELFARE_COMPETE_TEXT7 = "Bắt đầu vòng bảng",
WELFARE_COMPETE_TEXT8 = "Bắt đầu Top 16",
WELFARE_COMPETE_TEXT9 = "Bắt đầu Top 8 và chung kết",
CHECKOTHER9 = "Cầu Phúc",
CommunityExplain4 =
[[
<T C="229,105,22" S="22">Sảnh Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Căn cứ quản lý Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Góp Công Hội có thể nhận danh vọng Công Hội và cống hiến cá nhân</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Có thể tiến hành điều chỉnh, phê duyệt trong Công Hội</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18"> Có thể tăng cấp Công Hội, tăng cấp sẽ tăng giới hạn hội viên, đồng thời mở kiến trúc Công Hội cấp tương ứng</T><BR></BR>
<T C="229,105,22" S="22">Nhiệm vụ Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Chủ Hội mỗi ngày có thể phát nhiệm vụ Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Tất cả hội viên có thể cùng hoàn thành nhiệm vụ, sau đó nhận thưởng nhiệm vụ</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Mỗi tuần căn cứ theo quỹ Công Hội nhận được qua nhiệm vụ để phát thưởng tương ứng chức vị</T><BR></BR>
<T C="229,105,22" S="22">Vật Tổ Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Nơi lễ bái Vật Tổ Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Hội viên mỗi ngày có thể lễ bái Vật Tổ nhận BUFF</T><BR></BR>
<T C="229,105,22" S="22">Trường Kỹ Năng</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Hội viên có thể dùng cống hiến bản thân học kỹ năng Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Cấp Trường Kỹ Năng càng cao, giới hạn cấp học kỹ năng càng cao</T><BR></BR>
<T C="229,105,22" S="22">Tiệm Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Diệt BOSS phó bản Công Hội nhận vật phẩm</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Diệt BOSS phó bản Công Hội nhận Xu Khiêu Chiến để đổi vật phẩm hiếm</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Cấp tiệm càng cao, ưu đãi khi mua vật phẩm càng cao</T><BR></BR>
<T C="229,105,22" S="22">Thành viên Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Công Hội Lv1, tổng thành viên 100, chủ hội 1, phó hội 2, trưởng lão 10, tinh anh 20</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Công Hội Lv2, tổng thành viên 110, chủ hội 1, phó hội 2, trưởng lão 11, tinh anh 22</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Công Hội Lv3, tổng thành viên 120, chủ hội 1, phó hội 2, trưởng lão 12, tinh anh 24</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Công Hội Lv4, tổng thành viên 130, chủ hội 1, phó hội 2, trưởng lão 13, tinh anh 26</T><BR></BR>
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">Công Hội Lv5, tổng thành viên 140, chủ hội 1, phó hội 2, trưởng lão 14, tinh anh 28</T><BR></BR>
<T C="127,70,26" S="20">6.</T><T C="127,70,26" S="18">Công Hội Lv6, tổng thành viên 150, chủ hội 1, phó hội 2, trưởng lão 15, tinh anh 30</T><BR></BR>
<T C="127,70,26" S="20">7.</T><T C="127,70,26" S="18">Công Hội Lv7, tổng thành viên 160, chủ hội 1, phó hội 2, trưởng lão 16, tinh anh 32</T><BR></BR>
<T C="127,70,26" S="20">8.</T><T C="127,70,26" S="18">Công Hội Lv8, tổng thành viên 180, chủ hội 1, phó hội 2, trưởng lão 18, tinh anh 36</T><BR></BR>
<T C="127,70,26" S="20">9.</T><T C="127,70,26" S="18">Công Hội Lv9, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 20, tinh anh 40</T><BR></BR>
<T C="127,70,26" S="20">10.</T><T C="127,70,26" S="18">Công Hội Lv10, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 22, tinh anh 44</T><BR></BR>
<T C="127,70,26" S="20">11.</T><T C="127,70,26" S="18">Công Hội Lv11, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 24, tinh anh 48</T><BR></BR>
<T C="127,70,26" S="20">12.</T><T C="127,70,26" S="18">Công Hội Lv12, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 26, tinh anh 52</T><BR></BR>
<T C="127,70,26" S="20">13.</T><T C="127,70,26" S="18"> Công Hội Lv13, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 28, tinh anh 56</T><BR></BR>
<T C="127,70,26" S="20">14.</T><T C="127,70,26" S="18"> Công Hội Lv14, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 30, tinh anh 60</T><BR></BR>
<T C="127,70,26" S="20">15.</T><T C="127,70,26" S="18"> Công Hội Lv15, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 32, tinh anh 64</T><BR></BR>
<T C="229,105,22" S="22">Hướng dẫn chức vụ</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Chủ Hội có thể xét duyệt, bổ nhiệm, sửa tuyên ngôn, tăng cấp Công Hội (Bao gồm kiến trúc), gửi thư, thiết lập Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Phó Hội có thể xét duyệt, bổ nhiệm (Thấp hơn chức bản thân), sửa tuyên ngôn, tăng cấp Công Hội (Bao gồm kiến trúc), gửi thư</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Trưởng lão có thể xét duyệt, bổ nhiệm (Thấp hơn chức bản thân), gửi thư</T><BR></BR>
<T C="229,105,22" S="22">Hướng dẫn Thẻ Tháng Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Hội viên có thể tặng nhau Thẻ Tháng Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Sau khi mua Thẻ Tháng Công Hội, phải mở túi, chọn Thẻ Tháng Công Hội và tặng cho hội viên khác, cũng có thể tặng cho bản thân</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Sau khi mua Thẻ Tháng Công Hội, được nhận ngay một phần Kim Cương. Sau khi tặng, người được tặng sẽ được nhận Phúc Lợi Thẻ Tháng từ nhiệm vụ ngày trong 30 ngày liên tục.</T><BR></BR>
<T C="229,105,22" S="22">Hướng dẫn tố cáo</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Chủ Hội Công Hội rời mạng quá 5 ngày, sẽ kích hoạt tố cáo vào 12h đêm</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Tố cáo sẽ duy trì 24 giờ, thành viên có cống hiến Công Hội hôm đó ＞2000 có thể bỏ phiếu</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Nếu hơn 5 thành viên bỏ phiếu, tức tố cáo thành công, hệ thống sẽ chỉ định 1 thành viên Công Hội làm Chủ Hội mới</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Người chức càng cao càng dễ làm Chủ Hội mới nhưng cần cống hiến tuần này ＞0</T><BR></BR>
]],
SPACE105 = [[Tặng thành công, nhận %d Thể Lực]],
SPACE106 = [[Số lần tặng hoa hôm nay đã hết]],
SPACE107 = [[Một ngày chỉ được tặng người ấy 1 lần]],
MARRY_ROOM_FIND = "Không tìm thấy ID hôn lễ này",
EDIT_MARRY_ID = "Nhấp nhập ID hôn lễ",
NO_FIND_MARRY_TIP = "Nhập ID hôn lễ",
LEAGUE62 = "Đấu bảng vòng %d ",
MARRY_ID = "ID hôn lễ:",
WEDDING_TIP_STATS1 = "Hôn lễ chưa bắt đầu",
WEDDING_TIP_STATS2 = "Hôn lễ đã kết thúc",
ARE_YOU_SURE_DISMISS_THIS_PLAYER1 = "Xác nhận trục xuất %s?\n(Hôm nay còn có thể trục xuất %d người)", 
ARE_YOU_SURE_DISMISS_THIS_PLAYER2 = "Số lần trục xuất thành viên đã hết",
STRENGTENTIP7 = "Ghép lên cấp tốn:",
STRENGTENTIP8 = "Lên cấp tốn:",
LEAGUE63 = "Top 16 vòng %d",
LEAGUE64 = "Top 8 vòng %d",
LEAGUE65 = "Bán kết vòng %d",
LEAGUE66 = "Chung kết vòng %d",
LEAGUE67 = "Đối thủ bỏ cuộc trận này, chiến đội chúng ta chiến thắng",
PRACTICE_TITLE = "Tu Luyện",
NEEDMOREPRACTICE = "Điểm Tu Luyện không đủ",
COMMUNITY_COMPETE = "Lịch thi đấu",
COMMUNITY_TARGET = "Mục tiêu",
COMMUNITY_COMPETE_TEXT1 = "Danh sách Công Hội đi tiếp",
COMMUNITY_COMPETE_TEXT2 = "Báo danh",
COMMUNITY_COMPETE_TEXT3 = "Tổng cống hiến tuần trước",
COMMUNITY_COMPETE_TEXT4 = "Trạng thái",
COMMUNITY_COMPETE_TEXT5 = "Chưa báo danh",
COMMUNITY_COMPETE_TEXT6 = "Đã báo danh",
COMMUNITY_COMPETE_TEXT7 = "Báo danh",
COMMUNITY_COMPETE_TEXT8 = "Thứ %d",
COMMUNITY_COMPETE_TEXT9 = "Nhóm",
COMMUNITY_COMPETE_TEXT10 = "Chia nhóm",
COMMUNITY_COMPETE_TEXT11 = [[<T C="195,171,148" S="20" P="1">Hạng </T><T C="99,255,95" S="20" P="1">%d</T><T C="195,171,148" S="20" P="1"></T>]],
COMMUNITY_COMPETE_TEXT12 = "Đấu bảng",
COMMUNITY_COMPETE_TEXT13 = "Vào phòng",
COMMUNITY_COMPETE_TEXT14 = "%d vào %d",
COMMUNITY_COMPETE_TEXT15 = "Tạm chưa có",
COMMUNITY_COMPETE_TEXT16 = "Chưa bắt đầu",
COMMUNITY_COMPETE_TEXT17 = "Tổng chung kết",
COMMUNITY_COMPETE_TEXT18 = "Chung kết",
COMMUNITY_COMPETE_TEXT19 = "Bán kết",
COMMUNITY_COMPETE_TEXT20 = "Thứ 6 bán kết",
MOUNT_ALL_ADD = "Thuộc tính mỗi thú cưỡi đều là cộng dồn, và trạng thái cưỡi không ảnh hưởng đến lực chiến tăng",
STRENGTENTIP9 = "Số lượng Đá không đủ",
RANK_OPEN_DESC2 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">(%s đến %s)</T><T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Mở mùa giải kế</T>]],
PVP_LAST_TIME = "Mùa giải %d (%s-%s)",
CAN_BE_GET_REWARD = " nhận thưởng (24:00 mỗi ngày tạo mới)",
RANK_KING_WORSHIP1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,236,193" S="22" P="0">%s </T><T C="254,167,48" S="22" P="0">%s trước đã Thích</T>]],
RANK_RESULT_KF = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="99,255,95" S="20" P="0" SC="3,111,8" SE="1" SS="4">%s</T>]],
RANK_RESULT_NOKF = [[<T C="99,255,95" S="20" P="0" SC="3,111,8" SE="1" SS="4">%s</T>]],
RANK_FIGHT_PRO = "Thuộc tính Đấu Hạng",
RANK_FIGHT_PRO_DESC = "*Thuộc tính đấu hạng khởi đầu là giống nhau. Kỹ năng và thức tỉnh sẽ giúp mang lại hiệu quả hơn trong đấu hạng. Tổng thuộc tính đấu hạng được tính như sau: Thuộc tính khởi đầu + 1% tổng lực chiến nhân vật.",
GOTO_MARRY = "Đến kết hôn",
MARRY_DISCOUNT = "Trong thời gian hoạt động cử hành hôn lễ, hưởng ưu đãi",
MASTERINFO60 = [[Sư đồ truyền dạy]],
MASTERINFO61 = [[Truyền Dạy]],
MASTERINFO62 = [[<T C="255,236,193" S="18" P="1" SC="229,105,22" SS="4" SE="1">Sư phụ:</T><BR>8</BR><T C="127,70,26" S="18" P="1">Sau khi truyền dạy nhận %d sư đức</T><BR>5</BR><T C="5,180,0" S="18" P="1">(Đệ tử Online càng nhiều, sư đức nhận được càng nhiều, hiện Online %d/%d)</T>]],
MASTERINFO63 = [[<T C="255,236,193" S="18" P="1" SC="229,105,22" SS="4" SE="1">Đệ tử:</T><BR>8</BR><T C="127,70,26" S="18" P="1">Online được nhận </T><I Z="1">ui/common/common_icon_exp.png</I><T C="229,105,22" S="18" P="1">%d</T><BR>5</BR><T C="127,70,26" S="18" P="1">Rời mạng được nhận </T><I Z="1">ui/common/common_icon_exp.png</I><T C="229,105,22" S="18" P="1">%d</T><BR>5</BR><T C="5,180,0" S="18" P="1">(Cấp sư đức càng cao, EXP đệ tử càng nhiều, hiện tại Lv%d)</T>]],
MASTERINFO64 = [[<T C="255,89,74" S="20" P="1">%s</T><T C="79,60,48" S="20" P="1"> có thể truyền dạy</T>]],
POWER2 = "S.Mạnh: ",
AGILITY2 = "H.Giáp: ",
TIZHI2 = "T.Chất: ",
WNDPRATICE_TIPS_TITLE = "Tổng thuộc tính tu luyện tăng: ",
WNDPRATICE_TIPS_TITLE2 = "Lắc được ngôi sao sẽ được tăng EXP",
PRACTICE_VALUEDESC1  = "Sinh Lực sẽ tăng sinh lực của bạn",
PRACTICE_VALUEDESC2  = "Tấn Công sẽ tăng sát thương của bạn",
PRACTICE_VALUEDESC3  = "Phòng Thủ sẽ tăng khả năng đỡ sát thương",
PRACTICE_VALUEDESC4  = "Thể Chất sẽ tăng hiệu quả giàm sát thương",
PRACTICE_VALUEDESC5  = "Sức Mạnh sẽ tăng sát thương gây ra",
PRACTICE_VALUEDESC6  = "Hộ Giáp sẽ giảm sát thương phải chịu",
MASTERINFO65 = [[Hoàn thành]],
SPOUSE_COPY = "Ải Cặp Đôi",
PRACTICE_USE = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >Tiêu phí trong ngày:</T><I Z ="0.45">ui/common/common_icon_hylqhltb.png</I><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >%d</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >  Được nhận: </T><I P="1">ui/common/common_icon_xl.png</I><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >%d</T>]],
PRACTICE_USE2 = [[<T C="255,227,116" S="18" P="1" >Hôm nay tu luyện lần thứ %d:</T><I P="1">ui/common/common_icon_xl.png</I><T C="255,236,193" S="18" P="1" >%s</T>]],
MASTERINFO66 = [[<T C="127,70,26" S="20" P="1">Mục tiêu ngày tạo mới </T><T C="255,89,74" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"> mỗi ngày</T>]],
BAG_FULL = "Túi không đủ chỗ",
LEAGUE68 = [[Thiết lập %s thành đội phó (Quyền mở chiến đấu khi đội trưởng không trong phòng, chỉ được chọn 1 người)]],
LEAGUE69 = [[Hủy chức đội phó của %s)]],
LEAGUE70 = [[ID chiến đội]],
LEAGUE71 = [[Đấu bảng (Bo1): %s]].."\n"..[[Thời gian tham chiến vòng 1: %s]].."\n"..[[Thời gian tham chiến vòng 2: %s]].."\n"..[[Thời gian tham chiến vòng 3: %s]], 
LEAGUE72 = [[Vòng 1/16 (Bo3): %s]].."\n"..[[Thời gian tham chiến trận 1: %s]].."\n"..[[Thời gian tham chiến trận 2: %s]].."\n"..[[Thời gian tham chiến trận 3: %s]], 
LEAGUE73 = [[Vòng 1/8 (Bo3): %s]].."\n"..[[Thời gian tham chiến trận 1: %s]].."\n"..[[Thời gian tham chiến trận 2: %s]].."\n"..[[Thời gian tham chiến trận 3: %s]], 
LEAGUE74 = [[Bán kết (Bo3): %s]].."\n"..[[Thời gian tham chiến trận 1: %s]].."\n"..[[Thời gian tham chiến trận 2: %s]].."\n"..[[Thời gian tham chiến trận 3: %s]], 
LEAGUE75 = [[Chung kết (Bo3): %s]].."\n"..[[Thời gian tham chiến trận 1: %s]].."\n"..[[Thời gian tham chiến trận 2: %s]].."\n"..[[Thời gian tham chiến trận 3: %s]],
LEAGUE76 = [[Lập chiến đội thành công]],
LEAGUE77 = [[ phút sau mới được xin phép]],
LEAGUE78 = [[Xin phép chiến đội thành công]],
LEAGUE79 = [[Đã kiểm duyệt]],
LEAGUE80 = [[Mời khỏi đội thành công]],
LEAGUE81 = [[Vào chiến đội thành công]],
LEAGUE82 = [[Rời khỏi đội thành công]],
LEAGUE83 = [[Mời bạn vào giao diện chiến đội]],
LEAGUE84 = [[ phút sau mới được ghép]],
LEAGUE85 = [[Báo danh Liên Đấu]],
LEAGUE86 = [[Xác nhận báo danh]],
LEAGUE87 = [[Tìm kiếm báo danh]],
LEAGUE88 = [[Điều kiện tìm kiếm]],
LEAGUE89 = [[Tên chiến đội]],
LEAGUE90 = [[Điểm chiến đội]],
LEAGUE91 = [[Tối đa 5 ký tự]],
LEAGUE92 = [[Tuyên ngôn:]],
LEAGUE93 = [[Cần:]],
LEAGUE94 = [[(Tên chiến đội không thể sửa)]],
LEAGUE95 = [[Upload phải qua kiểm duyệt mới được dùng (Kiến nghị kích thước 150*150)]],
LEAGUE96 = [[Đến thi Đấu]],
LEAGUE97 = [[Hạng đội:]],
LEAGUE98 = [[Điểm:]],
LEAGUE99 = [[Duyệt thành viên]],
LEAGUE100 = [[Thành viên:]],
LEAGUE101 = [[Hạng Vòng Loại:]],
LEAGUE102 = [[Chiến tích:]],
LEAGUE103 = [[Tên chiến đội]],
LEAGUE104 = [[ID chiến đội:]],
LEAGUE105 = [[Hướng dẫn lịch thi đấu]],
LEAGUE106 = [[Mời thành viên]],
LEAGUE107 = [[Trạng thái dự bị]],
LEAGUE108 = [[Nhập ID chiến đội]],
LEAGUE109 = [[Hình:]],
LEAGUE110 = [[Chuẩn bị chiến đấu]],
LEAGUE111 = [[Thời gian tham chiến]], 
LEAGUE112 = [[Điểm chiến thắng]], 
LEAGUE113 = [[Điểm thất bại]],
ADVISE_FIGHT = "Lực chiến đội đề cử: ",
COMMUNITY_COMPETE_TEXT21 = 
[[
<T C="127,70,26" S="20" P="0">Quy tắc Công Hội Chiến</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Công Hội Chiến 2 tuần tổ chức 1 lần.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Số lượng Công Hội ≥ Lv2 của máy chủ ≥10 sẽ mở Công Hội Chiến (Kiểm tra lúc 0 giờ Thứ 2 hằng tuần)</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Sau khi mở Công Hội Chiến, tiến hành tranh đoạt tư cách 1 tuần, sau đó theo xếp hạng danh vọng từ cao xuống thấp, Công Hội Top 30 có thể báo danh vào tuần sau.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Tuần thứ 2 công bố xếp hạng (Thứ 2), báo danh (Thứ 3), chọn vào vòng trong và chia nhóm (Thứ 4), lịch thi đấu (Thứ 5-Thứ 7).</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">  Thứ 4 chọn ra Top 16 hạng danh vọng báo danh tuần trước để chia nhóm và công bố.</T><BR></BR>
<T C="229,105,22" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> Công Hội Chiến mỗi Công Hội có thể xuất chiến 3 đội 1 lần, mỗi đội tối đa 3 người. Điều kiện: Cấp ≥ 25, vào Công Hội ≥ 48 giờ.</T><BR></BR>
<T C="229,105,22" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0"> Nếu trong đội chưa thiết lập thành viên sẽ không cần đấu, đối thủ trực tiếp vào vòng trong. Nếu 2 đội đều trống, hệ thống sẽ phân thắng thua. Cơ chế 3 trận thắng 2, nếu 2 đội thắng trở lên sẽ vào vòng trong.</T><BR></BR>
]],
CARD_TEXT1 = "Đã thu thập %d Thẻ Bài",
CARD_TEXT2 = "Bộ Thẻ",
CARD_TEXT3 = "Chưa thu thập %d Thẻ Bài",
CARD_TEXT4 = "Còn lại: %d/%d",
CARD_TEXT5 = [[<T C="255,89,74" S="22" P="1" SC="158,0,0" SS="4" SE="1">%s </T><T C="195,171,148" S="22" P="1" SC="79,60,48" SS="4" SE="1"> Tổng thời gian chờ</T>]],
CARD_TEXT6 = [[<T C="127,70,26" S="22" P="1">Nhận Phiếu: </T><I Z="0.8" P="1">ui/common/common_icon_emzz.png</I><T C="229,105,22" S="22" P="1">%d-%d</T>]],
CARD_TEXT7 = [[<T C="127,70,26" S="22" P="1">Nhận Thẻ: </T><I Z="1" P="1">%s</I><T C="229,105,22" S="22" P="1">%d-%d</T>]],
CARD_TEXT8 = [[<T C="127,70,26" S="22" P="1">Mở tốn CD: </T><T C="229,105,22" S="22" P="1">%s</T>]],
CARD_TEXT9 = "Có cơ hội nhận các thẻ sau",
CARD_TEXT10 = "Mở Bộ Thẻ",
CARD_TEXT11 = [[<T C="195,171,148" S="22" P="1" SC="79,60,48" SS="4" SE="1">Mỗi ngày </T><T C="255,89,74" S="22" P="1" SC="158,0,0" SS="4" SE="1">%s </T><T C="195,171,148" S="22" P="1" SC="79,60,48" SS="4" SE="1">tạo mới Tiệm</T>]],
CARD_TEXT12 = [[<T C="127,70,26" S="22" P="1"> Tối thiểu gồm Thẻ Tinh Anh: </T><I Z="1" P="1">%s</I><T C="229,105,22" S="22" P="1">%d</T>]],
CARD_TEXT13 = [[<T C="127,70,26" S="22" P="1"> Tối thiểu gồm Thẻ Truyền Kỳ: </T><I Z="1" P="1">%s</I><T C="229,105,22" S="22" P="1">%d</T>]],
CARD_TEXT14 = [[<T C="255,227,116" S="22" P="1" SC="158,0,0" SS="4" SE="1">%s</T><I Z="1" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="158,0,0" SS="4" SE="1">%d</T>]],
MARRY_COPY_COST_LIFE = "(Cần %d)",
MASTERINFO67 = [[Kính biếu]],
MASTERINFO68 = [[Kính biếu thành công]],
MASTERINFO69 = [[Sư phụ Online mới được kính biếu]],
MASTERINFO70 = [[Hôm nay đã kính biếu đủ, mai hãy đến tiếp]],
MASTERINFO71 = [[Chờ]],
CARD_TEXT15 = "P.Chất: ",
CARD_TEXT16 = "Số lượng Thẻ Bài không đủ, không thể tăng cấp",
CARD_TEXT17 = "Số lượng phiếu không đủ, không thể tăng cấp",
CARD_TEXT18 = "Hôm nay đã đạt số lượng mở bộ Thẻ",
CARD_TEXT19 = "Đang trong thời gian chờ, dùng %d Kim Cương mở?",
CARD_TEXT20 = "Số lượng phiếu không đủ, không thể mua", 
CARD_TEXT21 = "Thẻ Bài %s đã mở",
CARD_TEXT22 = "Thẻ Bài %s + %d",
MASTERINFO72 = [[<T C="79,60,48" S="20" P="1">Còn %d lần</T>]],
MASTERINFO73 = [[ phút sau có thể truyền dạy]],
MASTERINFO74 = [[Số lần truyền dạy hôm nay đã hết]],
MASTERINFO75 = [[Truyền dạy thành công nhận %d Sư Đức]],
MASTERINFO76 = [[Đang chờ không thể kính biếu]],
MASTERINFO77 = [[Đệ tử hiện chưa online, không thể truyền dạy]],
INV_OBJECT = "Mời nửa kia",
COMMUNITYINFO128 = [[Chủ Hội hôm nay chưa phát nhiệm vụ Công Hội!]],
COMMUNITYINFO129 = [[Nhấp để nhắn tin cho Chủ Hội]],
CARD_TEXT23 = "Thường",
CARD_TEXT24 = "Tinh Anh",
CARD_TEXT25 = "Truyền Kỳ",
CARD_TEXT37 = "Sử Thi",
RANK_RESULT_KF1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,236,193" S="20" P="0" SC="105,65,46" SE="1" SS="4">%s</T>]],
FOREVER_WELFARE_CARD = "Thẻ Phúc Lợi",
CARD_TEXT26 = "Không có Thẻ Bài đã mở",
RANK_RESULT_NOKF1 = [[<T C="255,236,193" S="20" P="0" SC="105,65,46" SE="1" SS="4">%s</T>]],
CHECKOTHER10 = "Tu luyện",
CARD_TEXT27 = "Mở Túi Thẻ",
CARD_TEXT28 = "Phiếu +%d",
CARD_TEXT29 = "Số liệu Bộ Thẻ bất thường, hãy liên hệ CSKH",
CARD_TEXT30 = "Bộ Thẻ này không rõ nguồn gốc, không thể mở",
CARD_TEXT31 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Nhấp mở Bộ Thẻ</T>]],
CARD_TEXT32 = "Chờ xong rồi, hãy đi mở thẻ thôi",
CARD_TEXT33 = "Không có Bộ Thẻ, hãy đi càn quét phó bản để lấy nào!",
CARD_TEXT34 = 
[[
<T C="229,105,22" S="22" P="0">1. </T><T C="127,70,26" S="22" P="0">Vượt ải độ khó Thường, Tinh Anh và phó bản nhóm có thể nhận Bộ Thẻ.</T><BR></BR>
<T C="229,105,22" S="22" P="0">2. </T><T C="127,70,26" S="22" P="0">Mở Bộ Thẻ có thể nhận Thẻ quái vật và Phiếu, dùng kích hoạt, nâng cấp Thẻ Bài.</T><BR></BR>
<T C="229,105,22" S="22" P="0">3. </T><T C="127,70,26" S="22" P="0">Khi mở Bộ Thẻ sẽ có thời gian chờ. Khi thời gian chờ đạt đủ 24 giờ, sẽ không thể mở nữa. Mỗi ngày chỉ được mở số lần giới hạn.</T><BR></BR>
<T C="229,105,22" S="22" P="0">4. </T><T C="127,70,26" S="22" P="0">Tiệm Thẻ Bài mỗi ngày 0 giờ tạo mới, ngẫu nhiên tạo mới Thẻ Bài khác nhau.</T><BR></BR>
<T C="229,105,22" S="22" P="0">5. </T><T C="127,70,26" S="22" P="0">Thẻ chia làm 3 loại Thường, Tinh Anh, Master, rơi từ các phó bản độ khó khác nhau.</T><BR></BR>
<T C="229,105,22" S="22" P="0">6. </T><T C="127,70,26" S="22" P="0">Ngoài mở Bộ Thẻ và mua ở Tiệm, còn có thể mở túi thẻ, túi thẻ không tốn lần mở, không cần chờ. (Ngoài trừ Túi Thẻ Cam)</T><BR></BR>
<T C="229,105,22" S="22" P="0">7. </T><T C="127,70,26" S="22" P="0">Sau khi Thẻ đạt Lv40, có thể dùng Thẻ để đổi Mảnh Hồn Thẻ.</T><BR></BR>
<T C="229,105,22" S="22" P="0">8. </T><T C="127,70,26" S="22" P="0"> Có thể dùng Mảnh Hồn Thẻ để lễ bái Hồn Thẻ, tăng thuộc tính tạm thời.</T><BR></BR>
]],
CARD_COUNT1 = "%s không đủ",
LIMITE_BUY_ACTIVITY = "Có thể mua",
LIMITE_BUY_ORIGINPRICE = "Giá gốc",
MASTERINFO78 = [[Ta vừa mới truyền dạy, bạn nhận %d EXP]],
MASTERINFO79 = [[Tôi vừa kính biếu, bạn nhận %d Sư đức]],
GOTO_MULTIPLECOPY = "ĐếnNhómĐội",
GOTO_ELITE = "ĐếnTinh Anh",
LIMITE_BUY_CURPRICE = "Giá",
LIMITE_BUY_SOLDOUT = "Hết",
PETSKILL1 = "Kỹ năng 1",
PETSKILL2 = "Kỹ năng 2",
PETSKILL3 = "Kỹ năng 3",
PETSKILL4 = "Kỹ năng 4",
PETSKILLDESC1 = "Pet tiến hóa +1 mở lỗ kỹ năng",
PETSKILLDESC2 = "Pet tiến hóa +3 mở lỗ kỹ năng",
PETSKILLDESC3 = "Pet tiến hóa +5 mở lỗ kỹ năng",
PETSKILLDESC4 = "Pet tiến hóa +6 mở lỗ kỹ năng",
PETSKILL_LOCK_ASK = "Không nhắc lại",
PETSKILL_LOCK_ASK2 = "Pet có kỹ năng cao chưa khóa, tiếp tục lĩnh ngộ?",
PETSKILLNUM = "Kỹ năng:",
PETNEEDUPADVANCELEVEL = "Cần Pet tăng bậc +1 trở lên",
PRACTICE_QUICK = "Bỏ qua",
GOTO_PET = "Đến rút",
PRACTICE_QUICK_LV = "VIP2 sẽ mở, tăng cấp VIP ngay?",
WARN_DESC1 = [[<T C="255,236,193" S="12" P="0" SC="138,122,106" SE="1" SS="2">Chú ý giữ gìn sức khỏe  Đề phòng các hành vi lừa đảo  Phòng chống trộm cắp tài khoản  Sắp xếp thời gian chơi game hợp lý</T>]],
WARN_DESC2 = [[<T C="255,236,193" S="12" P="0" SC="138,122,106" SE="1" SS="2">Sản xuất: ZHWYD   Ấn bản: SSTLP   Số đăng ký: XG-2016-1266   ISSN: ISBN978-7-7979-0084-3</T>]],
INPUT_MAX_CHAT = "Nhập tối đa 24 ký tự",

COMMUNITY_COMPETE_TEXT23 = "Đấu vòng 1",
COMMUNITY_COMPETE_TEXT24 = "Đấu vòng 2",
COMMUNITY_COMPETE_TEXT25 = "Đã kết thúc",
COMMONITY_DESC1 = "Mục tiêu Công Hội",
COMMONITY_DESC2 = "Thưởng Công Hội",
COMMONITY_DESC3 = "Tham gia đủ %d trận Công Hội Chiến",
CHARM_SPACE = "Trang Hấp Dẫn",
CHARM_RANK_RELOAD = "Đề cử ngẫu nhiên",
CHARM_RECOMMEND = "BXH tuần",
CHARM_TOTAL_RANK  = "BXH tổng",
RANK_REWARD = "Thưởng hạng",
EVERY_WEEKDAY = "Mỗi chủ nhật ",
CHARM_TIME= "24:00",
CHARM_SEND_REWRAD = " sẽ phát thưởng theo Hạng Hấp Dẫn tuần hiện tại",
CHARM_PLAYER = "Người chơi",
CHARM_ID = "ID",
CHARM_SERVER = "Server",
CHARM_FLOWER_NUM = "Hấp Dẫn",
CHARM_MESSAGE = "Thông tin",
SPACE = "Trang cá nhân",
CHARM_ALL = "Tất cả",
CHARM_BOY = "Nam",
CHARM_GIRL = "Nữ",
CHARM_REFRESH = "Tạo mới",
COMMUNITY_COMPETE_TEXT26 = "Phòng không có ai",
FRIENDS_LOCALFRIEND = "Bạn cùng server",
FRIENDS_OTHERFRIEND = "Bạn liên server",
CHARM_RELOAD = "Tái lập lúc 24 giờ CN hàng tuần (Hấp Dẫn > %d vào BXH)",
CHARM_RELOAD2 = "Hấp Dẫn tuần > %d vào BXH",

INVITE_LEAGUE = "Có thể tham gia Liên Đấu, vào ngay không?",

FRIENDS_NO_OTHERFRIEND = [[Hiện chưa có thông tin bạn liên server]],
FRIENDS_KUAFU = "Liên server",
ATT_ONLINEFRIEND_NULL = [[Chưa có bạn liên server online]],
HAD_ONLINE = "Đã online",
ONLINE_REWRAD = "Nhận thưởng",
CONTINUE_ONLINE = "Tiếp tục online",
LEAGUE_REWARD_TEXT9 = "Chưa được",
MASTERINFO80 = [[Giải thưởng cấp độ hiện tại như sau:]],
COMMONITY_DESC4 = [[<T C="255,236,193" S="18" P="1">%s</T><T C="255,227,116" S="18" P="1"> %s</T>]],
COMMONITY_DESC5 = [[<T C="255,236,193" S="18" P="1">%s</T><T C="233,166,62" S="18" P="1"> %s</T>]],
COMMONITY_DESC6 = [[<T C="255,236,193" S="18" P="1">Tạm chưa có</T>]],
COMMONITY_DESC7 = "Tranh vô địch",
COMMONITY_DESC8 = "Tranh hạng 3",

ATH_DESC12 =
[[
<T C="229,105,22" S="22">Hướng dẫn</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Cấp Thi Đấu sẽ tăng theo Điểm Thi Đấu, Cấp Thi Đấu sẽ có thuộc tính cộng thêm.</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Cấp Thi Đấu dưới Đồng 5 thất bại sẽ không bị trừ Điểm Thi Đấu.</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Các yếu tố ảnh hưởng Điểm Thi Đấu: Số người tham gia, diệt đầu tiên, số tiêu diệt.</T><BR>10</BR>
]],
MEMBER_TEAM = "Chia đội",
COMMUNITY_COMPETE_TEXT27 = "Thành viên phòng Công Hội",
COMMUNITY_COMPETE_TEXT28 = "Hiện đã có %d hội viên vào Công Hội Chiến",
COMMUNITY_COMPETE_TEXT29 = "Hủy tham gia",
COMMUNITY_COMPETE_TEXT30 = "Xem thông tin",
COMMUNITY_COMPETE_TEXT31 = "Nhấp để thiết lập thành viên",
COMMUNITY_COMPETE_TEXT22 = "Nhóm",
COMMUNITYINFO130 = [[Bổ nhiệm]],
COMMONITY_DESC9 = "Quyết đấu",
COMMONITY_DESC10 = [[<T C="255,89,74" S="20" P="1">%s</T><T C="127,70,26" S="22" P="1">Bắt đầu</T>]],
COMMUNITYINFO131 = [[Số lượng %s cấp Công Hội hiện tại có thể bổ nhiệm:]],
COMMUNITYINFO132 = [[Xác nhận bổ nhiệm]],
COMMONITY_DESC11 = "Kỳ %d",
COMMUNITYINFO133 = [[Chức này đã bổ nhiệm tối đa]],
COMMUNITYINFO134 = [[Số người được bổ nhiệm chức này vượt giới hạn, hãy chọn lại]],
COMMUNITYINFO135 = [[Trong mục tiêu chọn có hội viên đã thay đổi chức]],
COMMUNITYINFO136 = [[Trong mục tiêu chọn có hội viên đã rời Công Hội]],
COMMUNITYINFO137 = [[Bổ nhiệm thành công]],
CHARM_DES =
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Đề cử ngẫu nhiên sẽ chỉ đề cử những người chơi có hình</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Upload càng nhiều hình, trong tuần nhận được càng nhiều hoa</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> xác suất được đề cử càng lớn</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Online cũng sẽ tăng xác suất</T><BR></BR>
]],
COMMYNITY_COMPETE_TEXT32 = "Đội đã đầy, hãy thiết lập lại",
COMMYNITY_COMPETE_TEXT33 = "Chưa thiết lập",
COMMYNITY_COMPETE_TEXT34 = "Đội",
CHARM_RESULT = "Chưa có dữ liệu",  
CHARM_SINGLE = "Độc thân",
CHARM_COMMUNITY = "Công Hội:",
CHARM_NOT_INTO_SPACE = "Trang liên server chưa mở",
CHARM_NO_PLAYER = "Không có người chơi đề cử",
COMMUNITYINFO138 = [[Hội viên được nhận thưởng]],

SPACE108 = [[More>>]],
SPACE109 = [[Đã có thể vào]],
SUREDELFRIEND1 = "Xác nhận xóa bạn?",
COMMYNITY_COMPETE_TEXT35 = "Hủy tham gia",
GAME_ACTIVITY_TITLE1 = "Nạp lần đầu",
GAME_ACTIVITY_TITLE2 = "Nạp Lần Đầu Ngày",
GAME_ACTIVITY_TITLE3 = "Nạp lần đầu hạn giờ",
GAME_ACTIVITY_TITLE4 = "Tích lũy nạp",
GAME_ACTIVITY_TITLE5 = "Hoàn trả nạp",
GAME_ACTIVITY_TITLE6 = "Tích lũy tiêu phí",
GAME_ACTIVITY_TITLE7 = "Đăng nhập giới hạn",
GAME_ACTIVITY_TITLE8 = "Tích lũy đăng nhập",
GAME_ACTIVITY_TITLE9 = "Cường hóa",
GAME_ACTIVITY_TITLE10 = "Thăng Cấp",
GAME_ACTIVITY_TITLE11 = "Tăng lực chiến",
GAME_ACTIVITY_TITLE12 = "Thưởng cấp VIP",
GAME_ACTIVITY_TITLE13 = "Túi Quà Ưu Đãi",
GAME_ACTIVITY_TITLE14 = "Điểm thi đấu",
GAME_ACTIVITY_TITLE15 = "Nạp Mỗi Ngày",
GAME_ACTIVITY_TITLE16 = "Dự Tiệc",
GAME_ACTIVITY_TITLE17 = "Nạp trước CB",
GAME_ACTIVITY_TITLE18 = "Hạng Đua Top",
GAME_ACTIVITY_TITLE19 = "Hạng Thi Đấu",
GAME_ACTIVITY_TITLE20 = "Hạng Lực Chiến",
GAME_ACTIVITY_TITLE21 = "Đồng Tâm Chiến",
GAME_ACTIVITY_TITLE22 = "Công Hội Tác Chiến",
GAME_ACTIVITY_TITLE23 = "Bí Cảnh x2",
GAME_ACTIVITY_TITLE24 = "Đấu Trường x2",
GAME_ACTIVITY_TITLE25 = "Vòng Quay May Mắn",
GAME_ACTIVITY_TITLE26 = "Giảm Giá Hàng Mới",
GAME_ACTIVITY_TITLE27 = "Ưu Đãi Giảm Giá",
GAME_ACTIVITY_TITLE28 = "Giới Hạn Đổi Quà",
GAME_ACTIVITY_TITLE29 = "Tổ Đội x2",
GAME_ACTIVITY_TITLE30 = "Tinh Anh x2",
GAME_ACTIVITY_TITLE31 = "Thưởng Nạp Lần Đầu",
GAME_ACTIVITY_TITLE32 = "Yêu Là Cưới",
GAME_ACTIVITY_TITLE33 = "Ra Mắt Thú Cưng ",
GAME_ACTIVITY_TITLE34 = "Thưởng online",
GAME_ACTIVITY_TITLE35 = "Thưởng Nạp Mỗi Ngày",
GAME_ACTIVITY_TITLE36 = "Husky",
ACTOR_NAME_LV = [[<T C="255,227,116" S="22" P="0">Lv%s</T><T C="255,255,255" S="22" P="0"> %s</T>]],
ACTOR_FIGHT = [[<T C="255,227,116" S="22" P="0">Lực chiến:</T><T C="255,255,255" S="22" P="0">%s</T>]],
TEN_TAKE_OUT = "Rút x10",
ATH_DESC13 = "Hạng Sơ: Cấp Điểm Đấu Điểm %d-%d ",
ATH_DESC14 = "Hạng Trung: Cấp Điểm Đấu Điểm %d-%d ",
ATH_DESC15 = "Hạng Cao: Cấp Điểm Đối Kháng %d-%d ",
ATH_DESC16 = "Hạng Sơ",
ATH_DESC17 = "Hạng Trung",
ATH_DESC18 = "Hạng Cao",
ATH_DESC19 = [[<T C="127,70,26" S="20" P="1">Hạng: </T><T C="255,105,22" S="20" P="1">Trống</T>]],
ATH_DESC20 = [[<T C="127,70,26" S="20" P="1">Hạng: </T><T C="255,105,22" S="20" P="1">%s</T>]],
ATH_DESC21 = [[<T C="127,70,26" S="20" P="1">Thuộc Hạng Sơ</T>]],
ATH_DESC22 = [[<T C="127,70,26" S="20" P="1">Thuộc Hạng Trung</T>]],
ATH_DESC23 = [[<T C="127,70,26" S="20" P="1">Thuộc Hạng Cao</T>]],
COMMYNITY_COMPETE_TEXT36 = "Chưa đạt Lv%d, không thể thiết lập xuất chiến",
COMMYNITY_COMPETE_TEXT37 = "Vào Công Hội chưa đủ %d giờ, không thể thiết lập xuất chiến",
COMMYNITY_COMPETE_TEXT38 = "Chưa vào mùa đấu mới",
COMMYNITY_COMPETE_TEXT39 = "Mùa đấu chưa mở, không thể xem",

ASCENDING1 = "Chế tạo",
ASCENDING2 = "Đổi phẩm",
ASCENDING3 = "Trước khi chế tạo",
ASCENDING4 = "Xem trước",
ASCENDING5 = "Nguyên liệu",
ASCENDING6 = "Tăng bậc",
ASCENDING7 = "T.Bị Lam",
ASCENDING8 = "Sách Chế Tạo",
ASCENDING9 = "Thánh Quang",
ASCENDING10 = "Sắt",
ASCENDING11 = "Vải",
ASCENDING12 = "Bảo lưu cường hóa, cấp tăng sao",
ASCENDING13 = "Thượng hạ phẩm",
ASCENDING14 = "Phẩm chất mới",
ASCENDING15 = "Phẩm chất cũ",
ASCENDING16 = "Chú ý: Sau khi đổi phẩm thuộc tính bị giảm, bảo lưu thuộc tính trước đó?",
NEARBY = "Người gần",
MALE = "Nam",
WOMAN = "Nữ",
ASCENDING17 = "Trang bị Lam:\nCường hóa +%d, cấp sao +%d có thể chế tạo trang bị Tím",
ASCENDING18 = "Trang bị Tím:\nCường hóa +%d, cấp sao +%d có thể chế tạo trang bị Cam",
COMMYNITY_COMPETE_TEXT40 = "Bắt đầu chuẩn bị",
COMMUNITY_COMPETE_TEXT41 = "Thoát phòng",
COMMUNITY_COMPETE_TEXT42 = " sau tự bắt đầu thi đấu",
COMMUNITY_COMPETE_TEXT43 = "Trống",
COMMUNITY_COMPETE_TEXT44 = "Trống",
ASCENDING19 = "Nguyên liệu không đủ, đến mở Rương Thánh Quang để nhận",
ASCENDING20 = "Chưa có trang bị Cam, hãy đến chế tạo",
COMMONITY_DESC12 = "Tích lũy số lần chiến thắng Công Hội Chiến %d lần",
COMMONITY_DESC13 = "Tích lũy số người diệt ở Công Hội Chiến %d người",
COMMUNITY_COMPETE_TEXT45 = 
[[
<T C="255,236,193" S="20" P="1">Báo danh:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1">Chủ Hội của Công Hội Top 30 cống hiến có thể báo danh vào Thứ 3.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1">Báo danh tốn 200000 Vàng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1">Sau khi tất cả Công Hội báo danh xong, sẽ căn cứ theo hạng danh vọng mới tăng của Công Hội báo danh, lấy Công Hội ở Top 16 để chia nhóm.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1">Công Hội nào không được chia nhóm, sẽ hoàn trả phí báo danh cho Chủ Hội qua Thư.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">16 Công Hội được chọn sẽ chia nhóm ngẫu nhiên, Thứ 5 bắt đầu Công Hội Chiến.</T><BR></BR>
<T C="229,105,22" S="20" P="0">6.</T><T C="255,236,193" S="20" P="1">Thanh viên có tham gia Công Hội Chiến cần đạt 2 điều kiện: Nhân vật ≥ Lv25, vào Công Hội ≥ 48 giờ.</T><BR></BR>
<T C="229,105,22" S="20" P="0">7.</T><T C="255,236,193" S="20" P="1">Công Hội Chiến chia làm 3 đội, do Chủ Hội sắp xếp thành viên.</T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT46 = 
[[
<T C="255,236,193" S="20" P="1">Đấu bảng: </T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Theo nhóm đã chia, sẽ thi đấu vào tối Thứ 5.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Các nhóm sẽ đấu loại căn cứ theo số, thắng vào vòng trong, thua bị loại.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> Quy tắc đấu cặp theo số của nhóm, Công Hội 1 VS Công Hội 2, Công Hội 3 VS Công Hội 4.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> Phòng Công Hội Chiến sẽ mở vào 20:00 tối thứ 5, sau khi mở có thể vào thiết lập thành viên.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1"> 20:10 tối thứ 5 chính thức thi đấu, trước đó có thể thiết lập thành viên tùy ý.</T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT47 = 
[[
<T C="255,236,193" S="20" P="1">Tứ kết: </T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Tối Thứ 6 thi đấu (Tứ kết).</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Thắng trận đấu tối Thứ 5 sẽ còn thi đấu tiếp.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> 2 Công Hội vào vòng trong của các nhóm sẽ đấu với nhau, chọn ra Công Hội đứng đầu nhóm.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> Phòng Công Hội Chiến sẽ mở vào 20:00 tối Thứ 6, sau khi mở có thể vào thiết lập thành viên.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1"> 20:00 tối Thứ 6 bắt đầu trận đấu, trước đó có thể thiết lập thành viên tùy ý.</T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT48 = 
[[
<T C="255,236,193" S="20" P="1">Chung kết: </T>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Tối Thứ 7 thi đấu (Bán kết) và trận tranh Quán Quân, Hạng 3.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Công Hội vào vòng trong còn lại thi đấu (Bán kết) trước, thắng sẽ đấu tiếp trận Quán Quân, thua tranh Hạng 3.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> Công Hội nhất nhóm A đấu với Công Hội nhất nhóm B, Công Hội nhất nhóm C đấu với Công Hội nhất nhóm D.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> 20:00-20:10 thiết lập thành viên thi đấu (Bán kết), 20:10-20:25 thi đấu.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">20:30-20:40 thiết lập thành viên tranh Quán Quân, Hạng 3, 20:40-20:55 thi đấu.</T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT49 = 
[[
<T C="255,236,193" S="20" P="1">Phòng đấu bảng: </T>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Thi Đấu dùng cơ chế 1 trận, sau khi tiêu diệt toàn bộ thành viên đội đối phương xem như chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Khi hết thời gian mà chưa phân định được thắng thua, hệ thống sẽ căn cứ theo tổng tỉ lệ sinh lực của thành viên còn lại 2 bên để quyết định thắng thua.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> Nếu vẫn bất phân thắng bại, thì sẽ căn cứ theo hạng danh vọng mới tăng, hạng cao hơn sẽ chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> Cuối cùng, căn cứ tổng tỉ số 3 đội của 2 bên phân thắng thua, phe thắng nhiều sẽ giành chiến thắng, được đi tiếp.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1"> 20:00-20:10 có thể tự do thiết lập thành viên, 20:10-20:25 là thời gian thi đấu </T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT50 = 
[[
<T C="255,236,193" S="20" P="1">Phòng tứ kết: </T>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Thi Đấu dùng cơ chế 1 trận, sau khi tiêu diệt toàn bộ thành viên đội đối phương xem như chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Khi hết thời gian mà chưa phân định được thắng thua, hệ thống sẽ căn cứ theo tổng tỉ lệ sinh lực của thành viên còn lại 2 bên để quyết định thắng thua.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> Nếu vẫn bất phân thắng bại, thì sẽ căn cứ theo hạng danh vọng mới tăng, hạng cao hơn sẽ chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> Cuối cùng, căn cứ tổng tỉ số 3 đội của 2 bên phân thắng thua, phe thắng nhiều sẽ giành chiến thắng, được đi tiếp.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1"> 20:00-20:10 có thể tự do thiết lập thành viên, 20:10-20:25 là thời gian thi đấu </T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT51 = 
[[
<T C="255,236,193" S="20" P="1">Phòng chung kết: </T>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Thi Đấu dùng cơ chế 1 trận, sau khi tiêu diệt toàn bộ thành viên đội đối phương xem như chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Khi hết thời gian mà chưa phân định được thắng thua, hệ thống sẽ căn cứ theo tổng tỉ lệ sinh lực của thành viên còn lại 2 bên để quyết định thắng thua.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> Nếu vẫn bất phân thắng bại, thì sẽ căn cứ theo hạng danh vọng mới tăng, hạng cao hơn sẽ chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> Cuối cùng, căn cứ tổng tỉ số 3 đội của 2 bên phân thắng thua, phe thắng nhiều sẽ giành chiến thắng, được đi tiếp.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1"> 20:00-20:10 là thời gian thiết lập thành viên thi đấu (Bán kết), 20:10-20:25 là thời gian thi đấu</T><BR></BR>
<T C="229,105,22" S="20" P="0">6.</T><T C="255,236,193" S="20" P="1"> 20:30-20:40 là thời gian thiết lập thành viên thi đấu tranh Quán Quân, Hạng 3, 20:40-20:55 là thời gian thi đấu.</T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT52 = [[Bạn được thiết lập là trạng thái xuất chiến, rời phòng sẽ hủy trạng thái xuất chiến, đồng ý?]],
COMMUNITY_COMPETE_TEXT53 = "%s mời bạn vào phòng Công Hội Chiến cùng chiến đấu",
ASCENDING21 = "Thuốc Thánh Quang không đủ, mua thêm?",
COMMUNITY_COMPETE_TEXT54 = "Công Hội Chiến đã bắt đầu\nĐợi ghép Công Hội Chiến...",
COMMUNITY_COMPETE_TEXT55 = "Thứ 6 bắt đầu bán kết",
COMMUNITY_COMPETE_TEXT56 = "Không có đối thủ chán quá, thắng quá dễ dàng!",
COMMUNITY_COMPETE_TEXT57 = "Tranh đoạt tư cách vào vòng trong Công Hội Chiến mùa mới!",
COMMONITY_DESC14 = "Không cần đấu",
COMMONITY_DESC15 = "Vòng 1/8",
COMMONITY_DESC16 = "Tứ Kết",
COMMONITY_DESC17 = "Bán Kết",
COMMONITY_DESC18 = "Tranh hạng 3",
COMMONITY_DESC19 = "Tranh vô địch",
COMMONITY_DESC20 = "Thứ 5",
COMMONITY_DESC21 = "Thứ 6",
COMMONITY_DESC22 = "Thứ 7",
COMMUNITYINFO139 = [[Hạng tổng]],
COMMUNITYINFO140 = [[Hạng tuần]],
COMMUNITYINFO141 = [[Hạng Công Hội Chiến kỷ lục:]],
COMMUNITYINFO142 = [[Hạng Công Hội Chiến lần trước:]],
COMMUNITYINFO143 = [[Top 4]],
COMMUNITYINFO144 = [[Danh vọng tuần]],
COMMUNITYINFO145 = [[Danh vọng tuần trước]],
ASCENDING22 = [[Đạo cụ không đủ, không thể mua nhanh]],
COMMUNITY_COMPETE_TEXT58 = "Công Hội Chiến hôm nay đã kết thúc, sẽ tự động rời phòng Công Hội Chiến",
COMMUNITY_COMPETE_TEXT59 = "Tranh tư cách tham gia",
COMMUNITY_COMPETE_TEXT60 = "Đến cùng chiến đấu!",
COMMUNITY_COMPETE_TEXT61 = "Công Hội Lv2 không đủ 10, mở Công Hội Chiến thất bại",
COMMUNITY_COMPETE_TEXT62 = "Công Hội vào vòng trong không đủ, Công Hội Chiến kết thúc",
COMMUNITY_COMPETE_TEXT63 = "Công Hội báo danh không đủ, Công Hội Chiến kết thúc",
COMMONITY_DESC23 = "Tạm không có mục tiêu mới",
ASCENDING23 = [[Trang bị Cam chỉ có thể kế thừa trang bị Cam]],

ASCENDINGEXPLAIN = 
[[
<T C="127,70,26" S="20" P="1">Hệ thống Thánh Quang:</T><BR></BR>
<T C="127,70,26" S="20" P="1"> </T><BR></BR>
<T C="229,105,22" S="20" P="1">Trang bị Lam:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Trang bị Lam đạt điều kiện cấp cường hóa ≥ 35, cấp sao ≥ 10, có thể chế tạo trang bị Tím.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Sau khi chế tạo, cấp cường hóa và cấp sao của trang bị Tím nhận được sẽ bị giảm nhất định, trước khi chế tạo có thể dùng ít Kim Cương để bảo lưu.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Sau khi chế tạo trang bị Lam thành trang bị Tím, không đổi thuộc tính Set.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">Chế tạo cần tốn Sách Chế Tạo Tím của bộ phận tương ứng, Thánh Quang Tinh Hoa, Sắt-Thấp, Vải-Thấp, khi mở Rương Thánh Quang có thể nhận các nguyên liệu này.</T><BR></BR>
<T C="127,70,26" S="20" P="1"> </T><BR></BR>
<T C="229,105,22" S="20" P="1">Trang bị Tím:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Trang bị Tím đạt điều kiện cấp cường hóa ≥ 40, cấp sao = 12, có thể chế tạo trang bị Cam.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Sau khi chế tạo, trang bị Cam sẽ kế thừa cấp cường hóa lớn hơn Lv40 của trang bị Tím, cấp sao sẽ tạo mới.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Sau khi chế tạo đồ Tím thành trang bị Cam, không đổi thuộc tính Set.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">Chế tạo cần tốn Sách Chế Tạo Cam của bộ phận tương ứng, Tinh Thánh Quang, Sắt-Cao, Vải-Cao, khi mở Rương Thánh Quang có thể nhận các nguyên liệu này.</T><BR></BR>
<T C="127,70,26" S="20" P="1"> </T><BR></BR>
<T C="229,105,22" S="20" P="1">Trang bị Cam:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Trang bị Cam có phẩm chất, có thể đổi phẩm chất của trang bị thông qua tính năng [Đổi Phẩm] của hệ thống Thánh Quang.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">[Đổi phẩm] cần tốn Sách Chế Tạo Cam của bộ phận tương ứng và Thuốc Thánh Quang.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="1">Trang bị cam chỉ được kế thừa trang bị cam.</T><BR></BR>
<T C="127,70,26" S="20" P="1"> </T><BR></BR>
]],
ASCENDING24 = [[Đề cử]],
COMMUNITY_COMPETE_TEXT64 = "Chưa đến giờ, không chưa thể vào phòng, vui lòng đợi",
MAIL_DOPAY2 = "Thay đối phương trả %s Kim Cương",
INN1 = "Thương Nhân Chợ Đen xuất hiện!!",
INN2 = "Thương Nhân Chợ Đen mang theo nhiều bảo vật, nếu gặp hãy tranh thủ cơ hội!",
INN3 = "Thương Nhân Chợ Đen đã xuất hiện, mau mua nào",
INN4 = "Mở Tiệm",
INN5 = "Vượt phó bản có xác suất gặp Thương Nhân Chợ Đen",
INN6 = "Phó bản nhóm",
INN7 = "Vùng Mạo Hiểm",
INN8 = [[<T C="127,70,26" S="16" P="0">Thương Nhân Chợ Đen sau </T><T C="158,0,0" S="16" P="0">%s</T><T C="127,70,26" S="16" P="0"> rời khỏi</T><BR></BR>
<T C="127,70,26" S="16" P="0">(Khiêu Chiến Phó Bản có thể gặp lại)</T>]],
INN9 = "Mời khỏi",
INN10 = "Mời Thương Nhân Chợ Đen đi? Mời đi xong Tiệm Chợ Đen sẽ đóng",
INN11 = 
[[
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1"> Vượt Vùng Mạo Hiểm có cơ hội tìm thấy Tiệm</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1"> Càn quét Vùng Mạo Hiểm có cơ hội tìm thấy Tiệm</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1"> Tổ đội vượt phó bản có cơ hội tìm thấy Tiệm</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1"> Khi Thương Nhân tồn tại sẽ không tìm thấy nữa</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="1"> Khi Thương Nhân xuất hiện lại, Tiệm sẽ bày vật phẩm mới</T><BR>10</BR>
]],
INN12 = "Thương Nhân Chợ Đen đã rời khỏi",
PASS_ELITE_SECTION_TIP = "Vượt Tinh Anh của chương để mở",
ASCENDING_FUSE1 = "Ghép",
ASCENDING_FUSE2 = [[<T C="255,89,74" S="22" P="1">(Chọn cầu phúc bên phải để ghép)</T>]],
ASCENDING_FUSE3 = "Chưa ghép",
ASCENDING_FUSE4 = "Đã ghép",
ASCENDING_FUSE5 = "Cầu phúc không đủ điều kiện ghép",
ASCENDING_FUSE6 = "Cầu phúc",
ASCENDING_FUSE7 = [[<T C="255,89,74" S="22" P="1">(Chúc phúc cam chỉ được ghép 1 lần)</T>]],
ASCENDING_FUSE8 = "Đã ghép xong tất cả",
ASCENDING_FUSE9 = "Chưa có chúc phúc đã ghép xong",
ASCENDING_FUSE10 = "(Chưa đạt Lv%d)",
ASCENDING_FUSE11 = "(Thiếu)",
ASCENDING_FUSE12 = "(Đã có)",
ASCENDING_FUSE13 = [[<T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%s</T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(Có  %d)  </T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(Có  %d)</T>]],
ASCENDING_FUSE14 = "Nguyên liệu không đủ",
ASCENDING_FUSE15 = "%s không đủ, mua đạo cụ này không?",
ASCENDING_FUSE16 = "Ghép cầu phúc",
FIXED_REWARD = "Được nhận",
ASCENDING_FUSE17 = "Không thể ghép",
ASCENDING_FUSE18 = "Có thể ghép",
PASS_LEVEL = "Đã vượt ải",
PASS_LEVEL_STAT = "%d sao",
TEN_DRAW = "Rút liên tục %d lần",
BLESS_HOUSE_FULL2 = "Túi Cầu Phúc không đủ chỗ, hãy nhặt rồi gọi tiếp",
GAME_ACTIVITY_TITLE37 = "Tơ Hồng",
DRAW_AGAIN_TEN = "Rút tiếp %d lần",
WELFARE_COMPETE1 = "Giải Trí",
ACTIVITY_HAVED_ATT = "Đã sở hữu %s vĩnh viễn, xác nhận mua lại?",
MELEE_DESC1 = "Hệ thống sẽ ghép 4 kẻ địch có thực lực tương đồng giao chiến, cần diệt 4 người chơi mới có thể chiến thắng, rời khỏi sẽ bị trừ Điểm Thi Đấu",
MELEE_DESC2 = "Tham gia: ",
MELEE_DESC3 = "Chiến thắng: ",
MELEE_DESC4 = "Diệt địch: ",
MELEE_DESC5 = [[<T C="255,227,116" S="22" P="1">%d (%d/%d)</T>]],
MELEE_DESC6 = [[<T C="255,227,116" S="22" P="1">%d (</T><T C="99,255,95" S="22" P="1">%d/%d</T><T C="255,227,116" S="22" P="1">)</T>]],
MELEE_DESC7 = [[<T C="255,227,116" S="22" P="1">%d (Đã hoàn thành)</T>]],
MELEE_DESC8 = "Hướng dẫn: ",
MELEE_DESC9 = "Thưởng hôm nay",
MELEE_DESC10 = "Diệt %d lần",
MELEE_DESC11 = "Chiến tích Loạn Đấu: %d trận, thắng %d, diệt %d",
MELEE_DESC12 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Chủ nhật 00:00-24:00 mở</T>]],
WELFARE_COMPETE2 = "Chủ Nhật",
WELFARE_COMPETE3 = "Thứ 2",
WELFARE_COMPETE4 = "Thứ 3",
WELFARE_COMPETE5 = "Thứ 4",
WELFARE_COMPETE6 = "Thứ 5",
WELFARE_COMPETE7 = "Thứ 6",
WELFARE_COMPETE8 = "Thứ 7",
GOTO_CALL = "Gọi",

ASCENDING25 = "Pet Tím tiến hóa +%d và cấp trên %d có thể\ntiến hóa thành pet Cam",
ASCENDING26 = "Nhỏ",
ASCENDING27 = "Đang lớn",
ASCENDING28 = "Trưởng thành",
ASCENDING29 = "Hoàn chỉnh",
ASCENDING30 = "Chọn Pet",
PET_STORE_COST_NO_ENOUGH = "Tinh Hoa Pet không đủ, hãy thu hồi Pet để nhận",
PET_STORE_REFRESH_TIMES_LIMIT = "Lần tạo mới không đủ, hãy tăng cấp VIP",

WASHPETGIFT = "Tẩy T.Chất",
GAME_ACTIVITY_TITLE38 = "Nạp liên tục",
CONTINUE_RECHARGE_WORD = "Tiến độ nạp hôm nay",
CONTINUE_RECHARGE_WORD2 = "Hoàn thành nạp %d ngày (%d/%d)",
PETMAXGIFT = "Pet đạt tư chất cao nhất",
ASCENDING31 = "Bồi dưỡng Pet",
BAG3 = "Xóa bạn thân",

ASCENDING32 = "Tạm chưa mở", 
ASCENDING33 = "Đang cập nhật",
ASCENDING34 = "Chọn Pet cần tiến hóa", 
ASCENDING35 = "Pet không đủ",
PETNOOPEN = "Pet chưa mở phẩm chất Cam, đang cập nhật",
PURPLEPET = "Pet Tím",
ORANGEPET = "Pet Cam",
PETNORECOVER = "Tạm chưa có pet thu hồi",
PETNOENOUGHITEM = "Tinh Hoa Pet không đủ, thu hồi Pet có thể nhận",
LOVE_VALUE = "Tình cảm: ",
ZUDUI_ROOM_KF1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,227,116" S="22" P="0" SC="60,19,12" SE="1" SS="3">%s</T>]],
ZUDUI_ROOM_NOKF = [[<T C="99,255,95" S="22" P="0" SC="60,19,12" SE="1" SS="3" >%s</T>]],
ZUDUI_ROOM_NOKF1 = [[<T C="255,227,116" S="22" P="0" SC="60,19,12" SE="1" SS="3" >%s</T>]],
ASCENDINGEXPLAIN2 = 
[[
<T C="229,105,22" S="20" P="1">Cầu Phúc Cam:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Cầu Phúc Cam cần ghép 2 Câu Phúc Tím Lv10 có thuộc tính chỉ định, nhận 2 loại Cầu Phúc Cam có 2 thuộc tính</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Sau khi ghép cấp trở lại là 1, cấp tối đa là 30</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Ghép sẽ tốn Xu Cầu Phúc</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">Không thể mang Cầu Phúc thuộc tính trùng nhau</T>
]],
ASCENDINGEXPLAIN3 = 
[[
<T C="127,70,26" S="20" P="1">Hệ thống Thánh Quang:</T><BR></BR>
<T C="127,70,26" S="20" P="1"> </T><BR></BR>
<T C="229,105,22" S="20" P="1">Pet Cam:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Pet Tím tiến hóa +4, Cấp ≥45 có thể tiến hóa Pet Cam.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Sau khi tiến hóa Pet Cam, tư chất và cấp tiến hóa Pet Tím sẽ được kế thừa.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Sau khi tiến hóa Pet Cam, cấp Pet sẽ suy giảm nhất định.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">Sau khi tiến hóa Pet Cam, tiến hóa Pet không còn giới hạn cấp (Có thể tiến hoa +6 trước).</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="1">Tiến hóa Pet Cam cần tốn Tinh Thánh Quang, 4 Pet tương tự (Chưa tiến hóa, chưa tăng cấp). Thuốc Tiến Hóa và các nguyên liệu khác.</T><BR></BR>
]],
ASCENDING36 = "Số lần mua giới hạn đạo cụ không đủ, không thể mua nhanh",
ASCENDING37 = "Tăng phẩm",
ASCENDING38 = "Tím",
ASCENDING39 = "Lam",
ASCENDING40 = "Lục",
ASCENDING41 = "Trước khi tăng phẩm",
ASCENDING42 = "Sau khi tăng phẩm",
MAX_MOUTH_CARD = "Thẻ Tháng còn hiệu lực trên %d ngày, không cần gia hạn",
ATTACH_EGG_SCORE = "Điểm thưởng:",
TARGET_HURT_HP = "Sát thương SL mục tiêu:",
EGG_SCORE = "Điểm thưởng:",
EXCHANGEEXP_TEXT1 = "Chuyển hóa EXP",
EXCHANGEEXP_TEXT2 = "Chuyển hóa nhanh",
EXCHANGEEXP_TEXT3 = "Chuyển hóa",
EXCHANGEEXP_TEXT4 = "iEXP dư ra hiện tại: %d",
EXCHANGEEXP_TEXT5 = "Chuyển hoa lần %d",
EXCHANGEEXP_TEXT6 = "%s không đủ, không thể chuyển %s",
EXCHANGEEXP_TEXT7 = "Tốn %d%s, nhận %d%s, tiếp tục?",
EXCHANGEEXP_TEXT8 = "Chuyển hóa EXP",
EXCHANGEEXP_TEXT9 = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Khi EXP nhân vật nhận đat giới hạn, sẽ bảo lưu EXP dư ra.</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> EXP dư ra được bảo lưu không thể dùng tăng cấp nhân vật.</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Có thể dùng EXP dư ra chuyển thành Điểm Tu Luyện, tiêu hao của mỗi lần sẽ tăng theo số lần chuyển.</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 0 giờ mỗi ngày tạo mới số lần đổi.</T><BR></BR>
]],
ASCENDING43 = "Đá Tăng Phẩm",
ASCENDING44 = "Thuốc Tăng Sao",
ASCENDING45 = "Thú Cưỡi",
ASCENDING46 = "Nuôi thú cưỡi",
ASCENDING47 = "Chọn thú cưỡi muốn tăng phẩm", 
ASCENDINGEXPLAIN5 = 
[[
<T C="127,70,26" S="20" P="1">Hệ thống Thánh Quang:</T><BR></BR>
<T C="127,70,26" S="20" P="1"> </T><BR></BR>
<T C="229,105,22" S="20" P="1">Thú cưỡi:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Thú cưỡi có thể tăng phẩm để thay đổi phẩm chất.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Sau khi tăng phẩm đến Cam, cấp cường hóa tối đa của thú cưỡi +5.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Tăng phẩm thú cưỡi cần tốn Thuốc Tăng Phẩm Thú, nguyên liệu Thánh Quang, Thuốc Tăng Sao.</T><BR></BR>
]],
ASCENDING48 = "Thú cưỡi Lục tăng sao +%d và cấp trên %d có thể\ntăng phẩm thành thú cưỡi Lam",
ASCENDING49 = "Thú cưỡi Lam tăng sao +%d và cấp trên %d có thể\ntăng phẩm thành thú cưỡi Tím",
ASCENDING50 = "Thú cưỡi Tím tăng sao +%d và cấp trên %d có thể\ntăng phẩm thành thú cưỡi Cam",
STRENGTHEN6 = "Kế thừa đồ Cam chỉ giữ phẩm chất, thuộc tính sẽ ngẫu nhiên, tiếp tục?",
PETEXPFULL = "EXP đã dư ra, hãy tự thao tác gộp Pet",
FYBER_TIP1 = "Phát video có thể nhận thưởng sau",
FYBER_TIP2 = "Còn được nhận thưởng %d lần",
FYBER_TIP3 = "Tải video thất bại, hãy thử lại",
LEAGUE114 = "Giải đấu Anh Hùng mùa 1",
LEAGUE115 = "Chiến đội:",

COPYENTRY_NAME = "Mirya",
COPYENTRY_DIALOG = "Phía trước thật thênh thang, chúc bạn may mắn!~",
FAST_CHAT_1 = "Chú ý hướng gió!",
FAST_CHAT_2 = "Tập trung đánh địch yếu nhất!",
FAST_CHAT_3 = "Cùng tấn công kẻ địch bắn cuối cùng!",
FAST_CHAT_4 = "Chuẩn bị phối hợp đào!",
FAST_CHAT_5 = "Vị trí tệ quá, chú ý chia ra!",
FAST_CHAT_6 = "Chú ý sinh lực, bảo vệ bản thân!",
FAST_CHAT_7 = "Chú ý điểm hành động, phối hợp nhịp nhàng nha!",
FAST_CHAT_8 = "Cố lên, chúng ta sẽ thắng!",
FAST_CHAT_9 = "Xem anh (chị) biểu diễn đây!",
FAST_CHAT_10 = "Đừng lo, anh (chị) đây cân hết!",
FAST_CHAT_11 = "Rất vinh hạnh được sát cánh chiến đấu với các bạn!",
FAST_CHAT_12 = "Quả là một trận chiến đấu kịch tính!",
SUMMON_1 = "Nhận Trang Bị",
SUMMON_2 = "Gọi Pet",
SUMMON_3 = "Cầu Phúc Thần Bí",

PVP_HALL_1 = "Trường Huấn Luyện",
PVP_HALL_2 = "Quan chiến",
PVP_HALL_3 = "Tiệm Thi Đấu",
PVP_HALL_4 = "Đấu Điểm",
PVP_HALL_5 = "Giải Trí",
PVP_HALL_6 = "Tranh Đua Lực Chiến, Kẻ Mạnh Làm Vua",
PVP_HALL_7 = "Cách Chơi Đa Dạng, Phần Thưởng Phong Phú",
PVP_HALL_8 = "Thực Lực Là Vua, Vinh Dự Tối Thượng",
PVP_HALL_9 = "Đấu Trường",
PVP_HALL_10 = "Ghép phòng",
PVP_HALL_11 = "Tổ đội cùng bạn",
PVP_HALL_12 = "Ghép đơn",
PVP_HALL_13 = "Ngẫu Nhiên",
PVP_HALL_14 = "Đào Hố",
PVP_HALL_15 = "Đội Trưởng",
PVP_HALL_16 = "Đạo Cụ",
PVP_HALL_17 = "Loạn Đấu",
PVP_HALL_18 = "Hồi Sinh",
PVP_HALL_19 = "Không sát thương, chỉ đào hố",
PVP_HALL_20 = "Đội trưởng phải bị tiêu diệt",
PVP_HALL_21 = "Đoạt thì sẽ được",
PVP_HALL_22 = "Ta là bất tử",
PVP_HALL_23 = "Còn 1 lần chiến đấu",
PVP_HALL_24 = "Mở Theo Sự Kiện",
PVP_HALL_25 = [[<T C="255,236,193" S="20" P="0" >Thứ 2</T>]],
PVP_HALL_26 = [[<T C="255,236,193" S="20" P="0" >Thứ 3</T>]],
PVP_HALL_27 = [[<T C="255,236,193" S="20" P="0" >Thứ 4</T>]],
PVP_HALL_28 = [[<T C="255,236,193" S="20" P="0" >Thứ 5</T>]],
PVP_HALL_29 = [[<T C="255,236,193" S="20" P="0" >Thứ 6</T>]],
PVP_HALL_30 = "Giải Trí",
PVP_HALL_31 = [[<T C="255,236,193" S="20" P="0" SC="127,70,26" SE="1" SS="4">Điểm Dũng Sĩ: %d/%d</T>]],
PVP_HALL_32 = [[<T C="255,236,193" S="18" P="0" SC="127,70,26" SE="1" SS="4">Điểm Dũng Sĩ (Đạt %d điểm=%d Sao)</T>]],
PVP_HALL_33 = [[<I Z="1">ui/pvp/event_icon_s1sj_s.png</I><A IMG = "ui/common_num/common_num_jccsz.png" Z ="1" W = "26" H = "44" CHAR = "0">%d</A><I Z="1">ui/pvp/event_icon_s1sj_sj.png</I>]],
PVP_HALL_34 = "Dạng này chưa được mở",
PVP_HALL_35 = [[<T C="255,236,193" S="20" P="0" >Lv%d mở</T>]],
PVP_HALL_36 = "Đối Kháng Tự Do",
PVP_HALL_37 = "Cách Chơi Phong Phú, Niềm Vui Bất Tận",
PVP_HALL_38 = "Xếp Hạng Thực Lực",


BAGTIP5 = [[<T C="255,89,74" S="20" P="0">%d món tăng thêm (</T><T C="255,236,193" S="20" P="0">%d</T><T C="255,89,74" S="20" P="0">/%d)</T>]],
BAGTIP6 = [[<T C="255,89,74" S="20" P="0">%d món tăng thêm (%d/%d)</T>]],
BAGTIP7 = [[Dùng sẽ nhận tất cả thưởng]],
BAGTIP8 = [[Dùng nhận ngẫu nhiên 1 phần thưởng]],
BAGTIP9 = [[Thông tin]],
BAGTIP10 = [[ID người chơi: ]],
BAGTIP11 = [[ID người chơi]],
BAGTIP12 = [[Thành công: ]],
BAGTIP13 = [[Ghép nhanh]],
BAGTIP14 = [[(VIP3 được ghép nhanh)]],
BAGTIP15 = [[Ghép tốn: ]],
BAGTIP16 = [[Chọn cách phối màu]],
BAGTIP17 = [[Dùng nhuộm màu]],
BAGTIP18 = [[Màu gốc]],
BAGTIP19 = [[Biểu Cảm và Cánh không thể nhuộm màu, thời trang quá hạn sẽ trở về màu gốc]],
BAGTIP20 = [[Bắt đầu nhuộm]],
BAGTIP21 = [[Xem trước phối màu]],
BAGTIP22 = [[Trang phục hiện tại có thời trang chưa mua, mua ngay?]],
BAGTIP23 = [[Nhuộm thời trang]],
BAGTIP24 = [[Không có thời trang, không thể nhuộm]],
BAGTIP25 = [[Phối màu]],
BAGTIP26 = [[Thông tin thời trang người chơi]],
BAGTIP27 = [[Hiển thị thời trang hiện tại]],
BAGTIP28 = [[Lực chiến thời trang tối đa:]],
BAGTIP29 = [[Thời trang đã sưu tập]],
BAGTIP30 = [[Tổng lực chiến thời trang:]],
BAGTIP31 = [[Số lượng tóc:]],
BAGTIP32 = [[Số lượng biểu cảm:]],
BAGTIP33 = [[Số lượng trang phục:]],
BAGTIP34 = [[Số lượng cánh:]],
BAGTIP35 = [[Nhận chat riêng]],
BAGTIP36 = [[Đã ẩn (Đăng nhập lần này)]],
BAGTIP37 = [[Hủy ẩn]],
BAGTIP39 = [[Vị trí này chưa có thời trang, mua ngay?]],
BAGTIP38 = [[Chọn thời trang cần nhuộm]],
BAGTIP40 = [[Nhuộm thành công]],
BAGTIP41 = [[Sau]],
BAGTIP42 = [[Màu hiện tại:]],
BAGTIP43 = [[Hiển thị]],
BAGTIP44 = [[Thời trang hiện tại không thể nhuộm]],
BAGTIP45 = [[Không thể nhuộm màu]],
BAGTIP46 = [[Hãy chọn ghép nhanh]],
BAGTIP47 = [[Số lượng thu hồi]],
BAGTIP48 = [[Đặt vào]],
BAGTIP49 = "Nhập số lượng",

CHALLENGEENTRANCE_TITLE = "Khiêu chiến",
CHALLENGEENTRANCE_TEXT1 = "Tháp Thí Luyện",
CHALLENGEENTRANCE_TEXT2 = "BOSS Thế Giới",

COMMUNITYINFO146 = [[Tố cáo]],
COMMUNITYINFO147 = [[Đang chờ tố cáo, xin hãy đợi!]],
COMMUNITYINFO148 = [[<T C="79,60,48" S="22" P="0">Chủ hội </T><T C="1,72,4" S="22" P="0">%s</T><T C="79,60,48" S="22" P="0"> đã rời mạng </T><T C="1,72,4" S="22" P="0">%s</T><T C="79,60,48" S="22" P="0"> ngày, muốn tố cáo?</T>]],
COMMUNITYINFO149 = [[Số người tố cáo:]],
COMMUNITYINFO150 = [[Cống hiến trong ngày ≥2000 có thể tố cáo]],
COMMUNITYINFO151 = [[Đã tố cáo]],
VIP_TIP09 = [[Quà]],
VIP_TIP10 = [[Phúc Lợi tuần]],
VIP_TIP11 = [[(Gửi qua thư trong 1 lần)]],
VIP_TIP12 = [[(Gửi qua thư vào mỗi thứ 2)]],
EQUIP_THE_SAME_ATT = "Xung đột với Châu Cầu Phúc trên người",
FYBER_REWARD = "Thưởng quảng cáo",
PETSKILL_DES = 
[[
<T C="127,70,26" S="20" P="0">Quy tắc Lĩnh Ngộ</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0"> Pet tăng bậc đến +1, +3, +5, +6 lần lượt mở 1 ô kỹ năng Pet.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0"> Lĩnh ngộ có thể ngẫu nhiên thay đổi kỹ năng Pet.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0"> Mỗi lần lĩnh ngộ tốn 1 Sách Lĩnh Ngộ.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0"> Nếu có kỹ năng muốn giữ lại có thể chọn khóa hoàn toàn để khóa.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0"> Sau khi khóa hoàn toàn, mỗi lần lĩnh ngộ sẽ tốn thêm Đá Khóa Skill, số lượng tương đương với số lượng kỹ năng khóa.</T><BR></BR>
<T C="229,105,22" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0"> Nếu có loại kỹ năng muốn giữ lại, nhưng muốn thay đổi cấp có thể chọn Khóa loại để khóa.</T><BR></BR>
<T C="229,105,22" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0"> Sau khi khóa loại, mỗi lần lĩnh ngộ sẽ tốn thêm Đá Khóa Sao, số lượng tương đương với số lượng kỹ năng khóa đã chọn.</T><BR></BR>
]],

BUYACTIVITY_RETURN = [[<T C="255,255,255" S="22" P="1" SC="105,65,46" SS="4" SE="1">Tốn </T><I Z="0.45" P="1">%s</I><T C="255,255,255" S="22" P="1" SC="105,65,46" SS="4" SE="1">%d/%d   Hoàn trả %d</T><I Z="0.45" P="1">%s</I>]],
TEACH_170 = "Nhấn đến Mạo Hiểm-Đơn",
TEACH_171 = "Nhấn đến Đấu Tự Do",
TEACH_172 = "Nhấn mở Rương May Mắn",
TEACH_173 = "Nhấn đến phó bản nhóm",
TEACH_174 = "Nhấn đến Bí Cảnh Mạo Hiểm",
TEACH_175 = "Nhấn vào Tháp Thí Luyện",
TEACH_176 = "Nhấn khiêu chiến BOSS Thế Giới",
TEACH_177 = "Nhấn mở lối triệu hồi",
TEACH_178 = "Chọn thẻ",

WORLDBOSS_TITLE = "BOSS Thế Giới",

FRIENDS_TEXT1 = "Tìm kiếm",
FRIENDS_TEXT2 = "Server",
FRIENDS_TEXT3 = "Xin kết bạn",
FRIENDS_TEXT4 = "Mời bạn thân",
FRIENDS_TEXT5 = "Tặng Thể Lực",
FRIENDS_TEXT6 = "Số bạn thân",
FRIENDS_TEXT6 = "Số bạn thân",
FRIENDS_TEXT7 = "Đồng ý nhanh",
FRIENDS_TEXT8 = "Từ chối nhanh",
FRIENDS_TEXT9 = "Chỉ thiết lập nhắc online đối với bạn trong server",
FRIENDS_TEXT10 = "Đã thiết lập số lượng nhắc online",
FRIENDS_TEXT11 = "Làm Đệ Tử",
FRIENDS_TEXT12 = "Làm Sư Phụ",

FRIENDS_TEXT13 = 
[[
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">1.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Từ Lv10-24 chưa có quan hệ sư đồ có thể bái sư</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">2.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Người được bái sư cần ≥ Lv25 và chưa đủ đệ tử</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">3.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Đệ tử Lv25 tự xuất sư, sau khi xuất sư 2 bên sư đồ nhận quà xuất sư</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">4.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Đệ tử có thể nhận BUFF Sư Môn, cấp sư đức sư phụ càng cao hiệu quả BUFF càng cao</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">5.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Sau khi làm đệ tử sẽ có nhiệm vụ và mục tiêu sư đồ, hoàn thành nhận nhiều EXP</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">6.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Sau khi làm đệ tử, được sư phụ truyền dạy sẽ nhận nhiều EXP</T><BR></BR>
]],
FRIENDS_TEXT14 = 
[[
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">1.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Người Lv25 trở lên và chưa nhận đủ đệ tử</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">2.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Người bái sư phải trên Lv9 và nhỏ hơn Lv25, không có quan hệ sư đồ</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">3.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Sư phụ có thể được tăng thuộc tính từ cấp Sư Đức, cấp sư đức càng cao nhận càng nhiều thuộc tính</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">4.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Đệ tử tốn Thể Lực, sư phụ sẽ nhận Thể Lực</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">5.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Đệ tử lên cấp hoặc kính biếu sư phụ, sư phụ được nhận sư đức.</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">5.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Sau khi làm sư phụ, truyền dạy cho đệ tử sẽ được nhiều sư đức</T><BR></BR>
]],
FRIENDS_TEXT15 = "Đã xuất sư",
FRIENDS_TEXT16 = "Truyền Dạy",
FRIENDS_TEXT17 = "Xem phúc lợi sư đức",
FRIENDS_TEXT18 = "Danh sách xin phép",
FRIENDS_TEXT19 = "Nhận đệ tử",
FRIENDS_TEXT20 = "Đồng môn",
--FRIENDS_TEXT21 = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1">Số người xuất sư sư đức Lv%d: %d</T>]],
FRIENDS_TEXT22 = "Danh sách xuất sư",
FRIENDS_TEXT21 = [[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1">Số người xuất sư sư đức Lv%d: %d</T>]],


MULTI_WIN_GOAL1 = "Dễ",
MULTI_WIN_GOAL2 = "Khó",
MULTI_WIN_GOAL3 = "Ác Mộng",
UNCOMPLETE =  "Chưa xong",
Daily_GOAL1_1 = "Sát thương đạt: %d/%d",
Daily_GOAL1_2 = "Số lượt: %d/%d",
Daily_GOAL1_3 = "Đã diệt: %d/%d",
Daily_GOAL1_4 = "Tổng Vàng được thưởng: ",

Daily_GOAL2_1 = "Đã diệt: %d/%d",
Daily_GOAL2_2 = "Sinh lực còn: %d/%d",
Daily_GOAL2_3 = "Đã thoát: %d/%d",
Daily_GOAL2_4 = "Tổng EXP được thưởng: ",

Daily_GOAL3_1 = "Sinh lực còn: %d/%d",
Daily_GOAL3_2 = "Trứng đã đập: %d/%d",
Daily_GOAL3_3 = "Đã diệt: %d/%d",
Daily_GOAL3_4 = "Tổng Trứng Pet được thưởng: ",

BATTLE_HURT_TARGET = "Mục tiêu sát thương: ",
BATTLE_KILL_COPPER_MONSTER = "Đã diệt: ",
BATTLE_KILL_NUM = "Đã diệt: ",
BATTLE_REMAIN_HP_PRE = "Sinh lực còn: ",
BATTLE_RUN_NUM = "Đã thoát: ",
BATTLE_PET_EGG_NUM = "Trứng đã đập: ",
BATTLE_KILL_MONSTER = "Đã diệt: ",

COMMUNITYINFO152 = [[Xin vào]],
COMMUNITYINFO153 = [[Sảnh]],
COMMUNITYINFO154 = [[Tăng Cấp]],
COMMUNITYINFO155 = [[Quản Lý]],
COMMUNITYINFO156 = [[Thiết Lập]],
COMMUNITYINFO157 = [[Cống hiến Thể Lực trong ngày: ]],
COMMUNITYINFO158 = [[Quảng Trường Công Hội]],
COMMUNITYINFO159 = [[Phó bản Công Hội]],
COMMUNITYINFO160 = [[Thông Báo Công Hội Chiến]],
COMMUNITYINFO161 = [[Đang diễn ra Công Hội Chiến]],
COMMUNITYINFO162 = [[Người chơi/Cấp/Chức]],
COMMUNITYINFO163 = [[Tăng cấp Sảnh Công Hội sẽ trở nên mạnh hơn, chứa càng nhiều người và được càng nhiều phúc lợi.]],
COMMUNITYINFO164 = [[Tăng cấp Vật Tổ Công Hội, người lễ bái nhận được lực chiến mạnh hơn]],
COMMUNITYINFO165 = [[Sau khi tăng cấp Trường Công Hội có thể dùng cống hiến tăng cấp kỹ năng Công Hội]],
COMMUNITYINFO166 = [[Tăng cấp Tiệm Công Hội nhận thêm càng nhiều ưu đãi]],
COMMUNITYINFO167 = [[Sảnh Công Hội]],
COMMUNITYINFO168 = [[Trường Công Hội]],
COMMUNITYINFO169 = [[Mở khóa Sảnh Công Hội Lv%d]],
COMMUNITYINFO170 = [[Đã đạt cấp tối đa]],
COMMUNITYINFO171 = [[Thành viên: ]],
COMMUNITYINFO172 = [[Tố cáo Chủ Hội]],
COMMUNITYINFO173 = [[Trục xuất thành viên]],
COMMUNITYINFO174 = [[Xem cống hiến]],
COMMUNITYINFO175 = [[Bổ nhiệm 1]],
COMMUNITYINFO176 = [[Danh sách xin phép 1]],
COMMUNITYINFO177 = [[Thư nhóm]],
COMMUNITYINFO178 = [[Thiết lập cơ bản]],
COMMUNITYINFO179 = [[Tên Công Hội: ]],
COMMUNITYINFO180 = [[Điều kiện xin phép: ]],
COMMUNITYINFO181 = [[Cấp bậc trở lên,]],
COMMUNITYINFO182 = [[Duyệt]],
COMMUNITYINFO183 = [[Thông báo Công Hội (Nội bộ)]],
COMMUNITYINFO184 = [[Tuyên ngôn Công Hội (Nội bộ)]],
COMMUNITYINFO185 = [[Góp Kim Cương-Cao]],
COMMUNITYINFO186 = [[Góp Kim Cương]],
COMMUNITYINFO187 = [[Góp Vàng]],
COMMUNITYINFO188 = [[Công Hội tăng %d danh vọng]],
COMMUNITYINFO189 = [[Cá nhân tăng %d cống hiến]],
COMMUNITYINFO190 = [[Nhiệm vụ]],
COMMUNITYINFO191 = [[Quỹ]],
COMMUNITYINFO192 = [[Quỹ Tuần]],

WNDCHECKOTHER50 = "Thay đổi vũ khí",
FRIENT_CHAT = "Liên hệ gần đây",
ASSISTANT2 = "Trợ thủ",

WORLD_LEVEL_WEEK = "Điểm Tuần",
WORLD_LEVEL = "Bảng Điểm",
HISTORY_WEEK_RANKG = "Nhật Ký Điểm Tuần",
RANGK_REWARD = "Thưởng BXH",

COMMUNITY_UPDATE_TIP = [[Trường Kỹ Năng Công Hội Lv%d, kỹ năng được tăng tối đa đến Lv%d]],
SECRETSCENE = "Bí Cảnh",

COMMUNITYINFO193 = [[Danh sách Công Hội]],
COMMUNITYINFO194 = [[Công Hội đề cử]],
COMMUNITYINFO195 = [[Cấp/Công Hội/ID]],
COMMUNITYINFO196 = [[Số người]],
COMMUNITYINFO197 = [[Giới hạn]],
COMMUNITYINFO198 = [[Tuyên ngôn Công Hội]],


BAG4 = "Thời Trang",
BAG5 = "Cầu Phúc",
BAG6 = "Danh Hiệu",
BAG7 = "Pet",
BAG8 = "Thú Cưỡi",
BAG9 = "Thay đổi",
BAG10 = "Nuôi Dưỡng",
BAG11 = "Xem kỹ năng",
BAG12 = "Thuộc tính nhân vật",
BAG13 = "Thuộc tính thời trang",
BAG14 = "Thời trang lực chiến cao nhất",
BAG15 = "Thu thập thuộc tính thời trang",
BAG16 = "Lực chiến thời trang:",
BAG17 = "Quá hạn",
BAG18 = "Nhuộm",
BAG19 = "Quà",

COMMUNITYINFO199 = [[Số người xin phép:]],
COMMUNITYINFO200 = [[Thành viên:]],
COMMUNITYINFO201 = [[Người chơi/Cấp/Lực chiến]],
COMMUNITYINFO202 = [[Cấp thi đấu]],
COMMUNITYINFO203 = [[Cấp bậc]],
COMMUNITYINFO204 = [[Lời nhắn]],




TASK_TEXT1 = "Trưởng Thành",
TASK_TEXT2 = "Mạnh Hơn",
TASK_TEXT3 = "Tài Nguyên",
TASK_TEXT4 = "Lv%d kích hoạt nhiệm vụ",
TASK_TEXT5 = "Thành Tựu Lv%d",
TASK_TEXT6 = "Thuộc tính cấp thành tựu tăng: ",
TASK_TEXT7 = "Hạng Toàn Server",
TASK_TEXT8 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Năng động: </T><T C="99,255,95" S="22" P="1" SC="0,72,3" SS="4" SE="1">%d</T>]],
TASK_TEXT9 = "Thưởng Lv%d",
TASK_TEXT10 = "Nhiệm vụ Lv%d",
TASK_TEXT11 = "Mở tính năng Lv%d",
TASK_TEXT12 = "Mỗi Ngày",
TASK_TEXT13 = "Chính Tuyến",
TASK_TEXT14 = "Thành Tựu",
TASK_TEXT15 = "Cấp này không mở thêm tính năng",
TASK_TEXT16 = "Cấp này không được thưởng tăng cấp",
TASK_TEXT17 = "Cấp này không có nhiệm vụ",

STRENGTEN1 = "Cường Hóa",
STRENGTEN2 = "Tăng Sao",
STRENGTEN3 = "Khảm",
STRENGTEN4 = "Đổi Phẩm",
STRENGTEN5 = "Rèn",

STRENGTEN6 = "Cường hóa 5 lần",

RULE = "Quy tắc",
COMMUNITY_STORE = "Tiệm Công Hội",
PET_STORE = "Tiệm Pet",
REFRESH_COUNT = "Số lần tạo mới",

AUTO_REFRESH_COUNT_DOWN = "Tự tạo mới còn",

EVERYDAY_REFRESH_TIME = "(Tạo mới vào %s giờ mỗi ngày)",

EVERYDAY_REFRESH_TIME2 = "(Tạo mới vào %s giờ, %s giờ, %s giờ, %s giờ mỗi ngày)",


NEW_SHOP_1 = "Ngẫu nhiên",
NEW_SHOP_2 = "Khôi phục",
NEW_SHOP_3 = [[<T C="255,236,193" S="26" P="0" SC="79,60,48" SE="1" SS="4">Mặc thử: %d món</T>]],
NEW_SHOP_4 = "Đề Cử",
NEW_SHOP_5 = "Đạo Cụ",
NEW_SHOP_6 = "Mua Giới Hạn",
NEW_SHOP_7 = "Tặng",
NEW_SHOP_8 = "Bán Chạy",
NEW_SHOP_9 = "Tân Thủ",
NEW_SHOP_10 = [[<I Z="0.5" P="2">%s</I><T C="99,255,96" S="18" P="1" SC="0,72,3" SE="1" SS="4">%d</T>]],
NEW_SHOP_11 = "Thử",

COST_ITEM_NOTENOUGH = "Đạo cụ %s không đủ, tạo mới thất bại!",
ASSISTANT = "Hỗ Trợ",
TACTICS = "Chiến Thuật",
WEAPON_LIST = "Danh sách vũ khí",
OBTAIN = "Nhận",

FINISH_ACHIEVEMENT_TIPS = "Xong thành tựu có thể nhận thêm điểm kỹ năng thành tựu",
PETRECOVERNUM = "Đã chọn thu hồi:",
PET_REFRESH_COST = [[<T S="24" C="127,70,26" P="1">Dùng %d Tinh Hoa Pet tạo mới Tiệm?</T><BR></BR><BL>48</BL><T S="24" C="127,70,26" P="1"> (Đã tạo mới %d lần)</T>]],
GAME_ACTIVITY_TITLE39 = "Tiệm Chợ Đen",

CALL_TEXT1 = "Trang Bị",
CALL_TEXT2 = "Pet",
CALL_TEXT3 = "Cầu Phúc",
CALL_TEXT4 = "Đã được trải nghiệm cảm giác tiêu tiền như nước!",
CALL_TEXT5 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1"></T><T C="99,255,95" S="22" P="1" SC="127,70,26" SS="4" SE="1">%d</T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1"> lần nữa được ngay </T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Đồ Tím</T>]],
CALL_TEXT6 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Lần này được ngay </T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Đồ Tím</T>]],
CALL_TEXT7 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Có cơ hội nhận </T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Đồ Tím</T>]],
CALL_TEXT8 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Rút x10 được ngay </T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Đồ Tím</T>]],
CALL_TEXT9 = [[<I Z="0.6" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">%s</T>]],
CALL_TEXT10 = [[<T C="255,89,74" S="22" P="1" SC="127,70,26" SS="4" SE="1">%s</T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1"> sau được miễn phí</T>]],
CALL_TEXT11 = "Rút x1",
CALL_TEXT12 = "Rút x10",

NEW_MOUNT1 = "Tổng lực chiến: %d",
BAG19 = "Quà",
NEW_MOUNT2 = "Thuộc tính",
NEW_MOUNT3 = "Nuôi Thú Cưỡi",
NEW_MOUNT4 = [[<T C="79,60,48" S="20" P="1">%d</T><I Z="0.65" P="2">ui/common/common_icon_xingxing2.png</I>]],
NEW_MOUNT5 = [[<T C="0,72,3" S="20" P="1">%d</T><I Z="0.65" P="2">ui/common/common_icon_xingxing2.png</I>]],
PUT_SELL_MATERIAL = "Hãy đặt vào vật phẩm muốn thu hồi",
WNDEXPIRED1 = "Thời trang hết hạn",
WNDEXPIRED2 = "Sắp hết hạn",
WNDEXPIRED3 = "Gia hạn hết",
WNDCHECKOTHER1 = "Thông tin",
WNDCHECKOTHER2 = "Chi tiết",
WNDCHECKOTHER3 = "Chiến tích",
WNDCHECKOTHER4 = "Quan hệ",
WNDCHECKOTHER5 = "Sư Đồ",
WNDCHECKOTHER6 = "Trang cá nhân",
WNDCHECKOTHER7 = "Công Hội:",
WNDCHECKOTHER8 = "Bạn đời:",
WNDCHECKOTHER9 = "Giới tính:",
WNDCHECKOTHER10 = "Tuổi:",
WNDCHECKOTHER11 = "Chòm sao:",
WNDCHECKOTHER12 = "Khu vực:",
WNDCHECKOTHER13 = "Voice:",
WNDCHECKOTHER14 = "Biên tập",
WNDCHECKOTHER15 = "Đổi tên",
WNDCHECKOTHER16 = [[<T C="255,227,116" S="22" P="1">Tổng lực chiến  </T><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="0.9" W = "16" H = "26" CHAR = "0" >%d</A>]],
WNDCHECKOTHER17 = "Vợ chồng",
WNDCHECKOTHER18 = "Đồng chí",

FIGHT_COPY = "Phó bản",
FIGHT_COPY_1 = "Mạo Hiểm-Đơn", 
FIGHT_COPY_2 = "Mạo Hiểm-Nhóm",
FIGHT_COPY_3 = "Bí Cảnh",
E_DRAW = "Ác Mộng",

MONSTER = "Quái",

PASS_LEVEL_TAGET = "Mục tiêu vượt ải",
PREPARE_FOR_WAR = "Chuẩn bị chiến",
WNDCHECKOTHER19 = "Số trận: ",
WNDCHECKOTHER20 = "First Blood: ",
WNDCHECKOTHER21 = "Double Kill: ",
WNDCHECKOTHER22 = "Triple Kill: ",
WNDCHECKOTHER23 = "Tỉ lệ thắng: ",
WNDCHECKOTHER24 = "Tỉ lệ diệt: ",
WNDCHECKOTHER25 = "Tỉ lệ đào: ",
WNDCHECKOTHER26 = "Tỉ lệ chính xác: ",
WNDCHECKOTHER27 = "Tỉ lệ tử vong: ",
WNDCHECKOTHER28 = "Toàn bộ thi đấu",

DROP_OUT = "Rơi",

RESERT_TIP = "Số lần khiêu chiến còn 0 mới được tạo mới",

FANPAI = "Lật thẻ",
WNDCHECKOTHER29 = "Đệ tử",
WNDCHECKOTHER30 = "Cấp sư đức: ",
WNDCHECKOTHER31 = "EXP sư đức: ",
WNDCHECKOTHER32 = "Danh hiệu sư đức: ",
WNDCHECKOTHER33 = "Thuộc tính cấp: ",
WNDCHECKOTHER34 = "Nhỏ",
WNDCHECKOTHER35 = "Đang lớn",
WNDCHECKOTHER36 = "Trưởng thành",
WNDCHECKOTHER37 = "Hoàn chỉnh",
WNDCHECKOTHER38 = "Tạm không có quan hệ vợ chồng",
WNDCHECKOTHER39 = "Tạm không có quan hệ đồng chí",
WNDCHECKOTHER40 = "Tình Cảm Lv%d",
WNDCHECKOTHER41 = "Thân mật",
WNDCHECKOTHER42 = "Sư phụ: ",
WNDCHECKOTHER43 = "Sư phụ tăng thêm thuộc tính: ",
WNDCHECKOTHER44 = "Sau Lv25 mới được nhận đệ tử",
WNDCHECKOTHER45 = "Lưu thành công",
WNDCHECKOTHER46 = "Tạm không",
WNDCHECKOTHER47 = "Đệ tử đã xuất sư",
WNDCHECKOTHER48 = "Thay đổi Pet",
WNDCHECKOTHER49 = "Thay đổi thú cưỡi",
FRIENDS_BESTFRIEND = "Thêm bạn thân",
FRIENDS_BESTFRIEND2 = "Thân mật cần đạt ",
FRIENDS_BESTFRIEND3 = "Đã chọn bạn thân",
FRIENDS_BESTFRIEND4 = "Thêm bạn thân thành công",
FRIENDS_BESTFRIEND5 = [[<T C="127,70,26" S="20" P="1">lời mời kết bạn (danh sách bạn bè còn %d chỗ)</T>]],
FRIENDS_BESTFRIEND6 = [[<T C="127,70,26" S="20" P="1">Hủy quan hệ bạn thân</T>]],
FRIENDS_BESTFRIEND7 = "Có tối đa %d bạn thân",
FRIENDS_BESTFRIEND8 = "Mời bạn thân",
FRIENDS_BESTFRIEND9 = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Tối đa được thêm 3 bạn thân, bạn thân có hiển thị hiệu quả</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Bạn thân tặng Thể Lực sẽ được x2 thân mật và Thể Lực</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Bạn thân tổ đội chiến đấu được x2 thân mật</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Trở thành bạn thân 2 bên cần đạt 500 thân mật</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Vợ chồng không thể trở thành bạn thân</T><BR></BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> Thân mật đạt nhất định sẽ mở danh hiệu đặc biệt</T><BR></BR>
<T C="229,105,22" S="22" P="0">7.</T><T C="127,70,26" S="22" P="0"> Lv30 mới được thêm bạn thân</T><BR></BR>
]],
FRIENDS_BESTFRIEND10 = "Số bạn thân đã đạt tối đa",
FRIENDS_BESTFRIEND11 = "Mời bạn thân thành công",
FRIENDS_BESTFRIEND12 = "Chưa phải là bạn bè!",
FRIENDS_BESTFRIEND13 = "Thân mật chưa đạt điều kiện",
FRIENDS_BESTFRIEND14 = "Quan hệ vợ chồng không thể đổi thành bạn thân",
FRIENDS_BESTFRIEND15 = "Thêm bạn thân thành công",
FRIENDS_BESTFRIEND16 = "Đã từ chối làm bạn thân",
FRIENDS_BESTFRIEND17 = "Hủy quan hệ bạn thân với %s?",
FRIENDS_BESTFRIEND18 = "Hủy quan hệ bạn thân thành công",







BUYACTIVITY_RULE = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Dùng Kim Cương trong tính năng, tiến độ đầy được hoàn trả Kim Cương.</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Mỗi ngày không giới hạn số lần hoàn trả, mua nhiều trả nhiều.</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 0 giờ mỗi ngày tạo mới tiến độ.</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Mua thể lực, Mèo Chiêu Tài đều được ưu đãi hoàn trả, tiêu phí 2 tính năng khác nhau.</T><BR></BR>
]],


FRIENDS_TEXT23 = [[<T C="255,236,193" S="20" P="1">Tiêu phí trong ngày</T><I Z="0.5" P="1">shopitems/activity.png</I><T C="255,236,193" S="20" P="1">%d Thể Lực, sư phụ nhận </T><I Z="0.5" P="1">shopitems/activity.png</I><T C="255,236,193" S="20" P="1">%d Thể Lực</T>]],

BeStrongBtnNameArrays1 = {"Trang bị","Pet","Thú cưỡi","Cầu phúc","Thẻ Bài","Tu luyện","Ăn thịt"},
BeStrongBtnNameArrays2 = {"Vàng","Kim Cương","Huy Chương Cầu Phúc"},

FIGHT_TARGET = "Mục tiêu",
COMMUNITYINFO205 = [[Người chơi/Cấp/Lực chiến/Chức]],
COMMUNITYINFO206 = [[Cống hiến hôm nay/Cống hiến tuần]],
COMMUNITYINFO207 = [[3 ngày chưa đăng nhập]],
COMMUNITYINFO208 = [[3 ngày chưa cống hiến]],
COMMUNITYINFO209 = [[Ngoài Tinh Anh trở lên]],
COMMUNITYINFO210 = [[Đã hủy:]],
COMMUNITYINFO211 = [[Bỏ chọn]],
COMMUNITYINFO212 = [[Cấp vào Công Hội]],
COMMUNITYINFO213 = [[Cấp Xếp Hạng]],
COMMUNITYINFO214 = [[Duyệt không?]],
COMMUNITYINFO215 = [[Không]],
COMMUNITYINFO216 = [[Không cần]],
COMMUNITYINFO217 = [[8 giờ mỗi tối thứ 5, 6, 7 mở]],
COMMUNITYINFO218 = [[Không có tin nhắn]],
COMMUNITYINFO219 = [[Chờ Chủ Hội lên cấp]],

BAG_TITLE_SHOW = "Không hiện danh hiệu",
SKILL_TXT = "Kỹ năng",
NOT_GOODS_TIP = "Không có vật phẩm",
COMMUNITYINFO228 = [[(Tối đa 16 ký tự)]],
NOT_GOODS_TIP = "Không có vật phẩm",
FRIENDS_TEXT24 = "Không có tin mời bạn thân",
SETTING_TIPS1 = "Code Quà",
SETTING_TIPS2 = "Thêm ý kiến",
WORLDBOSS_MYHURT = [[<T C="255,227,116" S="20" P="1" SC="79,60,48" SS="4" SE="1">Sát thương: </T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">%d (Hạng %d)</T>]],
WEEK_FIGHT_LEVEL = "Bảng Điểm Tuần",
COPY_TIP = "Ta là mỹ nhân",



FRIENDS_TEXT25 = [[<T C="255,255,255" S="22" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]],
FRIENDS_TEXT26 = [[<T C="127,70,26" S="20" P="1"> mời bạn, đồng ý 2 người sẽ trở thành </T><T C="255,89,74" S="20" P="1">%s</T>]],
FRIENDS_TEXT27 = [[<T C="127,70,26" S="20" P="1"> tặng bạn </T><T C="5,180,0" S="20" P="1"> %d</T><I Z="0.45" P="1">%s</I><T C="127,70,26" S="20" P="1">, thân mật 2 người +</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"></T>]],
FRIENDS_TEXT28 = [[<T C="127,70,26" S="20" P="1"> tặng bạn quà, thân mật 2 người +</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"></T>]],
FRIENDS_TEXT29 = [[<T C="127,70,26" S="20" P="1"> tặng quà cho người ấy, thân mật 2 người +</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"></T>]],
FRIENDS_TEXT30 = [[<T C="127,70,26" S="20" P="1"> tặng cho người ấy </T><T C="5,180,0" S="20" P="1"> %d</T><I Z="0.45" P="1">%s</I><T C="127,70,26" S="20" P="1">, thân mật 2 người +</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"></T>]],
FRIENDS_TEXT31 = [[<T C="127,70,26" S="20" P="1"> cùng bạn chiến đấu, thân mật 2 người +</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"></T>]],

CURRENT_CHAT_OPEN_LEVEL = "Lv%d mở kênh chat hiện tại",
COLOR_CHAT_OPEN_LEVEL = "Lv%d mở kênh chat màu",
WHISPER_CHAT_OPEN_LEVLE = "Lv%d mở kênh chat riêng",

CHALLENGEENTRANCE_TEXT3 = "Đất Cấm",
CHALLENGEENTRANCE_TEXT4 = "Thành Bóng Đêm",
CHALLENGEENTRANCE_TEXT5 = "Tính năng này chưa mở",

MAIL_SHOP1 = "Xin rương",
MAIL_SHOP2 = "Rương Quà",
MAIL_SHOP3 = "Không nhận yêu cầu",
MAIL_SHOP4 = "Nhật ký tặng",
MAIL_SHOP5 = [[<T C="79,60,48" S="20" P="1" >%s</T><I Z="0.5">shopitems/diamond.png</I><T C="79,60,48" S="20" P="1" >,Tặng cho </T><T C="5,180,0" S="20" P="1" >%s</T>]],
CURRENT_CHAT_OPEN_LEVEL = "Lv%d mở kênh chat hiện tại",
COLOR_CHAT_OPEN_LEVEL = "Lv%d mở kênh chat màu",
WHISPER_CHAT_OPEN_LEVLE = "Lv%d mở kênh chat riêng",
ENTERTAINMENT_MATCH_1 = "Đào Hố",
ENTERTAINMENT_MATCH_2 = "Đội Trưởng",
ENTERTAINMENT_MATCH_3 = "Đạo Cụ",
ENTERTAINMENT_MATCH_4 = "Loạn Đấu",
ENTERTAINMENT_MATCH_5 = "Hồi Sinh",

ROOM_FIGHT_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc Đấu Điểm</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Đấu Điểm tiến hành ghép đồng đội và đối thủ theo cấp thi đấu của người chơi</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Có thể Góp Công Hội, có thể nhận danh vọng Công Hội và cống hiến cá nhân</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Có thể tiến hành điều chỉnh, phê duyệt trong Công Hội</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Có thể tăng cấp Công Hội, tăng cấp sẽ tăng giới hạn hội viên, đồng thời mở kiến trúc Công Hội cấp tương ứng</T><BR>10</BR>
]],

QUALIFYING_FIGHT_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Ghép đội và đối thủ theo cấp bậc người chơi</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thuộc tính người chơi được điều chỉnh cân bằng, lực thực ngang nhau</T><BR>10</BR>
]],

YULE_FIGHT_RULE1 = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Sát thương người chơi vô hiệu, chỉ cần phá địa hình tiêu diệt đối thủ</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Đấu Đào Hố ghép đội và đối thủ theo cấp thi đấu của người chơi</T><BR>10</BR>
]],

YULE_FIGHT_RULE2 = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Nếu đội trưởng tử vong chiến đấu thất bại, cần bảo vệ đội trưởng phe mình, tấn công đội trưởng phe địch</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Mỗi lần là 1 thành viên ngẫu nhiên nhận thân phận đội trưởng</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Thuộc tính đội trưởng tăng mạnh</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Đấu Đội Trưởng ghép đội và đối thủ theo cấp thi đấu của người chơi</T><BR>10</BR>
]],


YULE_FIGHT_RULE3 = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Tạo mới 3 đạo cụ ngẫu nhiên phân bố trong chiến trường, nhận hiệu quả đạo cụ từ đạn và bay</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Khi 3 đạo cụ được nhặt và tiếp tục lượt kế, sẽ tạo mới 3 đạo cụ mới</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Đấu Đạo Cụ ghép đội và đối thủ theo cấp thi đấu của người chơi</T><BR>10</BR>
]],

YULE_FIGHT_RULE5 = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Đội diệt 4 kẻ địch sẽ thắng</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Trước khi quyết định thắng thua, tử vong được hồi sinh</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Đấu Hồi Sinh ghép đội và đối thủ theo cấp thi đấu của người chơi</T><BR>10</BR>
]],

ROOM_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Người chơi có thể dùng kỹ năng chỉ định, không bị giới hạn chờ</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thưởng được nhận 1 lần, khiêu chiến lại không được thưởng</T><BR>10</BR>
]],


ENTERTAINMENT1_TEXT_1 = "",
ENTERTAINMENT1_TEXT_2 = "",
ENTERTAINMENT1_TEXT_3 = "",


ENTERTAINMENT2_TEXT_1 = "",
ENTERTAINMENT2_TEXT_2 = "",
ENTERTAINMENT2_TEXT_3 = "",


ENTERTAINMENT3_TEXT_1 = "",
ENTERTAINMENT3_TEXT_2 = "",
ENTERTAINMENT3_TEXT_3 = "",


ENTERTAINMENT4_TEXT_1 = "",
ENTERTAINMENT4_TEXT_2 = "",
ENTERTAINMENT4_TEXT_3 = "",


ENTERTAINMENT5_TEXT_1 = "",
ENTERTAINMENT5_TEXT_2 = "",
ENTERTAINMENT5_TEXT_3 = "",

--Mời Loạn Đấu (Bạn bè, Công Hội, Sảnh)
ENTERTAINMENT6_TEXT_1 = "",
ENTERTAINMENT6_TEXT_2 = "Hướng dẫn",
ENTERTAINMENT6_TEXT_3 = "Hướng dẫn",

--Mời Hồi Sinh (Bạn bè, Công Hội, Sảnh)
ENTERTAINMENT7_TEXT_1 = "",
ENTERTAINMENT7_TEXT_2 = "",
ENTERTAINMENT7_TEXT_3 = "",


FRIENDS_TEXT32 = [[Không nhận]],
GAMEACTIVITY_NEWTEXT1 = "Hoạt động",
GAMEACTIVITY_NEWTEXT2 = [[<T C="255,227,116" S="22" P="1" SC="128,54,13" SS="4" SE="1">Thời gian: </T><T C="99,255,95" S="22" P="1" SC="0,72,3" SS="4" SE="1">%d giờ %d phút</T>]],
WELFARE_NEWTEXT1 = "Phúc Lợi",
WELFARE_NEWTEXT2 = "Thi Đấu",

BATTLE_ROLE_EXP = "EXP nhân vật",
BATTLE_COPPER = "Xu Thi Đấu",
BATTLE_WEEK_AWARD = "Lợi ích tuần",
BATTLE_WEEK_AWARD_FULL = "Lợi ích tuần đạt tối đa",
BATTLE_HERO_SCORE = "Điểm Dũng Sĩ",
BATTLE_RANK_WINS = "%d liên thắng",
BATTLE_GET_MVP = "Nhận MVP",
BATTLE_RANK_KILL_SCORE = "Đạt %d Kill",
BATTLE_RANK_SCORE_DES = "100 điểm = 1 Sao",
BATTLE_RANK_UPGRADE_TIPS = "Trận này tăng %d Sao",
BATTLE_RANK_UPGRADE_TIPS_II = "Trận này tăng %d Sao và cấp bậc tăng",
BATTLE_RANK_DnGRADE_TIPS = "Trận này giảm %d Sao",
BATTLE_RANK_DnGRADE_TIPS_II = "Trận này giảm %d Sao và cấp bậc giảm",
BATTLE_GET_KILL_ACHIEVE = "Lần %d nhận %d Kill",
BATTLE_GET_VIP_ACHIEVE = "Lần %d nhận VIP",

COMMUNITYINFO220 = "Đã sửa thông báo",
COMMUNITYINFO221 = "Vào cần Lv%d",
COMMUNITYINFO222 = "Cấp bậc %s trở lên",
COMMUNITYINFO223 = "Cấp",
COMMUNITYINFO224 = "Sao",
FRIENDS_TEXT33 = [[Người này từ chối bái sư]],
FRIENDS_TEXT34 = [[Người này từ chối nhận đệ tử]],

PRACTICE_ALL_FIGHTING = "Lực chiến tu luyện",

TOWER_GOAL1_1 = "Thắng sau %d lượt: %d",
TOWER_GOAL1_2 = "Còn %d%% sinh lực: %d%%",
TRY_STRONG_OTHER = "Thử cách dưới xem!",
WNDCHECKOTHER51 = "Độ hoàn thành thông tin",
WNDCHECKOTHER52 = "Không có Pet",
WNDCHECKOTHER53 = "Không có đệ tử đã xuất sư",

COPY_GOAL1_LOSE = "Vượt phó bản",
COPY_GOAL2_LOSE = "Còn %d%% sinh lực: %d%%",
COPY_GOAL3_LOSE = "Thắng sau %d lượt: %d lần",

PVP_RANK_TEXT1 = "Tạo mới thưởng cấp bậc",
PVP_RANK_TEXT2 = [[<T C="127,70,26" S="20" P="1">Mùa Giải sẽ kết thúc lúc </T><T C="255,105,22" S="20" P="1"> %d-%d %d</T><T C="127,70,26" S="20" P="1"></T>]],
PVP_RANK_TEXT3 = [[<T C="127,70,26" S="20" P="1">Cấp bậc: </T><T C="255,105,22" S="20" P="1">%s bậc %d</T>]],
PVP_RANK_TEXT4 = [[<T C="127,70,26" S="20" P="1"> (Thắng %d%%)</T>]],
PVP_RANK_TEXT5 = [[<T C="127,70,26" S="20" P="1">Cấp bậc: </T><T C="255,105,22" S="20" P="1">%s</T>]],
PVP_RANK_TEXT6 = [[<T C="127,70,26" S="20" P="1">Hạng 1 mùa giải có thể nhận </T><T C="255,105,22" S="20" P="1">vũ khí đặc biệt</T>]],
PVP_RANK_TEXT7 = [[<T C="127,70,26" S="20" P="1">Cấp bậc đạt </T><T C="255,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1" SC="127,70,26" SS="4" SE="0"> được nhận thưởng đặc biệt</T><T C="127,70,26" S="18" P="1"> (Chỉ 1 lần)</T>]],
PVP_RANK_TEXT8 = [[<T C="127,70,26" S="20" P="1">Khi mùa giải kết thúc, đạt bậc </T><T C="255,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1" SC="127,70,26" SS="4" SE="0"> sẽ được nhận Thưởng Mùa Giải</T>]],

BLESS_AAT_TITLE = "Chúc phúc",
BLESS_AAT_TITLE = "Cầu phúc",

PETGIFT1 = "Hướng dẫn: Tư chất hiện tại ",
PETGIFT2 = " ",
PETGIFT3 = "Thuộc tính chuyển đến nhân vật",

SETTING_POSITION = "Công khai vị trí",
SETTING_MESSAGE = "Cho phép nhắn tin",
ONLINE_STATS_1 = "Bận",
PET_EXTERIOR_DESC = "Tiến hóa +%d mở",
PET_EXTERIOR_MAX = "Hoàn chỉnh",
PET_EXTERIOR_MAX2 = "Tiến hóa Pet Cam mở",
ROOM_INVITE_INFO = "Phó bản nhóm",
ROOM_INVITE_INFO_1 = "Phó bản nhóm 2222",

VipRebateDesc = "Nạp đủ %d Kim Cương",

COMMUNITYINFO225 = "Cấp chưa đạt để xin phép",
COMMUNITYINFO226 = "Cấp bậc chưa đạt để xin phép",
COMMUNITYINFO227 = "Muốn tham gia",

GIFT_TITLE = "Mua quà",
GIFT_ITEM = "Gồm quà sau",
BUY_GIFT_NO_COUNT = "Không còn lần mua",
BUY_GIFT_NO_VIP = "Cấp VIP không đủ",
GIFT_PRICE = "Mua %s",
BUY_GIFT_LIMIT1 = [[<T C="127,70,26" S="20" P="0">Còn </T><T C="229,105,22" S="20" P="0">%d</T><T C="127,70,26" S="20" P="0">个</T>]],
BUY_GIFT_LIMIT2 = [[<T C="127,70,26" S="20" P="0">Còn </T><T C="229,105,22" S="20" P="0">%d</T><T C="127,70,26" S="20" P="0">个</T>]],
BUY_GIFT_LIMIT4 = [[<T C="127,70,26" S="20" P="0">VIP%d có thể mua, còn </T><T C="229,105,22" S="20" P="0">%d</T><T C="127,70,26" S="20" P="0">个</T>]],
BUY_GIFT_LIMIT5 = [[<T C="127,70,26" S="20" P="0">VIP%d có thể mua, còn </T><T C="229,105,22" S="20" P="0">%d</T><T C="127,70,26" S="20" P="0">个</T>]],
BUY_GIFT_LIMIT6 = [[<T C="127,70,26" S="20" P="0">VIP%d có thể mua</T>]],

LAST_COUNT = "Còn %d",
RANKLIST_HOST = "Chủ nhân: ",
BATTLE_FINAL_AWARD = "Thưởng cuối cùng: ",
MARRY_WEDDING = "Kết hôn",
MY_WEDDING = "Hôn Lễ",
RELIEVE_WEDDING = "Hủy đính hôn",
MARRY = "Kết Hôn",
PLAYAYER_INFO = [[<T C="255,227,116" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s </T><T C="255,255,255" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]],
TIPS10 = [[Thể Lực đã đầy]],
TASKTIP1 = "Có thưởng có thể nhận",
TASKTIP2 = "Có nhiệm vụ đang làm",
TASKTIP3 = "Đã xong",
PLAYAYER_INFO2 = [[<T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]],
REDPACK_ATT = "Đến kênh thế giới phát\nkhẩu lệnh sẽ nhận Lì Xì",
REDPACK_ATT2 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Còn có thể nhận Lì Xì: </T><T S="20" C="99,255,95" P="1" SC="79,60,48" SS="4" SE="1">%d/%d</T>]],
REDPACK_ATT3 = [[<T C="255,255,255" S="20" P="1" SC="158,0,0" SS="4" SE="1">%s</T><T C="255,255,255" S="20" P="1" SC="158,0,0" SS="4" SE="1"> sau có thể nhận thêm</T>]],
REDPACK_ATT4 = "Nhập ",
GUILD_SKILL_OPEN_TIP = "Công Hội Lv%d mở",

TEAM_BOSS_SIMPLE = "Vượt ải Thường",
TEAM_BOSS_NORMAL = "Vượt ải Khó",
TEAM_BOSS_HARD = "Vượt ải Địa Ngục",
DYEING = "Biểu cảm và cánh không thể nhuộm, thời trang quá hạn sẽ trở về màu gốc",

NEEDSTONE = "Đá không đủ",
BLOCTIPS = "Tính năng này cần cài đặt bản mới nhất",
CHAT_LATELY_PEOPLE = "Liên hệ gần đây",
ASSISTANT2 = "Trợ thủ",
LUCKY_GIFT = "Hộp Quà Tết",
LUCKYGIFT_HASDRAW = "Rút thưởng lần %d",
LUCKYGIFT_FREEDRAW = "%d lần",
LUCKYGIFT_FREE = "Lật thẻ miễn phí còn: ",
LUCKYGIFT_RESET = "Thời gian tạo mới hộp quà: ",
LUCKYGIFT_BOMB = "Rút phải Bomb, hôm nay không thể rút thưởng",
LUCKYGIFT_STARTDRAW = "Lật thẻ",
LUCKYGIFT_DES = 
[[
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hộp Quà May Mắn mỗi ngày tạo mới lúc 24 giờ</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Lật thẻ quà cần tốn Kim Cương, lật thẻ càng nhiều tiêu phí càng nhiều</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Mỗi ngày có số lần lật thẻ quà miễn phí nhất định</T><BR>10</BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Sau khi rút được Thẻ Tỉ Lệ, giá lật thẻ sẽ nhân với số trên Thẻ Tỉ Lệ</T><BR>10</BR>
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">Khi nhận Xu Ban Ân có thể dùng mua vật phẩm trong Cửa Hàng</T><BR>10</BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">Xác suất thưởng</T><BR>10</BR>
<T C="127,70,26" S="18"> Xu Ban Ân  1.3% </T><BR>10</BR>
<T C="127,70,26" S="18"> Vàng  14.2% </T><BR>10</BR>
<T C="127,70,26" S="18"> Đá Sao-Cao  4.5% </T><BR>10</BR>
<T C="127,70,26" S="18"> Sách Kỹ Năng-Trung  8.9% </T><BR>10</BR>
<T C="127,70,26" S="18"> Gà Quay  14.5% </T><BR>10</BR>
<T C="127,70,26" S="18"> Huy Chương Cầu Phúc  7.1% </T><BR>10</BR>
<T C="127,70,26" S="18"> Đá Thức Tỉnh-Trung  4.3% </T><BR>10</BR>
<T C="127,70,26" S="18"> Trứng Pet EXP-Cao  4.3% </T><BR>10</BR>
<T C="127,70,26" S="18"> Vé  Thẻ 10.9% </T><BR>10</BR>
<T C="127,70,26" S="18"> Thẻ Bội Số  10.9% </T><BR>10</BR>
<T C="127,70,26" S="18"> Bụi Thánh Quang  4.1% </T><BR>10</BR>
<T C="127,70,26" S="18"> Thẻ Thắng Thi Đấu  4.1% </T><BR>10</BR>
<T C="127,70,26" S="18"> Đá Thức Tỉnh-Sơ  8.1% </T><BR>10</BR>
<T C="127,70,26" S="18"> Xu Cầu Phúc  2.8% </T><BR>10</BR>


]],
LUCKYGIFT_FINISH = "Đã rút xong",
OnlineReward = "Thưởng online",
TODAY_CHALLENGE_TOTAL = "Số lần khiêu chiến: ",
TODAY_OBTAIN = "Nhận: ",
LUCKY_BOMB = "Rút phải Bomb, hôm nay không thể rút thưởng nữa",

TRAINCAMP_DEC1 = [[<T C="127,70,26" S="20" P="0">Thưởng: </T><T C="5,180,0" S="20" P="0">%s</T>]],
TRAINCAMP_DEC2 = "(Đã nhận)",
TRAINCAMP_DEC3 = "Đã vượt",
ROOMS = "Phòng %s",
COMMUNITY_OPEN_TIP = "Công Hội Lv%d mở",
HURT_BUFFER = "Sát thương +%d",
WEEK_TOTAL_HURT = "Tích lũy sát thương tuần: ",
PASS_RANK ="Xếp hạng vượt ải",
CHALLENGEING = "Đang khiêu chiến",
QUICK_MATCH = "Ghép nhanh",
TRAINCAMP_DEC4 = "Trường Huấn Luyện",
TRAINCAMP_DEC5 = "Vượt độ khó trước mới được khiêu chiến",
TRAINCAMP_DEC6 = "Bay đến mục tiêu %d lần: ",
TRAINCAMP_DEC7 = "Diệt %d quái: ",
TRAINCAMP_DEC8 = "Đánh trúng mục tiêu %d lần: ",
MY_PVPRANK = [[<T C="79,60,48" S="18" P="1">Hạng: </T><T C="0,72,3" S="18" P="1">%s</T>]],
VipRebateDesc1 =
[[
<T C="127,70,26" S="22">Nạp đủ </T>
<T C="255,236,193" S="22" P="1" SC="132,66,29" SS="4" SE="1"> %s</T>
<I Z="0.7">ui/common/common_icon_zuanshi.png</I>
]],
VipRebateDesc2 =
[[
<T C="127,70,26" S="20">Cần nạp thêm </T>
<T C="3,111,8" S="20"> %s</T>
<I Z="0.6">ui/common/common_icon_zuanshi.png</I>
<T C="127,70,26" S="20">Lên cấp</T>
<T C="3,111,8" S="20">%s</T>
<T C="127,70,26" S="20">Ồ!</T>
]],
RETURNMONEY = "Hoàn trả",
CARD_SHOP = "Tiệm Thẻ Bài",
EVERYDAY_AUTO_REFRESH = [[<T C="127,70,26" S="16" P="1">Mỗi ngày: </T><T C="158,0,0" S="16" P="1">%s</T><T C="127,70,26" S="16" P="1"> tạo mới Tiệm</T>]],
LOG = "Nhật ký",
COMMUNITY_STORE_DISCOUNT = [[<T C="127,70,26" S="20" P="1">Mua vật phẩm Công Hội với giá</T><T C="158,0,0" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"></T>]],
COMMUNITY_SHOP_OWN_COUNT = "Tiệm Công Hội có vật phẩm này là 0",
HEROBLOC = "Câu Lạc Bộ",
PLAYERBACK1 = "Chưa thỏa điều kiện, không thể nhận",
PLAYERBACK2 = "Người quá %d ngày chưa đăng nhập, đăng nhập trong thời gian hoạt động sẽ nhận thưởng",
PLAYERBACK3 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Quy tắc người cũ trở lại</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  Lv1-20 được nhận Vàng x15000</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  Lv21-40 được nhận Vàng x15000, Kim Cương x100</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  Lv41-60 được nhận Vàng x15000, Kim Cương x100, Rương Thánh Quang x10</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  Lv61-70 được nhận Vàng x15000, Kim Cương x100, Rương Thánh Quang x10, Đá Sao-Đỉnh x10</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> VIP5 trở lên được nhận thêm Kim Cương x500</T><BR></BR>
]],
PLAYERBACK4 = "Nhận thưởng",
STORAGE_LOG = "Lưu trữ",
COMMUNITY_SHOP_LOG = "Mua",
STORAGE_LOG_TIP = [[<T S="18" C="233,166,62" P="1">Boss</T><T S="18" C="233,166,62" P="1" >%s</T><T S="18" C="233,166,62" P="1"> tử vong, vật phẩm </T><T S="18" C="5,180,0" P="1" >%s</T><T S="18" C="233,166,62" P="1"> rơi ra đã đưa vào Tiệm Công Hội</T>]], 
COMMUNITY_SHOP_LOG_TIP = [[<T S="18" C="233,166,62" P="1" >%s</T><T S="18" C="233,166,62" P="1"> đã mua </T><T S="18" C="5,180,0" P="1" >%s</T>]],
GUILD_BOSS_FIGHT_COST = "Khiêu chiến tốn: %d",
GUILD_BOSS_DROP = "BOSS có thể rơi đạo cụ sau",
GUILD_BOSS_FIGHTER = "Số người đang khiêu chiến: %d",
GUILD_BOSS_HURT_PRE = "Sát thương tất cả +%d%%",
GUILD_BOSS_INSPIRE_TIPS = "(PS: Sát thương lần này chỉ hiệu lực với BOSS)",
GUILD_BOSS_INSPIRE_PLAYERS = "Người cổ vũ lần này",
GUILD_BOSS_INSPIRE_ALL = "Cổ vũ tất cả",
GUILD_BOSS_INSPIRE_ADD = "Sát thương +%d%%",
GUILD_BOSS_INSPIRE = "Cổ vũ",
GUILD_BOSS_INSPIRE_NUM = "Cổ vũ %d lần",
GUILD_BOSS_INSPIRE_DES = "(PS. Cổ vũ thành công, tất cả thành viên đều được cộng thêm)",
GUILD_BOSS_RAND_FIRST = "Lần đầu vượt toàn SV",
GUILD_BOSS_RAND_FAST = "Nhanh nhất toàn SV",
GUILD_BOSS_PASS_TIME_TITLE = "Thời gian",
GUILD_BOSS_WIN_DESC = [[<T C="255,236,193" S="22" P="0"></T><T C="99,255,95" S="22" P="0"> %s </T><T C="255,236,193" S="22" P="0"> đã diệt BOSS %s</T>]],
GUILD_BOSS_WIN_TITLE1 = "Đánh đòn cuối lên BOSS\nDiệt BOSS!",
GUILD_BOSS_WIN_TITLE2 = "%s đánh đòn cuối lên BOSS\nDiệt BOSS!",
GUILD_BOSS_WIN_TITLE3 = "BOSS chưa bị diệt, hãy cố gắng thêm!",
GUILD_BOSS_WIN_HURT_TITLE = "Chi tiết",
GUILD_BOSS_WIN_HURT = "Gây sát thương",
GUILD_BOSS_WIN_HP_PRE = "BOSS còn lại",
GUILD_BOSS_WIN_HURT_REWARD = "Thưởng sát thương",
GUILD_BOSS_WIN_KILL_REWARD = "Thưởng tiêu diệt",
PVPRANK_MODIFYING = "Đấu Hạng đang điều chỉnh",
PLAYERBACK5 = "Không đạt yêu cầu, không có thưởng",
CURRENT_COPY = "Phó bản hiện tại: ",
SWEEP_TEAM_COPY_DIFF_TIP = "Hãy chọn độ khó: ",
SWEEP_TEAM_COPY_FIGHTING = "Càn quét cần",
SURPLUS_SWEEP_COUNT_LESS = "Số lần càn quét không đủ",
GUILD_BOSS_PASS_TIME = "%02d giờ %02d phút",
GUILD_BOSS_INSPIRE_FULL = "Cổ vũ đã đầy!",
SWEEP_COPY_NOT_TIP = "Phó bản không hỗ trợ càn quét",
SWEEP_COPY_LEVEL_OPEN_TIP = "Lv%d mở càn quét phó bản này",
COMMUNITYWAR_TEXT1 = "Đứng đầu",
COMMUNITYWAR_TEXT2 = "Vào vòng trong",
COMMUNITYWAR_TEXT3 = "Tuần %d",
COMMUNITYWAR_TEXT4 = "Công Hội (Chủ Hội)",
COMMUNITYWAR_TEXT5 = "Lịch thi đấu",
COMMUNITYWAR_TEXT6 = "Hạng Sơ Tuyển",
COMMUNITYWAR_TEXT7 = "Hạng Đối Đầu",
COMMUNITYWAR_TEXT8 = "Quy tắc",
COMMUNITYWAR_TEXT9 = "Quy tắc",
COMMUNITYWAR_TEXT10 = [[<T C="255,227,116" S="20" P="1" SC="132,66,29" SE="1" SS="4">Lịch thi đấu bảng </T><T C="255,227,116" S="20" P="1" SC="132,66,29" SE="1" SS="4">(%s)</T><T C="255,227,116" S="20" P="1" SC="132,66,29" SE="1" SS="4"></T>]],
COMMUNITYWAR_TEXT11 = [[<T C="255,227,116" S="20" P="1" SC="132,66,29" SE="1" SS="4">Lịch thi đấu chung kết </T><T C="255,227,116" S="20" P="1" SC="132,66,29" SE="1" SS="4">(%s)</T><T C="255,227,116" S="20" P="1" SC="132,66,29" SE="1" SS="4"></T>]],
COMMUNITYWAR_TEXT12 =
[[
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Thời gian mở: 20:00-21:00 ngày 1, 3, 5, 7 hàng tháng là thời gian ghép đấu Công Hội Chiến-Sơ Tuyển.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Người chơi cùng Công Hội tạo thành đội 3 người, đấu với đội của Công Hội khác.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi trận đấu giới hạn 15 phút, hết giờ sẽ do hệ thống phán đoán thắng thua căn cứ số người, sinh lực còn lại của 2 bên.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Người chơi rời khỏi hoặc rớt mạng sẽ bị trừ điểm.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Hệ thống sẽ xếp hạng theo điểm Công Hội Chiến.</T><BR></BR>
<T C="229,105,22" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Hạng Công Hội Chiến-Sơ Tuyển là hạng SV, Công Hội nằm trong Top 4 sẽ được tư cách vào Công Hội Chiến-Đối Đầu.</T><BR></BR>
<T C="229,105,22" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Điểm Sơ Tuyển là 0 sẽ không thể nhận Tư Cách Đứng Đầu.</T><BR></BR>
]],

COMMUNITYWAR_TEXT13 =
[[
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Thời gian mở: 20:00-21:00 ngày 8, 10, 12, 14 hàng tháng là thời gian ghép đấu Công Hội Chiến-Đối Đầu.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Người chơi cùng Công Hội tạo thành đội 3 người, đấu với đội của Công Hội khác.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi trận đấu giới hạn 15 phút, hết giờ sẽ do hệ thống phán đoán thắng thua căn cứ số người, sinh lực còn lại của 2 bên.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Người chơi rời khỏi hoặc rớt mạng sẽ bị trừ điểm.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Hệ thống sẽ xếp hạng theo điểm Công Hội Chiến.</T><BR></BR>
<T C="229,105,22" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Hạng Công Hội Chiến-Đối Đầu là hạng toàn server, Công Hội Top 32 được tư cách Đấu Loại, đến khi tìm được Quán Quân.</T><BR></BR>
]],

COMMUNITYWAR_TEXT14 = [[<T C="127,70,26" S="20" P="1">Guild: Hạng </T><T C="229,105,22" S="20" P="1">%d</T><T C="127,70,26" S="20" P="1"></T>]],
COMMUNITYWAR_TEXT15 = "Nhìn lại trận đấu",
COMMUNITYWAR_TEXT16 = " sau mở",
COMMUNITYWAR_TEXT17 = "Chưa bắt đầu, xin đợi",
COMMUNITYWAR_TEXT18 = "Cấp không đủ",
COMMUNITYWAR_TEXT19 = "Cấp Công Hội không đủ",
COMMUNITYWAR_TEXT20 = "Thi Đấu đã kết thúc",
COMMUNITYWAR_TEXT21 = "Công Hội chưa vào trận Đối Đầu, lần sau cố gắng hơn!",
COMMUNITYWAR_TEXT22 = "Công Hội đã mất tư cách, lần sau cố gắng hơn!",
COMMUNITYWAR_TEXT23 = "Công Hội Chiến đã kết thúc",
COMMUNITYWAR_TEXT24 = "Ngày %s",
COMMUNITYWAR_TEXT25 = "1, 3, 5, 7 diễn ra Sơ Tuyển",
COMMUNITYWAR_TEXT26 = "8, 10, 12, 14 diễn ra Đối Đầu",
COMMUNITYWAR_TEXT27 = "Đấu Loại đang diễn ra",
COMMUNITYWAR_TEXT28 = "Chung kết đang diễn ra",
COMMUNITYWAR_TEXT29 = "Đang là thời gian nghỉ ngơi...",
COMMUNITYWAR_TEXT30 = "Khai chiến: ",
COMMUNITYWAR_TEXT31 = "Công Hội (Máy chủ)",
COMMUNITYWAR_TEXT32= "Tên (Cấp)",
COMMUNITYWAR_TEXT33 = "Hạng SV",
COMMUNITYWAR_TEXT34 = "Hạng thành viên",
UNIT_PRICE = "Giá",
PASS_HARD_COPY_TIP = "Vượt ải Địa Ngục mới được càn quét",
WEEK_CARD = "Thẻ Tuần",
ENJOY_CARD = "Thẻ Chí Tôn Vĩnh Viễn",
SWEEP_COPY_NOT_ITEM_TIP = "%s không đủ, muốn mua?",
PVPRANK_INVITE_NO_DATA = "Không có dữ liệu phù hợp yêu cầu",
KNOCKOUT1 = "Nhóm A",
KNOCKOUT2 = "Nhóm B",
KNOCKOUT3 = "Nhóm C",
KNOCKOUT4 = "Hiện tại đã có %s thành viên vào Công Hội Chiến",
KNOCKOUT5 = "Công Hội Chiến-Đấu Loại",
KNOCKOUT6 = "Quy tắc",
KNOCKOUT7 = "Tự bắt đầu",
KNOCKOUT8 = "Thành viên",
KNOCKOUT_DESC =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Quy tắc</T><BR></BR>
]],
KNOCKOUT9 = "Trong phòng",
KNOCKOUT10 = "Chủ Hội hoặc đại diện có thể thiết lập",
SHOUCHONG4 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">Đã nạp </T><T C="255,227,116" S="20" P="1" SC="0,0,0" SE="1" SS="4">%s Kim Cương</T><T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">:</T>]],
UNIT_PRICE = "Giá",
PASS_HARD_COPY_TIP = "Vượt ải Địa Ngục mới được càn quét",
WEEK_CARD = "Thẻ Tuần",
ENJOY_CARD = "Thẻ Chí Tôn Vĩnh Viễn",
COMMUNITYWARGIFT_TEXT1 = "Sơ Tuyển",
COMMUNITYWARGIFT_TEXT2 = "Đối Đầu",
COMMUNITYWARGIFT_TEXT3 = "Đấu Loại",
COMMUNITYWARGIFT_TEXT4 = "Thưởng",
COMMUNITYWARGIFT_TEXT6 = "Sau khi kết thúc lịch thi đấu, thưởng được gửi qua thư",
COMMUNITYWARTASK_TEXT1 = "Mục tiêu",
COMMUNITYWARTASK_TEXT2 = "Tham gia",
COMMUNITYWARTASK_TEXT3 = "Kết thúc chung kết, nhật ký sẽ được tạo mới, thưởng chưa nhận được gửi qua thư",
COMMUNITYWARTASK_TEXT4 = "Nhận",
COMMUNITYWARTASK_TEXT5 = "Chiến thắng",
COMMUNITYWARTASK_TEXT6 = "Diệt",
COMMUNITYWARHISTORY_TEXT2 = "Các đời",
COMMUNITYWARHISTORY_TEXT3 = "Lần %s",
COMMUNITYWARHISTORY_NUMBER = {
"1", "2", "3", "4", "5",
"6", "7", "8", "9", "10",
},
COMMUNITYWARAGENT_TEXT1 = "Thiết lập đại diện",
COMMUNITYWARAGENT_TEXT2 = "Đồng ý",
GUILD_WAR_RW_TITLE = "Công Hội Chiến-Đối Đầu",
GUILD_WAR_CX_TITLE = "Công Hội Chiến-Sơ Tuyển",
CANCEL_READY_GAME = "Hủy chuẩn bị",
CANCEL_PAIR_GAME = "Hủy ghép",
PVPRANK_INVITE_NO_DATA = "Không có dữ liệu phù hợp",
HAVE_KILL_BOSS = "BOSS đã tử vong",
SHOUCHONG1 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">Gợi Ý: Đầu Tư 1000 Kim Cương Quỹ Trưởng Thành hoàn trả 10.000 Kim Cương</T>]],
SHOUCHONG2 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">Nạp Thêm 250 Kim Cương Tặng PET Ong Vàng, Sách Kỹ Năng, Đá Sao</T>]],
SHOUCHONG3 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">Nạp Thêm 500 Kim Cương ẫm trọn Bộ Thời Trang, Cánh cực HOT</T>]],
GUILD_WAR_RANK_REWARD_VIEW = "Xem trước thưởng hạng",
GUILD_WAR_TEAM_SCORE = "Tổng điểm: %s",
SWEEP_FUNCTION_LAST = "Càn quét còn: ",
COMMUNITYWAR_TEXT35 = "Top 16",
LUCKYGIFT1 = "Ban Ân đổi",
SHOP_BUY_DESC3 = [[<T C="79,60,48" S="20" P="0">Gồm %d vật phẩm, cần chi trả </T><I Z="0.5">%s</I><T C="79,60,48" S="20" P="0">%d</T>]],
NOTRECOMMOEND = "Không có vật phẩm đề cử!",
ARENA_CARD_DES = 
[[
<T C="255,89,74" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Thẻ tăng điểm Thi Đấu gồm 2 loại: Thẻ Thắng và Thẻ Ngày.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Thẻ Thắng hiệu lực khi thắng Thi Đấu, mỗi lần hiệu lực, số trận duy trì -1, khi còn 0 sẽ mất hiệu lực..</T><BR></BR>
<T C="255,89,74" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Thẻ Ngày hiệu lực khi Thi Đấu＞0. Thời gian duy trì vẫn tính khi nhân vật rời mạng, 0 sẽ mất hiệu lực.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Hiệu quả Thẻ Thắng và Thẻ Ngày được cộng dồn.</T><BR></BR>
<T C="255,89,74" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Nhân vật tử vong trong kiểu Đấu Hạng và Đấu Điểm sẽ biến thành linh hồn, có thể di chuyển tự do</T><BR></BR>
<T C="255,89,74" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> Linh hồn có thể nhặt Rương Linh Hồn, nhận kỹ năng linh hồn. Có thể dùng kỹ năng cho đồng đội hoặc đối thủ tùy hiệu quả mỗi loại, được tích trữ tối đa 3 kỹ năng, nếu vượt hơn sẽ không thể nhặt nữa</T><BR></BR>
]],
ARENA_CARD_TIME_TITLE = "Thẻ Lần chiến thắng tăng",
ARENA_CARD_TIME_LEFT = "Số trận còn: %d",
ARENA_CARD_ADD_PREC = "Thi đấu ngẫu nhiên thắng, điểm +%d%%",
ARENA_CARD_DAY_TITLE = "Thẻ Ngày chiến thắng tăng",
ARENA_CARD_DAY_LEFT = "Thời gian còn: %d ngày %d giờ",
ARENA_CARD_DAY_LEFT2 = "Thời gian còn: %d giờ %d phút",
ARENA_CARD_DAY_LEFT3 = "Thời gian còn: %d phút",
ARENA_CARD_TIME_TIP = "Điểm thắng Thi Đấu +%d%%, số trận +%d",
ARENA_CARD_DAY_TIP = "Điểm tổng kết Thi Đấu +%d%%, thời hạn +%d",
ARENA_CARD_ADD = "Điểm Thi Đấu tăng",
COMMUNITYWARAGENT_TEXT3 = "Nhấn \"+\" hoặc Avatar để thiết lập",
COMMUNITYWARAGENT_TEXT4 = "Đại diện",
DAY1 = "Ngày 1",
DAY2 = "Ngày 2",
DAY3 = "Ngày 3",
DAY4 = "Ngày 4",
DAY5 = "Ngày 5",
DAY6 = "Ngày 6",
DAY7 = "Ngày 7",
NOSAVE = "Chưa nạp",
SEVEN1 = "Tiêu phí hôm nay",
SEVEN2 = "Tích lũy tiêu phí",
SEVEN3 = "Mai có thể nhận",
SEVEN4 = "Ngày 8 có thể nhận",
SEVENDESC =
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Hoạt động tính từ khi tạo nhân vật, duy trì 1 tuần</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Ngày 2 được nhận 10% Kim Cương tiêu phí của ngày trước</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Ngày 8 được nhận 10% Kim Cương tổng tiêu phí tuần trước</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Kim Cương hoàn trả đúng 12 giờ sẽ gửi qua thư</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Hoạt động chỉ hiệu lực trước 1 tuần tạo nhân vật mới</T><BR></BR>
]],
KNOCKOUT_DESC = 
[[
<T C="255,89,74" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> Thời gian mở: Ngày 15-20 mỗi tháng là lịch Đấu Loại, theo hình thức 3 trận thắng 2, thắng được vào vòng trong. Mỗi ngày 20:00-20:15 là thời gian chuẩn bị, đúng 20:15 là bắt đầu thi đấu, thành viên đã thiết lập được trực tiếp vào trận đấu.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> Chủ Hội có thể thiết lập thành viên tham gia mỗi đội tại phòng, cũng có thể thiết lập đại diện ở bản đồ Công Hội, do đại diện thiết lập.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> Mỗi trận đấu giới hạn 15 phút, hết giờ sẽ do hệ thống phán đoán thắng thua căn cứ số người, sinh lực còn lại của 2 bên.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> Ngày 19 sẽ tiến hành trận đấu giành hạng 3, ngày 20 diễn ra trận Quán Quân.</T><BR></BR>
]],
ROOM_BEINVITED_3 = "%s mời tham gia\n%s",
CANTJOINGUILD1 = "Chưa đạt cấp vào Công Hội",

COUNTDOWN = "Hoạt động còn:",
COMMUNITYWAR_TEXT36 = "Công Hội hôm nay không có thi đấu",
COMMUNITYWAR_TEXT37 = "Chủ Hội mới được thiết lập đại diện!",
COMMUNITYWAR_TEXT38 = "Đại diện quyền hạn cao hơn đã vào, bạn mất quyền thiết lập!",
SHOP_DRESS_NULL = "Hiện tại không có thời trang mặc thử",
COMMUNITYWARAGENT_TEXT5 = 
[[
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Người Người Đại Diện có thể thiết lập thành viên tham gia tại phòng Công Hội Chiến-Đấu Loại.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Tối đa được thiết lập 4 Người Người Đại Diện.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Trong phòng chỉ 1 người được quyền thiết lập, Chủ Hội luôn có quyền tuyệt đối.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Trong phòng, nếu Chủ Hội không có mặt thì Người Người Đại Diện có mã số nhỏ nhất có quyền thiết lập.</T><BR></BR>
]],
BATTLE_FIRST_KILL = "First Blood",
TEACH_179 = "Nhấn để bỏ qua",
INVITE_LIST = "Danh sách mời",
GAME_ACTIVITY_TITLE40 = "Bắn pháo bông",
GAME_ACTIVITY_TITLE41 = "Lì xì giờ chẵn",
GAME_ACTIVITY_TITLE42 = "Lì xì",
GAME_ACTIVITY_TITLE43 = "Nguời chơi cũ trở về",
GAME_ACTIVITY_TITLE44 = "Khuyến mãi nhân vật mới",
GAME_ACTIVITY_TITLE45 = "Lì xì nhân vật mới",
NEWYEARTIP7 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Thời gian: Mỗi ngày </T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Vào giờ chẵn, chỉ cần ở Thành chủ là có thể nhận 1 Lì Xì, 1 ngày có thể nhận  </T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4"> Lì Xì, mở Lì Xì nhận ngẫu nhiên </T>
<I Z="0.8" P="1">ui/common/common_icon_zuanshi.png</I>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Thưởng. </T>]],
MAX_Week_CARD = "Hiện tại Thẻ Tuần còn hơn %d ngày, không cần gia hạn",
LUCKYGIFT2 = "%.1f lần",
COMMUNITYWARAGENT_TEXT5 = 
[[
<T C="229,105,22" S="22">Người Đại Diện thiết lập đội viên Công Hội Chiến</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Người Đại Diện có thể thiết lập thành viên tham gia trong phòng Công Hội Chiến-Đấu Loại</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Có thể thiết lập nhiều nhất 4 Người Đại Diện</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Trong phòng chỉ 1 người có quyền thiết lập, Chủ Hội có quyền hạn tuyệt đối</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Nếu Chủ Hội vắng mặt, Người Đại Diện mã số nhỏ nhất mới được dùng quyền thiết lập</T><BR>20</BR>
<T C="229,105,22" S="22">Người Đại Diện tạo mới nhiệm vụ Công Hội</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Chủ Hội và Người Đại Diện đều được tạo mới nhiệm vụ Công Hội</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Cùng lúc, chỉ có 1 người được quyền tạo mới</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Chủ Hội không online, tức Người Đại Diện có mã số nhỏ nhất có quyền</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Khi người chơi có cấp ưu tiên cao hơn online, quyền hạn sẽ thay đổi</T><BR></BR>
]],
NEWUSER_WEAFARE_RETURN_RULE =
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Hoạt động tính từ khi tạo nhân vật, duy trì 1 tuần</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Nạp đạt mức chỉ định sẽ nhận thưởng tương ứng</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Hoạt động chỉ duy trì 7 ngày</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Hoạt động chỉ hiệu lực trước 1 tuần tạo nhân vật mới</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Sau khi hoạt động kết thúc nạp sẽ vô hiệu</T><BR></BR>
]],
DIGGEM_TEXT1 = "Túi Bảo Vật",
DIGGEM_TEXT2 = "Nhật ký Đào Bảo",
DIGGEM_TEXT3 = "Dự đoán thời gian còn lại: ",
DIGGEM_TEXT4 = "Bắt đầu Đào Bảo",
DIGGEM_TEXT5 = "Dừng Đào Bảo",
DIGGEM_TEXT6 = "Điểm Thuần Thục",
DIGGEM_TEXT7 = "Dung lượng",
DIGGEM_TEXT8 = "Chỉ lưu 50 nhật ký 3 ngày gần nhất",
DIGGEM_TEXT9 =  [[<T C="127,70,26" S="20" P="0">Bắt đầu Đào Mỏ, hãy tiếp tục </T><T C="229,105,22" S="20" P="0">%s</T>]],
DIGGEM_TEXT10 = [[<T C="127,70,26" S="20" P="0">Có làm thì mới có ăn, đào được </T><T C="229,105,22" S="20" P="0">[%s]</T><T C="127,70,26" S="20" P="0">, Điểm Thuần Thục </T><T C="5,180,0" S="20" P="0">+%d</T>]],
DIGGEM_TEXT11 = [[<T C="127,70,26" S="20" P="0">Kết thúc Đào Bảo, nhận được </T><T C="229,105,22" S="20" P="0">%s</T>]],
DIGGEM_TEXT12 = [[<T C="127,70,26" S="20" P="0">Túi Bảo Vật đã đầy, hãy dọn kịp thời, dừng Đào Bảo</T>]],
DIGGEM_TEXT13 = [[<T C="127,70,26" S="20" P="0">Cấp thông thạo lên đến </T><T C="5,180,0" S="20" P="0">Lv[%d]</T>]],
DIGGEM_TEXT14 = [[<T C="127,70,26" S="20" P="0">Hãy nghỉ ngơi một lát, dừng Đào Bảo</T>]],
DIGGEM_TEXT15 = "Thời gian đào: ",
DIGGEM_TEXT16 = "Hiệu suất đào: ",
DIGGEM_TEXT17 = "Tăng Điểm Thuần Thục: %d điểm",
DIGGEM_TEXT18 = "Giá",
DIGGEM_TEXT19 = 
[[
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Hướng dẫn 1.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Hướng dẫn 2.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Hướng dẫn 3.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Hướng dẫn 4.</T><BR></BR>
]],
DIGGEM_TEXT20 = "Chọn công cụ",
DIGGEM_TEXT21 = "Chưa có dữ liệu nhật ký",
DIGGEM_TEXT22 = "Thư viện bảo vật",
DIGGEM_TEXT23 = "Phí giám định",
DIGGEM_TEXT24 = " Điểm Thuần Thục có tỷ lệ đào được",
DIGGEM_TEXT25 = [[<T C="255,236,193" S="20" P="0">Có làm thì mới có ăn,</T>]],
DIGGEM_TEXT26 = [[<T C="255,236,193" S="20" P="0">May mắn đấy,</T>]],
DIGGEM_TEXT27 = [[<T C="255,236,193" S="20" P="0">Thật may mắn,</T>]],
DIGGEM_TEXT28 = [[<T C="255,236,193" S="20" P="0">Huyết thống Âu Hoàng!</T>]],
DIGGEM_TEXT29 = [[<T C="255,236,193" S="20" P="0">Chúc mừng đã nhận bảo vật hiếm!</T>]],
DIGGEM_TEXT30 = [[<T C="255,236,193" S="20" P="0">Đào được </T><T C="233,166,62" S="20" P="0">[%s]</T><T C="255,236,193" S="20" P="0">, Điểm Thuần Thục </T><T C="5,180,0" S="20" P="0">+%d</T>]],
DIGGEM_TEXT31 = "Giám định bảo vật",
DIGGEM_TEXT32 = "Giám định",
DIGGEM_TEXT33 = "Hãy chọn bảo vật cần giám định",
DIGGEM_TEXT34 = "Đồng ý tốn %d Kim Cương đổi %d Pha Lê hay không\nHôm nay còn được đổi %d lần",
DIGGEM_TEXT35 = "Số lần đổi hôm nay đã dùng hết",
DIGGEM_TEXT36 = "Số lượng giám định",
DIGGEM_TEXT37 = "Hãy chọn bảo vật bên phải để giám định",
DIGGEM_TEXT38 = "Đơn giá giám định",
DIGGEM_TEXT39 = "Tổng giá giám định",
DIGGEM_TEXT40 = "Ô giám định đã đầy, hãy giám định trước",
DIGGEM_TEXT41 = "Không có Đá chưa giám định",
DIGGEM_TEXT43 = "Có xác suất rơi ra khi mở hoặc vượt ải Phó Bản Di Tích",
TRANSACTION1 = "Giao Dịch",
TRANSACTION2 = "Đá Đỏ",
TRANSACTION3 = "Đá Lục",
TRANSACTION4 = "Đá Vàng",
TRANSACTION5 = "Đá Màu",
TRANSACTION6 = "Thường",
TRANSACTION7 = "Lấp lánh",
TRANSACTION8 = "Chói Lóa",
TRANSACTION9 = "Cần mua",
TRANSACTION10 = "Cần bán",
TRANSACTION11 = "Hệ thống thu hồi",
TRANSACTION12 = "Phân loại vật phẩm",
TRANSACTION13 = "Bảng vật phẩm",
TRANSACTION14 = "Số lượng mua",
TRANSACTION15 = "Túi Bảo Vật",
TRANSACTION16 = "Vật phẩm đang bán",
TRANSACTION18 = "Đã bán: ",
TRANSACTION19 = "Số lượng lên kệ",
TRANSACTION20 = "Lên kệ",
TRANSACTION21 = "Đơn giá bán",
TRANSACTION22 = "Tổng giá bán",
TRANSACTION23 = "Bán thành công sẽ thu 20% phí thủ tục",
TRANSACTION24 = "Pha Lê",
TRANSACTION25 = "Ngưng bán",
TRANSACTION26 = 
[[
<T C="255,236,193" S="18" P="0" SC="132,66,29" SS="4" SE="1">Có %s vật phẩm có thể thu hồi</T><I Z="0.6">ui/common/common_icon_kuangjing.png</I><T C="255,236,193" S="18" P="0" SC="132,66,29" SS="4" SE="1">%s</T>
]],
TRANSACTION27 = "Số lượng thu hồi: ",
TRANSACTION28 = "Đơn giá thu hồi",
TRANSACTION29 = "Tổng thu hồi",
TRANSACTION30 = "Hệ thống chỉ lưu 50 lần nhật ký giao dịch gần đây",
TRANSACTION31 = "Nhật ký",
TRANSACTION32 = "Bảng nhật ký giao dịch",
TRANSACTION33 =
[[
<T C="127,70,26" S="22" P="0">Bán </T><T C="229,105,22" S="22" P="0">[%s] x%s</T>
<T C="127,70,26" S="22" P="0">, giá thỏa thuận %s Pha Lê, nhận được %s Pha Lê</T>
]],
TRANSACTION34 =
[[
<T C="127,70,26" S="22" P="0">Bán </T><T C="229,105,22" S="22" P="0">[%s] x%s</T>
<T C="127,70,26" S="22" P="0">, giá thỏa thuận %s Pha Lê, nhận được %s Pha Lê</T>
]],
TRANSACTION35 =
[[
<T C="127,70,26" S="22" P="0">Bán </T<T C="229,105,22" S="22" P="0">[%s] x%s</T>
<T C="127,70,26" S="22" P="0">, giá thỏa thuận %s Pha Lê, nhận được %s Pha Lê</T>
]],
TRANSACTION36 =
[[
<T C="127,70,26" S="22" P="0">Bán </T><T C="229,105,22" S="22" P="0">[%s] x%s</T>
<T C="127,70,26" S="22" P="0">, giá thỏa thuận %s Pha Lê, nhận được %s Pha Lê</T>
]],
TRANSACTION37 =
[[
<T C="127,70,26" S="22" P="0">Mua </T><T C="229,105,22" S="22" P="0">[%s] x%s</T>
<T C="127,70,26" S="22" P="0">,Giá thỏa thuận %s Pha Lê</T>
<T C="127,70,26" S="22" P="0">, giám định xong nhận </T><T C="229,105,22" S="22" P="0">%s</T>
]],
TRANSACTION38 =
[[
<T C="127,70,26" S="22" P="0">Mua </T><T C="229,105,22" S="22" P="0">[%s] x%s</T>
<T C="127,70,26" S="22" P="0">,Giá thỏa thuận %s Pha Lê</T>
<T C="127,70,26" S="22" P="0">, giám định xong nhận </T><T C="229,105,22" S="22" P="0">%s</T>
]],
TRANSACTION39 =
[[
<T C="127,70,26" S="22" P="0">Mua </T><T C="229,105,22" S="22" P="0">[%s] x%s</T>
<T C="127,70,26" S="22" P="0">,Giá thỏa thuận %s Pha Lê</T>
<T C="127,70,26" S="22" P="0">, giám định xong nhận </T><T C="229,105,22" S="22" P="0">%s</T>
]],
TRANSACTION40 =
[[
<T C="127,70,26" S="22" P="0">Mua </T><T C="229,105,22" S="22" P="0">[%s] x%s</T>
<T C="127,70,26" S="22" P="0">,Giá thỏa thuận %s Pha Lê</T>
<T C="127,70,26" S="22" P="0">, giám định xong nhận </T><T C="229,105,22" S="22" P="0">%s</T>
]],

TRANSACTION41 = "Bán",
TRANSACTION42 = "Mua",
TRANSACTION43 = "Đơn giá mua",
TRANSACTION44 = "Tổng mua",
TRANSACTION45 = "Không đủ Pha Lê",
TRANSACTION46 = "Vật phẩm đã bán hết",
TRANSACTION47 = "Lên kệ thành công",
TRANSACTION48 = "Ô kệ đã đầy",
TRANSACTION49 = "Số lượng vật phẩm không đủ",
TRANSACTION50 = "Ngưng bán thành công",
TRANSACTION51 = "Đã bị mua",
TRANSACTION52 = "Mỗi lần thu hồi nhiều nhất 10 vật phẩm",
TRANSACTION53 = "Đã bán %s cái",
TRANSACTION54 = "Đồng ý ngưng bán %s?",
TRANSACTION55 = "Túi đã đầy, ngưng bán thất bại",
TRANSACTION56 = "Tổng",
TRANSACTION57 = "Lộng lẫy",
TRANSACTION_DESC =
[[
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Vật phẩm sau khi lên kệ phải được mua bởi người chơi khác mới có thể nhận Pha Lê</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Vật phẩm trong Giao Dịch đều do người chơi bày bán</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Những vật phẩm trên bảng sẽ được đề cử ngẫu nhiên</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Lên kệ có giới hạn thời gian, quá hạn sẽ ngưng bán vật phẩm đó</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Trong ngày Giao Dịch, sau khi bán hơn 100 Khoáng Thạch, sẽ không thể bán tiếp, giới hạn tạo mới lúc 0 giờ mỗi ngày.</T><BR></BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">Không thể bày bán đá phẩm chất thấp</T><BR>10</BR>
<T C="127,70,26" S="20">7. </T><T C="127,70,26" S="18">Sau khi bán thành công, hệ thống sẽ thu phí thủ tục bằng 20% giá bán</T><BR>10</BR>
<T C="127,70,26" S="20">8. </T><T C="127,70,26" S="18">Thu hồi vật phẩm là bán cho hệ thống, sau khi bán có thể nhận Pha Lê</T><BR>10</BR>
<T C="127,70,26" S="20">9. </T><T C="127,70,26" S="18">Sau khi mua vật phẩm, hệ thống sẽ tự động giám định đạo cụ</T><BR>10</BR>
]],
PROMISE_SHRINE_TEXT1 = "Ban đầu",
PROMISE_SHRINE_TEXT2 = "Cầu Nguyện lần sau còn: ",
PROMISE_SHRINE_TEXT3 = "Phúc Lợi còn: ",
PROMISE_SHRINE_TEXT4 = "Nạp ưu đãi",
PROMISE_SHRINE_TEXT5 = "",
PROMISE_SHRINE_TEXT6 = "Nạp",
PROMISE_SHRINE_TEXT7 = "Đang có buff Cầu Nguyện: Nạp bất kì để nhận thưởng!",
PROMISE_SHRINE_TEXT8 = 
[[
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Cầu Nguyện không tốn Xu, mỗi ngày chỉ được Cầu Nguyện 1 lần</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Buff phúc lợi sau khi Cầu Nguyện chỉ được dùng 1 lần</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Cầu Nguyện sẽ không còn sau khi hoạt động kết thúc</T><BR>10</BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Hoạt động Cầu Nguyện tạo mới vào 05:00 mỗi ngày</T><BR>10</BR>
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">Nạp thẻ đạt yêu cầu sau khi Cầu Nguyện sẽ nhận được thưởng Cầu Nguyện qua thư</T><BR>10</BR>
]],
PROMISE_SHRINE_TEXT9 = "Nạp lần đầu nhân đôi",
PROMISE_SHRINE_TEXT10 = "Cầu Nguyện",
PROMISE_SHRINE_TEXT11 = "Hoàn trả ", 
PROMISE_SHRINE_TEXT12 = "Hồ Ước Nguyện: ",
PROMISE_SHRINE_TEXT13 = "Tổng",
TDONATE = "Cống hiến thể lực: ",
LEAGUE_HONOUR_TITLE1 = "Giải đấu Xạ Thủ Liên Đấu mùa %s",
SUMMON_4 = "Nhận Bùa",
PETDES = 
[[
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Nếu tư chất Pet chưa đạt tối đa, có thể tẩy luyện để nhận tư chất ngẫu nhiên.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Mỗi lần tẩy luyện cần tốn 1 Tinh Thạch Pet, có thể nhận tại Tiệm Pet.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Khi tư chất Pet đạt cao nhất, sẽ không thể tiếp tục tẩy luyện.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Tư chất tẩy luyện có dạng ngẫu nhiên, hãy chọn kỹ.</T><BR></BR>
]],
DIGGEM_TEXT19 =
[[
<T C="229,105,22" S="22">Công cụ Đào Bảo</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Dùng công cụ cao để Đào Bảo, tốc độ thu hoạch càng nhanh, nhận Điểm Thuần Thục càng nhiều và dễ nhận bảo vật.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Công cụ cao duy trì lâu hơn.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Mua công cụ cần tốn Pha Lê, Pha Lê nhận khi bán hoặc treo bán các bảo vật.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Dừng Đào Bảo sẽ tốn thời gian, cần duy trì một khoảng thời gian mới được nhận bảo vật, nên đừng thao tác quá nhiều.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Khi Túi Bảo Vật đầy sẽ tự động dừng Đào Bảo, sắp xếp túi để hạn chế tổn thất.</T><BR></BR>
]],
DIGGEM_TEXT42 =
[[
<T C="229,105,22" S="22">Hướng dẫn Đào Bảo</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Dùng công cụ để Đào Bảo, sau thời gian nhất định sẽ nhận được bảo vật.</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Đào Bảo sẽ nhận được Điểm Thuần Thục, đạt mức nhất định sẽ tăng cấp kỹ năng Đào Bảo, giúp đào được bảo vật tốt hơn.</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Giám định bảo vật sẽ nhận được các loại Đá, Kim Cương Khóa, Pha Lê, Vàng.</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Nếu không giám định, cũng có thể bán trực tiếp cho hệ thống, hoặc bán cho người khác nhận Pha Lê.</T><BR></BR>
<T C="229,105,22" S="22">Hướng dẫn Thuê</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Có thể thuê bạn bè hỗ trợ Đào Bảo.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Mỗi lần đào được báu vật, mỗi bạn bè được thuê sẽ có cơ hội đào được thêm 1 phần.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Mỗi bạn bè được thuê đều có điểm tâm trạng, điểm càng cao, xác suất đào được báu vật càng lớn.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Có thể tương tác với bạn bè bằng các thao tác Hôn Gió, Cho Ăn, Đánh Đòn, có thể giúp tăng điểm tâm trạng.</T><BR></BR>
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">Bạn bè đang nhàn rỗi sẽ có xác suất đến trộm mỏ. Nếu thấy có người đến trộm, nhớ đuổi đi kịp thời.</T><BR></BR>

]],
RUNE_LOCK_TIP = "Hãy mở ô Bùa trước",
RUNE_OPEN_BY_DIAMONDS = "Đồng ý tốn %d Kim Cương để mở ô trước?",
RUNE_STORE = "Tiệm Bùa",
RUNE_TOTAL_LEVEL = "Tổng cấp Bùa",
RUNE_ATTRIBUTE = "Thuộc tính cộng thêm",
FAST_DISASSEMBLE = "Tháo nhanh",
RUNE_BAG = "Túi Bùa",
RUNE_INFO = "Thông tin Bùa",
RUNE_EXTRACT = "Nhận Bùa",
RUNE_LOAD = "Gắn Bùa",
RUNE_ITEM_ATTRIBUTE1 = [[<T C="255,227,116" S="20" P="0">%s </T><T C="99,255,95" S="20" P="0">+%s</T>]],
RUNE_ITEM_ATTRIBUTE2 = [[<T C="255,227,116" S="20" P="0">%s</T><T C="99,255,95" S="20" P="0">+%s</T>]],
COMMUNITYINFO228 = "Cấp thiết lập phải lớn hơn hoặc bằng %s",
COMMUNITYINFO229 = "Cấp VIP thiết lập phải nhỏ hơn hoặc bằng %s",
COMMUNITYINFO230 = "Cấp VIP thiết lập phải lớn hơn hoặc bằng %s",
COMMUNITYINFO231 = "Công Hội mục tiêu cần người chơi đạt cấp %s",
COMMUNITYINFO232 = "Công Hội mục tiêu cần cấp người chơi đạt VIP %s",
COMMUNITYINFO233 = "Công Hội mục tiêu đã đầy, không thể vào",
COMMUNITYINFO234 = "%s mời bạn vào Công Hội %s",
REVIEW1 = "Duyệt thủ công",
REVIEW2 = "Duyệt tự động",
REVIEW3 = "Cấp nhân vật vào Hội",
REVIEW4 = "Cấp VIP nhân vật vào Hội",
COMMUNITYINFO195 = [[Cấp/Tên/ID]],
COMMUNITYINFO235 = "Không hạn chế",
COMMUNITYINFO236 = "Nhân vật cấp %s",
COMMUNITYINFO237 = "Hạn chế vào Hội",
COMMUNITYINFO238 = "Mời Công Hội",
LUCK_DRAW_ONE = "Rút 1 lần",
LUCK_DRAW_FIVE = "Rút 5 lần",
TO_RUNE_SYSTEM = "Đến trang bị",
LUCK_DRAW_TIP = "Rút 5 lần được Bùa Lv2-Lv3",
LUCK_DRAW_TIP2 = "Rút 5 lần được Bùa Lv4-Lv7",
LUCK_DRAW_TIP3 = "Rút thêm %d lần được Bùa Lv2-Lv3",
LUCK_DRAW_TIP4 = "Rút thêm %d lần được Bùa Lv4-Lv7",
UNLOAD_ALL_RUNE = "Xác nhận tháo toàn bộ Bùa?",
OPERATION_ERROR = "Thao tác thất bại",
DIAMONDS_OPEN_SLOT_ERROR_TIP = "Mở ô thất bại",
RUNE_BAG_NULL_TIP = "Tạm không có Bùa để gắn",
BIG_RUNE_LEVEL ="Dấu Thánh Lv%d",
RED_RUNE_LEVEL = "(Bùa Đỏ tổng Lv%d kích hoạt)",
GREEN_RUNE_LEVEL = "(Bùa Xanh tổng Lv%d kích hoạt)",
YELLOW_RUNE_LEVEL = "(Bùa Vàng tổng Lv%d kích hoạt)",
BIG_RUNE_LEVEL_ACT = "(Bùa tổng Lv%d kích hoạt)",
RUNE_LEVEL_MAX = "(Cấp hiện tại đã đầy)",
RED_RUNE_UPDATE_LEVEL = "(Bùa Đỏ tổng Lv%d lên cấp)",
GREEN_RUNE_UPDATE_LEVEL = "(Bùa Xanh tổng Lv%d lên cấp)",
YELLOW_RUNE_UPDATE_LEVEL = "(Bùa Vàng tổng Lv%d lên cấp)",
BIG_UPDATE_LEVEL = "(Bùa tổng Lv%d lên cấp)",
BUY_RUNE_STORE_NOT_ENOUGTH = "%s không đủ %d, có thể đến bán Bùa để nhận",
NOT_RUNE_TO_UNLOAD = "Không có Bùa để tháo",
RUNEBOOK1 = "Cấp sàng lọc",
RUNEBOOK2 = "Bán nhiều",
RUNEBOOK3 = "Nhận Bùa",
RUNEBOOK4 = "Thông tin bán",
RUNEBOOK5 = "Nhấp chọn",
RUNEBOOK6 = "Không bán Bùa đã gắn",
RUNEBOOK7 = "Toàn bộ Bùa Lv1",
RUNEBOOK8 = "Bán Bùa",
RUNEBOOK9 = "Hãy chọn vật phẩm cần bán",
RUNEBOOK10 = "Tạm chưa nhận Bùa này",
RUNEBOOK11 = "Bùa đã trang bị, đồng ý bán?",
RUNEBOOK12 = "Đồng ý bán Bùa này?",
RUNEBOOK13 = "Toàn bộ Bùa Lv2",
RUNEBOOK14 = "Toàn bộ Bùa Lv3",
RUNEBOOK15 = "Toàn bộ Bùa Lv4",
RUNEBOOK16 = "Tạm không có Bùa loại này",
RUNEBOOK17 = "Không có Bùa để bán",
RUNEBOOK18 = "Bán thất bại",
PVPRANK_PROTECTED_ATT1 = "Còn %d điểm sẽ mở bảo vệ bậc",
PVPRANK_PROTECTED_ATT2 = "Bảo vệ bậc đã mở",
BATTLE_RANK_LOSE_TIPS = "Điểm Dũng Sĩ không đủ, bảo vệ thất bại",
BATTLE_RANK_LOSE_TIPS2 = "Mở bảo vệ cấp bậc",
BATTLE_RANK_LOSE_TIPS3 = "Điểm lên cấp ngăn bị trừ sao",
BATTLE_RANK_WIN_TIPS = "Điểm đầy, tăng thêm 1 sao",
BATTLE_RANK_COMMON_TIPS = "Điểm đầy %d = 1 sao",
BATTLE_RANK_LOSE_ICON_TIPS1 = "Bảo vệ bậc Đồng, cấp bậc không đổi",
BATTLE_RANK_LOSE_ICON_TIPS2 = "Thưởng Điểm Dũng Sĩ, ngăn bị trừ sao",
BATTLE_RANK_LOSE_ICON_TIPS3 = "Bảo vệ Điểm Dũng Sĩ, bậc không đổi",
OWNMOUNT = "Đã có thú cưỡi này, tiếp tục mua?",
OWN1 = "Đã có %s, tiếp tục mua?",
VOICE_CHAT_NOT_SUPPORT = "Phiên bản này không hỗ trợ chức năng Voice, hãy cập nhật phiên bản mới nhất",
LUCKYGIFT3 = "Còn %d",
LUCKYGIFT4 = "Ngẫu nhiên",
FAKEROOM = "Không thể vào phòng này",
VOICE_CLICKMORE = "Đừng nhấp nút chat voice liên tục",
VOICE_RECORDING_ERROR = "Trong cảnh chat voice không thể thu âm",
VOICE_RECORDING_ERROR2 = "Đã dùng chat voice trực tiếp, không thể phát voice",
ACTIVITYCLOSE = "Hoạt động chưa mở",
VOICE_NOSUPPORT = "Chức năng này cần cài đặt phiên bản mới nhất mới được dùng, vui lòng tải và cài đặt",
CANTBUY = "Không thể mua vật phẩm này.",
VOICE_OPENSTR= "Hiện tại chức năng Voice đã đóng, xác nhận mở chức năng Voice?",
CANTOPER = "Người có quyền hạn cao hơn đã online, không thể thao tác nhiệm vụ Công Hội",
INPUT_KEY_SEARCH = "Nhập từ khóa để tìm",
INPUTRECT_NULL_ATT = "Nhập ID bạn bè hoặc từ khóa của tên để tìm",
SEARCH_NO_RESULT = "Không tìm thấy mục tiêu phù hợp",
LOAD_SLOT_NULL_TIP = "Không có ô trống để gắn",
RANK32 = "Top 32",
BUY_FIVEGEM_ATTENTION = [[<T C="255,236,193" S="20" P="0">Liên tục mua </T><T C="233,166,62" S="20" P="0">%d lần </T><T C="255,236,193" S="20" P="0">Pha Lê</T>]],
BUY_TIMES = "Mua %d lần",
DRAW_RUNE_ERROR = "Rút thưởng Bùa thất bại",
LEAGUE114 = [[Top 32]],
RUNE_EXPLAIN = 
[[
<T C="229,105,22" S="22">Hệ thống Bùa</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0"> Sau khi tăng cấp sẽ mở thêm ô.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0"> Có thể tốn Kim Cương Khóa mở ô bùa trước, nhưng không thay đổi cấp mở các ô khác</T><BR></BR>
<T C="255,89,74" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0"> Bùa tương ứng đạt cấp nhất định sẽ kích hoạt Dấu Thánh tương ứng, nhận thuộc tính cộng thêm.</T><BR>20</BR>
<T C="255,89,74" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0"> Ô Bùa 11-14 của mỗi loại Bùa cần tốn Quyển Bùa để mở.</T><BR>20</BR>
<T C="229,105,22" S="22">Nhận Bùa</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0"> Phó Bản Nhóm Vận Mệnh có thể nhận Bùa.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0"> Bùa có thể mua ở Tiệm Bùa</T><BR>20</BR>
<T C="229,105,22" S="22">Thu hồi Bùa</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0"> Có thể bán các Bùa dư để nhận Mảnh Bùa.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0"> Mảnh Bùa dùng để mua tại Tiệm Bùa.</T><BR></BR>
<T C="229,105,22" S="22">Bùa Công Hưởng</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0"> Mảnh Bùa đạt 2000 sẽ mở Cộng Hưởng Bùa.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Cần tốn 500 Mảnh Bùa để Cộng Hưởng Bùa.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Cộng Hưởng Bùa giúp tăng 2.5% thuộc tính nhân vật.</T><BR></BR>
]],
PHANTOM1 = "Ảo Hóa",
PHANTOM2 = "Rương Ảo Hóa",
PHANTOM3 = "Ảo Lực",
PHANTOM4 = [[<T C="255,236,193" S="24" SC="132,66,29" SE="1" SS="4">Có cơ hội nhận </T><T C="99,255,95" S="24" SC="132,66,29" SE="1" SS="4"> skin Thường</T>]],
PHANTOM5 = [[<T C="255,236,193" S="24" SC="132,66,29" SE="1" SS="4">Có cơ hội nhận </T><T C="93,222,254" S="24" SC="132,66,29" SE="1" SS="4"> skin Dũng Sĩ</T>]],
PHANTOM6 = [[<T C="255,236,193" S="24" SC="132,66,29" SE="1" SS="4">Có cơ hội nhận </T><T C="198,130,255" S="24" SC="132,66,29" SE="1" SS="4"> skin Sử Thi</T>]],

PHANTOM7 = "Có cơ hội nhận skin Master",
PHANTOM8 = "Ảo Lực",
PHANTOM9 = "Dùng Thẻ",
PHANTOM10 = "Ảo Hóa Lực",
PHANTOM11 = "Thẻ Thử Nghiệm",
PHANTOM12 = "Thường",
PHANTOM13 = "Dũng Sĩ",
PHANTOM14 = "Sử Thi",
PHANTOM15 = "Master",
PHANTOM16 = "Skin Ảo Hóa",
PHANTOM17 = "Ảo Hóa thành công",
PHANTOM18 = "Thời gian thử %d ngày",
PHANTOM19 = "Thời gian thử còn lại ",
PHANTOM_DESC =
[[
<T C="229,105,22" S="22">Ảo Hóa</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Sau khi kích hoạt Skin, có thể Ảo Hóa để thay đổi ngoại hình nhân vật.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Có thể chọn dùng kỹ năng ảo của Skin trong giao diện kỹ năng. Kỹ năng ảo đang dùng vẫn có hiệu lực khi không trong trạng thái Ảo Hóa.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Sau khi kích hoạt Skin, sẽ nhận được thuộc tính ban đầu. Phẩm chất Skin càng cao, thuộc tính ban đầu càng cao.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Luyện hóa và tăng bậc có thể tăng thuộc tính Skin. Thuộc tính luyện hóa tối đa tùy thuộc vào phẩm chất Skin.</T><BR></BR>
<T C="255,89,74" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0"> Kích hoạt tổ hợp Skin chỉ định sẽ mở hiệu quả Duyên Nợ, giúp tăng thêm thuộc tính.</T><BR></BR>
<T C="255,89,74" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> Thuộc tính của tất cả Skin được tính cộng dồn, không bị ảnh hưởng bởi trạng thái Ảo Hóa.</T><BR></BR>
<T C="255,89,74" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0"> Skin dưới phẩm chất cam có thể dùng Mảnh Skin để tăng phẩm chất skin.</T><BR></BR>
<T C="255,89,74" S="20" P="0">8.</T><T C="127,70,26" S="20" P="0"> Chỉ một số Skin có thể tăng đến phẩm chất Đỏ, mở kỹ năng POW đặc biệt.</T><BR></BR>
<T C="255,89,74" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0"> Chỉ một số được tăng đến phẩm chất Đỏ, chi tiết xem tại giao diện [Kỹ Năng Ảo-Chủ]</T><BR></BR>
<T C="255,89,74" S="20" P="0">10.</T><T C="127,70,26" S="20" P="0"> Skin đã kích hoạt vĩnh viễn sẽ nhận được Ảo Lực, dùng tăng cấp Ảo Hóa.</T><BR></BR>
<T C="255,89,74" S="20" P="0">11.</T><T C="127,70,26" S="20" P="0"> Skin được kích hoạt bằng Thẻ Thử Nghiệm chỉ có thể thay đổi ngoại hình nhân vật, không thể luyện hóa, tăng bậc, tăng phẩm chất.</T><BR></BR>
]],
PHANTOM20 = "Mở rương",
PHANTOM21 = "Rương Thường",
PHANTOM22 = "Rương Hiếm",
PHANTOM23 = "Rương Sử Thi",
PHANTOM_CHEST_DESC =
[[
<T C="229,105,22" S="22">Rương Ảo Hóa</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Tốn số lượng Tinh Thạch Ảo Hóa nhất định có thể mở Rương Ảo Hóa</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Mở Rương Ảo Hóa có cơ hội nhận skin vĩnh viễn</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Nhận skin vĩnh viễn đã có sẽ chuyển thành Tinh Thạch Ảo Hóa</T><BR></BR>
]],
PHANTOM24 = "Đã có skin này, chuyển thành ",
COMMENT1 = "Nếu thích trò chơi này, hãy đến bình luận nhé!",
COMMENT2 = "Bình luận ngay",
COMMENT3 = "Lần sau",
COMMENT4 = "Từ chối",
TABOO_BOX_OPEN_NOW = "Mở ngay",
TABOO_BOX_OPEN_LOCK = "Nhấp mở khóa",
TABOO_BOX_OPEN = "Nhấp mở",
TABOO_BOX_EMPTY = "Rương trống",
TABOO_BOX_GET_DES = "Có thể nhận 1 phần thưởng sau đây",
TABOO_BOX_TITLE1 = "Mở khóa rương",
TABOO_BOX_TITLE2 = "Mở rương",
TABOO_BOX_TITLE3 = "Rương Bất Ngờ",
TABOO_BOX_OPEN_START = "Bắt đầu mở khóa",
TABOO_BOX_OPEN_CANCEL = "Vứt bỏ",
TABOO_BOX_OPEN_CANCEL2 = "Bỏ rương mới",
--TABOO_BOX_OPEN_CANCEL = "Vứt bỏ\n(Vứt bỏ là mất)",
TABOO_BOX_OPEN_COMMON_DES = "May mắn đấy, nhặt được 1 Rương Bất Ngờ!",
TABOO_BOX_DISCARD = "Đồng ý vứt bỏ rương này?\n(Vứt bỏ sẽ không thể tìm lại)",
TABOO_DICE_RUSH = "Hồi phục còn: ",
TABOO_BOX_OUT = "Không đủ ô rương, không nhận được rương này",
TABOO_EVENT_1 = "Nhận được %d Xúc Xắc",
TABOO_EVENT_2 = "Đi tiếp %d bước",
TABOO_EVENT_3 = "Lùi lại %d bước",
TABOO_EVENT_4 = "Chuyển đến vị trí khác",
TABOO_EVENT_5 = "Đã xóa thời gian mở khóa rương",
TABOO_BOX_OPENING = "Cùng lúc chỉ được mở khóa 1 rương",
TABOO_BOX_OPEN_COMMON_DES_1 = "Ô rương đã đầy, mở ngay rương đã mở khóa có thể nhận rương mới",
TABOO_BOX_OPEN_COMMON_DES_2 = "Ô rương đã đầy, mở ngay rương đang mở khóa có thể nhận rương mới",
BUY_FIVETOUZI_ATTENTION = [[<T C="255,236,193" S="20" P="0">Liên tục mua </T><T C="233,166,62" S="20" P="0">%d lần </T><T C="255,236,193" S="20" P="0">Xúc Xắc</T>]],
PHANTOM25 = "Chưa dùng",
TABOO_DIR_FRONT = "Đi tiếp",
TABOO_DIR_BACK = "Lùi lại",
PHANTOM26 = "Mảnh skin",
PHANTOM27 = "Đồng hành",
PHANTOM28 = "Hủy Ảo Hóa thành công",
TABOO_CELL_END = "Điểm đến",
PHANTOM29 = "Hiệu quả bị động",
PHANTOM30 = "Hiện skin",
PHANTOM31 = "Hãy Ảo Hóa trước",
TABOO_BOX_OPEN_ALREADY = "Đã mở khóa",
TABOO_DESC = 
[[
<T C="229,105,22" S="22">Đất Cấm</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Đất Cấm mỗi lần tốn 1 Xúc Xắc</T><BR></BR>
<T C="255,89,74" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Xúc Xắc Đất Cấm mỗi 60 phút hồi 1 viên, không hồi tiếp sau khi đạt giới hạn</T><BR></BR>
<T C="255,89,74" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0"> Sau khi đến điểm cuối sẽ trở về điểm bắt đầu và ngẫu nhiên tạo mới chương bản đồ.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Rương của chương khác nhau sẽ có Thẻ Thử Nghiệm của skin khác nhau.</T><BR></BR>
<T C="255,89,74" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Chỉ có 10 ô rương, tất cả chương đều dùng chung, khi đầy không thể nhận thêm rương mới, trừ phi mở ngay những rương đã hoặc đang mở khóa</T><BR></BR>
<T C="255,89,74" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Mỗi ngày được mua Xúc Xắc, cấp VIP khác nhau giới hạn số lượng Xúc Xắc được mua mỗi ngày khác nhau, 24h mỗi ngày tạo mới</T><BR></BR>
<T C="255,89,74" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0"> Sau khi nhận sẽ tự động lần lượt mở khóa, mở khóa rương cần thời gian nhất định, rương phẩm chất càng tốt, thời gian cần càng lâu, nội dung cũng càng phong phú hơn</T><BR></BR>
<T C="255,89,74" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0"> Trong rương có thể nhận Tinh Thạch Lục và Tinh Thạch Lam, có thể dùng để đổi Mảnh Skin trong Tiệm Tinh Thạch.</T><BR></BR>
<T C="255,89,74" S="20" P="0">9. </T><T C="127,70,26" S="20" P="0"> Khi giẫm vào Ô Xúc Xắc Điều Khiển Từ Xa sẽ nhận Xúc Xắc Điều Khiển Từ Xa, có thể tốn Xúc Xắc Điều Khiển Từ Xa để chỉ định số bước cho lần đi tiếp theo.</T><BR></BR>
<T C="255,89,74" S="20" P="0">10. </T><T C="127,70,26" S="20" P="0"> Mỗi lần đến điểm cuối là 1 vòng, hoàn thành số vòng nhất định có thể nhận thưởng vòng chạy, thưởng vòng chạy tạo mới vào 00:00 Thứ 2 hàng tuần.</T><BR></BR>
]],
SECTION_WORD = "Chương thứ %d",
WEEK_DAY = "Thời gian Thẻ Tuần còn",
VIP_WEB = "Nạp Thẻ Qua Web",
VIP_WEB_DESC = "Mỗi ngày nạp thẻ qua trang web 3 lần đầu sẽ nhận được thêm phần thưởng đặc biệt",
VIP_WEB_REWARD = "Phần thưởng nạp lần thứ %d",
VIP_WEB_REWARD2 = "Hôm nay đã hoàn thành 3 lần nạp",
VIP_WEB_GO = "Nạp qua web",
NO_ATTR_ADD = "không có thuộc tính cộng dồn",
MULTI_ROOM_EMPTY = "Phòng không tồn tại",
NOORANGE = "Chưa có trang bị Cam",
WAKEUP_TEXT1 = {"Thức Tỉnh", "Hồn Thức Tỉnh", "Thể Thức Tỉnh", "Sức Mạnh Thức Tỉnh", "Kỹ Năng Thức Tỉnh", "Thức Tỉnh-Tiến Hóa"},
WAKEUP_TEXT2 = {"Bậc 1-Hồn ", "Bậc 2-Thể ", "Bậc 3-Lực ", "Bậc 4-Kỹ ", "Bậc 5-Tiến Hóa"},
WAKEUP_TEXT3 = "Điều Kiện",
WAKEUP_TEXT4 = "Tiêu Hao",
WAKEUP_TEXT5 = "Thức Tỉnh",
WAKEUP_TEXT6 = {"Kích hoạt-Hồn Thức Tỉnh ", "Kích hoạt-Thể Thức Tỉnh ", "Kích hoạt-Sức Mạnh Thức Tỉnh ", "Kích hoạt-Kỹ Năng Thức Tỉnh ", "Kích hoạt-Thức Tỉnh-Tiến Hóa"},
WAKEUP_TEXT7 = {"Hồn Thức Tỉnh đã mở ", "Thể Thức Tỉnh đã mở ", "Sức Mạnh Thức Tỉnh đã mở ", "Kỹ Năng Thức Tỉnh đã mở ", "Thức Tỉnh-Tiến Hóa đã mở"},
WAKEUP_TEXT8 = "Đã hoàn thành",
WAKEUP_TEXT9 = {"Nuôi dưỡng-Thường", "Nuôi dưỡng-Trung", "nuôi dưỡng-Cao", "Nuôi dưỡng-Siêu"},
WAKEUP_TEXT10 = "Lên cấp có thể nhận %d điểm thiên phú",
WAKEUP_TEXT11 = "Điểm thiên phú",
WAKEUP_TEXT12 = "Mỗi lần nuôi dưỡng tốn %d đạo cụ",
WAKEUP_TEXT13 = "Đến Ảo Hóa",
WAKEUP_TEXT14 = "Sau khi Thức Tỉnh %s có thể nhận",
WAKEUP_TEXT15 =
[[
<T C="229,105,22" S="22">Tính năng Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Hoàn thành 5 giai đoạn Thức Tỉnh, sẽ lần lượt mở 5 tính năng.</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Bậc 1-Hồn: Hoàn thành sẽ mở Hồn Thức Tỉnh, đạt cấp nhất định mới được mở Thức Tỉnh tiếp theo.</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Bậc 2-Thể: Hoàn thành được nhận Skin Thức Tỉnh vĩnh viễn.</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Bậc 3-Lực: Hoàn thành sẽ kích hoạt kỹ năng thiên phú.</T><BR></BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Bậc 4-Kỹ: Hoàn thành sẽ có thể dùng kỹ năng Thức Tỉnh trong chiến đấu.</T><BR></BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">Bậc 5-Tiến Hóa: Hoàn thành sẽ mở tính năng Thức Tỉnh-Tiến Hóa.</T><BR></BR>
]],
WAKEUP_TEXT16 = "[Điều kiện %d]",
WAKEUP_TEXT17 = "Hãy lên cấp đã",
WAKEUP_TEXT18 = "Hãy hoàn thành toàn bộ điều kiện Thức Tỉnh trước",
WAKEUP_TEXT19 = "EXP",
WAKEUP_TEXT20 = 
[[
<T C="229,105,22" S="22">Hồn Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 1-Hồn mở Hồn Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Hồn Thức Tỉnh có thể dùng Đá Thức Tỉnh nuôi dưỡng nhận EXP để tăng cấp.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Sau khi tăng cấp Hồn Thức Tỉnh, có thể nhận thuộc tính cao hơn và điểm thiên phú.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Cấp của Hồn Thức Tỉnh là điều kiện Thức Tỉnh, cần đạt cấp nhất định để tiếp tục Thức Tỉnh.</T><BR></BR>
]],
WAKEUP_TEXT21 = 
[[
<T C="229,105,22" S="22">Thể Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 2-Thể mở Thể Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thông qua tính năng Thể Thức Tỉnh người chơi có thể nhận bộ skin Thức Tỉnh vĩnh viễn.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Skin Thức Tỉnh đẹp, kỹ năng hữu ích và hiệu quả.</T><BR></BR>
]],
WAKEUP_TEXT22 = 
[[
<T C="229,105,22" S="22">Sức Mạnh Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 3-Lực mở Sức Mạnh Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thông qua chức năng Lực Thức Tỉnh có thể dùng điểm thiên phú để học thiên phú, nhận đạo cụ thưởng hoặc thuộc tính tăng.</T><BR></BR>
]],
WAKEUP_TEXT23 = 
[[
<T C="229,105,22" S="22">Kỹ Năng Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 4-Kỹ mở Kỹ Năng Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Kỹ năng Thức Tỉnh, dùng thay đổi điểm hành động trong chiến đấu</T><BR></BR>
]],
PROPERTYINFO1 = "Thông tin thuộc tính",
EXTRACTION_TEXT1 = "Nhận",
EXTRACTION_TEXT2 = "Ngọc",
EXTRACTION_TEXT3 = "Chúc phúc",
EXTRACTION_TEXT4 = "Tự thêm",
EXTRACTION_TEXT5 = "Giá tách",
EXTRACTION_TEXT6 = "Tổng nhận",
ONE_YEAR_ACTIVITY = "Quà Mừng Lễ",
INTEGRAL_VALUE = "Điểm tích lũy",
FIREWORKS_LIST = "Thưởng Bảng Pháo Hoa",
RANK_VALUE = "%d - %d",
NEWYEARTIP10 = "Đốt Pháo Hoa",
NEWYEARTIP6 = "Lần đăng nhập này không xem pháo hoa",
NEWYEARTIP1 = "Pháo hoa-Thường",
NEWYEARTIP2 = "Pháo hoa-Lớn",
NEWYEARTIP3 = "Pháo hoa-Hào Hoa",
NEWYEARTIP4 = "Thời gian chờ pháo hoa: ",
NEWYEARTIP5 = "Quy tắc: Tốn Kim Cương để phát hiệu ứng pháo hoa toàn server",
NEWYEARTIP7 =
[[
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Thời gian: Mỗi ngày</T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4"> giờ chẵn, có thể nhận Lì Xì trong thành chính, mỗi lần có thể nhận 1 Lì Xì, 1 ngày có thể nhận </T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4"> Lì Xì, dùng Lì Xì có thể nhận ngẫu nhiên </T>
<I Z="0.8" P="1">ui/common/common_icon_zuanshi.png</I>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Thưởng.</T>
]],
NEWCOMMUNITY1 = "Cấp: ",
NEWCOMMUNITY2 = "Quản lý",
EXTRACTION_TEXT7 = {"Chưa có bùa để tách", "Chưa có trang bị để tách", "Chưa có Pet để tách", "Chưa có chúc phúc để tách"},
EXTRACTION_TEXT8 = "Phí tách",
PLAY_FIREWORKS_CLOSE = "Hoạt động Pháo Hoa đã kết thúc",
EXTRACTION_TEXT9 = "Đến Ghép",
EXTRACTION_TEXT10 = "Đến nhận",
EXTRACTION_TEXT11 = "Phân tích Đá Thức Tỉnh",
NEWCOMMUNITY3 = "Mời vào",
NEWCOMMUNITY4 = "Mời Ra",
RECHARGE_VALUE_TIP = "Nạp đạt mức tương ứng có thể nhận quà, mỗi quà chỉ có thể mua 1 lần!",
LOGIN_COUNT_SEVEN_TIP = "Hoạt động tích lũy đăng nhập 7 ngày có thể nhận danh hiệu riêng",
ONE_YEAR_DES =
[[
<T C="229,105,22" S="22">Hướng dẫn Sinh Nhật Đăng Nhập</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Mỗi ngày đăng nhập điểm danh có thể nhận thưởng</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Mỗi phần thưởng chỉ có thể nhận 1 lần</T><BR>20</BR>
<T C="229,105,22" S="22">Hướng dẫn Pháo Hoa Tưng Bừng</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Khi đốt Pháo Hoa, tất cả người chơi khác sẽ nhìn thấy</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Đốt Pháo Hoa có thể nhận điểm tích lũy, tiến hành xếp hạng dựa vào điểm tích lũy</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Trước khi hoạt động kết thúc 1 khoản thời gian sẽ ngừng chức năng đốt pháo hoa, sau khi hoạt động kết thúc sẽ gửi phần thưởng xếp hạng qua thư</T><BR>20</BR>
]],
RECHARGE_DOUBLE = "Nạp thẻ nhân đôi",
RECHARGE_DOUBLE_RULE = "Quy tắc: Mỗi mức chỉ có thể nhận 1 lần thưởng nạp nhân đôi",
REDPACK_ATT22 = "Số Lì Xì còn lại hôm nay: %d/%d",
GO_TO_WISHING = "Đến Cầu Nguyện",
WISHING_COME_BACK = "Cầu Nguyện trở lại",
WISHING_NOT_OPEN_TITLE = "Mừng Lễ Bí Mật",
WISHING_ONE_YEAR_TIP = "Mừng tròn 1 năm, Hồ Ước Nguyện sắp tái hiện",
PASS_OVER = "Đã nhận xong",
NEWCOMMUNITY5 = "Mời Ra",
NEWCOMMUNITY6 = "Trục xuất các thành viên đã chọn ra khỏi Công Hội?",
NEWCOMMUNITY7 = "Công Hội Chiến chưa mở",
NEWCOMMUNITY8 = "Không đủ quyền hạn",
NEWCOMMUNITY9 = "Thiết lập vào hội",
NEWCOMMUNITY10 = "Loại xét duyệt",
NEWCOMMUNITY11 = "Điều kiện hạn chế",
NEWCOMMUNITY12 = "Người chơi/Chức vụ",
ANNIV_END = "Hoạt động đã kết thúc",
ANNIV_END2 = "Hoạt động sẽ mở vào 16/6",
WAKEUP_TEXT24 = 
[[
<T C="229,105,22" S="22">Hồn Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 1-Hồn mở Hồn Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Hồn Thức Tỉnh có thể dùng Đá Thức Tỉnh để nuôi dưỡng và tăng cấp.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Tăng cấp Hồn Thức Tỉnh có thể nhận nhiều thuộc tính tăng và điểm thiên phú.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Cấp của Hồn Thức Tỉnh cũng là điều kiện Thức Tỉnh.</T><BR></BR>
]],
WAKEUP_TEXT25 = 
[[
<T C="229,105,22" S="22">Thể Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 2-Thể mở Thể Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thể Thức Tỉnh đã mở, có thể nhận skin Thức Tỉnh</T><BR></BR>
]],
WAKEUP_TEXT26 = 
[[
<T C="229,105,22" S="22">Sức Mạnh Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 3-Lực mở Sức Mạnh Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Sau khi mở Lực Thức Tỉnh, có thể tốn điểm thiên phú để học thiên phú.</T><BR></BR>
]],
WAKEUP_TEXT27 = 
[[
<T C="229,105,22" S="22">Kỹ Năng Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 4-Kỹ mở Kỹ Năng Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Sau khi mở Kỹ Năng Thức Tỉnh, có thể học các kỹ năng Thức Tỉnh để chiến đấu.</T><BR></BR>
]],
ACTIVITY_START_TITLE = "Thông báo hoạt động Kỷ Niệm (Hoạt động mở vào 16/6)",
ACTIVITY_START_TIP_1 = "1. Tặng quà khi đăng nhập (Kim Cương, Vàng, danh hiệu riêng)",
ACTIVITY_START_TIP_2 = "2. Chúc phúc khẩu lệnh (Tặng 616 Kim Cương!)",
ACTIVITY_START_TIP_3 = "3. Quà Lớn Kỷ Niệm (Tặng skin Cam!)",
ACTIVITY_START_TIP_4 = "4. Lễ Hội Pháo Hoa (Pháo hoa tỏa sáng trên bầu trời)",
ACTIVITY_START_TIP_5 = "Còn nhiều hoạt động khác",
WECHATTIPS1 =  "Chia sẻ có thể nhận thưởng trên",
WECHATTIPS2 =  "Hoàn thành nhiệm vụ chia sẻ mỗi ngày để nhận thưởng",
Promise1 = 
[[
<T C="255,227,116" SC="79,60,48" SS="4" S="22" P="1" SE="1">Nạp mức bất kỳ có thể nhận thêm</T>
<T C="93,222,254" SC="79,60,48" SS="4" S="30" P="1" SE="1">%d</T>
<T C="255,227,116" SC="79,60,48" SS="4" S="22" P="1" SE="1"> phúc lợi Kim Cương gấp bội</T>
]],
WAKEUP_TEXT28 = "Hãy chọn vật phẩm cần tách",
WAKEUP_TEXT29 = "Hãy chọn vật phẩm bên phải để tách",
WAKEUP_TEXT30 = "Ô tách đã đầy, hãy tách trước",
SEND_FIREWORK_TIP = "Đang đốt pháo hoa, hãy quay lại sau",
CLICK_TO_OPEN_REDBOX = "Nhấp mở Lì Xì",
WAKEUP_TEXT31 = "Tất cả vật phẩm đã trong ô tách",
WAKEUP_TEXT32 = "Không có vật phẩm để thêm",
WAKEUP_TEXT33 = "Vật phẩm phẩm chất cao không thể tự thêm",
WAKEUP_TEXT34 = "Có vật phẩm phẩm chất cao sẽ được tách, đồng ý tiếp tục?",
WAKEUP_TEXT35 = "Kích hoạt thuộc tính thưởng",
TIPS11 = [[<T C="138,122,106" S="20" P="0">Chưa Thức Tỉnh</T>]], 
TIPS12 = [[Bậc %d]], 
TIPS13 = [[Tăng bậc Thức Tỉnh]],
TIPS14 = [[Hồn Thức Tỉnh: ]],
LEAGUE_NOT_SEND = "Chưa phát",
ACTIVITY_YEAR_END = "Hoạt động đã kết thúc",
RECHARGE_YEAR_ACTIVITY_BAG = "Đang mua, vui lòng đợi",
COMPETE_TASK_NO_DATA = "Đã hoàn thành tất cả mục tiêu",
WAKEUP1 = "Nhật ký dùng",
WAKEUP2 = "Dùng 5 lần",
WAKEUP3 = [[<T C="195,171,148" S="22" P="0">Lần %d, %d->%d, chưa bạo kích nhận %d EXP</T>]],
WAKEUP4 = [[<T C="195,171,148" S="22" P="0">Lần %d, %d->%d, bạo kích x%d, nhận %d EXP</T>]],
WAKEUP5 = [[<T C="195,171,148" S="22" P="0">Dùng %d lần, Hồn Thức Tỉnh tăng đến Lv%d, nhận %d EXP</T>]],

ITEM_LIST = "Danh sách vật phẩm",
SETTING_COMMENT = "Bình luận: ",
WAKEUP6 = "Đá Thức Tỉnh",
ORANGE_COLOR = "Cam",
PURPLE_COLOR = "Tím",
BLUE_COLOR = "Lam",
GREEN_COLOR = "Lục",
FRAGMENT = "Mảnh",
HANDLE_PRODUCT = "Bao Tay",
ITEM1 = "Vật phẩm tốn",
ITEM2 = "Đạo cụ xã hội",
ITEM3 = "Mặt",
ITEM4 = "Loại cân bằng",
ITEM5 = "Loại tấn công",
ITEM6 = "Loại phòng thủ",
ITEM7 = "Loại sinh lực",
ITEM8 = "Rèn",
ITEM9 = "Mảnh Đạo Cụ",
ITEM10 = "Mảnh Skin",
ITEM11 = "Mảnh Thời Trang",
ITEM12 = "Mảnh Trang Bị",
CURRENT_TYPE = "(Hiện tại)",
ONLINE_REWARD_RECEVICED = "Đã nhận hết thưởng online hôm nay",
FAST_GET_ITEM = "Chưa thể nhận",
CONSUME_FIRST = "Ưu tiên tốn %s",
ZHANYANGTIME = "Hôm nay đã lễ bái Vật Tổ",
GAME_ACTIVITY_TITLE46 = "Tích lũy tiêu phí",
GAME_ACTIVITY_TITLE47 = "Ưu Đãi Giới Hạn",
GAME_ACTIVITY_TITLE48 = "Ưu đãi vật phẩm mới",
GAME_ACTIVITY_TITLE49 = "Quà ưu đãi",
NEWBAG1 = "Tủ Đồ",
NEWBAG2 = "Bảo vệ",
NEWBAG3 = "Túi Thời Trang",
NEWBAG4 = "Lực chiến Ảo Hóa: ",
NEWBAG5 = "Trang bị nhanh",
NEWBAG6 = "Thuộc tính trang bị",
NEWBAG7 = "Lực chiến trang bị: ",
RUNE_FIGHT = "Lực chiến Bùa",
NEWBAG8 = "Bông Tai",
NEWBAG9 = "Trợ Thủ",
NEWBAG11 = "Lực chiến Tủ Áo: ",
DESIGNATION_NO_POINT = "Không có điểm thành tựu",
SUMMER_VACTION_DES =
[[
<T C="229,105,22" S="22">Mùa Hè</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Mua Skin Mùa Hè có thể nhận thêm Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Skin Mùa Hè chỉ được mua 1 lần (Đơn hàng có thể trễ, đừng chi trả lần nữa)</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Mua Skin không tăng EXP VIP</T><BR>20</BR>
<T C="229,105,22" S="22">Ưu Đãi Hè</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Mỗi Quà Ưu Đãi Hè mỗi ngày được mua 1 (Đơn hàng có thể trễ đừng chi trả lần nữa)</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Quà Ưu Đãi Hè 24:00 mỗi ngày tạo mới số lần mua</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Quà Ưu Đãi Siêu không tăng EXP VIP</T><BR>20</BR>
<T C="229,105,22" S="22">Thưởng Hè</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Mỗi ngày ngẫu nhiên tạo mới 4 Quái Truy Nã Thưởng (24:00 tạo mới)</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Diệt Quái Truy Nã đạt số lượng chỉ định có thể hoàn thành nhiệm vụ và nhận thưởng (Càn quét không tính)</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Diệt Quái Truy Nã khi đã tổ đội, thành viên được xem như hoàn thành diệt</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18"> Điểm thưởng toàn server căn cứ điểm thưởng diệt cá nhân tích lũy, đạt mức nhất định cần nhận thủ công thưởng giai đoạn tương ứng</T><BR>20</BR>
<T C="229,105,22" S="22">Khuyến Mãi Hè</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Khuyến Mãi Hè giới hạn số lượng mua, đạt giới hạn không thể mua tiếp</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Vật phẩm Khuyến Mãi Hè cách một thời gian sẽ có vật phẩm mới lên kệ</T><BR>20</BR>
]],
FULL_SERVICE_SCORE = "Điểm thưởng toàn server",
THE_WANTED = "Truy Nã hôm nay",
BOUGHT = "Đã mua",
KILL_REWARD_TIP = "Diệt kẻ bị truy nã có thể nhận điểm thưởng, điểm thưởng toàn server đạt %d nhận thưởng",
BUY_SKIN_GET = "Mua Skin tặng",
BOUNTY = "Điểm thưởng: ",
SUMMER_VACTION_1 = "Mùa Hè",
SUMMER_VACTION_2 = "Ưu Đãi Hè",
SUMMER_VACTION_3 = "Thưởng Hè",
SUMMER_VACTION_4 = "Khuyến Mãi Hè",
SUMMER_VACTION_DES_1 = "Skin Hè Băng Tuyết Rơi",
SUMMER_VACTION_DES_2 = "Mua nhận nhiều ưu đãi",
SUMMER_VACTION_DES_3 = "Cùng hợp sức nhận quà lớn",
SUMMER_VACTION_DES_4 = [[Khuyến mãi "Giá thấp nhất"]],
SUMMER_VACTION_START_T = "Hoạt động đặc sắc %s mở",
SHOPBUY1 = "Đã mua tổng cộng %s vật phẩm %s, cần trả",
SUMMER_END = "Ngày Hội Mùa Hè đã kết thúc",
COPY_CHAPTER_NOT_OPEN_TIP = "Chương mục tiêu chưa mở",
SUMMER_BUY_FASHION_TIP = "Mùa hè sôi động, bán có giới hạn",
WARN_DESC3 = [[<T C="255,236,193" S="12" P="0" SC="138,122,106" SE="1" SS="2">ISSN: ISBN 978-7-7979-0084-3   Bản quyền: 2015SR235509   Sản xuất: ZHWYD</T>]],
DECOMPRESSION = "Đang giải nén dữ liệu, xin đợi",
NEWACTIVITY_TEXT2 = "Sử dụng nhận phần thưởng",

TEACH_181 = "Nhấp vào trạng thái viết",
TEACH_182 = "Nhấp kỹ năng cần mang theo",
TEACH_183 = "Đến trang đạo cụ",
TEACH_184 = "Nhấp đạo cụ cần mang theo",
TEACH_185 = "Hãy thử hiệu quả kỹ năng mới",
NEWSKILL1 = "Chiến đấu mang theo",
NEWSKILL2 = "Danh sách kỹ năng",
NEWSKILL3 = "Chờ: ",
NEWSKILL4 = "Hướng dẫn: ",
NEWSKILL5 = "Cấp kế",
NEWSKILL6 = "Nhật ký thao tác",
NEWSKILL7 = [[<T C="255,227,116" S="16" P="0">%s kế thừa từ vũ khí Lv%s%s %s sao</T><BR>8</BR>]],
NEWSKILL8 = [[<T C="255,227,116" S="16" P="0">Kích hoạt %s thành công</T><BR>8</BR>]],
NEWSKILL9 = [[<T C="255,227,116" S="16" P="0">Tăng cấp kỹ năng, %s tốn %s điểm kỹ năng</T><BR>8</BR>]],
NEWSKILL10 = "Kỹ năng có thể học",
NEWSKILL11 = "Kỹ năng đã đạt cấp tối đa",
NEWSKILL12 = "Xem trước hiệu quả",
NEWSKILL13 = "Điểm kỹ năng không đủ",
NEWSKILL14 = "Lên cấp thành công",
NEWSKILL15 = "Kích hoạt thành công",
NEWSKILL16 = "Học thành công",
NEWSKILL17 = "Học",
NEWSKILL18 = "Kỹ năng có thể trang bị",
NEWSKILL19 = "Trang bị tối thiểu 1 kỹ năng",
NEWSKILL20 = "Đạo cụ có thể kích hoạt",
PLAYER_NAME_LEVEL = [[<T C="255,227,116" S="18"  SE="1" SS="4" SC="105,65,46" >%s </T><T C="255,255,255" S="18"  SE="1" SS="4" SC="79,60,48" >%s</T>]],
PLAYER_NAME_LEVEL2 = [[<T C="255,227,116" S="18"  SE="1" SS="4" SC="105,65,46" >%s </T><T C="99,255,95" S="18"  SE="1" SS="4" SC="79,60,48" >%s</T>]],
NEWLEAGUE1 = [[Hạng:]],
NEWLEAGUE2 = [[Điểm vòng loại:]],
NEWPRACTICE1 = "Lấy %s lần",
NEWPRACTICE2 =
[[
<T C="255,89,74" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0"> Mỗi tốn 1 thể lực được nhận 10 điểm tu luyện, khi lấy điểm tu luyện sẽ chuyển thành EXP thuộc tính</T><BR></BR>
<T C="255,89,74" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0"> Mỗi lần tu luyện sẽ nhận ngẫu nhiên 3 loại hiệu quả (Sinh lực, tấn công, phòng thủ, thể chất, sức mạnh, hộ giáp, EXP)</T><BR></BR>
<T C="255,89,74" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Hiệu quả thuộc tính nhận được từ tu luyện sẽ tăng EXP tu luyện của thuộc tính đó, nếu có 2 hoặc 3 loại hiệu quả thuộc tính lặp lại thì EXP tu luyện thuộc tính tăng vẫn được cộng thêm</T><BR></BR>
<T C="255,89,74" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Hiệu quả EXP nhận được từ tu luyện vẫn sẽ tăng cho EXP tu luyện thuộc tính, nếu đồng thời nhận được 3 loại đều là EXP thì đều tăng EXP tu luyện tất cả thuộc tính.</T><BR>20</BR>
]],
FAMILY_TEXT1 = "Xây Vườn",
FAMILY_TEXT2 = [[<T C="127,70,26" S="22" P="1">Đồng ý tốn </T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="22" P="1">x%d xây Vườn</T>]],
FAMILY_TEXT3 = "Độ Hào Hoa",
FAMILY_TEXT4 = "Thu thập",
FAMILY_TEXT5 = "Đồng ý trả %d %s tăng tốc lên cấp %s?",
FAMILY_TEXT6 = "Đồng ý trả %d %s tăng tốc xây %s?",
FAMILY_TEXT7 = "Đồng ý trả %d %s tăng tốc hủy %s?",
FAMILY_TEXT8 = "Tất cả Giúp Việc đều bận, đồng ý trả %d%s hoàn thành ngay 1 kiến trúc?",
FAMILY_TEXT9 = "Đồng ý hủy lên cấp %s, hủy sẽ không hoàn trả phí.",
FAMILY_TEXT10 = "Đồng ý hủy xây %s, hủy sẽ không hoàn trả phí.",
FAMILY_TEXT11 = "Đồng ý hủy bỏ %s, hủy sẽ hoàn trả 50%% phí.",
FAMILY_TEXT12 = "Dung lượng sản xuất: ",
FAMILY_TEXT13 = "Tốc độ sản xuất: ",
FAMILY_TEXT14 = "Đá Lạ tối đa: ",
FAMILY_TEXT15 = "Nước Thánh tối đa: ",
FAMILY_TEXT16 = "Đồng ý bán %s để đổi %d%s?",
FAMILY_TEXT17 = "Vườn cần đạt Lv%d",
FAMILY_TEXT18 = "Cần xây đạt Lv%d: %s%d",
SKILLNUM = "Điểm kỹ năng: ",
NEWSKILL21 = "Tạo mới kỹ năng thành công",
NEWSKILL22 = "Đồng ý dùng Thuốc Quên Kỹ Năng để tạo mới kỹ năng, tạo mới sẽ quên kỹ năng đã học và trả lại điểm kỹ năng",
FAMILYSHOP1 = "Kiến Trúc",
FAMILYSHOP2 = "Trang Sức",
FAMILYSHOP3 = "Tiệm Vườn",
NEWSKILL23 = "Hãy hủy sẵn sàng",
NEWSKILL24 = "Đang viết không thể tạo mới kỹ năng",
NEWSKILL26 = "Đang chỉnh sửa, không thể học kỹ năng",
NEWSKILL27 = "Đang chỉnh sửa, không thể nâng cấp kỹ năng",
NEWSKILL25 = "Đã dùng",
FAMILYSHOP4 = "Không đủ tài nguyên",
FAMILYSHOP5 = "Phòng Chủ Nhân đạt Lv%s mở khóa",
FAMILYSHOP6 = "Lên cấp Phòng Chủ Nhân có thể xây nhiều hơn",
FAMILYSHOP7 = "Hạng Vườn",
FAMILYSHOP8 = "Cấp Vườn",
FAMILYSHOP9 = "Chủ Nhân",
FAMILY_TEXT19 = "Hãy xây 1 Phòng Giúp Việc trước để có người lao động",
BUY_FIVEFAMILY_ATTENTION = [[<T C="255,236,193" S="20" P="0">Liên tục mua </T><T C="233,166,62" S="20" P="0"> %d lần</T><T C="255,236,193" S="20" P="0">%s</T>]],
FAMILY_TEXT20 = "Về Nhà",
FAMILY_TEXT21 = "Lật lại",
FAMILY_TEXT22 = "Có thể xây nhiều kiến trúc hơn",
FAMILY_TEXT23 = "Mở khóa thêm nhiều nhiều kiến trúc",
LOURAACT1 = "7 Ngày Vui Vẻ",
LOURAACT2 = "Nhanh Như Tia Chớp",
LOURAACT3 = "Chung Cư Tình Yêu",
LOURAACT4 = "Nạp thẻ nhân đôi",
LOURAACT5 = "Chia sẻ hoạt động",
LOURAACT6 = "Đề cử",
FAMILY_TEXT24 = "Đang tham quan...",
FAMILYSHOP10 = "Đã xây",
FAMILYSHOP11 = "Hạng bạn bè",
FAMILYSHOP12 = [[<T C="138,122,106" S="20" P="0">Chưa tạo</T>]], 
FAMILYSHOP13 = "Cần Phòng Chủ Nhân Lv%s",
LOURAACT7 = "Quy tắc: Mỗi ngày đăng nhập điểm danh nhận thưởng.",
LOURAACT8 = "Trong thời gian hoạt động thu thập đủ đạo cụ có thể nhận quà tương ứng.",
LOURAACT9 = "Ưu Đãi đặc biệt, số lượng có hạn.",
LOURAACT10 = "Thưởng chia sẻ lần đầu mỗi ngày: ",
FAMILYSHOP14 = "Cần Vườn Lv%s",
FAMILYSHOP15 = "BXH Server",
FAMILYSHOP16 = "BXH Toàn Server",
FAMILYSHOP17 = "1:00 thứ 2 mỗi tuần gửi thưởng qua thư",
FAMILYRANK_DESC =
[[
<T C="127,70,26" S="20" P="1">Hướng dẫn: </T><BR></BR>
<T C="127,70,26" S="20" P="1"> </T><BR></BR>
<T C="229,105,22" S="20" P="1">BXH chia thành: </T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">BXH gồm BXH Server, BXH Toàn Server, BXH Bạn Bè.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">Xếp hạng dựa theo độ hào hoa của Vườn.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="1">Chỉ có BXH Server, BXH Toàn Server được nhận thưởng hạng, BXH Bạn Bè không có thưởng hạng.</T><BR></BR>
<T C="127,70,26" S="20" P="1"> </T><BR></BR>
<T C="229,105,22" S="20" P="1">Phát thưởng: </T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">1:00 thứ 2 mỗi tuần gửi thưởng hạng qua thư.</T><BR></BR>
<T C="127,70,26" S="20" P="1"> </T><BR></BR>
]],
FAMILYSHOP18 = "Lần này xây miễn phí",
FAMILY_TEXT25 = "Nước Thánh",
FAMILY_TEXT26 = "Đá Lạ",
FAMILY_TEXT27 = "Kho không đủ chỗ, hãy tăng cấp Kho hoặc xây thêm Kho",
TEACH_186 = "Nhấp Tiệm Vườn",
TEACH_187 = "Chọn Kho",
TEACH_188 = "Đồng ý xây",
TEACH_189 = "Hãy chọn Máy Nước Thánh",
TEACH_190 = "Bắt đầu thu thập",
LOURAACT_DESC =
[[
<T C="229,105,22" S="22">Hướng dẫn</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Thời trang Long Cung, trong hoạt động Skin 11.11 chỉ được mua 1 lần, mua quà không tính EXP VIP, không tính hoạt động tích lũy</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Hoạt động đổi hạn giờ, tìm đủ đạo cụ liên quan có thể đổi ngay đạo cụ tương ứng</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Quà Trở Lại-Cực mỗi ngày giới hạn mua 1 lần, mua quà không tính EXP VIP, không tính hoạt động tích lũy</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Quà siêu giá trị mỗi ngày giới hạn mua 1 lần, hoạt động Quà Thánh Quang giới hạn mua 1 lần, mua quà không tính EXP VIP, không tính hoạt động tích lũy</T><BR>20</BR>
]],

LOURAACT14 = "Đừng bỏ lỡ Quà Siêu Cấp!",
LOURAACT11= "Thần Tài Đến",
LOURAACT12 = "Bán trước Skin",
LOURAACT2 = "Đổi hạn giờ",
LOURAACT3 = "Quà Siêu Cấp",
LOURAACT13 = "Mua giới hạn siêu giá trị",

FAMILY_TEXT28 = "Không có Giúp Việc rảnh, hãy xây nhiều Phòng Giúp Việc hoặc tăng tốc công việc đang làm.",
FAMILY_TEXT29 = "Đang sản xuất tài nguyên...",
FAMILY_TEXT30 = "Kiến trúc đã xây xong, không thể hủy",
FAMILY_TEXT31 = "Kiến trúc đã thăng cấp xong, không thể hủy",
FAMILY_TEXT32 = "Kiến trúc đã xóa, không thể hủy",
LIMITEQUIP1 = "Trang bị thử nghiệm [%s] đã quá hạn.",
USINGLIMITEQUIP = "Đang dùng trang bị hạn giờ, khi hết hạn cần giữ lại trang bị cùng loại để thay thế, tiếp tục?",
LIMITEQUIP2 = "Đang dùng trang bị hạn giờ, cần giữ lại 1 trang bị cùng loại để thay thế.",
NEWACTIVITY_TEXT1 = [[<T C="255,227,116" S="14" P="1" SC="105,65,46" SS="4" SE="1">Mỗi nạp %d </T><I Z="0.5" P="1">ui/common/common_icon_zuanshi.png</I><T C="255,227,116" S="14" P="1" SC="105,65,46" SS="4" SE="1"> được nhận 1 </T><I Z="0.3" P="1">shopitems/kf_chuizi.png</I><T C="255,227,116" S="14" P="1" SC="105,65,46" SS="4" SE="1">, (Đã tích lũy nạp %d</T><I Z="0.5" P="1">ui/common/common_icon_zuanshi.png</I><T C="255,227,116" S="14" P="1" SC="105,65,46" SS="4" SE="1">)</T>]],
NEWACTIVITY_TEXT3 = "Đã hết số lần mua",
NEWACTIVITY_TEXT4 = [[<T C="79,60,48" S="16" P="1" SC="105,65,46" SS="4" SE="0">Nhấp trứng cần đập, tốn 1 </T><I Z="0.3" P="1">shopitems/kf_chuizi.png</I><T C="79,60,48" S="16" P="1" SC="105,65,46" SS="4" SE="0"> (Hiện có %d)</T>]],
NEWACTIVITY_TEXT5 = "Đập lần nữa chắc chắn nhận thưởng cao",
NEWACTIVITY_TEXT6 = "Trống",
NEWACTIVITY_TEXT7 = "Được Thích %d lần",
NEWACTIVITY_TEXT8 = "Riêng",
NEWACTIVITY_TEXT9 = "Cấp VIP không đủ không thể mua, đồng ý tăng cấp VIP?",
NEWACTIVITY_TEXT10 = {"Quà Vượt Ải 1 Sao","Quà Vượt Ải 2 Sao","Quà Vượt Ải 3 Sao"},
NEWACTIVITY_TEXT11 = "Tích lũy nhận phó bản",
NEWACTIVITY_TEXT12 = "Đã không còn Búa, đồng ý nạp nhận nhiều hơn?",
NEWACTIVITY_TEXT13 = "Khi tổng kết hạng mỗi mùa sẽ phát thưởng",
NEWACTIVITY_TEXT14 = "Ưu đãi server mới",
NEWACTIVITY_TEXT15 = "Tăng bậc server mới",
NEWACTIVITY_TEXT16 = "Tích lũy nạp server mới",
NEWACTIVITY_TEXT17 = "Lực chiến server mới",
NEWACTIVITY_TEXT18 = "Đập trứng server mới",
NEWACTIVITY_TEXT19 = "Vòng quay server mới",
NEWACTIVITY_TEXT20 = "Phó bản server mới",
NEWACTIVITY_TEXT21 = "Dự phòng server mới",
NEWACTIVITY_TEXT22 = "Dự phòng server mới 2",
CUR_TURN_COUNT = "Số lần rút còn: %d",
CUR_TURN_COUNT_NOT = "Số lần còn không đủ",
DIAMONDS_TURNTABLE_TIP =
[[
<T C="229,105,22" S="22">Hướng dẫn nhận lượt</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Người chơi tham gia Vòng Quay Nhân Phẩm bằng cách nạp định mức bất kỳ sẽ nhận được lượt quay tương ứng.</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Người chơi đạt cấp độ VIP nhất định mỗi ngày sẽ nhận các lượt quay miễn phí tương ứng</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">VIP 0-2 : 1 lượt </T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">VIP 3 : 2 lượt</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">VIP 4 : 3 lượt</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">VIP 5 : 4 lượt</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">VIP 6 : 5 lượt</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">VIP 7 : 6 lượt</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">VIP 8 : 7 lượt</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">VIP 9 : 8 lượt</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">VIP 10 trở lên : 8 lượt</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Lưu ý: Số lượt quay miễn phí mỗi ngày sẽ không được cộng dồn qua ngày hôm sau và sẽ được xóa vào lúc 24h hàng ngày</T><BR></BR>

]],
CROSS_SERVICE_TIP = "Hiện không thể chat liên server",
CROSS_SERVICE_TIP2 = "Không hỗ trợ xem thông tin người chơi liên server",
CROSS_SERVICE = "Toàn server",
CROSS_SERVICE_TIP3 = "Sau khi liên server sẽ mở Đấu Hạng",
NEWSHOP1 = "Vật phẩm mới lên kệ",
NEWSHOP2 = "Giảm giá còn",
NEWSHOP3 = "Đã có set này",
NEWSHOP4 = "Xem trước",
NEWSHOP5 = "Danh sách mặc thử",
NEWSHOP6 = "Ưu đãi",
NEWSHOP7 = "Tầm Bảo",
NEWSHOP8 = "Kim Cương",
NEWSHOP9 = "Kho Báu",
NEWSHOP10 = "Điểm may mắn",
NEWSHOP11 = [[<T C="158,0,0" S="20" P="1">[Giá gốc </T><T C="5,180,0" S="20" P="1">%s</T><T C="158,0,0" S="20" P="1">]</T>]],
NEWSHOP12 = [[ phần trăm]],
NEWSHOP13 = [[Mỗi ngày mua giới hạn ưu đãi]],
NEWSHOP14 = [[Vật phẩm ưu đãi hôm nay]],
NEWSHOP15 = [[Giá gốc: ]],
NEWSHOP16 = [[Giá mua giới hạn: ]],
NEWSHOP17 = "Giảm\n-%s%s",
NEWSHOP18 = [[Đoạt Bảo %s lần, sẽ nhận được %s điểm may mắn]],
NEWSHOP19 = [[Điểm may mắn càng nhiều, tỉ lệ nhận vật phẩm hiếm càng cao]],
NEWSHOP20 = [[Lần sau lật thẻ tốn: ]],
NEWSHOP21 = [[Mỗi ngày miễn phí lật thẻ lần đầu]],
NEWSHOP22 = [[Đá Mắt Phượng]],
NEWSHOP23 = [[Đá Mắt Phượng]],
NEWSHOP24 = [[Xu Ban Ân]],
NEWSHOP25 = [[Tranh mua còn: ]],
EQUIPSTORE = "Tiệm Trang Bị",
NEWACTIVITY_FIGHTINGLIST_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc hoạt động Lực Chiến</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoạt động kéo dài 4 tuần, 2 tuần đầu sẽ chọn Top 10 Vua Lực Chiến, 2 tuần cuối tất cả người chơi có thể chọn Thích；</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Mỗi ngày, mỗi người có thể chọn Thích 1 Vua Lực Chiến, chọn xong sẽ nhận được Thể Lực；</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Vua Lực Chiến sẽ được nhận thưởng Vàng theo tổng lượt được Thích mỗi ngày；</T><BR>10</BR>
]],
ADVISE_HERO_DESC = "Có thể đến trang CSKH tìm kiếm vấn đề thường gặp trong game, đồng thời giao lưu online!",
ADVISE_HERO = "Đến trang CSKH",
DRAW_LUCKY_TIP = "",
BUY2 = "Mua",
DRAW_TIP_FREE_TEXT = [[
<T C="255,236,193" S="20" P="0" SC="132,66,29" SE="1" SS="4">%s</T>
<I Z="0.4">%s</I>
<T C="255,236,193" S="20" P="0" SC="132,66,29" SE="1" SS="4">%s</T>
<I Z="0.4">%s</I>
]],
DRAW_TIP_FREE_TEXT_ADDITIONAL = [[
<T C="255,236,193" S="16" P="0" SC="132,66,29" SE="1" SS="4">(Tặng rút </T>
<T C="99,255,95" S="16" P="0" SC="132,66,29" SE="1" SS="4">%s</T>
<T C="255,236,193" S="16" P="0" SC="132,66,29" SE="1" SS="4"> lần)</T>
]],

SEND_DRAW_COUNT = "Tặng Gọi %d lần",
DRAW_TIP_FREE_TEXT2 = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4">%s</T><T C="93,222,254" S="18" P="1" SC="132,66,29" SE="1" SS="4">%d</T><T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4">%s</T>]],
DRAW_RUNE_TIP2 = "Tặng rút",
DRAW_COUNT = " lần",
PET_BUY_GOLD1 = "Mua",
PET_BUY_GOLD2 = "Mua 10000",
PET_BUY_GOLDDESC1 = [[
<T C="255,236,193" S="16" P="0" SC="132,66,29" SE="1" SS="4">(Tặng gọi </T>
<T C="99,255,95" S="16" P="0" SC="132,66,29" SE="1" SS="4">1</T>
<T C="255,236,193" S="16" P="0" SC="132,66,29" SE="1" SS="4"> lần)</T>
]],
PET_BUY_GOLDDESC2 = [[
<T C="255,236,193" S="16" P="0" SC="132,66,29" SE="1" SS="4">(Tặng gọi </T>
<T C="99,255,95" S="16" P="0" SC="132,66,29" SE="1" SS="4">10</T>
<T C="255,236,193" S="16" P="0" SC="132,66,29" SE="1" SS="4"> lần)</T>
]],
TEACH_191 = "Bắn theo đường nhắm",
TEACH_192 = "Nhấp hạng 1 BXH",
TEACH_193 = "Mỗi ngày tiến hành Thích sẽ được nhận thể lực",
TEACH_194 = "Lễ Đường là nơi tham gia hôn lễ của người khác, có thể nhận được Lì Xì",
TEACH_195 = "Cầu hôn là một việc rất lãng mạn, cùng tìm hiểu nào",
TEACH_196 = "Tìm hiểu điều kiện kết hôn",
TEACH_197 = "Đấu Hạng thi đấu công bằng đã mở",
TEACH_198 = "Thuộc tính nhân vật Đấu Hạng đều bằng nhau",
TEACH_199 = "Xem thuộc tính nhân vật",
TEACH_200 = "Kích hoạt thú cưỡi sẽ tăng thuộc tính",
TEACH_201 = "Tăng cấp thú cưỡi nhận hiệu quả thuộc tính cao hơn",
TEACH_202 = "Tốn Vàng tăng cấp thú cưỡi",
TEACH_203 = "Cách chơi mới đã mở",
TEACH_204 = "Vào Đất Cấm thần bí",
TEACH_205 = "Cấp càng cao mở khóa càng nhiều khu vực",
TEACH_206 = "Hãy ném Xúc Xắc tiến hành Mạo Hiểm",
TEACH_207 = "Tiếp tục online %d phút sẽ được nhận vũ khí",
TEACH_208 = "Mau đến nhận vũ khí Tím",
TEACH_209 = "Tiếp tục online %d phút sẽ được nhận danh hiệu",
TEACH_210 = "Mau đến nhận danh hiệu",
TEACH_211 = "Đang có Nộ Hỏa, hãy dùng POW đánh xuyên gỗ!",
FINISH_TASK_UPDATE_TIP = "Cách lên cấp nhanh",
CAN_BE_GET_REWARD1 = " có thể nhận thưởng",
TOTALLOGIN_DESC =
[[
<T C="158,0,0" S="22" P="0">1. </T><T C="62,34,8" S="22" P="0"> Tích lũy đăng nhập số ngày chỉ định được nhận thưởng tương ứng</T><BR></BR>
]],
SELLINFO1 = "Xác nhận thu hồi Thẻ Đổi Thú Cưỡi?",
STRENGTHEN_RULE1 = 
[[
<T C="229,105,22" S="22">Cường hóa cần tốn Vàng và cấp cường hóa phải thấp hơn cấp nhân vật.</T><BR></BR>
]],
STRENGTHEN_RULE2 = 
[[
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Kế thừa vũ khí có thể kế thừa kỹ năng của vũ khí tương ứng</T><BR></BR>
<T C="229,105,22" S="22">2. </T><T C="127,70,26" S="18">Kỹ năng vũ khí được kế thừa sẽ khôi phục về kỹ năng mặc định</T><BR>10</BR>
]],
STRENGTHEN_RULE3 = 
[[
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Mỗi lần tăng sao cần tốn Đá Sao, Vàng, Đá Thánh.</T><BR></BR>
<T C="229,105,22" S="22">2. </T><T C="127,70,26" S="18">Tăng sao dù thành công hay thất bại đều trừ vật phẩm tốn.</T><BR></BR>
<T C="229,105,22" S="22">3. </T><T C="127,70,26" S="18">Cấp tăng sao từ 3 trở xuống, thất bại không bị giảm cấp.</T><BR></BR>
<T C="229,105,22" S="22">4. </T><T C="127,70,26" S="18">Cấp tăng sao trên 3, khi thất bại sẽ bị giảm cấp.</T><BR>10</BR>
]],
STRENGTHEN_RULE4 = 
[[
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Đá khảm bao gồm 4 loại: Tấn Công, Phòng Thủ, Sinh Lực, Cộng Hưởng, cấp đá cao nhất là Lv12.</T><BR></BR>
<T C="229,105,22" S="22">2. </T><T C="127,70,26" S="18">Đá khảm cùng thuộc tính có thể ghép với nhau để nâng cấp.</T><BR></BR>
<T C="229,105,22" S="22">3. </T><T C="127,70,26" S="18">Mỗi lần khảm cần tốn số Vàng nhất định.</T><BR></BR>
<T C="229,105,22" S="22">4. </T><T C="127,70,26" S="18">Mỗi loại đá chỉ được khảm vào ô tương ứng.</T><BR></BR>
<T C="229,105,22" S="22">5. </T><T C="127,70,26" S="18">Nếu ô đã khảm đá, tiếp tục bỏ vào sẽ thay thế đá đã khảm.</T><BR>10</BR>
<T C="229,105,22" S="22">6. </T><T C="127,70,26" S="18">Đá Lv7 trở lên có thể ghép thành Đá Ma Lực, giữ lại EXP vượt trên Lv7. Đá Ma Lực có thuộc tính mạnh hơn, tối đa tăng đến Đá Thần Lv6.</T><BR>10</BR>
<T C="229,105,22" S="22">7. </T><T C="127,70,26" S="18">Đá Ma Lực cần dùng nhiều Tinh Hoa Đá Quý về Kết Tinh Đá Quý để nâng cấp, nhận từ Phó Bản Đào Mỏ.</T><BR>10</BR>
<T C="229,105,22" S="22">8. </T><T C="127,70,26" S="18">Ngoài Đá Cộng Hưởng, các loại đá khác có thể dùng làm nguyên liệu EXP, dùng gộp vào Đá Ma Lực.</T><BR>10</BR>
<T C="229,105,22" S="22">9. </T><T C="127,70,26" S="18">Đá Thần Lv6 sẽ không thể nhận EXP, cũng không hoàn trả EXP dư nữa.</T><BR>10</BR>
<T C="229,105,22" S="22">10. </T><T C="127,70,26" S="18">Đá Ma Lực mới: Đá Lục, Đá Lam, Đá Quỷ, Đá Thần sẽ lần lượt đối ứng với bậc 13, 14, 15, 16.</T><BR>10</BR>
]],
STRENGTHEN_RULE5 = 
[[
<T C="229,105,22" S="20">1. </T><T C="127,70,26" S="18">Chỉ có trang bị Cam mới được đổi phẩm.</T><BR></BR>
<T C="229,105,22" S="20">2. </T><T C="127,70,26" S="18">Trang bị Cam có phẩm cấp, có thể thông qua hệ thống Thánh Quang tính năng [Đổi phẩm] để thay đổi phẩm cấp hiện tại của trang bị.</T><BR></BR>
<T C="229,105,22" S="20">3. </T><T C="127,70,26" S="18">[Đổi phẩm] cần tốn Sách Chế Tạo Cam vị trí tương ứng của trang bị và Thuốc Thánh Quang.</T><BR>10</BR>
<T C="229,105,22" S="20">4. </T><T C="127,70,26" S="18">Khi chưa tăng phẩm sẽ tăng điểm may mắn, khi điểm may mắn đầy chắc chắn tăng phẩm thành công</T><BR></BR>
<T C="229,105,22" S="20">5. </T><T C="127,70,26" S="18">Điểm may mắn vĩnh viễn có hiệu lực, các trang bị ghi nhận riêng</T><BR></BR>
<T C="229,105,22" S="20">6.</T><T C="127,70,26" S="18">Tăng phẩm thành công sẽ xóa điểm may mắn</T><BR></BR>
]],
DRESS_RULE = 
[[
<T C="229,105,22" S="22">1.</T><T C="127,70,26" S="18">Mỗi món thời trang Đầu Tóc sẽ tăng 10 điểm Sức Mạnh.</T><BR></BR>
<T C="229,105,22" S="22">2.</T><T C="127,70,26" S="18">Mỗi món thời trang Biểu Cảm sẽ tăng 10 điểm Hộ Giáp.</T><BR></BR>
<T C="229,105,22" S="22">3.</T><T C="127,70,26" S="18">Mỗi món thời trang Trang Phục sẽ tăng 10 điểm Thể Chất.</T><BR></BR>
<T C="229,105,22" S="22">4.</T><T C="127,70,26" S="18">Mỗi món thời trang Cánh sẽ tăng 10 điểm Phá Giáp.</T><BR></BR>
<T C="229,105,22" S="22">5.</T><T C="127,70,26" S="18">Thời trang còn hiệu lực mới tăng thuộc tính.</T><BR></BR>
<T C="229,105,22" S="22">6.</T><T C="127,70,26" S="18">Lực chiến chỉ tính thời trang thuộc tính cap nhất, mỗi vị trí 1 món. Nhận thời trang cùng vị trí, chỉ tăng thuộc tính sưu tầm của Tủ Áo.</T><BR></BR>
]],

FIRST_CHARGE_RULE = 
[[
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Tại giao diện Nạp mua quà không tính vào nạp lần đầu.</T><BR></BR>
<T C="229,105,22" S="22">2. </T><T C="127,70,26" S="18">Mua Quà Lễ Kỷ Niệm không tính vào nạp lần đầu.</T><BR></BR>
]],
SHOP_5_RULE1 = 
[[
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Xu Ban Ân từ Hộp Quà trong giao diện Cửa Hàng-Kho Báu.</T><BR></BR>
<T C="229,105,22" S="22">2. </T><T C="127,70,26" S="18">Có thể vào giao diện đổi trong Cửa Hàng tốn Xu Ban Ân đổi vật phẩm tương ứng.</T><BR></BR>
]],
SHOP_5_RULE3 = 
[[
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Đá Purple từ giao diện Tiệm-Kho Báu dùng Kim Cương rút.</T><BR></BR>
<T C="229,105,22" S="22">2. </T><T C="127,70,26" S="18">Có thể vào giao diện đổi trong Cửa Hàng tốn Đá Purple đổi vật phẩm tương ứng.</T><BR></BR>
]],
FAMILY2_TEXT1 = "Chưa nhận thưởng",
FAMILY2_TEXT2 = "Đang trống",
FAMILY2_TEXT3 = "Số lần Nuôi đã đạt giới hạn, hãy tăng cấp kiến trúc chính để tăng giới hạn",
FAMILY2_TEXT4 = "Số lần Nuôi đã đạt giới hạn, 0:30 mỗi ngày tạo mới",
FAMILY2_TEXT5 = "Nuôi kết thúc, hãy nhận thưởng",
FAMILY2_TEXT6 = "Thưởng Nuôi",
FAMILY2_TEXT7 = [[<T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">Nuôi còn: </T><T C="255,255,255" S="22" P="1" SC="132,66,29" SS="4" SE="1">%d:%02d:%02d</T>]],
FAMILY2_TEXT8 = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1"></T><T C="99,255,95" S="18" P="1" SC="132,66,29" SS="4" SE="1"></T><T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1"></T>]],
FAMILY2_TEXT9 = "Bắt đầu Nuôi",
FAMILY2_TEXT10 = "Nghiên cứu đã kết thúc, hãy về nhận thưởng",
FAMILY2_TEXT11 = [[<T C="127,70,26" S="20" P="1">Tăng tốc cần tốn </T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1"> x%d, tiếp tục?</T>]],
FAMILY2_TEXT12 = "Nuôi đã hoàn thành, không cần tăng tốc",
FAMILY2_TEXT13 = "Thám Hiểm hoàn thành, không cần tăng tốc",
FAMILY2_TEXT14 = "Thưởng Thám Hiểm",
FAMILY2_TEXT15 = "Bắt đầu Thám Hiểm",
FAMILY2_TEXT16 = "Thám Hiểm kết thúc, hãy nhận thưởng",
FAMILY2_TEXT17 = [[<T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1">Thám Hiểm còn: </T><T C="255,255,255" S="22" P="1" SC="132,66,29" SS="4" SE="1">%d:%02d:%02d</T>]],
FAMILY2_TEXT18 = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1"></T><T C="99,255,95" S="18" P="1" SC="132,66,29" SS="4" SE="1"></T><T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1"></T>]],
FAMILY2_TEXT19 = "Số lần Thám Hiểm đã đạt tối đa, hãy tăng cấp kiến trúc chính để tăng giới hạn",
FAMILY2_TEXT20 = "Số lần Thám Hiểm đã đạt tối đa, 0:30 mỗi ngày tạo mới",
FAMILY2_TEXT21 = "Nuôi",
FAMILY2_TEXT22 = "Thám Hiểm",
REBATE1 = "Hối lộ ta sẽ được giảm giá!",
REBATE2 = "Hối lộ",
REBATE3 = "Thời gian bán: ",
REBATE4 = "Mấy cái này có thể bán rẻ chút.",
REBATE5 = "Đã hối lộ",
REBATE6 = "Đồng ý trả %s Kim Cương hối lộ thương nhân, sau khi hối lộ sẽ giảm giá 10-40% cho 3 vật phẩm ngẫu nhiên đợt này",
REBATE7 = "Vật phẩm đợt này không có giảm giá thấp hơn",
REBATE8 = "Đồng ý trả %s Kim Cương tạo mới danh sách, tạo mới sẽ mất giảm giá",
REBATE9 = "Vật phẩm đợt này không có giảm giá thấp hơn",
REBATE_DESC =
[[
<T C="229,105,22" S="22">Quy tắc hối lộ</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Sau khi hối lộ sẽ giảm giá 3 vật phẩm ngẫu nhiên đợt này</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Sau khi hối lộ giảm 10-40%</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Đợt này không đủ 5 vật phẩm không thể hối lộ, phải chờ tạo mới vật phẩm đợt sau</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Nếu mua vật phẩm được giảm giá nhờ hối lộ, khi tạo mới vật phẩm sẽ về giá cũ</T><BR>20</BR>
]],
GAMEACTIVITY_TIPTEXT1 = [[<T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1"></T><T C="255,227,116" S="22" P="1" SC="105,60,46" SS="4" SE="1">%d trang bị </T><T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1"> bất kỳ tăng đến </T><T C="255,227,116" S="22" P="1" SC="105,60,46" SS="4" SE="1"> %d Sao</T>]],
GAMEACTIVITY_TIPTEXT2 = {"Thưởng Rút Rương May Mắn x10","Thưởng Rút Đập Trứng x10","Thưởng Rút Bùa (Kim Cương) x10","Thưởng Rút Cửa Hàng (Kim Cương) x5"},
GAMEACTIVITY_TIPTEXT3 = ", ngày %s có thể nhận",
GAMEACTIVITY_TIPTEXT4 = " hoàn trả x%s",
GAMEACTIVITY_TIPTEXT5 = "Tăng sao trang bị",
GAMEACTIVITY_TIPTEXT6 = "Rút x10",
GAMEACTIVITY_TIPTEXT7 = "Hoàn trả Kim Cương",
GAMEACTIVITY_TIPTEXT8 = "Nạp x3",
NEWEXCHANGE_TEXT1 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Mỗi lần đổi tốn </T><I Z="0.4">%s </I><T C="255,227,116" S="20" P="1" SC="79,60,48" SE="1" SS="4">x%d</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">, mỗi ngày có thể đổi </T><T C="255,227,116" S="20" P="1" SC="79,60,48" SE="1" SS="4">%d</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4"> lần</T>]],
NEWEXCHANGE_TEXT2 = "Hoạt động Đổi",
GAMEACTIVITY_TIPTEXT9 = "Nạp 1 lần",
GAMEACTIVITY_TIPTEXT10 = 
[[
<T C="229,105,22" S="22">Nạp Ít Nhận Nhiều</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Trong thời gian hoạt động, nạp 1 lần đúng mốc yêu cầu, sẽ hoàn thành điều kiện nhận thưởng</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Sau khi thỏa điều kiện nhận thưởng, sẽ nhận thưởng bắt đầu từ phẩn thưởng của ngày 1</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Sau khi sự kiện kết thúc, phần thưởng còn lại chưa nhận, hệ thống sẽ gửi bù qua thư</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Mua Túi Quà Vip sẽ không được tính, phải nạp 1 lần đúng mốc chứ không được tích lũy nạp</T><BR>20</BR>
]],
GIFTTIP1 = "Đã có tất cả Thú Cưỡi trong quà, đồng ý mua?",
GIFTTIP2 = "Đã có tất cả Skin trong quà, đồng ý mua?",
MANYCOLLECT_TEXT1 = "Vui Góp",
MANYCOLLECT_TEXT2 = "Danh sách thưởng",
MANYCOLLECT_TEXT3 = "Góp thành công",
MANYCOLLECT_TEXT4 = "Góp",
MANYCOLLECT_TEXT5 = "Số lượng đầu tư",
MANYCOLLECT_TEXT6 = 
[[
<T C="229,105,22" S="22">Quy Tắc Đầu Tư</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Đầu tư 1 lần sẽ nhận được Giải Tham Dự, phần thưởng Giải Tham Dự sẽ gửi trực tiếp  vào túi của người chơi.</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Phần thưởng Giải Tham Dự của mỗi mốc Đầu Tư chỉ có thể nhận 1 lần, phần thưởng  Giải Đặc Biệt sau khi mở thưởng sẽ được gửi vào hộp thư của người chơi trúng thưởng.</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Mỗi mốc đầu tư sau khi mở thưởng, thì mốc đầu tư này sẽ được làm mới lại từ đầu.</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Trong sự kiện Đầu Tư, đầu tư Giải Tham Dự càng nhiều thì càng có cơ hội trúng  Giải Đặc Biệt.</T><BR></BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Trong thời gian diễn ra sự kiện, nếu chưa đạt đủ số lượng Giải Tham Dự yêu cầu để  có thể mở thưởng Giải Đặc Biệt, thì sẽ không mở thưởng Giải Đặc Biệt.</T><BR>10</BR>
]],
MANYCOLLECT_TEXT7 = "Mỗi phiếu",
MANYCOLLECT_TEXT8 = "Giải Tham Dự",
MANYCOLLECT_TEXT9 = "Giải Đặc Biệt",
MANYCOLLECT_TEXT10 = [[<T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1">Xác nhận mua </T><T C="255,227,116" S="22" P="1" SC="105,60,46" SS="4" SE="1">%d</T><T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1"> phiếu</T>]],
MANYCOLLECT_TEXT11 = "Chỉ được nhập số",
MANYCOLLECT_TEXT12 = "Chưa có danh sách thưởng",
MANYCOLLECT_TEXT13 = [[<T C="255,255,255" S="20" P="1" SC="105,60,46" SS="4" SE="1">%s </T><T C="255,236,193" S="20" P="1" SC="105,60,46" SS="4" SE="1"> trong thời gian rút thưởng </T><T C="255,227,116" S="20" P="1" SC="105,60,46" SS="4" SE="1">(%s)</T><T C="255,236,193" S="20" P="1" SC="105,60,46" SS="4" SE="1"> nhận quà siêu!!</T>]],
MANYCOLLECT_TEXT14 = "Chỉ được góp 1 lần",
ACTIVITY_BUY_SECOND = "Thao tác sẽ tốn Kim Cương nhất định, mua không?",
MUTLIP_COPY_SWEEP_TIP = "Không thể càn quét phó bản này",
MANYCOLLECT_TEXT15 = [[<T C="105,65,46" S="18" P="1" SC="105,60,46" SS="4" SE="0">(Nhấp nhập số lượng mua)</T>]],
GAMEACTIVITY_TIPTEXT5 = [[Chỉ định nạp]],
GAMEACTIVITY_TIPTEXT6 = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Hoạt động tổng cộng có 3 loại quà 1,6,12 đồng, thưởng phong phú</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Mỗi quà mỗi ngày được mua 1 lần, 24 giờ mỗi ngày sẽ tạo mới</T><BR></BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Quà sau khi mua sẽ đưa vào túi, hãy kiểm tra</T><BR>10</BR>
]],
WORLD_TEAM_IV_TIP = "Mời Thế Giới",
WORLD_TEAM_IV_TXT = "Đang ở phó bản %s, nhấp cùng đánh BOSS!",
WORLD_TEAM_IV_ERROR = "Thiết lập mật khẩu không thể mời tổ đội thế giới",
WORLD_TEAM_IV_ERROR2 = "Cảnh hiện tại không thể bỏ qua",
CANTADD = "Tạm không thể thêm người chơi liên server!",
LUCKYFULL1 = "Điểm may mắn đầy chắc chắn tăng phẩm", 
PETLOCK1 = "Khóa loại",
PETLOCK2 = "Khóa tất cả",
PETLOCK3 = "Tối thiểu chừa 1 kỹ năng cần tẩy luyện",
ACTIVITY_RECHARGELEVEL = "Nạp Định Mức",
ACTIVITY_RECHARGE_MONEY = "Nạp 1 lần đúng %s",
ACTIVITY_RECHARGELEVEL_DESC = "Nạp mức tương ứng có thể nhận thưởng, hoạt động tạo mới mỗi ngày",
GAMEACTIVITY_NEWRECHARGEBACK = 
[[
<T C="229,105,22" S="22">Hoàn trả tích lũy nạp x5</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Trong thời gian hoạt động nạp tích lũy 880 Kim Cương, đạt điều kiện nhận thưởng</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Mua vật phẩm quà không tính vào tích lũy nạp</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Hoàn thành điều kiện nhận thưởng sẽ nhận từ ngày thưởng đầu tiên</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Hoạt động kết thúc sẽ hủy thưởng chưa nhận hoặc thưởng chưa đạt, hãy mua sớm</T><BR>20</BR>
]],
GAMEACTIVITY_NEWRECHARGEBACK2 = "Hoàn trả tích lũy nạp",
GAMEACTIVITY_NEWRECHARGEBACK3 = "Tích lũy nạp đạt",
TEACH_212 = "Nhấp nút vào nhanh",
TEACH_213 = "Nhấp nút chuẩn bị vào game",
WAKEUP_TEXT36 = "Loại thuộc tính",
WAKEUP_TEXT37 = "Loại tài phù",
LOVELOTTERY_TEXT1 = "Nhắc nhở: Rút đạt số lần nhất định có thể nhận thưởng lớn",
NEWSHOP81 = "Bộ Ma Ảo",
NEWSHOP82 = "Bộ Tương Lai",
NEWSHOP83 = "Bộ Ác Ma",
NEWSHOP84 = "Bộ Sa Mạc",
NEWSHOP85 = "Bộ Sấm Sét",
NEWSHOP86 = "Bộ Băng",
NEWSHOP87 = "Bộ Trắng",
NEWSHOP26 = [[Rương May Mắn nhận]],
LOVELOTTERY_TEXT2 = 
[[
<T C="229,105,22" S="22">Quy tắc rút thưởng may mắn</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Mỗi lần rút thưởng tăng 1 điểm tiến độ</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Khi tiến độ đạt 20, 100, 200 sẽ được nhận thưởng gửi qua thư.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Sau khi hoàn thành và nhận thưởng, sẽ tạo mới tiến độ. (Được nhận thưởng nhiều lần nhé!)</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Khi hoạt động kết thúc, phần thưởng chưa nhận sẽ bị hủy! Mua càng sớm, thưởng càng nhiều</T><BR>20</BR>
<T C="127,70,26" S="20">Xác suất rút thưởng</T><T C="127,70,26" S="18"></T><BR>20</BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Thời trang/Thú cưỡi/Skin/Vũ khí: 1%</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Rương Mảnh Đá Tăng Phẩm-Cao:  3%</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Pet:   4%</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Mảnh Bùa/Đá Thức Tỉnh-Cao/Cầu Mộng Ảo: 15%</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Thuốc Nhuộm/Sách Lĩnh Ngộ:20%</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Sách Kỹ Năng-Trung/Đá Thức Tỉnh-Trung: 28%<BR></BR>
]],

IS_COST_MONEY = "Tốn %d Kim Cương, đồng ý tiếp tục?",
LOURAACT14 = "Quà siêu giá trị!",
LOURAACT11= "Thời trang Long Cung",
LOURAACT12 = "Độc Thân",
LOURAACT2 = "Đổi hạn giờ",
LOURAACT3 = "Giảm giá cực thấp",
LOURAACT13 = "Mua giới hạn siêu giá trị",
CARD_ACTIVITY_TEXT1 = [[<T C="195,171,148" S="18" P="1">Giá cực tốt, chỉ 1 lần</T>]],
CARD_ACTIVITY_TEXT2 = [[<T C="195,171,148" S="18" P="1">(Chỉ giới hạn 1 lần)</T>]],
CARD_ACTIVITY_TEXT3 = [[<T C="195,171,148" S="18" P="1">Ưu đãi bất ngờ, mua 1 tặng 1</T>]],
CARD_ACTIVITY_TEXT4 = [[<T C="195,171,148" S="18" P="1">(Đã mua)</T>]],
CARD_ACTIVITY_TEXT5 = [[<T C="195,171,148" S="18" P="1">Mua 1 tặng 1, chỉ được 1 lần</T>]],
CARD_ACTIVITY_TEXT6 = "Phúc lợi Thẻ Tháng",
CARD_ACTIVITY_TEXT7 = "Phúc lợi Thẻ Tuần",
NO_ATTR_ADD = "Tạm không có thuộc tính tăng",
EQUIPTYPETIP2 = "Tăng phòng Thủ nhân vật",
EQUIPTYPETIP3 = "Tăng miễn bạo nhân vật",
EQUIPTYPETIP4 = "Tăng sinh lực nhân vật",
EQUIPTYPETIP5 = "Tăng bạo Kích nhân vật",
EQUIPTYPETIP6 = "Tăng sinh lực nhân vật",
EQUIPTYPETIP7 = "Tăng phá giáp nhân vật",
EQUIPTYPETIP8 = "Tăng miễn thương nhân vật",
ACIVIITY_RECHARGERANK = "BXH Nạp Máy Chủ Này",
ACIVIITY_CROSS_RECHARGERANK = "BXH Nạp Toàn Máy Chủ",
ACIVIITY_CONSUMERANK = "BXH Tiêu Máy Chủ Này",
ACIVIITY_CROSS_CONSUMERANK = "BXH Tiêu Toàn Máy Chủ",
GIVE_MOVE = "Gọi lại %d lần tặng thêm",
GIVE_MOVE2 = [[<T C="79,60,48" S="20" P="1" >Gọi lại </T><T C="128,54,13" S="20" P="1" >%d</T><T C="79,60,48" S="20" P="1" > lần tặng thêm </T>]],
CALL_REWAR = "Thưởng Gọi",
GIVE_MOVE3 = [[<T C="79,60,48" S="20" P="1" >Có thể nhận</T>]],
GIVE_MOVE4 = [[<T C="79,60,48" S="20" P="1" >Đã nhận</T>]],
VIPWEEK_PACKAGE = "Quà Tuần",
VIPWEEK_PACKAGE2 = [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">VIP%d trở lên có thể mua</T><T C="127,70,26" S="18" P="1">(Mỗi Chủ nhật 24:00 tạo mới)</T>]],
ADVENTURE_STORE = "Tiệm Mạo Hiểm",
JEDI_ADVENTURE_OVER = "Hoạt động khiêu chiến Mạo Hiểm lần này đã kết thúc!",
ADVENTURE_DESC1 = 
[[
1. 12:00-14:00 mỗi ngày mở khiêu chiến Mạo Hiểm
2. Lv35 mới được tham gia khiêu chiến
3. Khiêu chiến gồm hỗn chiến 6 người, người tồn tại sau cùng sẽ là Vua
4. Sau khi vào chiến đấu, kỹ năng chiến đấu hoàn toàn ngẫu nhiên
5. Sau khi vào chiến đấu, ô đạo cụ sẽ trống, cần tự mở hoặc dùng đạn mở rương mới nhận được đạo cụ sử dụng
6. Sau khi vào chiến đấu, người chơi cần tự di chuyển, bay và dùng vũ khí để mở rộng phạm vi tầm nhìn
7. Sau khi vào chiến đấu sẽ có khói độc tăng dần theo thời gian và lan khắp bản đồ, người chơi phải tránh khói độc
]],
JUEDITIPS1 = "Thuộc tính chiến đấu Mạo Hiểm",
JUEDITIPS2 = "*Mạo Hiểm là dạng thi đấu nghiêng về kỹ thuật, trong cách chơi này thuộc tính nhân vật cân bằng",
ESCAPE_TREASURE = "Rương Đạo Cụ",
ADVENTURE_COIN = "Xu Mạo Hiểm",
VIPWEEK_PACKAGE3 = "Ưu đãi hạn giờ",
VIPWEEK_PACKAGE4 = [[<T C="127,70,26" S="18" P="1">Quà hạn giờ còn: </T><T C="229,105,22" S="18" P="1">%d:%02d:%02d</T>]],
VIPWEEK_PACKAGE5 = "Đã đóng đăng ký, hãy đến máy chủ mới nhận trải nghiệm tốt nhất!", 
LOURAACT15 = "Tiệm Năm Mới",
EQUIPMENT_DRAW_EXPLAIN =
[[
<T C="229,105,22" S="22">Quy tắc thưởng thêm Rút x10</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Gọi x10 thưởng thêm chỉ giới hạn mức 1888 Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thưởng thêm phải nhận thủ công</T><BR></BR>
]],
CHANGE_OPEN_TIP = "Nhân vật cần đạt Lv%d mới có thể khiêu chiến!",
DAILYRESET1 = "Lượt tạo mới hôm nay đã dùng hết",
DAILYRESET2 = "Đồng ý dùng %s tạo mới Bí Cảnh?",
DAILYRESET3 = "Hạng sát thương",
CONVERSION1 = "Đã có",
CONVERSION2 = "Tu luyện x2",
CONVERSION3 = "Mở tu luyện x2, mỗi lần tu luyện tốn %s Kim Cương nhận tu luyện x2 EXP",
FAST_GET_ITEM = "Tạm không được nhận nhanh",

FOOTMARK_TEXT1 = [[<I Z="0.8">ui/common/commom_icon_zj2.png</I><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="0.8" W = "16" H = "26" CHAR = "0">%d</A>]],
FOOTMARK_TEXT2 = "Tinh luyện",
FOOTMARK_TEXT3 = "DS Dấu Chân",
FOOTMARK_TEXT4 = "Ẩn",
FOOTMARK_TEXT5 = "Nhắc nhở: Tất cả thuộc tính Dấu Chân được cộng dồn",
FOOTMARK_TEXT6 = "Dấu Chân vĩnh viễn mới được lên cấp",
FOOTMARK_TEXT7 = "Dấu Chân vĩnh viễn mới được tinh luyện",
FOOTMARK_TEXT8 = "Tinh luyện Dấu Chân",
FOOTMARK_TEXT9 = "Dấu Chân lên cấp",
FOOTMARK_TEXT10 = "Tổng thuộc tính Dấu Chân",
FOOTMARK_TEXT11 = "Mỗi Dấu Chân được cộng dồn thuộc tính, khi sử dụng không ảnh hưởng đến thuộc tính đã tăng",
FOOTMARK_TEXT12 = "Đồng ý tốn %s%d kích hoạt Dấu Chân",
CRANK1 = "Tổng sát thương",
CRANK2 = "Không có thông tin sát thương",
PETLIBRARY1 = "Thư Viện kỹ năng Pet",
CRANK3 = "Tỉ lệ sát thương",
FOOTMARK_TEXT13 = "Dấu Chân đã đạt cấp cao nhất",
FOOTMARK_TEXT14 = "Dấu Chân đạt cấp tinh luyện cao nhất",
FOOTMARK_TEXT15 = "Dấu Chân cần đạt Lv%d mới được tinh luyện",
FOOTMARK_TEXT16 = [[<T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%d </T><I P="1" Z="0.45">%s</I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4"> kích hoạt</T>]],
FOOTMARK_TEXT17 = [[<I P="1" Z="0.45">%s </I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">x%d</T><T C="158,0,0" S="22" P="1">(Chưa nhận)</T>]],
FOOTMARK_TEXT18 = "Kích hoạt",
FOOTMARK_TEXT19 = [[<T C="195,171,148" S="16" P="0">Tăng cấp %d lần,Dấu Chân tăng Lv%d, tốn %d%s </T>]],
FOOTMARK_TEXT20 = [[<T C="195,171,148" S="20" P="0">Tăng cấp lần %d, %d->%d, tốn %d%s, xác suất thành công %s,</T><T C="99,255,95" S="20" P="0">Thành công</T>]],
FOOTMARK_TEXT21 = [[<T C="195,171,148" S="20" P="0">Tăng cấp lần %d, %d->%d, tốn %d%s, xác suất thành công %s,</T><T C="255,89,74" S="20" P="0">Thất bại</T>]],
FOOTMARK_TEXT22 = "Thời gian thử còn ",
FOOTMARK_TEXT23 = "Dùng Thẻ Thử Nghiệm thành công, thời gian +%d ngày",
FOOTMARK_TEXT24 = [[<I P="1" Z="0.45">%s </I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">x%d</T><T C="0,72,3" S="22" P="1">(Đã nhận)</T>]],
FOOTMARK_TEXT25 = "Tăng cấp nhân vật mới được tiếp tục tăng cấp Dấu Chân",
FOOTMARK_TEXT26 = "Dấu Chân đạt giới hạn cấp! Giỏi quá!",
FOOTMARK_TEXT27 = "Tinh luyện Dấu Chân đạt giới hạn! Giỏi quá!",
FOOTMARK_TEXT28 = "Tăng cấp nhân vật mới được tiếp tục tinh luyện Dấu Chân",
CLOWN_EXPLAIN = 
[[
<T C="229,105,22" S="22">Quy tắc Chú Hề Tìm Kho Báu</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Mỗi ngày được tìm kho báu miễn phí 3 lần, 24:00 tạo mới</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Mỗi ngày được giở mánh khóe miễn phí 3 lần, 24:00 tạo mới</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Tìm báu vật được càng nhiều Nón Chú Hề thưởng càng cao, có thể dùng mánh khóe để thay đổi kết quả</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Xem trước thưởng</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --Không có 5 Huy Chương Cầu Phúc Chú Hề tương ứng</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --1 Nón Chú Hề tương ứng 10 Huy Chương Cầu Phúc</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --2 Nón Chú Hề tương ứng 20 Huy Chương Cầu Phúc</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --3 Nón Chú Hề tương ứng 30 Huy Chương Cầu Phúc</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --4 Nón Chú Hề tương ứng 50 Huy Chương Cầu Phúc, 1 Xu Cầu Phúc</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --5 Nón Chú Hề tương ứng 70 Huy Chương Cầu Phúc, 2 Xu Cầu Phúc</T><BR></BR>
]],
CLOWN_TIP1 = "Kéo thử xem?",
CLOWN_TIP2 = "Hôm nay may mắn, thử lần nữa nào!",
CLOWN_TIP3 = "Lại gặp mặt",
CLOWN_TIP4 = "Trúng số lần nào chưa?",
CLOWN_TIP5 = "Chúc may mắn!",
CLOWN_TIP6 = "Hay là chúng ta giở mánh khóe một tí nhỉ?",
CLOWN_TIP7 = "Xem ra đổi tiếp là đến lượt rồi!",
CLOWN_TIP8 = "Thay đổi 1 chút, tăng phần thưởng",
CLOWN_TIP9 = "Thay đổi chút đi",
CLOWN_TIP10 = "Tiếp tục nào, sắp trúng thưởng rồi!",
TODAY_TREASURE_COUNT = "Lần %d tầm bảo: ",
NOT_GET_TREASURE_TIP = "Hãy nhận thưởng tầm bảo lần này",
TREASURE_RESERT_TIP3 = "Số lần không đủ, dùng %d Kim Cương tìm kho báu không? (Đã dùng %d/%d lần)",
TREASURE_RESERT_TIP4 = "Hôm nay đã dùng %d/%d lần, VIP%d được nhiều lần hơn!",
TREASURE_RESERT_TIP5 = "Đồng ý trả %d Kim Cương giở mánh khóe? (Đã dùng %d/%d lần)",
TREASURE_RESET_TIP6 = "Đợi nhận thưởng tầm bảo",
CHALLENGE_SURPLUS_COUNT = "Khiêu chiến còn: ",
CANTUPLOAD = "Không thể Upload",
NO_UPLOAD_PHOTOS = "Upload hình không hợp lệ, tạm cấm Upload",
ADVISE_HERO_DESC2 = "Nếu gặp vấn đề trong game, vui lòng liên hệ CSKH để được hướng dẫn.",
GUILDWAR_NEWTEXT1 = "Công Hội Chiến đã kết thúc",

AUTOSELL = "Tự bán",
CHECKOTHER11 = "Dấu Chân",
AUTOSELL1 = "Tự động",
CHRISTMASTREE_TEXT1 = "Hạng điểm Noel",
CHRISTMASTREE_TEXT2 = "Hoạt động mở sau: ",
CHRISTMASTREE_TEXT3 = "Hoạt động kết thúc sau: ",
CHRISTMASTREE_TEXT4 = "Đóng giao diện sau: ",
CHRISTMASTREE_TEXT5 = [[<T C="255,255,255" S="16" P="1" SC="79,60,48" SE="0" SS="4">Toàn server mỗi khi mua %d Điểm, mỗi người được rút miễn phí 1 lần</T>]],
CHRISTMASTREE_TEXT6 = "Rương quà",
CHRISTMASTREE_TEXT7 = "Rút thưởng miễn phí",
CHRISTMASTREE_TEXT8 = "Cầu Nguyện 10 lần",
CHRISTMASTREE_TEXT9 = 
[[
<T C="229,105,22" S="22">Hướng dẫn HĐ Cây Noel</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Cầu Nguyện Cây Noel có thể nhận điểm, miễn phí được 1 điểm, rút được 2 điểm, Rút x10 được 20 điểm</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Điểm Cầu Nguyện toàn server đạt 10000, người chơi toàn server được Cầu Nguyện miễn phí 1 lần</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Điểm Cầu Nguyện càng cao, hạng càng cao nhận thưởng càng nhiều</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Thưởng hạng: </T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 1: </T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4">Dấu Chân Chuông x1, Đá Tinh Luyện-Cao x5, Đạn Cấp Dấu Chân x500, Vàng x1000 Vạn</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 2: </T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4">Dấu Chân Chuông x1, Đá Tinh Luyện-Trung x5, Đạn Cấp Dấu Chân x300, Vàng x500 Vạn</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 3: </T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4">Dấu Chân Chuông x1, Đá Tinh Luyện-Sơ x10, Đạn Cấp Dấu Chân x200, Vàng x300 Vạn</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 4-10</T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4"> Dấu Chân Chuông (7 ngày) x1, Đạn Cấp Dấu Chân x100, Vàng x200 Vạn</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 11-50: </T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4"> Dấu Chân Chuông (3 ngày) x1, Đạn Cấp Dấu Chân x50, Vàng x100 Vạn</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 51-10000: </T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4"> Đạn Cấp Dấu Chân x100, Vàng x50 Vạn</T><BR></BR>
]],
CHRISTMASTREE_TEXT10 = "Rương quà đã đầy, sắp xếp rồi rút",
CHRISTMASTREE_TEXT11 = "Rút hết",
CHRISTMASTREE_TEXT12 = "Sắp xếp ngay",
CHRISTMASTREE_TEXT13 = [[<T C="255,236,193" S="16" P="1">Miễn phí %d lần</T>]],
CHRISTMASTREE_TEXT14 = "Rương quà trống, hãy rút thưởng",
CHRISTMASTREE_TEXT15 = "Không có quà",
CHRISTMASTREE_TEXT16 = "Hoạt động chưa bắt đầu, đang cập nhật!",
CHRISTMASTREE_TEXT17 = "Hoạt động đã kết thúc, không thể rút thưởng",
CHRISTMASTREE_TEXT18 = "Đã sắp xếp",
CHRISTMASTREE_TEXT19 = "Rút thành công",
CHRISTMASTREE_TEXT20 = "Cây Noel",
CHRISTMASTREE_TEXT21 = "Cầu Nguyện 1 lần",
THEMATIC_TASKS = "NV hoạt động",
DAILY_TASKS_TYPE = "(Mỗi ngày)",
ONLY_TASKS_TYPE = "(Duy nhất)",
LINE_VIP_ENGOUH = "Màu sắc dành riêng VIP, bạn chưa phải VIP",
SETTING_LINE = "Màu sắc: ",
LOURAACT16 = "Khuyến mãi Noel",
SECKILL1 = "Tranh mua -%s",
SECKILL2 = "Giới thiệu: ",
SECKILL3 = "Tranh mua hôm nay: [%s], mỗi người mua nhiều nhất %s. Ngoài thời gian tranh mua sẽ bán ưu đãi và được mua giới hạn!",
SECKILL4 = "Tranh mua còn",
SECKILL5 = "Bắt đầu: ",
SECKILL6 = "Kết thúc: ",
SECKILL7 = "Chậm quá, bán hết hàng rồi!",
SECKILL8 = "[Máy chủ còn %d]",

NEW_PRODUCT_PACKS = "Túi Quà Gói Vật Phẩm Mới",
TEACH_180 = "Tính năng mới ở đây",
NEWACTIVITY_THE_SERVICE_RECHARGE_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc sự kiện:</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Sự kiện áp dụng chỉ cho người chơi tại máy chủ này.</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Người chơi nằm trong top BXH nạp kim cương sẽ được nhận thưởng tương ứng với thứ hạng.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Kết quả sẽ được tổng kết lúc 23 giờ 59 phút 00 giây của ngày cuối sự kiện.</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Các trường hợp nạp sau 23 giờ 59 phút 01 giây sẽ không được hệ thống ghi nhận.</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Phần thưởng sẽ được tự động trao qua thư sau khi sự kiện kết thúc.</T><BR>10</BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">BXH sẽ được duy trì hiển thị thêm 1 ngày sau khi sự kiện kết thúc để người chơi tiện theo dõi.</T><BR>10</BR>
<T C="127,70,26" S="20">Đặc biệt:  </T><T C="127,70,26" S="18">Phần thưởng TOP 1 chỉ xuất hiện duy nhất độc quyền trong các sự kiện đua top!</T><BR>10</BR>
]],
NEWACTIVITY_CROSS_SERVICE_RECHARGE_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc sự kiện:</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Sự kiện áp dụng cho người chơi trên tất cả máy chủ.</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Người chơi nằm trong top BXH nạp kim cương sẽ được nhận thưởng tương ứng với thứ hạng.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Kết quả sẽ được tổng kết lúc 23 giờ 59 phút 00 giây của ngày cuối sự kiện.</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Các trường hợp nạp sau 23 giờ 59 phút 01 giây sẽ không được hệ thống ghi nhận.</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Phần thưởng sẽ được tự động trao qua thư sau khi sự kiện kết thúc.</T><BR>10</BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">BXH sẽ được duy trì hiển thị thêm 1 ngày sau khi sự kiện kết thúc để người chơi tiện theo dõi.</T><BR>10</BR>
<T C="127,70,26" S="20">Đặc biệt:  </T><T C="127,70,26" S="18">Phần thưởng TOP 1 chỉ xuất hiện duy nhất độc quyền trong các sự kiện đua top!</T><BR>10</BR>
]],
NEWACTIVITY_THE_SERVICE_CONSUMPTION_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc sự kiện:</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Sự kiện áp dụng chỉ cho người chơi tại máy chủ này.</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Người chơi nằm trong top BXH tiêu kim cương sẽ được nhận thưởng tương ứng với thứ hạng.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Kết quả sẽ được tổng kết lúc 23 giờ 59 phút 00 giây của ngày cuối sự kiện.</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Các trường hợp tiêu sau 23 giờ 59 phút 01 giây sẽ không được hệ thống ghi nhận.</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Phần thưởng sẽ được tự động trao qua thư sau khi sự kiện kết thúc.</T><BR>10</BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">BXH sẽ được duy trì hiển thị thêm 1 ngày sau khi sự kiện kết thúc để người chơi tiện theo dõi.</T><BR>10</BR>
<T C="127,70,26" S="20">Đặc biệt:  </T><T C="127,70,26" S="18">Phần thưởng TOP 1 chỉ xuất hiện duy nhất độc quyền trong các sự kiện đua top!</T><BR>10</BR>
]],
NEWACTIVITY_CROSS_SERVICE_CONSUMPTION_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc sự kiện:</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Sự kiện áp dụng cho người chơi tất cả máy chủ.</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Người chơi nằm trong top BXH tiêu kim cương sẽ được nhận thưởng tương ứng với thứ hạng.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Kết quả sẽ được tổng kết lúc 23 giờ 59 phút 00 giây của ngày cuối sự kiện.</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Các trường hợp tiêu sau 23 giờ 59 phút 01 giây sẽ không được hệ thống ghi nhận.</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Phần thưởng sẽ được tự động trao qua thư sau khi sự kiện kết thúc.</T><BR>10</BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">BXH sẽ được duy trì hiển thị thêm 1 ngày sau khi sự kiện kết thúc để người chơi tiện theo dõi.</T><BR>10</BR>
<T C="127,70,26" S="20">Đặc biệt:  </T><T C="127,70,26" S="18">Phần thưởng TOP 1 chỉ xuất hiện duy nhất độc quyền trong các sự kiện đua top!</T><BR>10</BR>
]],
GAMEACTIVITY_COST_ONLYDIAMOND ="Tích lũy tiêu phí",
GAMEACTIVITY_TYPE_5009 ="Thưởng online server mới",
GAMEACTIVITY_NEWSERVER_CARPACKAGE ="Rút thưởng túi thẻ",
GAMEACTIVITY_NEWSERVER_BREAKEGGS ="Đập Trứng Vàng",
GAMEACTIVITY_NEWSERVER_TIMEDISCOUNT ="Ưu đãi ngày",
GAMEACTIVITY_NEWSERVER_DIAMONDROUND ="Vòng Quay Nhân Phẩm",
GAMEACTIVITY_NEWSERVER_TIMECHALLENGE ="Khiêu chiến hạn giờ",
GAMEACTIVITY_NEWSERVER_ATHLETICSUP ="Tăng bậc Thi Đấu",
GAMEACTIVITY_NEWSERVER_TOTALRECHARGE ="Tích Lũy Nạp",
GAMEACTIVITY_NEWSERVER_SINGLECOPY ="Phó Bản Tích Lũy",
GAMEACTIVITY_NEWSERVER_FIGHTINGRANK ="Lực Chiến BXH Tháng",
BIND_TOURISTS = "Liên Kết Tài Khoản",
GAME_ACTIVITY_TYPE_5010 = "Nhân vật mới tích lũy đăng nhập",
GAME_ACTIVITY_TEN_LOTTERY ="Thưởng Rút x10",
GAME_ACTIVITY_MANY_COLLECT ="Vui Góp",
GAME_ACIVIITY_OLD_EXCHANGE ="Đổi",
TEACH_214 = "Nhấp nút Đồng Hành",
LOURAACT14 = "Đừng bỏ lỡ Quà Siêu Cấp!",
LOURAACT11= "Thời trang Long Cung",
LOURAACT12 = "Độc Thân",
LOURAACT2 = "Đổi Hạn Giờ",
LOURAACT3 = "Trở Lại-Cực",
LOURAACT13 = "Mua giới hạn siêu giá trị",

GUILDWAR_NEWTEXT1 = "Công Hội Chiến đã kết thúc",
ACTIVITYTIME_FORMAT = "%02d.%02d %02d:%02d-%02d.%02d %02d:%02d",
NEWDESC1 = "Thuộc tính thời trang có thể cộng dồn",
NEWSTONE1 = "Thuộc tính Đá",
NEWSTONE2 = "Đá Vô Cực",
NEWSTONE3 = "Lv%s mở Đá Vô Cực",
NEWSTONE4 = "Thuộc tính đá cơ bản",
NEWSINGIN1 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Tháng này tích lũy </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> lần có thể nhận</T>]],
NEWSINGIN2 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Tháng này đã điểm danh </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> lần</T>]],
NEWSINGIN3 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Người chơi VIP3 trở lên có thể tốn </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><I Z="0.46">%s</I><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> điểm danh bù ngay</T>]],
NEWSINGIN4 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Hiện tại có thể điểm danh bù </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> lần</T>]],
NEWSINGIN5 = "Điểm danh bù",
NEWSINGIN6 = "Không cần điểm danh bù",
SEVENDAY_TEXT1 = {"Ngày 1", "Ngày 2", "Ngày 3", "Ngày 4", "Ngày 5", "Ngày 6", "Ngày 7", "Ngày 8", "Ngày 9", "Ngày 10"},
SEVENDAY_TEXT2 = "Ngày thứ %d",
SEVENDAY_TEXT3 = {"Phúc Lợi Ngày", "Vùng Mạo Hiểm", "Cường hóa trang bị", "Ưu Đãi Giới Hạn"},
SEVENDAY_TEXT4 = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4">Thời gian kết thúc hoạt động: </T>]],
SEVENDAY_TEXT5 = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4">Thời gian kết thúc nhận thưởng: </T>]],
SEVENDAY_TEXT6 = [[<T C="255,89,74" S="18" P="1" SC="132,66,29" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="105,65,46" SE="1" SS="4">ngày </T><T C="255,89,74" S="18" P="1" SC="105,65,46" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="105,65,46" SE="1" SS="4"> giờ </T><T C="255,89,74" S="18" P="1" SC="105,65,46" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="105,65,46" SE="1" SS="4"> phút </T><T C="255,89,74" S="18" P="1" SC="105,65,46" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="105,65,46" SE="1" SS="4"> giây</T>]],
FIRST_RECHARGE_TALK = "Vũ khí giới hạn đã đến hạn, dùng rất thích phải không? Mau nạp lần đầu để sở hữu nó và sẵn tiện rước tôi về nhà nhé",
NEWSINGIN6 = "Không cần điểm danh bù",
SKINSKILL1 = "Kỹ năng ảo",
SKINSKILL2 = "Từ Skin--%s", 
SKINSKILL3 = "Duyên Nợ",
SKINSKILL4 = "Cách nhận",
BATTLE_EXIT_WARNING4 = "Cưỡng chế thoát sẽ bị phạt cấm thi đấu",
NEWDESC2 = "Nhắc nhở: Thuộc tính thú cưỡi được cộng dồn",
ASSIST_IN_FIGHTING= "Trợ chiến",
SUSPENSION_TITLE = "Phạt cấm thi đấu",
SUSPENSION_TIP = "Do rút lui trong Đấu Hạng, gây ảnh hưởng đến đồng đội, bạn bị cấm thi đấu",
SUSPENSION_TIP2 = "Số lần thoát trong ngày càng nhiều, thời gian cấm càng lâu",
SUSPENSION_TIP3 = "PS: Người chơi trợ chiến không tốn số lần và thể lực",
SUSPENSION_TIP4 = "(PS: Người chơi trợ chiến không tốn số lần và thể lực)",
ROOM_BEINVITED_4 = "%s mời bạn trợ chiến\n%s(%s)",
ROOM_BEINVITED_5 = "Người chơi được giúp đã thoát phòng, phòng giải tán",
ROOM_BEINVITED_6 = "Chỉ người chơi trợ chiến không được chơi ngay",
PARTNER_1 = "Đồng hành",
PARTNER_2 = "Dấu Chân",
CHANGESEX1 = [[
<T C="79,60,48" S="20" P="1">Đổi giới tính phải đạt điều kiện sau:</T><BR>5</BR>
<T C="79,60,48" S="20" P="1">1. Đã hủy quan hệ hộn nhân </T><T C="%s" S="20" P="1">%s</T><BR>5</BR>
<T C="79,60,48" S="20" P="1">2. Đã nhận hết đính kèm trong thư </T><T C="%s" S="20" P="1">%s</T><BR>5</BR>
]],
CHANGESEX2 = [[(Chưa hủy)]],
CHANGESEX3 = [[(Chưa hủy)]],
CHANGESEX4 = [[(Chưa nhận)]],
CHANGESEX5 = [[Xác nhận đổi giới tính?]],
CHANGESEX6 = [[Đổi giới tính phải hủy quan hệ hôn nhân trước]],
CHANGESEX7 = [[Đổi giới tính phải nhận hết đính kèm trong thư trước]],
BUBBLE_OPEN_BY_VIP= "VIP%d được dùng, tăng chứ?",
CHAT_BUBBLE_MESSAGE= "Khung chat đã mở, không thể kích hoạt lại",
CHANGESEX8 = [[Đổi giới tính thành công]],
WAKEUP_TEXT38 = "Đang khôi phục hành động không được dùng",
WAKEUP_TEXT39 = "Nhanh Nhẹn",
WAKEUP_TEXT40 = "Hiệu quả kỹ năng: Trong chiến đấu có thể hồi ngay %.1f điểm lực hành động",
WAKEUP_TEXT41 = {"Linh","động","nhanh"},
WAKEUP_TEXT42 = {"Chờ ban đầu","Chờ giãn cách","Hiệu quả khôi phục"},
COMMUNITYTASK_TEXT1 = {"Hôm nay","Ngày mai","Hôm sau","Ngày 3","Ngày 4","Ngày 5","Ngày 6","Ngày 7"},
COMMUNITYTASK_TEXT2 = "Nhiệm vụ đã công bố, thời gian hiệu lực còn ",
COMMUNITYTASK_TEXT3 = "Hãy phát nhiệm vụ ngày hôm trước rồi đến thực hiện thao tác!",
SKINSKILL5 = "Phẩm chất cao nhất",
WAKEUP_TEXT43 = "Điểm hành động đầy, không thể dùng kỹ năng Thức Tỉnh", 
YJ = "Vĩnh viễn",
GAME_ACTIVITY_EIGHTTIMES_DIAMOND ="Hoàn Trả Kim Cương x8",
CHECKOTHER12 = "Ngọc",
QUICKSELECT1 = "Chọn nhanh",
SUMMER_REWARD1 = "Truy Nã Tết",
QUICKSELECT2 = "Đá khác không hỗ trợ chọn nhanh",
QUICKSELECT3 = "Không còn vật phẩm có thể ghép",
QUICKSELECT4 = "Không có trang bị có thể chọn nhanh",
ITEM_COOL_TIME = "Đạo cụ đang chờ",
QUICKSELECT5 = "Pet phẩm chất cao không hỗ trợ chọn nhanh",
QUICKSELECT6 = "Nhấn giữ xem thông tin pet",
QUICKSELECT7 = "Nhấn giữ xem thông tin vật phẩm",
QUICKSELECT8 = "Mỗi lần tối đa thu hồi 16 pet",
PVPNEW_TEXT1 = "Vinh Dự Đấu Hạng Đặc Biệt",
PVPNEW_TEXT2 = "Mùa Giải S12 mở, khi tổng kết, người đạt Vinh Dự Tối Cao có thể nhận dấu ấn này",
PVPNEW_TEXT3 = "Giới hạn: %d/%d",
PVPNEW_TEXT4 = "Dấu Kẻ Mạnh",
GAME_ACTIVITY_RANKPVP_REWARD = "Thưởng Đấu Hạng",
FAMILY_TEXT33 = "Làm Thuê",
FAMILY_TEXT34 = "Bảo Vệ",
FAMILY_TEXT35 = "Hồi Phục",
FAMILY_TEXT36 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Đang bị thương không thể trộm, dùng </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%d</T> <I Z="0.46">%s</I><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> tăng tốc hồi phục</T>]],
FAMILY_TEXT37 = "Pet Làm Thuê",
FAMILY_TEXT38 = "Pet Bảo Vệ",
FAMILY_TEXT39 = [[<T C="127,70,26" S="18" P="1">Số làm thuê: </T><<T C="229,105,22" S="18" P="1">%d/%d</T>]],
FAMILY_TEXT40 = "Hiệu suất",
FAMILY_TEXT41 = "Bắt đầu",
FAMILY_TEXT42 = "Tăng hiệu suất",
FAMILY_TEXT43 = "Đang làm thuê...",
FAMILY_TEXT44 = "Pet đang làm thuê...",
FAMILY_TEXT45 = "May mắn đầy sẽ tăng hiệu suất",
FAMILY_TEXT46 = "Danh sách Pet Bảo Vệ",
FAMILY_TEXT47 = [[<T C="127,70,26" S="18" P="1">Bảo vệ còn: </T><T C="229,105,22" S="18" P="1">%s</T>]],
FAMILY_TEXT48 = "Đang sẽ mất hiệu quả bảo vệ, hãy cho ăn",
FAMILY_TEXT49 = "Ăn hết nổi rồi",
FAMILY_TEXT50 = "Cho Ăn",
FAMILY_TEXT51 = "Đạt hiệu suất cao nhất",
FAMILY_TEXT52 = "Thu hoạch xong, chưa bị trộm",
FAMILY_TEXT53 = "Thu hoạch xong, đã bị trộm %d lần",
FAMILY_TEXT54 = "Trộm thành công",
FAMILY_TEXT55 = "Bắt đầu bảo vệ",
FAMILY_TEXT56 = "Đặc tính: %d%% phát hiện và tấn công kẻ trộm",
FAMILY_TEXT57 = [[<T C="255,236,193" S="18" P="1">%s %d giờ Lợi ích </T><T C="255,227,116" S="18" P="1">%d</T><I Z="0.5">%s</I>]],
FAMILY_TEXT58 = "Đã tăng hiệu suất",
FAMILY_TEXT59 = "Chưa tăng hiệu suất",
FAMILY_TEXT60 = "Đang bảo vệ…",
FAMILY_TEXT61 = "Số Pet làm thuê đạt tối đa",
FAMILY_TEXT62 = "Nhật Ký Trộm",
FAMILY_TEXT63 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> %s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> đã trộm vật tư của pet </T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">!</T>]],
FAMILY_TEXT64 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> %s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> trộm vật tư bị Pet Bảo Vệ </T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> phát hiện, trộm thất bại</T>]],
FAMILY_TEXT65 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> %s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> trộm vật tư bị Pet Bảo Vệ </T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> phát hiện, đoạt lại vật tư</T>]],
FAMILY_TEXT66 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> Đã trộm được vật tư từ Pet của </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"></T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">!</T>]],
FAMILY_TEXT67 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> Đến trộm vật tư của </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> nhưng bị Pet Bảo Vệ </T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> phát hiện, trộm thất bại</T>]],
FAMILY_TEXT68 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> Đến trộm vật tư từ pet của </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> bị Pet Bảo Vệ </T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> phát hiện, đoạt lại vật tư</T>]],
FAMILY_TEXT69 = "Tư chất không đủ, hãy tăng cấp Sảnh Thuê",
FAMILY_TEXT70 = "Dùng %d %s mở ô pet thứ %d?",
FAMILY_TEXT71 = "Lv%d mới được tăng thêm ô",
FAMILY_TEXT72 = "Thiết lập bảo vệ thành công",
FAMILY_TEXT73 = "Đã trộm từ pet này rồi",
FAMILY_TEXT74 = "Pet bị trộm quá nhiều",
FAMILY_TEXT75 = "Bị Pet Bảo Vệ phát hiện, trộm thất bại",
FAMILY_TEXT76 = "Bị Pet Bảo Vệ phát hiện và tấn công, trộm thất bại",
FAMILY_TEXT77 = "Xong",
FAMILY_TEXT78 = "Đói",
FAMILY_TEXT79 = "Vườn bạn bè",
FAMILY_TEXT80 = "Pet chưa làm thuê xong",
FAMILY_TEXT81 = "Nhấp nút dưới để tăng hiệu suất",
FAMILY_TEXT82 = [[
<T C="229,105,22" S="22" P="0">Hướng dẫn Làm Thuê</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0"> Pet Làm Thuê là pet của bản thân, nhưng lợi ích không ảnh hưởng bởi mạnh yếu</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0"> Ban đầu có 2 vị trí Pet Làm Thuê, đạt cấp yêu cầu có thể dùng Kim Cương mở thêm, tối đa 6 ô</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Lợi ích nhận được tính theo hiệu suất, nhận khi kết thúc, không nhận kịp có thể bị trộm</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="20" P="0"> Có thể dùng Kim Cương tăng hiệu suất, thất bại tăng may mắn, điểm đầy sẽ tăng</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="20" P="0"> Khi bắt đầu lượt làm thuê mới, sẽ tạo mới ngẫu nhiên hiệu suất</T><BR>30</BR>

<T C="229,105,22" S="22" P="0">Hướng dẫn Trộm</T><BR></BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="20" P="0"> Pet làm thuê xong có thể bị trộm, hãy thu hoạch kịp thời</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Mỗi Pet Làm Thuê tối đa có thể bị trộm lợi ích 3 lần, cùng 1 người chỉ được trộm 1 lần</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Mỗi lần bị trộm mất 10% lợi ích làm thuê lần này, mỗi người mỗi ngày tối đa trộm thành công 10 lần</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Khi trộm có khả năng bị Pet Bảo Vệ tấn công, phẩm chất Pet Bảo Vệ càng cao, thời gian bị thương càng lâu, bị thương không thể trộm, có thể dùng Kim Cương tăng tốc hồi phục</T><BR>30</BR>

<T C="229,105,22" S="22" P="0">Hướng dẫn bảo vệ</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0"> Phẩm chất Pet bảo vệ không liên quan đến thú cưỡi của bản thân, mà tùy vào cấp Phòng Bảo Vệ</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Mỗi lần chỉ được chọn 1 Pet Bảo Vệ canh giữ</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="20" P="0"> Thời gian bảo vệ tùy vào thời hiệu thức ăn, hết hiệu lực sẽ mất đặc tính bảo vệ</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="20" P="0"> Pet Bảo Vệ phẩm chất càng cao, càng dễ phát hiện địch. Pet phẩm chất cao có thể tấn công, khiến địch bị thương và không thể trộm trong thời gian ngắn</T><BR></BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="20" P="0"> Khi bị Pet Bảo Vệ phát hiện, lần trộm này sẽ thất bại</T><BR></BR>

]],
FAMILY_TEXT83 = "Trễ rồi, chủ nhân đã nhận xong",
FAMILY_TEXT84 = "Không đủ số Pet làm thuê",
RUNEBOOK19 = "Toàn bộ Bùa Lv5",
RUNEBOOK20 = "Bùa muốn bán có %d Bùa Lv5, bán ngay?",
VIGOR_MAX = "Thể lực đạt tối đa, không thể dùng",
EXCHANGE1 = "Đổi vật phẩm",
EXCHANGE2 = "Chọn số lượng (1 lần tối đa %s)",
NPC_NAME_3 = "Thương Nhân",
CHALLENGE_SURPLUS_COUNT = "Khiêu chiến còn: ",
DAY_OF_THE_WEEK = {"Chủ Nhật","Thứ Hai","Thứ Ba","Thứ Tư","Thứ Năm","Thứ Sáu","Thứ Bảy"},
THE_NEXT_OPENING_TIME = "Chưa mở, thời gian mở gần nhất là %s %s-%s",
FOOTBALL_SHOOT = "Sút Luân Lưu",
FOOTBALL_SHOOT_FAIL = "Phát bóng thất bại",
FOOTBALL1 = "Bóng chưa vào lưới",
FOOTBALL_SUCCESS = "Sút vào lưới, điểm +%d",
FOOTBALL_FAIL = "Sút chưa vào, điểm +%d",
FOOTBALL_RESULT = "Kết quả thưởng",
FOOTBALL_STATE = "Đợi mở thưởng",
FOOTBALL_TEXT1 = "Tổng cược %s thắng: %d",
FOOTBALL_TEXT2 = "Tổng cược hòa: %d",
FOOTBALL_TEXT3 = "Bắt đầu",
FIELD_BETTING = "Cược trận này: ",
GUESS_WIN = "Đoán thắng",
GUESS_LOSE = "Đoán thua",
GUESS_DRAW = "Đoán hòa",
STOP_BETTING_AFTER_STARTING = " (Trận đấu bắt đầu sẽ ngừng nhận dự đoán)",
DRAW = "Hòa",
CURRENT_BET_WHO_WINS = "Hiện đang cược cho %s",
BET_AVAILABLE = "Dự đoán %d, được nhận %d %s",
REDEEM_PRIZES = "Đổi thưởng",
GUESSING_RECORDS = "Nhật ký dự đoán",
QUERIES_RANKING = "Hạng dự đoán",
QUIZ_PEOPLE = "Vua Dự Đoán",
CURRENT_WINNING = "Trúng thưởng",
RANK_REWARDS = "Thưởng Hạng",
QUIZZES_ISSUED_VIA_EMAIL = "Thưởng dự đoán sẽ được gửi qua thư khi thi đấu kết thúc (Do số liệu lớn, sẽ có trì hoãn)",
GAME_ACTIVITY_FOOTBALL_QUIZ = "Dự Đoán",
COUNTDOWN_TO_THE_GAME = "Thi đấu còn: %d ngày %d giờ %d phút %d giây",
FOOTBALL_TEXT4 = "Hãy đặt cược",
FOOTBALL_TEXT5 = "Đã đặt cược",
THE_GAME_HAS_STARTED = "Trận Đấu đã bắt đầu",
LABEL_END = "Kết thúc",
GAME_STARTED_CAN_NOT_BET = "Thi đấu đã kết thúc, không thể đặt cược",
MATCH_RESULTS = "Kết quả thi đấu:%d-%d",
FOOTBALL_TEXT6 = "Bóng không đủ, không sút được",
FOOTBALL_TEXT7 = "Tỉ suất:",
FOOTBALL_TEXT8 = [[
<T C="229,105,22" S="22" P="0">Hướng dẫn event Dự Đoán:</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0"> Dùng Xu Dự Đoán để dự đoán kết quả trận đấu. Khi trận đấu bắt đầu sẽ không thể dự đoán nữa. Mỗi trận cần đặt tối thiểu 100 Xu.</T><BR></BR>
<T C="229,105,22" S="22" P="0">Dự đoán đúng sẽ nhận được số thưởng = Số xu đặt x Tỉ Suất. </T><BR></BR>
<T C="229,105,22" S="22" P="0">Dự đoán sai sẽ không nhận được thưởng.</T><BR></BR>
<T C="229,105,22" S="22" P="0">Dùng Xu Dự Đoán để đổi thưởng tại giao diện hoạt động.</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0"> Thưởng dự đoán sẽ gửi qua thư sau khi trận đấu kết thúc khoảng 1 ngày.</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Thưởng BXH sẽ được gửi qua thư sau khi kết thúc hoạt động.</T><BR></BR>
<T C="229,105,22" S="22" P="0">Hướng dẫn event Sút Luân Lưu:</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0"> Dùng Bóng Luân Lưu để sút. Mỗi bóng tương ứng với 1 lượt sút.</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0"> Khi sút bóng có xác xuất bị thủ môn ngăn chặn </T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Thưởng BXH sẽ gửi qua thư khi sự kiện kết thúc.</T><BR></BR>
]],
LEVELUP_TO_TEN= "Bỏ qua tân thủ?",
WAKEUP_TEXT44 = "Dùng Thẻ Quên Thiên Phú tạo mới thiên phú? Thiên phú đã học sẽ quên hết và hoàn trả điểm thiên phú",
WAKEUP_TEXT45 = "Tạo mới thiên phú thành công",
WAKEUP_TEXT46 = "Không cần tạo mới thiên phú",

PET_TEXT1 = "Biến hình",
PET_TEXT2 = "Pet biến hình",
PET_TEXT3 = "Đang biến hình...",
PET_TEXT4 = "Pet có thể biến hình",
PET_TEXT5 = "Không có Pet có thể biến hình",
PET_TEXT6 = "Pet không thể biến hình",
PET_TEXT7 = "Biến hình thành công",
PET_TEXT8 = "Đã trong hình dạng đang chọn, không cần biến hình",
PET_TEXT9 = "Hãy chọn Pet muốn biến hình",
PET_TEXT10 = "Pet sắp gộp có Pet đã biến hình, tiếp tục không?",
PET_TEXT11 = "Pet thu hồi có Pet đã biến hình, tiếp tục không?",
PET_TEXT12 = "Pet sắp tách có Pet đã biến hình, tiếp tục không?",

MATCHING_TEXT1 = "Đang ghép trận, không thao thao tác",
MATCHING_TEXT2 = "Treo",
PET_TEXT13 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn biến hình</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">1.</T><T C = "127,70,26" S = "20" P = "0">Chỉ có thể biến hình thành Pet có giới hạn tư chất ban đầu giống nhau</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">2.</T><T C = "127,70,26" S = "20" P = "0">Phải từng sở hữu Pet muốn biến hình (Chỉ cần đã từng sở hữu, nhưng chỉ tính cho Pet sở hữu sau cập nhật lần này)</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">3.</T><T C = "127,70,26" S = "20" P = "0">Pet sau khi biến hình sẽ hiển thị ngoại hình mới, nhưng thuộc tính và lực chiến không đổi</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">4.</T><T C = "127,70,26" S = "20" P = "0">Biến hình có hiệu lực vĩnh viễn, có thể biến hình thành ngoại hình khác</T><BR></BR>
]],


CARD_TEXT35 = "Cấp Thẻ Bài: ",
CARD_TEXT36 = {"Tổng Cấp Thẻ Cam:  ","Tổng Cấp Thẻ Tím:  ","Tổng Cấp Thẻ Lam:  ","Tổng Cấp Thẻ Lục: "},
DRESSSUIT_TEXT1 = "Tên tối đa 8 ký tự",
DRESSSUIT_TEXT2 = "Đổi tên thành công",
DRESSSUIT_TEXT3 = "Trả %d %s để mở bộ thứ %d?",
FAMILY_TEXT85 = "Vườn",
SKILL_TEXT1 = "Nhấp chọn kỹ năng để dùng hoặc tháo",
SKILL_TEXT2 = "Nhấp chọn đạo cụ để dùng hoặc tháo",
COMMUNITY_DECLARElEN_ATT = "Tuyên ngôn Công Hội tối đa 66 ký tự",
BLACKLIST_TEXT1 = "Sổ Đen",
BLACKLIST_TEXT2 = "Thêm Sổ Đen sẽ không thể chat với người này trên kênh Riêng, Hiện Tại, Thế Giới, đồng ý?",
BLACKLIST_TEXT3 = "Thêm Sổ Đen sẽ hủy quan hệ bạn bè, không thể chat với người này trên kênh Riêng, Hiện Tại, Thế Giới, đồng ý?",
BLACKLIST_TEXT4 = "Người chơi này trong Sổ Đen, xin kết bạn sẽ xóa khỏi Sổ Đen, tiếp tục không?",
BLACKLIST_TEXT5 = "Không thể nhận tin chat từ người này trên kênh Riêng, Hiện Tại, Thế Giới",
BLACKLIST_TEXT6 = "Không có ai trong Sổ Đen",
BLACKLIST_TEXT7 = "Xóa Sổ Đen",
BLACKLIST_TEXT8 = "Thêm Sổ Đen",
BLACKLIST_TEXT9 = "Hai bên là bạn thân, không thể thêm Sổ Đen",
BLACKLIST_TEXT10 = "Hai bên là thầy trò, không thể thêm Sổ Đen",
BLACKLIST_TEXT11 = "Hai bên là vợ chồng, không thể thêm Sổ Đen",
BLACKLIST_TEXT12 = "Đã xóa Sổ Đen",
BLACKLIST_TEXT13 = "Đã thêm Sổ Đen",
COMMUNITY_DECLARElEN_ATT2 = "Đã sửa",
BLACKLIST_TEXT14 = "Sổ Đen đã đầy, không thể thêm",
PET_TEXT14 = "Xem Pet",
DAILY_TEXT1 = "VIP%d mở tạo mới, nạp ngay?",
CHECKOTHER_TEXT1 = "Hiện đang dùng thử, trả %d %s để mua?",
CHECKOTHER_TEXT2 = "Sau khi kết hôn mới hiển thị bạn đời",
CHECKOTHER_TEXT3 = "Thiết lập nền",
CHECKOTHER_TEXT4 = "Hiển thị Cánh",
CHECKOTHER_TEXT5 = "Hiển thị bạn đời",
CHECKOTHER_TEXT6 = "Hiển thị Pet",
CHECKOTHER_TEXT7 = "Hiển thị con",
CHECKOTHER_TEXT8 = "Chưa mở Pet",
DAILY_TEXT2 = "Chưa nhận lợi ích tối đa, không thể càn quét!",
KID_TEXT1 = [[<T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">Tuổi: </T><T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">%.1f tuổi</T>]],
KID_TEXT2 = [[<T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">Trưởng thành: </T><T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">%d</T>]],
KID_TEXT3 = [[<T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">Chăm sóc: </T><T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">%d</T>]],
KID_TEXT4 = "Chọn cho ăn",
KID_TEXT5 = "Nhập số lượng",
KID_TEXT6 = "Dùng %s có thể tăng %d điểm trưởng thành",
KID_TEXT7 = [[<T C="127,70,26" S="20" P="1">Nhận buff Chăm Sóc sẽ tăng </T><T C="255,105,22" S="20" P="1">%d</T><T C="127,70,26" S="20" P="1"> lực chiến, duy trì </T><T C="255,105,22" S="20" P="1">%d</T><T C="127,70,26" S="20" P="1"> giờ, tiếp tục không?</T>]],
KID_TEXT8 = "Sau khi có con mới được chăm sóc",
KID_TEXT9 = "Nhận buff Chăm Sóc",
KID_TEXT10 = "Chọn chăm sóc",
KID_TEXT11 = "Chọn Tã",
KID_TEXT12 = "Thay Tã",
KID_TEXT13 = {"Đồ dùng","Trang sức","Con","Bảo Mẫu","Thức ăn","Thời trang","Túi"}, 
KID_TEXT14 = "Bảo Mẫu Dễ Thương",
KID_TEXT15 = "Có thể tự động dùng thức ăn giúp con trưởng thành, giảm 50% thời gian mang thai",
KID_TEXT16 = "Thuê",
KID_TEXT17 = "Chọn thời gian thuê",
KID_TEXT18 = "Thời gian còn lại",
KID_TEXT19 = "Bảo mẫu đã ngưng việc",
KID_TEXT20 = "Nhận Nuôi",
KID_TEXT21 = "Sinh Con",
KID_TEXT22 = "Chưa kết hôn mới được nhận nuôi",
KID_TEXT23 = "Kết hôn mới được sinh con",
KID_TEXT24 = "Mang thai thất bại, hãy thử lại nhé!",
KID_TEXT25 = "Yêu Thương đạt Lv%d mới được sinh con",
KID_TEXT26 = "Độc thân chỉ được nuôi 1 con!",
KID_TEXT27 = "Vợ chồng sinh tối đa 2 con!",
KID_TEXT28 = "Nhận nuôi",
KID_TEXT29 = "Sinh con",
KID_TEXT30 = "Không có bạn đời có thể nhận con nuôi",
KID_TEXT31 = "Yêu Thương đạt Lv%d mới được sinh con",
KID_TEXT32 = "Xác xuất mang thai %d%% ",
KID_TEXT33 = "Nhận nuôi thành công",
KID_TEXT34 = "Mang thai thành công",
KID_TEXT35 = "Đứa con hiện thời là bé trai, có muốn đổi không?",
KID_TEXT36 = "Đứa con hiện thời là bé gái, có muốn đổi không?",
KID_TEXT37 = "Đứa con hiện thời là bé trai, chọn xác định sẽ không thể đổi nữa",
KID_TEXT38 = "Đứa con hiện thời là bé gái, chọn xác định sẽ không thể đổi nữa",
KID_TEXT39 = "Tên con tối đa 8 ký tự",
KID_TEXT40 = "Đã thuê, Bảo Mẫu sẽ chăm lo cho bé!",
KID_TEXT41 = "Đã tăng thời gian thuê",
KID_TEXT42 = "Nhà",
KID_TEXT43 = "Lễ Đường",
KID_TEXT44 = "Kết Bạn",
KID_TEXT45 = "Vợ chồng",
KID_TEXT46 = "Cầu Hôn",
KID_TEXT47 = "Quen Biết",
KID_TEXT48 = "Đính Hôn",
KID_TEXT49 = "Chăm Sóc",
KID_TEXT50 = "Quản Lý",
KID_TEXT51 = "Nhà Bạn",
KID_TEXT52 = "Thuộc tính của tất cả Thời Trang cùng giới tính đều có thể cộng dồn",
KID_TEXT53 = "Thoải Mái",
KID_TEXT54 = "Đang Yêu",
KID_TEXT55 = "Hôn Lễ",
KID_TEXT56 = "Con Cái",
KID_TEXT57 = "Đang chăm sóc...",
KID_TEXT58 = "Đang mang thai...",
KID_TEXT59 = "Đang làm thủ tục",
KID_TEXT60 = "Thú Nhún",
KID_TEXT61 = "Đã hết lượt mua",
KID_TEXT62 = "Cần có có trước đã!",
KID_TEXT63 = "Đang mang thai, làm sao mang thai tiếp được...",
KID_TEXT64 = "Đang làm thủ tục, không thể nhận nuôi tiếp",
KID_TEXT65 = "Bắt đầu Thú Nhún",
KID_TEXT66 = "Thú Nhún",
KID_TEXT67 = [[<T C="127,70,26" S="20" P="1">Trả </T><T C="255,105,22" S="20" P="1">%d</T> <I Z="0.5">%s</I><T C="127,70,26" S="20" P="1"> cho %s chơi Thú Nhún? Có thể tăng </T><T C="255,105,22" S="20" P="1">%d</T><T C="127,70,26" S="20" P="1"> điểm Chăm Sóc</T>]],
KID_TEXT68 = "Mỗi ngày chỉ 1 lần!",
KID_TEXT69 = "Chăm sóc thành công",
KID_TEXT70 = "Bắt đầu chơi Thú Nhún",
KID_TEXT71 = "Mỗi ngày chỉ 1 lần!",
KID_TEXT72 = "Không thể tăng thời gian thuê nữa",
KID_TEXT73 = "Đây là đồ chơi trẻ em, có con chưa?",
CHECKOTHER_TEXT9 = "Đang ghép trận, không thể thiết lập",
CHECKOTHER_TEXT10 = "Đang chiến đấu, không thể thiết lập",
KID_TEXT74 = "Túi trống",
KID_TEXT75 = "Không bán loại vật phẩm này",
KID_TEXT76 = "Không bán loại thời trang này",
KID_TEXT77 = [[<T C="127,70,26" S="20" P="1">Cha cống hiến: </T><T C="255,105,22" S="20" P="1"> %d</T>]],
KID_TEXT78 = [[<T C="127,70,26" S="20" P="1">Mẹ cống hiến: </T><T C="255,105,22" S="20" P="1"> %d</T>]],
KID_TEXT79 = "Thủ tục ly hôn",
KID_TEXT80 = "Xác nhận ly hôn",
KID_TEXT81 = "Bỏ quyền nuôi con",
KID_TEXT82 = "Bạn xác định bỏ quyền nuôi con?",
KID_TEXT83 = "Bạn cống hiến cho %s nhiều nhất, chọn quyền nuôi dưỡng %s, quyền nuôi dưỡng %s sẽ chuyển cho bên kia",
KID_TEXT84 = "Bạn cống hiến cho %s nhiều nhất, nếu chọn quyền nuôi dưỡng %s cần được bên kia đồng ý (Nếu bị từ chối, bạn được nhận quyền nuôi %s)",
KID_TEXT85 = "Bên kia cống hiến cho con nhiều nhất, bạn chọn quyền nuôi dưỡng %s cần bên kia đồng ý (Nếu bị từ chối, bạn nhận được quyền nuôi dưỡng %s)",
KID_TEXT86 = "Bạn đời đã yêu cầu ly hôn, (sau khi ly hôn đồ cưới sẽ biến mất), đồng thời muốn được quyền nuôi %s. Hãy xác định đứa con bạn muốn nuôi (Đứa con còn lại sẽ thuộc về người kia. Sau 5 ngày không xử lý sẽ buộc thực hiện theo lựa chọn của bên kia)",
KID_TEXT87 = "Không thể bỏ con riêng của mình",
KID_TEXT88 = "Không thể chọn con riêng của bên kia",
KID_TEXT89 = "Đã chọn quyền nuôi dưỡng %s, tiếp tục?",
KID_TEXT90 = "Xin ly hôn phải nộp %d Kim Cương Khóa làm thủ tục, sau khi ly hôn đồ cưới sẽ biến mất, ",
KID_TEXT91 = "Chỉ có thể chọn con riêng của mình",
KID_TEXT92 = "Bạn cống hiến cho con nhiều hơn, sau khi bạn chọn quyền nuôi dưỡng, quyền nuôi con sẽ thuộc về bạn, đồng ý?",
KID_TEXT93 = "Bạn đời cống hiến cho con nhiều hơn, khi chọn quyền nuôi dưỡng cần bên kia đồng ý (Nếu bị từ chối, bạn buộc phải bỏ quyền nuôi con), đồng ý?",
KID_TEXT94 = "Nếu chọn đứa con mà bạn đời cống hiến nhiều hơn, cần bên kia đồng ý. Nếu có con riêng thì chỉ có thể chọn con riêng.",
KID_TEXT95 = "Bạn đời đã yêu cầu ly hôn, (sau khi ly hôn đồ cưới sẽ biến mất), đồng thời muốn được quyền nuôi %s. Hãy xác định đứa con bạn muốn nuôi (Đứa con còn lại (nếu có) sẽ thuộc về người kia. Sau 5 ngày không xử lý sẽ buộc thực hiện theo lựa chọn của bên kia)",
KID_TEXT96 = "Bạn đời đã yêu cầu ly hôn, (sau khi ly hôn đồ cưới sẽ biến mất), bên kia muốn bỏ quyền nuôi con, hãy xác nhận lựa chọn của bạn? (Nếu bạn cũng bỏ, người nuôi đứa bé sẽ được quyết định theo mức cống hiến)",
KID_TEXT97 = "Ly hôn thành công, bạn được quyền nuôi dưỡng %s",
KID_TEXT98 = "Ly hôn thành công, bên kia được quyền nuôi dưỡng %s",
KID_TEXT99 = "Ly hôn thành công, bạn được quyền nuôi dưỡng %s, bên kia được quyền nuôi dưỡng %s",
KID_TEXT100 = [[<T C="127,70,26" S="20" P="1">Thuộc ngườichơi: </T><T C="255,105,22" S="20" P="1"> %s</T>]],
KID_TEXT101 = "Vỗ về thành công",
KID_TEXT102 = "Cho ăn thành công",
KID_TEXT103 = "Đã thay tã",
KID_TEXT104 = {"Tiệm Đồ Dùng","Tiệm Trang Sức","Con","Tiệm Bảo Mẫu","Tiệm Thức Ăn","Thời Trang Trẻ Em","Túi"},
KID_TEXT105 = "Nhận",
KID_TEXT106 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn Nhà</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">1.</T><T C = "127,70,26" S = "20" P = "0">Phòng càng thoải mái, trẻ càng mau lớn, thêm đồ gia dụng có thể tăng điểm thoải mái (Đã mua chưa đặt vào cũng sẽ tăng)</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">2.</T><T C = "127,70,26" S = "20" P = "0">Điểm trưởng thành của con càng cao, trưởng thành càng nhanh</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">3.</T><T C = "127,70,26" S = "20" P = "0">Con khóc, đói, ướt tã sẽ giảm trưởng thành, cần vỗ về, cho ăn hay thay tã để hồi phục</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">4.</T><T C = "127,70,26" S = "20" P = "0">Điểm Chăm Sóc có thể thông qua vuốt ve, chơi Thú Nhún, mua thời trang để hồi phục</T><BR></BR>
<T C = "229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="20" P="0"> Ly hôn khi đang mang thai, con sẽ không thể ra đời! Hãy thao tác cẩn thận!</T><BR></BR>
<T C = "229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="20" P="0"> Kết hôn khi đang nhận nuôi, sẽ không thể nhận nuôi con, hãy thao tác cẩn thận</T><BR></BR>
]],
KID_TEXT107 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn Chăm Sóc</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">1.</T><T C = "127,70,26" S = "20" P = "0">Chọn chăm sóc có thể nhận tỉ lệ thuộc tính tăng thêm từ con. Con chưa chọn cũng có thể tăng 20% thuộc tính nếu chăm sóc đạt 100%</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">2.</T><T C = "127,70,26" S = "20" P = "0">Mỗi ngày chỉ 1 lần! Duy trì 20 giờ</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">3.</T><T C = "127,70,26" S = "20" P = "0">BUFF Chăm Sóc bị trùng sẽ tính hiệu quả BUFF mới nhất</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">4.</T><T C = "127,70,26" S = "20" P = "0">Khi được BUFF Chăm Sóc sẽ không thay đổi khi con tăng thuộc tính</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">5.</T><T C = "127,70,26" S = "20" P = "0">Thăm Hỏi nhà người khác sẽ tăng nhận thêm 10% lực chiến của trẻ con nhà đó</T><BR></BR>
]],
KID_TEXT108 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn Thuê</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">1.</T><T C = "127,70,26" S = "20" P = "0">Khi mang thai, có thể nhờ bảo mẫu chăm sóc, rút ngắn 1/2 thời gian ra đời</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">2.</T><T C = "127,70,26" S = "20" P = "0">Bảo mẫu sẽ chăm sóc trẻ, tự động vỗ về, cho ăn, thay tã (Nếu không đủ tã và thức ăn, bảo mẫu cũng hết cách)</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">3.</T><T C = "127,70,26" S = "20" P = "0">Cần trả phí để bảo mẫu làm việc, nếu không sẽ ngưng việc đấy!</T><BR></BR>
]],
KID_TEXT109 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn Thời Trang</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0">Mua thời trang sẽ tăng thuộc tính tất cả con đang có</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0">Được nhận thuộc tính tăng thêm đầy đủ từ thời trang thuộc tính cao nhất (Không cần mặc), thời trang khác sẽ tăng 10% thuộc tính</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0">Thời trang do cha mẹ mua sẽ hiển thị riêng biệt, có thể chọn đồ mặc tùy ý.</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="20" P="0">Muốn đổi giới tính cho con, cần tháo bỏ tất cả Thời Trang con đang mặc</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="20" P="0">Khi đổi giới tính cho con, sẽ không thay đổi giới tính của món Thời Trang con đang mặc</T><BR></BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="20" P="0">Thuộc tính của tất cả Thời Trang cùng giới tính đều có thể cộng dồn</T><BR></BR>
]],

KID_TEXT110 = "Kiên nhẫn chờ con chào đời",
KID_TEXT111 = [[<T C = "255,227,116" S = "20" P = "1" SC = "105, 65, 46" SS = "4" SE = "1">Trưởng thành: </T><T C = "99, 255, 95" S = "20" P = "1" SC = "0, 72, 3" SS = "4" SE = "1">%d/%d</T>]],
KID_TEXT112 = "Thay %s có thể tăng %d điểm trưởng thành",
KID_TEXT113 = "Trưởng thành đã đạt tối đa",
KID_TEXT114 = "Không thể vượt quá trưởng thành tối đa",

KID_TEXT115 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn Túi</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">1.</T><T C = "127,70,26" S = "20" P = "0">Vợ chồng dùng chung túi, cùng chăm con, sắp xếp nhà cửa</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">2.</T><T C = "127,70,26" S = "20" P = "0">Cha mẹ mua vật phẩm sẽ hiện riêng, có thể dùng chung</T><BR></BR>
]],
KID_TEXT116 = "Trên tường đã hết chỗ ",
KID_TEXT117 = "Vuốt ve thành công",
KID_TEXT118 = "Mỗi ngày chỉ 1 lần!",
KID_TEXT119 = "Cha",
KID_TEXT120 = "Mẹ",
KID_TEXT121 = "Con đang chơi thú nhún",
GAME_ACTIVITY_ATHLETIC_VICTORY ="Trận Thắng Thi Đấu",
GAME_ACTIVITY_RANKING_VICTORY ="Trận Thắng Xếp Hạng",
GAME_ACTIVITY_PET_UPGRADE ="Tăng cấp Pet",
GAME_ACTIVITY_MOUNT_UPGRADE ="Tăng cấp thú cưỡi",
GAME_ACTIVITY_EQUIPMENT_CALL ="Nhận Trang Bị",
GAME_ACTIVITY_PET_QUAIL ="Đập Trứng Pet",
GAME_ACTIVITY_CONTINUOUS_LOGIN = "Đăng nhập liên tục",
GAME_ACTIVITY_CHANNEL_RECHARGE = "Nạp qua kênh",
CHECKOTHER_TEXT11 = "Thuộc tính chăm sóc: ",
CHECKOTHER_TEXT12 = "Hôm nay chưa chăm sóc",
CHECKOTHER_TEXT13 = " (%.1f tuổi)",
SINGLECOPY_TEXT1 = "Lãnh Chúa",
SINGLECOPY_TEXT2 = " (Mỗi CN bình chọn Lãnh Chúa)",
SINGLECOPY_TEXT3 = "Thông tin khiêu chiến Lãnh Chúa lần này",
SINGLECOPY_TEXT4 = [[<T C="79,60,48" S="18" P="0">Thưởng Lãnh Chúa: </T>]],
SINGLECOPY_TEXT5 = "Ứng viên kỳ sau",
SINGLECOPY_TEXT6 = "Điểm ải: ",
SINGLECOPY_TEXT7 = "Hạng khiêu chiến",
SINGLECOPY_TEXT8 = "Lãnh Địa",
SINGLECOPY_TEXT9 = "Sở Hữu Lãnh Địa",
SINGLECOPY_TEXT10 = "Đã Chiếm Lãnh Địa",
SINGLECOPY_TEXT11 = "Lãnh Địa ứng viên kỳ sau",
SINGLECOPY_TEXT12 = "Đã đoạt hạng 1 ải cao hơn, không thể lên BXH",
SINGLECOPY_TEXT13 = [[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0"> Trong vùng đất chưa có Lãnh Chúa, sau khi vượt phó bản sẽ trở thành Lãnh Chúa</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0"> Trong vùng đất đã có Lãnh Chúa, đánh bại Lãnh Chúa hiện tại sẽ trở thành Lãnh Chúa</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0"> Trở thành Lãnh Chúa sẽ nhận nhiều thuộc tính Bảo Vệ Lãnh Chúa (Thuộc tính chỉ hiệu lực trong Bảo Vệ Lãnh Chúa)</T><BR></BR> 
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Mỗi người được góp mặt trong 3 bảng đánh giá phó bản</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="20" P="0"> Trong độ khó Ác Mộng, chỉ khi khiêu chiến 3 sao thành công mới được trở thành Lãnh Chúa</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="20" P="0"> Lãnh Chúa được nhận thưởng theo thời gian chiếm lĩnh. Khi mất địa vị Lãnh Chúa, thưởng sẽ được gửi qua thư</T><BR></BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="20" P="0"> Sau khi trở thành Lãnh Chúa, sẽ có 22 giờ bảo vệ không bị khiêu chiến. Sau khi hết thời gian chiếm lĩnh sẽ mất địa vị Lạnh Chúa, phải chiếm lĩnh từ đầu</T><BR></BR>
<T C="229,105,22" S="22" P="0">7.</T><T C="127,70,26" S="20" P="0"> Định dạng Thưởng Lãnh Chúa: Số lượng vật phẩm/đơn vị thời gian chiến lĩnh. VD: 10/2h, tức mỗi chiếm lĩnh 2 giờ sẽ nhận được 10 vật phẩm</T><BR></BR>
<T C="229,105,22" S="22" P="0">8.</T><T C="127,70,26" S="20" P="0"> Sau khi đã chiếm 3 lãnh địa, chỉ có thể khiêu chiến phó bản độ khó cao hơn để đoạt địa vị Lãnh Chúa, đồng thời sẽ tự thế vào phó bản độ khó thấp hơn</T><BR></BR>
]],
MATCHMAKE_TEXT1 = "Đã kết hôn, không thể tìm bạn đời nữa",
MATCHMAKE_TEXT2 = [[<T C="105,65,46" S="20" P="0">Dùng %d </T><I Z="0.5">%s</I><T C="105,65,46" S="20" P="0"> nhận trạng thái đề cử? Cần đề cử không? (Hiệu lực trong lần đăng ký này)</T>]],
MATCHMAKE_TEXT3 = "Thông tin đăng ký lần này đã được đề cử rồi!",
MATCHMAKE_TEXT4 = "Đăng ký xong mới được đề cử",
MATCHMAKE_TEXT5 = "Chưa có thông tin đăng ký!",
MATCHMAKE_TEXT6 = "Đăng ký",
MATCHMAKE_TEXT7 = "Hủy thông tin đăng ký tìm bạn đời? Hủy sẽ không hoàn trả Kim Cương!",
MATCHMAKE_TEXT8 = "Xem Nữ",
MATCHMAKE_TEXT9 = "Xem Nam",
MATCHMAKE_TEXT10 = "Đã đề cử",
MATCHMAKE_TEXT11 = "Tuyên Ngôn Kết Bạn: ",
MATCHMAKE_TEXT12 = " (Đăng ký có hiệu lực %d ngày, quá hạn phải đăng ký lại)",
MATCHMAKE_TEXT13 = "Hạn đăng ký: ",
MATCHMAKE_TEXT14 = "Hủy đăng ký",
MATCHMAKE_TEXT15 = "Xác nhận sửa",
MATCHMAKE_TEXT16 = "Đã sửa tuyên ngôn",
MATCHMAKE_TEXT17 = "Đăng ký thành công",
MATCHMAKE_TEXT18 = "Tuyên Ngôn Kết Bạn không thể có khoảng trắng",
MATCHMAKE_TEXT19 = "Tuyên Ngôn Kết Bạn không được quá %d chữ",
MATCHMAKE_TEXT20 = "Nhập Tuyên Ngôn Kết Bạn",
MATCHMAKE_TEXT21 = "Đã hủy đăng ký",
MATCHMAKE_TEXT22 = "Đã sửa tuyên ngôn",
KID_TEXT122 = "Đang có thời trang mặc thử chưa mua, mua ngay?",
FIRST_DAY_CAN_NOT_DONATE = "Ngày đầu gia nhập Guild không thể cống hiến, ngày mai hãy quay lại !!!",
TEAMBOSS_TEXT1 = "Lãnh Chúa Vực Sâu",
TEAMBOSS_TEXT2 = 
[[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0"> Quy tắc Lãnh Chúa Vực Sâu</T><BR>10</BR>
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="22" P="0"> Lãnh Chúa xuất hiện từ 9:00 -12:00 mỗi ngày. Khiêu chiến nhận thưởng phong phú và Uy Danh để xây dựng công hội.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Đội gây sát thương cho Lãnh Chúa càng nhiều, thưởng càng cao. Hoàn thành mốc sát thương để nhận mảnh vỡ Khế Ước.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Thưởng từ Lãnh Chúa được phát vào 12h mỗi ngày.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Mỗi lần khiêu chiến sẽ kết thúc khi Lãnh Chúa tấn công 10 lượt.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Mỗi ngày sẽ thay đổi Lãnh Chúa. Lãnh Chúa bị tiêu diệt thì sẽ mạnh hơn vào hôm sau.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Cùng 1 người chơi đạt được thứ hạng trong nhiều BXH đội thì chỉ nhận được phần thưởng dành cho thứ hạng cao nhất.</T><BR>10</BR>
]],
TEAMBOSS_TEXT3 = "ID:",
TEAMBOSS_TEXT4 = "Lãnh Chúa Vực Sâu",
TEAMBOSS_TEXT5 = "Chỉ chủ phòng được thiết lập",
TEAMBOSS_TEXT6 = "%s mời bạn vào Phòng Lãnh Chúa Vực Sâu cùng chiến đấu",
TEAMBOSS_TEXT7 = "Chi tiết",
TEAMBOSS_TEXT8 = "Sát thương đội",
TEAMBOSS_TEXT9 = "Sát thương đơn",
TEAMBOSS_TEXT10 = "BOSS còn ",
TEAMBOSS_TEXT11 = "Thưởng sát thương",
TEAMBOSS_TEXT12 = "Lãnh Chúa Vực Sâu chưa bị tiêu diệt, hãy cố gắng hơn!",
TEAMBOSS_TEXT13 = "Đã tiêu diệt BOSS Lãnh Chúa Vực Sâu!",
TEAMBOSS_TEXT14 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Đã hết lượt khiêu chiến, dùng </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%d</T> <I Z="0.46">%s</I><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">mua 1 cơ hội?</T>]],
TEAMBOSS_TEXT15 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Đạt </T><T C="99,255,95" S="20" P="1" SC="0,72,3" SE="1" SS="4">VIP%d</T> <T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">được mua nhiều lượt hơn, tăng cấp VIP ngay?</T>]],
TEAMBOSS_TEXT16 = "Sát thương: ",
TEAMBOSS_TEXT17 = [[Đã diệt được BOSS!]],
TEAMBOSS_TEXT18 = "Chưa đến giờ khiêu chiến Lãnh Chúa Vực Sâu, cổ vũ vô hiệu!",
TEAMBOSS_TEXT19 = "Khiêu chiến Lãnh Chúa Vực Sâu hôm nay đã kết thúc, không thể cổ vũ!",
TEAMBOSS_TEXT20 = "Khiêu chiến Lãnh Chúa Vực Sâu hôm nay đã kết thúc!",
TEAMBOSS_TEXT21 = "Lãnh Chúa Vực Sâu xuất hiện lúc 9:00",
TEAMBOSS_TEXT22 = "Lãnh Chúa Vực Sâu đã bị đẩy lui! Mai chiến tiếp nhé!",
TEAMBOSS_TEXT23 = "Sinh lực BOSS: ",
TEAMBOSS_TEXT24 = "Lượt còn lại: ",
CHAT_CANTBUY = "Đang chiến đấu, không thể mua",
PVPGOOD_TEXT1 = "Đã thích %s",
PVPGOOD_TEXT2 = "%s đã thích bạn",
PVPGOOD_TEXT3 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Bạn được thích trong Đấu Hạng </T><BR></BR><T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">%d lần</T>]],
GHOSTBATTLE_TEXT1 = "Hãy chọn muc tiêu",
GHOSTBATTLE_TEXT2 = "Kỹ năng chỉ dùng cho phe ta",
GHOSTBATTLE_TEXT3 = "Kỹ năng chỉ dùng cho phe địch",
GHOSTBATTLE_TEXT4 = "Mục tiêu đã tử vong",
GHOSTBATTLE_TEXT5 = "Chậm rồi, rương bị lấy hết!",
GHOSTBATTLE_TEXT6 = "Đã xuất hiện Rương U Linh mới!",
GHOSTBATTLE_TEXT7 = "Chỉ được dùng trong lượt hành động của mục tiêu",
GENERAL_LIST = "Tổng Hợp",
RANK_SCORE_DESC1 = [[<T C="99,255,95" S="22" P="0">%s</T><T C="255,237,192" S="22" P="0"> Đấu Điểm đoạt được hạng 1! Bá đạo tuyệt đỉnh!</T>]],
RANK_SCORE_DESC2 = "Đã nhận hết Vàng",
RANK_SCORE_DESC3 = 
[[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0">Trùm Thi Đấu</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Trùm Thi Đấu sẽ hiện tên 3 người chơi hạng cao nhất trong Đấu Hạng.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Chọn "Thích" người chơi bất kỳ, sẽ nhận được Thể Lực</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Mỗi Mùa Giải kết thúc sẽ thay đổi đối tượng hiển thị</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0">Người chơi khác có thể chọn Thích nhân vật lọt vào BXH, nhận thưởng Vàng (Nhận thủ công)</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0">Có thể xem xếp hạng mới nhất tại giao diện "BXH"</T><BR>10</BR>
]],
RANK_SCORE_DESC4 = 
[[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0">Sao Tuần</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Sao Tuần sẽ hiện tên 3 người chơi điểm cao nhất trong Đấu Điểm tuần này.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Chọn "Thích" người chơi bất kỳ, sẽ nhận được Thể Lực</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0">Người chơi khác có thể chọn Thích nhân vật lọt vào BXH, nhận thưởng Vàng (Thưởng gửi qua thư lúc 0 giờ mỗi ngày)</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0">Có thể xem xếp hạng mới nhất tại giao diện "BXH"</T><BR>10</BR>
]],
GUILD_BOSS_TEXT1 = "Tổng sát thương",
GUILD_BOSS_TEXT2 = "CD Pow BOSS",
BOSSROOM_SWITCH_DIFFICULTY_TIPS_DIYU = "Chưa vượt qua độ khó trước, không thể khiêu chiến độ khó cao hơn",

TEAMBOSSROOM_NAME_ERROR = "Tên phòng tối đa 9 ký tự",
BADGELEVEL = "Cấp Huy Hiệu: ",
PAIWEISAI_SEASON_MODE_1V1 ="Mùa giải là này dạng 1V1, không thể mở vị trí này",
PAIWEISAI_SEASON_MODE_2V2 ="Mùa giải là này dạng 2V2, không thể mở vị trí này",
PVP_HALL_39 = "Dạng Quái Thú",
PVP_HALL_40 = "Kẻ Địch Ngụy Trang",
PVP_HALL_41 = "Hãy cẩn thận những kẻ địch ẩn nấp xung quanh! Có thể chúng là quái thú đấy!",
MELEE_DESC13 = "Hệ thống sẽ ghép 4 người có thực lực tương đương với nhau, trong đó 1 người sẽ biến thành Quái Thú, những người còn lại phải đánh bại Quái Thú mới giành được thắng lợi. Nếu thoát ra giữa chừng sẽ bị trừ Điểm Thi Đấu",
FLOP_CARD_DISCOUNT = "Ưu Đãi Lật Thẻ",

GAME_ACTIVITY_FLOWER_LIST ="Hoạt Động BXH Hoa Tươi",
FLOWER_LIST_RULE =
[[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0">Quy Tắc BXH Hoa Tươi</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0">Xếp hạng Đại Sứ GunPow được tính thông qua số lượng Hoa Quyến Rũ mà người chơi nhận được</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0">Hoa Quyến Rũ nhận từ sự kiện</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0">Người chơi tặng Hoa Quyến Rũ cho người chơi khác thông qua tính năng Tặng Hoa trong Trang Cá Nhân</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0">Sau khi sự kiện kết thúc, top 5 người chơi (tính riêng nam và nữ) sẽ nhận được  tư cách tham gia trình diễn và ứng xử tại hoạt động offline GunPow để giành giải thưởng đặc biệt, đồng thời sẽ nhận được phần thưởng từ xếp hạng</T><BR>10</BR>
]],
FREE_FLOWERS_WITHOUT_LIMIT ="Không giới hạn số lần tặng hoa",
NUMBER_OF_FLOWERS_RECEIVED = "Nhận Hoa",

RESOURCE_LOADING_TEXT = "Đang giải nén",
ACTIVITY_BACK_TEXT1 = "Đăng Nhập Trở Về",
ACTIVITY_BACK_TEXT2 = "Nạp Trở Về",
ACTIVITY_BACK_TEXT3 = "Chiến Đấu Trở Về",
ACTIVITY_BACK_TEXT4 = "Đăng nhập đủ %d ngày",
ROOM_TEXT1 = "Chưa có nửa kia",
SHOP_NEWCOIN = "Xu Điểm Danh",
SHOP_5_RULE4 = 
[[
<T C="229,105,22" S="22">1.</T><T C="127,70,26" S="18">Xu Điểm Danh có thể rút được bằng Kim Cương Khóa tại giao diện Kho Báu trong Cửa Hàng.</T><BR></BR>
<T C="229,105,22" S="22">1.</T><T C="127,70,26" S="18">Xu Điểm Danh dùng đổi vật phẩm tương ứng trong Cửa Hàng.</T><BR></BR>
]],

PRACTICE_TEXT1 = "Mời Song Tu",
PRACTICE_TEXT2 = "Hôm nay đã dùng: ",
PRACTICE_TEXT3 = "Trả %d %s để mở Ô Song Tu? Sau khi mở, hai bên sẽ dùng chung điểm thể lực, chuyển thành Điểm Tu Luyện cho mỗi bên.",
PRACTICE_TEXT4 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >Hôm nay đã dùng: </T><I Z ="0.45">ui/common/common_icon_hylqhltb.png</I><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >%d</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >  Nhận: </T><I P="1">ui/common/common_icon_xl.png</I><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >%d</T>]],
PRACTICE_TEXT5 = "Rời trạng thái Song Tu? Sau khi rời, %d giờ sau mới được mời bạn Song Tu mới.",
PRACTICE_TEXT6 = "Đã mở Song Tu, hãy mời nửa kia cùng Song Tu ngay nào!",
PRACTICE_TEXT7 = "Đã hủy Song Tu",
PRACTICE_TEXT8 = [[<T C="127,70,26" S="20" P="1">Đã xin Song Tu</T>]],
PRACTICE_TEXT9 = "Đã từ chối Song Tu",
PRACTICE_TEXT10 = "Có thể bắt đầu Song Tu",
PRACTICE_TEXT11 = "Đã gửi yêu cầu Song Tu",
PRACTICE_TEXT12 = "Đã gửi yêu cầu, hãy chờ phản hồi.",
PRACTICE_TEXT13 = "Đã có người rồi",
PRACTICE_TEXT14 = "Sau khi rời trạng thái Song Tu, %02d giờ %02d phút sau mới được mở lại",

GAMEACTIVITY_CUMULATIVELOGIN2 ="Tích lũy đăng nhập",
GAME_ACTIVITY_TYPE_3037 = "Hoàn Trả Kim Cương x3",
GAME_ACTIVITY_TYPE_3049 = "Giảm Giá Thẻ Tuần",
GAME_ACTIVITY_TYPE_3050 = "Giảm Giá Thẻ Tháng",   
TOPGOLD_TEXT1 = "%d ngày %d giờ",
TOPGOLD_TEXT2 = "%d giờ %d phút",
TOPGOLD_TEXT3 = [[<T C="229,105,22" S="22" P="0">Trả </T><I Z="0.5" P="0">%s</I><T C="127,70,26" S="24" P="0"> để tăng tốc %d giờ %d phút?</T>]],TOPGOLD_TEXT4 = "Tăng tốc thành công",
PET_FETTER1 = "Duyên Nợ",
PET_FETTER2 = "Pet Chính đạt Lv%d mới kích hoạt thuộc tính Duyên Nợ\nThuộc tính sẽ được tăng trực tiếp lên Pet Chính",
PET_FETTER3 = 
[[
<T C="127,70,26" S="20" P="0">Pet mang Duyên Nợ cần đạt</T>
<T C="229,105,22" S="20" P="0">Lv%d - %d Sao</T>
]],
PET_FETTER4 = "Pet không có Duyên Nợ với Pet khác",
PET_FETTER5 = "Pet Tím trở lên sẽ có tính năng Duyên Nợ",
PET_FETTER6 = "Bạn chưa có Pet",
PET_FETTER7 = "Năng Động Hôm Nay",
PET_FETTER8 = "Duyên Nợ Pet",
PET_FETTER9 = 
[[
<T C="127,70,26" S="20" P="0">Pet mang Duyên Nợ cần đạt</T>
<T C="229,105,22" S="20" P="0">Lv%d - %d Sao - Tăng bậc +%d</T>
]],
PVP_HALL_42 = "Đấu Cân Bằng",
PVP_HALL_43 = "Tuyệt Đối Công Bằng",
PVP_HALL_44 = 
[[
<T C="229,105,22" S="22">Quy tắc Đấu Cân Bằng</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Người chơi tham gia Đấu Cân Bằng sẽ có thuộc tính ngang nhau, không chênh lệch</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Người chơi tham gia Đấu Cân Bằng không Pet, không Ảo Hóa, không Thức Tỉnh</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Trong Đấu Cân Bằng, hiệu quả khắc chế giữa các hệ vẫn có hiệu lực</T><BR>10</BR>
]],
PVP_CARD_TIME_TITLE = "BUFF Điểm Dũng Sĩ",
PVP_CARD_ADD_PREC = "10 lần đầu Đấu Xếp Hạng mỗi ngày, Điểm Dũng Sĩ tăng %d%%",

TOWER_DESC_HERO = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Chỉ khi không ngừng khiêu chiến kẻ mạnh, bản thân mới trở nên mạnh hơn, cuối cùng đạt đến đỉnh cao.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Không giới hạn lượt khiêu chiến. Thất bại sẽ trở về trạng thái trước khi khiêu chiến, thành công sẽ giữ nguyên nộ khí và sinh lực hiện tại. Khi thành công, nếu sinh lực dưới 1% tính là 1%, mỗi lần khiêu chiến sẽ tạo mới đạo cụ kỹ năng.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Thưởng chưa nhận sẽ được gửi qua thư.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Quy tắc tạo mới nút: Không giới hạn số lần, tạo mới sẽ giảm một mức độ khó tầng hiện tại, mỗi lần cần tốn Kim Cương nhất định.</T><BR>20</BR>
]],
TOWER_HERO_TEXT1 = "Chịu ảnh hưởng Tháp Anh Hùng",
TOWER_HERO_TEXT2 = "Tạo mới lần này tốn: %d Kim Cương Khóa",
TOWER_HERO_TEXT3 = "Khiêu chiến ải hiện tại",
TOWER_HERO_TEXT4 = "Sinh lực còn lại",
THREE_YEAR_TEXT1 = "Hướng dẫn hoạt động",
THREE_YEAR_TEXT2 = "Đến ngay",
THREE_YEAR_TEXT3 = "Xu Kỷ Niệm",
GAMEACTIVITY_MARK_COIN = "Hoạt Động Xu Kỷ Niệm",
THREE_YEAR_TEXT4 = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Quy tắc hoạt động Xu Kỷ Niệm</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Mọi người đều có thể tham gia hoạt động Xu Kỷ Niệm, hoàn thành nhiệm vụ có thể nhận nhiều phần thưởng.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Phần thưởng đặc biệt dành cho người mua Xu Kỷ Niệm. Nếu chưa mua Xu Kỷ Niệm, sẽ chỉ được nhận thưởng thường.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Người đạt điều kiện hãy nhận thưởng kịp thời! Hoạt động kết thúc sẽ không thể nhận nữa!</T><BR>20</BR>
]],
THREE_YEAR_TEXT5 = "Phần thưởng kỷ niệm trong nhiệm vụ giới hạn, cần mua Xu Kỷ Niệm để kích hoạt.",
THREE_YEAR_TEXT6 = "Mua ngay",

WAKEUP_TEXT47 = 
[[
<T C="229,105,22" S="22">Thức Tỉnh-Tiến Hóa</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành "Bậc 4-Kỹ Năng" và đạt Lv40 sẽ mở tính năng Thức Tỉnh-Tiến Hóa.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Dùng Đá Thức Tỉnh mở "Bậc 5-Tiến Hóa", có thể tăng cấp tối đa, tăng thêm nhiều thuộc tính.</T><BR></BR>
]],

WAKEUP_TEXT49 = "Tiến hóa",
WAKEUP_TEXT50 = "Đã tiến hóa",
WAKEUP_TEXT51 = {"Cần hoàn thành CS1 ","Cần hoàn thành CS2","Cần hoàn thành CS3","Cần hoàn thành CS4"},
WAKEUP_TEXT52 = "Tiến hóa thành công",
WAKEUP_TEXT53 = "Tăng ngay lực chiến",
SPACE110 = "Chỉ cho bạn bè nhắn tin",
GAMEACTIVITY_TOW_PACKAGE = "Hai gói quà",
LIMIT_EQUIP_ATT = "Thiết bị này đã bị cấm đăng nhập, nếu có thắc mắc, hãy liên hệ CSKH.",

CHARM_LIFT1 = "Đã báo danh",
CHARM_LIFT2 = "BXH Thích (Tuần)",
CHARM_LIFT3 = "BXH Thích (Tổng)",
CHARM_LIFT4 = "Thời Trang Hấp Dẫn",
CHARM_LIFT5 = "Mỗi ngày chỉ có thể chọn thích mỗi người 1 lần.",
CHARM_LIFT6 = "Đã hết lượt chọn thích, mai hãy quay lại nhé!",
CHARM_LIFT7 = "Đã chọn thích, nhận %d điểm Nổi Tiếng",
CHARM_LIFT8 = "Thích",
CHARM_LIFT9 = "Thích: ",
CHARM_LIFT10 = "Đã báo danh thành công, xin đợi.",
CHARM_LIFT11 = "Phải mặc Thời Trang trên người mới được báo danh!",
CHARM_LIFT12 = "Dùng thời trang này để báo danh tham gia? (Báo danh thành công sẽ không thể thay đổi Thời Trang)",
CHARM_LIFT13 = "Đang đề cử, xin vui lòng chờ.",
CHARM_LIFT14 = "BXH Các Kỳ",
CHARM_LIFT15 = "Kỳ %d",
CHARM_LIFT16 = "Đang đề cử",
CHARM_LIFT17 = "Báo danh thành công",
CHARM_LIFT18 = "Báo danh thất bại",
CHARM_LIFT19 = "Đã đề cử",
CHARM_LIFT20 = [[<T C="127,70,26" S="20" P="1">Dùng </T><T C="127,70,26" S="20" P="1">%d</T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1"> để đề cử? Duy trì %d giờ</T>]],
CHARM_LIFT21 = "Chưa tìm được Quán Quân",
CHARM_LIFT22 = "Chưa báo danh, cần báo danh mới được đề cử",
CHARM_LIFT23 = " điểm, phát thưởng theo BXH Thích",
CHARM_LIFT24 = "24 giờ chủ nhật hàng tuần tạo mới (Được thích > %d được vào BXH)",
CHARM_LIFT25 = "Được thích > %d được vào BXH",
CHARM_LIFT26 = "Được thích",
CHARM_LIFT27 = "Được thích tuần này: ",
CHARM_LIFT28 = "Được thích tổng cộng: ",
CHARM_LIFT29 = "Không thể tự chọn thích bản thân",
CHARM_LIFT30 = "Ảo Hóa không thể tham gia thi đấu",
CHARM_LIFT31 = "Chưa có số liệu đề cử, hãy báo danh tham gia nhé!",

CHARM_LIFT32 =
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Chọn Thích người khác sẽ nhận được thưởng Nổi Tiếng.</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Người chơi Upload Ảnh trong trang cá nhân được đề cử nhiều hơn.</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Người chơi hôm qua điểm năng động cao được đều cử nhiều hơn.</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Người chơi Upload Voice trong trang cá nhân được đề cử nhiều hơn.</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Phần thưởng thi đấu được gửi qua thư.</T><BR></BR>
]],

RELIC_TEXT_1 = "Ánh Sáng Di Tích",
RELIC_TEXT_2 = "Chưa có khiêu chiến",
RELIC_TEXT_3 = "Có thể nhận",
RELIC_TEXT_4 = [[<T C="255,227,116" S="18" P="0">Thời gian còn: </T><T C="255,236,193" S="18" P="0">%02d:%02d</T>]],
RELIC_TEXT_5 = "Khiêu chiến thành công",
RELIC_TEXT_6 = "Khiêu chiến thất bại",
RELIC_TEXT_7 = "Thời gian còn",
RELIC_TEXT_8 = "Tỉ lệ",
RELIC_TEXT_9 = "%02d:%02d:%02d sẽ hồi phục 1 lần",
RELIC_TEXT_10 = "Khiêu Chiến Di Tích",
RELIC_TEXT_11 = "Phát hiện",
RELIC_TEXT_12 = "Mời Thám Hiểm,Nhấp để vào.",
RELIC_TEXT_13 = "Tích lũy sát thương",
RELIC_TEXT_14 = "Hiện không có lượt trợ giúp, hãy quay lại sau.",
RELIC_TEXT_15 = "%s khiêu chiến thành công! Mọi người hãy cùng cố gắng!",
RELIC_TEXT_16 = "Khiêu chiến đã kết thúc",
RELIC_TEXT_17 = "Chia sẻ thất bại",

RELIC_TEXT_18 = {
[[<T C="127,70,26" S="20" P="0">Dùng hết sức đập vỡ phiến đá trước mặt, nhìn thấy </T><T C="229,105,22" S="20" P="0">[%s]</T>]],
[[<T C="127,70,26" S="20" P="0">Càng đào sâu, càng cảm nhận được sức mạnh bí ẩn, ngẩng đầu thấy ngay </T><T C="229,105,22" S="20" P="0">[%s]</T>]],
},

GEM_MOUNTING_1 = "Ô Chính",
GEM_MOUNTING_2 = "Ô Phụ",
GEM_MOUNTING_3 = "Chọn",
GEM_MOUNTING_4 = "EXP sẽ dôi ra %d, vẫn tiếp tục?",
GEM_MOUNTING_5 = "Ghép thành công",
GEM_MOUNTING_6 = "Ghép thất bại",
GEM_MOUNTING_7 = "Tăng bậc thành công",
GEM_MOUNTING_8 = "Tăng bậc thất bại",
GEM_MOUNTING_9 = "Gộp thành công",
GEM_MOUNTING_10 = "Gộp thất bại",
GEM_MOUNTING_11 = " (Có %d)",
RELIC_TEXT_19 = "Người phát hiện",
GUILD_STORES_BUY_LIMIT = "Vật phẩm trong Tiệm Công Hội có giới hạn lượt mua mỗi ngày",
PHANTOM32 = "Biến hình sẽ mất ngoại hình Pet hiện tại, tiếp tục không?",
PHANTOM33 = "Khôi phục sẽ mất ngoại hình Pet hiện tại, tiếp tục không?",
GEM_MOUNTING_12 = "Có Đá Lv7 trở lên, hoặc có Đá Ma Lực, tiếp tục không?",
OPENCHEST2 = "Mỗi ngày được mua %d lần (Còn: %d)",
GEM_MOUNTING_13 = "Ghép nhận EXP: %d",
GEM_MOUNTING_14 = "Đã đạt cấp tối đa của giai đoạn này",
GEM_MOUNTING_15 = "Chọn đạo cụ lên cấp:",

BATTLE_HELP_TEXT1 = "Tình hình trợ chiến",
BATTLE_HELP_TEXT2 = "Lượt Treo Thưởng: ",
BATTLE_HELP_TEXT3 = "Lượt trợ chiến: ",
BATTLE_HELP_TEXT4 = "Có thể trợ chiến",
BATTLE_HELP_TEXT5 = "Đang trợ chiến",
BATTLE_HELP_TEXT6 = "Mở trợ chiến",
BATTLE_HELP_TEXT7 = "Chiến đấu nhận số lần trợ chiến",

CHAT_REPORT_TEXT1 = "Đã tố cáo",
CHAT_REPORT_TEXT2 = "Chọn lý do tố cáo",
CHAT_REPORT_TEXT3 = "Bạn đang tố cáo“%s”",
CHAT_REPORT_TEXT4 = {"Đăng tin quấy rối ","Ngôn từ xúc phạm","Quảng cáo","Nội dung xấu","Khác"},
CHAT_REPORT_TEXT5 = "Nhập nội dung vào đây. Sau khi xác thực, sự việc sẽ được xử lý.",
CHAT_REPORT_TEXT6 = "Tố cáo",
CHAT_REPORT_TEXT7 = "Chọn lý do tố cáo",
CHAT_REPORT_TEXT8 = {"Số lần tố cáo đạt tối đa", "Tố cáo trong thời gian chờ", "Nội dung tố cáo đang bỏ trống", "Nội dung tố cáo vượt quá giới hạn", "Lỗi khác"},
LevelAndNameFormat2 = [[<T S="22" C="127,70,26" P="0">Lv</T><T S="22" C="229,105,22" P="0">%d</T><BL>10</BL><T S="22" C="127,70,26" P="0">%s</T>]],
KID_HOME_TEXT1 = "Xác nhận mua và dùng %s",
YOU_TO_KUAFU = [[<T C="105,65,46" S="22">Đang </T>]],

CHECKOTHER_NEWTEXT1 = "Gần đây",
CHECKOTHER_NEWTEXT2 = "Chế giễu sẽ nhận ngẫu nhiên: Kim Cương Đỏ, Vàng, EXP, Thể Lực, v.v",
CHECKOTHER_NEWTEXT3 = "Đừng chế giễu bản thân!",
CHECKOTHER_NEWTEXT4 = "Ai tặng hoa cho bản thân vậy?",
CHECKOTHER_NEWTEXT5 = "Đang chiến đấu, không thể vào thăm",
CHECKOTHER_NEWTEXT6 = "Phòng này không thể vào",

PROFESSION_TEXT1 = "Hãy chọn hệ bạn muốn",
PROFESSION_TEXT2 = {"Chiến Sĩ","Sát Thủ","Phù Thủy"},
PROFESSION_TEXT3 = {"Chống đỡ chuyên nghiệp,gây thêm sát thương cho Sát Thủ","Sát thương bộc phát,gây sát thương thêm cho Phù Thủy","Khống chế giới hạn,gây sát thương thêm cho Chiến Sĩ"},
PROFESSION_TEXT4 = "Xác nhận",
PROFESSION_TEXT5 = "Hãy chọn 1 hệ",
PROFESSION_TEXT6 = "Xác nhận chuyển hệ thành %s? (Chuyển hệ thành công sẽ vào mục Thiên Phú)",
PROFESSION_TEXT7 = "Hãy hoàn thành tất cả nhiệm vụ cần thiết!",
PROFESSION_TEXT8 = "Hệ",
PROFESSION_TEXT9 = [[
<T C="229,105,22" S="22" P="1">Quy tắc CS1</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Không cần làm nhiệm vụ lần nữa</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Lần đầu chuyển hệ sẽ trả lại tất cả Học Thức, những lần sau đó chỉ trả 90%, Thiên Phú được tạo mới sẽ trả lại toàn bộ</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Chỉ được chọn 1 loại kỹ năng hệ để cường hóa</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Sau khi cường hóa kỹ năng hệ, cần vào mục đạo cụ kỹ năng để nâng cấp</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Hiệu quả khắc chế giữa các hệ chỉ hiệu lực trong chiến đấu</T><BR>20</BR>
<T C="229,105,22" S="22" P="1">Quy tắc CS2</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Đạt Lv35 và kích hoạt toàn bộ Thiên Phú CS1, sẽ mở CS2</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Tăng cấp Thiên Phú CS2 cần tốn Học Thức-Cao</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Học Thức-Cao nhận được từ tầng cao ở Ảo Cảnh Không Gian, chưa đạt Lv35 sẽ không thể nhận</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Bản thân Pha Lê Năng Lượng không có hiệu quả, khi tổ hợp 2 Pha Lê, có thể kích hoạt kỹ năng mới</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Tăng cấp Pha Lê Năng Lượng sẽ giúp tăng cấp kỹ năng tổ hợp</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0">Có thể xem kỹ năng tổ hợp của Pha Lê trong Thư Viện. Chú ý: Thứ tự của Pha Lê sẽ ảnh hưởng đến kỹ năng được kích hoạt</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0">Có thể chọn chuyển đổi Pha Lê, sau khi chuyển cấp Pha Lê không thay đổi, chỉ đổi kỹ năng tổ hợp</T><BR>10</BR>
]],
PROFESSION_TEXT10 = "Chưa hoàn thành chuyển hệ, hãy quay lại sau.",
PROFESSION_TEXT11 = "Kỹ Năng Hệ",
PROFESSION_TEXT12 = "Cấp Kế",
PROFESSION_TEXT13 = "Chọn hệ muốn xem",
PROFESSION_TEXT14 = "Lên cấp tốn",
PROFESSION_TEXT15 = "Đã đạt cấp tối đa",
PROFESSION_TEXT16 = "Chuyển Hệ",
PROFESSION_TEXT18 = "Hiện không cần tạo mới Thiên Phú",
PROFESSION_TEXT20 = "Chỉ được chọn 1 Thiên Phú để cường hóa, xác nhận chọn tuyến Thiên Phú (%s)?",
PROFESSION_TEXT21 = "Cần kích hoạt kỹ năng tiền đề",
PROFESSION_TEXT22 = "Cần tăng kỹ năng tiền đề đến cấp tối đa",
PROFESSION_TEXT24 = "Mở Hệ",
PROFESSION_TEXT25 = {"Khắc Chế", "Bị địch"},

DOUBLETOWER_TEXT1 = "Ảo Cảnh Không Gian",
DOUBLETOWER_TEXT2 = "Điều kiện vượt ải hoàn mỹ",
DOUBLETOWER_TEXT3 = "Mỗi lần vượt ải nhận",
DOUBLETOWER_TEXT4 = "Chiến",
DOUBLETOWER_TEXT5 =  [[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0">Quy tắc Ảo Cảnh Không Gian</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0">Mỗi ngày có 3 cơ hội khiêu chiến.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0">Ngày 1 hằng tháng sẽ tạo mới tiến độ và trạng thái vượt ải, đồng thời phát thưởng theo hạng.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0">0 giờ mỗi ngày sẽ quay về tầng thứ 1.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0">Sau khi vượt ải hoàn mỹ sẽ có thể càn quét</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0">Điều kiện vượt ải tính chung cho cả đội, hãy phối hợp thật ăn ý!</T><BR>10</BR>
]],
DOUBLETOWER_TEXT6 = {"Sinh lực còn lại > %d%%", "Số lần chủ phòng ra tay < %d", "Sát thương trong 1 lần > %d", "Xác suất chính xác = %d%%", "Số lần dùng đạo cụ < %d", "Không dùng %s", "Số người tử vong = %d", "Dùng %s diệt quái", "Diệt cùng lúc %d quái", "Tốc độ gió luôn ≥ %d", "Dùng kỹ năng của con để diệt quái"},
DOUBLETOWER_TEXT7 = "Vượt ải hoàn mỹ được nhận",
DOUBLETOWER_TEXT8 = [[<T C="127,70,26" S="20" P="0">Ngày 1 hàng tháng </T> <T C="255,89,74" S="20" P="0"> %s </T><T C="127,70,26" S="20" P="0"> sẽ phát thưởng theo hạng Ảo Cảnh Không Gian</T>]],
DOUBLETOWER_TEXT9 = "Lượt trợ chiến: ",
DOUBLETOWER_TEXT10 = "%s mời bạn cùng khiêu chiến\nẢo Cảnh Không Gian %s",
DOUBLETOWER_TEXT11 = [[<T C="127,70,26" S="20" P="1">Bạn đã dùng hết lượt khiêu chiến, dùng %d </T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1"> mua 1 lượt?</T>]],
DOUBLETOWER_TEXT12 = "Đang đợi đồng đội sẵn sàng",
DOUBLETOWER_TEXT13 = "Sau khi sẵn sằng, chủ phòng được mở khiêu chiến",
DOUBLETOWER_TEXT14 = "Sau khi vượt ải hoàn mỹ tầng này mới được càn quét",
DOUBLETOWER_TEXT15 = "Số lần trợ chiến không đủ",
DOUBLETOWER_TEXT16 = "Số lần khiêu chiến không đủ",
DOUBLETOWER_TEXT17 = "Đã vượt hết",
DOUBLETOWER_TEXT18 = "Trợ chiến thành công được nhận",
DOUBLETOWER_TEXT19 = "Trợ chiến thất bại được nhận",
DOUBLETOWER_TEXT20 = "Hôm nay đã hết lượt mua",
DOUBLETOWER_TEXT21 = "Số lần mua hôm nay đã đạt tối đa, hãy Tăng cấp VIP để Tăng số lần mua!",
PROFESSION_TEXT26 = [[<T C="127,70,26" S="24" P="0">Từ bỏ chuyển hệ lần này? (Lần này miễn phí)</T><BR>10</BR><T C="127,70,26" S="24" P="0">, hoàn trả %d%% Học Thức</T>]],
PROFESSION_TEXT17 = [[<T C="127,70,26" S="24" P="0">Từ bỏ hệ hiện tại?</T><BR>10</BR><T C="127,70,26" S="24" P="0">Tốn %d</T><I Z="0.5" P="0">%s</I><T C="127,70,26" S="24" P="0">, hoàn trả %d%% Học Thức</T>]],
PROFESSION_TEXT23 = [[<T C="127,70,26" S="24" P="0">Xác nhận tạo mới Thiên Phú? (Lần này miễn phí)</T><BR>10</BR><T C="127,70,26" S="24" P="0">, hoàn trả %d%% Học Thức</T>]],
PROFESSION_TEXT19 = [[<T C="127,70,26" S="24" P="0">Tạo mới Thiên Phú ngay?</T><BR>10</BR><T C="127,70,26" S="24" P="0">Tốn %d</T><I Z="0.5" P="0">%s</I><T C="127,70,26" S="24" P="0">, hoàn trả %d%% Học Thức</T>]],

PETSHOWTIP7 = 
[[
<T C="255,227,116" S="22" P="0">Tăng bậc</T>
<T C="99,255,95" S="22" P="0">+7</T>
<T C="255,227,116" S="22" P="0">: </T>
<T C="255,236,193" S="22" P="0">Mở khóa Pet</T>
<T C="99,255,95" S="22" P="0">Kỹ năng 5</T>
<T C="255,236,193" S="22" P="0">, tăng </T>
<T C="99,255,95" S="22" P="0">120%</T>
<T C="255,236,193" S="22" P="0"> tất cả thuộc tính</T>
]],

PET_FETTER9 = "Pet mang Duyên Nợ cần đạt Lv%d %d Sao, tăng bậc +%d",

ANSWER_TEXT1 = "Trả lời",
ANSWER_TEXT2 = "Hoàn thành %d câu hỏi",
ANSWER_TEXT3 = "Tiêu đề khảo sát",
ANSWER_TEXT4 = "Nộp bài khảo sát ngay? Thưởng sẽ được gửi qua thư.",
ANSWER_TEXT5 = "Còn câu chưa trả lời kìa, vội làm gì!",
ANSWER_TEXT6 = "Thời gian khảo sát: ",
ANSWER_TEXT7 = "Thời gian khảo sát đã kết thúc, lần sau nhớ đến sớm nhé!",
ANSWER_TEXT8 = "Đã nộp xong, thương sẽ được gửi qua thư.",
ANSWER_TEXT9 = " (Chọn 1)",
ANSWER_TEXT10 = " (Chọn nhiều)",

CHECKOTHER_TEXT20 = "Đã thăm nhau %d ngày",
CHECKOTHER_TEXT21 = "Tặng %d đóa hoa",

PETSKILL_TEXT1 = "Chuyển",
PETSKILL_TEXT2 = "Chuyển Pet",
PETSKILL_TEXT3 = 
[[
<T C="229,105,22" S="20" P="1">Quy tắc chuyển Pet: </T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Sau khi chuyển Pet sẽ hoán đổi kỹ năng Pet</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Nếu số kỹ năng của Pet Chính nhiều hơn Pet Chuyển, chỉ chuyển được X kỹ năng đầu tiên, mất các kỹ năng khác. Các kỹ năng còn lại của Pet Chính sẽ được tạo mới ngẫu nhiên.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Nếu số kỹ năng của Pet Chính ít hơn Pet Chuyển, sẽ không thể chuyển.</T><BR></BR>
]],
PETSKILL_TEXT4 = "Pet Chuyển không thể tăng bậc cao hơn Pet Chính",
PETSKILL_TEXT5 = [[<T C="127,70,26" S="20" P="1">Ô kỹ năng của Pet Chuyển không đủ để trang bị cho Pet Chính, sẽ chỉ chuyển </T><T C="99,255,95" S="20" P="1">%d</T><T C="127,70,26" S="20" P="1"> kỹ năng đầu tiên, các kỹ năng khác sẽ bị mất, tiếp tục?</T>]],
PETSKILL_TEXT6 = "Kỹ năng đã được chuyển",
PETSKILL_TEXT7 = "Kỹ năng Pet Chính sẽ được chuyển hết cho Pet Chuyển, tiếp tục?",

PETSKILL5 = "Kỹ năng 5",
PETSKILLDESC5 = "Pet tăng bậc đến +7 sẽ mở khóa ô kỹ năng này",
ROOM_SETTING1 = "Số người thi đấu",
ROOM_SETTING2 = "Dạng: ",
ROOM2 = "Phòng: ",
ENTERTAINMENT_MATCH_6 = "Đấu Cân Bằng",
BATTLE_AUTOFIGHT_OPEN = "Đã mở tự chiến đấu",
BATTLE_AUTOFIGHT_CLOSE = "Đã đóng tự chiến đấu",
BATTLE_AUTOFIGHT_ATT = "Đang tự chiến đấu, không thể thao tác",
PVP_HALL_45 = "Dạng Mạo Hiểm",
PVP_HALL_46 = "Truy Sát",
ADVENTURE_COIN_LIMIT = "Xu Mạo Hiểm nhận hôm nay:",
AMUSE_DAY_OPEN = "%d ngày sau",
TABOO_TEXT1 = "Từ bỏ",
TABOO_TEXT2 = "Thủ công",
TABOO_TEXT3 = "Còn điều kiện chưa đạt, không thể càn quét",
CHARMSPACE_TEXT2 = "BXH Chế Giễu Tuần",
CHARMSPACE_TEXT3 = "BXH Chế Giễu",
CHARMSPACE_TEXT4 = "giờ, phát thưởng trong hạng Chế Giễu",
CHARMSPACE_TEXT5 = "Chế Giễu",
CHARMSPACE_TEXT6 = "Tạo mới lúc 24 giờ mỗi ngày (Chế Giễu > %d mới vào BXH)",
CHARMSPACE_TEXT7 = "Chế Giễu > %d mới vào BXH",
CHARMSPACE_TEXT8 = "Chế Giễu tuần này:",
CHARMSPACE_TEXT9 = "Tổng lượt Chế Giễu:",
CHARMSPACE_TEXT10 = [[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Đề cử ngẫu nhiên chỉ đề cử người chơi đăng kèm ảnh</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Hình upload lên trang cá nhân càng nhiều, càng có cơ hội được đề cử</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Chế Giễu trong tuần càng nhiều, xác suất đề cử càng cao</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Online sẽ tăng xác suất đề cử</T><BR></BR>
]],
TASK_NEWTEXT1 = "Đã hoàn thành hết nhiệm vụ hôm nay",
CHARMSPACE_TEXT1 = "Sức Hút",
CHARMSPACE_TEXT11 = "Cuộc Đời\nHấp Dẫn",
LOGIN_LIMIT = "Hãy đến trung tâm hỗ trợ để chuyển đổi",

COUPLE_FIGHTING_TOGETHER = "Hạng chiến đấu của cặp đôi kết hôn liên server hiển thị trong server của bên nam.",

HEROTOWER_TITLE = "Thử Thách Anh Hùng",
PVP_COIN_LIMIT = "Xu Xếp Hạng đã nhận hôm nay: ",
FLOWER_CHOOSE_TYPE = "Chọn kiểu Tặng Hoa",
PHOTO_TITLE = "Hình",
WELFARECARD_VIP_TIP = "Nhân vật Lv%s mở tính năng này, đạt VIP%s hoặc mở Thẻ Phúc Lợi có thể mở khóa trước, đồng ý nạp?",
WELFARECARD_VIP_TEXT1 = "(VIP3 hoặc có Thẻ Phúc Lợi có thể dùng Ghép Nhanh)",
TURNCARD_VIP_NEWTIPS = "VIP5 hoặc có Thẻ Phúc Lợi sẽ đươc Lật Thẻ",
BACKGROUND_ONLYFOR_VIP = "Dành cho VIP%d",
BACKGROUND_VIP_TEXT1 = "Hình nền dành cho VIP%d, tăng VIP ngay?",
BACKGROUND_VIP_TEXT2 = "Hình nền dành cho Thẻ Phúc Lợi, mua ngay?",
BACKGROUND_VIP_TEXT3 = "Dành cho Thẻ Phúc Lợi",
BACKGROUND_VIP_TEXT4 = "Tăng",
BACKGROUND_VIP_TEXT5 = "Khung chat dành cho Thẻ Phúc Lợi, mua ngay?",
BACKGROUND_VIP_TEXT6 = "Thẻ Phúc Lợi hoặc VIP5",
TOWER_RANK_HISTORY = "Liên server",
MAGIC_STONE_TEXT1 = "Chiến Lệnh",
MAGIC_STONE_TEXT2 = "Nâng Cấp Có Quà",
MAGIC_STONE_TEXT3 = "Kích hoạt được nhận thưởng",
MAGIC_STONE_TEXT4 = "Thưởng Thẻ Nâng Cấp (Chiến Lệnh đạt Lv80 được nhận toàn bộ)",
MAGIC_STONE_TEXT5 =  [[<T C="255,232,182" S="22" P="1" SC="164,73,33" SS="4" SE="1">Mở khóa Nâng Cấp Có Quà, kích hoạt phần thưởng dành riêng, </T><T C="255,255,255" S="22" P="1" SC="164,73,33" SS="4" SE="1">tăng ngay đến Lv20</T>]],
MAGIC_STONE_TEXT6 = "Mua Cấp",
MAGIC_STONE_TEXT7 = "Cấp Chiến Lệnh",
MAGIC_STONE_TEXT8 = "Mua %d cấp, tăng đến Lv%d",
MAGIC_STONE_TEXT9 = "Tăng bậc Chiến Lệnh",
MAGIC_STONE_TEXT10 = "Thưởng tăng bậc",
MAGIC_STONE_TEXT11 = "Điểm Chiến Lệnh tuần này nhận được: ",
MAGIC_STONE_TEXT12 = "Điểm Chiến Lệnh tuần này nhận được đã đạt tối đa",
MAGIC_STONE_TEXT13 = "Thời gian tạo mới",
MAGIC_STONE_TEXT14 = "Xem trước Lv%d",
MAGIC_STONE_TEXT15 = "Chiến Lệnh Lv%d mở",
MAGIC_STONE_TEXT16 = "Mỗi ngày được mua %d lần (Còn lại %d)",
MAGIC_STONE_TEXT17 = "Được mua %d lần (Còn lại %d)",
MAGIC_STONE_TEXT18 = "Không có phần thưởng có thể nhận",
MAGIC_STONE_TEXT19 = [[
<T C="213,105,76" S="22">Cấp và Nhiệm Vụ Chiến Lệnh</T><BR></BR>
<T C="145,77,44" S="20">1.</T><T C="145,77,44" S="20">Hoàn thành Nhiệm Vụ Chiến Lệnh có thể tăng Cấp Chiến Lệnh</T><BR>10</BR>
<T C="145,77,44" S="20">1.</T><T C="145,77,44" S="20">Nạp Kim Cương Lam được nhận thêm Điểm Chiến Lệnh, mỗi nạp 6 VND có thể nhận 100 Điểm.</T><BR>10</BR>
<T C="145,77,44" S="20">2.</T><T C="145,77,44" S="20">Chiến Lệnh mỗi tăng 1 cấp, đều nhận được nhiều thưởng</T><BR>10</BR>
<T C="145,77,44" S="20">3.</T><T C="145,77,44" S="20">Nhiệm Vụ Chiến Lệnh có thể hoàn thành nhiều lần, có số lần hoàn thành tối đa</T><BR>10</BR>
<T C="145,77,44" S="20">3.</T><T C="145,77,44" S="20">Nhiệm Vụ Chiến Lệnh sau khi hoàn thành sẽ tự động nhận thưởng.</T><BR>10</BR>
<T C="145,77,44" S="20">4.</T><T C="145,77,44" S="20">Điểm nhiệm vụ tuần này đạt tối đa, sẽ không thể tiếp tục hoàn thành nhiệm vụ, kiến nghị lựa chọn kỹ</T><BR>10</BR>
<T C="145,77,44" S="20">5.</T><T C="145,77,44" S="20">Nhiệm Vụ Chiến Lệnh sẽ tái lập định kỳ, nhiệm vụ cũ sẽ bị xóa và tạo mới nhiệm vụ, hãy hoàn thành nhiệm vụ kịp thời</T><BR>10</BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="213,105,76" S="22">Tăng bậc Chiến Lệnh</T><BR></BR>
<T C="145,77,44" S="20">1.</T><T C="145,77,44" S="20">Chiến Lệnh có thể tăng bậc và nhận thưởng, đồng thời mở khóa thưởng tăng bậc</T><BR>10</BR>
<T C="145,77,44" S="20">2.</T><T C="145,77,44" S="20">Thưởng tăng bậc cần tăng Cấp Chiến Lệnh mới có thể nhận</T><BR>10</BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="213,105,76" S="22">Tái lập Chiến Lệnh</T><BR></BR>
<T C="145,77,44" S="20">1.</T><T C="145,77,44" S="20">Hệ thống Chiến Lệnh sẽ tái lập định kỳ, khi tái lập hãy xem giao diện góc trái dưới</T><BR>10</BR>
<T C="145,77,44" S="20">2.</T><T C="145,77,44" S="20">Tái lập Chiến Lệnh sẽ tái lập Cấp Chiến Lệnh, trạng thái tăng bậc, Ký Hiệu Chiến Lệnh, hãy nhận và đổi thưởng kịp thời</T><BR>10</BR>
]],
MAGIC_STONE_TEXT20 = "(Đã đạt: %d/%d)",
MAGIC_STONE_TEXT21 = "Chưa có ",
MAGIC_STONE_TEXT22 = "Hiện còn độc thân, hãy kết hôn trước", 
MAGIC_STONE_TEXT23 = "Mùa Giải đã kết thúc ", 
MAGIC_STONE_TEXT24 = "Thời gian kết thúc", 
SINGLECOPY_TEXT14 = "Thời gian bảo vệ: ", 
SINGLECOPY_TEXT15 = "Lãnh địa chưa có Lãnh Chúa, vượt phó bản thành công sẽ trở thành Lãnh Chúa ", 
SINGLECOPY_TEXT16 = "Hiện bạn đang là Lãnh Chúa rồi", 
SINGLECOPY_TEXT17 = "Lãnh Chúa đang trong thời gian bảo vệ khiêu chiến ", 
SINGLECOPY_TEXT18 = "Đã chiếm 3 lãnh địa rồi, khiêu chiến thành công sẽ thay vào lãnh địa có độ khó thấp nhất, đồng ý không?", 
SINGLECOPY_TEXT19 = "Đã chiếm 3 lãnh địa có độ khó cao hơn, nếu khiêu chiến thành công sẽ thay vào lãnh địa có độ khó thấp nhất và chiếm sớm nhất, đồng ý không?", 
SINGLECOPY_TEXT20 = "Khiêu chiến Lãnh Chúa ", 
ROOMINVITE_TEXT1 = "Có thể mời người chơi %s tham gia Đấu Hạng",
GAMEACTIVITY_SHOP_LOTTERY = "Rút Thưởng Cửa Hàng",
GOTO_SHOP_LOTTERY = "Rút thưởng",
GOTO_SHOP_LOTTERY2 = "Thưởng đặc biệt",
LUCKY_NAME = "Điểm may mắn: ",
LUCKY_GIFT_TIMES = "Rút %d lần nữa được tặng thêm",
LUCKY_GIFT_UPDATE = " sau sẽ thay đổi phần thưởng",
LUCKY_GIFT_TIMES2 = [[<T C="79,60,48" S="20" P="1" >Rút </T><T C="128,54,13" S="20" P="1" >%d</T><T C="79,60,48" S="20" P="1" > lần nữa được tặng thêm</T>]],
LUCKY_GIFT_TIMES3 = "Đã nhận hết thưởng tuần này",
LUCKY_GIFT_TIMES4 = "Còn phần thưởng chưa nhận",
LUCKY_GIFT_TIMES5 = "Tạo mới thứ hai hàng tuần",
SHOP_EXCHANGE_TIME = " sau ngưng bán",
SHOP_GOODS_TIMEOUT = "Vật phẩm đã ngưng bán",
GAMEACTIVITY_RECHARGELEVEL3 = "Sự Kiện Ngày Lễ",

HEROTOWER_TEXT1 = "Tháp Anh Hùng",
HEROTOWER_TEXT2 = "Tạo mới",
HEROTOWER_TEXT3 = "HP: ",
HEROTOWER_TEXT4 = "Nộ: ",
HEROTOWER_TEXT5 = "Đã vượt hết",
HEROTOWER_TEXT6 = "Tạo mới sẽ đổi thành đối thủ có lực chiến thấp hơn (Không dưới mức sàn của tầng này), cần tốn %d %s, tiếp tục không?",
HEROTOWER_TEXT7 = "Tái lập sẽ hồi phục HP đến 100%%, hồi đầy nộ khí. Tái lập lần này cần tốn %s, đồng ý không?",
HEROTOWER_TEXT8 = "Hôm nay đã hết lượt tái lập",
HEROTOWER_TEXT9 = "Càn quét Tháp Anh Hùng",
HEROTOWER_TEXT10 = "HP còn 0, không thể chiến đấu tiếp, mai hãy quay lại nhé!",
HEROTOWER_TEXT11 = "HP còn 0, không thể chiến đấu tiếp, hãy chọn [Tái lập]",
HEROTOWER_TEXT12 = "Khiêu chiến ải hiện tại",
HEROTOWER_TEXT13 = "Sinh lực còn lại",
HEROTOWER_TEXT14 = "Cần khiêu chiến %s",
HEROTOWER_TEXT15 = "Đã khiêu chiến ải này rồi",
HEROTOWER_TEXT16 = "Đã hết lượt tạo mới",
HEROTOWER_TEXT17 = 
[[
<T C="213,105,76" S="22">Hướng dẫn Tháp Anh Hùng</T><BR></BR>
<T C="145,77,44" S="20">1.</T><T C="145,77,44" S="20"> Mỗi tầng Tháp Anh Hùng đều có người chơi trấn thủ. Hãy đánh bại tất cả, chứng minh thực lực bản thân!</T><BR>10</BR>
<T C="145,77,44" S="20">2.</T><T C="145,77,44" S="20"> Khiêu chiến mỗi tầng thành công sẽ giữ nguyên mức HP hiện có, khi HP còn 0 sẽ không thể tiếp tục khiêu chiến.</T><BR>10</BR>
<T C="145,77,44" S="20">3.</T><T C="145,77,44" S="20"> Tái lập sẽ hồi đầy 100% HP và 100% Nộ Khí, mỗi ngày 1 lần.</T><BR>10</BR>
<T C="145,77,44" S="20">4.</T><T C="145,77,44" S="20"> Tạo mới sẽ đổi thành đối thủ có lực chiến thấp hơn, nhưng không dưới mức sàn của tầng này.</T><BR>10</BR>
<T C="145,77,44" S="20">5.</T><T C="145,77,44" S="20"> Số lượt tạo mới đối thủ có giới hạn, nâng cấp VIP để tăng số lần.</T><BR>10</BR>
<T C="145,77,44" S="20">6.</T><T C="145,77,44" S="20"> Lần đầu mở giao diện Tháp Anh Hùng trong ngày, hệ thống sẽ tự càn quét số tầng đã vượt trong ngày trước đó. Tự càn quét không ảnh hưởng đến mức thưởng được nhận.</T><BR>10</BR>
]],
SETTING_TASK = "Ô nhiệm vụ nhanh",
HURT_ADD_PERCENT = "Tăng sát thương: ",
PVP_HISTORY = "Cấp bậc cao nhất",
CHAT_LIMIT = "Vượt Phó Bản Nhóm %s (%s) hoặc đạt VIP%d sẽ mở chat riêng với người lạ",
CHAT_TOO_MUCH = "Chat riêng quá thường xuyên",
HAVED_IN_ROOM = "Đã ở trong phòng này rồi",
BUY_SPACEPHOTO_SEAT = "Mua vị trí",
BUY_SPACEPHOTO_SEAT_COST = [[<T C="127,70,26" S="20" P="1">Dùng %d </T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1"> để mở vị trí mới?</T>]],
BUY_SPACEPHOTO_SEAT_OK = "Mua thành công",
BUY_SPACEPHOTO_SEAT_FAIL = "Mua thất bại",
WEDDING_END_REQUEST_NOPAY = "Bạn đời rời mạng hơn %d giờ, có thể ly hôn miễn phí. Sau khi ly hôn, Lễ Phục Kết Hôn sẽ biến mất. Xác nhận giải trừ mối quan hệ hôn nhân này?",
MASTER_OUT = "Xuất sư",
MASTER_CAN_SHOUTU = "Xuất sư xong mới được nhận đệ tử",
HAVED_BUY_TIMES = "Tích lũy mua thưởng: ",
GAMEACTIVITY_INVESTREBATE = "Hoàn Trả\nĐầu Tư",
MASTER_LEVEL_OUT1 = "Đã đạt điều kiện xuất sư, có thể xuất sư rồi",
MASTER_LEVEL_OUT2 = "Đệ tử này đã đạt điều kiện xuất sư, có thể xuất sư rồi",
MASTER_LEVEL_OUT3 = [[<T C="151,64,19" S="20">Xác nhận giải trừ quan hệ sư đồ với %s? </T><BR></BR><T C="134,113,92" S="20">%s</T>]],
FRAMEACTIVITY_TEXT1 = [[
<T C="213,105,76" S="22">Hoàn Trả Đầu Tư</T><BR></BR>
<T C="145,77,44" S="20">1.</T><T C="145,77,44" S="20"> Trong hoạt động, có thể mua Quà Hoàn Trả các loại. Quà đã mua sau khi nhận thưởng xong có thể mua tiếp.</T><BR>10</BR>
<T C="145,77,44" S="20">2.</T><T C="145,77,44" S="20"> Nhận Quà Hoàn Trả từ giao diện hoạt động khi đăng nhập mỗi ngày</T><BR>10</BR>
<T C="145,77,44" S="20">3.</T><T C="145,77,44" S="20"> Tích lũy mua đủ số lần yêu cầu sẽ được nhận thưởng thêm!</T><BR>10</BR>
<T C="145,77,44" S="20">4.</T><T C="145,77,44" S="20"> Hãy nhanh chóng nhận thưởng hoàn trả và thưởng mua tích lũy đã kích hoạt. Khi hoạt động kết thúc số liệu sẽ bị xóa hết, không thể nhận nữa.</T><BR>10</BR>
<T C="145,77,44" S="20">5.</T><T C="145,77,44" S="20"> Không thể mua quà có thời hạn hoàn trả ngắn hơn thời gian hoạt động còn lại</T><BR>10</BR>
]],
CASTSOUL_TEXT1 = [[
<T C="213,105,76" S="22">Quy tắc Đúc Hồn Thời Trang</T><BR></BR>
<T C="145,77,44" S="20">1.</T><T C="145,77,44" S="20"> Sưu tập Thời Trang/Cánh/Danh Hiệu đạt mức yêu cầu sẽ mở khóa Ô Hồn</T><BR>10</BR>
<T C="145,77,44" S="20">2.</T><T C="145,77,44" S="20"> Tại Ô Hồn có thể khảm Hồn để nhận hiệu quả thuộc tính tương ứng</T><BR>10</BR>
<T C="145,77,44" S="20">3.</T><T C="145,77,44" S="20"> Nếu Thời Trang/Cánh/Danh Hiệu quá hạn mà chưa sưu tập đủ số cần thiết để mở Ô Phách, sẽ mất hiệu quả tương ứng</T><BR>10</BR>
<T C="145,77,44" S="20">4.</T><T C="145,77,44" S="20"> Thời Trang đủ bộ phải gồm Đầu, Mặt, Thân. Cánh/Danh Hiệu chỉ cần có một bộ phận đứng riêng là tính đã có bộ</T><BR>10</BR>
<T C="145,77,44" S="20">5.</T><T C="145,77,44" S="20"> Trong danh sách Thời Trang/Cánh/Danh Hiệu chỉ hiện thị loại đã có và đang bán trong Cửa Hàng, không hiển thị các loại bán trong hoạt động</T><BR>10</BR>
<T C="145,77,44" S="20">6.</T><T C="145,77,44" S="20"> Thời Trang sẽ sưu tập đủ bộ sẽ được hiển thị trong danh sách, những món lẻ chưa thành bộ sẽ không hiển thị</T><BR>10</BR>
<T C="145,77,44" S="20">7.</T><T C="145,77,44" S="20"> Thời Trang/Cánh/Danh Hiệu nhận lặp lại sẽ không tính thêm số lượng</T><BR>10</BR>
]],
CASTSOUL_TEXT2 = "Hồn Thời Trang",
CASTSOUL_TEXT3 = "Đã sưu tập",
CASTSOUL_TEXT4 = "Bộ %d",
CASTSOUL_TEXT5 = "Mở khóa Bộ %d",
CASTSOUL_TEXT6 = "Chưa sưu tập",
CASTSOUL_TEXT7 = "Ô Hồn",
CASTSOUL_TEXT8 = {"Thủ","Thể","Công"},
CASTSOUL_TEXT9 = "Sưu tập %d bộ Thời Trang để mở khóa Ô Hồn, hiện đã sưu tập %d bộ",
CASTSOUL_TEXT10 = "Sưu tập %d bộ Cánh để mở khóa Ô Hồn, hiện đã sưu tập %d bộ",
CASTSOUL_TEXT11 = "Chọn Hồn",
CASTSOUL_TEXT12 = "Đúc Hồn",
CASTSOUL_TEXT13 = "Nhận Hồn",
CASTSOUL_TEXT14 = "Hoàn trả liên tục %d ngày",
FOURYEAR_TEXT1 = "Mua Chung",
FOURYEAR_TEXT2 = "Hôm nay đã mua: ",
FOURYEAR_TEXT3 = [[
<T C="213,105,76" S="22">Mua Chung</T><BR></BR>
<T C="145,77,44" S="20">1.</T><T C="145,77,44" S="20"> Mua Chung đến rồi! Mỗi ngày hùn nhau hốt hàng siêu lợi!</T><BR>10</BR>
<T C="145,77,44" S="20">2.</T><T C="145,77,44" S="20"> Mỗi loại quà mỗi ngày được mua 1 lần</T><BR>10</BR>
<T C="145,77,44" S="20">3.</T><T C="145,77,44" S="20"> Mỗi ngày sẽ bày bán loại quà mới</T><BR>10</BR>
]],
FOURYEAR_TEXT4 = [[
<T C="213,105,76" S="22">Số quà đã mua hôm nay</T><BR></BR>
<T C="145,77,44" S="20"></T><T C="145,77,44" S="20"> Mỗi ngày mua 1 món quà bất kỳ, khi cả server tích đủ số người mua quà sẽ được nhận thưởng! Số người mua quà mỗi ngày càng nhiều, thưởng càng hấp dẫn!</T><BR>10</BR>
]],
FOURYEAR_TEXT5 = "%d người",
FOURYEAR_TEXT6 = "Lắc Thưởng",
FOURYEAR_TEXT7 = "Kiểu bài:  ",
FOURYEAR_TEXT8 = "Chọn thưởng và bội số: ",
FOURYEAR_TEXT9 = "Bội số thưởng: ",
FOURYEAR_TEXT10 = [[
<T C="213,105,76" S="22">Chào mừng tham gia Lắc Thưởng! Bội số bạn chọn càng cao, phần thưởng nhận được càng lớn! Mau mời bạn bè cùng tham gia ngay nào!</T><BR></BR>
<T C="145,77,44" S="20">1.</T><T C="145,77,44" S="20"> Cần chọn bội số trước rồi mới bắt đầu rút thưởng!</T><BR>10</BR>
<T C="145,77,44" S="20">2.</T><T C="145,77,44" S="20"> Có thể đổi bài để có được kiểu bài mình muốn.</T><BR>10</BR>
<T C="145,77,44" S="20">3.</T><T C="145,77,44" S="20"> Lắc Thưởng có xác suất nhận tổng cộng 10 kiểu bài, bội số thưởng khác nhau</T><BR>10</BR>
<T C="145,77,44" S="20">4.</T><T C="145,77,44" S="20"> Kho Thưởng có bội số khác nhau, mức Kim Cương/Kim Cương Khóa cần để rút thưởng cũng khác nhau</T><BR>10</BR>
<T C="145,77,44" S="20">5.</T><T C="145,77,44" S="20"> Số liệu nhiệm vụ ngày sẽ xóa hết vào hôm sau. Tích lũy hoàn thành nhiệm vụ chỉ định sẽ được nhận thưởng. Trong hoạt động, mỗi nhiệm vụ chỉ được làm và nhận thưởng 1 lần. Khi hoạt động kết thúc, tất cả số liệu sẽ bị xóa hết, do đó xong nhiệm vụ nhớ nhận thưởng kịp thời!</T><BR>10</BR>
<T C="213,105,76" S="20">6. Hướng dẫn kiểu bài và bội số thưởng</T><BR></BR>
<T C="145,77,44" S="20"></T><T C="145,77,44" S="20"> 
[High Card]: Thưởng x1, bài lẻ</T><BR></BR><T C="145,77,44" S="20">
[Pair]: Thưởng x2, 2 lá giống nhau</T><BR></BR><T C="145,77,44" S="20">
[Two Pair]: Thưởng x3, hai cặp bài</T><BR></BR><T C="145,77,44" S="20">
[Three of a kind]: Thưởng x4, 3 lá giống nhau</T><BR></BR><T C="145,77,44" S="20">
[Straight]: Thưởng x6, 5 lá liền nhau</T><BR></BR><T C="145,77,44" S="20">
[Flush]: Thưởng x10, 5 lá cùng chất</T><BR></BR><T C="145,77,44" S="20">
[Full House]: Thưởng x15, 3 lá giống + 1 cặp</T><BR></BR><T C="145,77,44" S="20">
[Four of a kind]: Thưởng x20, 4 lá giống nhau</T><BR></BR><T C="145,77,44" S="20">
[Straight Flush]: Thưởng x30, 5 lá liền cùng chất</T><BR></BR><T C="145,77,44" S="20">
[Royal Flush]: Thưởng x40, 10, J, Q, K, A cùng chất</T><BR>10</BR>
]],
FOURYEAR_TEXT11 = " x%d",
FOURYEAR_TEXT12 = "Chọn phần thưởng",
FOURYEAR_TEXT13 = {"High Card","Pair","Two Pair","Three of a kind","Straight","Flush","Full House","Four of a kind","Straight Flush","Royal Flush"},
FOURYEAR_TEXT14 = "Đã dùng hết lượt tạo mới",
FOURYEAR_TEXT15 = "Mỗi ngày",
FOURYEAR_TEXT16 = "Trưởng thành",
FOURYEAR_TEXT17 = "Nhiệm Vụ Lắc Thưởng",
FOURYEAR_TEXT18 = "Hãy nhận thưởng lần này",
FOURYEAR_TEXT19 = "Quà Siêu Hời",
FOURYEAR_TEXT20 = [[<T C="127,70,26" S="20" P="1" SC="128,54,13" SS="4" SE="0">Đổi bài lần này cần tốn </T><T C="99,255,95" S="20" P="1" SC="0,72,3" SS="4" SE="1">%d</T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1" SC="128,54,13" SS="4" SE="0"> (Đã dùng %d/%d lần)</T>]],
FOURYEAR_TEXT21 = "Nhận thưởng “%s”, bội số x%d",
CASTSOUL_TEXT15 = "Thuộc tính Đúc Hồn Thời Trang",
CASTSOUL_TEXT16 = "Thời Trang đã có: ",
CASTSOUL_TEXT17 = "Cánh đã có: ",
CASTSOUL_TEXT18 = "Thuộc tính Đúc Hồn Cánh",
CASTSOUL_TEXT19 = [[<T C="255,227,116" S="20" P="1" SC="128,54,13" SS="4" SE="1">Tăng đến Lv%d %s: </T><T C="99,255,95" S="20" P="1" SC="0,72,3" SS="4" SE="1">%d</T>]],
CASTSOUL_TEXT20 = "Hồn Cánh",
GAME_ACTIVITY_TITLE50 = "Nhiệm Vụ Trở Về",
GAME_ACTIVITY_TITLE51 = "Nhiệm Vụ Trở Về (Ngày)",
GAME_ACTIVITY_TITLE52 = "Thương Nhân Trở Về",
GAME_ACTIVITY_TITLE53 = "Thiệp Mời Trở Về",
GAME_ACTIVITY_TITLE54 = "Giới Thiệu Trở Về",
GAME_ACTIVITY_TITLE55 = "Buff Trở Về",
GAME_ACTIVITY_TITLE56 = "Mời bạn cũ",
PROGRESS_TEXT = "Tiến độ",
RETURNEE_TEXT1 = "Điểm Trở Về",
RETURNEE_TEXT2 = "Điền Code Trở Về để nhận thưởng",
RETURNEE_TEXT3 = "Thương Nhân Trở Về",
RETURNEE_TEXT4 = "Kết Hôn Sinh Con",
RETURNEE_TEXT5 = "Sư Đồ Liên Server",
RETURNEE_TEXT6 = "Hệ Dành Riêng",
RETURNEE_TEXT7 = "Đấu Hạng Công Bằng",
RETURNEE_TEXT8 = "Lãnh Chúa Tranh Bá",
RETURNEE_TEXT9 = "Giờ có thể kết hôn liên server rồi!",
RETURNEE_TEXT10 = "Có thể bái sư nhận đệ liên server luôn!",
RETURNEE_TEXT11 = "Kỹ năng hệ mạnh hơn!",
RETURNEE_TEXT12 = "Thẳng tiến đỉnh cao!",
RETURNEE_TEXT13 = "Lãnh Chúa bắt đầu quẩy!",
RETURNEE_TEXT14 = "Buff Đặc Quyền Trở Về: ",
RETURNEE_TEXT15 = "Tăng Điểm Dũng Sĩ",
RETURNEE_TEXT16 = "Buff Tăng Cường",
RETURNEE_TEXT17 = " (Mỗi ngày được tăng 1 lần)",
RETURNEE_TEXT18 = "Thưởng mời bạn quay về",
RETURNEE_TEXT19 = "Bạn bè trở về nạp đạt yêu cầu được hoàn trả",
RETURNEE_TEXT20 = "Mời thành công",
RETURNEE_TEXT21 = "Mời thất bại",
RETURNEE_TEXT22 = "Tăng Điểm Dũng Sĩ",
RETURNEE_TEXT23 = "Bạn Cũ Trở Về",
RETURNEE_TEXT24 = "Cấp chưa đạt",
RETURNEE_TEXT25 = "Số lượng không đủ",
RETURNEE_TEXT26 = "Mời %s người được nhận",
RETURNEE_TEXT27 = "Mời %s người có nạp được nhận",
RETURNEE_TEXT28 = "Nhận thất bại",
RETURNEE_TEXT29 = "code Trở Về: ",
RETURNEE_TEXT30 = "Tăng Điểm Dũng Sĩ Trở Về %s%%",
RETURNEE_TEXT31 = "Tăng Điểm Thi Đấu Trở Về %s%%",
TO_YOU = [[<T C="229,105,22" S="22">%s </T><T C="127,70,26" S="22" P="1"> </T>]],
YOU_TO = [[<T C="127,70,26" S="22">Bạn tặng quà cho </T><T C="229,105,22" S="22"> %s</T>]],
VIGOR_ADD_FRIENDLINESS = [[<T C="105,65,46" S="20" P="1">tặng bạn </T><T C="229,105,22" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> điểm thể lực, hai bên tăng </T><T C="229,105,22" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> điểm thân mật.</T>]],
GIFT_ADD_FRIENDLINESS = [[<T C="105,65,46" S="20" P="1">, hai bên tăng </T><T C="229,105,22" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> điểm thân mật</T>]],
ADD_FRIENDLINESS = [[<T C="105,65,46" S="24" P="1">tăng </T><T C="229,105,22" S="24" P="1"> %d</T><T C="105,65,46" S="24" P="1">điểm thân mật</T>]],
WITH_YOU = [[<T C="127,70,26" S="22">%s </T><T C="105,65,46" S="22" P="1"> và bạn </T>]],
FRIENDLINESS = "Thân mật: ",
NEWSKILL5 = "Hướng dẫn cấp kế",
CLEAR_RESULT = "Càn quét nhanh", 
CELAR_RESULT_TEXT1 = "Chưa vượt ải, không thể càn quét",
CELAR_RESULT_TEXT2 = "Đã hết lượt khiêu chiến, dùng %d Kim Cương Khóa tái lập tất cả ải?",
CELAR_RESULT_TEXT3 = "Đã dùng hết lượt tái lập hôm nay",

DISCOUNT_END_COUNTDOWN = "Kết thúc giảm giá: ",
CHECKOTHER_MOUNT = "Hiển thị thú cưỡi",
DISCOUNT_END_COUNTDOWN = "Kết thúc giảm giá: ",
CHECKOTHER_MOUNT = "Hiển thị thú cưỡi",
PVP_HALL_COMMUNITY = "Vinh dự tập thể, trận chính vinh quang",
TODAY_GET = "Hôm nay nhận: ",
TIME_OF_THE_SEASON = "Mùa giải này: ",
PVP_HALL_1V1 = "Ta đấu với ta",
PVP_HALL_2V2 = "Phối hợp nhịp nhàng",
PVP_HALL_3V3 = "Vinh dự tập thể",
COMMUNITY_TEXT1 = "Vật Tổ",
COMMUNITY_TEXT2 = "Trường Kỹ Năng",
COMMUNITY_TEXT3 = "Xếp hạng Công Hội",
TOUCH_COME_IN = "Nhấp chọn để vào",
NEWSEAT_OPENCOST = [[<T C="127,70,26" S="20" P="1" SC="128,54,13" SS="4" SE="0">Dùng </T><T C="99,255,95" S="20" P="1" SC="0,72,3" SS="4" SE="1">%d</T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1" SC="128,54,13" SS="4" SE="0"> mở khóa ô phương án %d?</T>]],
SKILLSUIT_ATT = "Không thể đổi tên phương án mặc định",
SKILLSUIT_TAIL = "Phương án",
TITLE_SUBJECT = "Câu hỏi",
TITLE_SUBJECT_TYPE = {"Thấp","Vừa","Cao"},
TITLE_ANSWER_TEXT2 = "Lv%d sẽ mở khóa câu hỏi Lv%s",
TITLE_ANSWER_TEXT3 = "Hãy trả lời câu hỏi trên trước",
RANK_CARD_TIP = "Số lần giữ sao trong Đấu Hạng +%d",
COMMUNITY_TEXT4 = "Giữ sao còn: %d lần",
COMMUNITY_TEXT5 = "Kích hoạt Thẻ Giữ Sao, không bị giảm sao",
ACTIVITY_TEXT_DESC_1 = [[
<T C="249,236,208" S="18" P="1" SC="128,54,13" SS="4" SE="1">Nạp </T>
<T C="255,227,116" S="18" P="1" SC="128,54,13" SS="4" SE="1">50 Kim Cương</T>
<T C="249,236,208" S="18" P="1" SC="128,54,13" SS="4" SE="1">, được rút thưởng </T>
<T C="255,227,116" S="18" P="1" SC="128,54,13" SS="4" SE="1">thú cưỡi vĩnh viễn</T>
]],
ACTIVITY_TEXT_DESC_2 = "Nạp ngay",
GAME_ACTIVITY_TITLE57 = "Nạp Thẻ May Mắn",
ACTIVITY_TEXT_DESC_3 = "Nạp 50 kim cương, có cơ hội nhận thưởng lớn",
ACTIVITY_TEXT_DESC_4 = "Thưởng lớn kỳ này: %s",
ACTIVITY_TEXT_DESC_5 = "Số người tham dự: ",
ACTIVITY_TEXT_DESC_6 = "Tham gia rút thưởng",
ACTIVITY_TEXT_DESC_7 = "Chưa có mã may mắn có thể nhận",
ACTIVITY_TEXT_DESC_8 = "(Còn %s phần chưa nhận, mỗi kỳ tối đa 100)",
ACTIVITY_TEXT_DESC_9 = "Mã may mắn",
ACTIVITY_TEXT_DESC_10 =
[[
<T C="255,89,74" S="18" P="1" SC="128,54,13" SS="4" SE="1">%s</T>
<T C="249,236,208" S="18" P="1" SC="128,54,13" SS="4" SE="1">Đã nhận </T>
<T C="255,89,74" S="18" P="1" SC="128,54,13" SS="4" SE="1">%s mã may mắn</T>
]],
ACTIVITY_TEXT_DESC_11 = "Kỳ ",

ACTIVITY_TEXT_DESC_12 =
[[
<T C="145,77,44" S="20">1. </T><T C="128,54,13" S="20">Nạp đủ 50 Kim Cương, được nhận 1 mã may mắn</T><BR>10</BR>
<T C="145,77,44" S="20">2. </T><T C="128,54,13" S="20">Mỗi kỳ phát mã may mắn đến số lượng nhất định, hệ thống sẽ rút ngẫu nhiên 1 mã may mắn trúng thưởng lớn</T><BR>10</BR>
<T C="145,77,44" S="20">3. </T><T C="128,54,13" S="20">Xác suất trúng thưởng của mỗi mã may mắn là như nhau, vì vậy càng nhiều mã thì cơ hội trúng thưởng càng lớn</T><BR>10</BR>
]],
ACTIVITY_TEXT_DESC_13 = [[<T C="128,54,13" S="20">Rất tiếc, bạn chưa trúng thưởng kỳ này, hãy thử lại nhé!</T>]],
ACTIVITY_TEXT_DESC_14 = [[<T C="128,54,13" S="20">Chúc mừng bạn trúng thưởng kỳ này! Hãy vào [Thư] xem thông tin chi tiết!</T>]],
ACTIVITY_TEXT_DESC_15 = "Quy tắc hoạt động",
ACTIVITY_TEXT_DESC_16 = "Nhắc nhở mở thưởng",
ACTIVITY_TEXT_DESC_17 = "Chưa đạt điều kiện mở thưởng",
ACTIVITY_TEXT_DESC_18 = "Mã may mắn đang có",
ACTIVITY_TEXT_DESC_19 = "Mã may mắn kỳ này",
ACTIVITY_TEXT_DESC_20 = "Xem lại kỳ trước",

ACTIVITY_TEXT_DESC_21 = "Thời gian mở thưởng",
ACTIVITY_TEXT_DESC_22 = "Người trúng thưởng",
ACTIVITY_TEXT_DESC_23 = "Nhắc: Sau khi kích hoạt Thẻ Kế Hoạch, cuối tuần được nhận thưởng 2 ngày. Nếu chưa online để nhận, phần thưởng sẽ bị xóa.",
ACTIVITY_TEXT_DESC_24 = "69000 VND kích hoạt",
ACTIVITY_TEXT_DESC_25 = "Thẻ Kế Hoạch Tuần",
INITIAL = "Ban đầu: ",
ACTIVITY_TEXT_DESC_27 = "Thẻ Kế Hoạch",
ACTIVITY_TEXT_DESC_28 = 
[[
<T C="128,54,13" S="20">Đã kích hoạt "Thẻ Kế Hoạch Tuần",</T><BR>10</BR>
<T C="128,54,13" S="20">Cuối tuần nhớ đến nhận thưởng nhé!</T><BR>10</BR>
]],
ACTIVITY_TEXT_DESC_29 = "Kỳ này đã nhận %s mã may mắn",
ACTIVITY_TEXT_DESC_30 = "Cuối tuần được nhận thưởng 2 ngày",
ACTIVITY_TEXT_DESC_31 = "Mỗi thứ hai dùng, kích hoạt Thẻ Kế Hoạch Tuần",
FRIEND_APPLY = [[<T C="127,70,26" S="20" P="1"> đã yêu cầu kết bạn.</T>]],
FRIENDCIRCLE_TEXT1 = "Đăng tâm trạng",
FRIENDCIRCLE_TEXT2 = "Tâm Trạng",
FRIENDCIRCLE_TEXT3 = "Người bấm like",
FRIENDCIRCLE_TEXT4 = "Người này chưa đăng tâm trạng",
FRIENDCIRCLE_TEXT5 = "Tâm trạng của %s",
FRIENDCIRCLE_TEXT6 = "Bạn Bè",
FRIENDCIRCLE_TEXT7 = "Tâm Trạng Nổi Bật",
FRIENDCIRCLE_TEXT8 = {"Kích động", "Lừa đảo", "Hack", "Quảng cáo", "Game lậu", "Khác"},
FRIENDCIRCLE_TEXT9 = "Chọn ít nhất 1 lý do",
FRIENDCIRCLE_TEXT10 = "Đăng",
FRIENDCIRCLE_TEXT11 = "Chưa đăng tâm trạng, hãy đăng 1 dòng đi nào!",
FRIENDCIRCLE_TEXT12 = "Chưa có nội dung!",
FRIENDCIRCLE_TEXT13 = "Nội dung trống, không thể đăng lên",
FRIENDCIRCLE_TEXT14 = "Không phải bạn bè, không thể bình luận",
FRIENDCIRCLE_TEXT15 = "Bình Luận",
FRIENDCIRCLE_TEXT16 = "Đăng tâm trạng thành công",
FRIENDCIRCLE_TEXT17 = "Bình luận không thể để trống",
FRIENDCIRCLE_TEXT18 = "Xóa tâm trạng thành công",
FRIENDCIRCLE_TEXT19 = "Xóa bình luận thành công",
FRIENDCIRCLE_TEXT20 = "Thiết lập tâm trạng thành công",
FRIENDCIRCLE_TEXT21 = "Bỏ like thành công",
FRIENDCIRCLE_TEXT22 = "Xác nhận xóa dòng tâm trạng này?",
FRIENDCIRCLE_TEXT23 = "Số dòng tâm trạng đạt tối đa",
FRIENDCIRCLE_TEXT24 = "Tâm trạng đã bị xóa",
FRIENDCIRCLE_TEXT25 = "Không phải bạn bè, không thể bình luận",
FRIENDCIRCLE_TEXT26 = "Trả Lời",
FRIENDCIRCLE_TEXT27 = "Số chữ vượt mức giới hạn",
FRIENDCIRCLE_TEXT28 = "Tâm trạng đã bị xóa",
FRIENDCIRCLE_TEXT29 = "Bình luận đã bị xóa",
FRIENDCIRCLE_TEXT30 = "Còn %d tin chưa đọc",
FRIENDCIRCLE_TEXT31 = "Xác nhận xóa bình luận này?",
FRIENDCIRCLE_TEXT32 = "Nhấp chọn để nhập bình luận",
FRIENDCIRCLE_TEXT33 = "Bấm like thành công",
FRIENDCIRCLE_TEXT34 = "Bình luận thành công",
FRIENDCIRCLE_TEXT35 = "Đã là trang cuối cùng",
FRIENDCIRCLE_TEXT36 = "Đã là trang đầu tiên",
FRIENDCIRCLE_TEXT37 = "Bình luận thất bại",
FRIENDCIRCLE_TEXT38 = "Đã bị liệt vào Sổ Đen",
FRIENDCIRCLE_TEXT39 = "Tâm Trạng",
FRIENDCIRCLE_TEXT40 = "Tâm Trạng",
CLEAR_RESULT1 = "(Không thể càn quét)",
NEW_ACTIVITY_TEXT_1 = [[V%d x2]],
NEW_ACTIVITY_TEXT_2 = "Hôm nay đã mua:",
NEW_ACTIVITY_TEXT_3 = [[<T C="149,98,57" S="20" P="1" SE="0">Tích lũy điểm danh </T><BR></BR><T C="240,103,122" S="22" P="1" SC="240,103,122" SE="1" SS="1"> %s</T><T C="149,98,57" S="20" P="1" SE="0">  ngày</T>]],
NEW_ACTIVITY_TEXT_4 = [[<I Z="0.46">%s</I><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T>]],
NEW_ACTIVITY_TEXT_5 = "Rút %d lần",
NEW_ACTIVITY_TEXT_6 = [[<T C="127,70,26" S="22" P="1">Cường hóa</T><T C="229,105,22" S="22" P="1"> %d món</T><T C="127,70,26" S="22" P="1"> trang bị bất kỳ đến </T><T C="229,105,22" S="22" P="1"> +%d</T>]],
NEW_ACTIVITY_TEXT_7 = [[<T C="127,70,26" S="22" P="1">Hoàn thành nhiệm vụ nạp %d ngày (%d/%d)</T>]],
NEW_ACTIVITY_TEXT_8 = [[<T C="127,70,26" S="22" P="1">Nạp %s</T>]],
NEW_ACTIVITY_TEXT_9 = [[<T C="127,70,26" S="22" P="1">Nạp một lần </T><T C="229,105,22" S="22" P="1"> %s</T><T C="127,70,26" S="22" P="1">, ngày thứ %s được nhận</T>]],
NEW_ACTIVITY_TEXT_10 = "Thẻ Phúc Lợi",
PET_TEXT15 = "(Ảnh hưởng cấp sao)",
PET_TEXT16 = "Số Pet::",
PET_TEXT17 = "Tổng lực chiến tăng",
PET_TEXT18 = "Số thú cưỡi::",
PET_TEXT19 = "LC Vòng Sáng",
PET_TEXT20 = "Số Vòng Sáng:",

PHANTOM_NEWTEXT1="Luyện Hóa",
PHANTOM_NEWTEXT2="Chưa mở Skin này, hãy kích hoạt trước đã",
PHANTOM_NEWTEXT3="Đây là Skin dùng thử, không thể tăng phẩm chất",
PHANTOM_NEWTEXT4="Đã đạt phẩm chất cao nhất",
PHANTOM_NEWTEXT5="Skin đã đạt bậc cao nhất",
PHANTOM_NEWTEXT6="Skin đạt phẩm chất %s mới được tăng bậc",
PHANTOM_NEWTEXT7={"Lục","Lam","Tím","Cam","Đỏ"},
PHANTOM_NEWTEXT8="Thần Thoại",
PHANTOM_NEWTEXT9 = [[<T C="255,227,116" S="16" P="1">Dùng </T><I Z="0.5" P="1">%s</I><T C="255,227,116" S="16" P="1"> tỉ lệ thành công 100%%</T>]],
PHANTOM_NEWTEXT10="Kích hoạt luyện hóa",
PHANTOM_NEWTEXT11="Cấp người chơi càng cao, phẩm chất Skin càng cao, thuộc tính càng nhiều",
PHANTOM_NEWTEXT12="Chưa mở luyện hóa, hãy kích hoạt luyện hóa trước",
PHANTOM_NEWTEXT13 = [[<T C="255,236,193" S="16" P="1" SC="128,54,13" SS="4" SE="1">Luyện Hóa-KC </T><I Z="0.5" P="1">%s</I>]],
PHANTOM_NEWTEXT14 = {"Kích hoạt mở khóa", "Đạt Lam mở khóa", "Đạt Tím mở khóa", "Đạt Cam mở khóa", "Đạt Đỏ mở khóa", "Đạt Đỏ mở khóa"},
PHANTOM_NEWTEXT15="Kích hoạt mở khóa",
PHANTOM_NEWTEXT16="Chưa có ",
PHANTOM_NEWTEXT17="Trong tính năng Thánh Quang, có thể dùng cách Khế Ước để tăng phẩm chất và kích hoạt kỹ năng POW của Skin",
PHANTOM_NEWTEXT18="Kỹ Năng Ảo-Chủ",
PHANTOM_NEWTEXT19="Kỹ Năng Ảo-Bị",
PHANTOM_NEWTEXT20="Khế Ước",
PHANTOM_NEWTEXT21 = "Skin Cam Ảo Hóa đến %d sao, có thể dùng Khế Ước để tăng đến phẩm chất Đỏ (Chỉ một số được tăng đến phẩm chất Đỏ, chi tiết xem tại giao diện [Kỹ Năng Ảo-Chủ])",
PHANTOM_NEWTEXT22="Skin",
PHANTOM_NEWTEXT23="Trước Khế Ước",
PHANTOM_NEWTEXT24="Sau Khế Ước",
PHANTOM_NEWTEXT25="Ảo Hóa",
PHANTOM_NEWTEXT26="Chọn Skin cần Khế Ước",
PHANTOM_NEWTEXT27="Skin đã kích hoạt luyện hóa thành công, có thể bắt đầu luyện hóa",
PHANTOM_NEWTEXT28="Luyện hóa thành công",
PHANTOM_NEWTEXT29="Lưu kết quả luyện hóa",
PHANTOM_NEWTEXT30="Đã hủy kết quả lần trước",
PHANTOM_NEWTEXT31="Skin đã tăng bậc thành công",
PHANTOM_NEWTEXT32="Thuộc tính đều đã được khóa",
PHANTOM_NEWTEXT33="Thuộc tính Luyện Hóa đã đạt tối đa",
PHANTOM_NEWTEXT34="Tăng bậc thất bại",
PHANTOM_NEWTEXT35="Nhấp chọn thuộc tính muốn khóa để không luyện hóa nữa",


MULCOPY_TEXT1 = "Dạng Thức Tỉnh",
MULCOPY_TEXT2="Thức Tỉnh",
MULCOPY_TEXT3="Độ khó Thức Tỉnh",
MULCOPY_TEXT4="Mỗi ngày chỉ được khiêu chiến độ khó Thức Tỉnh 1 lần, hôm nay đã khiêu chiến rồi",
MULCOPY_TEXT5="(Skin đạt phẩm chất Đỏ sẽ kích hoạt)",
MULCOPY_TEXT6="Mỗi Skin được cộng dồn thuộc tính, khi sử dụng không ảnh hưởng đến thuộc tính đã tăng",
MULCOPY_TEXT7="Tổng thuộc tính Ảo Hóa tăng",
MULCOPY_TEXT8="Số Skin",
BOSSROOM_SWITCH_DIFFICULTY_TIPS4="Chưa qua được độ khó Địa Ngục, không thể khiêu chiến độ khó Thức Tỉnh",


GAME_ACTIVITY_CRAZY_DOUBLING="Nhận thưởng gấp bội",
CRAZY_DOUBLING_TEXT1=[[<T C="127,70,26" S="20">Hãy nhớ nhận thưởng nhiệm vụ, </T><BR></BR><T C="127,70,26" S="20">tiến độ nhiệm vụ sẽ tự động xóa trống vào hôm sau.</T><BR></BR>]],
CRAZY_DOUBLING_TEXT2="Điểm x2 hiện tại: ",
CRAZY_DOUBLING_TEXT3="x2",
CRAZY_DOUBLING_TEXT4="Giới hạn x2: ",
CRAZY_DOUBLING_TEXT5=[[<T C="128,54,13" S="20">Chúc mừng nhận được thưởng x%s</T>]],
CRAZY_DOUBLING_TEXT6="Tốn chút tiền để có cơ hội nhận thưởng gấp 18 lần! Sai khi nhận sẽ mất cơ hội x2! Có muốn nhận ngay không?",
CRAZY_DOUBLING_TEXT7="Thực hiện x2 trong giao diện này sẽ hoàn thành nhiệm vụ",
FRIEND_DELETE1="Chỉ hiện rời mạng 1 tháng",
FRIEND_DELETE2="Xóa bạn bè đã chọn?",
FRIEND_DELETE3="Chưa chọn bạn bè muốn xóa",
FRIEND_DELETE4="Không có bạn bè phù hợp",
FRIEND_DELETE5="Mỗi lần chỉ được chọn %d",
FRIEND_DELETE6="Hãy nhập ghi chú: ",
FRIEND_DELETE7="Hãy nhập ghi chú",
FRIEND_DELETE8="Ghi chú không được có khoảng trắng",
FRIEND_DELETE9="Ghi chú không thể vượt hơn %d ký tự",
FRIEND_DELETE10="Thêm ghi chú thành công",
FRIEND_DELETE11="Ghi chú không thể vượt hơn 8 ký tự",

BIGSKILL_TYPE={"POW Vũ khí","POW Skin"},


ASCENDINGEXPLAIN4 = 
[[
<T C="229,105,22" S="20" P="1">Khế Ước Skin</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">Khi Skin Cam tăng đến bậc 6, co1 thể dùng Khế Ước tăng lên phẩm chất Đỏ.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">Skin đạt phẩm chất Đỏ, ngoài tăng thuộc tính, còn mở kỹ năng POW đặc biệt.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="1">Có thể chọn kỹ năng POW Skin trong giao diện Kỹ Năng, trang [Kỹ Năng Ảo-Chủ].</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="1">Khi chiến đấu, Nộ Khí đầy sẽ có thể dùng kỹ năng POW Skin.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="1">Chỉ một số được tăng đến phẩm chất Đỏ, chi tiết xem tại giao diện [Kỹ Năng Ảo-Chủ]</T><BR></BR>
]],
CRAZY_DOUBLING_TEXT8="Nhận được ",
CRAZY_DOUBLING_TEXT9=[[
<T C="127,70,26" S="18">Hoàn thành nhiệm vụ chỉ định, tốn </T>
<T C="127,70,26" S="18">1 VND</T>
<T C="51,51,51" S="18"> để dùng</T>
<T C="127,70,26" S="18">"x2"</T>
<T C="51,51,51" S="18">Tối đa nhận hoàn trả đạo cụ gấp 18 lần</T>
]],

DOUBLE_SEVEN_TEXT1="Chọn Bạn Bè",
DOUBLE_SEVEN_TEXT2="Chọn Bạn Bè chuyển quan hệ thành Người Yêu",
DOUBLE_SEVEN_TEXT3="Nhiệm Vụ Tỏ Tình",
DOUBLE_SEVEN_TEXT4="BXH Yêu Thương",
DOUBLE_SEVEN_TEXT5="Thư Tỏ Tình",
DOUBLE_SEVEN_TEXT6="Tỏ Tình",
DOUBLE_SEVEN_TEXT7="Số lượng: ",
DOUBLE_SEVEN_TEXT8="Điểm Tỏ Tình của mình: ",
DOUBLE_SEVEN_TEXT9="Điểm Tỏ Tình của ấy: ",
DOUBLE_SEVEN_TEXT10="Nhận được quà",
DOUBLE_SEVEN_TEXT11="%s x%d, Điểm Tỏ Tình +%d",
DOUBLE_SEVEN_TEXT12="Người Yêu",
DOUBLE_SEVEN_TEXT13="Điểm Yêu Thương",
DOUBLE_SEVEN_TEXT14="Hạng: ",
DOUBLE_SEVEN_TEXT15="Điểm Tỏ Tình: ",
DOUBLE_SEVEN_TEXT16="Đạo Cụ Tỏ Tình",
DOUBLE_SEVEN_TEXT17={"Tặng \"Hoa Hồng Tỏ Tình\" để nhận Điểm Yêu Thương, tốn số Kim Cương tương ứng.","Tặng \"Bánh Tỏ Tình\" để nhận Điểm Yêu Thương, nhận từ Đấu Hạng/Đấu Trường","Tặng \"Nhẫn Tỏ Tình\" để nhận Điểm Yêu Thương, nhận từ hoạt động nạp"},
DOUBLE_SEVEN_TEXT18 = {
[[<T C="127,70,26" S="18" P="1">Hôm nay được người khác tỏ tình </T><T C="229,89,22" S="18" P="1">%d/%d</T><T C="127,70,26" S="18" P="1"> lần</T>]],
[[<T C="127,70,26" S="18" P="1">Hôm nay đã dùng </T><T C="229,89,22" S="18" P="1">%d/%d</T><T C="127,70,26" S="18" P="1"> Hoa Hồng Tỏ Tình</T>]],
[[<T C="127,70,26" S="18" P="1">Hôm nay đã dùng </T><T C="229,89,22" S="18" P="1">%d/%d</T><T C="127,70,26" S="18" P="1"> Nhẫn Tỏ Tình</T>]],
[[<T C="127,70,26" S="18" P="1">Hôm nay đã dùng </T><T C="229,89,22" S="18" P="1">%d/%d</T><T C="127,70,26" S="18" P="1"> Bánh Tỏ Tình</T>]],
[[<T C="127,70,26" S="18" P="1">Hôm nay đã Tỏ Tình với Người Yêu </T><T C="229,89,22" S="18" P="1">%d/%d</T><T C="127,70,26" S="18" P="1"> lần</T>]]
},
DOUBLE_SEVEN_TEXT19 = "Mời",
DOUBLE_SEVEN_TEXT20 = "Chọn",
DOUBLE_SEVEN_TEXT21 = "Thông Báo",
DOUBLE_SEVEN_TEXT22 = "Trong hoạt động,chỉ được Tỏ Tình với 1 người bạn! Sau khi xác định\nsẽ không thể hủy bỏ quan hệ,hãy suy nghĩ kỹ!",
DOUBLE_SEVEN_TEXT23 = "Phần mời bạn không thể để trống",
DOUBLE_SEVEN_TEXT24 = {"Valentine ngọt ngào, tỏ tình có nhau!","Chúc ấy Valentine vui vẻ!","Có người kề bên, ngày nào cũng là Valentine.","Luôn sẵn lòng trở thành những gì ấy thích nhất.","Valentine đến rồi, mình hẹn hò nhé?"},
DOUBLE_SEVEN_TEXT25 = [[<T C="127,70,26" S="24" P="1">Người chơi </T><T C="229,105,22" S="24" P="1">%s</T><T C="127,70,26" S="24" P="1"> đã từ chối lời mời của bạn</T>]],
DOUBLE_SEVEN_TEXT26 = "Đã xác định quan hệ Người Yêu",
DOUBLE_SEVEN_TEXT27 = "Nhân vật này chuyển giới rồi, game này phải là khác giới mới được làm Người Yêu nhé!",
DOUBLE_SEVEN_TEXT28 = "Đồng ý trễ rồi, người ta đã có cặp rồi bạn ơi!",
DOUBLE_SEVEN_TEXT29 = "Chưa xác định quan hệ Người Yêu, không thể tặng quà Tỏ Tình",
DOUBLE_SEVEN_TEXT30 = "Gửi thành công",
DOUBLE_SEVEN_TEXT31 = "Vật phẩm không đủ",
DOUBLE_SEVEN_TEXT32 = "Tỏ Tình thành công",

DOUBLE_SEVEN_TEXT33= [[<T C="127,70,26" S="24" P="1">Người chơi </T><T C="229,105,22" S="24" P="1">%s</T><T C="127,70,26" S="24" P="1"> đã chấp nhận lời mời của bạn</T>]],

DOUBLE_SEVEN_TEXT34 = [[
<T C="229,105,22" S="20" P="1">Tỏ Tình Valentine</T><BR></BR>
<T C="127,70,26" S="20" P="1">Valentine ngọt ngào, chúc mọi người sớm tìm được một nửa của mình nhé!</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">Trong hoạt động, chọn một người bạn khác giới, xác định quan hệ xong là có thể tham gia hoạt động Tỏ Tình Valentine rồi đó! Trong hoạt động, chỉ được Tỏ Tình với 1 bạn thôi, chấp nhận rồi là không hủy được đâu nha!</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">Nhiệm Vụ Tỏ Tình: Diễn ra mỗi ngày trong hoạt động, khi hoàn thành sẽ được nhận phần thưởng cố định. Nhiệm vụ ngày không tính tích lũy, số liệu sẽ được xóa vào hôm sau.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="1">BXH Yêu Thương: Xếp hạng theo Điểm Yêu Thương. Top 100 được nhận thưởng hấp dẫn, 2 người dẫn đầu chắc chắn nhận được thưởng lớn.</T><BR></BR>
]],
DOUBLE_SEVEN_TEXT35="Đã có Người Yêu rồi, đừng có đi Tỏ Tình hoặc chấp nhận người khác nữa!",


AUCTION_HOUSE_TEXT1="Số đấu giá: ",
AUCTION_HOUSE_TEXT2="Giá khởi điểm: ",
AUCTION_HOUSE_TEXT3="Thời gian đấu giá",
AUCTION_HOUSE_TEXT4="Ra giá hiện tại",
AUCTION_HOUSE_TEXT5="Xu Đấu Giá: ",
AUCTION_HOUSE_TEXT6="Nhật ký ra giá",
AUCTION_HOUSE_TEXT7="Vua Đấu Giá tuần này: ",
AUCTION_HOUSE_TEXT8="BXH Đấu Giá",
AUCTION_HOUSE_TEXT9 = "Có thể nhận bằng cách mua các gói quà chỉ định thông qua sự kiện mua giới hạn siêu giá trị",
AUCTION_HOUSE_TEXT10 = [[

<T C="127,70,26" S="22">1. Đấu Giá: Trong hoạt động, mỗi ngày sẽ mở Đấu Giá trong thời gian cố định. Dùng Xu Đấu Giá để thực hiện Đấu Giá, người nào ra giá cao nhất trong thời gian cho phép sẽ nhận được vật phẩm, </T>
<T C="255,89,74" S="22">Đấu Giá chưa thành công sẽ không bị khấu trừ Xu Đấu Giá</T><BR>20</BR>
<T C="127,70,26" S="22">2. Xu Đấu Giá: Nhận từ hoạt động, dùng để tham gia Đấu Giá các loại vật phẩm.</T><BR>20</BR>
<T C="127,70,26" S="22">3. Điểm: Khi ra giá, Nâng Giá, đấu giá thành công, vào BXH Tuần, đều nhận được số định nhất định.</T><BR>20</BR>
<T C="127,70,26" S="22">[Ra giá] Điểm +1</T><BR>20</BR>
<T C="127,70,26" S="22">[Nâng Giá 5%] Điểm +2</T><BR>20</BR>
<T C="127,70,26" S="22">[Nâng Giá 25%] Điểm +5</T><BR>20</BR>
<T C="127,70,26" S="22">[Nâng Giá 100%] Điểm +10</T><BR>20</BR>
<T C="127,70,26" S="22">[Đấu giá thành công] Điểm +200</T><BR>20</BR>
<T C="127,70,26" S="22">[BXH Tuần] Điểm +1000</T><BR>20</BR>
<T C="127,70,26" S="22">4. Vua Đấu Giá Tuần: Tổng kết lúc 23:59 CN hàng tuần. Người có điểm tuần này (không phải tổng điểm) cao nhất nhận được Quà Vua Đấu Giá Tuần.</T><BR>20</BR>
<T C="127,70,26" S="22">5. BXH Đấu Giá: BXH Tổng, khi hoạt động kết thúc, người chơi top 10 được nhận thưởng hấp dẫn.</T><BR>20</BR>
<T C="127,70,26" S="22">6. Tiệm Đấu Giá: Nội dung đang chờ cập nhật</T><BR>20</BR>
<T C="127,70,26" S="22">7. Hoạt động Đấu Giá hàng ngày bắt đầu từ 20h40 đến 22h20</T><BR>20</BR>
<T C="255,89,74" S="22">Lưu ý: Khi hoạt động tuần này kết thúc, "Xu Đấu Giá" còn lại sẽ không bị xóa, hoạt động kỳ sau vẫn dùng được như thường.</T><BR>20</BR>


]],
AUCTION_HOUSE_TEXT11 = [[
<T C="127,70,26" S="20">Ra giá %s</T>

<T C="255,89,74" S="20">%s</T>
<T C="127,70,26" S="20">Xu Đấu Giá</T>

]],
AUCTION_HOUSE_TEXT12="Tên nhân vật",
AUCTION_HOUSE_TEXT13="Điểm Đấu Giá",
AUCTION_HOUSE_TEXT14="Điểm Đấu Giá: ",
AUCTION_HOUSE_TEXT15="Quy Tắc Đấu Giá",

AUCTION_HOUSE_TEXT16 = {
"1",
"2",
"3",
"4",
"5",
"6",
"7",
"8",
"9",
"10",

},
AUCTION_HOUSE_TEXT17="Vật phẩm Đấu Giá thứ %s",
AUCTION_HOUSE_TEXT18="Người ra giá",
AUCTION_HOUSE_TEXT19="Đếm ngược Đấu Giá",
AUCTION_HOUSE_TEXT20="Nâng Giá",
AUCTION_HOUSE_TEXT21="Ra giá",
AUCTION_HOUSE_TEXT22="Vật phẩm hôm nay",
AUCTION_HOUSE_TEXT23="BXH Đấu Giá",
AUCTION_HOUSE_TEXT24 = "Xu Đấu Giá không đủ, có thể nhận từ mua giới hạn siêu giá trị",
AUCTION_HOUSE_TEXT25="Nâng Giá thành công, Điểm Đấu Giá +%s",
AUCTION_HOUSE_TEXT26="Nâng Giá thất bại",
AUCTION_HOUSE_TEXT27="Thời gian mở hoạt động: %s",
AUCTION_HOUSE_TEXT28="Hoạt động mở lúc %s",
AUCTION_HOUSE_TEXT29="Hoạt động đã kết thúc",
AUCTION_HOUSE_TEXT30="Ra giá thành công, Điểm Đấu Giá +%s",
AUCTION_HOUSE_TEXT31="Ra giá thất bại",
OPTIMIZE_TEXT1 = [[<T C="255,236,193" S="20" P="1">Đã sưu tập </T><T C="229,105,22" S="20" P="1">%d/%d</T><T C="255,236,193" S="20" P="1"> thẻ</T>]],
OPTIMIZE_TEXT2 = [[<T C="255,236,193" S="20" P="1">Hôm nay còn: </T><T C="229,105,22" S="20" P="1">%d/%d</T><T C="255,236,193" S="20" P="1"></T>]],
OPTIMIZE_TEXT3 = [[<T C="255,236,193" S="20" P="1">Đã sưu tập: </T><T C="229,105,22" S="20" P="1">%d</T><T C="255,236,193" S="20" P="1"> bộ</T>]],
OPTIMIZE_TEXT4 = "Nhật ký thao tác",
OPTIMIZE_TEXT5 = "Cấp xem trước",
OPTIMIZE_TEXT6 = "Ban đầu",
BATTLE_HELP_TEXT8 = "Lượt trợ chiến Thức Tỉnh: ",
BATTLE_HELP_TEXT9 = "Số lần khiêu chiến phó bản không đủ, không thể đổi",
BATTLE_HELP_TEXT10 = "(Trong trạng thái Treo Thưởng)",
BATTLE_HELP_TEXT11 = "Tiệm Trợ Chiến",
BATTLE_HELP_TEXT12 = "Lượt Treo Thưởng Thức Tỉnh: ",
BATTLE_HELP_TEXT13 = "Trợ chiến cần hơn chủ phòng 10 cấp, trợ chiến Thức Tỉnh cần hơn 30 cấp",
BATTLE_HELP_TEXT14 = "Phó bản đã gửi mời Thế Giới sẽ thành phó bản Treo Thưởng, vượt phó bản Treo Thưởng có thể tăng lần trợ chiến thường",
BATTLE_HELP_TEXT15 = "Số lần khiêu chiến Thức Tỉnh chưa hết, không cần tái lập",
BATTLE_HELP_TEXT16 = "Lượt khiêu chiến Phó Bản Nhóm-Thức Tỉnh +1",
BATTLE_HELP_TEXT17 = "Vượt phó bản Treo Thưởng có thể tăng lần trợ chiến",
AUCTION_HOUSE_TEXT32 = "Giới hạn tuần:",
AUCTION_HOUSE_TEXT33 = [[<T C="127,70,26" S="20">Tiệm Đạo Cụ mỗi tuần tạo mới 1 lần, đạo cụ giới hạn ngày tạo mới mỗi ngày, tạo mới thủ công chỉ có thể tạo mới đạo cụ giới hạn ngày.</T>]],
AUCTION_HOUSE_TEXT34 = "Vật phẩm vĩnh viễn không thể thao tác",
AUCTION_HOUSE_TEXT35 = "Đổi thành công",
ROOMINVITE_TEXT2 = {"Đồng","Bạc","Vàng","Bạch Kim","Kim Cương","Vinh Diệu"},
BATTLE_HELP_TEXT18 = "Thức Tỉnh: ",
FESTIVAL_TEXT1 = [[Quà Mừng Lễ Kỷ Niệm (Lớn), mở có cơ hội nhận Skin vĩnh viễn]],
FESTIVAL_TEXT2 = "Mở ngay",
FESTIVAL_TEXT3 = [[  ]],
FESTIVAL_TEXT4 = "Đã mở",
FESTIVAL_TEXT5 = [[
<T C="229,105,22" S="20" P="1">Thưởng Điểm Danh</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">Thời gian hoạt động: 12/12/2025 - 18/12/2025</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">Trong hoạt động mua với 20K, có thể mở hoạt động Quà Đăng Nhập Lễ Hội 7 Ngày</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="1">Mở Quà Đăng Nhập 7 Ngày, trong hoạt động chỉ cần đăng nhập mỗi ngày là có thể nhận thưởng</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="1">Quà Mừng Lễ Kỷ Niệm (Lớn) là quà ngẫu nhiên, trong hoạt động, đăng nhập 7 ngày, mỗi ngày sẽ nhận được 1 "Quà Mừng Lễ Kỷ Niệm (Lớn)"</T><BR></BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="1">Hoạt động đã mở, hãy nhớ nhận thưởng kịp lúc, sau khi hoạt động kết thúc sẽ xóa toàn bộ thưởng</T><BR></BR>
]],
FESTIVAL_TEXT6 = [[
<T C="255,255,255" S="20">1. Nhận </T><T C="255,227,114" S="22">[Vé Vấn Đáp] </T><T C="255,255,255" S="20">từ Thi Đấu/Tiệm Xếp Hạng hoặc rút thưởng may mắn</T><BR>20</BR>
<T C="255,255,255" S="20">2. Mỗi câu trả lời cần tốn 1 </T><T C="255,227,114" S="22">[Vé Vấn Đáp]</T><BR>20</BR>
<T C="255,255,255" S="20">3. BXH: Chia làm BXH Cá Nhân và BXH Công Hội, thống kế số lần trả lời đúng, hoạt động kết thúc, các bạn và Công Hội được lên BXH Siêu Nhân có thể nhận thêm thưởng hạng.</T><BR>10</BR>
<T C="0,112,202" S="20">Chú ý: Hãy nhận thưởng nhiệm vụ kịp lúc, khi hoạt động kết thúc sẽ xóa toàn bộ</T><BR>20</BR>
]],
FESTIVAL_TEXT7 = "Vé Vấn Đáp: ",
FESTIVAL_TEXT8 = "Số câu đáp đúng: ",
FESTIVAL_TEXT9 = "Chính xác: ",
FESTIVAL_TEXT10 = "Hướng dẫn hoạt động: ",
FESTIVAL_TEXT11 = "Bắt đầu",
FESTIVAL_TEXT12 = "Thưởng Vấn Đáp",
FESTIVAL_TEXT13 = {"vấn đáp","BXH Siêu Nhân"},
FESTIVAL_TEXT14 = "Đáp đúng %d câu",
FESTIVAL_TEXT15 = {"Tổng Hạng","Hạng Công Hội","Tổng Thưởng","Thưởng Công Hội"},
FESTIVAL_TEXT16 = "Số câu đáp đúng",
FESTIVAL_TEXT17 = "Người chơi/Tên/ID",
FESTIVAL_TEXT18 = "Hôm nay đã hết lượt rút thưởng",
FIGHTADD2 = "Lực chiến tăng",
NO_EXTRA_OPTIONS = "Không có lựa chọn khác",
FESTIVAL_TEXT19 = "Câu %d",
FESTIVAL_TEXT20 = "Đã trả lời hết câu hỏi hôm nay",
FESTIVAL_TEXT21 = "Đã dùng hết Vé Vấn Đáp",
FESTIVAL_TEXT22 = [[<T C="229,105,22" S="20">Trả lời đúng</T>]],
FESTIVAL_TEXT23 = "Trả lời sai",
FESTIVAL_TEXT24 = "Tham gia vấn đáp %d/%d lần",
FESTIVAL_TEXT25 = "Đáp đúng %d/%d câu",
FESTIVAL_TEXT26 = "Nhận %d/%d Vé Vấn Đáp",
FESTIVAL_TEXT27 = "Rút thưởng may mắn nhận %d/%d Vé Vấn Đáp",
FESTIVAL_TEXT28 = [[
<T C="127,70,26" S="20">1. Nhận [Vé Vấn Đáp] từ Thi Đấu/Tiệm Xếp Hạng hoặc rút thưởng may mắn</T><BR>10</BR>
<T C="127,70,26" S="20">2. Mỗi câu trả lời cần tốn 1 [Vé Vấn Đáp]</T><BR>10</BR>
<T C="127,70,26" S="20">3. BXH: Chia làm BXH Cá Nhân và BXH Công Hội, thống kế số lần trả lời đúng, hoạt động kết thúc, các bạn và Công Hội được lên BXH Siêu Nhân có thể nhận thêm thưởng hạng.</T><BR>10</BR>
<T C="229,105,22" S="20">Chú ý: Hãy nhận thưởng nhiệm vụ kịp lúc, khi hoạt động kết thúc sẽ xóa toàn bộ</T><BR>20</BR>
]],
FESTIVAL_TEXT30 = "Mở nhận 1 phần thưởng: Du Hành Gia x1, Thiếu Nữ Và Tượng Thần x1, Vàng x1000010, Kim Cương Khóa x1001, Kim Cương Khóa x2022, Đá Thánh Tím x1, Đá Kế Thừa (Pet) x1, Đá Bảo Vệ x2, Quyển Bùa x10, Pha Lê Cộng Sinh x5, Đá Sao-Sơ (Pet) x20",
FESTIVAL_TEXT31 = "Hãy nhận Vé Vấn Đáp trước", 
GAME_ACTIVITY_OPPO_BIGVIP_WELFARE = "Phúc Lợi VIP",
GAME_ACTIVITY_OPPO_BIGVIP_SIGNIN = "VIP Điểm Danh",
GAME_ACTIVITY_OPPO_BIGVIP_RECHARGE = "VIP Nạp",
GAME_ACTIVITY_OPPO_BIGVIP_AMBERPLAYER = "VIP Hổ Phách",
GAME_ACTIVITY_OPPO_BIGVIP_TIPS = "Mở game từ Game Center sẽ nhận thưởng thêm, khởi động Game Center?",
CHANGESEX9 = [[Đổi giới tính thất bại]],  
FESTIVAL_TEXT32 = "Đi làm Siêu Nhân",
FESTIVAL_TEXT33 = "Vấn Đáp Vui",
DRESS_DAYTIPS = "Tích lũy vượt hơn 999 ngày sẽ tự động nâng cấp thành thời trang vĩnh viễn",
SINGLECOPY_TEXT21 = "Thưởng Lãnh Chúa", 
BUYACTIVITY_RETURN = [[
<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">Tốn </T>
<I Z="0.45" P="1">%s</I>
<T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1"> %d/%d</T>
<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">   Hoàn trả </T>
<I Z="0.45" P="1">%s</I>
<T C="255,255,255" S="20" P="1" SC="132,66,29" SS="4" SE="1"> %d</T>
]],
CHARM_LIFT33 = "Vua Hấp Dẫn",
THIS_WEEK = "Tuần này",
HISTORY = "Tổng",

GAME_ACTIVITY_WEEKEND_LIMITED = "Giới hạn cuối tuần",
CUMULATIVE_PURCHASE_PACKAGE = "Mua Quà \"Mua Chung/Hoàn Trả Đầu Tư hoặc Bánh Kem\" bất kỳ",
CUMULATIVE_CONSUMPTION_DIAMONDS = "Tích lũy tốn Kim Cương",
CUMULATIVE_VICTORY_BATTLE = "Tích lũy thắng Đấu Hạng",
PEOPLE_SHOP_TEXT1 = "Thời gian hoạt động: ",
PEOPLE_SHOP_TEXT2 = "Giỏ Hàng",
PEOPLE_SHOP_TEXT3 = "Tổng: ",
PEOPLE_SHOP_TEXT4 = "Ưu đãi: ",
PEOPLE_SHOP_TEXT5 = "Chi trả",
PEOPLE_SHOP_TEXT6 = "Vé Ưu Đãi",
PEOPLE_SHOP_TEXT7 = "BXH Mua Sắm",
PEOPLE_SHOP_TEXT8 = [[
<T C="127,70,26" S="20">1. Trong hoạt động, mỗi ngày hoàn thành nhiệm vụ chỉ định, nhận được Vé Ưu Đãi. Dùng Vé Ưu Đãi được hưởng mức giá ưu đãi khi mua sắm.</T><BR>10</BR>
<T C="127,70,26" S="20">2. Vé Ưu Đãi đã nhận chỉ có hiệu lực cho một lần chi trả trong ngày, quá hạn sẽ tự động mất giá trị. Mỗi lần chi trả chỉ được dùng 1 Vé Ưu Đãi, ưu tiên dùng tấm có giá trị lớn nhất.</T><BR>10</BR>
<T C="127,70,26" S="20">3. BXH Chuyên Gia Mua Sắm: Thống kê theo tổng điểm nhận được trong hoạt động. Khi hoạt động kết thúc, Top 30 người chơi sẽ được nhận thưởng hấp dẫn</T><BR>10</BR>
<T C="229,105,22" S="20">Chú ý: Có thể nhận Xu Mua Sắm từ chỗ "Bánh Kem", dùng đổi vẫt phẩm trong Lễ Hội Mua Sắm. Khi hoạt động kết thúc, sẽ xóa hết toàn bộ Xu Mua Sắm.</T><BR>20</BR>
]],
PEOPLE_SHOP_TEXT9 = "Bỏ vào Giỏ Hàng",
PEOPLE_SHOP_TEXT10 = "Giá Bán: ",
PEOPLE_SHOP_TEXT11 = "Giới hạn mua hôm nay: ",
PEOPLE_SHOP_TEXT12 = "Dùng ngay",
PEOPLE_SHOP_TEXT13 = "BXH Chuyên Gia",
PEOPLE_SHOP_TEXT14 = "Chưa chọn vật phẩm muốn xóa",
PEOPLE_SHOP_TEXT15 = "Xu Mua Sắm",
PEOPLE_SHOP_TEXT16 = "Chi trả thất bại",
PEOPLE_SHOP_TEXT17 = "Số lượng mua không thể bằng 0",
PEOPLE_SHOP_TEXT18 = "Số lượng mua không thể vượt giới hạn",
PEOPLE_SHOP_TEXT19 = "Thêm thành công",
PEOPLE_SHOP_TEXT20 = "Thêm thất bại",
PEOPLE_SHOP_TEXT21 = "Mức giá bị lỗi, hãy chọn mặt hàng khác",
PEOPLE_SHOP_TEXT22 = "Vật phẩm đã ngưng bán, hãy chọn mặt hàng khác",

HELPER_NAME = "Người Bí Ẩn",
HELPER_ATT = "Đây là con mồi mà ta chờ đợi từ lâu!",

BLESS_DRAW_1 = "Cầu Phúc-Thấp có cơ hội nhận được phẩm chất Lam",
BLESS_DRAW_2 = "Cầu Phúc-Cao có cơ hội nhận được phẩm chất Tím",
BLESS_DRAW_3 = "Chúc phúc %s đã gộp các chúc phúc khác",
BLESS_DRAW_4 = "Gộp nhanh ngay?",

AMUSERANK_TEXT1 = {"Hạng Thi Đấu Tuần", "Thưởng Hạng Thi Đấu", "Hạng Bậc Đấu"},
AMUSERANK_TEXT2 = "Điểm cấp bậc",
AMUSERANK_TEXT3 = "Có thể mời người chơi %s tham gia %s",
AMUSERANK_TEXT4 = {"Đồng","Bạc","Vàng","Bạch Kim","Bậc Thầy","Bá Chủ"},
AMUSERANK_TEXT5 = [[<T C="127,70,26" S="20" P="0">Tổng hạng cấp bậc Đấu Giải Trí</T>]],
AMUSERANK_TEXT6 = [[<T C="127,70,26" S="20" P="0">Chủ nhật hằng tuần lúc </T><T C="158,0,0" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0"> sẽ phát thưởng theo Điểm Hạng Tuần hiện tại</T>]],

AMUSERANK_TEXT7 = "Cấp Đấu Giải Trí",
AMUSERANK_TEXT8 = "Tăng Điểm Thi Đấu",

TEAM_WORLD_BOSS_SEND_DESC= [[<T C="127,70,26" S="20" P="0">Thưởng Hạng Lãnh Chúa Vực Sâu</T>]],
SINGLE_WORLD_BOSS_SEND_DESC= [[<T C="127,70,26" S="20" P="0">Thưởng Hạng BOSS Thế Giới</T>]],
CHARM_KING_SEND_REWARD = [[<T C="138,122,106" S="22" P="0">Người đồng thời đạt danh hiệu Thời Trang Hấp Dẫn, Trang Cá Nhân Hấp Dẫn, Sức Hút sẽ trở thành Vua Hấp Dẫn!</T>]],

AMUSE_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc Đấu Giải Trí</T><BR></BR>
<T C="255,89,74" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Mỗi ngày mở một kiểu Đấu Giải Trí</T><BR></BR>
<T C="255,89,74" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Tham gia Đấu Giải Trí để nhận Điểm Thi Đấu. Khi Điểm Thi Đấu đạt mức yêu cầu sẽ có thể tăng Bậc Thi Đấu</T><BR></BR>
<T C="255,89,74" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Điểm Thi Đấu có giới hạn mỗi tuần, đạt tối đa sẽ không thể nhận thêm nữa</T><BR></BR>
]],
YULE_FIGHT_RULE4 = 
[[
<T C="229,105,22" S="22">Quy tắc Loạn Đấu</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Hệ thống sẽ ghép 4 người có thực lực tương đương với nhau, cần diệt 4 người chơi mới có thể chiến thắng, thoát ra giữa chừng sẽ bị trừ Điểm Thi Đấu</T><BR>10</BR>
]],
YULE_FIGHT_RULE6 = 
[[
<T C="229,105,22" S="22">Quy tắc Đấu Quái Thú</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Hệ thống sẽ ghép 4 người có thực lực tương đương với nhau, trong đó 1 người sẽ biến thành Quái Thú, những người còn lại phải đánh bại Quái Thú mới giành được thắng lợi. Nếu thoát ra giữa chừng sẽ bị trừ Điểm Thi Đấu</T><BR>10</BR>
]],
YULE_FIGHT_RULE8 = 
[[
<T C="229,105,22" S="22">Quy tắc Mạo Hiểm</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Khiêu chiến là cuộc hỗn chiến 6 người, người sống sót sau cùng sẽ là Vua</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Sau khi vào chiến đấu, kỹ năng chiến đấu hoàn toàn ngẫu nhiên</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Sau khi vào chiến đấu, ô đạo cụ sẽ trống, cần tự mở hoặc dùng đạn mở rương mới nhận được đạo cụ sử dụng</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Sau khi vào chiến đấu, người chơi cần tự di chuyển, bay và dùng vũ khí để mở rộng phạm vi tầm nhìn</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Sau khi vào chiến đấu sẽ có khói độc tăng dần theo thời gian và lan khắp bản đồ, người chơi phải tránh khói độc</T><BR>10</BR>
]],
PVP_HALL_47 = "Người chơi tham gia Đấu Cân Bằng sẽ có thuộc tính ngang nhau\nKhông Pet, không Ảo Hóa, không Thức Tỉnh",
JUEDITIPS3 = "Thuộc tính Loạn Đấu",
JUEDITIPS4 = "*Loạn Đấu là dạng thi đấu thiên về kỹ thuật. Trong cách chơi này, thuộc tính nhân vật đều như nhau",
JUEDITIPS5 = "Thuộc tính Đấu Quái Thú",
JUEDITIPS6 = "*Đấu Quái Thú là dạng thi đấu thiên về kỹ thuật. Trong cách chơi này, thuộc tính nhân vật đều như nhau",
JUEDITIPS7 = "Thuộc tính Đấu Đạo Cụ",
JUEDITIPS8 = "*Đấu Đạo Cụ là dạng thi đấu thiên về kỹ thuật. Trong cách chơi này, thuộc tính nhân vật đều như nhau",
JUEDITIPS9 = "Thuộc tính Đấu Đội Trưởng",
JUEDITIPS10 = "*Đấu Đội Trưởng là dạng thi đấu thiên về kỹ thuật. Trong cách chơi này, thuộc tính nhân vật đều như nhau",
JUEDITIPS11 = "Thuộc tính Đấu Đào Hố",
JUEDITIPS12 = "*Đấu Đào Hố là dạng thi đấu thiên về kỹ thuật. Trong cách chơi này, thuộc tính nhân vật đều như nhau",
JUEDITIPS13 = "Thuộc tính Đấu Hồi Sinh",
JUEDITIPS14 = "*Đấu Hồi Sinh là dạng thi đấu thiên về kỹ thuật. Trong cách chơi này, thuộc tính nhân vật đều như nhau",
JUEDITIPS15 = "Thuộc tính Đấu Cân Bằng",
JUEDITIPS16 = "*Đấu Cân Bằng là dạng thi đấu thiên về kỹ thuật. Trong cách chơi này, thuộc tính nhân vật đều như nhau",
AMUSERANK_TEXT9 = "Giới hạn Điểm Thi Đấu tuần này",
OPTIMIZE_TEXT7 = "Vui Lễ 11/11",
OPTIMIZE_TEXT8 = [[
<T C="229,105,22" S="22">Cùng Vui 11/11</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Tích lũy nạp đạt mức yêu cầu, được nhận nhiều Kim Cương và danh hiệu hiếm</T><BR>10</BR>
]],
PEOPLE_SHOP_TEXT23 = "Hãy chọn vật phẩm muốn xóa",
PEOPLE_SHOP_TEXT24 = "Chỉ hiển thị người chơi top 30",

OPTIMIZE_TEXT9 = "Tìm Lại-K.C có thể tìm lại toàn bộ phần thưởng, Tìm Lại-Vàng chỉ có thể tìm lại một bộ phận trong tổng thưởng",
OPTIMIZE_TEXT10 = "Tìm Lại-K.C",
OPTIMIZE_TEXT11 = "Tìm Lại-Vàng",
OPTIMIZE_TEXT12 = "Lợi ích này không thể Tìm Lại",
OPTIMIZE_TEXT13 = "Lợi ích này không thể Tìm Lại-Vàng",
OPTIMIZE_TEXT14 = "Tìm Lại-Vàng chỉ có thể tìm lại 50% mức thưởng, xác nhận Tìm Lại-Vàng ngay?",
OPTIMIZE_TEXT15 = "Điểm Vinh Dự không đủ",
OPTIMIZE_TEXT16 = "Điểm Tín Dụng quá thấp",
OPTIMIZE_TEXT17 = "Điểm Tín Dụng dưới %d không thể tham gia tính năng này. Mỗi %s giờ sẽ hồi phục %s Điểm Tín Dụng",
OPTIMIZE_TEXT18 = "Điểm Tín Dụng hiện tại: ",
OPTIMIZE_TEXT19 =
[[
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Các hành vi tiêu cực như cố ý bỏ trận, tự sát, gây ảnh hưởng đến lợi ích đồng đội sẽ bị trừ Điểm Tín Dụng</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Điểm Tín Dụng không đủ 81 điểm sẽ cấm Đấu Hạng, không đủ 80 điểm sẽ cấm Đấu Giải Trí. Điểm Tín Dụng càng thấp, số tính năng bị giới hạn càng nhiều</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Điểm Tín Dụng mỗi giờ tự động hồi phục 1 điểm. Tham gia Đấu Hạng, Đấu Giải Trí, Phó Bản Nhóm cũng sẽ hồi phục Điểm Tín Dụng</T><BR>10</BR>
]],


OPTIMIZE_TEXT20 = "Điểm Tín Dụng",
OPTIMIZE_TEXT21 = "Tín Dụng cực thấp",
OPTIMIZE_TEXT22 = "Tín Dụng khá thấp",
OPTIMIZE_TEXT23 = "Tín Dụng vừa đủ",
OPTIMIZE_TEXT24 = "Tín Dụng khá tốt",
OPTIMIZE_TEXT25 = "Tín Dụng ưu tú",
OPTIMIZE_TEXT26 = "Tín Dụng cực tốt",

COPY_DIFFICULTY_1 = "Độ khó Thường",
COPY_DIFFICULTY_2 = "Độ khó Tinh Anh",
COPY_DIFFICULTY_3 = "Độ khó Ác Mộng",
MARRY_DESC_1 = "Thưởng lật thẻ %s",
MARRY_DESC_2 = [[
<T C="127,70,26" S="22" P="1">%s có thể tăng </T>
<T C="5,180,0" S="22" P="1">%d điểm</T>
<T C="127,70,26" S="22" P="1">Tình cảm</T>
]],
MARRY_DESC_3 = "Chúc Phúc",
MARRY_DESC_4 = "Lì Xì",
MARRY_DESC_5 = "Pháo Hoa",
MARRY_DESC_6 = "Kẹo Hỉ",
MARRY_DESC_7 = "Nhật Ký",
MARRY_DESC_8 = "Tìm bạn đời",
MARRY_DESC_9 = "Tham gia Hôn Lễ",
MARRY_DESC_10 = "Đang chuẩn bị",
MARRY_DESC_11 = "Hôn Lễ bắt đầu",

VIP_TEXT_1 = "x3",
VIP_TEXT_2 = "x2",
VIP_TEXT_3 = "Đề cử",


TREASURE_TEXT1 = [[<T C="127,70,26" S="18" P="1">Bản Đồ Săn Báu thứ </T><T C="229,105,22" S="18" P="1">%d</T><T C="127,70,26" S="18" P="1"></T>]],
TREASURE_TEXT2 = "Ô còn lại: ",
TREASURE_TEXT3 = "Quy tắc Bản Đồ Săn Báu",
TREASURE_TEXT4 = "Thưởng tham gia",
TREASURE_TEXT5 = "Thưởng toàn server",
TREASURE_TEXT6 = "BXH Săn Báu",
TREASURE_TEXT7 = "Thưởng đặc biệt",
TREASURE_TEXT8 = "Săn Báu 1 lần",
TREASURE_TEXT9 = "Săn Báu 10 lần",
TREASURE_TEXT10 = "Mua %d Vàng (Tặng %d lần Săn Báu)",

KID_HOME_TEXT2 = "Thăm Hỏi",
KID_HOME_TEXT3 = "Không phải bạn bè, không thể thăm hỏi.",
KID_HOME_TEXT4 = "Thăm Hỏi thành công",
KID_HOME_TEXT5 = "Đã thăm hỏi người khác rồi",
KID_HOME_TEXT6 = "Thăm hỏi quá nhiều",
KID_HOME_TEXT7 = "Đang đi thăm hỏi %d:%d:%d",
KID_HOME_TEXT8 = [[<T C="127,70,26" S="20" P="1">Đang Thăm Hỏi </T><T C="255,105,22" S="20" P="1"> %d:%d:%d</T>]],
KID_HOME_TEXT9 = "Thăm hỏi người khác sẽ được tăng thêm lực chiến",
KID_HOME_TEXT10 = "Không thể tự thăm hỏi nhà mình",


PRE_DEVIL_NAME = "-Tâm Ma",

MARRY_DESC_14 = "Adrien",
MARRY_DESC_15 = "Mối duyên đẹp nhất trên đời chính là tìm được một người bầu bạn, cùng nói chuyện đùa vui, luôn quan tâm săn sóc nhau, hiểu niềm vui nỗi buồn của nhau.",

TREASURE_TEXT1 = [[<T C="127,70,26" S="18" P="1">Bản Đồ Săn Báu thứ </T><T C="229,105,22" S="18" P="1"> %d </T><T C="127,70,26" S="18" P="1"></T>]],
TREASURE_TEXT2 = "Ô còn lại: ",
TREASURE_TEXT3 = [[
<T C="127,70,26" S="20">1. Mỗi lần Săn Báu sẽ mở một ô ngẫu nhiên, nhận phần thưởng trong ô đó.</T><BR>10</BR>
<T C="127,70,26" S="20">2. Thưởng Điểm: Sau khi Săn Báu thành công sẽ nhận được điểm tương ứng. Mỗi ngày đạt mức điểm yêu cầu sẽ được nhận rương thưởng tương ứng. Điểm sẽ xóa mỗi ngày, hãy nhận thưởng kịp thời</T><BR>10</BR>
<T C="127,70,26" S="20">3. Thưởng tham gia: Mỗi ngày Săn Báu 1 lần, được nhận thưởng tham gia của ngày hôm đó</T><BR>10</BR>
<T C="127,70,26" S="20">4. Thưởng toàn server: Người chơi toàn server khi Săn Báu đạt số lần chỉ định sẽ được nhận thưởng. Khi hoạt động kết thúc sẽ xóa hết sớ liệu, hãy nhận thưởng kịp thời.</T><BR>10</BR>
<T C="127,70,26" S="20">5. Thưởng Hạng: Xếp hạng theo điểm Săn Báu, người chơi Top 50 được nhận phần thưởng hấp dẫn.</T><BR>10</BR>
]],
TREASURE_TEXT4 = "Thưởng tham gia",
TREASURE_TEXT5 = "Thưởng toàn server",
TREASURE_TEXT6 = "BXH Săn Báu",
TREASURE_TEXT7 = "Thưởng đặc biệt",
TREASURE_TEXT8 = "Săn Báu 1 lần",
TREASURE_TEXT9 = "Săn Báu 10 lần",
TREASURE_TEXT10 = "Mua %d Vàng",
TREASURE_TEXT11 = " (Tặng 1 lần Săn Báu)",
TREASURE_TEXT12 = " (Tặng 10 lần Săn Báu)",
TREASURE_TEXT13 = "Hôm nay đã nhận thưởng, mai hãy cố gắng tiếp!",
TREASURE_TEXT14 = "Săn Báu 1 lần bất kỳ sẽ có thể nhận quà",
TREASURE_TEXT15 = "Chưa có thưởng lớn",
TREASURE_TEXT16 = "Số ô còn lại không đủ để Săn Báu 10 lần",
TREASURE_TEXT17 = "Không thể nhận rương",
TREASURE_TEXT18 = "Đã nhận rương này rồi",
TREASURE_TEXT19 = "Hiển thị người chơi trong Top 50",
TREASURE_TEXT20 = "Đang rút thưởng, đừng nhấp chọn nhiều lần!",
TREASURE_TEXT21 = "Hôm nay Săn Báu 1 lần, sẽ được nhận 2 món ngẫu nhiên",
TREASURE_TEXT22 = "Toàn server Săn Báu %s lần, sẽ được nhận 2 món ngẫu nhiên",

MARRY_DESC_12 = "Hiển thị bạn bè khác giới, điểm thân mật đạt 1000 trở lên",
MARRY_DESC_13 = [[<T S="22" C="127,70,26" P="0">Chọn </T><T S="22" C="255,89,74" P="0">bạn bè muốn mời</T>]],
KID_TEXT123 = "Điểm Chăm Sóc",
TRANS_HURT = "Chuyển sát thương",

LUCKYGIFT_DES2 = 
[[
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18"> Hộp Quà May Mắn mỗi ngày tạo mới lúc 24 giờ</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Lật thẻ quà cần tốn Kim Cương Khóa, lật thẻ càng nhiều tiêu phí càng nhiều</T><BR>10</BR> 
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18"> Mỗi ngày có số lần lật thẻ quà miễn phí nhất định</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18"> Sau khi rút được Thẻ Tỉ Lệ, giá lật thẻ sẽ nhân với số trên Thẻ Tỉ Lệ</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18"> Khi nhận Xu Ban Ân có thể dùng mua vật phẩm trong Cửa Hàng</T><BR>10</BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">Xác suất thưởng</T><BR>10</BR>
<T C="127,70,26" S="18"> Xu Ban Ân  1.3% </T><BR>10</BR>
<T C="127,70,26" S="18"> Vàng  14.2% </T><BR>10</BR>
<T C="127,70,26" S="18"> Đá Sao-Cao  4.5% </T><BR>10</BR>
<T C="127,70,26" S="18"> Sách Kỹ Năng-Trung  8.9% </T><BR>10</BR>
<T C="127,70,26" S="18"> Gà Quay  14.5% </T><BR>10</BR>
<T C="127,70,26" S="18"> Huy Chương Cầu Phúc  7.1% </T><BR>10</BR>
<T C="127,70,26" S="18"> Đá Thức Tỉnh-Trung  4.3% </T><BR>10</BR>
<T C="127,70,26" S="18"> Trứng Pet EXP-Cao  4.3% </T><BR>10</BR>
<T C="127,70,26" S="18"> Vé  Thẻ 10.9% </T><BR>10</BR>
<T C="127,70,26" S="18"> Thẻ Bội Số  10.9% </T><BR>10</BR>
<T C="127,70,26" S="18"> Bụi Thánh Quang  4.1% </T><BR>10</BR>
<T C="127,70,26" S="18"> Thẻ Thắng Thi Đấu  4.1% </T><BR>10</BR>
<T C="127,70,26" S="18"> Đá Thức Tỉnh-Sơ  8.1% </T><BR>10</BR>
<T C="127,70,26" S="18"> Xu Cầu Phúc  2.8% </T><BR>10</BR>
]],
LUCKYGIFT_DES3 = 
[[
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Săn Báu cần tốn Kim Cương Khóa</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Săn Báu đủ số lần yêu cầu sẽ được nhận thưởng</T><BR>10</BR> 
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Xác suất thưởng</T><BR>10</BR>
<T C="127,70,26" S="18"> Kim Cương Khóa  4.3% </T><BR>10</BR>
<T C="127,70,26" S="18"> Vàng  7.2% </T><BR>10</BR>
<T C="127,70,26" S="18"> Huy Chương Cầu Phúc  14.5% </T><BR>10</BR>
<T C="127,70,26" S="18"> Trứng Pet EXP-Cao  10.9% </T><BR>10</BR>
<T C="127,70,26" S="18"> Đá Sao-Cao  14.5% </T><BR>10</BR>
<T C="127,70,26" S="18"> Đá Purple  0.1% </T><BR>10</BR>
<T C="127,70,26" S="18"> Bụi Thánh Quang  4.3% </T><BR>10</BR>
<T C="127,70,26" S="18"> Quà Khảm  L5 4.3% </T><BR>10</BR>
<T C="127,70,26" S="18"> Quà Thẻ Lam  10.9% </T><BR>10</BR>
<T C="127,70,26" S="18"> Sách Kỹ Năng-Trung  10.9% </T><BR>10</BR>
<T C="127,70,26" S="18"> Đá Thức Tỉnh-Trung  11.1% </T><BR>10</BR>
<T C="127,70,26" S="18"> Bánh Donut  7% </T><BR>10</BR>
]],
LUCKYGIFT_DES4 = 
[[
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Săn Báu cần tốn Kim Cương Khóa</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Săn Báu đủ số lần yêu cầu sẽ được nhận thưởng</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Xác suất thưởng</T><BR>10</BR>
<T C="127,70,26" S="18">Kim Cương 10.6%</T><BR>10</BR>
<T C="127,70,26" S="18">Vàng 13.2%</T><BR>10</BR>
<T C="127,70,26" S="18">Xu Cầu Phúc 5.3%</T><BR>10</BR>
<T C="127,70,26" S="18">Trứng Pet EXP-Cao 13.2%</T><BR>10</BR>
<T C="127,70,26" S="18">Đá Sao-Cao 13.2%</T><BR>10</BR>
<T C="127,70,26" S="18">Bánh Donut 5.3%</T><BR>10</BR>
<T C="127,70,26" S="18">Bụi Thánh Quang 13.2%</T><BR>10</BR>
<T C="127,70,26" S="18">Xu Ban Ân 0.1%</T><BR>10</BR>
<T C="127,70,26" S="18">Quà Thẻ Tím 2.6%</T><BR>10</BR>
<T C="127,70,26" S="18">Sách Kỹ Năng-Cao 1.3%</T><BR>10</BR>
<T C="127,70,26" S="18">Vé Quét Ác Mộng 10.6%</T><BR>10</BR>
<T C="127,70,26" S="18">Thuốc Nhuộm 10.6%</T><BR>10</BR>
<T C="127,70,26" S="18">Kim Cương Khóa 1.1%</T><BR>10</BR>
]],

COMMUNITY_NEWTEXT1 = "Thưởng hôm nay",
COMMUNITY_NEWTEXT2 = "Hạng Cổ Vũ",
COMMUNITY_NEWTEXT3 = "Thưởng gây %d sát thương",
COMMUNITY_NEWTEXT4 = "Đã là BOSS cuối cùng",
COMMUNITY_NEWTEXT5 = "Đã là BOSS đầu tiên",
COMMUNITY_NEWTEXT6 = "Đừng nóng vội, diệt BOSS hiện tại đã",
COMMUNITY_NEWTEXT7 = "Cần diệt BOSS của chương trước đó trước",
COMMUNITY_NEWTEXT8 = "Chưa có thành viên cổ vũ\nBạn hãy là người đâu tiên nhé!",
COMMUNITY_NEWTEXT9 = 
[[
<T C="229,105,22" S="22" P="0">1. </T><T C="127,70,26" S="22" P="0">Tăng sát thương trong phó bản Công Hội sau khi cổ vũ, tất cả thành viên đều được nhận</T><BR></BR>
<T C="229,105,22" S="22" P="0">2. </T><T C="127,70,26" S="22" P="0">Tăng sát thương trong phó bản Công Hội sau khi cổ vũ chỉ có hiệu lực với BOSS đang khiêu chiến</T><BR></BR>
<T C="229,105,22" S="22" P="0">3. </T><T C="127,70,26" S="22" P="0">Mỗi lần cổ vũ sẽ nhận được 100 Xu Khiêu Chiến Công Hội</T><BR></BR>
]],

SORT_NAME = "Thứ tự: ",
COMMUNITY_SORT1 = "Cống hiến tuần",
COMMUNITY_SORT2 = "Tổng cống hiến",

SEVENDAY_TEXT7 = "7 Ngày Mở Server",
SPECIFY_ACTIVITY_TEXT = "Quà đề cử",
RANK_FIGHT_PRO2 = "Thuộc tính chiến đấu Đấu Điểm",
RANK_FIGHT_PRO_DESC2 = "*Đấu Điểm là dạng thi đấu thiên về kỹ thuật, trong cách chơi này, thuộc tính nhân vật đều được cân bằng",
OPEN_IN_DAY = "%d ngày sau mở",

PVP_KING_TEXT1 = "Trùm Thi Đấu",
PVP_KING_TEXT2 = "Sao Tuần",
DOUBLE_TOWER_TEXT1 = "Có vẻ bọn chúng đang âm mưu gì đó",

EVERYDAYBUY_TEXT1 = [[
<T C="127,70,26" S="20">1. Trong hoạt động, được chọn 3 vật phẩm trong mỗi phần quà cấp bậc để mua.</T><BR>10</BR>
<T C="127,70,26" S="20">2. Hoàn thành số lượt mua chỉ định, được chọn nhận 2 phần thưởng dưới đây. Sau khi xong hết toàn bộ nhiệm vụ và nhận thưởng, số liệu sẽ được tái lập.</T><BR>10</BR>
<T C="127,70,26" S="20">3. Quà Tiến Cử Mỗi Ngày sẽ được cập nhật mỗi ngày một lần.</T><BR>10</BR>
]],
EVERYDAYBUY_TEXT2 = "Chọn %s vật phẩm muốn mua",
EVERYDAYBUY_TEXT3 = "Nhiệm Vụ Ngày",
EVERYDAYBUY_TEXT4 = "Nhiệm Vụ Trưởng Thành",
EVERYDAYBUY_TEXT5 = "Tích lũy mua: ",
EVERYDAYBUY_TEXT6 = "Phía trước không còn gì nữa",
EVERYDAYBUY_TEXT7 = "Phía sau không còn gì nữa",
EVERYDAYBUY_TEXT8 = [[<T C="127,70,26" S="20" P="1">Mỗi loại quà chỉ được chọn </T><T C="229,105,22" S="20" P="1">%s phần thưởng</T><T C="127,70,26" S="20" P="1"> để mua. Mỗi loại quà mỗi ngày </T><T C="229,105,22" S="20" P="1"> được mua %s lần</T>]],
EVERYDAYBUY_TEXT9 = "Số lượng mua đã chọn vượt quá phạm vi cho phép",
EVERYDAYBUY_TEXT10 = "Đặt mua thất bại",
EVERYDAYBUY_TEXT11 = "Đang mua, xin chờ",
EVERYDAYBUY_TEXT12 = "Có thể chọn %s vật phẩm để nhận",
EVERYDAYBUY_TEXT13 = "Không được chọn quá %s vật phẩm",
EVERYDAYBUY_TEXT14 = "Mời bạn chọn phần thưởng",
EVERYDAYBUY_TEXT15 = "Máy chủ đã bắt đầu qua ngày, số liệu đã chọn sẽ bị xóa, hãy chọn lại",

SEVENDAY_TEXT4 = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4">Thời gian kết thúc hoạt động: </T>]],
SEVENDAY_TEXT5 = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4">Thời gian kết thúc nhận thưởng: </T>]],
SEVENDAY_TEXT6 = [[<T C="255,89,74" S="18" P="1" SC="132,66,29" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4"> ngày </T><T C="255,89,74" S="18" P="1" SC="132,66,29" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4"> giờ </T><T C="255,89,74" S="18" P="1" SC="132,66,29" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4"> phút </T><T C="255,89,74" S="18" P="1" SC="132,66,29" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4"> giây</T>]],
LevelAndNameFormat = [[<T S="22" C="127,70,26" P="0">Lv</T><T S="22" C="229,105,22" P="0">%d</T><BL>10</BL><T S="22" C="127,70,26" P="0">%s</T>]],

QIUQIAN_TASK1="Hôm nay đã Xin Xăm %s lần",
QIUQIAN_TASK2="Hôm nay nhận Xăm Trung Cát %s lần",
QIUQIAN_TASK3="Hôm nay đã Xin Xăm %s lần",
QIUQIAN_TASK4="Hôm nay đã dùng %s Kim Cương Lam",
QIUQIAN_TASK5="Hôm nay đã nhận Xăm Đại Cát %s lần",
QIUQIAN_TASK6="Tích lũy Xin Xăm %s lần",
QIUQIAN_TASK7="Tích lũy Xin Xăm %s lần",
QIUQIAN_TASK8="Tích lũy Xin Xăm %s lần",
QIUQIAN_TASK9="Tích lũy nhận Xăm Đại Cát %s lần",
QIUQIAN_TASK10="Nhận Xăm Trung Cát %s lần",
QIUQIAN_TASK11="Nhận Xăm Trung %s lần",
QIUQIAN_TASK12="Tích lũy nhận Xăm Tiểu Cát %s lần",
EVERYDAYBUY_TEXT16 = "Hoàn thành số lượt mua chỉ định, được chọn nhận thưởng %s số lần tương ứng, sau khi nhận số liệu sẽ được tái lập",
EVERYDAYBUY_TEXT17 = "Xin Xăm Mỗi Ngày",
EVERYDAYBUY_TEXT18 = "Nhiệm Vụ Xin Xăm",
EVERYDAYBUY_TEXT19 = "BXH Xin Xăm",
EVERYDAYBUY_TEXT20 = "Xin Xăm 1 lần",
EVERYDAYBUY_TEXT21 = "Xăm của tôi: ",
EVERYDAYBUY_TEXT22 = "BXH Xin Xăm",
EVERYDAYBUY_TEXT23 = "Xin Xăm bất kỳ 1 lần, được nhận ngẫu nhiên %s phần thưởng dưới đây, số liệu sẽ được xóa vào hôm sau",
EVERYDAYBUY_TEXT24 = "Hôm nay đã nhận thưởng, mai may mắn liền liền!",
EVERYDAYBUY_TEXT25 = "Chỉ hiển thị top 100 người chơi",
EVERYDAYBUY_TEXT26 = "Xin Xăm thất bại",
EVERYDAYBUY_TEXT27 = "Đang Xin Xăm, xin chờ",   
EVERYDAYBUY_TEXT28 = [[
<T C="127,70,26" S="20">1. Nhận [Lá Xăm] từ hoạt động, mỗi lần Xin Xăm cần tốn 1 Lá Xăm, nhận được 2 phần thưởng ngẫu nhiên.</T><BR>10</BR>
<T C="127,70,26" S="20">2. Xin Xăm Mỗi Ngày: Mỗi ngày Xin Xăm xong sẽ được nhận thưởng, qua ngày sẽ xóa hết số liệu, hãy nhận thưởng kịp thời.</T><BR>10</BR>
<T C="127,70,26" S="20">3. Nhiệm Vụ Xin Xăm: Chia làm "Nhiệm Vụ Ngày" và "Nhiệm Vụ Trưởng Thành". Nhiệm vụ ngày mỗi ngày được hoàn thành 1 lần, số liệu sẽ được xóa vào hôm sau</T><BR>10</BR>
<T C="127,70,26" S="20">Hãy nhận thưởng kịp thời. Trong hoạt động nhiệm vụ Trưởng Thành có thể hoàn thành và nhận thưởng 1 lần. Khi xong nhiệm vụ hãy nhận thưởng kịp thời, hoạt động kết thúc sẽ xóa hết.</T><BR>10</BR>
<T C="255,89,74" S="22">Chú ý: Đạo cụ xăm, khi hoạt động kết thúc sẽ xóa hết.</T><BR>20</BR>
]],
EVERYDAYBUY_TEXT29 = "Số lần Xin Xăm không đủ",
EVERYDAYBUY_TEXT30 = "Cát",
EVERYDAYBUY_TEXT31 = {"Mạt","Tiểu","Trung","Đại"},
NEWYEARSIGN_TEXT0 = {"Vững bước tiến lên","Cố gắng không ngừng","Dốc sức tấn tới","Mài sắt nên kim","Khắc phục khó khăn"},

NEWYEARSIGN_TEXT1 = {"Đạp bằng chông gai","Mười năm đèn sách","Tiến bộ không ngừng","Tinh thần phấn chấn","Vạn sự như ý","Chắp cánh ước mơ"},

NEWYEARSIGN_TEXT2 = {"Gió xuân ấm áp, reo vui lá cành","Công việc thuận lợi, sự nghiệp đi lên","Thăng quan tiến chức, gia đình hạnh phúc","Chúc mừng năm mới, cùng đón tết vui","Năm mới vui vẻ, vạn sự như ý","Cuộc sống thuận lợi, gặp nhiều may mắn","Năm mới tốt lành, đại cát đại lợi","Năm mới may mắn, gặp nhiều thuận lợi"},

NEWYEARSIGN_TEXT3 = {"Đại cát đại lợi, trăm sự an vui","Tài lộc tấn tới, phú quý cát tường","Như ý cát tường, bình an hạnh phúc","Tài vận hanh thông, ước gì được nấy","Gia đình đoàn tụ, tiền vô như nước","Vạn sự thuận hòa, vinh hoa phú quý","Năm mới may mắn, trâu vàng an khang","Năm mới vui vẻ, vạn sự như ý"},

GAMEACTIVITY_CHRISTMAS_CARNIVAL = "Lễ Hội World Cup",
GAMEACTIVITY_CHRISTMAS_CONSUMPTION = "BXH Tiêu Phí Noel",
OUT_OF_PRINT_TITLE = "Vòng Sáng Cực Hiếm",
ACCUMLATED_REBATE = "Khung Avatar Cực Hiếm",
TASK_PROGRESS = "Tiến độ nhiệm vụ: ",
FRISTDAY_RECHARGE = "Ngày đầu nạp: ",
AND_CONSUME = " và dùng: ",
CHRISTMAS_CARNIVAL_EXPLAIN = [[
<T C="229,105,22" S="20" P="1">Cá Tháng Tư</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">Khi hoạt động bắt đầu, ngày đầu tiên chỉ có thể hoàn thành nhiệm vụ của ngày hôm đó.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">Hoàn thành tất cả nhiệm vụ tiến độ trong hoạt động sẽ được nhận thưởng.</T><BR></BR>
]],

CHRISTMAS_CONSUMPTION_EXPLAIN = [[
<T C="229,105,22" S="20" P="1">BXH Tiêu Phí Noel</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">BXH Kim Cương Lam: Xếp hạng theo số Kim Cương Lam đã dùng trong hoạt động. Người chơi Top 100 sẽ được nhận thưởng hấp dẫn và danh hiệu tinh tế.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">BXH Kim Cương Khóa: Xếp hạng theo mức Kim Cương Khóa đã dùng trong thời gian hoạt động, người chơi Top 50 được nhận phần thưởng hấp dẫn.</T><BR></BR>
]],
BLUE_RANK = "BXH Kim Cương Lam",
PINK_RANK = "BXH Kim Cương Đỏ",

OPTIMIZE_TEXT27 = [[
<T C="229,105,22" S="20" P="1">Nguyên liệu trưởng thành</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">Trong hoạt động, mỗi loại quà chỉ được mua 3 lần.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">Khi mua và mở quà, ưu tiên nhận được phần thưởng chưa có.</T><BR></BR>
]],
OPTIMIZE_TEXT28 = "Nguyên liệu trưởng thành",
OPTIMIZE_TEXT29 = "Mở quà được nhận 1 phần thưởng ngẫu nhiên, ưu tiên nhận được loại chưa có",
STAR_STONE1 = "Thêm đồ Tím/Cam sẽ tăng xác suất thành công",  
OPTIMIZE_TEXT47 = "Dùng %d món trang bị để tăng xác suất thành công, tiếp tục?",
FLOWER_ACTIVITY = "Không có giới hạn về số hoạt động tặng hoa",
GIFTLIMIT_ATT = "Chỉ được tặng quà cho bạn bè",
SEND_FLOWER_ATT = [[Hôm nay đã tặng quà cho bạn này rồi.]],
OPTIMIZE_TEXT1000 = {"Quà Vũ Khí","Quà Thú Cưỡi","Quà Vòng Sáng","Quà Cánh","Quà Pet"},

USE_LEVEL = "Cấp dùng: ",
USE_LEVEL_CONTENT = "Cấp dùng của đạo cụ mua lần này là: %s, xác nhận mua?",
GUILD_BOSS_INSPIRE_FIVE = "Cổ vũ 5 lần",
PHANTOM_NEWTEXT36 = "Luyện hóa 5 lần",
PHANTOM_NEWTEXT37 = "Nhật ký luyện hóa",
PHANTOM_NEWTEXT38 = [[<T C="127,70,26" S="20" P="1">Luyện hóa lần %d,</T>]],
PHANTOM_NEWTEXT39 = [[<T C="255,89,74" S="20" P="1">Không lưu kết quả</T>]],
PHANTOM_NEWTEXT40 = [[<T C="5,180,0" S="20" P="1">Lưu kết quả</T>]],
PHANTOM_NEWTEXT41 = [[<T C="127,70,26" S="20" P="1">Luyện hóa %d lần, lưu kết quả </T><T C="5,180,0" S="20" P="1">%d</T><T C="127,70,26" S="20" P="1"> lần, tổng tốn %d</T> <I Z="0.5" P="1">%s</I>]],
OPTIMIZE_TEXT30 = " mở",
SWEPT_TEXT1 = "Khiêu chiến đến tầng %d và mở rương có thể nhận",
SWEPT_TEXT2 = "Càn quét tầng %d - %d có thể nhận",
DIGGEM_TEXT44 = "Nhiệm Vụ Mỏ Khoáng",
SWEPT_REWARD = "Thưởng càn quét",
OPTIMIZE_TEXT31 = "Số tăng bậc toàn server",
BAGTIP50 = [[<T C="255,89,74" S="20" P="0">Bộ Cam %d món cường hóa đến %d (%d/%d)</T>]],
BAGTIP51 = [[<T C="255,89,74" S="20" P="0">Bộ Cam %d món tăng sao đến %d (%d/%d)</T>]],


NEWYEAR_TEXT1 = [[
<T C="229,105,22" S="20" P="1">Hoàn Trả Năm Mới</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">Mỗi ngày nạp và tiêu phí Kim Cương đạt mức yêu cầu, được nhận thưởng tương ứng, phần thưởng tái lập lúc 0 giờ mỗi ngày.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">Nhiệm vụ và thưởng hoạt động được cập nhật vào 0:00 hàng ngày.</T><BR></BR>
]],
NEWYEAR_TEXT2 = [[
<T C="229,105,22" S="20" P="1">Cầu Phúc Năm Mới</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">Trong hoạt động, tiêu phí hoặc nạp Kim Cương Lam đều nhận được số lần Cầu Phúc (Tiêu 200 Kim Cương Lam = 1 lần Cầu Phúc, nạp 60 Kim Cương Lam = 1 lần Cầu Phúc). Mỗi lần Cầu Phúc chắc chắn nhận 1 phần thưởng ngẫu nhiên, có cơ hội nhận thưởng Cầu Phúc.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">Mỗi ngày hoàn thành số lần Cầu Phúc chỉ định, được nhận thêm thưởng Cầu Phúc, tái lập cách ngày, hãy hoàn thành tiến độ và nhận thưởng kịp thời.</T><BR></BR>
]],
NEWYEAR_TEXT3 = [[
<T C="229,105,22" S="20" P="1">Lì Xì Năm Mới</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">Trong hoạt động, mỗi ngày hoàn thành nhiệm vụ chỉ định, có thể nhận lượt mở Lì Xì.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">Số lượt mở chỉ có tác dụng trong hoạt động, mỗi lần mở Lì Xì được nhận đạo cụ ngẫu nhiên, có cơ hội nhận phần thưởng POSM.</T><BR></BR>
]],
NEWYEAR_TEXT4 = [[
<T C="229,105,22" S="20" P="1">Cửa Hàng Năm Mới</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">Trong hoạt động, có thể dùng Kim Cương mua đạo cụ ưu đãi từ Cửa Hàng, mỗi ngày tạo mới 1 lần.</T><BR></BR>
]],
NEWYEAR_TEXT5 = "Mở có cơ hội nhận phần thưởng POSM",
NEWYEAR_TEXT6 = [[<T C="255,236,193" S="16" P="1">1. Hôm nay nạp mức bất kỳ, có thể nhận Lì Xì</T><T C="255,89,74" S="16" P="1">(%s)</T>]],
NEWYEAR_TEXT7 = [[<T C="255,236,193" S="16" P="1">%d.Hôm nay nạp</T> <T C="255,89,74" S="16" P="1">(%s)</T><T C="255,236,193" S="16" P="1">Kim Cương, có thể nhận Lì Xì</T><T C="255,89,74" S="16" P="1">(%s)</T>]],
NEWYEAR_TEXT8 = "Nhận",
NEWYEAR_TEXT9 = "Mở thất bại",
NEWYEAR_TEXT10 = "Cầu Phúc 1 lần",
NEWYEAR_TEXT11 = "Cầu Phúc 10 lần",
NEWYEAR_TEXT12 = "Số lần Cầu Phúc còn lại: ",
NEWYEAR_TEXT13 = "Cầu Phúc hôm nay: ",
NEWYEAR_TEXT14 = "BXH Cầu Phúc",
NEWYEAR_TEXT15 = "Chỉ hiện Top %d",
NEWYEAR_TEXT16 = "Đang Cầu Phúc....",
NEWYEAR_TEXT17 = "Hiện tại: ",
NEWYEAR_TEXT18 = "Tạo mới: ",
NEWYEAR_TEXT19 = "Tốn Kim Cương: ",
NEWYEAR_TEXT20 = "Được mua: ",
NEWYEAR_TEXT21 = "Cửa Hàng tạo mới mỗi ngày",
NEWYEAR_TEXT22 = "Lưu trữ không đủ",
NEWYEAR_TEXT23 = "Kim Cương không đủ",
HANKBOOK1 = "Robot",
HANKBOOK2 = "Động Vật",
HANKBOOK3 = "Huyễn Tưởng",
HANKBOOK4 = "Ngầu Lòi",
HANKBOOK5 = "Tinh Tế",
HANKBOOK6 = "Ngày Lễ",
HANKBOOK7 = "Ma Quái",
HANKBOOK8 = "Thưởng thu thập: ",

OPTIMIZE_TEXT32 = "Điền địa chỉ người nhận",
OPTIMIZE_TEXT33 = "Người nhận: ",
OPTIMIZE_TEXT34 = "Số di động: ",
OPTIMIZE_TEXT35 = "Địa chỉ cụ thể: ",
OPTIMIZE_TEXT36 = "Nhập tên người nhận",
OPTIMIZE_TEXT37 = "Nhập số di động",
OPTIMIZE_TEXT38 = "Nhập địa chỉ cụ thể",
OPTIMIZE_TEXT39 = "Người nhận không thể bỏ trống",
OPTIMIZE_TEXT40 = "Số điện thoại không thể bỏ trống",
OPTIMIZE_TEXT41 = "Hãy nhập số điện thoại chính xác",
OPTIMIZE_TEXT42 = "Đia chỉ không thể bỏ trống",
OPTIMIZE_TEXT43 = "Cần điền đầy đủ thông tin",
OPTIMIZE_TEXT44 = "Số lượng không đủ",
OPTIMIZE_TEXT45 = "Thông tin đổi không đầy đủ",
OPTIMIZE_TEXT46 = "Hãy xác nhận thông tin là chính xác, nếu không sẽ không nhận được quà",

YOUWAN_TEXT8 = "Chính sách quyền riêng tư người vị thành niên",
YOUWAN_TEXT9 = "Cần chấp nhận bản điều khiển sử dụng, chính sách quyền riêng tư trước",
CANT_IN = "Không thể vào",
PETNOTUPONE = "Pet hiện có thể gộp không đủ để lên cấp",

YOUWAN_TEXT10 = "Chính sách quyền riêng tư kênh phân phối",
YOUWAN_TEXT11 = "Cần chấp nhận bản điều khiển sử dụng, chính sách quyền riêng tư trước",

PETNOTUPONE2 = "Hiện Pet đã tăng đến cấp tối đa",
PETNOTUPONE3 = "Nhập số lượng (Lần này tối đa %d)",

PROFESSION_TWO1 = "CS1",
PROFESSION_TWO2 = "CS2",
PROFESSION_TWO3 = "Cần kích hoạt tất cả Thiên Phú CS1",
PROFESSION_TWO4 = "Pha Lê Năng Lượng",
PROFESSION_TWO5 = "Tổ hợp 2 Pha Lê Năng Lượng có thể kích hoạt năng lực đặc biệt",
PROFESSION_TWO6 = "Chuyển Đổi",
PROFESSION_TWO7 = "Thư Viện Pha Lê",
PROFESSION_TWO8 = "Tổ Hợp: ",
PROFESSION_TWO9 = [[<T C="127,70,26" S="24" P="0">Xác nhận tạo mới Thiên Phú? </T><BR>10</BR><T C="127,70,26" S="24" P="0">Tốn %d</T> <I Z="0.5" P="0">%s</I><T C="127,70,26" S="24" P="0">, hoàn trả %d%%</T> <I Z="0.5" P="0">%s</I>]],
PROFESSION_TWO10 = [[<T C="127,70,26" S="24" P="0">Xác nhận tạo mới Thiên Phú? (Lần này miễn phí)</T><BR>10</BR><T C="127,70,26" S="24" P="0">, hoàn trả %d%%</T> <I Z="0.5" P="0">%s</I>]],
PROFESSION_TEXT17 = [[<T C="127,70,26" S="24" P="0">Từ bỏ hệ hiện tại? </T><BR>10</BR><T C="127,70,26" S="24" P="0">Tốn %d</T> <I Z="0.5" P="0">%s</I><T C="127,70,26" S="24" P="0">, hoàn trả %d%%</T> <I Z="0.5" P="0">%s</I> <T C="127,70,26" S="24" P="0">%s, hoàn trả %d%%</T> <I Z="0.5" P="0">%s</I> <T C="127,70,26" S="24" P="0">%s</T>]],
PROFESSION_TWO11 = [[<T C="127,70,26" S="24" P="0">Chuyển Đổi Pha Lê cần tốn </T>]],
PROFESSION_TWO12 = [[<T C="127,70,26" S="24" P="0">, xác nhận Chuyển Đổi?</T>]],
PROFESSION_TWO13 = [[<T C="255,236,193" S="22" P="0">Cần tăng cấp Pha Lê</T>]],
PROFESSION_TWO14 = "Chuyển đổi thành công",
PROFESSION_TWO15 = "Chuyển đổi",
PROFESSION_TWO16 = "Kích hoạt",
PROFESSION_TWO17 = "Tăng cấp",
COMMUNITYINFO239 = "Học %d lần",
STAR_SOUL_FIVE_UPDATE = "Tăng %d cấp",
MOUNT_UP_LOG5 = [[<T C="195,171,148" S="20" P="0">Tăng cấp lần %d, %d->%d, tốn %d Vàng, tốn %d Hồn</T>]],
MOUNT_UP_LOG6 = [[<T C="195,171,148" S="22" P="0">Tăng cấp %d lần, tốn %d Vàng, %d Hồn </T>]],
MOUNT_UP_LOG7 = [[<T C="195,171,148" S="18" P="0">Học lần thứ %d, %d->%d, tốn %d Vàng, tốn %d Cống Hiến</T>]],
MOUNT_UP_LOG8 = [[<T C="195,171,148" S="22" P="0">Học %d lần, tốn %d Vàng, %d Cống Hiến </T>]],
MOUNT_UP_LOG9 = "Nhật Ký Học",

FOURSTAR_TEXT1 = [[
<T C="255,255,255" S="22" P="1">[Tứ Tượng]</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">1.</T><T C="244,190,100" S="20">Cần chọn phần thưởng trước khi rút. Đến chỗ Xe Hàng nhận Lệnh Triệu Hồi, mỗi lần gọi cần tốn 1 Lệnh, nhận thưởng ngẫu nhiên. Mỗi lần gọi sẽ có cơ hội nhận mảnh Tứ Tượng.</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1">Triệu hồi mỗi ngày sẽ nhận thưởng khi đạt mốc. Sang ngày mới sẽ reset từ đầu, hãy chú ý.</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1">Ghép đủ mảnh tứ tượng sẽ nhận thưởng hấp dẫn. Khi hoạt động kết thúc sẽ không phát thưởng bù, hãy nhận thưởng kịp thời.</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1">Tham gia triệu hồi sẽ tích luỹ số lần triệu hồi để tính BXH. Bao gồm BXH Triệu Hồi (tính theo số lần triệu hồi) và BXH Ghép Mảnh ( Tính theo số mảnh nhận được).</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">Khi kết thúc hoạt động, Lệnh Triệu Hồi và Mảnh Tứ Tượng sẽ bị xoá.</T><BR>10</BR>
]],
FOURSTAR_TEXT2 = "Kho Thưởng Cấp A",
FOURSTAR_TEXT3 = "Kho Thưởng Cấp S",
FOURSTAR_TEXT4 = "Có thể chọn 2 phần thưởng",
FOURSTAR_TEXT5 = "Chọn Lại",
FOURSTAR_TEXT6 = "Gọi hôm nay: ",
FOURSTAR_TEXT7 = "Lệnh Gọi: ",
FOURSTAR_TEXT8 = "Gọi",
FOURSTAR_TEXT9 = "Chọn Thưởng",
FOURSTAR_TEXT10 = " (Có thể chọn 2 phần thưởng)",
FOURSTAR_TEXT11 = "Số lần tạo mới: ",
FOURSTAR_TEXT12 = "Mỗi Kho Thưởng chỉ được chọn 2 phần thưởng",
FOURSTAR_TEXT13 = "Cần chọn 2 phần thưởng cho mỗi Kho Thưởng",
FOURSTAR_TEXT14 = "Chọn thành công",
FOURSTAR_TEXT15 = [[<T C="255,236,193" S="30" P="1" SC="132,66,29" SS="4" SE="1">Nhận thưởng </T><T C="255,255,255" S="30" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,236,193" S="30" P="1" SC="132,66,29" SS="4" SE="1"></T>]],
FOURSTAR_TEXT16 = {"Thanh Long","Bạch Hổ","Chu Tước","Huyền Vũ"},
FOURSTAR_TEXT17 = "Lệnh Gọi không đủ, có thể nhận từ chỗ Bánh Kem",
FOURSTAR_TEXT18 = "Mở",
FOURSTAR_TEXT19 = "Mảnh Thanh Long: ",
FOURSTAR_TEXT20 = "Mảnh Bạch Hổ: ",
FOURSTAR_TEXT21 = "Mảnh Chu Tước: ",
FOURSTAR_TEXT22 = "Mảnh Huyền Vũ: ",
FOURSTAR_TEXT23 = "Thưởng Thư Viện",
FOURSTAR_TEXT24 = "BXH Triệu Hồi",
FOURSTAR_TEXT25 = "BXH Ghép Mảnh",
FOURSTAR_TEXT26 = [[<T C="255,236,193" S="30" P="1" SC="132,66,29" SS="4" SE="1">Nhận mảnh</T>]],
FOURSTAR_TEXT27 = [[<T C="255,236,193" S="30" P="1" SC="132,66,29" SS="4" SE="1">Chúc mừng nhận được phần thưởng thêm</T>]],
FOURSTAR_TEXT28 = "Lần lượt hiển thị người chơi Top %d",
FOURSTAR_TEXT29 = [[<T C="255,236,193" S="20" P="1">Đã kêu gọi: </T><T C="255,255,255" S="20" P="1">%d lần</T>]],
FOURSTAR_TEXT30 = [[<T C="255,236,193" S="20" P="1">Số Mảnh: </T><T C="255,255,255" S="20" P="1">%d</T>]],
FOURSTAR_TEXT31 = [[<T C="255,236,193" S="20" P="1">Hạng: </T><T C="255,255,255" S="20" P="1">%d</T>]],
FOURSTAR_TEXT32 = "Lệnh Gọi không đủ! Hãy đến chỗ Xe Đẩy Nhỏ nhận Lệnh Gọi nhé!",
FOURSTAR_TEXT33 = "Thông tin hoạt động đã có thay đổi, hãy tải lại giao diện rồi thử lại sau!",
FOURSTAR_TEXT34 = [[<T C="255,236,193" S="30" P="1" SC="132,66,29" SS="4" SE="1">Nhận thưởng</T>]],
FOURSTAR_TEXT35 = [[Nhận "Mảnh %s"]],
MARRY_DESC_16 = "Bắt đầu Hôn Lễ",
MARRY_DESC_17 = "Ăn tiệc cưới",
MARRY_DESC_18 = "Đợi hai bên tiến vào",
MARRY_DESC_19 = "Đợi cử hành hôn lễ",
MARRY_DESC_20 = "Đang cử hành hôn lễ",
MARRY_DESC_21 = "Đang trong tiệc cưới",
MARRY_DESC_22 = "Hôn Lễ bắt đầu",
MARRY_DESC_23 = "Chồng/Vợ của bạn đã yêu cầu mở Hôn Lễ,\nxác nhận mở Hôn Lễ?",
MARRY_DESC_24 = "Xác nhận bắt đầu",
MARRY_DESC_25 = "Chờ chút nữa",
MARRY_DESC_26 = "Bất ngờ nhận thêm thuộc tính tạm thời!",
MARRY_DESC_27 = "Đã dự tiệc cưới rồi",
MARRY_DESC_28 = "Không có quyền hạn",
MARRY_DESC_29 = "Bất ngờ nhận thêm xác suất Bạo Kích!",
MARRY_DESC_30 = "Niềm Vui Ngập Tràn",
MARRY_DESC_31 = "Hôn Lễ sắp kết thúc, bạn sắp được đưa về thành chính",
MARRY_DESC_32 = "Chồng/Vợ của bạn chưa có mặt, hiện chưa thể mở Hôn Lễ, mời ấy đến ngay nhé?",
MARRY_DESC_33 = "Thời gian duy trì kỹ năng vợ chồng",
RUNE_ATTR = "Thuộc tính Bùa",
PRACTICE_FIGHT = "Lực chiến Tu Luyện: ",
MOUNT_ATTR = "Thuộc tính Thú Cưỡi",
MOUNT_FIGHT = "Lực chiến Thú Cưỡi: ",
SPIRIT_ATTR = "Thuộc tính Hồn",
SPIRIT_FIGHT = "Lực chiến Hồn: ",
SHAPE_ATTR = "Thuộc tính Ảo Hóa",
FOOTMARK_ATTR = "Thuộc tính Vòng Sáng",
MOUNT_NUM = "Thú Cưỡi đã thu thập",
FOOTMARK_NUM = "Vòng Sáng đã thu thập",
SKIN_NUM = "Skin đã thu thập",
MARRY_DESC_34 = "Đối phương không trng phòng Hôn Lễ",
MARRY_DESC_35 = "Chồng/Vợ của bạn muốn chờ lát nữa mới mở Hôn Lễ",
MARRY_DESC_36 = {"Chúc mừng chúc mừng","Tân hôn vui vẻ","Trăm năm hạnh phúc","Chúc hai người mãi mãi hạnh phúc bên nhau","Đúng là xứng đôi vừa lứa","Cô dâu xinh gái, chú rể đẹp trai"},
MARRY_DESC_37 = "Hôm nay là ngày vui trọng đại, hãy cùng vỗ tay mừng đón cô dâu chú rể nào!",
CHECKOTHER13 = "Ảo Hóa",
MARRY_DESC_38 = {"Yêu thương là nhường nhịn, là khoan dung, là thật lòng.","Yêu thương là không quá trớn, không ngông nghênh, không áp đặt.","Đừng đòi bằng được lợi ích, đừng dễ bồng bột trút giận.","Đừng nhìn mãi cái xấu của người khác, đừng làm chuyện bất nghĩa, đừng quên chân lý trong lòng.","Khi gặp chuyện cần bao dung, cần tin tưởng, cần hi vọng.","Mọi chuyện chỉ cần kiên nhẫn, tình yêu sẽ được vĩnh hằng.","Tôi tuyên bố, hai người chính thức trở thành vợ chồng!"},
MARRY_DESC_39 = "Quay về bản đồ",
MARRY_DESC_40 = "Chồng/Vợ của bạn mời bạn trở về bản đồ tiệc cưới, đi ngay không?",
MARRY_DESC_41 = "Chồng/Vợ của bạn nhắn lát nữa sẽ về",
LevelAndNameFormat2 = [[<T S="24" C="158,0,0"  P="0">Lv%d</T><BL>10</BL><I Z="1" P="0">ui/common/common_icon_kuafu.png</I><T S="24" C="79,60,48" P="0">%s</T>]],
RESIDUAL_EXCHANGE = [[<T C="127,70,26" S="18" P="1">Còn được đổi: </T><T C="255,105,22" S="18" P="1">%d/%d</T>]],
DAY_LIMIT = [[<T C="127,70,26" S="18" P="1">Mỗi Ngày: </T><T C="255,105,22" S="18" P="1">%d/%d</T>]],
TOTAL_LIMIT = [[<T C="127,70,26" S="18" P="1">Toàn sự kiện: </T><T C="255,105,22" S="18" P="1">%d/%d</T>]],
EXCEED_GEMUPGRADE = "EXP đã vượt quá mức cần để lên cấp, hãy tăng cấp trước đã",
NOTCHOOSE_GEMUPGRADE = "Hiện tại không còn đá cấp thấp có thể chọn nhanh",
CONSUME_RANK = "BXH Tiêu Phí",

BLIND_TEXT1 = "Hộp Bí Ẩn",
BLIND_TEXT2 = {"Số lần kích hoạt hôm nay:", "Mở %d", "Mở thêm %di"},
BLIND_TEXT3 = [[
<T C="255,255,255" S="22" P="1">[Hộp Bí Ẩn]</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1">Mở Hộp Bí Ẩn có thể nhận số lần mở chỉ định, mỗi lần mở chắc chắn nhận được một phần thưởng.</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1">Số lần mở hôm nay: Mỗi giai đoạn có thể hoàn thành và nhận thưởng một lần. Số liệu mỗi ngày sẽ được xóa vào hôm sau, hãy nhận thưởng kịp thời.</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1">BXH: Xếp hạng theo số lần mở Hộp Bí Ẩn, Top 50 người chơi có thể nhận thưởng hấp dẫn.</T><BR>10</BR>
]],
BLIND_TEXT4 = "Mở Hộp Bí Ẩn",
BLIND_TEXT5 = "%s kích hoạt",
BLIND_TEXT6 = [[<T C="127,70,26" S="18" P="1">Còn được mở </T><T C="229,105,22" S="18" P="1">%d/%d</T><T C="127,70,26" S="18" P="1"> lần</T>]],
BLIND_TEXT7 = [[<T C="127,70,26" S="20" P="1">Kích hoạt có thể mở </T><T C="229,105,22" S="20" P="1">%d</T><T C="127,70,26" S="20" P="1"> lần</T>]],
BLIND_TEXT8 = "Số lần mở hộp",
BLIND_TEXT9 = "Số lần kích hoạt không đủ",
BLIND_TEXT10 = "Đang mở, xin chờ",
BLIND_TEXT11 = "Có muốn biết bên trong có gì không nào?",
BLIND_TEXT12 = [[<T C="127,70,26" S="18" P="1">Mỗi ngày giới hạn mua </T><T C="229,105,22" S="18" P="1">%d/%d</T><T C="127,70,26" S="18" P="1"> lần</T>]],
KID_TEXT124 = "Tên không được giống nhau",
KID_TEXT125 = "Tên không được để trống",
KID_TEXT126 = "Tên quá dài",
KID_TEXT127 = "Chưa nhận hết thư",
KID_TEXT128 = "Nguyên liệu đổi giới tính không đủ",
CHANGESEX10 = [[<T C="79,60,48" S="20" P="1">Cần nhận hết thư trước khi đổi giới tính </T><T C="%s" S="20" P="1">%s</T>]],

DIGGEM_TEXT45 = "Hôn Gió",
DIGGEM_TEXT46 = "Cho Ăn",
DIGGEM_TEXT47 = "Đánh Đòn",
DIGGEM_TEXT48 = " +%d điểm tâm trạng",
DIGGEM_TEXT49 = " -%d điểm tâm trạng",
DIGGEM_TEXT50 = "Đang trộm mỏ...",
DIGGEM_TEXT51 = "Đánh đuổi",
DIGGEM_TEXT52 = "Di Tích",
DIGGEM_TEXT53 = "Đang thuê",
DIGGEM_TEXT54 = {" thuê bạn Đào Mỏ"," tặng bạn 1 nụ Hôn Gió"," cho bạn ăn Bánh Mì"," cho bạn ăn đòn"},
DIGGEM_TEXT55 = {"Mới","%s phút","%s giờ","%s ngày"},
DIGGEM_TEXT56 = [[<T C="127,70,26" S="20" P="0">Bạn thuê </T><T C="229,105,22" S="20" P="0">%s</T><T C="127,70,26" S="20" P="0">Đào Mỏ</T> <T C="229,105,22" S="20" P="0">%s</T>]],
DIGGEM_TEXT57 = [[<T C="229,105,22" S="20" P="0">%s</T><T C="127,70,26" S="20" P="0"> thuê bạn </T><T C="127,70,26" S="20" P="0">Đào Mỏ</T> <T C="229,105,22" S="20" P="0">%s</T>]],
DIGGEM_TEXT58 = [[<T C="229,105,22" S="20" P="0">%s</T><T C="127,70,26" S="20" P="0">tặng bạn 1 nụ Hôn Gió trong lúc thuê bạn Đào Bảo</T>]],
DIGGEM_TEXT59 = [[<T C="229,105,22" S="20" P="0">%s</T><T C="127,70,26" S="20" P="0"> cho bạn ăn Bánh Mì trong lúc thuê bạn Đào Bảo</T>]],
DIGGEM_TEXT60 = [[<T C="229,105,22" S="20" P="0">%s</T><T C="127,70,26" S="20" P="0"> cho bạn ăn đòn trong lúc thuê bạn Đào Bảo</T>]],
DIGGEM_TEXT61 = [[<T C="127,70,26" S="20" P="0">Thợ Mỏ tăng đến </T><T C="229,105,22" S="20" P="0">Lv%s</T>]],
DIGGEM_TEXT62 = [[<T C="127,70,26" S="20" P="0">Đến chỗ </T><T C="229,105,22" S="20" P="0">%s</T><T C="127,70,26" S="20" P="0"> trộm được </T><T C="229,105,22" S="20" P="0">%s</T>]],
DIGGEM_TEXT63 = [[<T C="229,105,22" S="20" P="0">%s</T><T C="127,70,26" S="20" P="0"> đến chỗ bạn </T><T C="127,70,26" S="20" P="0">trộm được </T><T C="229,105,22" S="20" P="0">%s</T>]],
DIGGEM_TEXT64 = [[<T C="127,70,26" S="20" P="0">Nhân Công </T><T C="229,105,22" S="20" P="0">%s</T><T C="127,70,26" S="20" P="0"> giúp bạn đào được thêm </T><T C="229,105,22" S="20" P="0">%s</T>]],
DIGGEM_TEXT65 = "Đánh đuổi thành công",
DIGGEM_TEXT66 = "Hãy bắt đầu Đào Bảo",
DIGGEM_TEXT67 = "Bạn bè này đã được thuê rồi",
DIGGEM_TEXT68 = [[<T C="127,70,26" S="20" P="0">Rất tiếc, Nhân Công </T><T C="229,105,22" S="20" P="0">%s</T><T C="127,70,26" S="20" P="0"> không đào được gì cả</T>]],
DIGGEM_TEXT69 = "Tâm trạng người chơi đạt tối đa",
DIGGEM_TEXT70 = "Tối đa được thuê 2 người",
DIGGEM_TEXT71 = "Bận",

ATTR_FIGHT = [[<T C="127,70,26" S="20" >Lực chiến thuộc tính</T><T C="229,105,22" S="20" >   %d</T>]],


UPLOAD_IMAGE_PERMISSION = "Upload hình ảnh cần dùng đến quyền này. Do bạn đã từ chối cấp quyền, hãy vào phần thiết lập trên thiết bị để cấp quyền truy cập bộ nhớ và máy ảnh cho trò chơi.",

NEWVIP_TEXT1 = {"Nạp","Ruby","Đặc Quyền VIP","Phúc Lợi VIP","Huy Chương VIP"},
NEWVIP_TEXT2 = {"Hoàn Trả","Quà Tuần","Quà"},
NEWVIP_TEXT3 = "BXH Xạ Thủ VIP",
NEWVIP_TEXT4 = "Tăng bậc Phúc Lợi VIP%d",
NEWVIP_TEXT5 = "Phúc Lợi VIP %d",
NEWVIP_TEXT6 = "VIP",
NEWVIP_TEXT7 = [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">Nạp thêm </T><T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1"> Kim Cương sẽ tăng đến </T><T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">VIP%d</T>]],
NEWVIP_TEXT8 = [[<T C="255,236,193" S="22" P="1" SC="132,66,29" SS="4" SE="1">Đã đạt cấp tối đa</T>]],
NEWVIP_TEXT9 = "Đang cập nhật",
NEWVIP_TEXT10 = "Cấp tối thiểu",
NEWVIP_TEXT11 = "Phúc Lợi VIP",
NEWVIP_TEXT12 = {"BXH Xạ Thủ","Thưởng","Quán Quân Các Đời"},
NEWVIP_TEXT13 = "Điểm VIP",
NEWVIP_TEXT14 = "Điểm VIP: ",
NEWVIP_TEXT15 = "Thưởng được gửi qua thư",
NEWVIP_TEXT16 = "Cấp Huy Chương",
NEWVIP_TEXT17 = "Xem tất cả thưởng",
NEWVIP_TEXT18 = "Điểm Huy Chương: ",
NEWVIP_TEXT19 = [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">Nạp thêm </T><T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1"> Kim Cương sẽ tăng đến </T>]],
NEWVIP_TEXT20 = "00:00 %s-%s (tháng này) sẽ kết thúc", 
NEWVIP_TEXT21 = "Thưởng hạng %s-%s",
NEWVIP_TEXT22 = [[<T C="127,70,26" S="22" P="1">Được thích </T><T C="229,105,22" S="22" P="1">%d</T><T C="127,70,26" S="22" P="1"> lần</T>]],
NEWVIP_TEXT23 = "Lần %s",
NEWVIP_TEXT24 = "Thưởng Lv%d",
NEWVIP_TEXT25 = "Thưởng Huy Chương",
NEWVIP_TEXT26 = "Đã nhận qua rồi",
NEWVIP_TEXT27 = "Đặc quyền VIP %d",
NEWVIP_TEXT28 = "Toàn là thứ xịn!",
NEWVIP_TEXT29 = {{"Nhận thêm ô đạo cụ","Rèn được cường hóa 5 lần"},{"Vùng Mạo Hiểm được càn quét 10 lần","Bao gồm tất cả đặc quyền VIP1","Sử dụng Chat Voice kênh Thế Giới"},{"Được chọn ghép nhanh","Bạn bè tối đa +30 người"},{"Được dùng nhanh Mèo Chiêu Tài","Quà tặng Cửa Hàng"},{"Phó Bản Nhóm được lật thẻ thêm","Bạn bè tối đa +20 người"},{"Thú cưỡi","Vịt Vàng"},{"Bao gồm tất cả đặc quyền VIP6","Bạn bè tối đa +20 người"},{"Cánh Thánh Quang"},{"Hình nền dành riêng","Ảo Cảnh Không Gian được mua 9 lần"},{"Bạn bè tối đa 200 người","Bao gồm tất cả đặc quyền VIP9"},{"Bạn bè tối đa 210 người","Bao gồm tất cả đặc quyền VIP10"},{"Hình nền dành riêng"},{"Cánh Đặc Biệt"},{"VIP14"},{"VIP15"},{"VIP16"},{"Đang cập nhật các quyền khác"},{"Đang cập nhật các quyền khác"},{"Đang cập nhật các quyền khác"},{"Đang cập nhật các quyền khác"}},
NEWVIP_TEXT30 = "Thời Trang VIP %d",
NEWVIP_TEXT31 = "Nội dung Quà VIP",
NEWVIP_TEXT32 = "Nội dung Phúc Lợi Tuần VIP",
NEWVIP_TEXT33 = "Vòng Sáng Đặc Biệt VIP %d",
NEWVIP_TEXT34 = "Thú Cưỡi Đặc Biệt VIP %d",
NEWVIP_TEXT35 = "Vũ Khí Đặc Biệt VIP %d",
NEWVIP_TEXT36 = "Skin Đặc Biệt VIP %d",
NEWVIP_TEXT37 = "Cánh Đặc Biệt VIP %d",
CHANGESEX12 = [[Cần tháo hết Thời Trang con đang mặc mới có thể đổi giới tính]],
CHANGESEX11 = 
[[
<T C="79,60,48" S="20" P="1">Đổi giới tính phải đạt điều kiện sau: </T><BR>5</BR>
<T C="79,60,48" S="20" P="1">1. Con cần tháo hết Thời Trang </T><T C="%s" S="20" P="1">%s</T><BR>5</BR>
<T C="79,60,48" S="20" P="1">2. Đã nhận hết đính kèm trong thư </T><T C="%s" S="20" P="1">%s</T><BR>5</BR>
]],
CHANGESEX13 = "Cần tháo hết Thời Trang con đang mặc mới có thể đổi giới tính",
CHANGESEX14 = "Con đã thỏa mãn yêu cầu đổi giới tính, xác nhận đổi giới tính ngay?",

BACKGROUND_MEDAL1 = "Hình nền này dành cho Huy Chương Lv%d, tăng cấp Huy Chương ngay?",
BACKGROUND_MEDAL2 = "Dành cho Huy Chương Lv%d",
NON_COMPLIANT = "Nội dung đang nhập chứa ký tự không hợp lệ",

UPLOAD_IMAGE_PERMISSION_1 =  "Upload Avatar cần có quyền truy cập máy ảnh và bộ nhớ. Bạn đã cấp quyền cho máy ảnh nhưng từ chối cấp quyền cho bộ nhớ, hệ thống không thể tải ảnh chính xác! Hãy vào phần thiết lập trên thiết bị và cấp quyền truy cập bộ nhớ cho trò chơi nhé!",
PROFESSION_NAME = {{"Chiến Sĩ · CS1","Chiến Sĩ · CS2"},{"Sát Thủ · CS1","Sát Thủ · CS2"},{"Phù Thủy · CS1","Phù Thủy · CS2"}},
BACKGROUND_MEDAL3 = "Hình nền này %s, đến nhận ngay không?",
BACKGROUND_MEDAL4 = {"Dành cho BXH Xạ Thủ", "Dành cho hoạt động"},
GEM_MOUNTING_text1 ="Chọn đạo cụ lên cấp: ",
DELETE_ACCOUNT_TEXT1="Xoá tài khoản",
DELETE_ACCOUNT_TEXT2="Xoá thành công",
DELETE_ACCOUNT_TEXT3="Thất bại, xin thử lại",
PHANTOM_NEWTEXT42 = "Skin trải nghiệm, không thể luyện hóa được",
TEACH_SKIP_TEXT1 = "Bỏ Qua Hướng Dẫn",
TEACH_SKIP_TEXT2 = "Bỏ qua sẽ không thể xem lại hướng dẫn tân thủ. Bạn chắn chắn bỏ qua hướng dẫn chứ?",


EQUIPMENT_DRAW_EXPLAIN1 =
[[
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Dùng Xu Vàng triệu hồi đủ 10 lần chắc chắn nhận 1 trang bị tím trong kho thưởng tự chọn</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Triệu hồi đủ 100 lần chắc chắn nhận thêm 200 Huy Hiệu Ngôi Sao, dùng đổi ở tiệm Huy Hiệu.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Mỗi 4 tiếng sẽ nhận được vé triệu hồi miễn phí, dùng vé triệu hồi không được tính vào tiến độ nhận thưởng.</T><BR>10</BR>
]],
EQUIPMENT_DRAW_EXPLAIN2 =
[[
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Dùng Xu Vàng triệu hồi đủ 10 lần chắc chắn nhận 1 Pet cấp 1 trong kho thưởng bên phải.</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Triệu hồi đủ 100 lần chắc chắn nhận thêm 200 Huy Hiệu Ngôi Sao, dùng đổi ở tiệm Huy Hiệu.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Mỗi 4 tiếng sẽ nhận được vé triệu hồi miễn phí, dùng vé triệu hồi không được tính vào tiến độ nhận thưởng.</T><BR>10</BR>
]],
EQUIPMENT_DRAW_EXPLAIN3 =
[[
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Dùng Xu Vàng triệu hồi ngẫu nhiên nhận thưởng trong kho, tích lũy đủ 10 lần chắc chắn nhận 1 Thú Cưỡi Cam trong kho thưởng bên phải. </T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Triệu hồi đủ 100 lần chắc chắn nhận thêm 200 Huy Hiệu, dùng đổi thưởng ở tiệm Huy Hiệu.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Bất kỳ khi nào nếu triệu hồi trúng thú cưỡi đã sở hữu sẽ hoàn trả 200 Huy Hiệu. </T><BR>10</BR>
]],
EQUIPMENT_DRAW_EXPLAIN4 =
[[
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Dùng Xu Vàng triệu hồi ngẫu nhiên nhận thưởng trong kho, tích lũy đủ 10 lần chắc chắn nhận 1 Skin Cam trong kho thưởng bên phải.</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Triệu hồi đủ 100 lần chắc chắn nhận thêm 200 Huy Hiệu, dùng đổi thưởng ở tiệm Huy Hiệu.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Bất kỳ khi nào nếu triệu hồi trúng Skin đã sở hữu sẽ hoàn trả 200 Huy Hiệu. </T><BR>10</BR>
]],
EQUIPMENT_DRAW_EXPLAIN5 =
[[
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Dùng Xu Vàng triệu hồi ngẫu nhiên nhận thưởng trong kho, tích lũy đủ 10 lần chắc chắn nhận 1 Dấu Chân Cam trong kho thưởng bên phải. </T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Triệu hồi đủ 100 lần chắc chắn nhận thêm 200 Huy Hiệu, dùng đổi thưởng ở tiệm Huy Hiệu.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Bất kỳ khi nào nếu triệu hồi trúng Dấu Chân đã sở hữu sẽ hoàn trả 200 Huy Hiệu. </T><BR>10</BR>
]],
NEWYEAR_TEXT12 = "Số lần còn:",
NEWYEAR_TEXT24 = [[
<T C="229,105,22" S="20" P="1">Điểm danh Sinh Nhật</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">Trong hoạt động, đăng nhập mỗi ngày được nhận thưởng</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">Hoạt động lần này không có điểm danh bù, hãy nhớ đăng nhập mỗi ngày</T><BR></BR>
]],
NEWYEAR_TEXT25 = [[<T C="255,236,193" S="22" P="1" SC="132,66,29" SS="4" SE="1">Gặp may mắn,</T><T C="255,255,255" S="22" P="1" SC="132,66,29" SS="4" SE="1"> nhận thưởng lớn</T>]],
NEWYEAR_TEXT26 = "Bắn Pháo Hoa 1 lần",
NEWYEAR_TEXT27 = "Bắn Pháo Hoa 10 lần",
NEWYEAR_TEXT28 = "BXH Cầu Phúc",
NEXT_TIME = "Ải kế %ds",
NEXT_TIME1 = "Ải kế 5s",

PHANTOM_EQUIPMENT1 = "Trang bị Ảo Hóa",
PHANTOM_EQUIPMENT2 = "Nón",
PHANTOM_EQUIPMENT3 = "Áo",
PHANTOM_EQUIPMENT4 = "Quần",
PHANTOM_EQUIPMENT5 = "Giày",
PHANTOM_EQUIPMENT6 = "Đúc Lại",
PHANTOM_EQUIPMENT7 = "Kích hoạt %s skin vĩnh viễn mới được mặc trang bị %s",
PHANTOM_EQUIPMENT8 = {"Trắng","Lục","Lam","Tím","Cam","Đỏ","Màu"},
PHANTOM_EQUIPMENT9 = "Đúc lại tốn: ",
PHANTOM_EQUIPMENT10 = "Tối đa có thể chọn %d món trang bị",
PHANTOM_EQUIPMENT11 = "Lấy ra",
PHANTOM_EQUIPMENT12 = "Cần 3 món trang bị giống nhau mới có thể ghép",
PHANTOM_EQUIPMENT13 = "Ngẫu nhiên nhận 1 %s %s",
PHANTOM_EQUIPMENT14 = "Cần 2 trang bị Ảo Hóa trở lên mới có thể đúc lại",
PHANTOM_EQUIPMENT15 = "Thu thập Thư Viện",
PHANTOM_EQUIPMENT16 = [[<T C="229,105,22" S="22">Quy tắc ghép</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. Có thể ghép 3 món trang bị giống nhau để nhận trang bị cùng vị trí cùng loại có phẩm chất cao hơn</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. Tinh hoa trang bị có thể dùng thay thế trang bị có phẩm chất tinh hoa trang bị tương đồng để tiến hành ghép</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. Ba kết tinh trang bị cùng phẩm chất có thể ghép tinh hoa trang bị phẩm chất cao hơn</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. Kết tinh trang bị Đỏ và Nhiều Màu không thể làm nguyên liệu ghép</T><BR></BR>
]],
PHANTOM_EQUIPMENT17 = [[ <T C="229,105,22" S="22">Quy tắc đúc lại</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. Dùng 2 hoặc 3 trang bị cùng vị trí và phẩm chất có thể tiến hành đúc lại</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. Đúc Lại trang bị có thể nhận nhận được loại trang bị  ngẫu nhiên, cùng vị trí, cùng phẩm chất với trang bị gốc</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. Khi dùng 3 món trang bị tiến hành đúc lại sẽ có xác suất nhận kết tinh trang bị cùng phẩm chất chứ không phải trang bị</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. Kết tinh trang bị không thể dùng đúc lại</T><BR></BR>
]],
PHANTOM_EQUIPMENT18 = [[<T C="255,89,74" S="20" P="0">Toàn thân mang trang bị %s (</T><T C="%s" S="20" P="0">%d</T><T C="255,89,74" S="20" P="0">/%d)</T>]],
PHANTOM_EQUIPMENT19 = "Toàn thuộc tính",
PHANTOM_EQUIPMENT23 = [[ <T C="229,105,22" S="22">Trang bị Ảo Hóa</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. Mỗi người chơi chỉ mang được 1 bộ trang bị ảo hóa.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. Có thể thông qua ghép và đúc lại để nhận vật phẩm có phẩm chất cao hơn.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. Mang trang bị theo bộ sẽ kích hoạt hiệu quả thuộc tính cao cấp.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. Thuộc tính cộng thêm có hiệu quả với bộ trang bị đang mặc. </T><BR></BR>
<T C="229,105,22" S="20" P="0">5. Thu thập trọn 1 bộ trang bị sẽ được nhận thêm phần thưởng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">6. Có thể ghép 3 món trang bị giống nhau cùng phẩm chất để đạt phẩm cao hơn</T><BR></BR>
<T C="229,105,22" S="20" P="0">7. Có thể đục 2 hoặc 3 trang bị cùng loại (ví dụ: Giày Trắng+ Giày Trắng) để nhận 1 trang bị cùng loại (Giày Trắng) khác. Nếu dùng 3 nguyên liệu để đúc có thể nhận được phôi, dùng để thay thế bất kỳ trang bị nào khi ghép.</T><BR></BR>
]],
ASSIST_SKILL1 = "Kèm kỹ năng",
ASSIST_SKILL2 = "Kèm đạo cụ",
ASSIST_SKILL3 = "Mở khóa Con",
ASSIST_SKILL4 = "Mở khóa thú cưỡi",
ASSIST_SKILL5 = "Chọn ra trận con cái",
ASSIST_SKILL6 = "Chọn ra trận thú cưỡi",
ASSIST_SKILL7 = "Hãy cho ra trận con cái",
ASSIST_SKILL8 = "Bạn chưa có con",
ASSIST_SKILL9 = "Bạn vẫn chưa có thú cưỡi để ra trận'",
ASSIST_SKILL10 = "Hãy cho ra trận ",
ASSIST_SKILL11 = "Tụ lực: ",
ASSIST_SKILL12 = "Hãy cho ra trận thú cưỡi",
ASSIST_SKILL13 = [[
<T C="229,105,22" S="20" P="0">1. Kỹ năng hỗ trợ bao gồm kỹ năng Con và kỹ năng Thú Cưỡi.</T><BR>5</BR>
<T C="229,105,22" S="20" P="0">2. Con cấp càng cao sẽ mang được càng nhiều ô kỹ năng. Cấp nông trại càng cao sẽ mở khóa càng nhiều ô kỹ năng.</T><BR>5</BR>
<T C="229,105,22" S="20" P="0">3. Để nhận kỹ năng con, cần tham gia trường học, để nhận kỹ năng thú cưỡi, cần xây nông trại trong Chung Cư.</T><BR>5</BR>
<T C="229,105,22" S="20" P="0">4. Sau khi nhận đạo cụ kỹ năng từ tính năng Nông Trại và Trường Học, cần trang bị vào ô mới có thể mang vào trận đấu.</T><BR>5</BR>
<T C="229,105,22" S="20" P="0">5. Mỗi lần dùng kỹ năng trong trận sẽ mất 1 lần, cần thu thập lại ở trường và nông trại.</T><BR>5</BR>
<T C="229,105,22" S="20" P="0">6. Con cái khi dùng kỹ năng sẽ cần tụ lực thời gian ngắn. Trong thời gian này hãy chú ý bảo vệ.</T><BR>5</BR>
<T C="229,105,22" S="20" P="0">7. Tuổi Con càng cao, sát thương càng cao.</T><BR>5</BR>
<T C="229,105,22" S="20" P="0">8. Mẹo: Nâng cấp trường học với nhiều thành viên và cấp nông trại càng cao, số lượng kỹ năng nhận được mỗi giờ càng nhiều.</T><BR>5</BR>
]],
ACTIVITY_TEXT1 = "Xu Lắc Thưởng: ",
ACTIVITY_TEXT2 = "Lắc Thưởng 1 lần",
ACTIVITY_TEXT3 = "Lắc Thưởng 5 lần",
ACTIVITY_TEXT4 = "Nhiệm Vụ Lắc Thưởng",
ACTIVITY_TEXT5 = "Tiệm Lắc Thưởng",
ACTIVITY_TEXT6 = "BXH",
ACTIVITY_TEXT7 = "Xu Lắc Thưởng không đủ",
ACTIVITY_TEXT8 = "Số lần rút thưởng",
ACTIVITY_TEXT9 = "Mảnh: ",
ACTIVITY_TEXT11 = "Tạm không có nhiệm vụ",
ACTIVITY_TEXT12 = "Xu Lắc Thưởng không đủ, hãy đến chỗ Xe Đẩy Nhỏ để nhận",
ACTIVITY_TEXT13 = "Lắc Thưởng miễn phí",
ACTIVITY_TEXT14 = "Giới hạn hôm nay",
ACTIVITY_TEXT15 = "Tổng giới hạn",
ACTIVITY_TEXT16 = {"","Số lượng Mảnh không đủ","Vượt quá tổng giới hạn mua","Vượt quá giới hạn mua hôm nay"},
ACTIVITY_TEXT17 = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">Thật là may mắn,</T><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1"> đã trúng %s</T>]],
ACTIVITY_TEXT18 = "Thưởng giải nhất",
ACTIVITY_TEXT19 = "Thưởng đặc biệt",
PHANTOM_EQUIPMENT20 = "Lực chiến trang bị Ảo Hóa: ",
PHANTOM_EQUIPMENT21 = "Thuộc tính trang bị Ảo Hóa",
PHANTOM_EQUIPMENT22 = "Đúc lại lần này sẽ dùng %d món%s trang bị tiến hành đúc lại, đồng ý",
ACTIVITY_TEXT20 = "Đang rút thưởng, đừng nhấp chọn nhiều lần!",
GOODFULL_TOY = {"Toàn bộ Tính Năng","Tính Năng Mạo Hiểm","Tính Năng Khiêu Chiến","Tính Năng Đấu Trường"},
GOODSFULL_TITLENAME1 = [[<T C="255,89,100" S="20" P="0">%s: %s + %s, %s + %s Khóa</T>]],
GOODSFULL_TITLENAME2 = [[<T C="99,200,95" S="20" P="0">%s:%s+%s,%s+%s Đã mở</T>]],
GOODSFULL_TITLENAME3 = [[<T C="255,89,100" S="20" P="0">%s: %s + %s Khóa</T>]],
GOODSFULL_TITLENAME4 = [[<T C="99,200,95" S="20" P="0">%s:%s+%s Đã mở</T>]],
GOODSFULL_TEXT = [[ <T C="229,105,22" S="22">Set trang bị</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. Nhận hết tất cả trang bị trong Set là có thể kích hoạt thuộc tính Set tương ứng</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. Thuộc tính Set cần vào tính năng hoặc phó bản tương ứng mới có hiệu lực.</T><BR></BR>
<T C="229,105,22" S="20" P="0">Tính Năng Mạo Hiểm: Phó Bản Cá Nhân, Phó Bản Nhóm, Bí Cảnh, Đất Cấm</T><BR></BR>
<T C="229,105,22" S="20" P="0">Khiêu Chiến: Tháp Thí Luyện/Ảo Cảnh Không Gian/BOSS Thế Giới/Lãnh Chúa Vực Sâu/Tháp Anh Hùng</T><BR></BR>
<T C="229,105,22" S="20" P="0">Đấu Trường: Đấu Điểm/Đấu Hạng/Đấu Giải Trí</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. Toàn bộ tức tất cả các tính năng trên đều có hiệu lực.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. Tăng thuộc tính chỉ có hiệu quả với thuộc tính chiến đấu, không tăng thuộc tính phạm vi.</T><BR></BR>
]],
ACTIVITY_TEXT21 = "Miêu tả đăng nhập giới hạn",
ACTIVITY_TEXT22 = "Ngày %s",
ACTIVITY_TEXT23 = "Hôm nay đã hết lượt, mai hãy cố gắng tiếp!",

NEWFIRSTCHARGE_TEXT1 = {"Nạp lần đầu","Thời Trang Đặc Biệt","Cánh Đặc Biệt"},
NEWFIRSTCHARGE_TEXT2 = {"Nạp xong có thể nhận","Có thể nhận","Đã nhận"},
NEWFIRSTCHARGE_TEXT3 = [[<T C="255,236,193" S="22" P="1" SC="132,66,29" SE="1" SS="4">Đã nạp </T><T C="255,227,116" S="20" P="1" SC="132,66,29" SE="1" SS="4">%d Kim Cương</T>]],
NEWFIRSTCHARGE_TEXT4 = "Hoàn thành tiến độ có thể nhận",
NEWFIRSTCHARGE_TEXT5 = "Không thể nhận",
TRANSACTION58 = "Rương Di Tích",
PASTURE_TEXT1 = "Nhật ký",
PASTURE_TEXT2 = "Chế tạo đạo cụ",
PASTURE_TEXT3 = "Giao Dịch",
PASTURE_TEXT4 = "Túi đạo cụ",
PASTURE_TEXT5 = "Đang chế tạo",
PASTURE_TEXT6 = {"Nông Trại","Xưởng"},
PASTURE_TEXT7 = "Tăng cấp Nông Trại: ",
PASTURE_TEXT8 = "Tiệm",
PASTURE_TEXT9 = "Thu thập thú nuôi",
PASTURE_TEXT10 = "Vào Nông Trại",
PASTURE_TEXT11 = "Trộm thú nuôi",
PASTURE_TEXT12 = "Bán thú nuôi",
PASTURE_TEXT13 = "Mua thú nuôi",
PASTURE_TEXT14 = "Bảo Vệ",
PASTURE_TEXT15 = "Số lượng chăn thả",
PASTURE_TEXT16 = "Bảo Vệ trông coi Nông Trại, có %s tỉ lệ ngăn cản thú nuôi bị trộm, đồng thời có thể tăng %s sản xuất thú nuôi chăn thả. Đồng ý trả %d %s thuê công nhân làm việc 24 giờ?",
PASTURE_TEXT17 = "Vị trí Nông Trại không đủ, hãy kéo thú nuôi tiến hành ghép",
PASTURE_TEXT18 = "Ghép thành công",
PASTURE_TEXT19 = "Ghép thất bại",
PASTURE_TEXT20 = "Nông Trại Bạn Bè",
PASTURE_TEXT21 = "Trộm",
PASTURE_TEXT22 = "Cấp Nông Trại: ",
PASTURE_TEXT23 = "Hãy chọn vật phẩm chế tạo",
PASTURE_TEXT24 = "Mở khóa thành công",
PASTURE_TEXT25 = "Hiệu quả hiện tại",
PASTURE_TEXT26 = "Không thể ít hơn 1",
PASTURE_TEXT27 = "Ở Nông Trại người khác không thể vào Xưởng",
PASTURE_TEXT28 = "Xác nhận mở khóa?",
PASTURE_TEXT29 = [[Đồng ý trả %d Kim Cương Khóa tăng tốc bàn làm việc 24 giờ. Tăng tốc xong thời gian chế tạo đạo cụ giảm %d%%]],
PASTURE_TEXT30 = "Số lượng chế tạo không thể vượt quá giới hạn tối đa",
PASTURE_TEXT31 = [[<T C="229,105,22" S="20" P="1">Nhân vật thu thập %d thú cưỡi</T>]],
PASTURE_TEXT32 = "Thời gian chế tạo mỗi đạo cụ ở Xưởng",
PASTURE_TEXT33 = "Tăng sản lượng Nông Trại",
PASTURE_TEXT34 = "Tăng số Xu Nông Trại",
PASTURE_TEXT35 = "Tăng EXP Nông Trại",
PASTURE_TEXT36 = "Tăng đạo cụ tinh hoa",
PASTURE_TEXT37 = "Ghép ngay?",
PASTURE_TEXT38 = [[<T C="127,70,26" S="24" P="1">Bán thú nuôi này có thể nhận </T><I Z="0.5">%s</I><T C="229,105,22" S="24" P="1">%d</T><T C="127,70,26" S="24" P="1">, đồng ý?</T>]],
PASTURE_TEXT39 = "Hoàn thành nhiệm vụ",
PASTURE_TEXT40 = {"Cần xây Nông Trại mới có thể trộm thú nuôi.","Hôm nay đã trộm rất nhiều thú nuôi rồi, mai hãy quay lại","Hôm nay đã trộm sạch người bạn này rồi, mai hãy quay lại","Người chơi bị trộm chưa mở Nông Trại","Người chơi này đã bị trộm nhiều lần rồi, không thể trộm nữa","Khi bạn trộm thú nuôi đã bị Bảo Vệ của đối phương phát hiện, trộm thất bại"},
PASTURE_TEXT41 = "Nông Trại của tôi",
PASTURE_TEXT42 = [[ giờ trước]],
PASTURE_TEXT43 =[[ phút trước]],
PASTURE_TEXT44 = [[<T C="127,70,26" S="20" P="1">%s %s, đã trộm được Pet của </T><T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1">: Lv%d %s</T>]],
PASTURE_TEXT45 = [[<T C="127,70,26" S="20" P="1">%s%s,</T><T C="229,105,22" S="20" P="1"> %s</T><T C="127,70,26" S="20" P="1"> đã trộm thú nuôi của bạn: Lv%d %s</T>]],
PASTURE_TEXT46 = "Mở khóa giống loài mới",
PASTURE_TEXT47 = "Mua nhanh",
PASTURE_TEXT48 = [[ <T C="229,105,22" S="22">Nông Trại Thú Cưng</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. Trong Nông Trại có thể thông qua chăn thả thú nuôi để nhận Xu Nông Trại, EXP Nông Trại, tinh hoa đạo cụ</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. Xu Nông Trại dùng để mua Thú Nuôi mới để ghép thành thú cao cấp, nhận sản lượng cao hơn</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. Tinh hoa đạo cụ dùng chế tạo đạo cụ hỗ trợ ở Xưởng, đạo cụ hỗ trợ dùng trong chiến đấu</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. EXP Nông Trại dùng tăng cấp Nông Trại, tăng cấp có thể nhận vị trí chăn thả, mở khóa đạo cụ mới, tăng cấp đạo cụ.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5. Kéo thú trong nông trại đến vị trí một thú khác cùng cấp, có thể ghép thành thú cao cấp hơn</T><BR></BR>
<T C="229,105,22" S="20" P="0">6. Kéo thú trong nông trại đến chỗ biểu tượng bán để bán nhận Xu Nông Trại</T><BR></BR>
]],
PASTURE_TEXT49 = [[<T C="255,255,255" S="24" P="1">Đã trộm được Pet của </T><T C="229,105,22" S="24" P="1">%s</T><T C="255,255,255" S="24" P="1">: Lv%d %s</T>]],
PASTURE_TEXT50 = "Đang bị trộm",
PASTURE_TEXT51 = "Nông Trại này tạm không có thú nuôi để trộm, hãy quay lại sau",
PASTURE_TEXT52 = [[<T C="229,105,22" S="20" P="1">Nhân vật kích hoạt thú cưỡi %s</T>]],
PASTURE_TEXT53 ="Nông Trại lần đầu ghép thú nuôi Lv%d %s sẽ mở khóa mua thú nuôi này",
PASTURE_TEXT54 = "Cần xây Nông Trại thú nuôi mới có thể thăm Nông Trại của bạn bè",
PASTURE_TEXT55 = [[<T C="127,70,26" S="20" P="1">%s%s, khi trộm thú nuôi của </T><T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"> bị Bảo Vệ phát hiện, trộm thất bại</T>]],
PASTURE_TEXT56 = "Nông Trại thú nuôi Lv.%d mở",
PASTURE_TEXT57 = "Dùng %s, nhận Xu Nông Trại x%d, EXP Nông Trại x%d, tinh hoa đạo cụ x%d",
PASTURE_TEXT58 = "Hãy xây Nông Trại ở Chung Cư Tình Yêu trước rồi dùng Đồng Hồ Cát Bội Thu",
PASTURE_TEXT59 = "Cấp thú nuôi trong Nông Trại đã cao hơn cấp thú nuôi có thể mua, hãy ghép thú nuôi trước",

MOUNTS_LOTTERY = "Gọi Thú Cưỡi",
PHANTOM_LOTTERY = "Nhận Skin",
FOOT_LOTTERY = "Nhận Vòng Sáng",
GOTO_MOUNT = "Đến Thú cưỡi",
GOTO_PHANTOM = "Đến Skin",
GOTO_FOOT = "Đến Vòng Sáng",
MOUNT_HANK = "Thư Viện Thú Cưỡi",
FOOT_HANK = "Thư Viện Dấu Chân",
PHANTOM_HANK = "Thư Viện Skin",
LOTTERY_STORE = "Tiệm Huy Hiệu",
CONSUME_DIOMAND = "Tốn Xu Bạc",
NEED_LOTTERY_REWARD = "Gọi thêm %d lần nhận 200 H.Hiệu",
GET_LOTTERY_REWARD = "Nhấp nhận thưởng",
LOTTERY_MOUNT = "Tích lũy triệu hồi bằng Xu Vàng đủ 10 lần chắc chắn nhận được Thú Cưỡi Cam ở kho thưởng bên phải./nNếu đã có, hoàn trả 200 Huy Hiệu Ngôi Sao",
LOTTERY_MOUNT1 = "Tích lũy triệu hồi bằng Xu Vàng đủ 10 lần chắc chắn nhận được 1 phần thưởng bên phải.",
LOTTERY_MOUNT2 = "Tích lũy triệu hồi bằng Xu Vàng đủ 10 lần chắc chắn nhận được 1 phần thưởng bên phải.",
LOTTERY_MOUNT3 = "Tích lũy triệu hồi bằng Xu Vàng đủ 10 lần chắc chắn nhận được Skin Cam ở kho thưởng bên phải./nNếu đã có, hoàn trả 200 Huy Hiệu Ngôi Sao",
LOTTERY_MOUNT4 = "Tích lũy triệu hồi bằng Xu Vàng đủ 10 lần chắc chắn nhận được Dấu Chân Cam ở kho thưởng bên phải./nNếu đã có, hoàn trả 200 Huy Hiệu Ngôi Sao",
LOTTERY_MOUNT5 = "Mỗi gọi 10 lần chắc chắn nhận được Thú Cưỡi Cam hoặc nguyên liệu Linh Thạch cao cấp",
LOTTERY_MOUNT6 = "Mỗi gọi 10 lần chắc chắn nhận được trang bị Skin Cam hoặc Tím",
LOTTERY_MOUNT7 = "Hướng dẫn rút thưởng Skin Kim Cương Khóa",
LOTTERY_REFRESH_TIME = "Tạo Mới Kho Thưởng",
CHOOSE_REWARD = "Quà tự chọn",
CHOOSE_REWARD_DESC = "Hãy chọn 1 phần thưởng sau",
QUICKCHAT_TEXT1 = "Phát ngôn nhanh",
QUICKCHAT_TEXT2 = "Nội dung sửa",
QUICKCHAT_TEXT3 = "Thiết lập nội dung phát ngôn nhanh: ",
QUICKCHAT_TEXT4 = "Có thể điều kiện nội dung phát ngôn nhanh tại Thành Chủ-Thiết lập",
QUICKCHAT_TEXT5 = "Nội dung phát ngôn không được vượt quá 12 ký tự",
QUICKCHAT_TEXT6 = "Trong thiết lập có thể sửa phát ngôn nhanh",
QUICKCHAT_TEXT7 = "Hãy nhập nội dung mới: ",
QUICKCHAT_TEXT8 = "Tối đa 24 ký tự",

GUIDE_TEXT1 = {"","Thủ Lĩnh Goblin đợi bạn đến chinh chiến!","Thầy Tế Anubis đang thực hiện âm mưu của nó!",},
GUIDE_TEXT2 = "Lv11 sắp mở khóa",
GUIDE_TEXT3 = "Pet mạnh mẽ, hỗ trợ bạn chiến đấu",
DIGGEM_TEXT72 = "Mua xong sẽ tự động giám định đạo cụ",
DIGGEM_TEXT73 = [[
<T C="229,105,22" S="22">Quy tắc mua</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Vật phẩm sau khi lên kệ phải được mua bởi người chơi khác mới có thể nhận Pha Lê</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Vật phẩm trong Giao Dịch đều do người chơi bày bán</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Những vật phẩm trên bảng sẽ được đề cử ngẫu nhiên</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Lên kệ có giới hạn thời gian, quá hạn sẽ ngưng bán vật phẩm đó</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Đá phẩm chất thấp không thể lên kệ</T><BR>10</BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">Sau khi bán thành công, hệ thống sẽ thu phí bằng 20% giá vật phẩm</T><BR>10</BR>
<T C="127,70,26" S="20">7. </T><T C="127,70,26" S="18">Thu hồi vật phẩm là bán cho hệ thống, sau khi bán có thể nhận Pha Lê</T><BR>10</BR>
<T C="127,70,26" S="20">8. </T><T C="127,70,26" S="18">Sau khi mua vật phẩm, hệ thống sẽ tự động giám định đạo cụ</T><BR>10</BR>
]],

ACTIVITY_TEXT25 = "Thời gian hoạt động còn lại",
ACTIVITY_TEXT26 = "Tích lũy đăng nhập Trở Về",
ACTIVITY_TEXT27 = "Bá Chủ Trở Về",
ACTIVITY_TEXT28 = "Ưu Đãi Giá Hời",
ACTIVITY_TEXT29 = "Chia sẻ quà",
ACTIVITY_TEXT30 = "Cánh vĩnh viễn tự chọn",
ACTIVITY_TEXT31 = "Thời trang vĩnh viễn tự chọn",
ACTIVITY_TEXT32 = "Chỉ được chọn 1 loại",
ACTIVITY_TEXT33 = "Chia sẻ hướng dẫn nhiệm vụ",
ACTIVITY_TEXT34 = "Chọn thưởng trước",
ACTIVITY_TEXT35 =
[[
<T C="229,105,22" S="20" P="0">Ngày 1: Chia sẻ hình chụp màn hình với Nhóm Bạn Bè 1 lần</T><BR></BR>
<T C="229,105,22" S="20" P="0">Ngày 2: Chia sẻ với Nhóm Bạn Bè 1 lần + Nhóm Chính Thức 1 lần</T><BR></BR>
<T C="229,105,22" S="20" P="0">Ngày 3: Chia sẻ với Nhóm Bạn Bè 1 lần + Nhóm Bạn Bè Zalo 1 lần</T><BR></BR>
<T C="229,105,22" S="20" P="0">Số CSKH: 1587368643</T><BR></BR>
]],
ACTIVITY_TEXT36 = "Vòng Sáng Trở Về",
ACTIVITY_TEXT37 = "6 Đồng nhận Vòng Sáng vĩnh viễn",
ACTIVITY_TEXT38 = "Mảnh Vòng Sáng đặc biệt",
ACTIVITY_TEXT39 = "Giá Trở Về: ",
ACTIVITY_TEXT40 = "Thời gian hoạt động mua còn: ",
ACTIVITY_TEXT41 = "Mua xong tích lũy đăng nhập %d/%d ngày tất cả thưởng",
ACTIVITY_TEXT42 = {"Người Cũ Trình Diện","Dần Dần Tốt Lên","Thành Thạo Điêu Luyện","Bá Chủ Trở Về","Trở Lại Đỉnh Cao"},
ACTIVITY_TEXT43 = "Chào mừng trở về",
ACTIVITY_TEXT44 = "Hãy nhấp màn hình tiếp tục",
ACTIVITY_TEXT45 = "Chúng tôi đã chuẩn bị một số thưởng và nhiệm vụ có thể giúp bạn làm quen với trò chơi nhanh hơn!",
ACTIVITY_TEXT46 = [[<T C="127,70,26" S="12" P="1">Ngày %d</T>]],
ACTIVITY_TEXT47 = [[<T C="127,70,26" S="12" P="1">Ngày thứ %d</T><T C="229,105,22" S="12" P="1"> (Đã hoàn thành)</T>]],
ACTIVITY_TEXT48 = [[<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Dựa theo chia sẻ hướng dẫn mỗi ngày, chụp hình gửi cho CSKH là có thể nhận Code Đổi Quà, trong 3 nhiệm vụ ở thời gian hoạt động, 1 tài khoản chỉ được hoàn thành nhận 1 lần.</T><BR>10</BR>]],
ACTIVITY_TEXT49 = "Nhiệm vụ chưa mở, mai hãy quay lại",
ACTIVITY_TEXT50 = "Năng động tích lũy: ",

TEN_LOTTERY = "Gọi x10",
ONE_LOTTERY = "Gọi x1",
LOTTERY_TEXT1 = "Nhận thú cưỡi trùng lặp!",
LOTTERY_TEXT2 = [[<T C="132,66,29" S="20" P="1">Đã tự động chuyển hóa thành </T><T C="163,74,20" S="20" P="1">%d</T><I Z="0.5" P="1">%s</I>]],
LOTTERY_NOT_ENOUGH1 = "Xu Bạc không đủ, dùng %d Kim Cương để bù?",
LOTTERY_NOT_ENOUGH2 = "Xu Bạc không đủ, dùng %d Kim Cương Khóa, %d Kim Cương để bù?",
LOTTERY_NOT_ENOUGH3 = "Xu Bạc không đủ, dùng %d Kim Cương Khóa để bù?",
LOTTERY_NOT_ENOUGH4 = "Xu Vàng không đủ, dùng %d Ruby để bù?",
LOTTERY_NOT_ENOUGH5 = "Xu Vàng không đủ, dùng %d Kim Cương Khóa, %d Kim Cương để bù?",
LOTTERY_NOT_ENOUGH6 = "Xu Vàng không đủ, dùng %d Kim Cương Khóa để bù?",

KID_TEXT129 = "Trường học",
KID_TEXT130 = "Không có trẻ con có thể đến trường",
KID_TEXT131 = "Hiệu suất học tập",
KID_TEXT132 = "%s-Trường cấp %s",
KID_TEXT133 = "ID trường học",
KID_TEXT134 = "Tên trường học",
KID_TEXT135 = [[<T C="255,227,116" S="22" P="1" SC="132,66,29" SE="1" SS="4">%s</T><T C="255,236,193" S="22" P="1" SC="132,66,29" SE="1" SS="4">-Trường học</T>]],
KID_TEXT136 = "EXP Trường Học",
KID_TEXT137 = [[<I Z="0.8">ui/common/common_icon_zuanshi.png</I><T C="255,250,236" S="24" P="1" SC="163,74,20" SE="1" SS="4">%s góp</T>]],
KID_TEXT138 = "Gia trưởng",
KID_TEXT139 = "EXP hôm nay",
KID_TEXT140 = "Duyệt thành viên",
KID_TEXT141 = "Thôi học",
KID_TEXT142 = "Nền tảng trường học",
KID_TEXT143 = "Danh sách học sinh",
KID_TEXT144 = "Danh sách trường",
KID_TEXT145 = "Nhấp nhập ID trường học",
KID_TEXT146 = "Hãy nhập ID trường học",
KID_TEXT147 = "Nội dung không thể để trống!",
KID_TEXT148 = "Mật khẩu trường",
KID_TEXT149 = "Thông tin trường",
KID_TEXT150 = "Hiệu trưởng: ",
KID_TEXT151 = "Xin phép nhập học",
KID_TEXT152 = "Duyệt học sinh",
KID_TEXT153 = "Hãy chọn trẻ nhỏ trước",
KID_TEXT154 = "Không có trường học này",
KID_TEXT155 = "Đã vào trường học khác",
KID_TEXT156 = "Trường học đã giải tán rồi",
KID_TEXT157 = "Đang ly hôn không thể thao tác",
KID_TEXT158 = "Chưa có con, không thể vào trường",
KID_TEXT159 = "Xây trường học",
KID_TEXT160 = "Đã xây rồi",
KID_TEXT161 = "Chưa có con, không thể xây trường",
KID_TEXT162 = "Tên không hợp lệ",
KID_TEXT163 = "Độ dài không hợp lệ, hãy nhập 4-8 ký tự",
KID_TEXT164 = "Đã có trường học cùng tên rồi",
KID_TEXT165 = "Hãy đợi Con ra đời rồi xây dựng",
KID_TEXT166 = "Hãy nhận thưởng trước",
KID_TEXT167 = "Đã vượt quá thời gian học tập rồi",
KID_TEXT168 = "Góp-Siêu",
KID_TEXT169 = "Góp-Thường",
KID_TEXT170 = "Thời gian duy trì hiệu suất góp: ",
KID_TEXT171 = "Góp-Thường chỉ được nhận một nửa hiệu suất tăng của trường học",
KID_TEXT172 = "Đổi tên trường",
KID_TEXT173 = "Chưa vào trường nào cả",
KID_TEXT174 = "Hôm nay đã góp qua",
KID_TEXT175 = 
[[
<T C="127,70,26" S="20" P="0">1. Hiệu suất học tập có liên quan với số người góp cho trường học, số người góp càng nhiều thì hiệu suất càng cao</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">2. Góp-Siêu có thể tăng 2 cấp hiệu suất học tập, và sau đó có thể nhận toàn bộ hiệu suất tăng, Gop-Thường chỉ tăng 1 cấp hiệu suất học tập, và chỉ nhận một nửa hiệu suất tăng</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">3. Hiệu suất càng cao, học tập ở Khu Trưởng Thành có hiệu suất càng nhanh, thời gian học kỹ năng ở Khu Khoa Học ngắn hơn</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">4. Góp xong có thể tăng EXP Trường Học, Góp-Siêu nhận nhiều EXP hơn so với Góp-Thường</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">5. EXP Trường Học đầy sẽ tự động tăng cấp trường học</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">6. Cấp trường học càng cao, số người có thể học tập ở các khu sẽ càng nhiều</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">7. Trường học nghỉ dạy vào 23:00-07:00 mỗi ngày, không thể tiến hành học tập</T><BR>10</BR>
<T C="127,70,26" S="20" P="0"></T><BR>10</BR>
]],
KID_TEXT176 = "Chưa góp",
KID_TEXT177 = "Trạng thái góp",
KID_TEXT178 = "Thao tác",
KID_TEXT179 = "Không có quyền thao tác",
KID_TEXT180 = "Chuyển nhượng",
KID_TEXT181 = "Vượt quá số người",
KID_TEXT182 = "Giải tán",
KID_TEXT183 = "Trí tuệ",
KID_TEXT184 = "Tinh thần",
KID_TEXT185 = "Thể lực",
KID_TEXT186 = "Thời hạn Khu Trưởng Thành: ",
KID_TEXT187 = "Đổi Con",
KID_TEXT188 = "Đồng ý trục xuất đứa trẻ",
KID_TEXT189 = "Đồng ý thôi học",
KID_TEXT190 = "Đồng ý giải tán trường học",
KID_TEXT191 = "Chuyển nhượng trường học",
KID_TEXT192 = "Đang trống",
KID_TEXT193 = "Đang học tập",
KID_TEXT194 = "Đang nghỉ ngơi",
KID_TEXT195 = "Đang vận động",
KID_TEXT196 = "Đang tham quan",
KID_TEXT197 = "Đang đi dạo",
KID_TEXT198 = "Đang học ở Khu Trưởng Thành",
KID_TEXT199 = "Đang nghỉ ngơi ở Khu Trưởng Thành",
KID_TEXT200 = "Đang vận động trong Khu Trưởng Thành",
KID_TEXT201 = "Đang tham quan Khu Kỹ Nghệ",
KID_TEXT202 = "Bị đuổi khỏi trường rồi",
KID_TEXT203 = "Chỉ có 1 đứa Con",
KID_TEXT204 = "Bổ túc",
KID_TEXT205 = "Thời hạn Khu Kỹ Nghệ: ",
KID_TEXT206 = "Xác nhận chuyển nhượng trường học?",
KID_TEXT207 = "Kỹ năng đã đầy, không thể vào Khu Khoa Học",
KID_TEXT208 = "Vượt quá số người khu này rồi",
KID_TEXT209 = "Đồng ý đổi đứa trẻ",
KID_TEXT210 = "Hãy đợi Hôn Lễ cử hành xong",
KID_TEXT211 = "Đang ly hôn không thể thao tác",
KID_TEXT212 = "Hãy đợi Hôn Lễ cử hành xong",
KID_TEXT213 = "Xác nhận quyên góp thường?",
KID_TEXT214 = "Xác nhận Góp-Siêu",
KID_TEXT215 = [[<T C="127,70,26" S="18" P="1">Mỗi </T><T C="229,105,22" S="18" P="0">%s</T><T C="127,70,26" S="18" P="1"> phút có thể học được 1 kỹ năng</T>]],
KID_TEXT216 = "Vào Khu Khoa Học, con có thể tự động học kỹ năng đã mở khóa",
KID_TEXT217 = "Xây trường thành công",
KID_TEXT218 = "Xin vào học thành công",
KID_TEXT219 = "Duyệt vào học thành công",
KID_TEXT220 = "Giải tán trường thành công",
KID_TEXT221 = "Góp thành công",
KID_TEXT222 = "Đổi tên trường thành công",
KID_TEXT223 = "Nhận thành công",
KID_TEXT224 = "Vào khu vực thành công",
KID_TEXT225 = "Đổi con cái đi học thành công",
KID_TEXT226 = "Bỏ học thành công",
KID_TEXT227 = "Đuổi học thành công",
KID_TEXT228 = "Đã ẩn hiển thị trong danh sách trường",
KID_TEXT229 = "Đã mở hiển thị trong danh sách trường",
KID_TEXT230 = "Chuyển nhượng trường thành công",
KID_TEXT231 = "Xây trường thất bại",
KID_TEXT232 = "Giải tán thất bại",
KID_TEXT233 = "Chuyển nhượng thất bại",
KID_TEXT234 = "Góp thất bại",
KID_TEXT235 = "Đổi tên thất bại",
KID_TEXT236 = "Nhận thất bại",
KID_TEXT237 = "Đuổi học thất bại",
KID_TEXT238 = "Rời đi",
KID_TEXT239 = "Nhận thành công, Trí Tuệ +%d",
KID_TEXT240 = "Nhận thành công, Tinh Thần +%d",
KID_TEXT241 = "Nhận thành công, Thể Lực +%d",
KID_TEXT242 = "Khu này chưa mở khóa, hãy tăng cấp trường học trước",
KID_TEXT243 = 
[[
<T C="127,70,26" S="20" P="0">1. Nghỉ trưa tạo EXP Tinh Thần và thuộc tính HP, lên lớp tạo EXP Trí Tuệ và thuộc tính Tấn Công, chạy bộ tạo EXP Thể Lực và thuộc tính Phòng Thủ</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">2. Cấp tinh thần, trí tuệ, thể chất quyết định điểm thuộc tính tối đa, cấp càng cao, điểm thuộc tính trưởng thành càng nhiều</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">3.Cấp tinh thần, trí tuệ, thể chất bị giới hạn bởi cấp trường lớp, không thể vượt quá cấp trường lớp</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">4. Nghỉ trưa, lên lớp, chạy bộ đều thuộc phạm vi Khu Trưởng Thành, mỗi ngày có thể học 6 giờ, Khu Khoa Học mỗi ngày có thể học 4 giờ</T><BR>10</BR>
<T C="127,70,26" S="20" P="0"></T><BR>10</BR>
]],
KID_TEXT244 = "Vượt quá số lần thao tác tối đa hôm nay", 
KID_TEXT245 = "Thôi học thất bại",
KID_TEXT246 = "Bạn hoặc bạn đời là hiệu trưởng, không thể thôi học",  

MOUNTSTONE_TEXT1 = "Linh Thạch",
MOUNTSTONE_TEXT2 = "Linh Thạch",
MOUNTSTONE_TEXT3 = "Chiến Hồn",
MOUNTSTONE_TEXT4 = "Thiết lập chọn nhanh",
MOUNTSTONE_TEXT5 = "Hãy chọn nguyên liệu tự động thêm vào nhanh: ",
MOUNTSTONE_TEXT6 = "Đá EXP",
MOUNTSTONE_TEXT7 = "Đá Lục",
MOUNTSTONE_TEXT8 = "Đá Lam",
MOUNTSTONE_TEXT9 = "Nguồn Đá phẩm chất dưới 50",
MOUNTSTONE_TEXT10 = "",
MOUNTSTONE_TEXT11 = "Cần chọn vị trí mới có thể khảm và tháo",
MOUNTSTONE_TEXT12 = "Cấp Linh Thạch: ",
MOUNTSTONE_TEXT13 = "Chưa mở",
MOUNTSTONE_TEXT14 = "Vị trí này chưa khảm Linh Thạch",
MOUNTSTONE_TEXT15 = "Không có Nguồn Đá để khảm",
MOUNTSTONE_TEXT16 = "Không có khảm, không thể tháo",
MOUNTSTONE_TEXT17 = "Trang bị thành công",
MOUNTSTONE_TEXT18 = "Tháo thành công",
MOUNTSTONE_TEXT19 = "Không có trang bị Đá, không thể cường hóa",
MOUNTSTONE_TEXT20 = "Hãy chọn vật phẩm",
MOUNTSTONE_TEXT21 = "Tổng cấp Đá đạt %d cấp sẽ mở khóa, hiện tại tổng %d cấp",
MOUNTSTONE_TEXT22 = "Tổng cấp Đá đã trang bị đạt %d sẽ mở khóa vị trí này",
MOUNTSTONE_TEXT23 = "Hãy chọn Linh Thạch muốn khảm",
MOUNTSTONE_TEXT24 = [[<T C="255,255,255" S="20" P="0">Đá này chỉ được khảm Nguồn Đá thuộc tính </T><T C="0,255,0" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0"></T>]],
MOUNTSTONE_TEXT25 = "Không có đạo cụ có thể chọn nhanh, hãy điều chỉnh thiết lập nhanh",
MOUNTSTONE_TEXT26 = [[
<T C="229,105,22" S="22" P="1">Giới thiệu:</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Cần bắt đầu khảm Linh Thạch từ vị trí 1. Đạt cấp yêu cầu mới khảm được các vị trí tiếp theo. Linh Thạch ban đầu sẽ không có thuộc tính, cần gắn đá Chiến Hồn tương ứng để kích hoạt.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Tăng Cấp Linh Thạch càng cao, thuộc tính nhận được càng lớn. Dựa vào phẩm chất của viên Chiến Hồn đang được khảm để quyết định thuộc tính. Hãy truy tìm những viên chiến hồn có phẩm chất tốt.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Linh Thạch đã tăng cấp sẽ hoàn trả 70% EXP nếu dùng để tăng cấp Linh Thạch khác. Chiến Hồn cũng có thể dùng nhưng chỉ cho một ít EXP. Sử dụng EXP Linh Thạch (Sơ/Trung/Cao) để tăng cấp Linh Thạch hiệu quả.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Linh Thạch bậc cao sẽ cho nhiều ô khảm Chiến Hồn hơn.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Hiệu Ứng Đặc Biệt:</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Đối với linh thạch Bậc 1-2-3 ,khi tăng cấp có 5% tỉ lệ nhận được 1 dòng thuộc tính đặc biệt, tăng đến cấp 10 chắn chắn sẽ có thuộc tính đặc biệt. Linh Thạch Lv4 chắc chắn có 1 thuộc tính đặc biệt ngay từ khi mới nhận.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Mỗi viên Linh Thạch chỉ có tối đa 1 dòng hiệu ứng đặc biệt.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Danh sách hiệu ứng:</T><BR>10</BR>
<T C="229,105,22" S="20" P="0"></T><T C="127,70,26" S="20" P="0">- Sinh Lực/ Tấn Công / Phòng Thủ / May Mắn / Tốc Độ tăng từ 15-100%</T><BR>10</BR>
<T C="229,105,22" S="20" P="0"></T><T C="127,70,26" S="20" P="0">- Tăng cấp giới hạn tối đa của Linh Thạch từ 1 đến 3 cấp.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0"></T><T C="127,70,26" S="20" P="0">-Tăng thuộc tính dựa vào bộ sưu tập thú cưỡi đang có.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0"></T><T C="127,70,26" S="20" P="0">-Linh Thạch có 1 ô trở thành Vạn Năng, có thể khảm Chiến Hồn bất kỳ</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Hiệu ứng đặc biệt cộng thuộc tính trực tiếp vào viên Linh Thạch đang khảm.</T><BR>10</BR>

]],
MOUNTSTONE_TEXT27 = "Bất kỳ",
MOUNTSTONE_TEXT28 = "Hiện không có Nguồn Linh Thạch có thể chọn",
MOUNTSTONE_TEXT29 = "Khảm thành công",
MOUNTSTONE_TEXT32 = "Lực chiến Linh Thạch: ",
MOUNTSTONE_TEXT31 = "Thuộc tính Linh Thạch",
MOUNTS_STONE_ADD = "Linh Thạch tăng thêm",
LOTTERY_TEXT3 = "Không đủ 1 giờ",
LOTTERY_TEXT4 = "%d ngày %d giờ",
LOTTERY_TEXT5 = "%d giờ",
LOTTERY_TEXT6 = "Chia Sẻ lần đầu mỗi ngày nhận %d K.Cương",
LOTTERY_TEXT7 = "Vỏ Trứng không đủ",
LOTTERY_TEXT8 = "Nhận Skin đã có",
LOTTERY_TEXT9 = "Nhận Vòng Sáng đã có",
LOTTERY_SHOP_COIN = "Huy Hiệu Ngôi Sao không đủ",
ITEM_SUIT_TITLE = "Set trang bị",
ACTIVITY_TEXT24 = [[
<T C="255,255,255" S="22" P="1">Hướng dẫn hoạt động Lắc Thưởng</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">1. </T><T C="244,190,100" S="20">Đăng nhập mỗi ngày được nhận 1 lần Lắc Thưởng miễn phí, sang hôm sau sẽ tái lập.</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">2. </T><T C="244,190,100" S="20">Mỗi lần Lắc Thưởng cần tốn 1 Xu Lắc Thưởng, chắc chắn nhận được thưởng và điểm, có cơ hội nhận "Mảnh Nicole".</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">3. </T><T C="244,190,100" S="20">Mỗi ngày có thể nhận và hoàn thành Nhiệm Vụ Ngày 1 lần, hôm sau sẽ tái lập. Trong hoạt động, chỉ được nhận và hoàn thành Nhiệm Vụ Trưởng Thành 1 lần, sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, sẽ bị xóa hết khi hoạt động kết thúc.</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">4. </T><T C="244,190,100" S="20">BXH: Xếp hạng theo số điểm đạt được, Top 100 người chơi có thể nhận thưởng hấp dẫn.</T><BR>10</BR>
<T C="244,190,100" S="20">Chú ý: Xu Lắc Thưởng & Mảnh Nicole sẽ bị xóa hết khi hoạt động kết thúc.</T><BR>10</BR>
]],
VIP_FACE = "Biểu cảm dành riêng của VIP%d",
VIP_FACE_MSG = "Nội dung chat bao gồm biểu cảm dành riêng cho VIP%d",  
PHANTOM34 = "Ảo Hóa này sẽ thể hiện thành tầm gần trong một số động tác tấn công",

ACTIVITY_TEXT53 = "Chọn 1 rương bất kỳ và chọn 4 phần quà bên trong!",
ACTIVITY_TEXT54 = "Kho Báu Melia",
ACTIVITY_TEXT55 = [[
<T C="255,255,255" S="22" P="1">Hướng dẫn Phát Triển</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">1. </T><T C="255,236,193" S="20" P="1">Chọn 1 phần quà, sau đó chọn 4 loại thưởng muốn mua, mỗi loại được chọn lặp lại</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">2. </T><T C="255,236,193" S="20" P="1">Mua quà được nhận thêm Huy Chương Dũng Sĩ, dùng đổi đạo cụ trong tiệm tương ứng</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">3. </T><T C="255,236,193" S="20" P="1">Quà và đạo cụ trong tiệm sẽ tự động tạo mới sau 1 ngày</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">4. </T><T C="255,236,193" S="20" P="1">Huy Chương Dũng Sĩ sẽ bị xóa hết khi hoạt động kết thúc</T><BR>10</BR>
]],
ACTIVITY_TEXT56 = "Chọn đạo cụ mình thích",
ACTIVITY_TEXT57 = "Chú ý: Đạo cụ trong Tiệm Kho Báu Melia mỗi ngày tạo mới 1 lần, có thể dùng Huy Chương Dũng Sĩ để tạo mới chủ động",
ACTIVITY_TEXT58 = "Lượt mua: ",
ACTIVITY_TEXT59 = "Còn ",
ACTIVITY_TEXT60 = "Cần chọn đạo cụ trước",
ACTIVITY_TEXT61 = "Giới hạn mua mỗi ngày: ",
ACTIVITY_TEXT62 = " lần",
ACTIVITY_TEXT63 = "Đã chọn đạo cụ xong",
ACTIVITY_TEXT64 = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">Hôm nay được chọn </T><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T><T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1"> lần (Còn </T><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T><T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1"> lần)</T>]],
ACTIVITY_TEXT65 = "Huy Chương Dũng Sĩ: ",
ACTIVITY_TEXT66 = "Tối thiểu",
ACTIVITY_TEXT67 = "Tối đa",
ACTIVITY_TEXT68 = "Huy Chương Dũng Sĩ không đủ",
ACTIVITY_TEXT69 = "Số liệu đã quá hạn, hãy chọn mua lại",
ACTIVITY_TEXT70 = "Vật phẩm đã đạt mức giới hạn mua",
ACTIVITY_TEXT71 = "Giới hạn số lần tạo mới",
ACTIVITY_TEXT51 = [[
<T C="255,255,255" S="22" P="1">Hướng dẫn Lực Chiến Phi Thăng</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">1. </T><T C="244,190,100" S="20">Lực chiến tăng thêm = Lực chiến hiện tại - lực chiến khi bắt đầu hoạt động.</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">2. </T><T C="244,190,100" S="20">Nhiệm vụ: Nhiệm Vụ Ngày hoàn thành xong sẽ được nhận thưởng, qua ngày sẽ xóa hết số liệu, hãy nhận thưởng kịp thời. Trong hoạt động chỉ được nhận và hoàn thành Nhiệm Vụ Trưởng Thành 1 lần, sau khi xong nhiệm vụ hãy nhận thưởng kịp thời.</T><BR>10</BR>
<T C="255,236,193" S="20" P="0">3. </T><T C="244,190,100" S="20">BXH: Người chơi Top 200 tăng lực chiến được nhận thưởng hấp dẫn, thưởng gửi qua thư.</T><BR>10</BR>
]],  
ACTIVITY_TEXT52 = "Hướng dẫn hoạt động: Lọt vào Top 200 sẽ được nhận thưởng",
ACTIVITY_TEXT72 = "Mức tăng lực chiến: ",
ACTIVITY_TEXT73 = "Lần lượt hiển thị người chơi Top 50",
SHOOTARROW_TEXT1 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn Bắn Cung</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Đến chỗ Xe Đẩy Nhỏ nhận đạo cụ Bắn Cung, mỗi lần bắn cần tốn 1 mũi tên, bắn trúng hồng tâm (vòng 10 điểm) sẽ được nhận 2 phần thưởng ngẫu nhiên, trúng các vòng điểm khác được nhận 1 phần thưởng ngẫu nhiên.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Mục tiêu: Mỗi ngày có thể nhận và hoàn thành Nhiệm Vụ Ngày 1 lần, hôm sau sẽ tái lập. Trong hoạt động, chỉ được nhận và hoàn thành Nhiệm Vụ Trưởng Thành 1 lần, sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, sẽ bị xóa hết khi hoạt động kết thúc..</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Tổ đội: Tổ đội tham gia có thể cùng hoàn thành các mục tiêu thi đấu. Trong hoạt động, một khi đã xác định tổ đội xong, quan hệ sẽ không thể giải trừ.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH Cá Nhân: Xếp hạng theo số lần bắn cung của mỗi người, top 100 được nhận thưởng hấp dẫn. BXH Tổ Đội sẽ xếp theo tổng điểm cả đội đạt được, top 10 được nhận thưởng hấp dẫn. </T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Đạo cụ bắn cung sẽ bị xóa hết khi hoạt động kết thúc.</T><BR>10</BR>]],   
SHOOTARROW_TEXT2 = "Bình Luận",   
SHOOTARROW_TEXT3 = "Quà Thi Đấu",  
SHOOTARROW_TEXT4 = "Toàn server Bắn Cung đạt số lần chỉ định, được nhận 1 phần thưởng ngẫu nhiên", 
SHOOTARROW_TEXT5 = "Tổ đội tham gia", 
SHOOTARROW_TEXT6 = "Thông tin tổ đội", 
SHOOTARROW_TEXT7 = "BXH Thi Đấu", 
SHOOTARROW_TEXT8 = "Mục tiêu thi đấu", 
SHOOTARROW_TEXT9 = "Bắn Cung %d lần", 
SHOOTARROW_TEXT10 = "Dành cho tổ đội", 
SHOOTARROW_TEXT11 = "Tổ đội mỗi ngày tham gia bắn cung 10 lần để nhận phần thưởng hấp dẫn", 
SHOOTARROW_TEXT12 = [[Đã dùng hết mũi tên, đến chỗ Bánh Kem mua "Quà Bắn Cung" để nhận thêm tên]],
SHOOTARROW_TEXT13 = "Nhấp để nhập vào", 
SHOOTARROW_TEXT14 = "Chú ý: Tất cả các đội đã tham gia 1 lần Bắn Cung, đều được nhận Quà Tổ Đội. Khi hoạt động kết thúc, thưởng sẽ được gửi qua thư (Trong hoạt động, sau khi xác định quan hệ tổ đội sẽ không thể giải trừ)" ,
SHOOTARROW_TEXT15 = "Số vòng", 
SHOOTARROW_TEXT16 = "Số lần Bắn Cung", 
SHOOTARROW_TEXT17 = "BXH Bắn Cung", 
SHOOTARROW_TEXT18 = "BXH Tổ Đội", 
SHOOTARROW_TEXT19 = "Chỉ hiện Top %d", 
SHOOTARROW_TEXT20 = "Thưởng Tổ Đội", 
SHOOTARROW_TEXT21 = "Thông Báo Mời", 
SHOOTARROW_TEXT22 = "Mời tham gia", 
SHOOTARROW_TEXT23 = [[<T C="127,70,26" S="20" P="1"></T><T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"> đã từ chối lời mời của bạn</T>]],
SHOOTARROW_TEXT24 = [[<T C="127,70,26" S="20" P="1"></T><T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"> đã chấp nhận lời mời của bạn</T>]],
SHOOTARROW_TEXT25 = "Bạn đã tổ đội rồi, không thể thay đổi nữa",  
SHOOTARROW_TEXT26 = "Tổ đội thành công",  
SHOOTARROW_TEXT27 = "Đã từ chối",  
SHOOTARROW_TEXT28 = "Chậm chân rồi, người này đã vào đội khác",  
SHOOTARROW_TEXT29 = {"Bắn đâu trúng đó! Bắn trúng vòng ", "Bắn đâu trúng đó! Lần lượt bắn trúng vòng %s"},
SHOOTARROW_TEXT30 = "STT",

STAR_STONE1 = "Thêm đồ Tím/Cam sẽ tăng xác suất thành công",   
WONDERFUL_TEXT1 = "Mua giới hạn siêu giá trị",
MOUNTSTONE_TEXT30 = "Chọn 1 vị trí để thao tác",
GM_EXPLAIN = [[
[Loại tiền tệ]
1 Kim Cương 2 Vàng 3 EXP 70 Kim Cương Khóa
[Thưởng thông dụng]
102 Bánh Donut
106 Vé Càn Quét
201 Vé Quét Ác Mộng
23 Huy Chương Cầu Phúc
59 Mảnh Bùa
111 Túi Vàng Nhỏ
113 Túi Vàng Lớn
114 Loa
115 Loa Liên Server
850 Quà Không Gian
[Rút thưởng]
107 Vỏ Trứng Pet
163 Vé Gọi Pet
164 Chìa Trang Bị
165 Vé Trang Bị
[Đồng Hành]
118 Trứng Pet
208 Trứng Pet EXP-Thấp
209 Trứng Pet EXP-Cao
103 Thuốc Tiến Hóa
104 Vé Lĩnh Ngộ
105 Đá Khóa Skill
567 Đá Khóa Sao
119 Thuốc Tăng Sao
851 Thuốc Tăng Bậc Skin
853 Mảnh Khế Ước
854 Ý Chí Khế Ước (Hiếm)
800 Đạn Cấp Vòng Sáng
801 Đá Tinh Luyện-Sơ
802 Đá Tinh Luyện-Trung
803 Đá Tinh Luyện-Cao
[Rèn]
108 Đá Sao-Sơ
109 Đá Sao-Trung
110 Đá Sao-Cao
112 Đá Thánh
182 Tinh Thánh Quang
183 Bụi Thánh Quang
188 Đá Sao-Đỉnh
189 Đá Sao-Cực
190 Đá Sao-Thánh Quang
191 Đá Thánh-Thánh Quang
192 Rương Thánh Quang
193 Thuốc Thánh Quang
194 Chìa Thánh Quang
[Guild]
8 Danh Vọng Công Hội
27 Xu Khiêu Chiến Công Hội
[Vườn]
66 Nước Thánh
67 Đá Cảnh
[Thẻ]
79 Tăng Tốc
26 Phiếu
[Mỏ Khoáng]
58 Pha Lê
[Hệ]
85 Học Thức
95 Học Thức-Cao
[Khác]
6 Thể Lực
10 Xu Xếp Hạng
11 Xu Thi Đấu
12 Điểm Hạng
13 Điểm Thi Đấu
19 Điểm Thành Tựu
22 Xu Cầu Phúc
25 Điểm Tu Luyện
50 Thẻ Tháng
61 Tinh Thạch Ảo Hóa
62 Điểm Thiên Phú
63 Điểm Kỹ Năng
82 Kết Tinh Đá Quý
83 Tinh Hoa Đá Quý
87 EXP Thẻ GunPow
88 Mảnh Thẻ GunPow
89 Tư Cách Tăng Bậc Thẻ GunPow
97 Xu Nông Trại
98 EXP Nông Trại
99 Tinh Hoa Đạo Cụ
390 Gà Quay
849 Đạo Cụ Di Tích
500 Đá Thức Tỉnh-Sơ
501 Đá Thức Tỉnh-Trung
502 Đá Thức Tỉnh-Cao
503 Đá Thức Tỉnh-Siêu
550 Sách Kỹ Năng-Sơ
551 Sách Kỹ Năng-Trung
552 Sách Kỹ Năng-Cao
]],
OPTIMIZE_TEXT47 = "Dùng %d món trang bị để tăng xác suất thành công?",
OPENCHEST3 = "Được mua %d lần (Còn lại %d)" ,
PASTURE_TEXT_1 = "Thú cưỡi đang bị trộm không thể ghép",
BLESS_UPGRADE = "Nuốt để có kinh nghiệm:%d",
CHAT_VOICE_LIMIT = "Để đảm bảo chất lượng chat Thế Giới, VIP 2 mới có thể dùng Voice Chat tại kênh này.",
OPINION_TEXT_VN = "Hãy liên hệ Fanpage để góp ý, được hỗ trợ nhanh nhất và theo dõi các hoạt động của GunPow",
DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE_VN = "Ruby không đủ, nạp thêm?",
MAIL_DOPAY2_VN = "Thanh toán giúp đối phương %s Ruby ",
EQUIPMENT_DRAW_EXPLAIN6 =
[[
<T C="229,105,22" S="22">Quy tắc rút thú cưỡi bằng bạc</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Mỗi gọi 10 lần chắc chắn nhận được Thú Cưỡi Cam hoặc nguyên liệu Linh Thạch cao cấp trong [Thư Viện]</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Thú cưỡi nhận lặp lại từ rút thưởng sẽ tự động chuyển thành Huy Hiệu Ngôi Sao, dùng đổi đạo cụ trong Tiệm Rút Thưởng</T><BR>10</BR>
<T C="229,105,22" S="22">Hướng dẫn Kho Thưởng Nâng Cấp</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Xác suất rút được Thú Cưỡi kỳ này tăng đến 50% (Thú Cưỡi Cam tổng xác suất không đổi)</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Thú cưỡi kỳ này mỗi 4 ngày đổi 1 lần</T><BR>10</BR>
<T C="229,105,22" S="22">Công thức xác suất</T><BR></BR>
<T C="127,70,26" S="18">[Thú Cưỡi Cam]  6%</T><BR></BR>
<T C="127,70,26" S="18">[Linh Thạch Bậc 4]  4%</T><BR></BR>
<T C="127,70,26" S="18">[Linh Thạch Bậc 3]  10%</T><BR></BR>
<T C="127,70,26" S="18">[Linh Thạch Bậc 2]  21%</T><BR></BR>
<T C="127,70,26" S="18">[Linh Thạch Bậc 1]  10%</T><BR></BR>
<T C="127,70,26" S="18">[Nguồn Linh Thạch-Thuộc Tính] 21%</T><BR></BR>
<T C="127,70,26" S="18">[Nguồn Linh Thạch-EXP] 28%</T><BR></BR>
]],
EQUIPMENT_DRAW_EXPLAIN7 =
[[
<T C="229,105,22" S="22">Quy tắc rút Skin bằng bạc</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Mỗi gọi 10 lần chắc chắn nhận được Skin Cam trong [Thư Viện]</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Skin nhận lặp lại từ rút thưởng sẽ tự động chuyển thành Huy Hiệu Ngôi Sao, dùng đổi đạo cụ trong Tiệm Rút Thưởng</T><BR>10</BR>
<T C="229,105,22" S="22">Hướng dẫn Kho Thưởng Nâng Cấp</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Xác suất rút được Skin kỳ này tăng đến 50% (Skin Cam tổng xác suất không đổi)</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Skin kỳ này mỗi 4 ngày đổi 1 lần</T><BR>10</BR>
<T C="229,105,22" S="22">Công thức xác suất</T><BR></BR>
<T C="127,70,26" S="18">[Skin Cam] 7%</T><BR></BR>
<T C="127,70,26" S="18">[Skin Tím] 3%</T><BR></BR>
<T C="127,70,26" S="18">[Skin Lam] 26%</T><BR></BR>
<T C="127,70,26" S="18">[Skin Lục] 38%</T><BR></BR>
<T C="127,70,26" S="18">[Skin Trắng] 26%</T><BR></BR>
]],




CHALLENGEN_1 = "Ngọn tháp thử thách tấm lòng dũng sĩ",
CHALLENGEN_2 = "Xông pha ảo cảnh, chiến thắng tâm ma",
CHALLENGEN_3 = "Đất cấm luân hồi, đi tìm kho báu",
CHALLENGEN_4 = "Rồng thần viễn cổ sắp sửa thức tỉnh",
CHALLENGEN_5 = "Tộc quỷ vực sâu, ai dám chinh phục",
CHALLENGEN_6 = "Bí cảnh mỗi ngày, tiền bạc đầy túi",
CHALLENGEN_7 = "Thử thách kẻ mạnh, đột phá bản thân",
SEND_FLOWER_ATT = [[Hôm nay đã tặng quà cho bạn này rồi.]],
AGE_APPROPRIATE_TIPS = [[Hướng dẫn: 
1) Trò chơi giải trí thi đấu đối kháng dành cho người chơi từ 12 tuổi trở lên. Nếu là người chơi vị thành niên, vui lòng có sự giám hộ của người nhà.
2) Trò chơi dựa trên cốt truyện hư cấu mang hướng tích cực, không liên quan hoặc được cải biên từ bất cứ bối cảnh lịch sử hoặc câu chuyện có thật nào. Người chơi điều khiển nhân vật qua các thao tác tay cơ bản để huấn luyện và tham gia thi đấu. Trò chơi có hệ thống giao tiếp với người lạ dựa trên văn tự và voice.
3) Trò chơi có yêu cầu chứng thực người dùng, nếu là người vị thành niên, sẽ chịu các điều khoản quản lý sau đây: 
Trong trò chơi, một phần tính năng và đạo cụ có yêu cầu trả phí. Người chơi dưới 8 tuổi không được tham gia trả phí. Người chơi từ đủ 8 đến dưới 16 tuổi và từ đủ 16 tuổi đến dưới 18 tuổi, chỉ được nạp thẻ trong hạn mức quy định.
Trò chơi có yêu cầu giới hạn thời gian online đối với người chơi vị thành niên, quy định tùy theo tình huống cụ thể.
4) Trò chơi diễn ra theo hình thức bắn súng tọa độ thi đấu đối kháng, giúp phát triển trí não và tư duy logic của người chơi, giúp rèn luyện sự kết hợp khéo léo giữa tay và mắt, giúp người chơi thư giãn và giải trí, tăng thêm sự tự tin. Trò chơi có tính năng chơi theo tổ đội, người chơi cần phối hợp hiệu quả với nhau để hoàn thành thi đấu, giúp bồi dưỡng tinh thần và khả năng làm việc theo nhóm.]],
LOTTERY_HANK_GOLD = "Kho Thưởng Thú Cưỡi Xu Vàng",
LOTTERY_HANK_GOLD1 = "Kho Thưởng Skin Xu Vàng",
LOTTERY_HANK_GOLD2 = "Kho Thưởng Vòng Sáng Xu Vàng",
LOTTERY_HANK_SILVER = "Kho Thưởng Thú Cưỡi Xu Bạc",
LOTTERY_HANK_SILVER1 = "Kho Thưởng Skin Xu Bạc",
LOTTERY_HANK_SILVER2 = "Kho Thưởng Vòng Sáng Xu Bạc",
GEM_STONE1 = "Nhận Đá",
GEM_STONE2 = "Chưa chọn đá muốn khảm",
OPENCHEST3 = "Được mua %d lần (Còn lại %d)",
OPTIMIZE_TEXT47 = "Mạo Hiểm",
OPTIMIZE_TEXT48 = "Tính Năng",
OPTIMIZE_TEXT49 = "Tất cả thuộc tính",
OPTIMIZE_TEXT50 = [[<T C="229,105,22" S="22" P="1">Quy tắc Duyên Nợ</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Sau khi nhận được vật phẩm tương ứng sẽ kích hoạt Duyên Nợ. Sau khi kích hoạt, Duyên Nợ sẽ tồn tại vĩnh viễn.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Thuộc tính tăng thêm chỉ có hiệu lực trong tính năng tương ứng, không giúp tăng thêm lực chiến nhân vật.</T><BR></BR>
<T C="229,105,22" S="22" P="1">Phân loại tính năng: </T><BR></BR>
<T C="229,105,22" S="20" P="0">Tính Năng Mạo Hiểm: </T><T C="127,70,26" S="20" P="0">Phó Bản Cá Nhân, Phó Bản Nhóm, Đất Cấm, Thử Thách Anh Hùng</T><BR></BR>
<T C="229,105,22" S="20" P="0">Khiêu Chiến: </T><T C="127,70,26" S="20" P="0">Tháp Thí Luyện, Ảo Cảnh Không Gian, BOSS Thế Giới, BOSS Vực Sâu, Tháp Anh Hùng</T><BR></BR>
<T C="229,105,22" S="20" P="0">Đấu Trường: </T><T C="127,70,26" S="20" P="0">Đấu Điểm, Đấu Giải Trí, Công Hội Chiến, Đấu Hạng</T><BR>10</BR>
]],
OPTIMIZE_TEXT51 = "Nhân Vật",
ACTIVITY_TEXT74 = "Đại gia VIP%d đã xuất hiện!",
ACTIVITY_TEXT75 = [[
<T C="229,105,22" S="22" P="1">Quy tắc hoạt động</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Đăng nhập mỗi ngày được nhận 1 lần xem bói miễn phí, sang hôm sau sẽ tái lập.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Mỗi lần bói cần tốn 1 Đá Chiêm Tinh, chắc chắn nhận 1 phần thưởng, 1 Thẻ Bài và EXP Chiêm Tinh, tăng Cấp Chiêm Tinh sẽ được nhận thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Khi trên mặt bàn có đủ 3 Thẻ Bài, có thể chọn Thẻ Bài để bói lại. Nếu kiểu bài phù hợp với quy tắc, có thể chọn nhận 1 đạo cụ bất kỳ trong [Phần Thưởng Hôm Nay] (Nếu chưa chọn sẽ mặc định là chọn 1 phần thưởng ngẫu nhiên), tổng kết thưởng theo bội số quẻ trong ngày.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày có thể nhận và hoàn thành Nhiệm Vụ Ngày 1 lần, hôm sau sẽ tái lập. Trong hoạt động, chỉ được nhận và hoàn thành Nhiệm Vụ Trưởng Thành 1 lần, sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, sẽ bị xóa hết khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">BXH: Xếp hạng theo số điểm đạt được, Top 100 người chơi có thể nhận thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Đạo cụ Đá Chiêm Tinh sẽ bị xóa hết khi hoạt động kết thúc.</T><BR>10</BR>
]],
ACTIVITY_TEXT76 = "Bói lại",
ACTIVITY_TEXT77 = "Cần có đủ 3 Thẻ Bài mới có thể bói lại",
ACTIVITY_TEXT78 = "Thu thập đủ 3 Thẻ Bài, mới có thể kết thúc bói quẻ lần này",
ACTIVITY_TEXT79 = "Thưởng quẻ hôm nay",
ACTIVITY_TEXT80 = " lần",
ACTIVITY_TEXT81 = {"Thầy Bói-Sơ","Thầy Bói-Trung","Thầy Bói-Cao","Thánh Bói","Tiên Tri","Thần Toán"},
ACTIVITY_TEXT82 = "Cấp tối đa",
ACTIVITY_TEXT83 = {"Thời","Vận","Mệnh","Hồng","Hỗn","Không"},
ACTIVITY_TEXT84 = "Thưởng Cấp Bói",
ACTIVITY_TEXT85 = "Điểm may mắn",
ACTIVITY_TEXT86 = {"Phụng,Thiên,Thừa,Vận","Thời,Đến,Vận,Về","Theo,Vận,Mà,Ra","Trường,Mệnh,Phú,Quý","Hồng,Nghiệp,Viễn,Đồ","Hỗn,Độn,Sơ,Khai"},
ACTIVITY_TEXT87 = "Phúc Vận Đầy Tràn",
ACTIVITY_TEXT88 = "Bói thất bại",
ACTIVITY_TEXT89 = "Bói miễn phí",
ACTIVITY_TEXT90 = "Bói",
ACTIVITY_TEXT91 = "Kết thúc bói",
ACTIVITY_TEXT92 = {{"Thời+Vận+Mệnh","20"},{"Thời+Thời+Thời","10"},{"Vận+Vận+Vận","8"},{"Mệnh+Mệnh+Mệnh","7"},{"Hồng+Hồng+Hồng","6"},{"Hỗn+Hỗn+Hỗn","5"}},
ACTIVITY_TEXT93 = "Tải số liệu thất bại",
ACTIVITY_TEXT94 = "Hãy chọn thẻ bài muốn thay thế hoặc kết thúc bói quẻ",
ACTIVITY_TEXT95 = "Cẩm Nang",
ACTIVITY_TEXT96 = "Quy tắc Bói Quẻ",
ACTIVITY_TEXT97 = "Cẩm Nang",
ACTIVITY_TEXT98 = "Số lần bói",
ACTIVITY_TEXT99 = "Nhận quẻ",
ACTIVITY_TEXT100 = "Đang bói...",
ACTIVITY_TEXT101 = "Nhận được Thẻ Bài: ",
CAHT_SEND_CODE = "Đã gửi code",
GEM_STONE1 = "Nhận đá quý",
GEM_STONE2 = "Chưa chọn đá muốn khảm",
PRAYMEDAL_TEXT1 = "Tổng cấp Cầu Phúc: ",
PRAYMEDAL_TEXT2 = {"Cấp Tích Lũy Cầu Phúc Cam: ", "Cấp Tích Lũy Cầu Phúc Tím: ", "Cấp Tích Lũy Cầu Phúc Lam: ", "Cấp Tích Lũy Cầu Phúc Lục: "},
ACTIVITY_TEXT87 = "Phúc,Vận,Đầy,Tràn",
OPTIMIZE_TEXT52 = "Hoàn Trả Nạp",
OPTIMIZE_TEXT53 = [[
  <T C="229,105,22" S="22" P="1">Quy tắc Hoàn Trả Nạp</T><BR>10</BR>
  <T C="229,105,22" S="20" P="0">1.</T>Trong thời gian hoạt động, nạp 30 VND hoàn thành điều kiện nhận thưởng (Mua quà và thẻ không tính)</T><BR>10</BR>
  <T C="229,105,22" S="20" P="0">2.</T>Trong 7 ngày sau khi kích hoạt điều kiện nhận thưởng, mỗi ngày được nhận thưởng 1 lần. Thưởng chưa nhận sẽ không thể nhận bù, hãy nhận kịp thời.</T><BR>10</BR>
]],

LOTTERY_TITLE_1 = "Rút bằng bạc",
LOTTERY_TITLE_2 = "Rút bằng vàng",
ONEKEY_TRANSFER1 = "Kế thừa nhanh",
ONEKEY_TRANSFER2 = [[
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Kế thừa nhanh sẽ chuyển tất cả cấp Cường hóa, Tăng Sao, Khảm, Đá Qúy từ trang bị cũ sang trang bị mới</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Đá quý đã khảm trên trang bị mới sẽ được tự động bỏ vào túi</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Trang bị Tím có thể kế thừa sang trang bị Tím, trang bị Cam có thể kế thừa sang trang bị Tím và Cam</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Cấp cường hóa và tăng sao của trang bị cũ phải cao hơn trang bị mới</T><BR>10</BR>
]],  
ACTIVITY_TEXT102 = "Chú ý: Nếu chưa rút được quẻ trong thiết lập tổ hợp mà kết thúc bói quẻ, phần thưởng sẽ được lấy trong Kho Thưởng thường, tính theo bội số x1.",
ACTIVITY_TEXT103 = "Thiết lập tổ hợp",
ACTIVITY_TEXT104 = "Quẻ",
ACTIVITY_TEXT105 = "Bội số", 
ACTIVITY_TEXT106 = "Bói lại",
ACTIVITY_TEXT107 = "Đã nhận được quẻ [%s]. Bạn có muốn bói lại không?", 
BLESS_TEXT1 = "Kích hoạt Cầu Phúc cần tốn ",
BLESS_TEXT2 = "Lv%s mới được kích hoạt",
BLESS_TEXT3 = "Hiện không có Cầu Phúc có thể gộp",
BLESS_TEXT4 = "Có thể nhận EXP: ",
OPTIMIZE_TEXT55 = "Mạo Hiểm",
GEM_STONE3 = "Hãy chọn đá cần gộp",
SETSPEED_ATT = "Chỉ chủ phòng được thiết lập",
PASTURE_TEXT60 = " ngày trước",
PASTURE_TEXT61 = " tháng trước",
ACTIVITY_TEXT108 = "Đến chỗ Xe Đẩy Nhỏ",
ACTIVITY_TEXT109 = "Đá Chiêm Tinh không đủ, đến chỗ Xe Đẩy Nhỏ để nhận thêm?",
GIFTLIMIT_ATT = "Chỉ bạn bè mới được tặng quà",
CANSWEEPT = "Có Thẻ Phúc Lợi hoặc đạt VIP 2 trở lên mới được càn quét nhanh",
FETTER_REWARD = "Thưởng Duyên Nợ",
CURRENT_MULTIPLE = "Bội số hiện tại:",
YOUWAN_TEXT1 = "Tôi đã đọc và đồng ý",
YOUWAN_TEXT2 = "Điều khoản sử dụng trò chơi",
YOUWAN_TEXT3 = "và",
YOUWAN_TEXT4 = "Chính sách bảo mật thông tin",
EVERY_MONTHDAY = "Ngày cuối cùng mỗi tháng",
CHARM_LIFT34 = "Đã đề cử",
CHARM_LIFT35 = "Người chơi này đã đạt tối đa số lần được Thích hôm nay",

THIS_MONTH = "Tháng này",
ROOM_HAVE_FULL = "Số người trong phòng đã đầy",
KID_TEXT247 = "Chọn chứng nhận mở rộng",
KID_TEXT248 = "Mở rộng nhà thành công",
MARRY_CENTER = "Nguyệt Lão",
SPACE_CITY = "Thành phố:",
SPACE_CITY2 = "Không",
SPACE_CITY3 = "Hãy chọn tỉnh",
NOT_WEDDING = "Chưa có Hôn Lễ",
OPTIMIZE_TEXT80 = "Thuộc tính tăng của nhân vật",
ACTIVITY_TEXT110 = {"Quà Noel", "Noel Vui vẻ", "Nhiệm vụ Noel", "Noel Vui vẻ"},
ACTIVITY_TEXT130 = "Quà Trung Thu",
PHANTOM_EQUIPMENT24 = "Tự động đặt vào",
PHANTOM_EQUIPMENT25 = "Trong túi không có trang bị để ghép, không thể đặt vào",
OPTIMIZE_TEXT56 = "Sư môn",
OPTIMIZE_TEXT57 = "Sư môn tăng",
OPTIMIZE_TEXT58 = "Kỹ năng sư môn",
OPTIMIZE_TEXT59 = "Chọn rương",
OPTIMIZE_TEXT60 = "1. Sau khi mua rương, cùng sư phụ tổ đội khiêu chiến phó bản, thi đấu có thể nhận Năng Động mở khóa rương",
OPTIMIZE_TEXT61 = "2. Sau khi mở khóa rương, Sư Đồ có thể nhận thưởng phong phú",
OPTIMIZE_TEXT62 = "3. Mỗi ngày có thể mua rương 1 lần",
OPTIMIZE_TEXT63 = "4. Thưởng Rương-Cao phong phú hơn",
OPTIMIZE_TEXT64 = "Năng Động hiện tại của đệ tử:",
OPTIMIZE_TEXT65 = "Mở khóa Năng Động",
OPTIMIZE_TEXT66 = "Sư phụ được nhận thưởng",
OPTIMIZE_TEXT67 = "Hiện không có sư phụ, hãy bái sư",
OPTIMIZE_TEXT68 = "Chưa có kỹ năng",
OPTIMIZE_TEXT69 = "Chọn thiết lập kỹ năng",
OPTIMIZE_TEXT70 = "Hãy chọn rương muốn mua",
OPTIMIZE_TEXT71 = "Đệ tử mới được mua rương này",
OPTIMIZE_TEXT72 = "Đóng máy chủ sư môn",
OPTIMIZE_TEXT73 = {"Đã nhận","Nhiệm vụ chưa xong không thể nhận","Đã giải trừ quan hệ Sư Đồ","Nhận thất bại","Hôm nay đã nhận đủ","Chưa mua rương"},
OPTIMIZE_TEXT74 = {"Mua thành công","Đã mua","Bạn chưa có sư phụ","Vật phẩm không đủ","Mua thất bại"},
OPTIMIZE_TEXT75 = "Thiết lập thất bại",
OPTIMIZE_TEXT76 = "Hiện không có đệ tử, hãy nhận đệ tử",
OPTIMIZE_TEXT77 = {"Lực chiến, cấp đối phương cao hơn bạn","Lực chiến, cấp đối phương thấp hơn bạn","Bạn đã có sư phụ","Đệ tử của bạn đã đầy","Không thể làm sư đồ lẫn nhau"},
OPTIMIZE_TEXT78 = {"Nhận thành công","Đã bị trục xuất khỏi sư môn", "Đã nhận", "Thất bại","Đã có cấp kỹ năng cao hơn, không thể nhận"},
COMMUNITYINFO240 = "Chưa chọn người chơi",
ACTIVITY_TEXT111 = "Câu cá miễn phí",
ACTIVITY_TEXT112 = "Câu Cá 1 lần",
ACTIVITY_TEXT113 = "Câu Cá 5 lần",
ACTIVITY_TEXT114 = "Mồi Câu: ",
ACTIVITY_TEXT115 = "Mảnh không đủ, có thể nhận thêm từ hoạt động Câu Cá!",
ACTIVITY_TEXT116 = "Chuyên Gia Câu Cá",
ACTIVITY_TEXT117 = "Tiệm Câu Cá",
ACTIVITY_TEXT118 = "BXH Câu Cá",
ACTIVITY_TEXT119 = [[
<T C="229,105,22" S="22" P="1">Quy tắc hoạt động Câu Cá</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Mỗi ngày đăng nhập trò chơi có thể nhận 1 lần câu cá, số lần miễn phí sẽ xóa cách ngày.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Dùng Cần Câu-Sơ câu 1 lần, tốn 1 Mồi Câu, nhận 1 phần thưởng, có thể nhận ngẫu nhiên Mảnh Vảy Cá.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Dùng Cần Câu-Cao câu 1 lần, tốn 2 Mồi Câu, nhận 2 phần thưởng, được nhận ngẫu nhiên Mảnh Vảy Cá, dùng Cần Câu-Cao có cơ hội nhận thưởng phong phú hơn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Chuyên Gia Câu Cá: Mỗi ngày mỗi giai đoạn có thể hoàn thành nhận 1 lần thưởng, dữ liệu mỗi ngày sẽ xóa cách ngày, hãy nhận thưởng kịp thời.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Cuồng Câu Cá: Trong hoạt động chỉ được hoàn thành nhận 1 lần, xong nhiệm vụ hãy kịp thời nhận thưởng, hoạt động kết thúc sẽ xóa toàn bộ.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">BXH: Xếp hạng theo số điểm đạt được, Top 100 người chơi có thể nhận thưởng hấp dẫn</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Mồi Câu & Mảnh Vảy Cá, sau khi hoạt động offline sẽ xóa toàn bộ, hãy sử dụng hợp lý!</T><BR>10</BR>
]],
ACTIVITY_TEXT120 = "Thưởng Lớn Câu Cá",
ACTIVITY_TEXT121 = "Cá Chép May Mắn",
ACTIVITY_TEXT122 = "Mảnh không đủ, có thể nhận thêm từ hoạt động Câu Cá!",
ACTIVITY_TEXT123 = "Mồi Câu không đủ, đến Xe Đẩy Nhỏ nhận?",
TABOO_TEXT4 = "Đổi Tinh Thạch",
TABOO_TEXT5 = "Chọn Xúc Xắc",
TABOO_TEXT6 = "%d/%d vòng",
TABOO_TEXT7 = "Chưa có Xúc Xắc Điều Khiển Từ Xa",
ACTIVITY_TEXT124 = {"Cá Trắm Cỏ","Cá Rô Phi","Tôm Hùm Đất","Cá Diếc","Cá Koi"},
ACTIVITY_TEXT125 = "Loại Cá",
ACTIVITY_TEXT126 = [[<T C="255,236,193" S="22" P="1" SC="132,66,29" SS="4" SE="1"> vô cùng may mắn, </T><T C="255,255,255" S="22" P="1" SC="132,66,29" SS="4" SE="1">nhận được </T>]],
ACTIVITY_TEXT127 = [[<T C="255,236,193" S="22" P="1" SC="132,66,29" SS="4" SE="1">được phúc lành trời ban, </T><T C="255,255,255" S="22" P="1" SC="132,66,29" SS="4" SE="1">nhận được </T>]],
PROFESSION_ADVANCE1 = "Kỹ năng tăng bậc",
PROFESSION_ADVANCE2 = "Bậc %d tầng %d",
OPTIMIZE_TEXT79 = "Đã đạt cấp tối đa, không thể lên cấp",
ACTIVITY_TEXT128 = "Đang câu cá",
ACTIVITY_TEXT129 = "Mảnh không đủ, có thể nhận thêm từ hoạt động Câu Cá!",
CANSWEEPT = "Có Thẻ Phúc Lợi hoặc cấp VIP trên 2 có thể càn quét nhanh",
OPTIMIZE_TEXT79 = "Lv35 mở thưởng sư phụ",
ACTIVITY_TEXT131 = "Hôm nay đã dùng hết số lần mua giới hạn",
ACTIVITY_TEXT132 = "Đã dùng hết số lần mua giới hạn vật phẩm này",
ACTIVITY_TEXT134 = "Câu được",
ACTIVITY_TEXT135 = {"Cần Câu-Sơ","Cần Câu -Cao"},
ACTIVITY_TEXT136 = "Cuồng Câu Cá",
ACTIVITY_TEXT137 = "Nhận Mảnh Vảy Cá",
OPTIMIZE_TEXT85 = "Lv35 mở thưởng sư phụ",
OPTIMIZE_TEXT86 = "Nhấp hình kỹ năng có thể đổi kỹ năng sư môn",
OPTIMIZE_TEXT87 = "Chưa có bạn bè sư môn",
OPTIMIZE_TEXT88 = [[%s của bạn: %s mời bạn tham gia %s, đồng ý?]],
TABOO_TEXT8 = "Đã nhận %d %s",
OPTIMIZE_TEXT89 = "Phó bản Vực Sâu",
OPTIMIZE_TEXT90 = "Sư đức của tôi",
OPTIMIZE_TEXT91 = "Không thể mang kỹ năng giống nhau",
OPTIMIZE_TEXT92 = "%s của bạn %s đã từ chối lời mời tổ đội của bời, phát động chat riêng?",
KID_TEXT249 = "Chọn Thẻ Đổi Giới Tính Con",
KID_TEXT250 = "Chọn Bút Đổi Tên Con",
ACTIVITY_TEXT133 = "5 lần câu nhận",
OPTIMIZE_TEXT93 = "Đã có sư phụ",
OPTIMIZE_TEXT94 = "Đã xin phép",
OPTIMIZE_TEXT95 = "Không thể xin phép bản thân",
OPTIMIZE_TEXT96 = "Lực chiến hoặc cấp đối phương thấp hơn bạn",
OPTIMIZE_TEXT97 = "Đệ tử đã đầy",
OPTIMIZE_TEXT98 = "Không thể là sư đồ lẫn nhau",
OPTIMIZE_TEXT99 = "Lực chiến hoặc cấp đối phương cao hơn bạn",
UGLY_SHOW = "Show Diễn Chú Hề",
RANK_MEDAL = "BXH Huy Chương",
SCORE_MEDAL = "Điểm Huy Chương",
CHARMSPACE_12 = "Chưa báo danh",
CHARMSPACE_13 = "Số lần được Thích của người chơi đã đạt tối đa",
ISLAND_OWNER_TEXT1 = "Khiêu chiến Lãnh Chúa",
ISLAND_OWNER_TEXT2 = "Thời gian bảo vệ:",
ISLAND_OWNER_TEXT3 = "Thời gian chiếm: ",
ISLAND_OWNER_TEXT4 = "Thưởng trợ chiến",
ISLAND_OWNER_TEXT5 = "Vật chất có thể cướp",
ISLAND_OWNER_TEXT6 = "Đoạt tài nguyên",
ISLAND_OWNER_TEXT7 = "%s mời bạn khiêu chiến Lãnh Chúa %s (%s), đồng ý không?",
ISLAND_OWNER_TEXT8 = "%s mời bạn khiêu chiến Lãnh Chúa %s (%s) Lãnh Chúa, đồng ý không?\n(Chủ phòng đã là Lãnh Chúa của Lãnh Địa khác, khiêu chiến thành công sẽ chỉ nhận được thưởng cướp đoạt)",
ISLAND_OWNER_TEXT9 = "Cướp Lãnh Chúa",
ISLAND_OWNER_TEXT10 = "Thời gian cướp: ",
ISLAND_OWNER_TEXT11 = "Phát động phản kích",
ISLAND_OWNER_TEXT12 = "Lãnh Địa của bạn bị %s %d người chơi cướp, bạn mất địa vị Lãnh Chúa và mất %s, phát động phản kích họ trong thời gian quy định có thể đoạt lại lợi ích đã mất, và nhận thêm quà phản kích do hệ thống thưởng. (Tổ đội phản kích sẽ không khiến thưởng ít đi)",
ISLAND_OWNER_TEXT13 = "Sau khi vượt ải mới được khiêu chiến Lãnh Chúa",
ISLAND_OWNER_TEXT14 = "Bạn đã đủ %s Lãnh Địa, khiêu chiến thành công chỉ được cướp tài nguyên, tiếp tục?",
ISLAND_OWNER_TEXT15 = "Người này đã từ bỏ Lãnh Địa, không thể Phản Kích.",
ISLAND_OWNER_TEXT16 = "Phản kích khiêu chiến",
ISLAND_OWNER_TEXT17 = "Địa Ngục đạt 3 Sao mới được khiêu chiến Lãnh Chúa",
ISLAND_OWNER_TEXT18 = "Dùng %s có thể tăng %d điểm trưởng thành",
ISLAND_OWNER_TEXT19 = "Tối đa dùng 1",
ISLAND_OWNER_TEXT20 = "Trợ chiến Lãnh Địa",
TABOO_TEXT9 = "00:00 Thứ 2 hàng tuần tạo mới thưởng vòng chạy",
ISLAND_OWNER_TEXT21 = "Chưa có vật tư để cướp",
ISLAND_OWNER_TEXT22 = "Lần này không có vật tư để cướp",
ISLAND_OWNER_TEXT23 = [[
  <T C="229,105,22" S="22" P="1">Quy tắc tranh đoạt</T><BR>10</BR>
  <T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Cướp đoạt Lãnh Địa của người khác thành công sẽ nhận được tài nguyên và chiếm lĩnh Lãnh Địa đó. Người bị cướp đoạt sẽ bị mất một phần tài nguyên. </T><BR>10</BR>
  <T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Mỗi người chơi được chiếm lĩnh tối đa 1 Lãnh Địa. Sau khi chiếm Lãnh Địa, vẫn có thể cướp đoạt tài nguyên từ Lãnh Địa khác. Mỗi ngày tối đa nhận thưởng cướp tài nguyên 3 lần. </T><BR>10</BR>
  <T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Độ khó Tinh Anh, Ác Mộng có thể tổ đội chiếm lĩnh Lãnh Địa. Sau khi chiếm được, chủ phòng sẽ là Lãnh Chúa, các thành viên còn lại là người trợ chiến. </T><BR>10</BR>
  <T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi người chơi có thể trợ chiến cho tối đa 2 Lãnh Địa. Người trợ chiến cũng sẽ nhận được tài nguyên tích lũy như Lãnh Chúa. Khi kết thúc trợ chiến, tài nguyên sẽ được gửi qua thư. </T><BR>10</BR>
  <T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Lãnh Chúa và người trợ chiến đều có thể chọn rời đi, khi rời đi sẽ tổng kết thưởng. </T><BR>10</BR>
  <T C="229,105,22" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0">Khi kết toán thưởng, nếu Lãnh Địa bị chiếm giữ dưới 8 giờ, không thể thu hoạch tài nguyên chiếm giữ. </T><BR>10</BR>
  <T C="229,105,22" S="20" P="0">7. </T><T C="127,70,26" S="20" P="0">Sau khi bị chiếm mất Lãnh Địa, có thể Phản Kích. Nếu Phản Kích thành công, sẽ đoạt lại được tài nguyên đã tổn thất, hệ thống cũng sẽ tặng thêm phần Quà Phản Kích. </T><BR>10</BR>
  <T C="229,105,22" S="20" P="0">8. </T><T C="127,70,26" S="20" P="0">Ải cuối mỗi chương, Lãnh Chúa và người trợ chiến có thể nhận danh hiệu riêng (khi thoát, hệ thống sẽ tự động thu hồi)</T><BR>10</BR>
]],
ISLAND_OWNER_TEXT24 = "Rời đi sẽ bắt đầu tổng kết thưởng, xác nhận rời đi ngay? (Thời gian chiếm lĩnh không đủ 8 giờ sẽ không nhận được lợi ích)",
ISLAND_OWNER_TEXT25 = "Phản kích đã kết thúc",
ISLAND_OWNER_TEXT26 = "Trong đội có người chơi là Lãnh Chúa hoặc người trợ chiến",
ISLAND_OWNER_TEXT27 = "Số Lãnh Địa mà người chơi này trợ chiến đã đầy, nếu khiêu chiến thành công, người chơi này sẽ không tham gia canh giữ, tiếp tục?",
BATTLE_BUFF_1 = "N/A",
BATTLE_BUFF_2 = "%.1fs",
ACTIVITY_TEXT140 = "Bắn",
ACTIVITY_TEXT141 = "Xem thưởng",
ACTIVITY_TEXT142 = "BXH Bi",
ACTIVITY_TEXT143 = "Hồi Ký",
ACTIVITY_TEXT144 = "Nhiệm Vụ Bắn Bi",
ACTIVITY_TEXT145 = "Bạn bắn bi, máy bắn đã nạp đầy bi!",
ACTIVITY_TEXT146 = "Xu Chơi Game không đủ, đến Xe Đẩy Nhỏ nhận?",
ACTIVITY_TEXT147 = "Bạn bắn bi, máy bắn không có bi, hãy nạp Xu!",
ACTIVITY_TEXT148 = "Nạp Xu",
ACTIVITY_TEXT149 = "Nạp 5 Xu",
ACTIVITY_TEXT150 = [[
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Mỗi lần nạp Xu cần tốn 1 Xu Chơi Game, có thể nhận 1 viên bi, cứ bắn 1 viên bi vào Kho Thưởng sẽ được nhận ngẫu nhiên 1 phần thưởng;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Bắn bi có xác suất nhận Mảnh Ký Ức, Mảnh Ký Ức có thể mở Album Kỷ Niệm, mở hoàn chỉnh 1 bức ảnh, được nhận thêm thưởng hấp dẫn;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày có thể nhận và hoàn thành Nhiệm Vụ Ngày 1 lần, hôm sau sẽ tái lập. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, sẽ bị xóa hết khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH Ký Ức: Xếp hạng theo Mảnh Ký Ức người chơi nhận, top 100 người chơi có thể nhận thưởng phong phú; BXH Bi: Xếp hạng theo số lượng bi người chơi bắn, top 50 người chơi có thể nhận thưởng hấp dẫn;</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Xu Chơi Game và Mảnh Ký Ức sẽ xóa toàn bộ sau khi hoạt động offline;</T><BR>10</BR>
]],
ACTIVITY_TEXT151 = "Nhiệm Vụ Bắn Bi",
ACTIVITY_TEXT152 = "Hồi Ký",
ACTIVITY_TEXT153 = "Quà Tuổi Thơ",
ACTIVITY_TEXT154 = "Mảnh Ký Ức",
ACTIVITY_TEXT155 = "Số Bi",
ACTIVITY_TEXT156 = "BXH Ký Ức",
ACTIVITY_TEXT157 = "Hoàn thành",
ACTIVITY_TEXT158 = "Đang bắn",
ACTIVITY_TEXT159 = "Đang nạp xu",
ACTIVITY_TEXT160 = {"Nạp Xu thành công","Xu Chơi Game không đủ","Đã đạt tối đa"},
ACTIVITY_TEXT161 = "Mở tập bản đồ",
ACTIVITY_TEXT162 = {",Không có ảnh này","Cần mở khóa ảnh trước đó","Đã nhận thưởng"},
ACTIVITY_TEXT163 = {",Không có ảnh này","Ảnh này chưa mở","Đã nhận thưởng"},
ACTIVITY_TEXT164 = [[<T C="127,70,26" S="20" P="1">Điểm: </T><T C="229,105,22" S="20" P="1">%d</T>]],
ACTIVITY_TEXT165 = [[<T C="127,70,26" S="20" P="1">Hạng: </T><T C="229,105,22" S="20" P="1">%d</T>]],
CITY_TITLE1 = "Quà",
CITY_TITLE2 = "Tiệm Tinh Anh",
CITY_TITLE3 = "Quà Cầu Nguyện",
CITY_TITLE4 = "Bóng Đá\nCuồng Nhiệt",
CITY_TITLE5 = "7 Ngày Vui Vẻ",
CITY_TITLE6 = "Lãnh Chúa Trở Về",
CITY_TITLE7 = "Khảo sát",
CITY_TITLE8 = "Lắc Thưởng",
CITY_TITLE9 = "Powlott",
CITY_TITLE10 = "Valentine Tỏ Tình",
CITY_TITLE11 = "Đấu Giá",
CITY_TITLE12 = "Đăng Nhập\nLễ Hội",
CITY_TITLE13 = "VIP\nHổ Phách",
CITY_TITLE14 = "Lễ Hội Mua Sắm",
CITY_TITLE15 = "Tiến Cử Mỗi Ngày",
CITY_TITLE16 = "Xin Xăm",
CITY_TITLE17 = "Mừng Sinh Nhật",
CITY_TITLE18 = "Tứ Tượng",
CITY_TITLE19 = "Lắc Thưởng",
CITY_TITLE20 = "Đăng nhập giới hạn",
CITY_TITLE21 = "Quà Trở Về",
CITY_TITLE22 = "Lực Chiến Phi Thăng",
CITY_TITLE23 = "Bắn Cung",
CITY_TITLE24 = "Phát Triển",
CITY_TITLE25 = "Ảo Cảnh Kỳ Môn",
CITY_TITLE26 = "Câu cá",
CITY_TITLE27 = "Tặng",
CITY_TITLE28 = "Diễn đàn",
CITY_TITLE29 = "Xã Hội",
CITY_TITLE30 = "Nhân Vật",
CITY_TITLE31 = "Viên Bi Tuổi Thơ",
CITY_TITLE32 = "Sảnh Kết Hôn",
CITY_TITLE33 = "Chung Cư Tình Yêu",
CITY_TITLE34 = "Mỏ Đá",
CITY_TITLE35 = "Nữ Thương Gia Thần Bí",
ACTIVITY_TEXT166 = "Đã nhận",
ACTIVITY_TEXT167 = {"Nhận Ảnh Chuyện Vui Thuở Nhỏ","Nhận Ảnh Tình Cảm Thơ Ngây","Nhận Ảnh Tình Cảm Thơ Ngây","Nhận Ảnh Hồn Nhiên"},
ACTIVITY_TEXT168 = "Cần mở ảnh hiện tại mới được mở khóa ảnh tiếp theo!",
ACTIVITY_TEXT169 = "Mở nhanh",
ACTIVITY_TEXT170 = "BXH Bi kỳ này đến %s kết thúc",
ACTIVITY_TEXT171 = [[<T C="127,70,26" S="20" P="1">Số viên bi của tôi:</T><T C="229,105,22" S="20" P="1">%d</T>]],
ACTIVITY_TEXT172 = [[<T C="127,70,26" S="20" P="1">Mảnh Ký Ức của tôi:</T><T C="229,105,22" S="20" P="1">%d</T>]],
ACTIVITY_TEXT173 = "Nhận được phần thưởng cấp S",
CHARM_LIFT36 = "Được thích nhận được tháng này:",
CHARM_LIFT37 = "Tái lập lúc 24h ngày cuối cùng mỗi tháng (Số lượt thích cần > %d mới vào BXH)",
CHARM_LIFT38 =
[[
<T C="229,105,22" S="22" P="0">1. </T><T C="127,70,26" S="22" P="0"> Thích người chơi khác có thể nhận thưởng Nổi Tiếng;</T><BR></BR>
<T C="229,105,22" S="22" P="0">2. </T><T C="127,70,26" S="22" P="0">Người chơi hôm qua điểm năng động cao được nhiều cử nhiều hơn.</T><BR></BR>
<T C="229,105,22" S="22" P="0">3. </T><T C="127,70,26" S="22" P="0"> Hoạt động này ngày cuối hàng tháng tổng kết, thưởng được gửi qua thư.</T><BR></BR>
]],
RUNE_OPTIMIZE = "Cộng hưởng Bùa",
RUNE_OPTIMIZE1 = "Tốn %d Mảnh Bùa để Cộng Hưởng Bùa? Cộng Hưởng Bùa sẽ giúp tăng 2.5%% thuộc tính nhân vật, duy trì 24 giờ.",
RUNE_OPTIMIZE2 = "Tốn %s mở?",
RUNE_OPTIMIZE3 = "Số Mảnh Bùa hơn %d sẽ kích hoạt",
RUNE_OPTIMIZE4 = "Kích hoạt cộng hưởng Bùa thành công",
RUNE_OPTIMIZE5 = "Hiện Bùa đang cộng hưởng, buff cộng hưởng duy trì %s",
CARD_TEXT38 = "Mở 1 lần",
CARD_TEXT39 = "Mở %d lần",
KID_TEXT251 = "Tuyên ngôn:",
KID_TEXT252 = "Nội dung quá dài",
BLESS_TEXT5 = "Hiện tại Cầu Phúc đã có thể lên cấp đến cấp tối đa",
COMMUNITYINFO241 = "Vật Tổ Ban Phúc",
COMMUNITYINFO242 = "x2 Lễ Bái",
COMMUNITYINFO243 = "Tốn %d Cống hiến cá nhân để thử thách Vật Tổ, thử thách Vật Tổ duy trì 24 giờ",
OPTIMIZE_TEXT100 = "Truyền dạy thành công",
COMMUNITYINFO244 = "Thưởng lễ bái:",
COMMUNITYINFO245 = "Sinh Lực tăng:",
COMMUNITYINFO246 = "Tấn Công ăng:",
COMMUNITYINFO247 = "Phòng Thủ tăng:",
COMMUNITYINFO248 = "Thời gian duy trì Vật Tổ Ban Phúc",
COMMUNITYINFO249 = [[<T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">%s nhân vật tăng %s</T>]],
COMMUNITYINFO250 = "Thử thách Vật Tổ thành công",
HEAD_EFFECT = "Khung Avatar",
HEAD_EFFECT2 = [[Số lượng Khung Avatar có:]],
CITY_TITLE36 = "Đại Gia Nhà Đất",
ACTIVITY_TEXT175 = {"Nền móng","Căn tin","Tiệm Đồ Ăn Vặt","Chuỗi siêu thị","Công ty niêm yết","Tập đoàn bất động sản hàng đầu"},
ACTIVITY_TEXT176 = "Thẻ Đầu Tư không đủ, đến Xe Đẩy Nhỏ nhận?",
ACTIVITY_TEXT177 = "Đại Gia Nhà Đất",
ACTIVITY_TEXT178 = "Bất động sản của tôi",
ACTIVITY_TEXT179 = "Nhiệm Vụ Ngày",
ACTIVITY_TEXT180 = "Đầu Tư",
ACTIVITY_TEXT181 = "Đầu tư 5 lần",
ACTIVITY_TEXT182 = "Nhóm của tôi",
ACTIVITY_TEXT183 = "BXH Đầu Tư",
ACTIVITY_TEXT184 = "Quà Đầu Tư",
ACTIVITY_TEXT185 = [[
<T C="229,105,22" S="22" P="1">Quy tắc hoạt động Đại Gia Nhà Đất</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Cứ đầu tư 1 lần tốn 1 Thẻ Đầu Tư, được nhận ngẫu nhiên 1 phần thưởng và nhiều lợi ích bất động sản, lợi ích bất động sản dùng để lên cấp bất động sản, lên cấp bất động sản có thể nhận thưởng hấp dẫn;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Trong hoạt động, có thể mời bạn lập thành đội, cùng hoàn thành nhiệm vụ. Trong hoạt động, đội đã xác định quan hệ sẽ không thể giải trừ.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">BXH Đầu Tư xếp hạng theo số lần đầu tư cá nhân, top 100 người chơi có thể nhận thưởng hấp dẫn; BXH Nhóm xếp hạng theo tổng lợi ích nhóm, top 20 nhóm có thể nhận thưởng hấp dẫn;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Mỗi ngày có thể nhận và hoàn thành Nhiệm Vụ Ngày 1 lần, hôm sau sẽ tái lập. Trong hoạt động, chỉ được nhận và hoàn thành Nhiệm Vụ Trưởng Thành 1 lần, sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, sẽ bị xóa hết khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Trong hoạt động sẽ mở nhiệm vụ đầu tư giới hạn không theo giờ, hoàn thành điều kiện trong thời gian nhiệm vụ, được nhận thêm thưởng hấp dẫn, xong nhiệm vụ hãy kịp thời nhận thưởng, sau khi nhiệm vụ offline sẽ xóa toàn bộ;</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Thẻ Đầu Tư sẽ xóa toàn bộ sau khi hoạt động offline;!</T><BR>10</BR>
]],
ACTIVITY_TEXT186 = "Mời bạn",
ACTIVITY_TEXT187 = "Người chơi %s mời bạn vào nhóm mình",
ACTIVITY_TEXT188 = [[<T C="127,70,26" S="20" P="1"></T><T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"> đã từ chối lời mời của bạn</T>]],
ACTIVITY_TEXT189 = [[<T C="127,70,26" S="20" P="1"></T><T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"> đã chấp nhận lời mời của bạn</T>]],
ACTIVITY_TEXT190 = "Chú ý: Sau khi vào nhóm, không thể thoát trong thời gian hoạt động",
ACTIVITY_TEXT191 = "Thưởng Đầu Tư Bất Động Sản",
ACTIVITY_TEXT192 = "Thưởng BXH Đầu Tư",
ACTIVITY_TEXT193 = "Thưởng BXH Nhóm",
ACTIVITY_TEXT194 = "Nhà Đầu Tư",
ACTIVITY_TEXT195 = "Đại Gia Nhà Đất",
ACTIVITY_TEXT196 = "BXH Nhóm",
ACTIVITY_TEXT197 = "Số lần đầu tư",
ACTIVITY_TEXT198 = "Nhóm",
ACTIVITY_TEXT199 = "Lợi ích nhóm",
ACTIVITY_TEXT200 = "Hạng nhóm:",
ACTIVITY_TEXT201 = "Chỉ hiện Top %d",
ACTIVITY_TEXT202 = "Nhiệm Vụ Trưởng Thành",
ACTIVITY_TEXT203 = "Chọn bạn bè muốn mời",
ACTIVITY_TEXT204 = "Đang xin phép",
ACTIVITY_TEXT205 = {" thành công","Người này đã vào đội","Người này không phải bạn bè", "Không có trong danh sách mời", "Bạn đã tổ đội rồi", "Số người trong đội đã đầy"},
ACTIVITY_TEXT206 = "Chưa có quà để nhận",
ACTIVITY_TEXT207 = "Lợi ích bất động sản",
ACTIVITY_TEXT208 = "Chú ý: Trong hoạt động chỉ được liên kết 1 người bạn để tổ đội tham gia, sau khi xác nhận liên kết, không thể tác động đến quan hệ liên kết, hãy cẩn thận chọn đồng đội tham gia của bạn!",
ACTIVITY_TEXT209 = "Hợp tác với nhau, quán quân sẽ là của chúng ta",
ACTIVITY_TEXT210 = "Chưa có thông báo",
ACTIVITY_TEXT211 = "Chưa có nhóm",
ACTIVITY_TEXT212 = "Nhiệm vụ Đầu Tư",
ACTIVITY_TEXT213 = "Chú ý: Cần mời bạn thành công mới bắt đầu thống kê số lần đầu tư nhóm",
ACTIVITY_TEXT214 = "Toàn server Đầu Tư đạt số lần chỉ định, được nhận 1 phần thưởng ngẫu nhiên",
BATCH_BUY = "Mua số lượng lớn",
BATCH_BUY_TITLE = "Mua quà số lượng lớn",
BATCH_BUY_TEXT = [[<T C="127,70,26" S="20" P="1">Mua 1 lần số lượng lớn %d %s. Chỉ cần %s</T>]],
BATCH_NOT_BUY = "Chờ",
BATCH_WANT_BUY = "Chưa chọn quà để mua",
GIVE_RED_PACK = "Phát Lì Xì",
COIN_WORD = "Xu",
RED_PACK1 = {"Cung hỉ phát tài,Đại cát đại lợi", "Đại cát đại lợi,Đêm nay ăn gà", "Nhanh tay thì còn,Chậm tay thì hết", "Muôn điều thuận lợi,Vạn sự như ý", "Tâm muốn sự thành,Ngũ phúc lâm môn", "Cả năm bình an,Quanh năm dư dả", "Gia đình thịnh vượng,Phúc thái an khang", "Trăm năm hạnh phúc,vui vẻ bên nhau", "Tân hôn vui vẻ,Long phụng báo điềm lành"},
RED_PACK2 = "Lời Chúc Phúc",
RED_PACK3 = "Tổng số lượng",
RED_PACK4 = "Số lượng Lì Xì",
RED_PACK5 = {"Ôi chậm tay quá!", "Cảm giác như đã bỏ lỡ 100 triệu!", "Quỳ xin đại ca phát thêm ít Lì Xì nữa đi!", "Các vị thổ hào, phát còn ít hơn giành"},
RED_PACK6 = {"Cám ơn Lì Xì của %s!", "Cám ơn đại gia %s!", "Đại gia %s bá đạo!"},
RED_PACK7 = "Bạn đã giành",
RED_PACK8 = "Số lần phát Lì Xì trong ngày đã đạt tối đa",
RED_PACK9 = {"Cám ơn", "Bóc phốt", "Tạm thời không thể nhập bằng văn bản, hãy upload hình ảnh"},
RED_PACK10 = "Quá chậm, Lì Xì đã bị giành hết",
RED_PACK11 = "Lì Xì đến từ %s",
RED_PACK12 = "Người chơi %s phát Lì Xì, mọi người mau đến giành đi",
RED_PACK13 = "Đang chiến đấu, không thể phát Lì Xì",
VIPWEEK_PACKAGE6 = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">Tranh mua còn:</T><T C="5,180,0" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d:%02d:%02d</T>]],
VIPWEEK_PACKAGE7 = [[Thời gian mua giới hạn kết thúc]],
VIPWEEK_PACKAGE8 = [[Quà bất ngờ]],
BATTLE_HUD_TEXT1 = "Đang dùng POW, hãy đổi lại sau",
RED_PACK14 = "Phát Lì Xì, phát Lì Xì kìa, mau đến giành",
AUCTION_HOUSE_TEXT36 = "Thao tác quá nhiều lần, hãy thử lại sau",
UNLIMITED_PURCHASE = "Không mua giới hạn",
DELETEROLE_TEXT1 = "Trải nghiệm không tốt? Bạn có thể phản hồi bất cứ vấn đề gì qua hộp thư góp ý ở trang Thiếp lập trò chơi hoặc liên hệ CSKH, chúng tôi sẽ sẵn lòng cung cấp dịch vụ cho bạn. Tiếp tục xóa vui lòng nhấp nút [Đồng ý]",
DELETEROLE_TEXT2 = "Sắp xóa nhân vật sau:",
DELETEROLE_TEXT3 = "Nhấp [Xác nhận] sẽ vào 7 ngày chờ xóa, trong thời gian chờ có thể hủy bất cứ lúc nào, nếu hết hạn mà vẫn chưa hủy thì nhân vật sẽ tự động xóa và không thể khôi phục, xác nhận muốn xóa nhân vật?",
DELETEROLE_TEXT4 = "Xóa còn:",
DELETEROLE_TEXT5 = "Hủy xóa",
DELETEROLE_TEXT6 = "Trong thời gian đếm ngược bạn có thể hủy xóa bất cứ lúc nào, kết thúc đếm ngược nhân vật sẽ tự động xóa và không thể khôi phục.",
DELETEROLE_TEXT7 = "Xóa vai trò",
CURRENT_ACTIVITY = "Hoạt động:",
WATERCOUNTRY_TEXT1 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn Thế Giới Nước</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Mỗi lần mở chủ đề "Nước Chảy Đá Mòn" cần tốn 1 Bùa Nước, chắc chắn nhận được 1 phần thưởng ngẫu nhiên và 1 Mã Kho Báu. Mỗi lần mở chủ đề "Nước Nguồn Sinh Mệnh" cần tốn 2 Bùa Nước, chắc chắn nhận được 2 phần thưởng ngẫu nhiên và 2 Mã Kho Báu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Người chơi toàn server thu thập đủ số Mã Kho Báu yêu cầu, sẽ mở Kho Báu kỳ này. "Kho Báu Thiên Thủy" mỗi kỳ sẽ rút ngẫu nhiên 1 Mã Kho Báu trúng thưởng. "Kho Báu Tinh Thủy" mỗi kỳ sẽ rút ngẫu nhiên 3 Mã Kho Báu trúng thưởng. "Kho Báu Thanh Thủy" mỗi kỳ sẽ rút ngẫu nhiên 5 Mã Kho Báu trúng thưởng. Người chơi trúng thưởng sẽ nhận được phần thưởng hấp dẫn, mỗi Mã Kho Báu chỉ nhận được 1 loại thưởng, sở hữu càng nhiều Mã Kho Báu, xác suất trúng thưởng càng cao!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Thiên Thủy: Nhiệm Vụ Ngày, mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ tái lập. Trong hoạt động, Nhiệm Vụ Trưởng Thành chỉ có thể hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc, sẽ xóa dữ liệu trên toàn server.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Đầu Tư Thiên Thủy: Trong hoạt động, chỉ có thể hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu trên toàn server.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">BXH: Xếp hạng theo số Bùa Nước mỗi người đã dùng, top 100 được nhận thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Bùa Nước và Mã Kho Báu sẽ bị xóa hết khi hoạt động kết thúc!</T><BR>10</BR>]], 
WATERCOUNTRY_TEXT2 = {"Nhiệm Vụ Thiên Thủy", "Đầu Tư Thiên Thủy", "Kho Báu Hiện Tại", "Xem Lại Đoạt Bảo", "Nước Chảy Đá Mòn", "Nước Nguồn Sinh Mệnh", "Thế Giới Nước", "Tiến độ mở", "Mã đang có", "Kỳ %d", "Kho Báu", "Mã Kho Báu", "Thời gian mở", "Chưa mở thưởng"},
WATERCOUNTRY_TEXT3 = "Quà Server Mới",
BATTLE_HUD_TEXT2 = "Đấu Đào Hố cấm dùng Bay",
CARD_TEXT40 = "Hồn Thẻ",
CARD_TEXT41 = "Tạm không có Thẻ đạt Lv%d",
CARD_TEXT42 = "Đổi Hồn Thẻ",
CARD_TEXT43 = "Lễ bái Hồn Thẻ",
CARD_TEXT44 = "Thuộc tính nhân vật +%s%%",
CARD_TEXT45 = "Duy trì %s giờ",
CARD_TEXT46 = "Lễ bái",
CARD_TEXT47 = "Thẻ đạt Lv%d có thể đổi Mảnh Hồn Thẻ",
CARD_TEXT48 = "Lễ bái thành công",
CARD_TEXT49 = "Buff đang có hiệu lực",
CARD_TEXT50 = "Đổi thất bại",
CARD_TEXT51 = "Hãy tăng cấp Thẻ trước đã",
CARD_TEXT52 = "Mảnh Hồn Thẻ không đủ",
CARD_TEXT54 = "Số lượng thẻ không đủ",
WATERCOUNTRY_TEXT4 = "%s không đủ, đến chỗ Xe Đẩy Nhỏ mua ngay?",
WATERCOUNTRY_TEXT5 = {"Kho Báu Thiên Thủy", "Kho Báu Tinh Thủy", "Kho Báu Thanh Thủy", "Nhận Đá Bùa Nước x%d"},
FOOTMARK_TEXT29 = "Check-in",
FOOTMARK_TEXT30 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Sưu tập dấu chân để Check-in tại các thành phố.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Sau khi tính năng ra mắt, dấu chân nhận lặp lại sẽ được thống kê như mới.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Con Dấu Thành Phố dùng đổi thưởng tại Tiệm Thành Phố.</T><BR>10</BR>
]], 
FOOTMARK_TEXT31 = "Thưởng Check-in",
FOOTMARK_TEXT32 = "Dấu Check-in",
CASTSOUL_TEXT21 = "Ô Cộng Hưởng",
CASTSOUL_TEXT22 = "Lv%d mở",
CASTSOUL_TEXT23 = "Hồn cùng hàng dọc đều phải đạt đến ô Lv%d mới có thể mở",
CASTSOUL_TEXT24 = "Hồn cùng hàng dọc tăng", 
CARD_TEXT53 = "Lễ bái còn: ",
FOOTMARK_TEXT33 = "Tiệm Thành Phố",
DECORATIONS_TEXT1 = {"Giăng Đèn Kết Hoa", "Thắp Đèn %d lần", "Thiệp Chúc", "Nhận Thiệp Chúc x%d", "Thẻ Quà", "Chúc Phúc", "Thiệp Chúc của tôi", "Tặng Quà", "Nhận Quà", "Số lần tặng quà hôm nay đã đạt tối đa", "Số lần nhận quà hôm nay đã đạt tối đa", "Tặng quà thành công", "Số lần Thắp Đèn: ", "Số lần  tặng quà hôm nay không đủ", "Hãy chọn bạn bè muốn tặng quà", "Thẻ Quà tặng bạn, chúc phúc yên vui!", "Chưa xếp đầy Thiệp Chúc/Thẻ Quà!"},
DECORATIONS_TEXT2 = "Số lần Thắp Đèn", 
DECORATIONS_TEXT3 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Mỗi lần Thắp Đèn cần tốn 1 Ngọn Lửa, mỗi mở 1 Lồng Đèn sẽ được nhận 1 phần thưởng ngẫu nhiên, có cơ hội nhận được Thiệp Chúc. Mở toàn bộ Lồng Đèn sẽ được nhận thêm thưởng "Giăng Đèn Kết Hoa".</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Trong hoạt động, có thể dùng Thiệp Chúc của bản thân để tặng Thẻ Quà cho bạn bè. Trong họat động "Chúc Phúc Đầu Năm Mới" cần tốn 3 Thẻ Quà/Thiệp Chúc + 1 Thiệp Chúc để "Chúc Phúc", nhận thêm phần thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày có thể hoàn thành và nhận thưởng Nhiệm Vụ Ngày 1 lần, hôm sau sẽ tái lập. Trong hoạt động, chỉ được hoàn thành Nhiệm Vụ Trưởng Thành 1 lần, sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, dữ liệu sẽ bị xóa hết khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH: Xếp hạng theo số lần Thắp Đèn của mỗi người, top 100 được nhận thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Ngọn Lửa, Thiệp Chúc và Thẻ Quà sẽ bị xóa hết sau khi hoạt động kết thúc!</T><BR>10</BR>]], 
DECORATIONS_TEXT4 = [[<T C="127,70,26" S="20" P="1" SC="132,66,29" SS="4" SE="0">Số lần được nhận quà: </T><T C="229,105,22" S="20" P="1" SC="132,66,29" SS="4" SE="0">%s</T>]],
CASTSOUL_TEXT25 = "Hồn",
FOOTMARK_TEXT34 = "Chờ Check-in",
DELETEROLE_TEXT1 = "Nếu gặp phải vấn đề gì khi trải nghiệm, bạn có thể liên hệ CSKH để phản ánh. Nhấp nút [Đồng ý] để xác nhận tiếp tục xóa",

DELETEROLE_TEXT5 = "Hủy xóa nhân vật",

BREAK_TEXT1 = {"Đột phá thành công!", "Tiến độ hiện tại: ", "Cấp tối đa", "Tiệm Năng Lượng", "Giá cả và số lượng Đá Năng Lượng tồn kho sẽ được cập nhật mỗi ngày", "Tồn kho: ", "Số tồn kho không đủ, mai hãy quay lại nhé", "Đã sang ngày mới rồi, số liệu đã được tạo mới"},
BREAK_TEXT2 = "Đột Phá", 
RANK_TIPS_4 = {"Đổi tất cả server","Đổi server hiện tại"},
RANK_TIPS_5 = {"Sảnh Danh Vọng Server","BXH Server","Sảnh Danh Vọng Toàn Server","BXH Toàn Server"},
NEWYEARWISH_TEXT1 = {"Ước Nguyện Năm Mới", "Kế Hoạch Năm Mới", "Số lần Cầu Nguyện", "Tường Tâm Nguyện", "BXH Tâm Nguyện", "Quà Tâm Nguyện", "Nhận được chữ %s", "Muốn có tất cả", "Sưu tập đủ bộ chữ theo chủ đề, sẽ nhận được Quà Tâm Nguyện"},
NEWYEARWISH_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Làm nhiệm vụ hoặc vào cửa hàng mua Thẻ Ước Nguyện. Mỗi lần Cầu Nguyện sẽ tốn 1 Thẻ Ước Nguyện, chắc chắn nhận được 1 phần thưởng, nhận chữ ngẫu nhiên theo chủ đề.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Cầu Nguyện càng nhiều lần, càng có cơ hội nhận được thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Kế Hoạch Năm Mới: Chia làm Kế Hoạch Năm Mới 1 và Kế Hoạch Năm Mới 2. Kế Hoạch Năm Mới 1 mỗi ngày chỉ được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ tái lập. Kế Hoạch Năm Mới 2 trong hoạt động chỉ được hoàn thành và nhận thưởng 1 lần, sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa hết dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Tường Tâm Nguyện: Mỗi khi sưu tập đủ bộ chữ theo chủ đề, sẽ nhận được 1 phần Quà Tâm Nguyện. Nếu sưu tập đủ toàn bộ chữ trên Tường Tâm Nguyện sẽ được nhận thêm 1 phần Thưởng Tâm Nguyện.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">BXH Tâm Nguyện: Xếp hạng theo số lần Cầu Nguyện, Top 200 người chơi được nhận phần thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Thẻ Ước Nguyện và các chữ sưu tập được sẽ bị xóa hết khi hoạt động kết thúc, hãy dùng kịp thời!</T><BR>10</BR>]], 
NEWYEARWISH_TEXT3 = {{"Thế", "Giới", "Hòa", "Bình"}, {"Trong", "Túi", "Toàn", "Là", "Tiền"}, {"Mạnh", "Khỏe", "Sống", "Lâu"}, {"Ước", "Mơ", "Vĩ", "Đại"}, {"Tình", "Yêu", "Được", "Đáp", "Lại"}, {"Đánh", "Đâu", "Thắng", "Đó"}},
YEARMONSTER_TEXT1 = {"Đại Chiến Niên Thú", "Nhiệm Vụ Niên Thú", "Tiệm Niên Thú", "BXH Dũng Sĩ", "Quà Năm Mới", "HP: ", "Tấn công %d lần", "Tham gia tấn công Niên Thú, sau khi diệt sẽ nhận được 1 phần Quà Năm Mới", "Số lần tấn công", "Niên Thú thứ %d", "Nhận được %s x%d"},
YEARMONSTER_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Mỗi lần tấn công Niên Thú sẽ tốn 1 Pháo, chắc chắn nhận được 1 phần thưởng ngẫu nhiên, có xác suất rơi Lì Xì. Lì Xì có thể dùng đổi thưởng trong Tiệm Niên Thú.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Người chơi mỗi tham gia diệt 1 Niên Thú, sẽ được nhận 1 phần Quà Năm Mới</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mỗi ngày có thể hoàn thành và nhận thưởng Nhiệm Vụ Ngày 1 lần, hôm sau sẽ tái lập. Trong hoạt động, chỉ được hoàn thành Nhiệm Vụ Trưởng Thành 1 lần, sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, dữ liệu sẽ bị xóa hết khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH Dũng Sĩ sẽ xếp hạng theo số Pháo mà mỗi người đã dùng, Top 100 người chơi được nhận phần thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Pháo và Lì Xì sẽ bị xóa hết khi hoạt động kết thúc!</T><BR>10</BR>]], 
BEATENGINEER_TEXT1 = {"Sách Lược Tấn Công", "Tấn công %d lần", "Thưởng Tấn Công", "Mục tiêu", "BXH Tấn Công", "Số lần tấn công", "Thưởng Chảo Bằng", "Thưởng Chùy Gai", "BXH Chảo Bằng", "BXH Chùy Gai", "Cùng tấn công", "Cùng tấn công để nhận nhiều phần thưởng hơn", "Đạo cụ tấn công", "Mua %d %s", "Chảo Bằng, cần tốn Kim Cương Khóa hoặc Kim Cương Lam", "Chùy Gai, cần tốn Kim Cương Lam", "Tấn Công Mỗi Ngày", "Tấn Công Liên Tục", "Kế Hoạch Năm Mới 1", "Kế Hoạch Năm Mới 2", "Kế Hoạch Phiên Bản Kế"},
BEATENGINEER_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Dùng Chảo Bằng, tốn Kim Cương Khóa hoặc Kim Cương Lam để tấn công. Dùng Chùy Gai, cần tốn Kim Cương Lam để tấn công.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Mỗi lần tấn công chắc chắn nhận được 1 phần thưởng, tấn công đủ số lần yêu cầu sẽ kích hoạt phần thưởng lớn.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Mục tiêu: Gồm Tấn Công Mỗi Ngày và Tấn Công Liên Tục. Tấn Công Mỗi Ngày: Mỗi ngày chỉ được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ tái lập. Tấn Công Liên Tục: Trong hoạt động, chỉ có thể hoàn thành và nhận thưởng 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa hết dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH Tấn Công: Chia làm BXH Chảo Bằng và BXH Chùy Gai, xếp hạng theo số lần tấn công, Top 100 người chơi trên mỗi BXH sẽ nhận được phần thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Khi hoạt động kết thúc, tất cả số liệu sẽ bị xóa, sau khi hoàn thành nhiệm vụ hãy nhận thưởng kịp thời.</T><BR>10</BR>]], 
BEATENGINEER_TEXT3 = [[<T C="255,236,193" S="16" P="1" SC="132,66,29" SS="4" SE="1">(Tặng tấn công </T><T C="99,255,95" S="16" P="1" SC="132,66,29" SS="4" SE="1">%d</T><T C="255,236,193" S="16" P="1" SC="132,66,29" SS="4" SE="1"> lần)</T>]],
BREAK_TEXT3 = {"Tăng Sát Thương", "Giảm Sát Thương", "Cấp kế: ", "Hình nền động", "Rương Đạn Hóa Học", "Thay đổi Skin"} ,
--Sách Cộng Sinh
PHANTOM_COMBINATION_1 = "Duyên Phận",
PHANTOM_COMBINATION_2 = "Tổ hợp có Ảo Hóa chưa kích hoạt, không thể kích hoạt kỹ năng tổ hợp",
PHANTOM_COMBINATION_3 = "Cấp Tổ Hợp Skin đạt tối đa!",
PHANTOM_COMBINATION_4 = "Kích hoạt thất bại",
PHANTOM_COMBINATION_5 = "Đã sở hữu toàn bộ Ảo Hóa của tổ hợp này, kích hoạt Kỹ Năng Cộng Sinh",
PHANTOM_COMBINATION_6 = "Đã là cái đầu tiên",
PHANTOM_COMBINATION_7 = "Đã là cái cuối cùng",
PHANTOM_COMBINATION_8 = [[
<T C="229,105,22" S="22">Sách Cộng Sinh</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T>Sở hữu toàn bộ Skin Ảo Hóa của tổ hợp này, sẽ kích hoạt Kỹ Năng Cộng Sinh (chỉ tính Skin vĩnh viễn).</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T>Dùng Pha Lê Cộng Sinh để tăng cấp Kỹ Năng Cộng Sinh, cấp càng cao thuộc tính càng cao.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T>Dùng Skin trong tổ hợp sẽ tự động trang bị Kỹ Năng Cộng Sinh của tổ hợp đó.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T>Khi chiến đấu, đánh thường có xác suất kích hoạt Kỹ Năng Cộng Sinh</T><BR></BR>
<T C="255,89,74" S="20" P="0">5.</T>Đấu Hạng không kích hoạt Kỹ Năng Cộng Sinh.</T><BR></BR>
]],
LEAGUE116 = "Chiến đội của bạn đã đến trễ rồi! Lần sau vui lòng chuẩn bị sớm hơn nhé!",
ALCHEMY_TEXT1 = {"Đơn Đạo Tu Chân", "Tu Hành", "Ngũ Hành Tụ Luyện", "BXH Tu Hành", "Xem Đơn Dược", "Số lần Luyện Đơn", "Luyện Đơn %d lần", "BXH Tụ Luyện", "Tu Hành Mỗi Ngày", "Tu Hành Vô Hạn", "EXP Tụ Luyện", "Ngũ Hành Tụ Luyện", "Bỏ vào nhanh", "Tụ Luyện", "Không có Đơn Dược, hãy Luyện Đơn trước đã", "Tam Phẩm Phá Ách Đơn", "Ngũ Phẩm Trường Sinh Đơn", "Chúc mừng ", "Luyện Đơn 5 Lần", "Thuần Thục", "Xuất Sắc", "Kim Đơn", "Cửu Chuyển", "Mời chọn", "Đã bỏ vào, có thể Tụ Luyện", "Chúc mừng luyện được "},
ALCHEMY_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Dị Hỏa: Dùng để Luyện Đơn, mỗi lần Luyện Đơn chắc chắn nhận được 1 phần thưởng, có xác suất luyện được Tam Phẩm Phá Ách Đơn và Ngũ Phẩm Trường Sinh Đơn.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Tu Hành: Nhiệm vụ Tu Hành Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ tái lập. Nhiệm vụ Tu Hành Vô Hạn trong hoạt động chỉ được hoàn thành1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa hết dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Ngũ Hành Tụ Luyện: Tam Phẩm Phá Ách Đơn và Ngũ Phẩm Trường Sinh Đơn có thể Tụ Luyện thành "Ngũ Phẩm Phá Ách Đơn" và "Cửu Phẩm Trường Sinh Đơn". Tụ Luyện thành công chắc chắn nhận được thưởng thêm và EXP Tụ Luyện. Ngũ Phẩm Phá Ách Đơn x1 + 100 EXP, Cửu Phẩm Trường Sinh Đơn x1 + 500 EXP.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH: BXH Luyện Đơn xếp hạng theo số lần Luyện Đơn của mỗi người, top 100 được nhận thưởng hấp dẫn. BXH Tụ Luyện xếp theo mức EXP Tụ Luyện của mỗi người, top 20 được nhận thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Dị Hỏa/Đơn Dược sẽ bị xóa hết khi hoạt động kết thúc, hãy dùng kịp thời!</T><BR>10</BR>]], 
ALCHEMY_TEXT3 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Dị Hỏa: Dùng để Luyện Đơn, mỗi lần Luyện Đơn chắc chắn nhận được 1 phần thưởng, có xác suất luyện được Tam Phẩm Phá Ách Đơn và Ngũ Phẩm Trường Sinh Đơn.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Tu Hành: Nhiệm vụ Tu Hành Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ tái lập. Nhiệm vụ Tu Hành Vô Hạn trong hoạt động chỉ được hoàn thành1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa hết dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Ngũ Hành Tụ Luyện: Tam Phẩm Phá Ách Đơn và Ngũ Phẩm Trường Sinh Đơn có thể Tụ Luyện thành "Ngũ Phẩm Phá Ách Đơn" và "Cửu Phẩm Trường Sinh Đơn". Tụ Luyện thành công chắc chắn nhận được thưởng thêm và EXP Tụ Luyện. Ngũ Phẩm Phá Ách Đơn x1 + 100 EXP, Cửu Phẩm Trường Sinh Đơn x1 + 500 EXP.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH: BXH Luyện Đơn xếp hạng theo số lần Luyện Đơn của mỗi người, top 100 được nhận thưởng hấp dẫn. BXH Tụ Luyện xếp theo mức EXP Tụ Luyện của mỗi người, top 20 được nhận thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Dị Hỏa/Đơn Dược sẽ bị xóa hết khi hoạt động kết thúc, hãy dùng kịp thời!</T><BR>10</BR>]], 
FAILED_TO_PASS = "Từ chối",
PENDING_REVIEW = "Chờ duyệt",
PRODUCTS_SOLD_TODAY = "Sản phẩm đã bán hôm nay",
SKILL_EXPLOSION_1 = "Hiệu ứng tấn công",
SKILL_EXPLOSION_2 = "Đã dùng",
SKILL_EXPLOSION_3 = "Dùng thất bại",
SKILL_EXPLOSION_4 = "Tháo thành công",
SKILL_EXPLOSION_5 = "Tháo thất bại",
KILL_EXPLOSION_6 =
[[
<T C="127,70,26" S="20" P="0"> Dùng sẽ thay thế hiệu ứng nổ của đánh thường và một phần kỹ năng</T><BR></BR>
]],
SKILL_EXPLOSION_7 = "Hiệu ứng tấn công [%s] đã hết hạn và biến mất.",
CLOSE_CREATEROLE = "Giao diện tạo nhân vật đã đóng",

YEARPLAYER_TEXT1 =  {"Người Chơi Của Năm", "Thưởng Lựa Chọn", "BXH Debut", "Số Phiếu Bình Chọn", "Lựa Chọn", "Tạo mới miễn phí","Sơ Tuyển","Hạng Debut","Lựa Chọn Mỗi Ngày","Lựa Chọn Tích Lũy","Chọn Cách Tham Gia","Nhắc: Sau khi báo danh thành công sẽ không thể thay đổi nội dung tuyên ngôn", "Hãy nhập nội dung tuyên ngôn tham gia chương trình", "Sau khi đề cử sẽ được nhiều người biết đến hơn", '<T C="255,236,193" S="22" P="1">Dùng </T>%d</T> <I Z="0.5" P="1">%s</I> <T C="255,236,193" S="22" P="1">báo danh tham gia?</T>', "Tuyên ngôn tối đa 20 ký tự!", "Không thể tự bỏ phiếu cho bản thân!", '<T C="127,70,26" S="22" P="1">Dùng </T><T C="229,105,22" S="22" P="1">%d</T><I Z="0.5" P="1">%s</I> <T C="127,70,26" S="22" P="1">để bỏ </T><T C="229,105,22" S="22" P="1">%d</T><T C="127,70,26" S="22" P="1"> phiếu?</T>', "Không tìm thấy người này trong danh sách đã báo danh", "Đã dùng hết lượt bỏ phiếu hôm nay, tăng cấp VIP để tăng số lần bỏ phiếu?"},
YEARPLAYER_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Người Chơi Của Năm</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Cách tham gia: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Vào giao diện hoạt động và báo danh để tham gia. Báo danh cần tốn 500 Kim Cương.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Vào giao diện hoạt động và báo danh để tham gia.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Báo danh cần điền nội dung tuyên ngôn tham gia.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Báo danh xong có thể dùng 100 Kim Cương để đề cử. Hiệu quả đề cử duy trì 22 giờ, có thể giúp bản thân dễ được người khác tìm thấy hơn.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Cách bỏ phiếu</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Giao diện Sơ Tuyển mỗi lần sẽ hiển thị 12 người chơi, có thể dùng Kim Cương để tạo mới danh sách. Sau 10 lần tạo mới, có thể tìm kiếm người chơi bằng ID</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Sau khi tìm thấy người chơi mình muốn bỏ phiếu ủng hộ, nhấp nút [Lựa Chọn] để bỏ phiếu. Khi bỏ phiếu, có thể chọn dùng Kim Cương để bỏ phiếu, 200 Kim Cương = 1 phiếu</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Nhiệm vụ [Lựa Chọn]: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm nhiệm vụ ngắn và nhiệm vụ dài. Nhiệm vụ ngắn mỗi ngày được nhận 1 lần, sang hôm sau sẽ xóa dữ liệu, nhiệm vụ dài trong cả hoạt động chỉ được hoàn thành 1 lần. Khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi kết thúc hoạt động sẽ xóa tất cả dữ liệu liên quan.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">BXH Debut: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thống kê theo số phiếu mỗi người nhận được, top 100 được nhận thưởng hấp dẫn. Thưởng sẽ được gửi qua thư khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>]],
YEARPLAYER_TEXT3 = {"Mình đã đến gần thành công hơn rồi", "Cám ơn mọi người đã ủng hộ", "Fan cuồng đã có mặt", "Tất cả cho Debut"},


SPRINGOUTING_TEXT1 =  {"Du Xuân Đạp Thanh", "Hạng Đạp Thanh", "Nhiệm Vụ Du Xuân", "Nô Nức Chơi Xuân", "Bộ hành %d lần", "Bộ hành miễn phí", "Toàn server tích lũy bộ hành %d lần sẽ được nhận thưởng","Thưởng Đạp Thanh (Nhỏ)","Thưởng Đạp Thanh (Lớn)","Thưởng Cuồng Bộ Hành", "Cánh Xuân Tươi", "Hoa Xuân", "Du Xuân Đạp Thanh", "Điểm Bộ Hành", "Số bước đã đi", "Số bước Đạp Thanh", "BXH Đạp Thanh", "Số bước", "Điểm Danh Tri Ân", "Không nhắc nữa", [[<T C="127,70,26" S="22" P="1">Ngày </T><T C="127,70,26" S="40" P="1">%d</T><T C="127,70,26" S="22" P="1"></T>]], "Điểm danh bù", [[<T C="91,65,167" S="20" P="1">Điểm danh bù cần tốn </T>]], [[<T C="91,65,167" S="20" P="1">, tiếp tục không?</T>]]},
SPRINGOUTING_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Du Xuân Đạp Thanh</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng thể lực để rút thưởng Đạp Thanh, mỗi lần Đạp Thanh cần tốn 1 thể lực, chắc chắn nhận được 1 phần thưởng thông thường, đăng nhập mỗi ngày được miễn phí Đạp Thanh 1 lần</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần Đạp Thanh sẽ nhận được 1 bước chân và 2 điểm.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điểm đạt mức yêu cầu sẽ được nhận thưởng, phần thưởng được tái lập mỗi ngày.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Du Xuân đạt số bước yêu cầu sẽ được nhận thưởng.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Toàn server Đạp Thanh đạt số lần yêu cầu, sẽ được nhận thưởng toàn server.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Đạp Thanh có cơ hội nhận thưởng thêm!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Đạp Thanh: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm các nhiệm vụ Cánh Xuân Tươi, Hoa Xuân và Du Xuân Đạp Thanh. Nhiệm vụ Cánh Xuân Tươi mỗi ngày được nhận và hoàn thành 1 lần, sang hôm sau sẽ xóa dữ liệu. Nhiệm vụ Hoa Xuân và Du Xuân Đạp Thanh trong cả hoạt động chỉ được hoàn thành 1 lần. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa tất cả dữ liệu liên quan.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH Đạp Thanh: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH được thống kê theo số bước đã đi trong hoạt động Đạp Thanh. Top 100 sẽ được nhận thưởng hấp dẫn. Thưởng sẽ được gửi qua thư khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>
]],


SEVENYEAR_TEXT1 =  {"Điểm Danh Sinh Nhật", [[<T C="255,255,255" S="22" P="1">Đăng nhập</T> <T C="255,255,255" S="22" P="1">%d</T> <T C="255,255,255" S="22" P="1">ngày</T>]], [[<T C="91,65,167" S="20" P="1">Điểm danh bù cần tốn </T>]], [[<T C="91,65,167" S="20" P="1">, tiếp tục không?</T>]], "Điểm danh"},
SEVENYEAR_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Điểm Danh Sinh Nhật</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn điểm danh: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trong hoạt động, đăng nhập sẽ kích hoạt tính năng điểm danh mỗi ngày. Khi online có thể nhận thưởng điểm danh của ngày hôm đó, tổng cộng 7 ngày.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Nếu bị lỡ mất số ngày không điểm danh, có thể dùng Kim Cương để điểm danh bù. Sau khi hoạt động kết thúc, nếu chưa nhận thưởng sẽ bị xóa hết, không phát thưởng bù, vì vậy hãy nhớ nhận thưởng kịp thời!</T><BR>10</BR>
]],


SPECIFICSALES_TEXT1 = {"Hoạt Động Đặc Biệt","Siêu Ưu Đãi", "Pet", "Quy Tắc Hoạt Động", "Hoàn thành nhiệm vụ nạp và tiêu phí có thể chọn 1 phần thưởng để nhận. Sau khi nhận thưởng, tiến độ nhiệm vụ sẽ bị khấu trừ.\nTiến độ nạp và tiêu phí sẽ được tái lập lúc 0 giờ mỗi ngày, sau đó sẽ phát thưởng theo mức tiến độ còn lại", [[<T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">Hôm nay đã nạp </T><T C="255,227,117" S="18" P="1" SC="132,66,29" SS="4" SE="1">(%s)</T><I Z="0.4" P="1">shopitems/diamond.png</I><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1"> và tiêu phí </T><T C="255,227,117" S="18" P="1" SC="132,66,29" SS="4" SE="1">(%s)</T><I Z="0.4" P="1">shopitems/diamond.png</I>]],"Đã nhận phần thưởng này rồi, vẫn muốn nhận lại?"},
LEVELSTATE5 = "Độc Nhất",
ACTIVITY7001_TEXT1 = "Nạp ngày 1",
ACTIVITY7001_TEXT2 = "Nạp ngày 2",
ACTIVITY7001_TEXT3 = " và dùng: ",
OPTIMIZE_TEXT101 = "Dùng %d món trang bị để tăng xác suất thành công, tiếp tục?",
PHANTOM_COMBINATION_9 = "Thuộc tính tăng của Lv%d",
PHANTOM_COMBINATION_10 = "Tổng tăng thuộc tính Sách Cộng Sinh",
PHANTOM_COMBINATION_11 = "Thuộc tính tăng thêm của mỗi tổ hợp Ảo Hóa đều được cộng dồn",
BEATMICE_TEXT1 = {"Đập Chuột", "Nhiệm Vụ Đập Chuột", "Tiệm Đập Chuột", "BXH Đập Chuột", "Thưởng Vui Vẻ", "Số lần Đập Chuột", "Đập %d lần", "Thưởng Đập Chuột", "Thưởng May Mắn", "Thưởng Lớn", "EXP Đập Chuột", "Chúc mừng đập được ", "Chuột Mũ Sắt", "Chuột Kho Báu"},
BEATMICE_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Đập Chuột</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Mỗi lần đập chuột cần 1 tốn Búa Gỗ, nhận 1 phần thưởng ngẫu nhiên và một số EXP Đập Chuột. EXP này dùng để tăng Cấp Đập Chuột, có thể nhận nhiều thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Khi Đập Chuột, có xác suất xuất hiện Chuột Mũ Sắt và Chuột Kho Báu, đập trúng chuột này sẽ được nhận thêm phần thưởng hấp dẫn, có cơ hội nhận thêm Bắp Ngô, đạo cụ dùng đổi thưởng trong Tiệm Đập Chuột.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Đập Chuột được xếp hạng theo số lần tích lũy Đập Chuột của mỗi cá nhân, top 100 được nhận thưởng hấp dẫn.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Mỗi ngày có thể hoàn thành và nhận thưởng Nhiệm Vụ Ngày 1 lần, hôm sau sẽ tái lập. Trong hoạt động, chỉ được hoàn thành Nhiệm Vụ Trưởng Thành 1 lần, sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, dữ liệu sẽ bị xóa hết khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>]], 
CLOSE_CREATEROLE = "Giao diện tạo nhân vật đã đóng",
SETCIRCLE_TEXT1 ={"Ném Vòng", "Vua Ném Vòng", "Nhà Búp Bê", "BXH Ném Vòng", "BXH Búp Bê", "Số lần Ném Vòng", "Ném %d lần", "Lần đầu miễn phí","Thưởng Ném Vòng (Nhỏ)","Thưởng Ném Vòng (Lớn)","Nhiệm Vụ Ném Vòng","Cuồng Ném Vòng", "Chúc mừng ném trúng ", "Thỏ Con", "Vịt Con", "Gà Con", "Tự động mở"},
SETCIRCLE_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Ném Vòng</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Vòng: Đạo cụ dùng trong Ném Vòng, mỗi lần ném trúng sẽ nhận được Thưởng + Điểm, ném trúng Thỏ Con/Vịt Con/Gà Con sẽ nhận được 2 phần thưởng + Điểm gấp bội. Chi tiết nhận điểm như sau: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điểm ném trúng vật phẩm thường +1</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điểm Thỏ Con +5</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điểm Vịt Con +10</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điểm Gà Con +15</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ: Chia làm Nhiệm Vụ Ngày và Nhiệm Vụ Trưởng Thành. Nhiệm Vụ Ngày mỗi ngày được làm 1 lần, hôm sau sẽ tạo mới. Nhiệm Vụ Trưởng Thành cả hoạt động chỉ được hoàn thành 1 lần, xong sẽ được nhận thưởng, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ Vua Ném Vòng: Nhiệm vụ tích lũy số ngày, tiêu hao Vòng tích lũy hoàn thành số ngày yêu cầu để nhận thưởng, khi hoạt động kết thúc sẽ xóa hết dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Nhà Búp Bê: Ném trúng Thỏ Con sẽ được nhận thêm Búp Bê, dùng đổi thưởng trong Nhà Búp Bê.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">BXH được thống kê theo số điểm người chơi đã đạt. Top 100 sẽ được nhận thưởng hấp dẫn. Thưởng sẽ được gửi qua thư khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>]], 
GAME_ACTIVITY_TITLE58 = "Quà Tân Thủ",
GAME_ACTIVITY_TITLE59 = "Quà Mỗi Ngày",
GAME_ACTIVITY_TITLE60 = "Quà Trưởng Thành",
BATTLE_HUD_TEXT4 = "Nhấp chọn mục tiêu địch muốn tấn công",
LZTQ_TEXT1 = {"Đặc quyền VIP Lam", "Sảnh Đặc quyền", "Quà Tân Thủ", "Quà Mỗi Ngày", "Quà Trưởng Thành", "Mở VIP Lam", "Gia hạn VIP Lam", "Quà Lv%d", "Lên cấp thành VIP Lam Hào Hoa có thể nhận quà", "Mở VIP 12 tháng hoặc mua nhiều lần đủ 12 tháng, sẽ tự động mở VIP Năm và nhận quà", "Chơi chút nữa", "Rời trò chơi", "Không chơi nữa sao?", "%d giây tự đóng", [[<T C="127,70,26" S="20" P="1">Thưởng Online</T><T C="5,180,0" S="20" P="1"> đã có thể nhận</T><T C="127,70,26" S="20" P="1">!<T C="127,70,26" S="20" P="1">Hãy nhận ngay nào</T>]], [[<T C="127,70,26" S="20" P="1">Thưởng Online kế tiếp có thể nhận sa u%s</T><T C="5,180,0" S="20" P="1"> nữa</T><T C="127,70,26" S="20" P="1">!</T><T C="127,70,26" S="20" P="1">Chơi thêm chút nữa</T>]], [[<T C="127,70,26" S="20" P="1">Phần thưởng hấp dẫn đang chờ bạn đến nhận</T>]], "Nhắc nhở"},
LZTQ_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Đặc quyền VIP Lam:</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Đạo cụ dành cho VIP Lam</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Quà Tân Thủ VIP Lam</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Quà Mỗi Ngày VIP Lam</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Quà Trưởng Thành VIP Lam</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Ưu đãi -20% VIP Lam</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0">Ưu đãi tăng lực chiến VIP Lam, khi online "Tấn công +2%", mỗi ngày duy trì 2 giờ</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0">Theo dõi trang chủ để biết thêm chi tiết đặc quyền VIP</T><BR>10</BR>]], 
GARDEN_TEXT1 ={"Vườn Trái Cây", "Chú Ong Chăm Chỉ", "Tiệm Trái Cây", "Vua Trái Cây", "BXH Kinh Doanh", "Số lần hái", "Bón phân %d lần", "Bón phân miễn phí","Quả Nhỏ","Quả Lớn","Nhiệm Vụ Vườn Trái Cây","Mục Tiêu Chủ Vườn", "Thu hoạch %d lần", "Thu hoạch miễn phí", "Trồng", "Lao Động Là Vinh Quang", "Thưởng Vườn Trái Cây (Lớn)", '<T C="127,70,26" S="20" P="1">Chào mừng đến với [Vườn Trái Cây], Chủ Vườn sẽ tặng bạn 1 hạt giống bí ẩn, </T><BR>18</BR><T C="127,70,26" S="20" P="1">chăm thành cây lớn để thu hoạch trái cây nhé!</T>', "Người Kinh Doanh:", "Kho Trái Cây: ", "Điểm Kinh Doanh: ", "Toàn server tham gia hoạt động đủ số lần yêu cầu sẽ được nhận 1 phần thưởng", "Cùng Trồng Cây", "Kho đã trống!", "Bán Trái Cây", "Bán %d cân Trái Cây (Còn lại %d cân)", "Nhận được %d cânTrái Cây", "Nhấp chọn khu vực khác để đóng", "Lần này bán được %d cân Trái Cây, nhận %d điểm", "%d cân"},
GARDEN_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Vườn Trái Cây</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Đạo Cụ Bí Ẩn: Dùng để tham gia hoạt động, mỗi lần bón phân hoặc thu hoạch sẽ nhận 1 phần thưởng, trúng Thưởng Quả Nhỏ và Thưởng Quả Lớn sẽ được nhận thêm số cân Trái Cây, cụ thể như sau: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trúng Thưởng Quả Nhỏ - 1 hoặc 3 cân Trái Cây</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trúng Thưởng Quả Lớn - 10 cân Trái Cây</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Trạng thái Cây Ăn Quả: Cây Non/Cây Lớn/Cây Bí Ẩn, trong đó khi trồng được "Cây Bí Ẩn", khi thu hoạch được nhận thưởng x2.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ: Chia làm Nhiệm Vụ Ngày và Nhiệm Vụ Trưởng Thành. Nhiệm Vụ Ngày mỗi ngày được làm 1 lần, hôm sau sẽ tạo mới. Nhiệm Vụ Trưởng Thành cả hoạt động chỉ được hoàn thành 1 lần, xong sẽ được nhận thưởng, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ Chú Ong Chăm Chỉ: Nhiệm vụ tích lũy số ngày, tiêu hao đạo cụ bí ẩn để tích lũy đến số ngày chỉ định để nhận thưởng, sau khi hoạt động kết thúc sẽ xóa dữ liệu</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Tiệm Trái Cây: Có thể đem bán Trái Cây trong Tiệm Trái Cây, nhận thưởng thêm + Điểm Kinh Doanh. Bán 1 cân Trái Cây = 5 Điểm Kinh Doanh, mỗi lần bán lẻ 1 cân có thể nhận 1 phần thưởng, bán 1-10 cân vẫn nhận 1 phần thưởng, bán 11-100 cân được nhận 2 phần thưởng.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0">BXH Vua Trái Cây: Xếp hạng tho số lần tham gia hoạt động của mỗi cá nhân, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0">BXH Kinh Doanh: Xếp hạng theo mức Điểm Kinh Doanh Tiệm Trái Cây của mỗi cá nhân, top 20 được nhậnthưởng hấp dẫn, khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>]], 
GARDEN_TEXT3 = {{"Đang trưởng thành!", "Sắp kết trái rồi!"},{"Năm nay sẽ thu hoạch to!", "Người chăm chỉ sẽ trồng gì được nấy"}},
CATCHFISH_TEXT1 = {"Vua Đánh Cá", "Nhiệm Vụ Đánh Cá", "BXH Đánh Cá", "Đánh Cá Không Chuyên", "Đánh Cá Đỉnh Cao", "Đánh Cá Miễn Phí", "Đánh Cá %d lần", "Thư Viện Đánh Cá", "Lưới Cá", "Đánh Cá Mỗi Ngày", "Cao Thủ Đánh Cá", "Thưởng Tập Tành Đánh Cá", "Thưởng Cao Thủ Đánh Cá", "Thưởng Cuồng Đánh Cá", "Cấp Đánh Cá", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng chọn sẵn, chắc chắn nhận được 1 phần thưởng đã chọn</T>]], {"Tập Tành Đánh Cá", "Mới Biết Đánh Cá", "Cao Thủ Đánh Cá", "Chuyên Gia Đánh Cá", "Trùm Đánh Cá", "Vua Đánh Cá", "Vua Đánh Cá"}, "EXP Đánh Cá", "Đang Đánh Cá", "Cá Thường", "Cá Hiếm", "Thưởng Tự Chọn", "Chọn phần thưởng muốn nhận", "Cá Voi", "HP: ", "Tốn thêm %d Lưới Cá sẽ xuất hiện Cá Voi"},
CATCHFISH_TEXT2 = [[
<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Vua Đánh Cá</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">1. </T><T C="255,255,255" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Tốn Lưới Cá để rút thưởng Đánh Cá, Đánh Cá Không Chuyên mỗi lần tốn 1 Lưới Cá, chắc chắn nhận được 1 phần thưởng thường và 2 điểm EXP Đánh Cá. Đăng nhập mỗi ngày được Đánh Cá Miễn Phí 1 lần. Đánh Cá Đỉnh Cao mỗi lần tốn 5 Lưới Cá và 10 điểm EXP Đánh Cá, chắc chắn nhận được 1 phần thưởng cao cấp: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Mỗi lần Đánh Cá sẽ nhận ngẫu nhiên 1 loài Cá Thường, tốn Lưới Cá đạt số lượng nhất định sẽ xuất hiện Cá Voi, đánh bắt Cá Voi có thể nhận thưởng x2!</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Cá đánh bắt được có thể vào Thư Viện Đánh Cá đổi thưởng hiếm. Thư Viện được tạo mới mỗi ngày!</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Tích lũy Đánh Cá có xác suất nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">2. </T><T C="255,255,255" S="20" P="0">Nhiệm Vụ Đánh Cá: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Chia làm nhiệm vụ Đánh Cá Mỗi Ngày, Cao Thủ Đánh Cá. Nhiệm vụ Đánh Cá Mỗi Ngày có thể hoàn thành mỗi ngày 1 lần, sang hôm sau xóa dữ liệu. Nhiệm vụ Cao Thủ Đánh Cá trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">3. </T><T C="255,255,255" S="20" P="0">BXH Đánh Cá: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH Đánh Cá sẽ thống kê theo EXP Đánh Cá nhận được. Top 100 người chơi được nhận thưởng hấp dẫn, khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="255,150,16" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>
]],

SUPER_SELL_ACTIVITY = {"Ưu đãi bất ngờ","Mua ngay","Chỉ trong thời gian diễn ra sự kiện mỗi người chỉ được mua 1 lần/ngày!"},
NEED_DOWNLOAD_TIPS_1 = "Lần cập nhật này cần tải %0.2fMB.",
CAFFEE_TEXT1 =  {"Chuyên Gia Cà Phê", "Nhiệm vụ Cà Phê", "BXH Bậc Thầy", "EXP Pha Chế", "Pha Chế", "Pha chế miễn phí","Thưởng Học Viên Cà Phê","Thưởng Bậc Thầy Cà Phê","Học Viên Cà Phê","Bậc Thầy Cà Phê", "Xay %d lần", "Đã hết Bột Cà Phê, cần đi xay Hạt Cà Phê", "Pha %d lần", "Xay toàn bộ", "Đã xay xong, mau đi pha ngay thôi", "Không đủ Bột Cà Phê, cần đi xay Hạt Cà Phê", "Xay"},
CAFFEE_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Chuyên Gia Cà Phê</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Xay để nhận số lần pha, sau đó pha để rút thưởng, mỗi lần xay sẽ tốn 1 Hạt Cà Phê, chắc chắn nhận 1 lần pha, mỗi lần pha chắc chắn nhận 1 phần thưởng pha, đủ số lần pha sẽ có cơ hội nhận Thưởng Học Viên Cà Phê và Thưởng Bậc Thầy Cà Phê!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ Cà Phê: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Học Viên Cà Phê và Bậc Thầy Cà Phê. Nhiệm vụ Học Viên Cà Phê mỗi ngày được nhận và hoàn thành 1 lần, sang hôm sau sẽ xóa dữ liệu. Nhiệm vụ Bậc Thầy Cà Phê trong cả hoạt động chỉ được hoàn thành 1 lần. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa tất cả dữ liệu liên quan.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Bậc Thầy: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thống kê theo số EXP Pha Chế nhận được khi cá nhân tham gia hoạt động. Top 100 được nhận thưởng phát qua thư khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>]],
CAFFEE_TEXT3 = {"Đang chăm chỉ buôn bán, hôm nay rất nhiều đơn!", "Xin chờ một chút, sẽ đến lượt bạn ngay", "Xin chào, sự hài lòng của bạn là động lực phục vụ của chúng tôi!"},

BOWLING_TEXT1 =  {"Bowling", "Người Đam Mê", "BXH Cuồng Nhiệt", "Điểm Lăn Bóng", "Lăn bóng %d lần", "Lăn bóng miễn phí","Thưởng Bowling","Giải Bowling Đặc Biệt","Người Mới","Fan Cuồng", "Câu Lạc Bộ", "Thưởng Đặc Sắc", "Trận Sơ Cấp", "Trận Cao Cấp", "Trong lần lăn bóng này, bạn đã đánh trúng %d bóng", "Trong lần lăn bóng này, bạn đã đánh đổ %s ki", "Nhắc nhở Đặc Sắc", "Đếm ngược Đặc Sắc: ", "Ném thêm %d lần sẽ vào Thời Khắc Đặc Sắc, nhận thưởng gấp bội"},
BOWLING_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Bowling</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể chọn loại hình muốn vào [Trận Sơ Cấp/Cao Cấp], sau đó chọn [Ném] để rút thưởng. Trận Sơ Cấp mỗi lần cần tốn 1 Vé Tham Dự, mỗi lần ném chắc chắc nhận được 1 phần thưởng và 1 Điểm Lăn Bóng. Trận Sơ Cấp mỗi lần cần tốn 2 Vé Tham Dự, mỗi lần ném chắc chắc nhận được 2 phần thưởng và 2 Điểm Lăn Bóng. Tích lũy số lần ném có cơ hội nhận thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ Bowling: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Người Mới và Fan Cuồng. Nhiệm vụ Người Mới mỗi ngày được nhận và hoàn thành 1 lần, sang hôm sau sẽ xóa dữ liệu. Nhiệm vụ Fan Cuồng trong cả hoạt động chỉ được hoàn thành 1 lần. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa tất cả dữ liệu liên quan.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Cuồng Nhiệt: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thống kê theo số Điểm Lăn Bóng nhận được khi cá nhân tham gia hoạt động. Top 100 được nhận thưởng phát qua thư khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Thời Khắc Đặc Sắc: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi khi cả server sử dụng đủ 500 Vé Tham Dự, sẽ kích hoạt Thời Khắc Đặc Sắc. Trong thời gian Thời Khắc Đặc Sắc, thưởng lăn bóng sẽ tăng gấp bội. Mỗi lần Thời Khắc Đặc Sắc kéo dài 60 giây.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>]],
BOWLING_TEXT3 = {"Lần này nhất định sẽ Strike", "Lần này có hơi bất thường!", "Vẫn còn có thể cải thiện nhiều"},
YEARPLAYER_TEXT1 =  {"Người Chơi Của Năm", "Thưởng Lựa Chọn", "BXH Debut", "Số Phiếu Bình Chọn", "Lựa Chọn", "Tạo mới miễn phí","Sơ Tuyển","Hạng Debut","Lựa Chọn Mỗi Ngày","Lựa Chọn Tích Lũy","Chọn Cách Tham Gia","Nhắc: Sau khi báo danh thành công sẽ không thể thay đổi nội dung tuyên ngôn", "Hãy nhập nội dung tuyên ngôn tham gia chương trình", "Sau khi đề cử sẽ được nhiều người biết đến hơn", '<T C="255,236,193" S="22" P="1">Dùng </T>%d</T> <I Z="0.5" P="1">%s</I> <T C="255,236,193" S="22" P="1">báo danh tham gia?</T>', "Tuyên ngôn tối đa 20 ký tự!", "Không thể tự bỏ phiếu cho bản thân!", '<T C="127,70,26" S="22" P="1">Dùng </T><T C="229,105,22" S="22" P="1">%d</T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="22" P="1"> để bỏ </T><T C="229,105,22" S="22" P="1">%d</T><T C="127,70,26" S="22" P="1"> phiếu?</T>', "Không tìm thấy người này trong danh sách đã báo danh", "Đã dùng hết lượt bỏ phiếu hôm nay, tăng cấp VIP để tăng số lần bỏ phiếu?"},
YEARPLAYER_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Người Chơi Của Năm</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Cách tham gia: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Vào giao diện hoạt động và báo danh để tham gia. Báo danh cần tốn 500 Kim Cương Khóa.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Báo danh cần điền nội dung tuyên ngôn tham gia.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Báo danh xong có thể dùng 100 Kim Cương để đề cử. Hiệu quả đề cử duy trì 22 giờ, có thể giúp bản thân dễ được người khác tìm thấy hơn.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Cách bỏ phiếu</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Giao diện Sơ Tuyển mỗi lần sẽ hiển thị 12 người chơi, có thể dùng Kim Cương Khóa để tạo mới danh sách. Sau 10 lần tạo mới, có thể tìm kiếm người chơi bằng ID</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Sau khi tìm thấy người chơi mình muốn bỏ phiếu ủng hộ, nhấp nút [Lựa Chọn] để bỏ phiếu. Khi bỏ phiếu, có thể chọn dùng Kim Cương Khóa hoặc Kim Cương Lam để bỏ phiếu, 132 Kim Cương Khóa = 1 phiếu, 66 Kim Cương Lam = 1 phiếu</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ [Lựa Chọn]: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm nhiệm vụ ngắn và nhiệm vụ dài. Nhiệm vụ ngắn mỗi ngày được nhận 1 lần, sang hôm sau sẽ xóa dữ liệu, nhiệm vụ dài trong cả hoạt động chỉ được hoàn thành 1 lần. Khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi kết thúc hoạt động sẽ xóa tất cả dữ liệu liên quan.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Debut:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thống kê theo số phiếu mỗi người nhận được, top 100 được nhận thưởng hấp dẫn. Thưởng sẽ được gửi qua thư khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>]],
YEARPLAYER_TEXT3 = {"Mình đã đến gần thành công hơn rồi", "Cám ơn mọi người đã ủng hộ", "Fan cuồng đã có mặt", "Tất cả cho Debut"},
PET_EQUIPMENT_LOTTERY_1 = "Nhận Trang Bị Pet",
PET_EQUIPMENT_LOTTERY_2 = [[<T C="229,105,22" S="22" P="1">Hướng dẫn nhận Trang Bị Pet</T><BR>10</BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Gọi sẽ có thể nhận trang bị Pet Lục, Lam, Tím và các nguyên liệu trang bị Pet khác</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Mỗi 50 lần Gọi Vàng sẽ có thể nhận 1 Quà Trang Bị Đá Thép, mở nhận ngẫu nhiên 1 trang bị Đá Thép Tím</T><BR>10</BR>

]],
PET_EQUIPMENT_LOTTERY_3 = " ",
PET_EQUIPMENT_LOTTERY_4 = " ",
GEM_MOUNTING_text1 = "Chọn đạo cụ lên cấp: ",
PET_EQUIPMENT_1 = "Trang Bị Pet",
PET_EQUIPMENT_2 =  [[<T C="229,105,22" S="22" P="1">Hướng dẫn Trang Bị Pet</T><BR>10</BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Buff của trang bị Pet sẽ tăng cho thuộc tính của Pet đang xuất chiến. Nếu Pet hủy xuất chiến thì lực chiến của trang bị Pet sẽ không tăng.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Trang Bị Pet có thể Cường Hóa, Tăng Sao, Khảm. Trang Bị Pet Tím cường hóa +40, cấp sao +12 có thể chế tạo thành trang bị Cam.</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Khi nhận trang bị Pet sẽ nhận ngẫu nhiêu 1 dòng thuộc tính ngẫu nhiên. Thuộc tính ngẫu nhiên sau khi nhận sẽ không thay đổi.</T><BR>10</BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Khi chế tạo đồ Cam thì đồ Cam nhận được sẽ kế thừa thuộc tính ngẫu nhiên của đồ Tím gốc.</T><BR>10</BR>
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">Trang bị Pet dư ra có thể thu hồi, thu hồi trang bị Pet sẽ nhận nguyên liệu Đá Sao.</T><BR>10</BR>
<T C="127,70,26" S="20">6.</T><T C="127,70,26" S="18">Trang Bị Pet có thể thiết lập phương án trang bị, đổi phương án có thể đổi nhanh Trang Bị Pet đang mặc</T><BR>10</BR>
<T C="127,70,26" S="20">7.</T><T C="127,70,26" S="18">Trang Bị Pet có thể dùng Đá Kế Thừa (Pet) để kế thừa.</T><BR>10</BR>
<T C="127,70,26" S="20">8.</T><T C="127,70,26" S="18">Khi kế thừa, trang bị mới cần phải chưa tiến hành Cường Hóa, Tăng Sao, Tăng Phẩm.</T><BR>10</BR>
<T C="127,70,26" S="20">9.</T><T C="127,70,26" S="18">Trang bị Pet chỉ có thể kế thừa lên trang bị cùng phẩm chất, trang bị Cam có thể kế thừa lên trang bị Tím.</T><BR>10</BR>


]],
PET_EQUIPMENT_3 = {"Vuốt","Nón","Giáp","Vòng","Đuôi","Bùa"},
PET_EQUIPMENT_4 = "Mỗi lần tối đa thu hồi 16 Trang Bị Pet",
PET_EQUIPMENT_5 = "Trang bị pet phẩm chất cao không hỗ trợ chọn nhanh",
PET_EQUIPMENT_6 = "Nhấn giữ xem thông tin Trang Bị Pet",
PET_EQUIPMENT_7 = "Hãy chọn trang bị Pet",
PET_EQUIPMENT_8 = "Thuộc tính ngẫu nhiên",
PET_EQUIPMENT_9 = {"Đá Tấn Công","Đá Sinh Lực","Đá Phòng Thủ","Đá Cộng Hưởng"},
PET_EQUIPMENT_10 = "Chưa có trang bị Pet có thể thu hồi",
HOLIDAYVILLAGE_TEXT1 = {"Khu Nghỉ Mát", "Khu Nghỉ Mát Bạn Bè", "Trồng", "Hố", "Đá", "Phân Bón", "Kho", "Về", "Khách", "Cấp Khu Nghỉ Mát", [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">%s</T><I Z="1" P="1"> %s </I><T C="99,255,95" S="20" P="1" SC="132,66,29" SE="1" SS="4">%s</T> <T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4"> đến thăm hỏi, </T>]], [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">tiện tay lấy </T><T C="255,227,116" S="20" P="1" SC="132,66,29" SE="1" SS="4">%s</T> <T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">%s</T>]], [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">giúp diệt sâu hại</T>]], [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">giúp nhổ cỏ dại</T>]], "%d", "%d", "Tiệm Xu Nghỉ Mát", "Tiệm Khác", "Thành Tựu Nghỉ Mát", "Thư Viện Nghỉ Mát", "Hiện tại Lv%d", "Cấp kế Lv%d", [[<T C="127,70,26" S="20" P="1">Dùng </T>]], [[<T C="127,70,26" S="20" P="1"> mở khóa </T><T C="127,70,26" S="20" P="1"> %s</T>]], "Số lượng %s cần có không ít hơn %d", "Tăng sản lượng", "Xu Nghỉ Mát", "Hố", "Tổng tăng đá", "Chọn đá", "Nhận đá", "Mở rộng", "Hái", "Trộm", "Bắt", "Năng Lượng", "Lên cấp cần: ", "Điểm Nghỉ Mát", "Tăng thuộc tính Thành Tựu", "Hạng Bạn Bè", "Xác nhận khai khẩn hố này?", "Cần Khu Nghỉ Mát đạt Lv%d mới được khai khẩn!", "Nơi này chẳng có gì cả!", "Hố số %d", "Gieo trồng", "Hố này đã có cây rồi", "Gieo trồng thành công", "Không phải đất trống, không thể đào", "Cây trồng giai đoạn này không cần tưới nước", "Đất đã được nới ra rồi", "Tuyệt quá, tôi sẽ bắt đầu cố gắng phát triển!", "Đào hố", "Tưới nước", "Chậm tay rồi, sâu hại đã bị bắt", "Không còn gì có thể hái nữa rồi", "Bắt được sâu hại thành công", "Tâm trạng lúc thu hoạch thật vui", "Thành quả lao động của người khác thật là thơm", "Đã hết Phân Bón, cần đi mua", "Bón phân thành công", "Bón phân cũng phải đúng đối tượng", "Không thể bón phân lại", "Đã quá giới hạn trộm mỗi ngày", "Đã quá giới hạn trộm cá nhân mỗi ngày", "Có thể mở rộng", "Khu Nghỉ Mát Lv%d", "Số lượng nhận Thích", "Sản lượng", "Còn lại", "EXP", "Nhấn tưới nước thì hạt giống mới nảy mầm", "Thời gian nảy mầm", "Thời gian chín", "Không đủ năng lượng, mau đi bổ sung năng lượng!", "Đã bón phân tăng sản lượng (%d%%)", "Chúc mừng khai khẩn  thành công đất mới, mau đi trồng nông sản nào", "Đi mua", "EXP Nghỉ Mát", "Điểm Năng Lượng", "Khu Nghỉ Mát đạt Lv%d sẽ mở khóa", "Thu hoạch: ", "Khu Nghỉ Mát đạt Lv%d mới được lên cấp", "Tăng sản lượng thất bại", "Cần mở rộng hố trước đó", "Thu hoạch", "Năng lượng cần để gieo: ", "Nhận thêm", [[<T C="127,70,26" S="20" P="1">Thu hoạch </T><T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"> nông sản nhận thưởng thêm như sau: </T>]], "Điểm Vui", "Điểm Luyện", "Sâu giảm sản lượng: ", "Năng lượng đã đầy!", "Đã vượt quá số lượng giới hạn mỗi ngày toàn server, vui lòng chọn lại!", "Đã vượt quá số lượng giới hạn mỗi ngày cá nhân, vui lòng chọn lại!", "Hạt Giống", "Đạo cụ", [[<T C="127,70,26" S="22" P="1">Cần trả: </T>]]},
PET_EQUIPMENT_11 = "Trang bị Pet Tím:\nCường hóa +%d, cấp sao +%d sẽ được chế trang bị Cam",
PET_EQUIPMENT_12 = "Có chứa trang bị Pet đã cường hóa/tăng sao/khảm đá, thu hồi sẽ không hoàn lại nguyên liệu cường hóa, tăng sao, vẫn tiếp tục?",
PET_EQUIPMENT_13 = "Tích lũy gọi %s/%s lần có thể nhận",
PET_EQUIPMENT_14 = "Thưởng Tích Lũy Gọi",
PET_EQUIPMENT_15 = "Không thể tiếp tục tăng cấp đá quý",
WATERMELON_TEXT1 =  {"Dưa Hấu Ngày Hè", "Nhiệm Vụ Ngày Hè", "BXH Dưa Hấu", "Xu Dưa Hấu", "Uống %d ly", "Ăn %d miếng","Ăn %d miếng","Ăn Dưa Trong Ngày","Cao Thủ Ăn Dưa","Nhấn chọn dưa muốn ăn","Dưa Sa Mạc", "Dưa Kỳ Lân", "Nước Dưa Hấu", "Cùng Ăn Dưa Hấu", "Rút Thưởng Dưa Hấu", "Lắc %d lần", "Kho Thưởng A", "Kho Thưởng S", "Thưởng Cao Thủ Ăn Dưa", "Thưởng Trùm Ăn Dưa", "Khi người chơi toàn server sử dụng Xu Dưa Hấu đủ số lần quy định thì người chơi toàn server sẽ nhận 1 thưởng ngẫu nhiên", "Thưởng Tự Chọn", [[<T C="127,70,26" S="20" P="1">Tích lũy lắc thưởng </T><T C="229,105,22" S="20" P="1">%d/%d</T><T C="127,70,26" S="20" P="1"> lần sẽ được tự chọn </T><T C="229,105,22" S="20" P="1">%d/%d</T><T C="127,70,26" S="20" P="1"> thưởng.</T>]], "Đã vượt quá số lượng được chọn rồi", "G.Hạn Ngày"},
WATERMELON_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Dưa Hấu Ngày Hè</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể chọn cách thức Ăn Dưa [Dưa Sa Mạc/Dưa Kỳ Lân/Nước Dưa Hấu], sau đó chọn [Ăn Dưa/Uống Nước Dưa] để rút thưởng</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dưa Sa Mạc cần tốn 1 Xu Dưa Hấu, mỗi lần ăn 1 quả dưa chắc chắn nhận 1 phần thưởng</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dưa Kỳ Lân cần tốn 2 Xu Dưa Hấu, mỗi lần ăn 1 quả dưa chắc chắn nhận 1 phần thưởng</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Uống Nước Dưa cần tốn 1 Ống Hút, mỗi lần uống 1 ly nhận 1 phần thưởng</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần dùng 5 Xu Dưa Hấu sẽ nhận một Miếng Dưa Hấu</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy ăn dưa có cơ hội nhận thưởng lớn Dưa Hấu Ngày Hè!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ Dưa Đã Ăn: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Ăn Dưa Trong Ngày và Cao Thủ Ăn Dưa. Nhiệm vụ Ăn Dưa Trong Ngày mỗi ngày được nhận và hoàn thành 1 lần, sang hôm sau sẽ xóa dữ liệu. Nhiệm vụ Cao Thủ Ăn Dưa trong cả hoạt động chỉ được hoàn thành 1 lần. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa tất cả dữ liệu liên quan.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Vua Ăn Dưa: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thống kê theo số Xu Dưa Hấu đã tốn khi cá nhân tham gia hoạt động. Top 100 được nhận thưởng phát qua thư khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>
]],         
CHARACTER_ATTRIBUTES = "Thuộc tính nhân vật",
GEM_DISMANTLING = "Sau khi tháo, EXP Đá Quý sẽ bị xóa hết, xác nhận tháo?",
QQHALL_TEXT1 = {"Nhấn giữ chuột vào nhân vật để kéo về hướng ngược lại hướng muốn bay sẽ khiến nhân vật bay về khu vực mục tiêu", {[[Có thể rèn để tăng thuộc tính cơ bản trang bị.]],[[Trong chiến đấu có thể kéo rê chuột để xem bản đồ chiến đấu]],[[Đạt Lv15 sẽ có thể tạo Công Hội của riêng mình!]],[[Bạn bè mỗi ngày có thể tặng thể lực cho nhau!]],[[Nhấn giữ chuột vào hai bên nhân vật sẽ khiến nhân vật leo trái phải!]]}, "Nhấn giữ chuột vào nhân vật để kéo về hướng ngược lại của mục tiêu tấn công để nhắm chuẩn tấn công", "Nhấn giữ chuột vào nhân vật để kéo về hướng ngược lại của mục tiêu tấn công để nhắm chuẩn tấn công (lên xuống để chỉnh góc độ)", "Nhấn giữ chuột vào nhân vật để kéo về hướng ngược lại hướng muốn bay sẽ khiến nhân vật bay về khu vực mục tiêu", "Thả chuột ra để hủy gửi", "Lăn chuột lên trên để hủy gửi", "Lăn chuột lên trên để hủy ghi âm", "Lăn chuột lên trên để hủy gửi, chỉ hiệu lực trong server", "Chơi game điều độ, chi tiêu hợp lý", "Giá Kim Cương Lam"},
DOWNLOAD_RESOURCE_TIPS = "Chào bạn, trò chơi đang được tải xuống trong nền, bạn có thể chơi tiếp trong khi tải, nhưng ít nhiều sẽ bị ảnh hưởng, mong bạn thông cảm",
COUPLE_TEXT1 = "Nhân Duyên",
COUPLE_TEXT2 = {"Sau khi kết hôn mới được xem Nhân Duyên","Điểm Kết Duyên","Kết Duyên","Cấp Nhân Duyên Bạn Đời","Kết duyên thành công","Kết duyên thất bại","Nhân Duyên đã đạt cấp tối đa","Cấp Nhân Duyên chưa đạt Lv10, khóa kỹ năng Hẹn Ước Một Đời","Cấp Nhân Duyên bạn đời chưa đạt Lv10, khóa kỹ năng Hẹn Ước Một Đời","Đang tăng cấp, xin chờ","Điểm Nhân Duyên"},
COUPLE_TEXT3 = [[<T C="229,105,22" S="22" P="1">Hướng dẫn Nhân Duyên</T><BR>10</BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Trong mỗi 10 cấp, khi trong khoảng cấp 1-9 sẽ có thể dùng Đá Nhân Duyên để lên cấp, khi điểm Kết Duyên đầy sẽ lên cấp, khi dùng Đá Nhân Duyên có xác suất bạo kích, khi bạo kích sẽ nhận được mức Điểm Kết Duyên gấp bội.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Mỗi lần tăng lên Lv9 cần dùng Bùa Kết Duyên để kết duyên, kết duyên có xác suất thành công, cần phải thành công mới được tăng lên cấp kế.</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Khi cấp Nhân Duyên của Bạn Đời cao hơn bản thân thì điểm Kết Duyên nhận được khi dùng Đá Nhân Duyên sẽ có thể tăng thêm.</T><BR>10</BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Khi cấp Nhân Duyên của 2 vợ chồng đều là Lv10 sẽ có thể nhận kỹ năng Hẹn Ước Một Đời. Cấp Nhân Duyên của 2 vợ chồng mỗi lần tăng 10 cấp thì kỹ năng Hẹn Ước Một Đời tăng 1 cấp.</T><BR>10</BR>
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">Hẹn Ước Một Đời Lv10: Tổ đội vợ chồng cùng chiến đấu, hai bên may mắn +5%, tốc độ +5%.</T><BR>10</BR>
]],
SECRETTOWER_TEXT1 =  {"Vượt Tháp Bí Cảnh", "Nhiệm vụ Vượt Tháp", "BXH Vượt Tháp", "Tốn Bát Quái Lệnh", "Vượt tháp %d lần", "Vượt tháp miễn phí","Thưởng Bí Ẩn (Nhỏ)","Thưởng Bí Ẩn (Lớn)","Vượt tháp hôm nay","Cao Thủ Vượt Tháp", "Phương vị bát quái", "Thưởng Số Tầng Vượt", "Hoàn thành điểm Vượt Tháp sẽ vào tầng kế", [[Sự kiện ngẫu nhiên, kich hoạt thưởng thêm Cửa Sinh hoặc Cửa Tử]], "Thưởng Vượt Ải", "Kích hoạt %d lần Cửa Sinh sẽ nhận thêm quà", "Kích hoạt %d lần Cửa Tử sẽ nhận thêm quà", "Tầng hiện tại: %d", "Bát Quái Lệnh tốn: %d", "Lần vượt tháp này kích hoạt Cửa Sinh, nhận thưởng sau", "Lạc đường, bất cẩn kích hoạt Cửa Tử!", "Mặc Kệ Cửa Tử", "Dũng Cảm Xông Pha", [[<T C="127,70,26" S="20" P="1">Nhấn vào Mặc Kệ Cửa Tử sẽ mất %d điểm Tiến Độ, nhấn vào Dũng Cảm Xông Pha cần tốn %d </T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1">, phá giải bẫy nhận x2 điểm Tiến Độ. Vui lòng chọn cẩn thận!</T>]], [[<T C="249,255,0" S="48" P="1" SC="222,78,0" SS="4" SE="0">Thưởng Vượt %d Tầng</T><T C="255,255,255" S="48" P="1" SC="222,78,0" SS="4" SE="0"></T>]], [[<T C="127,70,26" S="20" P="13">Thu thập </T><T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="13"> sẽ nhận</T>]], [[<T C="127,70,26" S="20" P="13">Thu thập </T><T C="229,105,22" S="20" P="1">toàn bộ Văn Tự Bát Quái</T><T C="127,70,26" S="20" P="13"> sẽ nhận</T>]], [[<T C="249,255,0" S="48" P="1" SC="222,78,0" SS="4" SE="0">Thưởng Cửa Sinh</T><T C="255,255,255" S="48" P="1" SC="222,78,0" SS="4" SE="0"></T>]]},
SECRETTOWER_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Vượt Tháp Bí Cảnh</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Bát Quái Lệnh để vượt tháp, mỗi lần vượt chắc chắn nhận thưởng và điểm Vượt Tháp</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điểm Vượt Tháp đạt yêu càu sẽ vượt được tầng hiện tại và nhận Thưởng Vượt Ải</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trong Thưởng Vượt Ải có Văn Tự Phương Vị Bát Quái, thu thập đủ Văn Tự Phương Vị yêu cầu sẽ được nhận thưởng</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trong quá trình vượt tháp sẽ có xác suất kích hoạt Cửa Sinh hoặc Cửa Tử, khi kích hoạt Cửa Sinh sẽ nhận thêm 1 phần thưởng, khi kích hoạt Cửa Tử cần chọn Mặc Kệ Cửa Tử hoặc Dũng Cảm Xông Pha</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chọn Mặc Kệ Cửa Tử sẽ giảm điểm Tiến Độ của tầng</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chọn Dũng Cảm Xông Pha cần tốn Bát Quái Lệnh để phá giải và nhận thêm điểm Tiến Độ</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trên Bảo Tháp có hiển thị người chơi sử dụng Bát Quái Lệnh nhiều nhất, nếu số lượng bằng nhau thì hiển thị người chơi dùng trước</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Vượt đủ tầng quy định sẽ có cơ hội nhận Thưởng Bí Ẩn (Lớn)!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ Vượt Tháp: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Vượt Tháp Trong Ngày và Chuyên Gia Vượt Tháp. Nhiệm vụ Vượt Tháp Trong Ngày mỗi ngày được nhận và hoàn thành 1 lần, sang hôm sau sẽ xóa dữ liệu. Nhiệm vụ Chuyên Gia Vượt Tháp trong cả hoạt động chỉ được hoàn thành 1 lần. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa tất cả dữ liệu liên quan.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Vượt Tháp: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thống kê theo số Bát Quái Lệnh đã tốn khi cá nhân tham gia hoạt động. Bát Quái Lệnh tiêu tốn khi vượt cửa tử không tính vào BXH.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Top 100 người chơi sẽ nhận thưởng gửi qua thư khi hoạt động kết thúc</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>]],

MONEYTREE_TEXT1 =  {"Rung Cây Tiền", "Lợi ích rung Cây Tiền", "BXH Rung Cây Tiền", "Số lần rung", "Nhấn chọn để rung", "Rung Mạnh","Rung bao nhiêu tặng bấy nhiêu","Lợi ích Rung Cây Tiền","Kỳ này tổng kết vào lúc %s %02d:%02d", "Số lần còn lại: ", "Hoạt động đã hết hạn"},
MONEYTREE_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Cây Tiền</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Nạp Kim Cương sẽ nhận số lần rung Cây Tiền, mỗi nạp đủ 60 Kim Cương sẽ nhận 1 lần rung</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mua Quà Xu Cây Tiền, mở nhận Xu Cây Tiền, cũng sẽ tự động đổi thành số lần rung, mỗi 1 Xu Cây Tiền đổi được 1 lần rung Cây Tiền</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng số lần rung để rung Cây Tiền, rơi ra số lượng Kim Cương, Kim Cương Khóa, Vàng ngẫu nhiên</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Rung Mạnh sẽ tốn 10 lần rung cùng lúc</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Nhiệm vụ Cây Tiền: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi số lần rung Cây Tiền đạt số lượng quy định sẽ hoàn thành nhiệm vụ ngày và nhiệm vụ tích lũy, nhiệm vụ ngày làm mới mỗi ngày, nhiệm vụ tích lũy sẽ tích lũy số lượng, chỉ được hoàn thành 1 lần</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">BXH Rung Cây Tiền: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thống kê theo số lần rung khi cá nhân tham gia hoạt động. Top 50 được nhận thưởng phát qua thư khi hoạt động kết thúc. </T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>]],

PET_EQUIPMENT_16 = "Xác suất không giảm sao",
PET_EQUIPMENT_17 = "Kế thừa thành công",
HOLIDAYVILLAGE_TEXT2 = {{"Mệt rồi thì đến Khu Nghỉ Mát, trồng cây chăm hoa, rời xa thế giới xô bồ", "Mệt rồi thì đến Khu Nghỉ Mát, trồng cây chăm hoa, rời xa thế giới xô bồ", "Mệt rồi thì đến Khu Nghỉ Mát, trồng cây chăm hoa, rời xa thế giới xô bồ~"}, "Nhà", "Kho", "Cây Thần Tinh Linh", "Cấp Cây Thần", "Giảm thời gian sinh trưởng của Cây Trái", "Vị trí Cây Trái", "Thuộc tính hiện tại", "Thuộc tính cấp kế", "Cây Thần Lv%d mở", "Thời gian trưởng thành", "Chọn 1 đạo cụ để bồi dưỡng", "Có thể thu hoạch", " sau có thể thu hoạch", "Chưa mở khóa", "Chọn đạo cụ cần bồi dưỡng để tăng tốc", "Rừng Cây Thần", "Nhận tất cả", "Có hạt giống:", "Đang chờ cầu nguyện..."},

CHALLENGEN_8 = "Đồng Tâm Đồng Lòng",
COUPLE_HEGEMONY_TEXT1 = "Thử Thách Cặp Đôi",
COUPLE_HEGEMONY_TEXT2= [[<T C="127,70,26" S="20" P="0">Thưởng Hạng Thử Thách Cặp Đôi</T>]],

COUPLE_HEGEMONY_TEXT3 = "Chưa đến thời gian khiêu chiến BOSS Thử Thách Cặp Đôi, cổ vũ vô hiệu!",
COUPLE_HEGEMONY_TEXT4 = "Thời gian khiêu chiến Thử Thách Cặp Đôi hôm nay đã kết thúc, không thể cổ vũ",
COUPLE_HEGEMONY_TEXT5 = "Thời gian khiêu chiến Thử Thách Cặp Đôi hôm nay đã kết thúc",
COUPLE_HEGEMONY_TEXT6 = "BOSS Thử Thách Cặp Đôi sẽ xuất hiện lúc %s",
COUPLE_HEGEMONY_TEXT7 = "BOSS Thử Thách Cặp Đôi đã bị đẩy lui! Mai hãy quay lại nhé!",

COUPLE_HEGEMONY_TEXT8 =
[[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0"> Quy tắc Thử Thách Cặp Đôi</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1. </T><T C="127,70,26" S="22" P="0">Thưởng mục tiêu sinh lực BOSS Thử Thách Cặp Đôi sẽ phát lúc 23:00</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2. </T><T C="127,70,26" S="22" P="0">BXH được thống kê theo sát thương tổ đội vợ chồng gây cho BOSS, khiêu chiến cá nhân không tính vào BXH</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3. </T><T C="127,70,26" S="22" P="0">Thưởng hạng Thử Thách Cặp Đôi sẽ được phát sau khi tổng kết mỗi tháng</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4. </T><T C="127,70,26" S="22" P="0">Hiệu quả cổ vũ Thử Thách Cặp Đôi chỉ có hiệu lực khi đang đánh BOSS</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">5. </T><T C="127,70,26" S="22" P="0">Thử Thách Cặp Đôi sẽ kết thúc sau 10 lượt đánh của BOSS!</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">6. </T><T C="127,70,26" S="22" P="0">BOSS Thử Thách Cặp Đôi sẽ luân chuyển mỗi ngày</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">7. </T><T C="127,70,26" S="22" P="0">Cùng một người chơi đạt được nhiều thứ hạng trong BXH Sát Thương, thì chỉ nhận được phần thưởng dành cho thứ hạng cao nhất đã đạt</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">8. </T><T C="127,70,26" S="22" P="0">Thời gian khiêu chiến BOSS Thử Thách Cặp Đôi là 14:00-23:00 (Nếu bị diệt sớm sẽ kết thúc sớm)</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">9. </T><T C="127,70,26" S="22" P="0">BOSS Thử Thách Cặp Đôi bị đánh bại, liền đi bái sư học nghệ, tăng cường thực lực</T><BR>10</BR>
]],
COUPLE_HEGEMONY_TEXT9 = "%s mời bạn vào Phòng Thử Thách Cặp Đôi cùng chiến đấu",
COUPLE_HEGEMONY_TEXT10 = "BOSS Thử Thách Cặp Đôi chưa bị diệt, hãy tiếp tục cố gắng!",
COUPLE_HEGEMONY_TEXT11 = "Diệt BOSS Thử Thách Cặp Đôi thành công",
PET_EQUIPMENT_18 = "Cần thêm trang bị",
PET_EQUIPMENT_19 = "Trang bị này không có mục kế thừa, không thể kế thừa",
PET_EQUIPMENT_20 = "Cần chọn trang bị muốn kế thừa",

COUPLE_HEGEMONY_TEXT12 = "Bạn còn độc thân, chưa có đối tượng",
COUPLE_HEGEMONY_TEXT13 = "Cổ Vũ Tình Yêu",
COUPLE_HEGEMONY_TEXT14 = "Top 1 các kỳ",

GAME_ACTIVITY_EIGHTY_EIGHT = "Hoàn trả nạp Ngày Hội Mua Sắm",
RECHARGED_TEXT = "Hôm nay đã nạp ",
COUPLE_HEGEMONY_TEXT15 = "Hạng Vợ Chồng",
COUPLE_HEGEMONY_TEXT16 = "Thử Thách Cặp Đôi lần này",
COUPLE_HEGEMONY_TEXT17 = "Kết thúc vào 24h %s/%s",
COUPLE_HEGEMONY_TEXT18 = "BXH Tháng",
COUPLE_HEGEMONY_TEXT19 = {"Chưa hiệu lực","Đã hiệu lực"},
COUPLE_HEGEMONY_TEXT20 = "Cần có vợ hoặc chồng mới được tham gia!",
ACTIVITY_EIGHTY_EIGHT_TEXT1 = [[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0">Hướng dẫn hoạt động Hoàn Trả Nạp</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1. </T><T C="127,70,26" S="22" P="0">Hôm nay nạp đủ mức yêu cầu sẽ nhận hoàn trả siêu lợi.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2. </T><T C="127,70,26" S="22" P="0">0h mỗi ngày làm mới mức nạp</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3. </T><T C="127,70,26" S="22" P="0">Khi làm mới nếu có hoàn trả chưa nhận thì sẽ gửi qua thư</T><BR>10</BR>
]],
OTHER_TEXT1 = {"Tinh Thạch", "Danh Hiệu Hồn Đặc Biệt", "Danh Hiệu Thuộc Tính Đúc Hồn Đặc Biệt", "Danh Hiệu Đặc Biệt Đã Sưu Tập: ", "Thu thập %d Danh Hiệu đặc biệt có thể mở Ô Hồn, hiện đã sưu tập %d ", "%d mở khóa", '<T C="255,236,193" S="20" P="1">Đã sưu tập: </T><T C="229,105,22" S="20" P="1">%d</T><T C="255,236,193" S="20" P="1"> </T>', "Vua Lực Chiến", "Quà 7 Năm", "Cánh Hiếm", '<T S="16" C="255,236,193" P="1">Để cảm ơn sự đồng hành của các bạn trong 7 năm qua, chúng tôi sẽ kỷ niệm 7 năm vào lúc </T><T S="16" C="255,89,74" P="1">11:00 16/06</T><T S="16" C="255,236,193" P="1">, gửi quà tri ân qua thư toàn server: </T>', "Khung Avatar Độc Quyền VIP %d ", "Khung Thông Tin Độc Quyền VIP %d", "Khung Thông Tin", "Thiết Lập Ngoại Hình", "Hiển thị lời nhắn"},
CRAZY_GASHAPON_TEXT1 = {"Crazy Gacha","Nhiệm vụ Gacha","Cỗ Máy Thời Gian Gacha","Trùm Gacha","Gacha %d lượt","Gacha %s lần","Xuyên Không %d lượt","Kho Báu Gacha"," Xuyên Không  %d/%d lượt có thể chọn Kho Báu Gacha %d/%d lượt","Thưởng Gacha (Nhỏ)"," Thưởng Gacha (Lớn)","Gacha miễn phí",[[Chúc mừng, "Xuyên Không" nhận được phần thưởng như sau]]},
CRAZY_GASHAPON_TEXT2 = [[ <T C="229,105,22" S="22" P="1">Hướng dẫn event Crazy Gacha</T><BR>10</BR> <T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác：</T><BR>10</BR> <T C="127,70,26" S="20" P="0"> Sử dụng xu Gacha để tham gia quay Gacha;</T><BR>10</BR> <T C="127,70,26" S="20" P="0"> Quay Gacha có thể nhận được phần thưởng và điểm Gashapon. Nếu đạt đủ điểm Gashapon có thể nhận gấp đôi số lần quay Gacha, khi được gấp đôi số lần quay Gacha có thể nhận được gấp đôi thưởng；</T><BR>10</BR> <T C="127,70,26" S="20" P="0">Sử dụng mỗi 8 xu Gacha, sẽ nhận được một Phiếu Thời Gian；</T><BR>10</BR> <T C="127,70,26" S="20" P="0"> Phiếu Thời Gian được dùng trong Cỗ Máy Thời Gian để Xuyên Không.;</T><BR>10</BR> <T C="127,70,26" S="20" P="0"> Xuyên Không có thể nhận được những phần thưởng hiếm và có thể chọn Kho Báu Gacha sau khi Xuyên Không đến số lần nhất định;</T><BR>10</BR> <T C="127,70,26" S="20" P="0"> Tích lũy Gashapon có cơ hội giành được giải thưởng Gacha lớn! </T><BR>10</BR> <T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ Gacha：</T><BR>10</BR> <T C="127,70,26" S="20" P="0"> Được chia thành Gacha Hôm Nay và Gacha Master. Nhiệm vụ Gacha Hôm Nay hoàn thành trong ngày và nhận thưởng 1 lần mỗi ngày, dữ liệu sẽ xóa vào ngày hôm sau: Nhiệm vụ Gacha Master chỉ có thể hoàn thành một lần trong thời gian diễn ra event, sau khi hoàn thành cần nhận thưởng kịp thời, tất cả dữ liệu sẽ bị xóa sau khi kết thúc event；</T><BR>10</BR> <T C="127,70,26" S="20" P="0"> Số lượng Gacha miễn phí không được tính vào tiến trình của Nhiệm vụ Gacha </T><BR>10</BR> <T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Bảng Xếp Hạng Trùm Gacha：</T><BR>10</BR> <T C="127,70,26" S="20" P="0"> Thống kê dựa trên số lần xuyên không của mỗi user, 100 user top sẽ nhận được phần thưởng hậu hĩnh, sẽ gửi quà qua thư  vào cuối event .</T><BR>10</BR> <T C="229,105,22" S="22" P="1"> Lưu ý: Sau event, tất cả đạo cụ event và dữ liệu khác sẽ bị xóa. Hãy tiêu dùng hợp lý !</T><BR>10</BR> ]],
CRAZY_GASHAPON_TEXT3 = {"Bảng Xếp Hạng Gacha","Gacha Hôm Nay","Cao Thủ Gacha","Số Lần Xuyên Không", "Gacha", " Thưởng Gacha (Lớn)", " Thưởng Gacha (Nhỏ)"},
CRAZY_GASHAPON_TEXT4 = {"Không", "Một", "Hai", "Ba", "Bốn", "Năm", "Sáu", "Bảy", "Tám", "Chín"},
CRAZY_GASHAPON_TEXT5 = {"Chục", "Trăm", "Nghìn", "Chục Nghìn", "Trăm Triệu", "Triệu"},
CRAZY_GASHAPON_TEXT6 = "Đôi",

DRESS_SUIT_TEXT1 = [[<T C="255,89,74" S="20" P="0">Thưởng thuộc tính set %s món(</T><T C="%s" S="20" P="0">%d</T><T C="255,89,74" S="20" P="0">/%d)</T>]],
BILLIARDBALL_TEXT1 ={"Cao Thủ Billiard", "Nhiệm Vụ Huấn Luyện", "BXH Khiêu Chiến", "Điểm Ghi Bàn", "Đánh %d Lần", "Đánh Miễn Phí", "Thưởng May Mắn", "Thưởng Lớn", "Một Đòn Kết Trận", "Tiệm Sưu Tập", "Thưởng Cấp Huấn Luyện", "EXP Huấn Luyện"},
BILLIARDBALL_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Cao Thủ Billiard</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể chọn loại cơ cần thiết [Cơ Gỗ/Cơ Bạc/Cơ Vàng] để rút thưởng. Cơ Gỗ mỗi lần cần tốn 1 Găng Tay, Cơ Bạc mỗi lần cần tốn 3 Găng Tay, Cơ Vàng mỗi lần cần tốn 5 Găng Tay, nhận được phần thưởng tương ứng. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi tốn 1 Găng Tay sẽ nhận được 1 điểm. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi tốn 5 Găng Tay sẽ nhận được 1 cúp. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Một đòn kết trận bằng Cơ Vàng sẽ nhận thêm 1 Cúp. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Cúp có thể được đổi lấy phần thưởng quý giá trong Tiệm Sưu Tập. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy vụt bóng có cơ hội nhận thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Huấn Luyện:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Nhiệm Vụ Trong Ngày, Nhiệm Vụ Trưởng Thành và Nhiệm Vụ Huấn Luyện. Nhiệm Vụ Trong Ngày mỗi ngày được nhận và hoàn thành 1 lần, sang hôm sau sẽ xóa dữ liệu. Nhiệm Vụ Trưởng Thành và Nhiệm Vụ Huấn Luyện trong cả hoạt động chỉ được hoàn thành 1 lần. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa tất cả dữ liệu liên quan. </T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">BXH Khiêu Chiến:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thống kê theo số điểm cá nhân nhận được khi tham gia hoạt động. Top 100 được nhận thưởng phát qua thư khi hoạt động kết thúc. </T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>
]],
DRESSGIVE_TEXT1 = {"Thời Trang Ưu Đãi", "Thưởng mua ngay", "Mua ngay để nhận hoặc đăng nhập đủ %d ngày (%d/%d)", "Đã bán hết", "Hệ thống đang bảo trì, vui lòng quay lại sau"},
DRESSGIVE_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng Dẫn Hoạt Động Khuyến Mãi Thời Trang</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"></T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể nhận gói quà đầu tiên ở cấp đầu tiên bằng cách đăng nhập tích lũy. Có thể nhận trực tiếp sau khi đạt số ngày đăng nhập tích lũy. Sau khi nhận, giá của cấp này sẽ giảm xuống, chỉ có thể nhận được gói quà thứ hai và thứ ba khi mua. </T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"></T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể nhận thêm thưởng sau khi mua mức quà tương ứng</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Lưu ý: Có thể nhận thưởng sự kiện bằng cách đăng nhập tích lũy, đừng bỏ lỡ!</T><BR>10</BR>]],


FOOT_STAR_TEXT1 = "Vòng Sáng Tinh Tú",
FOOT_STAR_TEXT2 = {"Khảm thành công", "Khảm thất bại", "Tháo thành công", "Tháo thất bại", "(Sau khi thất bại, Đá sẽ biến mất)", "Thêm nhanh", "Danh sách Ghép đã đầy", "Chỉ ghép Đá giống nhau", "Chưa đặt Đá vào, không thể thêm Đá giống nhau", "Hãy để Đá vào trước", "Tất cả Đá đạt %s", "Ghép thành công", "Ghép thất bại", "Cần toàn bộ Đá %s đạt %s mới có thể mở khóa Bản Đồ Sao", "(Thất bại sẽ không tiêu hao Đá đã khảm)", "Hiện không thể ghép Đá", "(Thất bại sẽ hoàn trả 1 Đá)", "Danh sách Ghép đã đầy", "Không đủ Đá"},
FOOT_STAR_TEXT3 = {"Lục", "Lam", "Tím", "Cam", "Đỏ"},
FOOT_STAR_TEXT4 = {"Bản đồ sao %s", "Sao %s", "Tổng Vòng Sáng %s", "Tỷ lệ nâng cấp Vòng Sáng thành công", "Tỷ lệ tinh chỉnh Vòng Sáng thành công", "Tổng Thuộc Tính Vòng Sáng"},
FOOT_STAR_TEXT5 = [[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0">Hướng dẫn Vòng Sáng Tinh Tú</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1. </T><T C="127,70,26" S="22" P="0">Vòng Sáng Tinh Tú chia làm 12 Cung, khi tất cả lỗ trong Cung khảm Đá Tinh Tú từ màu Lam trở lên sẽ mở Cung kế</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2. </T><T C="127,70,26" S="22" P="0">Có tổng cộng 7 loại lỗ Đá, cần Đá Tinh Tú tương ứng mới có thể khảm. Thuộc tính tương ứng như sau:</T><BR>10</BR>
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="22" P="0"> Đá Tinh Tú-Tấn Công Nhiệt Tình</T><BR>10</BR>
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="22" P="0"> Đá Tinh Tú-Phòng Thủ Vững Vàng</T><BR>10</BR>
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="22" P="0"> Đá Tinh Tú-Sinh Lực An Toàn</T><BR>10</BR>
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="22" P="0"> Đá Tinh Tú-May Mắn Tỉ Mỉ</T><BR>10</BR>
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="22" P="0"> Đá Tinh Tú-Tốc Độ Nhạy Bén</T><BR>10</BR>
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="22" P="0"> Đá Tinh Tú-Tấn Công, Tốc Độ Hoàn Hảo</T><BR>10</BR>
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="22" P="0"> Đá Tinh Tú-Sinh Lực, May Mắn Đa Nguyên</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3. </T><T C="127,70,26" S="22" P="0">Khi toàn bộ Đá khảm trong cùng một Cung đạt đến phẩm chất yêu cầu, sẽ nhận thêm thuộc tính tăng</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4. </T><T C="127,70,26" S="22" P="0"> Đá Tinh Tú có thể ghép, khi ghép có thể dùng 1-4 viên Đá, với tỉ lệ thành công tương ứng khác nhau.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">5. </T><T C="127,70,26" S="22" P="0">Khi dùng từ 2 viên Đá trở lên để ghép, thất bại sẽ hoàn trả 1 viên.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">6. </T><T C="127,70,26" S="22" P="0">Khảm Đá không tốn Kim Cương Đỏ, nhưng tháo Đá sẽ tốn</T><BR>10</BR>
]],

CHAT_BLOCK_TEXT1 = "Chặn Chat riêng với người lạ",
CHAT_BLOCK_TEXT2 = "Chặn Chat riêng Công Hội",

PASTURE_TEXT_1 = "Thú cưỡi đang bị đoạt không thể ghép",
HOLIDAYVILLAGE_TEXT3 = {"%s sau tạo mới", "Đơn Hoa Tươi", "Ông Trùm Đơn Hàng", "Ông Trùm Các Kỳ", "Chưa nhận đơn", "Đã nhận đơn", "Giao đơn hàng", "Nhận đơn", "Lợi nhuận đơn hàng", "Người làm kinh doanh chú trọng nhất là uy tín, đã nhận đơn hàng, thì nhất định phải hoàn thành!", "Thưởng đơn hàng", "Chi tiết đơn hàng", "Chúc mừng hoàn thành một lô hàng lớn, thưởng lợi nhuận như sau!", "Kỳ %d", "Hoa Ngữ", "Hoàn thành đơn hàng", "Số lần thích hôm nay đã dùng hết", "Tạm không có đơn Hoa Tươi mới, đang cập nhật", [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">Lợi nhuận đơn hàng</T><T C="255,227,116" S="18" P="1" SC="132,66,29" SS="4" SE="1"> %d</T>]], "Dài hạn", "Ao nước", "Đồng ý khai khẩn ao nước này?", "Tinh luyện ao nước", "Ao %d", "Ao này đã có cây trồng rồi", "Hãy mở rộng ao trước đó trước", "Tăng Tinh Linh", "Bán trực tiếp", "Giá bán một bó:", "Tổng giá bán:", "Dùng Thẻ Tăng Tinh Linh để bán thêm, mỗi bó sẽ nhận thêm đạo cụ vật phẩm", "Chú ý: Bán hoa, số lượng Hoa Tươi trong Thư Viện sẽ giảm! Hãy thao tác cẩn thận", "Bán Hoa", "Số lượng Hoa Tươi không đủ để bán, mau đi trồng thêm 1 ít nữa", [[<T C="127,70,26" S="18" P="1">Lần này đã bán </T><T C="229,105,22" S="18" P="1">%d</T><T C="127,70,26" S="18" P="1"> bó hoa, Thẻ Tinh Linh còn lại chỉ có thể tăng thêm </T><T C="229,105,22" S="18" P="1">%d</T><T C="127,70,26" S="18" P="1"> bó hoa!</T>]], "Lợi nhuận cơ bản", "Tăng lợi nhuận", "Lợi nhuận bán"},
MIDNIGHTDINER_TEXT1 ={"Nhà Ăn Đêm Khuya", "Check-in Đêm", "BXH Check-in", "Số Lần Check-in", "Ăn %d Bát", "Ăn %d Phần", "Ăn Miễn Phí", "Thưởng Cao Thủ Check-in", "Thưởng Idol Check-in", "Thưởng Ngôi Sao Check-in", "Check-in Trong Ngày", "Tích Lũy Check-in", "Cùng Nhau Check-in", "Hoành Thánh", "Đĩa Xiên Nướng", "Tôm Càng", "BXH Cùng Nhau Check-in", "Thưởng Cùng Nhau Check-in", "EXP Check-in", "Cao Thủ Check-in", "Idol Check-in", "Ngôi Sao Check-in", "Chú ý: Cần mời bạn thành công mới có thể thống kê EXP Check-in", "Cá nhân tích lũy được số lần check-in nhất định có thể nhận đồ uống đặc biệt", "Chú ý: Trong thời gian sự kiện, chỉ có thể lập đội với một người bạn để check-in, sau khi xác nhận liên kết, không thể giải trừ. Hãy lựa chọn đồng đội cẩn thận!", "Cùng nhau đoàn kết, chức vô địch là của chúng ta"},
MIDNIGHTDINER_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Nhà Ăn Đêm Khuya</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể chọn 3 loại món ăn [Mì Hoành Thánh/Xiên Nướng/Tôm Càng Xanh] để check-In rút thưởng. Chi tiết cho từng món như sau:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Hoành thánh: Mỗi khi ăn một bát, tiêu hao 1 Phiếu Ăn Đêm và nhận 1 phần thưởng thường. Đăng nhập trò chơi mỗi ngày có thể ăn một bát hoành thánh miễn phí. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Đĩa Xiên Nướng: Mỗi lần ăn một đĩa, tiêu hao 3 Phiếu Ăn Đêm và nhận 1 phần thưởng thường</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tôm Càng Xanh: Mỗi phần ăn tiêu hao 5 Phiếu Ăn Đêm và nhận 2 phần thưởng thường</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Với mỗi Phiếu Ăn Đêm được sử dụng, có thể nhận 2 EXP Check-in. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Đồ Uống Bí Ẩn: Sau khi Check-in mỗi ngày đủ 10 lần, có thể nhận đồ uống đặc biệt bí ẩn, tối đa mười phần một ngày. Dữ liệu sẽ bị xóa vào ngày hôm sau, hãy nhận thưởng kịp thời. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Check-in có cơ hội trúng thêm thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Check-in Đêm:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Check-in Trong Ngày, Tích Lũy Check-in và Cùng Nhau Check-in. Check-in Trong Ngày mỗi ngày được nhận và hoàn thành 1 lần, sang hôm sau sẽ xóa dữ liệu. Tích Lũy Check-in và Cùng Nhau Check-in trong cả hoạt động chỉ được hoàn thành 1 lần. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa tất cả dữ liệu liên quan. </T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Lưu ý: Đối với nhiệm vụ tổ đội, bạn cần mời bạn bè cùng nhau lập đội hoàn thành. Sau khi khóa thành công mới có thể tăng điểm tích lũy tiến độ nhiệm vụ!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Cùng Nhau Check-in:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Người chơi có thể lập đội với bạn bè để check-in, hoàn thành nhiệm vụ hoặc xếp hạng. </T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH Check-in:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành BXH Check-in và BXH Cùng Nhau Check-in. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Check-in được tính dựa trên EXP Check-in của những cá nhân tham gia sự kiện, 100 người chơi hàng đầu sẽ nhận được thưởng hậu hĩnh, thưởng sẽ được gửi qua thư sau sự kiện. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Cùng Nhau Check-in được tính dựa trên EXP Check-in của các thành viên tổ đội tham gia sự kiện, 20 đội hàng đầu sẽ nhận được thưởng hậu hĩnh, thưởng sẽ được gửi qua thư sau sự kiện. </T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>
]],
MIDNIGHTDINER_TEXT3 ={"Bé ơi! có muốn ăn tối cùng nhau không?", "Đồ ăn khuya là thứ chữa lành vết thương tốt nhất.", "Chúng ta hãy cùng nhau thưởng thức đồ ăn và giành chức vô địch nhé.", "Này! Bé yêu của bạn gọi bạn đi ăn bữa tối kìa!"},
SHOP_DAY_LIMIT_HV = "Giới hạn mua hiện tại",
CHECK_OTHER_EXPAND = {"Thu hồi", "Bắt đầu"},
GOPHERBALL_TEXT1 ={"Home Run", "Kiện Tướng Vận Động", "BXH Cao Thủ Bóng Chày", "Độ Nổi Tiếng", "Đánh Bóng %d lần", "BXH Tiêu Phí", "Miễn Phí Đánh Bóng", "Đại Hội Vận Động", "Bóng Chày", "Giải Đặc Biệt", "Rèn Luyện Mỗi Ngày", "Con Đường Mạnh Mẽ", "BXH Base Run", "Điểm Số", "Người chơi toàn server tích lũy đánh bóng %d lần, có thể nhận 1 Thưởng", {"Phù.. đánh tốt đấy, tiếp tục!", "Xem tôi đánh cú Home Run này!", "Ấy, đánh lệch rồi!", "Yeah.."}, "BXH Cống Hiến", "Điểm Cống Hiến", "Điểm Cống Hiến của tôi: ", "Số khung avatar hiện có: ", "Base Run", "BXH Người Mới", "vip %d có thể mở Loa Vàng"},
GOPHERBALL_TEXT2 = 
[[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Home Run</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tốn Gậy Bóng Chày để rút thưởng phát bóng, mỗi lần phát bóng tốn 1 Gậy Bóng Chày, chắc chắn nhận 1 phần thưởng, đăng nhập mỗi ngày nhận miễn phí 1 lần phát bóng:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần tốn 1 Gậy Bóng Chày có thể nhận 2 Độ Nổi Tiếng. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần tốn 10 Gậy Bóng Chày, nhận một lần Base Run, mỗi lần thực hiện Base Run nhận 1 phần thưởng Base Run. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Base Run tại 4 điểm A, B, C, D, chạy từ điểm D đến điểm A là hoàn thành một vòng Base Run. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Hoàn thành 1 vòng Base Run nhận thêm thưởng 1 vòng Base Run, Mảnh Huy Chương Bóng Chày và Điểm Base Run. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Đại Hội Vận Động: Toàn server tích lũy 500 lần phát bóng có thể nhận 1 phần thưởng, tích lũy tối đa 10 lần, số liệu sẽ bị xóa vào ngày hôm sau, hãy nhận thưởng sau khi hoàn thành. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy vụt bóng có cơ hội nhận thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Nhiệm vụ Kiện Tướng Vận Động: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Rèn Luyện Mỗi Ngày và Con Đường Mạnh Mẽ. Rèn Luyện Mỗi Ngày mỗi ngày được nhận và hoàn thành 1 lần, sang hôm sau sẽ xóa dữ liệu. Con Đường Mạnh Mẽ trong cả hoạt động chỉ được hoàn thành 1 lần. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa tất cả dữ liệu liên quan. </T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Được chia thành BXH Cao Thủ Bóng Chày và BXH Điểm Base Run. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Cao Thủ Bóng Chày thống kê theo độ nổi tiếng đạt được khi tham gia hoạt động. Top 100 được nhận thưởng phát qua thư khi hoạt động kết thúc. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Điểm Base Run được tính trên điểm Base Run, top 20 người chơi có thể nhận thưởng hấp dẫn, thưởng được phát qua Thư sau khi hoạt động kết thúc. </T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả dữ liệu và đạo cụ liên quan sẽ bị xóa hết, hãy tiêu dùng hợp lý!</T><BR>10</BR>
]],

GOPHERBALL_TEXT3 = 
[[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động BXH Người Mới</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">BXH Cống Hiến: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Cống Hiến được tính trên điểm cống hiến, top 100 người chơi có thể nhận thưởng hấp dẫn, thưởng được phát qua Thư sau khi hoạt động kết thúc. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Nạp đủ 60 Kim Cương sẽ nhận được 2 điểm cống hiến (Chỉ tính nạp Kim Cương,Thẻ Tuần, Thẻ Tháng, Thẻ Phúc Lợi, không tính hoàn trả nạp)</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mua 1 Quà có thể nhận 2 điểm Cống Hiến</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">BXH Tiêu Phí: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Tiêu Phí được tính theo Điểm Tiêu Phí, top 100 người chơi có thể nhận thưởng hấp dẫn, thưởng được phát qua Thư sau khi hoạt động kết thúc. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tiêu phí 100 Kim Cương Lam nhận 1 điểm (Không tính Kim Cương Đỏ)</T><BR>10</BR>
]],
LITTLE_GAME_TEXT = {"Bắt Đầu Lại", "Khiêu Chiến Phó Bản", "Không Thể Di Chuyển", "Không Thể Rút Lại", "Không Thể Mở Bomb", "Chọn Ải", "Chơi Lại", "Ải Tiếp Theo"},
LITTLE_GAME_DESC = 
[[
<T C="229,105,22" S="22" P="1">Hướng dẫn</T>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Tính năng: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Nhấp vào hình, đưa ba hình giống nhau vào ô phía dưới để loại bỏ. </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Loại bỏ tất cả hình để qua ải</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng đạo cụ hỗ trợ qua ải</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Vượt ải 20, 40, 60, 80, 100 thành công có thể nhận thưởng danh hiệu</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Đạo cụ: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Xóa: xóa tối đa 3 hình khỏi thanh đặt hình</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Rút lại: đưa 1 hình vừa rút về vị trí ban đầu</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thay đổi: thay đổi vị trí hình trên màn hình (Không thay đổi bố cục)</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Bomb Chùm: Chọn 1 hình, xóa tất cả hình giống nhau</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Xào Lại: Xào lại tất cả hình</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể nhận đạo cụ thông qua nút Khiêu Chiến Phó Bản trong Thiết lập. </T><BR>10</BR>
]],
LEVEL_TEXT1 = "Ải",
LEVEL_TEXT2 = "Ải %d",
MARRY_DESC_42 = "Đã kết hôn, không cần cử hành hôn lễ",
SMALL_GAME_TEXT_1 = "Đến nhận đạo cụ rồi khiêu chiến ải này?",
BEINGIMMORTAL_TEXT1 ={"Tu Tiên Truyện", "Tu Tiên Ký", "Tông Môn Mạnh Nhất", "Số lần Tu Luyện", "Tu Luyện %d lần", "Bảng Huyền Thoại", "Cấp Tu Tiên","Thưởng Tu Tiên (Lớn)","Tu Luyện","Thưởng Tu Tiên (Nhỏ)", "Tu Luyện Mỗi Ngày", "Bế Quan Tu Luyện", "Thu Nhặt Vào Túi", "BXH Phi Thăng", "Số lần Phi Thăng", "BXH Phi Thăng Các Kỳ", "Đơn Dược Phi Thăng", "Thưởng BXH Tông Môn Mạnh Nhất", "Nhiệm Vụ Tông Môn", "Hạng Tông Môn", "Điểm Pháp Lực Tông Môn", "Hạng Tông Môn:", "Pháp Lực Tu Luyện", "Phi Thăng %d lần", "Phi Thăng 1 lần được nhận thêm thưởng sau", "Đơn Dược không đủ, hãy trang bị thêm!", [[<T C="127,70,26" S="18" P="1">Phi Thăng</T><T C="229,105,22" S="18" P="1">%d</T><T C="127,70,26" S="18" P="1"> lần</T>]], "Đơn Dược", "BXH Tông Môn Mạnh Nhất", "Tông Môn/Cấp/ID", "Người Phàm", {"Bách Yêu Cốc", "Thác Thiên Sa", "Vạn Yêu Điện", "Cổ Băng Động", "Côn Lôn Cung"}, {"Luyện Khí-Bách Yêu Cốc", "Thử Thách Trúc Cơ", "Thử Thách Kim Đơn", "Ngưng Tụ Nguyên Anh", "Thử Thách Hóa Thần"}, "Phi Thăng", "Điểm Pháp Lực"},
BEINGIMMORTAL_TEXT0_VN ={"Tiên Nhân Đăng Tiên"},
BEINGIMMORTAL_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Tu Tiên Truyện</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Nghe đồn thuở xa xưa, Lục Địa Tu Tiên từng có rất nhiều tu sĩ Tu Tiên. Trong suốt quá trình tu luyện và thám hiểm, họ đã phát hiện ra 5 nơi có nhiều tài nguyên phù hợp, tương ứng với các cấp bậc tu luyện của họ, lần lượt là: Tu Sĩ Luyện Khí/Bách Yêu Cốc, Tu Sĩ Trúc Cơ/Thác Thiên Sa, Tu Sĩ Kim Đơn/Vạn Yêu Điện, Tu Sĩ Nguyên Anh/Cổ Băng Động, Hóa Thần Tôn Giả/Côn Lôn Cung. Các vị tu sĩ cần đạt cấp bậc yêu cầu mới có thể vào nơi tu luyện tốt nhất, mỗi nơi lại có thể tìm được các loại Đơn Dược tương ứng. Đơn Dược chủ yếu dùng để Phi Thăng.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Các vị tu sĩ Tu Tiên có thể nhấp chọn vào Xe Bánh Kem trong giao diện chính để nhận [Đá Tu Luyện]. Mỗi lần Tu Luyện cần tốn 1 Đá Tu Luyện, nhận được 1 phần thưởng ngẫu nhiên. Hoàn thành 1 vòng Tu Luyện, sẽ có thể Tu Luyện tại Tu Sĩ Luyện Khí/Bách Yêu Cốc lần nữa, lúc này mỗi lần Tu Luyện sẽ tốn 1 Đá Tu Luyện, nhận được 2 phần thưởng ngẫu nhiên.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Cấp Tu Luyện: Tiêu hao Đá Tu Luyện để nhận Pháp Lực Tu Luyện. Pháp Lực Tu Luyện cần cho mỗi Cấp Tu Tiên sẽ được tính tích lũy riêng. Trong hoạt động, có thể hoàn thành và nhận thưởng 1 lần. Sau khi hoàn thành hãy nhớ nhận thưởng kịp thời! Khi hoạt động kết thúc sẽ xóa hết dữ liệu liên quan, cũng không có phát thưởng bù đâu!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Tu Tiên Ký: Chia làm nhiệm vụ Tu Luyện Mỗi Ngày và Bế Quan Tu Luyện. Nhiệm vụ Tu Luyện Mỗi Ngày mỗi ngày được nhận 1 lần, sang hôm sau sẽ xóa dữ liệu. Nhiệm vụ Bế Quan Tu Luyện có thể hoàn thành và nhận thưởng 1 lần. Sau khi hoàn thành hãy nhớ nhận thưởng kịp thời! Khi hoạt động kết thúc sẽ xóa hết dữ liệu liên quan, cũng không có phát thưởng bù đâu!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Phi Thăng: Các vị tu sĩ Tu Tiên có cơ hội nhận được Đơn Dược Phi Thăng trong quá trình Tu Luyện. Mỗi lần Phi Thăng cần tốn 1 Đơn Dược, nhận 1 phần thưởng ngẫu nhiên. Sau khi kích hoạt toàn bộ Đơn Dược tre7n người nhân vật, sẽ hoàn thành 1 lần Phi Thăng. Hoàn thành 1 lần Phi Thăng sẽ được nhận thêm 1 phần thưởng,P hi Thăng có thể hoàn thành và nhận thưởng nhiều lần.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0">Tông Môn Mạnh Nhất: Chia làm Nhiệm Vụ Tông Môn và BXH Tông Môn Mạnh Nhất. Nhiệm Vụ Tông Môn mỗi ngày được nhận 1 lần, sang hôm sau sẽ xóa dữ liệu. BXH Tông Môn sẽ tính tích lũy theo số Đá Tu Luyện đã tiêu tốn khi nhận Điểm Pháp Lực, Top 10 người chơi được nhận thưởng. Sau khi hoạt động kết thúc, thưởng sẽ được tự động gửi qua thư.</T><BR>10</BR>
<T C="229,105,22" S="20" P="1">Chú ý: BXH Tông Môn Mạnh Nhất, người chơi cùng Công Hội cần tham gia hoạt động và nhận ít nhất 1 Điểm Pháp Lực, mới có thể nhận thưởng khi tổng kết.</T><BR>10</BR>
<T C="229,105,22" S="20" P="1">Chú ý: Nếu thành viên rời Công Hội giữa chừng và gia nhập vào Công Hội mới, mức tích lũy Điểm Pháp Lực trong Công Hội cũ không đổi, nhưng sẽ không tính vào cho Công Hội mới.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">BXH Thông Thường: Chia làm [BXH Tu Luyện] và [BXH Phi Thăng]</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">[BXH Tu Luyện]: Tính hạng theo số lần Tu Luyện của người chơi, Top 100 người chơi được nhận thưởng. Sau khi hoạt động kết thúc, thưởng sẽ được tự động gửi qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">[BXH Phi Thăng] BXH: Tính tích lũy theo số lần người chơi Phi Thăng thành công, Top 10 người chơi được nhận thưởng. Sau khi hoạt động kết thúc, thưởng sẽ được tự động gửi qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],

GONGANDDRUM_TEXT1 =  {"Trống Chiêng Vang Lừng", "Nhiệm Vụ Gõ Trống", "BXH Ngũ Âm", "Toàn Dân Gõ Trống", "Ngũ Âm Giai", "Gõ Trống Miễn Phí", "Gõ Nhẹ %d lần", "Gõ Mạnh %d lần", "Số Âm Giai", "Gõ Trống Mỗi Ngày", "Biểu Diễn Gõ Chiêng", "Thưởng Gõ Trống (Nhỏ)", "Thưởng Mê Gõ Chiêng", "Chuyên Gia Gõ Chiêng", "Dùng đủ số Dùi Trống chỉ định có thể nhận 1 Âm Giai, mở 5 Âm Giai có thể nhận một phần Thưởng Ngũ Âm (chắc chắn nhận được một trong các thưởng đã chọn)", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó]], "Toàn server tích lũy Gõ Trống đạt %d lần thì có thể nhận 1 phần quà", "Thưởng Ngũ Âm"},
GONGANDDRUM_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Trống Chiêng Vang Lừng</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Dùi để rút thưởng Gõ Trống. Dùi Gỗ Gõ Trống mỗi lần cần tốn 1 Dùi, chắc chắn nhận được 1 phần thưởng thường. Đăng nhập mỗi ngày được miễn phí Gõ Trống 1 lần. Dùi Vàng Gõ Trống mỗi lần cần tốn 5 Dùi, chắc chắn nhận được 1 phần thưởng cao cấp: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi Gõ Trống có xác suất nhận Âm Giai, một Âm Giai gồm 5 loại: Cung, Thương, Giốc, Chủy, Vũ. Mỗi khi sưu tập đủ một Âm Giai có thể nhận 1 phần Thưởng Lớn Ngũ Âm (nếu đã chọn thưởng trước thì chắc chắn nhận đúng thưởng đã chọn)!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Toàn server Gõ Trống đạt số lần nhất định sẽ nhận được Thưởng toàn server.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Gõ Trống có cơ hội nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Gõ Trống: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Gõ Trống Mỗi Ngày, Biểu Diễn Gõ Chiêng. Nhiệm vụ Gõ Trống Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Biểu Diễn Gõ Chiêng trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">BXH Ngũ Âm: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Ngũ Âm thống kê theo Số Âm Giai nhận được. Top 100 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
DAZZLERANK_TEXT1 =  {"BXH Vinh Quang", "BXH Cống Hiến", "Điểm Vinh Quang", "Điểm Cống Hiến", "Vinh Quang Cá Nhân", "Cống Hiến Cá Nhân", "Vinh Quang", "Cống Hiến", "BXH Các Kỳ", "Hôm nay đã bấm Like cho người này rồi", "Bồn Hoa", "Không còn dư Bồn Hoa nào nữa!"},
DAZZLERANK_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động BXH Vinh Quang</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">BXH Vinh Quang: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Vinh Quang sẽ thống kê theo Điểm Vinh Quang, Top 100 người chơi được nhận thưởng. Sau khi hoạt động kết thúc, thưởng sẽ được gửi qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Nạp đủ 60 Kim Cương sẽ nhận được 1 Điểm Vinh Quang (Chỉ tính trên số Kim Cương nạp thực tế, không tính Thẻ Tuần, Thẻ Tháng, Thẻ Phúc Lợi, không tính hoàn trả nạp)</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">BXH Cống Hiến:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Cống Hiến sẽ thống kê theo Điểm Cống Hiến, Top 100 người chơi được nhận thưởng. Sau khi hoạt động kết thúc, thưởng sẽ được gửi qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng đủ 100 Kim Cương Lam sẽ nhận được 1 Điểm (Không tính Kim Cương Đỏ)</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">BXH Các Kỳ: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Ghi nhận thành tích của các nhà vô địch BXH Vinh Quang và BXH Cống Hiến các kỳ, người chơi có thể Xem và Thích.</T><BR>10</BR>
]],
ACTIVITY_TEXT215 = [[<T C="229,105,22" S="22" P="1">Tiến độ nhiệm vụ sẽ tái lập vào 0:00 hàng ngày</T><BR>10</BR>]],


DETECTIVE_TEXT1 =  {"Văn Phòng Thám Tử", "Ủy Thác Điều Tra", "BXH Điều Tra", "Chỉnh Lý Vụ Án", "BXH Danh Tiếng", "Điều Tra Miễn Phí", "Điều Tra %d lần", "Tốn Kính Lúp", "Danh Tiếng", "Điều Tra Hàng Ngày", "Ủy Thác Dài Ngày", "Giả Thiết", "Manh Mối", "Suy Luận", "Chân Tướng", [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó</T>]], {"Chỉ thiếu chút nữa thôi!", "Ai da, hình như đi quá đà rồi!", "Vào ngõ cụt rồi, ha ha..."}, "Đã đặt vào rồi, giờ hãy đi Chỉnh Lý Vụ Án nào!", "Cần đặt đạo cụ trên mỗi ô!"},
PVP_STRATEGIC_TEXT1 = {"Giải Chiến Lược", "Quần Hùng Tranh Bá", "Đối Kháng Sách Lược", "Chọn Kỹ Năng", "Thông Tin Thi Đấu", "Thưởng Thi Đấu", "Thuộc tính chiến đấu thống nhất trong Giải Chiến Lược", "Nhắc: Giải Chiến Lược là hình thức thi đấu đối kháng dựa trên sách lược và kỹ xảo của mỗi người. Trong tính năng này, thuộc tính nhân vật đều mặc định là giống nhau hoàn toàn.", "Tổng Điểm", "Số kỹ năng đã trang bị không hợp lệ", "Kỹ năng đang dùng không hợp lệ", "Chi tiết bậc đấu", "Tổng lượt trận", "Số trận thắng", "MVP", "Trợ chiến", "Kỷ lục thắng liên tục", "(Tổng %s bậc)", "Đạt yêu cầu", "Thắng liên tục", "2V2\\3V3 thỏa yêu cầu sẽ được nhận", "Thu Nhặt Vào Túi", "Thưởng Trưởng Thành", "Không thể để trống", "Không trong thời gian thi đấu", "Hãy trang bị kỹ năng và đạo cụ dành riêng cho Giải Chiến Lược", "Số lần bảo vệ bậc đấu Giải Chiến Lược +%d", "Số lần bảo vệ bậc đấu còn lại: %d lần", "Kích hoạt Thẻ Giữ Bậc Đấu Giải Chiến Lược, không bị giáng cấp", "Hôm nay đã kết thúc", "Hôm nay không mở", "Mùa Giải chưa bắt đầu"},
PVP_STRATEGIC_TEXT2 =
{
[[Khi gió lớn thì lực tấn công cũng phải lớn để tránh đạn bị thổi bay mất!]],
[[Kỹ năng khác nhau sẽ tốn Điểm Hành Động khác nhau, hãy cân nhắc kỹ và lựa đúng thời điểm ra tay!]],
[[Thi đấu nhiều người cần sự phối hợp nhuần nhuyễn giữa các thành viên trong đội.]],
[[Sử dụng đạo cụ và kỹ năng hợp lý, sẽ có thể lật ngược thế cờ trong chớp mắt! Hãy phán đoán thời cơ, ra tay kịp lúc!]],
[[Trong Giải Chiến Lược, thuộc tính của người chơi là như nhau, vì vậy tất cả đều là sách lược và kỹ xảo!]],
},
PVP_STRATEGIC_TEXT3 = [[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Tích lũy số điểm Giải Chiến Lược đạt mức yêu cầu, sẽ tự động dùng điểm tăng 1 bậc đấu</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Chiến thắng trong Giải Chiến Lược sẽ nhận được điểm. Thắng liên tục, đạt MVP, diệt địch có thể nhận thêm điểm</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Trong Giải Chiến Lược, khi chiến bại sẽ bị trừ điểm, khi điểm không đủ để duy trì bậc đấu, sẽ bị giáng cấp.</T><BR>20</BR>
<T C="229,105,22" S="22">Hướng dẫn</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Sau khi bắt đầu Mùa Giải mới, sẽ diễn ra trong 45 ngày.</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">14:00-23:00 hàng ngày có thể tham gia thi đấu.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Trong Giải Chiến Lược, sẽ mở thể thức thi đấu khác nhau tùy theo ngày. Ngày lẻ mở 2V2, ngày chẵn mở 3V3.</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Khi mở Mùa Giải mới, bậc đấu sẽ bị giảm một mức nhất định.</T><BR>20</BR>
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Kết thúc mùa giải, sẽ phát thưởng theo hạng hiện tại</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Kết thúc mùa giải, người hạng 1 Giải Chiến Lược 3V3 sẽ được lập tượng thành chủ (Trong Mùa Giải đầu tiên, tính theo người hạng 1 hiện tại)</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Trong Giải Chiến Lược, hoàn thành nhiệm vụ mỗi ngày sẽ được nhận thưởng.</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Trong mỗi Mùa Giải, đạt đến bậc đấu yêu cầu sẽ nhận được phần thưởng dành riêng (Tái lập mỗi Mùa Giải).</T><BR>10</BR>
<T C="127,70,26" S="20">PS: Sau khi tái lập Mùa Giải, cần hoàn thành 1 trận thi đấu, mới có thể nhận thưởng bậc đấu.</T><BR>10</BR>
]],
TEACH_215 = "Nhấp chọn kỹ năng",
TEACH_216 = "Nhấp chọn nút Chỉnh Sửa",
TEACH_217 = "Nhấp chọn nút Hoàn Thành",
TEACH_218 = "Chọn kỹ năng",
TEACH_219 = "Chọn đạo cụ",
TEACH_220 = "Đổi sang giao diện đạo cụ",
PVP_STRATEGIC_TEXT4 = {[[<T C="138,122,106" S="18" P="0">Chưa tham gia Giải Chiến Lược 2V2</T>]],[[<T C="138,122,106" S="18" P="0">Chưa tham gia Giải Chiến Lược 3V3</T>]]},
PVP_STRATEGIC_TEXT5 = "Do rút lui trong Giải Chiến Lược, gây ảnh hưởng đến đồng đội, bạn bị cấm thi đấu",
PLANETSEARCH_TEXT1 =  {"Thám Hiểm Hành Tinh", "Kế hoạch Hành Tinh", "BXH Thám Hiểm", [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">Khi kích hoạt phần thưởng đã chọn trước, chắc chắn nhận được một trong những phần thưởng đã chọn</T>]], "Thám hiểm %d lần", "Thám Hiểm miễn phí", "Thưởng nhỏ Hành Tinh", "Thưởng lớn Hành Tinh", "Kho Báu Hành Tinh", "Toàn Dân Thám Hiểm", "Thám Hiểm hàng ngày", "Thám Hiểm Hành Tinh", "Toàn bộ người chơi trong server tích lũy thám hiểm đạt %d lần, có thể nhận 1 phần thưởng", "Điểm Thám Hiểm", {"Mặt Trời", "Sao Thủy", "Sao Kim", "Trái Đất", "Sao Hỏa", "Sao Mộc", "Sao Thổ", "Sao Thiên Vương", "Sao Hải Vương"}, "Hành Tinh Số 1", "Hành Tinh Số 2", "Vật phẩm %s trong kho thưởng %s*%d đã đạt giới hạn, không thể chọn nữa rồi"},
PLANETSEARCH_TEXT2 = [[
<T C="243,227,189" S="22" P="1">Hướng dẫn hoạt động Thám Hiểm Hành Tinh</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">1.</T><T C="243,227,189" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="243,227,189" S="20" P="0">Tiêu hao Kết Tinh Thiên Thạch để rút thưởng (Thám Hiểm). Mỗi lần rút thưởng trong Kho Thưởng Hành Tinh Số 1, sẽ tốn 1 Kết Tinh Thiên Thạch, chắc chắn nhận được một phần thưởng thông thường, tăng 2 Điểm Thám Hiểm, đăng nhập mỗi ngày sẽ được nhận 1 lượt Thám Hiểm Miễn Phí. Mỗi lần rút thưởng trong Kho Thưởng Hành Tinh Số 2, sẽ tốn 5 Kết Tinh Thiên Thạch, chắc chắn nhận được một phần thưởng cao cấp, tăng 10 Điểm Thám Hiểm.</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">Kho Thưởng Hành Tinh Số 1 có cơ hội nhận được Trang Bị Pet Huyền Vũ (Lục), Kho Thưởng Hành Tinh Số 2 có cơ hội nhận được Trang Bị Pet Huyền Vũ (Lam)/(Tím).</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">Toàn server Thám Hiểm đạt số lần yêu cầu, sẽ được nhận một phần thưởng Thám Hiểm toàn server.</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">Tích lũy Thám Hiểm có cơ hội nhận thêm Thưởng Thám Hiểm (Lớn)!</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">2.</T><T C="243,227,189" S="20" P="0">Kế Hoạch Hành Tinh: </T><BR>10</BR>
<T C="243,227,189" S="20" P="0">Chia làm nhiệm vụ Thám Hiểm Hàng Ngày, Thám Hiểm Hành Tinh. Nhiệm vụ Thám Hiểm Hàng Ngày mỗi ngày được nhận 1 lần, sang hôm sau sẽ xóa dữ liệu. Nhiệm vụ Thám Hiểm Hành Tinh trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">4.</T><T C="243,227,189" S="20" P="0">BXH Thám Hiểm: </T><BR>10</BR>
<T C="243,227,189" S="20" P="0">BXH Thám Hiểm sẽ thống kê theo Điểm Thám Hiểm, Top 100 người chơi được nhận thưởng. Sau khi hoạt động kết thúc, thưởng sẽ được gửi qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
FIGURE_STATUE_TEXT1 = "Loạn Thế Kiêu Hùng",
ITEM_VN1 = "Huyền Thoại",
CATHOUSE_TEXT1 = {"Nhà Mèo", "Người Yêu Mèo", "Tiệm Pet", "Chọc Mèo", "Nuôi Mèo", "Chọc Mèo miễn phí", "Chọc Mèo %d lần", "Nuôi Mèo %d lần", "Điểm Vui Vẻ", "Chọc Mèo Mỗi Ngày", "Sen Mèo", "Thưởng Sen Mèo", "Thưởng Mèo Ngôi Sao", "Thưởng Cuồng Mèo", "Yêu Mèo Gấp Bội", [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó]], "Vòng Quay Mèo", "Điểm Vui Vẻ đạt đến %d, có thể nhận 1 phần thưởng", "Điểm Chọc Mèo"},
EIGHTYEAR_TEXT1 = {"Sinh Nhật 9 Tuổi", "Làm Bánh", "Ăn Bánh", "Mua Chung Sinh Nhật", "Bắt đầu làm bánh", "Nguyên liệu làm bánh", "Quà Chúc Mừng", "BXH Thưởng Thức", "Thưởng thức miễn phí", "Thưởng thức %d lần", "Đã mua chung: %d lần", "Thông tin mua chung", "Chuyên Gia Mua Chung", "Mua Chung ngay", "Phát đơn Mua Chung", "Mua trực tiếp", "Phát đơn Mua Chung nhiều người", "Ăn Bánh mỗi ngày", "Sinh Nhật 8 Tuổi", "Thưởng Bánh Nhỏ", "Thưởng Bánh Lớn", "Thưởng Bánh Siêu", "Đơn Mua Chung đã phát", "Chi trả ngay", "Tham gia Mua Chung", "Tham gia Mua Chung [%s]", [[<T C="127,98,211" S="18" P="1">Chỉ còn </T><T C="200,34,35" S="18" P="1">1</T><T C="127,98,211" S="18" P="1"> phần ghép</T>]], "Người Mua Chính", "Vé Mua Chung", "Số lần Mua Chung", "Đã đổi", "Còn thiếu 1 phần ghép", "Toàn server Ăn Bánh đủ %d, có thể nhận 1 phần thưởng", {"Sinh Nhật", "Chế tạo", "Thưởng thức", "Sinh Nhật"}, {"Lễ Mừng", "Bánh Kem", "Bánh Kem", "Mua Chung"}, "Số Dao Nĩa","Món hàng này còn Mua Chung chưa xong, tạm không thể phát đơn","Món hàng này hiện đã có nhiều người tham gia Mua Chung, tạm không thể phát đơn"},
EIGHTYEAR_TEXT2 = [[
<T C="255,255,250" S="22" P="1">Hướng dẫn hoạt động Mừng Sinh Nhật</T><BR>10</BR>
<T C="255,255,250" S="20" P="0">1.</T><T C="255,255,250" S="20" P="0">Làm Bánh: </T><BR>10</BR>
<T C="255,255,250" S="20" P="0">Hoàn thành Nhiệm Vụ Ngày có thể nhận Bơ và Bột Mì, nhiệm vụ sẽ tái lập mỗi ngày: </T><BR>10</BR>
<T C="255,255,250" S="20" P="0">Tiêu hao Bơ và Bột Mì để Làm Bánh, có thể nhận được thưởng thường quy</T><BR>10</BR>
<T C="255,255,250" S="20" P="0">Làm xong Bánh Kem có thể đổi phần thưởng hiếm</T><BR>10</BR>
<T C="255,255,250" S="20" P="0">2.</T><T C="255,255,250" S="20" P="0">Ăn Bánh: </T><BR>10</BR>
<T C="255,255,250" S="20" P="0">Dùng Dao Nĩa để Ăn Bánh, mỗi lần tốn 1 bộ Dao Nĩa, nhận một phần thưởng thường quy</T><BR>10</BR>
<T C="255,255,250" S="20" P="0">Tích lũy Ăn Bánh có cơ hội nhận thêm Bánh Kem!</T><BR>10</BR>
<T C="255,255,250" S="20" P="0">BXH Ăn Bánh thống kê theo số Dao Nĩa đã dùng, Top 100 có thể nhận thưởng, khi hoạt động kết thúc sẽ gửi qua thư.</T><BR>10</BR>
<T C="255,255,250" S="20" P="0">3.</T><T C="255,255,250" S="20" P="0">Mua Chung Sinh Nhật: </T><BR>10</BR>
<T C="255,255,250" S="20" P="0">Có thể dùng Vé Mua Chung để Mua Chung vật phẩm đã chọn, cũng có thể mua trực tiếp theo giá gốc.</T><BR>10</BR>
<T C="255,255,250" S="20" P="0">Nếu chọn Mua Chung, cần mời người khác cùng mua mới có thể Mua Chung thành công. Sau khi thành công, vật phẩm sẽ được gửi qua thư.</T><BR>10</BR>
<T C="255,255,250" S="20" P="0">0 giờ mỗi ngày sẽ tái lập Mua Chung, các đơn Mua Chung chưa hoàn thành xem như thất bại, Vé Mua Chung sẽ được gửi lại qua thư cho người chơi.</T><BR>10</BR>
<T C="255,255,250" S="20" P="0">BXH Chuyên Gia Mua Chung thống kê theo số Vé Mua Chung đã mua, Top 100 có thể nhận thưởng hấp dẫn, khi hoạt động kết thúc thưởng sẽ gửi qua thư.</T><BR>10</BR>
<T C="255,255,250" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
MAGIC_STONE_TEXT25 = {"Phần thưởng-Sơ","Thưởng Tinh Anh","Nhiệm vụ tuần%s","Ấn Chiến Lệnh","Mua điểm"},
WORSHIPGOD_TEXT1 ={"Cúng Thần Tài", "Chiêu Tài Tiến Bảo", "Thưởng Thần Tài", "Thần Tài Tặng Quà", "Cúng Thần Tài %d lần", "BXH Thần Tài", "BXH Cúng Thần Tài","Quà Thần Tài (Nhỏ)","Quà Thần Tài (Lớn)", "Thưởng Tu Tiên (Nhỏ)", "Hôm nay Cúng Thần Tài", "Liên tục Cúng Thần Tài", "Cúng Thần Tài mỗi ngày", "BXH Mưa Lì Xì", "Mưa Lì Xì", "Số lần Cúng Thần Tài", "Số lần Phát Lì Xì", "%d lần", [[<T C="127,70,26" S="20" P="1">Chiêu Tài Tiến Bảo </T><T C="229,105,22" S="20" P="1"> %d/%d</T><T C="127,70,26" S="20" P="1"> lần, có thể chọn nhận </T><T C="229,105,22" S="20" P="1">%d/%d</T><T C="127,70,26" S="20" P="1"> phần thưởng Quà Thần Tài.</T>]], "Đã dùng hết số lần", "Lần đăng nhập này ẩn Mưa Lì Xì"},
WORSHIPGOD_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Cúng Thần Tài</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tốn Bánh Tổ Năm để cúng Thần Tài và rút thưởng, mỗi lần phát bóng tốn Bánh Tổ Năm x1, chắc chắn nhận 1 phần thưởng thường, mỗi ngày đăng nhập game miễn phí Cúng Thần 1 lần:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi dùng 5 Bánh Mừng Tuổi sẽ nhận được 1 Nguyên Bảo.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Nguyên Bảo có thể dùng để rút thưởng và tạo mới thưởng trong Chiêu Tài Tiến Bảo.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi Chiêu Tài Tiến Bảo có thể nhận thêm số lần Mưa Lì Xì, dùng để gửi Mưa Lì Xì cho người chơi toàn server, mỗi ngày tối đa nhận Mưa Lì Xì x10;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi Chiêu Tài Tiến Bảo đạt số lần nhất định, có thể chọn 1 phần thưởng quý hiếm;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Cúng Thần có cơ hội nhận thêm thưởng Thần Tài khủng!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Nhiệm vụ Cúng Thần Tài:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Cúng Hôm Nay, Cúng Liên Tục và Cúng Mỗi Ngày. Nhiệm vụ Cúng Hôm Nay mỗi ngày được nhận và hoàn thành 1 lần, sang hôm sau sẽ xóa dữ liệu. Nhiệm vụ Cúng Liên Tục và Cúng Mỗi Ngày trong cả hoạt động chỉ được hoàn thành 1 lần. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa tất cả dữ liệu liên quan.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành BXH Cúng Thần Tài và BXH Mưa Lì Xì.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Cúng Thần Tài được thống kê dựa trên số lần cúng Thần Tài, người chơi Top 100 có thể nhận thưởng hấp dẫn, khi hoạt động kết thúc sẽ được phát qua Thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Mưa Lì Xì được thống kê dựa trên số lần gửi Mưa Lì Xì, người chơi Top 20 có thể nhận thưởng hấp dẫn, khi hoạt động kết thúc sẽ được phát qua Thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
HOLIDAYVILLAGE_TEXT5 = [[<T C="127,70,26" S="20" P="1" SC="105,65,46" SS="0" SE="1">Độ No: </T><T C="163,74,20" S="20" P="1" SC="0,72,3" SS="0" SE="1">%d/%d</T>]],
HOLIDAYVILLAGE_TEXT4 = {"Tinh Linh", "Huấn luyện", "Tỉ lệ thuộc tính", "Độ no", "Đặt Tinh Linh vào", "Chọn Tinh Linh để đặt vào", "%s có thể tăng %d độ no", "Đồng ý thu hồi Tinh Linh Bảo Vệ %s, Thu hồi Tinh Linh Bảo Vệ được hoàn trả toàn bộ nguyên liệu và 80%% nguyên liệu huấn luyện, đồng ý thu hồi?", "Dùng %d lần", "EXP", "Có thể nhận", "Không có Tinh Linh Bảo Vệ, không thể thêm", "Hãy đặt vào đầy ô trước", "Đã đạt cấp tối đa", "Đã đạt tiến hóa tối đa", "Thu hồi thành công", "Mở khóa thành công", "Đặt vào thành công", "Đã đạt cấp tối đa của giai đoạn hiện tại, có thể tiến hóa để tăng đến cấp tối đa", "Huấn luyện thành công", "Tiến hóa thành công", "Nuôi dưỡng thành công", "Ngăn người chơi trộm cây", "Tinh Linh đã tiến hóa đến bậc cao nhất, không thể tiến hóa nữa", "Độ no đã đạt giới hạn", "Không thể vượt giới hạn độ no", "Nhận Tinh Linh", [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">Ý định ăn trộm</T><T C="255,227,116" S="20" P="1" SC="132,66,29" SE="1" SS="4"> %s</T><T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">, đã bị </T><T C="255,227,116" S="20" P="1" SC="132,66,29" SE="1" SS="4">%s</T><T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4"> ngăn chặn</T>]], "Huấn luyện đến khi tăng cấp", "Đói bụng quá, mau ăn cơm thôi!"},
HOLIDAYVILLAGE_TEXT6 = [[
<T C="229,105,22" S="24" P="1">Tinh Linh Bảo Vệ</T><BR></BR>
<T C="229,105,22" S="22">Nuôi Dưỡng</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Nuôi dưỡng Tinh Linh có thể tăng độ no của Tinh Linh, độ no càng cao</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Thuộc tính tăng của Tinh Linh sẽ thay đổi theo độ no, độ no càng cao, thuộc tính càng cao.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Hiệu ứng Tinh Linh cần độ no đạt đến giá trị nhất định mới có hiệu lực</T><BR>20</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Trong tiệm Khu Nghỉ Mát có thể dùng sâu bắt được để đổi Hộp Tinh Linh</T><BR>20</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Hãy chú ý nuôi dưỡng Tinh Linh Bảo Vệ đúng giờ</T><BR>20</BR>
<T C="229,105,22" S="22">Huấn Luyện Tinh Linh</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Huấn luyện Tinh Linh cần tốn Đồ Ăn Vặt Huấn Luyện</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Căn cứ vào phẩm chất Đồ Ăn Vặt sẽ nhận SL EXP khác nhau, khi EXP đầy sẽ tăng cấp Tinh Linh.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Tăng cấp Tinh Linh sẽ tăng thuộc tính của Tinh Linh</T><BR>20</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Trong tiệm Khu Nghỉ Mát có thể dùng sâu bắt được để đổi Thức Ăn Huấn Luyện</T><BR>20</BR>
<T C="229,105,22" S="22">Tiến Hóa Tinh Linh</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Dùng Thuốc Tiến Hóa và Tinh Linh còn dư để tiến hóa Tinh Linh hiện tại</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Tiến hóa thành công sẽ tăng thuộc tính Tinh Linh theo tỉ lệ</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Khi tiến hóa đến bậc nhất định, Tinh Linh sẽ biến thành dạng mạnh hơn và tăng giới hạn cấp</T><BR>10</BR>
<T C="229,105,22" S="22">Thu hồi</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Có thể thu hồi Tinh Linh đang nuôi dưỡng</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Thu hồi sẽ hoàn trả toàn bộ nguyên liệu tiến hóa và 80% Đồ Ăn Vặt Huấn Luyện</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Hộp Tinh Linh tốn khi nuôi dưỡng sẽ không được hoàn trả</T><BR>10</BR>
]],
FIGURE_STATUE_TEXT1 = "Loạn Thế Kiêu Hùng",
CALABASH_TEXT1 ={"Bảy Anh Em Hồ Lô", "Thư Viện Bảy Anh Em Hồ Lô", "Nhiệm vụ Hồ Lô", "Ngôi Nhà Quý Của Ông Nội", "Tưới nước %d lần", "Tưới nước miễn phí", {"Hồ Lô-Đỏ", "Hồ Lô-Cam", "Hồ Lô-Vàng", "Hồ Lô-Lục", "Hồ Lô-Xanh", "Hồ Lô-Lam", "Hồ Lô-Tím"},"Quà Hồ Lô (Nhỏ)","Quà Hồ Lô (Lớn)","Hoàn thành\"Tổ Hợp Hồ Lô Chỉ Định\"Kích hoạt Bảy Anh Em Hồ Lô nhận thưởng", "Tưới nước hôm nay", "Tưới nước lâu dài", "Tưới nước mỗi ngày", "Thẻ Ông Nội", "Thẻ Ông Nội Của Ta", "Độ Trưởng Thành", "Hồ Lô Trưởng Thành", "Chọn tưới Hồ Lô"},
CALABASH_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Bảy Anh Em Hồ Lô</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tốn thùng nước để tưới nước rút thưởng, mỗi lần tưới tốn 1 thùng nước, chắc chắn nhận1 phần thưởng thường, mỗi ngày đăng nhập game miễn phí tưới nước 1 lần:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Sau khi tưới nước, Hồ Lô đã chọn nhận 2 điểm trưởng thành, Hồ Lô sau khi trưởng thành sẽ nhận Hồ Lô tương ứng;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thu thập SL Hồ Lô nhất định, sẽ nhận thưởng trong Thư Viện Bảy Anh Em Hồ Lô, nhận thưởng sẽ tốn Hồ Lô tương ứng, mỗi Thư Viện được nhận 1 lần.;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi dùng 5 Thùng Nước sẽ nhận được 1 Thẻ Ông.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thẻ Ông Nội dùng để đổi thưởng trong Bảo Vật Của Ông Nội.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy tưới nước có cơ hội nhận thêm thưởng Hồ Lô khủng!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Nhiệm vụ Hồ Lô:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Tưới Hôm Nay, Tưới Trường Kỳ và Tưới Mỗi Ngày. Nhiệm vụ Tưới Hôm Nay mỗi ngày được nhận và hoàn thành 1 lần, sang hôm sau sẽ xóa dữ liệu. Nhiệm vụ Tưới Trường Kỳ và Tưới Mỗi Ngày trong cả hoạt động chỉ được hoàn thành 1 lần. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa tất cả dữ liệu liên quan.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH được thống kê theo số Thẻ Ông nhận được trong hoạt động. Top 100 sẽ được nhận thưởng hấp dẫn. Thưởng sẽ được gửi qua thư khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],

SPRINGOUTING_TEXT1 ={"Du Xuân Đạp Thanh", "Hạng Đạp Thanh", "Nhiệm Vụ Du Xuân", "Nô Nức Chơi Xuân", "Bộ hành %d lần", "Bộ hành miễn phí", "Toàn server tích lũy bộ hành %d lần sẽ được nhận thưởng","Thưởng Đạp Thanh (Nhỏ)","Thưởng Đạp Thanh (Lớn)","Thưởng Cuồng Bộ Hành", "Cánh Xuân Tươi", "Hoa Xuân", "Du Xuân Đạp Thanh", "Điểm Bộ Hành", "Số bước đã đi", "Số bước Đạp Thanh", "BXH Đạp Thanh", "Số bước", "Điểm Danh Tri Ân", "Không nhắc nữa", [[<T C="127,70,26" S="22" P="1">Ngày </T><T C="127,70,26" S="40" P="1">%d</T><T C="127,70,26" S="22" P="1"></T>]], "Điểm danh bù", [[<T C="91,65,167" S="20" P="1">Điểm danh bù cần tốn </T>]], [[<T C="91,65,167" S="20" P="1">, tiếp tục không?</T>]]},
SPRINGOUTING_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Du Xuân Đạp Thanh</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng thể lực để rút thưởng Đạp Thanh, mỗi lần Đạp Thanh cần tốn 1 thể lực, chắc chắn nhận được 1 phần thưởng thông thường, đăng nhập mỗi ngày được miễn phí Đạp Thanh 1 lần.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần Đạp Thanh sẽ nhận được 1 bước chân và 2 điểm.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điểm đạt mức yêu cầu sẽ được nhận thưởng, phần thưởng được tái lập mỗi ngày.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Du Xuân đạt số bước yêu cầu sẽ được nhận thưởng.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Toàn server Đạp Thanh đạt số lần yêu cầu, sẽ được nhận thưởng toàn server.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Đạp Thanh có cơ hội nhận thưởng thêm!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Đạp Thanh: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Cánh Xuân Tươi, Hoa Xuân và Du Xuân Đạp Thanh. Nhiệm vụ Cánh Xuân Tươi mỗi ngày được nhận và hoàn thành 1 lần, sang hôm sau sẽ xóa dữ liệu. Nhiệm vụ Hoa Xuân và Du Xuân Đạp Thanh trong cả hoạt động chỉ được hoàn thành 1 lần. Sau khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa tất cả dữ liệu liên quan.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">BXH Đạp Thanh: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH được thống kê theo số bước đã đi trong hoạt động Đạp Thanh. Top 100 sẽ được nhận thưởng hấp dẫn. Thưởng sẽ được gửi qua thư khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
ACT_MAKE_WASTE_PROFITABLE = {"Biến Rác Thành Vàng", "%d ngày sau kết thúc", "%d giờ sau kết thúc", "%d phút sau kết thúc", "Điểm thu hồi", "Xem trước thưởng", "Thu hồi Kim Cương Khóa", "Điểm thu hồi x2", "Thu hồi thường", "Thu hồi Kim Cương Đỏ", "Mỗi đạo cụ %s", "Hạn giờ"},
ACT_MAKE_WASTE_PROFITABLE2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Biến Rác Thành Vàng</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Trong thời gian hoạt động, thu hồi đạo cụ để nhận điểm thu hồi.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Khi thu hồi, có thể chọn dùng Kim Cương Khóa để thu hồi, mỗi đạo cụ 5 Kim Cương Khóa.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Khi điểm thu hồi đầy, sẽ tiến hành rút thưởng, nếu điểm thu hồi Kim Cương Khóa trên 70%, sẽ rút thưởng từ trong kho thưởng Kim Cương Khóa.</T><BR>10</BR>
]],
TEACH_SKIP_TEXT1 = "Bỏ qua Tân Thủ",
TEACH_SKIP_TEXT2 = "Đồng ý bỏ qua Tân Thủ?",
SPRINGOUTING_TEXT3 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn Bán Hoa Tươi</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hoa Tươi lấy bó làm đơn vị bán, mỗi bó 99 đóa.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0">Bán Hoa Tươi có thể nhận thưởng cơ bản.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Lúc bán chọn dùng Thẻ Tinh Linh để tăng, Hoa Tươi sau khi tăng bán ra sẽ nhận thêm thưởng ngẫu nhiên.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Bán Hoa Tươi sẽ giảm số lượng Hoa Tươi trong Thư Viện!</T><BR>10</BR>
]],

ACITVITY_WELCOME_BACK = {"Chào Mừng Trở Lại", "Không nhắc nữa", "Thú Cưỡi Đặc Biệt", "Mạnh Lên Nhanh Chóng", "Tiến độ Check-in hoạt động:", "Hạn", "Nạp %s Kim Cương Lam, x%s", "Nhận thêm %s: +%s", "%s đồng", "Hiện tại đang là Check-in thường, không thể x2, đồng ý Check-in?", "Thứ"},
ACITVITY_WELCOME_BACK2 = [[
<T C="91,65,167" S="20" P="1" >1. Trong Thú Cưỡi Đặc Biệt, Check-in mỗi ngày để nhận Mảnh Thú cưỡi và đạo cụ vật phẩm, Check-in 15 ngày có thể ghép thú cưỡi Hoa Hồng Đỏ</T><BR>10</BR>
<T C="91,65,167" S="20" P="1" >2. Nếu quên Check-in, có thể tốn 200 Kim Cương để điểm danh bù, nhận phần thưởng như nhau</T><BR>10</BR>
<T C="91,65,167" S="20" P="1" >3. Trong Mạnh Lên Nhanh Chóng, điểm danh mỗi ngày để nhận thưởng đạo cụ hoặc thuộc tính tăng vĩnh viễn. Điểm danh sau khi nạp có thể nhận thưởng x2</T><BR>10</BR>
<T C="91,65,167" S="20" P="1" >4. Trong Mạnh Lên Nhanh Chóng có thể mua Quà Tự Chọn Ưu Đãi, mua quà nhận thêm thuộc tính tăng vĩnh viễn</T><BR>10</BR>
<T C="91,65,167" S="20" P="1" >5. Trong Mạnh Lên Nhanh Chóng, Check-in điểm danh hoặc mua quà có thể nhận tiến độ Check-in, khi tiến độ Check-in đạt yêu cầu, có thể nhận thưởng Rương</T><BR>10</BR>
]],

STORE_TEXT1 = {"Tiệm Fan Cứng", "Tiệm VIP", "Tiệm Hoa Tươi", "Tiệm"},
OTHER_UI_TEXT = {"", "Tải dữ liệu", "Bắt đầu tải", "Sau Lv14 cần tải đầy đủ dữ liệu mới có thể tiếp tục chơi\nLưu ý: Một số tính năng & sự kiện cần tải tài nguyên đầy đủ mới có thể sử dụng", "Để sau", "Tải trên nền", "(Nhắc: Tập tin khá lớn, nên dùng WIFI để tải)", "Dữ liệu cần tải: ", "Có dữ liệu cần tải"},
HOLIDAY_VILLAGE_TIPS1 = "Hoa Tươi lấy bó làm đơn vị bán, mỗi bó 99 đóa",
LIMIT_TEXT1 = "Mua giới hạn",
RUNE_OPTIMIZE6 = {"Kim Cương Khóa Cộng Hưởng", "Có muón tốn %d Kim Cương Khóa để Công Hưởng Bùa, Công Hưởng Bùa tăng 2.5%% tất cả thuộc tính nhân vật, duy trì 24 giờ."},
COMMUNITYTASK_TEXT1 = {"Hôm nay","Ngày mai","Hôm sau","Ngày 3","Ngày 4","Ngày 5","Ngày 6","Ngày 7"},
BEATBALLOON_TEXT1 =  {"Bắn Bong Bóng", "BXH Ngắn Hạn", "Mục tiêu Bắn Bong Bóng", "Nhiệm vụ đặc biệt", "Đánh %d lần", "Đánh miễn phí", "Cự ly kích hoạt“Bong Bóng Bất Ngờ”còn %d cái, xung phong", "Thưởng Bắn Bong Bóng Nhỏ", "Thưởng Bắn Bong Bóng Lớn", "Bá Chủ Bắn Bong Bóng", "Bắn Bong Bóng mỗi ngày", "Bắn Bong Bóng Điên Cuồng", "Bắn Bong Bóng Mỗi Ngày", "Điểm", "BXH Tổng", "Nộ Khí Sơ", "Nộ Khí Cao", "BXH tuần này kết thúc vào %s 23 giờ 59 phút", "Bong Bóng Bất Ngờ"},
BEATBALLOON_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Bắn Bong Bóng</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tốn Phi Tiêu Nhỏ để rút thưởng Bắn Bong Bóng, Nộ Khí Sơ mỗi lần tốn 1 Phi Tiêu Nhỏ, sẽ nhận 1 phần thưởng thường. Nộ Khí Cao mỗi lần tốn 5 Phi Tiêu Nhỏ, chắc chắn nhận 1 phần thưởng cao. Mỗi ngày đăng nhập nhận 1 lần Bắn Bong Bóng miễn phí:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi tốn 1 Phi Tiêu Nhỏ sẽ nhận được 1 Điểm</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi tốn 30 Phi Tiêu sẽ tạo ra 1 Bong Bóng Bất Ngờ, phá vỡ Bong Bóng Bất Ngờ sẽ nhận nhiều thưởng (Nộ Khí Sơ x4. Nộ Khí Cao x10);</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Bắn Bong Bóng có cơ hội nhận thêm thưởng Bong Bóng Lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Mục tiêu Bắn Bong Bóng: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Bắn Bóng Hàng Ngày, Bắn Bóng Không Ngừng và Hoạt Động Bắn Bóng. Nhiệm vụ Bắn Bóng Hàng Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Bắn Bóng Không Ngừng và Hoạt Động Bắn Bóng trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">BXH Bong Bóng: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH chia làm BXH Ngắn Hạn và BXH Tổng Sắp. BXH Ngắn Hạn sẽ tổng kết từng kỳ, BXH Tổng Sắp sẽ tổng kết khi hoạt động kết thúc.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Ngắn Hạn và BXH Tổng dựa vào điểm nhận để thống kê,top 100 người chơi có thể nhận thưởng hấp dẫn, hoạt động kết thúc gửi qua Thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],


DAZZLERANK_TEXT1 =  {"BXH Vinh Quang", "BXH Cống Hiến", "Điểm Vinh Quang", "Điểm Cống Hiến", "Vinh Quang Cá Nhân", "Cống Hiến Cá Nhân", "Vinh Quang Các Kỳ", "Cống Hiến Các Kỳ", "BXH Các Kỳ", "Hôm nay đã bấm Like cho người này rồi", "Bồn Hoa", "Không còn dư Bồn Hoa nào nữa!"},
DAZZLERANK_TEXT2 = [[
<T C="255,236,193" S="22" P="1">Hướng dẫn hoạt động BXH Vinh Quang</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">1.</T><T C="255,255,255" S="20" P="0">BXH Vinh Quang: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH Vinh Quang sẽ thống kê theo Điểm Vinh Quang, Top 100 người chơi được nhận thưởng. Sau khi hoạt động kết thúc, thưởng sẽ được gửi qua thư.</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Nạp đủ 60 Kim Cương sẽ nhận được 1 Điểm Vinh Quang (Chỉ tính trên số Kim Cương nạp thực tế, không tính Thẻ Tuần, Thẻ Tháng, Thẻ Phúc Lợi, không tính hoàn trả nạp)</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">2.</T><T C="255,255,255" S="20" P="0">BXH Cống Hiến:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH Cống Hiến sẽ thống kê theo Điểm Cống Hiến, Top 100 người chơi được nhận thưởng. Sau khi hoạt động kết thúc, thưởng sẽ được gửi qua thư.</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Dùng đủ 100 Kim Cương Lam sẽ nhận được 1 Điểm (Không tính Kim Cương Đỏ)</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">2.</T><T C="255,255,255" S="20" P="0">BXH Các Kỳ: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Ghi nhận thành tích của các nhà vô địch BXH Vinh Quang và BXH Cống Hiến các kỳ, người chơi có thể Xem và Thích.</T><BR>10</BR>
]],
NEW_ACTIVITY_TEXT_11 = "Lưu ý :Mỗi ngày mua 1 Quà bất kỳ, có thể nhận rương thưởng số người hoàn thành",
SUPER_SELL_ACTIVITY = {"Mua Siêu Giá Trị","Mua Ngay","Trong hoạt động mỗi ngày mỗi ngày chỉ được mua 1 lần!"},
TEAMCONSUME_TEXT1 =  {"Bạn Bè Mua Chung", "Đội", "Quà Đội Trưởng", "BXH Đội", "BXH Đội Trưởng", "Đội tiêu tốn", "Hạng Đội", "Thành viên", "Thành Đội Trưởng", "Đội Trưởng trong ngày dùng %d Kim Cương có thể nhận Quà Đội Trưởng", "Nhắc: Sau khi đồng ý sẽ không thể thay đổi", "Trong hoạt động, có thể mời tối đa 2 bạn bè làm đồng đội, sau khi lập đội sẽ không thể giải trừ quan hệ!", "Đội Trưởng", "Thành viên", "Thông tin", "Tổng tiêu hao", "Tiêu tốn: ", {"Cùng mua sắm nhé?", "Mua sắm thật vui.", "Cùng nhau mua sắm, giành ngay hạng nhất.", "Này, hẹn nha đi mua sắm nhé?"}, "Chỉ Đội Trưởng mới được mời bạn!", "Tên đội tối đa 10 ký tự", "Bạn đã là Đội Trưởng, hãy mời đồng đội nhé", "Nhập tên đội", "Đội GunPow", "Tên đội không được có khoảng trắng", "Tên đội không được quá %d ký tự"},
TEAMCONSUME_TEXT2 = [[
<T C="255,236,193" S="22" P="1">Hướng dẫn hoạt động Bạn Bè Mua Chung</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">1.</T><T C="255,255,255" S="20" P="0">Bạn Bè Mua Chung: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Người chơi có thể tạo đội và mời bạn cùng tham gia hoạt động.</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Sau khi tổ đội, trong đội có người tiêu tốn Kim Cương đều tăng tiến độ hoàn thành nhiệm vụ;</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Đội Trưởng tiêu phí đạt mức sẽ nhận Quà Đội Trưởng;</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">2.</T><T C="255,255,255" S="20" P="0">BXH: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH chia làm BXH Đội Nhóm và BXH Đội Trưởng.</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH Đội dựa vào tiêu phí tổng đội để xếp hạng, top 100 người chơi có thể nhận thưởng hấp dẫn</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH Đội Trưởng dựa vào số tiêu phí Đội Trưởng để xếp hạng , Top 10 người chơi có thể nhận thưởng hấp dẫn</T><BR>10</BR>
]],
SEAFARROAD_TEXT1 =  {"Thần Hàng Hải", "BXH Hàng Hải", "Đường Hàng Hải", "Hàng Hải Toàn Server", "Hàng Hải %d lần", "Hàng Hải Miễn Phí", "Người chơi Toàn Server tích lũy Hàng Hải %d lần, có thể nhận 1 phần thưởng","Thưởng Hàng Hải Nhỏ","Thưởng Hàng Hải Lớn","Thưởng Thần Biển Lớn", "Hàng Hải Mỗi Ngày", "Đường Thành Thần", "Hàng Hải Mỗi Ngày", "Điểm Hàng Hải", "%d lần Chiếm Đầu", "Hải Lý", "BXH Thần Biển", "Cấp sao", "%d Sao", "Thần Biển", "Người đầu tiên chiếm được toàn server, mỗi lượt chỉ 1 người", "Diệt %d lần", "HP Hải Tặc:", "Bắt đầu", "Đích Đến", "Kế Thừa", "Đã di chuyển %d Hải Lý, tiếp tục di chuyển %d Hải Lý sẽ gặp Hải Tặc (Điểm số gặp Hải Tặc 0h mỗi ngày tạo mới)", "Khi đến một Lãnh Địa có thể nhận 1", "Ánh Sáng Thần Biển", "Ánh Sáng Thần Biển nhận sẽ tự động mở hình, nhận 6 Ánh Sáng Thần Biển có thể Kế Thừa Thần Biển, nhận Dấu Ấn Thần Biển, mỗi kế thừa lại 1 lần sẽ tăng 1 sao của Dấu Ấn Thần Biển", "Lần Đầu Chiếm", "Quyền chiếm đã bị %s đoạt lấy và nhận", "Diệt Hải Tặc", "Chiếm Khu Vực", "Ánh Sáng Thần Biển"},
SEAFARROAD_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Vị Thần Hàng Hải</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tốn Dầu Hỏa để rút thưởng Hàng Hải, rút thưởng Hàng Hải mỗi lần tốn 1 thùng Dầu Hỏa, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập nhận Hàng Hải Miễn Phí 1 lần:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi Hàng Hải 100 lần sẽ kích hoạt Hải Tặc đột kích. Khi Hải Tặc đột kích, có thể tốn Dầu Hỏa để rút thưởng Tấn Công, mỗi lần Tấn Công Hải Tặc tốn 1 thùng Dầu Hỏa, chắc chắn nhận 3 phần thưởng thường. Sau khi diệt Hải Tặc thành công sẽ nhận 5 phần thưởng thêm:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần tốn 1 thùng Dầu Hỏa có thể nhận 2 Điểm và di chuyển 1 Hải Lý;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi di chuyển đạt Hải Lý nhất định, sẽ chiếm Lãnh Địa, mỗi lần chiếm Lãnh Địa sẽ nhận thêm 4 phần thưởng và 1 Ánh Sáng Thần Biển, chiếm Lãnh Địa lần đầu Toàn Server sẽ nhận thêm 5 phần thưởng Chiếm Đầu, mỗi thu thập 6 Ánh Sáng Thần Biển sẽ Kế Thừa nhận huy chương Dấu Ấn Thần Biển;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi ngày điểm đạt nhất định sẽ nhận Rương Điểm;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Hàng Hải Toàn Server đạt số lần nhất định, có thể nhận 1 phần Thưởng Hàng Hải Toàn Server;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Hàng Hải có tỉ lệ nhận thêm Thưởng Hàng Hải Lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="1">Tham gia Thần Hàng Hải có tỉ lệ nhận Quà Trang Bị Ảo Hóa Sương Phong Tuyết Liên!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Đường Hàng Hải:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Hàng Hải Hàng Ngày, Con Đường Thần Biển và Hoạt Động Hàng Hải. Nhiệm vụ Hàng Hải Hàng Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Con Đường Thần Biển và Hoạt Động Hàng Hải trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">BXH Hàng Hải: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH chia làm BXH Hàng Hải và BXH Thần Biển.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Hàng Hải dựa vào số Hải Lý đã di chuyển để thống kê, top 100 người chơi có thể nhận thưởng hấp dẫn, hoạt động kết thúc gửi qua Thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Thần Biển dựa vào số lượng Ánh Sáng Thần Biển nhận để thống kêSố lượng, Top 20 người chơi có thể nhận thưởng hấp dẫn, hoạt động kết thúc gửi qua Thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
CLIMBTREE_TEXT1 =  {"Đua Leo Dây", "BXH Leo Dây", "Nhiệm vụ Leo Dây", "Sứ Giả Hòa Bình", "Leo Dây %d lần", "Leo Dây Miễn Phí", "Điểm Giải Cứu","Thưởng Bạc","Thưởng Vàng","Cao Thủ Leo Dây", "Leo Dây Mỗi Ngày", "Tích lũy Leo Dây", "Đại Sứ Hòa Bình", "Chiều Cao Leo Dây (m)", "Giải Cứu Chim", "Thương Leo Dây %d/%dm", "Chim tầng này chưa bị giải cứu, mau giúp đỡ nó!", "Điểm Giải Cứu", "Chiều Cao Leo Dây+%dm", "Tôi lại có thể bay tự do trên bầu trời rồi!", "Giải Cứu Chim"},
CLIMBTREE_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Đua Leo Dây</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tốn Giày Vàng để rút thưởng Leo Dây, mỗi lần rút thưởng Leo Dây tốn 1 Giày Vàng, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập nhận Leo Dây Miễn Phí 1 lần:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi Leo Dây 30m, sẽ nhận thưởng Chiều Cao Leo Dây, chắc chắn nhận 3 phần thưởng. Mỗi Leo Dây 50m, đến số tầng Chim bị nhốt, cần Giải Cứu Chim mới có thể tiếp tục Leo Dây, Giải Cứu Chim không cần tốn Giày Vàng, giải cứu thành công chắc chắn nhận 3 phần thưởng thường, </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần tốn 1 Giày Vàng có thể Leo Dây 1 lần, Leo Dây 1 lần có chiều cao là 1m, mỗi giải cứu 1 con Chim nhận Điểm Giải Cứu x1;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điểm Giải Cứu đạt số nhất định có thể nhận Thưởng Sứ Giả Hòa Bình;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Leo Dây: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Nhiệm Vụ Ngày, Tích lũy Leo Dây. Nhiệm Vụ Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Tích lũy Leo Dây trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Cao Thủ Leo Dây:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Cao Thủ Leo Dây dựa vào số m Leo Dây để thống kê, top 100 người chơi có thể nhận thưởng hấp dẫn, hoạt động kết thúc gửi qua Thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
SUMMERSURF_TEXT1 =  {"Lướt Sóng Ngày Hè", "Cưỡi Gió Vượt Sóng", "Dũng Cảm Xông Lên", "Dũng Sĩ Vượt Sóng", "Lướt Sóng %d lần", "Lướt Sóng Miễn Phí", "Thưởng Hào Hoa Lướt Sóng","Thưởng Ngài Lướt Sóng Lớn","Thưởng Ngài Lướt Sóng Nhỏ","Kẻ Cuồng Cờ Ca Rô", "Sóng Dữ Cuồng Loạn", "Biển Cả Cuộn Trào", "Mở Vỏ Sò", "Tốn [Thẻ Cho Mượn]", "Tốn Ngọc Trai", "Hiệp thắng hiện tại", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó]], "Đạo cụ ẩn hiệp này", "Phúc Lợi Mỗi Ngày", "Cờ Ca Rô Bãi Biển", "Đăng nhập mỗi ngày được nhận!", "Hãy chọn Vỏ Sò muốn mở", [[<T C="127,70,26" S="20" P="0">Có muốn tốn </T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="0">X%d</T><T C="127,70,26" S="20" P="0"> đổi đạo cụ ẩn?</T>]], "Đã đạt giới hạn, không thể chọn nữa", {"Thắng rồi, thật nhẹ nhàng!", "Chiến thắng thì ra dễ như thế!", "Chính là lợi hại như thế, ta lật bài đây!"}},
SUMMERSURF_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Lướt Sóng Ngày Hè</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tốn Thẻ Cho Mượn để mượn Ván Lướt Sóng để rút thưởng Lướt Sóng, Ván Lướt Sóng Thường rút thưởng 1 lần tốn 1 Thẻ Cho Mượn, chắc chắn nhận 1 phần thưởng thường. Ván Lướt Sóng Hào Hoa rút thưởng mỗi lần tốn 5 Thẻ Cho Mượn, chắc chắn nhận 1 phần thưởng cao, mỗi ngày đăng nhập nhận Lướt Sóng Miễn Phí 1 lần:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Lướt Sóng có tỉ lệ nhận Thưởng Lướt Sóng Lớn! Thưởng Lướt Sóng Lớn có thể chọn trước trong xem trước thưởng, khi nhận thưởng của Kho Thưởng này, chắc chắn nhận 1 phần thưởng trong chọn trước, một số thưởng chộn trước bị hạn chế số lần</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Cách chơi Cờ Ca Rô Bãi Biển:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Bằng cách lật Vỏ Sò, tìm phe thắng Cờ Ca Rô, tìm được hiệp thắng +1, số hiệp thắng đạt số lượng nhất định sẽ mở thưởng ngày, thưởng này ngày sau tái lập, </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Lật Vỏ Sò cần tốn 1 Ngọc Trai, mỗi lần lật Vỏ Sò có tỉ lệ nhận đạo cụ ẩn, nếu tìm được phe thắng Cờ Ca Rô sớm thì sẽ tốn 1 Ngọc Trai đổi đạo cụ ẩn</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Dũng Cảm Xông Lên:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Sóng Dữ Vỗ Bờ, Biển Rộng Bao La. Nhiệm vụ Sóng Dữ Vỗ Bờ mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Biển Rộng Bao La trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Cưỡi Gió Vượt Sóng: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH chia làm Dũng Sĩ Vượt Sóng và Vua Cờ Ca Rô.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dũng Sĩ Vượt Sóng dựa vào số [Thẻ Cho Mượn] tốn để thống kê, top 100 người chơi có thể nhận thưởng hấp dẫn, hoạt động kết thúc gửi qua Thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Kẻ Cuồng Cờ Ca Rô dựa vào số lượng Ngọc Trai tốn để thống kê, top 100 người chơi có thể nhận thưởng hấp dẫn, hoạt động kết thúc gửi qua Thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],

PLANETSEARCH_TEXT1 =  {"Thám Hiểm Hành Tinh", "Kế Hoạch Hành Tinh", "BXH Thám Hiểm", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó]], "Thám Hiểm %d lần", "Thám Hiểm Miễn Phí", "Thưởng Hành Tinh (Nhỏ)", "Thưởng Hành Tinh (Lớn)", "Thưởng Hành Tinh (Bí Bảo)", "Chung Tay Thám Hiểm", "Thám Hiểm Hàng Ngày", "Thám Hiểm Hành Tinh", "Người chơi toàn server tích lũy Thám Hiểm %d lần, có thể nhận 1 phần thưởng", "Điểm Thám Hiểm", {"Mặt Trời", "Sao Thủy", "Sao Kim", "Trái Đất", "Sao Hỏa", "Sao Mộc", "Sao Thổ", "Sao Thiên Vương", "Sao Hải Vương"}, "Hành Tinh Số 1", "Hành Tinh Số 2", "Trong Kho Thưởng %s, số lượng %s x%d đã đạt tối đa, không thể chọn nữa"},
PLANETSEARCH_TEXT2 = [[
<T C="243,227,189" S="22" P="1">行星探索活动说明<T C="243,227,189" S="22" P="1">Hướng dẫn hoạt động Thám Hiểm Hành Tinh</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">1.</T><T C="243,227,189" S="20" P="0">操作说明：<T C="243,227,189" S="20" P="0">1. </T><T C="243,227,189" S="20" P="0">Hướng dẫn: </T><BR>10</BR>
<T C="243,227,189" S="20" P="0">可消耗陨石结晶进行探索抽奖，行星一号探索抽奖每次消耗1个陨石结晶,必定获得1份常规奖励并增加2点探索值,每天登录游戏可免费探索一次。行星二号探索抽奖每次消耗5个陨石结晶,必定获得1份高级奖励并增加10点探索值：<T C="243,227,189" S="20" P="0">Có thể dùng Kết Tinh Thiên Thạch để rút thưởng Thám Hiểm, Hành Tinh Số 1 mỗi lần rút thưởng cần tốn 1 Kết Tinh Thiên Thạch, chắc chắn nhận được 1 phần thưởng thường và tăng 2 Điểm Thám Hiểm. Đăng nhập mỗi ngày có thể Thám Hiểm Miễn Phí 1 lần. Hành Tinh Số 2 mỗi lần rút thưởng cần tốn 5 Kết Tinh Thiên Thạch, chắc chắn nhận được 1 phần thưởng cao cấp và tăng 10 Điểm Thám Hiểm.</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">行星一号奖池概率获得绿色玄武宠物装备，行星二号奖池概率获得蓝、紫色玄武宠物装备;<T C="243,227,189" S="20" P="0">Kho Thưởng Hành Tinh Số 1 có xác suất nhận được Trang Bị Pet Huyền Vũ Lục, Kho Thưởng Hành Tinh Số 2 có xác suất nhận Trang Bị Pet Huyền Vũ Lam, Tím.</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">全服探索达到一定次数，即可获得一份全服探索奖励;<T C="243,227,189" S="20" P="0">Toàn server Thám Hiểm đủ số lần yêu cầu, có thể nhận 1 phần thưởng Thám Hiểm toàn server</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">累计探索有几率获得额外探索大奖哦！<T C="243,227,189" S="20" P="0">Tích lũy Thám Hiểm có xác suất nhận thêm Thưởng Thám Hiểm (Lớn)!</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">2.</T><T C="243,227,189" S="20" P="0">行星计划：<T C="243,227,189" S="20" P="0">2. </T><T C="243,227,189" S="20" P="0">Kế Hoạch Hành Tinh: </T><BR>10</BR>
<T C="243,227,189" S="20" P="0">分为每日探索、行星探索，每日探索任务每天可完成领取1次，数据隔日清空；行星探索活动期间只能完成1次，完成任务请及时领取奖励，活动结束全部清空；<T C="243,227,189" S="20" P="0">Chia làm Thám Hiểm Hàng Ngày, Thám Hiểm Hành Tinh. Nhiệm vụ Thám Hiểm Hàng Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Thám Hiểm Hành Tinh trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="243,227,189" S="20" P="0">4.</T><T C="243,227,189" S="20" P="0">探索榜：<T C="243,227,189" S="20" P="0">4. </T><T C="243,227,189" S="20" P="0">BXH Thám Hiểm: </T><BR>10</BR>
<T C="243,227,189" S="20" P="0">探索榜根据探索值进行统计，前100玩家可获得丰厚的奖励，活动结束通过邮件发放。<T C="243,227,189" S="20" P="0">BXH Thám Hiểm sẽ thống kê theo Điểm Thám Hiểm, người chơi Top 100 có thể nhận thưởng hấp dẫn, khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
SEVENYEAR_TEXT1 =  {"Điểm Danh Sinh Nhật", [[<T C="255,255,255" S="22" P="1">Đăng nhập </T><T C="255,255,255" S="22" P="1">%d </T><T C="255,255,255" S="22" P="1">ngày</T>]], [[<T C="91,65,167" S="20" P="1">Điểm danh bù cần tốn </T>]], [[<T C="91,65,167" S="20" P="1">, tiếp tục không?</T>]], "Điểm danh"},
SEVENYEAR_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Điểm Danh Sinh Nhật</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn điểm danh: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trong hoạt động, đăng nhập sẽ kích hoạt tính năng điểm danh mỗi ngày. Khi online có thể nhận thưởng điểm danh của ngày hôm đó, tổng cộng 7 ngày.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Nếu bị lỡ mất số ngày không điểm danh, có thể dùng Kim Cương để điểm danh bù. Sau khi hoạt động kết thúc, nếu chưa nhận thưởng sẽ bị xóa hết, không phát thưởng bù, vì vậy hãy nhớ nhận thưởng kịp thời!</T><BR>10</BR>
]],
ZONGZI_TEXT1 =  {"Khác Biệt\nKhẩu Vị", [[<T C="0,108,3" S="20" P="1">Ngày thứ </T><T C="0,108,3" S="20" P="1">%d </T><T C="0,108,3" S="20" P="1"></T>]], "Quà Chiến Thắng", "Quà Thất Bại", "Bánh Mặn", "Bánh Ngọt", "Đồ Tiếp Viện Siêu Cấp", "Cổ Vũ %d lần", "Đồ Tiếp Viện Mỗi Ngày", "%s VND sẽ mở khóa, mỗi ngày có thể nhận đạo cụ chỉ định", "Sau khi bắt đầu lượt này không thể đổi phe!", "Ngày cuối hoạt động không thể mua nữa", "Phe chiến thắng có thể nhận", "Phe thất bại có thể nhận", "Đăng nhập mỗi ngày có thể nhận", "Hãy chọn phe của bạn", "Đồng ý chọn gia nhập phe %s? Một khi đồng ý, sau khi bắt đầu lượt này không thể đổi phe!", "Nhận bù", [[<T C="91,65,167" S="20" P="1">Nhận bù cần tốn</T>]], [[<T C="91,65,167" S="20" P="1">, có muốn tiếp tục?</T>]], "Điểm Đối Kháng", "Tiến độ Cổ Vũ:", "Lượt Cổ Vũ này kết thúc, phe thắng là: %s", "Lượt Cổ Vũ này kết thúc, hòa", "Quà Chiến Thắng, gửi thư", "Quà Thất Bại, gửi thư", "Quà Hòa, gửi thư", "Hòa có thể nhận","BXH Cổ Vũ","Số Lần cổ vũ"},
ZONGZI_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Khác Biệt Khẩu Vị</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tốn Quà Kẹo Ngọt để rút thưởng Cổ Vũ, rút thưởng Cổ Vũ mỗi lần tốn 1 Quà Kẹo Ngọt, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập nhận Cổ Vũ Miễn Phí 1 lần:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trước khi Cổ Vũ cần chọn phe, sau khi gia nhập trước khi lượt Cổ Vũ này kết thúc không thể thay đổi:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tiến độ Cổ Vũ mỗi lượt đầy 100% tự động tổng kết lượt Cổ Vũ này, người chơi phe chiến thắng nhận Quà Chiến Thắng, phe thất bại nhận Quà Thất Bại. Hòa thì người chơi tham gia Cổ Vũ nhận Quà Hòa;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Đồ Tiếp Viện Siêu Cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Đăng nhập mỗi ngày có thể nhận 1 Đồ Tiếp Viện Mỗi Ngày;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tốn 20K VND mở khóa tư cách Đồ Tiếp Viện 7 Ngày, sau khi mở khóa mỗi ngày có thể nhận 1 phần thưởng.,;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Sau khi nhận xong thưởng của 7 ngày, có thể mở khóa lại tư cách Đồ Tiếp Viện 7 Ngày;</T><BR>10</BR>
]],
SPECIFICSALES_TEXT1 = {"Hoạt Động Đặc Biệt","Siêu Ưu Đãi", "Pet", "Quy Tắc Hoạt Động", "Hoàn thành nhiệm vụ nạp và tiêu phí có thể chọn 1 phần thưởng để nhận. Sau khi nhận thưởng, tiến độ nhiệm vụ sẽ bị khấu trừ.\nTiến độ nạp và tiêu phí sẽ được tái lập lúc 0 giờ mỗi ngày, sau đó sẽ phát thưởng theo mức tiến độ còn lại", [[<T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">Hôm nay đã nạp </T><T C="255,227,117" S="18" P="1" SC="132,66,29" SS="4" SE="1">(%s)</T><I Z="0.4" P="1">shopitems/diamond.png</I><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1"> và tiêu phí </T><T C="255,227,117" S="18" P="1" SC="132,66,29" SS="4" SE="1">(%s)</T><I Z="0.4" P="1">shopitems/diamond.png</I>]],"Đã nhận phần thưởng này rồi, vẫn muốn nhận lại?"},

FACTION_TEXT1 = {"Tông Môn","Tông Môn của tôi","Tông Môn Sư Phụ","Cấp Tông Môn","Thuộc tính Tông Môn","buff Tông Môn","Tổ đội thành viên Tông Môn bất kỳ có thể nhận","Bậc của tôi","Cống Hiến Tông Môn","Chưa bái sư, chưa có thuộc tính Tông Môn","Nhiệm Vụ Tông Môn của tôi","Nhiệm Vụ Tông Môn Sư Phụ","Nhiệm vụ đã công bố","Đếm ngược kết thúc","Đếm ngược có hiệu lực","Sư phụ của bạn chưa công bố nhiệm vụ","Nhiệm vụ khóa đã quá hạn","Nhiệm vụ đã công bố","Nhiệm vụ qua ngày đã chọn quá hạn","EXP Tông Môn","Bậc đã đạt giới hạn cấp Tông Môn hiện tại, hãy đợi sư phụ tăng cấp Tông Môn"},

AGE_APPROPRIATE_TIPS_1 = [[Hướng dẫn: 
(1) Trò chơi này là một trò chơi bắn súng đấu PvP với lối chơi phức tạp, dành cho người dùng từ đủ 18 tuổi trở lên. Khuyến nghị người chưa thành niên chơi game dưới sự giám sát của phụ huynh.
(2) Trò chơi này thuộc thể loại hư cấu, có bối cảnh và thế giới tưởng tượng, không dựa trên các sự kiện lịch sử hay thực tế, không gây nhầm lẫn với đời sống thực. Lối chơi chính của trò chơi là nuôi dưỡng nhân vật, có chế độ đấu đội, cần đầu tư khá nhiều thời gian và tinh lực.Trong game có hệ thống giao tiếp xã hội mở với người lạ, bao gồm:
chat chữ, vioce, hình ảnh, v.v...Nhưng hệ thống xã hội sẽ được quản lý theo các quy định pháp luật hiện hành.
(3) Trò chơi có hệ thống xác minh danh tính người dùng thực tế. Người dùng được xác minh là chưa thành niên sẽ bị quản lý như sau:
Một số tính năng và đạo cụ trong game cần trả phí. Người dùng chưa đủ 8 tuổi không thể trả phí; người dùng từ 8-16 tuổi, số tiền mỗi lần nạp không được vượt quá 50 VND, số tiền tích lũy nạp mỗi tháng không được vượt quá 200 VND; người dùng vị thành niên 16 tuổi trở lên, số tiền mỗi lần nạp không được vượt quá 100 VND, số tiền tích lũy nạp mỗi tháng không được vượt quá 400 VND. Tài khoản chưa định danh không được vào game trải nghiệm, người chơi vị thành niên chỉ được chơi game vào 20:00 - 21:00 các ngày thứ 6, 7, chủ nhật và ngày lễ quốc gia.
(4) Game này lấy chủ đề là bắn đạn theo lượt, hỗ trợ người chơi nuôi dưỡng khả năng quan sát suy nghĩ và kết hợp giữa mắt-tay, mang đến cho người chơi trải nghiệm niềm vui và sự hứng thú tích cực, tăng sự tự tin cho người chơi. Trong game có tính năng dạng tổ đội, người chơi phải phối hợp với nhau, giúp đỡ nhau để hoàn thành thi đấu, có lợi cho việc người chơi nuôi dưỡng khả năng hợp tác trong đội.
(5) Trong game có hệ thống xã giao trở thành bạn đời, thích hợp cho người dùng 18 tuổi trở lên.
]],

AUCTION_HOUSE_TEXT37 = {"Giám Định","Điểm giám định","Giám định %d lần","Thưởng Giám Định","Hãy chọn vật phẩm","Không thể thay đổi vật phẩm đã chọn","Lượt này chưa giám định, không thể tổng kết phần thưởng","Chưa đạt điều kiện","Đã đạt giới hạn","Chọn phần thưởng","Hãy chọn phần thưởng giám định lần này!","Hãy chọn vật phẩm cần giám định","Giám định lượt này vẫn chưa kết thúc, đồng ý tiến hành tổng kết?","Bội số hiện tại: %d lần","Chi tiết tổng kết","Đã đạt số lượng giới hạn của hiệp","Đã đạt số lượng giới hạn của cá nhân","Đã đạt số lần giới hạn","Đã dùng hết số lần giám định, hãy tổng kết","Hãy chọn phần thưởng tự chọn","Bảng Giám Định","Điểm giám định của tôi","Chỉ hiện người chơi Top 50","Giám định thành công"},
AUCTION_HOUSE_TEXT38 = [[<T C="255,255,255" S="18" P="1">Mỗi lượt giám định tối đa </T><T C="255,236,193" S="18" P="1">%s lần, sau </T><BR>6</BR><T C="255,236,193" S="18" P="1">%s </T><T C="255,255,255" S="18" P="1"> lần sẽ tiến hành tổng kết</T>]],
AUCTION_HOUSE_TEXT39 = [[<T C="127,70,26" S="18" P="1">Giám định </T><T C="229,105,22" S="18" P="1">%d/%d</T><T C="127,70,26" S="18" P="1"> lần, được tự chọn thưởng giám định </T><T C="229,105,22" S="18" P="1">%d/%d</T><T C="127,70,26" S="18" P="1"> lần.</T>]],
AUCTION_HOUSE_TEXT40 = [[
<T C="255,255,255" S="22" P="1">Hướng dẫn Giám Định</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">1.</T><T C="255,255,255" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Sau khi chọn đạo cụ cần giám định được tốn Xu Nghỉ Mát để giám định, mỗi lần giám định nhận 10 điểm giám định, mỗi lượt giám định tối đa 5 lần.:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Sau khi giám định được tiến hành tổng kết, khi tổng kết sẽ dựa vào bội số tương ứng của điểm giám định để phát thưởng:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Khi bội số giám định đạt 5 lần sẽ tự động tổng kết đạo cụ hiện tại và xóa điểm giám định;</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Giám định đạt số lần nhất định được chọn nhận thưởng lớn;</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">2.</T><T C="255,255,255" S="20" P="0">BXH Giám Định: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Bảng Giám Định thống kê dựa vào điểm giám định, Top 50 người chơi được nhận thưởng hấp dẫn, hoạt động kết thúc sẽ được phát qua thư.</T><BR>10</BR>

]],
AUCTION_HOUSE_TEXT41 = [[<T C="255,255,255" S="20" P="1">Thưởng tổng kết lượt này </T><T C="93,222,254" S="22" P="1">Bội số là %d lần </T><T C="255,255,255" S="20" P="1">, nhận được phần thưởng sau:</T>]],

 HOLIDAYVILLAGE_TEXT7 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn Cây Thần Tinh Linh</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Cây Thần theo thời gian sẽ tự động trưởng thành, sau khi đếm ngược kết thúc sẽ tăng cấp;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Cây Thần tăng cấp sẽ cung cấp tăng thuộc tính, vị trí Quả Thần và sinh trưởng Quả Thần tăng;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Sau khi mở vị trí Quả Thần, được tự chọn đạo cụ tiến hành nuôi dưỡng, sau khi kết thúc nuôi dưỡng được nhận đạo cụ tương ứng, đạo cụ khác nhau thì thời gian bồi dưỡng khác nhau;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Người chơi có thể dùng Kết Tinh Thời Gian để tăng tốc sinh trưởng của Cây Thần hoặc bồi dưỡng cây trái</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Kéo Kết Tinh Thời Gian vào phần gốc Cây Thần, có thể tăng tốc sinh trưởng Cây Thần</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Kéo Kết Tinh Thời Gian vào vị trí Trái Cây đã chọn, có thể tăng tốc bồi dưỡng</T><BR>10</BR>
]],
DELETEROLE_TEXT7 = "Xóa nhân vật",
TRAMPOLINE_TEXT1 =  {"Nhún Nhảy Vui Vẻ", "Nhiệm Vụ Nhún Nhảy", "Bảng Nhún Nhảy", "Cùng Nhau Nhún Nhảy", "Tiệm Nhún Nhảy", "Nhún Nhảy Miễn Phí", "Nhún nhẹ %d lần", "Nhún mạnh %d lần", "Toàn server tích lũy nhún nhảy đạt %d lần được nhận ngay 1 phần quà", "Nhún Nhảy Ngày", "Nhún Nhảy Vui Vẻ", "Sư Môn Nhún Nhảy", "Thưởng Ngôi Sao Nhún Nhảy", "Thưởng Bậc Thầy Nhún Nhảy", "Thưởng Nhún Nhảy", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó]], "Bảng Cá Nnhân", "Bảng Sư Môn", "Huy Chương Nhún Nhảy", "Điểm Nhún Nhảy", {"Còn thiếu một chút nữa là đủ rồi", "Cố gắng thêm một chút nữa", "Cố lên, chắc lần sau sẽ được thôi"}, {"Ôi, nhún nhảy càng cao thì thưởng càng lớn", "Ngầu quá", "Nhảy càng cao, nhìn càng xa"}, "Nhún nhảy có tỉ lệ nhận thêm", "Quà A", "Quà B", "Quà S", "Hạng Sư Môn", "Nhân Viên Sư Môn", "Hạng sư môn của tôi", "Điểm cá nhân của tôi", "Điểm sư môn", "Chỉ hiện sư môn Top %d"},
TRAMPOLINE_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Nhún Nhảy Vui Vẻ</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Được dùng Thức Uống Năng Lượng tiến hành rút thưởng Nhún Nhảy, mỗi lần nhún nhẹ tốn 1 Thức Uống Năng Lượng, nhận ngay 1 phần thưởng thường và 1 điểm nhún nhảy. Mỗi ngày đăng nhập game được nhận miễn phí 1 lần nhún nhảy. Mỗi lần nhún mạnh tốn 5 Thức Uống Năng Lượng, nhận ngay 1 phần thưởng cao cấp và 5 điểm nhún nhảy: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tốn Thức Uống Năng Lượng tiến hành rút thưởng có thể nhận Quà A/B/S, khi nhận Quà A ngẫu nhiên nhận được 3 phần thưởng, khi nhận Quà B ngẫu nhiên nhận được 4 phần thưởng, khi nhận Quà S ngẫu nhiên nhận được 5 phần thưởng: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần tốn 5 Thức Uống Năng Lượng nhận được 1 Huy Chương Nhún Nhảy, huy chương có thể mang vào Tiệm Nhín Nhảy để đổi đạo cụ quý hiếm;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Nhún Nhảy Toàn Server đạt số lần nhất định, được nhận 1 phần Thưởng Nhún Nhảy Toàn Server;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Nhún Nhảy có tỉ lệ nhận thêm thưởng lớn nhún nhảy!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Giàn Nhún: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Nhún Nhảy Ngày, Nhún Nhảy Vui Vẻ và Nhún Nhảy Sư Môn, Nhiệm Vụ Nhún Nhảy được nhận hoàn thành 1 lần/ngày, qua ngày sẽ xóa dữ liệu; trong hoạt động Nhún Nhảy Vui Vẻ chỉ được hoàn thành 1 lần, xong nhiệm vụ hãy nhận thưởng ngay, hoạt động kết thúc sẽ xóa hết toàn bộ; nhiệm vụ Nhún Nhảy Sư Môn có thể do thành viên sư môn cùng hoàn thành;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">BXH Giàn Nhún: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH chia làm BXH Giàn Nhún và BXH Sư Môn.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Bảng Nhún Nhảy dựa vào số Huy Chương Nhún Nhảy nhận được để tiến hành thống kê, Top 100 người chơi được nhận thưởng hấp dẫn, hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Bảng Sư Môn dựa vào tổng số điểm nhún nhảy của Tông Môn nhận được để tiến hành thống kê, Top 20 Tông Môn được nhận thưởng hấp dẫn, hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điểm sư môn chỉ tính điểm nhận được sau khi đệ tử hoàn thành bái sư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Cần ít nhất có 1 đệ tử mới được làm sư phụ để tính Bảng Sư Môn.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Người chơi trên Bảng Sư Môn phải tiến hành qua rút thưởng nhún nhảy mới được nhận thưởng.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Người chơi giữa chừng rời khỏi Tông Môn, thì sẽ trừ điểm nhún nhảy do người chơi này cống hiến.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
CURRENT_ACTIVITY = "Năng động: ",
GOLFBALL_TEXT1 =  {"Giải Golf", "Mục tiêu tham gia", "BXH Thi Đấu", "Giải Đấu Đội", "Thưởng thêm mỗi vòng", "Đánh Bóng miễn phí", "Đánh Bóng %d lần", "Nhún Mạnh %d lần", "Chú ý: Cần mời bạn thành công và khóa xác định xong mới bắt đầu thống kê thông tin đội", "Thi Đấu Hàng Ngày", "Thi Đấu Dài Hạn", "Giải Đấu Đội", "Thưởng Đại Gia Chơi Golf", "Thưởng Đánh Golf Lớn", "Thưởng Đánh Golf Nhỏ", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó]], "BXH Đại Gia", "BXH Đội Nhóm", "Số lỗ", "Chú ý: Số người tối đa trong đội là 3 người, sau khi vào đội, trong thời gian hoạt động sẽ không thể rời đi!", {"Thiếu chút nữa là vào lỗ rồi", "Ây, lực mạnh quá rồi", "Bay mất rồi, ha ha"}, {"Vào rồi! Vào rồi!", "Gậy này rất thành công", "Một gậy vào lỗ, tôi cũng làm được!"}, "Hạng đội", "Thành viên đội", "Số lỗ đội đã đạt", "Chú ý: Trong hoạt động, chỉ có thể mời 2 bạn bè tổ đội tham gia, khóa xác định xong sẽ không thể giải trừ quan hệ!", "Thưởng đánh vào lỗ", {"Vận động thời thượng", "Chỉ cần cố gắng là có thể đánh vào lỗ", "Một gậy vào lỗ, thử ngay xem nào", "Hãy cùng nhau tổ đội giành vô địch"}, "Banh Golf", "Không phải Đội Trưởng", "Không có bạn bè có thể mời", "Số lỗ đã đạt", "Vòng %d"},
GOLFBALL_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Giải Golf</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Được tốn Banh Golf tiến hành đánh bóng rút thưởng, dùng Gậy Gỗ tốn 1 Banh Golf/lần, nhận ngay 1 phần thưởng thường. Đăng nhập game được nhận miễn phí 1 lần đánh bóng. Gậy Sắt tốn 5 Banh Golf, nhận ngay 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi khi đánh số bóng nhất định sẽ nhận được Thưởng Vào Lỗ, khi hoàn thành 18 lỗ, được nhận thêm Thưởng Trận Đấu: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trong hoạt động, mời bạn tổ đội cùng hoàn thành nhiệm vụ. Trong hoạt động, tổ đội đã xác định sẽ không thể giải trừ</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy đánh bóng có tỉ lệ nhận thêm Thưởng Đánh Bóng!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ Đánh Bóng:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Thi Đấu Ngày, Thi Đấu Dài Hạn và Thi Đấu Đồng Đội, nhiệm vụ Thi Đấu Ngày được hoàn thành 1 lần/ngày, qua ngày xóa dữ liệu; trong hoạt động Thi Đấu Dài Ngày chỉ được hoàn thành 1 lần, xong nhiệm vụ hãy nhận thưởng ngay, hoạt động kết thúc sẽ xóa toàn bộ; Thi Đấu Đồng Đội do thành viên trong đội cùng hoàn thành, sau khi tạo đội thành công mới bắt đầu tính tiến độ nhiệm vụ đội;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">Bảng Đánh Bóng:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH chia làm BXH Cá Nhân và BXH Đội Nhóm.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Bảng Cá Nhân dựa vào số Banh Golf tiêu tốn để thống kê, Top 100 người chơi được nhận thưởng hấp dẫn, hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Bảng Đồng Đội dựa vào tổng số lượng vào lỗ mà đội đã nhận để tiến hành thống kê, Top 30 đội được nhận thưởng hấp dẫn, hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Phải tiến hành lập đội thành công mới tính số lượng vào lỗ.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Người chơi trong Bảng Đồng Đội phải từng đánh bóng vào lỗ mới được nhận thưởng.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
WISHING_BOTTLE_TEXT1 = {"Bình Ước Nguyện","Điểm Ước Nguyện","Ước Nguyện Miễn Phí","Ước nguyện %d lần","Nhật Ký Ước Nguyện","Tiệm Tâm Nguyện","BXH Ước Nguyện","Cùng Nhau Ước Nguyện","Thưởng Ước Nguyện May Mắn","Thưởng Ước Nguyện-Lớn","Thưởng Ước Nguyện-Nhỏ","Xu Ước Nguyện","Xu Ước Nguyện của tôi","Tiệm Tâm Nguyện","Toàn server tích lũy ước nguyện đạt %d lần nhận ngay 1 phần quà","Ước Nguyện Ngày","Ước Nguyện Dài Hạn","Mỗi ngày ước nguyện","Xu Tâm Nguyện"},
WISHING_BOTTLE_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Bình Ước Nguyện</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Được tốn Xu Ước Nguyện tiến hành rút thưởng Ước Nguyện, Bình Bảo Vệ Môi Trường tốn 1 Xu Ước Nguyện/lần, nhận ngay 1 phần thưởng thường. Mỗi ngày đăng nhập được miễn phí 1 lần ước nguyện. Bình Pha Lê tốn 5 Xu Ước Nguyện/lần, nhận ngay 1 phần thưởng cao cấp: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi tốn 5 Xu Ước Nguyện sẽ nhận được 1 Xu Tâm Nguyện,Xu Tâm Nguyện, dùng đổi đạo cụ trong Tiệm Tâm Nguyện</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Ước Nguyện Toàn Server đạt số lần nhất định, nhận ngay 1 phần Thưởng Ước Nguyện Toàn Server;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy ước nguyện có tỉ lệ nhận thêm Thưởng Lớn Ước Nguyện!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhật Ký Ước Nguyện: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Cầu Nguyện Hàng Ngày, Cầu Nguyện Lâu Dài và Hoạt Động Mỗi Ngày. Nhiệm vụ Cầu Nguyện Hàng Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Cầu Nguyện Lâu Dài và Hoạt Động Mỗi Ngày trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">BXH Ước Nguyện: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Ước Nguyện dựa vào số Xu Tâm Nguyện nhận được để thống kê, Top 100 người chơi được nhận thưởng hấp dẫn, hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
WISHING_BOTTLE_TEXT3 = {"Bình An Vui Vẻ","Vạn Sự Như Ý","Thăng Quan Tiến Chức","Phúc Thọ Song Toàn","Kim Bảng Đề Danh","Bộ Bộ Cao Thăng","Một Bước Lên Mây","Cát Tường","Cầu Được Ước Thấy","Thắng Ngay Trận Đầu","Phồn Vinh Thịnh Vượng","Vinh Hoa Phú Quý","Vô Ưu Vô Lo","Quần Anh Hội Tụ","Công Thành Danh Toại","Long Phụng Trình Tường","Tiền Đồ Vô Hạn","Cát Tường","Luôn Nở Nụ Cười","Cả Nhà An Khang","Xuân Phong Đắc Ý","Kim Ngọc Mãn Đường"},
ADDITIONAL_ATTRIBUTES = "Thuộc tính tăng",
DETECTIVE_TEXT1 =  {"Văn Phòng Thám Tử", "Ủy Thác Điều Tra", "BXH Điều Tra", "Chỉnh Lý Vụ Án", "BXH Danh Tiếng", "Điều Tra Miễn Phí", "Điều Tra%d lần", "TốnKính Lúp", "Danh Tiếng", "Điều Tra Hàng Ngày", "Ủy Thác Dài Ngày", "Giả Thiết", "Manh Mối", "Suy Luận", "Chân Tướng", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó]], {"Thiếu chút nữa thôi", "Chà, có vẻ đi quá đà rồi", "Ôi thôi hỏng rồi"}, "Đã đặt chi tiết vào xong, hãy đi Chỉnh Lý Vụ Án nào!", "Cần đặt đạo cụ trên mỗi ô!"},
DETECTIVE_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Văn Phòng Thám Tử</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Kính Lúp để Điều Tra rút thưởng. Điều Tra Thường mỗi lần tốn 1 Kính Lúp, chắc chắn nhận được 1 phần thưởng thường. Đăng nhập mỗi ngày nhận 1 lần Điều Tra Miễn Phí. Điều Tra Cao Cấp mỗi lần tốn 5 Kính Lúp, chắc chắn nhận được 1 phần thưởng cao cấp.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điều Tra có cơ hội nhận được Giả Thiết và Manh Mối, chỉnh lý Giả Thiết và Manh Mối có thể nhận thưởng Suy Luận và Chân Tướng!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Điều Tra có khả năng nhận thêm phần thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ Điều Tra: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Ủy Thác Hàng Ngày, Ủy Thác Dài Ngày. Nhiệm vụ Ủy Thác Hàng Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Ủy Thác Dài Ngày trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">BXH Điều Tra:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Điều Tra được thống kê theo số lượng Kính Lúp tiêu tốn, Top 100 người chơi có thể nhận phần thưởng hấp dẫn, phần thưởng sẽ được gửi qua thư sau khi hoạt động kết thúc.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
DETECTIVE_TEXT3 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn Chỉnh Lý Vụ Án</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Giả Thiết và Manh Mối có thể chỉnh lý thành Suy Luận và Chân Tướng, chỉnh lý xong có thể nhận thưởng tự chọn</T><BR>10</BR>
]],
MAGIC_STONE_TEXT25 = {"Thưởng Sơ Cấp","Thưởng Tinh Anh","Nhiệm vụ tuần %s","Ký Hiệu Chiến Lệnh","Mua điểm"},
FLOWER_RANK_TEXT1 = {"BXH Hoa Tươi", "Bảng Nam Thần", "Bảng Nữ Thần", "BXH Tổng", "BXH Các Kỳ", "Hạng", "Người chơi", "Hoa Tươi", "Thưởng", "Hoa Tươi của tôi", [[<T C="127,70,26" S="18" P="1">Phân biệt hiển thị người chơi Top </T><T C="229,105,22" S="18" P="1">%s</T><T C="127,70,26" S="18" P="1"></T>]], "Quy tắc"},
FLOWER_RANK_TEXT2 = [[<T C="185,48,72" S="22" P="1">Hướng dẫn hoạt động BXH Hoa Tươi</T><BR>10</BR>]],
GROW_GIFT_TEXT1 = {"Quà Trưởng Thành", "Quà Siêu Giá Trị", "Quà Tôn Hưởng", "Chưa Mở Khóa", "%s VND để mở khóa"},
MYSTERIOUS_SHOP_TEXT1 = {"Tiệm Năm Mới", "Tiệm Năm Mới", "Nhiệm Vụ Ngày", "Giảm Giá Toàn Server", "Giỏ Hàng", "Xin chào, hoan nghênh ghé thăm", "Toàn bộ sản phẩm", "Tổng cộng", "Vé Ưu Đãi của tôi", "Thanh toán", "Mua giới hạn", "Giảm còn %s%%", "Tạo mới thành công", "Không còn lượt tạo mới", "Đếm ngược chớp nhoáng", "Cách giảm giá còn", "Số lượng còn lại", "Đã bán hết", "Mua ngay", "Chưa đến giờ giảm sốc", "Tổng %s món", "Không dùng được Vé Ưu Đãi", "Có số lượng", "Không giới hạn số lần mua", "Vui lòng chọn vật phẩm để thanh toán", "Xác nhận mua"},
MYSTERIOUS_SHOP_TEXT2=[[<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Tiệm Năm Mới</T>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Tiệm Năm Mới: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trong hoạt động, mỗi ngày lúc 0h sẽ tạo mới 12 đạo cụ giảm giá, tốn [Thẻ Mua Sắm] để mua vật phẩm tương ứng, Thẻ Mua Sắm có thể nhận được từ Nhiệm Vụ Ngày hoặc Quà Xe Đẩy Nhỏ.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi ngày có 5 lần làm mới loại đạo cụ!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Đạo cụ trong Tiệm Năm Mới cần thêm vào Giỏ Hàng để thanh toán, mỗi đạo cụ có thể dùng Vé Ưu Đãi (Phiếu giảm giá chỉ có thể dùng cho một đạo cụ).</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi thanh toán trong Giỏ Hàng, tổng cộng có thể dùng hết phiếu giảm giá để được giá tốt nhất.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Lưu ý: Có một số vật phẩm không thể dùng Vé Ưu Đãi.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Ngày: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Nhiệm Vụ Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Hoàn thành nhiệm vụ có thể nhận thưởng tương ứng.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Giảm Giá Toàn Server:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi ngày vào lúc 0h sẽ tạo mới 9 đạo cụ giảm giá. Sau khi kết thúc đếm ngược có thể bắt đầu mua tranh.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi vật phẩm có số lượng giới hạn, bán hết sẽ ngừng.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Vật phẩm trong Giảm Giá Toàn Server không thể dùng Vé Ưu Đãi</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Không thể mua khi đếm ngược chưa kết thúc, hãy chú ý thời gian tranh mua!</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu liên quan sẽ bị xóa!</T><BR>10</BR>]],
ZOO_SIGHTSEEING_TEXT1 = {"Tham Quan Vườn Thú", "Nhiệm vụ Tham Quan", "BXH Tham Quan", "", "Gấu Trúc Tặng Quà", "Tham Quan Miễn Phí", "Tham Quan %d lần", "Tiệm Tham Quan", "", "Tham Quan Mỗi Ngày", "Nhiệm vụ Tham Quan", "Thưởng nhỏ Tham Quan", "Thưởng lớn Tham Quan", "Thưởng Chuyên Gia Tham Quan", "Cấp Tham Quan", [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó</T>]], {"Người Mới Tham Quan","Nhập Môn Tham Quan","Khách Quen Vườn Thú","Người Đam Mê Động Vật","Chuyên Gia Vườn Thú","Giám Đốc Vườn Thú"}, "Điểm Tham Quan", "Điểm Tham Quan của tôi", "Thưởng Tự Chọn", "Hãy chọn một phần thưởng", "Tre", "Điểm Tham Quan", "Cầu Phúc", "Dừng"},
ZOO_SIGHTSEEING_TEXT2 = [[<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Tham Quan Vườn Thú</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Vé Vào Vườn Thú để rút thưởng Tham Quan, thăm động vật nhỏ tốn 1 Vé Vào Vườn Thú, chắc chắn nhận 1 phần thưởng thường và 2 Điểm Tham Quan. Mỗi ngày đăng nhập nhận 1 lần tham quan Miễn Phí. Tốn 5 Vé Vào Vườn Thú để tham quan động vật lớn, chắc chắn nhận 1 phần thưởng cao cấp và 10 Điểm Tham Quan:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tham Quan có tỉ lệ nhận Tre, Tre có thể đổi đạo cụ trong Tiệm Tham Quan hoặc rút thưởng trong Gấu Trúc Tặng Quà!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi rút thưởng Gấu Trúc Tặng Quà có thể nhận nhiều thưởng!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Tham Quan có tỉ lệ nhận thêm thưởng Tham Quan!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm vụ Tham Quan: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Tham Quan Mỗi Ngày, Nhiệm Vụ Tham Quan. Tham Quan Mỗi Ngày trong ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm Vụ Tham Quan trong hoạt động chỉ được hoàn thành 1 lần, hoạt động kết thúc sẽ xóa hết dữ liệu, hãy nhận thưởng kịp thời.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Tham Quan: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Tham Quan thống kê dựa vào Điểm Tham Quan nhận được, Top 100 người chơi có thể nhậnthưởng hấp dẫn, hoạt động kết thúc gửi qua Thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu liên quan sẽ bị xóa!</T><BR>10</BR>]],

HAPPY_MIDAUTUMN_TEXT1 = {"Đoan Ngọ\nBình An", "Tặng Quà Miễn Phí", "Tặng Quà %s lần", "BXH Tặng Quà", "Xem BXH", "Hạng", "Tên", "Điểm Lộ Trình", "Điểm Lộ Trình Toàn Server", "Hãy chọn đạo cụ yêu thích", [[<T C="255,236,193" S="16" P="1" SC="132,66,29" SS="4" SE="1">Mỗi lần Tặng Quà có cơ hội nhận Điểm Lộ Trình x2, tỉ lệ nhỏ nhận Điểm Lộ Trình x100, </T><T C="255,89,74" S="16" P="1" SC="132,66,29" SS="4" SE="1">Điểm Lộ Trình và Quà Cá Nhân tạo mới mỗi ngày, hãy nhận kịp thời!</T>]], "Thưởng Lộ Trình Cá Nhân chưa chọn", "Điểm Lộ Trình của tôi", "Sau khi tham gia Tặng Quà mới được nhận"},
HAPPY_MIDAUTUMN_TEXT2 = [[<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Đoan Ngọ Bình An</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tốn Bánh Ú để rút thưởng Tặng Quà, mỗi lần Tặng Quà sẽ nhận một phần thưởng, và nhận 1 Điểm Lộ Trình, có tỉ lệ nhận 2 Điểm Lộ Trình, tỉ lệ nhỏ nhận 100 Điểm Lộ Trình, </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trước mỗi lần rút thưởng Tặng Quà cần chọn Thưởng Cá Nhân, đạt Điểm Lộ Trình tương ứng có thể nhận, Thưởng Cá Nhân và Điểm Lộ Trình 0h mỗi ngày tạo mới, hãy nhận kịp thời!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trong hoạt động, Điểm Lộ Trình nhận mỗi lần Tặng Quà sẽ tính vào Điểm Lộ Trình Toàn Server, người chơi tham gia rút thưởng Tặng Quà, khi tích lũy Điểm Lộ Trình Toàn Server đạt số lượng tương ứng sẽ nhận thưởng!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Tặng Quà:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Tặng Quà dựa vào tích lũy Điểm Lộ Trình Cá Nhân để thống kê, top 100 người chơi có thể nhận thưởng hấp dẫn, hoạt động kết thúc gửi qua Thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>]],
BATTLE_HUD_TEXT3 = {"Vui lòng nhấp vào điểm đến để chọn vị trí đặt bom", "Vui lòng nhấp vào điểm đến để triệu hồi Phân Thân Linh Hồn", " - Phân Thân Linh Hồn"},
BATTLE_HUD_TEXT5 = "Vui lòng nhấp vào đơn vị đồng minh",
WEEKEND_SPECIAL_TEXT1 = {"Ưu Đãi Cuối Tuần"},
TOPGOLD_TEXT5 = "%d phút %d giây",
GOLD_MINER_TEXT1 = {"Thợ Mỏ Hoàng Kim", "Đào Mỏ Miễn Phí", "Đào Mỏ %d lần", "Nhiệm Vụ Vàng", "Đội Hoàng Kim", "Thưởng Kim Cương (Lớn)", "Thưởng Vàng (Lớn)", "Thưởng Vàng (Nhỏ)", "Đào Mỏ Mỗi Ngày", "Đào Mỏ Dài Hạn", "Đào Mỏ Đội Nhóm", "Tốn Sợi Móc", "Bảng Vàng", "Tốn Sợi Móc"},
GOLD_MINER_TEXT2 = [[<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Thợ Mỏ Hoàng Kim</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Sợi Móc để rút thưởng Đào Mỏ. Móc Sắt Đào Mỏ mỗi lần cần tốn 1 Sợi Móc, chắc chắn nhận được 1 phần thưởng thường. Đăng nhập mỗi ngày được miễn phí Đào Mỏ 1 lần. Móc Vàng Đào Mỏ mỗi lần cần tốn 5 Sợi Móc, chắc chắn nhận được 1 phần thưởng cao cấp: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trong hoạt động, mời bạn tổ đội cùng hoàn thành nhiệm vụ. Trong hoạt động, tổ đội đã xác định sẽ không thể giải trừ</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Đào Mỏ có cơ hội nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Vàng: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Đào Mỏ Mỗi Ngày, Đào Mỏ Dài Hạn và Đào Mỏ Đội Nhóm. Nhiệm vụ Đào Mỏ Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ  Đào Mỏ Dài Hạn và Đào Mỏ Đội Nhóm trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu. Đào Mỏ Đội Nhóm phải mời các thành viên trong Đội Nhóm cùng hoàn thành, phải gia nhập vào đội nhóm trước mới bắt đầu tính tiến độ nhiệm vụ.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">BXH: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH chia làm BXH Cá Nhân và BXH Đội Nhóm.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Cá Nhân thống kê theo số Sợi Móc đã tiêu hao. Top 100 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Đội Nhóm thống kê theo số Sợi Móc đã tiêu hao. Top 30 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Cần gia nhập đội nhóm mới bắt đầu tính số Sợi Móc tiêu hao.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Người chơi trên BXH Đội Nhóm cần Rút Thưởng Đào Mỏ mới được nhận thưởng.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>]],
GOLD_MINER_TEXT3 = {"Thám Hiểm Đào Vàng, cùng nhau thử nào", "Cùng tổ đội giành quán quân nhé"},

ACTIVITY_TEXT205 = {"thành công","Người này đã vào đội","Người này không phải bạn bè", "Không có trong danh sách mời", "Đã vào đội rồi", "Số thành viên đội đã đầy", "Người này đã vào đội khác", "Đã là Đội Trưởng rồi"},
DEEPSEA_TEXT1 =  {"Săn Báu Đáy Biển", "Nhật Ký Lặn Biển", "BXH Săn Báu", "Khu An Toàn", "Khu Nguy Hiểm", "Lặn Miễn Phí", "Lặn %d lần", "Tiệm Đáy Biển", "Tiền Xu Cổ", "Lặn Biển Mỗi Ngày", "Săn Báu Đáy Biển", "Thưởng Ngọc Trai (Nhỏ)", "Thưởng Trang Sức (Lớn)", "Thưởng Cổ Vật (Lớn)", "Thưởng Cấp Độ Lặn", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó]], {"Tân Thủ Tập Lặn", "Thợ Lặn Sơ Cấp", "Thợ Lặn Trung Cấp", "Thợ Lặn Cao Cấp", "Thợ Lặn Lành Nghề", "Chuyên Gia Lặn Biển", "Bậc Thầy Lặn Biển"},"Điểm Lặn", "Đang Săn Báu"},
DEEPSEA_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Săn Báu Đáy Biển</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Bình Oxy để rút thưởng Lặn Biển. Lặn Khu An Toàn mỗi lần cần tốn 1 Bình Oxy, chắc chắn nhận được 1 phần thưởng thường. Đăng nhập mỗi ngày được miễn phí Lặn Biển 1 lần. Lặn Khu Nguy Hiểm mỗi lần cần tốn 5 Bình Oxy, chắc chắn nhận được 1 phần thưởng cao cấp: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi lặn có xác suất nhận Tiền Xu Cổ, có thể đổi lấy thưởng quý trong Tiệm Đáy Biển!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Lặn Biển có cơ hội nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhật Ký Lặn Biển: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Lặn Biển Mỗi Ngày, Săn Báu Đáy Biển. Nhiệm vụ Lặn Biển Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Săn Báu Đáy Biển trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">BXH Lặn Biển: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Săn Báu thống kê theo số Tiền Xu Cổ nhận được. Top 100 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
CHESS_ACTIVITY_TEXT1 = {"Cờ Đấu Tiên", "Đánh Cờ Miễn Phí", "Đánh %d ván", "Nhật Ký Đánh Cờ", "Toàn Dân Đánh Cờ", "BXH Đánh Cờ", "Giải Thánh Cờ", "Giải Tiên Cờ", "Giải Quỷ Cờ", "Toàn server tích lũy rút thưởng đạt %d lần thì có thể nhận 1 phần quà", "Mảnh Kỳ Phổ", "Đánh Cờ Hằng Ngày", "Đánh Cờ Dài Hạn", "Sư Đồ Đánh Cờ", "Lan Kha Kỳ Phổ", "Bàn Cờ Gỗ", "Bàn Cờ Ngọc", "Mảnh Kỳ Phổ không đủ", "Biên Soạn thành công", "Biên Soạn %d lần", "Đương Hồ Thập Cuộc", "Cửu Long Hí Châu", "Huyết Lệ Kỳ Cuộc", "Trân Lung Kỳ Cuộc", "Biên soạn xong hết tất cả Kỳ Cuộc 1 lần, có thể nhận thêm một trong các thưởng sau (nếu đã chọn thưởng trước thì chắc chắn nhận đúng thưởng đã chọn)", "Kỳ Phổ", "Điểm Kỳ Nghệ"},
CHESS_ACTIVITY_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Cờ Đấu Tiên</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Con Cờ để rút thưởng Đánh Cờ. Bàn Gỗ Đánh Cờ mỗi lần cần tốn 1 Con Cờ, chắc chắn nhận được 1 phần thưởng thường. Đăng nhập mỗi ngày được miễn phí Đánh Cờ 1 lần. Bàn Ngọc Đánh Cờ mỗi lần cần tốn 5 Con Cờ, chắc chắn nhận được 1 phần thưởng cao cấp: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi Đánh Cờ có xác suất nhận Mảnh Kỳ Phổ, dùng trong Lan Kha Kỳ Phổ để biên soạn và rút thưởng, mỗi lần tốn 1 Mảnh Kỳ Phổ chắc chắn nhận 1 phần thưởng!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Lan Kha Kỳ Phổ gồm 4 Kỳ Cuộc: Đương Hồ Thập Cuộc, Cửu Long Hí Châu, Huyết Lệ Kỳ Cuộc, Trân Lung Kỳ Cuộc. Hoàn thành cả 4 Kỳ Cuộc kể trên, sẽ nhận được Thưởng Kỳ Phổ (nếu đã chọn thưởng trước thì chắc chắn nhận đúng thưởng đã chọn)!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Đánh Cờ có cơ hội nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhật Ký Đánh Cờ: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Đánh Cờ Hằng Ngày, Đánh Cờ Dài Hạn, Sư Đồ Đánh Cờ. Nhiệm vụ Đánh Cờ Hằng Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Đánh Cờ Dài Hạn, Sư Đồ Đánh Cờ trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">BXH Đánh Cờ: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Đánh Cờ chia thành BXH Cá Nhân và BXH Sư Môn.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Cá Nhân thống kê theo số Mảnh Kỳ Phổ nhận được. Top 100 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Sư Môn thống kê theo số Điểm Đánh Cờ Tông Môn nhận được. Top 200 Tông Môn được nhận thưởng qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điểm sư môn chỉ tính điểm nhận được sau khi đệ tử hoàn thành bái sư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Cần ít nhất có 1 đệ tử mới được làm sư phụ để tính Bảng Sư Môn.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Người chơi trên BXH Sư Môn cần tốn Con Cờ để rút thưởng xong mới được nhận thưởng.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Người chơi rời khỏi Tông Môn giữa chừng, sẽ xóa hết Điểm Đánh Cờ mà người chơi này cống hiến.</T><BR>10</BR>
]],
VIP_TEXT38 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn BXH Xạ Thủ</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">1.BXH Xạ Thủ thống kê theo số Điểm VIP đã nhận được. Top 200 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">2.Nạp Kim Cương Lam, dùng Kim Cương Lam, mua quà, đều nhận được Điểm VIP</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">   Khi nạp Kim Cương Lam, mỗi 60 Kim Cương Lam sẽ nhận được 1 Điểm VIP. (Kim Cương Lam do hệ thống tặng, nhận từ Thẻ Tháng, Thẻ Phúc Lợi sẽ không tính vào Điểm VIP)</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">   Khi tiêu Kim Cương Lam, mỗi 600 Kim Cương Lam nhận 2 điểm VIP.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">   Khi mua quà, sẽ tính điểm theo mức chi trả, mỗi 6 VND tăng 1 Điểm VIP.</T><BR>10</BR>
]],
AUTUMNCAMP_TEXT1 =  {"Dã Ngoại Mùa Thu", "Nhiệm Vụ Dã Ngoại", "BXH Dã Ngoại", "Dã Ngoại Công Viên", "Dã Ngoại Rừng Núi", "Dã Ngoại Miễn Phí", "Dã Ngoại %d lần", "Thêm Củi %d lần", "Tổng Điểm Dã Ngoại", "Nhật Ký Dã Ngoại", "Cuộc Sống Dã Ngoại", "Thưởng Dã Ngoại (Nhỏ)", "Thưởng Dã Ngoại (Lớn)", "Thưởng Chuyên Gia Dã Ngoại", "Thưởng Lửa Trại", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó]], "Nhiệt Độ Lửa Trại Toàn Server", "Điểm Dã Ngoại", "Đang Dã Ngoại", "Nhiệt Độ Cá Nhân", "Đang Thêm Củi", "Lửa Trại Cá Nhân", "Lửa Trại Toàn Server"},
AUTUMNCAMP_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Dã Ngoại Mùa Thu</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Thẻ Dã Ngoại để rút thưởng Dã Ngoại. Dã Ngoại Công Viên mỗi lần cần tốn 1 Thẻ Dã Ngoại, chắc chắn nhận được 1 phần thưởng thường và 2 Điểm Dã Ngoại. Đăng nhập mỗi ngày được miễn phí Dã Ngoại 1 lần. Dã Ngoại Rừng Núi mỗi lần cần tốn 5 Thẻ Dã Ngoại, chắc chắn nhận được 1 phần thưởng cao cấp và 10 Điểm Dã Ngoại: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi Dã Ngoại có xác suất nhận Củi Gỗ, có thể thêm vào Lửa Trại để rút thưởng, mỗi lần tăng 1 điểm Nhiệt Độ!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Độ nóng cá nhân và toàn server đạt giá trị nhất định có thể nhận Thưởng Nhiệt Độ!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Dã Ngoại có cơ hội nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Dã Ngoại: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Nhật Ký Dã Ngoại, Cuộc Sống Dã Ngoại. Nhiệm vụ Nhật Ký Dã Ngoại mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Cuộc Sống Dã Ngoại trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Dã Ngoại: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Dã Ngoại thống kê theo số Điểm Dã Ngoại nhận được. Top 100 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
HOTBASKETBALL_TEXT1 =  {"Bóng Rổ Sôi Động", "Nhiệm Vụ Ném Rổ", "BXH Cao Thủ Bóng Rổ", "Tân Thủ Ném Rổ", "Cao Thủ Ném Rổ", "Ném Rổ Miễn Phí", "Ném Rổ %d lần", "Cửa Hàng Ném Rổ", "Phiếu Thưởng", "Ném Rổ Mỗi Ngày", "Cao Thủ Ném Rổ", "Thưởng Tân Thủ Ném Rổ", "Thưởng Cao Thủ Ném Rổ", "Thưởng Thánh Thủ Ném Rổ", "Thưởng Cấp Độ Ném Rổ", [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó</T>]], {"Tân Binh Bóng Rổ", "Tinh Anh Bóng Rổ", "Cao Thủ Bóng Rổ", "Đội Trưởng Kiểm Soát", "Vua Kết Liễu", "Thần Xạ Thủ", "Điểm Ghi Điểm"}, "Đang Ném Rổ", "ném bóng...", "Đếm Ngược Ném Rổ", "Cần ném trúng %d lần để Thưởng Ném Rổ nhân đôi", "Khoảnh Khắc May Mắn"},
HOTBASKETBALL_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Bóng Rổ Sôi Động</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Xu Bóng Rổ để rút thưởng Ném Rổ. Tân Thủ Ném Rổ mỗi lần cần tốn 1 Xu Bóng Rổ, chắc chắn nhận được 1 phần thưởng thường. Đăng nhập mỗi ngày được miễn phí Ném Rổ 1 lần. Cao Thủ Ném Rổ mỗi lần cần tốn 5 Xu Bóng Rổ, chắc chắn nhận được 1 phần thưởng cao cấp: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi ném rổ có xác suất ném trúng, sau khi ghi điểm sẽ nhận được Điểm Ghi Điểm!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi ném rổ có xác suất nhận được Phiếu Thưởng, dùng đổi thưởng hiếm trong Tiệm Ném Rổ!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Ném Rổ có cơ hội nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Ném Rổ: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Ném Rổ Mỗi Ngày, Cao Thủ Ném Rổ. Nhiệm vụ Ném Rổ Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Cao Thủ Ném Rổ trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Cao Thủ Bóng Rổ: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Cao Thủ Bóng Rổ thống kê theo số Điểm Ghi Điểm nhận được. Top 100 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
FLYKITES_TEXT1 = {"Thả Diều", "Thả Diều Miễn Phí", "Thả Diều %d lần", "Mục Tiêu Thả Diều", "Dấu Chân Du Lịch", "BXH Thả Diều", "Thưởng Du Lịch", "Mục Tiêu Thả Diều", "Thả Diều Mỗi Ngày", "Cao Thủ Thả Diều", "Thả Diều Mỗi Ngày", "Ổ Dây Thả Diều", "Ổ Dây Của Tôi", "Du lịch thành công mới có thưởng", "Bắt Đầu Du Lịch", "Thưởng Chuyên Gia Thả Diều", "Thưởng Cao Thủ Thả Diều", "Thưởng Tân Thủ Thả Diều", "Điểm Thả Diều", "Tăng Tốc Du Lịch", "Đang Tăng Tốc", "Thưởng Tăng Tốc", "Dấu Chân Du Lịch", "Thời Gian Du Lịch", "Giới Hạn Du Lịch", "%s sau sẽ nhận thưởng", "Đang Tăng Tốc Du Lịc", "Giới Hạn Tăng Tốc"},
FLYKITES_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Thả Diều</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Ổ Dây Thả Diều để rút thưởng Thả Diều. Con Diều Số 1 mỗi lần cần tốn 1 Ổ Dây Thả Diều, chắc chắn nhận được 1 phần thưởng thường và 2 Điểm Con Diều. Đăng nhập mỗi ngày được miễn phí Thả Diều 1 lần. Con Diều Số 2 mỗi lần cần tốn 5 Ổ Dây Thả Diều, chắc chắn nhận được 1 phần thưởng cao cấp: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Thả Diều có cơ hội nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Con Diều Du Lịch: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tốn 5 Ổ Dây Thả Diều để bắt đầu Con Diều Du Lịch, duy trì 10 giờ, mỗi 2 giờ nhận một phần thưởng. Khi bắt đầu Du Lịch có thể nhận 3 phần thưởng và 1 Dấu Chân Du Lịch!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tốn 5 Ổ Dây Thả Diều để tăng tốc Con Diều Du Lịch, mỗi lần tăng tốc sẽ giảm 20% thời gian giãn cách nhận thưởng, tăng gấp đôi thời gian nhận thưởng, đồng thời nhận 1 Dấu Chân Du Lịch!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần nhận 1 dấu chân sẽ mở khóa 1 phần Thưởng Thành Phố, nhận trong Dấu Chân Du Lịch!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Thả Diều: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Thả Diều Mỗi Ngày, Cao Thủ Thả Diều. Nhiệm vụ Thả Diều Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Cao Thủ Thả Diều trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0">BXH Thả Diều: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Thả Diều thống kê theo số Ổ Dây Thả Diều đã tiêu hao. Top 100 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
ADDITIONAL_ATTRIBUTE2 = "Tăng thêm thuộc tính",
THROWPOT_TEXT1 =  {"Ném Tên", "Nhiệm Vụ Ném Tên", "BXH Cao Thủ Ném Tên", "Ném Tên Sát Tai", "Ném Tên Qua Tai", "Ném Tên Miễn Phí", "Ném Tên %d lần", "Tiệm Ném Tên", "Điểm Ném Tên", "Ném Tên Mỗi Ngày", "Ném Tên Qua Tai", "Thưởng Ném Tên (Nhỏ)", "Thưởng Ném Tên (Lớn)", "Thưởng Cao Thủ Ném Tên", "Đang Ném Tên", [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó</T>]], {"Suýt nữa thì trúng", "Cần luyện thêm một chút", "Vẫn còn có thể cải thiện thêm"}, {"Bách phát bách trúng", "Tạm ổn, tạm ổn", "Nhẹ nhàng thôi", "Hôm nay may mắn quá"}, "Ném trúng, nhận thưởng %d lần"},
THROWPOT_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Ném Tên</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Mũi Tên Nhỏ để rút thưởng Ném Tên. Ném Tên Sát Tai mỗi lần cần tốn 1 Mũi Tên Nhỏ, chắc chắn nhận được 1 phần thưởng thường và 2 Điểm Ném Tên. Đăng nhập mỗi ngày được miễn phí Ném Tên 1 lần. Ném Tên Qua Tai mỗi lần cần tốn 5 Mũi Tên Nhỏ, chắc chắn nhận được 1 phần thưởng cao cấp và 10 Điểm Ném Tên: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Điểm Ném Tên đạt đến giá trị nhất định có thể nhận điểm thưởng, điểm thưởng sẽ tái lập mỗi ngày!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Ném Tên có xác suất ném vào miệng bình, nếu trúng được nhận thưởng x2, đồng thời Ném Tên Qua Tai chắc chắn trúng</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Ném Tên có xác suất nhận được Lệnh Cản Rượu, dùng đổi thưởng hiếm trong Tiệm Ném Tên!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Ném Tên có cơ hội nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Ném Tên: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Ném Tên Mỗi Ngày, Ném Tên Qua Tai. Nhiệm vụ Ném Tên Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Ném Tên Qua Tai trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Cao Thủ Ném Tên: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Cao Thủ Ném Tên thống kê theo Điểm Ném Tên nhận được. Top 100 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
BIKEMATCH_TEXT1 =  {"Giải Đua Xe Đạp", "Nhật Ký Đua Tốc", "BXH Đua Tốc", "Đua Chặng Ngắn", "Đua Chuyên Nghiệp", "Đua Tốc Miễn Phí", "Đua Tốc %d lần", "Thưởng Vòng %d", "Cự Ly Đạp Xe", "Đạp Xe Hôm Nay", "Tay Đua Chuyên Nghiệp", "Thưởng Đua Tốc (Nhỏ)", "Thưởng Đua Tốc (Lớn)", "Thưởng Quán Quân", "%d/%d vòng", [[Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó]], "Đang Đạp Xe", "Thưởng Huy Chương"},
BIKEMATCH_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Giải Đua Xe Đạp</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Găng Tay Kỵ Sĩ để rút thưởng Đua Xe Đạp. Đua Chặng Ngắn mỗi lần cần tốn 1 Găng Tay Kỵ Sĩ, chắc chắn nhận được 1 phần thưởng thường. Đăng nhập mỗi ngày được miễn phí Đua Xe Đạp 1 lần. Đua Chuyên Nghiệp mỗi lần cần tốn 5 Găng Tay Kỵ Sĩ, chắc chắn nhận được 1 phần thưởng cao cấp: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi Đạp Xe, mỗi lần tốn 1 Găng Tay Kỵ Sĩ sẽ đi được 1 mét. Khi cự ly đạt yêu cầu sẽ hoàn thành 1 vòng và nhận thưởng vòng. Số vòng đạt yêu cầu sẽ nhận Huy Chương Đạp Xe!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Đua Xe Đạp có cơ hội nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhật Ký Đua Tốc: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Đạp Xe Hôm Nay, Tay Đua Chuyên Nghiệp. Nhiệm vụ Đạp Xe Hôm Nay mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Tay Đua Chuyên Nghiệp trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Đua Tốc: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Đua Tốc thống kê theo cự ly đã đi được. Top 100 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
CATCHFISH_TEXT1 = {"Vua Đánh Cá", "Nhiệm Vụ Đánh Cá", "BXH Đánh Cá", "Đánh Cá Không Chuyên", "Đánh Cá Đỉnh Cao", "Đánh Cá Miễn Phí", "Đánh Cá %d lần", "Thư Viện Đánh Cá", "Lưới Cá", "Đánh Cá Mỗi Ngày", "Cao Thủ Đánh Cá", "Thưởng Tập Tành Đánh Cá", "Thưởng Cao Thủ Đánh Cá", "Thưởng Cuồng Đánh Cá", "Cấp Đánh Cá", [[Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó]], {"Tập Tành Đánh Cá", "Mới Biết Đánh Cá", "Cao Thủ Đánh Cá", "Chuyên Gia Đánh Cá", "Trùm Đánh Cá", "Vua Đánh Cá", "Vua Đánh Cá"}, "EXP Đánh Cá", "Đang Đánh Cá", "Cá Thường", "Cá Hiếm", "Thưởng Tự Chọn", "Chọn một phần thưởng", "Cá Voi", "HP: ", "Tốn thêm %d Lưới Cá sẽ xuất hiện Cá Voi"},
CATCHFISH_TEXT2 = [[
<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Vua Đánh Cá</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">1.</T><T C="255,255,255" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Tốn Lưới Cá để rút thưởng Đánh Cá, Đánh Cá Không Chuyên mỗi lần tốn 1 Lưới Cá, chắc chắn nhận được 1 phần thưởng thường và 2 điểm EXP Đánh Cá. Đăng nhập mỗi ngày được Đánh Cá Miễn Phí 1 lần. Đánh Cá Đỉnh Cao mỗi lần tốn 5 Lưới Cá và 10 điểm EXP Đánh Cá, chắc chắn nhận được 1 phần thưởng cao cấp: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Mỗi lần Đánh Cá sẽ nhận ngẫu nhiên 1 loài Cá Thường, tốn Lưới Cá đạt số lượng nhất định sẽ xuất hiện Cá Voi, đánh Đánh Cá Voi có thể nhận thưởng x2!</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Cá đánh bắt được có thể vào Thư Viện Đánh Cá đổi thưởng hiếm. Thư Viện được tạo mới mỗi ngày!</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Tích lũy Đánh Cá có xác suất nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">2.</T><T C="255,255,255" S="20" P="0">Nhiệm Vụ Đánh Cá: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Chia làm nhiệm vụ Đánh Cá Mỗi Ngày, Cao Thủ Đánh Cá. Nhiệm vụ Đánh Cá Mỗi Ngày có thể hoàn thành mỗi ngày 1 lần, sang hôm sau xóa dữ liệu. Nhiệm vụ Cao Thủ Đánh Cá trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">3.</T><T C="255,255,255" S="20" P="0">BXH Đánh Cá: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH Đánh Cá thống kê theo EXP Đánh Cá nhận được. Top 100 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="255,150,16" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
LASHTOP_TEXT1 = {"Đánh Con Quay", "Tiệm Tuổi Thơ", "Nhật Ký Tuổi Thơ", "BXH Con Quay", "Quay Miễn Phí", "Quay %d lần", "Thưởng Con Quay (Lớn)", "Thưởng Tuổi Thơ (Lớn)", "Thưởng Tuổi Thơ (Nhỏ)", "Trò Chơi Hôm Nay", "Nhật Ký Tuổi Thơ", "BXH Thú Vui Con Trẻ", "Tốn Roi Nhỏ", "Roi Nhỏ Đã Tốn", "Thẻ Con Quay"},
LASHTOP_TEXT2 = [[<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Đánh Con Quay</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Roi Nhỏ để rút thưởng Đánh Con Quay. Đánh Con Quay Gỗ mỗi lần cần tốn 1 Roi Nhỏ, chắc chắn nhận được 1 phần thưởng thường. Đăng nhập mỗi ngày được miễn phí Đánh Con Quay 1 lần. Đánh Con Quay Sắt mỗi lần cần tốn 5 Roi Nhỏ, chắc chắn nhận được 1 phần thưởng cao cấp: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Ném Tên có xác suất nhận được Thẻ Con Quay, dùng đổi thưởng hiếm trong Tiệm Tuổi Thơ!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Đánh Con Quay có cơ hội nhận thêm thưởng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhật Ký Tuổi Thơ: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Trò Chơi Hôm Nay, Nhật Ký Tuổi Thơ. Nhiệm vụ Trò Chơi Hôm Nay mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Nhật Ký Tuổi Thơ trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Thú Vui Con Trẻ: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Thú Vui Con Trẻ thống kê theo số Roi Nhỏ đã tiêu hao. Top 100 người chơi được nhận thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
COLDDRINK_TEXT1 =  {"Giải Khát Mát Lạnh", "Nhiệm Vụ Mát Lạnh", "BXH Giải Khát", "EXP Mát Lạnh", "EXP Mát Lạnh đang có", "Uống miễn phí", "Uống %d ly", "Cửa Hàng Mát Lạnh", "Giải Khát Mỗi Ngày", "Nhiệm Vụ Mát Lạnh", "Uống Nước Mỗi Ngày", "Thưởng Giải Khát (Nhỏ)", "Thưởng Giải Khát (Lớn)", "Thưởng Siêu Mát Lạnh", "Cấp Giải Khát", [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó</T>]], {"Không có danh hiệu", "Mát Lạnh Tuyệt Vời", "Mát Lạnh Đã Khát", "Thấm Tận Tâm Can", "Hứng Khởi Vô Tận", "Lạnh Buốt Chân Răng"}, "EXP Mát Lạnh", "Toàn server tích lũy rút thưởng đủ %d lần sẽ có thể nhận 1 phần quà", "Thời gian còn", [[<T C="73,100,163" S="16" P="1">Dùng thêm </T><T C="255,89,73" S="16" P="1">%s</T><T C="73,100,163" S="16" P="1"> Phiếu Giải Khát sẽ vào Thời Khắc Cực Kool</T>]], "Thời Khắc Cực Kool", "Mùa Hè Mát Mẻ", "Xu Mát Lạnh"},
COLDDRINK_TEXT2 = [[<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Giải Khát Mát Lạnh</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng Phiếu Giải Khát để uống Nước Giải Khát rút thưởng. Uống Trà mỗi lần tốn 1 Phiếu Giải Khát, chắc chắn nhận được 1 phần thưởng thường và 2 EXP Mát Lạnh. Đăng nhập mỗi ngày được uống miễn phí 1 lần. Uống Trà Sữa mỗi lần tốn 5 Phiếu Giải Khát, chắc chắn nhận được 1 phần thưởng cao cấp và 10 EXP Mát Lạnh: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Dùng đủ số Phiếu Giải Khát sẽ vào Thời Khắc Cực Kool.</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trong thời gian duy trì Thời Khắc Cực Kool, uống Nước Giải Khát sẽ được nhận thưởng x2!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy uống Nước Giải Khát, có cơ hội nhận thêm Thưởng Giải Khát (Lớn)!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Mát Lạnh: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Giải Khát Mỗi Ngày, Nhiệm Vụ Mát Lạnh và Uống Nước Mỗi Ngày. Nhiệm vụ Giải Khát Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm Vụ Mát Lạnh và Uống Nước Mỗi Ngày trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Giải Khát: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Giải Khát sẽ thống kê theo tổng số Phiếu Giải Khát đã tiêu hao, Top 100 người chơi được nhận thưởng hấp dẫn, khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
WEEKEND_SPECIAL_TWO_TEXT1 = {"Ưu Đãi Cuối Tuần"},
KICKING_BIRDIE_TEXT1 = {"Đá Cầu", "Nhiệm Vụ Đá Cầu", "Công Hội Đá Cầu", "BXH", "Cùng Đá Cầu", "Căn Tin Tạp Hóa", "Thưởng Hạng 1", "Thưởng Cao Thủ", "Thưởng Nhập Môn", "Đá Cầu Miễn Phí", "Đá Cầu %d lần", "Đá Cầu Mỗi Ngày", "Đá Cầu Dài Hạn", "Lông Vũ", "Toàn server tích lũy rút thưởng đạt %d lần có thể nhận 1 phần quà", "BXH Đá Cầu", "Điểm Đá Cầu", "Điểm Đá Cầu của tôi", "Công Hội Đá Cầu", "Công Hội Mạnh Nhất", "Thưởng BXH Công Hội Mạnh Nhất", "Hạng Công Hội", "Công Hội/Cấp/ID", "Điểm Cầu Công Hội", "Điểm Cầu của tôi", "Hạng Công Hội", "Hạng BXH Công Hội Mạnh Nhất"},
KICKING_BIRDIE_TEXT2 = [[<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Đá Cầu</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Trái Cầu để rút thưởng Đá Cầu, Đá Cầu Kiểu Tân Thủ mỗi lần dùng 1 Trái Cầu, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Đá Cầu Miễn Phí 1 lần. Đá Cầu Kiểu Cao Thủ mỗi lần dùng 5 Trái Cầu, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi Ném Tên có xác suất nhận Lông Vũ, Lông Vũ có thể đổi thưởng quý giá tại Căn Tin Tạp Hóa!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Đá Cầu có xác suất nhận thêm Thưởng Lớn Đá Cầu!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Đá Cầu Công Hội: Là nhiệm vụ Công Hội và BXH Công Hội Mạnh Nhất, nhiệm vụ Công Hội có thể do thành viên Công Hội cùng hoàn thành và nhận thưởng; BXH Công Hội Mạnh Nhất tính toán dựa trên số Cầu Tông Môn tiêu hao, Tông Môn top 10 có thể nhận thưởng, sau khi hoạt động kết thúc sẽ tự động phát qua thư hệ thống;</T><BR>10</BR>
<T C="229,105,22" S="20" P="1">Chú ý: BXH Công Hội Mạnh Nhất, người chơi cùng Công Hội cần tham gia hoạt động và nhận ít nhất 1 Điểm Đá Cầu, mới có thể nhận thưởng khi tổng kết.</T><BR>10</BR>
<T C="229,105,22" S="20" P="1">Chú ý: Nếu thành viên rời Công Hội giữa chừng và gia nhập vào Công Hội mới, mức tích lũy Điểm Đá Cầu trong Công Hội cũ không đổi, nhưng sẽ không tính vào cho Công Hội mới.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Đá Cầu:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Đá Cầu Mỗi Ngày, Đá Cầu Dài Hạn, nhiệm vụ Đá Cầu Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Đá Cầu Dài Hạn trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Đá Cầu:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Đá Cầu thống kê dựa trên điểm Đá Cầu, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
MAGIC_CLASSROOM_TEXT1 = {"Giảng Đường Ma Thuật", "Huy Hiệu Phù Thủy Ma Thuật", "Nhiệm Vụ Học Tập", "BXH Pháp Sư", "Học Miễn Phí", "Học %d lần", "Phù Thủy Ma Thuật-Cao", "Phù Thủy Ma Thuật-Vừa", "Phù Thủy Ma Thuật-Sơ", "Cấp Ma Thuật", "EXP Ma Thuật", "Tiến độ học Ma Thuật Nguyên Tố %s", "Học Ma Thuật", "Nghiên Cứu Ma Thuật", "BXH Pháp Sư", "EXP Ma Thuật", "EXP Ma Thuật"},
MAGIC_CLASSROOM_TEXT2 = {"Phong", "Hỏa", "Thủy", "Băng", "Lôi", "Địa"},
MAGIC_CLASSROOM_TEXT3 = {"Ngôi Sao", "Quỹ Đạo", "Tinh Đồ", "Chòm Sao", "Tinh Cung", "Thuật Chiêm Tinh"},
MAGIC_CLASSROOM_TEXT4 = [[<T C="255,200,10" S="22" P="1">Hướng dẫn hoạt động Giảng Đường Ma Thuật</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">1.</T><T C="255,255,255" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Có thể dùng Tinh Thạch Ma Thuật để rút thưởng Học Tập, Học Tập Kiểu Học Việc mỗi lần dùng 1 Tinh Thạch Ma Thuật, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Học Tập Miễn Phí 1 lần. Học Tập Kiểu Cao Thủ mỗi lần dùng 5 Tinh Thạch Ma Thuật, chắc chắn nhận 1 phần thưởng cao cấp;</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Khi học sẽ học theo thứ tự 6 nguyên tố Phong/Hỏa/Thủy/Băng/Lôi/Địa, cứ hoàn thành tiến độ học của 1 nguyên tố, có thể mở nguyên tố ma thuật tương ứng của Huy Chương Phù Thủy Ma Thuật;</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Mỗi khi mở 1 Nguyên Tố Phép sẽ nhận được một Mảnh Huy Chương Phù Thủy Ma Thuật, sau khi thu thập đủ 6 nguyên tố có thể ghép Huy Chương Phù Thủy Ma Thuật;</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Tích lũy học tập có xác suất nhận thêm phần thưởng học tập lớn!</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">2.</T><T C="255,255,255" S="20" P="0">Nhiệm Vụ Học Tập:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Chia thành Học Phép Thuật, Nghiên Cứu Phép Thuật, nhiệm vụ Học Phép Thuật mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Nghiên Cứu Phép Thuật trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">3.</T><T C="255,255,255" S="20" P="0">BXH Pháp Sư:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH Pháp Sư thống kê dựa trên EXP Phép Thuật, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="255,200,10" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],

PIANIST_TEXT1 = {"Diễn Tấu Piano", "Biểu Diễn Miễn Phí", "Diễn Tấu %d Lần", "Tiệm Nốt Nhạc", "Lịch Sử Biểu Diễn", "BXH Biểu Diễn", "Chung Tay Biểu Diễn", "Thưởng Nghệ Sĩ Piano", "Thưởng Có Chút Tiếng Tăm", "Thưởng Tân Binh Âm Nhạc", "Nốt Nhạc", "Biểu Diễn Hôm Nay", "Lịch Sử Biểu Diễn", "Biểu Diễn Hàng Ngày", "Bản Nhạc", "Bản Nhạc Tôi Dùng", "Toàn server rút thưởng đạt %d lần sẽ có thể nhận 1 phần quà", "Điểm Biểu Diễn"},
PIANIST_TEXT2 = [[<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Diễn Tấu Piano</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Bản Nhạc để rút thưởng Biểu Diễn, Biểu Diễn Piano Thường mỗi lần dùng 1 Bản Nhạc, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Biểu Diễn Miễn Phí 1 lần. Biểu Diễn Piano Sang Trọng mỗi lần dùng 5 Bản Nhạc, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi Ném Tên có xác suất nhận Nốt Nhạc, Nốt Nhạc có thể đổi thưởng quý giá tại Tiệm Nốt Nhạc!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy biểu diễn có xác suất nhận thêm phần thưởng biểu diễn lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Lịch Sử Biểu Diễn:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Biểu Diễn Hôm Nay, Lịch Sử Biểu Diễn, Biểu Diễn Hàng Ngày, nhiệm vụ Biểu Diễn Hôm Nay mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Lịch Sử Biểu Diễn và Biểu Diễn Hàng Ngày trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Biểu Diễn:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Biểu Diễn thống kê dựa trên số lượng Bản Nhạc đã tiêu hao, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],

BATTLE_HUD_TEXT5 = "Chọn đơn vị phe ta",
MAKE_SHOWMAN_TEXT1 = {"Đắp Người Tuyết", "Đắp Người Tuyết Miễn Phí", "Đắp Người Tuyết %d lần", "Nhiệm Vụ Người Tuyết", "BXH Hồi Ức", "Đắp Người Tuyết Toàn Server", "Hồi Ức Người Tuyết", "Thưởng Cao Thủ Đắp Người Tuyết", "Thưởng Người Tuyết-Lớn", "Thưởng Người Tuyết-Nhỏ", "Mảnh Ghép Hồi Ức Người Tuyết", "Tích lũy rút thưởng toàn server đạt %d lần có thể nhận 1 phần quà", "Trò Chơi Hôm Nay", "Nhật Ký Miền Tuyết", "BXH", "Mảnh Ghép Hồi Ức", "Hồi ức tôi nhận được", "Thưởng Hồi Ức", "Điểm", "Tốn Cầu Tuyết Đắp Người Tuyết đạt số lần chỉ định có thể nhận 1 Mảnh Ghép Hồi Ức, thu thập đủ 9 mảnh ghép có thể nhận 1 phần thưởng hồi ức (chắc chắn nhận được 1 trong số các phần thưởng đã chọn)", "Mảnh Hồi Ức Người Tuyết", "Chưa thu thập đủ Mảnh Ghép Hồi Ức", "Đắp Người Tuyết mỗi ngày"},
MAKE_SHOWMAN_TEXT2 = [[<T C="255,200,10" S="22" P="1">Hướng dẫn hoạt động Đắp Người Tuyết</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">1.</T><T C="255,255,255" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Có thể dùng Cầu Tuyết để rút thưởng Đắp Người Tuyết, Đắp Người Tuyết Thường mỗi lần dùng 1 Cầu Tuyết, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Đắp Người Tuyết Miễn Phí 1 lần. Đắp Người Tuyết Tinh Xảo mỗi lần dùng 5 Cầu Tuyết, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Khi Ném Tên có xác suất nhận Mảnh Ghép Hồi Ức, mỗi khi thu thập đủ 9 Mảnh Ghép Hồi Ức sẽ nhận được Thưởng Hồi Ức Người Tuyết, Thưởng Hồi Ức là thưởng tự chọn!</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Tích lũy Đắp Người Tuyết có xác suất nhận thêm Thưởng Lớn Đắp Người Tuyết!</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">2.</T><T C="255,255,255" S="20" P="0">Nhiệm Vụ Người Tuyết:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Chia thành Trò Chơi Hôm Nay, Nhật Ký Miền Tuyết, Đắp Người Tuyết Mỗi Ngày, nhiệm vụ Trò Chơi Hôm Nay mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Nhật Ký Miền Tuyết và Đắp Người Tuyết Mỗi Ngày trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">3.</T><T C="255,255,255" S="20" P="0">BXH Hồi Ức:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH Hồi Ức thống kê dựa trên số lượng Mảnh Ghép Hồi Ức đã nhận, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="255,200,10" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
FRIEND_TOP_TEXT1 = "Ghim bạn bè",
FRIEND_TOP_TEXT2 = "Chọn bạn bè muốn ghim",
CERAMIC_WORKSHOP_TEXT1 = {"Xưởng Gốm", "Làm Gốm Miễn Phí", "Làm Gốm %d lần", "Nung Gốm Miễn Phí", "Nung Gốm %d lần", "Thưởng Bậc Thầy Gốm Sứ", "Thưởng Lớn Làm Gốm", "Thưởng Nhỏ Làm Gốm", "Nhiệm Vụ Làm Gốm", "BXH", "Làm Gốm Mỗi Ngày", "Nhiệm Vụ Làm Gốm", "BXH Làm Gốm", "EXP Làm Gốm", "EXP Làm Gốm Của Tôi", "Cấp Làm Gốm", "EXP Làm Gốm", "EXP Làm Gốm Của Tôi", "Hỏa Lực", "Dùng thêm %s Đất Sét bắt đầu Nung Gốm\n(Khi Nung Gốm có thể nhận Thưởng gấp %s lần)"},
CERAMIC_WORKSHOP_TEXT2 = {"Chưa nhập môn", "Người mới học Làm Gốm", "Người Làm Gốm Lành Nghề", "Chuyên Gia Lò Nung", "Chuyên Gia Gốm Sứ", "Bậc Thầy Đồ Gốm"},
CERAMIC_WORKSHOP_TEXT3 = [[<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Đồ Gốm</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Đất Sét để rút thưởng Làm Gốm, Làm Gốm Thô Sơ mỗi lần dùng 1 Đất Sét, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Làm Gốm Miễn Phí 1 lần. Làm Gốm Tinh Xảo mỗi lần dùng 5 Đất Sét, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Làm Gốm đạt số lần nhất định sẽ bắt đầu đem nung, khi nung có thể nhận thưởng x3, đồng thời tích lũy Hỏa Lực. Hỏa Lực đầy sẽ kết thúc việc nung!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy làm gốm có xác suất nhận thêm phần thưởng làm gốm lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Đồ Gốm:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Làm Gốm Hôm Nay, Nhiệm Vụ Làm Gốm, nhiệm vụ Làm Gốm Hôm Nay mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm Vụ Làm Gốm trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Làm Gốm:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Làm Gốm thống kê dựa trên EXP Làm Gốm đã nhận, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
WEIGHTLIFTING_TEXT1 = {"Giải Đấu Cử Tạ", "Cử Tạ Miễn Phí", "Cử Tạ %d lần", "Điểm", "Tiệm Huy Chương", "Nhật ký Cử Tạ", "BXH Cử Tạ", "Huy Chương", "Thần Sức Mạnh", "Thưởng Cử Tạ-Lớn", "Thưởng Cử Tạ-Nhỏ", "Cử Tạ Hôm Nay", "Nhật Ký Cử Tạ", "Cử Tạ Mỗi Ngày", "Huy Chương của tôi", "Cử Tạ Hạng Nhẹ", "Cử Tạ Hạng Nặng"},
WEIGHTLIFTING_TEXT2 = [[<T C="255,200,10" S="22" P="1">Hướng dẫn hoạt động Cử Tạ</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">1.</T><T C="255,255,255" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Có thể dùng Trang Phục Cử Tạ để rút thưởng Cử Tạ, Cử Tạ Hạng Nhẹ mỗi lần dùng 1 Trang Phục Cử Tạ, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Cử Tạ Miễn Phí 1 lần. Cử Tạ Hạng Nặng mỗi lần dùng 5 Trang Phục Cử Tạ, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Khi Cử Tạ có xác suất Nhận Huy Chương, Huy Chương có thể đổi thưởng quý giá tại Tiệm Cử Tạ!</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Tích lũy cử tạ có xác suất nhận thêm phần thưởng cử tạ lớn!</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">2.</T><T C="255,255,255" S="20" P="0">Nhật ký Cử Tạ:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Chia thành Cử Tạ Hôm Nay, Nhật Ký Cử Tạ, Cử Tạ Mỗi Ngày, nhiệm vụ Cử Tạ Hôm Nay mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Nhật Ký Cử Tạ và Cử Tạ Mỗi Ngày trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">3.</T><T C="255,255,255" S="20" P="0">BXH Huy Chương:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH Cử Tạ thống kê dựa trên số lượng Huy Chương đã nhận, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="255,200,10" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],

ARCTIC_EXPLORATION_TEXT1 = {"Thám Hiểm Cánh Đồng Tuyết", "Thám Hiểm Miễn Phí", "Thám Hiểm %d lần", "Nhiệm Vụ Thám Hiểm", "BXH Thám Hiểm", "Cùng Thám Hiểm", "Thưởng Chuyên Gia Cực Địa", "Thưởng Nhà Thám Hiểm", "Thưởng Tân Thủ Thám Hiểm", "Toàn server tích lũy Thám Hiểm đạt %d lần có thể nhận 1 phần quà", "Thám Hiểm Mỗi Ngày", "Nhiệm Vụ Thám Hiểm", "BXH Thám Hiểm", "Vật Tư Thám Hiểm", "Vật Tư Thám Hiểm Tốn", "Bản Đồ Thám Hiểm", "Tốn Vật Tư Thám Hiểm để thám hiểm đạt số lần chỉ định có thể mở địa điểm thám hiểm, hoàn thành thám hiểm 5 địa điểm có thể nhận 1 phần thưởng Thám Hiểm (chắc chắn nhận được một trong các phần thưởng đã chọn)", "Quà Bản Đồ Thám Hiểm", "Mục Tiêu Thám Hiểm"},
ARCTIC_EXPLORATION_TEXT2 = [[<T C="255,200,10" S="22" P="1">Hướng dẫn hoạt động Thám Hiểm Miền Tuyết</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">1.</T><T C="255,255,255" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Có thể dùng Vật Tư Thám Hiểm để rút thưởng Thám Hiểm, Thám Hiểm Đi Bộ mỗi lần dùng 1 Vật Tư Thám Hiểm, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Thám Hiểm Miễn Phí 1 lần. Thám Hiểm Xe Trượt Tuyết mỗi lần dùng 5 Vật Tư Thám Hiểm, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Khi Thám Hiểm có xác suất hoàn thành Mục Tiêu Thám Hiểm, mỗi vòng có 5 Mục Tiêu Thám Hiểm. Mỗi khi hoàn thành 1 vòng Thám Hiểm sẽ nhận được 1 Thưởng Lớn Bản Đồ Thám Hiểm (nếu đã chọn thưởng trước thì chắc chắn nhận đúng thưởng đã chọn)!</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Tích lũy Thám Hiểm có xác suất nhận thêm Thưởng Lớn Thám Hiểm!</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">2.</T><T C="255,255,255" S="20" P="0">Nhiệm Vụ Thám Hiểm:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Chia thành Thám Hiểm Mỗi Ngày, Nhật Ký Thám Hiểm, nhiệm vụ Thám Hiểm Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Nhật Ký Thám Hiểm trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">3.</T><T C="255,255,255" S="20" P="0">BXH Thám Hiểm:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH Thám Hiểm thống kê dựa trên vật tư Thám Hiểm đã tiêu hao, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="255,200,10" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
BUILDING_BLOCKS_TEXT1 = {"Lắp Ghép Khối", "Lắp Ghép Miễn Phí", "Lắp Ghép %d lần", "Nhiệm Vụ Khối Lắp Ghép", "Khối Lắp Ghép Vợ Chồng", "BXH Lắp Ghép", "Cấp Khối Lắp Ghép", "Lắp Ghép Mỗi Ngày", "Vợ Chồng Mạnh Nhất", "Thưởng Bậc Thầy Thủ Công", "Thưởng Lắp Ghép-Lớn", "Thưởng Lắp Ghép-Nhỏ", "EXP Khối Lắp Ghép", "EXP Khối Lắp Ghép của tôi", "Thưởng BXH Vợ Chồng Mạnh Nhất", "Hạng Vợ Chồng của tôi", "Hạng", "Người chơi", "Khối Lắp Ghép Tốn", "Khối Lắp Ghép tôi tốn", "Khối Lắp Ghép Thường", "Khối Lắp Ghép Tinh Xảo"},
BUILDING_BLOCKS_TEXT2 = [[<T C="229,105,22" S="22" P="1">Hướng dẫn Lắp Ghép Khối</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Khối Lắp Ghép để rút thưởng Lắp Ghép, Lắp Ghép Khối Thường mỗi lần dùng 1 Khối Lắp Ghép, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Lắp Ghép Miễn Phí 1 lần. Lắp Ghép Khối Tinh Xảo mỗi lần dùng 5 Khối Lắp Ghép, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Lắp Ghép có xác suất nhận thêm phần thưởng Lắp Ghép lớn!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Vợ Chồng Lắp Ghép: Là nhiệm vụ Vợ Chồng và BXH Vợ Chồng Mạnh Nhất, nhiệm vụ Vợ Chồng có thể do Vợ Chồng cùng hoàn thành và nhận thưởng; BXH Vợ Chồng Mạnh Nhất tính toán dựa trên số Khối Lắp Ghép Vợ Chồng tiêu hao, Vợ Chồng top 20 có thể nhận thưởng, sau khi hoạt động kết thúc sẽ tự động phát qua thư hệ thống;</T><BR>10</BR>
<T C="229,105,22" S="20" P="1">Khi có nhiều lịch sử trên BXH Vợ Chồng Mạnh Nhất thì chỉ nhận được thưởng của lịch sử có hạng cao nhất.</T><BR>10</BR>
<T C="229,105,22" S="20" P="1">Chú ý: Nếu ly hôn giữa chừng và kết hôn với người khác, số Khối Lắp Ghép tích lũy cá nhân trong hôn nhân cũ vẫn giữ nguyên. Số Khối Lắp Ghép đã tiêu hao trong thời gian hôn nhân cũ sẽ không được tính vào nhật ký của hôn nhân mới.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Lắp Ghép:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Lắp Ghép Mỗi Ngày, Nhiệm Vụ Lắp Ghép, nhiệm vụ Lắp Ghép Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm Vụ Lắp Ghép trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Lắp Ghép:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Lắp Ghép thống kê dựa trên EXP Khối Lắp Ghép đã nhận, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
BUILDING_BLOCKS_TEXT3 = {"Bình Địa", "Nhà Khối Lắp Ghép", "Khối Lắp Ghép Lầu", "Khối Lắp Ghép Tháp", "Khối Lắp Ghép Trang Viên", "Khối Lắp Ghép Lâu Đài"},
BATTLE_TEXT1 = {"Chặn kẻ địch phát ngôn", "Chặn đồng đội phát ngôn"},
CASTING_MASTER_ACTIVITY_TEXT1 = {"Thợ Rèn Kiếm Tài Ba", "Phụ Ma Miễn Phí", "Phụ Ma %d lần", "Nhiệm Vụ Rèn Kiếm", "Vợ Chồng Rèn Kiếm", "BXH Thần Rèn", "Rèn Kiếm Mỗi Ngày", "Bậc Thầy Rèn Kiếm", "Số Kiếm Thần", "Số Kiếm Thần của tôi", "Nhiệm Vụ Rèn Kiếm", "BXH Vợ Chồng Rèn Kiếm", "Thưởng BXH Vợ Chồng", "Hạng Vợ Chồng", "Vợ Chồng", "Linh Khí Vợ Chồng Rèn Kiếm", "Linh Khí Rèn Kiếm của tôi", "Hạng Vợ Chồng của tôi", "Kho Thưởng Thợ Thần", "Kho Thưởng Đại Tông Sư", "Kho Thưởng Bách Luyện", "Chú Kiếm Các", "Linh Khí", "Huy Chương Rèn Kiếm", "Được nhận thưởng thêm", "Nhiệm Vụ Kiếm Linh", "Đã tính giờ", "Thưởng thêm", "%s%s*%d vật phẩm đã đạt giới hạn, không thể chọn", "Phụ Linh %s lần", "Số Kiếm Thần"},
CASTING_MASTER_ACTIVITY_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn Thợ Rèn Kiếm Tài Ba</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Búa Rèn Kiếm để rút thưởng Rèn Kiếm, Rèn Kiếm Phụ Ma mỗi lần dùng 1 Búa Rèn Kiếm, chắc chắn nhận 1 phần thưởng thường và 2 điểm Linh Khí Rèn Kiếm. Mỗi ngày đăng nhập trò chơi có thể Rèn Kiếm Miễn Phí 1 lần. Rèn Kiếm Phụ Linh mỗi lần dùng 5 Búa Rèn Kiếm và 10 điểm Linh Khí Rèn Kiếm, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Rèn Kiếm chia ra 6 giai đoạn gồm Trúc, Dã, Phù, Lật, Đoạn, Đào, cứ hoàn thành 1 giai đoạn có thể nhận 1 phần thưởng thêm</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy rèn kiếm có xác suất nhận thêm phần thưởng đúc kiếm lớn!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Vợ Chồng Rèn Kiếm: Là Rèn Kiếm Vợ Chồng và BXH Vợ Chồng Rèn Kiếm, nhiệm vụ Rèn Kiếm Vợ Chồng có thể do Vợ Chồng cùng hoàn thành và nhận thưởng; BXH Vợ Chồng Rèn Kiếm tính toán dựa trên Linh Khí Rèn Kiếm Vợ Chồng nhận được, Vợ Chồng top 20 có thể nhận thưởng, sau khi hoạt động kết thúc sẽ tự động phát qua thư hệ thống;</T><BR>10</BR>
<T C="229,105,22" S="20" P="1">Khi có nhiều lịch sử trên BXH Vợ Chồng Mạnh Nhất thì chỉ nhận được thưởng của lịch sử có hạng cao nhất.</T><BR>10</BR>
<T C="229,105,22" S="20" P="1">Chú ý: Nếu ly hôn giữa chừng và kết hôn với người khác, số Búa Rèn Kiếm tích lũy cá nhân trong hôn nhân cũ vẫn giữ nguyên. Số Búa Rèn Kiếm đã tiêu hao trong thời gian hôn nhân cũ sẽ không được tính vào nhật ký của hôn nhân mới.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Rèn Kiếm:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Rèn Kiếm Mỗi Ngày, Rèn Kiếm Bậc Thầy, nhiệm vụ Rèn Kiếm Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Rèn Kiếm Bậc Thầy trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Kiếm Linh:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">12:00-23:00 mỗi ngày mở, khi mở có thể hoàn thành nhiệm vụ Kiếm Linh, cứ 10 phút tạo mới 1 lần nhiệm vụ;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Thần Rèn:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Rèn Kiếm thống kê dựa trên EXP Búa Rèn Kiếm đã nhận, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
BOATING_LAKE_TEXT1 = {"Thả Thuyền Dạo Hồ", "Dạo Hồ Miễn Phí", "Dạo Hồ %d lần", "Phong Cảnh Dạo Hồ", "BXH Dạo Hồ", "Cùng Thả Thuyền", "Thế Ngoại Đào Nguyên", "Non Xanh Nước Biếc", "Hoa Nở Rực Rỡ", "Dạo Hồ Hôm Nay", "Phong Cảnh Dạo Hồ", "Dạo Hồ Mỗi Ngày", "Vé Tàu", "Vé Tàu Tôi Tốn", "Điểm", "Toàn server tích lũy rút thưởng đạt %d lần có thể nhận 1 phần quà"},
BOATING_LAKE_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn Thả Thuyền Dạo Hồ</T><BR>10</BR>
<T C="255,150,16" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Vé Tàu để rút thưởng Dạo Hồ, Dạo Hồ Thuyền Nhỏ mỗi lần dùng 1 Vé Tàu, chắc chắn nhận 1 phần thưởng thường và 2 điểm EXP Dạo Hồ. Mỗi ngày đăng nhập trò chơi có thể Dạo Hồ Miễn Phí 1 lần. Dạo Hồ Thuyền Hoa mỗi lần dùng 5 Vé Tàu và 10 điểm EXP Dạo Hồ, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy dạo hồ có xác suất nhận thêm phần thưởng dạo hồ lớn!</T><BR>10</BR>
<T C="255,150,16" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Phong Cảnh Dạo Hồ:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Dạo Hồ Hôm Nay, Cảnh Sắc Dạo Hồ và Dạo Hồ Mỗi Ngày, nhiệm vụ Dạo Hồ Hôm Nay mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Cảnh Sắc Dạo Hồ và Dạo Hồ Mỗi Ngày trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="255,150,16" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Dạo Hồ:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Dạo Hồ thống kê dựa trên số lượng Vé Tàu đã tiêu hao, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="255,150,16" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
BLOW_BUBBLES_TEXT1 = {"Thổi Bong Bóng", "Thổi Bong Bóng Miễn Phí", "Thổi Bong Bóng %s lần", "Tiệm Thổi Bong Bóng", "Mục Tiêu Thổi Bong Bóng", "BXH Bong Bóng", "Quà Đăng Nhập", "Thưởng Bong Bóng Mộng Ảo", "Thưởng Bong Bóng-Lớn", "Thưởng Bong Bóng-Nhỏ", "Bong Bóng Sắc Màu", "Thổi Bong Bóng Mỗi Ngày", "Nhật Ký Thổi Bong Bóng", "Thổi Bong Bóng Mỗi Ngày", "Bong Bóng Sắc Màu Tôi Nhận"},
BLOW_BUBBLES_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn Thổi Bong Bóng</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">1.</T><T C="255,255,255" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Có thể dùng Nước Bong Bóng để rút thưởng Thổi Bong Bóng, Gậy Thổi Bong Bóng mỗi lần dùng 1 Nước Bong Bóng, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Thổi Bong Bóng Miễn Phí 1 lần. Máy Thổi Bong Bóng mỗi lần dùng 5 Nước Bong Bóng, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Khi Thổi Bong Bóng có xác suất nhận Bong Bóng Sắc Màu, Bong Bóng Sắc Màu có thể đổi thưởng quý giá tại Tiệm Thổi Bong Bóng!</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Tích lũy Thổi Bong Bóng có xác suất nhận thêm Thưởng Lớn Thổi Bong Bóng!</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">2.</T><T C="255,255,255" S="20" P="0">Mục tiêu Thổi Bong Bóng:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">Chia thành Thổi Bong Bóng Mỗi Ngày, Nhật Ký Thổi Bong Bóng, Thổi Bong Bóng Mỗi Ngày, nhiệm vụ Thổi Bong Bóng Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Nhật Ký Thổi Bong Bóng và Thổi Bong Bóng Mỗi Ngày trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="255,200,10" S="20" P="0">3.</T><T C="255,255,255" S="20" P="0">BXH Bong Bóng:</T><BR>10</BR>
<T C="255,255,255" S="20" P="0">BXH Bong Bóng thống kê dựa trên số lượng Bong Bóng Sắc Màu đã nhận, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="255,200,10" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
PICKTEA_TEXT1 = {"Cùng Nhau Hái Trà", "Nhiệm Vụ Hái Trà", "BXH Trà Đạo", "Hái Trà Vườn Trà", "Hái Trà Núi Cao", "Hái Trà Miễn Phí", "Hái Trà %d Lần", "Sổ Tay Hái Trà", "Toàn server hái trà đủ %d lần sẽ có thể nhận 1 phần thưởng", "Hái Trà Hôm Nay", "Nhiệm Vụ Hái Trà", "Thưởng Trà Thanh-Nhỏ", "Thưởng Trà Thanh-Lớn", "Thưởng Bậc Thầy Chế Trà", "Cấp Hái Trà", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó</T>]], {"Không có danh hiệu", "Học Việc Hái Trà", "Hái Trà Lành Nghề", "Nhập Môn Chế Trà", "Cao Thủ Chế Trà", "Bậc Thầy Chế Trà"}, "EXP Hái Trà", "Đang Hái Trà...", "Thưởng Tự Chọn", "Chọn 1 thưởng muốn nhận", "Chung Tay Hái Trà"},
PICKTEA_TEXT2 = [[
<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Cùng Nhau Hái Trà</T><BR>10</BR>
<T C="255,150,16" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Găng Tay Hái Trà để rút thưởng Hái Trà, Hái Trà Kéo Thủ Công mỗi lần dùng 1 Găng Tay Hái Trà, chắc chắn nhận 1 phần thưởng thường và 2 điểm EXP Hái Trà. Mỗi ngày đăng nhập trò chơi có thể Hái Trà Miễn Phí 1 lần. Hái Trà Bằng Tay mỗi lần dùng 5 Găng Tay Hái Trà và 10 điểm EXP Hái Trà, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần hái trà được ngẫu nhiên nhận trà, có 7 loại trà gồm Long Tỉnh, Bích Loa Xuân, Thiết Quan Âm, Đại Hồng Bào, Phổ Nhĩ, Kỳ Môn Hồng Trà, Bạch Hào Ngân Châm!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Nhận Lá Trà có thể đổi thưởng quý giá trong Sổ Tay Hái Trà, Thư Viện làm mới giới hạn mỗi ngày!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy hái trà có xác suất nhận thêm phần thưởng hái trà lớn!</T><BR>10</BR>
<T C="255,150,16" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Hái Trà:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Hái Trà Mỗi Ngày, Nhiệm Vụ Hái Trà, nhiệm vụ Hái Trà Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm Vụ Hái Trà trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="255,150,16" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Trà Đạo:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Hái Trà thống kê dựa trên EXP Hái Trà đã nhận, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="255,150,16" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
UNION_TEXT1 = {"Liên Minh", "Tạo Liên Minh", "Tên Liên Minh không được để trống", "Sảnh Liên Minh", "Rời Liên Minh", "Giới hạn vào", "Duyệt Liên Minh", "Cống hiến Liên Minh", "EXP Liên Minh", "Thông tin Liên Minh", "Xin vào Liên Minh", "Minh Chủ", "Phó Minh Chủ", "Tên Liên Minh", "Minh Chủ Liên Minh", "Số người Liên Minh", "Nhấn nhập ID Liên Minh", "Cấp nhân vật vào", "Lực chiến nhân vật vào", "Cấp VIP nhân vật vào", "Cấp Liên Minh hiện tại có thể bổ nhiệm %s chức:", "Liên Minh mục tiêu cần cấp người chơi đạt %s", "Liên Minh mục tiêu cần cấp VIP người chơi đạt %s", "Số người Liên Minh mục tiêu đã đầy, gia nhập thất bại", "Đã gửi thông tin xin vào Liên Minh", "Chức", "Chuyển nhượng Minh Chủ", "Thiết lập lực chiến người chơi phải >= 0", "Thiết lập lực chiến người chơi phải <= %", "Số người Liên Minh đã đầy, không thể gia nhập Liên Minh", "BXH Liên Minh", "Cấp chưa đạt %d không thể tạo Liên Minh", "VIP chưa đạt %d không thể tạo Liên Minh", "Lực chiến chưa đạt %d không thể tạo Liên Minh", "Tên vượt quá 7 ký tự", "Tên ít hơn 2 ký tự", "Vui lòng nhập ID Liên Minh", "Chỗ ID Liên Minh chỉ được là số", "Liên Minh mục tiêu cần lực chiến người chơi đạt %s", [[<T S="20" C="127,70,26" P="1">Cấp NV: </T><T S="20" C="229,105,22" P="1">%d</T><BR>2</BR><T S="20" C="127,70,26" P="1">Cấp VIP: </T><T S="20" C="229,105,22" P="1">%d</T><BR>2</BR><T S="20" C="127,70,26" P="1">Lực chiến: </T><T S="20" C="229,105,22" P="1">%d</T>]], [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22" P="0">đã gia nhập Liên Minh</T>]], [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22">đã rời Liên Minh</T>]], [[<T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22">đã đuổi</T><T S="20" C="255,236,193" P="0">%s</T><T S="20" C="229,105,22" P="0">ra khỏi Liên Minh</T>]], "Liên Minh Của Tôi", "Có chắc muốn rời Liên Minh không,\nLiên Minh sẽ bị giải tán ", "Rời Liên Minh sẽ xóa Cống hiến Liên Minh,\nChắc chắn rời Liên Minh?", "Vui lòng chuyển nhượng Minh Chủ trước", "Chắc chắn muốn trục xuất thành viên đã chọn khỏi Liên Minh không?", "Chưa vào Liên Minh", "[Liên Minh]"},
JEWELRY_TEXT1 = {"Bậc Thầy Trang Sức", "Nhiệm Vụ Chế Tạo", "BXH Trang Sức", "Đá Thô", "Đá Lấp Lánh", "Chế Tạo Miễn Phí", "Chế tạo %d lần", "Set Trang Sức", "Người chơi toàn server tích lũy chế tạo %d lần, có thể nhận 1 phần thưởng", "Chế Tạo Mỗi Ngày", "Mục tiêu chế tạo", "Thưởng Bước Đầu Nhập Môn", "Thưởng Lên Trình Thành Thạo", "Thưởng Nghệ Thuật Tinh Xảo", "Thưởng Set", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn sẽ nhận được thưởng đó</T>]], "Tốn Khối Đá chế tạo đạt số lượng chỉ định có thể hoàn thành 1 món Trang Sức, hoàn thành 5 món Trang Sức có thể nhận 1 phần thưởng Set Trang Sức (chắc chắn nhận được một trong các phần thưởng đã chọn)", "Số Trang Sức", "Đang chế tạo...", "Thưởng Tự Chọn", "Hãy chọn 1 phần thưởng mình cần", "Cùng chế tạo"},
JEWELRY_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Bậc Thầy Trang Sức</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="229,105,22" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Khối Đá để rút thưởng Chế Tạo, Chế Tạo Đá Thô mỗi lần dùng 1 Khối Đá, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Chế Tạo Miễn Phí 1 lần. Chế Tạo Đá Lấp Lánh mỗi lần dùng 5 Khối Đá, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi chế tạo có xác suất hoàn thành chế tạo Trang Sức, Trang Sức chia ra 5 món gồm Cài Tóc/Hoa Tai/Dây/Vòng Tay/Nhẫn, hoàn thành chế tạo 5 món Trang Sức có thể nhận thưởng Set Trang Sức!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy chế tạo có xác suất nhận thêm phần thưởng chế tạo lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="229,105,22" S="20" P="0">Nhiệm Vụ Chế Tạo:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Chế Tạo Mỗi Ngày, Nhiệm Vụ Mục Tiêu Chế Tạo, nhiệm vụ Chế Tạo Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Mục Tiêu Chế Tạo trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="229,105,22" S="20" P="0">BXH Trang Sức:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Trang Sức thống kê dựa trên số lượng Trang Sức chế tác hoàn thành, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
AFFORESTATION_TEXT1 = {"Trồng Cây Gây Rừng", "Trồng Cây Miễn Phí", "Trồng Cây %d lần", "EXP Trồng Cây", "Khắc Tinh Sa Mạc", "Thưởng Trồng Cây-Lớn", "Thưởng Trồng Cây-Nhỏ", "Nhiệm Vụ Trồng Cây", "Liên Minh Trồng Cây", "BXH Trồng Cây", "Hôm Nay Trồng Cây", "Nhật Ký Trồng Cây", "Mỗi Ngày Trồng Cây", "Cuốc", "Cuốc tốn", "Rừng Liên Minh", "Nhiệm Vụ Liên Minh", "BXH Trồng Cây Liên Minh", "Tổng số Cây Trồng Liên Minh", "Số Cây Trồng Cá Nhân", "Điểm Trồng Cây", "Thưởng hiện tại", "Hạng Liên Minh", "Liên Minh", "Điểm Trồng Cây của tôi", "Chỉ hiển thị top %d Liên Minh", "Số Cây Trồng", "Hôm nay đã nhận", "Chưa vào Liên Minh, không thể tham gia cách chơi Liên Minh","Liên Minh trồng tổng cộng đạt %s cây, thành viên Liên Minh mỗi ngày có thể nhận"},
AFFORESTATION_TEXT2 = [[
<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Trồng Cây Gây Rừng</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Cuốc để rút thưởng Trồng Cây, Trồng Cây Dinh Dưỡng Thường mỗi lần dùng 1 Cuốc, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Trồng Cây Miễn Phí 1 lần. Trồng Cây Dinh Dưỡng Cao Cấp mỗi lần dùng 5 Cuốc, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy trồng cây có xác suất nhận thêm phần thưởng trồng cây lớn!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Liên Minh Trồng Cây: Là Rừng Liên Minh, Nhiệm Vụ Liên Minh và BXH Liên Minh Trồng Cây; Sau khi tổng số Trồng Cây Liên Minh đạt mốc nhất định, tất cả thành viên trong Liên Minh mỗi ngày đều có thể nhận 1 phần thưởng trong Rừng Liên Minh, phần thưởng thay đổi theo tổng số Trồng Cây Liên Minh; Nhiệm Vụ Liên Minh có thể do thành viên Liên Minh cùng hoàn thành và nhận thưởng; BXH Liên Minh Trồng Cây tính toán dựa trên điểm Trồng Cây nhận được trong Liên Minh, Liên Minh top 10 có thể nhận thưởng, sau khi hoạt động kết thúc sẽ tự động phát qua thư hệ thống;</T><BR>10</BR>
<T C="229,105,22" S="20" P="1">Chú ý: Trong BXH Trồng Cây Liên Minh, người chơi cùng một Liên Minh cần tham gia hoạt động tạo ra tối thiểu 1 điểm Cuốc thì khi tổng kết mới có thể nhận thưởng.</T><BR>10</BR>
<T C="229,105,22" S="20" P="1">Chú ý: Nếu thành viên Liên Minh giữa chừng thoát Liên Minh cũ để đến Liên Minh mới, thì số cây trồng và điểm trồng cây cá nhân tích lũy ở Liên Minh cũ sẽ không đổi, số cây trồng và điểm trồng cây của Liên Minh cũ không tính vào Liên Minh mới vào.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Trồng Cây:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Trồng Cây Mỗi Ngày, Nhật Ký Trồng Cây và Trồng Cây Mỗi Ngày, nhiệm vụ Trồng Cây Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Nhật Ký Trồng Cây và Trồng Cây Mỗi Ngày trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Trồng Cây:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Trồng Cây thống kê dựa trên số lượng Cuốc đã tiêu hao, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
AFFORESTATION_TEXT3 = {"Không có danh hiệu","Người mới trồng cây","Cao thủ trồng cây","Tiểu tướng trồng cây","Chuyên gia trồng cây","Tay Rừng"},
POTIONS_REFININ_TEXT1 = {"Luyện Chế Ma Dược", "Luyện Chế Miễn Phí", "Luyện chế %d lần", "Luyện Ma Dược", "Nhiệm Vụ Ma Dược", "BXH Dược Sư", "Thuốc Hỗn Hợp", "Thuốc Trị Liệu-Cao", "Đá Phép Thuật", "Thuốc Biến Hình", "Thuốc Trị Liệu-Sơ", "Hôm Nay Chế Thuốc", "Chế Thuốc Lâu Dài", "Điểm Chế Thuốc", "Điểm Chế Thuốc Của Tôi", "Vui lòng đặt đạo cụ vào mỗi ô trước!"},
POTIONS_REFININ_TEXT2 = [[<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Luyện Chế Ma Dược</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Tinh Hoa Ma Dược để rút thưởng Luyện Chế, Luyện Chế Thường mỗi lần dùng 1 Tinh Hoa Ma Dược, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Luyện Chế Miễn Phí 1 lần. Luyện Chế Cao Cấp mỗi lần dùng 5 Tinh Hoa Ma Dược, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi luyện chế có xác suất nhận Thuốc Trị Liệu-Sơ và Thuốc Biến Hình, luyện Thuốc Trị Liệu-Sơ và Thuốc Biến Hình có thể nhận Thuốc Trị Liệu-Cao và Thuốc Hỗn Hợp!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy luyện chế có xác suất nhận thêm phần thưởng luyện chế lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Luyện Chế:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Chế Thuốc Hôm Nay, Chế Thuốc Dài Hạn, nhiệm vụ Chế Thuốc Hôm Nay mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Chế Thuốc Dài Hạn trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Dược Sư:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Dược Sư thống kê dựa trên Điểm Chế Thuốc đã nhận, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
POTIONS_REFININ_TEXT3 = [[<T C="255,150,16" S="22" P="1">Hướng dẫn luyện Thuốc Ma</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Thuốc Trị Liệu-Sơ và Thuốc Biến Hình có thể luyện thành Thuốc Trị Liệu-Cao và Thuốc Hỗn Hợp, sau khi luyện có thể nhận Thưởng Lớn Tự Chọn:</T><BR>10</BR>
]],
PEOPLE_SHOP_TEXT25 = "Trong giỏ hàng đang có vật phẩm, vui lòng làm trống giỏ hàng trước",
PEOPLE_SHOP_TEXT26 = "Làm mới hàng hóa thành công",
UNION_TEXT2 = {"Xác nhận chuyển nhượng Minh Chủ?\nBạn sẽ trao đổi chức với mục tiêu chuyển nhượng chứ!", "Người chơi này chưa đạt Lv%d không thể chuyển nhượng", "Người chơi này chưa đạt VIP%d không thể chuyển nhượng", "Lực chiến người chơi này chưa đạt %d không thể chuyển nhượng", "Đã đảm nhận chức Minh Chủ thành công", "%s mời bạn vào Liên Minh %s này", [[<T S="20" C="229,105,22" P="0">Liên Minh</T><T S="20" C="229,105,22" P="0">Tăng đến</T><T S="20" C="229,105,22" P="0">Lv%d</T>]], "Minh Hữu", "Duyệt Minh Hữu", "Xóa Minh Hữu"},
UNION_TEXT3 = [[
<T C="229,105,22" S="22" P="1">Điều kiện lập Liên Minh</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="229,105,22" S="20" P="0">Cấp VIP: %d </T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="229,105,22" S="20" P="0">Cấp nhân vật: Lv%d</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="229,105,22" S="20" P="0">Lực chiến nhân vật: %d</T><BR>10</BR>
]],
RABBIT_GIFT_TEXT1 = {"Thỏ Phúc Tặng Quà", "Ban Phúc Miễn Phí", "Ban Phúc %d Lần", "BXH Ban Phúc", "Nhiệm Vụ Ban Phúc", "Cửa Hàng Thỏ Phúc", "Điểm Ban Phúc", "Thỏ Phúc Ban Duyên", "Báu Vật Trời Ban", "Xu Thỏ Phúc", "Xu Thỏ Phúc Của Tôi", "Ban Phúc Mỗi Ngày", "Nhiệm Vụ Ban Phúc", "Xu Thỏ Phúc", "Xu Thỏ Phúc Của Tôi", "Cà Rốt Ma Thuật", "[1-100] lần chắc chắn nhận được đạo cụ đã chọn trong Điều Ước", "Chọn Điều Ước", "Rương Thỏ Phúc-Bạc", "Rương Thỏ Phúc-Vàng", "[70-100] lần chắc chắn nhận được đạo cụ đã chọn trong Điều Ước"},
RABBIT_GIFT_TEXT2 = [[<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Thỏ Phúc Tặng Quà</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tiêu hao Xu Thỏ Phúc để rút thưởng Ban Phúc. Ước Nguyện Xu Bạc mỗi lần tiêu hao 1 Xu Thỏ Phúc, chắc chắn nhận được 1 phần thưởng thường và 2 điểm Ban Phúc. Mỗi ngày đăng nhập game được Ban Phúc miễn phí 1 lần. Ước Nguyện Xu Vàng mỗi lần tiêu hao 5 Xu Thỏ Phúc, chắc chắn nhận được 1 phần thưởng cao cấp và 10 điểm Ban Phúc:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Ước Nguyện Xu Bạc và Ước Nguyện Xu Vàng có kho thưởng [Chọn Điều Ước] riêng biệt, cần đạt số lần Ban Phúc khác nhau mới nhận được Thưởng Điều Ước, số lần Ban Phúc của hai loại không cộng dồn</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Ước Nguyện Xu Bạc trong 1-100 lần chắc chắn nhận Thưởng Chọn Điều Ước; Ước Nguyện Xu Vàng trong 70-100 lần chắc chắn nhận Thưởng Chọn Điều Ước; nếu chưa chọn thưởng thì sẽ ngẫu nhiên nhận 1 phần thưởng trong kho</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi Ban Phúc có xác suất nhận được Cà Rốt Ma Thuật, có thể dùng tại Cửa Hàng Thỏ Phúc để đổi vật phẩm quý hiếm!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Ban Phúc có cơ hội nhận thêm thưởng Báu Vật Trời Ban, Thỏ Phúc Ban Duyên!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Ban Phúc:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Ban Phúc Mỗi Ngày, Nhiệm Vụ Ban Phúc, nhiệm vụ Ban Phúc Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Nhiệm Vụ Ban Phúc trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Ban Phúc:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Ban Phúc thống kê dựa trên số lượng Xu Thỏ Phúc đã tiêu hao, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
BRAVING_TOWER_TEXT1 = {"Xông Pha Tháp Cao", "Leo Tháp Miễn Phí", "Leo Tháp %s Lần", "Thay Đổi Thưởng Lớn", "Thưởng Số Vòng", "Vòng %s", "Tầng %s", "Vé Tháp Cao", "Vé Tháp Cao Của Tôi", "Thưởng Tăng Cấp", "Hãy chọn Thưởng Số Vòng trước", "Thưởng Đỉnh Tháp"},
BRAVING_TOWER_TEXT2 = [[<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Xông Pha Tháp Cao</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tiêu hao Vé Tháp Cao để leo tháp rút thưởng, mỗi lần leo tháp tiêu hao 1 Vé Tháp Cao, chắc chắn nhận được 1 phần thưởng thường;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tháp có tổng cộng 6 tầng, bắt đầu từ tầng 1, mỗi lần rút thưởng chỉ nhận được phần thưởng của tầng hiện tại;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần leo tháp có xác suất tăng cấp lên tầng tiếp theo, càng lên cao phần thưởng càng giá trị!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tầng 4, 5, 6 có thể tự chọn thay đổi nội dung thưởng tăng cấp. Khi đạt đỉnh tháp sẽ làm mới toàn bộ ô thưởng và quay về tầng 1.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Thưởng Số Vòng:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trước mỗi lần rút thưởng cần chọn thưởng số vòng. Mỗi lần leo lên đỉnh tháp được tính là 1 vòng, đạt 2, 3, 4 vòng sẽ nhận được thưởng tương ứng;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Leo Tháp thống kê dựa trên số lượng Vé Tháp Cao đã tiêu hao, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>]],
LUCKY_FLIP_TEXT1 = {"Lật Thẻ May Mắn", "Lật Miễn Phí", "Lật %s lần", "Số Lần Có Thể Nhận", "Thưởng Thu Thập", "Thưởng Hào Hoa", "Chọn Vật Phẩm Yêu Thích", "Dừng", "Không Có Lượt Nhận", "Thưởng Thu Thập Chưa Nhận", "Hãy nhận hết Rương Thưởng Thu Thập trước", "Đã lật toàn bộ thẻ, vui lòng làm mới", "Hãy chọn Thưởng Hào Hoa trước"},
LUCKY_FLIP_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Lật Thẻ May Mắn</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng Dẫn Lật Thẻ:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tiêu hao Thẻ May Mắn để lật thẻ rút thưởng, mỗi lần lật tiêu hao 2 Thẻ May Mắn:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi lật Thẻ May Mắn, sẽ ngẫu nhiên nhận 1 ký tự từ A-F và 1 số từ 1-6, kết hợp thành mã số để mở ô tương ứng và nhận thưởng! Mã số đã lật sẽ không bị trùng lặp;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mở thành công 1 hàng ngang hoặc 1 cột dọc gồm 6 ô sẽ nhận thêm Thưởng Thu Thập!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mở toàn bộ 36 ô trên bảng sẽ nhận được Thưởng Hào Hoa! Thưởng Hào Hoa cần chọn trước khi nhận;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Làm Mới Bảng:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi làm mới bảng, toàn bộ ô chưa mở và Thưởng Thu Thập sẽ được làm mới lại;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Làm mới bảng cần tiêu hao Kim Cương, mỗi ngày được làm mới miễn phí 1 lần;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Sau khi mở toàn bộ bảng, có thể làm mới miễn phí;</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
FLYINGCAR_TEXT1 = {"Đua Xe Tốc Độ", "Nhiệm Vụ Đua Tốc", "BXH Đua Tốc", "Đua Trong Server", "Đua Thế Giới", "Tăng Tốc Miễn Phí", "Tăng Tốc %d lần", "Hoàn thành 1 vòng sẽ nhận 1 phần thưởng (chắc chắn nhận 1 trong các thưởng đã chọn)", "Chọn Thưởng Chạy Vòng", "Đua Tốc Mỗi Ngày", "Nhiệm Vụ Tăng Tốc", "Thưởng Tân Thủ Tăng Tốc", "Thưởng Cao Thủ Đua Xe", "Thưởng Quán Quân Đua Xe", "Thưởng Chạy Vòng", [[<T C="229,105,22" S="22" P="1">Khi kích hoạt phần thưởng đã chọn sẵn, chắc chắn nhận được một trong các phần thưởng đó</T>]], "Đang đua...", "Điểm Đua Tốc", "Chọn Thưởng Chạy Vòng", "Tiêu Hao Đạo Cụ", "Toàn server tích lũy tăng tốc %d lần có thể nhận 1 phần thưởng", "Toàn Server Đua Xe"},
DRESS_SUIT_TEXT1 = {[[<T C="255,89,74" S="20" P="0">Thuộc tính cộng thêm bộ %s món (</T><T C="%s" S="20" P="0">%d</T><T C="255,89,74" S="20" P="0">/%d)</T>]], [[<T C="255,89,74" S="20" P="0">Bộ phận trang phục trẻ (</T><T C="%s" S="20" P="0">%d</T><T C="255,89,74" S="20" P="0">/%d)</T>]], "1. Bộ thời trang này có thể tăng bậc hay không;\n2. Thu thập đủ toàn bộ các bộ phận trong bộ trang phục (sở hữu vĩnh viễn).", "Vui lòng chọn trang phục để tăng bậc", "(Có thể tăng bậc)", "(Đã tăng bậc)", [[<T C="255,89,74" S="20" P="0">Thuộc tính cộng thêm bộ %s món</T>]]},
DRESS_SUIT_TEXT2 =
[[
<T C="229,105,22" S="20" P="1">Tăng bậc thời trang</T><BR></BR>        
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Một số thời trang có thể tăng bậc.</T><BR></BR>        
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Khi tăng bậc thời trang cần thu thập đủ bộ 3 món của thời trang đó với thời gian vĩnh viễn.</T><BR></BR>        
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Sau khi tăng bậc, thời trang sẽ thành phẩm chất Đỏ và nhận thêm các thuộc tính tăng bậc.</T><BR></BR>
]],
RABBIT_GIFT_TEXT1 = {"Thỏ Phúc Tặng Quà", "Ban Phúc Miễn Phí", "Ban Phúc %d Lần", "BXH Ban Phúc", "Nhiệm Vụ Ban Phúc", "Cửa Hàng Thỏ Phúc", "Điểm Ban Phúc", "Thỏ Phúc Ban Duyên", "Báu Vật Trời Ban", "Xu Thỏ Phúc", "Xu Thỏ Phúc Của Tôi", "Ban Phúc Mỗi Ngày", "Nhiệm Vụ Ban Phúc", "Xu Thỏ Phúc", "Xu Thỏ Phúc Của Tôi", "Cà Rốt Ma Thuật", "[1-100] lần chắc chắn nhận được đạo cụ đã chọn trong Điều Ước", "Chọn Điều Ước", "Rương Thỏ Phúc-Bạc", "Rương Thỏ Phúc-Vàng", "[70-100] lần chắc chắn nhận được đạo cụ đã chọn trong Điều Ước"},
RABBIT_GIFT_TEXT2 = [[<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Thỏ Phúc Tặng Quà</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tiêu hao Xu Thỏ Phúc để rút thưởng Ban Phúc. Ước Nguyện Xu Bạc mỗi lần tiêu hao 1 Xu Thỏ Phúc, chắc chắn nhận được 1 phần thưởng thường và 2 điểm Ban Phúc. Mỗi ngày đăng nhập game được Ban Phúc miễn phí 1 lần. Ước Nguyện Xu Vàng mỗi lần tiêu hao 5 Xu Thỏ Phúc, chắc chắn nhận được 1 phần thưởng cao cấp và 10 điểm Ban Phúc:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Ước Nguyện Xu Bạc và Ước Nguyện Xu Vàng có kho thưởng [Chọn Điều Ước] riêng biệt, cần đạt số lần Ban Phúc khác nhau mới nhận được Thưởng Điều Ước, số lần Ban Phúc của hai loại không cộng dồn</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Ước Nguyện Xu Bạc trong 1-100 lần chắc chắn nhận Thưởng Chọn Điều Ước; Ước Nguyện Xu Vàng trong 70-100 lần chắc chắn nhận Thưởng Chọn Điều Ước; nếu chưa chọn thưởng thì sẽ ngẫu nhiên nhận 1 phần thưởng trong kho</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi Ban Phúc có xác suất nhận được Cà Rốt Ma Thuật, có thể dùng tại Cửa Hàng Thỏ Phúc để đổi vật phẩm quý hiếm!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy Ban Phúc có cơ hội nhận thêm thưởng Báu Vật Trời Ban, Thỏ Phúc Ban Duyên!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Ban Phúc:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia thành Ban Phúc Mỗi Ngày, Nhiệm Vụ Ban Phúc, nhiệm vụ Ban Phúc Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm vụ Nhiệm Vụ Ban Phúc trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Ban Phúc:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Ban Phúc thống kê dựa trên số lượng Xu Thỏ Phúc đã tiêu hao, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
BRAVING_TOWER_TEXT1 = {"Xông Pha Tháp Cao", "Leo Tháp Miễn Phí", "Leo Tháp %s Lần", "Thay Đổi Thưởng Lớn", "Thưởng Số Vòng", "Vòng %s", "Tầng %s", "Vé Tháp Cao", "Vé Tháp Cao Của Tôi", "Thưởng Tăng Cấp", "Hãy chọn Thưởng Số Vòng trước", "Thưởng Đỉnh Tháp"},
BRAVING_TOWER_TEXT2 = [[<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Xông Pha Tháp Cao</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tiêu hao Vé Tháp Cao để leo tháp rút thưởng, mỗi lần leo tháp tiêu hao 1 Vé Tháp Cao, chắc chắn nhận được 1 phần thưởng thường;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tháp có tổng cộng 6 tầng, bắt đầu từ tầng 1, mỗi lần rút thưởng chỉ nhận được phần thưởng của tầng hiện tại;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi lần leo tháp có xác suất tăng cấp lên tầng tiếp theo, càng lên cao phần thưởng càng giá trị!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tầng 4, 5, 6 có thể tự chọn thay đổi nội dung thưởng tăng cấp. Khi đạt đỉnh tháp sẽ làm mới toàn bộ ô thưởng và quay về tầng 1.</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Thưởng Số Vòng:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Trước mỗi lần rút thưởng cần chọn thưởng số vòng. Mỗi lần leo lên đỉnh tháp được tính là 1 vòng, đạt 2, 3, 4 vòng sẽ nhận được thưởng tương ứng;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Leo Tháp thống kê dựa trên số lượng Vé Tháp Cao đã tiêu hao, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>]],
LUCKY_FLIP_TEXT1 = {"Lật Thẻ May Mắn", "Lật Miễn Phí", "Lật %s lần", "Số Lần Có Thể Nhận", "Thưởng Thu Thập", "Thưởng Hào Hoa", "Chọn Vật Phẩm Yêu Thích", "Dừng", "Không Có Lượt Nhận", "Thưởng Thu Thập Chưa Nhận", "Hãy nhận hết Rương Thưởng Thu Thập trước", "Đã lật toàn bộ thẻ, vui lòng làm mới", "Hãy chọn Thưởng Hào Hoa trước"},
LUCKY_FLIP_TEXT2 = [[
<T C="229,105,22" S="22" P="1">Hướng dẫn hoạt động Lật Thẻ May Mắn</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0">Hướng Dẫn Lật Thẻ:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể tiêu hao Thẻ May Mắn để lật thẻ rút thưởng, mỗi lần lật tiêu hao 2 Thẻ May Mắn:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi lật Thẻ May Mắn, sẽ ngẫu nhiên nhận 1 ký tự từ A-F và 1 số từ 1-6, kết hợp thành mã số để mở ô tương ứng và nhận thưởng! Mã số đã lật sẽ không bị trùng lặp;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mở thành công 1 hàng ngang hoặc 1 cột dọc gồm 6 ô sẽ nhận thêm Thưởng Thu Thập!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mở toàn bộ 36 ô trên bảng sẽ nhận được Thưởng Hào Hoa! Thưởng Hào Hoa cần chọn trước khi nhận;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Làm Mới Bảng:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi làm mới bảng, toàn bộ ô chưa mở và Thưởng Thu Thập sẽ được làm mới lại;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Làm mới bảng cần tiêu hao Kim Cương, mỗi ngày được làm mới miễn phí 1 lần;</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Sau khi mở toàn bộ bảng, có thể làm mới miễn phí;</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],
FIGHTACTIVITY1_TEXT1 = {"Lực Chiến Phi Thăng"},
FIGHTACTIVITY2_TEXT1 = {"Lực Chiến Phi Thăng"},
FOOTBALL_SHOOT_TEXT1 = {"Đại Chiến\nSút Bóng", "Miễn Phí Sút Bóng", "Sút Bóng %d lần", "Phạt Đền Toàn Server", "Nhiệm Vụ Bóng Đá", "BXH Phạt Đền", "Thưởng Sút Bóng-Nhỏ", "Thưởng Sút Bóng-Lớn", "Cúp Vàng Thế Giới", "Điểm Sút Bóng", "Sút Bóng Mỗi Ngày", "Nhiệm Vụ Sút Bóng", "Nhiệm Vụ Phạt Đền", "Toàn server tích lũy sút bóng %d lần, có thể nhận 1 phần thưởng", "Giày Thể Thao", "Số Giày Thể Thao đã dùng", "Hiện không có Quà Sút Bóng để nhận"},
FOOTBALL_SHOOT_TEXT2 = [[
<T C="255,150,16" S="22" P="1">Hướng dẫn hoạt động Đại Chiến Sút Bóng</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0">Hướng dẫn thao tác: </T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Có thể dùng Giày Thể Thao để rút thưởng Sút Bóng, Sút Bóng Thường mỗi lần dùng 1 Giày Thể Thao, chắc chắn nhận 1 phần thưởng thường. Mỗi ngày đăng nhập trò chơi có thể Sút Bóng Miễn Phí 1 lần. Sút Bóng Vàng mỗi lần dùng 5 Giày Thể Thao, chắc chắn nhận 1 phần thưởng cao cấp:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Khi Sút Bóng-Thường có thể ngẫu nhiên nhận 1-5 Điểm Sút Bóng, khi Sút Bóng-Vàng có thể ngẫu nhiên nhận 5-25 Điểm Sút Bóng!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Mỗi khi đạt 100 Điểm Sút Bóng có thể nhận 1 Quà Sút Bóng!</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Tích lũy học tập có xác suất nhận thêm phần thưởng sút bóng lớn!</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Bóng Đá:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">Chia làm Sút Bóng Mỗi Ngày, Nhiệm Vụ Sút Bóng, Nhiệm Vụ Sút Bóng Mỗi Ngày mỗi ngày được hoàn thành và nhận thưởng 1 lần, hôm sau sẽ xóa dữ liệu. Nhiệm Vụ Sút Bóng trong hoạt động chỉ được hoàn thành 1 lần, khi xong nhiệm vụ hãy nhận thưởng kịp thời, khi hoạt động kết thúc sẽ xóa dữ liệu.;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0">Nhiệm Vụ Phạt Đền:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">12:00-23:00 mỗi ngày mở, khi mở có thể hoàn thành nhiệm vụ Phạt Đền, cứ 10 phút tạo mới 1 lần nhiệm vụ;</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0">BXH Phạt Đền:</T><BR>10</BR>
<T C="127,70,26" S="20" P="0">BXH Phạt Đền thống kê dựa trên Giày Thể Thao sử dụng, top 100 được nhận thưởng hấp dẫn khi hoạt động kết thúc sẽ phát thưởng qua thư.</T><BR>10</BR>
<T C="229,105,22" S="22" P="1">Chú ý: Sau khi hoạt động kết thúc, tất cả đạo cụ hoạt động và số liệu sẽ bị xóa, hãy sử dụng kịp thời!</T><BR>10</BR>
]],

}

