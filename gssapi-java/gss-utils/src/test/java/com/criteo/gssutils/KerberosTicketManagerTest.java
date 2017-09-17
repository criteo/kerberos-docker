package com.criteo.gssutils;

import static com.criteo.gssutils.KerberosTicketManager.getTGT;
import static com.criteo.gssutils.KerberosTicketManager.getTGS;

import java.io.File;
import java.io.IOException;
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import sun.security.krb5.KrbException;
import sun.security.krb5.RealmException;
import sun.security.krb5.internal.ccache.Credentials;
import sun.security.krb5.internal.ccache.CredentialsCache;
import sun.security.krb5.internal.ccache.FileCredentialsCache;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class KerberosTicketManagerTest extends TestCase {


  public KerberosTicketManagerTest(String testName) {
    super(testName);
  }


  public static Test suite() {
    return new TestSuite(KerberosTicketManagerTest.class);
  }


  public void test01getTGT() {
    try {
      Credentials tgtCredentials = getTGT("/etc/bob.keytab", "bob@EXAMPLE.COM");
      assertEquals(
          "krbtgt/EXAMPLE.COM@EXAMPLE.COM",
          tgtCredentials.getServicePrincipal().toString()
      );
      KerberosTicketManager.putInCache("bob@EXAMPLE.COM", tgtCredentials);
    } catch (KrbException | IOException e) {
      e.printStackTrace();
    }
  }


  public void test02getTGS() {
    try {
      sun.security.krb5.Credentials tgsCredentials = getTGS(
          "host/krb5-service.example.com@EXAMPLE.COM");
      assertEquals(
          "host/krb5-service.example.com@EXAMPLE.COM",
          tgsCredentials.getServer().toString()
      );
      KerberosTicketManager.putInCache(tgsCredentials);
    } catch (KrbException | IOException e) {
      e.printStackTrace();
    }
  }


  public void test03checkCache() {
    try {
      CredentialsCache cache = KerberosTicketManager.getCache();
      Credentials[] credentials = cache.getCredsList();
      assertEquals(2, credentials.length);
      assertEquals("krbtgt/EXAMPLE.COM@EXAMPLE.COM",
          credentials[0].getServicePrincipal().toString());
      assertEquals("host/krb5-service.example.com@EXAMPLE.COM",
          credentials[1].getServicePrincipal().toString());
    } catch (RealmException e) {
      e.printStackTrace();
    }
  }


  public void test04cleanCache() {
    try {
      boolean hasBeenRemoved = KerberosTicketManager.cleanCache();
      assertEquals(true, hasBeenRemoved);
      String cacheName = FileCredentialsCache.getDefaultCacheName();
      File file = new File(cacheName);
      assertEquals(true, !file.exists());
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

}
