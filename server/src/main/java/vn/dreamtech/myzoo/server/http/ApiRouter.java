package vn.dreamtech.myzoo.server.http;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.myzoo.server.auth.AccountService;
import vn.dreamtech.myzoo.server.catalog.Catalog;
import vn.dreamtech.myzoo.server.chat.ChatCatalog;
import vn.dreamtech.myzoo.server.chat.ChatService;
import vn.dreamtech.myzoo.server.config.GameConfig;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.gacha.CosmeticService;
import vn.dreamtech.myzoo.server.gacha.GachaService;
import vn.dreamtech.myzoo.server.minigame.MinigameService;
import vn.dreamtech.myzoo.server.mission.MissionService;
import vn.dreamtech.myzoo.server.mail.MailService;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.processing.ProcessingService;
import vn.dreamtech.myzoo.server.reward.AchievementService;
import vn.dreamtech.myzoo.server.reward.GiftcodeService;
import vn.dreamtech.myzoo.server.shop.ShopCatalog;
import vn.dreamtech.myzoo.server.shop.ShopService;
import vn.dreamtech.myzoo.server.social.SocialService;
import vn.dreamtech.myzoo.server.zoo.ZooService;

import java.io.IOException;
import java.util.Map;

public final class ApiRouter implements HttpHandler {
    private final PlayerService players;
    private final FarmService farm;
    private final ZooService zoo;
    private final MinigameService minigames;
    private final MissionService missions;
    private final AccountService accounts;
    private final SocialService social;
    private final MailService mail;
    private final GiftcodeService giftcodes;
    private final AchievementService achievements;
    private final ShopService shop;
    private final ProcessingService processing;
    private final ChatService chat;
    private final EconomyService economy;
    private final GachaService gacha;
    private final CosmeticService cosmetics;
    private final Idempotency idempotency;
    private final RateLimiter limiter;
    private final java.util.concurrent.atomic.AtomicLong requestCount = new java.util.concurrent.atomic.AtomicLong();

    public ApiRouter(PlayerService players, FarmService farm, ZooService zoo, MinigameService minigames,
                     MissionService missions, AccountService accounts, SocialService social, MailService mail,
                     GiftcodeService giftcodes, AchievementService achievements, ShopService shop,
                     ProcessingService processing, ChatService chat, EconomyService economy,
                     GachaService gacha, CosmeticService cosmetics,
                     Idempotency idempotency, RateLimiter limiter) {
        this.gacha = gacha;
        this.cosmetics = cosmetics;
        this.limiter = limiter;
        this.economy = economy;
        this.shop = shop;
        this.processing = processing;
        this.chat = chat;
        this.accounts = accounts;
        this.social = social;
        this.mail = mail;
        this.giftcodes = giftcodes;
        this.achievements = achievements;
        this.players = players;
        this.farm = farm;
        this.zoo = zoo;
        this.minigames = minigames;
        this.missions = missions;
        this.idempotency = idempotency;
    }

    private static final class Body {
        String guestToken;
        String name;
        String requestId;
        Integer plotIndex;
        String cropId;
        String typeId;
        Integer habitatId;
        String speciesId;
        String foodId;
        Integer quantity;
        String sessionId;
        Integer linesMade;
        String missionId;
        String username;
        String password;
        String newPassword;
        String serverId;
        String avatar;
        Integer friendId;
        String friendName;
        String type;
        Long mailId;
        String code;
        String achievementId;
        Integer targetPlayerId;
        String title;
        String body;
        Long rewardVang;
        Long rewardKc;
        Integer maxUses;
        Integer expiresDays;
        String itemId;
        String packId;
        String recipeId;
        Long slotId;
        String decorId;
        String gameType;
        Integer score;
        String channel;
        Integer targetId;
        String text;
        String refId;
        Long messageId;
        String mode;
        String reason;
        Long minutes;
        String voiceBase64;
        Integer durationMs;
        String bannerId;
        Integer count;
        String cosmeticId;
    }

    @Override
    public void handle(HttpExchange ex) throws IOException {
        try {
            route(ex);
        } catch (ApiException e) {
            JsonHttp.writeError(ex, e.status(), e.getMessage());
        } catch (Exception e) {
            JsonHttp.writeError(ex, 500, "Lỗi máy chủ: " + e.getMessage());
        }
    }

    private void route(HttpExchange ex) throws IOException {
        String path = ex.getRequestURI().getPath();
        String method = ex.getRequestMethod();
        String key = method + " " + path;

        // Bảo trì: chỉ cho phép đọc cấu hình để client hiện thông báo.
        if (GameConfig.maintenance() && !key.equals("GET /v1/config")) {
            JsonHttp.writeError(ex, 503, GameConfig.maintenanceMessage());
            return;
        }

        // Chặn spam ở đúng một chỗ — mọi request đều đi qua đây.
        int retryAfter = limiter.retryAfterSeconds(callerOf(ex), method, path);
        if (retryAfter > 0) {
            ex.getResponseHeaders().set("Retry-After", String.valueOf(retryAfter));
            JsonHttp.writeError(ex, 429, "Bạn thao tác quá nhanh, thử lại sau " + retryAfter + " giây");
            return;
        }
        if (requestCount.incrementAndGet() % 500 == 0) limiter.evictIdle();

        switch (key) {
            case "GET /v1/config" -> JsonHttp.write(ex, 200, Map.of(
                    "gameVersion", GameConfig.GAME_VERSION,
                    "minClientVersion", GameConfig.MIN_CLIENT_VERSION,
                    "maintenance", GameConfig.maintenance(),
                    "maintenanceMessage", GameConfig.maintenance() ? GameConfig.maintenanceMessage() : "",
                    "serverTime", System.currentTimeMillis()));
            case "GET /v1/servers" -> JsonHttp.write(ex, 200, Map.of("servers", GameConfig.SERVERS));
            case "POST /v1/servers/select" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.serverId != null, "Cần serverId");
                mutate(ex, b, playerId, () -> {
                    players.selectServer(playerId, b.serverId);
                    return players.profile(playerId);
                });
            }
            case "POST /v1/auth/register" -> {
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.username != null && b.password != null, "Cần username và password");
                JsonHttp.write(ex, 200, accounts.register(b.username, b.password, b.guestToken));
            }
            case "POST /v1/auth/login" -> {
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.username != null && b.password != null, "Cần username và password");
                JsonHttp.write(ex, 200, accounts.login(b.username, b.password));
            }
            case "POST /v1/auth/logout" -> {
                players.logout(tokenOf(ex));
                JsonHttp.write(ex, 200, Map.of("ok", true));
            }
            case "POST /v1/auth/password" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.password != null && b.newPassword != null, "Cần password và newPassword");
                accounts.changePassword(playerId, b.password, b.newPassword);
                JsonHttp.write(ex, 200, Map.of("ok", true));
            }
            case "POST /v1/players" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.name != null, "Cần name");
                // Chỉ cho đặt ngoại hình gốc hoặc món đã sở hữu — trước đây client gửi chuỗi gì cũng nhận.
                cosmetics.requireWearable(playerId, b.avatar);
                mutate(ex, b, playerId, () -> players.createCharacter(playerId, b.name, b.avatar));
            }
            case "GET /v1/world/snapshot" -> {
                int playerId = auth(ex);
                JsonHttp.write(ex, 200, Map.of(
                        "me", players.profile(playerId),
                        "farm", farm.view(playerId),
                        "zoo", zoo.view(playerId),
                        "missions", missions.view(playerId)));
            }
            case "POST /v1/auth/guest" -> {
                Body b = JsonHttp.readBody(ex, Body.class);
                JsonHttp.write(ex, 200, players.guestLogin(b.guestToken));
            }
            case "GET /v1/catalog" -> JsonHttp.write(ex, 200, Map.of(
                    "crops", Catalog.CROPS,
                    "species", Catalog.SPECIES,
                    "habitatTypes", Catalog.HABITAT_TYPES,
                    "products", Catalog.PRODUCTS,
                    "decors", Catalog.DECORS,
                    "recipes", ProcessingService.RECIPES,
                    "games", MinigameService.GAMES,
                    "plotCount", FarmService.PLOT_COUNT));
            case "GET /v1/me" -> JsonHttp.write(ex, 200, players.profile(auth(ex)));
            case "GET /v1/gacha/banners" -> {
                auth(ex);
                JsonHttp.write(ex, 200, Map.of("banners", gacha.banners()));
            }
            case "POST /v1/gacha/pull" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                mutate(ex, b, playerId, () -> gacha.pull(playerId, b.bannerId, b.count == null ? 1 : b.count));
            }
            case "GET /v1/gacha/history" -> {
                int playerId = auth(ex);
                Integer limit = QueryParam.intParam(ex.getRequestURI().getQuery(), "limit");
                JsonHttp.write(ex, 200, Map.of(
                        "pulls", gacha.history(playerId, limit == null ? 50 : limit),
                        "fragments", gacha.fragments(playerId),
                        "pity", gacha.pityOf(playerId, GachaService.DEFAULT_BANNER)));
            }
            case "POST /v1/gacha/exchange" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.cosmeticId != null, "Cần cosmeticId");
                mutate(ex, b, playerId, () -> gacha.exchange(playerId, b.cosmeticId));
            }
            case "GET /v1/cosmetics" -> {
                int playerId = auth(ex);
                JsonHttp.write(ex, 200, Map.of(
                        "cosmetics", cosmetics.list(playerId),
                        "fragments", gacha.fragments(playerId)));
            }
            case "POST /v1/cosmetics/equip" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.cosmeticId != null, "Cần cosmeticId");
                mutate(ex, b, playerId, () -> cosmetics.equip(playerId, b.cosmeticId));
            }
            case "GET /v1/wallet" -> {
                int playerId = auth(ex);
                String query = ex.getRequestURI().getQuery();
                Integer limit = QueryParam.intParam(query, "limit");
                int size = EconomyService.pageSize(limit == null ? 0 : limit);
                var entries = economy.history(playerId, QueryParam.longParam(query, "cursor"), size);
                var balances = economy.balances(playerId);
                JsonHttp.write(ex, 200, Map.of(
                        "vang", balances.get(EconomyService.VANG),
                        "kc", balances.get(EconomyService.KIM_CUONG),
                        "entries", entries,
                        // Trang cuối trả 0 để client biết dừng, khỏi phải gọi thêm một lần rỗng.
                        "nextCursor", entries.size() < size ? 0L : entries.get(entries.size() - 1).id()));
            }
            case "POST /v1/players/name" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                players.setName(playerId, b.name);
                JsonHttp.write(ex, 200, players.profile(playerId));
            }
            case "GET /v1/farm" -> JsonHttp.write(ex, 200, farm.view(auth(ex)));
            case "POST /v1/farm/plant" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.plotIndex != null && b.cropId != null, "Cần plotIndex và cropId");
                mutate(ex, b, playerId, () -> {
                    var r = farm.plant(playerId, b.plotIndex, b.cropId);
                    track(playerId, "PLANT", 1);
                    return r;
                });
            }
            case "POST /v1/farm/harvest" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.plotIndex != null, "Cần plotIndex");
                mutate(ex, b, playerId, () -> {
                    var r = farm.harvest(playerId, b.plotIndex);
                    track(playerId, "HARVEST", 1);
                    return r;
                });
            }
            case "POST /v1/farm/sell" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.foodId != null && b.quantity != null, "Cần foodId và quantity");
                mutate(ex, b, playerId, () -> {
                    var r = farm.sell(playerId, b.foodId, b.quantity);
                    track(playerId, "SELL", r.quantity());
                    return r;
                });
            }
            case "GET /v1/missions" -> JsonHttp.write(ex, 200, Map.of("missions", missions.view(auth(ex))));
            case "POST /v1/missions/claim" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.missionId != null, "Cần missionId");
                mutate(ex, b, playerId, () -> missions.claim(playerId, b.missionId));
            }
            case "POST /v1/daily/checkin" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                mutate(ex, b, playerId, () -> missions.checkin(playerId));
            }
            case "POST /v1/admin/mail" -> {
                requireAdmin(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.targetPlayerId != null && b.title != null, "Cần targetPlayerId và title");
                long id = mail.send(b.targetPlayerId, b.title, b.body == null ? "" : b.body,
                        b.rewardVang == null ? 0 : b.rewardVang, b.rewardKc == null ? 0 : b.rewardKc,
                        b.foodId, b.quantity == null ? 0 : b.quantity);
                JsonHttp.write(ex, 200, Map.of("mailId", id));
            }
            case "POST /v1/admin/giftcode" -> {
                requireAdmin(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.code != null, "Cần code");
                long days = b.expiresDays == null ? 30 : b.expiresDays;
                giftcodes.create(b.code,
                        b.rewardVang == null ? 0 : b.rewardVang, b.rewardKc == null ? 0 : b.rewardKc,
                        b.foodId, b.quantity == null ? 0 : b.quantity,
                        b.maxUses == null ? 1000 : b.maxUses,
                        System.currentTimeMillis() + days * 24 * 60 * 60 * 1000L);
                JsonHttp.write(ex, 200, Map.of("code", GiftcodeService.normalize(b.code)));
            }
            case "GET /v1/chat/catalog" -> {
                auth(ex);
                JsonHttp.write(ex, 200, Map.of("stickers", ChatCatalog.STICKERS, "gifs", ChatCatalog.GIFS,
                        "maxTextLength", vn.dreamtech.myzoo.server.chat.ChatModeration.MAX_LENGTH));
            }
            case "GET /v1/chat/world" -> {
                int playerId = auth(ex);
                String query = ex.getRequestURI().getQuery();
                Integer since = QueryParam.intParam(query, "sinceId");
                Integer limit = QueryParam.intParam(query, "limit");
                JsonHttp.write(ex, 200, Map.of(
                        "messages", chat.world(playerId, since == null ? null : since.longValue(),
                                limit == null ? 50 : limit),
                        "ban", chat.banInfo(playerId)));
            }
            case "GET /v1/chat/private" -> {
                int playerId = auth(ex);
                String query = ex.getRequestURI().getQuery();
                Integer other = QueryParam.intParam(query, "playerId");
                Integer since = QueryParam.intParam(query, "sinceId");
                Integer limit = QueryParam.intParam(query, "limit");
                requireFields(other != null, "Cần playerId");
                JsonHttp.write(ex, 200, Map.of("messages",
                        chat.conversation(playerId, other, since == null ? null : since.longValue(),
                                limit == null ? 50 : limit)));
            }
            case "POST /v1/chat/send" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                mutate(ex, b, playerId, () -> chat.send(playerId, b.channel, b.targetId, b.type, b.text, b.refId));
            }
            case "POST /v1/chat/voice" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.voiceBase64 != null && b.durationMs != null, "Cần voiceBase64 và durationMs");
                byte[] data;
                try {
                    data = java.util.Base64.getDecoder().decode(b.voiceBase64);
                } catch (IllegalArgumentException e) {
                    throw new ApiException(400, "Dữ liệu ghi âm không hợp lệ");
                }
                mutate(ex, b, playerId, () -> chat.saveVoice(playerId, data, b.durationMs));
            }
            case "GET /v1/chat/voice" -> {
                int playerId = auth(ex);
                String voiceId = QueryParam.stringParam(ex.getRequestURI().getQuery(), "voiceId");
                requireFields(voiceId != null, "Cần voiceId");
                byte[] data = chat.readVoice(playerId, voiceId);
                ex.getResponseHeaders().add("Content-Type", "application/octet-stream");
                ex.sendResponseHeaders(200, data.length);
                try (var os = ex.getResponseBody()) {
                    os.write(data);
                }
            }
            case "GET /v1/chat/relations" -> JsonHttp.write(ex, 200, chat.relations(auth(ex)));
            case "POST /v1/chat/relations" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.targetId != null && b.mode != null, "Cần targetId và mode");
                mutate(ex, b, playerId, () -> {
                    chat.setRelation(playerId, b.targetId, b.mode);
                    return chat.relations(playerId);
                });
            }
            case "POST /v1/chat/report" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.messageId != null, "Cần messageId");
                mutate(ex, b, playerId, () -> {
                    chat.report(playerId, b.messageId, b.reason);
                    return Map.of("ok", true);
                });
            }
            case "POST /v1/admin/chat/delete" -> {
                requireAdmin(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.messageId != null, "Cần messageId");
                chat.deleteMessage(b.messageId, 0);
                JsonHttp.write(ex, 200, Map.of("ok", true));
            }
            case "POST /v1/admin/chat/ban" -> {
                requireAdmin(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.targetPlayerId != null, "Cần targetPlayerId");
                if (b.minutes != null && b.minutes <= 0) {
                    chat.unbanChat(b.targetPlayerId);
                    JsonHttp.write(ex, 200, Map.of("ok", true));
                } else {
                    JsonHttp.write(ex, 200, chat.banChat(b.targetPlayerId,
                            b.minutes == null ? 60 : b.minutes, b.reason));
                }
            }
            case "POST /v1/admin/chat/announce" -> {
                requireAdmin(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.text != null, "Cần text");
                JsonHttp.write(ex, 200, Map.of("messageId", chat.system(b.text)));
            }
            case "GET /v1/admin/chat/log" -> {
                requireAdmin(ex);
                String query = ex.getRequestURI().getQuery();
                Integer since = QueryParam.intParam(query, "sinceId");
                Integer limit = QueryParam.intParam(query, "limit");
                JsonHttp.write(ex, 200, Map.of("messages",
                        chat.adminLog(QueryParam.stringParam(query, "channel"),
                                since == null ? null : since.longValue(), limit == null ? 100 : limit)));
            }
            case "GET /v1/admin/chat/reports" -> {
                requireAdmin(ex);
                Integer limit = QueryParam.intParam(ex.getRequestURI().getQuery(), "limit");
                JsonHttp.write(ex, 200, Map.of("reports", chat.reports(limit == null ? 50 : limit)));
            }
            case "GET /v1/processing" -> JsonHttp.write(ex, 200, processing.view(auth(ex)));
            case "POST /v1/processing/start" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.recipeId != null, "Cần recipeId");
                mutate(ex, b, playerId, () -> processing.start(playerId, b.recipeId));
            }
            case "POST /v1/processing/collect" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.slotId != null, "Cần slotId");
                mutate(ex, b, playerId, () -> processing.collect(playerId, b.slotId));
            }
            case "POST /v1/zoo/decors" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.habitatId != null && b.decorId != null, "Cần habitatId và decorId");
                mutate(ex, b, playerId, () -> zoo.buyDecor(playerId, b.habitatId, b.decorId));
            }
            case "GET /v1/shop" -> {
                auth(ex);
                JsonHttp.write(ex, 200, Map.of("items", ShopCatalog.ITEMS, "kcPacks", ShopCatalog.KC_PACKS));
            }
            case "GET /v1/inventory" -> JsonHttp.write(ex, 200, Map.of("items", shop.inventory(auth(ex))));
            case "POST /v1/shop/purchase" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.itemId != null, "Cần itemId");
                mutate(ex, b, playerId, () -> shop.purchase(playerId, b.itemId,
                        b.quantity == null ? 1 : b.quantity));
            }
            case "POST /v1/items/use" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.itemId != null, "Cần itemId");
                mutate(ex, b, playerId, () -> shop.use(playerId, b.itemId, b.plotIndex));
            }
            case "POST /v1/shop/topup" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.packId != null, "Cần packId");
                mutate(ex, b, playerId, () -> shop.topup(playerId, b.packId));
            }
            case "GET /v1/mails" -> JsonHttp.write(ex, 200, Map.of("mails", mail.inbox(auth(ex))));
            case "POST /v1/mails/claim" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.mailId != null, "Cần mailId");
                mutate(ex, b, playerId, () -> mail.claim(playerId, b.mailId));
            }
            case "POST /v1/mails/claim-all" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                mutate(ex, b, playerId, () -> Map.of("claimed", mail.claimAll(playerId)));
            }
            case "POST /v1/giftcodes/redeem" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.code != null, "Cần code");
                mutate(ex, b, playerId, () -> giftcodes.redeem(playerId, b.code));
            }
            case "GET /v1/achievements" -> JsonHttp.write(ex, 200,
                    Map.of("achievements", achievements.view(auth(ex))));
            case "POST /v1/achievements/claim" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.achievementId != null, "Cần achievementId");
                mutate(ex, b, playerId, () -> achievements.claim(playerId, b.achievementId));
            }
            case "GET /v1/collection" -> JsonHttp.write(ex, 200,
                    Map.of("species", achievements.collection(auth(ex))));
            case "GET /v1/friends" -> JsonHttp.write(ex, 200, social.view(auth(ex)));
            case "POST /v1/friends/request" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.friendName != null, "Cần friendName");
                mutate(ex, b, playerId, () -> {
                    social.sendRequest(playerId, b.friendName);
                    return social.view(playerId);
                });
            }
            case "POST /v1/friends/accept" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.friendId != null, "Cần friendId");
                mutate(ex, b, playerId, () -> {
                    social.accept(playerId, b.friendId);
                    return social.view(playerId);
                });
            }
            case "POST /v1/friends/remove" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.friendId != null, "Cần friendId");
                mutate(ex, b, playerId, () -> {
                    social.remove(playerId, b.friendId);
                    return social.view(playerId);
                });
            }
            case "GET /v1/friends/visit" -> {
                int playerId = auth(ex);
                Integer friendId = QueryParam.intParam(ex.getRequestURI().getQuery(), "friendId");
                requireFields(friendId != null, "Cần friendId");
                JsonHttp.write(ex, 200, social.visit(playerId, friendId));
            }
            case "POST /v1/friends/help" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.friendId != null, "Cần friendId");
                mutate(ex, b, playerId, () -> {
                    var r = social.help(playerId, b.friendId);
                    track(playerId, "FRIEND_HELP", 1);
                    return r;
                });
            }
            case "GET /v1/leaderboard" -> {
                auth(ex);
                String query = ex.getRequestURI().getQuery();
                String type = QueryParam.stringParam(query, "type");
                Integer limit = QueryParam.intParam(query, "limit");
                JsonHttp.write(ex, 200, Map.of("rows",
                        social.leaderboard(type == null ? "zoo" : type, limit == null ? 20 : limit)));
            }
            case "GET /v1/zoo" -> JsonHttp.write(ex, 200, zoo.view(auth(ex)));
            case "POST /v1/zoo/habitats" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.typeId != null, "Cần typeId");
                mutate(ex, b, playerId, () -> zoo.buyHabitat(playerId, b.typeId));
            }
            case "POST /v1/zoo/animals" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.habitatId != null && b.speciesId != null, "Cần habitatId và speciesId");
                mutate(ex, b, playerId, () -> {
                    var r = zoo.buyAnimal(playerId, b.habitatId, b.speciesId);
                    try {
                        achievements.recordSpecies(playerId, b.speciesId);
                        announceRareAnimal(playerId, b.speciesId);
                    } catch (RuntimeException ignored) {
                    }
                    return r;
                });
            }
            case "POST /v1/zoo/deliver" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.foodId != null && b.quantity != null, "Cần foodId và quantity");
                mutate(ex, b, playerId, () -> zoo.deliver(playerId, b.foodId, b.quantity));
            }
            case "POST /v1/zoo/feed" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.habitatId != null, "Cần habitatId");
                mutate(ex, b, playerId, () -> {
                    var r = zoo.feed(playerId, b.habitatId);
                    track(playerId, "FEED", r.animalsFed());
                    return r;
                });
            }
            case "POST /v1/zoo/open" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                mutate(ex, b, playerId, () -> {
                    zoo.open(playerId);
                    return zoo.view(playerId);
                });
            }
            case "POST /v1/zoo/close" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                mutate(ex, b, playerId, () -> zoo.close(playerId));
            }
            case "POST /v1/zoo/collect" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                mutate(ex, b, playerId, () -> {
                    var r = zoo.collect(playerId);
                    if (r.vangEarned() > 0) track(playerId, "COLLECT", 1);
                    return r;
                });
            }
            case "POST /v1/minigames/session" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                mutate(ex, b, playerId, () -> minigames.create(playerId, b.gameType));
            }
            case "POST /v1/minigames/finish" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                Integer score = b.score != null ? b.score : b.linesMade;
                requireFields(b.sessionId != null && score != null, "Cần sessionId và score");
                mutate(ex, b, playerId, () -> {
                    var r = minigames.finish(playerId, b.sessionId, score);
                    if (r.newlyFinished()) track(playerId, "MINIGAME", 1);
                    return r;
                });
            }
            default -> JsonHttp.writeError(ex, 404, "Không có đường dẫn này");
        }
    }

    private int auth(HttpExchange ex) {
        return players.authenticate(tokenOf(ex));
    }

    // Đếm theo token nếu có (khỏi phải tra DB), không có thì theo IP để khách vãng lai cũng bị giới hạn.
    private static String callerOf(HttpExchange ex) {
        String token = tokenOf(ex);
        if (token != null && !token.isBlank()) return token;
        var remote = ex.getRemoteAddress();
        return remote == null ? "unknown" : remote.getAddress().getHostAddress();
    }

    private static String tokenOf(HttpExchange ex) {
        String session = ex.getRequestHeaders().getFirst("X-Session-Token");
        return session != null ? session : ex.getRequestHeaders().getFirst("X-Guest-Token");
    }

    private void mutate(HttpExchange ex, Body b, int playerId, java.util.function.Supplier<Object> action)
            throws IOException {
        JsonHttp.writeRaw(ex, 200, idempotency.execute(b.requestId, playerId, action));
    }

    // Khoe thú hiếm lên kênh hệ thống — tạo không khí và khuyến khích sưu tầm.
    private void announceRareAnimal(int playerId, String speciesId) {
        Catalog.species(speciesId).ifPresent(species -> {
            if (!"SSR".equals(species.rarity())) return;
            String name = players.profile(playerId).name();
            if (name == null) return;
            chat.system(name + " vừa đón " + species.name() + " [SSR] về sở thú!");
        });
    }

    // Admin chỉ mở khi đặt biến môi trường ADMIN_TOKEN trên server.
    private static void requireAdmin(HttpExchange ex) {
        String expected = GameConfig.adminToken();
        if (expected == null || expected.isBlank()) throw new ApiException(404, "Không có đường dẫn này");
        String given = ex.getRequestHeaders().getFirst("X-Admin-Token");
        if (!expected.equals(given)) throw new ApiException(401, "Sai admin token");
    }

    private static void requireFields(boolean ok, String message) {
        if (!ok) throw new ApiException(400, message);
    }

    // Tiến độ nhiệm vụ/thành tựu không được làm hỏng hành động chính.
    private void track(int playerId, String type, int amount) {
        try {
            missions.record(playerId, type, amount);
        } catch (RuntimeException ignored) {
        }
        try {
            achievements.record(playerId, type, amount);
        } catch (RuntimeException ignored) {
        }
    }
}
