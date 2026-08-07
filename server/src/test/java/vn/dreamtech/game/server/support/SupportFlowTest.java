package vn.dreamtech.game.server.support;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.SupportTicketDao;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;

class SupportFlowTest {
    private HttpServer server;
    private int port;
    private SupportTicketDao dao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:support_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE support_tickets (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, category VARCHAR(20) NOT NULL,
                  message VARCHAR(1000) NOT NULL, created_at TIMESTAMP NOT NULL, resolved BOOLEAN NOT NULL DEFAULT FALSE
                )
                """);
        }
        dao = new SupportTicketDao(dataSource);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/support/report", new ReportHandler(dao));
        server.createContext("/api/support/tickets", new MyTicketsHandler(dao));
        server.createContext("/api/admin/support/tickets", new AdminListTicketsHandler(dao));
        server.createContext("/api/admin/support/resolve", new AdminResolveTicketHandler(dao));
        server.setExecutor(null);
        server.start();
        port = server.getAddress().getPort();
    }

    @AfterEach
    void stop() {
        server.stop(0);
    }

    private HttpResponse<String> post(String path, Object body) throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + path))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(gson.toJson(body)))
                .build();
        return http.send(req, HttpResponse.BodyHandlers.ofString());
    }

    private HttpResponse<String> get(String path) throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + path)).GET().build();
        return http.send(req, HttpResponse.BodyHandlers.ofString());
    }

    @Test
    void invalidCategoryRejected() throws Exception {
        var res = post("/api/support/report", new ReportHandler.Req(1, "weird", "bug ở đâu đó"));
        assertEquals(400, res.statusCode());
    }

    @Test
    void blankMessageRejected() throws Exception {
        var res = post("/api/support/report", new ReportHandler.Req(1, "bug", "   "));
        assertEquals(400, res.statusCode());
    }

    @Test
    void fullCycle_reportThenListOnlyOwnTickets() throws Exception {
        var report = post("/api/support/report", new ReportHandler.Req(1, "bug", "cây không lớn"));
        assertEquals(201, report.statusCode());
        post("/api/support/report", new ReportHandler.Req(2, "contact", "hỏi thăm"));

        var mine = get("/api/support/tickets?userId=1");
        assertEquals(200, mine.statusCode());
        JsonArray arr = gson.fromJson(mine.body(), JsonArray.class);
        assertEquals(1, arr.size());
        assertEquals("bug", arr.get(0).getAsJsonObject().get("category").getAsString());
    }

    @Test
    void newTicketStartsUnresolved() throws Exception {
        post("/api/support/report", new ReportHandler.Req(1, "bug", "cây không lớn"));
        var ticket = dao.findByUser(1).get(0);
        assertEquals(false, ticket.resolved());
    }

    @Test
    void resolveMarksResolved() throws Exception {
        var ticket = dao.create(1, "bug", "cây không lớn", System.currentTimeMillis());
        assertEquals(true, dao.resolve(ticket.id()));
        assertEquals(true, dao.findByUser(1).get(0).resolved());
    }

    @Test
    void resolveUnknownTicketReturnsFalse() throws Exception {
        assertEquals(false, dao.resolve(999));
    }

    @Test
    void findAllUnresolvedOnlyExcludesResolved() throws Exception {
        var t1 = dao.create(1, "bug", "a", System.currentTimeMillis());
        dao.create(2, "contact", "b", System.currentTimeMillis());
        dao.resolve(t1.id());

        assertEquals(1, dao.findAll(true).size());
        assertEquals(2, dao.findAll(false).size());
    }

    @Test
    void adminEndpointsRequireAdminToken() throws Exception {
        var list = get("/api/admin/support/tickets");
        assertEquals(503, list.statusCode());

        var resolve = post("/api/admin/support/resolve", new AdminResolveTicketHandler.Req(1));
        assertEquals(503, resolve.statusCode());
    }
}
