package vn.dreamtech.myzoo.server.http;

import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

public final class JsonHttp {
    public static final Gson GSON = new Gson();

    public static <T> T readBody(HttpExchange exchange, Class<T> type) throws IOException {
        try (var reader = new InputStreamReader(exchange.getRequestBody(), StandardCharsets.UTF_8)) {
            T body = GSON.fromJson(reader, type);
            if (body == null) throw new ApiException(400, "Thiếu nội dung request");
            return body;
        }
    }

    public static void write(HttpExchange exchange, int status, Object body) throws IOException {
        writeRaw(exchange, status, GSON.toJson(body));
    }

    public static void writeRaw(HttpExchange exchange, int status, String json) throws IOException {
        byte[] bytes = json.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().set("Content-Type", "application/json; charset=utf-8");
        exchange.sendResponseHeaders(status, bytes.length);
        try (var os = exchange.getResponseBody()) {
            os.write(bytes);
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
