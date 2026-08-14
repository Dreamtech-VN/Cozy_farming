package vn.dreamtech.myzoo.server.http;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.myzoo.server.catalog.Catalog;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.minigame.MinigameService;
import vn.dreamtech.myzoo.server.mission.MissionService;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.zoo.ZooService;

import java.io.IOException;
import java.util.Map;

public final class ApiRouter implements HttpHandler {
    private final PlayerService players;
    private final FarmService farm;
    private final ZooService zoo;
    private final MinigameService minigames;
    private final MissionService missions;
    private final Idempotency idempotency;

    public ApiRouter(PlayerService players, FarmService farm, ZooService zoo, MinigameService minigames,
                     MissionService missions, Idempotency idempotency) {
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

        switch (key) {
            case "POST /v1/auth/guest" -> {
                Body b = JsonHttp.readBody(ex, Body.class);
                JsonHttp.write(ex, 200, players.guestLogin(b.guestToken));
            }
            case "GET /v1/catalog" -> JsonHttp.write(ex, 200, Map.of(
                    "crops", Catalog.CROPS,
                    "species", Catalog.SPECIES,
                    "habitatTypes", Catalog.HABITAT_TYPES,
                    "plotCount", FarmService.PLOT_COUNT));
            case "GET /v1/me" -> JsonHttp.write(ex, 200, players.profile(auth(ex)));
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
            case "GET /v1/missions" -> JsonHttp.write(ex, 200, missions.view(auth(ex)));
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
                mutate(ex, b, playerId, () -> zoo.buyAnimal(playerId, b.habitatId, b.speciesId));
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
                mutate(ex, b, playerId, () -> minigames.create(playerId));
            }
            case "POST /v1/minigames/finish" -> {
                int playerId = auth(ex);
                Body b = JsonHttp.readBody(ex, Body.class);
                requireFields(b.sessionId != null && b.linesMade != null, "Cần sessionId và linesMade");
                mutate(ex, b, playerId, () -> {
                    var r = minigames.finish(playerId, b.sessionId, b.linesMade);
                    if (r.newlyFinished()) track(playerId, "MINIGAME", 1);
                    return r;
                });
            }
            default -> JsonHttp.writeError(ex, 404, "Không có đường dẫn này");
        }
    }

    private int auth(HttpExchange ex) {
        return players.authenticate(ex.getRequestHeaders().getFirst("X-Guest-Token"));
    }

    private void mutate(HttpExchange ex, Body b, int playerId, java.util.function.Supplier<Object> action)
            throws IOException {
        JsonHttp.writeRaw(ex, 200, idempotency.execute(b.requestId, playerId, action));
    }

    private static void requireFields(boolean ok, String message) {
        if (!ok) throw new ApiException(400, message);
    }

    // Tiến độ nhiệm vụ không được làm hỏng hành động chính.
    private void track(int playerId, String type, int amount) {
        try {
            missions.record(playerId, type, amount);
        } catch (RuntimeException ignored) {
        }
    }
}
