package vn.dreamtech.cozyfarming.server.farm;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.FarmPlotDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.FarmPlot;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/** GET /api/farm/plots?userId=1 — danh sách ô đất kèm tiến độ lớn/sức khỏe TÍNH SẴN (không bắt client tự tính). */
public final class FarmPlotsHandler implements HttpHandler {
    private final FarmPlotDao plotDao;

    public FarmPlotsHandler(FarmPlotDao plotDao) {
        this.plotDao = plotDao;
    }

    record PlotView(int index, String state, String cropId, boolean watered, boolean fertilized,
                     double growth, int health, boolean ripe) {
        static PlotView of(FarmPlot p) {
            return new PlotView(p.index(), p.state(), p.cropId(), p.watered(), p.fertilized(),
                    FarmService.growth(p), FarmService.healthOf(p), FarmService.isRipe(p));
        }
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận GET");
            return;
        }
        Integer userId = FarmParams.userId(exchange.getRequestURI().getQuery());
        if (userId == null) {
            JsonHttp.writeError(exchange, 400, "Thiếu tham số userId");
            return;
        }
        try {
            List<FarmPlot> plots = plotDao.findAll(userId);
            JsonHttp.write(exchange, 200, plots.stream().map(PlotView::of).toList());
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi lấy danh sách ô đất: " + e.getMessage());
        }
    }
}

/** Đọc query param dùng chung cho cả nhóm handler nông trại. */
final class FarmParams {
    static Integer userId(String query) {
        return intParam(query, "userId");
    }

    static Integer intParam(String query, String key) {
        if (query == null) return null;
        for (String pair : query.split("&")) {
            int eq = pair.indexOf('=');
            if (eq < 0) continue;
            if (pair.substring(0, eq).equals(key)) {
                try {
                    return Integer.parseInt(pair.substring(eq + 1));
                } catch (NumberFormatException e) {
                    return null;
                }
            }
        }
        return null;
    }

    private FarmParams() {
    }
}
