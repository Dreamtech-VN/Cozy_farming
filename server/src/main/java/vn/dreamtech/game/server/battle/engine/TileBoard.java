package vn.dreamtech.game.server.battle.engine;

import java.util.Random;

/**
 * Bàn cờ match-3 — mỗi ô là 1 số nguyên (màu gem 0..colorCount-1), {@code
 * EMPTY} là ô rỗng tạm thời trong lúc rơi/tái tạo.
 */
public final class TileBoard {
    public static final int EMPTY = -1;

    private final int rows;
    private final int cols;
    private final int[][] grid;

    public TileBoard(int rows, int cols) {
        this.rows = rows;
        this.cols = cols;
        this.grid = new int[rows][cols];
    }

    public int rows() {
        return rows;
    }

    public int cols() {
        return cols;
    }

    public int get(int row, int col) {
        return grid[row][col];
    }

    public void set(int row, int col, int value) {
        grid[row][col] = value;
    }

    public boolean inBounds(int row, int col) {
        return row >= 0 && row < rows && col >= 0 && col < cols;
    }

    public void swapCells(int r1, int c1, int r2, int c2) {
        int tmp = grid[r1][c1];
        grid[r1][c1] = grid[r2][c2];
        grid[r2][c2] = tmp;
    }

    public TileBoard copy() {
        TileBoard copy = new TileBoard(rows, cols);
        for (int r = 0; r < rows; r++) {
            System.arraycopy(grid[r], 0, copy.grid[r], 0, cols);
        }
        return copy;
    }

    /** Ô rỗng "rơi" xuống đáy, ô có màu dồn xuống theo trọng lực (giữ thứ tự trong cột). */
    public void applyGravity() {
        for (int c = 0; c < cols; c++) {
            int writeRow = rows - 1;
            for (int r = rows - 1; r >= 0; r--) {
                if (grid[r][c] != EMPTY) {
                    grid[writeRow][c] = grid[r][c];
                    writeRow--;
                }
            }
            for (int r = writeRow; r >= 0; r--) {
                grid[r][c] = EMPTY;
            }
        }
    }

    /** Lấp các ô rỗng còn lại (sau {@link #applyGravity()}) bằng màu ngẫu nhiên. */
    public void refill(Random random, int colorCount) {
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                if (grid[r][c] == EMPTY) {
                    grid[r][c] = random.nextInt(colorCount);
                }
            }
        }
    }

    /** Xáo lại vị trí các ô hiện có (giữ nguyên số lượng mỗi màu) — dùng khi bàn cờ bị kẹt, không còn nước đi hợp lệ. */
    public void shuffle(Random random) {
        int total = rows * cols;
        int[] flat = new int[total];
        int i = 0;
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                flat[i++] = grid[r][c];
            }
        }
        for (int i2 = total - 1; i2 > 0; i2--) {
            int j = random.nextInt(i2 + 1);
            int tmp = flat[i2];
            flat[i2] = flat[j];
            flat[j] = tmp;
        }
        i = 0;
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                grid[r][c] = flat[i++];
            }
        }
    }

    public int[][] toArray() {
        int[][] out = new int[rows][cols];
        for (int r = 0; r < rows; r++) {
            System.arraycopy(grid[r], 0, out[r], 0, cols);
        }
        return out;
    }
}
