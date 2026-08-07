# Game server — dự án mới

Server Java cho game mới (client Unity/C#). Bắt đầu lại từ đầu sau khi dừng
dự án nông trại cũ (Cozy Farming) — xem lịch sử git nếu cần tham khảo code
cũ.

- Mới setup máy lần đầu? Đọc **[SETUP.md](SETUP.md)**.
- Đang làm client Unity? Đọc **[UNITY_INTEGRATION.md](UNITY_INTEGRATION.md)**.

## Quy trình: từng giai đoạn, xong mới sang giai đoạn kế

- [x] **Giai đoạn 1 — khung project**: Maven project biên dịch + chạy được,
      `DataSourceProvider` (HikariCP, đọc `DB_URL`/`DB_USER`/`DB_PASSWORD`
      từ biến môi trường, không hardcode tài khoản), 1 endpoint `/health`
      xác nhận server sống, có test JUnit xác nhận.
- [x] **Giai đoạn 2 — tài khoản**: 1 bảng `users` duy nhất cho MỌI cách đăng
      nhập — 1 user id xuyên suốt, các cột định danh (`username`,
      `guest_token`, `google_id`, `apple_id`) đều nullable, thêm dần khi liên
      kết chứ không tạo bản ghi mới.
      - `POST /api/auth/register` {username, password} — tài khoản thường.
      - `POST /api/auth/login` {username, password}.
      - `POST /api/auth/guest` {guestToken?} — không gửi token (hoặc gửi
        token lạ) thì tạo khách mới, trả token để client tự lưu; gửi đúng
        token cũ thì vào lại ĐÚNG tài khoản đó (không tạo mới).
      - `POST /api/auth/forgot/{request,reset}` — mã 6 số, hạn 15 phút.
        ⚠️ CHƯA gửi email/SMS thật, trả `devOnlyCode` để test.
      - `POST /api/auth/link/upgrade` {userId, username, password} — khách
        nâng cấp lên tài khoản thường, GIỮ NGUYÊN user id (không mất tiến
        trình). Chặn nếu user không phải khách thuần (409) hoặc username
        trùng (409).
      - `POST /api/auth/social/{google,apple}` {idToken} — đăng nhập THẲNG
        bằng mạng xã hội: đã liên kết thì vào lại đúng tài khoản, chưa từng
        liên kết thì tạo tài khoản MỚI (chỉ có mạng xã hội, chưa có
        username/password).
      - `POST /api/auth/link/{google,apple}` {userId, idToken} — gắn thêm
        mạng xã hội vào tài khoản ĐANG đăng nhập (thường dùng khi đã đăng
        nhập bằng username/password). Chặn nếu id đó đã gắn cho user khác
        (409) — không tự gộp 2 tài khoản.
      - **Khung xác thực OAuth** (`auth/oauth/`): `GoogleTokenVerifier` xác
        thực THẬT qua endpoint `tokeninfo` chính chủ Google (không phải
        placeholder) — cần biến môi trường `GOOGLE_CLIENT_ID` (OAuth client
        ID thật từ Google Cloud Console) để so khớp `aud`. `AppleTokenVerifier`
        (khi ra đời ở giai đoạn này) CHƯA xong thật — chủ động báo lỗi 401
        thay vì tin token gửi lên, xem Giai đoạn 26 để biết bản THẬT sau này.
      Test: `PasswordHasherTest`, `UserDaoTest` (đơn vị); `AuthFlowTest`
      (luồng HTTP thật: đăng ký→đăng nhập→quên mật khẩu→đặt lại→đăng nhập
      lại; khách tạo mới rồi vào lại đúng tài khoản bằng token cũ; nâng cấp
      khách giữ nguyên user id rồi đăng nhập được bằng mật khẩu; đăng nhập
      mạng xã hội tạo mới rồi vào lại đúng tài khoản; liên kết mạng xã hội
      vào tài khoản thường rồi bị chặn khi gắn trùng cho tài khoản khác).
- [x] **Giai đoạn 3 — tạo nhân vật**: 1 user 1 nhân vật (bảng `characters`,
      PK trên `user_id`). Trang phục chỉ 3 ô cơ bản (tóc/áo/quần) — CHƯA có
      bảng vật phẩm thật cho game mới này, id trang phục tạm là số nguyên tự
      do, TODO ràng buộc theo catalog thật khi có hệ vật phẩm.
      - `POST /api/character/create` {userId, name, gender, hairId, topId,
        bottomId} — tên 2-20 ký tự, giới tính 0/1, chặn nếu user đã có nhân
        vật (409) hoặc tên trùng người khác (409, kiểm tra toàn server chứ
        không riêng theo user), 404 nếu user không tồn tại.
      - `GET /api/character?userId=` — 404 nếu chưa tạo (client dựa vào đó
        để biết đưa sang màn tạo nhân vật hay vào thẳng sảnh).
      - `POST /api/character/outfit` {userId, hairId, topId, bottomId} — đổi
        trang phục sau khi đã tạo, 404 nếu chưa có nhân vật.
      Test: `CharacterDaoTest` (đơn vị); `CharacterFlowTest` (luồng HTTP
      thật: chưa tạo trả 404, user không tồn tại bị chặn, tên/giới tính
      không hợp lệ bị chặn, tạo 2 lần bị chặn, tên trùng người khác bị chặn,
      đổi trang phục sau khi tạo).
- [x] **Giai đoạn 4 — sảnh**: Sảnh = màn hình chính sau khi đăng nhập + tạo
      nhân vật, mọi người đứng chung 1 world, thấy được nhân vật/vị trí của
      nhau. ⚠️ Làm bằng REST POLLING (bảng `lobby_presence`), KHÔNG phải
      WebSocket — server hiện tại chỉ có `com.sun.net.httpserver` thuần,
      chưa thêm dependency WebSocket. Polling đủ dùng cho sảnh tĩnh (đứng
      nói chuyện/chọn menu), TODO nâng cấp WebSocket nếu cần đồng bộ di
      chuyển mượt hơn sau này.
      - `POST /api/lobby/heartbeat` {userId, x, y} — client gọi định kỳ
        (khuyến nghị mỗi 1-2 giây) để báo còn hoạt động + cập nhật vị trí.
        404 nếu chưa tạo nhân vật (sảnh chỉ hiện người có nhân vật).
      - `GET /api/lobby/players` — danh sách người ĐANG hoạt động (heartbeat
        trong 15 giây gần nhất), JOIN với `characters` để trả kèm
        tên/giới tính/trang phục cho client vẽ được, không chỉ toạ độ trần.
      - `POST /api/lobby/leave` {userId} — thoát chủ động, gỡ khỏi danh sách
        ngay thay vì chờ hết hạn 15 giây.
      Test: `PresenceDaoTest` (đơn vị, heartbeat/hết hạn/ghi đè vị trí/gỡ
      khỏi danh sách); `LobbyFlowTest` (luồng HTTP thật: chưa có nhân vật bị
      chặn, sảnh trống mặc định, heartbeat hiện đúng tên+vị trí, thoát gỡ
      khỏi danh sách ngay).
- [x] **Giai đoạn 5 — chat**: 1 kênh chat sảnh chung (`chat_messages`, mọi
      người thấy chung), poll bằng REST giống cơ chế sảnh giai đoạn 4 — client
      giữ `id` tin nhắn cuối đã thấy, gọi lại `sinceId` đó để lấy tin mới,
      KHÔNG dùng mốc thời gian (tránh lệch giờ máy giữa client/server).
      - `POST /api/chat/send` {userId, text} — bắt buộc đã tạo nhân vật (404
        nếu chưa), tên hiện trong chat lấy từ TÊN NHÂN VẬT chứ không phải
        username tài khoản. Chặn nội dung rỗng/quá 500 ký tự.
      - `GET /api/chat/recent?sinceId=&limit=` — tin nhắn có `id > sinceId`,
        cũ nhất trước, mặc định 50 tin/lần, tối đa 200.
      - `sender_name` lưu tại thời điểm gửi (denormalize) — lịch sử chat hiện
        đúng tên lúc gửi, không đổi ngược nếu người chơi đổi tên nhân vật
        sau này.
      Test: `ChatMessageDaoTest` (đơn vị, gửi/lọc theo sinceId/giới hạn số
      lượng); `ChatFlowTest` (luồng HTTP thật: chưa có nhân vật bị chặn, nội
      dung rỗng bị chặn, chat trống mặc định, gửi rồi poll tăng dần không lặp
      lại tin đã thấy).
- [x] **Giai đoạn 6 — cài đặt (phần cần server)**: 10 mục cài đặt trong
      game, nhưng CHỈ notifications/privacy & social/account/support cần
      server — graphics/audio/controls/gameplay/language/about là cấu hình
      thuần client (Unity lưu local), không có gì để đồng bộ.
      - `GET /api/settings?userId=` / `POST /api/settings/update` — gộp
        chung "Notifications" (bật/tắt push) + "Privacy & Social"
        (`friendRequestPrivacy`/`messagePrivacy`: EVERYONE/NOBODY) +
        "Language" (đồng bộ đa thiết bị, dù bản thân ngôn ngữ hiển thị vẫn
        client tự xử lý) vào 1 bảng `user_settings`. Update là CẬP NHẬT MỘT
        PHẦN — field nào không gửi (null) thì giữ nguyên, khớp cách người
        dùng thật chỉ đổi 1 mục mỗi lần trong màn cài đặt. Chưa từng lưu thì
        trả về mặc định (khớp cách `WalletDao` đã làm ở dự án trước).
      - **Account**: `POST /api/account/change-password` (đổi mật khẩu khi
        ĐANG đăng nhập, khác `ForgotPasswordResetHandler` — endpoint đó
        dùng khi KHÔNG đăng nhập được). `POST /api/account/delete` — tài
        khoản có mật khẩu bắt buộc xác nhận đúng mật khẩu (401 nếu sai,
        chặn xoá phá hoại nếu lộ userId), tài khoản khách thuần xoá thẳng
        không cần xác nhận gì thêm.
      - **Support**: `POST /api/support/report` {userId, category(bug|contact),
        message} — lưu vào `support_tickets`, chưa có màn admin (xem trực
        tiếp DB). `GET /api/support/tickets?userId=` — người chơi xem lại
        báo cáo của chính mình.
      Test: `UserSettingsDaoTest` (đơn vị); `SettingsFlowTest` (luồng HTTP
      thật: mặc định khi chưa lưu, giá trị riêng tư sai bị chặn, cập nhật
      một phần không ghi đè field không gửi); `AccountFlowTest` (đổi mật
      khẩu sai mật khẩu cũ bị chặn, tài khoản khách chưa có mật khẩu không
      đổi được, xoá tài khoản thường cần đúng mật khẩu, xoá tài khoản khách
      không cần mật khẩu); `SupportFlowTest` (category/nội dung không hợp lệ
      bị chặn, chỉ thấy báo cáo của chính mình).
- [x] **Giai đoạn 7 — bạn bè + quà tặng/thân mật**: 1 cặp bạn bè chỉ 1 dòng
      duy nhất trong `friendships` (chuẩn hoá `userIdA < userIdB`, không quan
      trọng ai gửi lời mời trước) — điểm thân mật (`intimacy_points`) gắn
      liền với tình bạn, mất bạn là mất điểm.
      - `POST /api/friends/request` {fromUserId, toUserId} — tôn trọng cài
        đặt "Privacy & Social" của người NHẬN (giai đoạn 6): `NOBODY` thì
        chặn thẳng (403).
      - `POST /api/friends/respond` {requestId, userId, accept} — `userId`
        BẮT BUỘC là người nhận lời mời (chặn tự duyệt lời mời của mình hoặc
        người thứ 3 duyệt hộ, 403).
      - `GET /api/friends?userId=`, `GET /api/friends/requests?userId=`
        (lời mời đang chờ phản hồi), `POST /api/friends/remove`.
      - `POST /api/friends/gift` {fromUserId, toUserId, giftId} — tặng quà
        CỘNG THẲNG điểm thân mật, chỉ tặng được cho bạn bè (404 nếu chưa kết
        bạn). ⚠️ Game chưa có ví/xu (chưa làm shop/economy) nên quà tặng
        CHƯA tốn tiền — giới hạn 1 LẦN/CẶP BẠN/NGÀY (429 nếu tặng lại sớm)
        để tránh gọi API liên tục max điểm thân mật tức thì, TODO đổi sang
        tốn xu khi có ví. `GiftCatalog` 4 loại quà (hoa/socola/gấu bông/
        trang sức), điểm tăng dần theo độ "đắt" của quà.
      Test: `FriendshipDaoTest` (đơn vị, chuẩn hoá thứ tự cặp/cộng-trừ điểm
      không phụ thuộc thứ tự tham số); `FriendFlowTest` (luồng HTTP thật: tự
      kết bạn bị chặn, privacy NOBODY chặn lời mời, gửi trùng bị chặn, duyệt
      sai người bị chặn, chấp nhận rồi xuất hiện trong danh sách bạn, huỷ kết
      bạn, từ chối không tạo tình bạn); `GiftFlowTest` (tặng cho người lạ bị
      chặn, quà không hợp lệ bị chặn, tặng cộng đúng điểm rồi tặng lại ngay bị
      chặn theo cooldown, hoạt động đúng dù đổi thứ tự from/to).
- [x] **Giai đoạn 8 — kết hôn/đám cưới**: "Đám cưới" hiểu là chính trạng thái
      kết hôn hoàn tất (chưa làm hệ sự kiện/lễ cưới riêng, ví dụ đặt lịch/mời
      khách — chỉ số liệu cân bằng ở `MarriageConstants` là tự đặt, game mới
      không có gốc thật để đối chiếu).
      - `POST /api/marriage/propose` {fromUserId, toUserId} — cầu hôn: phải
        đang là bạn bè (404), chưa ai kết hôn (409), đủ 1000 điểm thân mật
        (409 nếu thiếu). "Mua nhẫn" = TRỪ 200 điểm thân mật chung của cặp
        NGAY khi gửi (chưa có ví/xu, xem TODO giai đoạn 7) — dù bị từ chối
        CŨNG KHÔNG hoàn lại (giống mua nhẫn thật ngoài đời, tăng cân nhắc
        trước khi cầu hôn).
      - `POST /api/marriage/respond` {proposalId, userId, accept} —
        `userId` BẮT BUỘC là người ĐƯỢC cầu hôn (chặn tự chấp nhận lời cầu
        hôn của chính mình, 403). Chấp nhận = tạo hôn nhân (bảng `marriages`,
        chuẩn hoá `userIdA < userIdB` giống `friendships`) + xoá lời cầu
        hôn. Từ chối chỉ xoá lời cầu hôn.
      - `GET /api/marriage/status?userId=` — {married, spouseUserId}.
      - Chưa làm ly hôn (không có yêu cầu) — kết hôn 1 lần vĩnh viễn ở phiên
        bản này.
      Test: `MarriageDaoTest` (đơn vị, chuẩn hoá thứ tự cặp); `MarriageFlowTest`
      (luồng HTTP thật: tự cầu hôn bị chặn, cầu hôn người lạ bị chặn, thiếu
      điểm thân mật bị chặn, chấp nhận sai người bị chặn, cầu hôn thành công
      trừ đúng tiền nhẫn rồi chấp nhận tạo hôn nhân, đã kết hôn rồi không cầu
      hôn người khác được, từ chối không tạo hôn nhân và không hoàn tiền
      nhẫn).
- [x] **Giai đoạn 9 — level/exp + ví vàng/kim cương (nền tảng)**: Người dùng
      đưa ra bản thiết kế chi tiết cho hệ kết hôn (yêu cầu level 20-30+, chi
      phí bằng vàng/kim cương, ly hôn + cooldown...) — nhưng game chưa có hệ
      level hay ví tiền nào cả, nên làm 2 hệ NỀN này trước khi nâng cấp hệ
      kết hôn (giai đoạn 10).
      - `character_levels` (bảng RIÊNG với `characters`, không đụng bảng cũ)
        — `GET /api/level?userId=`, `POST /api/level/add-exp` {userId, amount}.
        Đường cong exp tự đặt (`level * 100` exp lên level kế) — game mới
        không có gốc thật để đối chiếu. ⚠️ CHƯA có hệ chiến đấu/nhiệm vụ thật
        để cộng exp — `add-exp` là HOOK sẵn cho các hệ đó gọi vào sau.
      - `wallets` (vàng/kim cương) — `GET /api/wallet?userId=`,
        `POST /api/wallet/add` {userId, gold?, diamond?}. Người chơi mới
        KHÔNG được cấp sẵn tiền (khác dự án nông trại cũ có `STARTING_COINS`)
        vì chưa có nguồn kiếm tiền nào để cân bằng số khởi điểm hợp lý.
        ⚠️ CHƯA có shop/hệ kiếm tiền thật — `add` là HOOK tương tự.
      Test: `LevelServiceTest` (đơn vị, công thức lên level kể cả lên nhiều
      level 1 lần cộng exp), `LevelDaoTest`, `WalletDaoTest` (đơn vị);
      `LevelFlowTest`, `WalletFlowTest` (luồng HTTP thật).
- [x] **Giai đoạn 10 — nâng cấp hệ kết hôn theo bản thiết kế**: `ProposeHandler`
      kiểm tra ĐỦ điều kiện theo thứ tự (dừng ở điều kiện đầu tiên không đạt):
      bạn bè → đủ level `MIN_LEVEL=25` cả hai → kết bạn đủ 7 ngày (thêm
      `created_at` vào `Friendship`/`FriendshipDao`) → đủ 1000 điểm thân mật
      → cả hai đang online (`PresenceDao.isOnline()`, dùng lại
      `PresenceDao.ONLINE_WINDOW_MS` — tách hằng số này ra khỏi
      `LobbyPlayersHandler` để `ProposeHandler` dùng chung) → chưa ai kết hôn
      → không ai đang trong thời gian chờ sau ly hôn.
      - `currency` ("gold"/"diamond") trong request cầu hôn — "mua nhẫn" trừ
        THẬT vào ví (100.000 Gold HOẶC 500 Kim cương, người cầu hôn chọn 1
        trong 2). Chưa có hệ vật phẩm nên KHÔNG có "nhẫn cưới" dạng item thật,
        chỉ trừ tiền tương ứng.
      - `POST /api/marriage/divorce` {userId} — ly hôn ĐƠN PHƯƠNG (không cần
        đối phương đồng ý, tránh bị "giam" hôn nhân mãi mãi). Cả HAI người
        đều bị áp thời gian chờ 3 ngày (`divorce_cooldowns`) trước khi cưới
        lại được, với BẤT KỲ ai chứ không riêng người vừa ly hôn.
      - Các phần còn lại của bản thiết kế (chơi trận/nhiệm vụ đôi/thắng trận/
        sự kiện cặp đôi tăng thân mật, online cùng +1đ/10 phút, couple
        house/buff tổ đội/bảng xếp hạng/nhiệm vụ hằng ngày cặp đôi) cần hệ
        chiến đấu/nhiệm vụ/nhà ở/đội nhóm/leaderboard CHƯA XÂY — để giai đoạn
        sau khi có hệ gốc, không bịa tạm.
      Test: `DivorceCooldownDaoTest` (đơn vị); `MarriageFlowTest` viết lại
      hoàn toàn — mỗi điều kiện mới có test riêng (thiếu level/kết bạn chưa
      đủ lâu/đối phương offline/không đủ vàng đều bị chặn 409/402), cộng luồng
      đầy đủ: cầu hôn trừ đúng vàng → chấp nhận tạo hôn nhân → ly hôn → cả
      hai vào cooldown → cầu hôn lại ngay bị chặn.
- [x] **Giai đoạn 11 — hệ thống nhân vật mở rộng (tuỳ chỉnh + trang bị làm
      đẹp)**: tách khỏi `Character` (chỉ giữ tóc/áo/quần lúc tạo) sang bảng
      mới `character_appearance` cho các ô chỉnh SAU khi vào game — mắt,
      avatar, khung avatar, danh hiệu, biểu cảm — CỘNG các ô "trang bị cho
      đẹp" không có chỉ số — mũ, áo, quần, giày, pet, skin. 11 ô này gộp
      chung 1 enum `CosmeticType`.
      - `CosmeticCatalog` (tĩnh, giống `GiftCatalog`) — danh mục vật phẩm.
        `GET /api/cosmetics/catalog`.
      - `player_cosmetics` — sở hữu vật phẩm. `GET /api/cosmetics/owned?userId=`.
        `POST /api/cosmetics/unlock` {userId, itemId} — hệ shop/thành tựu/
        gacha CHƯA XÂY nên đây là HOOK tạm (giống `AddCurrencyHandler`) đứng
        thay cho nguồn mở khoá thật sau này.
      - `GET /api/character/appearance?userId=` — các ô đang trang bị (mặc
        định toàn `null` = chưa trang bị gì, client tự vẽ mặc định).
      - `POST /api/character/appearance/equip` {userId, slot, itemId} — trang
        bị 1 vật phẩm vào 1 ô (`itemId` = 0/null để tháo ra). Chặn nếu: chưa
        có nhân vật (404), vật phẩm không khớp loại ô (400), chưa sở hữu vật
        phẩm (403).
      - Giới tính (nam/nữ) và chọn set quần áo lúc tạo nhân vật đã có sẵn từ
        Giai đoạn 3 (`CreateCharacterHandler`, `hairId`/`topId`/`bottomId`),
        không làm lại.
      Test: `PlayerCosmeticDaoTest`, `CharacterAppearanceDaoTest` (đơn vị);
      `AppearanceFlowTest` (luồng HTTP thật: mở khoá → trang bị → tháo, chặn
      trang bị khi chưa sở hữu/sai loại ô/chưa có nhân vật).
- [x] **Giai đoạn 12 — lõi gameplay match-3 (Story mode)**: package
      `vn.dreamtech.game.server.battle`. KHÔNG có client Unity để chạy thử
      bằng mắt — logic server-authoritative, kiểm bằng unit test (engine) +
      test luồng HTTP thật (chấp nhận theo lựa chọn của người dùng).
      - `battle.engine`: `TileBoard` (bàn cờ 8x8, 6 màu), `BoardGenerator`
        (sinh bàn không có sẵn khớp), `MatchFinder` (dò hàng/cột >=3 cùng
        màu), `CascadeResolver` (lặp xoá→rơi→lấp đầy→dò lại cho tới hết
        khớp — mỗi vòng lặp là 1 tầng **chain**).
      - Cơ chế: **combo** (khớp liên tiếp không trượt lượt nào +10%/tầng,
        tối đa 5 tầng, trượt 1 lượt là reset về 0); **mana** (+2/ô khớp, tối
        đa 100); **ultimate** (đủ mana → tốn hết mana, gây 80 sát thương cố
        định, không phụ thuộc bàn cờ); **buff/debuff** (`BuffType` — khớp
        critical (nhóm ≥5 ô) tự nhận buff +20% sát thương 2 lượt kế; địch cứ
        3 lượt phản đòn 1 lần, tự áp debuff -50% mana nhận 2 lượt kế); **chain**
        (mỗi tầng dây chuyền +20% sát thương tầng đó); **critical** (nhóm ≥5
        ô = x2 sát thương, nhóm 4 ô = x1.5).
      - `StoryLevelCatalog` (tĩnh, 3 màn tuyến tính, MVP) — thắng trận cộng
        exp/vàng thật qua `LevelDao`/`WalletDao` (nối vào nền tảng Giai đoạn
        9). `BattleService` giữ phiên trận TRONG BỘ NHỚ (không lưu DB — trận
        đấu là phiên thời gian thực, không phải dữ liệu cần bền vững).
      - `POST /api/battle/story/start` {userId, levelId},
        `POST /api/battle/swap` {battleId, r1, c1, r2, c2},
        `POST /api/battle/ultimate` {battleId},
        `GET /api/battle/state?battleId=`,
        `GET /api/battle/story/levels`.
      - CHƯA làm: Adventure/Daily/Weekly Challenge/Event Puzzle, toàn bộ
        PvP (Ranked/Casual/Custom Room/Tournament/Guild War/Season/Replay/
        Spectate) và phần còn lại của PvE (Dungeon/Elite Dungeon/Tower/Raid/
        Boss Rush/World Boss/Guild Boss) — cần thêm hệ guild/matchmaking/
        replay chưa xây, để giai đoạn sau khi lõi match-3 đã ổn định.
      Test: `MatchFinderTest`, `BoardGeneratorTest`, `CascadeResolverTest`
      (đơn vị, engine thuần logic); `BattleServiceTest` (đơn vị service —
      dò nước đi khớp/không khớp thật trên bàn cờ ngẫu nhiên bằng chính
      `MatchFinder`, không giả lập, để test đúng hành vi server); `BattleFlowTest`
      (luồng HTTP thật cho các endpoint).
- [x] **Giai đoạn 13 — Daily/Weekly Challenge**: dùng lại NGUYÊN lõi match-3
      của Giai đoạn 12 (`EnemyDef` — interface chung cho `StoryLevelDef` và
      `ChallengeDef` — để `BattleSession`/`BattleService` không cần biết
      trận đấu tới từ đâu). Mỗi loại (Daily/Weekly) MVP chỉ có ĐÚNG 1 con
      trùm cố định (`ChallengeCatalog`), TODO xoay vòng nội dung thật sau.
      - Cooldown tính từ LẦN THẮNG gần nhất (không reset theo mốc lịch/tuần
        thật — đơn giản hoá cho MVP): Daily 24h, Weekly 7 ngày
        (`challenge_attempts`, `ChallengeAttemptDao`). Thắng mới tính là
        hoàn thành — thua không bị tính cooldown, được thử lại ngay.
      - `POST /api/battle/challenge/start` {userId, type} — 429 nếu còn
        trong thời gian chờ (kèm số ms còn lại).
      - `GET /api/battle/challenge/status?userId=&type=` — còn làm được
        không, còn bao lâu nếu chưa.
      - `swap`/`ultimate`/`state` dùng chung y hệt endpoint của Story
        (không tách riêng — cùng `battleId`).
      Test: `ChallengeFlowTest` (luồng HTTP thật: mặc định làm được ngay,
      chặn loại thử thách sai, chặn làm lại khi còn cooldown, làm lại được
      khi cooldown đã hết).
- [x] **Giai đoạn 14 — Dungeon (nhiều tầng)**: dùng lại lõi match-3 lần thứ
      3 (`EnemyDef`). Khác Story/Challenge (1 địch/trận), Dungeon là 1 trận
      NHIỀU tầng đấu liên tiếp trong CÙNG 1 `battleId` — thắng 1 tầng không
      kết thúc trận, tự động sinh bàn cờ mới và chuyển sang địch tầng kế
      (`BattleSession#advanceFloor`). Máu người chơi/hiệu ứng buff/debuff
      KHÔNG hồi lại giữa các tầng (khó dần); mana/combo/số lượt reset về 0
      mỗi tầng mới. Thưởng (exp/vàng) chỉ phát khi qua tầng CUỐI — bỏ giữa
      chừng (thua) không mất gì thêm ngoài lượt chơi.
      - `DungeonCatalog` (tĩnh, MVP 2 dungeon x 3 tầng).
      - `POST /api/battle/dungeon/start` {userId, dungeonId},
        `GET /api/battle/dungeon/list`.
      - `swap`/`ultimate`/`state` dùng CHUNG endpoint với Story/Challenge.
        Response `BattleStateView` thêm `floorIndex`/`totalFloors` (chỉ có
        giá trị khi mode DUNGEON) và `floorCleared` (true đúng 1 lần ở
        swap/ultimate vừa hạ gục tầng hiện tại, còn tầng sau nên KHÔNG
        chuyển sang WON).
      Test: `DungeonFlowTest` (qua `BattleService` trực tiếp — dò nước đi
      khớp thật để đẩy trận qua nhiều tầng, kiểm tầng mới hồi đầy máu địch
      MỚI chứ không cộng dồn máu tầng cũ, mana/combo reset về 0, thắng đủ
      tầng cuối mới phát thưởng); `DungeonHttpFlowTest` (nối dây HTTP).
- [x] **Giai đoạn 15 — Tower**: tách interface `FloorSource` (Dungeon lẫn
      Tower cùng implement) khỏi `DungeonDef` để `BattleSession` dùng lại
      NGUYÊN cơ chế nhiều tầng của Giai đoạn 14 mà không cần biết tầng tới
      từ đâu. Khác Dungeon (danh sách tầng cố định): `TowerDef` sinh địch
      theo CÔNG THỨC tuyến tính (`enemyHp = start + step * floorIndex`,
      tương tự `enemyCounterDamage`) — mạnh dần vô hạn về mặt thiết kế
      nhưng có mốc `maxFloors` (MVP đơn giản hoá, chưa phải "leo mãi thật" —
      TODO leaderboard theo tầng cao nhất khi có hệ leaderboard).
      - KHÁC Dungeon: MỖI tầng qua đều phát thưởng NGAY
        (`rewardExpPerFloor`/`rewardGoldPerFloor` cố định mỗi tầng), không
        đợi tới tầng cuối — hợp lý vì không đảm bảo người chơi lên được tới
        đỉnh. `BattleService` gộp chung logic này (`grantFloorReward`) dùng
        được cho cả Dungeon (tầng giữa thưởng 0/0 nên no-op) lẫn Tower.
      - `POST /api/battle/tower/start` {userId, towerId},
        `GET /api/battle/tower/list`. `swap`/`ultimate`/`state` dùng CHUNG
        endpoint với Story/Challenge/Dungeon.
      Test: `TowerFlowTest` (qua `BattleService` trực tiếp — tầng đầu đúng
      chỉ số gốc, tầng 2 chỉ số tăng đúng công thức, mana reset khi sang
      tầng); `TowerHttpFlowTest` (nối dây HTTP).
- [x] **Giai đoạn 16 — Guild (nền tảng)**: 1 user chỉ ở ĐÚNG 1 guild tại 1
      thời điểm (PK trên `user_id` ở `guild_members`, giống cách
      `characters` chỉ cho 1 nhân vật/user). Tạo guild tốn 10.000 vàng, trừ
      NGAY không hoàn — cùng triết lý "không hoàn tiền" đã dùng ở nhẫn cầu
      hôn (Giai đoạn 10).
      - 3 cấp bậc: LEADER/OFFICER/MEMBER. Hội trưởng rời guild khi còn
        thành viên khác bị CHẶN (409) — phải `transfer-leader` trước, tránh
        guild mất chủ; hội trưởng duy nhất rời = tự giải tán.
      - `POST /api/guild/create` {userId, name, tag, description},
        `POST /api/guild/join` {userId, guildId} (vào thẳng, CHƯA có duyệt
        đơn — MVP, TODO khi cần), `POST /api/guild/leave` {userId},
        `POST /api/guild/kick` {actorUserId, targetUserId} (hội trưởng/phó,
        không đuổi được hội trưởng), `POST /api/guild/role`
        {actorUserId, targetUserId, role} (chỉ hội trưởng, thăng/giáng
        OFFICER/MEMBER — dùng `transfer-leader` riêng để đặt LEADER),
        `POST /api/guild/transfer-leader` {actorUserId, targetUserId} (hội
        trưởng cũ tự xuống OFFICER), `POST /api/guild/disband` {userId}
        (chỉ hội trưởng), `GET /api/guild/list`,
        `GET /api/guild/info?guildId=`, `GET /api/guild/my?userId=`.
      - Đặt nền cho Guild War/World Boss/Guild Boss/bảng xếp hạng guild sau
        này — CHƯA làm các phần đó (cần thêm hệ chiến đấu chung/matchmaking
        guild, để giai đoạn sau).
      Test: `GuildDaoTest`, `GuildMemberDaoTest` (đơn vị); `GuildFlowTest`
      (luồng HTTP thật: chặn tạo khi chưa có nhân vật/không đủ vàng, trừ
      đúng vàng khi tạo, tên/tag trùng bị chặn, vào/rời/đuổi/đổi cấp
      bậc/chuyển quyền hội trưởng/giải tán đầy đủ, hội trưởng duy nhất rời
      = tự giải tán).
- [x] **Giai đoạn 17 — Guild Boss**: dùng lại NGUYÊN lõi match-3 lần thứ 4
      qua `BattleService.startGuildBoss(userId, EnemyDef)` (generic, không
      qua Story/Dungeon/Tower catalog) — mỗi thành viên đánh 1 "bản sao" cá
      nhân của trùm (`GuildBossFightDef`, HP cố định 300), sát thương
      KHÔNG trực tiếp trừ vào HP chung của guild trong lúc đánh (mỗi phiên
      độc lập trong bộ nhớ, không có gì để đồng bộ ngay lập tức) — thay vào
      đó, sau khi trận cá nhân kết thúc (WON/LOST), client gọi
      `POST /api/guild/boss/report` để đồng bộ 1 LẦN tổng sát thương
      (`BattleSession.totalDamageDealt`, field mới cộng dồn theo trận) vào
      HP chung (`guild_boss_cycles`), chống báo cáo trùng bằng tập
      `battleId` đã báo cáo (in-memory).
      - Thêm `BattleStateView.userId` (để `GuildBossService` xác minh trận
        đúng là của người gọi report, chặn báo cáo hộ) và
        `BattleStateView.totalDamageDealt`.
      - Chu kỳ trùm (5000 HP, 24h) KHÔNG dùng cron — tự phát hiện hết hạn
        và tạo chu kỳ mới ngay khi có request tiếp theo (lazy reset, khớp
        cách server chưa có background job nào). Mỗi thành viên chỉ đánh
        được 1 lần/chu kỳ (`guild_boss_attempts`, lưu MỐC chu kỳ đã đánh
        thay vì cooldown tuyệt đối — tự "reset" khi sang chu kỳ mới).
      - Thắng/thua đều tính là 1 lượt đã dùng (đã trừ lúc BẮT ĐẦU đánh,
        không phải lúc thắng) — tránh spam nhiều phiên trước khi report.
        Thưởng (20 exp/40 vàng) chỉ phát nếu gây được sát thương >0.
      - `guild_boss_contributions` — đóng góp sát thương từng thành viên
        theo chu kỳ, để sau này hiển thị bảng xếp hạng đóng góp guild.
      - `POST /api/guild/boss/attack` {userId}, `POST /api/guild/boss/report`
        {userId, battleId}, `GET /api/guild/boss/status?guildId=`,
        `GET /api/guild/boss/attack-status?userId=`. `swap`/`ultimate`/
        `state` dùng CHUNG endpoint với Story/Challenge/Dungeon/Tower.
      - CHƯA làm: bảng xếp hạng guild theo đóng góp (dữ liệu đã có, thiếu
        endpoint hiển thị), World Boss (trùm chung TOÀN SERVER thay vì
        từng guild), Guild War (PvP giữa 2 guild — cần matchmaking).
      Test: `GuildBossCycleDaoTest`, `GuildBossAttemptDaoTest`,
      `GuildBossContributionDaoTest` (đơn vị); `GuildBossServiceTest` (qua
      service trực tiếp — chặn đánh khi chưa vào guild, chặn đánh 2 lần/chu
      kỳ, chặn report khi trận chưa xong/report hộ người khác/report trùng,
      đánh tới khi trận kết thúc rồi report đúng tổng sát thương + trừ
      đúng HP chung + phát thưởng đúng); `GuildBossHttpFlowTest` (nối dây
      HTTP).
- [x] **Giai đoạn 18 — bảng đóng góp trùm guild**: dữ liệu đã có sẵn từ
      Giai đoạn 17 (`guild_boss_contributions`), chỉ thêm endpoint đọc —
      `GET /api/guild/boss/leaderboard?guildId=` trả về đóng góp sát thương
      từng thành viên trong CHU KỲ HIỆN TẠI, xếp giảm dần kèm hạng
      (`GuildBossService.leaderboard`). Chu kỳ cũ không hiện trong bảng khi
      chu kỳ mới đã bắt đầu (khớp cách `guild_boss_attempts` "reset" theo
      mốc chu kỳ ở Giai đoạn 17, không phải xoá dữ liệu — lịch sử chu kỳ cũ
      vẫn còn trong DB, chỉ không hiển thị qua endpoint này).
      Test: 3 test mới trong `GuildBossServiceTest` (bảng trống lúc guild
      chưa ai đánh; xếp hạng đúng thứ tự giảm dần theo sát thương; report
      xong thì xuất hiện đúng trong bảng).
- [x] **Giai đoạn 19 — World Boss**: gần như COPY nguyên cơ chế Guild Boss
      (Giai đoạn 17-18) nhưng HP CHUNG dùng cho TOÀN SERVER (bảng
      `world_boss_cycle` CHỈ 1 DÒNG DUY NHẤT, không theo guild) và KHÔNG
      yêu cầu ở guild nào — chỉ cần đã tạo nhân vật. Thêm
      `BattleMode.WORLD_BOSS` riêng (KHÔNG dùng chung `GUILD_BOSS`, dù cùng
      cơ chế "bản sao cá nhân + report" — tách mode để response API không
      gây hiểu nhầm trận Guild Boss/World Boss) qua
      `BattleService.startWorldBoss(userId, EnemyDef)` (sinh đôi với
      `startGuildBoss` đã có).
      - Dùng LẠI `GuildBossReportView`/`GuildBossLeaderboardEntry`/
        `AttackStatusView` từ package `guild.boss` cho World Boss (hình
        dạng dữ liệu giống hệt, không tạo record trùng lặp).
      - HP pool lớn hơn (50.000, so với 5.000 của Guild Boss) và địch mạnh
        hơn (HP cá nhân 400, phản đòn 15) — phản ánh đây là nội dung
        server-wide, thưởng cũng cao hơn (30 exp/60 vàng so với 20/40).
      - `POST /api/world-boss/attack` {userId},
        `POST /api/world-boss/report` {userId, battleId},
        `GET /api/world-boss/status`, `GET /api/world-boss/attack-status?userId=`,
        `GET /api/world-boss/leaderboard`. `swap`/`ultimate`/`state` dùng
        CHUNG endpoint với Story/Challenge/Dungeon/Tower/Guild Boss.
      - Trùng tên class với `guild.boss` (`AttackHandler`,
        `ReportBossResultHandler`, `AttackStatusHandler`,
        `LeaderboardHandler`) — `Main.java` dùng tên đầy đủ
        (fully-qualified) tại nơi gọi thay vì import, tránh xung đột.
      Test: `WorldBossCycleDaoTest`, `WorldBossAttemptDaoTest`,
      `WorldBossContributionDaoTest` (đơn vị); `WorldBossServiceTest` (qua
      service trực tiếp — không cần guild vẫn đánh được, HP pool dùng
      chung giữa nhiều người chơi khác nhau, đánh tới khi trận kết thúc rồi
      report đúng + phát thưởng + lên bảng xếp hạng); `WorldBossHttpFlowTest`
      (nối dây HTTP).
- [x] **Giai đoạn 20 — PvP Ranked**: server CHỈ có REST polling, KHÔNG có
      WebSocket (xem Giai đoạn 4) — nên 2 người chơi KHÔNG thể thao tác
      chung 1 bàn cờ theo thời gian thực. Giải pháp: PvP dạng "đấu song
      song không chung bàn cờ" (async score-attack) — ghép cặp xong, mỗi
      bên tự chơi ĐỘC LẬP trong giới hạn `BattleConstants.PVP_MOVE_LIMIT`
      (20 lượt, địch gần như bất tử — `PvpFightDef`, HP 999999, không đấu
      tới khi hết máu địch), ai TỔNG SÁT THƯƠNG cao hơn thắng.
      - Thêm `BattleMode.PVP` + `BattleService.startPvp` (sinh đôi với
        `startGuildBoss`/`startWorldBoss`). `resolveOutcome` thêm nhánh:
        PVP mà đủ `PVP_MOVE_LIMIT` lượt thì dừng trận (dùng lại
        `BattleStatus.LOST` làm "đã kết thúc", KHÔNG mang nghĩa "thua thật"
        — `PvpService` chỉ đọc `totalDamageDealt`, không quan tâm status).
      - Ghép cặp: CHỈ 1 vị trí chờ (MVP, chưa phải hàng đợi thật nhiều
        người/theo rating — TODO nâng cấp sau). Người thứ 2 vào hàng chờ
        được ghép NGAY, người thứ 1 phải tự poll `match/my` để biết đã
        được ghép (không có cách "đẩy" thông báo qua REST polling thuần).
      - Mỗi bên tự `match/start` trận cá nhân riêng, tự `swap`/`ultimate`
        (dùng CHUNG endpoint), rồi `match/report` nộp điểm SAU khi trận cá
        nhân kết thúc. Trận CHỈ resolve khi CẢ HAI đã report — chống báo
        cáo trùng bằng tập `battleId` đã báo cáo (in-memory, giống Guild/
        World Boss).
      - Elo-lite đơn giản (`pvp_ranks`): thắng +20, thua -10, hoà +5 mỗi
        bên (không phải Elo thật có tính theo chênh lệch rating đối thủ —
        TODO khi cần cân bằng công bằng hơn), rating tối thiểu 0.
        `pvp_match_history` chỉ ghi kết quả cuối lúc resolve, không lưu
        từng lượt (giống triết lý "chỉ lưu kết quả cuối" của
        `BattleSession`).
      - `POST /api/pvp/queue/join` {userId} (ghép ngay thì trả `matchId`
        luôn), `POST /api/pvp/queue/leave` {userId},
        `POST /api/pvp/match/start` {userId, matchId},
        `POST /api/pvp/match/report` {userId, matchId, battleId},
        `GET /api/pvp/match/status?matchId=`, `GET /api/pvp/match/my?userId=`
        (kể cả trận đã xong, để xem kết quả), `GET /api/pvp/rank?userId=`,
        `GET /api/pvp/leaderboard`.
      Test: `PvpRankDaoTest`, `PvpMatchHistoryDaoTest` (đơn vị);
      `PvpServiceTest` (qua service trực tiếp — chặn ghép khi chưa có nhân
      vật/đã trong hàng chờ/đã có trận chưa xong, chặn report khi trận cá
      nhân chưa xong/report trùng, đấu tới hết lượt cả 2 bên rồi report
      đúng điểm + resolve đúng thắng-thua-hoà + cập nhật rating, sau khi
      resolve vào hàng chờ lại được); `PvpHttpFlowTest` (nối dây HTTP).
- [x] **Giai đoạn 21 — hàng chờ PvP thật (nhiều người cùng chờ)**: nâng cấp
      hàng chờ 1-vị-trí ở Giai đoạn 20 lên `Set<Integer> waitingUserIds`
      thật — nhưng CHỈ ghép khi chênh rating trong ngưỡng
      `PvpConstants.MAX_MATCH_RATING_DIFF` (300), nếu không ai đủ gần thì
      TIẾP TỤC chờ thay vì ghép bừa. Đây là điểm mấu chốt: không có ngưỡng
      thì hàng chờ KHÔNG BAO GIỜ giữ được >1 người (ai vào cũng ghép ngay
      với người đang chờ) — có ngưỡng mới thật sự mô phỏng được nhiều người
      cùng chờ đồng thời. TODO: nới ngưỡng dần theo thời gian chờ.
      Test: `PvpServiceTest` thêm 2 test — nhiều người chờ cùng lúc, ghép
      đúng người gần rating nhất (không phải cứ vào trước là ghép trước);
      rời hàng chờ chỉ ảnh hưởng đúng người đó.
- [x] **Giai đoạn 22 — thêm nội dung Story/Adventure/Event Puzzle**: Story
      mở rộng từ 3 lên 6 màn. Thêm 2 chế độ MỚI dùng lại nguyên lõi
      `EnemyDef`/`BattleService` (không sửa engine): **Adventure**
      (`AdventureLevelCatalog`, 4 màn, không giới hạn lượt chơi lại — khác
      Story chỉ ở chỗ tách catalog/endpoint riêng để dễ mở rộng nội dung
      song song) và **Event Puzzle** (`EventPuzzleCatalog`, sự kiện có
      `startAt`/`endAt` theo mốc thời gian THẬT — chỉ chơi được trong
      khung thời gian, tự kiểm tra lúc `start`, KHÔNG cần cron; hiện có 2
      sự kiện mẫu hardcode theo lịch, TODO công cụ admin thêm sự kiện mới
      mà không cần sửa code).
      - `BattleMode` thêm `ADVENTURE`, `EVENT_PUZZLE`; đổi tên field
        `BattleSession.storyLevelId` → `catalogLevelId` (dùng chung cho cả
        3 chế độ catalog-based: Story/Adventure/Event Puzzle).
      - `GET /api/battle/adventure/levels`, `POST /api/battle/adventure/start`
        {userId, levelId}; `GET /api/battle/event-puzzle/list`,
        `POST /api/battle/event-puzzle/start` {userId, eventId}.
      Test: `BattleServiceTest` thêm test cho cả 2 chế độ mới (bắt đầu
      đúng, từ chối id không tồn tại, Event Puzzle từ chối ngoài khung thời
      gian).
- [x] **Giai đoạn 23 — thêm nội dung Dungeon/Tower**: Dungeon mở rộng từ 2
      lên 4 hầm ngục, Tower mở rộng từ 1 lên 2 tháp — chỉ thêm dữ liệu vào
      catalog có sẵn (`DungeonCatalog`/`TowerCatalog`), không đổi cơ chế.
- [x] **Giai đoạn 24 — Guild War**: PvP giữa 2 GUILD (điều còn thiếu đã ghi
      chú ở Giai đoạn 17) — cùng triết lý "bản sao cá nhân + report" như
      Guild Boss/World Boss/PvP: hội trưởng/phó tuyên chiến guild khác
      (`POST /api/guild/war/declare`), mỗi thành viên đánh 1 lần
      MỘT-LẦN-DUY-NHẤT cho CUỘC CHIẾN đó (không phải theo chu kỳ như Guild
      Boss — Guild War là sự kiện 1 LẦN, `guild_war_attempts` khoá theo
      `war_id` chứ không phải mốc chu kỳ), tổng sát thương cộng dồn vào
      điểm CHUNG của guild mình (`guild_wars.score_a`/`score_b`).
      - Thời hạn 24h (`GuildWarConstants.WAR_DURATION_MS`) — hết hạn thì
        guild điểm cao hơn thắng, tự resolve LAZY khi có request tiếp theo
        (giống chu kỳ Guild/World Boss, KHÔNG dùng cron). Guild đang chiến
        tranh chưa xong thì không tuyên chiến tiếp được (cả 2 phía).
      - `GuildWarDao`/`GuildWarAttemptDao` (bảng `guild_wars`,
        `guild_war_attempts`); `GuildWarService`
        (declare/attack/report/status/myWar); `BattleMode.GUILD_WAR` +
        `BattleService.startGuildWar` (sinh đôi với `startPvp`/
        `startGuildBoss`).
      - `POST /api/guild/war/declare` {userId, targetGuildId},
        `POST /api/guild/war/attack` {userId},
        `POST /api/guild/war/report` {userId, battleId},
        `GET /api/guild/war/status?guildId=`, `GET /api/guild/war/my?userId=`.
      - Trùng tên class `AttackHandler` với `guild.boss`/`worldboss` —
        `Main.java` dùng tên đầy đủ (fully-qualified) tại nơi gọi, đúng
        pattern đã dùng ở Giai đoạn 19.
      Test: `GuildWarDaoTest`, `GuildWarAttemptDaoTest` (đơn vị);
      `GuildWarServiceTest` (qua service trực tiếp — chặn tuyên chiến khi
      chưa vào guild/không phải hội trưởng-phó/tuyên chiến chính mình/đang
      chiến tranh khác, chặn đánh khi không trong cuộc chiến/đã đánh rồi,
      chặn report khi trận chưa xong, đánh tới khi trận kết thúc rồi report
      đúng cộng vào điểm ĐÚNG BÊN guild mình).
- [x] **Giai đoạn 25 — nguồn điểm thân mật sau khi cưới**: trước đây chỉ có
      quà tặng (`SendGiftHandler`, giai đoạn 9) làm nguồn thân mật. Thêm 3
      nguồn MỚI, riêng cho VỢ CHỒNG đã cưới (`MarriageActivityService`,
      vẫn cộng điểm vào ĐÚNG bảng `friendships` — vợ chồng vẫn là bạn bè):
      1. **Online cùng nhau**: `POST /api/marriage/online-tick` {userId} —
         cộng điểm nếu CẢ HAI đang online (dùng lại `PresenceDao`, cửa sổ
         `ONLINE_WINDOW_MS` có sẵn từ giai đoạn Lobby), chặn spam bằng
         cooldown 5 phút/cặp (không phải theo ngày).
      2. **Nhiệm vụ đôi hàng ngày**: `POST /api/marriage/duo-quest/claim`
         {userId} — cần cả 2 đang online, 1 lần/24h/cặp, thưởng lớn hơn
         tick thường.
      3. **Trận đánh hợp tác**: `POST /api/marriage/battle/start` {userId}
         bắt đầu 1 "bản sao" cá nhân (`MarriageCoopFightDef`, giống Guild
         War/Guild Boss về ý tưởng), `POST /api/marriage/battle/report`
         {userId, battleId} sau khi xong — nếu VỢ/CHỒNG cũng đã hoàn thành
         lượt của họ trong vòng `COOP_BATTLE_WINDOW_MS` (24h) tính từ lượt
         này, CẢ HAI nhận thêm điểm thưởng chung; chống thưởng trùng bằng
         so sánh mốc `coop_last_awarded_at` với mốc hoàn thành của người
         kia (chỉ thưởng nếu chưa thưởng cho VÒNG đánh hiện tại).
      - `BattleMode` thêm `MARRIAGE_COOP` +
        `BattleService.startMarriageCoop` (sinh đôi với `startGuildWar`).
      - `MarriageActivityDao` (bảng `marriage_activity`, khoá theo cặp
        `userIdA < userIdB` giống `MarriageDao`/`FriendshipDao`) lưu mốc
        thời gian cho cả 3 nguồn trên trong 1 bảng duy nhất.
      Test: `MarriageActivityDaoTest` (đơn vị); `MarriageActivityServiceTest`
      (qua service trực tiếp — chặn khi chưa cưới, chặn tick/nhiệm vụ đôi
      khi vợ/chồng chưa online, cooldown tick/nhiệm vụ đôi hoạt động đúng,
      trận hợp tác chỉ thưởng khi CẢ HAI cùng hoàn thành trong khung thời
      gian chứ không phải 1 người đánh 2 lần).
- [x] **Giai đoạn 26 — xác thực Apple THẬT**: hoàn thành TODO ghi ở Giai
      đoạn 2 — `AppleTokenVerifier` trước đây CHỦ ĐỘNG báo lỗi thay vì tin
      token gửi lên (đúng nguyên tắc an toàn, nhưng chưa dùng được thật).
      Giờ verify chữ ký JWT THẬT bằng JWKS chính chủ Apple
      (`https://appleid.apple.com/auth/keys`) qua thư viện `nimbus-jose-jwt`
      (dependency MỚI, đã thêm `pom.xml`) — không tự chế lại logic JWT/JWK.
      - Tải JWKS 1 lần rồi cache (`volatile JWKSet`, double-checked locking)
        — mỗi request KHÔNG gọi Apple lại; nếu gặp `kid` lạ (Apple xoay khoá
        định kỳ) thì tự tải lại JWKS 1 lần trước khi báo lỗi hẳn.
      - Kiểm ĐỦ những gì 1 verifier JWT thật cần: chữ ký (`RSASSAVerifier`
        theo đúng khoá công khai khớp `kid`), `iss` phải là
        `https://appleid.apple.com`, `aud` phải khớp biến môi trường
        `APPLE_CLIENT_ID` (Services ID thật đăng ký với Apple — thêm mới,
        sinh đôi với `GOOGLE_CLIENT_ID`), `exp` chưa hết hạn.
      - Test KHÔNG gọi Apple thật: `AppleTokenVerifierTest` tự sinh cặp khoá
        RSA + tự ký JWT cục bộ (`nimbus-jose-jwt` cũng dùng để ký trong
        test), tiêm JWKS giả qua constructor package-private thay vì
        constructor công khai (constructor công khai vẫn luôn gọi Apple
        thật, không đổi hành vi production) — kiểm đủ: verify đúng token
        hợp lệ, từ chối sai `aud`/sai `iss`/hết hạn/ký bằng khoá sai/`kid`
        lạ/thiếu cấu hình `APPLE_CLIENT_ID`/token sai định dạng.
- [x] **Giai đoạn 27 — giftcode, hộp thư, bảng sự kiện, admin quản trị**:
      4 tính năng gắn liền nhau, xây quanh 1 "kho item" DÙNG CHUNG duy nhất
      (`items`, admin quản lý) — mọi nguồn phần thưởng (giftcode/thư/sự
      kiện) chỉ khai báo `{itemId, quantity}` trỏ vào kho này thay vì định
      nghĩa lại phần thưởng ở từng nơi, và CHỈ CÓ 1 chỗ thật sự cấp phát
      (`RewardGrantService`) — tránh lặp logic cấp thưởng ở nhiều nơi.
      - **Kho item** (`item/`, DAO `ItemDao`): mỗi item có `category`
        (GOLD/DIAMOND/EXP/COSMETIC/MATERIAL) quyết định cách cấp khi claim —
        GOLD/DIAMOND/EXP cấp thẳng vào ví/exp (dùng lại `WalletDao`/
        `LevelDao`/`LevelService` có sẵn), COSMETIC cấp qua `refId` (trỏ
        vào `CosmeticCatalog` có sẵn từ giai đoạn 3), MATERIAL cấp vào kho
        đồ chung MỚI `player_items` (chưa có công dụng cụ thể — dành cho
        chế tạo/nhiệm vụ sau này). `GET /api/items/catalog` (public, để
        client hiện tên/loại phần thưởng); admin CRUD qua
        `/api/admin/items/{create,update,delete}`.
      - **Hộp thư** (`mail/`, DAO `MailDao`/`MailTemplateDao`/
        `MailBroadcastReceiptDao`): NGUỒN DUY NHẤT để nhận thưởng — giftcode
        và admin gửi thư chỉ TẠO thư (`MailService#sendToUser`), còn cấp
        phát thật chỉ xảy ra khi user bấm nhận (`POST /api/mail/claim`,
        gọi `RewardGrantService`, chặn nhận 2 lần/thư + thư hết hạn). Mail
        admin gửi TOÀN SERVER (`broadcast`) KHÔNG tạo 1 dòng cho từng user
        ngay lúc gửi (không biết hết ai sẽ chơi sau này) — chỉ tạo
        `mail_templates`, rồi "vật chất hoá" LAZY thành thư riêng cho từng
        user ở lần đầu họ mở hộp thư (`MailService#list`, giống cách chu kỳ
        Guild Boss tự resolve lazy, KHÔNG dùng cron), đánh dấu đã nhận qua
        `mail_broadcast_receipts` để không tạo trùng. `GET /api/mail/list?userId=`,
        `POST /api/mail/read` (đọc không nhận thưởng), `POST /api/mail/claim`.
      - **Giftcode** (`giftcode/`, DAO `GiftcodeDao`/`GiftcodeRedemptionDao`):
        đổi code KHÔNG cấp thưởng ngay mà tạo 1 thư (khớp yêu cầu "tất cả
        đều xem thư") — `POST /api/giftcode/redeem` {userId, code}. 2 giới
        hạn ĐỘC LẬP nhau: `maxUses` tổng của cả server (null = không giới
        hạn) và mỗi user chỉ đổi 1 LẦN/code (`giftcode_redemptions`, PK
        (user_id, code)). Admin CRUD qua `/api/admin/giftcode/
        {create,update,delete,list}` (list KHÔNG public — lộ danh sách code
        thật thì ai cũng đổi được).
      - **Bảng sự kiện** (`event/`, DAO `EventBoardDao`): CHỈ hiển thị
        thông tin (tên/mô tả/thời gian) qua `GET /api/events/board`
        (public, chỉ trả sự kiện active và chưa kết thúc) — KHÔNG tự cấp
        thưởng (tách bạch "thông báo" khỏi "phát thưởng"; muốn phát thưởng
        sự kiện thì admin gửi thư quảng bá riêng qua
        `POST /api/admin/mail/broadcast`, 1 sự kiện có thể có nhiều đợt
        phát thưởng khác nhau). Admin CRUD qua
        `/api/admin/events/{create,update,delete,list}`.
      - **Admin** (`admin/`): MVP xác thực bằng 1 shared-secret qua header
        `X-Admin-Token`, so khớp với biến môi trường `ADMIN_TOKEN` (so sánh
        thời gian hằng số tránh timing attack dò token) — CHƯA có hệ tài
        khoản admin/phân quyền thật (RBAC), TODO khi cần nhiều admin với
        quyền khác nhau. CHƯA đặt `ADMIN_TOKEN` thì MỌI request admin bị từ
        chối (503, an toàn theo mặc định — không phải "mở hết nếu quên cấu
        hình"). Phạm vi admin ở giai đoạn này CHỈ quản lý 4 hệ thống MỚI
        vừa xây (kho item, giftcode, thư quảng bá, sự kiện) — TODO mở rộng
        CRUD admin sang các catalog khác đã có sẵn (Story/Dungeon/Tower,
        guild,...) khi cần.
      Test: `ItemDaoTest`, `PlayerItemDaoTest`, `MailDaoTest`,
      `MailTemplateDaoTest`, `MailBroadcastReceiptDaoTest`, `GiftcodeDaoTest`,
      `GiftcodeRedemptionDaoTest`, `EventBoardDaoTest` (đơn vị);
      `RewardGrantServiceTest` (cấp đúng theo từng category, từ chối item
      không tồn tại/số lượng ≤0); `MailServiceTest` (claim cấp đúng thưởng +
      chặn claim trùng/claim hộ người khác/claim thư hết hạn, mail quảng bá
      vật chất hoá đúng 1 lần/user); `GiftcodeServiceTest` (đổi code tạo thư
      chứ không cấp thẳng, chặn đổi trùng/hết lượt/hết hạn/code tắt/code đã
      xoá); `EventBoardServiceTest`; `AdminAuthTest` (nối dây HTTP thật —
      thiếu header/sai token/chưa cấu hình `ADMIN_TOKEN`/token đúng);
      `GiftcodeMailHttpFlowTest` (nối dây HTTP thật — đổi giftcode xong vào
      thư nhận thưởng đúng, đổi trùng code bị chặn, catalog/bảng sự kiện
      public đọc được).
- [x] **Giai đoạn 28 — GM tool quản lý tài khoản**: mở rộng phạm vi admin
      (đã ghi TODO ở Giai đoạn 27) sang quản lý NGƯỜI CHƠI — cấm/gỡ cấm tài
      khoản, chỉnh ví trực tiếp, tra cứu thông tin 1 user.
      - **Cấm tài khoản** (`BannedUserDao`, bảng MỚI `banned_users`) — tách
        RIÊNG khỏi bảng `users` thay vì thêm cột `banned` vào `User` record
        (record đó dùng ở RẤT nhiều nơi: đăng ký/đăng nhập/liên kết mạng xã
        hội/nâng cấp khách...), tránh phải sửa hàng loạt chỗ chỉ để thêm 1
        cờ quản trị. `POST /api/admin/users/ban` {userId, reason},
        `POST /api/admin/users/unban` {userId}. Chặn đăng nhập ở CẢ 3 lối
        vào (`LoginHandler`/`GuestLoginHandler`/`SocialLoginHandler`) —
        tài khoản bị cấm bị từ chối (403) dù đăng nhập bằng mật khẩu/khách/
        mạng xã hội.
      - **Chỉnh ví GM** (`WalletDao.adjustGold`/`adjustDiamond`, method
        MỚI) — khác `addGold`/`spendGold` có sẵn (chỉ cộng, hoặc trừ có
        kiểm tra đủ tiền), admin được TRỪ TUỲ Ý (delta âm), chỉ kẹp về 0
        chứ không chặn thao tác. `POST /api/admin/users/wallet/adjust`
        {userId, goldDelta, diamondDelta}.
      - **Tra cứu user** (`AdminLookupUserHandler`) — gộp
        `User`/`Character`/`Wallet`/`LevelInfo`/trạng thái cấm vào 1
        response, phục vụ hỗ trợ/kiểm duyệt. `GET /api/admin/users/lookup?userId=`.
      Test: `BannedUserDaoTest` (đơn vị); `WalletDaoTest` thêm test cho
      `adjustGold`/`adjustDiamond` (áp dụng delta dương, kẹp về 0 khi delta
      âm vượt quá số dư, không đụng tới trường còn lại); `AuthFlowTest`
      thêm 3 test (tài khoản bị cấm không đăng nhập được qua CẢ 3 lối vào);
      `AdminUserManagementHttpFlowTest` (nối dây HTTP thật cho cả 4
      endpoint, kiểm nhánh 503 khi chưa cấu hình `ADMIN_TOKEN` — logic so
      khớp token đã kiểm đủ ở `AdminAuthTest`).
- [x] **Giai đoạn 29 — admin quản lý guild**: mở rộng phạm vi admin sang
      GUILD — admin giải tán BẤT KỲ guild nào, đuổi BẤT KỲ thành viên nào
      (kể cả hội trưởng), không cần hợp tác từ phía guild đó.
      - `GuildService.adminDisband`/`adminKick` (method MỚI) — khác
        `disband`/`kick` sẵn có (chỉ hội trưởng tự giải tán guild mình,
        hội trưởng/phó kick nhưng KHÔNG kick được hội trưởng), admin bỏ
        qua hết các ràng buộc phân quyền đó, chỉ còn kiểm tra guild/thành
        viên có tồn tại. `POST /api/admin/guild/disband` {guildId},
        `POST /api/admin/guild/kick` {guildId, targetUserId}.
      - Admin đuổi hội trưởng thì guild tạm thời KHÔNG có hội trưởng cho
        tới khi thành viên còn lại tự chuyển quyền — TODO tự động thăng
        cấp officer cũ nhất lên hội trưởng nếu cần sau này.
      - Không cần "kho item" cho phần này — guild không phải nội dung có
        thể "add bằng id" như item/giftcode/sự kiện, nên chỉ thêm 2 hành
        động quản trị trực tiếp thay vì CRUD đầy đủ.
      Test: `GuildFlowTest` thêm 5 test (`adminDisband` xoá guild bất kể ai
      là hội trưởng + từ chối guild không tồn tại; `adminKick` đuổi được cả
      hội trưởng + từ chối đuổi sai guild; endpoint HTTP đòi hỏi
      `ADMIN_TOKEN` giống các endpoint admin khác).

## Chạy thử

```
cd server
mvn compile
mvn test
mvn -Dserver.port=8080 exec:java
# hoặc: mvn package && java -jar target/game-server-0.1.0-SNAPSHOT.jar
```

### Chạy nhanh bằng file build (bấm 1 phát)

`pom.xml` đã cấu hình `maven-shade-plugin` — `mvn package` ra 1 file
`.jar` gộp sẵn hết thư viện (`target/game-server-0.1.0-SNAPSHOT.jar`),
chạy được bằng `java -jar` mà không cần Maven/IDE nữa. Để tiện hơn nữa,
dùng script tự build (nếu chưa có `.jar`) + tự chạy:

- Windows: bấm đúp `start.bat` (hoặc chạy trong Command Prompt).
- Mac/Linux: `./start.sh`.

Mặc định nối `jdbc:mysql://localhost:3306/game` (user `root`, không mật
khẩu) ở cổng `8080` — đổi bằng biến môi trường trước khi chạy nếu cần:
`DB_URL`, `DB_USER`, `DB_PASSWORD`, `DB_POOL_SIZE`, `SERVER_PORT`.
