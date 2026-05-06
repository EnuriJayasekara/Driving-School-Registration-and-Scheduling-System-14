package com.drivingschool.util;

import org.mindrot.jbcrypt.BCrypt;

/** BCrypt password hashing helpers. */
public class PasswordUtil {

    private PasswordUtil() {}

    public static String hash(String plainText) {
        return BCrypt.hashpw(plainText, BCrypt.gensalt(10));
    }

    public static boolean verify(String plainText, String hashed) {
        return BCrypt.checkpw(plainText, hashed);
    }
}
