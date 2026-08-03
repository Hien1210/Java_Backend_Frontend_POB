package org.example.utils;

import java.net.URI;
import java.net.URISyntaxException;

public class UploadValidationUtil {

    private static final String ALLOWED_HOST = "res.cloudinary.com";
    private static final String ALLOWED_CLOUD_NAME = "jcnsb47f";
    private static final int MAX_URL_LENGTH = 500;

    private UploadValidationUtil() {
    }

    public static boolean isValidCloudinaryImageUrl(String url) {
        if (url == null || url.isBlank() || url.length() > MAX_URL_LENGTH) {
            return false;
        }
        URI uri;
        try {
            uri = new URI(url.trim());
        } catch (URISyntaxException e) {
            return false;
        }
        if (!"https".equalsIgnoreCase(uri.getScheme())) {
            return false;
        }
        if (!ALLOWED_HOST.equalsIgnoreCase(uri.getHost())) {
            return false;
        }
        String path = uri.getRawPath();
        if (path == null) {
            return false;
        }
        String expectedPrefix = "/" + ALLOWED_CLOUD_NAME + "/image/upload/";
        return path.startsWith(expectedPrefix);
    }
}
