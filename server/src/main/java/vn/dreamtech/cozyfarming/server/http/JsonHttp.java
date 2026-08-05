package vn.dreamtech.cozyfarming.server.http;

import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

/** Đọc/ghi JSON dùng chung cho mọi HTTP handler — tránh lặp code Gson + response headers. */
public final class JsonHttp {
    private static final Gson GSON = new Gson();

    public static <T> T readBody(HttpExchange exchange, Class<T> type) throws IOException {
        try (var reader = new InputStreamReader(exchange.getRequestBody(), StandardCharsets.UTF_8)) {
            T body = GSON.fromJson(reader, type);
            if (body == null) throw new IOException("Thiếu nội dung request");
            return body;
        }
    }

    public static void write(HttpExchange exchange, int status, Object body) throws IOException {
        byte[] json = GSON.toJson(body).getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().set("Content-Type", "application/json; charset=utf-8");
        exchange.sendResponseHeaders(status, json.length);
        try (var os = exchange.getResponseBody()) {
            os.write(json);
        }
    }

    public static void writeError(HttpExchange exchange, int status, String message) throws IOException {
        write(exchange, status, new ErrorBody(message));
    }

    public record ErrorBody(String error) {
    }

    private JsonHttp() {
    }
}
