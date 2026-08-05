package vn.dreamtech.cozyfarming.server.livestock;

/** Khớp {@code AnimalDef} trong `src/data/animals.ts` — chỉ số liệu cân bằng, không đụng sprite. */
public record AnimalDef(String id, int price, String product, int productQtyMin, int productQtyMax,
                         int produceMin, int maturityMin, int exp) {
}
