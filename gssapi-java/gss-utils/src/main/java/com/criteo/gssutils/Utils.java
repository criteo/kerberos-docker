package com.criteo.gssutils;

import org.ietf.jgss.GSSException;
import org.ietf.jgss.Oid;

/**
 * Utility class to manage Kerberos authentication.
 */
public class Utils {

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

  public static Oid createKerberosOid() throws GSSException {
    return new Oid("1.2.840.113554.1.2.2");
  }

  public static Oid createKerberosPrincipalOid() throws GSSException {
    return new Oid("1.2.840.113554.1.2.2.1");
  }

}
