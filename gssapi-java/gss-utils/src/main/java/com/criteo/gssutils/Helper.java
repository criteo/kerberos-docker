package com.criteo.gssutils;

public class Helper {

    public static String getHexBytes(byte[] bytes, int pos, int len) {

        StringBuilder sb = new StringBuilder();
        for (int i = pos; i < (pos + len); i++) {

            int b1 = (bytes[i] >> 4) & 0x0f;
            int b2 = bytes[i] & 0x0f;

            sb.append(Integer.toHexString(b1));
            sb.append(Integer.toHexString(b2));
            sb.append(' ');
        }
        return sb.toString();
    }

    public static String getHexBytes(byte[] bytes) {
        return getHexBytes(bytes, 0, bytes.length);
    }
}
