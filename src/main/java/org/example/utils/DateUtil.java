package org.example.utils;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

/**
 * Ham dinh dang ngay gio dung chung cho JSP (goi qua EL function trong functions.tld).
 */
public class DateUtil {

    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter DATE_ONLY = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter INPUT_DATE_TIME = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    private DateUtil() {
    }

    public static String format(Object value) {
        if (value == null) {
            return "";
        }
        if (value instanceof LocalDateTime) {
            return ((LocalDateTime) value).format(DATE_TIME);
        }
        if (value instanceof LocalDate) {
            return ((LocalDate) value).format(DATE_ONLY);
        }
        if (value instanceof Timestamp) {
            return ((Timestamp) value).toLocalDateTime().format(DATE_TIME);
        }
        if (value instanceof Date) {
            return new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format((Date) value);
        }
        return value.toString();
    }

    public static String formatDate(Object value) {
        if (value == null) {
            return "";
        }
        if (value instanceof LocalDateTime) {
            return ((LocalDateTime) value).format(DATE_ONLY);
        }
        if (value instanceof LocalDate) {
            return ((LocalDate) value).format(DATE_ONLY);
        }
        if (value instanceof Timestamp) {
            return ((Timestamp) value).toLocalDateTime().format(DATE_ONLY);
        }
        if (value instanceof Date) {
            return new java.text.SimpleDateFormat("dd/MM/yyyy").format((Date) value);
        }
        return value.toString();
    }

    /** Dinh dang ISO yyyy-MM-ddTHH:mm de dien san gia tri cho input type="datetime-local". */
    public static String formatForInput(Object value) {
        if (value == null) {
            return "";
        }
        if (value instanceof LocalDateTime) {
            return ((LocalDateTime) value).format(INPUT_DATE_TIME);
        }
        if (value instanceof LocalDate) {
            return ((LocalDate) value).atStartOfDay().format(INPUT_DATE_TIME);
        }
        if (value instanceof Timestamp) {
            return ((Timestamp) value).toLocalDateTime().format(INPUT_DATE_TIME);
        }
        if (value instanceof Date) {
            return new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format((Date) value);
        }
        return value.toString();
    }
}
