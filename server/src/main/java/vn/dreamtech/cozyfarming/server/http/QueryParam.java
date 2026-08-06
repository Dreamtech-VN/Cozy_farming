package vn.dreamtech.cozyfarming.server.http;

/** Đọc query param dùng chung cho mọi handler GET — trước bị lặp code này ở 2 nhóm handler (farm/livestock). */
public final class QueryParam {
    public static Integer intParam(String query, String key) {
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

    public static String stringParam(String query, String key) {
        if (query == null) return null;
        for (String pair : query.split("&")) {
            int eq = pair.indexOf('=');
            if (eq < 0) continue;
            if (pair.substring(0, eq).equals(key)) {
                return pair.substring(eq + 1);
            }
        }
        return null;
    }

    private QueryParam() {
    }
}
