package vn.dreamtech.cozyfarming.server;

import com.sun.net.httpserver.HttpServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import vn.dreamtech.cozyfarming.server.auth.ForgotPasswordRequestHandler;
import vn.dreamtech.cozyfarming.server.auth.ForgotPasswordResetHandler;
import vn.dreamtech.cozyfarming.server.auth.LoginHandler;
import vn.dreamtech.cozyfarming.server.auth.RegisterHandler;
import vn.dreamtech.cozyfarming.server.dao.AnimalDao;
import vn.dreamtech.cozyfarming.server.dao.BagDao;
import vn.dreamtech.cozyfarming.server.dao.FarmPlotDao;
import vn.dreamtech.cozyfarming.server.dao.FarmStoreDao;
import vn.dreamtech.cozyfarming.server.dao.ItemDao;
import vn.dreamtech.cozyfarming.server.dao.PasswordResetDao;
import vn.dreamtech.cozyfarming.server.dao.PondFishDao;
import vn.dreamtech.cozyfarming.server.dao.UserDao;
import vn.dreamtech.cozyfarming.server.dao.WalletDao;
import vn.dreamtech.cozyfarming.server.db.DataSourceProvider;
import vn.dreamtech.cozyfarming.server.farm.FarmPlotsHandler;
import vn.dreamtech.cozyfarming.server.farm.HarvestHandler;
import vn.dreamtech.cozyfarming.server.farm.PlantHandler;
import vn.dreamtech.cozyfarming.server.farm.TillHandler;
import vn.dreamtech.cozyfarming.server.farm.WaterHandler;
import vn.dreamtech.cozyfarming.server.fishpond.FeedFishHandler;
import vn.dreamtech.cozyfarming.server.fishpond.NetFishHandler;
import vn.dreamtech.cozyfarming.server.fishpond.PondHandler;
import vn.dreamtech.cozyfarming.server.fishpond.StockFryHandler;
import vn.dreamtech.cozyfarming.server.inventory.BagHandler;
import vn.dreamtech.cozyfarming.server.inventory.FarmStoreHandler;
import vn.dreamtech.cozyfarming.server.livestock.AnimalsHandler;
import vn.dreamtech.cozyfarming.server.livestock.BuyAnimalHandler;
import vn.dreamtech.cozyfarming.server.livestock.CollectAnimalHandler;
import vn.dreamtech.cozyfarming.server.livestock.FeedAnimalHandler;
import vn.dreamtech.cozyfarming.server.livestock.SellAnimalHandler;
import vn.dreamtech.cozyfarming.server.shop.BuyItemHandler;
import vn.dreamtech.cozyfarming.server.shop.SellItemHandler;
import vn.dreamtech.cozyfarming.server.wallet.WalletHandler;
import vn.dreamtech.cozyfarming.server.wardrobe.ItemsHandler;

import javax.sql.DataSource;
import java.net.InetSocketAddress;

/**
 * Điểm khởi động server. Giai đoạn 1: khung HTTP tối thiểu (/health). Giai
 * đoạn 2: DB + DAO. Giai đoạn 3: đăng ký/đăng nhập/quên mật khẩu. Giai đoạn
 * 4: tủ đồ trang bị. Giai đoạn 5: nông trại. Giai đoạn 6: vật nuôi. Giai
 * đoạn 7 (hiện tại): ví xu/kim cương — nối thật vào mua/bán vật nuôi. Module
 * còn lại (ao cá, kho, chat...) thêm dần.
 */
public final class Main {
    private static final Logger log = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getProperty("server.port", "8080"));
        DataSource dataSource = DataSourceProvider.create();
        UserDao userDao = new UserDao(dataSource);
        PasswordResetDao resetDao = new PasswordResetDao(dataSource);
        ItemDao itemDao = new ItemDao(dataSource);
        FarmPlotDao plotDao = new FarmPlotDao(dataSource);
        AnimalDao animalDao = new AnimalDao(dataSource);
        WalletDao walletDao = new WalletDao(dataSource);
        FarmStoreDao farmStoreDao = new FarmStoreDao(dataSource);
        BagDao bagDao = new BagDao(dataSource);
        PondFishDao pondFishDao = new PondFishDao(dataSource);

        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/health", new HealthCheckHandler());
        server.createContext("/api/register", new RegisterHandler(userDao));
        server.createContext("/api/login", new LoginHandler(userDao));
        server.createContext("/api/forgot/request", new ForgotPasswordRequestHandler(userDao, resetDao));
        server.createContext("/api/forgot/reset", new ForgotPasswordResetHandler(userDao, resetDao));
        server.createContext("/api/items", new ItemsHandler(itemDao));
        server.createContext("/api/wallet", new WalletHandler(walletDao));
        server.createContext("/api/inventory/farmstore", new FarmStoreHandler(farmStoreDao));
        server.createContext("/api/inventory/bag", new BagHandler(bagDao));
        server.createContext("/api/farm/plots", new FarmPlotsHandler(plotDao));
        server.createContext("/api/farm/till", new TillHandler(plotDao));
        server.createContext("/api/farm/plant", new PlantHandler(plotDao, farmStoreDao));
        server.createContext("/api/farm/water", new WaterHandler(plotDao));
        server.createContext("/api/farm/harvest", new HarvestHandler(plotDao, farmStoreDao));
        server.createContext("/api/livestock", new AnimalsHandler(animalDao));
        server.createContext("/api/livestock/buy", new BuyAnimalHandler(animalDao, walletDao));
        server.createContext("/api/livestock/feed", new FeedAnimalHandler(animalDao, bagDao));
        server.createContext("/api/livestock/collect", new CollectAnimalHandler(animalDao, farmStoreDao));
        server.createContext("/api/livestock/sell", new SellAnimalHandler(animalDao, walletDao));
        server.createContext("/api/fishpond", new PondHandler(pondFishDao));
        server.createContext("/api/fishpond/stock", new StockFryHandler(pondFishDao, walletDao));
        server.createContext("/api/fishpond/feed", new FeedFishHandler(pondFishDao, bagDao));
        server.createContext("/api/fishpond/net", new NetFishHandler(pondFishDao, farmStoreDao));
        server.createContext("/api/shop/buy", new BuyItemHandler(farmStoreDao, bagDao, walletDao));
        server.createContext("/api/shop/sell", new SellItemHandler(farmStoreDao, bagDao, walletDao));
        server.setExecutor(null);
        server.start();
        log.info("Cozy Farming server đang chạy ở cổng {}", port);
    }

    private Main() {
    }
}
