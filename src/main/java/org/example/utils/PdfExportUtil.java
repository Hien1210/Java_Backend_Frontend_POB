package org.example.utils;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import org.example.models.BillLine;
import org.example.models.BillView;
import org.example.models.Order;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;

/**
 * Xuat hoa don (BillView co san tu BillUtil.build(order)) ra file PDF, dung chung cho khach hang
 * (/bill) va Shop (/shop/bills). Dung font Helvetica voi bang ma Cp1258 (khong can nhung file
 * .ttf ben ngoai) de hien thi dung tieng Viet co dau.
 */
public final class PdfExportUtil {

    private static final DecimalFormat MONEY = new DecimalFormat("#,##0");

    private PdfExportUtil() {
    }

    public static byte[] buildInvoicePdf(BillView bill) throws IOException {
        try {
            BaseFont baseFont = BaseFont.createFont(BaseFont.HELVETICA, "Cp1258", BaseFont.NOT_EMBEDDED);
            Font titleFont = new Font(baseFont, 18, Font.BOLD);
            Font headFont = new Font(baseFont, 11, Font.BOLD);
            Font normalFont = new Font(baseFont, 10, Font.NORMAL);
            Font boldFont = new Font(baseFont, 10, Font.BOLD);

            Document document = new Document(PageSize.A5, 24, 24, 24, 24);
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            PdfWriter.getInstance(document, bos);
            document.open();

            Order order = bill.getOrder();

            Paragraph title = new Paragraph("HOA DON DAT HANG", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            Paragraph shopLine = new Paragraph(bill.getShopName() != null ? bill.getShopName() : "", headFont);
            shopLine.setAlignment(Element.ALIGN_CENTER);
            shopLine.setSpacingAfter(12);
            document.add(shopLine);

            document.add(new Paragraph("Ma don: #" + order.getId(), normalFont));
            document.add(new Paragraph("Nguoi nhan: " + nullSafe(order.getReceiverName()), normalFont));
            document.add(new Paragraph("So dien thoai: " + nullSafe(order.getReceiverPhone()), normalFont));
            document.add(new Paragraph("Dia chi giao hang: " + nullSafe(order.getShippingAddress()), normalFont));
            document.add(new Paragraph("Phuong thuc thanh toan: " + nullSafe(order.getPaymentMethod()), normalFont));
            if (order.getCreatedAt() != null) {
                document.add(new Paragraph("Ngay tao: " + order.getCreatedAt(), normalFont));
            }
            document.add(new Paragraph(" "));

            PdfPTable table = new PdfPTable(new float[]{3.2f, 1.2f, 0.8f, 1.2f, 1.4f});
            table.setWidthPercentage(100);

            addHeaderCell(table, "San pham", headFont);
            addHeaderCell(table, "Size", headFont);
            addHeaderCell(table, "SL", headFont);
            addHeaderCell(table, "Don gia", headFont);
            addHeaderCell(table, "Thanh tien", headFont);

            for (BillLine line : bill.getLines()) {
                table.addCell(cell(line.getProductName(), normalFont, Element.ALIGN_LEFT));
                table.addCell(cell(nullSafe(line.getSizeName()), normalFont, Element.ALIGN_CENTER));
                table.addCell(cell(String.valueOf(line.getQuantity()), normalFont, Element.ALIGN_CENTER));
                table.addCell(cell(MONEY.format(line.getPrice()), normalFont, Element.ALIGN_RIGHT));
                table.addCell(cell(MONEY.format(line.getLineTotal()), normalFont, Element.ALIGN_RIGHT));
            }

            document.add(table);
            document.add(new Paragraph(" "));

            Paragraph subtotal = new Paragraph("Tam tinh: " + MONEY.format(bill.getSubtotal()) + " d", normalFont);
            subtotal.setAlignment(Element.ALIGN_RIGHT);
            document.add(subtotal);

            if (order.getDeliveryFee() != null) {
                Paragraph fee = new Paragraph("Phi giao hang: " + MONEY.format(order.getDeliveryFee()) + " d", normalFont);
                fee.setAlignment(Element.ALIGN_RIGHT);
                document.add(fee);
            }

            Paragraph total = new Paragraph("TONG CONG: " + MONEY.format(order.getTotalPrice()) + " d", boldFont);
            total.setAlignment(Element.ALIGN_RIGHT);
            document.add(total);

            document.close();
            return bos.toByteArray();
        } catch (DocumentException e) {
            throw new IOException("Loi tao file PDF", e);
        }
    }

    private static void addHeaderCell(PdfPTable table, String text, Font font) {
        PdfPCell cell = new PdfPCell(new Paragraph(text, font));
        cell.setBackgroundColor(new BaseColor(230, 230, 230));
        cell.setPadding(5);
        table.addCell(cell);
    }

    private static PdfPCell cell(String text, Font font, int align) {
        PdfPCell cell = new PdfPCell(new Paragraph(text == null ? "" : text, font));
        cell.setHorizontalAlignment(align);
        cell.setPadding(4);
        return cell;
    }

    private static String nullSafe(String value) {
        return value == null ? "" : value;
    }
}
