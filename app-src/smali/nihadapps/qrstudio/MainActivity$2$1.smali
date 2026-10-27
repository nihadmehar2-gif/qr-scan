.class Lnihadapps/qrstudio/MainActivity$2$1;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lnihadapps/qrstudio/MainActivity$2;->onPermissionRequest(Landroid/webkit/PermissionRequest;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lnihadapps/qrstudio/MainActivity$2;

.field final synthetic val$request:Landroid/webkit/PermissionRequest;


# direct methods
.method constructor <init>(Lnihadapps/qrstudio/MainActivity$2;Landroid/webkit/PermissionRequest;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x1010
        }
        names = {
            null,
            null
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    iput-object p1, p0, Lnihadapps/qrstudio/MainActivity$2$1;->this$1:Lnihadapps/qrstudio/MainActivity$2;

    iput-object p2, p0, Lnihadapps/qrstudio/MainActivity$2$1;->val$request:Landroid/webkit/PermissionRequest;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    iget-object v0, p0, Lnihadapps/qrstudio/MainActivity$2$1;->val$request:Landroid/webkit/PermissionRequest;

    invoke-virtual {v0}, Landroid/webkit/PermissionRequest;->getResources()[Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/webkit/PermissionRequest;->grant([Ljava/lang/String;)V

    return-void
.end method
