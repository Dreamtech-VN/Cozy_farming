package vn.dreamtech.myzoo.server;

import com.sun.net.httpserver.HttpServer;
import vn.dreamtech.myzoo.server.db.DataSourceProvider;
import vn.dreamtech.myzoo.server.db.SchemaInit;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.http.ApiRouter;
import vn.dreamtech.myzoo.server.http.Idempotency;
import vn.dreamtech.myzoo.server.http.JsonHttp;
import vn.dreamtech.myzoo.server.http.StaticFileHandler;
import vn.dreamtech.myzoo.server.minigame.MinigameService;
import vn.dreamtech.myzoo.server.mission.MissionService;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.time.TimeSource;
import vn.dreamtech.myzoo.server.zoo.ZooService;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;
import java.util.concurrent.Executors;

public final class Main {
    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getenv().getOrDefault("SERVER_PORT", "8080"));
        DataSource dataSource = DataSourceProvider.create();
        SchemaInit.run(dataSource);

        TimeSource time = TimeSource.system();
        EconomyService economy = new EconomyService(dataSource, time);
        PlayerService players = new PlayerService(dataSource, economy, time);
        FarmService farm = new FarmService(dataSource, economy, players, time);
        ZooService zoo = new ZooService(dataSource, economy, farm, players, time);
        MinigameService minigames = new MinigameService(dataSource, economy, players, time);
        MissionService missions = new MissionService(dataSource, economy, players, time);
        Idempotency idempotency = new Idempotency(dataSource, time);

        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/v1", new ApiRouter(players, farm, zoo, minigames, missions, idempotency));
        server.createContext("/health", ex -> JsonHttp.write(ex, 200, Map.of("status", "ok")));

        Path clientDir = Path.of(System.getenv().getOrDefault("CLIENT_DIR", "client"));
        if (Files.isDirectory(clientDir)) {
            server.createContext("/", new StaticFileHandler(clientDir));
        }

        server.setExecutor(Executors.newFixedThreadPool(16));
        server.start();
        System.out.println("MyZoo server chạy tại http://localhost:" + port
                + (Files.isDirectory(clientDir) ? " (client: " + clientDir.toAbsolutePath() + ")" : ""));
    }

    private Main() {
    }
}
