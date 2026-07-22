<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông báo - POB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme-space.css">
    <style>
        .mini-nav { background: var(--bg-panel-solid); border-bottom: 1px solid var(--border-color); padding: 16px 24px; display: flex; align-items: center; gap: 16px; }
        .mini-nav .logo { width: 36px; height: 36px; border-radius: var(--radius-sm); background: linear-gradient(135deg, var(--primary), var(--secondary)); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; box-shadow: var(--glow-primary); }
        .mini-nav .title { font-size: 17px; font-weight: 800; color: var(--text-main); }
        .mini-nav .nav-links { margin-left: auto; display: flex; align-items: center; gap: 18px; }
        .mini-nav .nav-links a { font-size: 13px; color: var(--text-muted); }
        .mini-nav .nav-links a:hover { color: var(--secondary); }

        .container { max-width: 760px; margin: 0 auto; padding: 32px 16px; }
        .page-header { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px; margin-bottom: 20px; }
        .page-title { font-size: 20px; font-weight: 800; color: var(--text-main); display: flex; align-items: center; gap: 10px; }
        .unread-badge { background: var(--warning); color: #3a2a1e; font-size: 12px; font-weight: 700; padding: 2px 10px; border-radius: var(--radius-pill); }
        .btn-mark-all { padding: 8px 16px; border-radius: var(--radius-pill); border: 1.5px solid var(--border-color); background: transparent; color: var(--text-main); font-size: 12.5px; font-weight: 700; cursor: pointer; }

        .notif-list { display: flex; flex-direction: column; gap: 12px; }
        .notif-card { background: var(--bg-panel-solid); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 16px 20px; display: flex; gap: 14px; align-items: flex-start; }
        .notif-card.unread { border-left: 4px solid var(--secondary); background: rgba(255,255,255,.03); }
        .notif-icon { font-size: 22px; flex-shrink: 0; margin-top: 2px; }
        .notif-body { flex: 1; }
        .notif-title { font-size: 14.5px; font-weight: 700; margin-bottom: 4px; color: var(--text-dim); }
        .notif-card.unread .notif-title { color: var(--text-main); }
        .notif-message { font-size: 13px; color: var(--text-dim); line-height: 1.6; }
        .notif-time { font-size: 11px; color: var(--text-dim); margin-top: 6px; opacity: .7; }
        .notif-read-btn { background: none; border: 1px solid var(--border-color); border-radius: 6px; padding: 4px 10px; font-size: 11px; cursor: pointer; color: var(--text-dim); flex-shrink: 0; }
        .notif-read-btn:hover { color: var(--secondary); border-color: var(--secondary); }
    </style>
</head>
<body class="space-scope">
<div class="starfield"></div>

<div class="mini-nav">
    <div class="logo">POB</div>
    <span class="title">Thông báo</span>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/donhang">📦 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/user/home">← Trang chủ</a>
    </div>
</div>

<div class="container">
    <div class="page-header">
        <div class="page-title">
            🔔 Thông báo
            <c:if test="${unreadCount > 0}"><span class="unread-badge">${unreadCount} chưa đọc</span></c:if>
        </div>
        <c:if test="${unreadCount > 0}">
            <form action="${pageContext.request.contextPath}/user/thong-bao" method="post" style="margin:0">
                <input type="hidden" name="action" value="markAll"/>
                <button type="submit" class="btn-mark-all">✅ Đánh dấu tất cả đã đọc</button>
            </form>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${empty notifications}">
            <div class="card empty-state">
                <div class="e-icon">🔕</div>
                <div class="e-title">Bạn chưa có thông báo nào</div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="notif-list">
                <c:forEach var="n" items="${notifications}">
                    <div class="notif-card ${n.read ? '' : 'unread'}">
                        <div class="notif-icon">🔔</div>
                        <div class="notif-body">
                            <div class="notif-title">${fn:escapeXml(n.title)}</div>
                            <div class="notif-message">${fn:escapeXml(n.message)}</div>
                            <div class="notif-time">
                                <c:if test="${n.createdAt != null}">
                                    ${n.createdAt.hour}:<c:set var="m" value="${n.createdAt.minute}"/><c:if test="${m < 10}">0</c:if>${m}
                                    &nbsp;·&nbsp;${n.createdAt.dayOfMonth}/${n.createdAt.monthValue}/${n.createdAt.year}
                                </c:if>
                            </div>
                        </div>
                        <c:if test="${!n.read}">
                            <form action="${pageContext.request.contextPath}/user/thong-bao" method="post" style="margin:0">
                                <input type="hidden" name="id" value="${n.id}"/>
                                <button type="submit" class="notif-read-btn">Đã đọc</button>
                            </form>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<script>window.POB_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/notifications-ws.js"></script>
<script>
    // Dang xem trang thong bao khi co thong bao moi day toi -> tai lai de hien ngay trong danh sach.
    document.addEventListener('pob-notification', function () {
        setTimeout(function () { window.location.reload(); }, 1200);
    });
</script>
</body>
</html>
