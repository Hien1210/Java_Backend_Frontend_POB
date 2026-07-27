<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông báo - POB</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-theme.css">
    <style>
        :root {
            --bg:      #FFFBF8;
            --surface: #FFFFFF;
            --surface-lt: #FFF4EC;
            --gold:    #FF5A1F;
            --text:    #241C15;
            --muted:   #8A7B6C;
            --border:  #F1E4D6;
            --font-b:  'Plus Jakarta Sans', sans-serif;
            --tr: all .25s ease;
        }
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: var(--font-b); background: var(--bg); color: var(--text); min-height: 100vh; }
        a { text-decoration: none; color: inherit; transition: var(--tr); }

        /* NAVBAR */
        .navbar {
            background: rgba(255,251,248,.92); backdrop-filter: blur(14px);
            border-bottom: 1px solid var(--border);
            height: 74px; display: flex; align-items: center;
            padding: 0 30px; position: sticky; top: 0; z-index: 100; gap: 16px;
        }
        .nav-logo { font-size: 1.55rem; font-weight: 800; letter-spacing: -.5px; }
        .nav-logo span { color: var(--gold); }
        .nav-title { font-size: .95rem; font-weight: 700; color: var(--text); }
        .nav-sep { width: 1px; height: 20px; background: var(--border); }
        .nav-right { margin-left: auto; display: flex; gap: 10px; }
        .nav-link {
            display: inline-flex; align-items: center; gap: 7px;
            padding: 9px 18px; font-size: .85rem; font-weight: 700;
            color: var(--muted); border: 1.5px solid var(--border); border-radius: 50px;
        }
        .nav-link:hover { color: var(--gold); border-color: var(--gold); background: var(--surface-lt); }

        .container { max-width: 760px; margin: 0 auto; padding: 40px 20px 80px; }
        .page-header { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px; margin-bottom: 22px; }
        .page-title { font-size: 22px; font-weight: 800; color: var(--text); display: flex; align-items: center; gap: 10px; }
        .unread-badge { background: var(--gold); color: #fff; font-size: 12px; font-weight: 700; padding: 3px 12px; border-radius: 50px; }
        .btn-mark-all { padding: 9px 18px; border-radius: 50px; border: 1.5px solid var(--border); background: var(--surface); color: var(--text); font-size: 12.5px; font-weight: 700; cursor: pointer; }
        .btn-mark-all:hover { color: var(--gold); border-color: var(--gold); background: var(--surface-lt); }

        .notif-list { display: flex; flex-direction: column; gap: 12px; }
        .notif-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 18px 20px; display: flex; gap: 14px; align-items: flex-start; box-shadow: 0 2px 10px rgba(60,30,10,.05); }
        .notif-card.unread { border-left: 4px solid var(--gold); background: var(--surface-lt); }
        .notif-icon { font-size: 22px; flex-shrink: 0; margin-top: 2px; }
        .notif-body { flex: 1; }
        .notif-title { font-size: 14.5px; font-weight: 700; margin-bottom: 4px; color: var(--muted); }
        .notif-card.unread .notif-title { color: var(--text); }
        .notif-message { font-size: 13px; color: var(--muted); line-height: 1.6; }
        .notif-time { font-size: 11px; color: var(--muted); margin-top: 6px; opacity: .8; }
        .notif-read-btn { background: none; border: 1px solid var(--border); border-radius: 6px; padding: 4px 10px; font-size: 11px; cursor: pointer; color: var(--muted); flex-shrink: 0; }
        .notif-read-btn:hover { color: var(--gold); border-color: var(--gold); }

        .empty-state { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 60px 20px; text-align: center; }
        .empty-state .e-icon { font-size: 42px; margin-bottom: 12px; }
        .empty-state .e-title { font-size: 14px; font-weight: 700; color: var(--muted); }
    </style>
</head>
<body>

<div class="navbar">
    <div class="nav-logo"><span>POB</span></div>
    <div class="nav-sep"></div>
    <span class="nav-title">Thông báo</span>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link">📦 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/user/diem-thuong" class="nav-link">🎁 Điểm thưởng</a>
        <a href="${pageContext.request.contextPath}/user/home" class="nav-link">← Trang chủ</a>
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
            <div class="empty-state">
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
