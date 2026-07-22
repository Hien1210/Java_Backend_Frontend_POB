package org.example.utils;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

/**
 * Xuat 1 bang du lieu don gian (tieu de + nhieu dong) ra file Excel (.xlsx).
 * Dung chung cho xuat doanh thu (Shop) va xuat thong ke (Admin), khong can tuy bien phuc tap.
 */
public final class ExcelExportUtil {

    private ExcelExportUtil() {
    }

    /**
     * @param sheetName ten sheet (khong duoc chua ky tu dac biet [ ] : * ? / \)
     * @param title     dong tieu de lon o tren cung (co the null neu khong can)
     * @param headers   ten cac cot
     * @param rows      moi phan tu la 1 dong, moi Object[] co do dai = headers.length; ho tro
     *                  String/Number/null (Number se can le phai va format so)
     */
    public static byte[] export(String sheetName, String title, String[] headers, List<Object[]> rows) throws IOException {
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet(safeSheetName(sheetName));

            Font boldFont = workbook.createFont();
            boldFont.setBold(true);

            CellStyle titleStyle = workbook.createCellStyle();
            titleStyle.setFont(boldFont);

            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFont(boldFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(org.apache.poi.ss.usermodel.FillPatternType.SOLID_FOREGROUND);

            int rowIdx = 0;
            if (title != null && !title.isBlank()) {
                Row titleRow = sheet.createRow(rowIdx++);
                Cell titleCell = titleRow.createCell(0);
                titleCell.setCellValue(title);
                titleCell.setCellStyle(titleStyle);
                rowIdx++; // 1 dong trong ngan cach
            }

            Row headerRow = sheet.createRow(rowIdx++);
            for (int c = 0; c < headers.length; c++) {
                Cell cell = headerRow.createCell(c);
                cell.setCellValue(headers[c]);
                cell.setCellStyle(headerStyle);
            }

            for (Object[] row : rows) {
                Row dataRow = sheet.createRow(rowIdx++);
                for (int c = 0; c < row.length; c++) {
                    Cell cell = dataRow.createCell(c);
                    Object value = row[c];
                    if (value == null) {
                        cell.setBlank();
                    } else if (value instanceof Number) {
                        cell.setCellValue(((Number) value).doubleValue());
                    } else {
                        cell.setCellValue(String.valueOf(value));
                    }
                }
            }

            for (int c = 0; c < headers.length; c++) {
                sheet.autoSizeColumn(c);
            }

            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            workbook.write(bos);
            return bos.toByteArray();
        }
    }

    private static String safeSheetName(String name) {
        if (name == null || name.isBlank()) return "Sheet1";
        String cleaned = name.replaceAll("[\\[\\]:*?/\\\\]", " ").trim();
        return cleaned.length() > 31 ? cleaned.substring(0, 31) : cleaned;
    }
}
