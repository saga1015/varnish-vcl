vcl 4.0;
import directors;
import std;

# Default backend definition. Set this to point to your content server.
backend default {
  .host = "127.0.0.1";
  .port = "8080";
}

acl purge {
  # ACL we'll use later to allow purges
  "localhost";
  "127.0.0.1";
  "::1";
}

sub vcl_recv {
  # Allow purging
  if (req.method == "PURGE") {
    if (!client.ip ~ purge) { # purge is the ACL defined at the begining
      # Not from an allowed IP? Then die with an error.
      return (synth(405, "This IP is not allowed to send PURGE requests."));
    }
    # If you got this stage (and didn't error out above), purge the cached result
    return (purge);
  }
}

sub vcl_backend_response {
}

sub vcl_deliver {
}
