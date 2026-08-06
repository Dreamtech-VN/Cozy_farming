package vn.dreamtech.game.server;

import com.sun.net.httpserver.HttpServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import vn.dreamtech.game.server.auth.ForgotPasswordRequestHandler;
import vn.dreamtech.game.server.auth.ForgotPasswordResetHandler;
import vn.dreamtech.game.server.auth.GuestLoginHandler;
import vn.dreamtech.game.server.auth.LinkSocialHandler;
import vn.dreamtech.game.server.auth.LoginHandler;
import vn.dreamtech.game.server.auth.RegisterHandler;
import vn.dreamtech.game.server.auth.SocialLoginHandler;
import vn.dreamtech.game.server.auth.UpgradeGuestHandler;
import vn.dreamtech.game.server.auth.oauth.AppleTokenVerifier;
import vn.dreamtech.game.server.auth.oauth.GoogleTokenVerifier;
import vn.dreamtech.game.server.account.ChangePasswordHandler;
import vn.dreamtech.game.server.account.DeleteAccountHandler;
import vn.dreamtech.game.server.character.CharacterHandler;
import vn.dreamtech.game.server.character.CreateCharacterHandler;
import vn.dreamtech.game.server.character.UpdateOutfitHandler;
import vn.dreamtech.game.server.chat.RecentMessagesHandler;
import vn.dreamtech.game.server.chat.SendMessageHandler;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.ChatMessageDao;
import vn.dreamtech.game.server.dao.PasswordResetDao;
import vn.dreamtech.game.server.dao.PresenceDao;
import vn.dreamtech.game.server.dao.FriendRequestDao;
import vn.dreamtech.game.server.dao.FriendshipDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.MarriageDao;
import vn.dreamtech.game.server.dao.MarriageProposalDao;
import vn.dreamtech.game.server.dao.SupportTicketDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.UserSettingsDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.db.DataSourceProvider;
import vn.dreamtech.game.server.level.AddExpHandler;
import vn.dreamtech.game.server.level.GetLevelHandler;
import vn.dreamtech.game.server.lobby.HeartbeatHandler;
import vn.dreamtech.game.server.lobby.LeaveLobbyHandler;
import vn.dreamtech.game.server.lobby.LobbyPlayersHandler;
import vn.dreamtech.game.server.settings.GetSettingsHandler;
import vn.dreamtech.game.server.settings.UpdateSettingsHandler;
import vn.dreamtech.game.server.social.friend.FriendsListHandler;
import vn.dreamtech.game.server.social.friend.PendingRequestsHandler;
import vn.dreamtech.game.server.social.friend.RemoveFriendHandler;
import vn.dreamtech.game.server.social.friend.RespondFriendRequestHandler;
import vn.dreamtech.game.server.social.friend.SendFriendRequestHandler;
import vn.dreamtech.game.server.social.gift.SendGiftHandler;
import vn.dreamtech.game.server.social.marriage.MarriageStatusHandler;
import vn.dreamtech.game.server.social.marriage.ProposeHandler;
import vn.dreamtech.game.server.social.marriage.RespondProposalHandler;
import vn.dreamtech.game.server.support.MyTicketsHandler;
import vn.dreamtech.game.server.support.ReportHandler;
import vn.dreamtech.game.server.wallet.AddCurrencyHandler;
import vn.dreamtech.game.server.wallet.GetWalletHandler;

import javax.sql.DataSource;
import java.net.InetSocketAddress;

/**
 * Điểm khởi động server. Giai đoạn 1: khung HTTP tối thiểu (/health) + DB.
 * Giai đoạn 2: tài khoản — đăng ký/đăng nhập/quên mật khẩu/khách, liên kết
 * khách->thường, đăng nhập/liên kết Google/Apple (khung xác thực dựng sẵn,
 * Apple chưa xong thật — xem {@code AppleTokenVerifier}). Giai đoạn 3 (hiện
 * tại): tạo nhân vật (giới tính/tên/trang phục cơ bản). Sảnh, chat, cài đặt
 * thêm dần ở các giai đoạn sau.
 */
public final class Main {
    private static final Logger log = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getProperty("server.port", "8080"));
        DataSource dataSource = DataSourceProvider.create();
        UserDao userDao = new UserDao(dataSource);
        PasswordResetDao resetDao = new PasswordResetDao(dataSource);
        CharacterDao characterDao = new CharacterDao(dataSource);
        PresenceDao presenceDao = new PresenceDao(dataSource);
        ChatMessageDao chatMessageDao = new ChatMessageDao(dataSource);
        UserSettingsDao settingsDao = new UserSettingsDao(dataSource);
        SupportTicketDao supportTicketDao = new SupportTicketDao(dataSource);
        FriendRequestDao friendRequestDao = new FriendRequestDao(dataSource);
        FriendshipDao friendshipDao = new FriendshipDao(dataSource);
        MarriageProposalDao marriageProposalDao = new MarriageProposalDao(dataSource);
        MarriageDao marriageDao = new MarriageDao(dataSource);
        LevelDao levelDao = new LevelDao(dataSource);
        WalletDao walletDao = new WalletDao(dataSource);
        var googleVerifier = new GoogleTokenVerifier(System.getenv("GOOGLE_CLIENT_ID"));
        var appleVerifier = new AppleTokenVerifier();

        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/health", new HealthCheckHandler());
        server.createContext("/api/auth/register", new RegisterHandler(userDao));
        server.createContext("/api/auth/login", new LoginHandler(userDao));
        server.createContext("/api/auth/guest", new GuestLoginHandler(userDao));
        server.createContext("/api/auth/forgot/request", new ForgotPasswordRequestHandler(userDao, resetDao));
        server.createContext("/api/auth/forgot/reset", new ForgotPasswordResetHandler(userDao, resetDao));
        server.createContext("/api/auth/link/upgrade", new UpgradeGuestHandler(userDao));
        server.createContext("/api/auth/social/google", new SocialLoginHandler(userDao, googleVerifier, SocialLoginHandler.Provider.GOOGLE));
        server.createContext("/api/auth/social/apple", new SocialLoginHandler(userDao, appleVerifier, SocialLoginHandler.Provider.APPLE));
        server.createContext("/api/auth/link/google", new LinkSocialHandler(userDao, googleVerifier, SocialLoginHandler.Provider.GOOGLE));
        server.createContext("/api/auth/link/apple", new LinkSocialHandler(userDao, appleVerifier, SocialLoginHandler.Provider.APPLE));
        server.createContext("/api/character/create", new CreateCharacterHandler(userDao, characterDao));
        server.createContext("/api/character", new CharacterHandler(characterDao));
        server.createContext("/api/character/outfit", new UpdateOutfitHandler(characterDao));
        server.createContext("/api/lobby/heartbeat", new HeartbeatHandler(characterDao, presenceDao));
        server.createContext("/api/lobby/leave", new LeaveLobbyHandler(presenceDao));
        server.createContext("/api/lobby/players", new LobbyPlayersHandler(presenceDao, characterDao));
        server.createContext("/api/chat/send", new SendMessageHandler(characterDao, chatMessageDao));
        server.createContext("/api/chat/recent", new RecentMessagesHandler(chatMessageDao));
        server.createContext("/api/settings", new GetSettingsHandler(settingsDao));
        server.createContext("/api/settings/update", new UpdateSettingsHandler(settingsDao));
        server.createContext("/api/account/change-password", new ChangePasswordHandler(userDao));
        server.createContext("/api/account/delete", new DeleteAccountHandler(userDao));
        server.createContext("/api/support/report", new ReportHandler(supportTicketDao));
        server.createContext("/api/support/tickets", new MyTicketsHandler(supportTicketDao));
        server.createContext("/api/friends/request", new SendFriendRequestHandler(friendRequestDao, friendshipDao, settingsDao));
        server.createContext("/api/friends/respond", new RespondFriendRequestHandler(friendRequestDao, friendshipDao));
        server.createContext("/api/friends/requests", new PendingRequestsHandler(friendRequestDao));
        server.createContext("/api/friends/remove", new RemoveFriendHandler(friendshipDao));
        server.createContext("/api/friends/gift", new SendGiftHandler(friendshipDao));
        server.createContext("/api/friends", new FriendsListHandler(friendshipDao, characterDao));
        server.createContext("/api/marriage/propose", new ProposeHandler(friendshipDao, marriageDao, marriageProposalDao));
        server.createContext("/api/marriage/respond", new RespondProposalHandler(marriageProposalDao, marriageDao));
        server.createContext("/api/marriage/status", new MarriageStatusHandler(marriageDao));
        server.createContext("/api/level", new GetLevelHandler(levelDao));
        server.createContext("/api/level/add-exp", new AddExpHandler(levelDao));
        server.createContext("/api/wallet", new GetWalletHandler(walletDao));
        server.createContext("/api/wallet/add", new AddCurrencyHandler(walletDao));
        server.setExecutor(null);
        server.start();
        log.info("Game server đang chạy ở cổng {}", port);
    }

    private Main() {
    }
}
