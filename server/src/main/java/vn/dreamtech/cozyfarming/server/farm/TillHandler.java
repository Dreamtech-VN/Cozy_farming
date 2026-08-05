package vn.dreamtech.cozyfarming.server.farm;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.cozyfarming.server.dao.FarmPlotDao;
import vn.dreamtech.cozyfarming.server.http.JsonHttp;
import vn.dreamtech.cozyfarming.server.model.FarmPlot;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/** POST /api/farm/till {userId, index} — cuốc đất trống thành đất đã cuốc, khớp {@code till()} client. */
public final class TillHandler implements HttpHandler {
    private final FarmPlotDao plotDao;

    public TillHandler(FarmPlotDao plotDao) {
        this.plotDao = plotDao;
    }

    record Req(int userId, int index) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        try {
            Optional<FarmPlot> found = plotDao.find(req.userId(), req.index());
            FarmPlot current = found.orElse(FarmPlot.empty(req.index()));
            if (!"empty".equals(current.state())) {
                JsonHttp.writeError(exchange, 409, "Ô đất không ở trạng thái trống");
                return;
            }
            FarmPlot tilled = new FarmPlot(req.index(), "tilled", null, null, false, null, false, 100);
            plotDao.upsert(req.userId(), tilled);
            JsonHttp.write(exchange, 200, tilled);
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi cuốc đất: " + e.getMessage());
        }
    }
}
