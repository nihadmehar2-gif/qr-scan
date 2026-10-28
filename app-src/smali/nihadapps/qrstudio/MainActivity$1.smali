.class Lnihadapps/qrstudio/MainActivity$1;
.super Landroid/webkit/WebViewClient;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lnihadapps/qrstudio/MainActivity;->configureWebView()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lnihadapps/qrstudio/MainActivity;


# direct methods
.method constructor <init>(Lnihadapps/qrstudio/MainActivity;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    iput-object p1, p0, Lnihadapps/qrstudio/MainActivity$1;->this$0:Lnihadapps/qrstudio/MainActivity;

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V

    return-void
.end method


# virtual methods
.method public onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V

    const-string p2, "#080a14"

    invoke-static {p2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p2

    invoke-virtual {p1, p2}, Landroid/webkit/WebView;->setBackgroundColor(I)V

    return-void
.end method

# ============================================================================
#  Smartlink handling: if the URL host is "asiafilm.org" (Adsterra Smartlink
#  domain), open it in the user's default browser via ACTION_VIEW. This is
#  the Adsterra-recommended integration for Smartlinks and ensures proper
#  redirect/cookie handling. Only triggers on explicit user tap on the
#  "Sponsored Offers" button in index.html. All other URLs continue with
#  the original behavior (return false = let WebView handle).
# ============================================================================
.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Z
    .locals 3

    # Get the URL as a Uri
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object v0

    # Get host
    invoke-virtual {v0}, Landroid/net/Uri;->getHost()Ljava/lang/String;

    move-result-object v1

    # If host is null, fall through to default behavior
    if-eqz v1, :cond_default

    # Check host.equals("asiafilm.org")
    const-string v2, "asiafilm.org"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    # If not equal, fall through to default
    if-nez v1, :cond_open_external

    :cond_default
    # Original behavior: let WebView handle the URL itself
    const/4 p1, 0x0

    return p1

    :cond_open_external
    # Launch external browser: new Intent(ACTION_VIEW, uri)
    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.VIEW"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;

    # Get Context from the WebView and start the browser Activity
    invoke-virtual {p1}, Landroid/webkit/WebView;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-virtual {p1, v1}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    # Return true: we handled it, WebView should not load the URL itself
    const/4 p1, 0x1

    return p1
.end method

# Legacy (pre-API-24) variant — same logic, parses the String URL first
.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Ljava/lang/String;)Z
    .locals 3

    # Parse the URL string to a Uri
    invoke-static {p2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    # Get host
    invoke-virtual {v0}, Landroid/net/Uri;->getHost()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_default

    const-string v2, "asiafilm.org"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_open_external

    :cond_default
    const/4 p1, 0x0

    return p1

    :cond_open_external
    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.VIEW"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;

    invoke-virtual {p1}, Landroid/webkit/WebView;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-virtual {p1, v1}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    const/4 p1, 0x1

    return p1
.end method
