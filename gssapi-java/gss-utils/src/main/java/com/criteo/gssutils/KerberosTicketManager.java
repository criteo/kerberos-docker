package com.criteo.gssutils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import javax.security.auth.kerberos.KeyTab;
import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import sun.security.krb5.*;
import sun.security.krb5.internal.KerberosTime;
import sun.security.krb5.internal.Krb5;
import sun.security.krb5.internal.ccache.Credentials;
import sun.security.krb5.internal.ccache.CredentialsCache;
import sun.security.krb5.internal.ccache.FileCredentialsCache;

/**
 * Utility class to manage Kerberos tickets (TGS and TGT tickets) with default cache file.
 *
 * Note:
 * - https://docs.oracle.com/javase/8/docs/technotes/guides/security/
 * - http://hg.openjdk.java.net/jdk8/jdk8/jdk/file/default/src/share/classes/sun/security/krb5
 * - http://hg.openjdk.java.net/jdk8/jdk8/jdk/file/default/test/sun/security/krb5
 */
public class KerberosTicketManager {

  private static boolean DEBUG = Krb5.DEBUG;

  public static void main(String[] args) {
    try {
      String userNamePrincipal = "bob@EXAMPLE.COM";
      Credentials tgtCredentials = getTGT("/etc/bob.keytab", userNamePrincipal);
      putInCache(userNamePrincipal, tgtCredentials);
      sun.security.krb5.Credentials tgsCredentials = getTGS(
          "host/krb5-service.example.com@EXAMPLE.COM"
      );
      putInCache(tgsCredentials);
      cleanCache();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }


  /**
   * Get a Ticket Granting Ticket (TGT) from Authentication Server (AS) with required keytab file.
   *
   * 1. Create and send AS-REQ
   * 2. Receive KRB ERROR (PRE-AUTH is mandatory in Kerberos v5)
   * 3. Re-send AS-REQ
   * 4. Receive AS-REP
   * 5. Return TGT credentials ticket in Java object
   *
   * @param keytabFileName Path file name to keytab (required already on disk storage, for instance
   *                       /etc/bob.keytab)
   * @param userName user name principal (UPN) (ex: bob@EXAMPLE.COM)
   * @param realm Kerberos domain of the Authentication Server (ex: EXAMPLE.COM)
   * @return TGT credentials
   * @throws KrbException
   * @throws IOException
   *
   * Note: 
   * - For system administrator it is like the command: kinit -kt keytab upn 
   * - [WARNING] dependencies with internal proprietary API and may be removed in a future release
   */
  public static Credentials getTGT(String keytabFileName, String userName, String realm)
      throws KrbException, IOException {

    KrbAsReqBuilder builder = null;
    try {

      PrincipalName userPrincipalName = new PrincipalName(userName);
      KeyTab keyTab = KeyTab.getInstance(new File(keytabFileName));
      builder = new KrbAsReqBuilder(userPrincipalName, keyTab);

      PrincipalName tgsPrincipalName = PrincipalName.tgsService(realm, realm);
      builder.setTarget(tgsPrincipalName);

      // see http://hg.openjdk.java.net/jdk8/jdk8/jdk/file/default/src/share/classes/sun/security/krb5/KdcComm.java#l145
      // for default parameters (timeout, max retries ...)
      builder.action();

      Credentials tgtCredentials = builder.getCCreds();
      if (DEBUG) {
        System.out.println(">>>TGT credentials : " +
            ReflectionToStringBuilder.toString(tgtCredentials));
      }
      return tgtCredentials;

    } finally {

      if (builder != null) {
        builder.destroy();
      }

    }

  }


  /**
   * Get a Ticket Granting Ticket (TGT) from Authentication Server (AS) with keytab file.
   *
   * @param keytabFileName Path file name to keytab (required already on disk storage, for instance
   * /etc/bob.keytab)
   * @param userName user name principal (ex: bob@EXAMPLE.COM)
   * @return TGT credentials
   * @throws KrbException
   * @throws IOException
   *
   * @see KerberosTicketManager#getTGT(String, String, String)
   */
  public static Credentials getTGT(String keytabFileName, String userName)
      throws KrbException, IOException {

    String realm = Config.getInstance().getDefaultRealm();
    return getTGT(keytabFileName, userName, realm);

  }


  /**
   * Get a Ticket Granting Service (TGS) from Ticket Granting Server (TGS) required TGT.
   * 
   * 1. Create and send TGS-REQ
   * 2. Receive TGS-REP
   * 3. Return TGS credentials ticket in Java object
   * 
   * @param serviceName service name principal (SPN) (ex: host/krb5-service.example.com@EXAMPLE.COM)
   * @return TGS credentials
   * @throws KrbException
   * @throws IOException
   * 
   * Note: 
   * - For system administrator it is like the command: kvno spn
   */
  public static sun.security.krb5.Credentials getTGS(String serviceName)
      throws KrbException, IOException {

    PrincipalName servicePrincipalName = new PrincipalName(serviceName);
    sun.security.krb5.Credentials credentials = sun.security.krb5.Credentials.acquireDefaultCreds();
    KrbTgsReq tgsReq = new KrbTgsReq(credentials, servicePrincipalName);
    sun.security.krb5.Credentials tgsCredentials = tgsReq.sendAndGetCreds();
    if (DEBUG) {
      System.out.println(">>>TGS credentials : " +
          ReflectionToStringBuilder.toString(tgsCredentials));
    }
    return tgsCredentials;
  }


  /**
   * Get credentials tickets cache (from file with default name /tmp/krb5cc_${uuid} for Linux)
   *
   * @return credentials tickets cache
   */
  public static CredentialsCache getCache() {
    return CredentialsCache.getInstance();
  }

  /**
   * Put TGT credentials in cache file.
   * (by removing existing credential cache file before putting TGT credentials).
   *
   * @param userName user name principal (UPN) (ex: bob@EXAMPLE.COM)
   * @param tgtCredentials TGT credentials
   * @throws KrbException
   * @throws RealmException
   * @throws IOException
   */
  public static void putInCache(String userName, Credentials tgtCredentials)
      throws KrbException, RealmException, IOException {

    String cacheName = FileCredentialsCache.getDefaultCacheName();
    PrincipalName userPrincipalName = new PrincipalName(userName);
    CredentialsCache cache = CredentialsCache.create(userPrincipalName, cacheName);
    if (cache == null) {
      throw new IOException("Unable to create cache file " + cacheName);
    }
    cache.update(tgtCredentials);
    cache.save();

  }


  /**
   * Put TGS credentials ticket in cache file to persist credentials.
   *
   * @param tgsCredentials TGS credentials
   * @throws KrbException 
   * @throws IOException 
   */
  public static void putInCache(sun.security.krb5.Credentials tgsCredentials)
      throws KrbException, IOException {

    CredentialsCache cache = CredentialsCache.getInstance();
    Credentials ccreds = new sun.security.krb5.internal.ccache.Credentials(
        tgsCredentials.getClient(),
        tgsCredentials.getServer(),
        tgsCredentials.getSessionKey(),
        new KerberosTime(tgsCredentials.getAuthTime()),
        /*new KerberosTime(tgsCredentials.getStartTime())*/ null,
        new KerberosTime(tgsCredentials.getEndTime()),
        /*new KerberosTime(receivedCredentials.getRenewTill())*/ null,
        false,
        tgsCredentials.getTicketFlags(),
        /*new HostAddresses(receivedCredentials.getClientAddresses())*/ null,
        null,
        tgsCredentials.getTicket(),
        null);
    cache.update(ccreds);
    cache.save();

  }


  /**
   * Clean credentials tickets cache (remove file with default name /tmp/krb5cc_${uuid} for Linux).
   *
   * @return true if file existed and has been really deleted.
   */
  public static boolean cleanCache() throws IOException {
    String cacheName = FileCredentialsCache.getDefaultCacheName();
    File file = new File(cacheName);
    return Files.deleteIfExists(file.toPath());
  }

}
