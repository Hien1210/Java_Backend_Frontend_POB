package org.example.utils;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility hỗ trợ mã hóa 2 chiều AES-256-GCM bảo mật dữ liệu nhạy cảm (PayOS keys, API keys).
 */
public class EncryptionUtil {

    private static final String ALGORITHM = "AES/GCM/NoPadding";
    private static final int GCM_TAG_LENGTH = 128; // in bits
    private static final int GCM_IV_LENGTH = 12;   // 12 bytes chuẩn cho GCM

    // Key bí mật tĩnh dùng để mã hóa/giải mã (Fall-back nếu không set biến môi trường)
    private static final String DEFAULT_SECRET_KEY = "POBFoodSecretKeyForPayOSEncryption2026!@#$";

    private static SecretKey deriveKey() {
        try {
            String secretEnv = System.getenv("POB_ENCRYPTION_SECRET");
            String secret = (secretEnv != null && !secretEnv.isBlank()) ? secretEnv : DEFAULT_SECRET_KEY;
            byte[] keyBytes = MessageDigest.getInstance("SHA-256").digest(secret.getBytes(StandardCharsets.UTF_8));
            return new SecretKeySpec(keyBytes, "AES");
        } catch (Exception e) {
            throw new RuntimeException("Lỗi sinh SecretKey mã hóa", e);
        }
    }

    /**
     * Mã hóa chuỗi văn bản thuần thành chuỗi mã hóa (Base64 kết hợp IV + Ciphertext)
     */
    public static String encrypt(String plainText) {
        if (plainText == null || plainText.isBlank()) {
            return plainText;
        }
        // Nếu dữ liệu đã có tiền tố mã hóa rồi thì không mã hóa lại
        if (plainText.startsWith("ENC:")) {
            return plainText;
        }

        try {
            byte[] iv = new byte[GCM_IV_LENGTH];
            new SecureRandom().nextBytes(iv);

            Cipher cipher = Cipher.getInstance(ALGORITHM);
            GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
            cipher.init(Cipher.ENCRYPT_MODE, deriveKey(), spec);

            byte[] cipherText = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));

            // Kết hợp IV (12 bytes) + CipherText
            byte[] encryptedData = new byte[iv.length + cipherText.length];
            System.arraycopy(iv, 0, encryptedData, 0, iv.length);
            System.arraycopy(cipherText, 0, encryptedData, iv.length, cipherText.length);

            return "ENC:" + Base64.getEncoder().encodeToString(encryptedData);
        } catch (Exception e) {
            e.printStackTrace();
            return plainText;
        }
    }

    /**
     * Giải mã chuỗi đã được mã hóa về lại văn bản thuần.
     * Nếu chuỗi truyền vào không mã hóa (không có tiền tố ENC:) thì trả về nguyên bản (hỗ trợ tương thích ngược).
     */
    public static String decrypt(String cipherTextWithPrefix) {
        if (cipherTextWithPrefix == null || cipherTextWithPrefix.isBlank()) {
            return cipherTextWithPrefix;
        }
        if (!cipherTextWithPrefix.startsWith("ENC:")) {
            return cipherTextWithPrefix; // Dữ liệu cũ chưa mã hóa
        }

        try {
            String base64Data = cipherTextWithPrefix.substring(4);
            byte[] encryptedData = Base64.getDecoder().decode(base64Data);

            if (encryptedData.length < GCM_IV_LENGTH) {
                return cipherTextWithPrefix;
            }

            byte[] iv = new byte[GCM_IV_LENGTH];
            System.arraycopy(encryptedData, 0, iv, 0, GCM_IV_LENGTH);

            int cipherTextLen = encryptedData.length - GCM_IV_LENGTH;
            byte[] cipherText = new byte[cipherTextLen];
            System.arraycopy(encryptedData, GCM_IV_LENGTH, cipherText, 0, cipherTextLen);

            Cipher cipher = Cipher.getInstance(ALGORITHM);
            GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
            cipher.init(Cipher.DECRYPT_MODE, deriveKey(), spec);

            byte[] plainBytes = cipher.doFinal(cipherText);
            return new String(plainBytes, StandardCharsets.UTF_8);
        } catch (Exception e) {
            e.printStackTrace();
            return cipherTextWithPrefix;
        }
    }
}
