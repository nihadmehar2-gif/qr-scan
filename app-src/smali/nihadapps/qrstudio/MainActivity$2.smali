.class Lnihadapps/qrstudio/MainActivity$2;
.super Landroid/webkit/WebChromeClient;


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

    iput-object p1, p0, Lnihadapps/qrstudio/MainActivity$2;->this$0:Lnihadapps/qrstudio/MainActivity;

    invoke-direct {p0}, Landroid/webkit/WebChromeClient;-><init>()V

    return-void
.end method


# virtual methods
.method public onPermissionRequest(Landroid/webkit/PermissionRequest;)V
    .locals 2

    iget-object v0, p0, Lnihadapps/qrstudio/MainActivity$2;->this$0:Lnihadapps/qrstudio/MainActivity;

    new-instance v1, Lnihadapps/qrstudio/MainActivity$2$1;

    invoke-direct {v1, p0, p1}, Lnihadapps/qrstudio/MainActivity$2$1;-><init>(Lnihadapps/qrstudio/MainActivity$2;Landroid/webkit/PermissionRequest;)V

    invoke-virtual {v0, v1}, Lnihadapps/qrstudio/MainActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

.method public onShowFileChooser(Landroid/webkit/WebView;Landroid/webkit/ValueCallback;Landroid/webkit/WebChromeClient$FileChooserParams;)Z
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/webkit/WebView;",
            "Landroid/webkit/ValueCallback<",
            "[",
            "Landroid/net/Uri;",
            ">;",
            "Landroid/webkit/WebChromeClient$FileChooserParams;",
            ")Z"
        }
    .end annotation

    iget-object p1, p0, Lnihadapps/qrstudio/MainActivity$2;->this$0:Lnihadapps/qrstudio/MainActivity;

    invoke-static {p1}, Lnihadapps/qrstudio/MainActivity;->access$000(Lnihadapps/qrstudio/MainActivity;)Landroid/webkit/ValueCallback;

    move-result-object p1

    const/4 p3, 0x0

    if-eqz p1, :cond_0

    iget-object p1, p0, Lnihadapps/qrstudio/MainActivity$2;->this$0:Lnihadapps/qrstudio/MainActivity;

    invoke-static {p1}, Lnihadapps/qrstudio/MainActivity;->access$000(Lnihadapps/qrstudio/MainActivity;)Landroid/webkit/ValueCallback;

    move-result-object p1

    invoke-interface {p1, p3}, Landroid/webkit/ValueCallback;->onReceiveValue(Ljava/lang/Object;)V

    :cond_0
    iget-object p1, p0, Lnihadapps/qrstudio/MainActivity$2;->this$0:Lnihadapps/qrstudio/MainActivity;

    invoke-static {p1, p2}, Lnihadapps/qrstudio/MainActivity;->access$002(Lnihadapps/qrstudio/MainActivity;Landroid/webkit/ValueCallback;)Landroid/webkit/ValueCallback;

    new-instance p1, Landroid/content/Intent;

    const-string p2, "android.intent.action.GET_CONTENT"

    invoke-direct {p1, p2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string p2, "android.intent.category.OPENABLE"

    invoke-virtual {p1, p2}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    const-string p2, "image/*"

    invoke-virtual {p1, p2}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    const-string p2, "android.intent.extra.ALLOW_MULTIPLE"

    const/4 v0, 0x0

    invoke-virtual {p1, p2, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    const-string p2, "Select image"

    invoke-static {p1, p2}, Landroid/content/Intent;->createChooser(Landroid/content/Intent;Ljava/lang/CharSequence;)Landroid/content/Intent;

    move-result-object p1

    :try_start_0
    iget-object p2, p0, Lnihadapps/qrstudio/MainActivity$2;->this$0:Lnihadapps/qrstudio/MainActivity;

    invoke-static {p2}, Lnihadapps/qrstudio/MainActivity;->access$100(Lnihadapps/qrstudio/MainActivity;)Ljava/io/File;

    move-result-object p2

    if-eqz p2, :cond_1

    iget-object v0, p0, Lnihadapps/qrstudio/MainActivity$2;->this$0:Lnihadapps/qrstudio/MainActivity;

    invoke-static {p2}, Landroid/net/Uri;->fromFile(Ljava/io/File;)Landroid/net/Uri;

    move-result-object p2

    invoke-static {v0, p2}, Lnihadapps/qrstudio/MainActivity;->access$202(Lnihadapps/qrstudio/MainActivity;Landroid/net/Uri;)Landroid/net/Uri;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    iget-object p2, p0, Lnihadapps/qrstudio/MainActivity$2;->this$0:Lnihadapps/qrstudio/MainActivity;

    invoke-static {p2, p3}, Lnihadapps/qrstudio/MainActivity;->access$202(Lnihadapps/qrstudio/MainActivity;Landroid/net/Uri;)Landroid/net/Uri;

    :cond_1
    :goto_0
    iget-object p2, p0, Lnihadapps/qrstudio/MainActivity$2;->this$0:Lnihadapps/qrstudio/MainActivity;

    const/16 p3, 0x10a2

    invoke-virtual {p2, p1, p3}, Lnihadapps/qrstudio/MainActivity;->startActivityForResult(Landroid/content/Intent;I)V

    const/4 p1, 0x1

    return p1
.end method
