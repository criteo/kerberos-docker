package com.criteo.gssutils;

import javax.security.auth.Subject;
import javax.security.auth.login.*;
import javax.security.auth.callback.CallbackHandler;
import java.security.*;

import com.sun.security.auth.callback.TextCallbackHandler;


public class Jaas {

  private static String name;
  private static final boolean verbose = false;

  public static void main(String[] args) throws Exception {
    if (args.length > 0) {
      name = args[0];
    } else {
      name = "client";
    }

    // Create action to perform
    PrivilegedExceptionAction action = new MyAction();

    loginAndAction(name, action);
  }

  public static void loginAndAction(String name, PrivilegedExceptionAction action)
      throws LoginException, PrivilegedActionException {

    // Create a callback handler
    CallbackHandler callbackHandler = new TextCallbackHandler();

    LoginContext context = null;

    try {
      // Create a LoginContext with a callback handler
      context = new LoginContext(name, callbackHandler);

      // Perform authentication
      context.login();
    } catch (LoginException e) {
      System.err.println("Login failed");
      e.printStackTrace();
      System.exit(-1);
    }

    // Perform action as authenticated user
    Subject subject = context.getSubject();
    if (verbose) {
      System.out.println(subject.toString());
    } else {
      System.out.println("Authenticated principal: " + subject.getPrincipals());
    }

    Subject.doAs(subject, action);

    context.logout();
  }

  // Action to perform
  public static class MyAction implements PrivilegedExceptionAction {

    MyAction() {
    }

    public Object run() throws Exception {
      // Replace the following with an action to be performed
      // by authenticated user
      System.out.println("Performing secure action ...");
      return null;
    }
  }
}
